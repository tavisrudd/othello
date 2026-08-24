# Bounded recovery structures paper preparation

**Lane**: `complete-ports`

**Date**: 2026-08-24
**Status**: ACTIVE; C950 PRIMARY-PAPER ARCHITECTURE IN PROGRESS; C951 FORMAL
BOUNDARY, C952 MANUSCRIPT REBUILD, C325 APPENDIX VERIFIER, AND C953 AGGREGATE
REVIEW FOLLOW IN THAT ORDER; REMOTE PUBLICATION GATED
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md)
**Canonical paper identity**: `complete-ports` — *Bounded Recovery Structures of Linear Codes:
Transfer, Reliability, and Geometry*
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

## Current paper spine

Working title: *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*.

1. recovery sets, normalized recovery equations, and stochastic repair as
   distinct forgetful layers;
2. the associated nested code pair and its exact sequence;
3. relative generalized Hamming weights as the exact minimum helper costs for
   recovering subspaces of each dimension;
4. exact eventual confinement and transfer of all normalized equations;
5. the best-target GHW identity, cooperative-locality min--max corollary, and
   MDS rigidity;
6. positive-density realization and bounded service-rate-region transfer;
7. reliability and coefficient-presentation separations beyond the RGHW
   hierarchy;
8. the projective simplex code as the principal non-MDS application; and
9. compact formal-verification and reproducibility appendices.

Use only established coding-theory terminology. “Associated nested code pair”
is a literal description of $K_P\subseteq D_P$, not a coined term. Research
and referee reports must contain factual findings and result ordering only;
they must not contain percentiles, venue-prestige judgments, or overall-quality
grades that could bias later cold reads.

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
- [C676 pointed Tutte specialization and filtration boundary](../2026-07-26-c676-pointed-tutte-filtration.md).

**Discovery companion**: [complete-ports discovery track](../complete-ports-discovery-track.md).

Completed strengthening:

- [C944 recovery-terminology revision](../2026-08-22-c944-complete-ports-recovery-terminology.md)
  removes “port” as visible technical terminology, distinguishes exact helper
  supports from the upward-closed recovery-set family, preserves normalized
  recovery coefficients, passes an independent cold read after five minor
  edit repairs, distinguishes the transfer theorem explicitly from Jin--Fu's
  fixed-inner parameter constructions, and exports the verified 23-page
  standalone artifact.
- [C939 unified asymptotic separation revision](../2026-08-21-c939-complete-ports-unified-asymptotic-separation.md)
  proves the matched-availability structural seed pair, lifts it to
  positive-density asymptotically good families, passes final cold/formal
  review, and leaves a verified local public export; no push or deposit was
  made.

Sequel research:

- [C946 multi-target recovery and exact confinement](../2026-08-22-c946-multitarget-recovery-confinement.md)
  derives the restricted-dual splitting object and proves the exact finite and
  eventual helper-union thresholds reducing to the one-target theorem; C948
  closes its cold-read and generalized-weight gates.
- [C947 recovery-cost lattice and theory audit](../2026-08-22-c947-recovery-cost-lattice-theory.md)
  proves that the demand cost is finite-field minimum joint row support,
  neither submodular nor supermodular and NP-complete already for one binary
  demand; it packages all presented-demand lifts as a Yoneda representable and
  bounds the arithmetic-matroid/Smith-normal-form sequel. It is math-only and
  made no manuscript or formal-boundary change.
- [C948 recovery of target subspaces and relative-weight confinement](../2026-08-22-c948-rank-stratified-recovery-hierarchy.md)
  proves that the RGHWs of the associated nested pair are the exact minimum
  helper costs, derives the sharp dimension-by-dimension confinement threshold,
  best-target GHW identity, MDS rigidity, service-rate and reliability
  corollaries, projective example, and coefficient-presentation separation;
  its independent proof reread closes all findings and selects the primary-paper
  rebuild above. BGS/disjoint-recovery work remains a separate gated project.

## Publication boundary

Every paper is a fresh-history allowlisted export. Never publish, fork, history-filter, or broadly
copy the private monorepo. The shared Lean monorepo is separately owned and derived from the union of
paper-facing target closures. Compiled Lean reuse requires the guarded `lake pack` path plus an
independent restore/trace validation; never copy raw build trees or selected `.olean` files.

## Current scope

Retain the exact transfer theorem, positive-density realization, represented
$[10,4,6]$ separation, only the pointed-Tutte material required by that
separation, compact MDS reconstruction, the service-rate corollary, and the
projective simplex example. Compress or move extended EXIT,
deletion--contraction, secondary geometric inventories, and competing examples.
Exclude sequential composition, vector-bandwidth claims, the full coefficient-
optimization programme, generic tract/foundation exposition, and BGS packing.

The manuscript now includes one bounded cross-paper application. For the
Clebsch `[6,3,4]_11` code, its full family of normalized recovery equations
reconstructs the inner code, has `z_x=8`, and occurs with density `1/6` in an
asymptotically good fixed-`F_11` family. The support-only clutter is generic
MDS data; the scalar coefficient layer is the exact Clebsch-bearing part.
The proof ledger records this as manuscript-derived rather than a new Lean
terminal.

## Next step

C950 freezes the exact section/theorem architecture and retain/rewrite/move/cut
map without editing the manuscript. Then run C951 formal-boundary closure,
C952 manuscript reconstruction, C325 appendix-only verification, and C953
aggregate referee/export review. Before nontrivial proof development or
formalization, read the paper-specific expert dossier
[`papers/expert-profiles/05-complete-repair-ports.md`](../../papers/expert-profiles/05-complete-repair-ports.md).

The prior monolithic draft and its cold reads remain inputs, not acceptance of the modular
hierarchy. C220 remains omitted. Shared-Lean extraction is planned under
[C287](../2026-07-17-c287-shared-lean-extraction-plan.md) and remains separately build-system-owned.

Public export remains gated on the public checker/archive identity and C287 shared-Lean export. The
paper repo pins an exact validated shared-Lean commit and contains no copied Lean sources. The
approved repository metadata and private rename do not authorize repository initialization, copy,
publication, or push.
