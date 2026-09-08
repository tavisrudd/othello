# Cubic pair: four targeted proof and statement repairs

**Date:** 2026-09-08. **Lane:** cubic-threefolds. **Tasks:** C978/C956 remain open.
**Authorization:** the author supplied four prioritized edits A–D after export.
**Status:** all four edits implemented and exported. Both authority and mirror
gates pass; rendered pages inspected and paired PDFs byte-identical.

1. **Quotient section:** replace generic injectivity as a purported
   characteristic-free birationality criterion by the supplied isomorphism on
   the tangent-projection open. Since C is closed in Z, its intersection with
   that open maps to a closed subset of the image open. It lies in the indicated
   irreducible linear space with equal dimension, and hence equals the linear
   space intersected with the image open. Thus the restriction identifies dense
   open subsets. No perfectness or separability assumption is added to the
   infinite-field theorem.
2. **Selected subspaces:** attribute descent to Galois stability and the
   integral-basis condition to determinant one in separate sentences. The
   subsequent free-orbit argument is unchanged.
3. **Threefold criterion:** state positive I_lat as the sufficient condition,
   with I_exp positivity as an immediate special case. The proof uses the
   intrinsic lattice-count formulas and surface-center vanishing. Projective
   four-space has no rank-two primary summands, so its lattice count is zero;
   this avoids citing the exponent-only displayed endpoint as if it already
   stated the stronger equality. The unstabilized irrationality consequence
   remains in the corollary.
4. **Both spectral extensions:** give an explicit second clause for the lattice
   spectrum and its scalar augmentation in each numbered statement. Define its
   monoid, group target and augmentation beside its existing definition. The
   proof explicitly applies the constant-field and regular-lattice argument
   with either exclusion rule, and repeats the additive construction with the
   corresponding target. The original exponent notation remains usable later.

The three altered Paper 1 statement digests were refreshed only after their
claim records were reviewed. The threefold criterion remains fragmentary and
the two spectral statements remain absent; no Lean declaration or coverage
upgrade is claimed. The dependency graph now records the intrinsic formulas
used by the strengthened corollary. No Lean kernel is run.

## Validation

Both authority `make check` gates pass (2026-09-08):

- `make -C papers/cubic-stabilization-m1 check`: source/claim checks, exact
  residue replay and clean PDF build; 20 pages, 189078 bytes.
- `make -C papers/cubic-stabilization-irrationality check`: source/metadata
  checks, slice and rank-four certificate replays and clean PDF build;
  19 pages, 176145 bytes.
- Rendered affected pages inspected: Paper 1 pages 13, 16–17; Paper 2 pages
  5 and 7. No clipping or layout defect; neither paper gained a page.
- `git diff --check` passes. Both standalone `make check` gates also pass.
- Authority commit: `f879abf24`. Ordinary local mirror commits:
  `43b1c2c` (one-stabilization), `d06806d` (sharpness).
- Export plans and audits had zero findings; post-build, post-commit
  verification passes and both mirror worktrees are clean. Paired authority
  and mirror PDFs are byte-identical. No push was performed.

| Paper | Export content SHA-256 | PDF SHA-256 |
|---|---|---|
| One-stabilization | `bfedb6eca5e2b3d353e771b773bd33d9899becee820123f187733aef132e1819` | `6ee4f570d5954262dff595b260900d2dda058a1560e9921f122c433647928ffe` |
| Sharpness | `58628aef12045fa3b03b1fd2232572808c8766ba0a4df4f1845ab56f2d6e5da3` | `77bdc33b24d0fc4b84c6c7f5d5c69253d61e3c9357ed62f286906e609b7eb965` |

 The edits retain the accepted coefficient
comparison, persistence and torus construction; no earlier exposition request
is reopened and no computational certificate is changed.

## ej + tt and Mystery ledger

The focused closeout checks are whether A silently requires separability and
whether C/D silently treat exponent-only exclusions as lattice statements.
The dense-open isomorphism resolves the first in every characteristic allowed
by the theorem. The explicit lattice endpoint and the argument-level use of
the constant-field lemma resolve the second. No new mathematical mystery or
incidental observation arose: these are the exact issues the author asked to
repair. The broader author-retained review obligations remain C978/C956.
