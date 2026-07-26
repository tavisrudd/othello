# C80 — q23 fourth-control rank-zero test

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The direct rank-zero correspondence survives the fourth canonical q23 P
control exactly.

The C54 archive orders the first four P replies after root opponent `(0,0)`
as `(5,2)`, `(5,9)`, `(5,10)`, and `(5,13)`. The tested control is

```text
T''' = S4(1,2,3,4) + (0,0) + (5,13).
```

Across its complete outer domain:

```text
outer opponent fibres:          118
legal outer replies:          7,988
R0 replies:                   1,270
recursive F_d replies:        1,270
R0/F_d disagreements:             0
fibres containing an R0 reply: 118/118
```

Thus `R0=F_d` edge-for-edge and `R0` is opponent-complete. There is no
`F_d \ R0` edge and no uncovered fibre on this control. This is a fourth
finite positive, not a growing-depth theorem; C82 remains gated.

## First rejected branch

The first candidate in canonical opponent/reply order is again the first
recursive failure:

```text
outer opponent = (6,3)
outer reply    = (7,2)
target d       = 27
target Omega   = 47
```

The independently rules-checked C54 archive labels this target N:

```text
REPLY x=6,3 y=7,2 ygeom=int value=N
```

After the exchange

```text
(9,4) -> (22,9)
```

(with the reverse orientation also legal), play reaches

```text
S = {
  (0,0), (1,1), (2,12), (3,8), (4,6),
  (5,13), (6,3), (7,2), (9,4), (22,9)
}.
```

Here `Omega(S)=0`, the defect rank is two, and four legal moves remain.
Both defect move `(10,18)` and move `(20,19)` are terminal. Hence the
candidate fails one exchange below the eight-point target by direct
premature N absorption.

## Interpretation

Across the first four canonical controls, the exact finite record is now:

```text
controls:                    4
outer opponent fibres:      472
legal outer replies:     31,922
R0 = F_d edges:            5,220
uncovered fibres:              0
edge disagreements:            0
```

The identity has survived four adjacent controls with distinct outer
densities and edge counts. The first rejected branches on controls two
through four all fail after one exchange at an overload-zero state with a
terminal defect move. This is a stable local pattern, but the controls
remain correlated replies to one normalized root opponent and do not address
the square-root growing-depth obstruction.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_fourth_control_rank_zero.py
python3 rust/scripts/c80_q23_fourth_control_rank_zero.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_fourth_control_rank_zero.py` | 2,895 | `8169dd3019b795d5cab95d47b4b44ed7b11801107981d65fe382cad919faf3b7` |
| `notes/2026-07-25-c80-q23-fourth-control-rank-zero.json` | 30,637 | `e4a5b0ce7ac74676dcb69f107228bd135d4bf44dcb8555fe47dc33909ba6919d` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The generator reuses the checked second-control full-domain engine, pins its
source hash, shifts the C54 canonical P-reply window to the third/fourth
pair, and tests all 7,988 outer replies. The `R0`/`F_d` comparison uses the
same prime-grid implementation on both sides. The independent cross-check is
narrower: the C54 archive, whose full proof DAG was separately rules-checked,
confirms the chosen control is P and the extracted first rejected target is
N. No independent second implementation replays all 7,988 relation labels.

The exact searched domain is every legal outer opponent and every legal
reply from `S4(1,2,3,4)+(0,0)+(5,13)`. The stopping condition was the first
`F_d \ R0` edge, the first uncovered `R0` fibre, or exhaustion; exhaustion
occurred with neither failure.

## `ej` + `tt` closeout

The `ej` pass adds the four-control aggregate and preserves the direct
two-terminal-move obstruction for the first rejected branch.

The Tao-style correction is methodological: after four adjacent positives,
another one-control wrapper has diminishing information value. The next
finite falsifier should sweep the remaining canonical controls in archive
order and stop at the first disagreement or uncovered fibre, while emitting
a compact per-control summary. That changes only the batching, not the
mathematical claim or trust tier.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does `R0=F_d` survive the fourth canonical q23 P control?**
  Yes, exactly on all 7,988 candidates.
- **[SETTLED] Is `R0` opponent-complete there?** Yes, `118/118`.
- **[SETTLED] What is the first direct rejected branch?** Candidate
  `(6,3)->(7,2)` reaches, after `(9,4)->(22,9)`, an overload-zero rank-two
  state with two terminal moves.
- **[OPEN — C80] Which later canonical q23 control first has an
  `F_d \ R0` edge or an uncovered `R0` fibre?**
- **[OPEN — C80/C82 gate] What growing-rank algebraic update replaces the
  fixed-depth identity uniformly?**

## Vibe

The local identity now looks robust, but one-at-a-time adjacent probes have
reached diminishing returns; a stop-on-first-failure batch is the cleaner
next falsifier.

go C80 cap batch canonical q23 P controls from the fifth until first R0/F_d failure
