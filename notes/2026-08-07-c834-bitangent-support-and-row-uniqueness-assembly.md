# C834 — the bitangent support lemma and the structural row-uniqueness assembly

**Date:** 2026-08-07 · **Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure)

## What landed

Stage 5 item 10 is now closed structurally. `admissible_seven_set_is_geometric_row` no longer
consumes an indexed passant-clique search; it is proved from the Gram relation of four internal
points, the discriminant law, and a bitangent-conic construction. The seven residue shards, the
index certificate, and the pair transporter are deleted.

Three new modules under `papers/q13-passant-code/lean-certificates`, and one rewritten:

### `PassantCodeQ13/MinimumWords/RowUniqueness/BitangentSupport.lean`

For a dual coordinate triple `L` and a field element `nu`, `bitangentPoints L nu` is the list of
normalized representatives on the conic `C - nu L^2` and off the chord `L`. Two facts are proved
about it.

Every such point is internal when `nu` is a nonzero nonsquare, because its conic value is
`nu` times a nonzero square. And when the pair is *admissible* — `L` a secant, `nu` a nonzero
nonsquare, and `nu * lineDiscriminant L - 1` a nonzero nonsquare — the encoded point set is one of
the `364` displayed minimum-weight supports. That last statement is the finite content of the
module: an exhaustion over the `183` normalized dual triples and the `13` field elements, where the
guard selects the `273` admissible pairs and the encoded support is computed and looked up in
`minimumWordSupports`. It is discharged by `decide +kernel` in a single declaration.

The construction is stated for an arbitrary dual triple, and the general statement reduces to the
finite check over normalized representatives by the rescaling `(L, nu) ↦ (s L, s⁻² nu)`, under which
both the point set and the admissibility test are invariant.

The terminal is `exists_semanticMinimumSupport_of_bitangent`: an admissible pair exhibits a member
of the decoded minimum-word family containing every internal point of its bitangent conic.

### `PassantCodeQ13/MinimumWords/RowUniqueness/BitangentWitness.lean`

This module derives the chord from the trace pattern, which the earlier evidence bundle had only
verified numerically. Three normalized lifts with traces `a`, `b`, `c` have trace Gram matrix `M`
with diagonal `2` and off-diagonal `-a, -b, -c`; its determinant is `2 D` with
`D = 4 - (a²+b²+c²) - abc` and its adjugate row sums are `poleCoefficient₁₂₃`, summing to
`cofactorSum`. The vector `bitangentPole` formed from the lifts with those coefficients satisfies
`B(w, uᵢ) = -2 D` for each lift, by the adjugate identity, and hence `B(w,w) = -2 D · cofactorSum`.

`polarDual` identifies a vector with the linear form it represents: `lineValue (polarDual w) p` is
the normalized trace of the pair, and `lineDiscriminant (polarDual w) = pointDiscriminant w`. So the
chord and its dual-conic value are polynomials in the three traces, and the scalar is
`bitangentScalar D = 11 * ((-2 D)²)⁻¹`, which is a nonsquare because `11` is and `(-2D)²` is a
square. Three nonsquare conditions then reduce to two, and they are exactly the two nonsquare tests
of `QuadrupleGram.bitangentWitness`, once `chordInvariant` is identified as a quarter of
`cofactorSum`. The field arithmetic behind those reductions is one exhaustion over pairs of elements
of `ZMod 13`.

The residue dictionary is completed here: `mul13_val`, `sub13_val`, `neg13_val`, `tripleGram_val`,
`chordDiscriminant_val` and `mul13_four_val` carry each modular operation on residues to the
corresponding field operation on the elements they name.

Two terminals. `exists_semanticMinimumSupport_of_bitangentWitness` says that a trace pattern
satisfying `bitangentWitness` exhibits a member of the decoded family containing all three points.
`tripleAdmissible_of_no_common_support` is its contrapositive in the form the assembly needs: three
internal points lying in no common member of the family satisfy `QuadrupleGram.tripleAdmissible` at
the traces of any normalized lifts. The four sign patterns of `signVariants` are the trace patterns
of the same three points under the four choices of lift signs, so each is excluded by the same
argument applied to a negated lift.

### `PassantCodeQ13/MinimumWords/RowUniqueness/Transport.lean`

The assembly. Choose for each internal point a lift of the fixed conic value. A pair of points of an
admissible seven-set has its normalized trace in `joinTraces`, because the pair is passant-joined; a
triple satisfies `tripleAdmissible`, by the previous module; a quadruple has vanishing four-by-four
trace Gram determinant, because four coordinate triples are dependent. The exhaustion
`admissible_trace_quadruple_has_vanishing_triple_grams` then forces all four triple Gram
determinants to vanish, so every three of the four points are collinear. A seven-set supplies a
fourth point for any of its triples, so every triple of the set is collinear; the set therefore lies
on the unique line through any two of its points, that line is a passant because the two points are
passant-joined, and `passantRow_card` closes the inclusion to an equality.

