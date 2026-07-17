# Repair ports: exact local geometry beyond the current paper — C215–C220

**Lane**: `repairports`

**Date:** 2026-07-16
**Status:** ACTIVE. C215--C218 are complete. C218's characteristic-three quartic plus its unique
osculating-hyperplane nucleus gives a harmonic Steiner radius-four family and meets its scout gate.
**Roadmap:** [`2026-07-16-repaircodes-a-plus-roadmap.md`](../2026-07-16-repaircodes-a-plus-roadmap.md)
**Parent paper:** [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)
**Discovery log:** [`2026-07-16-repairports-discovery-track.md`](../2026-07-16-repairports-discovery-track.md)

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
| C219 | queued | repair reliability/Boolean theory | general formula, recurrence, or threshold theorem |
| C220 | long-horizon | additive equality and stability | uniform inverse/stability theorem |

## Immediate next step

Run C219's reliability/Boolean scout. Seek a general reliability formula, recurrence, influence
identity, or threshold theorem for complete repair ports; use C218's harmonic Steiner port as a
second structured test alongside the existing C202 blockers. C218 is closed in
[`2026-07-16-c218-quartic-nucleus-repair.md`](../2026-07-16-c218-quartic-nucleus-repair.md).

## Scope and ownership

This lane may edit:

- `notes/handoffs/2026-07-16-repairports.md` and a future companion archive;
- `notes/2026-07-16-repaircodes-a-plus-roadmap.md` and future C215–C220 reports;
- future `papers/repair-ports-*` packages;
- future `lean/RepairPorts/` modules and an aggregate `lean/RepairPorts.lean`;
- future explicitly named C215–C220 scripts and certificates under `notes/`.

It must not edit the current `coding-repair-hypergraphs` paper or `lean/RepairCodes/` theorem chain;
those remain owned by `repaircodes` unless the user explicitly moves a deliverable. Before any Lean
work, read `lean/AGENTS.md` completely.

## Boundaries

- Do not treat a restatement of the concatenated-dual preimage as a contribution without a strict
  application or useful invariant.
- Raw repair coefficients are gauge; C217 studies only gauge-invariant compatibility data.
- A finite q=9 census is a test or artifact, not a stand-alone theorem.
- D-PC9 is banked as a certified modest-novelty few-weight family and is not a lane headline.
- D-PC9 has `q+1` minimum-weight projective classes and `q^2-1` ordinary nonzero minimum-weight
  codewords; never conflate the two counting conventions.
