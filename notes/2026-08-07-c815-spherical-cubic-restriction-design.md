# Design of the spherical cubic restriction module

**Lane:** `clebsch`
**Date:** 2026-08-07
**Task:** C815, row HARM-2 of
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`

This is a design pass, written before any Lean is added. It fixes the mechanism,
the statement shapes, the exact constants, and the two places where the work can
go wrong. No Lean file is touched by it.

## What the module closes

Row HARM-2 excludes the invariant-line input for the geometric spherical cubic
and the raw spherical moment. One module,
`RelativeConicArcs.SphericalCubicRestriction`, closes both. Its main statement,
over the reals and in the notation of `RelativeConicArcs.FaceAxisHarmonicGram`:

```
theorem normalizedMean_zonalCombination_pairSum_cube {y : Fin 5 → ℝ}
    (hy : ∑ i, y i = 0) :
    normalizedMean 18 (zonalCombination (pairSum y) * zonalCombination (pairSum y)
        * zonalCombination (pairSum y))
      = (-784000 / 1247103) * ((1 / 3) * ∑ i, y i ^ 3)
```

with the marked corollary at `stabilizerFixedVertexWeight` equal to
`-15680000 / 1247103`, and a rational corollary phrased against
`RelativeConicArcs.ClebschInvariantCubic.sigmaThree` so that the hypothesis
`LiesOnSigmaThreeLine` of that module and the marked value it assumes are both
discharged. `ClebschInvariantCubic` is over `ℚ` and is imported by the passages
gate; it is not edited. The bridge goes the other way: the new module states its
theorem over `ℝ` and derives the `ℚ`-shaped corollary by casting a rational
weight vector, so no gate-attached file changes.

After this module the only item left in the two harmonic rows is the
identification of `normalizedMean` with the normalized surface integral, which
has its own module and is the declared trust boundary.

## Route, and why not the direct one

The scope note `notes/2026-08-07-c815-harmonic-realization-scope.md` proposed
proving the cubic identity directly in symbolic `y`, because the certificate
establishes it that way. Costed out in Lean, that route is the expensive one.
Expanding the cube of a general field means either the triple moments
`M(Z_p Z_q Z_r)` for the thousand label triples — each a degree-eighteen
evaluation, and no apolarity clause reaches a degree-twelve second factor, so a
general triple-zonal formula would have to be developed first — or expanding a
twenty-eight-term degree-six polynomial with weight-linear coefficients into its
cube, which is tens of thousands of products before collection.

The manuscript's own route costs one group-theoretic step and a single numeric
evaluation, and the numeric evaluation is small because the marked weight is
stabilized by the tetrahedral rotations. That is the route taken here. The
symbolic-in-`y` certificate remains the independent evidence for the identity;
the Lean proof does not have to mirror its shape.

The structure constants are never computed. Only the cubic form's behaviour
under the label action, and its value at one weight vector, are needed.

## The mechanism

Write `F y := zonalCombination (pairSum y)` for the harmonic field of a weight
vector, and `B y z w := normalizedMean 18 (F y * F z * F w)`.

**Trilinearity.** `pairSum`, `zonalCombination` and `normalizedMean` are linear
and multiplication is bilinear, so `B` is symmetric and trilinear. With
`C i j k := B (e i) (e j) (e k)` for the coordinate vectors, expanding
`y = ∑ i, y i • e i` gives `B y y y = ∑ i, ∑ j, ∑ k, y i * y j * y k * C i j k`.
This is the only role the structure constants play: they are named, never
evaluated.

**Rotation transport.** `IcosahedralFaceAxes` supplies three matrices over `ℤ√5`,
scaled by four, with `scaledRotation_rows_orthogonal`, `scaledRotation_det` and
`scaledRotationApply_doubledFaceAxis`. The new module needs their real forms:
`rotationReal r i j := goldenCast (Real.sqrt 5) sqrt_five_mul_self (scaledRotation r i j) / 4`,
orthogonal by the rows lemma, and
`unitFaceAxis (labelPermutation r ⬝ p) = ± rotationReal r` applied to
`unitFaceAxis p`, by transporting the axis lemma along `goldenCast` and dividing
by the common length. The sign is unavoidable and harmless: the zonal form uses
only even powers of its axis, so `zonalHarmonic (-u) = zonalHarmonic u` is one
`ring` step from the definition.

**Zonal covariance.** `zonalHarmonic u` is built from `linearForm u` and
`quadric`. A linear substitution fixes `quadric` when the matrix is orthogonal
and sends `linearForm u` to the linear form of the transported axis, so
`linearSubstitution M (zonalHarmonic u) = zonalHarmonic (M ᵀ ⬝ u)` in the
orientation the writer settles from `linearSubstitution_X`.

**Invariance.** `pairSum_comp` in `RelativeConicArcs.AlternatingComparisonLine`
already gives `pairSum (y ∘ σ) p = pairSum y (pairMap σ p)`. Combining it with
covariance, `F (y ∘ σ_r) = linearSubstitution (rotationReal r) (F y)`. Since
`linearSubstitution` is an algebra homomorphism it passes through the triple
product, and `gaussianMoment_linearSubstitution` then gives
`B (y ∘ σ_r) (z ∘ σ_r) (w ∘ σ_r) = B y z w`, hence
`C (σ_r i) (σ_r j) (σ_r k) = C i j k` on evaluating at coordinate vectors.

**Coefficient orbits.** A degree-three monomial in five labels leaves two labels
unused, so any permutation matching two index triples of the same pattern can be
corrected to an even one by the transposition of two unused labels: the even
permutations already identify all index triples of a pattern. Three patterns
remain — all indices equal, exactly two equal, all distinct — so
`C i j k` takes at most three values `a`, `b`, `c`, and

```
B y y y = a * ∑ i, y i ^ 3 + b * ∑ i, ∑ j ≠ i, y i ^ 2 * y j
            + c * ∑ i < j < k, y i * y j * y k .
