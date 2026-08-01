# C745 — Paper III current-theorem Lean formalization

**Lane:** `clebsch`

**Status:** queued and unblocked by C744

## Objective

Bring the Paper III Lean companion up to the structural theorem surface frozen
by C744.  Formalize the mathematical mechanisms used by the polished human
proofs, not certificate-shaped restatements of displayed coordinates, and
produce one exact current-paper gate with a declaration-level claim map.

## Dependency and boundary

C744 has frozen the proof architecture, definitions, normalizations, marking
datum, and statement correspondence.  Before any Lean operation, read
and follow `lean/AGENTS.md` and use its serialized build, resource, validation,
and exit protocols.

Reuse the public mechanisms from C664/C685 and the conference/triangle source
from C712.  Do not pull Paper IV's middle-exterior or later golden-shadow
theorems into the current-paper gate merely because those modules already
exist.  Public extraction and tagging remain with C287 after this task freezes
and validates the exact source closure.

## Work package

1. Freeze a five-row theorem map for `ARITH-1`, `ARITH-2`, `ORIENT-1`,
   `HARM-1`, and `HARM-2`, with an explicit correspondence theorem between
   manuscript definitions and Lean definitions before claiming coverage.
   Import C744's degrees-of-freedom and magic-number ledger as a formalization
   checklist: every choice and coefficient must appear as a parameter,
   quotient, invariance theorem, or derived constant rather than hidden data.
2. Build the reusable quadratic-cover layer required by C744's proof:
   involution/trace splitting, anti-invariant rank-one summand, multiplication
   law, branch section, and the normalization or Stein interface actually used
   in the paper.  Do not substitute the scalar factorization for the global
   scheme statement.
3. Formalize the golden quadratic algebra, Clebsch chart pullback, component
   factorization, deck action, fibre and conductor interfaces, and the exact
   characteristic hypotheses retained by C744.
4. Define the complete marked bridge datum.  Prove switching and relabelling
   covariance, chart-scaling behavior, and the Galois/deck sign actions.
   Formalize the fibrewise exchanger comparison
   without claiming that a sheet reconstructs the auxiliary marking.
5. Formalize the structural `[5]`/`[2]` torsor or normalizer theorem and derive
   the displayed spinor specialization as a corollary.  Literal matrices may
   remain only as audited witnesses after the conceptual theorem is present.
6. Formalize the Petersen pair-sum comparison, explicit zonal Gram identity,
   multiplicity-one cubic line, and exact Gaunt normalization using C744's
   compressed derivation.  Prefer invariant moment and representation
   arguments to enumerated coefficient tables.
7. Create a current-paper import gate, exact axiom audit, source/hash manifest,
   paper-local replay, and clean pinned-toolchain validation.  Report every use
   of native evaluation, generated input, external computation, classical
   axiom, or unsafe feature; reject `sorry` and undeclared axioms.
8. Update the paper trust surface only after the formal declarations and
   correspondence map pass.  Preserve `none claimed` for any statement not
   actually represented at its manuscript strength.
9. Run the required `ej` and Tao-style closeout passes after the acceptance
   gate, perform cheap structural generalizations exposed by the formal proof,
   and record the exact remaining evidence boundary without inventing one.

## Acceptance

- The current-paper gate contains exactly the Paper III closure and no Golden
  paper spillover.
- Every claimed formal row matches the manuscript statement in hypotheses,
  field, marking, normalization, and scheme-theoretic strength.
- Every scalar, sign, labeling choice, denominator, and exceptional prime in
  the formal surface has a named derivation or invariance statement; Lean does
  not merely verify unexplained literal constants inherited from a replay.
- The proof terms expose the structural mechanisms frozen by C744; native
  decision or finite data do not replace a conceptual theorem.
- The source build, exact-target freshness check, axiom audit, paper-local
  replay, and clean-checkout validation are green under the pinned toolchain.
- The paper and formal manifests name every covered declaration and retain an
  honest boundary for anything not covered.
- C287 receives a reviewed, content-addressed closure suitable for a later
  incremental `finitegeom` tag.
