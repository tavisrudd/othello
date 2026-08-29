# C985 commercial benchmark expansion

## Current best target

The first external expansion is the [official VLSAT-2 suite](https://cadp.inria.fr/resources/vlsat/2.html).  Despite its name,
"VL" means "Very Large": the instances arise from decomposing Petri nets that
model communication protocols and concurrent systems.  The official suite has
100 formulas, split evenly between SAT and UNSAT, and its authors excluded any
formula that one of five contemporary solvers could finish within one minute on
their reference host.

The first experiment is the first ten rows of the official size-ordered table,
without outcome-based selection.  Nine are officially UNSAT and one is SAT.
Ergodis recognizes the direct coloring semantics, constructs the effective
pairwise-incompatibility graph, and emits a clique of size `colors + 1`.  The
SAT control is required to remain a theorem miss and routes to Kissat in the
portfolio executable.

## Fairness gate

The protocol incorporates the 2026-08-28 performance review rather than using
the older asymmetric warm-loop comparison:

- both commands are fresh native processes and receive the identical CNF;
- process launch, parsing, solving, and result emission are timed for both;
- Ergodis certificate construction and JSON emission are inside its timed
  region, while Kissat proof emission is disabled, favoring the baseline;
- the CNF page cache is warmed by the same SHA-256 pass before either command;
- commands are pinned to one recorded logical CPU and their order rotates;
- completed baselines receive seven paired rounds; the short certificate path
  receives fifteen fresh-process rounds, but only matching within-round pairs
  enter a speedup or t-score;
- a first Kissat timeout is retained as a timeout lower-bound case and stops
  further baseline rounds; timeout cases produce only lower bounds and never enter a
  t-score;
- raw records stream directly to JSONL and include wall time, process CPU time,
  context switches, sampled CPU frequency, and peak RSS;
- summaries report min, Q1, median, Q3, max, normalized time per clause, paired
  geometric-mean ratios, paired log t-scores, and RSS distributions;
- the report records CPU topology, online and isolated SMT siblings, governor,
  boost state, scaling driver and preference, load, Rust toolchain and flags,
  Kissat compiler/build strings, revisions, and hashes;
- a separate checker recomputes every statistic and independently verifies
  every clique against the original CNF.

Canonical evidence refuses to run unless the pinned CPU uses the `performance`
governor and boost/turbo is disabled.  CPU/SMT isolation remains recorded but,
by explicit user direction for this quiet host, is not a refusal condition.
Earlier sizing measurements made under `powersave` with boost enabled remain
diagnostic and are not benchmark evidence.

Replay after configuring a stable host with:

```sh
ERGODIS_BENCH_CPU=3 scripts/vlsat2-prefix-ab.sh
```

Set `ERGODIS_DIAGNOSTIC_HOST=1` only for uncommitted sizing runs.
The replay script defaults to explicit generic `x86-64` Rust code generation,
matching the recorded generic `-O3 -DNDEBUG` Kissat build rather than silently
giving either side a host-native ISA advantage.  `ERGODIS_RUSTFLAGS` may override
this only as a separately labelled configuration; the exact effective flags and
both executable hashes are retained.

## Next strata

1. Run the complete 100-case VLSAT-2 suite, reporting theorem coverage separately
   for the 50 official SAT and 50 official UNSAT cases.
2. Run the 80-case SATComp-2024 manifest: all 42 `hardware-miter` entries, all
   adjacent verification/miter families, and five lowest-hash controls from
   five unrelated families.
3. Add clausal AND/ITE/XOR congruence compilation for isomorphic hardware miters,
   then rerun the unchanged manifest against direct Kissat and the
   Ergodis-to-Kissat portfolio.
4. Add HWMCC AIGER/BTOR2 inputs only after the CNF suite establishes which circuit
   interface summaries produce wins beyond modern Kissat's own congruence pass.

The target metric is not a cherry-picked maximum speedup.  It is theorem-hit
coverage, clean-miss overhead, end-to-end time and memory by family, with generic
fallback parity on the controls.

The full-suite coverage path is deliberately separate from performance evidence:
it records logical hits, misses, errors, and timeouts, while marking all elapsed
fields diagnostic.  It streams one record per instance and independently replays
each certificate without retaining the CNF or clause set in memory:

```sh
ERGODIS_BENCH_CPU=3 scripts/vlsat2-full-coverage.sh
```

The checked full-suite result is reported in
`notes/2026-08-28-c985-vlsat2-full-coverage.md`: all 50 officially UNSAT rows
receive exact certificates, 49 officially SAT rows are clean misses, and one
current official download receives a replayed 90-clique/89-color certificate
despite its SAT table label.  There are no recognizer errors or timeouts.

The corrected-protocol first-ten Kissat A/B is reported in
`notes/2026-08-28-c985-vlsat2-kissat-corrected-ab.md`.  Four paired UNSAT rows
give a `381.13x` geometric mean with instance-log `t=22.56`; five further UNSAT
rows give ten-second timeout lower bounds above `2051x`.  The user-approved
quiet host used the performance governor with boost disabled; its lack of
kernel CPU isolation is recorded explicitly.
