#!/usr/bin/env bash
# One-time setup of a single-node SLURM "cluster" on this workstation, so
# sbatch/squeue can queue pipeline runs instead of racing them by hand.
#
# Must be run once with sudo (root is required to install packages, create
# the slurm/munge system users, and manage systemd services):
#   sudo scripts/slurm/setup_slurm.sh
#
# Safe to re-run; each step is idempotent.
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run this with sudo: sudo $0" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# Hardcoded, not derived from $SUDO_USER: this script may be run via sudo
# from a different login (e.g. one that only exists to hold sudo rights),
# but the pipeline itself always runs as this OS user.
RUN_USER="work"

echo "==> Installing slurm-wlm and munge"
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y slurm-wlm munge

echo "==> Setting up munge auth key"
if [[ ! -s /etc/munge/munge.key ]]; then
    /usr/sbin/mungekey --verbose
fi
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key

echo "==> Deploying slurm.conf / cgroup.conf"
mkdir -p /etc/slurm
cp "$REPO_DIR/scripts/slurm/slurm.conf" /etc/slurm/slurm.conf
cp "$REPO_DIR/scripts/slurm/cgroup.conf" /etc/slurm/cgroup.conf

echo "==> Creating SLURM state/log directories"
install -d -o slurm -g slurm /var/spool/slurmctld
install -d -o slurm -g slurm /var/spool/slurmd
install -d -o slurm -g slurm /var/log/slurm

echo "==> Enabling lingering for '$RUN_USER' (needed so run_snakemake.sh's"
echo "    'systemd-run --user' cgroup wrapper works from a batch job with no"
echo "    interactive login session)"
loginctl enable-linger "$RUN_USER"

echo "==> Starting services"
systemctl enable --now munge
systemctl enable --now slurmctld
systemctl enable --now slurmd

sleep 2
echo "==> Cluster status"
sinfo
echo
echo "Setup complete. Submit jobs as the '$RUN_USER' user, e.g.:"
echo "  sbatch scripts/slurm/run_project.sbatch config/config_tisha260707.yaml"
