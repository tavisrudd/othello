# C994 — Context-clean cold read of compressed AME-LU paper

**Lane:** `ame-lu`
**Status:** complete
**Scope:** review current Paper I authority and repair accepted findings;
no Lean, mirror, push, deposit, or submission action

## Objective

Obtain a context-clean referee read of the current 34-page paper after the
Appendix B structural compression.  Audit theorem correctness, proof
dependencies, sequencing, accessibility for a quantum-information reader,
scope and convention clarity, stale references or advertised results, and
the Appendix A--B--C transitions.  Repair every accepted finding and rebuild.

## Gates

1. Reader receives the PDF and a neutral referee brief, not the edit history.
2. Every mathematical finding is independently checked before repair.
3. Main theorem hypotheses, constants, and generality remain unchanged unless
   a genuine error requires an explicit correction.
4. Warning-free build, release check, rendered inspection of repairs, and a
   recorded final verdict.

## Cold verdict

`MINOR`.  The context-clean reader reconstructed the exact theorem and the
complete cleaning/Fourier/overlap/balanced-cut chain, finding no hidden
`F_q`-linearity, `m=2`, characteristic-two, constant, quantifier, or
existence-scaling defect.  It found four repairable presentation/metadata
issues and no major mathematical error.

## Repairs and dispositions

1. **Accepted — undeclared Appendix B dependency.**  The proof of Theorem
   6.7 used the two-uniform generator isometry in one sentence while claiming
   Appendix B was supplementary.  Section 6 now proves the required estimate
   in place: for `M=sum h_i^(i)`, two-uniformity gives
   `||M psi||^2=D^2/q`, and the path integral for `e^{iM}-I` gives the norm
   bound.  Appendix B is again genuinely unused by the headline theorem.
2. **Accepted — verification-table interruption.**  Table 2 is fixed at its
   source call, so it no longer splits the following sentence across pages.
3. **Accepted — projective qualification.**  Figure 3 now calls its domain
   the projective product-unitary group and states isolation modulo scalar
   phases.
4. **Partly accepted — bibliography.**  Alexander's approximate
   Eastin--Knill paper now has its 2026 `npj Quantum Information` version-of-
   record metadata and DOI.  Visible arXiv locators were added for Albert,
   Bevins--Bidav, and Claudet.  The suggested Bevins--Bidav title replacement
   was rejected: the primary arXiv v2 record still gives the title already in
   the manuscript, *Symmetry-guided constructions of absolutely maximally
   entangled states in five open cases*.

The reader judged Appendix A relevant to the endomorphism-module table,
Appendix B relevant but secondary, and Appendix C useful as transparency
material; no appendix result remains silently load-bearing.  Its optional
suggestion to explain prime-field coordinate mixing was not needed because
the abstract and headline convention already state the full
`Sp_{2e}(F_p)` action and explicitly deny `F_q`-linearity.

Validation passes: warning-free `make check`, `make release-check`, 18 public
artifacts, the pinned 83-artifact formal companion, `git diff --check`, and
rendered inspection of pages 18, 23, and 30--34.  The paper remains 34 pages.
PDF SHA-256:
`92af6e801fba0b2cb7f55a2f5f5541ab8cd055f8d9c07b571485d51903cfa1e4`.
