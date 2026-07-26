# C80 — q23 third-control rank-zero test

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The direct rank-zero correspondence survives the third canonical q23 P
control exactly.

The C54 archive orders the P replies after root opponent `(0,0)` with
`(5,2)`, `(5,9)`, and `(5,10)` first. The tested control is therefore

```text
T'' = S4(1,2,3,4) + (0,0) + (5,10).
```

Across its complete outer domain:

```text
outer opponent fibres:          120
legal outer replies:          8,248
R0 replies:                   1,384
recursive F_d replies:        1,384
R0/F_d disagreements:             0
fibres containing an R0 reply: 120/120
```

Thus `R0=F_d` edge-for-edge and `R0` is opponent-complete. There is no
`F_d \ R0` edge and no uncovered fibre on this control. This is a third
finite positive, not a growing-depth theorem; C82 remains gated.

## First rejected branch

The first candidate in canonical opponent/reply order is again the first
recursive failure:

```text
outer opponent = (6,3)
outer reply    = (7,2)
target d       = 37
target Omega   = 69
```

The independently rules-checked C54 archive labels this target N:

```text
REPLY x=6,3 y=7,2 ygeom=int value=N
```

After the exchange

```text
(8,7) -> (18,19)
```

(with the reverse orientation also legal), play reaches

```text
S = {
  (0,0), (1,1), (2,12), (3,8), (4,6),
  (5,10), (6,3), (7,2), (8,7), (18,19)
}.
```

Here `Omega(S)=0`, the defect rank is one, and five legal moves remain. The
unique defect move `(15,18)` is terminal. Hence the candidate fails one
exchange below the eight-point target for the same direct boundary reason
seen on the second control, with different ranks and coordinates.

## Interpretation

Across the first three canonical controls, the exact finite record is now:

```text
controls:                    3
outer opponent fibres:      354
legal outer replies:     23,934
R0 = F_d edges:            3,950
uncovered fibres:              0
edge disagreements:            0
```

The third control changes the outer density again and preserves exact
edge equality. This makes a one-control or two-control accident less likely,
but the controls are adjacent replies to the same normalized root opponent.
They are therefore correlated tests and do not address the established
square-root growing-depth obstruction.

The first rejected branch also repeats the meaningful negative pattern:
premature absorption at `Omega=0` with a terminal defect move, rather than a
failure of raw rank decrease.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_third_control_rank_zero.py
python3 rust/scripts/c80_q23_third_control_rank_zero.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_third_control_rank_zero.py` | 3,042 | `2a10fbe6e44c183a4b95a748fb5cf334e03440bf1d6d1c2055f7776bae66bdea` |
| `notes/2026-07-25-c80-q23-third-control-rank-zero.json` | 31,154 | `03330bfbbcf4af210b15676f6e577620cf707ff5a8e9ccb3e699796c88fcaed1` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The generator reuses the checked second-control full-domain engine, pins its
source hash, shifts the C54 canonical P-reply window by one, and tests all
8,248 outer replies. The `R0`/`F_d` comparison uses the same prime-grid
implementation on both sides. The independent cross-check is narrower: the
C54 archive, whose full proof DAG was separately rules-checked, confirms the
chosen control is P and the extracted first rejected target is N. No
independent second implementation replays all 8,248 relation labels.

The exact searched domain is every legal outer opponent and every legal
reply from `S4(1,2,3,4)+(0,0)+(5,10)`. The stopping condition was the first
`F_d \ R0` edge, the first uncovered `R0` fibre, or exhaustion; exhaustion
occurred with neither failure.

## `ej` + `tt` closeout

The `ej` pass adds the three-control aggregate and retains a direct terminal
certificate for the first rejected branch. Exact equality now covers 23,934
candidates rather than being reported as three disconnected runs.

The Tao-style correction is to keep the quantifiers visible: three adjacent
controls establish three finite identities, not one uniform identity. The
right next falsifier is another canonical control, while the theorem-level
target remains a growing-rank update rather than repeated fixed-shell
agreement.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does `R0=F_d` survive the third canonical q23 P control?**
  Yes, exactly on all 8,248 candidates.
- **[SETTLED] Is `R0` opponent-complete there?** Yes, `120/120`.
- **[SETTLED] What is the first direct rejected branch?** Candidate
  `(6,3)->(7,2)` reaches, after `(8,7)->(18,19)`, an overload-zero rank-one
  state where defect move `(15,18)` is terminal.
- **[OPEN — C80] Which canonical q23 control first has an `F_d \ R0` edge
  or an uncovered `R0` fibre?**
- **[OPEN — C80/C82 gate] What growing-rank algebraic update replaces the
  fixed-depth identity uniformly?**

## Vibe

The finite signal is now convincingly reproducible across three controls,
but it remains a local q23 shell and has not moved the uniform crown.

go C80 cap test R0/F_d equality on the fourth canonical q23 P control
