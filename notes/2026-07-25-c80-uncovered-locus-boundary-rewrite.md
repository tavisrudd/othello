# C80 — uncovered-locus boundary rewrite

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The q17 one-/two-point uncovered obligations have a complete graph-theoretic
classification, and one direct boundary rewrite is sound and
opponent-complete on the entire q17 repair orbit plus the q19 control.

Define rewrite rank zero by

```text
Omega(U)=0
and the legal conflict graph G_U satisfies B_cc,
```

where `B_cc` is the proved persistent-pair/adaptive-copycat boundary. Define
rank one by one explicit opponent/reply exchange from `U` into rank zero.
For each marked opponent, retain all replies lexicographically minimizing

```text
(rewrite rank, kappa),
```

where `kappa=|Legal(U)|`.

The resulting correspondence is finite-sound:

| target | opponent coverage | selected edges | exact values |
| --- | ---: | ---: | ---: |
| each q17 repair target | `32/32`, all rank zero | 49 | `49 P + 0 N` |
| q19 control | `47/51` rank zero, `4/51` rank one | 67 | `67 P + 0 N` |

All q17 targets land at `Omega=0`. At q19, 62 selected oriented edges land at
`Omega=0`, three at `Omega=1`, and two at `Omega=2`, all far below the
control target's `Omega=169`; the five positive-overload targets have a
direct exchange into the overload-zero boundary.

This is the first tested reply correspondence in the current thread that is
both opponent-complete and value-pure on q17 and q19. It is not yet the
uniform C80 crown. A `B_cc` witness may list a growing persistent pairing,
and rank one quantifies over the full next reply fibre. The construction is a
direct finite proof object, but no bounded algebraic format or field-uniform
size bound is proved. C82 remains gated.

## Exact q17 small-locus classification

For the 22 isolates of the q17 terminal-reply graph, retain every reply with
minimum raw `kappa`. Their uncovered legal conflict graphs are:

| `kappa` | uncovered graph | value | oriented edges |
| ---: | --- | ---: | ---: |
| 1 | `K1` | N | 13 |
| 2 | `K2` | N | 29 |
| 2 | `2 K1` | P | 3 |
| 3 | path `P3` | N | 1 |
| 3 | `K2 disjoint K1` | P | 2 |

Thus the one-/two-point distinction is exact and elementary:

```text
one uncovered move       -> N;
two conflicting moves    -> N;
two nonconflicting moves -> P by pairing.
```

At deficiency three, `P3` is N while `K2 disjoint K1` is P. The latter is
the one-exchange adaptive shell: replying in the `K2` leaves the isolated
mate, or replying to the isolate leaves a terminal response in `K2`.

For these minimum-coverage replies, q17 value is exactly “the uncovered graph
is disconnected.” That finite mnemonic does not survive q19, whose
minimum-deficiency graphs include connected P examples. The structural rule
that does survive is the proved `B_cc` boundary, not connectivity.

## The direct rewrite

### Rank zero

At overload zero the residual cap game is Node--Kayles on its legal conflict
graph. A persistent pairing is P by copycat. The adaptive clause

```text
for every opponent x,
there is a nonconflicting reply y
whose follower has a persistent pairing
```

is also P by one exchange followed by copycat. These are precisely the
soundness propositions already proved for `B_cc`; no minimax value appears
in the rewrite definition.

Choosing minimum `kappa` only **after** imposing this boundary condition
changes the q17 isolate census:

```text
minimum boundary kappa: 2^7 3^9 4^6.
```

Together with the ten terminal-core fibres at `kappa=0`, all 32 opponents
are covered at rank zero. The fibre-degree histogram is

```text
degree 1: 19 opponents
degree 2: 10 opponents
degree 3:  2 opponents
degree 4:  1 opponent.
```

All 49 retained oriented edges are P by the boundary proof and by independent
exact-grid cross-check.

### Rank one

At q19 the overload-zero boundary covers 47 of 51 opponents. The four
exceptions are

```text
(1,3), (5,12), (6,15), (8,8).
```

Their selected rank-one deficiencies are respectively

```text
9, 7, 11, 9.
```

The `(6,15)` fibre has two tied replies; the other three have one, giving
five selected rank-one edges. For every legal move from each of those five
targets, the certificate records at least one direct reply to an
overload-zero `B_cc` graph. Induction is unnecessary: this is one displayed
quantifier layer followed by the proved boundary.

