# Explainable infeasibility for assignment and scheduling — prototype

**Date**: 2026-08-31
**Scope**: commercial prototype, not a math task. All work confined to
`ergodis-private/src/bin/certiis.rs` and three scripts under `ergodis-private/python/`
(`certiis_benchmark.py`, `certiis_summarise.py`, `certiis_core_audit.py`). No edit to the
Ergodis core, to `ergodis-private/src/lib.rs`, `ergodis-private/Cargo.toml`, or
`ergodis-private/src/hall_core.rs`; `hall_core` is called exactly as it stands.

## Verdict

The prototype does what it set out to do and the acceptance gate passes on all counts.
Against 78 generated instances: certificates irreducible and verified by explicit removal
test everywhere; Hopcroft-Karp agrees on feasible-versus-infeasible everywhere; the
classifier declines on the non-matching shapes; and certiis is roughly 100x faster than
OR-Tools CP-SAT at producing an explanation, while CP-SAT fails to produce one at all
within 60 seconds on a third of the infeasible instances.

The commercially interesting result is not the speed. It is that on rosters with several
independent shortages, CP-SAT returns a *smaller* core than our explanation — and deleting
the tasks that core names leaves the roster still infeasible, on every such instance. Our
decomposed certificates restore feasibility every time. A solver's unsatisfiable core
answers "is there a conflict"; a planner needs "what are all the shortages, and who is
short".

## Product thesis

Every commercial optimizer answers an over-constrained roster with `INFEASIBLE` and leaves
a human to bisect by hand. The Hall matching machinery already in this repository can
return the *reason*: a minimal set of tasks whose eligible resources are too few, together
with those resources. The differentiator is not the matching — it is that the tool knows
which problems it may legitimately answer and declines the rest by name.

## Design

### Instance model

One JSON schema, `certiis-instance/v1`:

```json
{
  "schema": "certiis-instance/v1",
  "name": "roster-...",
  "tasks":     [{"id": "shift_mon_am", "demand": 1, "distinct": false}],
  "resources": [{"id": "nurse_alice",  "capacity": 3}],
  "eligible":  [["shift_mon_am", "nurse_alice"]],
  "couplings": []
}
```

`demand` is how many resource-units the task consumes; `capacity` is how many task-units a
resource can serve. `distinct` (default false) says the units must come from different
resources, which as explained below takes the instance out of the certifiable regime.
`couplings` carries the other structure that does the same: exact resource loads,
prescribed row or column sums, pairwise inner products, task conflicts.

### Classifier — the regimes

| Regime | Trigger | Verdict |
|---|---|---|
| `bipartite_matching`             | all demands 1, all capacities 1, no couplings | certify |
| `capacitated_matching`           | demands or capacities > 1, no couplings       | certify |
| `degree_constrained_completion`  | any exact resource load, prescribed row or column sums, or any task needing distinct resources | decline |
| `quadratically_coupled`          | any pairwise inner-product or task-conflict coupling | decline |

Quadratic coupling is checked first, so an instance carrying both kinds of structure is
named by the harder one.

The boundary is stated exactly, because it is where the value of the product lives:

- Task-side *exact demands* plus resource-side *upper bounds* only. Feasibility is a
  max-flow on `source -> task (d_t) -> eligible resource (inf) -> sink (c_r)`. Min-cut
  equals `min_{S subset T} [ demand(T) - demand(S) + capacity(N(S)) ]`, so the instance is
  feasible **iff** `demand(S) <= capacity(N(S))` for every task set `S`. A violating `S`
  with its neighbourhood is therefore a complete and sufficient explanation. This is the
  defect form of Hall's theorem and it is what the tool certifies.
- Add resource-side *lower* bounds (every nurse must work exactly `c` shifts, prescribed
  column sums) and feasibility becomes a degree-constrained subgraph / transportation
  problem. Hall's condition stays necessary but stops being sufficient, and the minimal
  explanation can be a cut on the resource side that no task set names. The tool declines
  and names Gale-Ryser and the Gale supply-demand (flow feasibility) theorem as what is
  needed instead.
