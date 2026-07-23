# C503 / F10 — Lean rank-three arithmetic gluing

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Formalize the bounded arithmetic-gluing theorem used by Paper 1 from C441, C442/C458, C444, C445,
C449, and C460: the frozen A3/B3/H3 reductions, their sheet or fused-fibre actions, the q=11 golden
matching orbit and q=7 silver pair, the stated stabilizer/intersection facts, and the split/inert
trichotomy at `q=5,7,11`.

The preferred route is symbolic finite-field and group-action lemmas plus small checked data leaves.
Classical group names, orthogonal/spinor terminology, and reciprocity language must be isolated
behind exact proved interfaces or cited inputs; they may not be inferred from orders alone.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschArithmeticGluingData.lean`,
  `lean/RelativeConicArcs/ClebschArithmeticGluing.lean`,
  `lean/RelativeConicArcs/Gates/ClebschArithmeticGluing.lean`, this report, and a same-stem
  `.py/.json/.sha256` bundle only if a new normalized certificate is necessary.
- Consume the committed F5/F8 APIs and frozen upstream certificates read-only.
- Exit through `RelativeConicArcs.Gates.ClebschArithmeticGluing`.

## Required theorem boundary

The gate must distinguish:

- literal finite reductions, orbit sizes, sheet swaps, stabilizers, intersections, and generation;
- the exact polynomial root/splitting checks at `5,7,11`;
- any named abstract-group or spinor-norm identification;
- any broader number-field or all-prime statement, which is excluded.

No integral cubic lift, universal cubic-sign readout, or Paper-2 descent mechanism is in scope.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Every finite leaf needs
generator/schema/data/hash provenance, independent replay, a checker-soundness theorem, and an
exact axiom audit. Use only guarded/unattended exact-target builds.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

To be completed during execution.
