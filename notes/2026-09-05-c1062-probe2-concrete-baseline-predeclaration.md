# C1062 probe 2: predeclaration for the strengthened concrete-search baseline

**Lane**: `complete-ports`
**Task**: C1062, probe 2 (baseline repair)
**Report this amends**: `2026-09-04-c1062-probe2-best-intervention-and-economics.md`
**Review that raised it**: `2026-09-05-c1062-probe2-review.md`, findings 2.1 and 2.2
**Status**: predeclaration only. **No code has been written and no measurement taken.** This note is
committed before the change is implemented, because every review in this task found predeclaration
unverifiable when the code and the numbers landed in one commit. The measured result goes in the
probe 2 report and in `ergodis-private` `evidence/2026-09-05-best-intervention-repaired.txt`.

## 1. What is being changed and why

`ConcreteSearch` is probe 2's baseline arm: the same shortest-path query run on the concrete
`(u, I)` states with no compile and no quotient. Its documented purpose is that "the ratio of the two
timings is the compression the query actually cashes in".

It does not currently measure that. At every settled state it scans **every generator in the
presentation** and asks the transition table whether that generator applies:

```rust
for (generator, cost) in self.costs.iter().copied().enumerate() {
    let Some(target) = presentation.transition(generator as u32, state) else { continue };
```

On the timing family `deep-pipeline` the alphabet is 256 generators and only the generators of a
state's own sort can apply, so about seven of the 256 succeed. The compiled arm, by contrast, walks a
200-edge per-class adjacency list. The measured ratio between the two arms is therefore partly a
difference of *representation* — dense `(generator, state)` matrix scanned in full, against a compact
adjacency — and not only the difference in graph size that the arm exists to isolate.

The change: `ConcreteSearch::new` precomputes, once, the list of generator ids belonging to each sort
(from `presentation().generators()[g].source_sort`) and a state-to-sort map (from
`presentation().sorts()`); `best_from_context` then iterates only its state's sort's list. Nothing
about the search changes — same graph, same costs, same Dijkstra, same std `BinaryHeap`, same answers.
Only which candidate edges are enumerated changes.

This is deliberately a change to *what the baseline is*, not to how it is measured. The plan requires
the baseline to be the strong form, and an arm that scans 256 generators where seven apply is not it.

## 2. The arithmetic this rests on, entered before the run

The timing family has 37 sorts: one empty sort, eight arity-one sorts, twenty-eight arity-two sorts.
Generator counts follow the lowering's boundary rule — a sort below the arity bound carries `n·d = 16`
generators, a sort at the bound carries `k·d = 4`:

```
16·1 + 16·8 + 4·28 = 256 generators
```

The reachable component from `(u, {})` is one fibre, `1 + 16 + 112 = 129` states, because hard
interventions are idempotent and commute on distinct variables. So per query that exhausts the fibre:

| quantity | now | after |
|---|---|---|
| transition lookups | `129 × 256 = 33,024` | `16·1 + 16·16 + 4·112 = 720` |
| reduction | — | **`45.9x`** |

## 3. Predictions

**P1 — the falsifiable invariant.** `relaxations` per query must stay at **`356.7`**, unchanged to one
decimal, and the arms' answer vectors must stay identical. Every generator in a state's own sort list
applies to that state, so the successful-transition count cannot move; only the failed lookups
disappear. The current measurement is `356.7`, and `720 × 0.4954` — the fraction of sampled contexts
that are unreachable and therefore exhaust the fibre, `2,029` of `4,096` — is `356.7`. If
`relaxations` moves at all, the patch changed the search rather than its representation, and that is
a bug rather than a result.

**P2 — the headline ratio.** Like-for-like, `state search` against `compiled` at 65,536 queries, both
unmemoized, both including their build. Current value **`103x`** (`1,829.704 ms` against `17.803 ms`).

- **Point prediction: `7x`.**
- **Predeclared band: `4x` to `15x`.** Landing inside it means the per-state scan over the whole
  alphabet accounted for most of the `103x` and the mechanism named in the review is the right one.
- **Would surprise me: below `3x` or above `25x`.** Above `25x` would mean I have misattributed the
  cost a second time and something other than the generator scan dominates — the std `BinaryHeap`
  without decrease-key, or the touched-list bookkeeping, are the candidates. Below `3x` would mean the
  fibre-versus-class-count difference buys essentially nothing per query.

The reasoning, stated so it can be checked against the outcome. The arm's current marginal cost is
`27.81 µs` per query (`(1,829.704 − 13.982) / 65,280`), which is `55.6 µs` per exhausting query. At
`33,024` lookups that is `1.68 ns` per lookup, which leaves under two microseconds for the heap and
the bookkeeping — so the lookups are almost the whole cost, and the reduction in lookups should carry
almost the whole way through. `720` lookups at a somewhat worse per-lookup cost (fewer of them, less
prefetch benefit) plus the same `~1.6 µs` of heap and bookkeeping gives roughly `3 µs` per exhausting
query, `1.5 µs` averaged, so about `112 ms` at 65,536 queries against the compiled arm's `17.8 ms`.
The band's upper end is the alternative model in which the heap is a larger share than the residual
suggests.

I am entering this with the previous prediction in this same arm on the record: I predicted that
bounding the per-query workspace clear would collapse the ratio, and it did not — the clear was worth
about a sixth of the per-query cost, and the arithmetic that convinced me used a DRAM bandwidth figure
for a 297 KB block that streams from cache. The estimate above is built from a work count I have since
measured rather than from a bandwidth assumption, which is why P1 exists as a check on it.

**P3 — what counts as the compiled form still winning.** A like-for-like ratio of **`5x` or more**
after the change. At or above that, the quotient's smaller search graph is a real per-query effect and
"quotienting the search graph is worth something" survives as a timing claim, restated at the new
number. Below `5x`, it does not, and the probe 2 report should retire the timing form of that claim
entirely and keep only the structural counts — `22x` to `84x` on states-to-classes and `1.07x` to
`1.46x` on the plan's edge collapse — which are counts off the compiled artifact rather than timings.

**P4 — nothing else moves.** The compression table, the states/classes/edges table, the correctness
table, the vocabulary quotient, the certificate-policy table, the minimax-regret table, and the
`enumerate`, `memoized`, `compiled` and `compiled+memo` timing columns are all untouched by this
change. If any of them moves, that is a defect in the patch.

## 4. What each outcome does to the task verdict

Stated now so the reading is not chosen after the number is known. The closeout's economics sections
rest on the claim that the compiled query's per-query advantage over concrete search is representation
rather than compression.

- **Ratio in the `5x`–`15x` band.** The claim needs softening rather than withdrawing: most of the
  published `220x` was representation, and a real single-digit-to-low-double-digit advantage remains
  that is attributable to the smaller graph.
- **Ratio below `5x`.** The claim is confirmed in its strong form. The compiled query buys almost
  nothing per query on this family once both arms have the same representation, which *strengthens*
  the task's economics conclusion — materializing the flat carrier is what loses, and the search-graph
  compression was never cashing in at query time either. That is the direction the rest of the
  evidence already points, and it should be reported plainly rather than hedged.
- **Ratio above `25x`.** My attribution is wrong again and the next step is a work-counted profile of
  the arm rather than another patch.

## 5. Replay

`cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
best-intervention-report --rounds 5 --workloads 256,1024,4096,16384,65536`, retained at
`evidence/2026-09-05-best-intervention-repaired.txt`. Timing figures are host- and load-sensitive;
the ratio between arms measured in the same process is the quantity predicted here, not the absolute
milliseconds.
