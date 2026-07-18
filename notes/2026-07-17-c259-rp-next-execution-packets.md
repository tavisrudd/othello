# C259 — `rp-next` execution packets

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — C258's three primary rewards are packaged for execution with owners,
destinations, inputs, ordered work, validation gates, claim limits, and stop conditions. Two banked
mini-packets are retained without creating a new backlog. The `rp-next` lane is complete.

## Portfolio routing decision

| Priority | Packet | Owner | Destination | Start condition |
|---:|---|---|---|---|
| 1 | M1 — focused complete-port manuscript | `complete-ports` paper lane | existing `papers/coding-repair-hypergraphs/`; decide rename versus retitle before any fork | may start now |
| 2 | P1 — Capsule CLI and recovery digital twin | proposed new `portcaps` implementation lane | proposed `tools/repair-port-capsule/`, with language/layout fixed by its first task | may start after owner/path approval; independent of M1 prose |
| 3 | M2 — compositional restoration semantics | proposed new `repair-semantics` paper lane | proposed `papers/bounded-restoration-semantics/` | start after M1's scope freeze prevents theorem duplication |
| Bank A | N1 — TTSP reliability counterexample note | paper/literature owner selected by user | no package until novelty gate passes | dormant |
| Bank B | F1 — coefficient-cost compiler module | future `portcaps` lane | optional module under the accepted Capsule schema | only after P1 schema stability |

The recommended next lane is `complete-ports` for M1. P1 is the best choice if the next objective is
engineering validation rather than publication. M2 is mathematically coherent but should not race
M1 for definitions, examples, or theorem ownership.

## Dependency map

```text
C215--C227 + C243--C244
        |
        +--> M1 focused complete-port manuscript
        |
        +--> P1 structural Capsule schema
                  |
C229--C235 + C241 + C246
        |         +--> P1 simulator / digital twin / verifier
        |
        +--> M2 compositional restoration semantics

C217 + C255 --> F1 coefficient-cost module (after P1 schema)
C245 + C254 --> N1 reliability note (after novelty gate)
```

M1 and P1 may proceed concurrently once ownership is explicit. M2 depends only on M1's scope
freeze, not on completion of the paper or prototype. Prototype measurements may later strengthen
motivation, but none of the mathematical correctness claims depend on them.

## Packet M1 — focused complete bounded repair ports

### Objective and claim

Produce one short theorem-led manuscript whose thesis is that a complete bounded repair port is the
right local invariant for linear-code recovery, with exact transfer, realization, reliability,
pointed-Tutte, and contrasting geometric-family results.

**Claim ceiling:** B+ expected, credible A-minus ceiling. No storage-performance, threshold,
capacity-region, or generic knowledge-compilation claim without new evidence.

### Owner and destination

- **Owner:** `complete-ports`; the archived `repaircodes` lane retains the completed theorem chain.
- **Destination:** `papers/coding-repair-hypergraphs/`.
- **Fork rule:** do not create a second manuscript tree. The owner first chooses whether the
  existing manuscript is retitled/restructured or whether an explicitly approved new paper package
  supersedes it.

### Inputs

- core: C215, C216, C218, C219, C226, C227;
- selected flagship strengthening: C220, C243, C244;
- current paper definitions and existing citations;
- certificates/scripts already named by those reports.

### Ordered work

1. **Freeze a theorem crosswalk.** Map every retained theorem to its report, proof/certificate,
   notation, and intended manuscript section. Mark every existing manuscript claim as keep,
   replace, move, or delete.
2. **Freeze exclusions.** Exclude C229--C241 composition, general C235 service regions, full
   C217/C255 coefficient optimization, LC history, tract/foundation positioning, and product
   architecture.
3. **Set the six-part spine.** Object; exact transfer; asymptotic realization; reliability/EXIT;
   pointed Tutte; cubic versus harmonic/quartic-nucleus flagships.
4. **Integrate the flagship pack.** Use C243's deterministic nucleus gate and C244's exact blocker,
   enumerator, corrected EXIT, and design-layer results. Include C220 only when it shortens the
   cubic story.
5. **Run a specialist citation/novelty audit.** Check quotient/projective weights, coset leaders,
   matroid ports/perspectives, reliability/EXIT, LRC realization, and Steiner-system boundaries.
6. **Assemble and validate.** Replay every paper-facing exact artifact; ensure counting
   conventions, q-ranges, EXIT dimension ledger, and local/full-MAP distinctions are consistent.
7. **Grade honestly.** Evaluate the frozen manuscript, not the repository portfolio, against the
   B+/A-minus claim.

