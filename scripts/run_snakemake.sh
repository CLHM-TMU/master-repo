#!/usr/bin/env bash
# Wrapper that runs `snakemake` inside a transient user-scope systemd cgroup
# with swap disabled. Rationale: a runaway rule that thrashes into swap can
# wedge the whole host for a long time before the kernel OOM-killer steps in;
# with MemorySwapMax=0 the cgroup hits its ceiling immediately and the
# offending process gets killed fast instead.
#
# Usage: same as calling snakemake directly, e.g.
#   scripts/run_snakemake.sh --sdm apptainer --configfile config/foo.yaml <target>
#
# Env overrides:
#   SNAKEMAKE_MEM_MAX      cgroup memory ceiling (systemd size syntax, default 26G)
#   SNAKEMAKE_MEM_BUDGET   mem_mb resource budget passed to snakemake (default 24000)
set -euo pipefail

MEM_MAX="${SNAKEMAKE_MEM_MAX:-26G}"
MEM_BUDGET="${SNAKEMAKE_MEM_BUDGET:-24000}"

exec systemd-run --user --scope --collect --same-dir \
    -p MemoryMax="$MEM_MAX" \
    -p MemorySwapMax=0 \
    -- snakemake --resources "mem_mb=${MEM_BUDGET}" "$@"
