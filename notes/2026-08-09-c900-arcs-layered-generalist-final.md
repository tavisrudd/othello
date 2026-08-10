# C900 Arcs layered-generalist final gate

**Verdict: NO-GO.**

## Actionable defect

The abstract introduces (KG(k,2)) before giving an operational definition, and the introductory equality-rigidity corollary again relies on “Kneser edge” and “star--matching incidence realization” before the reader reaches the explanation in Section~\ref{subsec:matching-design}.  The abstract does immediately unpack the \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) condition (“every pair of independent edges occurs once”), but it does not say that the vertices of \(KG(k,2)\) are the two-subsets/edges of \(K_k\), with adjacency meaning disjointness.  “Star--matching incidence realization” is likewise not operationally described until the later dual-realization corollary.

This is a headline-layer defect for an adjacent combinatorics/coding reader, not a request for background exposition.  Add one short first-use gloss for \(KG(k,2)\), and either unpack the star--matching realization in the introductory corollary or defer that coined label until its definition.  For example, the needed information is only that secants are vertices indexed by edges of \(K_k\), disjoint endpoint pairs give Kneser adjacency, and after duality shared-endpoint pairs lie on star lines while disjoint pairs lie on matching lines.

## Gate findings

- The object/result/mechanism hierarchy is otherwise clear.  The paper opens with arcs complete outside prescribed holes, states the exact defect identity early, then identifies matching rigidity, stability, and the conic application as consequences.
- The principal defect theorem is self-contained relative to the notation defined immediately before it, and its nonnegative local remainder and equality cases are visible.
- The universal analytic lower bound is clearly separated from the exact finite values.  The introduction distinguishes the kernel-checked \(q=16\) exclusion from the trusted classifiers at \(q=13,17,19\), while the attaining witnesses are separately kernel-checked; the verification appendix preserves these roles.
- The proof map explains the causal mechanism, while the later first-pass paragraph supplies a distinct safe-skip route.  Their jobs do not collapse into one another.
- The coding translation is optional, compact, and explicitly identified as a dictionary rather than a proof input.
- The conic specialization announces its two logical layers; the characteristic-two proof gives a useful branch-level preview before the chord-involution argument; and the finite and verification appendices state what a first-pass reader should retain and where trust changes.
- The conclusion returns to the defect-to-matching mechanism, states the asymptotic limitation, and ends with concrete mathematical questions rather than audit administration.

No other actionable layered-exposition defect emerged from the sequential read.
