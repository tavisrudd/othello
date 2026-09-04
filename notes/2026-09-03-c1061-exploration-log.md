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
