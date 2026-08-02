# C801 — Paper II fixed-line Lean update

**Lane:** clebsch

**Status:** complete on 2026-08-02; table-free radial inheritance, sheet-sign trade line, and
`q-2` count are kernel-checked and integrated into the Paper II gate and trust surface

## Goal

Formalize the reusable algebraic core of Paper II's fixed-line ambiguity and
Chow-rigidity level-up without encoding an eleven-orbit table.

## Scope

1. State an abstract two-sheet radial-translation theorem: the top
   configurations and their first and second moments stay fixed, while the
   outer radial constant changes affinely with nonzero slope.
2. Deduce that every noncoalescent parameter inherits the hypotheses and
   conclusion of Radical--Hadamard recovery, hence has the unique sheet-sign
   quadratic trade.
3. Prove the finite-line count giving one matching parameter, one excluded
   coalescence parameter, and q-2 nonmatching exact-trade parameters.
4. Keep the unique Chow intersection on the human side unless a genuinely
   reusable unique-factorization/block-system lemma is cleaner than the prose
   proof; do not formalize orbit representatives or an eleven-row census.
5. Extend the guarded Paper II gate, axiom audit, trust map, and paper-local
   Lean mirror after C798 freezes the exact manuscript statement.

## Acceptance

- No sorry, new untracked axioms, native_decide, or table enumeration.
- The formal theorem matches the frozen manuscript hypothesis boundary.
- The guarded Paper II Lean gate and aggregate verifier pass.
- Axiom and statement-identity reports are regenerated before any standalone
  synchronization.

## Ownership

C801 owns the Lean additions and their Paper II trust integration. C798 owns
the human fixed-space, normalizer, block-system, and Chow-intersection proof.

## Closeout

Implemented in `RelativeConicArcs.ClebschFixedLineRadialTranslation`; the complete report is
`notes/2026-08-02-c801-paper-ii-fixed-line-lean.md`.
