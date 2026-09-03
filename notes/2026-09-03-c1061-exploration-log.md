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
