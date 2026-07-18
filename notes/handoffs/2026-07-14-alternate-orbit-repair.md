# Alternate-orbit repair for invariant ten-arcs

**Lane**: `alt-orbit-repair` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-18
**Status:** OPEN — C142, C143, C148–C150 reported; C151's universal normalized-row lower bound and
five-row attainment are checked. The residual-orbit layer is certified: the parameter group, its
action, the five orbit sizes, their disjointness, and the union `1600` are kernel-checked. The
semantic normalization lift is now checked, so `≥ 32` holds for semantic invariant eight-arcs.
Equality-orbit exhaustion is the sole remaining step
**Tasks:** C142–C143, C148–C152, C318–C319

Companion discovery log:
[`../2026-07-18-alt-orbit-repair-discovery-track.md`](../2026-07-18-alt-orbit-repair-discovery-track.md).

> **LIVE-DOC WARNING — DO NOT LOG HERE.** This file is only the lane's current-state map. Never
> append session history, build timings, validation transcripts, dated progress, dead ends,
> superseded plans, or amendment trails here. Put every such entry in
> [the companion archive](done/2026-07-14-alternate-orbit-repair-archive.md), then rewrite this file
> cleanly to show only the surviving state and next actions.

## Lane scope

This is the sticky `alt-orbit-repair` lane. Until the user explicitly switches lanes or this
handoff is finished, `go` and `next?` refer to the next C151 step below.

### Allowed paths

- alternate-repair modules under `lean/FiniteGeom/BaerCompletion/` and
  `lean/RelativeConicArcs/`
- the quadratic pair-count and Q25 profile modules needed to state or prove the repair results;
  generated Q25 certificate sources only under C143/C151
- `notes/2026-07-14-c142-*` through `notes/2026-07-14-c152-*`, this handoff, and its companion
  archive
- this lane's rows in `notes/2026-07-07-codex-task-queue.md` and its routing row in `CLAUDE.md`
- `papers/equivariant-robust-completion/` and its index/planning rows only after the corresponding
  theorem and trust gates pass

### Foreign lanes

The closed `baer` lane supplies pair-counting and Q25 extension theorems but does not own this
deliverable. Build-system, Clebsch, cap, cubic, relative-conic, RepairCodes, Queens/Othello, and
their working-tree changes remain foreign. Do not edit, stage, or commit their files here.

## Goal

Prove robust equivariant repair for Frobenius-invariant arcs: after deleting a selected nonfixed
conjugate orbit, replace it by a different legal conjugate orbit. The general theorem and the Q25
existence/multiplicity theorem are reported. The active strengthening is the exact exceptional-Q25
minimum of 32 legal pairs and the classification of equality cases.

## Current theorem map

- **General repair:** for every prime power `s ≥ 7`, deletion from an invariant ten-arc leaves at
  least eight alternate repairs; the exact profile envelope strengthens the uniform bound to 318.
- **Parameterized exchange:** if
  `floor((k-1)^2/4) + r + 1 ≤ s(s-1)/2`, deletion from an invariant `(k+2)`-arc leaves at least `r`
  alternate repairs, with the reported sharp rectangle `s ≥ 4`, `k ≤ s+1`.
- **Q25 exceptional profile:** all 1,189 residual class representatives have a kernel-checked
  lower bound of 32, and five proposed minimizer representatives have checked equality.
- **Residual orbits:** the parameter group, its `MulAction`, the five orbit sizes
  `200,400,400,200,400`, their pairwise disjointness, and the union `1600` are kernel-checked
  through orbit–stabilizer against decided stabilizer orders; no orbit is materialized.
- **Semantic lower bound:** `f2_card_globalLegalPairs_ge_32` carries the normalized-row `≥32`
  theorem through both projective normalizations to every invariant eight-arc in `PG(2,25)` with
  exactly two fixed points.
- **Remaining exactness gap:** prove that the five certified orbits exhaust the rows attaining 32.

