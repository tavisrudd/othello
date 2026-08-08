# The face-axis zonal Gram matrix in Lean

**Lane:** `clebsch`
**Date:** 2026-08-07

One new Lean module closes the Gram half of the degree-six harmonic
realization:

- `lean/RelativeConicArcs/FaceAxisHarmonicGram.lean` (new)
- `lean/RelativeConicArcs/SphericalMomentFunctional.lean` (edited: one extra
  fine-grained import and two `normalizedMean` linearity lemmas)

No other Lean file is touched, nothing is added to a gate, and no manuscript
source is changed. Every declaration below is in the namespace
`RelativeConicArcs.FaceAxisHarmonicGram` unless stated otherwise.

## Edit to `SphericalMomentFunctional`

`normalizedMean d p` is `gaussianMoment p / momentFactor (d + 2)`, so linearity
is immediate, but the module had no statement of it and the new module needs it
twice (to expand a combination of ten zonal forms, and to pull out a scalar
coefficient). Added:

- `RelativeConicArcs.SphericalMomentFunctional.normalizedMean_sum`:
  `normalizedMean d (∑ i ∈ s, f i) = ∑ i ∈ s, normalizedMean d (f i)`, for any
  index type and finite index set.
- `RelativeConicArcs.SphericalMomentFunctional.normalizedMean_C_mul`:
  `normalizedMean d (C c * p) = c * normalizedMean d p`.

`Finset.sum_div` is not reachable from that module's fine-grained imports, so
`import Mathlib.Algebra.BigOperators.Field` was added. The module header's list
of main results gained one line naming the two lemmas.

The reverse-import closure of `SphericalMomentFunctional` inside the repository
is `ZonalHarmonicDegreeSix` alone; no gate module imports either, so the edit
widens validation only to the new module's own build.

## Definitions and why they are shaped that way

- `sqrt_five_mul_self : Real.sqrt 5 * Real.sqrt 5 = 5`. The hypothesis shape
  required by `IcosahedralFaceAxes.doubledFaceAxisOver`, which is stated over an
  arbitrary commutative ring carrying a square root of five.
- `doubledFaceAxisReal (p : Pair 5) (i : Fin 3) : ℝ`. The labelled face axes over
  the reals in the doubled integral coordinates, with the nonnegative square root
  chosen. Naming the specialization once keeps every later statement free of the
  `hs` proof argument.
- `unitFaceAxis (p : Pair 5) (i : Fin 3) : ℝ := doubledFaceAxisReal p i /
  (2 * Real.sqrt 3)`. The doubled coordinates have squared length `12` and
  `(2 * Real.sqrt 3) ^ 2 = 12`, so this is the unit representative. The zonal
  addition theorem requires unit axes, which is the only reason for the rescaling.
- `faceAxisZonalForm (p : Pair 5) : MvPolynomial (Fin 3) ℝ :=
  zonalHarmonic (unitFaceAxis p)`. An abbreviation for the object the whole module
  is about; it also keeps the theorem names readable.
- `zonalGramEntry (p q : Pair 5) : ℝ :=
  (196 * (if p = q then 1 else 0) + 47
    - 112 * (if Disjoint p.vertices q.vertices then 1 else 0)) / 3159`.
  This is the manuscript's `G = K/13` written as one closed formula, with
  `3159 = 243 * 13`. The disjointness predicate is spelled exactly as in
  `KneserPairEigenspace.adjacency`, so the Gram-operator proof can collapse the
  sum against that definition by `rfl` rather than by a transport lemma. Note
  that `Disjoint p.vertices q.vertices` already excludes `p = q`, so the three
  cases of the matrix are the three cases of the two `if`s.
- `zonalCombination (x : Pair 5 → ℝ) : MvPolynomial (Fin 3) ℝ :=
  ∑ p, C (x p) * faceAxisZonalForm p`. The image of a coefficient vector.
- `stabilizerFixedVertexWeight : Fin 5 → ℝ := ![4, -1, -1, -1, -1]`. The marked
  vertex weight of the manuscript, named for the property visible in its values:
  total weight zero, constant on the last four labels.

## Theorems

Fully qualified names, all in `RelativeConicArcs.FaceAxisHarmonicGram`.

