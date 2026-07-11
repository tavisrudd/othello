# C44 — GF(25) prime-power path + q=25 on-conic bucket census

## Status: COMPLETE (2026-07-10, Claude). q=25 is NOT arc-depleted at the (ON) route's on-conic layer.

**Result: all 28 full-`PGL(2,25)` on-conic S4 buckets are P. Zero N, zero aborted.** Every one of the
`10,626` raw on-conic states at q=25 canonicalizes into a P-valued bucket. Consequence for C68: `D(25)
= 0`, `min-witness(25) = q−4 = 21` (full), `ν(25) = 0` — the same clean pattern as every other
non-arc-depleted order (5,7,9,13,19,23). **The `2 → 1 → ?` slide across the two known depleted orders
{11,17} does NOT continue at the first square order — it rebounds fully.** The (ON) route's on-conic
escape margin at q=25 is maximal, not marginal.

Full census log: `notes/data/c68b-onconic-buckets-q25.txt` (28 rows, `s4arena` output, all `value=P`).
Compute: ~6.67 h summed bucket wall time (dominated by ~20 generic buckets at 100–260M positions
each), 8 GB arena (`--log2 29`), single-core, run in a low-contention window.

The GF(25) path + bucket enumeration ready check, and the RAM-gate engineering that made the census
possible (the FnvMap path blows 8 GB on generic buckets; built + validated the arena labeling path,
commit `60c87fb`), are below unchanged as the record of how this was unblocked.

### Why q=25's depletion status matters (the import, before any RAM logistics)

C68 found the (ON)-route escape margin is a step function on arithmetic-depleted orders: `D(q)=0`
and full min-witness `= q−4` everywhere except {11,17}, where the worst-class on-conic escape count
is `2` then `1`. The margin **sharpens** across the two known depleted orders (`2 → 1`) and recovers
to full only *between* them. So the sharpest open question is whether some larger depleted order
drives **min-witness → 0** — a size-3 class with *zero* on-conic escapes. That would refute conic
localization as the load-bearing mechanism (the plane could still be P via off-conic escapes; at
q=17's knife-edge class the root still has 5 total escapes, 4 off-conic), forcing the uniform proof
off the conic. **q=25 is the next chance at a third depleted point** to see whether the margin keeps
collapsing `2 → 1 → 0?` or stabilizes. That is what makes its depletion status decisive — not
completeness, but the first place the (ON) route could visibly start to break. The obstacle below is
purely compute; the question is conceptual and load-bearing.

## What is ready (cheap, done)

**1. GF(25) prime-power path — in place and consistent.**

- `irred(25)` in `notes/2026-07-06-grid-cap-solver.rs` = poly `[3,0,1]` = `x² + 3` over F₅.
  Irreducible: `x² = −3 ≡ 2 (mod 5)`, and the squares mod 5 are `{1,4}`, so 2 is a nonsquare ⇒ no
  root. (Distinct from the C6 GF(49) bug, where `x²+3` over F₇ was *reducible* because `−3 ≡ 4 = 2²`.)
- `GF::new` runs the C6 self-check on every field: a multiplicative-inverse assert for every nonzero
  element and a zero-divisor assert for every nonzero pair. It passes at q=25 (the field is exact).
- `MAXW = 16` supports `q² ≤ 1024`, i.e. `q ≤ 32`, so q=25 (625 cells) fits the mask.
- Field-path consistency: `s4 25 1,2,3,4` = **P**, `peak-memo = 26,305,294`, `elapsed = 124.8 s`,
  reproducing the handoff's ad-hoc "≈26.3M memo, P" datum. (Remaining minor C44-point-1 hardening —
  a byte-identical small-q regression rerun through the same code path, and the GF-hash header
  guards — is engineering, not a blocker; the field arithmetic itself is validated here and by the
  earlier C37 union checks.)

**2. Bucket enumeration — 28 full-`PGL(2,25)` on-conic buckets (group theory, no solves, ~4 s).**

```text
S4BUCKETLIST q=25 raw=10626 pgl=15600 buckets=28 size-hist=6:1,120:3,180:5,360:12,720:7 enum-elapsed=3.894
```

Orbit-size histogram: one degenerate size-6 orbit (`[0,1,2,3,4,25]`, the ∞-containing special
bucket), then 3×120, 5×180, 12×360, 7×720. **~19 of the 28 are size ≥ 360** (generic orbits); these
are the expensive ones. By the C53 full-PGL bridge, one representative per bucket is game-value
sound, so 28 representative solves is the whole census — no per-member duplication needed.

