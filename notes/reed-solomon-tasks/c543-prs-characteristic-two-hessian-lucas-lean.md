# C543 — Lean closure for characteristic-two Hessian and Lucas carriers

**Lane:** `reed-solomon` · **Status:** queued after C539; may proceed independently of C541/C542

## Objective

Formalize the characteristic-two modular layer used by the merged paper: the ordinary-discriminant
failure, ordered divided-Hessian replacement, constrained carrier classification, and the proved
Lucas-carrier arithmetic through the degree-nine `e_7` orbit.

## Required coverage

- C519's doubled-quadric discriminant and Artin--Schreier residual class.
- C525's bidegree-`(2,2)` ordered-Hessian equation, Veronese component, tangent-quadric rulings,
  rank-one complementary-ruling pullback, and persistent/Lucas containment synthesis.
- The exact effective base/deletion/Hasse--Weil implication as visible hypotheses where the
  requisite algebraic-geometry library theorem is absent.
- C529's power-of-two Lucas overlap and linearized-root-cover arithmetic.
- C530's `e_7` additive subcover and exact witness-count synthesis, without claiming completion of
  the other degree-nine carrier strata.

Acceptance requires scholarly-public modules, import gates, scoped builds, exact axiom audits, and
manuscript-ledger reconciliation.  Before any Lean operation, read `lean/AGENTS.md` completely.
