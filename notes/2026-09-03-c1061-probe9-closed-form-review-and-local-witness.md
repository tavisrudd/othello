# C1061 probe 9: hostile review of the closed form, and local witness readout

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 9. Part A hostile-reviews the closed-form replacement of the LRC counted
kernel claimed in `notes/2026-09-03-c1061-probe6-summary-keyed-cache-and-witness-serving.md`;
part B makes single-pod and window witness queries `O(depth)`.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `tasks/tools/src/closed_form_audit.rs` — exhaustive enumeration and differential-corpus emitter,
  as the `closed-form-audit` subcommand.
- `python/lrc_counted_oracle.py` — the independent CP-SAT oracle.
- `src/lrc_delta_binding.rs` — `witness_for_pod_with`, `witness_for_pod`, `witness_for_window_with`.
- `scripts/counter_ab.py`, `tasks/tools/src/summary_cache_bench.rs` — the probe 9 operations added
  to the counter harness.
Committed as `b5ceaef`, staged as an exact patch so only my own hunk of the shared
`tasks/tools/src/main.rs` was included.

- `evidence/2026-09-03-lrc-closed-form-corpus.json`,
  `evidence/2026-09-03-lrc-closed-form-oracle-report.json`,
  `evidence/2026-09-03-lrc-fleet-counter-ab-probe9.json`.

## Part A — hostile review of the closed form

### A0. Scope of the claim, restated before it is defended

Probe 6's phrasing was too strong and is withdrawn here. The closed form decides exactly one field:
`AzureLrcBatchAnswer::repaired_count`. The published kernel also returns `mode_counts` (the
per-domain local / global-zero / global-one assignment), `total_loads` (the realized per-domain
load), and `totals_checked`. **None of those are reproduced**, so the kernel cannot be deleted; what
the closed form supports is skipping it wherever only the repaired count is consumed, which is
everywhere in the fleet binding. Any future consumer that needs a witness at the pod's *interior*
— which mode repaired which shard — must call the kernel.

With that scope, three claims are under review:

1. the `global > global_capacity` rejection inside the kernel's scan cannot fire;
2. the per-domain multiplicity test is equivalent to a single scalar bound;
3. starting the descending scan below the kernel's `maximum` skips only infeasible candidates.

### A1. Line-by-line derivation

Notation from `azure_lrc_12_2_2_counted` (`/home/tavis/src/ergodis/src/applications.rs:664`):
`D = demand_count`, `Lc = capacities[6]`, `Gc = capacities[7] + capacities[8]`,
`c_d = capacities[d]` and `m_d = multiplicities[d]` for `d` in `0..6`, all widened to `u64`.

```
let maximum = (demand_count as u64).min(local_capacity + global_capacity);   // (1)
for served in (0..=maximum).rev() {                                          // (2)
    let local = served.min(local_capacity);                                  // (3)
    let global = served - local;                                             // (4)
    if global > global_capacity { continue; }                                // (5)
    let aggregate_data = local + 2 * global;                                 // (6)
    let lower: [u64; 6] = from_fn(|d| aggregate_data.saturating_sub(c_d));   // (7)
    if lower.iter().zip(multiplicities).any(|(&n, a)| n > a)                 // (8)
        || lower.iter().sum::<u64>() > served { continue; }                  // (9)
    return ... repaired_count: served ...                                    // (10)
}
```

**Claim 1 — line (5) is dead, for every input, not only for fleet-reachable inputs.**
From (3) and (4): if `served <= Lc` then `local = served` and `global = 0`, and `0 > Gc` is false
because `Gc: u64`. If `served > Lc` then `local = Lc` and `global = served - Lc`; by (1) and (2),
`served <= maximum <= Lc + Gc`, hence `global <= Gc`. Both cases refute the guard. The bound is
established by the function's own line (1), so this holds for arbitrary caller arguments — no
schema reachability assumption is needed.

