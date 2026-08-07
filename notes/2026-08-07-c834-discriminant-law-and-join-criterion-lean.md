# C834 — the discriminant law and the passant-join criterion, formalized

**Date:** 2026-08-07 · **Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure)

## What landed

Three new modules in the paper package under `papers/q13-passant-code/lean-certificates`, all
arithmetic over `ZMod 13` and its coordinate triples, none running a search over points, lines, or
supports. They supply the first of the two geometry lemmas that
`notes/2026-08-07-c834-row-uniqueness-structural-proof.md` left for the row-uniqueness replacement,
and all but one hypothesis of the quadruple theorem in
`PassantCodeQ13.MinimumWords.RowUniqueness.QuadrupleGram`.

### `PassantCodeQ13/MinimumWords/RowUniqueness/PolarGram.lean`

The polar form `polarValue P R = 2 P.y R.y - P.x R.z - P.z R.x` has matrix determinant `-2` in the
standard coordinates, so the Gram determinant of three coordinate triples factors through the
determinant of their coordinate matrix. Normalizing by twice the product of the three discriminants
gives `normalizedPolarGram`, and the two readings of it are proved:

| declaration | statement |
|---|---|
| `polarGramDeterminant_eq_neg_two_mul_sq` | `det (polarValue Pᵢ Pⱼ) = -2 · (det V)^2` |
| `normalizedPolarGram_eq_four_sub_invariants` | `D = 4 - (ρ₁₂ + ρ₁₃ + ρ₂₃) - π` for nondegenerate triples |
| `normalizedPolarGram_eq_neg_sq_mul_inv` | `D = (det V)^2 · (-(Δ₁Δ₂Δ₃)⁻¹)`, unconditionally |
| `normalizedPolarGram_eq_zero_iff` | `D = 0 ↔ det V = 0` |
| `isNonzeroSquare_normalizedPolarGram_eq_false` | **the discriminant law:** `D` is never a nonzero square |
| `polarGramDeterminantFour_eq_zero` | the four-by-four polar Gram determinant vanishes for every four triples |

The elliptic parameter `ρ` is the package's existing `polarInvariant`; `π` is the new
`polarTripleInvariant`, the negated product of the three polar values over the product of the three
discriminants. `coordinateDeterminant` is tied to the plane vocabulary by
`dotTriple_joinTriple_eq_coordinateDeterminant`: the join of the first two triples pairs with the
third to the determinant, so its vanishing is collinearity.

The discriminant law is exactly the argument of the structural-proof report. Three independent lifts
span the ambient three-dimensional quadratic space, so the form they carry is the ambient form;
comparing the two expressions for the determinant leaves `(det V)^2` times the inverse of a product
of three nonsquares, and `-1` is a square modulo thirteen, so the result is a nonsquare whenever
`det V ≠ 0`.

The four-point statement is the companion relation the quadruple theorem consumes: four coordinate
triples are dependent, so the four-by-four matrix of their polar values is singular. It is a
polynomial identity in twelve variables and closes by `ring`.

### `PassantCodeQ13/MinimumWords/RowUniqueness/PassantJoinInvariant.lean`

The line through two points meets the conic in the zeros of the binary form it carries, and that
form's discriminant is the dual-conic value of the join:

  `lineDiscriminant (joinTriple P R) = polarValue P R ^ 2 - 4 Δ(P) Δ(R)`.

`hasPassantJoin_iff_lineDiscriminant` turns this into the criterion: two distinct internal points are
joined by a passant exactly when that value is a nonzero nonsquare. Both directions go through
`PassantCodeQ13.PlaneJoin.existsUnique_incident`, the unique normalized representative incident to
two distinct normalized representatives, with the rescaling handled by
`isNonzeroSquare_sq_mul`.

`polarInvariant_of_hasPassantJoin` reads the criterion in the invariant: for a joined pair the
elliptic parameter is `9`, `10` or `12`. The mechanism is that `Δ(P) Δ(R)` is a product of two
nonsquares, hence a nonzero square, so the parameter is a square; requiring the parameter minus four
to be a nonzero nonsquare then leaves those three values. This is the association scheme's
passant-join row proved rather than tabulated, and it excludes the parameter value `4` for a joined
pair — the value that says the join is tangent to the conic.

### `PassantCodeQ13/MinimumWords/RowUniqueness/NormalizedTrace.lean`

`QuadrupleGram` quantifies over natural numbers below thirteen combined by explicit modular
operations, and knows nothing of the plane. This module is the dictionary between it and the
coordinate statements above.

A normalized lift of an internal point is a coordinate representative whose conic value is the fixed
nonsquare `11`; `exists_normalizedLift` produces one for every internal point, since rescaling
multiplies the conic value by a square and the nonsquares form one coset of the squares. Under the
identification of a point off the conic with a trace-zero matrix, the conic value is the negated
determinant, so normalized lifts are the matrices of determinant `2` and the normalized trace of a
pair is `polarValue / 2`.

