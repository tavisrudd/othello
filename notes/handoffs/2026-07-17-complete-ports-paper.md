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

- [C998 ergodis public/private partition design](../2026-08-29-c998-ergodis-partition-design.md)
  and [patent landscape by vertical](../2026-08-29-c998-patent-landscape.md)
  are closed as design-only commercialization inputs (AGPL + commercial dual
  license; five-tier split; narrow quantum provisional recommended before C997
  publishes; storage needs paid FTO; certified compiler alone is not
  patentable per the [VeriPB prior-art note](../2026-08-29-ergodis-certificate-prior-art-veripb.md)).
  No code moves, push, or filing has been made.
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
  The subsequent [code/architecture/performance review](../2026-08-27-c983-ergodis-code-architecture-performance-review.md)
  identifies exhaustive concrete-pair certificates and explicit one-hole
  context materialization as the first scaling walls, followed by synchronous
  refinement, witness duplication, and the test-local adapter/schema boundary.
  Its accepted first scaling slice preserves exhaustive audit as the default,
  adds a quotient-only canonical-recomputation policy with zero pair-certificate
  bytes, closes the cross-sort class-range verifier hole, and adds separated
  and long-chain benchmark families.  The next continuation pre-indexes
  generators by source sort and removes redundant per-signature allocation;
  exhaustive evidence can now stream directly through `Write` (normally a
  buffered file) and be verified through `Read` without retaining records or
  paths.  A hostile pass found that the legacy exhaustive-default compile API
  could defeat streaming before the writer ran; the accepted integrated
  compile-to-writer path now constructs quotient-only state directly, and the
  lower-level stream boundary rejects exhaustive artifacts.  Streaming controls
  aggregate evidence residency but not per-separator product-BFS memory or
  quadratic output/work.  The following compact split-transcript mode now
  derives the quotient from the typed observation partition using one 16-byte
  record per legal binary refinement split.  Exact controls reduce certificate
  payloads from `1456/57180/2412/2952` bytes to `32/416/32/64` for WTA,
  resources, recovery, and hierarchy respectively, with independent replay
  and identical partitions.  Rust and independent Python controls pass.  The
  transcript policy now uses typed inverse CSR and a pending-aware small-half
  worklist directly as its quotient engine, with range-bounded flat pools and
  no allocation in the refinement loop.  A hostile pass supplied a valid
  stale-queue counterexample; the pending-bit repair, permanent regression,
  256-presentation typed corpus, and second hostile review all pass.  The
  independently checked inverse-indexed replayer and five-round interleaved
  wall/RSS harness also pass: the worklist policy is 103.3x faster on the
  256-state long chain and 14.9x faster on 16,384 already-separated states,
  with no stable process-RSS delta (-4.2% to +2.2%). Edge-sparse scheduling is
  now implemented with target-state candidate CSR, exact-footprint selection
  between a dense bitmap and fixed-pool binary Patricia directory, and an
  `O(M)` live-work bound. The Patricia path has at most 64 branch decisions per
  operation; the adversarial `D=262,144, M=64` typed control, former fixed-hash
  collision family, and allocation-growth gate pass. Semantic
  witness schemas and provenance compaction remain open; exhaustive pair
  evidence is now a bounded audit mode rather than a scaling dependency. A
  subsequent
  [SOTA comparison](../2026-08-27-c983-observational-minimization-sota-comparison.md)
  pins MATA, mCRL2's Groote--Jansen 2025 kernel, and Boa as the specialized,
  general-LTS, and generic-coalgebraic frontiers.  The first 131,072-state MATA
  comparison exposed a full-block rescan under singleton splits; flat member
  positions and marked counts repair that quadratic pathology without hot-loop
  allocation or recursion, reducing the cold chain from 3.834 s to 14.126 ms.
  Final seven-round controls put ergodis 1.61x ahead of MATA on that chain and
  3.30x ahead on a four-generator deterministic random family, even though
  ergodis emits and verifies a compact split proof. Separate cold peak RSS is
  13.2--16.2x smaller. A linear initial-stability test gives an 11.5x advantage
  on a native 256-output control; largest-splitter omission plus singleton-sort
  congruence gives 547x on a fully reachable/coaccessible 131,072-state,
  64-generator Boolean stable family, and 1,100x on the 65,536-state,
  128-generator scaling point with 31.9x lower RSS. A native Boa comparison
  makes the adaptive frontier precise: ergodis is 1.81x faster on the chain
  and 1.76x faster on native outputs, while Boa's narrower partition-ID engine
  is 2.48x faster on random-4. The million-state
  profile selected adaptive counting
  scatter for dense inverse construction, now implemented with one reusable
  source permutation and one in-place target count/cursor array.  Seven
  interleaved old/new rounds reduce the four-generator random median from
  2.065 s to 1.760 s (14.8% less time); non-multiplexed counters show 53.6%
  fewer instructions and 49.8% fewer branches with essentially unchanged
  random-case peak RSS.  Sorted sparse inverse storage remains in place for
  asymmetric typed systems. A final policy control found that quotient-only
  still entered the quadratic synchronous refiner; it now constructs and
  verifies the compact transcript internally, discards it before return, and
  has a 16,384-state long-chain regression. Raw MATA and Boa TSV evidence,
  SHA-256 pins, and retained checkers are in-tree.
  C983 is closed and does not block C325 or C953. Its remaining adaptive
  dirty-signature backend, validated-input service boundary, sparse crossover,
  explicit separator extraction, and artifact-schema questions are successor
  opportunities rather than acceptance gaps. No manuscript or public-surface
  change was made.

