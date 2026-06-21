# Compact set-associative TT — encoding fingerprint bits into the cache-line layout

**Date**: 2026-06-21
**Session**: --16 (resumes [explicit-stack frontier](handoffs/2026-06-19-explicit-stack-frontier.md))
**Goal**: cut the per-probe DRAM stall (the #1 cost: ~165 cyc entry probe, 66% skid) toward **30s end-to-end**.
**Status**: exploration + decisive experiment (in progress).

## The lever, reframed

Two separable sub-levers live inside "set-associative TT", and they trade off at a fixed 64-byte line:

- **Density** (bits/key ↓) → smaller table → fewer huge-page dTLB entries + fewer bytes touched + less
  prep. The table always blows L3 (~256 MB vs multi-GB), so the residency win is the **TLB walk** + bytes,
  ~proportional to table size.
- **Associativity** (ways/line ↑) → conflict evictions ↓ → re-expansion ↓ → fewer total probes (nodes).

The parked `queens-tt-assoc-buckets` branch (8-byte slots, 8-way) captured *only* the associativity half and
measured **break-even** (−7% nodes ≈ +7% scan cyc/node). At today's low load (~30%) conflict misses are
already rare, so associativity *alone* yields little. **The combined win is what density unlocks: pack the
slot small enough to run a smaller table at higher load, and let high associativity absorb the conflicts a
direct-mapped table at that load would suffer.** That buys prep + TLB on the **e2e wall** — the 30s lever —
even though raw node count barely moves.

## Constraints (fixed)

1. **Safety floor.** Wrong-hits ≈ probes·occupancy·2⁻ᶠᵖ. Today's scale (K=16: 0.39 B nodes, ~2 B probes,
   ~5 occupied/bucket): 2e9·5·2⁻ᶠᵖ < 1e−3 ⇒ **fp ≥ 43**; use **46** for completion-scale margin
   (10¹¹ probes). Non-negotiable — the verdict must be trustworthy (cross-checked vs Jenrich = second).
2. **Value = 1 bit** for iso-dense (win/loss). The general slot reserves 8 (nimbers); the compact TT can be
   iso-dense-specific and reclaim 7.
3. **Lockless concurrent.** get/put are `Relaxed` atomic load/store, no locks. Torn reads tolerated
   (fp-mismatch → miss → recompute). Constrains the layout to atomic-word-granular access.
4. **Flat-TT working set is pc ≥ 17 only.** getK resolves pc 9..16, W8 resolves pc 8; the flat TT is probed
   only for pc > `recurse_min` = max(DK=16, block_k, iso_max) = 16. ~393 M keys, all pc 17–~25. Band sizing
   should concentrate there (the embedded n=14 weights start at pc 9 — re-derive for K=16).
5. **Hot path is a MISS** (the node is being expanded *because* it missed) — the scan must be cheap on miss:
   load line, one SIMD compare, usually empty.

## Free-bit sources (the user's steer: "encode bits into the layout for free — SoA, EF, sentinels")

| src | trick | yield | verdict |
|-----|-------|-------|---------|
| **F1** | reclaim `val` 8→1 bit (iso-dense win/loss) | **+7 bits/key** | ✅ take |
| **F2** | SoA: pack fields bit-exact across the line's u64 words, no 8-byte atomic padding | 47-bit entry costs **47, not 64** | ✅ take |
| **F3** | EF / position-encode (lane ≈ home fine-bucket → free high hash bits) | sparse buckets ⇒ U/N huge ⇒ EF saves ~1 bit; needs sort-on-insert (lockless-hostile) | ⏸ defer — wrong tool for sparse buckets |
| **F4** | pc implicit by band (segmentation) | 0 within-bucket (same pc) | already used |
| **F5** | sentinels: tag 0 ≡ empty (drops the occupancy bitmap, −W bits/line); last-lane sentinel ≡ overflow | lets load run to ~55–60% safely | ✅ take |

**Why F3 (Elias-Fano / position) doesn't pay here.** EF wins when buckets are *dense* (N large, U/N small →
many free high bits encoded in ~2 bits/elem). Ours are sparse — ~10 keys in a 2⁴⁶ universe → only ~3 "high"
bits to encode implicitly, and the displacement bookkeeping a lockless set-assoc table needs to *recover*
position eats them back. Net ~+1 bit for large complexity. The within-bucket discrimination is
information-theoretically the per-slot stored bits; position-encoding can't cheat it in a dynamic table.

**Density floor:** ~**47 bits/key** (46 fp + 1 val), achievable only in a *packed* layout (AoS 8-byte = 64).
Max density gain = 47/64 = **−27%**. That is the ceiling of this lever; there is no safe 4-byte (32-bit) slot
(31 fp ⇒ ~23 wrong-hits/run).

## Recommended layout — Scheme B (SoA split tag, 64-byte bucket)