### Validation gate

- every theorem statement has one exact evidence owner;
- every computational statement has a replayable certificate and independently checked convention;
- no q=9 observation is phrased as an all-field theorem;
- no bounded repair statement is conflated with full MAP decoding;
- the manuscript contains one narrative and no unmotivated application catalogue; and
- any Lean changes, if later chosen, use the separate Lean gate owned by the destination lane.

### Stop conditions

- Stop and split before importing sequential composition as a second thesis.
- Drop any C243/C244 consequence that requires a new census or overlap classification.
- If the current manuscript's architecture cannot accept the six-part spine without duplication,
  request the user's paper-package decision; do not maintain two live versions.
- Do not delay submission assembly for P1 benchmark results.

### First executable work unit

Create the theorem crosswalk and keep/replace/move/delete audit inside the `repaircodes` handoff.
That unit is reversible, exposes the true rewrite bill, and requires no paper prose edit.

## Packet P1 — Repair Port Capsule CLI and digital twin

### Objective and claim

Build an offline compiler that turns a code matrix plus deployment annotations into exact bounded
repair semantics, then answers recovery counterfactuals with replayable evidence.

**Claim ceiling:** useful prototype and product falsifier. No systems-paper, commercial superiority,
or globally optimal repair claim before comparative measurements.

### Owner and destination

- **Owner:** a new `portcaps` implementation lane after explicit user approval.
- **Proposed destination:** `tools/repair-port-capsule/`.
- **First architecture gate:** choose a Python reference implementation or Rust CLI by auditing
  reusable finite-field/circuit code, packaging needs, and expected instance size. Preserve one
  language-neutral signed JSON schema either way. This choice is intentionally not made by C259.

### Inputs

- structural compiler semantics: C219, C226--C227, C229, C241, C246;
- sequential timing and witnesses: C230--C234;
- capacities and dual prices: C235;
- architecture and baseline list: C238--C239;
- checker/lineage pattern and negative boundaries: C250--C253;
- optional coefficient layer later: C217/C255.

### Ordered work

1. **Freeze schema v0.** Code/version hash, field, target, radius, normalized supports and
   coefficients, blockers, Horn rules, optional boundary profiles, evidence hashes, and freshness.
2. **Build the reference compiler.** Parse small prime/extension-field matrices; enumerate or lazily
   represent bounded target circuits; independently verify every emitted equation.
3. **Build the structural simulator.** Parallel/sequential closure, arrival rounds, residual
   stopping core, and repair witnesses.
4. **Add resource analysis.** Recovery-set LP, helper-price duals, and a small time-indexed MILP
   oracle; compare greedy, configured-group, and unlock-aware choices.
5. **Add digital-twin queries.** Node/rack/failure-domain counterfactuals, mandatory/pivotal helpers,
   feasible repaired fraction, bottlenecks, and intervention ranking.
6. **Add a small plan verifier.** Check code identity, equations, prerequisites, capacities, and
   claimed target completion; retain C250's proof-carrying pattern without novelty wording.
7. **Benchmark before integration.** Only a decisive offline result may promote an HDFS/Ceph
   adapter or systems-paper task.

### Correctness corpus

- RS/MDS and Azure-style or layered LRC layouts;
- the committed cubic/harmonic q=9 fixtures and a larger-field replay;
- random small matrices with an independent grid/linear-algebra oracle;
- deliberately mutated coefficients, stale hashes, missing prerequisites, and false completion
  claims; and
- C229's three-way closure witness, C231's relay, C235's `8/3` bottleneck, and C251--C253 regression
  fixtures under their stated synthetic boundaries.

### Benchmark gate

Report capsule size/build time, query latency, plan-verification cost, locally and sequentially
repaired fractions, makespan/oracle gap, helper imbalance, cross-domain bytes, and diagnostic
accuracy. Compare configured repair groups, full reconstruction, greedy complete-port selection,
and the small MILP oracle at equal failure/resource inputs.

### Stop conditions

- Stop product promotion if complete ports make indistinguishable decisions from standard policies
  on representative traces.
- Stop eager compilation if capsules do not remain compact; switch to lazy mode generation before
  widening the corpus.
- Stop runtime-controller work if verification/capsule overhead is material relative to recovery.
- Do not add agent proposal generation, coefficient-cost optimization, BDD/ZDD reliability, or
  cluster integration before the structural compiler and simulator pass.

### First executable work unit

