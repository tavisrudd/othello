# C815 — the exchange spectrum in Lean: compression, characteristic polynomial, moments

**Date:** 2026-08-06
**Lane:** `clebsch` (Paper III route task C815, ledger row OPER-3)
**Module:** `lean/RelativeConicArcs/BalancedExchangeSpectrum.lean`
**Status:** the module elaborates with no errors and no warnings; not yet on a
gate and its compiled artifact is not yet built, because another lane holds the
shared build lock

## What this closes

The route scoped in `notes/2026-08-06-c815-exchange-spectrum-scope.md` is
implemented and kernel-checked for the two claims that carry the row:

- `charpoly_exchangeCompression_cut` — the characteristic polynomial of the
  exchange operator of a balanced cut equals that of `1 - q⁻¹ • (A * A)`, for
  `A` the principal block on the chosen half.  This is stronger than the
  manuscript's set-level spectral formula, which it implies.
- `trace_exchangeCompression_pow_cut` — every power trace of the exchange
  operator equals the corresponding power trace of `1 - q⁻¹ • (A * A)`.  This is
  the passage the ledger row names, from the traces of the principal block to
  the exchange moments, and it does not go through the spectrum at all.
- `trace_exchangeCompression_cut` — the first exchange moment is `d² / q`, the
  manuscript's first displayed trace formula, obtained from the previous item
  and the already-proved trace of the square of a sign matrix.

The scope's central prediction holds: the development contains no eigenvalue, no
singular value, no diagonalization, and no `Real.sqrt`.  The square root of the
order enters only as a hypothesis `s * s = q` on a field element, so the whole
module is stated over an arbitrary field of characteristic zero.

## Shape of the development

Three layers, all in `RelativeConicArcs.BalancedExchangeSpectrum`.

**Abstract involution layer.**  For matrices `D` and `Q` with `Q * Q = 1`,
`D * D = 1` and both symmetric, `signCommutator D Q = D * Q - Q * D` is
antisymmetric and anticommutes with `Q`, and `exchangeOperator D Q` is minus a
quarter of its square.  The two spectral projections `fixedProjection Q` and
`antifixedProjection Q` are `(1 ± Q)/2`.  The key trace fact is
`trace_pow_signCommutator_mul_involution`: for every `j`, moving one factor of
the commutator around the trace of `L ^ (j+1) * Q` reverses the sign, so that
trace vanishes.

**Compression layer.**  An isometry onto the fixed space is a matrix `U` with
`Uᵀ * U = 1` and `U * Uᵀ = fixedProjection Q`; this pair of equations is the
subspace-free form of "an isometry onto the positive eigenspace", so no
submodule machinery appears.  `exchangeCompression_eq` identifies the
manuscript's `Uᵀ D (1-Q)/2 D U` with the compression `Uᵀ * (exchangeOperator * U)`,
by computing the Gram matrix of `signCommutator * U` in two ways.
`trace_exchangeCompression_pow` then halves the trace of each power of the
operator onto the fixed space.

**Characteristic-polynomial layer.**  With `W` an isometry onto the antifixed
space, `S = (Wᵀ * (L * U))/2` satisfies `Sᵀ * S = ` the fixed compression and
`S * Sᵀ = ` the antifixed compression, so `Matrix.charpoly_mul_comm'` gives them
equal characteristic polynomials (`charpoly_compression_eq`); this is where the
balanced hypothesis `Fintype.card n = Fintype.card m` is used, to cancel the
power of `X`.  Placing the two isometries side by side in `Matrix.fromCols`
block diagonalizes the operator, so the product of the two compressions'
characteristic polynomials is that of the operator (`charpoly_compression_mul`).
Two monic polynomials of the same degree with equal squares are equal, because
their sum has leading coefficient two, which is `monic_eq_of_mul_self_eq`.

**Cut layer.**  `exchangeOperator_cut` computes the operator in cut coordinates:
it is block diagonal with blocks `q⁻¹ • (B * Bᵀ)` and `q⁻¹ • (Bᵀ * B)`.  The two
blocks have equal characteristic polynomials and equal power traces, again by
the rectangular commutation lemmas, and `ConferenceCutBlocks` rewrites the first
as `1 - q⁻¹ • (A * A)`.

## What remains in row OPER-3

- The second exchange moment in the manuscript's form `(F_d + 32 c_Y)/q²`.  The
  power-trace transfer above already reduces it to the fourth trace of the
  principal block, which is proved; what is missing is the counting step
  `Σ_K w(K) = 4 c_Y - C(d,4)` that converts the weight sum into the count of
  aligned four-sets, and the arithmetic of `F_d`.
- The failure clause for `4 ≤ d`: a wrapper deriving unequal spectra from the
  unequal second moments already proved in
  `RelativeConicArcs.BalancedExchangeRigidity`.
- The constancy clause for `d ≤ 3`, including the order-six spectrum
  `{1/5, 4/5, 4/5}` through the uniform cubic `(X-2)³ - 3(X-2) - 2 = (X-4)(X-1)²`.
- The eigenvalue phrasing `{1 - αᵢ²/q}`, the only statement needing the
  Hermitian eigenvalue interface, and the existence of the two isometries, which
  is what would make the theorems unconditional rather than conditional on an
  isometry being supplied.
- Gate integration: the module belongs on the golden-return gate, with the axiom
  audit and closure inventory regenerated in one owning build window.  It is on
  no gate yet, and its compiled artifact has not been produced, because a
  foreign Lean build held the shared build lock throughout this session.  Until
  that build window, the evidence for the module is its clean single-file
  elaboration, not a gate replay.

## Mystery ledger

- **Settled.** The scope predicted that the compression argument would need no
  analysis and no Newton identities.  It needed neither, and the proof is
  shorter than the scope estimated: the two Gram matrices `Sᵀ * S` and `S * Sᵀ`
  do the whole spectral comparison in one application of a mathlib lemma.
- **Settled.** The manuscript's isometry `Q₊` looked like it would force
  submodules into the formal statement.  The pair `Uᵀ * U = 1`,
  `U * Uᵀ = (1 + Q)/2` replaces it exactly and keeps everything in matrix
  algebra.
- **Open.** Whether an isometry onto each spectral space exists for a real
  symmetric involution with zero trace is not proved here, so the theorems are
  conditional.  This is the only respect in which the formal statements are
  weaker than the manuscript's, and it is the next item that needs the
  inner-product library.  Owner: C815.
