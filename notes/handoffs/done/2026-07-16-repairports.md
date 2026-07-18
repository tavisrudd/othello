# Repair ports: exact local geometry beyond the current paper — C215–C220

**Lane**: `repairports`

**Date:** 2026-07-16
**Status:** ARCHIVED 2026-07-16. C215--C220 are complete. C220 upgrades C202's two q=9 cubic blocker
forms to a uniform equality and first-stability theorem over every `F_3^h`.
**Successor:** [`rp-next`](../2026-07-16-rp-next.md)
**Roadmap:**
[`2026-07-16-repaircodes-a-plus-roadmap.md`](../../2026-07-16-repaircodes-a-plus-roadmap.md)
**Parent paper:** [`complete-repair-ports`](../../../papers/complete-repair-ports/README.md)
**Discovery log:**
[`2026-07-16-repairports-discovery-track.md`](../../2026-07-16-repairports-discovery-track.md)

## Goal

Develop complete bounded repair ports as local pointed represented-matroid objects: characterize
their exact behavior under concatenation, realize prescribed ports in asymptotically good codes,
and investigate the gauge, geometric, reliability, and additive structures exposed by the current
twisted-cubic--axis paper.

## Task order

| Task | Status | Deliverable | Promotion gate |
|---|---|---|---|
| C215 | complete | weighted functional-dual theory | exact criterion plus a strict natural example |
| C216 | complete; optional Lean wrapper deferred to build-system entry | prescribed-port asymptotic realization | general theorem plus nontrivial achievable region |
| C217 | complete | circuit-coefficient gauge invariants | complete holonomy fingerprint, cross-ratio, and strict inequivalence example |
| C218 | complete | quartic-nucleus harmonic repair family | `S(3,4,q+1)` circuits, exact parameters, and replication |
| C219 | complete | repair reliability/Boolean theory | general formula, recurrence, or threshold theorem |
| C220 | complete | additive equality and stability | uniform inverse/stability theorem |

## Disposition

No further work is open in this lane. The user selected `rp-next` for the structured depth search;
its first task is C226. C220 is closed in
[`2026-07-16-c220-cubic-blocker-stability.md`](../../2026-07-16-c220-cubic-blocker-stability.md).
The axis zero-sum-free and line-partition classifications remain outside the completed gate and
require a separately allocated task if resumed.

## Historical scope and ownership

While live, this lane owned its handoff, roadmap, C215--C220 reports and explicitly named artifacts,
future `papers/repair-ports-*` packages, and future `lean/RepairPorts/` modules. It did not own the
current `complete-repair-ports` paper or the `lean/RepairCodes/` theorem chain; those remained
with `repaircodes` unless the user explicitly moved a deliverable.

## Boundaries retained for the record

- Do not treat a restatement of the concatenated-dual preimage as a contribution without a strict
  application or useful invariant.
- Raw repair coefficients are gauge; C217 studies only gauge-invariant compatibility data.
- A finite q=9 census is a test or artifact, not a stand-alone theorem.
- D-PC9 is banked as a certified modest-novelty few-weight family and is not a lane headline.
- D-PC9 has `q+1` minimum-weight projective classes and `q^2-1` ordinary nonzero minimum-weight
  codewords; never conflate the two counting conventions.
