# C935 — Elliptic two-division discriminant resolvent

**Lane:** `cubic-threefolds`

**Date:** 2026-08-21

**Status:** complete; report `../2026-08-21-c935-elliptic-two-division-resolvent.md`

## Goal

Audit the supplied “Proof Packet 01 — Upgrade” against the authoritative
`m = 1` manuscript and determine which parts materially strengthen the paper.
The central proposed statement identifies the exotic two-sheet complement in
the five-sheet principal-gluing packet with the sign, or discriminant,
resolvent of the relative elliptic two-division cover.

## Scope and ownership

- Authoritative manuscript: `papers/cubic-stabilization-m1/`.
- Task records: this card, one dated C935 report, the lane handoff, live queue,
  archive on completion, and the lane discovery track if an incidental finding
  meets its discriminator.
- Literature evidence: the shared persistent cache and a durable audit record.
- No all-`m` claim, Gamma-row claim, mirror synchronization, public release, or
  Lean edit follows from this task without a separate gate.

## Gates

1. Verify that the manuscript proves the relative elliptic source and the
   five-sheet packet with monodromy acting through `GL_2(F_2)`.
2. Prove or refute, at the correct scheme/stack level, that the complementary
   two-set is canonically the orientation torsor of the rational three-set.
3. State the discriminant equation invariantly, including characteristic and
   Hodge-line hypotheses; avoid presenting `u^2 = Delta_E` as a global scalar
   equation without a chosen differential.
4. Check separately whether the programme base is actually identified with a
   level-three modular curve.  If only a pullback statement is justified, keep
   the universal `Y_0(3)` theorem out of the paper's main theorem.
5. Verify the subgroup, cusp, genus, Galois-closure, and eta-quotient claims.
6. Run a literature audit proportionate to any novelty or priority sentence,
   with read depth and coverage recorded for every named source.
7. If the upgrade survives, integrate the smallest theorem/corollary package
   that strengthens the paper without distracting from its `m = 1`
   irrationality argument; update its claim/evidence surfaces and validate the
   manuscript through the guarded project entry points.
8. After the acceptance gate, run the required `ej` + `tt` closeout pass and
   record a mystery ledger in the dated report.

All gates are discharged at the scope recorded in the report.  The universal
modular diagram is verified but not promoted as an identification of the cubic
period curve; that stronger curve-level theorem is separated as an unallocated
companion-note candidate.

## Initial risk assessment

The finite `S_3`-set statement is elementary and likely unconditional.  The
load-bearing risks are global: the exact base carrying the relative elliptic
scheme, the distinction between coarse `X_0(3)` and stack-level
`Gamma_1(3)`/`Gamma_0(3)` data, and whether the eta square root descends with
the claimed rational normalization.  These claims must not be bundled.
