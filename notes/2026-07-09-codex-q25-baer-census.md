# C44 — GF(25) prime-power path + q=25 on-conic bucket census

## Status: SIZED + arena tool built (2026-07-10, Claude). Census now gate-feasible; full run pending a low-contention window.

This is the C44 sizing pass (C68 follow-on). Outcome: the GF(25) path + bucket enumeration are ready;
the FnvMap labeling path blows the 8 GB gate, **so I built + validated the arena labeling path (option
(b), committed `60c87fb`) which resolves it** — and used it to certify the hardest bucket. Current
state:

- **2 of 28 q=25 on-conic buckets labeled, both P** (via the new `s4arena` path):
  - bucket 1 `[1,2,3,4]` (degenerate size-6 orbit): **P**, 26.3M positions, ~120 s.
  - bucket 0 `[1,2,3,5]` (generic size-720 orbit, the FnvMap path's wall): **P**,
    **213,512,095 positions**, 1089 s (18.2 min) in a 4 GB arena. No N — no falsification here.
- **The census is now feasible at ~6 h / 8 GB** with `s4arena --all` (bucket 0 ≈ 18 min × ~19 generic
  buckets + fast small ones). It needs `--log2 29` (8 GB) because bucket 0's 213.5M nearly maxed the
  4 GB / 214M-cap arena; larger buckets will exceed it.
- **Not yet run in full** because the box is contended (rust-analyzer + a second claude + codex active,
  ~4–12 GB headroom fluctuating) and a hash table faults ~all its arena pages immediately (arena RSS ≈
  arena size, ~8 GB), so a ~6 h 8 GB run risks the OOM line the CLAUDE.md flags. **Decision needed:**
  run now (box permitting, monitored) or in a low-contention window.

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

To answer q=25's depletion status, **all 28 buckets must be labeled P or N** — an aborted bucket
gives no verdict, and an N bucket cannot be assumed away (N-labeling is not reliably cheap either: an
N root is certified by fully expanding one P child, whose subtree can itself be tens of millions of
positions). The ~19 generic buckets are each bucket-0-class (> 8 GB, ~10–16+ min). **The full census
does not fit the C44 8h/8GB gate as written.**

## Unblock — option (b) chosen and BUILT

**Option (b) is done: `s4arena` (commit `60c87fb`) routes S4-rooted labeling through the 16-byte
`Shard` arena** (fixed pre-alloc, no rehash), the durable fix. Validated byte-identical to the FnvMap
path — same P/N label AND same distinct-class count, both matching C54's independent record counts:
q=9 P/16, q=11 N/42, q=13 P/553 (+ full census 5/5 P), q=17 P/64728, q=25 `[1,2,3,4]` P/26,305,294. It
already certified the FnvMap path's wall (bucket 0, 213.5M positions) inside a 4 GB arena.

Remaining: the census is now a **~6 h / 8 GB `--log2 29` run** — gate-compliant on RAM but multi-hour,
so it is a "size-then-gate" decision (per intent-based mode) rather than inside-gate. Run it in a
low-contention window (or monitored, box permitting). The old FnvMap-only options — (a) re-gate RAM to
~14–16 GB, (c) cheap partial — are superseded by (b) and kept below only for history.

<details><summary>superseded FnvMap-only options</summary>

- (a) Re-gate RAM to ~14–16 GB and run the 28 reps serially with cache-drops (~2–5 h). No new code but
  over the 8 GB limit.
- (c) Cheap partial: label only the buckets that terminate under a modest FnvMap cap; cannot decide
  depletion (an uncertified generic bucket could be the N one).

</details>

## Reproduction (arena path)

```bash
cd rust
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-arena
./target/gridcap-arena s4arena 25 1,2,3,5 --log2 28   # bucket 0: P, 213.5M positions, ~18 min, 4 GB
./target/gridcap-arena s4arena 25 --all --log2 29      # full 28-bucket census (~6 h, 8 GB) — the run
./target/gridcap-arena s4arena 13 --all --log2 24      # smoke: q=13 census, 5/5 P (fast)
```

`--all` streams one `S4ARENA-BUCKET` line per bucket, so any N appears immediately (falsification watch)
and the run is resumable with `--start <idx>`.

## Consequence for C68 / the (ON) route

`D(25)` and q=25's depletion status — the decisive next datum for the C68 knife-edge (`min-witness
2 → 1` across the two known depleted orders {11,17}) — are gated behind this census. It is **not** a
quick follow-up: it needs the RAM/machinery gate above. Until then the C68 depleted-order subsequence
stays at two points ({11,17}), and "min-witness ≥ 1 at every depleted order" (the A5 anchor
`maxonN(q) ≤ q−5`) remains untested past q=17.

## Reproduction

```bash
cd rust
./target/gridcap s4bucketlist 25                 # 28 buckets, ~4 s, no solves
./target/gridcap s4 25 1,2,3,4 --cap 60000000    # bucket 1: P, 26.3M memo, ~125 s (field-path check)
./target/gridcap s4 25 1,2,3,5 --cap 100000000   # bucket 0: ABORTED at 100M, ~479 s (the wall)
```

Binary `rust/target/gridcap` built from `notes/2026-07-06-grid-cap-solver.rs`
(`rustc -O -C target-cpu=native`). RSS sampled from `/proc/<pid>/status` (no `/usr/bin/time` on box).