The precise condition is worth naming, because it is what a future edit could break: the branch is
dead **because `maximum <= Lc + Gc`**. If `maximum` were ever changed to `demand_count` alone, the
guard would become live and the closed form would be wrong. So the guard is dead code today but
load-bearing documentation; the audit therefore instruments it rather than assuming it (see A3).

**Claim 2 — line (8) is equivalent to `aggregate_data <= min_d (c_d + m_d)`.**
For each `d`, line (7) uses `saturating_sub`, so `lower_d = max(0, A - c_d)` where `A` is
`aggregate_data`. If `A <= c_d` then `lower_d = 0`, which cannot exceed `m_d: u64`, and separately
`A <= c_d <= c_d + m_d`; so both the test and the scalar bound pass. If `A > c_d` then
`lower_d = A - c_d`, and `lower_d > m_d` is exactly `A > c_d + m_d`. Therefore (8) rejects if and
only if `A > c_d + m_d` for some `d`, i.e. if and only if `A > min_d (c_d + m_d) =: cap`. The
equivalence depends on `saturating_sub`: with a wrapping subtraction the `A <= c_d` case would
produce an enormous `lower_d` and the collapse would fail.

**Claim 3 — the scan may start at `min(maximum, S1)`.**
`A(s) = s` for `s <= Lc` and `A(s) = 2s - Lc` for `s > Lc`; both pieces are strictly increasing and
agree at `s = Lc`, so `A` is strictly increasing on `[0, maximum]`. Define

```
S1 = cap                              if cap <= Lc
S1 = floor((cap + Lc) / 2)            otherwise
```

*`A(S1) <= cap`.* If `cap <= Lc` then `S1 = cap <= Lc`, so `A(S1) = cap`. If `cap > Lc` then
`S1 >= Lc`, so `A(S1) = 2*floor((cap + Lc)/2) - Lc <= (cap + Lc) - Lc = cap`.

*Every `s > S1` violates claim 2's bound.* If `cap <= Lc`: for `Lc >= s > cap`, `A(s) = s > cap`;
for `s > Lc`, `A(s) = 2s - Lc > s > cap`. If `cap > Lc`: `s > S1 = floor((cap + Lc)/2) >= Lc`
gives `2s >= 2*floor((cap + Lc)/2) + 2 >= (cap + Lc - 1) + 2`, so `A(s) = 2s - Lc >= cap + 1`.

So every candidate the closed form skips is one the kernel rejects at line (8), and the first
feasible candidate at or below `min(maximum, S1)` is the same one the kernel returns. Line (9)
remains non-monotone — its discrete slope is `2k - 1` where `k = #{d : A(s) > c_d}` — so the
descending scan is retained; `s = 0` gives `A = 0`, `lower = 0`, `sum = 0 <= 0`, so the scan always
terminates with an answer, matching line (10).

**Arithmetic envelope.** The derivation needs `cap + Lc` not to overflow `u64`. With `u32`
capacities and `m_d <= D`, this holds whenever `D <= u64::MAX - 2^33`, which covers every input the
kernel's own `usize` demand can express on this target. The fleet binding is far inside it: `u16`
demands and small capacities.

### A2. Differential against the Python oracle

The Ergodis validation gate requires agreement with a Python oracle, not merely with the Rust
kernel. `python/lrc_counted_oracle.py` is the per-domain-capacity generalization of the
`azure-counted` CP-SAT model in the core repository's `python/benchmark_python.py:555`: counts
`x[kind][mode]` bounded by the multiplicities, per-data-domain load constraints
`L + 2G - served[d] <= capacity[d]`, parity-domain constraints `L <= capacity[6]`,
`G0 <= capacity[7]`, `G1 <= capacity[8]`, maximizing `L + G`. It is a **declarative model of the
problem**, not a transcription of the scan, so agreement is evidence rather than restatement.

The corpus is emitted by `ergodis-tools closed-form-audit corpus` and covers the boundary inputs the
review asked for:

