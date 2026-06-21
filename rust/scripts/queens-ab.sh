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
#   * The solver's live bar is on STDERR (stays on the pane TTY = watchable). The summary line is on
#     STDOUT, `tee`d via `1> >(tee file)` so it stays visible live; results, though, are parsed from the
#     per-run `--to-file` JSON (`{nodes, wall_secs, winner}`) — robust to any human-format change, no
#     pane scraping. Teeing STDOUT is safe — the bar is on STDERR and untouched. (Do NOT `2>&1 | tee`:
#     routing the bar through a pipe makes it a non-TTY and hides it.)
#   * RESULTS prints the per-run table AND the aggregate off/on means + Δ (nodes / cyc/node / total cyc /
#     wall) — so the A/B verdict is read straight off the harness, not recomputed by hand each time.
#   * Run each A/B in a FRESH dedicated tmux window (NOT a user's interactive pane); poll the JSON files
#     or `$STATE`, never the pane text.
#   * A monitor file `$STATE` (default /tmp/queens-ab.state, override with STATE=…) gets one appended
#     line per transition (START/BEGIN/END-with-summary/QUEENS_AB_DONE), so a watcher can
#     `inotifywait -m -e modify "$STATE"` / `tail -F "$STATE"` instead of scraping the pane.
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
# Monitor file (override with STATE=…): one line appended at every state transition so a watcher can
# `inotifywait -m -e modify "$STATE"` (or `tail -F`) instead of scraping the pane. The pane still shows
# the BEGIN/END markers, the live bar (stderr), AND the solver summary line — nothing is swallowed.
STATE=${STATE:-/tmp/queens-ab.state}
echo "START n=$N $TOG out=$OUT $(date +%s)" > "$STATE"
echo "######## queens A/B  n=$N  $TOG=0(off)/1(on)  bin=$BIN  solver=$SOLVER  rounds=$ROUNDS  TT=$TT  out=$OUT  state=$STATE ########"
for r in $(seq 1 "$ROUNDS"); do
  for v in 0 1; do
    lab=off; [ "$v" = 1 ] && lab=on
    tag=${lab}_${r}
    echo; echo ">>>>>>>>>>>> BEGIN $tag ($TOG=$v) <<<<<<<<<<<<"
    echo "BEGIN $tag $TOG=$v $(date +%s)" >> "$STATE"
    # Default-TT (TT=0, 17 GB) runs commit the whole table upfront, and huge-page reclaim lags the
    # prior process's exit — so back-to-back runs OOM-kill the 2nd. Gate on free memory (≥18 GB)
    # before launching so each run starts from a reclaimed box. (The 12 GB default needs no wait.)
    if [ "$TT" = 0 ]; then
      while [ "$(free -g | awk '/^Mem:/{print $7}')" -lt 18 ]; do sleep 3; done
    fi
    # stdout (the solver SUMMARY line) is `tee`d so it lands in the file AND on the pane TTY; the live
    # progress bar is on stderr (untouched ⇒ still renders live). perf stat → its own file. `--to-file`
    # also writes a clean JSON (`{nodes, wall_secs, winner, ...}`) so the results are parsed from JSON,
    # not scraped from the pane/text (decouples from the human-readable format).
    env $tt "$TOG=$v" perf stat -o "$OUT/$tag.perf" -e cycles,instructions \
      "$BIN" solve "$N" "$SOLVER" --to-file "$OUT/$tag.json" 1> >(tee "$OUT/$tag.out")
    echo "============ END $tag ============"
    # Append this run's summary + wall to the monitor file (one transition the watcher can fire on),
    # pulled from the JSON (winner / nodes / wall_secs).
    { printf 'END %s ' "$tag"
      python3 -c "import json,sys;d=json.load(open('$OUT/$tag.json'));print(f\"{d['winner']} player wins · {d['nodes']:,} nodes · {d['wall_secs']:.2f}s\")" 2>/dev/null \
        || echo "(json parse failed)"
    } >> "$STATE"
  done
done
echo; echo "===== RESULTS  n=$N  $TOG  (cyc/node = perf cycles / JSON nodes; node-count-independent) ====="
# Per-run table + accumulate off/on means for the aggregate delta (the node/cyc/wall ratios, computed
# here so we stop doing it by hand). cyc from perf, nodes+wall from the JSON.
python3 - "$OUT" "$ROUNDS" <<'PY'
import json, re, sys, glob, os
out, rounds = sys.argv[1], int(sys.argv[2])
def cyc(p):
    try:
        t = open(p).read()
        m = re.search(r'^\s*([\d,]+)\s+cycles', t, re.M)
        return int(m.group(1).replace(',', '')) if m else 0
    except OSError:
        return 0
agg = {'off': [], 'on': []}
for r in range(1, rounds + 1):
    for lab in ('off', 'on'):
        tag = f'{lab}_{r}'
        jp = os.path.join(out, f'{tag}.json')
        try:
            d = json.load(open(jp))
        except OSError:
            print(f'{tag:8} FAIL (no json)'); continue
        n, w = d['nodes'], d['wall_secs']
        c = cyc(os.path.join(out, f'{tag}.perf'))
        cpn = c / n if n else 0
        agg[lab].append((n, cpn, c, w))
        print(f'{tag:8} cyc/node={cpn:8.1f}  nodes={n:>13,}  wall={w:6.1f}s')
def mean(xs): return sum(xs) / len(xs) if xs else 0
if agg['off'] and agg['on']:
    on_, oc, ot, ow = (mean([x[i] for x in agg['off']]) for i in range(4))
    nn, nc, nt, nw = (mean([x[i] for x in agg['on']]) for i in range(4))
    print(f'\n  MEAN off: cyc/node={oc:.0f}  nodes={on_/1e9:.3f}B  totalGcyc={oc*on_/1e9:.0f}  wall={ow:.1f}s')
    print(f'  MEAN on : cyc/node={nc:.0f}  nodes={nn/1e9:.3f}B  totalGcyc={nc*nn/1e9:.0f}  wall={nw:.1f}s')
    pct = lambda a, b: f'{b/a-1:+.1%}' if a else 'n/a'
    print(f'  Δ on vs off: nodes {pct(on_,nn)} | cyc/node {pct(oc,nc)} | total cyc {pct(oc*on_,nc*nn)} | wall {pct(ow,nw)}')
PY
echo "QUEENS_AB_DONE  ($OUT)"
echo "QUEENS_AB_DONE $OUT $(date +%s)" >> "$STATE"
