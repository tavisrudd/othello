# C924 — rigorous audit of the direct quantum-D-module route

**Lane:** `cubic-threefolds`

**Status:** completed 2026-08-19

**Objective:** decide whether the proposed direct quantum-`D`-module proof in
`/home/tavis/Downloads/direct_qdm_proof_packet_unified_stronger.md` proves the
one-stabilization irrationality theorem claimed by the cubic-stabilization
epilogue.

## Scope and order

This is a mathematics-only task.  It makes no paper edits.  Before auditing any
proof step, read the complete existing epilogue, the complete direct-QDM packet,
the related research memo
`/home/tavis/Downloads/stable_irrationality_qdm_atom_monodromy_research_memo.md`,
and the complete source material on which the proposed route relies.

After that prerequisite read:

1. reconstruct the route as a dependency graph with exact hypotheses,
   conventions, coefficient fields, and categorical functoriality;
2. check every imported theorem against its original statement and every
   internal deduction line by line, separating proved facts, standard lemmas,
   calculations, and unsupported assertions;
3. stress-test base change, formal decomposition, monodromy, blowup and
   projective-bundle formulas, weak factorization, and the final stable
   birational inference, using Lean only for sharply isolated algebraic steps
   when useful;
4. issue a rigorous verdict with a minimal repair list for every gap; and
5. only if the route is verified, identify simplifications or safe compression.

## Acceptance gate

- A durable report at `../2026-08-19-c924-direct-qdm-proof-audit.md` gives a
  claim-by-claim verdict and exact source locations.
- Every load-bearing citation has been checked against the primary source,
  including hypotheses and conventions.
- Every logical bridge from the quantum connection to the stable irrationality
  conclusion is either proved or marked with an exact gap; plausibility is not
  counted as verification.
- Any computational or Lean cross-check has a bounded, reproducible statement
  and is not substituted for the surrounding mathematics.
- No simplification/compression proposal is made until the proof itself has
  passed this gate.

## Non-ownership

This task does not edit either stabilization manuscript, their mirrors, or the
existing Lean companion.  Any later promotion requires a separate instruction
and the owning task's normal gates.

## Outcome

The route is mathematically verified after one local coefficient-spine repair:
the projective-bundle comparison must pass through the common faithful ring
`C[q][[Q,t]]` used by Iritani--Koto, rather than a nonexistent map from the
full `q`-adic completion to the opposite Laurent completion.  Two minor
proof-text corrections and the complete claim-by-claim audit are recorded in
[`2026-08-19-c924-direct-qdm-proof-audit.md`](../2026-08-19-c924-direct-qdm-proof-audit.md).
The report also gives the exact finite-algebra replay and the safe even-only
compression.  No paper or Lean source was edited.
