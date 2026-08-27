#!/usr/bin/env bash
# One-time setup of SLURM accounting (slurmdbd + MariaDB), required by
# snakemake-executor-plugin-slurm's `sacct`-based job status polling.
# Without this, the plugin hits a confirmed unfixed bug (TypeError) when
# AccountingStorageType is left at the default accounting_storage/none:
# https://github.com/snakemake/snakemake-executor-plugin-slurm/issues/38
#
# Run once, AFTER scripts/slurm/setup_slurm.sh, with sudo:
#   sudo scripts/slurm/setup_slurmdbd.sh
#
# Safe to re-run; the generated DB password is reused across runs.
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run this with sudo: sudo $0" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SLURMDBD_CONF=/etc/slurm/slurmdbd.conf
DB_NAME=slurm_acct_db
DB_USER=slurm

echo "==> Installing mariadb-server and slurmdbd"
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server slurmdbd

echo "==> Ensuring MariaDB is running"
systemctl enable --now mariadb

if [[ -s "$SLURMDBD_CONF" ]]; then
    echo "==> $SLURMDBD_CONF already exists, reusing its DB password"
    DB_PASS="$(grep -oP '^StoragePass=\K.*' "$SLURMDBD_CONF")"
else
    echo "==> Generating a new DB password"
    DB_PASS="$(openssl rand -base64 24)"
fi

echo "==> Creating accounting database/user (idempotent)"
mysql <<SQL
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
ALTER USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "==> Writing $SLURMDBD_CONF"
cat > "$SLURMDBD_CONF" <<EOF
AuthType=auth/munge
DbdHost=localhost
SlurmUser=slurm
StorageType=accounting_storage/mysql
StorageHost=localhost
StorageUser=${DB_USER}
StoragePass=${DB_PASS}
StorageLoc=${DB_NAME}
LogFile=/var/log/slurm/slurmdbd.log
PidFile=/run/slurmdbd.pid
EOF
chown slurm:slurm "$SLURMDBD_CONF"
chmod 600 "$SLURMDBD_CONF"

echo "==> Redeploying slurm.conf (now includes AccountingStorageType=slurmdbd)"
cp "$REPO_DIR/scripts/slurm/slurm.conf" /etc/slurm/slurm.conf

echo "==> Starting slurmdbd, then restarting slurmctld to pick up accounting config"
systemctl enable --now slurmdbd
sleep 2
systemctl restart slurmctld

echo "==> Registering cluster/account/user with SLURM accounting"
sacctmgr -i add cluster clhm-local || true
sacctmgr -i add account clhm Description="CLHM lab" Organization=tmu || true
# Hardcoded, not $SUDO_USER: this script may be run via sudo from a
# different login than the one that actually runs the pipeline.
sacctmgr -i add user work Account=clhm || true

echo "==> Verifying with a test job"
TEST_JOBID="$(sbatch --parsable --wrap="sleep 5")"
echo "Submitted test job $TEST_JOBID, waiting for it to finish..."
sleep 12
sacct -j "$TEST_JOBID" --format=JobID,State,Elapsed

echo
echo "If the row above shows a real State (e.g. COMPLETED) rather than an"
echo "error about accounting storage being disabled, setup succeeded."