```

**Sum-zero collapse.** With `∑ y i = 0` the second sum is `-∑ y i ^ 3` and the
third is `(∑ y i ^ 3) / 3`, so `B y y y = (a - b + c / 3) * ∑ y i ^ 3`; the
identity holds with an unknown scalar, and one value fixes it.

## The marked evaluation

The marked weight `stabilizerFixedVertexWeight = ![4,-1,-1,-1,-1]` puts `3` on
the four axes containing label `0` and `-2` on the other six. In the frame of
`IcosahedralFaceAxes` those four axes are the cube diagonals `(±2,±2,±2)`, so
the tetrahedral rotations fixing label `0` act, and the marked field is a
polynomial in the squared coordinates alone.

**Clearing both square roots.** A zonal form written in doubled coordinates has
no square roots at all. With `T := linearForm (doubledFaceAxisReal p) ^ 2` and
`Q := quadric`,

```
zonalHarmonic (unitFaceAxis p)
  = C (1 / 27648) * (231 * T ^ 3 - 3780 * T ^ 2 * Q + 15120 * T * Q ^ 2 - 8640 * Q ^ 3),
```

because `27648 = 16 * 12 ^ 3` and the doubled axes have squared length twelve.
Proving this once removes `Real.sqrt 3` from every later step; only the `√5` in
the axis coordinates survives.

**The marked field.** Writing `u, v, w` for `X 0 ^ 2, X 1 ^ 2, X 2 ^ 2`, summing
the ten zonal forms against the marked coefficients gives

```
F = (35/12) (u³ + v³ + w³) + (525/2) u v w
      + (-175/8 + 385√5/24) (u²v + v²w + w²u)
      + (-175/8 - 385√5/24) (u v² + v w² + w u²).
