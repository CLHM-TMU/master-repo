#!/usr/bin/env bash
# Attaches to an already-running `qiime fragment-insertion sepp` job and
# polls its stage/resource status, the same way the monitor baked into
# rules/Silva138.smk does — but standalone, so it can watch a job that's
# already in flight (started before this script ran, or from another
# terminal) instead of only ones launched after the fact.
#
# Apptainer here doesn't isolate the PID namespace, so the contained
# run_sepp.py process is visible on the host's own /proc at its real PID —
# no special handling needed to "reach into" the container.
#
# Usage:
#   scripts/watch_sepp.sh            # auto-attach if exactly one job is running
#   scripts/watch_sepp.sh <pid>      # attach to a specific run_sepp.py PID
#                                     # (shown by this script when >1 is running)
#
# Env: WATCH_SEPP_INTERVAL  polling interval in seconds (default 30)
set -euo pipefail

INTERVAL="${WATCH_SEPP_INTERVAL:-30}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/sepp_monitor_lib.sh"

# Walk up parents from a run_sepp.py PID to find the `qiime fragment-insertion
# sepp` process that launched it, and pull the --i-representative-sequences
# path out of its cmdline — the only place the study/db name actually shows up
# (run_sepp.py itself only sees anonymised /tmp/qiime2/work/data/<uuid> paths).
describe_sepp_job() {
    local pid="$1" ppid cmdline
    while [ -n "$pid" ] && [ "$pid" != "1" ]; do
        cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)
        case "$cmdline" in
            *"fragment-insertion sepp"*)
                echo "$cmdline" | grep -oE -- '--i-representative-sequences [^ ]+' || echo "$cmdline"
                return 0
                ;;
        esac
        ppid=$(awk '/^PPid:/{print $2}' "/proc/$pid/status" 2>/dev/null || true)
        pid="$ppid"
    done
    echo "(could not trace back to the qiime invocation)"
}

find_all_sepp_pids() {
    local pid field
    for pid in /proc/[0-9]*; do
        pid=${pid#/proc/}
        # Match individual NUL-separated argv fields, not a substring grep
        # over the raw cmdline blob: the Snakemake rule's own `bash -c`
        # script passes its whole body as one argv field, and that body's
        # comments mention "run_sepp.py" in prose — a substring grep would
        # false-match the rule's wrapper shell itself, not just the actual
        # run_sepp.py worker.
        [ -r "/proc/$pid/cmdline" ] || continue
        while IFS= read -r -d '' field; do
            case "$field" in
                run_sepp.py|*/run_sepp.py)
                    echo "$pid"
                    break
                    ;;
            esac
        done < "/proc/$pid/cmdline" 2>/dev/null
    done
}

pick_sepp_pid() {
    if [ $# -ge 1 ]; then
        echo "$1"
        return 0
    fi
    # A single SEPP invocation spawns several run_sepp.py worker processes
    # (one main + N multiprocessing children) that all share the same stderr
    # log file — dedupe on that log path so one real job's workers don't look
    # like several independent jobs.
    local candidates seen_logs="" p log first_pid=""
    candidates=$(find_all_sepp_pids | sort -u)
    local jobs=""
    for p in $candidates; do
        log=$(readlink -f "/proc/$p/fd/2" 2>/dev/null || true)
        case " $seen_logs " in
            *" $log "*) continue ;;
        esac
        seen_logs="$seen_logs $log"
        jobs="$jobs $p"
    done
    jobs=$(echo "$jobs" | xargs -n1 2>/dev/null || true)
    local n
    n=$(echo "$jobs" | grep -c . || true)
    if [ "$n" -eq 0 ]; then
        return 1
    elif [ "$n" -eq 1 ]; then
        echo "$jobs"
        return 0
    else
        echo "Multiple SEPP jobs are running — pick one:" >&2
        for p in $jobs; do
            echo "  pid $p: $(describe_sepp_job "$p")" >&2
        done
        echo "Re-run as: scripts/watch_sepp.sh <pid>" >&2
        return 2
    fi
}

sepp_pid="$(pick_sepp_pid "$@")" || {
    rc=$?
    if [ "$rc" -eq 2 ]; then exit 1; fi
    echo "No run_sepp.py process found yet. Waiting (checking every ${INTERVAL}s, Ctrl-C to stop)..." >&2
    while [ -z "${sepp_pid:-}" ]; do
        sleep "$INTERVAL"
        sepp_pid="$(pick_sepp_pid || true)"
    done
}

echo "Watching pid $sepp_pid: $(describe_sepp_job "$sepp_pid")" >&2
sepp_log=$(readlink -f "/proc/$sepp_pid/fd/2" 2>/dev/null || true)
echo "Log: ${sepp_log:-<not found>}" >&2

placement_total="?"
alignment_total="?"
while kill -0 "$sepp_pid" 2>/dev/null; do
    sleep "$INTERVAL"
    if { [ "$placement_total" = "?" ] || [ "$alignment_total" = "?" ]; } && [ -n "$sepp_log" ] && [ -r "$sepp_log" ]; then
        read -r placement_total alignment_total <<< "$(sepp_totals "$sepp_log")"
    fi
    if [ -n "$sepp_log" ] && [ -r "$sepp_log" ]; then
        format_sepp_progress "$sepp_log" "$placement_total" "$alignment_total"
    fi
    pids="$sepp_pid $(collect_descendants "$sepp_pid")"
    resource_summary "$pids"
done
echo "[watch_sepp] pid $sepp_pid is no longer running."
