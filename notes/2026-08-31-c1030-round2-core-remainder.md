# C1030 round 2 — core-crate remainder and unaudited private modules

**Task**: C1030 round 2 · **Lane**: `complete-ports` · **Scope**: core-crate remainder and unaudited private modules

## Verdict

Four findings at the reportable severities: one SEV1 and three SEV2. Nothing in round 1's
nineteen-finding register is repeated here.

The SEV1 is in `css_distance.rs`. The sharded wide/syndrome-driven CSS distance search splits work
across shards by taking a positional residue class of a branch list that the incumbent weight bound
helped build. Two shards that disagree about the incumbent build different branch lists, and the
positional filter over two different lists is not a partition of the branch set — branches fall
through the gap and nobody searches them. `css_distance_shard_ledger` then requires every shard
index to be present and stamps the aggregate `verdict: "complete-compatible-cover"`. That is a
completeness certificate over a decomposition that is not a cover. Both committed problem inputs
carry exactly two anchors, which is the precondition, and the compact (non-wide) sharded path is
demonstrably free of the defect, which is what makes the wide path's divergence visible.

The three SEV2s are: the control plane's evolution beam search prunes candidates with a gate keyed
to one ordering while reporting and expanding under a different ordering, so the plan it names as
best can be strictly worse than one it discarded; the projective grid scout computes a defect-count
successor by a delta formula that silently drops defects born at the intermediate half-move, and the
same expression in a sibling binary is serialized into an evidence record; and the q16 quadratic
census treats an undetermined (all-zero) kernel as a satisfied incidence, counting a leaf as
`forced_hit` whenever the monomial rank falls below five.

Two independent reads of `ergodis-private/src/hall_core.rs` — mine and a delegate's, arrived at
separately — agree that the Hall matching, the König deficiency extraction, and the saturation test
are sound, and that the reported neighbourhood is recomputed from the caller's graph rather than
self-reported. That is the strongest clean signal in this round, and it is the file the task brief
identified as feeding paper claims most directly.

**Read deeply** (line by line, by me): `span.rs`, `linear_code.rs`, `multiset.rs`, `arena.rs`,
`witness.rs`, `packed_ternary.rs`, `theorem_search.rs` (evolution core), the cited regions of
`scheduler.rs` and `css_distance.rs` and `control/evolution.rs` and `control/vm.rs`, and in the
private crate `hall_core.rs`, `projective_grid.rs`, `two_adic_autocorrelation.rs`,
`semantic_rank.rs`, `semantic_sets.rs`, `semantic_plan.rs`, `q19_marked_polar.rs`,
`bitset_sumset.rs`.

**Read deeply by delegates, every finding re-verified by me against the file**: `control/mod.rs`,
`control/vm.rs`, `control/text.rs`, `control/synthesis.rs`, `control/client.rs`, `scheduler.rs`,
`contextual.rs`, `rpc.rs`, `hall.rs`, `zdd.rs`, `orbit.rs`, `orbit_compile.rs`, `group_action.rs`,
`ordered_resource.rs`, `parametric_certificate.rs`, `integer_moments.rs`, `sat.rs`,
`modular_power.rs`, `prime_polynomial.rs`, `residual_hitting.rs`, `frozen_shortest_path.rs`,
`root_execution.rs`, `composition.rs`, `commutant.rs`, `coherent_closure.rs`, `confinement.rs`,
`continuation.rs`, `cyclic_action.rs`, `bitset.rs`, `automata.rs`, `landed_rank_adapter.rs`,
`q25_pair_repair.rs`, `q16_quadratic.rs`, and the `#[cfg(feature = "parallel")]` regions of
`css_distance.rs` and `balanced.rs`.

**Skimmed or grep-driven only**: `applications.rs`, `character_sum.rs`, `alignment.rs` (the
fractional-context Gray scan at lines 240–306 was not opened), `transfer.rs`, `semantic_symmetry.rs`,
`query_design.rs`, `provenance.rs`, `interface.rs`, `family_response.rs`, `alignment_control.rs`,
`defect.rs` from roughly line 430 onward, and the artifact serialization regions of
`css_distance.rs`.

**Not opened**: `selector.rs` beyond its header and error taxonomy, and about eight thousand lines
of `observational.rs` — only its `verify_*` entry points, `distinguishing_path`, and a
sentinel/memo sweep were read. These two are named again under the coverage gap at the end,
because `observational.rs` is where the certificate machinery is densest and where the
verify-by-re-execution shape from round 1's RC3 would hide a compiler defect from its own verifier.

**Reachability context that bears on every feature-gated finding below**: the core crate declares
`default = []`, but `ergodis-private/Cargo.toml:11` depends on it as
`features = ["control-plane", "parallel"]`. Every campaign binary in the private crate therefore
builds the core crate with both gates on. A parallel-path or control-plane defect is not a
hypothetical build configuration here; it is the one the campaigns run.

## SEV1 — sharded wide CSS distance search splits a bound-dependent branch list, so the shards do not cover it

**Location**: `papers/complete-repair-ports/ergodis/src/css_distance.rs`, function
`search_syndrome_anchor_parallel` at lines 2195–2298, and its caller
`search_bounded_syndrome_parallel_pulsed_impl` at lines 2423–2453.

**Verified quotes** (re-read at these exact lines in this session; the text below is copied from
that read).

The caller carries one incumbent weight across anchors and hands it to the next anchor as the
initial bound (`css_distance.rs:2423`, then `:2442-2453`):

