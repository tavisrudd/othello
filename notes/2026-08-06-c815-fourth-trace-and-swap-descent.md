# C815 — the fourth trace by support, and the inclusion swap descent

**Date:** 2026-08-06
**Task:** C815
**Lane:** `clebsch`
**Status:** landed and validated; the combinatorial half of gap class B row
OPER-3 is closed, including its conclusion, leaving only the spectral
statements

## What was proved

### The inclusion swap descent

New module `lean/RelativeConicArcs/SubsetInclusionSums.lean`, over an arbitrary
type with decidable equality and a commutative ring of characteristic zero with
no zero divisors. For a function `g` on finite label sets, the *inclusion sums*
at sizes `r ≤ m` are the numbers `Σ_{T ⊆ S, |T| = r} g T`, one for each
`m`-subset `S` of the label set `X`.

- `sum_powersetCard_insert` — the `(r+1)`-subsets of `insert a S`, for `a ∉ S`,
  split into those inside `S` and those adjoining `a` to an `r`-subset of `S`.
- `sum_sub_eq_zero_of_sum_powersetCard_eq` — the exchange step. If the
  inclusion sums at size `r+1` over the `(m+1)`-subsets of `X` all agree, then
  for any two labels `a, b` the difference function
  `T ↦ g (T ∪ {a}) - g (T ∪ {b})` has vanishing inclusion sums at size `r` over
  the `m`-subsets of `X \ {a, b}`. Subtracting the two sums cancels the terms
  that avoid both labels.
- `eq_of_swap_invariant` — one-element exchanges connect the subsets of a fixed
  size, so a function invariant under every exchange takes one value on all of
  them. This is an induction on the cardinality of the difference of two
  subsets, not a connectivity theorem imported from anywhere.
- `eq_zero_of_sum_powersetCard_eq_zero` — if every inclusion sum vanishes, and
  `r ≤ m` with `r + m ≤ |X|`, then `g` vanishes on every `r`-subset. Induction
  on `r`: the exchange step plus the inductive hypothesis on `X \ {a, b}` makes
  `g` exchange-invariant, hence constant, and one inclusion sum then reads
  `C(m, r)` times that constant.
- `eq_of_sum_powersetCard_eq` — the form the manuscript uses: if the inclusion
  sums are merely all *equal*, and `1 ≤ r ≤ m` with `r + m ≤ |X|`, then `g`
  takes one value on all `r`-subsets.

This is exactly the consequence of full column rank of the inclusion matrix of
`r`-subsets against `m`-subsets that Paper III needs, proved by swap descent.
The rank formula itself — Gottlieb, *A certain class of incidence matrices*,
Proceedings of the American Mathematical Society **17** (1966), 1233–1237,
Theorem 1, with the representation-theoretic proof of Jolliffe,
arXiv:2009.05202v1 (2020), Theorem 1 — is now an attribution in the manuscript
rather than a dependency of any Paper III theorem.

### The fourth trace, sorted by support

New declarations in `lean/RelativeConicArcs/ConferenceCutBlocks.lean`:

- `closedFourWalkSum A K` — the sum of `A i j * A j k * A k l * A l i` over the
  quadruples of pairwise distinct labels in `K`. For a four-element `K` these
  are the twenty-four traversals of its three Hamilton cycles.
- `trace_pow_four` — for a zero-diagonal matrix whose off-diagonal entries
  satisfy `A i j * A j i = 1`,

  ```
  tr(A⁴) = d(d-1) + 12·C(d,3) + Σ_{|K| = 4} closedFourWalkSum A K,
  ```

  with `d` the number of labels. The proof splits the quadruple sum on the two
  conditions `k = i` and `l = j`: the doubly degenerate case counts ordered
  pairs of distinct labels, the two singly degenerate cases each count ordered
  triples of distinct labels, and the remaining sum is regrouped by the
  four-element support of the walk. Symmetry is not used anywhere in it.
- `closedFourWalkSum_labelled` and
  `closedFourWalkSum_eq_eight_mul_fourSetWeight` — on a four-element label set
  the sum is eight times the sum of the three Hamilton-cycle products, that is
  eight times `fourSetWeight` read on any labelling of the set.
- `closedFourWalkSum_eq_twentyFour_or_neg_eight` — for a symmetric sign matrix
  every four-set therefore carries weight `24` or `-8`, from the existing
  dichotomy `w ∈ {3, -1}`.
- `closedFourWalkSum_eq_of_sum_eq` — the exchange-rigidity input. If the label
  set has `2d` elements with `4 ≤ d`, and the four-subset weight sums agree on
  every balanced half, then every four-subset carries the same weight. This is
  the swap descent above at `r = 4`, `m = d`, where the hypothesis `r + m ≤ |X|`
  is exactly `4 + d ≤ 2d`, the manuscript's `d ≥ 4`.

## Independent consistency checks of the constants

Neither check is evidence for the theorem, which is kernel-checked; both were
run to confirm that the formalized constants say what the manuscript display
says.

The all-ones off-diagonal matrix `J - I` on `d` labels has eigenvalues `d-1`
once and `-1` with multiplicity `d-1`, so `tr(A⁴) = (d-1)⁴ + (d-1)`. Every
four-set has all three cycle products `+1`, hence weight `24`. The formula
gives `d(d-1) + 12·C(d,3) + 24·C(d,4)`, and the two agree at `d = 4`
(`84`), `d = 5` (`260`) and `d = 6` (`630`).

