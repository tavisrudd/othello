# C900 layered-exposition clean-close

**Verdict: GO.**

Cold adjacent-expert review of the current
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`, using
`papers/style-guide.md` as the rubric. No actionable layered-exposition,
grammar, or mathematical-scope issue remains.

The abstract and introduction proceed in the right order: they define the
arc/relative-completeness problem, state the universal prescribed-hole
identity with all hypotheses and notation, state the fully quantified
\(q+1\)-hole theorem and its definition of \(L_2(q)\), then isolate the exact
small-order claims. Specialized terminology is either given an operational
gloss at first use or is standard finite-geometry vocabulary for the paper's
primary audience.

The proof map explains the four mathematical moves and the bottleneck. The
later reading map instead records dependencies and safe skips; it does not
duplicate the proof map's job. The coding paragraph is visibly optional and
states that the code dictionary is not a proof input.

The evidence boundary is concise and consistent: the structural identity,
rigidity, and stability have ordinary proofs; the order-16 lower exclusion is
kernel-certificate checked; the odd-order lower exclusions are trusted
classifier executions; attaining witnesses are checked separately. The
verification appendix retains those categories without leaking audit detail
into the main proofs.

Section-opening spot checks preserve the hierarchy from universal moments, to
the arbitrary-hole identity, to equality designs, to the conic specialization.
The appendix openings explicitly mark secondary material and its dependencies.
The conclusion returns to the mathematical mechanism and states two concrete
open problems with proved boundaries separated from missing ingredients.
