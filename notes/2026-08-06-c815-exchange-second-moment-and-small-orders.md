# C815 — the second exchange moment, the small orders, and the gated spectrum module

**Date:** 2026-08-06
**Lane:** `clebsch` (Paper III route task C815, ledger row OPER-3)
**Module:** `lean/RelativeConicArcs/BalancedExchangeSpectrum.lean`
**Gate:** `RelativeConicArcs.Gates.ClebschGoldenReturn`, 67 terminals, no
compiled-evaluation axiom
**Status:** the row's spectral half is closed except for the eigenvalue phrasing
and the existence of the isometries

## What this closes

The module already carried the compression argument: the exchange operator of a
balanced cut has the characteristic polynomial and every power trace of
`1 - q⁻¹ • (A * A)`, and the first moment is `d²/q`.  This round adds the rest
of the row that does not need the inner-product library.

- `sum_closedFourWalkSum_eq_alignedFourSetCount` — the four-subset weight sum of
  a set of labels is `32 c - 8 C(|Y|, 4)`, where `c = alignedFourSetCount A Y`
  counts the four-subsets of Hamilton-cycle weight `3`.  This is the counting
  step the earlier scope named as the only new combinatorial bookkeeping, and it
  is a two-way split of the closed `{24, -8}` dichotomy, not an argument.
- `trace_pow_two_exchangeCompression_cut` — the second exchange moment in the
  manuscript's aligned-four-set form,

  `tr(H²) = (d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c) / q²`.

  Every summand except the last is fixed by the order, so the aligned count
  carries the whole dependence of the second moment on the half.
- `not_forall_alignedFourSetCount_eq` — that count is not the same for every
  balanced half of a symmetric conference matrix of order `2d` once `4 ≤ d`.
  With the moment formula this is the failure clause: the second moment, and
  with it the spectrum, depends on the cut.
- `charpoly_one_sub_smul_mul_self_of_card_one`, `_of_card_two`,
  `_of_card_three`, and `charpoly_exchangeCompression_cut_card_three` — the
  constancy clause for a half of at most three labels, ending in the order-six
  spectrum: the characteristic polynomial of the exchange operator is
  `(X - 1/5)(X - 4/5)²` for every balanced cut of every symmetric conference
  matrix of order six.
- `ne_smul_one_of_card_four` — no symmetric matrix with zero diagonal and
  off-diagonal entries squaring to one has a scalar square on four labels.

The last item was not in the scope's list.  It is the input the scope flagged as
the open question behind the manuscript's claim that order six is the unique
nontrivial realized order with a cut-independent spectrum, and it turned out to
cost nothing: it is the same fourth-trace count, read at four labels.

## How the pieces go

**The second moment.**  The power-trace transfer reduces `tr(H²)` to
`tr((1 - q⁻¹ A²)²) = d - 2 q⁻¹ tr(A²) + q⁻² tr(A⁴)`.  The trace of the square is
`d(d-1)`, and the support-sorted fourth trace is
`d(d-1) + 12·C(d,3)` plus the closed four-walk weights of the four-subsets.
Each of those weights is `24` on an aligned four-set and `-8` otherwise, so
their sum is `32 c - 8 C(d,4)`, and clearing `q²` gives the displayed formula.
Nothing here goes through the spectrum.

**The failure clause.**  If the aligned count were the same for every balanced
half then, by the same weight sum, the fourth trace of the principal block would
be too, which the exchange-rigidity theorem excludes for `4 ≤ d`.  Stated on the
aligned count rather than on the walk sum, this is the invariant the second
moment actually sees.

**The small orders.**  On three labels every off-diagonal product satisfies
`A i k · A k j = τ · A i j` with `τ` the product of the three edge signs, so
`A * A = 2 • 1 + τ • A` and `1 - A²/5 = (3/5) • 1 - (1/5) • (τ • A)`.  For a
symmetric sign matrix `N` with zero diagonal on three labels whose edge signs
multiply to one, the three-by-three determinant of the characteristic matrix of
`3v • 1 - v • N` is `u³ - 3v²u + 2v³` with `u = X - 3v`, which factors as
`(u - v)²(u + 2v) = (X - 4v)²(X - v)`.  The sign product `τ` cancels — the
matrix `τ • A` has the same shape as `A` and edge-sign product `τ⁴ = 1` — so
there is no case split, and the manuscript's two-case factorization
`(t-2)(t+1)²` / `(t+2)(t-1)²` is one uniform cubic.  Composing with the
characteristic-polynomial identity gives the order-six spectrum.  Two labels
give `A * A = 1` and one label gives `A = 0`, both immediate.  The general
label set is reduced to `Fin k` by `Matrix.charpoly_reindex`, so no theorem is
restricted to a numbered index type.