| case class | cases | kernel agrees | closed form agrees |
|---|---|---|---|
| `all_zero_capacity` (every capacity 0, demands 0-11) | 12 | 12 | 12 |
| `zero_demand` | 1 | 1 | 1 |
| `max_demand` | 1 | 1 | 1 |
| `all_equal_capacity` (demands 0-17, every residue mod 6) | 18 | 18 | 18 |
| `single_domain_saturated` (each of the six, seven demands) | 42 | 42 | 42 |
| `local_parity_only` | 14 | 14 | 14 |
| `global_parity_only` | 14 | 14 | 14 |
| `global_split_low_high` / `global_split_high_low` | 28 | 28 | 28 |
| `grid` (bounded fixture grid) | 896 | 896 | 896 |
| `hostile` | 4,000 | 4,000 | 4,000 |
| **total** | **5,026** | **5,026** | **5,026** |

Zero disagreements. This run also validates the published Rust kernel itself against an independent
model, which the probe did not set out to do but is the more valuable half of the result.

Replay:

```
ergodis-tools closed-form-audit corpus --out evidence/2026-09-03-lrc-closed-form-corpus.json --hostile 4000
uv run --with ortools python3 python/lrc_counted_oracle.py \
    --corpus evidence/2026-09-03-lrc-closed-form-corpus.json \
    --report evidence/2026-09-03-lrc-closed-form-oracle-report.json
```

### A3. Adversarial construction, and exhaustive enumeration

Rather than sample, I attacked each step of the derivation for the input that would break it.

| attack | target | outcome |
|---|---|---|
| make `global > Gc` fire | claim 1 | requires `served > Lc + Gc`, contradicted by line (1); impossible for any argument |
| pass `A <= c_d` with tiny `m_d` | claim 2 | `saturating_sub` gives `lower_d = 0`; no rejection, and the scalar bound also passes |
| pass `A > c_d` with `m_d = 0` | claim 2 | both forms reject identically |
| skip a feasible `s > S1` | claim 3 | shown above to violate the multiplicity bound in all four sign cases |
| `cap = 0` | claim 3 | `S1 = 0`, scan returns 0; kernel agrees |
| `maximum < S1` | claim 3 | start collapses to `maximum`, identical to the kernel |
| overflow `cap + Lc` | envelope | needs `D > u64::MAX - 2^33`; unrepresentable through the binding's `u16` demand |
| non-monotone residual test | claim 3 | not claimed monotone; the descending scan is retained precisely for this |

No counterexample was constructible. The remaining risk is a derivation error I cannot see, so the
audit also enumerates **completely** rather than sampling. The enumeration uses the code's own
data-domain symmetry — the kernel depends on the data domains only through the multiset of
`(capacity, multiplicity)` pairs, and the multiplicity vector is fixed by the demand — so sorted
capacity six-tuples cover every distinct instance in the box.

| box | instances | comparisons | mismatches | line-(5) rejections observed |
|---|---|---|---|---|
| data caps 0-5, local 0-6, global 0-8, demand 0-24, extra 0-8 | 727,650 | 6,548,850 | 0 | **0** |
| data caps 0-8, local 0-10, global 0-10, demand 0-18, extra 0-4 | 6,903,897 | 34,519,485 | 0 | **0** |
| data caps 0-12, local 0-20, global 0-20, demand 0-40, extra 0-6 | 335,655,684 | **2,349,589,788** | 0 | **0** |

Each comparison checks three implementations against each other: the closed form, the published
kernel, and an instrumented transcription of the kernel's scan that counts how often line (5) fires.
The instrumented count is **zero across 2.39 billion comparisons**, which is the empirical companion
to the proof that the branch is dead.

### A4. Instance or family?

The derivation never uses the specific numbers 12, 2, 2. It uses exactly four properties of the
counted-kernel shape:

1. the scan's upper limit satisfies `maximum <= Lc + Gc` (line 1);
2. the aggregate load `A(s)` is a nondecreasing piecewise-affine function of `s`, here with slopes
   1 then 2;
