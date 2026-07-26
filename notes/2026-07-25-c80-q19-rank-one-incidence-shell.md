# C80 — bounded small-shell incidence correspondence

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The explicit `B_cc` pairings and rank-one reply tables can be eliminated from
the q17/q19 repair correspondence. One bounded, projectively natural
incidence formula is opponent-complete and value-pure on all five targets.

For a target `U`, define the small boundary `B_small(U)` by

```text
Omega(U)=0
and
(
  U has no legal moves
  or
  U has exactly two legal moves and they are mutually legal
).
```

Define its one-exchange shell by

```text
Shell_small(U) :=
  for every legal x,
  there is a legal reply y such that B_small(U+x+y).
```

Both clauses are sound:

- no legal moves is terminal P;
- exactly two mutually legal moves is P by pairing;
- `Shell_small` is P by making the displayed reply into `B_small`.

The definition has fixed quantifier depth and bounded incidence/cardinality
arity. It contains no matching witness, explicit reply table, Grundy value,
minimax query, or recursive survivor membership.

Use the outer correspondence

```text
R_small(T;o,p) :=
  T+o+p satisfies B_small or Shell_small.
```

Retaining all replies lexicographically minimizing small-shell rank and
`kappa=|Legal(T+o+p)|` gives:

| target | opponent coverage | selected edges | exact values |
| --- | ---: | ---: | ---: |
| each q17 repair target | `32/32` | 49 | `49 P + 0 N` |
| q19 control | `51/51` | 69 | `69 P + 0 N` |

Thus the representative combined correspondence is `118/118 P`. All
selected targets strictly lower `Omega`, and every fibre signature commutes
with projective transport.

This is a live C80 candidate formula, not a uniform theorem. Opponent
completeness is finite-certified only at q17 and q19; neither a field-uniform
incidence proof nor a q23 out-of-sample test has been completed. C82 remains
gated on that coverage theorem.

## Compression of the four q19 exceptions

The preceding `B_cc` rewrite left four q19 outer opponent fibres requiring
rank one. They give five selected targets:

| outer pair `(o,p)` | `Omega` | legal moves | active zero-load blocks |
| --- | ---: | ---: | ---: |
| `((1,3),(7,13))` | 2 | 9 | two triples |
| `((5,12),(7,13))` | 1 | 7 | one triple |
| `((6,15),(2,10))` | 1 | 11 | one triple |
| `((6,15),(3,13))` | 2 | 11 | two triples |
| `((8,8),(12,3))` | 1 | 9 | one triple |

For the first four targets, the terminal-pair relation alone covers every
legal opponent. Their oriented terminal edges are respectively

```text
16, 12, 18, 18.
```

The fifth has 16 terminal edges plus 12 edges leaving exactly two mutually
legal moves. Hence all 47 inner opponent fibres are covered by 92
formula-defined sound edges:

```text
80 terminal + 12 two-move pairing.
```

All five targets and all 92 boundary followers cross-check as exact P.
The earlier explicit persistent pairings were therefore unnecessary on this
entire exceptional layer.

## Full q17/q19 outer gate

The same formula unexpectedly replaces `B_cc` on every outer fibre, not only
the four q19 exceptions.

At q17, small-shell rank and minimum deficiency are

```text
rank 0: kappa 0^10 2^7
rank 1: kappa 3^9 4^6.
```

The 49 selected edges all land at `Omega=0`. Their fibre degrees are:

```text
degree 1: 19 opponents
degree 2: 10 opponents
degree 3:  2 opponents
degree 4:  1 opponent.
```

At q19 every selected target is in `Shell_small`; the minimum deficiencies
are

```text
4^10 5^7 6^7 7^14 8^9 9^3 11^1.
```

The 69 selected edges land at:

```text
Omega 0: 49
Omega 1: 18
Omega 2:  2,
```

compared with `Omega=169` at the control target. Their fibre degrees are:

```text
degree 1: 36 opponents
degree 2: 13 opponents
degree 3:  1 opponent
degree 4:  1 opponent.
```

The observed degree is at most four at both orders, but no uniform
degree-four theorem is claimed.

## Fixed bounded incidence format