| declaration | statement |
|---|---|
| `polarInvariant_eq_normalizedTrace_sq` | the elliptic parameter of two lifts is the square of their trace |
| `normalizedPolarGram_eq_trace_expression` | `D = 4 - Σ g² - g₁₂g₁₃g₂₃` for three lifts |
| `cast_add13`, `cast_mul13`, `cast_sub13`, `cast_neg13`, `cast_tripleGram`, `cast_gramDet4` | each modular residue operation casts to its field operation |
| `tripleGram_eq_val_normalizedPolarGram` | the residue Gram of a triple of lifts is the residue of `normalizedPolarGram` |
| `gramDet4_eq_zero` | the residue Gram determinant of a quadruple of lifts vanishes |
| `tripleGram_eq_zero_iff` | it vanishes for a triple exactly when the three lifts are dependent |
| `isNonsquare_tripleGram` | **the discriminant law in residues:** otherwise it is a nonsquare |
| `val_normalizedTrace_mem_joinTraces` | the trace of a passant-joined pair lies in `joinTraces` |

The quadruple statement goes through a general symmetric four-by-four Gram determinant added to
`PolarGram`, presented by its ten distinct entries, together with its scaling law
`symmetricGramDeterminantFour_smul`. The trace matrix is `-7` times the matrix of polar values —
the diagonal `2` is `-7` times the common `polarValue u u = 9` — so the vanishing of the polar Gram
determinant transports to it with no reduction of numerals modulo thirteen. Trying to prove that
step by `ring` directly fails, because `ring` does not know the characteristic; factoring the
scaling out is what avoids the problem.

## Validation

All three modules elaborate without errors or warnings under the pinned toolchain, and every
terminal depends only on `propext`, `Classical.choice` and `Quot.sound`. No terminal carries a
compiled-evaluation axiom; `native_decide` occurs in none of them.

Replay from the repository root:

```sh
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/PolarGram.lean
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/PassantJoinInvariant.lean
lean/scripts/guarded-lean --root "$PWD/papers/q13-passant-code/lean-certificates" \
  PassantCodeQ13/MinimumWords/RowUniqueness/NormalizedTrace.lean
lean/scripts/lean-build-queue.py build \
  PassantCodeQ13.MinimumWords.RowUniqueness.NormalizedTrace \
  --lean-root "$PWD/papers/q13-passant-code/lean-certificates" --cores 20-23
```

Measured: `PolarGram` elaborates in about four seconds and builds in eleven at a peak of 1.8 GB;
`PassantJoinInvariant` elaborates in about four seconds against built dependencies and builds in
twenty-two at the same peak; `NormalizedTrace` elaborates in ten seconds and builds in four. Every
finite check is an exhaustion over the elements of `ZMod 13` or over ordered pairs of them,
discharged by `decide +kernel`; the largest is the two-variable case analysis that pins the three
parameter values.

None of the three is imported by a package gate yet, so the tracked axiom audit and its terminal
count are unchanged. They enter the gate with the semantic bridge that consumes them, which is where
their terminals become paper-facing.

One elaboration note for the next round: a `∀` over three elements of `ZMod 13` followed by six
hypotheses does not get a `Decidable` instance synthesized, while two elements followed by four
hypotheses does. Split a wide finite lemma into two-variable pieces rather than raising a synthesis
limit.

## What this leaves for stage 5 item 10

1. **The bitangent support lemma.** For a secant `L` and a nonsquare `ν` with `ν disc(L) - 1` a
   nonsquare, the twelve points of `C - ν L^2` off the chord are internal and form the support of a
   weight-twelve word. This is the remaining geometry lemma, and unlike the two above it touches the
   minimum-word family.
2. **The rest of the semantic bridge.** `NormalizedTrace` supplies every hypothesis of
   `admissible_trace_quadruple_has_vanishing_triple_grams` except the one that says no bitangent
   conic through the triple is a minimum-word support, which is what the bitangent support lemma
   will give. What is then left is the assembly in `RowUniqueness/Transport.lean`: from a seven-set
   of pairwise-joined internal points with zero triple concurrence, choose normalized lifts, apply
   the quadruple theorem to every four-subset, conclude that all of them are collinear, and identify
   the resulting line as the passant carrying the seven points.
3. **Retirement** of `IndexCertificate` and the seven residue modules once
   `RowUniqueness/Transport.lean` reaches `admissible_seven_set_is_geometric_row` through the new
   route.

## Mystery ledger

* **Settled: why the elliptic parameter omits `4`.** The structural-proof report recorded this as
  cheap to add alongside the criterion, and it is now a consequence of it rather than a separate
  observation: `polarInvariant_of_hasPassantJoin` leaves a joined pair only the values `9`, `10` and
  `12`. The parameter value `4` is precisely a vanishing discriminant of the restricted binary form,
  that is, a tangent join, and a tangent carries no two internal points that the criterion applies to.
* **Open: the parameter value `4` for an arbitrary pair of internal points.** What is proved is that
  a *joined* pair does not realize it. That no pair of internal points at all has parameter `4` — the
  statement that no tangent of the conic carries two internal points — is not formalized, and nothing
  in the row-uniqueness route needs it. Owner: C834, if a later leaf wants the full six-class
  dichotomy rather than the passant half.
* **No mystery in the discriminant law itself.** The two expressions for the Gram determinant are
  polynomial identities and the character count is forced; nothing about the outcome was open once
  the factorization was written down.
