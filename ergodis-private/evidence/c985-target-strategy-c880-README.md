# C985 target-strategy mechanism audit

This bundle tests whether Ergodis' `balanced`, `numeric`, and `structural`
evolution strategies change the time-to-first exact predicate in the intended
direction.  It uses the frozen C880 live-ordering rows, but the two seeds are
deliberately shaped mechanism controls rather than held-out application tasks.
Consequently, these results support the routing mechanism only; they are not a
claim about end-to-end C880 solve time or general theorem-synthesis speed.

All three strategies enumerate the same bounded mutation set and test 32
candidates.  Only their ordering differs.

| Control | Balanced | Numeric | Structural |
|---|---:|---:|---:|
| Numeric-shaped seed: first exact trial | 6 | **2** | 7 |
| Numeric-shaped seed: semantic-op rows | 60 | **20** | 70 |
| Structural-shaped seed: first exact trial | 13 | 24 | **7** |
| Structural-shaped seed: semantic-op rows | 130 | 240 | **70** |

Thus numeric routing uses 3.0x fewer trials than balanced on the
numeric-shaped control, while structural routing uses 1.86x fewer trials than
balanced and 3.43x fewer than numeric on the reciprocal structural-shaped
control.  Every strategy still finds at least one exact predicate in each
control.

The machine-readable reports contain the input, seed, and streamed-evidence
SHA-256 hashes:

- `c985-target-strategy-c880-report.json`
- `c985-target-strategy-c880-structural-report.json`

The six referenced JSONL evidence streams are retained under the corresponding
`*-runs/*/evidence/` directories.  Campaign manifests and control ledgers are
intentionally excluded because they contain ephemeral process/control state.

Replay from `ergodis-private/` with fresh create-only output paths:

```sh
CARGO_TARGET_DIR=../rust/target-c985-private-profile \
  cargo run --release --bin target_strategy_audit -- \
  --data examples/data/campaign-c880-live-ordering.jsonl \
  --seeds examples/data/c985-target-strategy-seeds.jsonl \
  --run-root evidence/replay-target-strategy-numeric-runs \
  --output evidence/replay-target-strategy-numeric-report.json \
  --target-field root_orbit --target-field root_initial_packing \
  --target-field root_sized --target-value 6 --target-value 2 \
  --target-value 1 --generations 3 --beam 4 --max-candidates 32

CARGO_TARGET_DIR=../rust/target-c985-private-profile \
  cargo run --release --bin target_strategy_audit -- \
  --data examples/data/campaign-c880-live-ordering.jsonl \
  --seeds examples/data/c985-target-strategy-structural-seeds.jsonl \
  --run-root evidence/replay-target-strategy-structural-runs \
  --output evidence/replay-target-strategy-structural-report.json \
  --target-field root_orbit --target-field root_initial_packing \
  --target-field root_sized --target-value 6 --target-value 2 \
  --target-value 1 --generations 3 --beam 4 --max-candidates 32
```
