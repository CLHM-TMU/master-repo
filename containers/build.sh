#!/usr/bin/env bash
# Build one or more containers/*.def files into containers/*.sif.
#
# Usage:
#   containers/build.sh                 # build every *.def missing a *.sif
#   containers/build.sh --force         # rebuild every *.def, even if a *.sif exists
#   containers/build.sh NAME [NAME...]  # build only the named container(s)
#   containers/build.sh --force NAME    # force-rebuild only the named container(s)
#
# NAME is the container's base name, e.g. "qiime2-2025.10-amplicon-core"
# (matching containers/qiime2-2025.10-amplicon-core.def).
#
# Must run with the repo root as the working directory: the .def files
# reference source envs/*.yaml with paths relative to the build context, not
# to the .def file's own location.
#
# Builds run one at a time on purpose. Building multiple containers
# concurrently was tried once and failed across the board — apptainer's
# --fakeroot builds contend over the same subuid/subgid-mapped namespace
# state, corrupting unrelated builds running at the same time.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FORCE=0
TARGETS=()
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=1 ;;
        *) TARGETS+=("$arg") ;;
    esac
done

if [ ${#TARGETS[@]} -eq 0 ]; then
    while IFS= read -r f; do
        TARGETS+=("$(basename "$f" .def)")
    done < <(find containers -maxdepth 1 -name '*.def' | sort)
fi

for name in "${TARGETS[@]}"; do
    def="containers/${name}.def"
    sif="containers/${name}.sif"

    if [ ! -f "$def" ]; then
        echo "No such container definition: $def" >&2
        exit 1
    fi

    if [ -f "$sif" ] && [ "$FORCE" -ne 1 ]; then
        echo "== Skipping ${name} (${sif} already exists; use --force to rebuild) =="
        continue
    fi

    echo "== Building ${name} =="
    rm -f "$sif"
    apptainer build --fakeroot "$sif" "$def"
done
