# C1062 probe 3 successor: the certificate on the domain-width axis, and the amortization arm

**Lane**: `complete-ports`
**Task**: C1062, probe 3 successor (closeout § 13 item 2, first half)
**Status**: **measured.** §§ 1–7 are the predeclaration, committed at `othello` `d53c8817a` before
any code existed. §§ 8–11 are the result, added afterwards; nothing above § 8 has been edited.
**Verdict**: **the domain-width prediction failed, and its own control caught it.** The `d = 2` row
was predeclared to show no compaction at all and prunes 6 of 13. The candidate counts and carrier
sizes were right on all eleven rows; the class counts were not, and the reason is that at the queried
context no pin set inside the arity bound can flip the outcome, so the whole fibre is one class per
sort and the settings collapse for a reason that has nothing to do with the domain. The 10% threshold
is nominally met from `d = 5` onward — earlier than predicted, which is the wrong direction for a
declared loss — and **should not be reported as met**, because the fixture is degenerate. The
amortization arm is a clean loss: the compile does not pay on any row, and the oracle route is
*slower* than the plain route everywhere, including the case most favourable to it.
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-wide-domain-amortization.txt`.
**Inputs**: `2026-09-04-c1062-probe3-actual-cause-and-responsibility.md` (as corrected),
`2026-09-05-c1062-probe3-review.md` § 2.3 for the structural argument this tests, and
`2026-09-05-c1062-closeout-synthesis.md` § 12 for the two open items.
**Owning code**: `ergodis-private` `src/causal_fixtures.rs`, `src/actual_cause.rs`,
`tasks/tools/src/actual_cause_report.rs`. Nothing in `~/src/ergodis`.

## 1. What is being tested, and why it can fail

Probe 3's exhaustion certificate missed its predeclared threshold — a verifier fraction under 10% —
and the original report predicted the fraction would "improve sharply with model size". The review
refuted that on the model-size axis and gave a structural reason: a compiled class never spans
sorts, a contingency candidate's pinned support **is** its sort, so class pruning can never merge two
candidates with different witness sets. It can only merge the settings of one fixed support, and the
number of those is `∏_{v ∈ X} d_v − 1`. For singleton causes over binary variables that is one — no
compaction is available at all — while the candidate count is dominated by the witness-set choice
`C(|pool| − |X|, |W|)`, which pruning cannot touch.

The prediction that follows is that **domain width, not model width, is the axis on which the
certificate can compact**, with a verifier fraction of order `1 / (d − 1)` for singleton causes. This
successor turns that from an argument into a measurement, and it is falsifiable in three separate
ways: the fraction could fail to fall with `d`, it could fail to stay flat in `n`, or the predicted
per-row numbers could simply be wrong.

## 2. The fixture

**`wide_domain_quorum(inputs, domain)`**, a new fixture in `src/causal_fixtures.rs`.

- `inputs` endogenous variables `V_0 … V_{inputs−1}`, each of domain `domain = d`.
- One dedicated exogenous variable per input, each of domain **2**, with `V_i = u_i` mapped into
  `{0, 1} ⊂ {0 … d−1}`. The exogenous alphabet is deliberately narrow: `|U| = 2^inputs`. Domain
  width is the dial being turned and the exogenous alphabet must not be turned with it, or the
  carrier grows for the wrong reason.
- One binary outcome `V_inputs`, with `V_inputs = 1` iff **at least one** input equals zero. This is
  a quorum of `k = 1` over the predicate `V_i = 0`.
- `observed = [V_inputs]`; `intervenable = [V_0 … V_{inputs−1}]`, excluding the outcome; arity equal
  to the query's size bound.

**The query.** Context `0` (every `u_i = 0`, so every `V_i = 0` and the outcome is 1). Literal
`V_0 = 0`. Outcome `V_inputs = 1`. Pool `V_0 … V_{inputs−1}`. Size bound `mx`.

**Why this shape.** Three properties are needed and this fixture is the smallest thing with all
three.

1. **The query is a genuine negative inside the bound, so the search exhausts.** The witness is held
   at its actual value, which is zero and therefore still satisfies the quorum, so only cause
   coordinates can break it; the outcome flips only when *every* input is set nonzero, which needs a
   cause of size `inputs`. For any `mx < inputs` the engine finds no cause and the certificate must
   cover every candidate. The certificate then certifies "no cause of size at most `mx`", which is
   exactly what an exhaustion certificate is for. The true minimal cause has size `inputs`, so this
   is a bounded-search negative and not a claim that `V_0 = 0` is causally irrelevant.
2. **All `d − 1` non-actual settings of a coordinate are equivalent.** The outcome reads each input
   only through the predicate `V_i = 0`, and the actual value *is* zero, so every other value in the
   domain behaves identically. This is what makes the compaction factor `d − 1` rather than 2; a
   threshold predicate `V_i ≥ θ` would split the non-actual settings into two and halve the effect.
3. **The class of a state is exactly its zero/nonzero pattern on the pinned set.** Derivation: with
   pinned set `D` and pin vector `p`, the number of coordinates still matching is
   `(inputs − |D|) + #{i ∈ D : p_i = 0}`, so the observation is `[nz(p) ≤ inputs − k]` where `nz`
   counts nonzero pins. Under an overwrite on a set `S`, the observation becomes
   `[#{i ∈ D\S : p_i ≠ 0} + #{i ∈ S : J_i ≠ 0} ≤ inputs − k]`. Two pin vectors agree for every `J` iff
   `#{i ∈ D\S : p_i ≠ 0}` agrees, and taking `S = D \ {i}` for each `i` forces agreement coordinate by
   coordinate. So the class is the zero/nonzero pattern, and the number of distinct classes among the
   `d^c − 1` settings of a size-`c` cause is `2^c − 1`, **independent of `d`**.

