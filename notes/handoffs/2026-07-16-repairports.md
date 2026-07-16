# Repair ports: exact local geometry beyond the current paper — C215–C220

**Lane**: `repairports`

**Date:** 2026-07-16
**Status:** ACTIVE. C214 was paper-promoted and the repaircodes lane is complete, so C215 is
unblocked. No repairports theorem development or implementation has started.
**Roadmap:** [`2026-07-16-repaircodes-a-plus-roadmap.md`](../2026-07-16-repaircodes-a-plus-roadmap.md)
**Parent paper:** [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)

## Goal

Develop complete bounded repair ports as local pointed represented-matroid objects: characterize
their exact behavior under concatenation, realize prescribed ports in asymptotically good codes,
and investigate the gauge, geometric, reliability, and additive structures exposed by the current
twisted-cubic--axis paper.

## Task order

| Task | Status | Deliverable | Promotion gate |
|---|---|---|---|
| C215 | active | weighted functional-dual theory | exact criterion plus a strict natural example |
| C216 | queued after C215 definition layer | prescribed-port asymptotic realization | general theorem plus nontrivial achievable region |
| C217 | bounded scout after C215 definitions | circuit-coefficient gauge invariants | nontrivial holonomy/cross-ratio with a consequence |
| C218 | bounded scout after C215 definitions | rational-normal-curve nucleus hierarchy | a second tractable infinite repair family |
| C219 | queued | repair reliability/Boolean theory | general formula, recurrence, or threshold theorem |
| C220 | long-horizon | additive equality and stability | uniform inverse/stability theorem |

## Immediate next step

C215 starts from the general algorithms, target-conditioned refinements, and strict applications
that were deliberately kept out of the C214 paper upgrade. First isolate the stable definition and
algorithmic problem layer without editing the `RepairCodes` theorem chain.

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