Reported theorem and scout details live in their reports:
[C142](../2026-07-14-c142-alternate-orbit-repair.md),
[C143](../2026-07-14-c143-q25-alternate-orbit-repair.md),
[C148](../2026-07-14-c148-general-s-profile-envelope.md),
[C149](../2026-07-14-c149-parameterized-robust-exchange.md), and
[C150](../2026-07-14-c150-q25-multiplicity-structure.md).

## Current discovery frontier

This table is a state register, not a diary. Historical observations and how they arose belong in
the companion archive. `LEAN-CHECKED` means kernel-checked; `COMPUTE-CHECKED` means independently
computed but not yet promoted through the complete semantic theorem.

| ID | Surviving finding | Status | Active use |
|---|---|---|---|
| D-AOR2 | Orbit replacement gives a token-jumping-style graph on embedded invariant ten-arcs, fibered by the exact fixed-point subset. Dye's shared-triangle graph is a predecessor with different adjacency. | local profile inputs checked; graph theorem open | C152: prove neighbor injectivity and the degree identity before any connectivity claim |
| D-AOR4 | The 469,600 exceptional-profile arcs form 1,189 classes under the order-400 ordered-fixed-pair group; the 1,600 computed minimizers form five classes. | representative equalities, orbit sizes, disjointness, and union 1,600 `LEAN-CHECKED`; exhaustion open | C151 equality-orbit completeness |
| D-AOR5 | For an invariant old set, legality of a conjugate candidate pair reduces to freshness, one representative avoiding old secants, and its fixed carrier avoiding old points. | `LEAN-CHECKED; LIT-OPEN` | C151 certificate compression and later exposition assessment |
| D-AOR6 | The residual order-400 group is two independent 20-element base-field affine normalizers; its executable action preserves legal-orbit cardinality. | `LEAN-CHECKED` | C151 class transport |
| D-AOR7 | Determinant obstructions factor through 651 canonical dual-line masks; the 310 candidate carriers lie ten apiece on the 31 conjugation-fixed lines. | mask table and Boolean composition `LEAN-CHECKED` | compact C151 residual certificates |
| D-AOR8 | Freshness blocks 3 candidates and carrier incidence blocks 140 in every residual class; only the old-secant mask varies, yielding the legal-count spectrum 32–47 through overlap. | lower bound and five equalities `LEAN-CHECKED`; spectrum `COMPUTE-CHECKED` | seek a conceptual overlap inequality after the residual cover closes |

Closed discoveries D-AOR1 and D-AOR3 were promoted by C148 and C149 respectively; their final
statements are in the reports above and their development history is in the companion archive.

## Open queue

| Task | State | Current deliverable |
|---|---|---|
| C151 | active; lower bound, residual-orbit layer, and semantic lift checked | Prove exhaustion, then conclude exact Q25 minimum 32 with five equality classes |
| C318 | queued after C151 | Manifest rows for the residual layer, its data trees, and the trusted-surface statement |
| C319 | gated on measured C151 cost | Decide verified canonicalizer versus demotion to reduction-plus-computation |
| C152 | queued behind C151 | Define the orbit-replacement graph, prove the exact local degree identity, then run a component census before considering connectivity |

Reported: C142, C143, C148, C149, and C150; use the linked reports rather than recreating their
plans here.

## C151 — next actions

Read [the C151 report](../2026-07-14-c151-q25-minimum-classification.md) § "Residual-orbit
certification" before touching the residual layer; it records why the fast evaluator exists and two
approaches that are ruled out.

1. Prove exhaustion: every normalized row attaining 32 lies in `minimumOrbitUnion`. This is work on
   the residual-cover side; `isMinimumResidualClass_iff_mem_minimumOrbitUnion` already turns the
   goal into a membership statement. The report's "Current next step" fixes the design and names the
   two reuse facts that keep it off the frozen checker cores.
2. Run the scoped trust/axiom and source-generation audits, then update the manuscript only after
   the complete semantic theorem passes.

