# P0a border-signature census / valtest report (Codex, 2026-07-07)

## Result

C10 completed as a **NO-GO / gate failure** for C11.

Reasons:

1. Under the stated `<= 1 GB` guardrail, the event census already fails at `n=14,
   max-events=3` and at `n=18, max-events=2`.
2. `valtest` finds mixed-value buckets at `n=8` and `n=10`, so the `(exact global-tau core
   class, v1 border signature)` key is not value-sufficient even at small n.
3. `valtest n=12` also fails the 1 GB cap before producing a table.

At the user's request I also recorded higher-cap diagnostics with a 10 GB virtual-memory cap.
Those diagnostics recover `n=18, max-events=2`, but `n=14, max-events=3` still fails under 10 GB.
The C11 gate remains a no-go because the requested `n=18 depth >= 3` evidence is still absent
and the valtest violations are real.

So the compression hypothesis needed for C11 is not supported by this probe as implemented.
Do not start the central-child certificate extractor build from these data.

## Probe

Standalone source:

```text
notes/2026-07-07-p0a-border-signature-probe.rs
```

Compile:

```bash
rustc -O 2026-07-07-p0a-border-signature-probe.rs -o /tmp/p0a-probe
```

Interpretation note: the n20 plan's live counts force the paired core to be
`[0..n-2]^2` inclusive with `tau(r,c)=(n-2-r,n-2-c)`. The appendix text says
`[0..n-3]^2`, but that would not reproduce the documented core live counts
(`n=18: 224`, `n=20: 288`), so the probe follows the plan geometry.

The census also collapses ordinary tau-live core exchanges and enumerates only exception events
border/scar move plus all legal replies. This is the only interpretation compatible with the
required `max-events=0` gate producing exactly one all-mirror state.

## Gates

Compile: passed, no warnings.

Full-board solver gate:

```text
SOLVE-FULL n=4 verdict=FIRST memo=7
SOLVE-FULL n=5 verdict=FIRST memo=81
SOLVE-FULL n=6 verdict=FIRST memo=74
SOLVE-FULL n=7 verdict=FIRST memo=2246
SOLVE-FULL n=8 verdict=FIRST memo=17077
SOLVE-FULL n=9 verdict=FIRST memo=16577
```

Existing project solver cross-check (`rust/target/release/queens solve <n> naive`) reports FIRST
for all `n=4..9`.

Zero-event census gate:

```text
CENSUS n=12 max_events=0 residual_live=100 core_live=80 border_live=20
CENSUS-DEPTH n=12 depth=0 states=1 border_subsets=1 v0=1 v1=1
```

n=8 residual self-consistency:

```text
SOLVE-RESIDUAL n=8 verdict=P memo=1494 live=36
```

Since the full board is FIRST and the central child is P, the central strike is a winning first
move in the probe's own semantics.

## Census Tables

Runs below used:

```bash
ulimit -v 1000000
```

### n=12, max-events=4

```text
CENSUS n=12 max_events=4 residual_live=100 core_live=80 border_live=20
CENSUS-DEPTH n=12 depth=0 states=1 border_subsets=1 v0=1 v1=1
CENSUS-DEPTH n=12 depth=1 states=1386 border_subsets=501 v0=9 v1=1047
CENSUS-DEPTH n=12 depth=2 states=346134 border_subsets=1935 v0=15 v1=6957
CENSUS-DEPTH n=12 depth=3 states=5540075 border_subsets=1275 v0=11 v1=1265
CENSUS-DEPTH n=12 depth=4 states=353432 border_subsets=351 v0=7 v1=73
```

### n=14, max-events=2

```text
CENSUS n=14 max_events=2 residual_live=144 core_live=120 border_live=24
CENSUS-DEPTH n=14 depth=0 states=1 border_subsets=1 v0=1 v1=1
CENSUS-DEPTH n=14 depth=1 states=2556 border_subsets=919 v0=9 v1=2117
CENSUS-DEPTH n=14 depth=2 states=1689133 border_subsets=7901 v0=17 v1=48207
```

### n=16, max-events=2

```text
CENSUS n=16 max_events=2 residual_live=196 core_live=168 border_live=28
CENSUS-DEPTH n=16 depth=0 states=1 border_subsets=1 v0=1 v1=1
CENSUS-DEPTH n=16 depth=1 states=4238 border_subsets=1535 v0=9 v1=3639
CENSUS-DEPTH n=16 depth=2 states=6014751 border_subsets=29987 v0=17 v1=217279
```

### n=18, max-events=1

```text
CENSUS n=18 max_events=1 residual_live=256 core_live=224 border_live=32
CENSUS-DEPTH n=18 depth=0 states=1 border_subsets=1 v0=1 v1=1
CENSUS-DEPTH n=18 depth=1 states=6544 border_subsets=2359 v0=9 v1=5921
```