## 3. The exact predicted numbers

Write `c` for the cause size, `w` for the witness size, `n` for `inputs`. For each `(size, c)` split
the candidate count is `C(n−1, c−1) · C(n−c, size−c) · (d^c − 1)` and the searched count — one per
distinct class — is the same with `(2^c − 1)` in place of `(d^c − 1)`. Because the query is a pure
negative, **every searched candidate is recorded**, so `entries = searched` and

```
verifier fraction (entries)  =  searched / (searched + pruned)
```

with the denominator equal to the total candidate count. Per the decision recorded in the closeout,
entries is the numerator and distinct classes is reported beside it.

### 3a. The domain sweep, `n = 4`, `mx = 2`

Closed forms: `total = 3d² + 4d − 7`, `entries = 13`, `distinct = 10`.

| `d` | carrier states | candidates | pruned | entries | distinct | fraction (entries) | fraction (distinct) | verdict at 10% |
|-----|----------------|------------|--------|---------|----------|--------------------|---------------------|----------------|
| 2   | 528            | 13         | 0      | 13      | 10       | **100.00%**        | 76.92%              | miss (control) |
| 3   | 1,072          | 32         | 19     | 13      | 10       | 40.63%             | 31.25%              | miss           |
| 5   | 2,736          | 88         | 75     | 13      | 10       | 14.77%             | 11.36%              | **miss (predicted loss)** |
| 8   | 6,672          | 217        | 204    | 13      | 10       | **5.99%**          | 4.61%               | **pass**       |
| 10  | 10,256         | 333        | 320    | 13      | 10       | **3.90%**          | 3.00%               | pass           |
| 20  | 39,696         | 1,273      | 1,260  | 13      | 10       | **1.02%**          | 0.79%               | pass           |

### 3b. The domain sweep, `n = 4`, `mx = 3`

Closed forms: `total = 3d³ + 9d² + 7d − 19`, `entries = 55`, `distinct = 31`.

| `d` | carrier states | candidates | entries | distinct | fraction (entries) | verdict at 10% |
|-----|----------------|------------|---------|----------|--------------------|----------------|
| 3   | 2,800          | 164        | 55      | 31       | 33.54%             | miss           |
| 5   | 10,736         | 616        | 55      | 31       | **8.93%**          | **pass**       |
| 10  | 74,256         | 3,951      | 55      | 31       | 1.39%              | pass           |

### 3c. The model-width control, `d = 5`, `mx = 2`

Closed forms: `total = 4n + 24(n−1)`, `entries = 4n − 3`, `distinct = 3n − 2`.

| `n` | carrier states | candidates | entries | distinct | fraction (entries) |
|-----|----------------|------------|---------|----------|--------------------|
| 4   | 2,736          | 88         | 13      | 10       | 14.77%             |
| 5   | 8,832          | 116        | 17      | 13       | 14.66%             |
| 6   | 25,984         | 144        | 21      | 16       | 14.58%             |

