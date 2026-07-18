# Complete bounded repair ports paper preparation

**Lane**: `complete-ports`

**Date**: 2026-07-17
**Status**: ACTIVE; C277 LANE SPLIT COMPLETE; PRIVATE PAPER RENAME READY / PUBLIC EXPORT GATED
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)
**Canonical paper identity**: `complete-ports` — *Complete Bounded Repair Ports: Transfer,
Reliability, and Geometric Structure*

## Goal

Produce one short theorem-led complete-ports manuscript in a fresh-history repository without
publishing the private monorepo or its history. The paper's six-part spine is the complete bounded
repair-port object, exact weighted-functional transfer, prescribed asymptotic realization,
reliability/bounded EXIT, pointed Tutte/perspective structure, and the cubic versus
quartic-nucleus/harmonic flagship contrast.

## Lane lineage and ownership

C277 created this paper-preparation lane and moved exactly C274--C276 into it. All C111--C224
theorem/formalization work remains pegged to `repaircodes`; `RepairCodes` and `RepairPorts` Lean
names remain unchanged. Future manuscript, clean-export, citation, and paper-release tasks use
`[complete-ports]`.

Completed preparation:

- [C274 theorem/evidence crosswalk](../2026-07-17-c274-complete-port-manuscript-crosswalk.md);
- [C275 clean-room publication boundary](../2026-07-17-c275-m1-publication-boundary-manifest.md)
  and [allowlist](../2026-07-17-c275-m1-publication-allowlist.tsv); and
- [C276 paper-only rename census](../2026-07-17-c276-complete-ports-rename-census.md).

## Publication boundary

Every paper is a fresh-history allowlisted export. Never publish, fork, history-filter, or broadly
copy the private monorepo. The shared Lean monorepo is separately owned and derived from the union of
paper-facing target closures. Compiled Lean reuse requires the guarded `lake pack` path plus an
independent restore/trace validation; never copy raw build trees or selected `.olean` files.

## Frozen scope

Retain complete ports, pointed transfer, prescribed realization, reliability/EXIT, pointed Tutte,
and the two geometric flagships. Exclude sequential-composition semantics, general service regions,
the full coefficient-optimization programme, log-concavity history, product architecture, and
generic tract/foundation exposition. C220 remains an explicit inclusion decision.

## Next step

Allocate the next global C-ID in `complete-ports` and execute C276's paper-only identity migration:
rename the private paper directory and TeX/PDF stem, C274/C275 artifacts, and expert profile; update
M1/M2 paper shorthand, registries, links, build commands, and the C275 allowlist; preserve every
historical `repaircodes` peg and Lean namespace. Rebuild the PDF only after the renamed source and
new section skeleton are ready.

Public export remains gated on the complete-ports repository name/local destination/public remote,
license, and C220 decision. The private rename does not authorize repository initialization, copy,
publication, or push.