```
one 64-byte line = bucket of W≈10 ways, reinterpreted as packed SoA arrays:
  [ W×16-bit fast-tag ] [ W×30-bit ext-fp ] [ W×1-bit val ]
  empty lane ≡ fast-tag == 0  (F5; no occupancy bitmap)
scan:  vpcmpeqw(broadcast query.tag16) over the tag array → candidate mask (usually 0 = clean miss)
       on a candidate lane: check its 30-bit ext-fp → confirm / reject.   effective fp = 16+30 = 46 ✓
```
- **bits/key ≈ 47** vs 64 (AoS 8-byte) → table 8.6 GB → ~6.3 GB at the same keys+load, **or** a ~5 GB table at
  ~55% load (assoc absorbs it).
- get+put amortize to **one bucket scan** (the parked `probe_assoc`/`store_slot` already does this for 8-byte).
- torn reads across u64 words → fp-mismatch → miss → recompute (lockless-safe, identical discipline to today).
- **storage:** keep `Box<[AtomicU64]>`; a bucket = 8 contiguous `AtomicU64`. The SoA arrays are bit-packed
  views into those 8 words. Tag scan reads words 0–2 (160 tag bits) as one SIMD load; ext extraction (cold,
  on a match) is a cross-word bit-extract.

## Decisive experiment (before the Scheme-B refactor)

The Scheme-B bet rests entirely on: **does associativity recover the eviction a smaller table suffers?**
(The --15 note: "bits 29 (4.3 GB) saves prep but loses more to eviction.") The parked 8-byte branch tests this
*directly* without any refactor — A/B `QUEENS_TT_ASSOC` 1-vs-0 (both `QUEENS_TT_SEGMENT=1`) at several slot
counts (load factors):

- 1.5 B slots (12 GB, ~26% load) — assoc benefit at low load (expect ~0).
- 750 M slots (6 GB, ~52% load) — mid load.
- 500 M slots (4 GB, ~79% load) — high load (expect the assoc node-cut to show).

If assoc holds the node count near the large-table baseline as load rises while direct blows up → the density
lever is real and Scheme B is worth building. If assoc barely helps even at high load → the lever is weak;
report + pivot (back to getK-evaluator cost / nimber decomposition).

## Integration finding (current main)

On current main `MODE` is a *single* axis — the winning **M_ORD_W deep loop always uses the FLAT TT**; only
the standalone M_SEG mode uses bands. Segmentation/assoc were **never composed with the production search**.
Ported the parked assoc TT (`tt.rs`, applies clean) and exposed seg/assoc to M_ORD_W via resolved-once runtime
fields (`self.assoc`/`self.segment`) in the 5 TT helpers — orthogonal to `MODE` (branch `queens-compact-assoc-tt`).
Verdict-correct n=4..12 with assoc on; n=12 node count matches seg to 0.06% at ~0 load.

**Band-sizing confound (important).** The embedded band weights (`N14_PUTS_FROM9`) put ~58% of slots in the
pc 9–16 bands — but at K=16 **getK resolves pc ≤ 16, so those bands are never stored** (dead weight). The live
pc≥17 bands are therefore starved to ~42% of the table ⇒ effective load on them is ~2.4× nominal. The
assoc-vs-seg A/B (same layout both arms) still **isolates associativity** — a valid mechanism gate — but the
absolute node counts are inflated vs the production FLAT table, and the nominal load points (26/52/79%) are
really ~62/124/187% effective. For the clean vs-production comparison: either feed real K=16 pc≥17 band weights
(`QUEENS_PC_HIST` → `QUEENS_TT_BANDS`) **or** use a band-free **flat-assoc** (bucket the flat fastrange index;
simpler, directly comparable to flat-direct).

## Results

### Mechanism gate — assoc(8-way) vs seg(1-way), n=16 M_ORD_W, n14 bands (starved live bands)

At 1.5 B slots (~62% effective load on the starved live bands), 3-round interleaved A/B:

| arm | nodes | wall | cyc/node |
|-----|-------|------|----------|
| assoc (8-way) | 996 M | 70.4 s | 4738 |
| seg (1-way)   | 1100 M | 79.0 s | 4539 |
| **Δ (direct vs assoc)** | **+10.5% nodes** | **+12.2% wall** | −4.2% |

**Associativity mechanism CONFIRMED**: 8-way buckets cut ~9.5% of conflict-miss nodes at high load, and the
node cut dominates the +4.2% scan cost → −11% wall. **But the seg bands are broken at K=16** — both arms are
~2.5× worse than production flat (394 M / 30 s) because getK voids the pc≤16 bands (the n=12 single-thread
check sharpens it: seg = 81 k nodes vs flat = 47 k at a non-evicting TT — the bands evict even there). ⇒ the
segmented path is a dead end here; the real comparison is **flat-assoc vs flat-direct** (band-free, control =
production flat). Built (`bucket_base` flat path), verdict-correct n=4..12, n=12 node-identical to flat-direct.

### Clean gate — flat-assoc(8-way) vs flat-direct, n=16 M_ORD_W, no bands (3-round A/B)

