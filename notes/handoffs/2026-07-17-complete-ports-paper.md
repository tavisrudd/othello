# Bounded recovery structures paper preparation

**Lane**: `complete-ports`

**Date**: 2026-08-25
**Status**: ACTIVE; C961 REPEATED-CONCATENATION COST COMPOSITION PROVED,
PRIORITY-BOUNDED, HARD-RED-TEAMED, AND EXPORTED; C971 ERGO-COMP PACKAGING AND
MANUSCRIPT UPDATE COMPLETE; 27-PAGE AUTHORITY AND 99-FILE STANDALONE GATES
PASS; C962 ALGORITHM/BOUND DEVELOPMENT REMAINS IN PROGRESS; C325 APPENDIX
VERIFIER AND C953 AGGREGATE REVIEW FOLLOW;
C955 AMBIENT-REALIZATION SPECTRUM REMAINS QUEUED; NO PUSH OR DEPOSIT
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md)
**Canonical paper identity**: `complete-ports` — *Exact Transfer of Bounded Linear Recovery and
Relative Weight Hierarchies*
**Standalone paper repository**: `tavisrudd/complete-repair-ports` at
`~/src/math-papers/complete-repair-ports`
**Current local standalone commit**: `84e2175` (C961 repeated-concatenation
composition and sharp cost envelopes; verified; no push or deposit)
**Approved paper license**: MIT

## Goal

Produce one short theorem-led complete-ports manuscript whose main proof spine consists of complete
human proofs and whose formal coverage is stated claim by claim. Computations, finite tables,
certificates, and replay machinery may support appendices but may not carry a body theorem. Public
release remains a separate fresh-history operation that never publishes the private monorepo or its
history.

## Main-proof admission rule

A result enters the body proof spine only when it has:

1. an exact stable paper statement;
2. a complete human proof exposing the mathematical mechanism;
3. an explicit formal-coverage classification;
4. exact attribution of every imported mathematical input; and
5. no computation or certificate in its logical dependency chain.

Only the associated-pair exact sequence is currently Lean-complete.  Every stronger theorem is
marked absent from the paper-local Lean package and is supported by its human proof and cited
classical inputs.

## Current paper spine

Working title: *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*.

1. recovery sets, normalized recovery equations, and stochastic repair as
   distinct forgetful layers;
2. the associated nested code pair and its exact sequence;
3. relative generalized Hamming weights as the exact minimum helper costs for
   recovering subspaces of each dimension;
4. exact ungated finite arbitrary-rank transfer from target-normalized joint
   coset-support costs and the complete outer functional dual;
5. the RGHW outer-distance criterion and the pointed weighted formula as
   specializations of that exact optimization;
6. the rank-one escape cost as the exact bottleneck for simultaneous bounded
   transfer across all recoverable target dimensions;
7. the best-target GHW identity, cooperative-locality min--max corollary, and
   MDS rigidity;
8. positive-density realization and bounded service-rate-region transfer;
9. reliability and coefficient-presentation separations beyond the RGHW
   hierarchy;
10. the projective simplex code as the principal non-MDS application; and
11. compact formal-verification and reproducibility appendices.

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

Current and completed strengthening:

- [C961 repeated-concatenation composition](../2026-08-24-c961-recovery-composition-law.md)
  proves exact min-sum substitution for labelled ordinary prescribed-coset
  support costs, identifies the additional target-image and full-lift data
  needed for normalized numerical and coefficient-level composition, derives
  the compatible two-sector dual-distance recursion and sharp envelopes, and
  exports the verified 24-page paper and synchronized portfolio summary
  without push or deposit.

- [C960 exact ungated arbitrary-rank transfer](../2026-08-24-c960-ungated-ranked-transfer.md)
  proves that target-normalized joint coset-support costs optimized over maps
  into the full outer functional dual give the exact first nonconfined cost,
  recovers the RGHW and pointed formulas as specializations, derives the
  radius-free collapse and demandwise service-rate consequences, closes the
  generalized-covering/coset-weight priority boundary, and exports the
  verified 22-page paper and synchronized portfolio summary without push or
  deposit.

- [C959 puncturing--shortening identification and positioning repair](../2026-08-24-c959-puncture-shortening-positioning.md)
  identifies the associated pair as the shortening--puncturing pair of the
  inner dual, identifies its dual pair from the primal inner code, removes
  generator-row-basis dependence, centers the two transfer theorems, and
  exports verified local paper and portfolio-summary commits without push or
  deposit.

