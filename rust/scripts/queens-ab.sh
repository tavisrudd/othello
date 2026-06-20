#!/usr/bin/env bash
# Canonical interleaved A/B bench harness for the Queens solver.
# Codifies the hard-won orchestration lessons (see CLAUDE.md "Performance discipline") so we
# stop re-deriving this in /tmp every session. Toggles ONE env flag 0(off/control) vs 1(on)
# on the same binary, interleaved round-by-round (the only thermally-robust pattern on this box).
#
# WHY each choice (the failure modes this avoids):
#   * Run ONCE in the queens tmux pane (NOT driven by per-run `send-keys` from outside) — typing
#     into a busy pane interleaves garbage into the running solve.
#   * NEVER blind `tmux send-keys C-c` into the pane to "reset" it — that SIGINTs a running solve.
#     Make sure the pane is idle (at a prompt) before launching instead.
#   * The solver's live bar is on STDERR (stays on the pane TTY = watchable); the summary line is
#     on STDOUT (redirected to a file here so node counts are parseable). Never `| tee` (makes
#     stdout a non-TTY and the solver still prints the bar to stderr, but tee buffering hides it).
#   * Completion marker `QUEENS_AB_DONE` only ever appears as script OUTPUT, never as a typed
#     command, so an external `tmux capture-pane -t queens:<win> -p -S - | grep -q QUEENS_AB_DONE`
#     poll can't false-match the command line that launched the run.
#   * cyc/node = (perf cycles) / (solver nodes) is node-count-INDEPENDENT — the only trustworthy
#     n=16 A/B metric (wall hides real deltas under +-18% parallel node-count noise).
#   * n=16 default TT is 17 GB and the box has ~4 GB headroom during a run, so back-to-back 17 GB
#     allocations OOM-kill the 2nd run (huge-page reclaim lags process exit). Default to a ~12 GB
#     TT (QUEENS_TT_SLOTS=1500000000) which is memory-safe AND a valid comparison (the toggle's
#     per-node delta is TT-size-independent). Pass tt_slots=0 to use the solver default (17 GB) —
#     only with cache-drops between runs.
#
# Usage (run INSIDE the queens tmux pane):
#   scripts/queens-ab.sh <n> <TOGGLE_ENV> <binary> [rounds] [tt_slots] [solver]
# e.g.
#   scripts/queens-ab.sh 16 QUEENS_ITER ./target/release/queens
#   scripts/queens-ab.sh 16 QUEENS_PEEL /tmp/queens_snap 4 1500000000 iso-dense
# Poll completion from another shell:
#   until tmux capture-pane -t queens:<win> -p -S - | grep -q QUEENS_AB_DONE; do sleep 10; done
set -u
N=${1:?usage: queens-ab.sh <n> <TOGGLE_ENV> <binary> [rounds] [tt_slots] [solver]}
TOG=${2:?toggle env var, e.g. QUEENS_ITER}
BIN=${3:?path to a queens binary}
ROUNDS=${4:-3}
TT=${5:-1500000000}   # ~12 GB; 0 = solver default (17 GB, needs cache-drops between runs)
SOLVER=${6:-iso-dense}
OUT=$(mktemp -d /tmp/queens-ab.XXXXXX)
tt=""; [ "$TT" != 0 ] && tt="QUEENS_TT_SLOTS=$TT"
echo "######## queens A/B  n=$N  $TOG=0(off)/1(on)  bin=$BIN  solver=$SOLVER  rounds=$ROUNDS  TT=$TT  out=$OUT ########"
for r in $(seq 1 "$ROUNDS"); do
  for v in 0 1; do
    lab=off; [ "$v" = 1 ] && lab=on
    tag=${lab}_${r}
    echo; echo ">>>>>>>>>>>> BEGIN $tag ($TOG=$v) <<<<<<<<<<<<"
    env $tt "$TOG=$v" perf stat -o "$OUT/$tag.perf" -e cycles,instructions \
      "$BIN" solve "$N" "$SOLVER" 1>"$OUT/$tag.out"
    echo "============ END $tag ============"
  done
done
echo; echo "===== RESULTS  n=$N  $TOG  (cyc/node = perf cycles / solver nodes; node-count-independent) ====="
for r in $(seq 1 "$ROUNDS"); do
  for lab in off on; do
    tag=${lab}_${r}
    n=$(grep -oE "searched [0-9,]+ nodes" "$OUT/$tag.out" | grep -oE "[0-9,]+" | tr -d ,)
    c=$(grep -E " cycles" "$OUT/$tag.perf" | grep -oE "^[ ]*[0-9,]+" | tr -d ', ')
    awk -v n="$n" -v c="$c" -v t="$tag" \
      'BEGIN{if(n>0&&c>0)printf "%-8s cyc/node=%8.1f  nodes=%d\n",t,c/n,n; else printf "%-8s FAIL n=[%s] c=[%s]\n",t,n,c}'
  done
done
echo "QUEENS_AB_DONE  ($OUT)"