```

**The split that isolates the irrationality.** Set

```
Hodd  := (u v² + v w² + w u²) - (u²v + v²w + w²u),
Heven := (u³ + v³ + w³) - (15/2) (u²v + v²w + w²u + u v² + v w² + w u²) + 90 u v w.
```

Both are harmonic. The coordinate transposition `X 0 ↔ X 1` negates `Hodd` and
fixes `Heven`, and it is an orthogonal substitution, so `gaussianMoment` is
invariant under it. Then

```
F = a * Hodd + b * Heven,   a = -385√5/24,   b = 35/12,
```

and the golden part of the marked field is exactly its transposition-odd
component. Every term of the cube carrying an odd power of `Hodd` has vanishing
moment by that transposition, which both explains why the answer is rational and
removes two of the four expansions:

```
M(Hodd³) = 0,           M(Hodd · Heven²) = 0,
M(Hodd² · Heven) = -1024/969969,   M(Heven³) = -1280/46189,
M(F³) = 3 a² b · (-1024/969969) + b³ · (-1280/46189) = -15680000/1247103,
```

with `a² = 741125/576` rational. The same split reproduces the landed quadratic
value: `M(Hodd²) = 32/15015`, `M(Hodd · Heven) = 0`, `M(Heven²) = 8/13`, and
`a² · 32/15015 + b² · 8/13 = 2800/351`, which is the value proved in the Gram
module. That agreement is a free consistency check on the split before any cubic
expansion is attempted.

One arithmetic remark worth a docstring line: `46189 = 11 · 13 · 17 · 19`, the
manuscript's universal degree-six denominator, appears here as the denominator of
the moment of the cube of the symmetric tetrahedral harmonic, and
`1247103 = 27 · 46189`.

So the whole computational content of the marked value is two degree-eighteen
moments of explicit polynomials with small integer coefficients — `Hodd` has six
terms, `Heven` has ten — plus two vanishing statements that are proved by a
symmetry rather than by expansion.

## The label combinatorics, concretely

The coefficient-orbit step needs, for each pair of index triples of the same
pattern, one even permutation carrying the first to the second and realized by
the rotations. Two ways to supply it.

**Recommended: words, no group theory.** The three induced label permutations
are `g0 = (1 4)(2 3)`, `g1 = (2 4 3)` and `g2 = (0 1)(2 4)` on `Fin 5`. The
subgroup `⟨g0, g1⟩` fixes label `0`, has order twelve, and is sharply
two-transitive on the other four labels; adding `g2` gives a transitive group.
Transitive with a two-transitive point stabilizer is three-transitive, which
covers all three patterns. The words needed, read left to right as composition:

| carries | word |
|---|---|
| `0 ↦ 1` | `g2` |
| `0 ↦ 2` | `g2 g0 g2` |
| `0 ↦ 3` | `g1 g0 g2` |
| `0 ↦ 4` | `g0 g2` |
| `(1,2) ↦ (1,3)` | `g1 g1` |
| `(1,2) ↦ (1,4)` | `g1` |
| `(1,2) ↦ (2,1)` | `g1 g1 g0 g1` |
| `(1,2) ↦ (2,3)` | `g0 g1 g0` |
| `(1,2) ↦ (2,4)` | `g1 g1 g0` |
| `(1,2) ↦ (3,1)` | `g1 g0 g1` |
| `(1,2) ↦ (3,2)` | `g1 g0` |
| `(1,2) ↦ (3,4)` | `g1 g0 g1 g1` |
| `(1,2) ↦ (4,1)` | `g0 g1` |
| `(1,2) ↦ (4,2)` | `g0 g1 g1` |
| `(1,2) ↦ (4,3)` | `g0` |

Each row is checked by `decide` on `Fin 5` functions, and invariance under a word
is the composition of the three generator invariances. No `Subgroup`, no
`alternatingGroup`, no closure computation appears.

**Alternative: the abstract subgroup.** Prove
`Subgroup.closure {g0, g1, g2} = alternatingGroup (Fin 5)` and then reuse
`AlternatingComparisonLine.exists_even_perm_apply_eq`, which is the landed
two-transitivity of the alternating group, together with a three-point analogue
proved by its swap-and-correct pattern. This reads better but the closure
equality is the hard part: a kernel `decide` over iterated Finset images of
permutations is the only cheap proof and may not elaborate in reasonable time.
Fall back to it only if the word tables prove unwieldy.

The generated group is the alternating group — order sixty, all even — which the
tracked certificate `notes/2026-08-07-c815-harmonic-realization-checks.json`
already records; the word route does not need that fact, and the abstract route
needs it in Lean rather than in a certificate.

## Conventions and boundaries

- The cubic is `σ₃(y) = (1/3) ∑ y i ^ 3`, the convention already fixed by
  `ClebschInvariantCubic.sigmaThree`; the module states the agreement with the
  third elementary symmetric function on the sum-zero module where it needs it,
  as the scope note requires.
- The module header must say that `normalizedMean` is the explicitly defined
  functional of `RelativeConicArcs.SphericalMomentFunctional`, that its
  identification with the normalized surface integral is not formalized, and that
  no theorem here is a statement about an integral. The two square roots — of
  five, in the axis coordinates, and of three, in the unit rescaling, which the
  doubled-coordinate lemma removes from every later step — are the only
  non-algebraic ingredients.
- Files touched: one new module. `FaceAxisHarmonicGram`,
  `ZonalHarmonicDegreeSix`, `SphericalMomentFunctional`, `IcosahedralFaceAxes`
  and `AlternatingComparisonLine` are imported, not edited; `ClebschInvariantCubic`
  and `PetersenHarmonicKernel` are gate-attached and stay untouched. Like the
  other five harmonic modules, the new one goes on a gate when the harmonic rows
  close, not before.

## Risks, and the order to attack them

1. **The two degree-eighteen expansions.** This is the first place in the
   harmonic stack where a moment is computed by expanding monomials rather than
   by apolarity; `Hodd² · Heven` collects to forty-six monomials and `Heven³` to
   fifty-five. Prototype `M(Heven³)` first, in isolation, before writing anything
   else: if `ring_nf` on `MvPolynomial (Fin 3) ℝ` handles it, everything else in
   the module is easier. If it does not, the fallback is a small helper that
   evaluates moments of polynomials in the squared coordinates, halving the
   degree that has to be normalized.
2. **The coefficient orbits.** Mechanical but bulky. The tables above are the
   whole content; the risk is only that the composition bookkeeping for words is
   fiddlier than expected, in which case the abstract subgroup route is the
   fallback.
3. **Nothing else is load-bearing.** Rotation transport, zonal covariance and the
   sum-zero collapse are each a handful of lines on landed API.

## Certificate

`notes/2026-08-07-c815-spherical-cubic-design-checks.py` computes, in exact
arithmetic over `Q(√5)`, every constant this design commits to: the doubled-axis
geometry, the vanishing Laplacians of the doubled-coordinate zonal forms, the
monomial form of the marked field and that all its exponents are even, the split
`F = a·Hodd + b·Heven` with the two stated scalars, the transposition parity of
the two harmonics, the four cubic moments and the three quadratic ones, the
recombination against both the manuscript's cubic value and the Gram module's
quadratic value, the agreement of the recombination with a direct evaluation of
`M(F³)`, and the group orders and word tables above. Replay from the repository
root:

```sh
uv run --with sympy python3 notes/2026-08-07-c815-spherical-cubic-design-checks.py \
  --check notes/2026-08-07-c815-spherical-cubic-design-checks.json
```

| artifact | bytes | sha256 |
|---|---|---|
| `notes/2026-08-07-c815-spherical-cubic-design-checks.py`   | 10377 | `1f0c02ab9b7e2d8963f99ce4f9c2cf3f2cd62db1ff1a0ac5088a9f6e51610c5e` |
| `notes/2026-08-07-c815-spherical-cubic-design-checks.json` |  1964 | `e52bde66c0e21039a684023490257f4313ad7a75e1cdc8289a574aee0ba4b4f3` |

The independent check inside this bundle is that the recombination through the
split and the direct evaluation of the cube agree, and that the same split
reproduces the quadratic value that Lean already proves by a different route
through the Petersen eigenspace. The wider identity for arbitrary sum-zero
weights is certified separately by
`notes/2026-08-07-c815-harmonic-realization-checks.py`, which this design does
not modify.
