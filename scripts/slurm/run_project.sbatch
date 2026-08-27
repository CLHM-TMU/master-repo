#!/usr/bin/env bash
# Generic SLURM batch job: runs one project's pipeline end-to-end through
# scripts/run_snakemake.sh (which itself wraps snakemake in a memory-capped
# systemd cgroup — see that script's header).
#
# Usage:
#   sbatch --job-name=<study_name> scripts/slurm/run_project.sbatch \
#       config/config_<study_name>.yaml [snakemake target, default: all]
#
# Example (this repo's two pending projects):
#   sbatch --job-name=tisha260707 scripts/slurm/run_project.sbatch config/config_tisha260707.yaml
#   sbatch --job-name=hu260708    scripts/slurm/run_project.sbatch config/config_hu260708.yaml
#
# --mem below matches run_snakemake.sh's default SNAKEMAKE_MEM_MAX (26G) so
# SLURM won't schedule both jobs onto the node at once (RealMemory=28000MB in
# slurm.conf) -- the second job queues until the first finishes.
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --mem=26G
#SBATCH --time=7-00:00:00
#SBATCH --output=logs/slurm/%x-%j.out
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: sbatch run_project.sbatch <configfile.yaml> [target]" >&2
    exit 1
fi

CONFIGFILE="$1"
TARGET="${2:-all}"

# NOT `dirname "${BASH_SOURCE[0]}"`: sbatch copies the submitted script into
# a spool directory and executes that copy, so BASH_SOURCE at runtime points
# there, not into this repo -- computing REPO_DIR from it silently resolves
# to garbage under /var/spool/slurmd/, and `mkdir -p` against that fails
# with a bare "Permission denied" for any non-root submitting user.
# $SLURM_SUBMIT_DIR is the directory `sbatch` was invoked from, which is
# already this job's working directory by default; cd is just for safety
# against a future --chdir override.
REPO_DIR="${SLURM_SUBMIT_DIR:-$PWD}"
cd "$REPO_DIR"
mkdir -p logs/slurm

# systemd-run --user (used by run_snakemake.sh) needs the user's systemd
# instance and runtime dir, which aren't set by default in a batch job
# with no interactive login session.
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# Hardcoded rather than `$(conda info --base)`: sbatch inherits whatever
# conda distribution happens to be first on the submitting shell's PATH,
# which silently picks the wrong installation (and thus "no smk9 env") if
# that shell had a different conda active at submission time. Activating by
# full prefix path sidesteps name-lookup entirely.
source /home/work/miniforge3/etc/profile.d/conda.sh
conda activate /home/work/miniforge3/envs/smk9

echo "Host: $(hostname)  Job: ${SLURM_JOB_NAME:-manual} (${SLURM_JOB_ID:-n/a})"
echo "Config: $CONFIGFILE  Target: $TARGET"

# Target must precede --configfile: --configfile takes nargs='+', so a
# target placed after it gets silently swallowed as a second config file
# instead of being treated as the rule to build.
exec scripts/run_snakemake.sh "$TARGET" --sdm apptainer --configfile "$CONFIGFILE"
