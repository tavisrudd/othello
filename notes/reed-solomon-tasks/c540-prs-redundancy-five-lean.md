# C540 — Lean closure for PRS redundancy five

**Lane:** `reed-solomon` · **Status:** queued after C539

## Objective

Formalize the paper-facing redundancy-five theorem boundary: the Hankel-pencil criterion,
exceptional-cover case split, family/orbit/count synthesis, and checked sporadic inventory.

## Required coverage

- The characteristic-free `2 x 4` Hankel-pencil criterion and split-squarefree witness semantics.
- The tangent, conjugate-secant, osculating-pair, characteristic-three nucleus, and wild
  Artin--Schreier family synthesis at their exact hypotheses.
- A finite certificate interface checking the complete sporadic tables for
  `q in {7,8,9,11,13,17,19}` and their absence in the certified comparison band.
- Exact total-count and `PGL2/PGammaL2` orbit consequences.
- Seroussi--Roth completeness, Aubry--Perret, and any unformalized cover classification remain
  precisely named external hypotheses with stable citations, never hidden axioms.

Acceptance requires kernel-checked symbolic algebra and certificate semantics, an import-only gate,
an exact axiom audit, and manuscript ledger reconciliation.  Before any Lean operation, read
`lean/AGENTS.md` completely.
