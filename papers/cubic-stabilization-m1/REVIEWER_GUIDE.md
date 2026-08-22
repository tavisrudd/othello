# Reviewer guide

This guide gives a short route through the proof of *Irrationality of Cubic
Threefolds after One Stabilization* and identifies the boundary between the
written argument, cited inputs, formal deductions, and computational evidence.
The two papers under `companions/` are logically separate and are not needed
for this route.  The conditional all-stabilization manuscript is not part of
this repository's primary theorem.

## Suggested reading

Start with the theorem and four-paragraph proof overview in
[`sections/01-introduction.tex`](sections/01-introduction.tex), through the
discussion following `thm:every-cubic`.  Then read the one-blowup model at the
start of [`sections/02-qdm-marker.tex`](sections/02-qdm-marker.tex).  It gives
the concrete invariant before the categorical ledger.  The remainder of that
section contains the complete proof.  The consequences in
[`sections/03-applications.tex`](sections/03-applications.tex) may be skipped
on a first pass.

## For referees

The shortest route through the central argument is:

1. **The additive ledger.** Starting from the generalized eigenspaces of Euler
   multiplication, `prop:generic-spectral-connection-splitting` upgrades the
   separated leading decomposition to formal connection blocks.
   `thm:marker-ledger` shows that an additive marker of those blocks is
   birationally invariant once every actual center occurrence contributes
   zero.  The occurrence index is essential: repeated copies of the same
   center are not silently identified.
2. **The operation formulas.** `lem:faithful-center-base-change` restores the
   curve-class information lost by the raw center Novikov map.
   `prop:qdm-operation-ledgers` then places Iritani's blowup comparison and
   Iritani--Koto's projective-bundle comparison in the ledger.  Check here the
   common coefficient fields, restriction to the even carrier, regularity in
   $z$, grading shifts, and separate center occurrences.
3. **The marker.** By `lem:A0preserve`, the only possible new pole in the
   elementary modification vanishes, so the modified rank-two square-zero
   block is regular.  `prop:rank2-rigidity` proves that its
   modified residue moves by conjugation, and
   `prop:residue-discriminant-exponents` identifies its eigenvalues modulo
   $\mathbb Z$ with the formal exponent classes.  The fold marks distinct
   exponent classes; a merely nonzero residue discriminant would also mark
   resonant blocks and is not enough.
4. **Cubic detection.** `prop:cubic-block-data` derives the small even block
   from Beauville's three displayed quantum products.  The zero block has
   exponent representatives $-1/6$ and $-5/6$, so their difference is
   $2/3$ and the cubic marker equals one.
5. **Center nullity.** `prop:atomic-lowdim` proves that the marker vanishes on
   every point, curve, and smooth projective surface, including every actual
   comparison occurrence.  The surface step separates nef-canonical surfaces,
   projective space, ruled surfaces, and point blowups; this is the
   load-bearing geometric exclusion for fourfold weak factorization.
6. **The contradiction.** The projective-bundle formula gives marker value two
   on $X\times\mathbb P^1$, while the generic quantum product of
   $\mathbb P^4$ is semisimple and has marker zero.  Applying
   `thm:marker-ledger` and `prop:atomic-lowdim` to a hypothetical rationality
   factorization proves `thm:every-cubic`.

## Proof and evidence boundary

The manuscript gives a written proof of every step above.  Its imported inputs
are recorded with source pinpoints and recorded convention matches in
[`verification/imported-sources.json`](verification/imported-sources.json):
in particular weak factorization, Beauville's cubic quantum products,
Iritani's blowup comparison, Iritani--Koto's projective-bundle comparison,
regular-singular classification, and the classification of minimal surfaces.
The headline theorem uses no computational evidence bundle.

For the primary paper, this repository's Lean 4 companion, built against
Mathlib, records no claim as complete:
five are strict fragments, nine are conditional deductions, and
`lem:faithful-center-base-change` is absent.  It checks the effective ledger
and occurrence-indexed telescope, parts of the rank-two residue matrix algebra,
and the final implications from explicit typed premises.  It does not
formalize the regular-singular identification of residue eigenvalues with
formal exponent classes, faithful center base change, the geometric QDM
comparisons, weak factorization, or low-dimensional geometric nullity.  These
inputs occur as theorem hypotheses rather than Lean axioms.  The primary-paper
entry point is
[`PaperInterface/Main.lean`](lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/PaperInterface/Main.lean).
Exact claim coverage and limitations are recorded in
[`claims.json`](lean/verification/claims.json), and the expected kernel-reported
dependencies are pinned in
[`expected_axioms.txt`](lean/verification/expected_axioms.txt).

From this directory, `make check` validates the source-level
manuscript-to-claim correspondence, rebuilds the PDF in the pinned environment,
and rejects TeX warnings.  It does not build Lean or replay a captured axiom
audit.  This guide does not provide a standalone formal replay command.
[`lean/README.md`](lean/README.md) explains the artifact and checker semantics;
the complete registry semantics are in
[`verification/README.md`](verification/README.md).
