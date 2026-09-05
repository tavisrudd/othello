# C1062 probe 3 successor: the certificate on the domain-width axis, and the amortization arm

**Lane**: `complete-ports`
**Task**: C1062, probe 3 successor (closeout § 13 item 2, first half)
**Status**: **predeclaration only.** Nothing here has been built, run or measured. Every number below
is a prediction derived from the structure, entered before any code exists, so that the measurement
can fail. This file is committed before Phase 2 begins.
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