**Order four.**  A symmetric sign matrix with zero diagonal on four labels whose
square is `q • 1` has `q = 3` by the trace of its square, hence fourth trace
`36`.  The support-sorted count makes that `12 + 12·C(4,3)` plus the weight of
its only four-set, so that weight is `-24`, which the `{24, -8}` dichotomy
forbids.

## Arithmetic check of the two formulas at order six

At `d = 3`, `q = 5` a half has no four-subsets at all, so `c = 0` and
`C(3,4) = 0`, and the moment formula gives
`(3·25 - 2·5·6 + 6 + 12·1 - 8·0)/25 = 33/25`.  The proved spectrum
`{1/5, 4/5, 4/5}` gives `1/25 + 16/25 + 16/25 = 33/25`, and the first moment
`d²/q = 9/5` matches `1/5 + 4/5 + 4/5`.  The two halves of the row therefore
agree numerically where they overlap, which they were derived independently of.

## Validation

- `guarded-lean` on the module: no errors, no warnings.
- `lean-build-queue.py build RelativeConicArcs.Gates.ClebschGoldenReturn`:
  success.  The gate now audits sixty-seven terminals, each depending only on
  `propext`, `Classical.choice` and `Quot.sound`, several on strictly fewer.  No
  compiled evaluation appears anywhere in the pinned closure.
- Axiom report, source-closure inventory and tracked gate stdout regenerated by
  their committed generators from that build; `golden_return_formal.json` and
  the OPER-3 rows of `passages_formal.json` re-pinned.
- The golden-return replay passes in both source-only and axiom-log modes, and
  the passages and four-shadow replays pass.
- `verify_release.py` passes every check except its manuscript build, which
  cannot run in this environment: `latexmk` is absent from both the ambient
  shell and the Lean development shell.  That check was already failing on the
  tracked PDF before this work, and no Paper III Lean work touches it.

## What row OPER-3 still needs

- The eigenvalue phrasing `Spec = {1 - αᵢ²/q}`.  Given the characteristic
  polynomial identity this is a root-set reading of a polynomial identity over
  the reals, `Matrix.IsHermitian.charpoly_eq` plus a substitution.  It is the
  only remaining statement that needs the Hermitian eigenvalue interface.
- The existence of the two isometries, which is what would make the compression
  theorems unconditional rather than conditional on an isometry being supplied.
  This needs the rank-equals-trace fact for idempotents and an orthonormal basis
  of a range, the one place where the inner-product library is unavoidable.
- The bridge from a balanced half `Y` of a matrix on one label set to the cut
  coordinates `n ⊕ m` in which the compression theorems are stated.  The
  cut-dependence statement is proved on the invariant the moment sees, the
  aligned count of the half, rather than on the compression of a cut built from
  `Y` by `Equiv.sumCompl`; carrying it across that equivalence is mechanical and
  unstarted.

## Mystery ledger

- **Settled.**  The scope's estimate of roughly 800–1000 lines for the whole
  spectral half was too high, and the reason is structural rather than
  incidental: every piece that looked analytic is a characteristic-polynomial or
  trace identity, and the two that remain are exactly the two that mention
  eigenvalues or an orthonormal basis by name.
- **Settled.**  The manuscript's separate order-four discussion is not needed as
  an input.  The fourth-trace count that excludes cut-independence for `4 ≤ d`
  also excludes order four outright, from the same dichotomy, so the uniqueness
  of order six among the orders the constancy clause covers is proved rather
  than assumed.
- **Settled.**  The product `τ` of the three edge signs of a three-label half is
  a switching invariant and separates the two switching classes of such blocks,
  yet it does not reach the spectrum.  The reason is that the two classes are
  exchanged by the global sign flip `A ↦ -A`, which flips `τ` because three is
  odd and leaves `A * A` — hence the whole exchange operator — unchanged.  The
  block spectra do differ: `{2, -1, -1}` against `{1, 1, -2}`.
- **Open.**  The exchange moments form a hierarchy: the `k`-th moment is the
  `k`-th moment of `1 - q⁻¹ A²`, hence a signed count of closed `2k`-walks on
  the half.  The second moment sees exactly the aligned four-set count; what the
  third sees is a count of closed six-walks, and the third cut moment is already
  known to separate the four order-26 switching classes.  Whether the separation
  proved there is the same statement as the third exchange moment of the cut is
  not settled here.  Owner: the aligned-certificate robustness task, which owns
  the moment recurrence.
- **Open.**  Whether `R Rᵀ` can be singular for a symmetric conference matrix,
  equivalently whether `q` can be an eigenvalue of `A²` on a balanced half,
  remains open and remains outside Paper III's obligations; nothing above
  depends on it.