3. the per-domain admissibility test has the form `max(0, A(s) - c_d) <= m_d`;
4. the residual test has the form `sum_d max(0, A(s) - c_d) <= s`.

So the closed form is a property of the **counted-kernel family**, not of the LRC(12,2,2) instance.
For a different LRC parameterization the constants move: the number of data domains changes from 6
to the group width, the multiplicity formula cycles over that width instead of 6, and the slope 2
becomes the per-repair read weight `w`, which changes the start bound to

```
S1 = cap                                      if cap <= Lc
S1 = floor((cap + (w - 1) * Lc) / w)          otherwise
```

with the same two-case argument. What does *not* survive a change of family is the collapse of the
two global parity capacities into their sum: that holds because the kernel constrains them only
through `global_capacity` and the split affects `mode_counts` alone. A family whose feasibility test
reads the parities separately would need both fields in the key.

This generalization is **derived, not measured** — no second counted kernel exists in the codebase
to test it against, and probe 8's survey of other kernels is the natural place to check it.

### A5. Verdict

All three claims hold, with the scope correction in A0: the closed form decides `repaired_count`
only. The `ResponseSource::Kernel` fallback is retained and tested
(`response_source_kernel_agrees_with_decided`), so a caller can switch the decided path off without
changing any answer. No envelope restriction was found beyond the `u64` arithmetic bound, which the
binding's types make unreachable.

## Part B — local witness readout

### B1. What was built

The retained witness blocks already hold the argmin split label of every `(from, to)` entry of every
internal node, so a single pod's decision does not need a fleet-wide descent. `witness_for_pod_with`
walks the root path that contains the pod: at each internal node it reads one split label and
descends into the child holding the pod, keeping the half-interval that child is responsible for —
left child takes `(from, middle)`, right child takes `(middle, to)`. That is `1 + log2(leaves)`
block reads, no allocation, and no work proportional to the fleet.
`witness_for_window_with` answers a contiguous window by repeating it, writing into a caller-owned
slice. The repair count is resolved through the same `RepairResolver` as a full materialization, so
kernel-resolved and response-served queries are both available.

Exact agreement is checked two ways:
`local_witness_queries_agree_with_the_full_readout` compares **every pod's** single-pod query, and a
nine-pod window, against the full materialization after each of 500 events on a 37-pod fleet; and
the counter harness re-verifies every pod of the 16,384-pod fleet against the full readout before
timing anything.

### B2. Measured cost

Instructions per operation at 16,384 pods (tree depth 15), paired over 8 rounds:

| operation | instructions | cycles | IPC |
|---|---|---|---|
| full readout, kernel-resolved | 14.56M | 4.06M | 3.58 |
| full readout, served from responses | 1.21M | 379.5k | 3.19 |
| **single pod, served** | **399** | **200** | 2.00 |
| single pod, kernel-resolved | 1.2k | 439 | 2.66 |
| window of 64, served | 24.4k | 7.3k | 3.35 |
| single pod, served, unique fleet | 399 | 198 | 2.02 |

| comparison | instructions | cycles [95% CI] |
|---|---|---|
| single pod over full served readout | **3,039x** | 1,864x [1,587, 2,189] |
| single pod over full kernel-resolved readout | **36,493x** | 20,061x [16,753, 24,022] |
| window(64) over full served readout | 49.8x | 51.8x [42.1, 63.8] |
| kernel-resolved over served, single pod | 2.92x | 2.19x [1.94, 2.46] |
| unique fleet over rack fleet, single pod | 1.00x | 0.99x [0.82, 1.19] **inconclusive** |

Three things worth saying plainly.

**The `O(pods)` term probe 6 left behind is gone for local queries.** 399 instructions over 15 levels
is about 27 instructions per level, and the last inconclusive comparison is the evidence that the
cost is structural rather than fleet-dependent: the same query costs the same on a fleet of unique
pods as on a fleet of 24 rack types, which is what `O(depth)` predicts and what a fleet-proportional
implementation could not produce.