## The sizing wall — per-bucket labeling exceeds 8 GB

The bucket-labeling solver (`eval_s4_on_board`, and equally the `s4dump` path) uses a growable
`FnvMap<u128, bool/u8>`. Measured slot cost at power-of-two capacity: 64M-cap → 2.21 GB RSS, 128M-cap
→ 4.38 GB RSS ⇒ **≈ 33 bytes/slot**, load factor 0.875. So:

| FnvMap capacity | table RSS | max live entries | rehash-into peak (old+new) |
|----------------:|----------:|-----------------:|---------------------------:|
| 128M            | ~4.4 GB   | ~112M            | 2.2 + 4.4 = ~6.6 GB        |
| 256M            | ~8.4 GB   | ~224M            | 4.4 + 8.4 = **~12.7 GB**   |

Under an 8 GB budget the usable table is 128M-cap ⇒ **≤ ~112M distinct positions per bucket**.

**Bucket 0** (`[1,2,3,5]`, canon `[0,1,2,3,4,5]`, the generic size-720 orbit) exceeds this:

- Prior run (`s4buckets`, cap 100M): `status=ABORTED peak-memo=100,000,000 elapsed=479.172 s` — still
  expanding at 100M, no verdict.
- This sizing probe (cap 200M): reached the 128M-cap FnvMap plateau (RSS **4.38 GB**) at 317 s with no
  verdict, i.e. its game graph has **> 112M distinct positions**. Certifying it therefore requires the
  256M-cap table (~8.4 GB, ~12.7 GB rehash peak) — **over the 8 GB gate**. Killed before the rehash to
  respect the gate and avoid an OOM spike against ~11 GB free.

Solve rate ≈ **210K entries/s** (bucket 1: 26.3M/125s; bucket 0: 100M/479s). So a ~200M-entry bucket
is ~16 min of wall *plus* > 8 GB of RAM.

**Why q=25 is so much heavier than the q=23 primes:** the C54 q=23 buckets were 6–14M records each;
q=25 bucket 0 is > 100M distinct positions — roughly an order of magnitude larger. This is exactly the
Baer-subplane density the falsification map flags (A4): the square order's extra collinearity blows up
the P-certification tree.

The 16-byte arena `Memo` (`Shard`/`Memo`, `u128` slots, half the FnvMap footprint, with
`MADV_COLLAPSE` huge pages) would roughly halve this — but it is currently wired only to the
full-board parallel solver (`g_par`), **not** to the S4-rooted labeling path. Routing bucket labeling
through it is unbuilt engineering.

## Verdict

**All 28 buckets are P. Zero N, zero aborted.** The FnvMap path could not reach a verdict on the
generic buckets (>8 GB, would need the 256M-cap table); the arena path (below) resolved that and
carried the census to completion.

## How the RAM gate was unblocked — `s4arena`

**`s4arena` (commit `60c87fb`) routes S4-rooted labeling through the 16-byte `Shard` arena** (fixed
pre-alloc, no rehash) instead of the growable 33-byte `FnvMap`. Validated byte-identical to the FnvMap
path before use on q=25 — same P/N label AND same distinct-class count, both matching C54's
independent record counts: q=9 P/16, q=11 N/42, q=13 P/553 (+ full census 5/5 P), q=17 P/64728, q=25
`[1,2,3,4]` P/26,305,294.

Ran serially, single-core, `--log2 29` (8 GB physical arena): bucket 0 first (213.5M positions, the
FnvMap wall) inside a smaller 4 GB arena to confirm the biggest bucket fit before committing the box
to a multi-hour run; then buckets 2–27 at 8 GB (bucket 2 hit the 4 GB/214M cap and was rerun at 8 GB).
Total: **~6.67 h summed bucket wall time**, largest bucket 257.2M positions (idx 3, `[1,2,5,11]`),
smallest labeled bucket 6M (idx 1, the degenerate orbit). Fired in a low-contention window (freed
~1 GB of stale `/tmp` scratch first to widen headroom); RSS held steady at the 8 GB arena ceiling
throughout, no OOM risk materialized.

## Full result table

All 28 rows in `notes/data/c68b-onconic-buckets-q25.txt`; every row `status=OK value=P`. Summary:

```text
S4ARENA-SUMMARY q=25 run=26 okP=26 okN=0 aborted=0   (+ buckets 0,1 from earlier prep runs, also P)
buckets=28  P=28  N=0  aborted=0
total on-conic states (sum of fibers) = C(24,4) = 10,626
```

## Reproduction

