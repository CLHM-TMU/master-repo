#!/usr/bin/env bash
# SLURM orchestrator job: runs the Snakemake driver process for one project
# under --workflow-profile profiles/slurm, which submits each *rule* as its
# own SLURM job (via snakemake-executor-plugin-slurm) instead of running the
# whole pipeline as one big job (that's scripts/slurm/run_project.sbatch).
#
# This lets two projects' cheap rules (taxa barplots, Greengenes2 steps,
# etc.) run concurrently on the cluster, while memory-heavy rules like
# Silva138's SEPP phylogeny step (mem_mb=24000) still naturally serialize
# against each other since only one such reservation fits on the
# 28000MB node (see scripts/slurm/slurm.conf).
#
# Prerequisite: scripts/slurm/setup_slurm.sh and scripts/slurm/setup_slurmdbd.sh
# must both have been run once (the latter is required for `sacct`-based job
# status polling -- without it the plugin fails, see setup_slurmdbd.sh header).
#
# Usage:
#   sbatch --job-name=<study_name> scripts/slurm/submit_project.sbatch \
#       config/config_<study_name>.yaml [snakemake target, default: all]
#
# Example (this repo's two pending projects):
#   sbatch --job-name=tisha260707 scripts/slurm/submit_project.sbatch config/config_tisha260707.yaml
#   sbatch --job-name=hu260708    scripts/slurm/submit_project.sbatch config/config_hu260708.yaml
#
# This job itself is a lightweight orchestrator (it just calls sbatch per
# ready rule and polls sacct) -- the --mem/--cpus-per-task below are for the
# driver process only, not the actual pipeline work, which is why they're
# small even though the pipeline as a whole needs much more.
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=7-00:00:00
#SBATCH --output=logs/slurm/%x-%j.out
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: sbatch submit_project.sbatch <configfile.yaml> [target]" >&2
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

# Hardcoded rather than `$(conda info --base)`: sbatch inherits whatever
# conda distribution happens to be first on the submitting shell's PATH,
# which silently picks the wrong installation (and thus "no smk9 env") if
# that shell had a different conda active at submission time. Activating by
# full prefix path sidesteps name-lookup entirely.
source /home/work/miniforge3/etc/profile.d/conda.sh
conda activate /home/work/miniforge3/envs/smk9

echo "Host: $(hostname)  Job: ${SLURM_JOB_NAME:-manual} (${SLURM_JOB_ID:-n/a})"
echo "Config: $CONFIGFILE  Target: $TARGET"

# Tags each rule-job this run submits with the project name (default is an
# opaque run UUID), so `squeue`/`sacct` are readable with two projects
# submitting rule-jobs into the same queue at once.
PROJECT_NAME="$(basename "$CONFIGFILE" .yaml)"

# Target must precede --configfile: --configfile takes nargs='+', so a
# target placed after it gets silently swallowed as a second config file
# instead of being treated as the rule to build.
#
# --set-threads overrides dada2's thread count above the shared N_THREADS
# config value: its mem_mb=16000 reservation is fixed regardless of thread
# count, and that reservation alone already serializes the two projects'
# dada2 jobs against each other (16000x2 > the node's memory budget) --
# so capping its threads to leave room for a second concurrent instance
# bought no actual concurrency, only a slower single run. Unlike this,
# Silva138's SEPP rule (rules/Silva138.smk) hardcodes threads=3
# independently of N_THREADS specifically because its memory usage DOES
# scale with thread count (one heavy worker per thread, already near its
# mem_mb=24000 ceiling there) -- leave that one alone.
exec snakemake "$TARGET" --workflow-profile profiles/slurm \
    --slurm-jobname-prefix "$PROJECT_NAME" --configfile "$CONFIGFILE" \
    --set-threads TGS_dada2=12 NGS_dada2=12