- [C957 weighted finite rank-one transfer](../2026-08-24-c957-weighted-rank-one-transfer.md)
  restores the exact finite formula over all outer-functional fibers for a
  target block with nonzero projection, separates it from the arbitrary-rank
  theorem after the distance gate, gives a nonvacuous strict family from a
  Singer cycle, and passes literature, anti-smuggling, cold-read, and 20-page
  release gates; the verified local standalone is commit `dc3a9cf`.

- [C954 dual failure-threshold upgrade](../2026-08-24-c954-dual-failure-threshold.md)
  identifies the minimum failures leaving each dimension of target ambiguity
  with the RGHWs of the dual nested pair, using pointwise
  shortening--puncturing duality rather than a false hierarchy-level duality;
  a fresh cold read found one proof-wording defect, which was repaired and
  passed reread, and the verified local standalone is commit `171da01`.

- [C952 manuscript rebuild](../2026-08-24-c952-recovery-manuscript-rebuild.md)
  produces the 17-page theorem-led paper, strengthens confinement to its exact
  finite outer gate, gives the target/helper-symmetric MDS staircase, records
  the four-terminal paper-local Lean boundary, and passes independent referee
  and exact-manifest standalone checks without export or push.

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
copy the private monorepo. This paper's formal companion is the paper-owned Lean 4 project, built
against a pinned Mathlib revision and listed
in its exact 37-file distribution manifest; monorepo trust files and local `lean/AGENTS.md` norms are
excluded. The shared Lean monorepo remains separately owned. Never copy raw build trees or selected
`.olean` files.

## Current scope

The rebuilt manuscript contains the shortening--puncturing pair of the inner
dual, its RGHW
interpretation, exact ungated finite rank-stratified transfer through joint
prescribed-coset support optimization, the outer-distance RGHW and pointed
weighted specializations,
exact repeated-concatenation composition of the labelled costs,
best-target GHW and cooperative-locality consequences, the symmetric MDS
staircase and rigidity, positive-density and service-rate transfer, reliability
and coefficient-presentation separations, and the projective-simplex family.
Extended EXIT, deletion--contraction, secondary geometries, vector bandwidth,
generic coefficient optimization, and BGS packing remain outside this paper.

## Next step

C961 and C971 are closed. C962 now includes the streamed/narrow Rust kernels,
the regenerated scaling and TMA evidence, two paper-native benchmarks from
Jin--Fu's published concatenated LRCs, and matched open-source exact controls
for all six application front ends. The latter replace direct CP-SAT as the
primary comparison: ERGO-comp wins by 336x--173,996x on the five compiled
classes, while Graphillion's ZDD wins the 256-support recursive-XOR case by
29x and motivates an adaptive compressed-family backend. On the binary
`[129,72,10;2]` example,
ERGO-comp computes exact `Gamma=5` in 20.938 ms versus 4.07 s direct and 4.91 s
labelled CP-SAT. On the GF(4)-Hamming-outer binary `[4095,2718,6;2]` family
member, ERGO-comp checks all 4,095 outer functionals in a 21-run median of
231 ms versus completed single-worker optimality proofs of 100 s direct and
82 s labelled CP-SAT, with respective peak RSS of 2.4, 119, and 124 MiB. The
exact models, raw samples, hashes, source-depth audit, and ranked commercial
storage/LDPC follow-ups are in
`notes/2026-08-26-c962-published-benchmark-audit.md` and
`notes/2026-08-26-c962-commercial-benchmark-candidates.md`.
Continue C962 with the bounded explicit/ZDD/Roaring representation experiment,
then only for additional paper-owned algorithm and bound development beyond
the exported ERGO-comp baseline.
Python remains the exact differential oracle, and no Rust performance result is
accepted before cost/witness/load parity.  Then run C325 appendix-only
verification, followed by C953
aggregate referee/export review.  C955 owns the later coefficient-presentation
spectrum. Before nontrivial proof development or
formalization, read the paper-specific expert dossier
[`papers/expert-profiles/05-complete-repair-ports.md`](../../papers/expert-profiles/05-complete-repair-ports.md).

The prior monolithic draft and its cold reads remain inputs, not acceptance of the modular
hierarchy. C220 remains omitted. Shared-Lean extraction is planned under
[C287](../2026-07-17-c287-shared-lean-extraction-plan.md), remains separately build-system-owned,
and is not evidence for or a release dependency of the paper-local companion.

Local standalone synchronization is complete at `e7b9717`. Publication, push,
and deposit remain gated on C325 and C953; the approved repository metadata
does not authorize any of those external actions.