The order-six conference matrix normalized at a root has `C² = 5I`, so
`tr(C⁴) = 150`. Its fifteen four-sets: those containing the root have weight
`xy + xz + yz` in the three pentagon signs, which is `-1` for each of the three
edge patterns that occur, and the four-sets inside the pentagon give
`-1 + 1 - 1 = -1`. All fifteen weights are `-1`, so the formula gives
`30 + 240 - 8·15 = 150`. The count of aligned four-sets in that matrix is zero,
which the trace identity forces: `32a - 120 = -120`.

## Validation

- `guarded-lean` on both modules: no errors, no warnings.
- `lean-build-queue.py build RelativeConicArcs.Gates.ClebschGoldenReturn`:
  success. The gate audits fifty-one terminals after the exchange-rigidity
  theorem below is added, and every one of them depends only on `propext`,
  `Classical.choice` and `Quot.sound`, several on strictly fewer. No compiled
  evaluation appears anywhere in the pinned closure.
- Axiom report, source-closure inventory and tracked gate stdout regenerated by
  their committed generators from that build; `golden_return_formal.json` and
  the OPER-3 rows of `passages_formal.json` re-pinned.
- The golden-return replay passes in both source-only and axiom-log modes, and
  the passages and four-shadow replays pass.
- `verify_release.py` passes eighteen checks and fails only its manuscript
  build, which cannot run in this environment at all: `latexmk` is absent from
  both the ambient shell and the Lean development shell. That check was already
  recorded as failing on the tracked PDF before this work, and no Paper III Lean
  work touches it.

## The conclusion, closed the same day

The exchange-rigidity conclusion is also proved, in
`RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`, by a
shorter route than the manuscript's: the fourth-trace count applied to the
whole matrix pins the common four-set weight and leaves only the orders `2` and
`6`, so neither the switching normalization nor `R(3,3) = 6` is needed. The
argument, and an exact proposed manuscript replacement, are in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md`. The support-sorted
count was generalized from the whole label set to an arbitrary subset for that
proof, and `trace_pow_four` is now its corollary at the full set.

## What row OPER-3 still needs

- Every eigenvalue and singular-value statement. `B * Bᵀ = q • 1 - A * A` is
  the algebra behind the exchange spectrum `{1 - α²/q}`, but the passage from
  that identity to squared singular values is not formalized, and with it the
  passage from the fourth trace of a principal block to the second exchange
  moment.

## Extra juice and Tao pass

Done here because it was cheap:

- The fourth-trace count was stated for symmetric sign matrices and is proved
  for the weaker and more natural hypothesis `A i j * A j i = 1`, matching the
  hypothesis the second-trace theorem in the same module already carries.
  Symmetry and unit squares are needed only for the `24`-or-`-8` dichotomy.
- The bridge to `fourSetWeight` was added rather than left implicit, so the new
  count meets the pre-existing four-set weight and its dichotomy inside Lean
  instead of in prose.

Free strengthenings now visible, not taken:

- The descent theorem is proved at every pair of sizes with `r ≤ m` and
  `r + m ≤ |X|`, so cut-independence of the second exchange moment over the
  subsets of *any* fixed size `m` with `4 ≤ m ≤ 2d - 4` already forces the
  four-set weight to be constant. The manuscript uses only balanced halves.
  Stating the stronger hypothesis in the paper costs nothing.
- The same module answers the distance, parity and moment row family's
  inclusion-type inputs if any of them needs one; it is stated for an arbitrary
  set function and does not mention matrices.

## Mystery ledger

- **Where the manuscript's `d ≥ 4` comes from.** Settled by this work, and it
  is less of a constraint than it looks. The descent needs `r ≤ m` and
  `r + m ≤ |X|`; at `r = 4`, `m = d`, `|X| = 2d` both collapse to `d ≥ 4`, which
  is just the requirement that a half be large enough to contain a four-set.
  The hypothesis is therefore forced by the shape of the statement and is not
  an artifact of the Ramsey step later in the proof. The two conditions come
  apart only for unbalanced cuts, where they read `4 ≤ m ≤ 2d - 4`.
- **The order-six conference matrix has no aligned four-set.** Settled by the
  arithmetic above: the trace identity forces the count to be zero, and the
  fifteen weights are individually `-1`. It is a consistency check rather than
  an open question, but it is worth stating because the recognition theorem
  elsewhere in Paper III is about *aligned* four-sets, and at order six there
  are none.
- **Why the Ramsey bound was needed at all.** Settled the same day, in the
  negative: it was not. The manuscript's case split exists because the argument
  works inside one balanced half; summing over the whole matrix instead makes
  the constant computable and both cases collapse to one linear equation. The
  Ramsey bound remains proved and is still used by the aligned-design material.
- **Whether the spectral half is small.** Open. Nothing in the formal surface
  yet touches eigenvalues, and Mathlib's spectral theory for symmetric real
  matrices is the unknown cost. The C815 task card already records that if the
  spectral half proves large it takes a newly allocated task rather than moving
  into C823.

No other genuine mystery arose. The counting constants, the descent bound, and
the eight-fold multiplicity all came out where the manuscript says they do.
