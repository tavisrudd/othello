# C504 / F11 — Lean Witt–Hadamard–Mathieu capstone

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Translate the Paper-1 C452/C464/C469/C470 chain into sound finite checker leaves:

- QR/Barker incidence and the perfect-code substrate used by the paper;
- the twelve full-support projective points and their `1+11` frozen `PSL_2(11)` action;
- all 66 secants and their complete Witt-design shadow;
- parity extension, the exact order-12 Hadamard identity, and minimum-word secant exhaustion;
- the `S(5,6,12)` support design, two degree-12 parent actions, their exact frozen
  `PSL_2(11)` intersection, their join, and the row/column outer hinge.

Use definitions-only data and theorem-bearing checkers. GAP and ATLAS may identify classical names
in the paper ledger, but neither is a Lean axiom.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschWittHadamardData.lean`,
  `lean/RelativeConicArcs/ClebschWittHadamard.lean`,
  `lean/RelativeConicArcs/Gates/ClebschWittHadamard.lean`, and this report.
- Consume C452/C464/C469/C470 scripts, replays, JSON, and manifests read-only.
- Exit through `RelativeConicArcs.Gates.ClebschWittHadamard`.

## Required theorem boundary

The gate must prove literal finite incidence, code, matrix, permutation-action, subgroup,
intersection, join, normalizer, and non-inner-witness statements. It may call a group `M12`,
`M11`, or `2.M12` only if the exact identification is formalized; otherwise export the explicit
finite group properties and leave the classical name to C320's cited-input column. Do not import
C471's operator complex or C472's genuine-Weil claims.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Shard finite data across
module boundaries, retain independent replay, connect every accepted table to its quantified
theorem, and audit every terminal for axioms. Use guarded/unattended exact-target builds only.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

To be completed during execution.
