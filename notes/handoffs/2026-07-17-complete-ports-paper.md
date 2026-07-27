# Complete bounded repair ports paper preparation

**Lane**: `complete-ports`

**Date**: 2026-07-26
**Status**: ACTIVE; C672--C675 PROOF GATES COMPLETE; C676 NEXT; PUBLIC RELEASE GATED
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md)
**Canonical paper identity**: `complete-ports` — *Complete Bounded Repair Ports: Local Memory,
Transfer, and Reliability*
**Approved paper repository**: `tavisrudd/complete-ports` at `~/src/papers/complete-ports`
**Approved paper license**: MIT

## Goal

Produce one short theorem-led complete-ports manuscript whose main proof spine consists entirely of
complete human proofs backed by statement-adequate Lean declarations. Computations, finite tables,
certificates, and replay machinery may support appendices but may not carry a body theorem. Public
release remains a separate fresh-history operation that never publishes the private monorepo or its
history.

## Main-proof admission rule

A result enters the body proof spine only when it has:

1. an exact stable paper statement;
2. a complete human proof exposing the mathematical mechanism;
3. a matching Lean declaration;
4. a field-by-field statement-adequacy check;
5. an axiom audit naming every classical imported input; and
6. no computation or certificate in its logical dependency chain.

Results failing this gate are marked `TO FORMALIZE`, `APPENDIX COMPUTATION`, or `CUT/DERIVE`.
Classical literature inputs may remain cited, but the paper and Lean boundary must expose the same
input explicitly.

## Revised paper spine

1. complete bounded ports, reconstruction radius, support/coefficient/probability layers, intrinsic
   port isomorphisms, and the general MDS local-reconstruction theorem on page 2;
2. exact pointed confinement and weighted-functional transfer;
3. positive-density geometric fingerprints, led by the general MDS theorem and followed by compact
   Clebsch/arc/PRS/AME consequences;
4. reliability and bounded EXIT;
5. pointed Tutte structure and the radius-filtration boundary;
6. cubic--axis versus quartic--nucleus/harmonic applications as demonstrations of different port
   geometries;
7. verification and provenance; and
8. appendices containing every retained computation, certificate, exact finite table, and replay
   description.

The working title is *Complete Bounded Repair Ports: Local Memory, Transfer, and Reliability*;
C671 freezes the final adopted title and theorem hierarchy.

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
- [C671 revised theorem hierarchy and paper-control surface](../2026-07-26-c671-complete-ports-theorem-hierarchy.md).
- [C672 MDS minimum coefficient-port reconstruction](../2026-07-26-c672-mds-local-reconstruction.md).
- [C673 exact pointed confinement and weighted transfer](../2026-07-26-c673-exact-confinement-transfer.md).
- [C674 positive-density coefficient fingerprints](../2026-07-26-c674-positive-density-fingerprints.md).
- [C675 reliability and bounded EXIT](../2026-07-26-c675-reliability-bounded-exit.md).

**Discovery companion**: [complete-ports discovery track](../complete-ports-discovery-track.md).

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

The manuscript now includes one bounded cross-paper application. For the
Clebsch `[6,3,4]_11` code, its full pointed coefficient port reconstructs
the inner code, has `z_x=8`, and occurs with density `1/6` in an
asymptotically good fixed-`F_11` family. The support-only clutter is generic
MDS data; the scalar coefficient layer is the exact Clebsch-bearing part.
The proof ledger records this as manuscript-derived rather than a new Lean
terminal.

## Next step

Before any nontrivial proof development or formalization for this paper, read the required
paper-specific expert dossier
[`papers/expert-profiles/05-complete-repair-ports.md`](../../papers/expert-profiles/05-complete-repair-ports.md).
It routes C675 to the Janson--O'Donnell reliability lens, C676 to the Britz--Ravagnani
code/matroid lens, and C677 to the Lavrauw--Ball/Bartoli finite-geometry lens; final assembly also
requires the Yaakobi/Tamo operational-storage read.

Run C676 next: complete the pointed Tutte specialization and radius-filtration boundary with human
proofs and matching Lean statements.  C675 closed finite-sum deletion--contraction, pivotal
derivatives, homogeneous Russo--Margulis, blocker asymptotics, radius truncation, cheapest-radius
transforms, and the complete-ports trust closure.  The remaining proof/formalization work branches:

- C676 now owns pointed Tutte and the filtration boundary; and
- C677 follows C672 for the harmonic geometric application.

C678 assembles the revised modular draft only after C672--C677 pass their gates. C325 then builds
the appendix-only finite verifier. C679 performs the aggregate formal/prose audits and independent
draft-readiness cold reads.

The corrected prior twelve-page draft and its cold reads remain inputs, not acceptance of the new
hierarchy. C220 remains omitted. Shared-Lean extraction is planned under
[C287](../2026-07-17-c287-shared-lean-extraction-plan.md) and remains separately build-system-owned.

Public export remains gated on the public checker/archive identity and C287 shared-Lean export. The
paper repo pins an exact validated shared-Lean commit and contains no copied Lean sources. The
approved repository metadata and private rename do not authorize repository initialization, copy,
publication, or push.