## Higher-Cap Diagnostics

Runs below used:

```bash
ulimit -v 10000000
```

These are diagnostic rows, not the original `<= 1 GB` C10 gate.

### n=18, max-events=2

```text
CENSUS n=18 max_events=2 residual_live=256 core_live=224 border_live=32
CENSUS-DEPTH n=18 depth=0 states=1 border_subsets=1 v0=1 v1=1
CENSUS-DEPTH n=18 depth=1 states=6544 border_subsets=2359 v0=9 v1=5921
CENSUS-DEPTH n=18 depth=2 states=17406053 border_subsets=102161 v0=17 v1=946885
```

### n=14, max-events=3

Still fails under the 10 GB cap:

```text
exit=134
memory allocation of 8724152336 bytes failed
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

## Guardrail Failures

### n=14, max-events=3

```text
exit=134
memory allocation of 545259536 bytes failed
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

An uncapped monitor before stopping the original sweep showed the `n=14, max-events=3` process at
about `8.8 GB RSS`, so the cap failure is not a near miss.

### n=18, max-events=2

```text
exit=134
memory allocation of 1090519056 bytes failed
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

### valtest n=12

```text
exit=134
memory allocation of 545259536 bytes failed
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

## Valtest Key

Bucket key:

```text
(global_tau_canonical_live_core_set, v1_signature)
```

The core component is the exact live-core set modulo the single global tau involution:
`min(sorted(core_live), sorted(tau(core_live)))`. It does not independently fold each tau pair.
The v1 component is:

```text
(row-arm live count, col-arm live count,
 sorted row-arm live-border core-incidence counts,
 sorted col-arm live-border core-incidence counts)
```

## Valtest Violations

### n=8

```text
VALTEST n=8 states=1973 buckets=1613 solver_memo=3510 violations=2
VALTEST-VIOLATION n=8 idx=0 bucket_core=[1, 4] bucket_v1=2:0:[1, 1]:[] members=4
  member verdict=N live_count=4 border=Mask([432345564227567616, 0, 0, 0, 0, 0, 0, 0])
  member verdict=N live_count=4 border=Mask([3458764513820540928, 0, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([1441151880758558720, 0, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([4899916394579099648, 0, 0, 0, 0, 0, 0, 0])
VALTEST-VIOLATION n=8 idx=1 bucket_core=[8, 32] bucket_v1=0:2:[]:[1, 1] members=4
  member verdict=P live_count=4 border=Mask([36028797027352576, 0, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([549764202496, 0, 0, 0, 0, 0, 0, 0])
  member verdict=N live_count=4 border=Mask([8421376, 0, 0, 0, 0, 0, 0, 0])
  member verdict=N live_count=4 border=Mask([141287244169216, 0, 0, 0, 0, 0, 0, 0])
```

### n=10

Summary:

```text
VALTEST n=10 states=71766 buckets=62069 solver_memo=156561 violations=142
```

The n=10 violations are numerous variants of the same issue: equal exact global-tau core class
and equal v1 border incidence signature can still have mixed P/N values. The first few printed
violations were:

```text
VALTEST-VIOLATION n=10 idx=0 bucket_core=[1, 21] bucket_v1=0:2:[]:[1, 1] members=3
  member verdict=P live_count=4 border=Mask([536870912, 33554432, 0, 0, 0, 0, 0, 0])
  member verdict=N live_count=4 border=Mask([512, 33554432, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([536871424, 0, 0, 0, 0, 0, 0, 0])
VALTEST-VIOLATION n=10 idx=1 bucket_core=[1, 3, 31] bucket_v1=0:1:[]:[1] members=3
  member verdict=N live_count=4 border=Mask([0, 33554432, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([549755813888, 0, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([576460752303423488, 0, 0, 0, 0, 0, 0, 0])
VALTEST-VIOLATION n=10 idx=2 bucket_core=[1, 3, 56] bucket_v1=1:0:[1]:[] members=3
  member verdict=P live_count=4 border=Mask([0, 268435456, 0, 0, 0, 0, 0, 0])
  member verdict=P live_count=4 border=Mask([0, 4294967296, 0, 0, 0, 0, 0, 0])
  member verdict=N live_count=4 border=Mask([0, 134217728, 0, 0, 0, 0, 0, 0])
```

## C11 Gate

C11 should remain gated. The required condition in the queue was:

```text
#v1-signatures growing clearly slower than #border subsets at n=18 (depth >= 3)
AND valtest violations are zero or obviously structured
```

This probe reaches neither:

- n=18 depth 2 cannot be produced under the original 1 GB memory cap; a 10 GB diagnostic run
  produced depth 2 but not depth >= 3 evidence;
- n=8 and n=10 valtests have mixed-value buckets.