```rust
        let mut best_weight = searched_maximum_weight.saturating_add(1);
```

```rust
            let partial = self.search_syndrome_anchor_parallel(
                anchor,
                searched_maximum_weight,
                best_weight,
                pulse_interval,
                shard,
            );
            merge_search_stats(&mut stats, partial.stats);
            if partial.best_weight < best_weight {
                best_weight = partial.best_weight;
                best_support = partial.best_support;
            }
```

That bound becomes `active_bound`, and `active_bound` decides which children survive into the
branch list (`css_distance.rs:2224`, `:2256-2262`, `:2273`):

```rust
        let mut active_bound = initial_bound;
        while branches.len() < target_branches {
```

```rust
                    let improvement_budget = active_bound.saturating_sub(child_weight + 1);
                    if child_weight >= searched_maximum_weight
                        || self.completion_lower_bound_exceeds(child_syndrome, improvement_budget)
                    {
                        prefix_stats.syndrome_bound_prunes += 1;
                        continue;
                    }
```

```rust
                    next.push(WideRootBranch {
```

The shard is then a positional residue class of whatever list that loop produced
(`css_distance.rs:2288-2298`):

```rust
        if let Some(shard) = shard {
            let count = usize::try_from(shard.count()).unwrap();
            let index = usize::try_from(shard.index()).unwrap();
            branches = branches
                .into_iter()
                .enumerate()
                .filter_map(|(branch_index, branch)| {
                    (branch_index % count == index).then_some(branch)
                })
                .collect();
        }
```

**Mechanism**. Each shard is a separate process invocation. Line 2450 updates `best_weight` only
from that shard's own partial result, so after the first anchor two shards can hold different
incumbents: a shard whose partition contained a witness enters the next anchor with a strictly
smaller bound than a shard that found nothing. The smaller bound makes `improvement_budget` smaller
at line 2256, which prunes more children out of `next`, which makes the surviving `branches` vector
shorter — and, critically, renumbers every branch that survives. The shard filter at line 2295 is
positional, so a branch that both shards retain sits at different indices in their two lists and can
satisfy neither shard's residue test. It is searched by nobody.

There is a coarser second route to the same outcome in the same loop. The loop condition at line
2225 is `while branches.len() < target_branches`, and `target_branches` is the same value in every
shard. A more aggressively pruned shard reaches that threshold one expansion level later, so the two
shards' lists are at different depths of the tree and are not comparable as lists at all.

The divergence is strictly across anchors, not within one. Line 2251
(`active_bound = active_bound.min(child_weight)`) lowers the bound inside the prefix loop, but that
is deterministic given the same `initial_bound`, so it is identical in every shard. The zero-syndrome
anchor shortcut at lines 2432–2440 also sets `best_weight = 1` identically in every shard before any
shard-dependent work. Line 2450 is the sole divergence source.

**Concrete trigger**. `css_distance_native --shard-index k --shard-count n` with `n >= 2`, on a
Wide, ExtraWide, Large, Huge, or Colossal backend, with an input carrying two or more anchors and no
`incumbent_support` (shards are rejected for incumbent certification at
`src/bin/css_distance_native.rs:516-517`), where some but not all shards find a codeword at an
anchor that is followed by at least one further anchor. With `count = 2`: shard 0 finds a weight-8
codeword at anchor 0 and shard 1 finds nothing. At anchor 1 shard 0's list is `[a, c, e]` — `b` and
`d` pruned under bound 8 — and it takes indices 0 and 2, giving `{a, e}`. Shard 1's list is
`[a, b, c, d, e]` and it takes indices 1 and 3, giving `{b, d}`. Branch `c` is searched by neither,
although shard 0's individual prunes of `b` and `d` were each sound. A weight-7 codeword below `c` is
missed and the aggregate reports 8.

The multi-anchor precondition is the normal case, not a contrived one. I read both committed inputs:
`papers/complete-repair-ports/ergodis/evidence/c985-c997-native-input.json` has `anchors = [0, 72]`
and `c985-bb288-native-input.json` has `anchors = [0, 144]`.

**Reachability**. `search_bounded_syndrome_parallel_pulsed_shard` is public on all five wide widths
(`css_distance.rs:2762, 2803, 2845, 2887, 2931`) and is called from
`src/bin/css_distance_native.rs:565, 588, 612` and the Huge and Colossal arms below them. Shard
records are aggregated by `src/bin/css_distance_shard_ledger.rs`, which refuses to proceed unless
every shard index is present (`bail!("missing shard index {missing}")`, line 231), takes the minimum
reported distance, and writes `verdict: "complete-compatible-cover"` at line 239.

The compact, non-wide sharded path is not affected, and the contrast is the cleanest evidence that
the wide path's bound dependence is the defect rather than the design. I read
`css_distance.rs:4256-4295`: `search_bounded_root_parallel` builds `branches` purely from
`anchors` crossed with `self.neighbors[root]`, with no pruning and no reference to any bound, before
applying the identical positional filter. Every shard index there sees a byte-identical list, so the
filter is a genuine partition.

**Impact**. A silently too-large reported CSS distance, or a false "no codeword of weight below W",
aggregated into a record the ledger labels a complete cover. The benign case is worth stating
precisely: on a clean closure run where no shard finds any witness, `best_weight` stays at
`searched_maximum_weight + 1` in every shard at every anchor, all branch lists are identical, and the
cover is exact. The defect bites only on mixed runs. A single-anchor input is also safe. I grepped
`notes/` and `papers/complete-repair-ports/` for `complete-compatible-cover` and `shard-coverage-v1`
and the only hit is the ledger's own source, so no committed certificate depends on this today. The
exposure is any future sharded closure run.