1. `sum_unitFaceAxis_sq (p : Pair 5) : ∑ i, unitFaceAxis p i ^ 2 = 1`.
2. `sum_unitFaceAxis_mul_sq (p q : Pair 5) (hpq : p ≠ q) :
   (∑ i, unitFaceAxis p i * unitFaceAxis q i) ^ 2 =
     if Disjoint p.vertices q.vertices then 5 / 9 else 1 / 9`.
3. `normalizedMean_faceAxisZonalForm_mul (p q : Pair 5) :
   normalizedMean 12 (faceAxisZonalForm p * faceAxisZonalForm q) = zonalGramEntry p q`.
   The three entries are stated separately as
   `normalizedMean_faceAxisZonalForm_mul_self` (`= 1 / 13`),
   `normalizedMean_faceAxisZonalForm_mul_of_disjoint` (`= -65 / 3159`) and
   `normalizedMean_faceAxisZonalForm_mul_of_not_disjoint` (`= 47 / 3159`).
4. `normalizedMean_faceAxisZonalForm_mul_zonalCombination (x : Pair 5 → ℝ) (p : Pair 5) :
   normalizedMean 12 (faceAxisZonalForm p * zonalCombination x)
     = (196 * x p + 47 * totalPairSum x - 112 * adjacency x p) / 3159`.
5. `normalizedMean_faceAxisZonalForm_mul_zonalCombination_const (c : ℝ) (p : Pair 5) :
   normalizedMean 12 (faceAxisZonalForm p * zonalCombination (fun _ => c))
     = 110 / 1053 * c`.
6. `normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_petersenEigen
   {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x) (p : Pair 5) :
   normalizedMean 12 (faceAxisZonalForm p * zonalCombination x) = 140 / 1053 * x p`.
7. `normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_adjacency_eq_self
   {x : Pair 5 → ℝ} (htot : totalPairSum x = 0) (hadj : ∀ p, adjacency x p = x p)
   (p : Pair 5) :
   normalizedMean 12 (faceAxisZonalForm p * zonalCombination x) = 28 / 1053 * x p`.
8. `normalizedMean_zonalCombination_mul_self_of_petersenEigen
   {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x) :
   normalizedMean 12 (zonalCombination x * zonalCombination x)
     = 140 / 1053 * ∑ p, x p ^ 2`.
9. `eq_zero_of_zonalCombination_eq_zero_of_petersenEigen
   {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x)
   (hzero : zonalCombination x = 0) : x = 0`.
10. `zonalCombination_injective_of_petersenEigen {x z : Pair 5 → ℝ}
    (hx : IsPetersenNegTwoEigenvector x) (hz : IsPetersenNegTwoEigenvector z)
    (h : zonalCombination x = zonalCombination z) : x = z`.
11. `sum_pairSum_sq {y : Fin 5 → ℝ} (hy : ∑ i, y i = 0) :
    ∑ p : Pair 5, pairSum y p ^ 2 = 3 * ∑ i, y i ^ 2`.
12. `normalizedMean_zonalCombination_pairSum_mul_self {y : Fin 5 → ℝ} (hy : ∑ i, y i = 0) :
    normalizedMean 12 (zonalCombination (pairSum y) * zonalCombination (pairSum y))
      = 140 / 351 * ∑ i, y i ^ 2`.
13. `normalizedMean_zonalCombination_stabilizerFixedVertexWeight :
    normalizedMean 12 (zonalCombination (pairSum stabilizerFixedVertexWeight)
        * zonalCombination (pairSum stabilizerFixedVertexWeight)) = 2800 / 351`.

## Spec coverage

| spec item | status |
|---|---|
| 1 unit length                       | closed, theorem 1  |
| 2 squared inner products            | closed, theorem 2  |
| 3 three Gram entries                | closed, theorem 3 and its three corollaries |
| 4 matrix form `G = K/13`            | closed, `zonalGramEntry` and theorem 3 |
| 5 Gram operator                     | closed, theorem 4  |
| 6 three eigenvalues                 | closed, theorems 5, 6, 7 |
| 7 injectivity on the `(-2)`-space   | closed, theorems 8, 9, 10 |
| 8 quadratic identity and its value  | closed, theorems 11, 12, 13 |

## Deviations from the spec

- The spec's `gramEntry` is named `zonalGramEntry` and is given the explicit
  closed formula of spec item 4 rather than being left as an opaque value, so
  that item 3 and item 4 are one definition and one theorem instead of two
  parallel statements. The three entry values are still available separately.
