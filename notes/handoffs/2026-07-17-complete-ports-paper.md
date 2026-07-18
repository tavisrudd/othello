# Complete bounded repair ports paper preparation

**Lane**: `complete-ports`

**Date**: 2026-07-17
**Status**: ACTIVE; C220 OMITTED; RELEASE GATES OPEN
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md)
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

- [C274 theorem/evidence crosswalk](../2026-07-17-c274-complete-ports-manuscript-crosswalk.md);
- [C275 clean-room publication boundary](../2026-07-17-c275-complete-ports-publication-boundary.md)
  and [allowlist](../2026-07-17-c275-complete-ports-publication-allowlist.tsv); and
- [C276 paper-only rename census](../2026-07-17-c276-complete-ports-rename-census.md).
- [C279 private identity migration](../2026-07-17-c279-complete-ports-identity-migration.md); and
- [C280 six-part manuscript assembly](../2026-07-17-c280-complete-ports-six-part-assembly.md).
- [C285 submission-preflight citation and claim audit](../2026-07-17-c285-complete-ports-citation-preflight.md).
- [C286 private-source correction and independent cold-read pass](../2026-07-17-c286-complete-ports-correction-and-cold-read.md).

## Publication boundary

Every paper is a fresh-history allowlisted export. Never publish, fork, history-filter, or broadly
copy the private monorepo. The shared Lean monorepo is separately owned and derived from the union of
paper-facing target closures. Compiled Lean reuse requires the guarded `lake pack` path plus an
independent restore/trace validation; never copy raw build trees or selected `.olean` files.

## Frozen scope

Retain complete ports, pointed transfer, prescribed realization, reliability/EXIT, pointed Tutte,
and the two geometric flagships. Exclude sequential-composition semantics, general service regions,
the full coefficient-optimization programme, log-concavity history, product architecture, and
generic tract/foundation exposition. The user chose to omit C220's optional cubic
blocker-stability strengthening.

## Next step

The corrected private draft has passed three independent paragraph-by-paragraph cold reads and
same-reader resolution checks, and the user has chosen to omit C220. Allocate the
release-preparation pass only after the repository destination/remote, license, public
checker/archive identity, and shared-Lean export gates are resolved. Do not initialize, copy,
publish, or push before those decisions.

Public export remains gated on the complete-ports repository name/local destination/public remote,
license, public checker/archive identity, and shared-Lean export. The private rename does not
authorize repository initialization, copy, publication, or push.
