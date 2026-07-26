# C80 — q23 next-control rank-zero test

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The direct rank-zero correspondence survives the immediate next canonical
q23 P control exactly.

The C54 archive orders the P replies after root opponent `(0,0)` with
`(5,2)` first and `(5,9)` second. The tested control is therefore

```text
T' = S4(1,2,3,4) + (0,0) + (5,9).
```

Across its complete outer domain:

```text
outer opponent fibres:          116
legal outer replies:          7,700
R0 replies:                   1,326
recursive F_d replies:        1,326
R0/F_d disagreements:             0
fibres containing an R0 reply: 116/116
```

Thus

```text
R0 = F_d
```

on the second canonical control as well as the first. There is no
`F_d \ R0` edge and no `R0` coverage failure here. This is a second finite
positive, not a uniform theorem; C82 remains gated.

## First depth-two failure

The first candidate in canonical opponent/reply order is already the first
recursive failure:

```text
outer opponent = (6,3)
outer reply    = (7,5)
target d       = 25
target Omega   = 43
```

The target is N in the independently rules-checked C54 archive:

```text
REPLY x=6,3 y=7,5 ygeom=ext value=N
```

Its first failing recursive branch plays the exchange

```text
(10,13) -> (12,14)
```

(the reverse orientation is also legal) and reaches

```text
S = {
  (0,0), (1,1), (2,12), (3,8), (4,6),
  (5,9), (6,3), (7,5), (10,13), (12,14)
}.
```

Here `Omega(S)=0`, the defect rank is two, and four legal moves remain. The
defect move `(14,11)` has no legal response: it is a terminal move. Hence
this branch fails one exchange below the eight-point target for a direct
game reason, not because of a rank tie or a hidden minimax label.

The complete legal-move/follower counts and both legal orientations of the
exchange are retained in the JSON certificate.

## Interpretation

The identity on the first control was not a one-control accident. Its edge
count changes from `1,240/7,986` to `1,326/7,700`, yet the direct and
recursive relations remain identical and opponent-complete.

The extracted failure also sharpens what `R0` rejects. A losing outer reply
can preserve a large current defect rank and still collapse after one
exchange to an overload-zero state with a terminal defect move. The
obstruction is therefore premature N absorption at the boundary, not a
failure to decrease the raw rank.

This does not supply the growing-rank update required by C80. The next
decisive falsifier is the third canonical q23 P control, again comparing the
entire `R0` and `F_d` edge sets rather than fitting a scalar selector.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_next_control_depth_two.py
python3 rust/scripts/c80_q23_next_control_depth_two.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_next_control_depth_two.py` | 17,414 | `25ba9007b580f87e35bd2e411658781d25621d8341f58b22b6022f63458f33f3` |
| `notes/2026-07-25-c80-q23-next-control-depth-two.json` | 30,191 | `14706ee9076c3adf7c53d089c7191f1627597912ecce17837f62af65038cee57` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The generator reconstructs the normalized q23 grid incidence geometry and
tests all 7,700 outer replies. The `R0`/`F_d` comparison uses the same
prime-grid engine on both sides. The independent cross-check is narrower:
the C54 archive, whose full proof DAG was separately rules-checked, confirms
that the chosen control is P and that the extracted first failing target is
N. No independent second implementation replays all 7,700 relation labels.

## `ej` + `tt` closeout

The `ej` pass upgraded the requested failure extraction from a rank-only
trace to a direct terminal-move certificate and added the C54 N-value
cross-check. The failure is now locally intelligible: after one exchange,
`Omega=0` and `(14,11)` ends the game.

The Tao-style correction is not to call the second exact equality evidence
for a fixed-depth theorem. Two nearby controls may share the same shallow
geometry, while the square-root obstruction still forces growing depth
uniformly. The useful invariant evidence is narrower: `R0` remains
edge-exact under a nontrivial change in density, and its first rejection is
explained by a boundary terminal move.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does `R0=F_d` survive the immediate next canonical q23 P
  control?** Yes, exactly on all 7,700 candidates.
- **[SETTLED] Is `R0` opponent-complete there?** Yes, `116/116`.
- **[SETTLED] What is the first depth-two failure?** The candidate
  `(6,3)->(7,5)` reaches, after `(10,13)->(12,14)`, an overload-zero
  rank-two state where `(14,11)` is terminal.
- **[OPEN — C80] Which canonical q23 control first has an `F_d \ R0` edge
  or an uncovered `R0` fibre?**
- **[OPEN — C80/C82 gate] What growing-rank algebraic update replaces the
  fixed-depth identity uniformly?**

## Vibe

This is a clean positive replication with a concrete negative branch, but
the crown has not moved: the relation is still fixed-depth and only two
nearby q23 controls have been exhausted.

go C80 cap test R0/F_d equality on the third canonical q23 P control
