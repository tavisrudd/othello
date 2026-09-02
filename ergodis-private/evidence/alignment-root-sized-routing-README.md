# Sized-root operational routing baseline

This bundle repeats the alignment root-cost audit on the first active root
whose sizing pass has completed.  These rows expose the stable fields sampled
by the once-per-second operational publisher: root orbit, sizing status,
initial unresolved count, packing, and initial branch count.  Every controlled
root is independently rerun through the uncontrolled solver with exact counter
parity before the corpus is written.

The 8-point/budget-8 development corpus has 56 rows, six observable classes,
and an exact interface ceiling of 39/56.  Numeric routing reaches that ceiling
at trial 32 / 5,376 semantic-op rows, versus 49 / 8,232 for balanced and
structural (1.53x).

The separately frozen 7-point/budget-7 corpus has 35 rows and five observable
classes.  Its exact interface ceiling rises to 24/35 because the sized-root
branch-count feature separates an additional class.  All three current
evolution routes stop at 20/35, reached at trial 2 / 210 rows by the shared
counterexample-threshold repair.  The missing four points are therefore not a
representation limit: they expose the absence of a bounded mutation that can
grow a predicate by composing a new field clause.  This bundle is the frozen
before-control for that candidate-language extension.

The corpora, reports, streamed evidence, hashes, and exact evidence lengths are
retained beside this memo.  Ephemeral manifests, ledgers, sockets, and control
credentials are excluded.

Replay from `ergodis-private/` with fresh create-only output paths:

```sh
cargo run --release -p ergodis-tools -- alignment-root-corpus \
  --points 8 --budget 8 --capture-sized \
  --output examples/data/replay-alignment-root-cost-p8-b8-sized.jsonl \
  --report evidence/replay-alignment-root-cost-p8-b8-sized-report.json

cargo run --release -p ergodis-tools -- target-strategy-audit \
  --data examples/data/alignment-root-cost-p8-b8-sized.jsonl \
  --seeds examples/data/alignment-root-cost-seeds.jsonl \
  --run-root evidence/replay-alignment-root-sized-routing-runs \
  --output evidence/replay-alignment-root-sized-routing-report.json \
  --target-field root_sized --target-value 1 \
  --generations 4 --beam 8 --max-candidates 128
```

Replace `8` by `7` and use `--points 7 --budget 7` for the held-out control.
