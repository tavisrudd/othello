# Bounded recovery structures paper preparation

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: ACTIVE; C972 COMPOSITIONAL-STATE CHARACTERIZATION, C976
EXPOSITION/LITERATURE/EXPORT, AND C984 SMALL-MODEL PROMOTION CLOSED; 40-PAGE
AUTHORITY, 31-CLAIM, FOUR-LEAN-TERMINAL, AND 84-FILE ERGODIS PUBLIC-SURFACE
GATES PASS; C962 ALGORITHM/BOUND DEVELOPMENT AND C980 HIGHER-RANK
CONTEXTUAL-MINIMALITY RESEARCH ARE CLOSED; C325 APPENDIX VERIFIER AND C953 AGGREGATE
REVIEW FOLLOW; C955 AMBIENT-REALIZATION SPECTRUM REMAINS QUEUED; NO PUSH OR
DEPOSIT
**Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md)
**Current private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md)
**Canonical paper identity**: `complete-ports` — *Exact Compositional Transfer of Bounded Linear
Recovery*
**Standalone paper repository**: `tavisrudd/compositional-recovery` at
`~/src/math-papers/compositional-recovery`
**Current local standalone commit**: `80c600f` (40-page revised manuscript;
verified; no push or deposit)
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

Title: *Exact Compositional Transfer of Bounded Linear Recovery*.

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

- [C980 higher-rank contextual minimality](../2026-08-27-c980-higher-rank-contextual-minimality.md)
  is closed as a mathematics-only task.  It proves higher-rank
  column-type, universality, and congruence theorems together with a bounded
  small-model theorem: through helper radius `r`, every numerical distinction
  and every coefficient witness is captured by outer shortenings to the target
  and at most `r` helpers, so separating contexts have length at most
  `max(2,r+1)` and functional-dual rank at most `min(t,r)`.  The report gives
  the exact `GL`-orbit census, the dual-shortening evaluator, the finite
  transformation-category corollary, finite ordered-monoid and sharp bounded
  Pareto extensions, and fixed-batch packing and multi-target compression
  lemmas.  Its [structural compression, hostile proof review, and literature
  audit](../2026-08-27-c980-structural-compression-hostile-proof-literature-audit.md)
  reduce the load-bearing scalar package to four theorems and find no defect
  in that core.  The review repairs the finite-monoid stabilization and
  rank-restriction aggregation steps, and demotes fixed-batch congruence until
  a typed composition law is proved.  The next gate is an independent reread
  of the compressed scalar spine; code-realizable sharpness is a possible
  strengthening rather than a correctness gate.  Its independent reread found
  and repaired the omitted nonzero-target hypothesis, found no further scalar
  defect, and selected the small-model core for C984 manuscript promotion.

- [C984 higher-rank small-model manuscript promotion](../2026-08-27-c984-higher-rank-small-model-manuscript-promotion.md)
  is closed.  The 40-page manuscript now proves the pointed column-type normal
  form, exact dual-shortening identity, radius-bounded separator, compact
  coefficient-witness cover, finite coarsest bounded contextual quotient and
  typed congruence, and the exact recoverable-target finite-test corollary.
  The abstract, introduction, conclusion, public README, and portfolio summary
  distinguish this finite higher-rank quotient from the explicit projective
  rank-one quotient.  An independent hostile read found no mathematical
  defect; the deterministic 31-claim, four-terminal release gate passes.

- [C962 exact recovery algorithms](../2026-08-25-c962-recovery-algorithms-and-bounds.md)
  is closed by user direction.  It includes a radius-pruned rank-one complete-transfer certificate, lazy
  projective line-probe caching, and rank-bounded contextual subspace caching
  with Python/Rust differential fixtures and interleaved cold/warm A/B evidence.
  The certificate is 1.66x faster for the measured exact radius decision and
  removes the higher-rank recomputations; warm projective and rank-bounded
  queries are 2.62x and 5.83x faster, while their measured cold paths remain
  slower and are not selected for one-shot queries.

- [C972 minimal compositional state](../2026-08-26-c972-minimal-compositional-state.md)
  identifies the zero-truncated projective line-probe profile as the coarsest
  rank-one numerical state observable in every finite outer context, proves
  that this contextual equivalence is a concatenation congruence, reduces
  rank-`t` tests to outer functional-dual dimension at most `t`, upgrades the
  rank-one bottleneck to complete bounded transfer of coefficient and support
  systems, and sharpens the binary/quaternary example to a fixed-code,
  fixed-pair functional-label separation.

- [C976 exposition and literature-positioning closeout](../2026-08-27-c976-sequential-cold-read-repair.md)
  reorganizes the opening around the loss of functional labels, the exact
  two-sector formula, min--sum closure, and outer-distance collapse; adds
  section navigation and scoped cross-field explanations; corrects the
  surrounding GHW, service-rate, exact-repair, concatenated-LRC, and solver
  literature; and exports the verified 37-page authority as standalone commit
  `1fdb00c` without push or deposit.  The detailed 30-source audit is
  [separate](../2026-08-27-c976-recent-literature-positioning-audit.md).

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