**A window is cheaper per pod than a lone query** — 381 instructions per pod against 399 — because
consecutive pods share the upper part of their root paths in cache. There is no path-sharing logic
in the code; this is purely locality.

**There is a crossover, and it should be a dispatch rule.** At about 381 instructions per pod,
querying more than roughly 3,200 pods (a fifth of this fleet) costs more than the 1.21M-instruction
full readout. Local queries are the right answer for dashboards, per-pod API calls, and windows;
a full readout is still the right answer for a fleet-wide report. The rule is not implemented.

## Mystery ledger

- **Probe 6's "the kernel could be deleted" was too strong, and is withdrawn.** The closed form
  decides `repaired_count` only; `mode_counts`, `total_loads`, and `totals_checked` are not
  reproduced. Settled by restating the scope in A0; no code changed, because the binding only ever
  consumed the repaired count.
- **The dead branch is dead for all inputs, but only because of the function's own line 1.** If
  `maximum` were ever widened to `demand_count`, line (5) would become live and the closed form
  would be wrong. The audit instruments the branch rather than assuming it, and observed zero firings
  in 2.4 billion comparisons; nothing currently guards against that future edit, which is worth a
  note in the core if the closed form is ever promoted there.
- **The family generalization is derived, not measured.** The closed form should hold for any
  counted kernel with a nondecreasing piecewise-affine aggregate and the same two admissibility
  tests, with `S1 = floor((cap + (w-1) * Lc) / w)` for read weight `w`. No second counted kernel
  exists here to test it; probe 8's survey is the place to check.
- **The two global parity capacities collapse into their sum only for this family.** That is the one
  step of the canonicalization that is genuinely instance-specific: it holds because the kernel's
  feasibility test reads only `global_capacity`, and the split affects `mode_counts` alone.
- **The window's per-pod advantage is unexplained beyond "locality".** 381 against 399 instructions
  is a 4.5% effect with no code path difference; it is almost certainly cache warmth on the shared
  upper path, but no cache counters were collected to confirm it. Open, cheap, and low-value.
- No genuine mystery remains in Part A: three claims, three proofs, an independent oracle, and a
  complete enumeration all agree.

## Validation

```
cargo test -p ergodis-private --lib lrc_delta          # 8 passed, incl. local witness agreement
cargo test -p ergodis-private --lib summary_cache      # 9 passed
cargo test --test lrc_delta_allocations                # 1 passed
ergodis-tools closed-form-audit exhaustive             # 6.5M comparisons, 0 mismatches
ergodis-tools closed-form-audit exhaustive --max-data-capacity 12 --max-local 20     --max-global 20 --max-demand 40 --max-extra 6      # 2.35G comparisons, 0 mismatches
uv run --with ortools python3 python/lrc_counted_oracle.py --corpus <corpus> --report <report>
python3 scripts/counter_ab.py --binary <bin> --rounds 8 --pods 16384 --target-seconds 0.25 --out <json>
```

## Vibe check

Strong, and the review did its job: it caught one overclaim of mine (the kernel cannot be deleted,
only its repaired count skipped), converted a sampled argument into a proof plus a 2.4-billion-case
complete enumeration with the supposedly dead branch instrumented and observed to fire zero times,
and validated both the closed form and the published Rust kernel against an independent CP-SAT model
on 5,026 cases including every boundary class asked for. Part B removed the last fleet-proportional
term from a local witness query: 399 instructions, 3,039x below the full served readout, and
provably fleet-shape independent.

## Next probes

1. Implement the readout dispatch rule — local queries below roughly a fifth of the fleet, full
   readout above — and measure the crossover precisely.
2. Test the family generalization of the closed form against whatever counted kernels probe 8's
   survey turns up.
3. If the closed form is promoted toward the core, add a guard or comment binding line (5)'s
   deadness to `maximum <= Lc + Gc`, so a future edit to `maximum` cannot silently invalidate it.
4. Extend the CP-SAT oracle differential to the `mode_counts` and `total_loads` fields, which no
   current test covers against an independent model.
