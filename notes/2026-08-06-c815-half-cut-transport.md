# C815 — the cut of a half, and the closure of row OPER-3

**Date:** 2026-08-06
**Lane:** `clebsch` (Paper III route task C815, ledger row OPER-3)
**Module:** `lean/RelativeConicArcs/BalancedExchangeHalfCut.lean`
**Gate:** `RelativeConicArcs.Gates.ClebschGoldenReturn`, 83 terminals, no
compiled-evaluation axiom
**Status:** row OPER-3 is closed; nothing in it rests on an assumed hypothesis
or on a statement about an abstractly presented cut

## What this closes

The spectral half of the row was proved for a matrix already presented in cut
coordinates, as `Matrix.fromBlocks A B Bᵀ E` on a sum type, while the
cut-dependence statement was proved for a matrix `C` on a single label set and a
subset `Y` of it, in the invariant the second moment sees rather than on the
exchange operator that `Y` defines.  This module supplies the missing
identification, so the dependence on the cut is now stated about the cut.

- `cutMatrix` and `cutMatrix_eq_submatrix` — the block presentation of `C` at a
  subset `Y` is exactly the relabelling of `C` along `Equiv.sumCompl (· ∈ Y)`,
  which lists the labels of `Y` before those of its complement.  Symmetry of `C`
  is what makes the lower-left block the transpose of the cross block.
- `cutMatrix_mul_self` — relabelling along an equivalence is a ring map on
  matrices, so `C * C = q • 1` is carried into cut coordinates unchanged.
- `trace_pow_four_principalBlock` — the fourth trace of the principal block is
  the fourfold sum over `Y` of `C i j * C j k * C k l * C l i`, the quantity
  whose dependence on the half `not_forall_sum_closedFourWalkWeight_eq` settles.
- `closedFourWalkSum_map` and `alignedFourSetCount_principalBlock` — the closed
  four-walk weight of a four-set is unchanged by relabelling along an injection,
  so the aligned four-sets of the principal block are the images of the aligned
  four-subsets of `Y` and the two counts agree.
- `exists_isometry_trace_pow_two_exchangeCompression_half` — over the reals, for
  a symmetric `C` with zero diagonal and off-diagonal entries squaring to one,
  `C * C = q • 1`, and a subset `Y` with `Fintype.card n = 2 * Y.card`, an
  isometry onto the fixed space exists and the exchange operator it defines has
  second moment
  `(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²`
  with `d = Y.card` and `c` the number of aligned four-subsets of `Y` itself.
- `not_forall_trace_pow_two_exchangeCompression_half_eq` — for order `2d` with
  `4 ≤ d`, no real number is that second moment for every balanced half.  This
  is the manuscript's substantive direction, now stated on the exchange operator
  of the cut rather than on a proxy invariant.
- `exists_isometry_charpoly_exchangeCompression_half` and
  `exists_isometry_charpoly_exchangeCompression_half_card_three` — the same
  identification puts the two spectral statements in the same language: the
  exchange spectrum at a half is `∏ (X - (1 - αᵢ²/q))` over the eigenvalues of
  the submatrix on that half, and at order six it is `(X - 1/5)(X - 4/5)²` for
  every three-element subset.  Cut-independence at the exceptional order and its
  failure for `4 ≤ d` are now statements of the same shape about the same
  object.

## How the pieces go

**Cut coordinates.**  `Equiv.sumCompl (· ∈ Y)` is the equivalence
`{x // x ∈ Y} ⊕ {x // x ∉ Y} ≃ n`.  Relabelling both indices of `C` along it
gives a block matrix whose four blocks are the four submatrices cut out by `Y`
and its complement; the only input beyond unfolding is symmetry, which turns the
lower-left submatrix into the transpose of the upper-right one.  Because
`Matrix.submatrix` along an equivalence commutes with multiplication and fixes
the identity, the scalar square transports with no further argument.

