# C1061 exploration log: Ergodis as a compiled dynamic decision engine

**Lane**: `complete-ports`
**Brief**: `2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**Mode**: open-ended; append-only; each entry names the probe, the evidence location, and the
verdict (promote / drop / open). Findings that deserve their own file get a dated note and a
one-line pointer here.

## Entries

- 2026-09-03 — allocated; brief written; event-sourcing/CQRS shell added to brief.
- 2026-09-03 — probe 1 launched: survey of existing composition / interface / min-sum machinery
  in `~/src/ergodis` and `~/src/ergodis-private` for associativity, retained composition trees,
  and delta hooks; first incremental-recomposition prototype with a sequence benchmark. Report:
  `2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`. Verdict: **promote**.
  Survey: core has associative min-plus / Pareto / frozen-shortest-path composition and an
  exhaustive associativity certifier, but no leaf identity, no repairable retained tree, and no
  `apply_delta` in either repo. Prototype `delta_composition` in ergodis-private (commit `cbf2332`):
  64-byte min-plus boundary summary, flat balanced tree, typed `Delta` enum, allocation-free
  leaf-to-root update, `DeltaRun` event monoid. At 16,384 leaves: fresh solve 4.93 ms vs delta
  mean 614 ns (p50 491 ns, p99.99 14.6 us), 0.046% of nodes recomputed, break-even about one
  update, zero allocations. Monoid collapse k=8 gives 7.06x. The collapse law exposed a lossy
  saturating cost store that broke the group action; fixed by signed store, clamp at leaf.
  Congruence is exact for the declared vocabulary; quotient infinite only through unbounded cost.
  Interface width (4 labels), not chain length, drives cost.
- Open next probes (from probe 1): witness/certificate deltas; tropical normalization to test
  finiteness of the quotient; several semirings over one topology; bind a real capacitated batch
  kernel (`azure_lrc_12_2_2_counted`); `schedule_repair_dag` is not a candidate (subset-mask BFS
  has no per-leaf factorization).
- 2026-09-03 — probe 2: real kernel binding, witness deltas, quotient finiteness. Report:
  `2026-09-03-c1061-probe2-real-kernel-witness-deltas.md` (ergodis-private `525a82b`). Verdict:
  **promote**. A fleet of LRC(12,2,2) pods bound as leaves of the retained tree, coupled only
  through a four-level shared cross-rack repair budget; `FleetSchema` separates stable schema
  from mutable parameters and derives each event's affected leaf set from declared schema facts;
  grain and pod-count events return `RebaseRequired`. At 16,384 pods: fresh solve 19.1 ms vs
  delta mean 1.89 us, break-even 1.13 updates, zero allocations. Delta cost is flat in fleet
  size because the ten kernel calls per leaf dominate the log-depth walk, so probe 1's
  monoid-collapse win does not transfer here. Witness deltas: argmin split labels repaired on
  the same path, +35% per update, +17% state; reading the whole witness out stays O(pods)
  (2.6 ms, only 7x below fresh). Tropical normalization: 2 normalized leaf classes (from 25 raw)
  and 4 root classes (from 1,338 raw) over 20,000 events, so a four-state weighted transducer
  plus scalar offset is a real target; measured reachable set, not a proved bound. Symmetry
  finding: sorting data-domain capacities is exact only when demand is a multiple of six
  (multiplicity vector), so it applies to 23% of pods; fix is canonicalizing
  (capacity, multiplicity) pairs. Open: witness readout locality; proved class bound.
- 2026-09-03 — probe 4: evolve congruence objective (smallest sufficient statistic closed under
  the update monoid). Report: `2026-09-03-c1061-probe4-evolve-sufficient-statistics.md`
  (ergodis-private `015f487`, module `congruence_search.rs`). Verdict: **promote**. Evolve's
  current fitness is per-row label correctness over a sealed feature batch and cannot express a
  pairwise, event-closed condition; the closest machinery is `feature_ceiling`. The new scorer
  keeps three counters (exactness, single-step closure over a generator-closed set, quotient
  size) and never collapses them. Planted test: on Opt = min(a) + sum(b) + T[c mod 3] with 19
  sealed features and 7 generators the closure objective recovers exactly the planted statistic;
  corpus exactness alone returns the answer itself and an additive decoy, each with thousands of
  closure violations. Design finding: the two decoy classes fail different conditions (an index
  decoy has zero closure violations and fails exactness on the reachable closure; the answer
  itself is exact and fails closure), so both counters are necessary; the bare Myhill--Nerode
  condition would admit the index decoy. Probe-1 toy: no compression on the parameter side
  (minimal closed statistic is the full parameter record; probe 1's win is the retained tree,
  not a state quotient), and the clamp-at-evaluation fix from probe 1 shows up as the price of
  closure vs exactness for the two encodings. On the summary side tropical-projective
  normalization is composition-compatible with 5 leaf classes and root classes growing
  12/36/98/219/540 against 25 to 15,625 assignments, so Q = (finite normalized class set) x Z.
  Evolve cannot reach that quotient because its VM is i64-valued; next step is sealing a
  `normalized_class_id` feature through the feature-DAG presentation transition.
- 2026-09-03 — probe 5 candidate (from the snapshot-speedup question): accelerate the initial
  snapshot bind using probe-2 observations: memoize leaf kernels by normalized class with an
  exact miss path; compose runs of identical leaf classes by repeated squaring; treat
  snapshot-from-snapshot as a bucketed delta batch with subtree rebuild O(k log(n/k)); compile
  leaf classes as piecewise functions of the shared budget level; run-length witness readout.
  Gate to watch: the 2-class leaf census is stream-specific and needs a hostile stream or a
  proved bound.
- 2026-09-03 — probe 3: incremental certificates. Report:
  `2026-09-03-c1061-probe3-incremental-certificates.md` (ergodis-private `83773c6`, module
  `incremental_certificate.rs`). Verdict: **promote**. Hash tree over the retained tree's own node
  summaries; an internal digest commits to the composed summary plus child digests, so checking
  the digest chain checks the min-plus composition law. Snapshot certificate plus independent
  recomposing verifier; delta certificate checked in O(depth) by a verifier holding 72 bytes
  (artifact, root, sequence). At 1,024 / 16,384 leaves: 1,168 / 1,552 bytes per event, verify
  4.6 / 6.0 us, full re-verification 129x / 1,748x more expensive. 100,000-event chains verify
  with zero disagreements; forged ancestor, event, leaf, base matrix, wrong artifact,
  truncation, and replayed stale deltas each fail closed. Monoid collapse: one certificate per
  run of k events on a leaf, verification still O(depth), 146 bytes/event at k=8. Crash
  recovery round-trips through a file and replays to an identical root; full-history replay
  matches. Cost finding: about 95% of the certified path is SHA-256, so the proof chain costs
  about 20x the update it certifies; `target-cpu=native` is a recorded negative, lever is a
  SHA-NI `sha2` backend or BLAKE3 (already a core dependency). Literature to search before any
  novelty language: authenticated data structures (Merkle, Naor--Nissim, Tamassia, Miller et
  al., Certificate Transparency consistency proofs), incremental view maintenance with proofs,
  verifiable state machines and folding schemes, certifying dynamic graph algorithms, tropical
  segment trees; only "historical decision provenance for an optimization answer" looks
  unoccupied and is a composition of two mature ideas. Accessor hook for `delta_composition`
  described in the report, not applied.
- 2026-09-03 — probe 5: snapshot-bind acceleration. Report:
  `2026-09-03-c1061-probe5-snapshot-bind-acceleration.md` (ergodis-private `6403357`). Verdict:
  **promote, layout-conditional**. Canonicalization defect fixed: `LeafClassKey` sorts
  (capacity, multiplicity) pairs and keys the two global-parity capacities by their sum, exact
  for every demand residue because both kernel feasibility tests are symmetric functions of that
  multiset (40,000 hostile draws). Wins: leaf-class memoization 4.4x on a 24-rack-type fleet
  (99.85% hit rate); run composition by repeated squaring 276 to 292x on a blocked fleet (25 runs
  over 16,384 pods); budget profile 19x per grain change. Negatives: memoization is a 34%
  slowdown on a fleet of unique pods (4% hit rate); witness run-length compression is 1.0x on an
  interleaved fleet. Fleet layout is the hidden parameter behind both big wins.
  Snapshot-from-snapshot beats a full rebuild by three to four orders of magnitude at every k;
  merged bottom-up rebuild wins over independent paths for large k and loses slightly at k=1,
  dispatch threshold between k=4 and k=16. Budget dependence reduces to composing precompiled
  matrices, so `BudgetGrainChanged` moves from a rebase exit to an in-envelope parametric event
  (0.85 ms, no kernel call). Redirects: the hostile stream shows the class space is not small
  (193,473 classes per 200,000 draws) even though only two to three tropically normalized
  summaries occur, so the table must be keyed on the summary, not the class; witness O(pods) cost
  is kernel-bound materialization, so serving witnesses from the class cache is the highest-value
  follow-on.
- 2026-09-03 — probe 3 follow-up launched: hash backend A/B on the certified path (sha2 baseline,
  SHA-NI/asm sha2, BLAKE3 single and batch, non-cryptographic lower bound, fewer hash calls).
  Certificate work is engineering, not a paper; no further novelty effort.
- 2026-09-03 — measurement caveat: the box was loaded with concurrent builds and benchmarks
  during probes 2, 3, and 5, and their ratios are wall-clock. Every wall-based verdict in those
  entries is provisional until re-measured in hardware counters (instructions and cycles).
  Probe 6 re-measures probes 2 and 5; the hash-backend A/B re-measures probe 3's baseline.
  Probe 1's counter numbers (about 2,366 instructions / 1,025 cycles per update) stand.
- 2026-09-03 — probe 3 follow-up: hash backend A/B (counters, 7 interleaved paired rounds, 95%
  CIs). Appended to `2026-09-03-c1061-probe3-incremental-certificates.md` (ergodis-private
  `3971eb6`). Verdict: **switched default to `sha256-packed`** (SHA-256 compression over packed
  fixed-size blocks, domain in the initial state, no length block; 128-byte internal-node
  preimage is two compressions instead of three): 0.665x baseline cycles per emit+verify at 1,024
  leaves (CI [0.661, 0.668], t = -196) and 0.674x at 16,384 (CI [0.648, 0.701]). SHA-NI is not a
  separate candidate: `sha2` 0.10.9 already selects it at runtime (force-soft is 4x slower),
  which also explains the earlier `target-cpu=native` null. BLAKE3 is 2.0x worse at 76- and
  128-byte sequentially dependent preimages; the non-cryptographic mixer is kept only as a
  labeled lower bound (0.16x). Counter re-measurement: certified pair costs 22.0x the
  uncertified update at 1,024 leaves (CI [17.6, 27.6]) and 15.3x at 16,384; full over
  incremental verification is 136x and 2,072x in cycles, so probe 3's wall verdicts stand.
  Superseded: the "95% of the certified path is hashing" figure was a cross-binary artifact;
  within one binary it is 75% at depth 10 and 68% at depth 14. All eight gates pass on all four
  backends; zero-allocation regression passes with the new default.
- 2026-09-03 — probe 6: summary-keyed cache, witness serving, dispatch threshold, and counter
  re-measurement of probes 2 and 5. Report:
  `2026-09-03-c1061-probe6-summary-keyed-cache-and-witness-serving.md` (ergodis-private
  `c2e1ac5`). Verdict: **promote; delete the cache**. Unfolding the LRC kernel shows its
  global-capacity rejection is dead code and the per-domain multiplicity test collapses to one
  scalar bound A(s) <= min_d(c_d + m_d) with A increasing, so the repaired count is decided in
  closed form (2.1M hostile comparisons, exact kernel fallback): 8.2x (rack) and 8.6x (unique)
  fewer instructions than kernel-per-leaf, beating both memos. Re-keying still confirmed as
  structure: on the unique fleet the parameter-class table had 15,718 entries at 4% hits; the
  budget-response table has 82 entries at 99.5% hits with three normalized shapes, reconciling
  probes 2 and 5. Witness serving from stored responses: 1.21M instructions on every fleet
  shape vs 14.6 to 15.8M kernel-resolved, 12 to 13x (cycle CIs [10.0, 14.6]), 10 bytes per pod;
  residual is tree descent, still O(pods). Dispatch rule refuted by measurement: merged rebuild
  wins from k = 4 (not k >= leaves/64) and grows to 1.46x at k = 4,096; threshold is a measured
  constant. Counter re-measurement (8 rounds, paired log-ratios): most claims confirmed or
  larger; three changed: witness delta overhead +44% not +35%; blocked-fleet witness run
  readout 20.9x not 343x (wall timed an 86 ns op); rebind over full rebuild at k = 4,096 is
  1.74x not 11.5x (wall charged a clone both paths do). Instruction counts are deterministic
  under load, cycle CIs wide, so instructions are primary; rack-fleet run readout inconclusive
  on cycles.
- 2026-09-03 — probe 7: other problem domains and solve shapes. Report:
  `2026-09-03-c1061-probe7-other-domains-and-shapes.md` (ergodis-private `cc59d6a`, modules
  `semiring_tree.rs`, `syndrome_window.rs`, `policy_automaton.rs`). Verdict: **promote the
  semiring layer; QEC conditional; policy confirmed; routing downgraded to conditional**. Three
  shapes examined, two prototyped to exact-agreement gates. QEC syndrome decoding as a min-plus
  chain over rounds (repetition code, phenomenological noise): leaf is closed-form because the
  parity check has a one-dimensional kernel; congruence exact against brute force; update monoid
  is an elementary abelian 2-group (toggles commute and are involutions), the best algebra in the
  series; but interface width is 2^D and per-event instructions grow 8x per unit distance
  (5,040 / 37,525 / 281,580 / 2,565,491 / 21,974,623 at D = 2..6), so the shape dies at distance
  6. Delta vs fresh at D = 4, 1,024 rounds, 8 interleaved rounds: 134.7x instructions
  (CI [134.7, 134.7]), 114.0x cycles (CI [95.6, 136.0]) — two orders below probe 2 because the
  leaf is cheap. Tropical normalization gives 42 root classes from 799, not probe 2's 2 to 4.
  Orbit compilation measured and dead: cyclic/dihedral orbits reduce the syndrome table by the
  group order (m or 2m) against a 2^m table. Five semirings over one compiled topology, and here
  the functors are different decoders: min-plus is minimum-weight, sum-product is
  degeneracy-summing maximum-likelihood, and they disagree on 2.5% to 27% of planted instances.
  Policy automaton: determinism makes the summary a function, so width is |Q| and composition is
  |Q| lookups; congruence finite by construction (transition monoid 626 at 17 states); trace-edit
  delta 13.0x instructions / 39.0x cycles; rule-change events have a 128x wider affected set than
  a path; re-minimization refines only, never coarsens, in 1,500 trials. Clos/fat-tree argued
  only and downgraded: raw interface far too wide, rescued only by fabric symmetry, which probe
  5's negative control says is layout-dependent. Two cross-domain rules added to the brief: the
  chain delta speedup is set by the leaf-to-composition cost ratio, not chain length; symmetry
  reduction is an instance-structure win, never a structural bound.
- 2026-09-03 — probe 7: other domains and shapes (QEC, security policy automaton, routing).
  Report: `2026-09-03-c1061-probe7-other-domains-and-shapes.md` (ergodis-private `cc59d6a`).
  Verdicts: **QEC time-axis chain: drop beyond small distance**; **policy automaton: promote**;
  **routing: conditional**. QEC syndrome decoding as a min-plus chain over rounds has the best
  update algebra so far (toggles commute and are involutions: elementary abelian 2-group, exact
  run collapse, free rollback) but interface width is 2^D and per-event instructions grow about
  8x per unit of distance (5,040 at D=2 to 22.0M at D=6). Delta vs fresh (8 rounds, two-size
  differencing): syndrome 134.7x instructions (CI tight) and 114x cycles (CI [95.6, 136]);
  policy 13.0x instructions and 39x cycles (CI [30.1, 50.5]). Rule added: a chain's delta
  speedup is set by the leaf-to-composition cost ratio, not chain length, which predicts probe
  2's 10,000x, 135x, and 13x with one model. Negatives: compiling syndromes by automorphism
  orbit only divides a 2^m table by the group order; "one decomposition, several semirings"
  needs the summary to be a matrix, not a function (the deterministic policy summary is a
  function, 17x cheaper composition, no functor freedom). Policy automaton is the only domain
  with a finite congruence by construction (626-element transition monoid at 17 states,
  emittable as a compiled transducer today); single rule edits only refine the Myhill--Nerode
  partition in 1,500 trials, licensing a split-only incremental minimizer, with a 128x wider
  affected set than a path. Ranking revision: QEC about 3, security policy 5 with that caveat,
  routing conditional pending a boundary-class-collapse measurement.
- 2026-09-03 — probe 8: monoidal collapse inside kernels. Report:
  `2026-09-03-c1061-probe8-monoidal-collapse-inside-kernels.md` (ergodis-private `2d114d2`).
  Verdict: **promote; two kernels collapsed, one structural rule**. (A) The LRC residual test is
  a prefix predicate (probe 6 evaluated the slope globally, but k = 0 means no violation), and
  its threshold is independent of the global parity capacities, so one closed-form sorted pass
  over the six data capacities answers every budget level: 19.7x fewer instructions than the
  published kernel per pod (CI tight), 3.2x fewer than probe 6's decided path as called, 1.56x
  fewer than its best four-call variant but a cycle wash against that variant (CI [0.99, 1.00])
  because 794 instructions per pod is division-latency-bound. Gate: 960,000 exact value and
  witness comparisons across all residues. (C) `ergodis::defect`'s signed-flip reachability scan
  folds one commuting Boolean-semiring convolution per line degree, 757 on PG(2,27) with only
  seven distinct maps, so binary splitting over multiplicities replaces 598 folds with 17:
  19.3x fewer instructions and 12.1x fewer cycles (CI [10.1, 14.6]) on the scalar scan, 2.7x
  across all 757 pencils; verified against a replica of the core scan on all pencils and 2,000
  hostile multisets. (B) Structural rule: an inner algebra is exploitable exactly when the inner
  state is a fixed-width vector and the stages come from a small set of commuting maps.
  Canonical negative: `schedule_repair_dag` (subset mask over 63 tasks, descends through all
  subsets of the ready set); also partition-refinement loops, `minimum_node_span_repair`, the
  Ceph antichain builder, `parallel_composition_step`. Three wins that cannot be taken
  (Gray-code enumeration, extension-field powers, matrix powers) because every intermediate
  state is itself the output. Highest-value item left: `defect.rs::build_threshold_masks`, one
  prefix-and-suffix scan for every bound. Core untouched; the defect collapse is a private
  replica pending a core change.
- 2026-09-03 — probe 9: hostile review of the closed-form LRC decision and O(depth) witness
  queries. Report: `2026-09-03-c1061-probe9-closed-form-review-and-local-witness.md`
  (ergodis-private `b5ceaef`). Verdict: **closed form proved for repaired_count only; kernel
  stays**. Scope correction: probe 6's "kernel could be deleted" is withdrawn; the closed form
  decides `repaired_count`, not `mode_counts`, `total_loads`, or `totals_checked`, so the
  kernel is skipped only where the count alone is consumed (all of the fleet binding). All
  three claims proved line by line: the global-capacity branch is dead for every input because
  the function's first line sets maximum = min(D, Lc + Gc) (named as the condition a future
  edit could break); the per-domain test collapses to A <= min_d(c_d + m_d) exactly, relying on
  `saturating_sub`; starting the scan at min(maximum, S1) skips only rejected candidates.
  Independent oracle: a CP-SAT model (`python/lrc_counted_oracle.py`) agrees with kernel and
  closed form on all 5,026 corpus cases including boundary inputs, incidentally validating the
  published kernel against an independent model. Complete enumeration of 2.35 billion inputs
  over a capacity/demand/extra box: zero mismatches, zero firings of the dead branch; only
  envelope is an unreachable u64 overflow. The closed form is a property of the counted-kernel
  family (four structural assumptions, S1 = floor((cap + (w-1)Lc)/w) for read weight w),
  derived not measured. Local witness queries: 399 instructions per single-pod query vs 1.21M
  full served readout (3,039x; cycles 1,864x, CI [1,587, 2,189]); 64-pod window 49.8x cheaper;
  unique vs rack inconclusive at 1.00x, evidence the cost is structural. Implied rule not yet
  implemented: above about a fifth of the fleet, full readout is cheaper.
- 2026-09-03 — probe 11 launched: land the two defect-kernel collapses in the Ergodis core under
  the full core validation gate (first core edit of this task).
- 2026-09-03 — probe 10: QEC on the space axis and the split-only minimizer. Report:
  `2026-09-03-c1061-probe10-qec-space-axis-and-split-only-minimizer.md` (ergodis-private
  `c079d29`). Verdicts: **QEC space cut: promote (distance-independent)**; **split-only
  minimizer: modest, worklist refinement is the lever**; **policy transducer: promote**. Cutting
  the detector grid along space makes the separator 2^T in the window height and independent
  of code distance (distance 25 with a four-round window needs width 16, where the time cut
  needed 2^25); both cuts agree exactly (500 planted trials plus brute force) and per-event
  instructions match at equal width, so cost is a function of separator width alone. Both stop
  paying at width 64: distance 6 for the time cut, window height 6 for the space cut, a decoder
  tuning knob. `CodeDistanceChanged` drops from rebase to a `RegrowRequired` class. The
  matching-parity invariant voids exactly half of every leaf's entries at every height (2x on
  live entries, no change in width). Tropical normalization is weaker on space (3,810 raw root
  summaries collapse only to 946, vs 19x on time), so no compiled transducer over the space
  boundary. Delta vs fresh on the space cut: 118.1x instructions and 114.9x cycles (CI
  [113.9, 115.8]). The cluster-growth decoder is a real join-semilattice (idempotent,
  commutative, one pointer repointed per effective merge, half of joins absorbed) but has no
  inverse: a retraction costs 126x a merge even with bounded 64-join replay. Policy: any
  single-cell edit (deletion included) refines the Myhill--Nerode partition across 1,500
  trials; a whole-row copy coarsens 64% of the time. The split-only minimizer is 2.65x, not a
  locality win, because Moore convergence is dominated by refinement-cascade depth. The emitted
  transducer: 626 monoid elements at 17 states, zero disagreements on all 7,512 Cayley cells and
  2,000 traces; a monoid-indexed retained tree runs 9.17x the function tree (CI [9.12, 9.22])
  with 17x less node state, about 119x a naive policy engine with probe 7's 13x. Streaming
  needs only the 30 KB Cayley table; the 1.5 MB product table is the cost of retained
  composition.
- 2026-09-03 — probe 11: defect-kernel collapses landed in the Ergodis core under the full gate
  (core commits `eb349ce`, `08ccfb0`, `9a02921`; ergodis-private `b25cb13` removes the replica).
  Appended to `2026-09-03-c1061-probe8-monoidal-collapse-inside-kernels.md`. Verdict:
  **landed**. Binary splitting over multiplicities replaces the per-degree fold; threshold
  masks rebuilt as one scatter plus suffix and prefix scans; both predecessors retained as
  cfg(test) differential references. Paired A/B, seven rounds, two retained binaries with
  distinct hashes: 14.85x / 15.45x fewer instructions at budgets 12 / 13 on the whole-plane scan
  (cycles 8.3x / 9.3x), 2.15x per pencil, 5.04x on the catalogue constructor, all CIs excluding
  1.0; the depth-32 search is the negative control at 1.000x. Bit-exact on PG(2,27) at five
  seated prefixes and every budget, all 757 pencils, 2,000 hostile multisets, the catalogue's
  masks; zero-allocation regression; identical work counts across arms and under parallel at
  1/2/8 threads. Gate green: fmt, clippy, 747 tests, 79 Python oracle tests. Finding:
  `analyze_fixed_maximal_set` short-circuits on a negative correction budget and the best
  constructible 54-point set reports defect 640 for a budget of -621, so the flip scan is
  unreachable through the public analysis; a set with defect at most 19 is the open object it
  searches for, which is why the end-to-end workload shows no change. Hazard recorded: a
  worktree build sharing the target directory overwrote the candidate binary and produced two
  identical retained arms; compare SHA-256 of both arms before trusting an A/B.
- 2026-09-03 — probe 12: family test of the closed form and the compiled fleet transducer.
  Report: `2026-09-03-c1061-probe12-family-test-and-compiled-transducer.md` (ergodis-private
  `23a25ed`). Verdicts: **closed form generalizes across the counted-kernel family**;
  **online optimizer disappears (structurally), but the table is an accelerator, not an exact
  compiled optimizer, and the endpoint is slower per event than the tree**. Family: a reference
  scan reproduces the published kernel on 200,000 hostile instances; seven shapes (LRC(12,2,2),
  (6,2,2), (12,4,2), (10,2,4), read weights 1 and 3, single parity domain) pass complete
  enumeration (2.03M comparisons, zero mismatches, zero dead-branch firings) and a
  family-generalized CP-SAT oracle on 4,704 cases; S1 = Lc + floor((cap - Lc)/w) holds for
  every w and g tested. Each structural assumption is load-bearing: read weight 0, an uncapped
  scan limit, and a wrapping shortfall each break one, and the closed form refuses by naming
  the failing assumption. Structural fact: leaf summaries satisfy cost[from][to] = f(to - from),
  so they are min-plus convolution operators and commute; the fleet optimum is a three-level
  knapsack over the multiset of leaf profiles, a statistic independent of fleet size.
  `FleetPolicy` maintains that multiset and matches the tree's optimum on all 100,000 events at
  16,384 pods with no tree and no kernel. Finite table: seven gain states, 71 KB, zero value
  and state disagreements on a 100,000-event replay with 0.39% fail-closed rebases; but
  training on 400k and 800k events exposes 2 then 4 conflicting keys and one value error per
  100k events after poisoning them. What breaks finiteness is the multiplicity of pods tied at
  the top of the discount order, not fleet size or width. Defect fixed: class indices are
  interned per instance, keying on them gave 7% error; keying on the profile gives zero. Cost:
  20.7k instructions per event vs 16.2k for the tree delta (1.28x regression, CIs exclude 1.0)
  while cutting state 22x (137 KB vs 3.0 MB); a speed win needs the top-k maintained
  incrementally instead of rescanned. Harness calibration failure recorded: repeat=2 sizing
  gave negative instruction counts; a `--min-repeat` floor fixed it.
- 2026-09-03 — probe 14: design ADR for the generic dynamic decision layer, at
  `~/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md` (ergodis-private
  `17e753f`; establishes `docs/adr/`). Status: **proposed, for Tavis; no migration decided**.
  Eight elements, each with its measuring probe, implementing modules, generic vs
  domain-specific split, and core vs private recommendation. Recommended for the core: the
  `OpenProblem` trait with law tests and semirings, the retained tree, the event-class
  taxonomy, and the certificate chain (named the cheapest first step, fully generic, already
  following core certificate conventions). Domain-bound elements stay private; the transducer
  endpoint stays labelled an accelerator with a fail-closed path. Five measured rules of thumb
  stated with evidence; nineteen negatives listed in one section; consolidation debt found
  while surveying: the retained tree exists four times, the tropical offset/residual split
  four times, the induce-a-finite-table idea twice. Ten open questions; question 1 (does the
  trait survive both a matrix summary and a function summary) is the gate on any extraction.
  Shared-target-directory worktree hazard recorded as ADR section 7.
- 2026-09-03 — probe 13: QEC window exactness and external baseline; worklist minimizer.
  Report: `2026-09-03-c1061-probe13-qec-window-exactness-and-external-baseline.md`
  (ergodis-private `ecaa632`). Verdicts: **QEC decoding: drop from the product-target list**;
  **worklist minimizer: promote**. At matched accuracy the retained space-cut delta costs 64x
  to 82x more instructions per event than PyMatching's sparse blossom at distances 3, 5, 7, 9
  (497 / 843 / 1,195 / 1,484 per decode vs 40,539 / 67,703 / 94,870 / 94,870 per event), all CIs
  far from 1.0. The loss is structural: the delta pays a dense 16x16 min-plus product per tree
  node regardless of defect locality; blossom touches only the defect neighbourhood. Delta cost
  is flat in distance and blossom's linear, so the crossover is near distance 3,000 to 5,000.
  Accuracy parity: identical logical error rates and zero disagreements at distances 5, 7, 9
  over 20,000 shots; 41 tie-breaking disagreements at distance 3. Windowed objective stated
  precisely: minimum weight over configurations with no measurement error on any seam round,
  vs full-history minimum weight over free seam states; identical only at T = R. Exactness is a
  condition on the optimum, not the noise: disagreements on seam-avoiding histories grow from
  0% to 54% as physical error rises from 0.1% to 5%. Window height priced: height 2 to 6 cuts
  excess logical error 6x to 14x (60% to 4% excess at 1% physical) at 8x cost per unit height.
  Qualifies probe 10: the space cut makes distance free, not experiment length. Worklist
  minimizer: 47.8x (36 states) to 154.8x (144 states) over full re-minimization and 18x to 66x
  over split-only, growing with size; a one-line fix (recompact labels only when a block
  splits) moved it from 4.6x. Caveat: steady-state numbers; on a live non-minimal policy the
  structural win is 4x to 7x, and a linked partition structure would remove the per-block
  state scan.
- 2026-09-03 — probe 16: empirical check of ADR question 1 (one trait for matrix, function,
  monoid-index, and semiring-window summaries). ADR section 9 (ergodis-private code `041e198`,
  ADR `1cd8960`). Verdict: **trait holds as a four-method core plus three capability traits;
  dedupe deferred**. The core (`identity`, `compose_into`, `optimum`, width) instantiates for
  all four, but only when composition takes the compiled problem as `&self` (a monoid index is
  meaningless without its Cayley table). `quotient` splits off as `NormalizedProblem` (2 of 4;
  the semiring window only at MinPlus), `tensor` as `TensorProblem` (1 of 4; automata tensor
  into a product automaton so the summary type changes), `reconstruct` as
  `ReconstructProblem` (2 of 4; a monoid index names the composed function, not the trace,
  probe 12's boundary from the other side). At equal work the abstraction is free: the width-8
  window arm (the only like-for-like) is 0.988x instructions (CI tight); the min-plus arm's
  1.129x gap is leaf-evaluation fusion, not dispatch, so extraction needs a
  `set_leaf_from_parameters` hook. Defect caught in the generic tree: storing summaries by
  value and cloning to recompose allocated per node per update (8,380 vs 2,895 instructions
  on the function arm); composing in place via `split_at_mut` removed it, and the
  zero-allocation regression now covers Copy and owned summaries. Dedupe not done: every file
  it touches is owned by an active probe; section 9.5 lists the exact hooks per module,
  including the per-leaf summary accessor `delta_composition` still lacks. Methodology: below
  about a thousand instructions per op, cycle differencing goes negative on this box; only
  instructions carry a verdict there.
- 2026-09-03 — probe 15: incremental top-k policy, tie-closed state, mechanical congruence
  check. Report: `2026-09-03-c1061-probe15-incremental-topk-and-tie-closed-state.md` (code
  landed in ergodis-private under `1cd8960`, swept in by a concurrent commit; see process note).
  Verdicts: **top-k policy: promote (11.4x cheaper than the tree)**; **exact compressive state
  key: does not exist for this vocabulary**; **probe 12's regression verdict reversed**.
  Harness error found: the N vs N/2 differencing assumes setup constant in N, but policy,
  table, and leaf ops pre-drove a driver tree for `repeat` events in setup, charging one extra
  tree update per event (containment check: leaf evaluation measured 26.1k vs 16.2k for the
  whole tree delta containing it). Corrected with a fixed 4,096-event window: probe 12's policy
  is 2.81x cheaper than the tree and its table 5.52x cheaper, not 1.28x and 1.16x more
  expensive; correction appended to the probe 12 report. `TopKPolicy`: classes in a discount
  order fixed at intern time (discount vector immutable, only multiplicity moves), three grants
  collected by an early-exit walk, one pass for grant and gain vector: 1.3k instructions per
  event vs 15.2k for the tree (11.37x; cycles CI [8.95, 10.27]), 56 KB vs 3.0 MB state, zero
  allocations, exact agreement with tree and probe 12 policy; the decided leaf alone is 740
  instructions, so the policy is within 1.81x of irreducible. Ties: no capped multiplicity
  closes the state (a count at the cap is ambiguous under removal; caps 2 to 4 still give 1 to 4
  conflicting keys at 400k and 800k events); only the uncapped profile-count vector is
  conflict-free, at 142,015 states from 400k events and a 99.999% rebase rate. No state key is
  both exact and compressive; the gain vector gives 7 states, 1% rebase, one value error per
  100k. Mechanical scorer (1,991 states, 469 checked, 21 events): every multiset statistic is
  value-exact, none is closed; violations fall monotonically as pod identity is restored
  (2,347 gain vector, 800 counts, 82 per-pod profile assignment, zero only with per-pod
  parameters), because the vocabulary names a pod. Probe 12's table therefore reads the class
  transition as an input symbol: a transducer over an enriched alphabet, not over the state.
  Process: `retain-bin.sh` refused to overwrite because the same revision produced a different
  executable; final campaign re-run against a pinned binary (sha256 fd61165d...), ratios
  reproduced. Shared git index hazard: a concurrent `git add -A`-style commit by another agent
  swept probe 15's staged and untracked files into its own commit; nothing lost, no history
  rewritten.
- 2026-09-03 — probe 19: profile-level vocabulary. Report:
  `2026-09-03-c1061-probe19-profile-level-vocabulary.md` (ergodis-private `ab05c40`). Verdict:
  **promote: the LRC fleet optimizer is an exact computed transducer plus a constant-cost
  ingest**. Re-indexing events by profile (`Reprofile{from,to}`, `AddPod`, `RemovePod`;
  `GrainChanged` still a rebase) makes the count vector's successor one decrement and one
  increment, and the congruence scorer returns zero exactness and zero closure violations for
  the uncapped count vector (exact re-scoring, no hash collision), against 800 closure
  violations under the pod-indexed alphabet. Controls: the gain vector still fails closure
  (1,276) and capped counts now fail exactness (141). Exact quotient is the multiset count
  C(n + P - 1, P - 1): 4.1e36 states at 16,384 pods and 84 profiles, 37,979 reachable on the
  10^5 stream, zero value disagreements vs the tree. Enriched-alphabet transducer has zero
  conflicts at 400k and 800k events but a 99.999% rebase rate, so it must be computed, not
  tabulated: transition is a decrement and an increment, output a three-level knapsack, both
  closed forms; `TopKPolicy` is that transducer and fails closed on an unseen profile. End to
  end (pinned binary 181e407e...): ingest + policy 1.3k instructions vs tree 15.3k (11.40x;
  cycles CI [9.19, 10.17]); ingest is 780 (within 1.05x of the bare closed-form leaf), the
  transducer about 520. Domain-specific remainder is exactly the ingest (closed-form leaf and
  profile identity, 60% of per-event cost); everything downstream is counts and a bounded
  knapsack. Two checkable compilation obligations recorded: leaf summaries commute (cost
  depends only on consumed budget) and the grant count is bounded. Added `leaf_summary` /
  `node_summary` accessors to `delta_composition` for the certificate generalization.
- 2026-09-03 — probe 17: sparsity-aware composition (QEC) and routing verdict. Report:
  `2026-09-03-c1061-probe17-sparsity-aware-composition-and-routing.md` (ergodis-private
  `5ed47f9`, `739e289`, `a06ceb2`). Verdicts: **QEC: closed, off the target list**;
  **routing: promote, ranking row no longer conditional**. Sparsity-aware tree (cost
  truncation plus a precomputed table for defect-free subtrees serving 46 to 50% of the repair
  path) is worth 2.8x to 4.1x and cuts the loss to sparse blossom from 82x to 15.1x at
  distance 9 and 1% physical error (CI [14.3, 16.0]), but no regime flips: PyMatching costs
  about 400 + 1,054 instructions per defect while the sparse tree is flat at 23,500, so the
  crossover needs about 22 defects in a 32-detector window (69% density vs a threshold near
  30%). Residual is W^2 scanning of dense summaries; the representation that would reach it is
  itself a matching decoder. Own prediction corrected: the no-tree vector sweep is worse than
  the tree from distance 5 up. Routing: folded-Clos fabric with pod separators; reachable
  boundary-class set under tropical normalization is 9 to 360 classes over a 10^5 mixed event
  stream and shrinks as the fabric grows from 256 to 1,024 pods; at matched exactness (3,000
  Dijkstra agreement checks, zero mismatches) the retained delta beats a Dijkstra re-solve by
  41x to 305x and full recomposition by 47x to 154x, growing with size; Pareto (latency,
  bandwidth) stays a four-point front through ten levels; per-event cost 2,287 / 17,167 /
  119,924 instructions at separator width 2 / 4 / 8, close to S^3. Harness audit: all four of
  this agent's benches had setup scaling with operation count; converted to a fixed
  4,096-event window, re-measured over eight rounds, no verdict changed (corrections 1.5% to
  43% upward, probe 13's QEC loss overstated by 5%). Second defect: three loops silently
  iterated the window instead of the operation count after a concurrent `cargo fmt` broke a
  text substitution; symptom was 0.06 instructions per operation. Rule recorded: a
  differencing harness reporting near-zero per-operation cost has a broken loop, not a fast
  one; every timed loop now verified to bound on `--operations`. Differential gates caught an
  unsound truncation rule (sound rule: exact once the best surviving total is within budget)
  and an asymmetric port penalty in the Dijkstra comparator.
- 2026-09-03 — probe 20: sealed compilation obligations and second semirings. Report:
  `2026-09-03-c1061-probe20-sealed-obligations-and-second-semiring.md` (ergodis-private
  `33b6ded`, which also swept in probe 18's staged files; see process note). Verdicts:
  **obligations sealed**; **three semirings over one decomposition, count vector closed under
  all**; **probability semiring is not reliability (load-bearing negative)**.
  `fleet_obligations` seals a schema binding, derives ten Horn steps, and verifies by
  recomputing every semantic check from sealed representative pods (convolution property,
  probe 12's four assumptions, profile from budget response); tampering with profile, grant
  bound, transcript, or provenance each fails closed. Emit 345.7k instructions, verify 172.5k
  for 20 profiles. Boolean, counting, and probability semirings all run on the same
  count-vector state and profile alphabet, each checked against brute force; the scorer gives
  quotient 220 with zero exactness and zero closure violations for all three. None needs the
  tree; cost separates them: Boolean 39 instructions (34x below min-plus, 392x below the tree
  delta), min-plus 1.3k, counting 627k and probability 650k because their readouts enumerate
  grant-shape assignments instead of a bounded top-k (implementation property; probe-15 trick
  should transfer, untested). Negative: the probability semiring sums over overlapping
  allocation events, returning 2.19 against a true 0.109 on a three-pod fleet; it is a
  union-bound surrogate, and reliability needs a per-pod threshold decomposition that is not a
  semiring readout over this decomposition. Second finding: the min-plus knapsack has run in a
  near-degenerate regime across probes 12 to 19 because adding global parity capacity also
  raises aggregate data load, so data-domain capacity binds rather than the shared budget;
  exactness unaffected, optimum less interesting than it looked. Process: the shared git
  index is not safe even with a `git diff --cached --stat` check, since the check is not
  atomic with the commit; the fix is per-agent worktrees or `GIT_INDEX_FILE` (Tavis's call).
- 2026-09-03 — redirect (Tavis, from Sol's notes): QEC is not given up. The dense per-shot
  decoder negative stands; the target becomes compiling the smallest certifiably safe decoder
  policy, plus an internal zero-allocation sparse-blossom kernel. Brief:
  `2026-09-03-c1061-qec-redirect-brief.md`. Probes 18 (generic certificates), 21 (routing fair
  baseline), and 22 (non-degenerate LRC regime, true reliability) are stopped as documentation
  only and continue in a fresh session. Launched: probe 23 context-certified predecoder
  (coverage(p, d, T), exactness of the safety claim, minimized LUT, tiered path vs PyMatching);
  probe 24 matching-signature compression of the dense boundary tables (valuated delta-matroid
  and matchgate identities); probe 25 soft output vs `decode_gap`; probe 26 TigerBlossom
  (specialized, bounded-memory, index-based sparse blossom with exact fast paths, gated on
  identical MWPM weight to PyMatching on probe 13's frozen inputs).
- 2026-09-03 — probe 22: stopped as documentation (ergodis-private `305373d`, one path). Report:
  `2026-09-03-c1061-probe22-nondegenerate-regime-and-true-reliability.md`. Part A
  (non-degenerate regime re-run of probes 12, 15, 19, 20) not started; recorded expectation:
  structural results survive (commutation and closure do not mention discount magnitudes),
  performance ratios are at risk (deeper top-k walk under contention). Part B implemented,
  unverified: true reliability is a semiring readout over the distribution of budget demand
  (one threshold vector per fleet, truncation at the grant bound discards exactly the
  infeasible mass), not over the cost decomposition; `reliability_exact` folds pods of one
  profile by repeated squaring, O(P log n), reading the count vector alone. Probe 20's "not a
  semiring readout" narrows to "not over the cost decomposition" once verified. Part C
  implemented, unverified: `optimal_pattern_count_incremental` restricts enumeration to the
  top GRANT_BOUND discount values per level. Neither new function has a test or an instruction
  count. Fresh-session order: gate C (equality with `optimal_pattern_count` on fleets with ties
  and singleton classes), gate B against `overlap_gap`'s exact branch, measure both vs 627k /
  650k, then A with a named contended-fleet generator.
- 2026-09-03 — probe 18: generic certificate chain, wrapped up (ergodis-private `93572c5`,
  ADR section 10; probe-3 report appended, monorepo `5eee9718d`). Verdict: **promote; one
  chain serves four summary shapes; table-emitted certificates work**. `CertifiableProblem`
  (canonical encoding, validating decode, artifact payload) as a fourth capability; all four
  shapes run the fail-closed suite and crash-recovery replay (5 generic, 10 open-problem, 32
  specialized tests green). Two defects fixed: per-digest allocation and a length prefix
  pushing the internal preimage to a third compression block, together 63.3k to 49.5k
  instructions per event. Measured (7 rounds, fixed window, pinned b0138ac0..., instruction sd
  0): specialized chain 25,046 instructions / 1,168 bytes per event; generic matrix 49,457 /
  1,216; policy function 62,166 / 1,264; monoid index 25,598 / 496; width-8 window 204,433 /
  3,520; generic costs 1.97x the specialized chain where directly comparable, 1.02x when the
  summary is one word. Probe 12's question answered yes: `TableCommitment` / `TableProver` /
  `TableVerifier` emit (table root, previous sequence, previous state, symbol, next state,
  offset delta, inclusion path); the verifier holds 64 bytes, does O(log cells) hashes, and
  costs 3,749 instructions / 328 bytes per event, 6.68x cheaper than the tree chain; the table
  is certified once at build by recomputation, then each event is an inclusion proof; covers
  value and offset, not witnesses, and must not be applied to the fleet `ShapeTable` until
  its state closes. Corrections: the generic chain proves composition, not leaf evaluation
  (separate obligation); a forged ancestor yields `PreviousRoot` only at level 0, above it the
  guarantee is a disjunction (true of the specialized chain too). Harness audit: probe 8's
  parametric-vs-kernel win is 33.45x not 19.70x, parametric-vs-decided 1.99x not 1.56x, cycle
  wash confirmed; no probe-16 verdict changed. Next session: zero-allocation regression for
  the generic chain (missing; both defects are what it would catch), borrowed-encoding path
  for the 1.97x, other hash backends, file round-trip, normalized-class encoding for the
  width-8 certificate; 9.5 dedupe still needs a quiet tree.
- 2026-09-03 — probe 21: routing fair baseline, stopped as documentation. Report:
  `2026-09-03-c1061-probe21-fair-dynamic-routing-baseline.md` (ergodis-private `23c9b3f`).
  Routing continues in a fresh session.
- 2026-09-03 — probe 23: context-certified predecoder. Report:
  `2026-09-03-c1061-probe23-context-certified-predecoder.md` (ergodis-private `7673db3`).
  Verdict: **promote; the QEC opportunity is real in this form**. K(s,b) is the set of
  commit-region parities among minimum-weight explanations conditional on seam state b;
  Safe(s) is a nonempty intersection over all reachable b. Splicing argument: any global
  optimum's window part is window-optimal at its seam b*, so a safe action replaces it at
  equal weight; logical outcome preserved exactly whenever the class costs differ, exact ties
  counted as the one gap. Verified by exhaustive adversarial enumeration over every syndrome at
  (d,T) = (3,3), (3,4), (5,2) at both commit sizes, plus a brute-force check of the min-plus
  cost table (8 tests). Coverage at d=9, p=1%: proved tier 92.05% at T=2, 99.80% at T=4,
  99.85% at T=6; as a cascade the strong decoder sees 0.00% to 0.56% of shots across p in
  0.001 to 0.05 and d in 3 to 9. Certification is not quiet-window recognition: at d=9, T=6,
  p=5% only 0.35% of windows are clean yet 98.85% are certified, nearly all with a unique safe
  parity. Compiled artifact: the certified predecoder for the distance-9 repetition code with
  two rounds of lookahead is a six-state automaton in 6,150 bytes (65,536 syndromes, 11,000x
  compression, worklist-minimized); d=5, T=4 gives 29 states. Proved-only is smaller than
  proved-plus-bounded (6 vs 90 states). Cost: 62 to 100 instructions per committed round, flat
  in distance and error rate, vs PyMatching 300 to 8,861 on matched six-round windows; raw
  3.5x to 140.7x, composed (charging the LUT for every deferred shot) 3.5x to 30x; at d=3 the
  full T=2,4,6 cascade in 595 bytes defers nothing at any error rate. Binding constraint:
  enumeration depth 2^((d-1)T), so only T=2 compiles at d >= 7 (d=7 defer 6.3% at 1%, 24.7%
  at 5%); the tier census predicts about 28x at d=7 with deeper tiers. Next: a spatial
  locality argument (a defect far from the commit region cannot change the commit decision),
  for which the six-state d=9 automaton is direct evidence.
- 2026-09-03 — probe 26: TigerBlossom kernel. Report:
  `2026-09-03-c1061-probe26-tiger-blossom-kernel.md` (code and A/B logs committed in
  ergodis-private). Verdict: **promote; exact; wins at low error, loses at high error and
  large d through the fallback**. Exactness: identical minimum-weight matching to PyMatching
  on all 360,000 shots across d in {3, 5, 7, 9, 15, 25} and p in {0.001, 0.01, 0.05}, plus an
  in-tree Floyd--Warshall and subset-DP oracle; prediction differences only on degenerate
  ties (4.2% at d=3, p=0.05, zero by d=25). Zero allocations across `decode_batch`, workspace
  bounded at 559 KiB. Instructions vs PyMatching: 3.1x to 12.3x fewer at p=0.001 and 1.9x to
  7.2x at p=0.01 up to d=15; loses at p=0.05 for d >= 7 (1.5x at d=7 to 25.5x at d=25) and
  at d=25, p=0.01 (1.7x); all CIs exclude 1.0, eight rounds, pinned hashed binaries. The whole
  win is one specialization: compiling the metric closure (all-pairs distances and path
  parities, constants of the code); removing it costs 1.15x at d=3 and 20.6x at d=25.
  Small-case closed forms add 1.0x to 2.3x; cluster decomposition is a measured wash (first
  misread from a two-variable arm, corrected with an isolating arm). The whole loss is the
  general fallback, a dense O(n^3) blossom over the reduced complete graph instead of sparse
  region growth (deliberate deviation from the brief); replacing it is the next step and
  would close every losing cell. Zero allocation bought determinism, not speed.
- 2026-09-03 — probe 24: matching-signature compression. Report:
  `2026-09-03-c1061-probe24-matching-signature-compression.md`. Verdict: **killed; hypothesis
  inverted**. The boundary table is a valuated even delta-matroid (zero exchange violations
  across 524,288 triples per shape; the even-support condition is probe 17's parity
  superselection rule under its proper name), but the tropical matchgate identities fail, and
  a parameter count shows the 256-entry table is the compressed form for any region past about
  sixteen columns, the matching gadget being the expansion. No smaller exact object exists.
- 2026-09-03 — probe 25: soft-output gap. Report: `2026-09-03-c1061-probe25-soft-output-gap.md`.
  Verdict: **exact, loses on cost**. PyMatching 2.4.0 has no `decode_gap`, so an
  augmented-graph two-decode baseline was built; our gap matches it on 20,000 of 20,000 shots
  at three distances on both class costs. Our composition is 6x to 12x dearer than two matching
  decodes, and the k-logical widening loses from k=2 (8^(k-1) composition vs 2^k decodes).
  Kept: the competitor's curve, soft output costs sparse blossom 3.5x to 20x its hard decode,
  worst at low error rates.
- 2026-09-03 — probe 27: spatial locality and the rotated surface code. Report:
  `2026-09-03-c1061-probe27-locality-and-surface-code-predecoder.md`. Verdicts: **locality
  argument false**; **certificate transfers to the surface code, compilation does not**. Every
  spatial column influences the commit decision at every distance because the committed
  quantity is a logical parity and the logical operator spans the code; the fallback (closure
  over reachable normalized states) gives 111x at d=5 and dies at d=7, so deeper tiers compile
  where not needed and not where needed; probe 23's predicted 28x at d=7 is unreachable this
  way. Surface code: a BFS-compiled metric closure replaces the closed-form leaf and the whole
  pipeline carries over (exhaustive safety at d=3 passes; the cascade defers nothing up to 2%
  error), but the boundary alphabet goes from 2^d to 2^((d^2+1)/2): 268 MB dense leaf matrix
  at d=5 (matrix-free sweep at about 4 s per shot after a stack overflow), 2^25 wide at d=7;
  the compiled LUT stops at d=3. Next move: change what is committed, a local correction
  rather than a global logical parity. Code: ergodis-private `fe4d6a3`, `9e64308`, `afd9e54`,
  `130b0fa`, `b7e7c6d`; 26 tests across four modules.
- 2026-09-03 — probe 29: local-commit predecoder. Report:
  `2026-09-03-c1061-probe29-local-commit-predecoder.md` (ergodis-private `a120c33`). Verdict:
  **sound at every radius; still does not compile past small d; certificate too
  conservative**. Committing a local correction: the splicing argument proves a safe local
  action preserves a global minimum-weight solution with no reachability quantifier and no
  exact-tie gap; the handoff contract (residual syndrome s ^ boundary(a) with the region
  retired, globalmin = |a| + residualmin) is verified exhaustively on repetition and rotated
  surface codes. Ball width saturates with distance (6 bits at repetition radius 1 for d = 7
  to 15, 10 bits at surface radius 1 for d = 5 to 9), so the table is distance-independent.
  Locality still fails: the proved tier survives only when the ball spans a full spatial cut
  (d=9 repetition, radius 3: centre position certifies 95.0%, its neighbour 2.6%); required
  radius grows like d/2, so the surface code needs 2^((d^2-1)/2). The radius-1 surface policy
  is 1 KB containing the single decision `defer`; shot-level defer rate 1.0000 at d=5, 0.9998
  on repetition d=9; 296 instructions per position evaluation, 2,665 per committed round vs
  PyMatching's 2,296. The bounded tier (at most one fault crossing the ball boundary) covers 93
  to 96% of windows in a 1 KB distance-independent table, deployable but not
  accuracy-identical. Named successor: a certificate that charges the crossing context its own
  weight instead of intersecting within each context.
- 2026-09-03 — probe 30: margin certificate predecoder. Report:
  `2026-09-03-c1061-probe30-margin-certificate-predecoder.md` (ergodis-private `c4ba919`,
  twelve gates). Verdict: **certificate proved and local; coverage recovered; still not d=9
  accuracy-identical, now for oracle-reach and cost reasons**. Charging each crossing mechanism
  its weight gives the escaped-ball cost W_a; the condition W_a + Delta <= min over a' != a of
  W_a' is proved safe by explicit splicing, with the outside advantage bounded by R_max, the
  largest outside repair cost over the crossing subspace (exact BFS where the outside fits).
  Smallest sound margin measured by exhaustive audit against a metric-closure oracle over all
  syndromes of weight <= 4: Delta = 1 to 2 at radius 2, 2 to 3 at radius 1, never more than 3;
  the unpriced Delta = 0 policy (what a clustering predecoder assumes) violates on 2.6% of
  commits at repetition d=7. Probe 29's full-spatial-cut requirement is gone: at radius 1,
  Delta = 2, one 1,024-byte table identical at surface d = 5, 7, 9 commits 97.4% of windows
  (probe 29 committed 0.0000 at d = 7, 9); shot-level defer falls from 1.0000 to 0.611 at d=9
  and 0.212 at d=5 with a two-tier radius cascade, committing real corrections. Not reached:
  the audit oracle reaches only surface d=3, so Delta = 2 there is extrapolated while the
  audited-sound radius-1 value is 3, which defers every shot; and the timed arm costs 415.5
  instructions per position, 32,825 per committed round vs PyMatching 2,296 (14.9x loss), with
  a bitset rewrite estimated to reach only parity since both do O(d^2) work per round. Too
  conservative because a radius-1 ball expresses cost differences of only 0, 1, 2, so margin 3
  exceeds its dynamic range. Named successor: a per-witness bound Delta(c_a) from the observed
  syndrome just outside the ball, and a radius-2 representation avoiding 2^28 enumeration.
- 2026-09-03 — probe 31: sparse evaluation and per-witness margin, paused by Tavis. Report:
  `2026-09-03-c1061-probe31-sparse-evaluation-and-per-witness-margin.md` (ergodis-private
  `8a75f0a`, seventeen gates across probes 29 to 31). Done: clean-ball lemma proved and gated
  (zero ball syndrome gives W_0 = 0 and any other action costs at least the local girth g_R,
  so g_R >= Delta lets a defect-free position commit the empty correction unevaluated, an
  identity of the compiled table); sparse evaluation provably equals dense, and the gate
  caught that evaluation order changes the policy since each commit rewrites the syndrome, so
  the worklist must stay in ascending position order; an exact matching oracle (unit-weight
  BFS detector metric plus 2^k subset matching over defects) replaces the 2^detectors metric
  closure and agrees with it on three small instances and with probe 30's audit at surface
  d=3. Dead: the per-witness margin as posed, because crossing patterns form a group under
  symmetric difference, so the coset {c_a xor c*} equals {c*} and Delta(c_a) = R_max for every
  witness; only conditioning on the observed outside syndrome can tighten it (not reached).
  Unmeasured, in order: the d=5 oracle audit (is Delta = 2 sound there); a sparse-margin bench
  subcommand; instructions per committed round across p, with the live risk that at 1% error a
  d=9 shot's about 30 defects wake about 300 positions against the dense sweep's 79, so sparse
  may only win at low p.
- 2026-09-03 — probe 28: TigerBlossom sparse fallback, every cell. Probe-28 section of
  `2026-09-03-c1061-probe26-tiger-blossom-kernel.md` (ergodis-private `880ffa6`). Verdict:
  **15 of 18 cells won (was 12); three p=0.05 cells still lose with a measured cause**. The
  dense O(n^3) fallback is replaced by region growth over the compiled detector graph
  (linear-function duals on a global clock, bucket event queue with recycled pool, blossom
  contraction and extraction), and every solve is certified optimal by LP duality before its
  answer is used, so a matcher bug costs speed, not correctness; the sparse matcher costs
  about 5,500 instructions on a sixteen-defect block vs 706,000 dense. Exactness: zero
  minimum-weight disagreements vs PyMatching on all 360,000 frozen shots; zero allocations
  across `decode_batch`; certificate soundness gated on 77,174 random instances with zero
  certified-but-wrong answers. Ratios 0.089x to 0.95x on the won cells, all CIs excluding
  1.0; worst cell d=25, p=0.05 improved 12.7x (25.51x to 2.008x, CI [1.994, 2.021]); losing:
  d=9 1.135x (wins on cycles at 0.785x through a third fewer branch misses), d=15 1.534x,
  d=25 2.008x. Pinned binary sha256 203cb386...7042. Remaining loss: the dense fallback is 32%
  of the worst cell's profile while answering 1.7% of blocks; 4,430 of 4,434 random-instance
  declines were optimal answers whose dual drifted infeasible by one unit, so fixing the
  drift retires the dense matcher (about a third of that cell); a rounding-overshoot theory
  was ruled out by assertion. `decode_with_gap` added as a separate entry point (exact minimum
  weight per logical class via a parity-resolved metric closure plus a compiled
  closed-logical-operator term, gated by exhaustive enumeration at d=3); hot path untouched.
  Next, in order: fix the dual drift, add blossom expansion (61 structural declines), then
  the sparse core's per-operation cost; the `latency` mode for per-shot p50/p99/max is
  written but was not run.
- 2026-09-04 — probe 28b: the TigerBlossom dual drift. Report:
  `2026-09-04-c1061-probe28b-tiger-blossom-dual-drift.md` (ergodis-private `6750d5e`,
  `6d973a0`, `dfd4ee0`, retained binary `ergodis-tools-dfd4ee0`). Verdict: **drift fixed;
  declines to zero; exactness intact; worst cell 16% better, mid cells 3 to 8% worse**. Three
  defects, each one broken invariant of the geometric primal-dual model and each located by a
  debug assertion of the two local dual-feasibility invariants after every event: a shrinking
  region released nodes one tick late; a singleton whose dual went negative had no node left to
  collide through (fixed by a phantom presence at its home node, with tree links recording the
  contacting singleton rather than a detector node); and a collision entry from a since-frozen
  side was dropped instead of being oriented to the still-growing side. Same-tick releases
  jumping the queue cost 2.5x scheduling traffic until releases and phantom contacts got a late
  lane. Random suite 76,612 of 76,612 certified, ratchet now demands full coverage; zero
  minimum-weight disagreements against PyMatching on all 360,000 shots. Against the retained
  control: d=25 p=0.05 0.841x, d=15 p=0.05 0.953x, other p>=0.01 cells 1.01x to 1.08x. Three
  cells still lose to PyMatching (about 1.20x, 1.46x, 1.69x). Next, in order: blossom expansion
  and deletion of the dense matcher; the local certificate in place of the LP pair loop; one
  entry per edge.

## Session close, 2026-09-03

Thirty-one probes in one day; all reports and code committed (monorepo `notes/`,
ergodis-private through `880ffa6`, ergodis core through `9a02921`). All three trees clean.

**Standing results.** The retained composition tree with typed deltas, the closed-form LRC
leaf, the profile-level vocabulary, the computed exact transducer plus constant-cost ingest
(11.4x over the tree), the generic `OpenProblem` core with a certificate chain over four
summary shapes, the policy transducer and worklist minimizer, the two defect-kernel collapses
landed in core (15x), the routing win over Dijkstra re-solve, the proved predecoder safety
certificates (per-context, local-commit, margin), and TigerBlossom (exact on 360,000 shots,
15 of 18 cells ahead of PyMatching).

**Standing negatives.** Dense per-shot QEC decoding; syndrome orbit compilation; boundary-matrix
compression (the table is already the compressed form); probability semiring over the cost
decomposition as reliability; capped-multiplicity state keys; per-witness margin as posed;
memoization on unique fleets; QEC time-axis chain beyond distance 6.

**Paused, with next steps in their reports.** Probe 18 (generic chain zero-allocation
regression, 9.5 dedupe needs a quiet tree), probe 21 (routing fair baseline), probe 22
(non-degenerate LRC regime, true reliability gates), probe 28 (dual drift fix retires the dense
fallback, blossom expansion, latency mode unrun), probe 31 (d=5 soundness audit, sparse-margin
cost across p). The ADR at `~/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md`
is a proposal awaiting Tavis's decision on core extraction.

**Process rules learned today.** Instructions primary under load, cycles unusable below about
a thousand instructions per op; fixed-window harness, every timed loop bound on `--operations`;
near-zero per-op cost means a broken loop; pin and hash both A/B binaries; commit with
`git commit -m .. -- <own paths>` since the shared index is not safe even after a staged check.