State a cold session needs before starting:

- The residual-orbit layer is committed and green: `Q25ResidualComposition.lean` (composition law),
  `Q25ResidualGroup.lean` (group, `MulAction`, orbit–stabilizer bridge),
  `Q25ResidualMinimumOrbits.lean` (five stabilizer orders, orbit sizes, disjointness, union 1600),
  and `Q25ResidualEquality.lean` (semantic class predicate). Orbit sizes are theorems now, not
  schema payload.
- Phrase every new `decide` through `residualApplyFast`, never through `parameterEmbedding` or
  `residualApply`; `smul_eq_map` bridges to the embedding form used by the cover certificates.
- Decide stabilizers and non-reachability, never orbits: `Finset.image` deduplicates quadratically.
  High-level automation can reintroduce this silently — `tauto` on a goal mentioning `Finset`
  membership tried to decide it and hit the recursion limit.
- `Q25MinimumClassification.lean`, `Q25ResidualConclusionDispatchData/`, the row-conclusion
  prototype change, and the dispatch generator are committed and green.
- Two paths are deliberately left uncommitted. `lean/RelativeConicArcs/README.md` carries a
  one-line pointer edit belonging to the in-flight `CERTIFICATES.md` → `TRUST.md` rename in another
  lane; commit it there, not here. `notes/2026-07-17-c151-residual-equality-generator.py` writes a
  `Q25ResidualEqualityData` tree that does not exist — the orbit–stabilizer route replaced it, so
  decide whether it is superseded before committing a generator with no tracked output.
- C318 (manifest rows for the residual layer) and C319 (gated canonicalizer-or-demote decision) are
  queued behind this work.

The checked valid-row cover is split into 1,036 modules under
`lean/RelativeConicArcs/Q25ResidualTransportData/`, with at most eight valid eight-point
permutation certificates per module. The handwritten prototype remains split under
`lean/RelativeConicArcs/Q25ResidualCoverPrototype/`, and the generic bridge is
`lean/RelativeConicArcs/Q25ResidualCoverBridge.lean`. Preserve these module boundaries because a
combined elaboration exceeded the safe memory envelope.

The checked mixed-row dispatcher is split into 1,071 leaves under
`lean/RelativeConicArcs/Q25ResidualDispatchData/`; the 7,044 literal canonical-class links are
split along the transport leaves under `lean/RelativeConicArcs/Q25ResidualClassLinkData/`; and the
composed conclusions are split into 1,071 leaves plus bounded `b`-aggregates under
`lean/RelativeConicArcs/Q25ResidualConclusionData/`.

## C152 — queued shape

Vertices are embedded Frobenius-invariant ten-arcs with a fixed exact fixed-point subset; an edge
exchanges one nonfixed conjugate orbit while retaining the common invariant eight-arc. First prove
adjacency symmetry, fixed-subset preservation, deleted-orbit recovery, neighbor injectivity, and

```text
degree(A) = sum over selected nonfixed orbits q of card(alternateLegalPairs(A,q)).
```

Only then run embedded and symmetry-quotiented component censuses, actively looking for component
invariants. High degree alone does not justify connectivity, expansion, or mixing claims.

## Publication boundary

The reported general and Q25 repair theorems may be used with the cautious literature posture in
the [C143 literature report](../2026-07-14-c143-literature-positioning.md). Do not make a
historical-first claim. Do not present 32 as the exact semantic minimum, or the five classes as a
complete extremal classification, until C151's residual-cover and orbit-completeness bridge passes.

While C151 remains live, the `alt-orbit-repair` integrator is the sole writer of
`papers/equivariant-robust-completion/` and its release boundary. C270/C287 may inventory metadata
and prospective shared-Lean targets read-only, but the release coordinator must not freeze or edit
the manuscript around an unfinished theorem boundary. C152 becomes a release gate only if its
exchange-graph claims are adopted. Public-release preparation resumes after the lane integrator
records the final adopted theorem set.