**Described fix, not applied**. Make the prefix expansion bound-independent whenever a shard is
active, so every shard index builds a byte-identical `branches` list. The minimal form is to pass
`searched_maximum_weight.saturating_add(1)` instead of `best_weight` at `css_distance.rs:2445` when
`shard.is_some()`, keeping the anchor-carried `best_weight` only for the final minimum. The cleaner
form splits `search_syndrome_anchor_parallel` so the prefix loop always runs under a fixed bound and
`active_bound` is used only to seed the deep search and its bound mailbox. Either way the ledger's
`complete-compatible-cover` verdict should be gated on a recorded property — identical branch-list
length and hash across shards — rather than on shard-index presence alone. A regression test needs a
multi-anchor case where shard 0 finds a witness at anchor 0, asserting the per-shard `branches` lists
are identical; the existing `randomized_small_serial_parallel_and_sharded_searches_match_brute_force`
at `css_distance.rs:4820` cannot catch it, because its five-to-eight-coordinate problems exhaust
inside the unsharded prefix loop, leaving `branches` empty at line 2299 so the shard filter is a
no-op.

## SEV2 — the evolution beam prunes under one ordering and reports under another

**Location**: `papers/complete-repair-ports/ergodis/src/control/evolution.rs:111`, `:127-136`,
`:186-219`, `:226-233`; the gate is applied in
`papers/complete-repair-ports/ergodis/src/control/vm.rs:1238-1246`.

**Verified quotes** (re-read at these lines in this session).

The survivor set and the pruning predicate (`evolution.rs:111`, `:127-134`):

```rust
        let mut survivor_keys = Vec::<(u64, std::cmp::Reverse<u64>, usize)>::new();
```

```rust
            let can_enter = |false_positive: u64, maximum_correct: u64| {
                if survivor_keys.len() < bounds.beam {
                    return true;
                }
                let worst = survivor_keys[survivor_keys.len() - 1];
                false_positive < worst.0
                    || (false_positive == worst.0 && maximum_correct >= worst.1 .0)
            };
```

The survivor keys are ordered false-positive first (`evolution.rs:205-211`):

```rust
            survivor_keys.push((
                evaluation.weighted_false_positive,
                std::cmp::Reverse(evaluation.weighted_correct),
                plan.program.len(),
            ));
            survivor_keys.sort_unstable();
            survivor_keys.truncate(bounds.beam);
```

The set that is actually expanded is ordered correctness first (`evolution.rs:226-233`; the tuples
in `ranked` are `(weighted_correct, weighted_false_positive, program.len(), outcome_hash, hash,
plan)`):

```rust
        ranked.sort_unstable_by(|left, right| {
            right
                .0
                .cmp(&left.0)
                .then_with(|| left.1.cmp(&right.1))
                .then_with(|| left.2.cmp(&right.2))
                .then_with(|| left.5.name.cmp(&right.5.name))
        });
```

and the reported `best` uses that same correctness-first order (`evolution.rs:191-197`):

```rust
            if best.as_ref().is_none_or(|best| {
                candidate_key.0 > best.0
                    || (candidate_key.0 == best.0 && candidate_key.1 < best.1)
                    || (candidate_key.0 == best.0
                        && candidate_key.1 == best.1
                        && candidate_key.2 < best.2)
            }) {
```

The gate fires mid-evaluation and abandons the candidate (`vm.rs:1238-1246`):

```rust
        let rows_evaluated = row + 1;
        if rows_evaluated % 64 == 0 && rows_evaluated != batch.rows() {
            let remaining_weight = total_weight.saturating_sub(result.weighted_rows);
            let maximum_correct = result.weighted_correct.saturating_add(remaining_weight);
            if can_enter.is_some_and(|gate| !gate(result.weighted_false_positive, maximum_correct))
            {
                return Ok((None, rows_evaluated));
            }
        }
```

**Mechanism**. The gate's primary key is `weighted_false_positive`. A candidate whose partial
false-positive weight already exceeds the worst survivor's is pruned no matter how high its
correctness can still climb. Taken against `survivor_keys` alone the gate is sound — the running
false-positive weight is a genuine lower bound on the final value and `maximum_correct` is a genuine
upper bound, so it never discards something that would enter that set. But the set that is expanded,
and the `best` plan the job summary reports, are chosen with `weighted_correct` as the primary key.
The two orders are different, so the gate discards candidates the ranking would have placed first.
A pruned candidate never reaches `ranked` at line 212 and never reaches the `best` comparison at
line 191; it is written to the evidence file with `"evaluation": null` and counted in
`cascade_rejections`. No error is raised. The doc comment at `vm.rs:1173-1174` says the search stops
"only when `can_enter` proves that no completion of the unseen rows can enter the current survivor
set" — true of `survivor_keys`, and the defect is that `survivor_keys` is not the set that decides
the outcome.

**Concrete trigger**. One field, 128 rows of weight 1: rows 0–62 have `x = 0` and `expected: false`;
row 63 has `x = 5` and `expected: false`; rows 64–127 have `x = 5` and `expected: true`. Run
`evolve-start` with `beam = 1`, `generations = 1`, and two seeds in this order: `x > 8`, then
`x > 0`.

