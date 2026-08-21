# Shared by rules/Silva138.smk's inline monitor and scripts/watch_sepp.sh.
# Bash functions for locating a running SEPP job's own log and turning it
# into one compact progress line: timestamp, job type, which decomposition
# subset it belongs to, and completed/total progress.
#
# Not meant to be run directly — source it.
#
# Every extraction below that greps for an optional/phase-specific pattern is
# guarded with `|| true` on the assignment. Without it, a `grep` that finds no
# match exits non-zero, and under `set -e -o pipefail` (as both callers run
# with) that silently kills the whole monitor script the instant SEPP's log
# format changes between phases — which is exactly what happened: hmmbuild/
# hmmsearch lines carry a "P_<n>/A_<n>_<m>" subset id, but the later pplacer
# phase only logs "P_<n>" (no alignment-subset component), so the stricter
# pattern stopped matching and the unguarded pipeline took the script down
# with no error message the moment SEPP reached that phase.

# All descendant PIDs of $1, walked via /proc (portable — no dependency on
# pgrep/job-control semantics).
collect_descendants() {
    local pid="$1" kids c
    kids=$(cat "/proc/$pid/task/$pid/children" 2>/dev/null)
    for c in $kids; do
        echo "$c"
        collect_descendants "$c"
    done
}

# Finds the run_sepp.py process among $1's descendants and returns the path
# its stderr is redirected to (qiime hides this log instead of streaming it).
find_sepp_log() {
    local root="$1" pid field
    for pid in $(collect_descendants "$root"); do
        # Match individual NUL-separated argv fields, not a substring grep
        # over the raw cmdline blob: under apptainer, the rule's own script
        # gets re-exec'd one or more times as a `bash -c` wrapper carrying
        # its whole body as one argv field, and that body's comments mention
        # "run_sepp.py" in prose — a substring grep matches that wrapper
        # (whose fd 2 is the terminal, not a log file) before ever reaching
        # the real run_sepp.py descendant.
        [ -r "/proc/$pid/cmdline" ] || continue
        while IFS= read -r -d '' field; do
            case "$field" in
                run_sepp.py|*/run_sepp.py)
                    readlink -f "/proc/$pid/fd/2" 2>/dev/null && return 0
                    ;;
            esac
        done < "/proc/$pid/cmdline" 2>/dev/null
    done
    return 1
}

# SEPP logs its total subset counts once, near the start, before any
# per-subset work begins. Prints "<placement_total> <alignment_total>",
# each "?" if not found yet (run still in early setup).
sepp_totals() {
    local log="$1" placement_total alignment_total
    placement_total=$(grep -oE "Breaking into [0-9]+ placement subsets" "$log" 2>/dev/null | grep -oE "[0-9]+" | head -1) || true
    alignment_total=$(grep -oE "Breaking into [0-9]+ alignment subsets" "$log" 2>/dev/null | grep -oE "[0-9]+" | head -1) || true
    echo "${placement_total:-?} ${alignment_total:-?}"
}

# Formats the latest "Finished <type> Job" line into one summary line:
# timestamp, job type, subset, and completed/total (%). hmmbuild/hmmsearch
# are each one job per alignment subset (P_<n>/A_<n>_<m>), tracked against
# alignment_total; pplacer is one job per placement subset (P_<n> only),
# tracked against placement_total. Falls back to a raw count for any other
# job type this hasn't seen before, rather than guessing a denominator.
format_sepp_progress() {
    local log="$1" placement_total="$2" alignment_total="$3"
    local last_line ts job_type subset total_for_subset completed pct
    last_line=$(grep "Finished .* Job" "$log" 2>/dev/null | tail -n 1) || true
    if [ -z "$last_line" ]; then
        echo "(still in setup — no job completions logged yet)"
        return
    fi

    ts=$(echo "$last_line" | grep -oE "^\[[0-9:]+\]" | tr -d '[]') || true
    job_type=$(echo "$last_line" | grep -oE "Finished [A-Za-z]+ Job" | awk '{print $2}') || true

    # The line typically mentions the subset path twice (once for the
    # model/backbone input, once for the results/output side) — take the
    # first. Try the full alignment-subset id first; only pplacer-phase
    # lines lack it, in which case fall back to just the placement subset.
    subset=$(echo "$last_line" | grep -oE "root/P_[0-9]+/A_[0-9]+_[0-9]+" | head -1 | sed 's#root/##') || true
    if [ -n "$subset" ]; then
        total_for_subset="$alignment_total"
    else
        subset=$(echo "$last_line" | grep -oE "root/P_[0-9]+" | head -1 | sed 's#root/##') || true
        total_for_subset="$placement_total"
    fi

    completed=$(grep -c "Finished ${job_type} Job" "$log") || true

    if [ "$total_for_subset" != "?" ] && [ -n "$total_for_subset" ]; then
        pct=$(awk -v c="$completed" -v t="$total_for_subset" 'BEGIN{printf "%.1f", (t>0 ? 100*c/t : 0)}')
        echo "[$ts] $job_type  ${subset:-?}  -  $completed/$total_for_subset subsets ($pct%)"
    else
        echo "[$ts] $job_type  ${subset:-?}  -  $completed completed"
    fi
}

# One-line aggregate RSS + process count across a PID list (space- and/or
# newline-separated — collect_descendants emits one PID per line).
resource_summary() {
    local pids="$1" pid_csv
    pid_csv=$(echo "$pids" | tr '\n' ' ' | tr -s ' ' | sed 's/^ *//; s/ *$//' | tr ' ' ',')
    ps -o rss= -p "$pid_csv" 2>/dev/null \
        | awk '{sum+=$1; n++} END{ if (n>0) printf "%.1fGB RSS across %d procs\n", sum/1024/1024, n; else print "no matching processes" }' || true
}