The search space grows by 64% from `n = 4` to `n = 6` and the fraction moves by 0.19 points. Against
that, holding `n = 4` and moving `d` from 5 to 8 takes it from 14.77% to 5.99%.

## 4. Thresholds, entered before the run

1. **The compactness threshold is unchanged: a verifier fraction below 10%, entries as numerator.**
   It is **met** if any row reaches it. Predicted: met at `d ≥ 8` for `mx = 2` and at `d ≥ 5` for
   `mx = 3`.
2. **The predicted loss, named:** `n = 4`, `d = 5`, `mx = 2` is predicted to **miss** at 14.77%. A
   predicted loss that loses is a pass for the measurement, not for the certificate.
3. **The `d = 2` control must show no compaction at all** — exactly 100.00%, `pruned = 0`. If it
   shows any compaction the class model in § 2 is wrong and every other row is suspect.
4. **The model-width control must stay inside a 1-point band** across `n ∈ {4, 5, 6}`. If the
   fraction falls with `n`, the review's structural argument is wrong and the original report's
   prediction was right after all.
5. **Every cell in § 3 is a hard prediction.** These are deterministic combinatorial counts, not
   samples, so a deviation of one is a failure to diagnose, not noise. In particular `entries` and
   `distinct` must be **invariant in `d`** at fixed `(n, mx)`.
6. **The verdict must remain `0/1`** on every row, and `unclassified` must be zero, or the
   certificate does not cover the search.

## 5. The amortization arm

The timing arm already exists in `tasks/tools/src/actual_cause_report.rs` — it was written when
probe 3 ran and never executed, because a concurrent lane's uncompilable file blocked the binary.
That obstruction is gone, so this arm needs no new code beyond adding the wide-domain rows to the
query list.

**What "amortizes" means numerically here.** The compiled route pays a one-off `lower` plus `compile`
and then answers each responsibility query with the class oracle; the direct route pays nothing up
front and answers each query without it. The binary measures `compile_us` once and the mean
microseconds of a query with the oracle (`pruned`) and without (`plain`), then reports

```
break-even queries  =  compile_us / (plain_us − pruned_us),   or "never" when pruned >= plain
```

**What the break-even would have to be for the compile to pay.** A model of `n` inputs has exactly
`n` distinct responsibility queries — one per pool literal — so **the compile pays on this model only
if the break-even is below `n`**. That is the number to compare against, and it is 4, 5 or 6 here,
not some large abstract workload.

**Prediction.** The compile does **not** pay, and the reason is visible in the code rather than in
the arithmetic: the class is computed for *every* candidate before the prune check, so the oracle
route pays one `class_of` per candidate where the plain route pays one `solve_into` per candidate.
`class_of` allocates two vectors, sorts one, and linear-scans the support table; `solve_into` is a
handful of table lookups into a caller-owned buffer with no allocation. Pruning therefore does not
remove work per candidate, it substitutes a heavier operation for a lighter one and saves only the
downstream record construction. Specifically:

- **Predicted: `plain_us − pruned_us` is small in magnitude and of uncertain sign**, and the
  measurement is called either way. If `pruned ≥ plain`, the binary prints `never` and the arm is a
  clean loss.
- **Predicted: on every row, break-even exceeds the number of distinct queries the model has**, so
  the compile never amortizes on that model. Named predicted loss: `n = 4`, `d = 20`, `mx = 2` —
  break-even predicted well above 4.
- **Predicted: the break-even does not improve with `d`**, because the substitution is per candidate
  and both routes scale with the candidate count. If break-even falls sharply with `d`, this
  prediction is wrong and the reason will be that pruning skips the three per-record allocations,
  which is the one asymmetry that favours the oracle.

This is a predeclared loss in the same sense probe 8's economics arm was, with one difference worth
stating in advance: unlike probe 8's ratio, this one is a real timing measurement and *could* come
out favourable, so it is falsifiable.

## 6. What will be built, and the replay commands

- `src/causal_fixtures.rs`: `wide_domain_quorum(inputs, domain)` and a `wide_domain_rows()` list
  carrying the predeclared verdict for each row.