Seed 1 is evaluated in full because `survivor_keys` is empty, giving `weighted_correct = 64` and
`weighted_false_positive = 0`, and it fills the beam. Seed 2 reaches the checkpoint at
`rows_evaluated = 64` (`64 % 64 == 0` and `64 != 128`) holding `weighted_correct = 63`,
`weighted_false_positive = 1` from row 63, and `maximum_correct = 63 + 64 = 127`. The gate evaluates
`1 < 0` (false) and `1 == 0` (false), returns false, and abandons it. Seed 2's true scores are
`weighted_correct = 127` and `weighted_false_positive = 1`, which beat seed 1 under the summary's own
ordering because 127 > 64. The summary nonetheless reports seed 1 as best. With `generations > 1`
the same mismatch also sends the beam down the wrong lineage.

**Reachability**. `run_evolution` is spawned from `Campaign::evolution_start` at
`control/mod.rs:1149`, dispatched from the `"evolve-start"` operation at `control/mod.rs:318`. The
user-facing entry is `ergodisctl evolve-start` (`src/bin/ergodisctl.rs:240-262`), whose defaults are
`beam = 16`, `max_candidates = 1000`, `generations = 3` (`ergodisctl.rs:138-143`), so with a few
hundred candidates per generation the gate is live on the default invocation. `Some(&can_enter)` is
the only caller that supplies a gate; `evaluate_plan` passes `None` at `vm.rs:1169`, so
`candidate-try`, `candidate-apply`, `candidate-batch`, and `synthesize-tree` are exact and
unaffected. The `perfect` counter is also safe: a perfect plan has partial false-positive weight 0
and `maximum_correct` equal to the total weight, so it satisfies the gate in both branches.

I checked the ungated library sibling. `theorem_search.rs::evolve_implications` has the same split
between its expansion comparator (`compare_trials`, false-positives ascending, at
`theorem_search.rs:213-223`) and its reporting predicate (`better`, coverage descending, at `:207-211`),
but it has no cascade gate — every candidate at `theorem_search.rs:156-186` is fully evaluated before
either ordering is applied. So `best_sound` there is exact over everything trialed and the defect
does not reproduce in the default build.

**Impact and why this is SEV2 rather than SEV1**. The tool's own output is "best plan found by a beam
search", which never claimed to be a global optimum, and the evidence file does mark each pruned row
with `cascade.rejected: true` rather than dropping it invisibly. I grepped `notes/` and `papers/` for
`evolve-start` and `evolve_implications` and found no manuscript or note that consumes an
evolve-start result. If a manuscript ever cites an evolve-start `best` predicate, this becomes SEV1
immediately, because the named plan can be strictly inferior to one the same run discarded and the
`cascade.rejected` marker reads as a sound prune.

**Described fix, not applied**. Make the gate's order identical to the ranking order instead of
maintaining two. Store survivors as `(Reverse(weighted_correct), weighted_false_positive,
program.len())` and prune only when the candidate provably cannot place under correctness-first
ordering: keep if `maximum_correct > worst.correct`, or if `maximum_correct == worst.correct` and
`false_positive <= worst.false_positive`. That is sound by the same bound argument the current gate
uses. Define the comparator once and share it between the gate, `ranked`, and `best`, so the two
cannot drift apart again.

## SEV2 — the projective grid scout's successor defect count drops defects born at the half-move

**Location**: `ergodis-private/src/projective_grid.rs:369-371` and `:393-401`. The identical
expression, with the identical definition of `created`, also appears at
`ergodis-private/src/bin/c80_hall_rematch.rs:617` and is serialized into an evidence record there at
`:711`.

**Verified quotes** (re-read at these lines in this session).

`projective_grid.rs:369-371`:

```rust
                    let created = next_defects
                        .difference(half_defects)
                        .difference(old_defects);
```

`projective_grid.rs:393-401`:

```rust
                        let next_support = old_support - consumed_count + created_count;
                        let next_legal = game.legal(successor);
                        let next_omega = game.omega(successor, next_legal);
                        if (next_support, next_omega) >= (old_support, old_omega) {
                            metrics.support_first_lex_failures += 1;
                        }
                        if (next_omega, next_support) >= (old_omega, old_support) {
                            metrics.omega_first_lex_failures += 1;
                        }
```

In the sibling binary, `c80_hall_rematch.rs:711`:

```rust
                                charged_support: [old_support, next_support],
```

**Mechanism**. `old_support` at `projective_grid.rs:352` is a true count, `old_defects.count()`.
`consumed` at `:373` is `old_defects.difference(next_defects)`, so `old_support - consumed_count`
equals `|next_defects ∩ old_defects|`. The delta formula would therefore be right only if `created`
were `next_defects \ old_defects`. It is not: `created` additionally subtracts `half_defects`, the
defect set after the first move alone. Working the algebra through, the computed quantity is

  `next_support = |next_defects| − |(next_defects ∩ half_defects) \ old_defects|`

so every defect that appears at the half-move, survives the second move, and was not already a defect
of `state` is silently dropped. The two lexicographic tests at `:396` and `:399` then compare this
partially counted quantity against a fully counted `old_support`, mixing two different scales on the
two sides of the same comparison.

