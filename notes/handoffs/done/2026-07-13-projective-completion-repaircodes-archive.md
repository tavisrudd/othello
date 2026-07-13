# Projectively completed cubic–axis RepairCodes — companion log

Append-only session history for
[`2026-07-13-projective-completion-repaircodes.md`](../2026-07-13-projective-completion-repaircodes.md).
The live handoff contains only the current claim and gate map.

## 2026-07-13 — lane opened

Allocated C111–C114 after a diagnostic q9 enumeration suggested that adding the omitted projective
twisted-cubic point gives a `[20,4,9]_9` seed with two repair types. The q9 numbers and proposed
general formulas remain evidence-only. The strict route is independent refutation, written proof,
Lean proof and axiom audit, bounded-support transfer, exact-claim literature review, then paper
promotion. The supplied 2015 *Open Problems in Coding Theory* survey was checked: it supplies broad
code/design, projective/MDS, and TVZ context but does not discuss locality, repair hypergraphs,
matroid ports, or the twisted-cubic-axis union; its silence is not novelty evidence.

## 2026-07-13 — C111 parameter slice

Added `FiniteGeom/ProjectiveAxisTwistedCubic.lean`. The proof explicitly separates finite cubic
parameters from cubic infinity. If infinity lies in the plane, the finite section reduces to a
degree-two moment-curve section; if the plane contains the axis, Frobenius injectivity and the
finite/infinity cross-case give at most one projective cubic point. The maximum section remains
`q+2`, the length is `2q+2`, and the module derives dimension four and distance `q`.

Focused validation:

```text
choom -n 1000 -- nix develop --command lake env lean \
  FiniteGeom/ProjectiveAxisTwistedCubic.lean
```

passes. `#print axioms` for the full-cubic section bound, completed-system section bound, and
bundled code parameters reports only `propext`, `Classical.choice`, and `Quot.sound`. C111 remains
open: projective distinctness, dual distance, independent small-field replay/mutations, aggregate
wiring/build, scans, and xhigh review are not yet done.
