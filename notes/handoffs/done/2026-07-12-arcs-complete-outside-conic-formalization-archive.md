# Arcs complete outside a conic formalization — archive

Append-only companion to
[`../2026-07-12-arcs-complete-outside-conic-formalization.md`](../2026-07-12-arcs-complete-outside-conic-formalization.md).
The live handoff holds current state; dated session notes, validation output, superseded plans, and
closed-negative proof routes belong here.

## 2026-07-12 — dedicated spinoff lane created

- Allocated C89–C96 for the isolated incidence foundation, moment equations, defect identity,
  conic lower bounds, asymptotic theorem, projective averaging, even-characteristic nucleus facts,
  and certified small examples.
- Chose a standalone `lean/RelativeConicArcs/` library with one-way reuse from existing Lean code;
  existing projective-cap/game libraries are not consumers of the spinoff.
- Read the manuscript README, theorem statements, proof audit, current Lean trust document, existing
  projective-cap abstractions, and the live handoff/task-queue conventions before fixing the plan.
- Set the trust boundary to kernel-checked elementary claims plus named hypotheses for deep external
  inputs. In particular, the Kim–Vu corollary will not introduce a global axiom.
- Split the implementation into abstract incidence, coordinate conic, analytic, averaging/nucleus,
  and rules-only certificate layers so each headline claim has a legible axiom profile.

## 2026-07-12 — C89 incidence foundation and coordinate bridge landed

- Reused pinned Mathlib's `Configuration.ProjectivePlane` instead of creating a competing incidence
  structure. Its existing API supplies unique joins/intersections, plane order, uniform line size,
  `q²+q+1` point count, and the dual-vector coordinate plane instance.
- Added the standalone `RelativeConicArcs` Lake target and modules `Plane.lean`, `Arc.lean`, and
  `ProjectiveBridge.lean`; no existing Lean target imports the spinoff.
- Formalized arcs, secants, point indices, prescribed required/covered/uncovered loci, relative
  completeness, and `rho`. A maximal-cardinality admissible arc proves that complete relative arcs
  always exist; `Nat.sInf_mem` then proves `rho` is attained.
- Proved the coordinate plane has order `Fintype.card K` and proved incidence `Arc` equivalent to
  `ProjectiveCap.Projective.Cap`. The bridge reduces coordinate collinearity to a `3×3` determinant
  and uses Mathlib's projective cross product for the unique common line.
- Validation: `nix develop --command lake build RelativeConicArcs` completed successfully with 3010
  jobs and no source warnings. A separate `lake env lean` audit printed
  `[propext, Classical.choice, Quot.sound]` for `card_points`, the uncovered characterization,
  maximal completion, attained `rho`, coordinate order, and cap compatibility. A source scan found
  no `sorry`, `native_decide`, `admit`, or custom `axiom`.