- `src/actual_cause.rs`: a measurement test over the sweep, asserting the § 3 numbers cell by cell,
  so a later change that moves them fails rather than reprints.
- `tasks/tools/src/actual_cause_report.rs`: the sweep rows added to the certificate table and to the
  amortization table, plus a `--repeats` value large enough for stable timing.

Replay:

```
cd ~/src/ergodis-private
cargo run --release --package ergodis-tools -- actual-cause-report
cargo test --release --package ergodis-private --lib actual_cause:: -- --nocapture --test-threads=1
```

Evidence to be retained as `evidence/2026-09-05-causal-wide-domain-amortization.txt`, matching the
naming of the files added with the review repairs.

## 7. What this cannot settle

Stated now so it is not discovered later as a result.

- **It does not show that the certificate compacts on a model anyone would write.** The fixture is
  built so that all `d − 1` non-actual settings are observationally identical. That is the condition
  under which compaction is available, and naming it is the deliverable; whether applied models meet
  it is a separate question this cannot answer.
- **It does not touch the witness-set axis**, which is the one that grows combinatorially and which
  the sort structure forbids pruning. A positive result here is a statement about one axis of a
  two-axis search.
- **It does not revisit probe 3's eight published verdicts**, which are unaffected.

---

# Measured

Everything above this line predates the code. Nothing above it has been changed.

**Convention, stated once**: the verifier fraction's numerator is **certificate entries**, per the
decision recorded in the closeout, with **distinct `(size, class)` pairs** reported beside it. Every
percentage in this section is entries over candidates.

## 8. The domain sweep: measured against predicted, cell by cell

Replay: `cd ~/src/ergodis-private && cargo test --release --package ergodis-private --lib
actual_cause:: -- --nocapture --test-threads=1`.

| row | `d` | `mx` | states | pred. states | candidates | pred. candidates | entries | pred. entries | distinct | pred. distinct | fraction | predicted fraction |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| width `d=2` (control) | 2 | 2 | 528 | 528 | 13 | 13 | **7** | 13 | **4** | 10 | **53.85%** | 100.00% |
| width `d=3` | 3 | 2 | 1,072 | 1,072 | 32 | 32 | **7** | 13 | **4** | 10 | **21.88%** | 40.63% |
| width `d=5` (loss row) | 5 | 2 | 2,736 | 2,736 | 88 | 88 | **7** | 13 | **4** | 10 | **7.95%** | 14.77% |
| width `d=8` | 8 | 2 | 6,672 | 6,672 | 217 | 217 | **7** | 13 | **4** | 10 | **3.23%** | 5.99% |
| width `d=10` | 10 | 2 | 10,256 | 10,256 | 333 | 333 | **7** | 13 | **4** | 10 | **2.10%** | 3.90% |
| width `d=20` | 20 | 2 | 39,696 | 39,696 | 1,273 | 1,273 | **7** | 13 | **4** | 10 | **0.55%** | 1.02% |
| depth 3, `d=3` | 3 | 3 | 2,800 | 2,800 | 164 | 164 | **19** | 55 | **7** | 31 | **11.59%** | 33.54% |
| depth 3, `d=5` | 5 | 3 | 10,736 | 10,736 | 616 | 616 | **19** | 55 | **7** | 31 | **3.08%** | 8.93% |
| depth 3, `d=10` | 10 | 3 | 74,256 | 74,256 | 3,951 | 3,951 | **19** | 55 | **7** | 31 | **0.48%** | 1.39% |
| model `n=5, d=5` | 5 | 2 | 8,832 | 8,832 | 116 | 116 | **9** | 17 | **5** | 13 | **7.76%** | 14.66% |
| model `n=6, d=5` | 5 | 2 | 25,984 | 25,984 | 144 | 144 | **11** | 21 | **6** | 16 | **7.64%** | 14.58% |

**What was right.** Every carrier size and every candidate count, on all eleven rows. The search
structure — which causes, which witnesses, how many settings — is exactly as modelled, and the query
is a genuine negative on every row with `unclassified = 0` throughout, so the certificate covers
every candidate it should.

**What was wrong.** Every class count. Entries came in at 7 where 13 was predicted, 19 where 55 was
predicted, 9 and 11 where 17 and 21 were. The one invariant the prediction rested on does hold:
entries and distinct classes do not move with the domain at fixed `(n, mx)`. But the constants are
smaller than predicted, and the reason invalidates the fixture.