| table | load | assoc nodes/wall/cyc-n | direct nodes/wall/cyc-n | Δ direct−assoc |
|-------|------|------------------------|-------------------------|----------------|
| 12 GB (1.5B) | 26% | 395 M / 31.47s / 5307 | 396 M / 30.40s / 5046 | wall −3.4% (assoc **loses**) |
| 5.6 GB (700M) | 56% | 385 M / 30.27s / 5210 | 411 M / 32.62s / 5048 | wall +7.8% (assoc wins — **noise**) |
| 4 GB (500M) | 79% | 401 M / 33.26s / 5211 | 405 M / 31.01s / 5063 | wall −6.7% (assoc **loses**) |

**Verdict: WASH-to-NEGATIVE in the fitting regime.** The decisive observation: **node counts are flat (~395–411M)
across 4–12 GB** — the K=16 working set (~393M keys) *fits even in a 4 GB table*, so there is almost no eviction
for associativity to recover. direct cyc/node is also flat (~5050; smaller tables give **no residency win** —
random-access + huge pages make it DRAM/TLB-bound independent of size). assoc adds a fixed ~+3-5% cyc/node scan
for no consistent node benefit. The 700M "win" and 500M "loss" are both inside the ±18% node-noise (3 rounds).
**The W_K K=16 collapse removed the very oversubscription set-associativity targets** — consistent with the
parked branch's own note ("revive for the *oversubscribed* regime / small-TT / n=18"). At K=16 the TT is not
oversubscribed.

### Oversubscribed regime — table SMALLER than the working set (350M slots)

At 350M slots (~112% load): assoc 393M/30.5s vs direct 410M/31.8s — assoc wins +4.3% wall but **even with
assoc the oversubscribed table (31.8s) is slower than the fitting production table (~30.4s)**. Associativity
never turns oversubscription into a win; it only softens it. **Assoc-TT verdict at K=16: wash-to-marginal,
closed.** The W_K collapse removed the oversubscription it targets.

---

## PIVOT (user-steered): dense exact-key sidecar probed before the TT, to CUT DRAM access

Goal restated: **cut DRAM probes**, not shrink the TT (cyc/node is flat across TT size — shrinking doesn't help
the probe latency). A **dense, exact** (value-preserving ⇒ **node-count-neutral**) structure, **cache-resident**,
**probed before the TT** (BurrStore memtable+Bloom model), **targeted to bands that fit cache**, **SIMD batch-probed**
over the ETC child set. The TT value is **1 bit** (win/loss) ⇒ density cost is *all* key-identity.

### Reuse / cacheability — MEASURED (n=16, M_ORD_W; new `QUEENS_RC_BITS` recency-sim tap)

| metric | value |
|--------|-------|
| total entry probes / distinct | 1.10 B / 0.81 B |
| **global dedup ceiling** (max any probe-cache can cut) | **26.9%** |
| recency hit, per-worker, 64 KB→256 KB→1 MB→4 MB→16 MB→64 MB | 12.2 → 14.2 → 15.7 → 16.5 → 17.0 → **~17% (saturates)** |
| slow-root (giant-root tail) hit vs average | 15.8% vs 15.5% — **not more cacheable** |
| temporal profile (slow root, per 4M-probe window) | **flat ~15–16%** — no late-tail enrichment |
| hit concentration by band | pc 17–21 = 75% (large-cardinality bands) |

**Read:** exploitable reuse exists but is **modest and mostly long-range** — a recency cache caps at ~17%
(saturated even at 64 MB; the rest of the 26.9% reuse recurs after the key is evicted). L2-resident (~1 MB) gets
~15%. With a **SIMD batch-probe** (amortizes the check) + L2 latency, that ~15% is bankable; serial-probe at L3
latency would lose (break-even 30%). To beat 17% toward 26.9% needs a **learned predictor** (cache by predicted
reuse, not recency) — the reuse is long-range + temporally flat, so signal is the open question. Wall payoff of
a ~15% probe-DRAM cut is **uncertain pending a real build** (depends on the probe-DRAM fraction of cyc/node).

### Free bonus found (node-neutral, no sidecar): ETC win-child double-probe

The M_ORD_W ETC probes every recurse child for a loss-cut (`Some(0)`) but **discards `Some(1)`/`None`**; the
descent then recurses each non-cut child and **entry-probes it again**. Win-children (`Some(1)`) are thus probed
twice. Threading the ETC value into the descent (skip the recurse+re-probe for an already-known `Some(1)`)
is a node-neutral DRAM cut. (`None` children must still re-probe — a sibling may have solved them between.)

### Build plan (next)

1. **(quick) ETC win-child re-probe elimination** — thread `Some(1)` results to the descent. Node-neutral.
2. **Minimal exact per-worker L2 sidecar** — ~1 MB, 46-bit-tag slots (exact ⇒ node-neutral), probed before the
   TT in the ETC batch; populate on TT-hit/put. Measure the wall (the real test of the ~15% → wall translation).
3. **If signal, push the hit rate**: dim-reduction/learned code for denser cache (more keys/byte → L2 holds more)
   and/or a reuse predictor (beat recency's 17% toward the 26.9% ceiling).