**Concrete trigger**. A delegate wrote a standalone Python replica of `legal_after`, `legal`,
`omega`, `is_small_boundary`, `defects`, `roots`, and `scout_root`, reproducing the `XorShift64` root
generator exactly, and reports: at `q = 13`, seed 98508030, root state `{0, 74, 124, 159}`,
`first = 79`, `second = 25`, the code computes `next_support = 6` while `next_defects.count() = 7`,
with point 31 the dropped element; across four seeds at `q = 13` the replica found 100 mismatching
rows out of 24,038 exchanges with new defects. I did not re-run that replica. What I verified
independently is the algebraic identity above, directly from the source, and it is sufficient on its
own to establish that the two sides of the comparison are not the same quantity. At `q = 5` and
`q = 7` the scout is vacuous (four-point roots admit no legal continuation, so `complete_exchanges`
is 0); at `q = 11` the replica found 1,404 such rows and no mismatch.

**Reachability**. `scout` is called from `ergodis-private/src/bin/projective_grid_scout.rs:30`, which
takes `--q` from the command line, and `q = 13` is inside the supported prime range 3 through 17.
`c80_hall_rematch.rs` is outside my assigned file list — I am flagging its line 617 as a second
occurrence rather than auditing that binary — but it is the occurrence that matters most, because
line 711 writes the value into an evidence record under the name `charged_support`.

**Impact and my uncertainty, stated plainly**. In the 24,038 sampled rows the error never flipped
`support_first_lex_failures` or `omega_first_lex_failures`; both stayed at 0 under either quantity,
because the sampled regime has a large margin (`old_support = 26`, `old_omega = 102` against
`next_support ≈ 6`, `next_omega = 0`). So the intermediate is demonstrably wrong and a wrong reported
metric is not demonstrated. It is also possible the quantity is deliberate: the sibling binary names
it `charged_support`, which reads like an accounting measure rather than a defect count. That
ambiguity is exactly why this is SEV2. If the lexicographic-descent claim in the manuscript is about
the actual defect support, this is the wrong measure and the descent guarantee is unproven at the
boundary; if it is about a charged support, then comparing it against a raw `old_support` still mixes
two scales.

**Described fix, not applied**. Either compute `let next_support = next_defects.count();` directly and
drop the delta formula, or, if a charged quantity is intended, compute `old_support` on the same
footing and rename both so the lexicographic comparison is between like quantities. Changing one
without the other makes the comparison worse, not better. Whichever is chosen must be applied to
`c80_hall_rematch.rs:617` in the same change, since that is the copy that reaches evidence.

## SEV2 — an undetermined quadratic kernel is counted as a satisfied incidence

**Location**: `ergodis-private/src/q16_quadratic.rs:330-344`, with the kernel construction at
`:390-399`.

**Verified quotes** (re-read at these lines in this session).

`q16_quadratic.rs:330-344`:

```rust
        let (rank, kernel) = quadratic_rank_kernel(&self.geometry.monomials, uncovered);
        if rank == 6 {
            return QuadraticCensus {
                leaves: 1,
                full_rank_fallback: 1,
                ..QuadraticCensus::default()
            };
        }
        let selected_zeros = arc
            .iter()
            .filter(|&&point| dot6(self.geometry.monomials[point as usize], kernel) == 0)
            .count() as u8;
        QuadraticCensus {
            leaves: 1,
            forced_hit: u32::from(selected_zeros != 0),
```

`q16_quadratic.rs:390-400`:

```rust
    let mut kernel = [0_u8; 6];
    if rank == 5 {
        let free = (0..6).find(|&column| basis[column][column] == 0).unwrap();
        kernel[free] = 1;
        for pivot in 0..6 {
            if basis[pivot][pivot] != 0 {
                kernel[pivot] = basis[pivot][free];
            }
        }
    }
    (rank, kernel)
```

**Mechanism**. `kernel` is populated only when `rank == 5`. The `rank == 6` case returns early at
line 331. Every remaining case — `rank <= 4` — falls through to line 338 with `kernel` still
`[0; 6]`, and `dot6(anything, [0; 6])` is 0, so `selected_zeros` becomes the full arc size and
`forced_hit` is set to 1. The census then records a leaf as forced to meet a quadratic that was never
determined, and stores the all-zero vector as that leaf's kernel in the `ExceptionalLeaf` record at
`:345-349`.

**Concrete trigger**. Any level-8 arc whose uncovered-point set spans a monomial space of dimension
at most 4. The cleanest instance is a complete 8-arc with an empty uncovered set, giving `rank = 0`.
Such an arc also bypasses `has_six_point_obstruction` at line 322, since that branch requires a line
carrying at least three uncovered points.

**Reachability**. The only call site is `analyze_quadratic_obstructions` at `q16_quadratic.rs:98`,
reached from `ergodis-private/src/bin/q16_quadratic.rs:35`, fed by `read_level8`, which hard-requires
exactly 2,633 rows parsed from a Lean source file. Whether any of those 2,633 leaves has rank below 5
cannot be settled without running the census, and no committed evidence file records the per-leaf
ranks. The indirect argument that it is currently unreached: `merge_census` copies into a fixed
`[ExceptionalLeaf; 3]`, so a fourth exceptional leaf would panic; the census does not panic in
practice, and the in-file test exercises exactly three exceptional arcs (ordinals 89, 90, 2631) whose
expected kernels are all nonzero, hence rank 5. With the frozen input the path is very likely never
taken, which is what holds this at SEV2. It is silent rather than loud, so if the input set ever
changes it fails quietly and inflates `forced_hit`.

**Described fix, not applied**. Have `quadratic_rank_kernel` return `Option<[u8; 6]>`, yielding
`None` unless `rank == 5`, so the type makes the undetermined case unrepresentable at the call site.
In `evaluate`, record `rank < 5` leaves in their own census bucket instead of computing
`selected_zeros` against a zero vector.