- Spec item 6 states the eigenvalue on the all-ones vector; the Lean statement is
  for an arbitrary constant vector `fun _ => c`, which is the eigenvector equation
  on the whole `3`-eigenspace and specializes to the all-ones vector at `c = 1`.
- Theorem 10 (injectivity for two eigenvectors) is not in the spec; it is three
  lines given theorem 9 and the linearity of `adjacency` and `zonalCombination`,
  and it is the form the manuscript's "injective copy" sentence asserts.

## Validation

All commands run from the repository root.

1. `lean/scripts/guarded-lean RelativeConicArcs/SphericalMomentFunctional.lean`
   — first run failed with `Unknown constant Finset.sum_div`; after adding
   `import Mathlib.Algebra.BigOperators.Field` it returned `exit=0` with an empty
   stdout log (no errors, no warnings).
2. `lean/scripts/lean-build-queue.py build RelativeConicArcs.ZonalHarmonicDegreeSix
   RelativeConicArcs.IcosahedralFaceAxes --cores 20-23` — needed to refresh the
   dependency artifacts before single-file elaboration of the new module
   (`IcosahedralFaceAxes` had never been compiled). This was `refused` five times
   over roughly twenty-five minutes because a foreign Lean build held the shared
   tree; the sixth attempt returned `state: success`, with
   `RelativeConicArcs.ZonalHarmonicDegreeSix` at 14.8 s and
   `RelativeConicArcs.IcosahedralFaceAxes` at 2 min 32 s, and a passing aggregate
   gate. The quiet wait was never raised.
3. `lean/scripts/guarded-lean RelativeConicArcs/FaceAxisHarmonicGram.lean` — one
   failing round, two unsolved goals in the last theorem where `norm_num` did not
   evaluate `![4, -1, -1, -1, -1]` at the indices `2`, `3`, `4` (the matching
   `Matrix.cons_val_two`, `cons_val_three`, `cons_val_four` are not simp lemmas);
   replaced by five `rfl` equations for the five entries. The next run returned
   `exit=0` with an empty stdout log: no errors and no warnings.
4. `lean/scripts/lean-build-queue.py build RelativeConicArcs.FaceAxisHarmonicGram
   --cores 20-23` — `state: success`, `built RelativeConicArcs.FaceAxisHarmonicGram`
   in 26.7 s wall, 3.4 GB peak, aggregate gate passed.

The module contains no `sorry`, no `native_decide` and no axiom declaration. It
contains exactly one `decide`, on `Fintype.card (Pair 5) = 10`; every other finite
check it relies on is discharged inside `RelativeConicArcs.IcosahedralFaceAxes`.

## Review-gate pass

The whole new module was read, not only the parts written last. No task
identifier, lane name, agent or session reference, internal path, status prose,
`TODO`, or novelty language appears in either touched file. The module header
states the trust boundary: `normalizedMean` is the explicitly defined functional
of `RelativeConicArcs.SphericalMomentFunctional`, its identification with the
normalized surface integral over the unit two-sphere is not formalized anywhere
in the closure, and no theorem in the module is a statement about an integral.
An earlier draft of the header claimed that nothing in the verification closure
imports measure theory; that is false, since `KneserPairEigenspace` imports all
of Mathlib, and the sentence was replaced by the accurate claim that no measure,
integral or analytic hypothesis occurs in any statement or proof here.

## Amendment after review

The trust-boundary paragraph of the module header was sharpened once more. It had
said that no analytic hypothesis occurs in any statement or proof, which is true
but leaves the two square roots unaccounted for: the configuration is realized
over the reals through the nonnegative square root of five, and an axis is
rescaled to unit length by the nonnegative square root of three. The paragraph
now says that no measure, no integral and no limit occurs, and names those two
square roots as the only ingredient that is not algebraic.

The module was re-elaborated after that edit —
`lean/scripts/guarded-lean RelativeConicArcs/FaceAxisHarmonicGram.lean`, `exit=0`
with an empty log — and rebuilt through the queue,
`lean/scripts/lean-build-queue.py build RelativeConicArcs.FaceAxisHarmonicGram --cores 20-23`,
reporting `state: success` with the aggregate gate passed, in run directory
`~/.cache/othello-lean-build/run-20260808-043949-19c69d69`.
