# Two-uniform rigidity: Lean formalization

**Lane**: `ame-lu`
**Date**: 2026-08-02
**Status**: IN PROGRESS

Formalizes the adopted `sec:two-uniform` subsection of
`papers/ame_lu/sections/03-lu-rigidity.tex` ("Discreteness and quantitative
stability") so the formal layer matches the manuscript.

## Setting fixed in Lean

The manuscript works with an arbitrary party count `n` and arbitrary local
dimension `q >= 2`; the existing `RelativeConicArcs.AMELU` modules are pinned to
six parties over a finite field.  The new material therefore lives in a nested
namespace `RelativeConicArcs.AMELU.Multipartite` with its own setting: a finite
site type `Site`, a finite local alphabet `Level` with `q = Fintype.card Level`,
computational-basis labels `Site -> Level`, states as complex amplitude
functions on labels, and operators as complex matrices indexed by labels
(`SystemOperator`) or by the alphabet (`LocalOperator`).  Row = output, column =
input, matching `AMELU.Definitions`.

Everything is proved structurally.  No `decide`, `native_decide`, generated
data, external certificate, or finite case enumeration appears anywhere in the
new modules.

## Modules

All under `lean/RelativeConicArcs/AMELU/`.

| Module | Content |
|---|---|
| `SiteOperators.lean` | `siteOperator j A` (local operator at one site), its algebra-embedding laws (`siteOperator_one/_add/_smul/_mul/_conjTranspose`), the bundled `siteAlgHom j`, the two-site entry formula, and commutation of operators at distinct sites |
| `TwoUniformIsometry.lean` | `stateInner`, `expectation`, `IsTwoUniform`, `localGeneratorSum`, the polarized second-moment identity, its norm form, and injectivity of the isometry |
| `ProductUnitaryExponential.lean` | `tensorOperator`, site-by-site multiplicativity, product operator as an ordered product of single-site operators, `exp_siteOperator`, and the single-exponential identity `tensorOperator_exp` |
| `LocalGeneratorDecomposition.lean` | `tracelessPart`, its tracelessness and hermiticity, and the splitting `Sum_j H_j^(j) = M + c I` with `M` traceless-local |
| `TwoUniformDiscreteness.lean` | the derivative-at-the-identity argument: a one-parameter group `exp(t (i (M + cI)))` fixing the ray of a 2-uniform state forces every traceless local generator to vanish |
| `TwoUniformProductSymmetry.lean` | the same conclusion stated directly for product unitaries `⊗_j exp(i t H_j)` with arbitrary Hermitian local generators |
| `ApproximateSymmetryDecomposition.lean` | `defectSq`, `IsRaySymmetry`, invariance of the defect under an exact ray symmetry on either side, and the hypothesis-explicit `ApproximateDecompositionInputs` with terminal `approximate_decomposition` |

Gates: `lean/RelativeConicArcs/Gates/AMELUTwoUniformRigidity.lean` (import
gate) and `.../AMELUTwoUniformRigidityAxioms.lean` (axiom audit).

## What is proved, item by item against the manuscript

**Traceless/scalar decomposition of local generators (`lem:local-generator-isometry`
preamble, and the `L = M + cI` step inside `thm:two-uniform-discrete`).**
Unconditional.  `eq_tracelessPart_add_scalar`, `trace_tracelessPart`,
`isHermitian_tracelessPart`, and `localGeneratorSum_eq_traceless_add_scalar`
prove that a Hermitian local operator splits as a traceless Hermitian operator
plus `(Tr H / q) I`, that the traceless part is Hermitian, and that summing site
embeddings gives `M + cI` with `c` real (reality is used in
`TwoUniformProductSymmetry`).

**Single-exponential identity for product unitaries (the paragraph before
`lem:product-lie`).**  Unconditional.  `tensorOperator_exp` proves
`⊗_j exp(h_j) = exp(Sum_j h_j^(j))`.  The proof is structural: operators at
distinct sites commute (`siteOperator_commute`), so Mathlib's
`Matrix.exp_sum_of_commute` factors the exponential of the sum into an ordered
product; `exp_siteOperator` moves each exponential inside its site embedding via
`NormedSpace.map_exp` applied to the continuous algebra homomorphism
`siteAlgHom j`; and `tensorOperator_eq_noncommProd` identifies the ordered
product with the product operator.  A corollary,
`tensorOperator_exp_eq_exp_traceless_add_scalar`, writes an arbitrary product of
one-site unitary exponentials as one exponential with generator split as
`M + cI`.

**Polarized second-moment isometry, manuscript display (3.8).**  Unconditional
and complete.  `stateInner_localGeneratorSum_mulVec` proves

  `⟪M ψ, M' ψ⟫ = q⁻¹ Sum_j Tr(h_j h'_j)`

for `M = Sum_j h_j^(j)`, `M' = Sum_j h'^(j)_j`, with the `h_j` Hermitian and
traceless.  `expectation_localGeneratorSum_eq_zero` is the accompanying
`⟨M⟩ = 0`.  `stateInner_self_localGeneratorSum_mulVec` is the norm form
`‖M ψ‖² = q⁻¹ Sum_j ‖h_j‖_F²`, and
`eq_zero_of_stateInner_self_eq_zero` / `eq_zero_of_localGeneratorSum_mulVec_eq_zero`
are the injectivity statement that makes the map an isometry onto its image.

One deliberate strengthening: Lean needs tracelessness only of the *first*
family.  The cross terms already vanish through `Tr h_j = 0`, so the hypothesis
`Tr h'_j = 0` of the manuscript lemma is not used.  This is recorded in the
declaration's docstring.

The manuscript's separate argument that the imaginary part vanishes is not
needed in the formal proof: with `M` Hermitian, `⟪Mψ, M'ψ⟫` is literally
`⟪ψ, M M' ψ⟫`, and the expectation identities evaluate that directly.  The
manuscript's commutator paragraph is a consistency check rather than a step.

**Discreteness (`thm:two-uniform-discrete`).**  The algebraic and analytic core
is proved unconditionally; the Lie-theoretic packaging is not formalized and is
declared as such.

`localGenerator_eq_zero_of_ray_invariant` assumes a 2-uniform `ψ`, traceless
Hermitian local generators `h_j`, a real `c`, and that for every real `t` the
operator `exp(t · i(M + cI))` maps `ψ` into its own complex line; it concludes
`h_j = 0` for every site, and `localGeneratorSum_eq_zero_of_ray_invariant`
concludes `M = 0`, that is, the generator is the scalar `i c I`.
`tracelessPart_eq_zero_of_productUnitary_ray_invariant` states the same for the
product unitaries `⊗_j exp(i t H_j)` with arbitrary Hermitian `H_j`: every `H_j`
is a scalar, so the one-parameter group acts by global phases.

The Lean proof follows the manuscript: pair `M ψ` against the orbit, note that
`⟪M ψ, ψ⟫ = ⟨M⟩ = 0` makes the pairing identically zero along the orbit,
differentiate at `t = 0` using Mathlib's `hasDerivAt_exp_smul_const` composed
with the continuous linear functional `A ↦ ⟪M ψ, A ψ⟫`, and read off
`‖M ψ‖² = 0`; the polarized isometry then kills every `h_j`.  This replaces the
manuscript's "differentiate the unimodular scalar `λ(t)`" with an equivalent
one-line derivative that needs no spectral theorem.

Unformalized boundary for this theorem: `lem:product-lie` and the last sentence
of `thm:two-uniform-discrete`.  Specifically, Lean does not prove that the
product map `U(q)^n → U(q^n)` has closed image and that the Lie algebra of a
closed subgroup of that image consists of the summed local generators, nor that
a compact Lie group with zero-dimensional quotient is finite.  Mathlib has no
Cartan closed-subgroup theorem, and there is no Lie-algebra-of-a-matrix-group
API to hang the statement on.  The formal statement is therefore about a
one-parameter group *presented* with a generator of summed local form, which is
exactly what `lem:product-lie` supplies in the manuscript.  Everything after
that presentation is formal.

**Two-sided stability estimate (`thm:two-uniform-stability`, display (3.10)).**
NOT formalized.  See "Boundary: the stability estimate" below.

**Decomposition corollary (`cor:approximate-decomposition`).**  Conditional
interface, as scoped, plus one unconditional lemma.

`defectSq ψ A = 2 - 2‖⟨ψ|A|ψ⟩‖` is the squared defect.  `raySymmetry_eigenvalue`
proves that a unitary exact ray symmetry has unimodular eigenvalue and that the
adjoint acts by the conjugate eigenvalue; `defectSq_symmetry_mul` and
`defectSq_mul_symmetry` prove that composing an exact ray symmetry on the left,
respectively the right, leaves the defect unchanged.  The *left* version is the
one the manuscript's proof needs and the one the C776 integration review flagged
as mis-stated there (the manuscript proves right invariance and then uses left
translates); the Lean development proves both, so the formal layer is not
exposed to that slip.

`ApproximateDecompositionInputs` carries the two unformalized inputs as named
fields: `exists_nearby_symmetry` (the compactness extraction producing a
positive threshold and the factorization through an exact symmetry) and
`frobeniusSq_le` (the quadratic growth estimate with constant `6q/5`).  The
terminal `approximate_decomposition` composes them, using the proved left
invariance to transport the growth estimate from the generator ball to its
translate.  No compactness extraction is performed in Lean, and the threshold is
not explicit — matching the manuscript.

**Two-state intertwiner bound (`lem:quantitative-axes`,
`prop:quantitative-intertwiner`).**  NOT entered.  See "Boundary: the intertwiner
bound".

**Deliberately excluded, as scoped:** the Fisher remark
(`rem:fisher-isotropy`), the gauge corollary (`cor:two-unitary-gauge`), and the
Reed-Muller region proposition (`prop:stability-region`).

## Faithfulness of the 2-uniformity hypothesis

`IsTwoUniform ψ` is a structure with three fields: `stateInner ψ ψ = 1`,
`⟨A^(j)⟩ = Tr A / q` for every site and local operator, and
`⟨A^(j) B^(k)⟩ = Tr A Tr B / q²` for every pair of distinct sites.  These are
exactly the statements that the one-site and two-site reduced density operators
are `q⁻¹ I` and `q⁻² I`, because operators of product form span the operators on
one and on two sites.  That spanning equivalence with a partial-trace
presentation of the reduced density operator is *not* proved in Lean; it is
stated in the module header as the mathematical reading of the definition.  The
implication from the pair condition to the single condition, which needs only a
second site, *is* proved (`single_of_pair`).

This is the one place where a reader must accept a standard linear-algebra fact
to connect the Lean hypothesis to the manuscript's definition.  Closing it would
mean defining partial traces on the `Site -> Level` index and proving the
product-operator expectation equals the pair-marginal contraction; that is a
self-contained follow-up, not a defect in the present statements.

## Boundary: the stability estimate

The two-sided estimate (3.10) is materially harder than the rest of the
subsection in this framework, and it is reported as a boundary rather than
weakened.  Three separate pieces are missing, none available off the shelf:

1. *A spectral-expectation calculus.*  The proof writes `M = Sum_i λ_i P_i` and
   sets `p_i = ⟨P_i⟩ >= 0` with `Sum_i p_i = 1`, then evaluates `⟨M⟩`, `⟨M²⟩`,
   `⟨e^{iM}⟩`, and `⟨r(M)⟩` as `Sum_i p_i f(λ_i)`.  Mathlib has
   `Matrix.IsHermitian.spectral_theorem`, but the transfer to expectations in a
   fixed state — the statement `⟨f(M)⟩ = Sum_i p_i f(λ_i)` with the weights a
   probability vector — has to be built.
2. *The spectral operator norm of a site-embedded operator.*  The hypothesis
   `t = Sum_j ‖h_j‖_op` bounds `‖M‖_op` by the triangle inequality, and the
   proof then uses `|λ_i| <= t`.  This is the `l²` operator norm, not the
   `linftyOp` norm that Mathlib's matrix exponential lemmas use, and it requires
   `‖siteOperator j h‖_op = ‖h‖_op`, itself a tensor-structure computation.
3. *The integral-remainder Taylor bound with the exact constant.*  The estimate
   needs `|e^{ix} - 1 - ix + x²/2| <= |x|³/6` for real `x`.  Mathlib's
   `Complex.exp_bound` gives the third-order remainder with constant `2/9`, not
   `1/6`, and the sharper bound comes from the integral form of the remainder.
   Substituting `2/9` would change the constants in (3.10) and in the
   `sqrt(6q/5)` corollary, so it is not an acceptable substitute for a statement
   the manuscript states sharply.

The consequence for the ledger: no part of `thm:two-uniform-stability` may be
described as kernel checked.  Its role in the decomposition corollary is carried
by the named hypothesis `ApproximateDecompositionInputs.frobeniusSq_le`, whose
statement is exactly the growth estimate the theorem supplies.

## Boundary: the intertwiner bound

`lem:quantitative-axes` and `prop:quantitative-intertwiner` are not entered, even
as an interface.  Their content is not about 2-uniformity: it is Eckart-Young
perturbation of an orthogonally decomposable tensor followed by additive and
symplectic rigidity of Weyl axes and realization by a single-qudit Clifford.
The Weyl and Clifford apparatus lives in the six-party finite-field framework of
`AMELU.Definitions`, not in the arbitrary-`q` multipartite framework built here,
and an interface stated in the multipartite framework would have to re-declare
that apparatus abstractly.  A structure whose only fields are the three proof
steps and whose terminal restates the conclusion would carry no formal content
beyond the manuscript statement.  Recommendation: if this is wanted formally, do
it inside the six-party framework where `IsCliffordMatrix` and `weylMatrix`
already exist, as its own task.

## Validation

(to be completed once the shared build lock is free)

## Formalization ledger: what the row should say

The ledger row for
`lem:local-generator-isometry`; `lem:product-lie`; `thm:two-uniform-discrete`;
`thm:two-uniform-stability`; `prop:stability-region`;
`cor:approximate-decomposition`; `lem:quantitative-axes`;
`prop:quantitative-intertwiner`; `cor:two-unitary-gauge`
currently reads "none" in `papers/ame_lu/formalization-ledger.md`.  It should be
replaced by (the ledger is outside this task's allowed paths, so this is a
recommendation, not an edit):

- **Formal status.**  `RelativeConicArcs.AMELU.Multipartite` proves
  unconditionally, for an arbitrary finite site set and arbitrary local
  dimension: the traceless/scalar splitting of Hermitian local generators; the
  single-exponential identity `⊗_j exp(h_j) = exp(Sum_j h_j^(j))`; the polarized
  second-moment identity (3.8) with its norm form and injectivity; that a
  one-parameter group of product unitaries fixing the ray of a 2-uniform state
  has scalar local generators; and that the defect is invariant under an exact
  ray symmetry composed on either side.  `ApproximateDecompositionInputs` is a
  hypothesis-explicit interface whose terminal is the decomposition corollary.
- **Unformalized boundary.**  The closed-subgroup and Lie-algebra content of
  `lem:product-lie`, and the passage from a trivial Lie algebra to a finite
  quotient in `thm:two-uniform-discrete`; the equivalence of the expectation form
  of 2-uniformity with a partial-trace presentation; the whole of
  `thm:two-uniform-stability`, whose growth estimate appears only as the named
  hypothesis `ApproximateDecompositionInputs.frobeniusSq_le`, and the compactness
  threshold, which appears as `ApproximateDecompositionInputs.exists_nearby_symmetry`;
  `prop:stability-region`, `lem:quantitative-axes`,
  `prop:quantitative-intertwiner`, `rem:fisher-isotropy`, and
  `cor:two-unitary-gauge` are not formalized.
- **Action.**  Cite Lean unconditionally for the generator splitting, the
  single-exponential identity, identity (3.8), and the absence of a nonscalar
  continuous product-unitary symmetry; cite the decomposition corollary as a
  conditional formal interface; do not describe any part of the stability
  estimate, the region proposition, or the intertwiner bound as kernel checked.

The gate row for this package is
`RelativeConicArcs.Gates.AMELUTwoUniformRigidity` with audit
`RelativeConicArcs.Gates.AMELUTwoUniformRigidityAxioms`.
