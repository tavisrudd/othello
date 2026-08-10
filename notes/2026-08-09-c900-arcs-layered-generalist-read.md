# C900 layered-exposition generalist read

**Verdict: MINOR**

Cold-reader profile: adjacent expert in combinatorics/coding, not a finite-geometry specialist. I read the current manuscript sequentially and assessed only the first-pass route against `papers/style-guide.md`.

The route is complete. The introduction supplies the object and question, states the universal prescribed-hole theorem before its conic application, explains the two-moment remainder in plain language, separates the proof map from the later reading map, and gives safe stopping points. Section openings orient the reader before the equality-spectrum, characteristic-two, and finite-classification arguments. The introduction and verification appendix also distinguish ordinary proof, an external classification, kernel-checked finite certificates, and trusted executions. The conclusion recalls the conceptual bridge without replaying the paper. I found no route-breaking defect.

## Exact actionable findings

1. **First friction: the abstract introduces the discipline-interface notation before its operational meaning (lines 47--50).** `KG(k,2)`, `MATCH(k,\lfloor k/2\rfloor,1)`, and “rank-three projective realization” arrive in one sentence, while the definition that a MATCH design is a family of maximum matchings in which every pair of disjoint edges occurs exactly once appears much later. Replace or follow the notation in the abstract with that one-clause operational gloss; the symbols can then remain for specialists.

2. **Separate the analytic theorem from the finite classifications in the introductory theorem hierarchy (lines 169--195).** `thm:main-conic` currently joins the universal (q+1)-hole lower bound and asymptotic consequence to four exact values whose lower bounds have different evidence roles. Split lines 183--187 into a separately named introductory theorem (or corollary) for the exact small orders, leaving `thm:main-conic` purely structural. Keep the existing trust paragraph immediately after the two statements. This makes the logical/evidential separation visible in the theorem architecture rather than only in prose after the combined theorem.

No other first-pass revision is required by the requested criteria.