### `PassantCodeQ13/MinimumWords/RowUniqueness/PassantRowMasks.lean`

The row bit set `passantRowMask` and the increasing point list `passantRowPoints`, which the
semantic transports still consume, extracted from the retired index certificate. No finite search.

### Retired

`IndexCertificate.lean`, `Aggregate.lean`, `PairTransport.lean` and `Residue{Zero..Six}.lean` are
deleted, together with `Base.lean`'s `indexedPassantJoin` and the ten audit lines naming their
terminals. Ten kernel-reduced terminals leave the audit; all ten were clean, so the count of
terminals carrying a declaration-local native-evaluation axiom is unchanged.

## Validation

Both package gates build and the evidence verifier passes. The axiom audit now reports **84
terminals, of which 73 depend only on `propext`, `Classical.choice` and `Quot.sound`** and 11 carry
a declaration-local native-evaluation axiom — the automorphism anchors, the weight-ten profile
shards, and the fixed-point exhaustion, all unchanged by this round.

Replay from the repository root:

```sh
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/BitangentSupport.lean
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/BitangentWitness.lean
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/Transport.lean
lean/scripts/lean-build-queue.py build PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit \
  --lean-root "$PWD/papers/q13-passant-code/lean-certificates" --cores 20-23
cd papers/q13-passant-code && python3 verification/verify_evidence.py
```

Measured. `BitangentSupport` elaborates in forty-eight seconds and builds in fifty-two;
`BitangentWitness` builds in twenty-four seconds at a peak of two gigabytes; `Transport` elaborates
against built dependencies with no finite computation of its own. Against this, the seven retired
residue shards each took about a minute at a peak of 3.6 gigabytes.

## What remains of stage 5 item 10

Nothing. The row-uniqueness layer is closed, and the converse direction is unchanged: it still rests
on `geometric_rows_have_zero_triple_concurrence`, the blockwise kernel check that no displayed
support meets a passant in three points. That check is kernel-reduced and carries no compiled
evaluation, so it is not a trust boundary; it is an enumeration where a structural argument exists
for three quarters of the family and is recorded in the mystery ledger below.

The remaining native decisions of the package are the fourteen weight-ten profile shards, the
automorphism anchors, and the fixed-point exhaustion — stage 5 items 11 to 13 — followed by the
stage 6 release surfaces.

## Mystery ledger

* **Settled: where the chord invariant `F` comes from.** It was introduced as a formula validated
  numerically over the 9100 non-collinear joined triples. It is now derived: `4 F` is the sum of the
  adjugate entries of the trace Gram matrix, and the vector realizing it is the pole of the chord.
  The two nonsquare conditions of the witness are the secant condition on that chord and the
  no-passant-tangent condition on the conic it cuts.
* **Settled: the scalar of the bitangent conic is forced, not chosen.** For a secant of the standard
  conic there are three nonsquares `nu` making `C - nu L^2` carry a minimum-weight support, so a
  chord alone does not name a conic. A *trace pattern* does: normalizing the pole so that the chord
  takes the value `-2 D` at each lift leaves `nu = 11 · ((-2 D)²)⁻¹` with no freedom. The three
  values per secant reappear as the three sign patterns of a collinear-free triple on it, not as a
  choice inside the construction.
* **Settled: the finite check proves the bitangent construction, not just uses it.** The exhaustion
  `bitangentSupportCode_check` establishes in Lean that every admissible pair `(L, nu)` gives a
  displayed minimum-weight support. That is the Lean form of the statement that the 91 secants
  against three nonsquares each reproduce the 273 conic supports, which the evidence bundle of
  2026-08-07 had asserted from Python.
* **Open: no structural proof that a minimum support meets a passant in at most two points.** The
  273 conic supports lie on nondegenerate conics, so they are arcs; the 91 octahedral supports are
  arcs by verification only, and the converse half of row uniqueness consumes the enumerated form
  for all 364. A uniform argument would come from proving directly that a minimum support meets
  every passant in zero or two points. Owner: C834 stage 5 item 13, which owns the fixed-point
  exhaustion that currently supplies the three empty domains.
* **Open: the elliptic parameter `4` for an arbitrary pair of internal points.** Carried forward
  unchanged from the previous round: what is proved is that a passant-joined pair does not realize
  it. Nothing in the row-uniqueness route needs the full six-class dichotomy.