## Below threshold

- `control/mod.rs:670-675` — `args.get(argument).and_then(Value::as_array).map(Vec::as_slice).unwrap_or(&[])` silently drops a malformed `"sum"`/`"minimum"`/`"maximum"` value; same family as round 1's `count` default, but the default is inert.
- `control/mod.rs:867-870` and `:971-974` — once `self.archive` reaches `MAX_ARCHIVE_CLASSES` (4096), new outcome classes stop being recorded and `equivalent_to` reports `null` (false novelty) for later plans; `status.outcome_classes` pins at the cap, so it is visible.
- `control/mod.rs:970-974` — `candidate_batch` updates the archive before the `byte_limit` truncation check, so a plan never written to evidence can still be named as another plan's `equivalent_to`.
- `control/mod.rs:441-495` — `pulse` mutates `solver_status` and `live_scope_masks` before validating `since_epoch`, so a rejected request has already changed state.
- `control/client.rs:56` — a missing or non-boolean `changed` field reads as "no change" and leaves a stale arena; self-correcting on the next pulse because `self.epoch` is not advanced.
- `css_distance.rs:1596` and `:4098` map the rayon thread index modulo `mailboxes.len()`, so two workers sharing a mailbox can clobber each other's `published_bound` — loses pruning power, never over-prunes.
- `css_distance.rs:1706` sets `stats.connected_supports = stats.candidates` where the serial sibling counts incrementally at `:1478`/`:1512`; a reported statistic only.
- `balanced.rs:1769` uses rayon's `collect::<Result<Vec<_>, _>>`, returning an unspecified failing task's error, while `balanced.rs:1746` returns the lowest-ordinal error; error identity only.
- `contextual.rs:1091` — `let compile_kernels = matches!(strategy, ContextStrategy::Cached);` means an `Auto` plan that selects `Cached` never compiles its kernels and silently takes the slow enumeration path; same answer, worse performance.
- `contextual.rs:1054` — `Auto` consults the warm cache before honouring `memory_budget_bytes`, so a budget of 0 still returns a cached result.
- `rpc.rs:260` counts the terminating newline against `max_request_bytes`, so the effective payload limit is one byte below the advertised value.
- `scheduler.rs:1791` — `solve_mixed_radix` has no non-test caller in the crate.
- `semantic_sets.rs:54` — `FixedMaskSet` reserves `u64::MAX` as its empty sentinel and asserts on it, so an orbit over a full 64-element universe whose closure contains the all-ones mask aborts; the only caller, `bin/semantic_affine_census.rs:231`, closes 9-subsets of 27 points and cannot reach it.
- `semantic_sets.rs:370-372` — `TernaryPartitionMaxOverlapProfiler::observe` guards its object-size precondition with `debug_assert_eq!`, so in release a wrong-popcount object underflows `third_overlap` and panics on the histogram index; the sole caller passes a verified 9-subset.
- `semantic_rank.rs:363-371` — a genuinely rank-0 block system compiles but fails `verify`, because `select_rows(&[])` builds `block_offsets = [0, 0]` which `try_new` rejects; a false negative, not a false positive.
- `two_adic_autocorrelation.rs:186` vs `:200` — `lift_autocorrelation` reduces modulo `2^(exponent+1)` while `autocorrelation_total_from_row_sum` reduces modulo `2^exponent`; both are documented and the callers compensate by passing exponents 3 and 4 respectively to land on modulus 16.
- `span.rs:122` — `ambient as u16` is an unchecked truncation, but `arena.rs:45`'s `u16::try_from(cols)` panics first, so it is loud.
- `q16_quadratic.rs:176-179` — `merge_census` copies into `[ExceptionalLeaf; 3]` with no capacity check; a fourth exceptional leaf panics.
- `projective_grid.rs:550-553` — `parallel_root_reduction_is_exact` runs at `q = 5`, where every metric is identically zero, so it compares two all-zero structs and cannot detect a threading defect.
- `zdd.rs:22` and `:599` bound the variable index with `debug_assert!` only; a variable at 256 or above would collide with the `contains_empty` flag in `meta`, but `applications.rs:380` rejects `coordinate_count > 256` and `MAX_VARIABLES` is exactly 256.
- `witness.rs:36` — `WitnessArena::push` would mint an id equal to the `ROOT` sentinel `WitnessId(u32::MAX)` at 2^32 nodes, just past where `u32::try_from` still succeeds.
- `binary_kernel_search.rs:351` — `search` clears `self.witness`, so a second call on the same workspace discards the earlier best witness.
- `confinement.rs` — `confinement_by_generators_field::<F>` does not re-validate `functional_dual_basis` entries against `F::ORDER`, so a matrix built for another field silently makes every candidate infeasible; this is round 1's finding 16 seen from the caller side.
- `applications.rs:1290` — which equal-cost component set is reported depends on `FxHashMap` iteration order; deterministic per build, not stable across hashbrown versions.
- `alignment_control.rs:524` — `ordering_active` returns true when `root_candidate` is `None`, the same permissive-on-absent shape as round 1's `control/mod.rs` finding, but it only steers branch ordering and cannot change a result.
- `group_action.rs` and `ordered_resource.rs` each carry a duplicated evaluator body (`evaluate_impl` / `evaluate_legacy_impl`); the guards agree today, a standing instance of round 1's RC1 copy-and-diverge.

## Not found / checked clean