## 9. The diagnosis: the fixture is degenerate, and the `d = 2` control is what caught it

Threshold 3 said the `d = 2` row must show exactly 100% with zero pruning, and that if it showed any
compaction the class model was wrong and everything else was suspect. It shows 53.85% and prunes 6 of
13. Taking that at its word:

**The class model in § 2 property 3 is wrong.** It derived that the class of a pinned state is its
zero/nonzero pattern, using overwrites on `S = D \ {i}` to read off each coordinate separately. The
derivation is valid in general and fails on this fixture for a reason the derivation did not check:
it assumed the observation *varies* over the reachable set. It does not. At the queried context every
input is zero, so at least one input is zero however few coordinates are pinned; breaking the quorum
requires setting **every** input nonzero, which needs `inputs` simultaneous pins. With the arity bound
below that — which § 2 property 1 deliberately arranged, because it is what makes the query a genuine
negative — **no pin set reachable in that fibre changes the observation at all.** The whole fibre is
one class per sort, so every setting of every cause collapses, and the collapse has nothing to do
with `d`.

This is pinned as a test rather than left as prose:
`the_wide_domain_fibre_is_observationally_constant_within_the_arity_bound` checks all 400 value pairs
of a size-two cause at `d = 20` and finds one class, and separately checks that the compiled quotient
over the *whole* carrier is not trivial — classes per sort run 5, 9 and 12 — so the collapse is a
property of this fibre and this bound, invisible without asking the question at one context.

**The tension the fixture design missed**, stated so a successor does not walk into it. Two things
were required at once: no candidate may flip the outcome (or the query is not a negative and there is
nothing to certify), and the observation must vary within the arity bound (or the classes are
trivial). In this shape those are the same condition. A candidate pins its cause coordinates freely
and its witness coordinates at their actual values; a free overwrite pins any coordinates freely; and
because the witness's actual value is the quorum-satisfying one, both are capped at the same reach —
`arity` coordinates set nonzero. So "flippable within the bound" and "some candidate flips" coincide,
and there is no gap to sit in.

**What a corrected fixture needs.** The flip must require a coordinate the *cause* cannot reach while
a free overwrite can. The natural construction is a variable that is intervenable but excluded from
the query pool: free overwrites may pin it, causes may not, so the observation varies within the
bound while no candidate flips. That is a different fixture with different predicted numbers, and it
needs its own predeclaration before it is built. It is not written here, on purpose.

## 10. Against the thresholds

| # | threshold | verdict |
|---|---|---|
| 1 | 10% met at some domain width | **nominally met from `d = 5`, and it does not count.** The compaction is trivial pruning of a degenerate query, not the settings-per-cause mechanism the threshold was about. Reporting this as the certificate compacting would be reporting the fixture, not the method. |
| 2 | `d = 5` predicted to **miss** at 14.77% | **failed.** It passes, at 7.95%. A declared loss that wins is the direction that deserves suspicion, and here the suspicion was justified. |
| 3 | `d = 2` control must show no compaction | **failed, and it is the finding.** 53.85%, 6 of 13 pruned. |
| 4 | model-width control flat within 1 point | **passed.** 7.95%, 7.76%, 7.64% across `n = 4, 5, 6` while the candidate count grows 88 → 116 → 144, a spread of 0.31 points. The absolute values are not the predicted ones, but the review's structural claim — the fraction is flat in model width — is confirmed on a second family, independent of the fixture's degeneracy, because it follows from entries growing as `4n − 3` against candidates growing as `4n + 24(n−1)`. |
| 5 | every cell hard, entries and distinct invariant in `d` | **half.** The invariance holds exactly. The constants are wrong on every row. |
| 6 | verdict `0/1` and `unclassified = 0` everywhere | **passed** on all eleven rows. |

**So: is the 10% threshold met at any reachable domain width? Not by a measurement that means
anything.** The numbers below 10% are real numbers produced by real pruning, and they are not
evidence that the exhaustion certificate compacts, because the query they certify has a constant
observation. The domain-width axis remains **untested**, not refuted — the review's argument that it
is the only axis on which compaction is available still stands, and this attempt failed to build a
fixture that isolates it.

## 11. The amortization arm

Replay: `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
actual-cause-report`. Timing is the mean of 200 repeats per query; `compile us` is one `lower` plus
one `compile` under `SplitTranscript`.