- [C983 Ergodis cross-domain exact compositional optimization](../2026-08-27-c983-ergodis-cross-domain-potential.md)
  is in progress as private research.  Its first concentrated expansion window
  produced a [90-minute report](../2026-08-27-c983-90m-report.md), a 36-source
  hostile audit, a typed deterministic/effectful compiler-law boundary, two
  exact noncoding fixture contracts, and proof-carrying artifact/Rust design.
  Classical automata, graph, abstract-interpretation, provenance, max-plus
  control, mergeable-summary, and game results are treated as corollaries or
  backends rather than abandoned paths.  Application targets now include
  oracle-wrapped legacy solvers, networks, bounded discrete-event systems,
  exact mergeable analytics, robust interfaces, finite analysis, boundary
  protocols, and an exact-to-learned realization laboratory.  Mamba remains
  one experimental vehicle, not the mathematical premise.  The subsequent
  [deterministic reference-compiler spike](../2026-08-27-c983-reference-compiler-spike.md)
  implements one unchanged Rust minimizer/verifier for the bounded tropical-WTA
  and determinized resource-batch adapters.  Exact controls give `13 -> 6` and
  `35/51/44 -> 22/14/5`; typed separators, WTA tree/run replay, exhaustive
  resource-assignment replay, artifact-corruption tests, and an independent
  Python oracle pass.  That accepted implementation stages 1/2, not C983.
  The follow-on [recovery/sidecar control](../2026-08-27-c983-recovery-sidecar-control.md)
  closes the recovery, common-sidecar, and presentation-fingerprint architecture
  gaps: all 16 raw triangle-gauge
  `2 x 2` demands compile `16 -> 5` under the complete stated request-projection
  schema, with exact coefficient/support/helper-load replay and an independent
  Python oracle.  Recovery, WTA, and resources now share one presentation-bound
  concrete-trace/provenance sidecar.  An incompatible-equivalent-witness
  regression forbids class-representative substitution.  This passes the
  three-exemplar architecture gate; actual hierarchical `CostTable`
  composition, measured reuse economics, versioned payload schemas, and a cold
  implementation review remain C983 gates.  The subsequent
  [hierarchical composition control](../2026-08-27-c983-hierarchical-composition-control.md)
  routes bounded ordinary/target scalar profiles through the production
  `CompositionTable` algebra: raw sorts `9/12/12` compile to `3/6/4`, and all
  117 admitted depth-two queries replay complete local-label witness trees.
  An independent Python min-plus convolution agrees.  Hierarchical API closure
  therefore passes; concrete-code leaf generation, measured economics,
  certificate/provenance compaction, versioned payload schemas, and cold review
  remain C983 gates.
  C983 does not block C325 or C953 and makes no manuscript or public-surface
  change.

- [C985 Ergodis exact algebraic optimization paper](../2026-08-27-c985-ergodis-optimization-paper.md)
  is queued after C983.  It targets constraint programming and exact
  combinatorial optimization with contextual quotient compilation, the C980
  finite ordered-monoid/Pareto theorem, witness-preserving composition, and
  C983's two admitted noncoding exemplars.  Recovery remains the deepest
  motivating application, but the paper proceeds only if C983 demonstrates
  one genuine shared kernel and material cross-domain state reduction.

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

C980 is closed after structural compression, hostile proof review, a scoped
priority audit, and an independent reread.  C984 is next: promote only its
accepted scalar small-model block, update the formal claim records, obtain an
independent cold read, and pass the existing authority/export gates.  Keep the
probe census, rank-stratified algorithms, Pareto, fixed-batch packing, and
multi-target state algebras outside the manuscript.
C962's bounded representation work was accepted as sufficient, further
candidate-parity experiments were cancelled, and its private task-owned code
and evidence are committed.  No successor was allocated for the optional
optimization work.  C983 is active for the separate cross-domain
Ergodis feasibility program; it does not block the paper closeout.  After C984,
run C325 appendix-only
verification, followed by C953
aggregate referee/export review.  C955 owns the later coefficient-presentation
spectrum. Before nontrivial proof development or
formalization, read the paper-specific expert dossier
[`papers/expert-profiles/05-complete-repair-ports.md`](../../papers/expert-profiles/05-complete-repair-ports.md).

C985 follows C983 as a separate optimization-facing paper research task and
does not block C984, C325, or C953.

The prior monolithic draft and its cold reads remain inputs, not acceptance of the modular
hierarchy. C220 remains omitted. Shared-Lean extraction is planned under
[C287](../2026-07-17-c287-shared-lean-extraction-plan.md), remains separately build-system-owned,
and is not evidence for or a release dependency of the paper-local companion.

Local standalone synchronization is complete at `6bfc17d`. Publication, push,
and deposit remain gated on C325 and C953; the approved repository metadata
does not authorize any of those external actions.