The formula can be written without cardinality primitives.

`Omega(U)=0` says that there do not exist a zero-load line and three distinct
legal points of `U` on that line. Terminality says there is no legal point.
The two-move clause quantifies distinct legal points `a,b`, requires every
legal point to equal one of them, and requires `b` to remain legal after
selecting `a`. All predicates are projective incidence and selected/legal
membership predicates with a fixed number of variables.

Consequently `B_small`, `Shell_small`, and `R_small` are q-independent
first-order formulas of bounded arity. Their witnesses do not pack
`Theta(q)` matching edges or encode a strategy tree. The shell still contains
one `forall x exists y` coverage obligation, but that is the theorem C80 is
supposed to prove, not stored proof data.

This resolves the prior anti-packing objection at the formula level. What
remains is genuinely algebraic/combinatorial: prove that every opponent
fibre contains such a reply and obtain a count usable by C82.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q19_rank_one_incidence_shell.py
python3 rust/scripts/c80_q19_rank_one_incidence_shell.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q19_rank_one_incidence_shell.py` | 20,147 | `340f7f46b3189420b2ba2517469271fbd1ced68051a7c6988353267795fa1323` |
| `notes/2026-07-25-c80-q19-rank-one-incidence-shell.json` | 158,965 | `cd1171c10dadfdfe5485e31c34791555002cc6df1afb2d94b87ebb4ff94706c4` |

The generator reconstructs the q17 repair orbit and q19 control, evaluates
the bounded formula on every legal outer pair, retains all lexicographic
minimizers, and independently checks exact value and strict overload
decrease. It also records all 92 inner edges for the five former rank-one
targets.

Transport recomputation passes:

```text
q17 outer fibres: 128/128;
q19 outer fibres: 204/204;
q19 inner fibres: 188/188.
```

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

Soundness of `B_small` and `Shell_small` is mathematical and
field-independent. Opponent completeness, fibre degrees, exact-value
cross-checks, and transport counts retain the normalized q17/q19
computational trust boundary.

## `ej` + `tt` closeout

The `ej` compression first removed the five explicit q19 witness tables, then
tested the resulting formula globally rather than assuming it applied only
to the exceptions. That second pass is the main gain: `R_small` replaces all
explicit `B_cc` witnesses on the full q17/q19 test domain.

The Tao-style distinction is now clean:

```text
soundness of each R_small edge: proved;
finite q17/q19 fibre coverage: certified;
uniform odd-q fibre coverage:  open.
```

This is no longer a feature fit or packed response tree. It is a fixed
incidence statement with an out-of-sample proof obligation.

No incidental discovery-track item arose.

## Mystery ledger

- **[PROVED] Is `B_small` a P boundary?** Yes: terminal or a pair of mutually
  legal moves.
- **[PROVED] Is `Shell_small` P?** Yes, by one direct exchange into
  `B_small`.
- **[SETTLED] Do the four q19 rank-one fibres require explicit `B_cc`
  pairings?** No. The bounded small-shell relation covers all 47 inner
  opponents with 92 sound edges.
- **[FINITE-CERTIFIED positive] Does the same bounded formula cover the full
  q17/q19 outer correspondence?** Yes: `49/49 P` and `69/69 P`.
- **[SETTLED] Does the formula satisfy the anti-packing format gate?** Yes at
  the definition level: fixed arity, fixed quantifier depth, no matching or
  response-tree datum.
- **[OPEN — C80] Does every intended odd-q escape target have
  opponent-complete `R_small` fibres?**
- **[OPEN — C80] Is the observed outer fibre degree at most four uniformly,
  or what lower bound is available for C82?**
- **[OPEN — q23 falsifier] Does the correspondence survive the first
  out-of-sample order?**
- **[OPEN — C80/C82 gate] Can the `forall exists` incidence obligation be
  proved and counted uniformly?**

## Vibe

This is the first bounded-formula correspondence in the thread that is
simultaneously projective, sound, opponent-complete, and value-pure on both
q17 and q19. The remaining gap is exactly the right one: prove or falsify its
uniform coverage.

go C80 cap test the bounded small-shell correspondence on q23 and derive its field-uniform incidence equations