| fixture | pool `n` | compile µs | plain µs | pruned µs | break-even | pays? |
|---|---|---|---|---|---|---|
| forest-fire-conjunctive | 2 | 156.2 | 0.22 | 0.31 | never | no |
| forest-fire-disjunctive | 2 | 93.7 | 0.90 | 1.46 | never | no |
| rock-throwing-suzy | 4 | 548.2 | 0.63 | 1.04 | never | no |
| rock-throwing-billy | 4 | 505.8 | 11.61 | 16.77 | never | no |
| voting-5-4 | 9 | 1,850,202.5 | 0.42 | 0.50 | never | no |
| width `d=2` | 4 | 306.9 | 1.44 | 2.32 | never | no |
| width `d=5` | 4 | 1,907.5 | 5.68 | 7.40 | never | no |
| width `d=10` | 4 | 13,302.5 | 20.24 | 25.30 | never | no |
| width `d=20` | 4 | 103,425.4 | 72.26 | 97.25 | never | no |
| depth 3, `d=10` | 4 | 188,723.1 | 247.68 | 340.51 | never | no |
| model `n=6, d=5` | 6 | 19,012.7 | 12.28 | 14.44 | never | no |

**Which branch fired.** The predeclaration named two and said the sign was uncertain: either
`pruned ≥ plain`, in which case break-even is "never" and the arm is a clean loss, or `pruned < plain`
with a very large break-even. **The first branch fired, on every one of the sixteen rows.** I did not
predict which, and this is not the branch I leaned toward in the prose; what was predicted, and
holds, is that the compile does not pay on any row.

**The mechanism is the one named in advance.** The class is computed for *every* candidate before
the prune check, so the oracle route pays one `class_of` per candidate where the plain route pays one
`solve_into` per candidate. `class_of` allocates two vectors, sorts one and linear-scans the support
table; `solve_into` is a handful of table lookups into a caller-owned buffer. Pruning does not remove
per-candidate work, it substitutes heavier work for lighter and saves only the downstream record
construction. The `d = 20` row is the sharpest illustration: pruning removes 1,260 of 1,273
candidates, so the oracle route performs 13 solves against the plain route's 1,273 — and is still
**35% slower**, 97.25 µs against 72.26 µs.

**Against the declared pay condition.** A model with `n` pool literals has exactly `n` distinct
responsibility queries, so the compile pays only if break-even is below `n` — 2, 4, 6 or 9 here.
Break-even is infinite on every row, so it is not below `n` anywhere. **The named predicted loss
(`n = 4`, `d = 20`, `mx = 2`) lost.** The most extreme number in the table is `voting-5-4`, where a
1.85-second compile supports a 0.42 µs query: even had the sign gone the other way, break-even would
have been in the millions against a model with nine queries.

This is the third independent route to the same structural finding — probe 2's timing arm, probe 8's
economics identity, and now this — and it is the only one of the three that was a real timing
measurement free to come out the other way.

## 12. Closeout

### Extra value now in reach

- **The degenerate-fibre check is worth promoting out of this fixture.** Asking whether the queried
  context's fibre is observationally constant within the arity bound is a two-line test, and it is
  the precondition for *any* certificate measurement meaning anything. Probe 3's original five
  fixtures were never checked for it. `voting-5-4` and `forest-fire-conjunctive` both report `0.00%`
  with an empty certificate, which the corrected report already flags as "not a pass"; the check
  would say why in a way that generalizes.
- **`class_of` is the amortization arm's whole cost, and it is fixable.** It allocates two vectors
  per call and finds the sort by a linear scan comparing `Vec<u32>`s. A precomputed support index and
  a caller-owned buffer would remove both. That would not make the compile pay — the compile cost
  dominates by orders of magnitude — but it would change the per-query comparison from "the oracle is
  35% slower" to something closer to a real test of whether pruning helps, which is what this arm
  should have been measuring. Cheap, and it is the only lever visible on it.
- **The `4n − 3` and `3n − 2` closed forms held exactly.** They are a small general result about this
  search's shape: with a size bound of two, entries grow linearly in the pool while candidates grow
  linearly in the pool *and* quadratically in the domain. That is the compaction ceiling stated as a
  formula rather than as a measurement, and it is what a successor should predict against.