- Add pairwise coupling between tasks — inner products, conflict pairs, "these two shifts
  may not share a nurse" written as a quadratic rather than as an eligibility restriction —
  and the problem is a degree-constrained matrix completion. This is precisely the failure
  mode C1018 recorded (`notes/2026-08-30-c1018-hunt-plane12.md`, "Ergodis interface
  notes"): forcing Hall onto it yields a decorative rather than a load-bearing certificate.
  The tool declines outright.

### Minimal-certificate extraction

`hall_core::HallWorkspace::solve` returns the alternating-reachable deficient left set —
the *maximum-deficiency* set, which is generally far from minimal. Three things turn it
into a product-quality explanation.

**Decomposition into independent bottlenecks.** The set is first split into the connected
components of the bipartite subgraph it induces with its neighbourhood. Components
partition both the task set and its neighbourhood, so the total deficit is the sum of the
per-component deficits; a component with deficit zero is padding and is dropped, and each
remaining component is reported as its own certificate. This is not cosmetic. On a
three-shortage roster the maximum-deficiency set has 139 tasks and a single irreducible
set would report one padded blob; decomposition returns three certificates of 4, 6 and 9
tasks, each with its own disjoint resource set, and each one on its own proving the
instance infeasible. A roster manager can act on the three independently.

**Fixpoint deletion inside each component.** For each task `t` in the current set, test
whether `S \ {t}` still violates; if so, drop `t` permanently, and repeat until a pass
changes nothing. The fixpoint loop is not optional here, and this is a trap worth naming.
The one-pass deletion filter used for irreducible infeasible subsystems in linear
programming is justified by infeasibility being inherited by supersets. A Hall violation is
not monotone that way — a subset of a non-violating set can violate — so a task passed over
early can become removable after a later removal, and only a pass that changes nothing
proves irreducibility. The prototype produced reducible certificates until this was fixed.

**Explicit removal tests in the output.** For every task in every certificate the JSON
records the post-removal `(demand, capacity)` pair witnessing that dropping it destroys the
violation. Irreducibility is proved by exhibited test, not asserted; `--verify` recomputes
every one of them from the eligibility relation alone.

One caveat stated plainly: irreducible under single-task removal is a weaker property than
smallest. Finding a minimum-cardinality Hall violator is a different and harder problem, and
this tool does not claim to solve it. What decomposition buys is that the common source of
padding — several unrelated shortages fused into one set — is removed structurally rather
than left to a greedy sweep.

### Capacities via `hall_core` unchanged

`hall_core` has no capacity concept, so the capacitated instance is expanded to unit
copies: `d_t` copies of each task, `c_r` copies of each resource, copies inheriting the
eligibility relation. Two closure facts make the projection back to the task level exact.
Copies of one task have identical neighbourhoods, so the alternating-reachable left set is
a union of whole task-copy classes; the reached right set is `N` of that, hence a union of
whole resource-copy classes. Therefore `demand(S) = |L*| > |R*| = capacity(N(S))`. The
price is an expansion of size `sum(d) x sum(c)`, which is the first item on the `hall_core`
request list below.

### Generators

Five domains. The two realistic ones each carry a knob that plants a violation of known
size and known membership, plus a second knob that inflates the maximum-deficiency set
without changing the answer, so minimization has something real to do:

- `roster` — shifts with a required qualification, nurses holding qualification sets and a
  maximum shift count. The feasible core is built by drawing a valid assignment first and
  taking eligibility as a superset of it, so the base is feasible by construction.
- `placement` — jobs requiring an accelerator class and a memory footprint, hosts with a
  class and a slot capacity, capacities above one throughout.
- `multi-roster` — the same roster carrying three independent shortages of sizes `k`,
  `k + 2` and `k + 5`. This is the case that separates a single unsatisfiable core from a
  decomposed explanation.
- `coupled` — row sums, column sums and all pairwise inner products together. Must be
  declined.
- `distinct-roster` — every shift needs two *distinct* nurses. Must also be declined; see
  the boundary section below.

The planted block is `k` scarce tasks eligible only to scarce resources of total capacity
`k - 2` plus one bridge resource of capacity 1. The bridge is pinned by a chain
`chain_j ~ {bridge_j, bridge_{j+1}}` whose last link sees only the last bridge, so the
chain's matching is forced from the far end inwards and the bridge is never free. Two
consequences are checked on every generated instance rather than assumed: the unique
irreducible certificate is exactly the `k` scarce tasks, because dropping any one leaves
demand `k - 1` against capacity `k - 1`; and the alternating-reachable set has size
`k + cascade`, because reachability walks the whole chain. On the `k = 9`, cascade 40
roster that is a 49-task raw set reduced to the 9 planted tasks; on the three-shortage
roster with cascade 40 it is 139 raw tasks reduced to 4 + 6 + 9.

The ground truth emitted inside each instance file — planted tasks per block, planted
resources, expected certificate size, expected raw set size, bottleneck count — is what
certificate quality is measured against, rather than the tool's own output.

### Where the tool stops, stated exactly

The sharpest boundary found in this work is not the exotic one. `demand` counts
resource-*units*, and units of one task may come from the same resource more than once — a
job taking three slots on one host. The moment a task instead needs `demand` **distinct**
resources — "this shift needs three different nurses", the most common real roster shape
there is — Hall's condition stops being sufficient. One task of demand 2 against one
resource of capacity 5 passes every task-side Hall test and is infeasible. That is an
`x_tr <= 1` upper bound on top of the capacities, which makes the problem a
degree-constrained subgraph problem whose certificate is a cut naming both a task set and a
resource set. The tool classifies such instances as `degree_constrained_completion` and
declines. Any product in this space must either solve that case properly or say plainly
that it does not.

## Correctness evidence

`certiis selftest` is the acceptance gate for the extractor itself and runs in under a
second:

```bash
cd ~/src/othello/ergodis-private
cargo test  --release --bin certiis     # 6 unit tests
cargo build --release --bin certiis
./target/release/certiis selftest
```

It checks four things.

1. **Exhaustive cross-check on small random instances.** 4000 random capacitated instances
   with up to 6 tasks and 5 resources, demands 1-2 and capacities 1-3. Each one is decided
   by brute force over *every* task subset against the defect-Hall condition, and the tool's
   verdict must agree — 1392 feasible, 2608 infeasible in the fixed seeded run. Every
   certificate is then re-verified by the independent verifier. A wrong maximum matching, a
   wrong projection through the unit expansion, or a reducible certificate all fail here.
2. **Planted ground truth.** For every seed and every `(plant, cascade)` setting in
   `(4,0)`, `(4,40)`, `(9,40)`, `(17,120)`, across both realistic domains, the returned
   certificate must equal the planted task set exactly — not merely have the right size —
   and the pre-minimization maximum-deficiency set must have exactly the predicted size
   `plant + cascade`.
3. **Independent shortages stay separated.** Three-shortage rosters must return exactly
   three certificates, and the multiset of certificate task sets must equal the multiset of
   planted blocks.
4. **Declines.** The coupled instance (row sums, column sums, all pairwise inner products),
   the exact-resource-load instance, and the distinct-resources roster must each be
   declined, with a non-empty statement of what is needed instead.

The unit tests add a two-bottleneck instance with a hand-checked expected answer, a
capacitated feasible/infeasible pair, both decline paths, and a tampering test: a
certificate with an extra task appended is rejected by `--verify` as reducible.

Independent verification is genuinely independent. `certiis verify` reloads the instance,
recomputes the SHA-256 digest and refuses a certificate produced for different bytes,
re-runs the classifier, recomputes each neighbourhood from the eligibility pair list alone,
recomputes demand and capacity, redoes every removal test, and checks that the certificates
are pairwise disjoint in tasks and in resources. It shares no code path with the extractor
and never touches `hall_core`.

## Benchmark

### What was compared, with versions and invocations

Three independent parties look at the same 78 generated instances (5 seeds x 3 realistic
domains x 5 `(plant, cascade)` settings, plus the 3 instances that must be declined):

- **certiis**, this prototype, Rust release build.
- **Google OR-Tools CP-SAT 9.15.6755**, whose unsatisfiable core over assumption literals
  is the directly comparable "which tasks are to blame" explanation. Model: an integer
  variable per eligible pair bounded by `min(demand, capacity)`; one hard constraint per
  resource, `sum of units <= capacity`; one assumption literal per task enforcing
  `sum of units == demand` via `OnlyEnforceIf`; all literals passed to `AddAssumptions`;
  `num_workers = 1`, `max_time_in_seconds = 60`; explanation read from
  `SufficientAssumptionsForInfeasibility()`.
- **HiGHS 1.15.1** (via `highspy`), irreducible infeasible subsystem on the linear
  relaxation. The constraint matrix is bipartite, hence totally unimodular, so the
  relaxation is exact here and an LP IIS is a fair comparison. Only `iis_strategy = 2`
  returns a populated IIS in this version; the default `0` silently returns an empty one and
  `1` returns `kError`.

**networkx 3.6.1** Hopcroft-Karp maximum matching on the unit-expanded graph is the
correctness oracle, so a bug in the extractor cannot masquerade as a win. Python 3.12.12.

`highspy` and `ortools` cannot share one interpreter here: the OR-Tools wheel bundles its
own HiGHS shared object and importing `highspy` afterwards fails with an undefined
`Highs::releaseMemory` symbol. The two incumbents therefore run as separate passes, merged
with `--merge-from`. Every engine runs three times per instance and the fastest is kept.
The machine carried other work during the passes, so all three engines' absolute timings
are pessimistic by a similar factor; the ratios are the trustworthy part, and the scale
figures at the end of this section were retaken on an idle machine.

Raw artifacts: `~/.cache/ergodis/certiis/benchmark.json`, `benchmark-highs.json`,
`summary.txt`, `audit.txt`, with the per-instance certificates under `certificates/` and the
instances under `instances/`. These are regenerable from the commands above and are
deliberately not committed.

```bash
cd ~/src/othello/ergodis-private
cargo build --release --bin certiis
C=~/.cache/ergodis/certiis
./target/release/certiis suite --out $C/instances

uv run --python 3.12 --with highspy python python/certiis_benchmark.py \
    --engines highs --repeats 3 --time-limit 60 \
    --instances $C/instances --certificates $C/certificates \
    --binary ./target/release/certiis --out $C/benchmark-highs.json

uv run --python 3.12 --with ortools --with networkx python python/certiis_benchmark.py \
    --engines hopcroft,cpsat --repeats 3 --time-limit 60 \
    --instances $C/instances --certificates $C/certificates \
    --binary ./target/release/certiis \
    --merge-from $C/benchmark-highs.json --out $C/benchmark.json

uv run --python 3.12 python python/certiis_summarise.py --benchmark $C/benchmark.json
uv run --python 3.12 python python/certiis_core_audit.py \
    --benchmark $C/benchmark.json --instances $C/instances \
    --binary ./target/release/certiis --workdir $C/audit
```

### Correctness

Hopcroft-Karp agrees with certiis on feasible-versus-infeasible for all 78 instances, and
certiis declines on all 3 non-matching instances. All 60 infeasible instances return
certificates that equal the planted ground truth exactly, and the number of certificates
equals the planted bottleneck count on all 60.

### Time to explanation

| | certiis | CP-SAT | HiGHS |
|---|---:|---:|---:|
| infeasible, median | 0.40 ms | 61.2 ms | 57.8 ms |
| infeasible, max | 1.10 ms | 60018 ms (limit) | 327 ms |
| feasible, median | 0.31 ms | 23.7 ms | 15.9 ms |

certiis figures are in-process; end-to-end wall time including process launch and JSON
output has median 2.61 ms, and independent verification of the certificate adds a further
3.07 ms median. Even measured that way, **CP-SAT does not beat certiis end-to-end on a
single instance in the suite.**

CP-SAT returned no explanation at all on 20 of the 60 infeasible instances: it hit the 60-second
limit and reported `UNKNOWN`. These are the cascade instances, where a long forced
alternating chain sits next to the shortage. Over the 40 instances where it did answer, its
median was 38.6 ms against 0.35 ms for certiis on the same subset — a factor of about 110.

### Explanation size

| | median | min | max |
|---|---:|---:|---:|
| certiis, total tasks named | 13 | 4 | 58 |
| certiis before minimization | 49 | 4 | 418 |
| CP-SAT core | 43 | 4 | 49 |
| HiGHS IIS, task rows only | 22 | 4 | 124 |
| HiGHS IIS, all rows and columns | 88 | 9 | 845 |

Minimization is doing real work: the median explanation shrinks from 49 tasks to 13, and on
the largest instance from 418 to 58 (as 17 + 19 + 22 across three bottlenecks).

The cascade is what separates the tools. On `roster-...-plant9-cascade40` certiis names the
9 shifts that are actually short; CP-SAT's core has 49 tasks — the 9 plus the entire
40-link chain, which is matched perfectly and is not part of any minimal violator. The
chain is reachable by alternating paths, so it is in the raw deficient set too; the
difference is that certiis removes it and CP-SAT does not.

### Where the incumbent wins, and why it is not a win

On the five multi-shortage instances with three planted bottlenecks of sizes 4, 6 and 9 and
no cascade, CP-SAT returns a **4-task** core against our 19 tasks. On raw size the incumbent
wins by almost 5x there, and that is worth stating plainly. (On the five cascade variants of
the same instances its core is 43 tasks against our 19, so the size win is specific to the
no-cascade case.)

It is not a usable win. An explanation names a set of tasks; the test that matters is
whether removing exactly those tasks restores feasibility. `certiis_core_audit.py` applies
that residual test to both explanations on all 40 instances where CP-SAT produced a core:

- Removing the tasks named by the CP-SAT core left the instance **still infeasible on 10 of
  them** — every multi-shortage instance. The core names one of the three shortages, so a
  planner who fixes it comes back to a roster that is still infeasible, twice.
- Removing the tasks named by the certiis certificates restored feasibility on **all 40**.

That is the shape of the difference: a solver's unsatisfiable core is a proof that *some*
conflict exists, and one core is enough for that purpose. A planner needs every independent
shortage, separated, with the resources responsible for each. HiGHS behaves the same way —
its IIS is one subsystem — and additionally reports resource rows and column bounds, so its
raw output is larger still (median 88 entries against our 13 tasks).

### Scale

On an 8000-shift, 1107-nurse instance with 2.58 million eligible pairs (a 144 MB JSON file),
wall time is 0.50 s, of which `solve` is 191 ms and the matching itself only 20 ms; peak
resident memory is 542 MB, nearly all of it the parsed instance. The cost is dominated by
parsing and index construction, not by matching. Replacing ordered maps and per-task
ordered sets with hash maps and sort/dedup during this work cut `solve` by a factor of
about three on this instance.

The unit expansion is the other scaling term. On an 8000-shift, 300-nurse instance where
each nurse has capacity 28, the 892 thousand eligible pairs become roughly 25 million unit
incidences; peak memory is 253 MB against 0.21 s wall, so the expansion, not the
eligibility list, sets the memory. Past 40 million incidences the tool refuses with a clear
message rather than exhausting memory — the right failure mode, and a ceiling that a
capacity-aware `hall_core` would remove outright. (Verified: 60 tasks of demand 1000
against 60 resources of capacity 1000, fully eligible, is refused rather than attempted.)

These figures were taken on an otherwise idle machine. Measurements made while the
benchmark and other builds were running were three to seven times worse, which is worth
remembering before quoting any of them as a product number.

## What would make this a real product

### What is missing

- **Repair suggestions.** The certificate says which shifts are short and which nurses
  could cover them. It does not say what to change. The natural next step is cheap and is
  the thing a buyer actually wants: for each certificate, rank the eligibility edges that
  would most reduce the deficit if added (cross-train this nurse for that qualification),
  and the capacity increases that would do the same (one more shift from this nurse). Both
  are one pass over the certificate's neighbourhood; neither is implemented.
- **Explanations for feasible-but-tight instances.** A roster that is feasible today with
  zero slack is a roster that breaks on the first sick day. The same machinery gives the
  tight sets — task sets where demand equals capacity exactly — and nothing surfaces them.
- **Soft constraints and objectives.** Real rosters have preferences, costs, and fairness
  targets. This tool answers a pure feasibility question. An instance that is feasible but
  unacceptably expensive gets `FEASIBLE` and no further help.
- **Incremental re-solve.** The interactive question is "what if we cross-train one
  nurse?", and today that is a full rebuild and re-solve of the whole instance.
- **A real input format.** JSON with string identifiers on both sides of every eligibility
  pair costs 144 MB and most of the wall time on an 8000-shift instance. A columnar or
  binary format, and integer identifiers, are table stakes at production scale.

### What is fragile

- **Instance compilation dominates the runtime.** On the 8000-shift, 1107-nurse,
  2.58-million-pair instance the matching is 20 ms, the whole `solve` is 191 ms, and end to
  end it is 0.50 s; peak resident memory is 542 MB, nearly all of it the parsed instance.
  Replacing ordered maps and per-task ordered sets with hash maps and sort/dedup cut `solve`
  by about three times during this work, which says the remaining cost sits in the same
  place and is addressable rather than fundamental.
- **The unit expansion is a memory multiplier.** Capacities are handled by expanding to
  unit copies, so the incidence list is roughly the eligibility list times the average
  resource capacity. At capacity 5 that is a 5x multiplier; a nurse roster with monthly
  capacity 20 makes it 20x. There is a hard cap at 40 million incidences after which the
  tool refuses rather than exhausting memory, which is the right failure mode but is still
  a ceiling that a capacity-aware matching would remove entirely.
- **Certificate order is heuristic.** Deletion runs in three orders (index, reverse,
  descending eligibility count) and keeps the smallest result. Every order yields an
  irreducible set, so this only affects size, but it means certificate size is not a
  deterministic function of the instance alone in the way the verdict is.
- **The classifier is syntactic.** It reads declared couplings and the `distinct` flag. An
  instance that encodes a pairwise conflict by some other means — say by pre-filtering
  eligibility in a way that only makes sense jointly — will be classified as a matching and
  certified. The decline is only as good as the faithfulness of the input encoding.

### Problem shapes it will never cover

These are not gaps to be closed later; they are outside the method.

- **Anything with a genuine objective.** Hall's condition is about existence. Cost, overtime
  minimisation, and fairness are not expressible as a deficiency.
- **Pairwise or higher coupling between tasks.** Conflicts, precedence, "these two shifts
  must go to the same nurse", and inner-product constraints all leave the matching world.
  This is exactly the failure mode C1018 recorded when the orbit-matrix search carried row
  sums, column sums and pairwise row inner products together, and it is why that search
  uses its own row enumeration rather than `hall_core`.
- **Resource-side lower bounds and distinct-resource requirements.** Feasibility is still a
  flow question but the certificate is a cut naming both sides, not a task set. The tool
  declines; a different product would be needed.
- **Time-indexed scheduling with sequencing.** Once the question is "in what order", not
  "who does what", bipartite matching is the wrong model outright.

## Requests against `hall_core` (not implemented, read-only constraint)

Nothing under `papers/complete-repair-ports/ergodis/`, `ergodis-private/src/lib.rs`,
`ergodis-private/Cargo.toml` or `ergodis-private/src/hall_core.rs` was touched. These are
the changes this prototype wanted and worked around instead.

1. **A capacity-aware solve.** The single most valuable change. Something like
   `solve_capacitated(left_count, right_count, offsets, neighbors, demands, capacities)`
   that scales capacities inside the augmenting search — `pair_right` becoming a count plus
   a list of partners — instead of forcing the caller to expand to unit copies. It removes
   the `sum(d) x sum(c)` incidence blow-up, the 40-million-edge ceiling, and the projection
   argument that currently has to be justified by hand.
2. **Deficiency reported per unmatched root, or the alternating forest exposed.** The single
   alternating-reachable set merges every independent bottleneck into one blob; this
   prototype recovers the separate bottlenecks by decomposing it into connected components
   afterwards. `hall_core` already computes the reachability that would give them directly,
   and one root per bottleneck is the natural output.
3. **A first-violation fast path.** For screening large instance families, an option to
   stop at the first unmatched root without extracting the full reachable set. Today the
   caller pays for the full extraction even when only the yes/no answer is wanted.
4. **A fallible constructor.** `HallWorkspace::new` asserts on capacity overflow. A service
   taking untrusted input wants `Result`, so an oversized request is rejected rather than
   aborting the process. `solve` already validates the CSR shape properly and returns
   `HallError`; the constructor is the one place that does not.
5. **A documented contract for `matching()` after a deficient solve.** The maximum matching
   is still in the workspace and is useful — it is the partial assignment to keep while the
   shortage is fixed — but the doc comment only describes it for the saturated case, so
   this prototype does not rely on it there.
6. **Warm-start / incremental re-solve.** Re-solving after adding or removing a handful of
   edges currently redoes the whole matching. The interactive product question is exactly
   that edit, repeated.
7. **Deficit magnitude in the outcome.** `HallOutcome::Deficient` gives the two set sizes;
   the caller usually wants the deficiency `|S| - |N(S)|` and the count of unmatched left
   vertices to rank bottlenecks by severity without recomputing.

None of these is a correctness complaint. `hall_core` did exactly what it says: it
allocated once, validated the CSR shape rather than panicking, and returned a deficient set
with its neighbourhood that was in every one of thousands of tested cases a genuine Hall
witness. Every item above is about the shape of the API for a capacitated, multi-bottleneck,
interactive use rather than for a tight inner search loop, which is what it was built for.

## Files and replay

All work is confined to these paths; nothing else in the repository was edited.

| Path | Role |
|---|---|
| `ergodis-private/src/bin/certiis.rs` | the tool: classifier, extractor, verifier, generators, selftest |
| `ergodis-private/python/certiis_benchmark.py` | head-to-head harness against CP-SAT, HiGHS, Hopcroft-Karp |
| `ergodis-private/python/certiis_summarise.py` | reduces a benchmark JSON to the tables above |
| `ergodis-private/python/certiis_core_audit.py` | residual test: does an explanation actually restore feasibility |
| `notes/2026-08-31-infeasibility-certificate-prototype.md` | this report |

`certiis.rs` needs no `Cargo.toml` entry: edition-2021 autobins picks it up from `src/bin`.
Bulk output goes to `~/.cache/ergodis/certiis/` and is not committed.

```bash
cd ~/src/othello/ergodis-private
cargo test  --release --bin certiis
cargo build --release --bin certiis
./target/release/certiis selftest

# one instance, end to end
C=~/.cache/ergodis/certiis
./target/release/certiis generate --domain multi-roster --seed 1 \
    --tasks 150 --resources 45 --plant 4 --cascade 40 --out $C/demo.json
./target/release/certiis classify --input $C/demo.json
./target/release/certiis solve  --input $C/demo.json --out $C/demo.cert.json
./target/release/certiis verify --input $C/demo.json --certificate $C/demo.cert.json
```

## Foreign-lane issues

1. **`ergodis-private/src/g53_search.rs` briefly broke the library build.** Two
   `E0502` borrow errors around line 1340 (`workspace.class_orbits[class]` held immutably
   across a mutable use). Because every `ergodis-private` binary links the library, this
   blocked all of them, not only that lane's. It was left untouched and had cleared within
   about a minute, so another session was evidently mid-edit. Worth raising only because the
   blast radius is crate-wide.
2. **A crate-wide `cargo fmt` reformatted `certiis.rs` mid-session.** The change was pure
   rustfmt line-wrapping with no semantic difference (`git diff -w` shows only re-wrapping),
   and it was revalidated and kept. Still, a formatter run against the whole crate reaches
   into other lanes' in-progress files.

Both are noted, not acted on.