The complete q19 fibre-degree histogram, including rank zero, is

```text
degree 1: 39 opponents
degree 2: 10 opponents
degree 4:  2 opponents.
```

All 67 selected edges are P by the rank-zero/rank-one proof and exact-grid
cross-check.

## Why this does not release C82

The correspondence meets three previously missing finite gates:

1. every opponent has a reply;
2. every selected reply is sound without consulting minimax;
3. the construction commutes with projective transport.

It has not met the anti-packing/information gate. Persistent-pair witnesses
can contain `Theta(q)` pairs, and the rank-one clause can contain one response
for every legal move of its target. The observed minimum boundary deficiency
also grows from at most four at q17 to as much as eleven at q19.

Consequently this result certifies the q17 repair orbit and q19 control by a
common **logical schema**, but it does not yet give one bounded-degree
algebraic datum countable by C82. Calling the finite `B_cc` witnesses the
uniform datum would merely package the response tree.

The highest-value successor is now sharply localized: compress the four q19
rank-one fibres into a direct incidence certificate, or prove that their
`B_cc` witnesses necessarily carry growing matching information. The q17
small-locus problem itself is closed.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_uncovered_locus_boundary_rewrite.py
python3 rust/scripts/c80_uncovered_locus_boundary_rewrite.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_uncovered_locus_boundary_rewrite.py` | 19,295 | `ee693d6112f9b79e776ccd94d0552984316b46a8fd997ba93cd57f9c476a8de5` |
| `notes/2026-07-25-c80-uncovered-locus-boundary-rewrite.json` | 219,207 | `9fa15a0d8fb347f36ef5ec1c0e9a9629778ab313a2c1bf55a241a97809beca69` |

The generator reconstructs every legal outer pair, classifies all q17
minimum uncovered graphs, constructs rank-zero and rank-one witnesses,
retains all lexicographic minimizers, and independently checks exact grid
value. Representative fibre signatures are recomputed under the order-four
projective stabilizers:

```text
q17: 128/128;
q19: 204/204.
```

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The rank-zero and rank-one soundness arguments are mathematical. The
opponent coverage, witness sizes, exact P cross-checks, and transport census
retain the normalized prime-grid computational trust boundary.

## `ej` + `tt` closeout

The `ej` upgrade did not stop at the attractive q17 shape mnemonic. It tested
the actual proved boundary on q19, exposed four positive-overload exceptions,
and closed them with exactly one additional exchange layer. This isolates
the remaining problem as proof-object compression rather than game
soundness.

The Tao-style warning is equally concrete: `B_cc` is a fixed logical formula,
but its witnesses are not automatically bounded data. A uniform theorem must
replace the enumerated pairings and response fibres by an algebraic
certificate with direct update. The present result is a successful finite
model of that theorem, not the theorem itself.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] What are the q17 one-/two-point uncovered obligations?**
  `K1` is N, `K2` is N, and `2K1` is P.
- **[SETTLED] What happens at the only q17 minimum-deficiency-three fibre?**
  Its two `K2 disjoint K1` replies are P; its `P3` reply is N.
- **[FINITE-CERTIFIED positive] Is there one sound opponent-complete rewrite
  on the q17 repair orbit and q19 control?** Yes: rank zero `B_cc`, plus one
  direct exchange into it for four q19 fibres.
- **[SETTLED] Does this rewrite query minimax?** No. Exact minimax is used
  only as an independent cross-check.
- **[OPEN — C80] Can the four q19 rank-one fibres be certified by a bounded
  algebraic incidence datum rather than explicit pairings/reply lists?**
- **[OPEN — C80] Are boundary deficiency and witness size uniformly bounded
  on the intended escape family?** No such bound is proved; the q17-to-q19
  increase is adverse evidence.
- **[OPEN — C80/C82 gate] Can the sound finite correspondence be projected
  to bounded-degree geometric fibres before abundance counting?**

## Vibe

The small-locus question is genuinely solved, and the first common q17/q19
sound correspondence now exists. The obstruction has moved from value
purity to algebraic compression—real progress, with the release gate still
honest.

go C80 cap compress the four q19 rank-one boundary fibres into a direct algebraic incidence certificate