### What Tao would ask that this missed

- **"What is the smallest object that exhibits the phenomenon?"** The fixture was designed for a
  clean closed form and got one, and the closed form was for the wrong quantity. A single hand-worked
  three-context example — write out the signature of two settings and see whether they differ —
  would have caught the constant-observation collapse before any code, in minutes. The `d = 2` control
  did the same job afterwards, at the cost of a build.
- **"You proved compaction is *available* at `d − 1`; did you check it is *attained*?"** The review's
  structural argument gives an upper bound on how much pruning is possible. This attempt confused the
  bound with a construction. Attaining it needs the settings to be pairwise distinguishable *except*
  through the queried coordinate, which is a strictly harder condition than "the outcome reads a
  coarse predicate", and neither the review nor the predeclaration separated the two.
- **"The quotient is rich and the fibre is trivial — which one does the certificate live in?"** The
  fibre, and nothing in probe 3, its review, or this predeclaration says so. Every certificate
  statement in this task is a statement about one exogenous context, while every quotient statement is
  about the whole carrier. That distinction is now explicit and it deserves to be stated wherever the
  certificate is discussed.

### Mystery ledger

- **Can the domain-width axis be isolated at all?** The corrected fixture in § 9 — an intervenable
  variable outside the query pool — is a construction, not a proof that it works. **Open.** Evidence
  gap: a predeclared fixture in which the observation varies within the arity bound while no
  candidate flips, and a measured fraction that falls with `d` for the settings reason rather than
  the constant-fibre reason. One session, and it needs its own predeclaration.
- **Why is the compaction constant exactly `2^{mx}·k` -shaped?** Measured entries are 7 at `mx = 2`
  and 19 at `mx = 3` for `n = 4`, and 9 and 11 for `n = 5, 6` at `mx = 2`. The `mx = 2` family fits
  `2n − 1`, which is not a form I predicted or can currently derive from the collapse argument — the
  collapse says one class per `(cause, witness)` group, which would give `1 + (n−1) + (n−1) = 2n − 1`
  at `mx = 2`. That matches. **Closed by arithmetic**, and worth stating: under a constant fibre the
  entry count is the number of distinct pinned *supports* the search reaches, which is a property of
  the pool and the bound alone.
- **Is probe 3's original `rock-throwing-billy` row degenerate in the same way?** Its fraction is
  58.18% with 16 distinct classes over 55 candidates, so its fibre is clearly *not* constant — the
  classes vary. **Closed in the negative**, and it means the original measurement, though it missed
  its threshold, was measuring the real thing while this one was not.
- **Would a faster `class_of` change the amortization verdict?** **Open, and narrow.** Evidence gap:
  the compile cost exceeds the total query cost by two to four orders of magnitude on every row, so
  the per-query comparison would have to invert *and* the compile would have to fall by three orders
  of magnitude. The first is plausible, the second is not, so the expected answer is no and the
  measurement would be about the per-query claim only.
- **No mystery remains about whether the compile amortizes on the flat carrier.** It does not, on any
  fixture in this task, and this arm was the last one free to say otherwise.

### What this does to the task-level verdict

For the closeout's author to apply; this note does not edit that file.

- **§ 12's "probe 3's certificate compactness — open on the domain-width axis only, predicted of
  order `1/(d−1)`, one fixture, one session"** should become: attempted, the fixture was degenerate,
  the axis remains open, and the next attempt must predeclare a fixture whose queried fibre is
  observationally non-constant within the arity bound. The estimate of one session still looks right;
  the prediction of `1/(d−1)` is untested rather than confirmed.
- **§ 12's "probe 3's amortization arm — still unmeasured, open and cheap"** should become
  **closed in the negative**: measured on sixteen rows, the compile never pays and the oracle route is
  slower than the plain route on every one, including the case built to favour it.
- **§ 5's "no measurement shows that compiling makes an answer cheaper"** gains its third and
  strongest instance. The first two were identities that could not have come out otherwise; this one
  was a timing measurement that could have, and did not.
- **§ 13's recommendation item 2** loses half its content. The compositional counterfactual crossover
  remains; probe 3's pair of measurements is now one measurement closed in the negative and one
  attempt that failed on its own control.
- **Nothing in §§ 1–4 or 6–9 moves.** No published verdict, no quotient, no economics number changes.