- [C987 observational application integration](../2026-08-28-c987-observational-application-integration.md)
  is closed as a conditional positive control.  On the existing hierarchical
  labelled-recovery composition path, a 328,704-state raw presentation reduces
  to 2,049 observational classes; the retained artifact is 3.26x smaller and
  random-start queries are 2.34x faster after about 3.96 million queries.
  Sequential and tiny cases do not improve, and compilation peak RSS is 70.36%
  higher because the source and transient compiler workspaces coexist.  The
  benchmark/evidence remain private; there is no default recovery, manuscript,
  mirror, or public-surface change.  C985 owns direct algebraic construction,
  adaptive inverse scheduling, consuming input, frozen evaluation artifacts,
  workload admission, and witness-bearing compiled services.

- [C985 Ergodis exact algebraic optimization paper](../2026-08-27-c985-ergodis-optimization-paper.md)
  is in progress after C983.  It targets constraint programming and exact
  combinatorial optimization with contextual quotient compilation, the C980
  finite ordered-monoid/Pareto theorem, witness-preserving composition, and
  C983's two admitted noncoding exemplars.  Recovery remains the deepest
  motivating application, but the paper proceeds only if C983 demonstrates
  one genuine shared kernel and material cross-domain state reduction.  Its
  corrected application benchmark protocol now covers eight README/paper
  workloads with symmetric cold and eight-solve warm batches, streamed raw
  evidence, independent replay, and three-round long controls.  The six
  completed cold application comparisons have a 104.16x geometric mean;
  the represented tower is >87,743x, and the published Hamming-outer LRC is
  657.88x with log-ratio `t=49.09`.  The README, benchmark guide, figures, and
  37-page manuscript use only the corrected evidence; the release gate passes.
  Its subsequent
  [Gurobi product-boundary memo](../2026-08-29-c985-ergodis-gurobi-boundary-and-semantic-symmetry-spike.md)
  positions Ergodis as a theorem-aware semantic compiler and certifier in front
  of Gurobi, SCIP, Kissat, or its native backend, rather than as a generic MIP
  competitor.  The first C997-derived Rust spike compiles and independently
  verifies nonempty-support coordinate-orbit covers; the Gross two-block
  translation control reduces 144 anchors to `[0, 72]`.  Domain invariance is
  deliberately not trusted by that generic layer.  A concrete small binary
  invariance adapter now consumes canonical flat support/cost records, verifies
  generator preservation and exact cost invariance, replays both obligations,
  and rejects malformed models or changed actions.  Direct and anchored minima
  agree, and anchored evaluation allocates nothing.  Binary linear-model
  emission now has a bounded external-boundary control: deterministic streamed
  one-hot LP, source-plus-cover identity, and allocation-free single/complete
  result replay with omission, duplication, identity, claim, feasibility, and
  optimality rejection.  It is not a scaling representation, and no installed
  Gurobi/SCIP/HiGHS executable was available for a parser round trip.  The
  native parity path now extends through an isolated six-word specialization
  to the official QDistSAT `BB_360_12_?` matrices.  Both CSS directions
  independently certify exact distance 24 after a combined 192,001,784,180
  candidates and 469.322088944 seconds of search; block-swap plus torus
  inversion independently proves their equivalence.  The published radius-20
  portfolio completed 0/46 configurations at 7,200 seconds, whereas Ergodis
  closes both directions in 12.470892325 seconds warm.  The prior five-word
  BB288 layout and artifact format are unchanged, and its post-change control
  shows no slowdown.  The atomic report is
  [C985 BB360 exact distance](../2026-08-29-c985-qdist-bb360-exact-distance.md).
  The next gate is an algebraically prefiltered weight-six discovery search for
  a Pareto survivor with `k d^2 / n > 19.2`; a broad generic-SAT claim remains
  out of scope.
  The follow-on [BB756 large-code spike](../2026-08-29-c985-bb756-large-code-spike.md)
  adds an opt-in 12-support-word/6-syndrome-word backend and directly generates
  the published `[[756,16,<=34]]` construction.  It certifies `d >= 24` through
  radius 22 in 32.793410331 seconds on 16 threads at 23.6 MiB RSS.  Its
  large-only streaming completion compiler finishes cold in 1.538285858
  seconds, versus an interrupted >90-second old path.  A 40-run interleaved
  BB288 A/B gives current/old ratio 0.997266 and `t=-0.1229`, so the large
  extension does not measurably hurt smaller solves.  Exact distance remains
  open pending stronger completion pruning and a replayable weight-34
  incumbent; the installed restricted Gurobi license cannot instantiate the
  756-qubit model.
  The next larger published control is now closed as well: the
  [BB784 exact-distance certificate](../2026-08-29-c985-bb784-exact-distance.md)
  widens only the opt-in large backend to 13 support words and certifies the
  published `[[784,24,24]]` code.  The 16-thread exact radius-24 run examines
  29,319,071,014 candidates in 127.077243335 seconds at 23.4 MiB peak RSS;
  an independent replay validates its weight-24 logical witness.  This is a
  larger-code result, not a new-code claim.  The next discovery gate remains
  an algebraically deduplicated weight-six sweep with direct-sum rejection.
  A broader search found a higher-value target outside the BB family.  The
  [SCE R2Elite01 certificate](../2026-08-29-c985-sce-r2elite01-distance.md)
  reconstructs the published non-abelian lifted-product `[[1496,194,<=20]]`
  candidate and closes it exactly as `[[1496,194,20]]`.  The generator proves
  that the central involution preserves both presented check families and
  solves the natural blockwise left/right deck equations, reducing 1,496
  anchors to 748; each natural deck family has exactly two actions.  The two
  radius-18 misses examine 712.48 billion candidates in 4,247.838 seconds
  combined, while a deterministic native random-information-set search finds
  an independently replayed weight-20 X-type logical at trial 765.  The exact
  figure of merit is `9700/187 = 51.87166...`, 2.702x BB360.  The reusable RIS
  worker allocates nothing per trial, and the huge exact backend remains about
  40 MB RSS with streamed final evidence.
  The adjacent
  [SCE R2Elite02 exact certificate](../2026-08-29-c985-sce-r2elite02-exact-distance.md)
  closes the stronger immediate target: it independently reconstructs the
  published `[[1496,198,<=16]]` dihedral lifted product, exhausts both CSS
  directions below 16, exhausts X through 16, and independently replays a
  weight-16 X-type logical.  Hence the code is exactly `[[1496,198,16]]`, with
  exact figure of merit `576/17 = 33.88235...`, 1.765x BB360.  The radius-16
  runs examine 116.97 billion candidates in 647.943 seconds combined at the
  same low-memory huge backend; no non-abelian orbit reduction is assumed.
  The portfolio-import programme has begun with the
  [verified commutant foundation](../2026-08-29-c985-ergodis-commutant-foundation.md):
  induced binary subspace and nested-quotient actions, full commuting algebras,
  central-idempotent block coordinates, and exact extension-field certificates.  The packed
  rank-63 correctness gate and CSS logical-quotient adapter pass; segmented
  large-rank syndrome support and hot-backend integration,
  and clean performance measurements remain open.  Minimal-polynomial
  irreducibility has replaced exhaustive field-element rank testing, with a
  diagnostic three-pair counter A/B showing 20.09x fewer instructions and
  19.90x fewer cycles at degree eight; the shared-host result is not a paper
  benchmark.  Bounded oracle-independent commutant search now discovers exact
  `F_4` and `F_8` scalar actions and rejects `F_4 x F_2`; its Gray-code scan,
  rank filter, power recurrence, and fixed labelled reducer allocate nothing
  per candidate, and an exhaustive `2 x 2` oracle plus allocation-growth gate
  pass.  Misses remain bounded negatives, not indecomposability claims.
  Work Package B has also landed its first theorem import: arbitrary rowspace
  functionals now recognize the exact even-kernel condition and parity-round
  residual degree and packing bounds without hot-loop allocation or a
  run-constant branch.  On a diagnostic three-pair, 500-round Gross A/B this
  removes 28.91% of candidates and 19.2% of cycles, while one-shot cold time
  remains compile-dominated.  Higher residues and moment images remain open.
  Profiling then assigned 95.81% of BB288 compile cycles to the optional
  fourth-order completion Bloom.  A family-independent 10-million-quadruple
  work cap now selects streamed triples and a universal four-filter: BB288
  compile is 84.35x faster, its artifact 4.45x smaller, and compile-only RSS
  13.97x smaller, while compiled-in search wall time is statistically
  unchanged in the diagnostic A/B.  Small presentations retain the stronger
  four-filter.  The adjacent Gross crossover supports the cap: the smaller
  representation remains 1.097x faster across 500-round pairs despite 39.3%
  more candidates, because it removes about 192x cache misses.
  The clean continuation is now recorded in
  [C985 completion compression and wide search](../2026-08-30-c985-completion-compression-and-wide-search.md).
  Exact bounded-multiplicity syndrome types, saturated-filter abandonment,
  and adaptive Bloom hashing improve cold compilation 3.361x on BB756 and
  476x on R2Elite01.  Parity-compatible monotone packing and hardware-target
  specialization improve warm search 1.344x on BB288, 1.460x on BB756, and
  1.389x on the exact R2Elite02 Z application.  The BB756 search removes
  54.4% of instructions and 30.2% of cycles at about 24 MiB RSS.  All changes
  remain iterative and allocation-free in the candidate loop.
  The read-only cross-lane/open-problem scan is ranked in
  [C985 cross-domain gem scan](../2026-08-30-c985-ergodis-cross-domain-gem-scan.md).
  Its highest-EV common stepping stone is a small exact continuation-hierarchy
  API, with B3/H3 double-coset information levels as the first fixture; C80's
  cap game and the gated `R^18` real-rooted polynomial enumerator are the two
  flagship adapters.  The C1000 large enumeration remains unapproved.
  The common stepping stone is now implemented in
  [C985 continuation hierarchy and Hall engine](../2026-08-30-c985-continuation-hierarchy-and-hall-engine.md):
  nested context alphabets compile to replayable exact quotient towers with
  allocation-free level selection/projection, and the B3/H3 controls realize
  `1 -> 2 -> 6 -> 2q` through one API without retaining cloned transition
  tables.  A pre-sized iterative Hall backend streams and replays exact
  matching/deficiency certificates and passes all 4,096 `3 x 4` graphs against
  brute force.  On C80's q=11 falsifier the causal-only reply-resource graph is
  deficient by one while the complete certificate-reply graph saturates both
  new defects.  The first projectively natural consumed-label lift now also
  passes: a direct edge uses an attacked reply that is itself an old label, and
  a deletion-secant edge uses a consumed old label on the causal/reply line.
  This matches the two original q11 defects to `(3,7)` and `(7,10)` and
  saturates all three certified q23 replacement representatives.  A bounded
  hostile q11 scout then rejects the candidate theorem on its first tested
  complete exchange: two consumed labels are replaced by two new defects, both
  with singleton neighbourhood equal to the causal label, giving an exact
  deficiency-one Hall set and no strict support-cardinality drop.  Primary
  bitmask, independent determinant, and Rust Hall replay agree; the overload
  coordinate falls `10 -> 0 -> 0`.  The successor is N (its only two legal
  moves conflict), so this rejects a universal exchange law but not existence
  of a different good reply for every opponent.  An exchange motif plus
  lexicographic descent is the surviving C80 stepping stone only when paired
  with an explicit P-survivor reply-admission predicate.  The coarser complete-exchange
  relation then removes matching entirely: Hall is exactly
  `consumed >= created`.  Deterministic diagnostics find zero failures of that
  inequality or of support-first `(cardinality, Omega)` descent across 65,464
  q11 and 2,953 q13 exchanges with new defects.  Every one of the 234
  equal-support cases in the 1,000-state q11 sample has the locked profile
  `2/2/2/10/0`.  These are sampled stepping-stone data, not a uniform theorem.
  Since q11 and q13 are already proved cap-game base fields, the surviving
  theorem shape is strict consumed-label surplus above a field threshold plus
  the existing finite bases; this is now a counting problem rather than a
  matching problem.  The first game-semantic admission predicate now requires
  re-entry into the proved `K_Omega` survivor with strict `Omega` drop before
  applying the charge test.  Deterministic controls admit all 6,124 q11 and
  1,930 q13 opponent fibres.  All 23,000 q11 certified replies are
  support-equality cases with minimum `Omega` drop 6, whereas all 10,428 q13
  replies have strict support surplus with minimum 18.  This identifies a
  q11-equality/q13-surplus counting split but remains sampled evidence using
  the existing survivor certificate, not a uniform theorem.  Every sampled
  legal reply already decreases `Omega`; the only failed admission condition
  is re-entry into `K_Omega`, and some fibres have a unique certified reply.
  The
  once-validated Pareto objective wrapper also closes its hostile
  same-cardinality-order gate and gives 1.028--1.044x warm gains on two clean
  20-pair protocols. The C880 aligned-attachment backend now has an independent
  outer solve--replay--cut boundary after a Gurobi presolve incumbent escaped
  callback enforcement; unreplayed objectives are never reported as
  incumbents. Its native DFS can opt into exact setwise-stabilizer
  canonicalization with no hot-loop allocation. Monotone unresolved-cut masks
  and compiled crossing-triple masks remove discharged and irrelevant work.
  Incremental per-depth group images remove repeated canonical remapping.
  A 1.73 MiB factored meet-in-the-middle clause table is 18.75x smaller than
  full colouring materialization and adds 1.201x. Completed controls improve
  5.78x at `n=6` and about 68.1x on a rooted `n=8` exclusion; the crossing-mask
  and incremental-image slices add 1.746x and 1.077x respectively. A
  parity-DSU alternative is rejected as 1.674x slower. A bounded rooted
  budget-16 probe remains incomplete, and the exact `15 <= g(8) <= 17` gap is
  unchanged. The next C880 gate is a proof-producing symmetry-quotiented orbit
  sweep or a genuinely aggregate context rank inequality, not more first-order
  Gurobi pulse tuning. An opt-in exact five-byte combinatorial duplicate key now
  replaces eight-byte masks when the rooted cardinality layers fit 40 bits. It
  cuts `2^22`-slot process RSS 33.4% (`36,680 -> 24,420` KiB), is 1.036x faster
  under the loaded sweep, and keeps exhaustive key/search/allocation gates. The
  full 28-case wide `2^26` weight-15 sweep closes only roots `[0,1,2]` and
  `[0,1,6]`; the other 26 exhaust exact capacity at about 528 MiB RSS each.
  These diagnostics are not UNSAT certificates and do not change the proved
  bound. A compact `2^27` retry of `[0,1,11]` makes 134,217,728 exact slots
  practical at 659,164 KiB RSS but also exhausts capacity. Further syntactic
  growth is abandoned. Cardinality plus the 127 parity-component closures is a
  valid optimal-continuation quotient (not a literal syntactic-trace
  congruence), and its caller-buffered signature/equal-optimum controls pass.
  It is not admitted as a backend: the exhaustive five-point census merges only
  `9/1,024` states, all near saturation, and a deterministic 100,000-family
  rooted weight-15 sample has zero exact merges after bytewise collision replay.
  The first aggregate bound is now admitted: an iterative, allocation-free
  exact residual hitting oracle for the final three selections. It cuts rooted
  budget-10/11/12 states by 6.82x/6.35x/5.33x and improves the seven-round
  budget-12 wall time 1.841x (`t=267.262`). On the actual `[0,1,2]` weight-15
  orbit it reduces states `62.71M -> 24.03M`, capacity `2^26 -> 2^25`, wall
  time `310.37 -> 215.38` seconds, and RSS `527,600 -> 265,672` KiB. Extending
  that bound and adding proof-producing search are the next route. A `2^25`
  sweep over the 26 formerly failed roots closes four more, for 6/28 total
  rooted diagnostic closures, at 23.20--26.47 million states and at most
  265,884 KiB RSS; the other 22 still fill the exact table. This is evidence
  that the aggregate bound transfers across roots, not an UNSAT certificate or
  a change to the proved bound.  The residual backend is now separately
  reusable and proof-producing: commit `a9f8bfd1e` adds a pre-sized iterative
  bounded-transversal solver plus a canonical streamed negative certificate
  and independent verifier, exhaustively checked on every four-vertex
  hypergraph.  Its flat subset proof is a correctness baseline and may have
  combinatorial output; a streamed branch DAG is the next proof-compression
  target, and global C880 search replay is still open.  The higher-level C80
  workflow is specified as a runtime typed attack-plan controller in
  [C985 adaptive attack controller](../2026-08-30-c985-adaptive-attack-controller.md):
  exact features are compiled once, many diagnostic/ordering plans race by
  successive halving without Rust recompilation, and only replay-gated typed
  predicates may prune or admit.  FunSearch/AlphaEvolve supply the compact
  program and proposer--evaluator--archive pattern; Ergodis adds theorem-role
  effects, permanent falsifiers, and universal-claim gates.

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

C980 and C984 are closed after structural compression, manuscript promotion,
and independent review.  Keep the probe census, rank-stratified algorithms,
Pareto, fixed-batch packing, and multi-target state algebras outside the primary
manuscript.
C962's bounded representation work was accepted as sufficient, further
candidate-parity experiments were cancelled, and its private task-owned code
and evidence are committed.  No successor was allocated for the optional
optimization work.  C983 and its C987 application crossover control are
closed; neither blocks the paper closeout.  C985 is the next optimization-facing
research task.  The primary-paper route remains C325 appendix-only verification,
followed by C953
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
