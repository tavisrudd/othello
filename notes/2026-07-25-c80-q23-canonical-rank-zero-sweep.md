# C80 — q23 canonical rank-zero sweep

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The exact finite identity `R0=F_d` first fails on the eleventh canonical
q23 P control.

The checkpointed sweep starts after the four individually certified
controls and follows the C54 P-reply order after root opponent `(0,0)`.
Controls five through ten exhaust completely with exact edge equality and
full opponent coverage:

| canonical index | history reply | fibres | candidates | `R0=F_d` edges |
| ---: | --- | ---: | ---: | ---: |
| 5 | `(5,14)` | 115 | 7,624 | 1,138 |
| 6 | `(5,16)` | 116 | 7,706 | 1,206 |
| 7 | `(5,18)` | 114 | 7,494 | 1,258 |
| 8 | `(5,20)` | 116 | 7,724 | 1,300 |
| 9 | `(6,3)` | 115 | 7,600 | 1,294 |
| 10 | `(6,4)` | 115 | 7,562 | 1,080 |

Together with the four prior controls, the exact positive range is:

```text
canonical controls exhausted:    10
outer opponent fibres:        1,163
legal outer replies:         77,632
R0 = F_d edges:              12,496
uncovered fibres:                 0
edge disagreements:               0
```

The eleventh control is

```text
T = S4(1,2,3,4) + (0,0) + (6,5).
```

The sweep stops at candidate 3,281 in its canonical opponent/reply order:

```text
outer opponent = (12,20)
outer reply    = (16,15)
target d       = 30
target Omega   = 72
R0             = false
F_d            = true
```

This is the requested first `F_d \ R0` edge. No later candidate or control
was searched.

## Exact extra recursive layer

The target fails `R0` at exactly one defect obligation:

```text
defect opponent = (14,3)
direct replies to defect rank zero = none
```

The recursive survivor instead supplies

```text
F_d reply       = (18,21)
rank change     = 30 -> 1
target Omega    = 1
successor in R0 = true
```

The ten-point successor is

```text
{
  (0,0), (1,1), (2,12), (3,8), (4,6),
  (6,5), (12,20), (14,3), (16,15), (18,21)
}.
```

Thus the first failure is cleanly one layer beyond the direct
correspondence: `R0` cannot answer `(14,3)` immediately at rank zero, while
`F_d` answers into a rank-one `R0` state. This is not an uncovered outer
fibre and not a failure of defect descent.

The C54 archive independently labels the eleventh history reply P:

```text
REPLY x=0,0 y=6,5 ygeom=int value=P
```

Its early-break archive leaves the specific outer candidate unlabelled:

```text
REPLY x=12,20 y=16,15 ygeom=int value=unknown
```

The load-bearing P certificate for that target is therefore the sound
well-founded `F_d` recursion, not an oracle value.

## Interpretation

The direct rank-zero correspondence is a strong local compression, but not
the whole recursive survivor even at q23. Its first failure is unusually
controlled: only one defect fibre needs help, and one extra exchange lands
back in `R0`.

This is useful shape evidence but not a license to add another anonymous
fixed shell. The existing square-root depth obstruction rules out any
uniform bounded-depth absorption theorem. The correct successor must explain
how an algebraic rank-carrying obligation such as `(14,3)` transports through
the exchange `(18,21)` and returns to the direct packet, with iteration
allowed to grow with q.

C82 remains gated: a finite recursive edge has been located, not a
nonrecursive opponent-complete algebraic correspondence.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_canonical_rank_zero_sweep.py
python3 rust/scripts/c80_q23_canonical_rank_zero_sweep.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_canonical_rank_zero_sweep.py` | 10,249 | `c406751ee941fdc1b6c84b6e2d479dd2a4d0eb49579a9dd1ddbb01ddc8dc5432` |
| `notes/2026-07-25-c80-q23-canonical-rank-zero-sweep.json` | 6,760 | `0df43b36fab5f20bee9fdca006f2b6b1964c9d9df77edbf6acaa2b0b59a778e2` |

The JSON is canonical sorted data and is atomically checkpointed after every
exhausted control. `--check` regenerates the sweep in a temporary directory
and requires byte equality.

The generator reconstructs the normalized q23 geometry, reuses one
defect-survivor cache across controls, and compares `R0` and `F_d` with the
same prime-grid implementation. The C54 rules-checked archive independently
fixes the canonical P-control order and the history-control value, but does
not independently label the first mismatching child. No second
implementation replays the 45,710 fully exhausted new candidates plus 3,281
candidates in the stopping control; the exact machine-checked domain is
48,991 new candidates.

The stop condition is the first edge disagreement, first uncovered fibre,
or exhaustion of the canonical P-control list. The run stopped at the first
edge disagreement. Controls after canonical index eleven were not examined.

## `ej` + `tt` closeout

The `ej` pass promoted the Boolean mismatch into an exact obligation trace:
one defect fibre lacks a direct rank-zero reply, and its canonical `F_d`
witness lands at rank one inside `R0`. It also aggregates the ten-control
positive range rather than reporting only the batch tail.

The Tao-style correction is to resist naming a new depth-two packet. The
failure already exhibits the correct quantifier shape: carry a marked
obligation through a strict rank drop, then re-enter the direct relation.
The uniform question is how this rewrite iterates, not whether one more
fixed shell fits q23.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Where does `R0=F_d` first fail in canonical q23 P-control
  order?** At the eleventh control `(6,5)`, candidate
  `(12,20)->(16,15)`.
- **[SETTLED] Is the first failure an uncovered opponent fibre?** No. It is
  an `F_d \ R0` edge.
- **[SETTLED] What extra recursion is required?** Defect move `(14,3)` has
  no rank-zero reply; `(18,21)` drops rank `30->1` into `R0`.
- **[OPEN — C80] What bounded algebraic obligation datum makes that rewrite
  transportable and iterable through growing rank?**
- **[OPEN — C80/C82 gate] Can the resulting projected reply
  correspondence be proved opponent-complete uniformly in q?**

## Vibe

This is the best kind of finite failure: early enough to stop shell
overfitting, but structured enough to expose the missing recursive layer.
The direct correspondence survives as a base packet; the crown now moves to
an iterable obligation rewrite.

go C80 cap derive an iterable growing-rank obligation rewrite from the first q23 F_d-outside-R0 edge
