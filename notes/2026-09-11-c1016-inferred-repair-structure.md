# C1016: inferred response structure and checked local repair

**Lane**: `ergodis`. Private native work, 2026-09-11; not for shipment.

## Result

The private compiler now derives additive response components from supplied
quadratic vector constraints and linear invariant scopes. Component IDs are no
longer handed to the quadratic path. It freezes other variables, enumerates
bounded invariant-preserving component options, and compiles incident-term
responses into the allocation-free exact additive repair kernel.

This is general structural extraction within a supplied model. The Hadamard
adapter still supplies the bordered circulant construction and row-sum
invariants. No known solution, solution seed or witness-derived feature is read;
the compiler contains no order-specific solving branch. Property controls use
arbitrary quadratic systems and arbitrary linear maps, including forced hash
collisions and exhaustive independent oracles.

The final sparse compiler reduces measured cycles by about 23% at order 668 and
33–35% at 2092 relative to the retained direct compiler, including compilation.
Every fixed-round paired witness agrees. The index increases cache misses and
memory; these are representation gains, not new global reductions.

Optional convex-hull directions, checked with exact Cauchy–Schwarz and a
response-derived score lattice, remove 11–14% of leaf checks at 2092 and reduce
cycles by 4–7% in the short controlled workload. They do not repay their cost
reliably at 668. Span-based directions removed no additional leaves and added
7–14% cycles. Both are optional, disabled by default. No floating-point proposal
can authorize pruning.

A second general mechanism recognizes balanced four-sign exchanges by matching
sums of invariant columns and independently checking every match. This derives
a grid rectangle from row/column equations without grid-specific solving code.
The adapter's capped first-match sampling is biased and loses on the measured
row-sum-only controls. It is not a complete circuit basis or connectivity proof.

## Evidence and gates

Private authority:
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.
Implementation snapshot e8aca40; reproducibility bundle committed at 7931e22; diagnostic hardening at 086574d
(initial bundle 1dff719); projection-free arithmetic reuse design at 0ecef36.
Reproducibility bundle: `evidence/structure-repair/REPORT.md`, with generated
witnesses, counter samples, exact commands, retained hashes, paired log t-scores,
profiles and CPU-budget overruns. Full-gate result is recorded there.

At seeds 801–808 with 300 ms per-thread CPU budgets, order-2092 residual-policy
median score changes from 29,648 direct to 21,968 generic and 20,688 generic+hull.
Mixed-policy medians are 90,872 / 44,416 / 25,776. These consecutive quality
batches are not timing A/Bs. Search preserves row sums only. None passes the
separate q18/q29 margin-fibre gate at 14,800.

1,026 records independently replayed; four successful order-124 runs additionally
passed complete matrix row-orthogonality checks. Successful runs include repeated
solutions, not four claimed inequivalent matrices. Orders 668/716/2092 remain
unsolved by this probe. These known-feasible smaller models expose capability
limits; a miss is never evidence of nonexistence.

## Longer-budget discriminator

At the same seeds with 2,000 ms CPU allowances, residual-guided 668/716 runs
end at exactly the same witnesses as their 300 ms runs; mixed exploration improves
some states. Ordinary and hull variants agree on all 48 longer paired witnesses.
No solution appears. A frozen-state diagnostic shows that the pressure shortlist,
even with all boundary ties included, can expose only 7–9% of variables there.
That restricts proposal reach; it does not prove all eligible combinations fail.
The next general mechanism should track failed regions/coverage and broaden
exploration when progress stalls, with exact source-scope checks on any memo.
At two seconds, pressure has the best measured median at 668; exact gain wins
at 716 and narrowly at 2092. No one policy wins all orders. Use this to motivate
feedback-driven allocation, never an order-to-policy lookup.

The full release gate passed: 783 passed, zero failed, one ignored. All 1,026
records independently replay and 16 mutation controls are rejected. Two seconds
still does not decide these hard models; all longer runs reached their CPU limit.

## Next decisions

1. Preserve vector residual structure in the model/IR instead of immediately
   expanding squared objectives into quartic scalar form. The component
   recognizer is now real; construction-family recognition remains separate.
2. Select optional projections using observed bound lift, active-table shape and
   compile cost. Start with cheap screens and abandon costly checks when they
   do not repay work. Never use order labels or known-solution information.
3. Escape local minima using general invariant-map moves and schedules. Compare
   neutral movement, composite exchanges and scope-bound repair explanations on
   smaller controls before the strict 2092 fibre-recovery gate. Exact local
   solving alone does not establish global reachability.
4. First test reuse of the already checked score lattice in ordinary interval
   bounds, without a geometric projection: strict improvements are at most S-d,
   so a box lower bound above S-d suffices. Cache the cutoff at incumbent changes.
   This is designed, not implemented or timed; preserve the clean d=1 path and
   run the full proof/allocation/retained-counter gates.
5. Price duplicate-term canonicalization and reusable sparse priority workspaces.
   Priorities account for about 16% of sampled cycles. Neither proposed change
   has yet passed its own retained counter gate.

## Mystery ledger: ej and tt

- Settled: support and invariant analysis can recover additive groups without
  supplied component IDs. Frozen supports, not problem names, determine legality.
- Settled: general convex-hull geometry can produce useful exact local bounds;
  the numerical proposer does not need trusted theorem authority.
- Open: why local exact repair stalls despite a known-feasible 668 model. Proposal reach and barrier crossing
  remain candidate explanations; no model obstruction is established.
  Owner: C1016; matched-CPU schedule experiments and the known-feasible fibre gate.
- Open: whether a cheap predictor distinguishes profitable projection regions.
  Current evidence is workload-specific and too small to admit a general policy.
- Open: whether richer linear constraints make the exchange family worthwhile.
  Row-sum-only negatives do not decide that question, and first-64 sampling is
  biased. No complete circuit enumeration or fibre-connectivity result exists.
- Open: source-family discovery and production Evolve integration. These private
  recognizers are candidate capabilities, not shipped public APIs or completed
  automatic model discovery.