**`ergodis-private/src/hall_core.rs` — clean, on two independent reads.** I read it and a delegate
read it separately, and we agree on every point. The neighbourhood is never self-reported:
`extract_deficiency` at `:197-241` recomputes reachability from the CSR the caller supplied. The
König argument holds exactly as written — the alternating BFS starts from every unmatched left
vertex, and the only edge skipped from a reachable left vertex is its own matched edge, whose right
endpoint is already marked because that is how the vertex was reached (roots are unmatched and skip
nothing, since `pair_left[left] == NONE == u32::MAX` can never equal a valid right index). So
`deficient_right` is exactly `N(deficient_left)`, not merely a superset. Every reachable right vertex
is matched — an unmatched one would be an augmenting path against a maximum matching — and matched
into the reachable left set, giving `|deficient_right| < |deficient_left|`. Kuhn's outer loop at
`:74-78` does produce a maximum matching, so the saturation test at `:79` is on the correct side and
is `==` rather than `>=`. `left_count == 0` returns `Saturated`, the correct vacuous answer.
`validate` at `:106-130` checks that every neighbour index lies inside the declared right ground set
and that the offset array has exactly `left_count + 1` entries, is monotone, starts at 0, and ends at
`neighbors.len()`, so a certificate subset outside the ground set is rejected. `next_epoch` at
`:132-140` wraps safely by zeroing both seen arrays and restarting at 1. The exhaustive four-by-four
test at `:311-373` independently confirms saturation against brute force and recomputes the true
neighbourhood of the reported violator.

**`hall.rs`** in the core crate is the same story: `alternating_deficiency` at `:302-355` computes
König's set correctly for the same reason, and `verify_hall_result` at `:358-412` is a genuine
independent replay that re-ORs the rows of the claimed deficient set and demands bit-for-bit equality
with the claimed neighbourhood plus `left_total > right_total`. It does not depend on the matching
being maximum, which is right, since `|Z| > |N(Z)|` alone refutes saturation.

**`linear_code.rs`** — the Brouwer–Zimmermann bound is correct. Because each systematic basis is
systematic on its own information set, the number of rows combined equals the codeword's weight
restricted to that set, so a codeword not found at level `w` in any of `N` disjoint sets has weight
at least `N(w+1)`. That is exactly `unseen_lower_bound` at `:340-341` and the post-level-1 early
return at `:301`. `compile_disjoint_systematic_bases` produces genuinely systematic bases — I
verified the invariant that eliminating with a later pivot cannot reintroduce a bit at an earlier
pivot — and pivots within one basis are distinct because elimination zeroes the chosen coordinate in
every other row. The Gray-code scan visits each nonzero coefficient vector exactly once, and
`next_same_weight` is Gosper's hack with no overflow at rank 63.

**`span.rs`** — the generated-span closure is complete and its dedup is safe. By induction over the
column loop at `:88-119`, the state set after pass `k` is exactly the set of spans of subsets of the
first `k` columns, because each pass extends every state that existed before it. The dedup at `:104`
keeps only the first witness path to a subspace, which is sound here because every step raises the
rank by exactly one, so every path to a dimension-`d` subspace has length `d` and the reported cost
is path-independent. `query_canonical_target_image` scans states sorted by `(rank, basis)` and returns
the first containing subspace, which is the minimum-cost one.

**`multiset.rs`, `arena.rs`, `witness.rs`, `packed_ternary.rs`, `semantic_plan.rs`,
`q19_marked_polar.rs`** — read in full, nothing at severity. `add_mod3` in `packed_ternary.rs` is
correct: three-bit lanes cap at 4, so `threes | fours` sets exactly one flag per lane needing the
subtraction and `3 * mask` cannot carry between lanes. `q19_marked_polar`'s projective normalization
enumerates exactly the 381 points of PG(2,19) and its root count arithmetic cannot overflow.

**`two_adic_autocorrelation.rs`** — the lift identity is right. With `c = a + 2^k x` and `x` binary,
the omitted `2^{2k} A_s(x)` term vanishes mod `2^{k+1}` for `k >= 1`, and the cross term reduces to
its parity. The `left as u8` truncation at `:183` is harmless because the operand is masked to bit 0
by the binary lift. The quadratic-form synthesis at `:86-126` is exact: a degree-two polynomial over
GF(2) with no constant term is determined by its values on basis vectors and on sums of two basis
vectors, which is precisely what the double loop evaluates, and `evaluate` reconstructs it with each
mixed pair counted once because `mixed_upper[i]` carries only bits above `i`.

**`semantic_rank.rs`** — both rank kernels are correct. `rank_blocks_online` reduces against basis
rows whose pivots need not be in increasing column order, which looks like it could let a later
elimination reintroduce a nonzero at an earlier pivot; it cannot, because the invariant
`basis[k][p_i] = 0` for all `i < k` holds by induction and makes every such reintroduction a
multiplication by zero. `rank_matrix_prefix` is ordinary Gaussian elimination. The two disagree
loudly rather than silently: `compile_semantic_rank_core:473` asserts the independent-row count
equals the rank computed by the other kernel. The certificate ordering also matches: the compiler
enumerates only masks containing the mandatory blocks, which is complete because a block whose
removal loses rank must lie in every full-rank subset, and the deposit-plus-union map preserves the
colexicographic order that `for_each_k_subset` produces, so the verifier's filtered enumeration
lands in the same sequence. The GF(9) tables use `x^2 = 2 = -1`, which is irreducible over GF(3),
and `landed_rank_adapter.rs` imports this same `Gf9` rather than carrying a second copy — there is
no encoding divergence between them.

