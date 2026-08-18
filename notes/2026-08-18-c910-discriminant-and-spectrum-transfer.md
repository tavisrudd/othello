# C910 — the discriminant differential equation and spectrum transfer

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commit:** `59e679e0b`.
**Predecessor:** the low-dimensional exclusions report
`2026-08-18-c910-low-dimensional-exclusions.md`.

`lem:disc` and `lem:spectrum-transfer` were the two remaining absent rows of the
atomic route in Section 4.  Both are now conditional deductions.

## The discriminant lemma

Three pieces landed, in
`Quantum/QuarticDiscriminantDerivations.lean` and
`Quantum/PowerSeriesLogarithmicVanishing.lean`.

The universal discriminant polynomial of a monic quartic is defined in the
coefficients and proved equal to the squared product of the pairwise root
differences when the quartic splits, so nothing about the discriminant is taken
on trust.

The frame data is a structure over an arbitrary commutative ring: four elements
playing the role of the characteristic coefficients, four derivations playing the
role of `X₀ = e`, `X₁ = E`, `X₂ = E ∘ E`, `X₃ = E ∘ E ∘ E`, and the sixteen
coefficient identities of David--Hertling, equations (19), (20), (24), (25), in
the conventions `λ₄ = 1` and `λ_j = 0` for `j < 0`.  From those identities alone
Lean proves the four displayed logarithmic derivatives — annihilation by the unit
field, the factor twelve for the Euler field, and the factors `-6λ₃` and
`6λ₃² - 10λ₂` — and then that any ring-coefficient combination of the frame
multiplies the discriminant by the corresponding combination of those factors.
That last statement is the manuscript's `dΔ = Δ ω` with the regular one-form
made explicit.

The vanishing half is proved in a formal power-series model of the germ over a
commutative domain of characteristic zero: if every formal partial derivative of
a series is a multiple of the series and its constant coefficient vanishes, the
series is zero.  The proof is coefficientwise — take a monomial of least total
degree with a nonzero coefficient, differentiate in a variable occurring in it,
and observe that the product side has no coefficient in that lower degree at all.
The assembled terminal takes the frame expression of every coordinate derivation,
which is regularity of Euler multiplication at the base point, plus vanishing at
the base point, and concludes that the discriminant is the zero series.

The frame hypotheses are exhibited, not merely assumed: the universal root model
— the polynomial ring in four root variables over the rationals, with the signed
elementary symmetric functions as coefficients and `Xₛ` acting by
`∑ᵢ μᵢ ^ s ∂/∂μᵢ` — satisfies all sixteen identities, so the deductions above are
not vacuous.

Reviewer terminals: `quarticDiscriminant_eq_squared_root_differences`,
`eulerFrame_discriminant_logarithmicDerivatives`,
`eulerFrame_discriminant_differential`,
`eulerFrame_discriminant_eq_zero_of_vanishing_at_base_point`, and
`eulerFrame_data_nonempty`.

## The spectrum-transfer lemma

`Quantum/ModuleSpectrumTransfer.lean` proves the eigenvalue sets of an algebra
element on the algebra and on a module over it coincide, for a finite-dimensional
commutative algebra over a field and a module in which some vector generates an
injective copy of the algebra.  Terminal:
`eulerMultiplication_eigenvalues_module_eq_algebra`.

The formal proof is shorter than the manuscript's.  An eigenvalue on the module
makes `E - λ` a non-unit, and in a finite-dimensional commutative algebra a
non-unit is a zero divisor, which is an eigenvector in the algebra; conversely an
eigenvector in the algebra is pushed into the module along the injection.  The
generalized-eigenvalue decomposition, the orthogonal idempotents, and the
nilpotence of `E - λᵢ` on each block are not needed at all.

## Coverage

Two rows moved from absent to conditional deductions.  The snapshot is 50 claims
and 46 machinery rows over 198 terminals: 16 absent, 16 fragmentary, 17
conditional, 1 complete.

## Gates

All green at `59e679e0b`.  Each new module was elaborated singly and then built
through the guarded queue together with `PaperInterface` and
`Verification/AxiomAudit`.  `make check` and the axiom-log check pass over 109
sources and 198 terminals.  Every new terminal reports `propext,
Classical.choice, Quot.sound`, except the root-difference identity, which reports
`propext, Quot.sound`.  No manuscript source was edited; the tracked PDF is
unchanged at 49 pages.

## Scope

Lean constructs no `F`-manifold, tangent sheaf, Euler field, spectral cover,
quantum cohomology, or Hodge base.  The sixteen coefficient identities are
hypotheses of the frame data rather than consequences of Cayley--Hamilton and the
Witt relations; regularity of Euler multiplication enters only as the frame
expression of the coordinate derivations; and the germ is modelled by a formal
power-series ring, so the completion of the local ring of a rigid-analytic germ,
its identification with that ring, and Krull's intersection theorem are outside
the formalization.  For the spectrum lemma, finite dimensionality of even quantum
cohomology and injectivity of the action on the cohomology unit are hypotheses.

## Mystery ledger

- The manuscript's spectrum-transfer proof is heavier than it needs to be.  The
  idempotent decomposition can be replaced by two lines: `E - λ` is a non-unit,
  hence a zero divisor in a finite-dimensional commutative algebra, and an
  algebra eigenvector maps into the module along the unit.  The formal proof
  takes that route.  Settled here as a mathematical fact; whether to shorten the
  manuscript proof is an author decision and no manuscript source was touched.
- Regularity is used less than the prose suggests.  The four logarithmic
  derivatives need only the coefficient identities and hold over any commutative
  ring; regularity of Euler multiplication enters solely in making `X₀, …, X₃` a
  frame, which is what turns the four equations into a statement about every
  coordinate derivative.  Settled by this pass.
- Characteristic zero is exactly the hypothesis the vanishing argument needs, and
  it is sharp: over a field of characteristic `p` the series `y ^ p` has all
  formal partial derivatives zero and zero constant coefficient without being
  zero.  The formal proof isolates the single point of use, the nonvanishing of
  the exponent as a scalar.  Settled by this pass.
- The manuscript's proof of the vanishing step uses the lowest homogeneous part
  and Euler's identity; the formalization uses a single monomial of least total
  degree instead.  The two are equivalent, and the monomial form avoids Euler's
  identity entirely.  Settled by this pass.
- No genuine mystery remains in the two lemmas.  What remains open in their
  neighbourhood is the geometry they sit on: `lem:hodge-base` and
  `lem:euler-sign` are still absent, so nothing in Lean yet connects a cubic
  threefold to the frame data used here.

## Next

From the gap audit, still open in the atomic neighbourhood: the even-part
refinement of `lem:orthogonal`, the absent geometric rows `lem:hodge-base` and
`lem:euler-sign`, and the disposition of the orphaned machinery themes.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-epilogue` was synchronized from authority
`3c2a343d8` at its commit `20a9f57`, the export manifest verifies over its
tracked tree, and the repository's own `make check`, pinned Lean build, and
axiom-log replay agree with the authority over 198 reviewer terminals.