Allocate the `portcaps` lane and decide the implementation language/path using a bounded reuse and
packaging audit; then write schema v0 plus one matrix-to-capsule golden fixture. No scheduler is
needed for the first commit.

## Packet M2 — compositional restoration semantics

### Objective and claim

Develop the exact finite-structural/infinite-quantitative interface theorem into a separate
semantics/algorithms manuscript.

**Claim ceiling:** B+ now. An A-minus ceiling requires either a genuine extension beyond
represented matroid 2-sum trees or a precise theorem showing a preservation/minimality gap in the
strongest generic interface framework.

### Owner and destination

- **Owner:** proposed new `repair-semantics` lane after user approval.
- **Proposed destination:** `papers/bounded-restoration-semantics/`.
- **Dependency:** M1 must first freeze its exclusions and notation ownership; no need to wait for
  M1 completion.

### Inputs

- C229--C234 for closure, depth, 2-sum composition, finite obstruction, structural control, and
  infinite timing algebra;
- C241 for the exact bounded-branchwidth algorithm;
- C246 for realizability, full abstraction, minimality, and distinguishing contexts;
- C236 as the flagship static/sequential/global separation;
- C235 only as an optional capacity example.

### Ordered work

1. Freeze a theorem dependency diagram and one common interface notation.
2. State the central finite-control/infinite-value dichotomy before presenting examples.
3. Separate structural closure/core/count semantics from synchronous timing and capacity.
4. Build the exact comparison matrix against Datalog/Horn systems, weighted automata, provenance,
   abstract interpretation, quantitative contracts, and branch-decomposition algorithms.
5. Run one bounded generalization probe beyond represented matroid 2-sums, chosen only after the
   comparison identifies the missing hypothesis.
6. Use C236 for meaning and C229/C231 for minimal witnesses; avoid a catalogue of all certificates.
7. Decide paper/no-paper at the generalization/comparison gate before prose expansion.

### Validation gate

- replay all C229--C234, C241, and C246 certificates used by a paper-facing claim;
- keep exact synchronous timing on the infinite carrier;
- state supplied-decomposition versus decomposition-construction complexity honestly;
- retain realizable-input and masked-output qualifications from C246; and
- demonstrate one claim that is not generic Horn closure, semiring evaluation, or interface
  minimization by renaming.

### Stop conditions

- Stop paper promotion if the strongest generic formalism supplies the same exact interface and
  minimality theorem after direct translation.
- Stop the generalization probe after its predeclared first counterexample or proof obstacle; do
  not begin a new broad PL program inside this packet.
- Do not seek a finite timing alphabet, Tutte-style minor recurrence, or more q=9 tables.

### First executable work unit

After M1 scope freeze, allocate `repair-semantics` and write the theorem dependency/comparison
matrix. That matrix determines whether the one permitted generalization probe is justified.

## Banked mini-packet N1 — TTSP reliability note

- **Input:** C254 exact family, composition identities, minimal 14-edge sweep, and C245 conjecture
  correction.
- **Gate:** a dedicated literature search must find no prior TTSP/two-terminal `N_i`
  log-concavity counterexample family.
- **If green:** write a compact counterexample note centered on the infinite family and the positive
  series-composition island; the exhaustive minimality result is supporting evidence.
- **If red:** retain as an appendix/caution in the repository; do not allocate a paper.
- **Stop:** no renewed ULC/LC conjecture or Hodge program.

## Banked mini-packet F1 — coefficient-cost Capsule module

- **Input:** C217 coefficient holonomy/cross-ratio and C255 exact `GF(9)` cost separations.
- **Gate:** P1 schema v0 must preserve coefficient labels and a realistic multiplier/table-cost
  model must exist.
- **If green:** implement gauge-invariant cost normalization as an optional compiler pass with the
  exact `U(2,4)` pair as a golden test.
- **Claim:** representation-aware implementation feature, not a new switching optimizer.
- **Stop:** if the chosen codec/hardware cost model makes the strict pair operationally irrelevant.

## Explicit non-packets

Do not allocate follow-ons for ordinary/ULC profile shape, peeling minors, generic tracts,
asymptotic MSP lifting, generic proof-carrying planning, decision-focused active learning,
continuation resilience, separator-profile embedding dimension, harmonic thresholds, or a generic
Capability Compiler platform. Their negative or positioning results are already harvested.

## Lane closure

`rp-next` has no remaining allocated mathematical, product, or consolidation work. Archive this
handoff and update root routing only after the user approves. The recommended next selection is
`complete-ports` to execute M1; select or create `portcaps` instead if prototype validation is the
priority.