**`scheduler.rs`** — clean, including the two places I probed independently. The `par_chunks_mut`
prefix-max sweep at `:2051-2063` is exactly equivalent to the serial `step_by(block)` loop at
`:2064-2072`, because `block = stride * radix` is a prefix product of the radices and so divides the
state space, each chunk is one `base` iteration, and the recurrence never crosses a chunk boundary.
All reductions are integer `min`/`max`, so there is no non-associative accumulation anywhere.
`state_is_pareto` at `:2147-2165` would drop *both* members of a duplicated state pair, since each
dominates the other; that is unreachable because the incumbent lookup at `:781-801` admits at most
one state per distinct load vector, and the degenerate `store_loads == false` configuration
(`:679`) requires `graded_antichain`, which takes the branch at `:861` that skips Pareto filtering
entirely. The in-place witness compaction at `:911-926` is also safe: the i-th newly created state's
witness index is always at least `layer_witness_start + i`, so the write target is never a future
source.

**`contextual.rs`** — every memo key captures everything its value depends on.
`RankBoundedContextCache.costs` is keyed on the ambient subspace matrix in RREF, which is canonical
across queries with different ambient bases, and the cached cost is basis-independent because
replacing the basis reparameterizes the minimizing map over the same set. `RankOneProbeCache` is
keyed on the canonical projective line. `encode_subspace_order` returns an overflow error rather
than truncating, so no two distinct keys collide.

**`zdd.rs`** — the unique table is not a collision hazard. `UniqueTable::intern` at `:60-87` walks
the bucket chain and compares every field; `node_key` is only a bucket selector. `DirectMemo` is
lossy but stores and compares the full 64-bit key, so a hit is always exact and an eviction costs
only recomputation. `pair_key` and `commutative_key` are injective given the hard node cap of
`(1 << 24) - 2` at `:450`, so the two 24-bit fields never overlap.

**`orbit.rs`, `orbit_compile.rs`, `group_action.rs`, `parametric_certificate.rs`,
`ordered_resource.rs`, `integer_moments.rs`, `sat.rs`, `residual_hitting.rs`,
`frozen_shortest_path.rs`, `modular_power.rs`, `prime_polynomial.rs`** — checked and sound. The
notable ones: `group_action.rs`'s RREF canonicalization is a true canonical form because
`pack_basis` is shared between the compiler and the on-the-fly representative;
`orbit_compile.rs`'s ternary infeasibility certificate produces a functional that genuinely
annihilates every basis row; `ordered_resource.rs`'s slab reuse fails loudly with
`FrozenParetoError::Artifact` rather than silently reading a released slab; `sat.rs`'s UNSAT
certificate survives the disjoint-colour-domain case, because "adjacent" means "must differ" and
disjoint domains satisfy that, leaving the pigeonhole refutation valid.

**`commutant.rs`, `coherent_closure.rs`, `confinement.rs`, `continuation.rs`, `cyclic_action.rs`,
`bitset.rs`, `automata.rs`** — the `verify_*` and `certify_*` entry points establish what they name.
`verify_binary_commutant` is sound by rank–nullity rather than by trusting the compiler;
`certify_binary_extension_field` runs a correct Rabin irreducibility test on the recovered minimal
polynomial rather than sampling; `verify_coherent_closure` compares full struct equality, and taking
the order from the certificate is not a loophole because the compiler rejects any order whose square
does not match the label count.

**`landed_rank_adapter.rs` and `q25_pair_repair.rs`** — clean beyond round 1's GF(9) verification.
The GF(9) encoding does match its consumer: `add`, `mul`, and `neg` are identical to
`semantic_rank.rs`'s, with `x^2 = 2 = -1` on both sides. `sym_power(M, 1)` evaluates to the
transpose, but it is applied to both the target and the source block, and the transposed matrices
generate the same group, so the intertwiner rank is unaffected. In `q25_pair_repair.rs`,
`verify_certificate` and `verify_minimum_certificate` both recompute the geometry rather than
trusting the file, and `canonical_triple` minimizes over sorted images, which is a correct canonical
form that merges no inequivalent triples.

**Sentinel and memo sweep across every file opened** — no sentinel found that a real id can reach in
its actual domain, and no memo whose key omits an input its value depends on. The near misses are
recorded above under "Below threshold".

## Coverage gap

Two places in scope could still hide a silent-wrongness defect and were not read at a depth that
would find one.

`observational.rs` is 8,626 lines and only its `verify_*` entry points, `distinguishing_path`,
`restrict_generators`, and a sentinel and memo sweep were read. The verifiers themselves check out —
`verify_compilation` establishes both the congruence and the maximality halves and rejects the
`AdaptiveTranscript` policy outright rather than skipping it. But the `QuotientOnly` and
`MultiwayTranscript` verifier branches re-run the same minimization compilers the prover ran, so a
defect inside `minimize_partition_multiway` or the split-transcript compiler would replay identically
and verify clean. That is round 1's RC3 in its most concentrated form, and it is a real residual
risk rather than a hypothetical one. It should be the first target of any round 3.

`selector.rs` was read only as far as its header and error taxonomy; its successive-specialization
body was not audited. The back half of `defect.rs`, from roughly line 430, was likewise not opened,
and its domain constants in `analyze_fixed_maximal_set` — the baseline cost table, the correction
budget of 19, the required internal-line count of 279 — encode a GF(27) plane argument that cannot be
checked against the source alone. The surrounding code is internally consistent; validating the
constants needs the manuscript.