**The fourth trace.**  Expanding the trace of the fourth power of the principal
block gives a fourfold sum over the subtype `{x // x ∈ Y}`; each of the four
sums is a sum over `Y` by `Finset.sum_subtype`, applied one level at a time
under the surrounding binders.  Nothing else happens: the identification is an
indexing statement, not a combinatorial one.

**The aligned count.**  For a four-element set the closed four-walk weight is
eight times the sum of the three Hamilton-cycle products read off any labelling,
and a labelling of `K` maps to a labelling of the image of `K`.  So the weight
is preserved by relabelling along an injection, and mapping a four-subset of the
subtype to its image is a bijection between the two filtered families, with
`Finset.subtype` as inverse.

**The negative statement.**  If every balanced half had the same second moment,
the moment formula — affine in the aligned count with coefficient `32/q²` —
would force the aligned counts of all balanced halves to agree, which
`not_forall_alignedFourSetCount_eq` refutes.  The passage from the real equality
of counts to the equality of naturals is the injectivity of the cast, so the
argument does not weaken the arithmetic already in place.

## Validation

- `guarded-lean` on the module: no errors, no warnings.
- `lean-build-queue.py build RelativeConicArcs.Gates.ClebschGoldenReturn`:
  success.  The gate audits eighty-three terminals, each depending only on
  `propext`, `Classical.choice` and `Quot.sound`; no compiled evaluation appears
  anywhere in the pinned closure.
- Axiom report and source-closure inventory regenerated by their committed
  generators from that build's tracked stdout; `golden_return_formal.json`
  re-pinned and the OPER-3 row of `passages_formal.json` refreshed.
- All six paper-local replays pass, in both source-only and axiom-log modes
  where applicable, and the release gate replays all three Lean gates.
- `verify_release.py` passes every check except its manuscript build, which
  cannot run in this environment because `latexmk` is absent; that failure
  predates this work and no Paper III Lean work touches it.
- `verification/README.md` said that no eigenvalue or singular-value statement
  was formalized, which stopped being true when the eigenvalue reading and the
  isometry existence landed.  That paragraph now describes the exchange
  operator, its two moments, the eigenvalue reading, the isometry existence and
  the half-cut identification.

## Mystery ledger

- **Settled.**  The scope expected the aligned-count transport to need a
  bijection argument on four-subsets and the fourth-trace transport to need a
  sum manipulation.  Both were as expected and neither carried mathematical
  content; what made them cheap is that the four-set weight is determined by a
  labelling, so relabelling invariance is one rewrite rather than an induction
  over walks.
- **Settled.**  Nothing in the transport needed the cut to be balanced except
  where the isometries are produced.  The block identifications, the fourth
  trace and the aligned count hold for an arbitrary subset of the labels, which
  is why the moment theorem takes `Fintype.card n = 2 * Y.card` as a hypothesis
  rather than building it into the definitions.
- **Open, and recorded rather than closed; sharpened by the 2026-08-07 review.**
  The cut-dependence theorem is a non-constancy statement proved by
  contradiction through the constant-weight descent, so it names no pair of
  halves with different second moments.  The claim made here that a witness
  would need a construction rather than a counting argument is too strong: the
  *existence* of such a pair is a two-line classical corollary, obtained by
  instantiating the aligned-count theorem at a fixed half and negating the
  quantifier.  What the proof does not give is a *named* pair, and at order ten
  even that is a bounded finite check on one explicit matrix.  The manuscript
  needs only the negative form, so neither was added.  See
  `notes/2026-08-07-c815-oper3-referee-review.md`.
- **Open, unchanged, and outside the row.**  Whether `q` is ever an eigenvalue
  of the square of a principal block on a balanced half — equivalently whether
  the exchange operator can be singular — remains unsettled.  The positive
  semidefiniteness noted in the eigenvalue round bounds the spectrum in the unit
  interval and says only that `q` cannot be exceeded.  Logged in the discovery
  track; no C-ID allocated.
