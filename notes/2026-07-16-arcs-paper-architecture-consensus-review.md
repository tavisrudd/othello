# Arcs paper: architecture consensus review

## Inputs

Two fresh sequential Sol reads and one Fable referee-style review agreed that
the manuscript's mathematics was strong and that its remaining weakness was
global architecture rather than correctness. The common recommendation was to
make the prescribed-hole defect identity the unmistakable centre, keep the
lower/upper-bound geometry contiguous, and move the coding dictionary beside
its only substantial application at q=11.

## Disposition

The 2026-07-16 revision:

- orders the main route as moments, defect, conic lower bounds, projective
  transfer, nucleus refinements, and finite values;
- moves the coding dictionary to a late section shared with the q=11
  application;
- shortens the abstract and sharpens the new-versus-classical paragraph;
- introduces the general uncovered-locus notation once;
- expands the central substitution in Theorem 3.1;
- numbers the polynomial estimate as Lemma 4.2;
- fixes the quantifier order in the q=16 augmentation contract;
- states the q=16 proof architecture and trust boundary before the certificate;
- connects the q=11 maximum-index table entry to the stability criterion; and
- makes Appendix C self-contained about witness-checking provenance.

The nucleus section remains standalone because it is a genuine geometric
refinement and now no longer interrupts the lower/upper-bound sequence. The
q=11 extension complex remains in the main paper but is explicitly secondary.
The sole unresolved release gate is a permanent archived identity for the
supplement and the exact release commit corresponding to the manuscript.

## Significance follow-up

A subsequent referee concern was that the conic parameter was self-introduced
without demonstrated external demand. The manuscript now observes that a line
at infinity specializes the same framework to complete affine arcs, and cites
the established hyperfocused-arc/secret-sharing literature where completeness
off a distinguished line occurs explicitly. Corollary `cor:affine` records the
exact line-hole bound and equality pattern. The introduction also states the
already formalized MDS interpretation as confinement of projective
distance-three syndrome directions. The sharper `O(sqrt(q))` construction or
infinite-family obstruction is queued as a post-submission theorem program.