```bash
cd rust
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-arena
./target/gridcap-arena s4bucketlist 25                 # 28 buckets, ~4 s, no solves
./target/gridcap-arena s4arena 25 1,2,3,4 --log2 27    # bucket 1: P, 26.3M positions, ~120 s
./target/gridcap-arena s4arena 25 1,2,3,5 --log2 28    # bucket 0: P, 213.5M positions, ~18 min, 4 GB
./target/gridcap-arena s4arena 25 --all --log2 29 --start 2   # remaining 26 buckets, ~6.5 h, 8 GB
./target/gridcap-arena s4arena 13 --all --log2 24      # smoke: q=13 census, 5/5 P (fast)
```

`--all` streams one `S4ARENA-BUCKET` line per bucket (any N appears immediately; run is resumable
with `--start <idx>`). Binary built with `rustc -O -C target-cpu=native`. RSS sampled from
`/proc/<pid>/status` (no `/usr/bin/time` on box).

## Consequence for C68 / the (ON) route

**`D(25) = 0`, `min-witness(25) = q−4 = 21` (full), `ν(25) = 0`.** The C68 depleted-order subsequence
is `{11: min-wit 2, 17: min-wit 1}` and q=25 is **not** a member — it joins the non-depleted set
`{5,7,9,13,19,23,25}`, all with `D=0`/full min-witness/`ν=0`. The `2 → 1 → ?` slide does **not**
continue at the first square order; it rebounds fully rather than sliding to 0. This directly answers
the C68/A5-nu-density open question (`notes/2026-07-10-codex-a5-nbucket-density.md`): the adverse
`ν(11)=0.357 → ν(17)=0.791` doubling trend breaks at q=25 rather than continuing toward a
fully-N class. Combined with C74's independent value-blind row analysis (all four R7 six-set
buckets — the sole previously-uncovered orbit — are P, `f_10=f_14=f_16=f_17=P`), this is now the
**complete** q=25 on-conic verdict, not a partial/lower-bound one.

Per C74 §6's 2×2 interpretation matrix: with q=25 non-depleted, every on-conic endpoint is P, so
"non-depleted ∧ L-fails" is logically impossible — L's tests (the max-incidence selector, the
concurrence-point ESC prediction) all pass vacuously and add no new stress-test information at this
order. The concurrence-point off-conic solve (C73 §7 step 0) was left un-run for this reason: it is
no longer decision-relevant once the on-conic census is complete and all-P, and translating C74's
abstract projective-parameter coordinates into the solver's grid coordinates would need new tooling
that this order doesn't require building. L's stress test (a genuine test of the ESC form against a
depleted order) now waits for the next depleted order past q=17.

## Independent chunked certification: bucket 2 is P (2026-07-10, Codex)

The 4 GB arena continuation independently reached its fixed capacity on bucket 2
(`[1,2,6,17]`) without a root label:

```text
S4ARENA-BUCKET q=25 idx=2 size=360 rep=[1, 2, 6, 17] status=ABORTED value=- peak-memo=214748361 elapsed=1096.130
```

The chunked `s4xormine` route nevertheless certifies this representative **P**. For every one of
the root's 329 legal moves, it found and exactly solved a P-valued reply. The slices partitioned
the root-move indices as `[0,10), [10,40), ..., [280,310), [310,329)`; the combined result is:

```text
root moves covered exactly once: 329/329
XORRESULT rows:                 329
status=hit:                     329
no-candidates/no-hit/aborted:  0
largest per-slice memo:         41,358,450
largest measured RSS:          3,296,104 KB
```

Representative command shape (the first slice used `--limit 10`, the middle slices 30):

```bash
target/gridcap-c44 s4xormine 25 1,2,6,17 \
  --cap 50000000 --start 10 --limit 30
```

Verbatim boundary summaries:

```text
S4XORMINE-DONE moves=10 root-start=0 root-end=10 root-total=329 hits=10 no-candidates=0 no-hit=0 aborted=false memo=13064597
S4XORMINE-DONE moves=30 root-start=280 root-end=310 root-total=329 hits=30 no-candidates=0 no-hit=0 aborted=false memo=40627911
S4XORMINE-DONE moves=19 root-start=310 root-end=329 root-total=329 hits=19 no-candidates=0 no-hit=0 aborted=false memo=24756426
```

This is a complete root P certificate at the same computed-oracle trust tier as the other S4
labels: every legal child is N because it has an exact P child. By the C53 full-PGL bridge, bucket
2 is therefore P. Current labeled total is at least **3/28, all P** (buckets 0, 1, 2); no q=25 N
bucket has appeared.
