# C1016: theory for discovering useful residual structure

This is a prioritized reading/experiment plan, not a completed literature audit
or novelty claim. Sources were checked at abstract/catalog level on 2026-09-11;
full proofs and applicability must be read before implementation relies on them.

The measured discriminator is recovery near 14,800 in a randomized state from
that known-containing margin fibre. Small complete neighbourhoods and several
barrier policies have failed this gate. Connectivity alone is not efficient
descent. Witness coordinates must not guide region selection.

1. **Exact local branching / large-neighbourhood repair.** Select a bounded
   variable region from residual-constraint incidence, freeze its complement,
   retain exact margins and solve the restricted improvement problem exactly.
   General reusable output: a valid coordinated repair, or a scope-bound proof
   that this region cannot improve. Never turn a timeout into an exclusion.
   Fischetti–Lodi, Local branching (2003):
   https://publications.polymtl.ca/25914/
2. **Markov/Graver bases and bounded integer fibres.** Derive admissible
   coupled moves from the linear invariant matrix rather than hand-growing
   rectangle/cycle templates. Distinguish connectivity from objective descent.
   Graver convex-augmentation guarantees do not automatically cover our quartic
   correlation objective; use the machinery as checked proposal generation.
   Diaconis–Sturmfels:
   https://statistics.stanford.edu/technical-reports/algebraic-algorithms-sampling-conditional-distributions
   Hemmecke–Onn–Weismantel: https://arxiv.org/abs/0710.3003
3. **Logic-based Benders / CEGAR between quotient and lift.** Exact failed lift
   subproblems may yield necessary constraints on the quotient interface. Keep
   frozen-variable assumptions explicit; a local failure does not exclude an
   entire shell. Heuristic plateaus yield ordering evidence only.
   Hooker tutorial: https://johnhooker.tepper.cmu.edu/bendersTutorial2016.pdf
4. **Polynomial/moment relaxations on small residual regions.** Look for bounds
   and coordinated directions invisible to marginal energies. Begin locally,
   not with a dense global SDP. Numerical suggestions need exact checking;
   proof cuts require a checked certificate.
   Laurent: https://ir.cwi.nl/pub/13237/
5. **SAT+CAS complementary-sequence practice.** Read for compression/lift
   interfaces and proof-producing filters. Do not transfer Williamson symmetry
   or other construction assumptions into unrestricted bordered SDS search.
   Bright–Kotsireas–Ganesh: https://arxiv.org/abs/1804.01172

Priority: exact bounded repair informed by integer-fibre geometry, then checked
lift explanations. Compare against size-matched random regions at matched CPU
budgets, using held-out seeds/shells. Accept a general region-selection rule
only on transfer evidence, not one fortunate trajectory. The known 14,800
witness supplies an evaluation threshold only, never a coordinate template.
