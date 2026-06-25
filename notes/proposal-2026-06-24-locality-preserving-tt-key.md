# Proposal: a locality-preserving canonical TT key + block-loading sidecar for the n=18 deep bands

**Date**: 2026-06-24
**Status**: design exploration / decision-grade RFC (no code yet)
**Scope**: the on-disk deep-band store for n=18 Non-Attacking Queens (= Node Kayles on the
queen graph). The companion threads are the
[n=18 umbrella](handoffs/2026-06-23-queens-n18-umbrella.md) and the
[RocksDB-vs-BuRR store evaluation](handoffs/2026-06-24-rocksdb-store-evaluation.md). This
document designs the **routing/block layer** those stores are missing — the thing that turns
one NVMe read into *many* useful entries.

---

## 0. TL;DR — the recommendation up front

- **★ The cost model is INVERTED vs n=16 (§1.0).** At n=18 a cold NVMe lookup is **~1000× a getK
  recompute** (vs ~10× when n=16's TT was in RAM — measured, per the umbrella). This overrides the
  project's n=16 "lookup ≈ compute" intuition. **The governing principle (§1.0.1): PAY COMPUTE TO STORE
  LESS AND LOOK UP LESS** — compute is abundant/parallel/~ns–µs, a lookup is scarce/IOPS-capped/~100 µs;
  trade the former for the latter at up to ~1000:1 and still win. Consequences: **store only deep
  high-reuse nodes** (recompute the cheap near-frontier — forced, not optional); **a miss is pure loss**
  (paid 1000×, learned nothing ⇒ membership-gate before any fetch); **L is worth ~1000× more** (every
  avoided block-load saves ~1000 recompute-equivalents); **idle cores recompute rather than wait on the
  IOPS wall**; and **several n=16 negatives invert** — a *stronger, more-merging canonical key* (the
  iso-key that lost at n=16 on compute), *deeper skip/recompute*, and the *parked component-nimber/
  modular decomposition* are now re-tested as **store-shrinkers** (measured by deep-distinct-count, not
  by node count or n=16 wall). The dense-bitmap structural tier (§6A.4) is the single highest-value
  component — it fuses membership + value + zero-key density into one O(1) in-slice index, killing the
  miss-penalty and the per-key overhead together.

- **The make-or-break problem is real and has a clean resolution.** D4 lex-min
  canonicalisation followed by a 128-bit *scatter* hash (`pos_key` → `canon` → `hash128`,
  `geom.rs:172` / `tt.rs:1003`) destroys locality by design. The fix is **not** to weaken
  canonicalisation but to **re-derive a locality-preserving ROUTING ordinal from the canonical
  representative** — canon for *correctness* (sharing), an order-preserving curve over the
  canonical bitmask for *locality* (blocking). They are two functions of one canonical object,
  not a trade-off.

- **The crux's true shape — siblings DON'T share a canonical prefix.** The naive hope ("siblings
  differ by one queen ⇒ adjacent keys") **fails**: each sibling re-canonicalises into a possibly
  *different* D4 orbit, so a placed-queen-set prefix key scatters siblings. **The locality that
  survives canonicalisation is not parent→child adjacency; it is band/shape adjacency** — the
  reuse structure of this DAG is *transposition-driven*, and transpositions cluster by
  `(popcount, coarse occupancy region)`, not by descent path. So the key must cluster by
  **available-popcount band first**, then by a **canonical-occupancy space-filling ordinal**
  within the band.

- **Recommended key (rank #1):**

  ```
  routing_key = pc_band(8 bits, high)  ++  hilbert_d4canon(occupancy)  ++  hash_tiebreak(low)
  ```

  - `pc_band` = available popcount (or a coarse bucket of it) — the strongest, *provably*
    locality-preserving coordinate (every parent and child differ by exactly one in pc; reuse
    is overwhelmingly intra-band; the deep store only holds pc ≳ 24 anyway).
  - `hilbert_d4canon` = a **Hilbert-curve index over the D4-canonical occupancy bitmask's
    centre-of-mass + low-order region descriptor** — siblings/cousins that survive into the
    same band land in nearby Hilbert cells because they share most of their occupancy.
  - `hash_tiebreak` = `hash128`'s fingerprint in the low bits — uniform fill *within* a block,
    so a block is densely packed and the BuRR/value layer underneath stays balanced.

- **The sidecar:** sort the deep store by `routing_key`; cut it into **fixed ~256 KB–1 MB
  blocks** (the NVMe-efficient transfer unit, far above the 4 KB random-read floor); a **Syzygy-style
  two-level sparse index** (resident, a few hundred KB) maps `routing_key → block`; one `pread`
  loads a whole block, delivering the band-neighbourhood of the probed key. **The BuRR ribbon is
  the value payload *inside* each block**; the routing key is the block-selection layer *over* it.
  This **eliminates the O(S) segment-Bloom walk** (the RocksDB-eval's whole premise) by routing to
  exactly one block by key-range, the way an LSM routes by fence-keys — but with a key whose ranges
  are *locality-bearing*, so one block-load amortises across the whole gather, not just the one key.

- **The metric to optimise = the locality factor L** = useful entries delivered per block-load =
  (intra-block reuse-hit edges) / (block-loads). The reuse-locality instrument should measure L
  directly for each candidate key. **Target: L ≳ 16–32** (one block-load serves a node's whole
  child-gather), which would convert the ~250–16,000× read-amplification into a ~16–32× *useful*
  read and recover one-to-two orders of magnitude of effective IOPS.

- **The structural key is also a STORAGE-SHRINK lever, not only a range-read lever (§6A).** Because
  it is bijective/sorted (not hashed), it (a) needs ~½ the bits of the collision-safe 54-bit
  fingerprint and is **collision-free** (exact verdict, no 2^-54 caveat), (b) **front-codes within a
  block** (sorted ⇒ shared prefixes ⇒ ~5–11 bits/key), and (c) for **dense deep slices** drops keys
  **entirely** via a direct-indexed compressed bitmap (~1–2 keyless bits/position — *below* BuRR's
  ~2–3 + its ~15 GB resident Bloom). **This reshapes the BuRR decision:** a sorted structural store
  with per-slice tiering (dense→bitmap, medium→front-coded, sparse→MPHF/BuRR) **matches/beats BuRR on
  density while ALSO being routable (no O(S) walk) and range-readable** — it subsumes BuRR as the
  sparse-tier special case. The deep bands (pc ≳ 24, near-terminal, low branching) are structurally
  *dense*, which is exactly where the bitmap floor pays — to be confirmed by the density instrument.

- **Biggest risk:** the surviving locality may be too weak — if reuse is dominated by *long-range*
  transpositions (a position reached from two distant openings), no occupancy-space ordering
  clusters them, and only the pc-band coordinate pays. **That is exactly what the instrument must
  measure before any build** (§7). The pc-band coordinate alone is a guaranteed floor (L ≈ the mean
  band-fanout that fits a block); Hilbert-over-canon is the upside we must verify. The *second* risk
  is dense-tier reachability (§6A.4): if deep slices are sparser than the structural prior suggests,
  the bitmap floor is unavailable and we fall back to front-coded medium tier (still Bloom-free and
  routable — still beating BuRR on RAM + routing, just not on dense-band density).

---

## 1. Problem statement and the physics

### 1.0 ★ The cost model is INVERTED vs n=16 — a lookup costs ~1000× a recompute

**This is the most important fact in the document and it overrides the project's n=16 performance
intuition.** At n=16 the TT lived in RAM: a lookup (~100 ns DRAM, often warm in L3) and a recompute
(the bounded getK leaf sweep, ~ns–tens of ns) were within ~10× of each other, so the search was
DRAM-latency/transposition-bound, per-node micro-opts washed out, and "store the result to avoid
recomputing" was nearly free. **At n=18 the deep store is on NVMe: a cold random point-read is
~80–100 µs, while a getK recompute of a near-terminal node is ~tens of ns — a ~1000× gap** (measured
and recorded in the n=18 umbrella: "disk-read ≫ getK-sweep ~1000×, vs ~10× when n=16 was
RAM-resident"). Every conclusion that assumed "lookup ≈ compute" flips:

1. **Store far less; recompute far more.** The break-even "store-vs-recompute" threshold moves
   drastically toward recompute. A node is worth storing only if its expected reuse × (per-lookup
   saving) beats its storage + *every future lookup's* cost. At 1000×, that is true only for nodes
   with **high in-degree AND an expensive (deep) recompute** — i.e. the deep bands. The near-frontier
   (pc 18–23, ~79% of all probes, nw≈0, children all getK leaves) is the *opposite*: cheap to
   recompute, so storing it is **net-negative** (the umbrella's measured "skip 18–21 = 51% of probe
   mass eliminated, cascade 0.04 ≈ FREE"). **The skip-the-near-frontier decision is not an
   optimization here — it is forced by the 1000× inversion**, and it is what shrinks the stored set to
   the deep, high-reuse remainder this key serves.

2. **A miss is pure loss — paid 1000×, learned nothing.** A lookup that block-loads and finds the key
   absent costs the full NVMe latency and then you recompute anyway. So **membership-before-fetch is
   worth ~1000× a recompute to get right** — but as a *cheap resident per-slice/per-block* filter, not
   the O(S) Bloom walk (which pays S filter-checks per probe). The locality key's sparse index already
   gives O(1) routing to the one block; a single per-block presence bit / tiny filter then gates the
   pread. (This is also why the structural store's *dense bitmap tier* (§6A.4) is ideal: it encodes
   presence-and-value together, so "is it stored?" and "what is it?" are one O(1) in-slice index — no
   separate membership probe.)

3. **The locality factor L is worth ~1000× more than at n=16.** Every block-load avoided (by serving a
   whole gather from one read) saves not "a few cache misses" but ~1000 recompute-equivalents of
   NVMe latency. L is no longer a nice-to-have throughput tweak; **it is the dominant term in the
   wall-clock model.** Amortizing one NVMe read across a gather of 16–32 is the difference between an
   IOPS-bound crawl and a viable solve.

4. **Idle CPU should recompute, not wait.** n=16 found the box memory-starved with cores idle. At n=18
   the cores are idle waiting on the 56K-IOPS NVMe wall — but recompute is cheap and embarrassingly
   parallel. **Prefer recomputing a near-frontier subtree on an idle core over issuing a scattered
   point-read for it.** Disk reads should be spent only on the deep, expensive, high-reuse nodes that
   the locality key gathers into shared blocks; everything else the CPU regenerates.

**Net effect on this document:** the inversion *strengthens* the core recommendation (skip-near-frontier
+ locality-key-the-deep-remainder is now mandatory, not optional), raises the stakes on L and on
membership-gating, and makes the **dense-bitmap structural tier (§6A.4) the single highest-value
component** (it fuses membership + value + zero-key density + O(1) in-slice lookup, eliminating the
miss-penalty and the per-key overhead at once). The block sidecar and per-gather prefetch (§4) are no
longer latency-hiding niceties — they are the mechanism that keeps the 1000×-expensive reads rare and
amortized. Read the rest of the document with "every avoided/mis-targeted disk read = ~1000 wasted
recomputes" as the cost unit.

### 1.0.1 ★ The governing principle: PAY COMPUTE TO STORE LESS AND LOOK UP LESS

The 1000× inversion crystallizes into one design rule that should be applied everywhere: **spend CPU
freely if it shrinks the stored set or avoids a disk lookup.** Compute is the abundant, parallel,
~ns–µs resource; a disk lookup is the scarce, IOPS-capped, ~100 µs resource. Trade the former for the
latter at up to ~1000:1 and still win. This *reverses several n=16 verdicts* that were rejected purely
on compute cost — a cost basis that no longer holds:

1. **Use a STRONGER, more-merging canonical key — even an expensive one.** At n=16 the full graph-iso
   key cost ~100× the D4 key and *lost* (the banked "iso-key cost" result: ~2.2× slower despite 3.4×
   fewer nodes, because compute dominated). **At n=18 that verdict inverts:** a costlier key that
   merges more positions ⇒ a smaller stored set ⇒ fewer distinct deep entries ⇒ fewer cold lookups
   *and* a denser store. If a heavier canon (full WL/IR graph-iso on the deep available-graph, or the
   twin-class key of §6B) cuts the deep distinct count by even 1.5–2×, paying 100× the key-compute is
   trivially worth it against the 1000×-cost lookups it removes. **Re-test the iso-key / stronger-canon
   merge specifically on the DEEP stored bands** (not the shallow tail where it was measured) — the
   compute basis that killed it is gone.

2. **Recompute DEEPER, not just getK leaves.** The skip frontier need not stop where getK leaves do. On
   a lookup miss (or to avoid storing a band), recompute a *deeper* subtree on the fly — a few
   microseconds of CPU — rather than issue a chain of cold point-reads into it. Tune the skip band
   `[18, pc*]` *upward* (store even less) as long as the recompute cascade stays bounded (the
   umbrella's cascade metric: skip 18–21 = 0.04 free, 18–24 = 0.43, 18–30 = 2.07 cascades). The 1000×
   gap buys a lot of cascade headroom — the cost/benefit crossover is far deeper than n=16's would be.

3. **Pay compute to densify the store (rank/unrank, bitmap tier, heavier block compression).** The
   structural rank (§6A.2 route R), the in-slice density computation (§6A.4), and heavier per-block
   compression (front-coding, even a small arithmetic/range coder over the value+gap stream) all cost
   CPU on the write path and a little on decode — and all shrink the store and/or raise L. At 1000:1
   they are free. Larger blocks with heavier compression (pay decode CPU to unpack more useful entries
   per single read) directly raise L; do it.

4. **Decide fetch-vs-recompute per child, spending CPU to avoid the read.** In the gather, a child that
   is shallow/cheap (near-frontier, nw≈0) should be **recomputed, never fetched** — the recompute is
   ~1000× cheaper than the read it replaces. Only deep, high-in-degree children (the ones the locality
   key gathers into a shared block) are worth a disk read, and then only one block-load for the whole
   shared set. This is a per-child policy the move loop can apply for free (it already computes each
   child's pc and descriptor).

5. **Revisit the parked component-nimber / decomposition levers under the new basis.** The
   `queens-component-nimber` branch was parked because the cutoff-free nimber recursion was 6.6× the
   wall despite −74% nodes — a *compute* cost. With compute now ~1000× cheaper than the lookups the
   node-cut removes, **a decomposition that cuts the stored deep set by −74% could be a massive win even
   at 6.6× the per-node compute** — the arithmetic flips. This is a multi-session lever, but the n=18
   cost basis is the first reason it might actually pay; re-evaluate it (and Kobayashi's modular-value
   combination, §6B) as *store-shrinkers*, measured by deep-distinct-count reduction, not by n=16 wall.

**The rule in one line:** at n=18, *node count is no longer the cost — distinct STORED entries and
cold LOOKUPS are the cost*; burn compute without hesitation to reduce either. Every lever in this
document (stronger canon, deeper skip, structural density, per-gather batching, membership-gating)
is an instance of spending the cheap resource to conserve the scarce one.

### 1.1 The regime

n=18, squares indexed `r*18+c ∈ [0,324)`, a position = the set of placed queens (equivalently the
available mask `board & !blocked`). The board bitset is `Bits = [u64; WORDS]` (`bits.rs`); at n=18,
`WORDS = 6` (384 bits), so a raw canonical key is 384 bits. Available-popcount `pc` decreases
monotonically as queens are placed (every move clears ≥1 available square; the moved square plus all
newly-attacked squares leave the available set).

- Distinct deep set: ~2–5 billion entries (pc ≳ 24, the bands we *store*; the near-frontier bands
  pc < 24 are skipped and recomputed by the bounded getK leaf-evaluator sweep — see the iso-dense
  W_K hierarchy).
- Value: 1–2 bits (win / loss / unknown). Write-once during the solve, read-many.
- Storage: NVMe-backed ZFS pool (1.4 TB). Random 4 KB reads cap ~56K IOPS (measured pool ceiling).
- **Read amplification today:** a TT value is ~1.5 bits; a random 4 KB block read fetches 32,768
  bits ⇒ **~21,800× amplification** if exactly one useful value per block, up to the ~250–16,000×
  range the task cites depending on block granularity and packing. *The entire game is to raise the
  useful-bits-per-block ratio.*

### 1.2 The lever, stated as one number

Define the **locality factor**

```
L  =  (useful TT entries consumed from a block, before it is evicted)
      ─────────────────────────────────────────────────────────────
                    (number of block-loads)
```

Every NVMe latency (~80–100 µs cold on this pool) is paid once per block-load. If a block-load
delivers L useful entries, the *effective* per-useful-entry latency is `latency / L`. At L = 1 we
have today's pathology. At L = 16–32 we have amortised the NVMe wall down to DRAM-ish effective
latency for the gather. **L is the single figure of merit; rank every key by its predicted/measured
L.** This is the same quantity Korf calls "nodes per file read", Syzygy calls "positions per
decompressed block", and SDD formalises as the duplicate-detection-scope hit density.

### 1.3 Where the useful entries come from — the gather and the band

Two reuse structures generate the "fetched-together" set:

1. **The child gather (intra-node).** At a deep node the solver enumerates `nw ≈ 16–32` children
   (one per available move) and probes the TT for each. These `nw` probes happen within microseconds
   of each other. If they live in one block, **one block-load serves the whole gather** ⇒ L ≈ nw.
   This is the *primary, exploitable* locality, and it is what an α-β move loop most wants prefetched.

2. **The band / subtree neighbourhood (inter-node).** Nodes at the same pc, in the same region of
   the search, reuse each other's results via transposition. Korf's HBDDD and SDD both exploit
   exactly this: states that *could* be duplicates are routed to the same partition. For us the
   partition that provably contains the duplicates of a node's children is **the pc-1 band**, and
   within it the region of occupancy space near the parent.

The child gather is the bird in the hand (guaranteed structure: children share the parent's
occupancy minus one queen). The band neighbourhood is the bird in the bush (depends on how
transpositions distribute — the thing §7 must measure).

---

## 2. The crux: canonicalisation vs locality (the make-or-break analysis)

### 2.1 What canon does, exactly

`canon(mask)` (`geom.rs:172`) returns the lexicographically smallest image of the available mask
under the board's 8 dihedral symmetries `sym[1..8]` (`geom.rs`, built in `Geom::new`). `pos_key`
canonicalises the *available* squares (fewer bits set deep in the tree, so cheaper) and the result
feeds `hash128` (`tt.rs:1003`), which produces `(route, fp)` — `route` scatters the position
uniformly across slots (good for a hash TT, fatal for locality), `fp` is the stored fingerprint.

There is also the **selective graph-iso key** (`graph.rs`, `iso_key_*`): for small available graphs
(`pc ≤ KEY_MAX`, default 7) the key is a canonical form of the *available graph* (Node-Kayles
equivalence), merging positions that are graph-isomorphic even when not board-symmetric. **This
merges MORE than D4** and is even more locality-hostile (two boards with nothing geometric in common
hash to the same key). But it applies only at small pc — *below* the deep bands we store — so for
the deep store the relevant canon is **D4 lex-min on the available mask**.

### 2.2 Why the naive "sibling prefix" hope fails — proven

**Claim under test:** "Siblings share the parent's placed-queen prefix and differ by one move, so a
key = sorted placed-queen list (or occupancy bitmask) clusters them." This is the task's first
candidate, and it is the intuitive one. **It fails under canonicalisation, and here is exactly why.**

Take a parent available mask `A`. Its children are `A \ N[q]` for each available move `q` (placing a
queen clears the queen's square and all squares it newly attacks). Before canonicalisation, the
children's occupancy bitmasks are indeed near-identical to `A`'s — they differ in a localised region
(the placed queen and its rays). **But each child is then independently re-canonicalised:**
`canon(child)` picks the lex-min over 8 symmetries. Two siblings can have their lex-min achieved by
**different elements of D4** — sibling X's canonical orientation might be the 90°-rotation, sibling
Y's the horizontal flip. After that, X's and Y's canonical bitmasks are images under *different*
transforms of two already-slightly-different masks. **Their occupancy bitmasks (and any lexicographic
or space-filling ordinal over them) can diverge arbitrarily.** The shared prefix is destroyed not by
the hash but by the *symmetry selection step that precedes it*.

This is the precise mechanism the task flags ("after independent D4-canonicalization, may land in
DIFFERENT symmetry orbits → their keys scatter"). It is structural, not a hashing artefact, so
turning off the hash does not fix it.

**Quantitatively:** D4 has order 8. A generic deep position has trivial automorphism group, so its
orbit has 8 distinct images and canon picks one. The probability that two independently-canonicalised
siblings happen to select the *same* group element (and thus stay near-adjacent in occupancy space)
is governed by which image is lex-min — for near-random deep occupancy this is ≈ uniform over the 8,
so **≈ 7/8 of sibling pairs land in a different orientation** and scatter under any occupancy-ordering
key. A placed-queen-prefix key therefore delivers L ≈ 1 + (1/8)·(extra) — essentially no clustering.
**Candidate #1 is dead as a *sole* locality mechanism** (kept only as a within-block tiebreak, where
it is harmless).

### 2.3 The three escape routes, evaluated

**(a) Canonicalise the PARENT, express children relative to the parent's fixed orientation.**
Idea: don't re-canonicalise each child; instead store children under the parent's chosen orientation,
so they keep the shared prefix. *Verdict: breaks global sharing — fatal.* The whole value of a TT is
that the SAME position reached via a DIFFERENT parent/move-order hits the SAME entry. If a position's
key depends on which parent's orientation it was reached through, the same position gets multiple keys
(one per parent orientation), the transposition merge collapses, and the re-expansion explodes (the
project has measured exactly this class of regression: the n=12 re-exp invariant, and the +94%
sorted-wave node blow-up when consumer move-order was disturbed). This route trades the only thing
that makes the store worth having. **Rejected.**

**(b) An order-preserving / monotonic canonicalisation.** Idea: find a canonical form whose *ordering*
is preserved by the move operator — i.e. a canonical labelling where parent→child stays adjacent. *Verdict:
provably unavailable in general.* D4 lex-min is the canonical form precisely *because* it is a min over
an orbit; min-over-orbit is not order-compatible with the "remove a queen and its rays" operator (the
operator does not commute with the symmetry selection). There is no total order on D4-orbits under
which the queen-placement operator is monotone — the symmetry group acts non-trivially on the occupancy
lattice and the min-selection is a non-monotone projection. (This is the same obstruction that makes
graph-canonical-form ordering not respect edge deletion in general; cf. the WL/IR canon in `graph.rs`,
which is a *certificate*, deliberately not order-preserving.) **Rejected as a clean solution**, though
a *weak* approximate version survives as (c).

**(c) Accept partial locality — cluster by the INVARIANT coordinates, not the path.** This is the
winner. The insight: **drop the demand that parent→child be adjacent, and instead cluster by
properties that are (i) invariant under D4 and (ii) shared by transposition-equivalent reuse.** The
strongest such coordinate is **available popcount `pc`** — it is *exactly* D4-invariant (symmetry
permutes squares, preserves popcount), it is the band coordinate the reuse structure already follows
(transpositions are intra-band: a position has a fixed pc regardless of how it was reached), and it
is the dimension the deep store is already sliced on (we store pc ≳ 24). Within a band, a **canonical
geometric descriptor** (a D4-invariant occupancy summary fed through a Hilbert curve, §3.3) recovers
the residual spatial locality: two positions that share most of their occupied region — whether
siblings, cousins, or transpositions — have nearby descriptors because the descriptor is computed on
the *canonical* mask, so both have already been mapped to the same orientation before the descriptor
is read. **The canon step that scatters the prefix key is the same step that ALIGNS the descriptor
key** — that is the resolution.

### 2.4 The resolution, stated cleanly

> Compute `canon(mask)` once (for correctness/sharing — unchanged from today). From the *canonical
> representative* derive the routing key as `pc-band ++ Hilbert(canonical occupancy descriptor) ++
> fp-tiebreak`. Canon is no longer the enemy of locality: because both the routing descriptor and
> the value fingerprint are read off the *same canonical bitmask*, two positions that are
> D4-equivalent get identical routing keys (they share the block) and two positions that are merely
> *geometrically close after canonicalisation* get nearby routing keys (they share a block-load).
> The hash's scatter is confined to the **low** tiebreak bits, where it balances block fill without
> moving entries across blocks.

The remaining open question is empirical, not structural: **how much spatial locality survives in the
canonical occupancy descriptor for THIS DAG's reuse edges?** §7 measures it. The pc-band coordinate is
a hard floor that pays regardless; Hilbert-over-canon is the measured upside.

---

## 3. Candidate key constructions, designed and ranked

All candidates produce a total-order routing ordinal; the store is sorted by it and blocked. They
differ in how they spend the bits between *locality* (high bits, coarse, clustered) and *uniformity*
(low bits, fine, scattered). I evaluate each on: **gather clustering** (do a node's children share a
block?), **subtree/band clustering**, **bucket-population uniformity** (does any block overflow?), and
the resolved **L**.

### 3.1 Candidate A — lexicographic placed-queen-set / occupancy bitmask (the naive baseline)

`key = the canonical occupancy bitmask interpreted as a 384-bit big-endian integer` (or the sorted
placed-queen list). **Gather clustering: poor** — §2.2, siblings re-canonicalise into different
orbits; even within an orbit, lexicographic order on a bitmask clusters by the *high* squares only, so
two positions differing in a low square are far apart while two differing in a high square are
adjacent — anisotropic and weak. **Band clustering: accidental.** **Uniformity: terrible** — real
occupancy masks are wildly non-uniform (legal queen configurations cluster), so lexicographic blocks
have orders-of-magnitude population skew ⇒ some blocks overflow, some are empty. **L ≈ 1–2.**
*Role: rejected as primary; the bitmask is reused only as the within-block tiebreak in A-variants.*

### 3.2 Candidate B — Z-order (Morton) over an occupancy feature vector

Interleave the bits of a small canonical feature vector — e.g. `(centre-of-mass row, centre-of-mass
col, pc, a coarse quadrant-occupancy histogram)`. Morton is trivially cheap (bit-interleave). **Gather
clustering: moderate** — children share most of the parent's occupancy, so their feature vectors are
close, and Morton keeps *most* close points close. **But Morton's quadrant-boundary jumps** (Moon et
al. 2001; the "Z" teleports from the top-right of one quadrant to the bottom-left of the next) fragment
a compact query region into many runs — a node's gather that straddles a Morton boundary splits across
2–4 blocks. **Band clustering: good if pc is a high coordinate.** **Uniformity: good** (feature-vector
space is denser/more uniform than raw occupancy). **L ≈ 8–16.** *Role: viable; strictly dominated by C.*

### 3.3 Candidate C — Hilbert curve over a canonical occupancy descriptor (RECOMMENDED core)

Same feature-vector idea as B, but order it by a **Hilbert** index instead of Morton. Hilbert is
*fully continuous* — consecutive indices are always spatial neighbours, no jumps — so a compact query
region maps to **far fewer, longer runs**. Moon, Jagadish, Faloutsos & Saltz (*Analysis of the
Clustering Properties of the Hilbert Space-Filling Curve*, IEEE TKDE 13(1):124–141, 2001) prove the
expected number of clusters (runs) for a query region is asymptotically proportional to its **surface
area (perimeter in 2-D), not its volume**, and that Hilbert strictly dominates Z-order (Morton adds
Θ(extra) clusters per quadrant-boundary crossing). For a node's gather — a compact blob in
feature-space — Hilbert yields ~½ the runs of Morton, so a gather that Morton splits into 3–4 blocks
Hilbert keeps in 1–2.

**The descriptor (what we run the curve over) — D4-invariant by construction:**

- **Coordinate 0 (highest): pc-band** — `pc` (or `pc >> b` for a coarse band). Provably
  D4-invariant; the dominant reuse axis. *This alone is the floor (§3.7).*
- **Coordinates 1–2: canonical centre-of-mass** of the available squares, computed on the
  *canonical* mask (so D4-fixed): `(Σr)/pc, (Σc)/pc` quantised to a small grid (e.g. 18×18 → or a
  coarser 8×8). Positions with similar occupancy have similar centroids.
- **Coordinate 3: a coarse region descriptor** — e.g. a 4×4 super-cell occupancy histogram of the
  canonical mask, quantised, capturing *where* the queens are without the full bitmask. Two positions
  that differ by one queen differ in one histogram cell ⇒ adjacent.

Hilbert-index this 3–4-D descriptor → the high bits of the routing key. **Gather clustering: strong**
(children differ in ≤1 histogram cell + a centroid nudge ⇒ ≤1 Hilbert run). **Band clustering: strong**
(pc is coordinate 0). **Uniformity: good** (descriptor space is much smoother than raw occupancy; a
within-block fp-tiebreak finishes the balancing). **L ≈ 16–32 if the band hypothesis holds.** *Role:
the recommended core.*

### 3.4 Candidate D — "place-k-queen prefix" key (high bits = canonical opening prefix)

`key = canon_prefix(first k placed queens) ++ hash(rest)`. The first k queens of the canonical line
fix a coarse region; the rest hash uniformly within it. **This is a real, tunable knob** but it
inherits §2.2's disease in a milder form: the "first k placed queens" must themselves be defined
*canonically* (else move-order breaks sharing), and a canonical opening prefix is only stable for the
*shallow* part of the tree — by the deep bands (pc ≳ 24, i.e. ~10–14 queens placed on n=18) the
"opening prefix" is many plies back and a single position is reached through *many* openings
(transposition), so there is no single canonical prefix to key on without re-introducing path-dependence.
**Gather clustering: moderate-to-poor at depth** (the prefix is stale; the gather lives in the `hash(rest)`
part = scatter). **Band clustering: poor.** **Uniformity: tunable via k.** **L ≈ 2–6.** *Role:
inferior to C for the deep store; its one virtue — a coarse, cheap, resident prefix → block map —
is better served by C's pc-band + centroid coordinates, which ARE canonical and depth-stable.*

The **right value of k** if one insisted on D: k ≈ the number of queens whose placement is forced/
near-forced by the canonical static order (`Geom::order`, descending attack degree) — empirically
2–3 on these boards. Beyond that the prefix stops being shared. But C subsumes this: C's centroid +
histogram *is* a depth-stable, transposition-robust generalisation of a fixed opening prefix.

### 3.5 Candidate E — Hybrid prefix(locality) ++ hash(uniform-within-block) — the GENERAL FORM

This is the family the recommendation lives in, with C as the "prefix" = the Hilbert-over-canon
descriptor and the hash as the low tiebreak:

```
routing_key  =  [ pc_band : 8 ]  ++  [ hilbert_descriptor : 32–40 ]  ++  [ hash_fp : low ]
                └──── locality (clusters gathers + bands) ────┘        └─ within-block balance ─┘
```

The split point is the **block boundary**: everything above the low ~`log2(block_entries)` bits
selects the block (locality-bearing); the low bits scatter *within* the block (uniformity, so the
block packs densely and the BuRR value layer underneath sees a near-uniform key subset). **This is
exactly the RocksDB prefix-bloom shape** (a locality-bearing prefix routes/skips blocks; the suffix is
arbitrary) and the Nalimov/Syzygy shape (a dense combinatorial index routes to a block; decompression
handles within-block). **L = C's L, with guaranteed block balance.** *Role: the recommended construction
— C is its locality half.*

### 3.6 Ranking table

| # | Key | Gather cluster | Band cluster | Uniformity | Predicted L | Verdict |
|---|----------------------------------------|----------------|--------------|------------|-------------|---------|
| **E** | **pc-band ++ Hilbert(canon descriptor) ++ fp** | **strong** | **strong** | **good** | **16–32** | **RECOMMENDED** |
| C | Hilbert(canon descriptor) [E's core] | strong | strong | good | 16–32 | core of E |
| B | Morton(canon feature vector) | moderate | good | good | 8–16 | viable, dominated by C |
| D | place-k-queen prefix ++ hash | moderate→poor | poor | tunable | 2–6 | inferior at depth |
| A | lexicographic occupancy bitmask | poor | accidental | terrible | 1–2 | tiebreak only |
| — | `hash128` (today) | none (by design) | none | perfect | 1 | the baseline to beat |

### 3.7 The guaranteed floor (de-risks the whole proposal)

Even if every geometric coordinate turns out worthless (reuse is pure long-range transposition with no
occupancy locality), **the pc-band coordinate alone still pays**, because:

- The deep store is sliced into pc-bands anyway (pc ≳ 24, ~a dozen bands).
- A node's child gather is *entirely* in the pc-1 band (every child has pc-1 ≤ pc' ≤ pc-1... actually
  exactly the children's pc's cluster in a 1–3 wide window below the parent's pc, since one move
  clears the queen + its newly-attacked rays). So **routing by pc-band already co-locates the gather's
  target band**, and within a band even a *random* layout gives L = (block_entries / band_entries) ·
  (gather size) — i.e. if a band's entries fit in a handful of blocks, the gather is served by a
  handful of block-loads regardless of intra-band order.
- This is the **HBDDD `hash1` guarantee** (Korf): route every potential-duplicate into the same
  partition; the partition (here the band) bounds the scope. It is unconditional.

So the proposal cannot do *worse* than "band-partitioned store, random within band" — already a large
win over today's fully-scattered hash — and the Hilbert descriptor is pure upside on top.

---

## 4. The block-loading sidecar mechanism

### 4.1 Layout: sorted-by-routing-key, fixed blocks, sparse index

Three layers, mirroring Syzygy (the cleanest template for compressed variable-fill blocks) and RocksDB
BlockBasedTable:

```
  on-disk sidecar (ZFS pool file, one per pc-band or one global, append-only/frozen):

   ┌───────── block 0 ──────────┬──── block 1 ────┬─ … ─┬──── block B ────┬─ meta ─┐
   │ entries sorted by routing  │      …          │     │       …          │ index  │
   │ key, BuRR ribbon payload   │                 │     │                  │ + foot │
   └────────────────────────────┴─────────────────┴─────┴──────────────────┴────────┘

  resident (RAM): the SPARSE INDEX — one entry per block:
     [ first_routing_key_of_block : u64 ]  →  [ block file offset : u48, block length : u24 ]
```

- **Sorted order = routing-key order** (§3 candidate E). Sibling/band entries are physically adjacent.
- **Block = a contiguous routing-key range.** Fixed *byte* size (below), variable *entry* count
  (because the BuRR ribbon + value packing is variable-rate), exactly like Syzygy's RE-PAIR blocks —
  hence the need for a sparse index rather than arithmetic addressing.
- **Sparse index (resident).** One `(first_key, offset, len)` per block. With ~256 KB blocks over a
  ~5 B-entry / ~few-hundred-GB store, that is ~1–2 M blocks × 16 B ≈ **16–32 MB resident** — trivial,
  stays hot in L3/DRAM, replaces the ~15 GB of segment Blooms with a far smaller, O(1)-routing
  structure. (If even that is too big, a two-level index à la RocksDB `kTwoLevelIndexSearch` /
  Syzygy's `idxbits` sparse-of-sparse halves it again.)
- **Probe:** `block = upper_bound(sparse_index, routing_key) - 1`; one `pread(offset, len)`;
  decode the BuRR ribbon for that block; extract the value. **One block-load per probe, O(log B)
  resident binary search, ZERO O(S) segment walk.** This is the structural fix the RocksDB-eval wants,
  achieved in-house and with a *locality-bearing* range (RocksDB's fence-keys would be over the scatter
  hash and give locality = 0).

### 4.2 Block size — analyse the three scales

The task asks whether to target L3 (tens of MB), DRAM page, or NVMe transfer unit. They serve
different purposes; pick the **NVMe-efficient transfer unit** for the on-disk block, and let the OS/ARC
and the gather-prefetch handle the larger scales:

- **4 KB (ZFS recordsize floor / random-read unit):** too small. The whole point is to read *more*
  than the random-read unit per latency. A 4 KB block holds ~maybe a few hundred packed entries but
  pays full random-read latency for each — L stays low.
- **128 KB–1 MB (NVMe-efficient sequential transfer; ZFS recordsize is tunable to 1 MB):** **the
  sweet spot.** At ~256 KB–1 MB, a single `pread` runs at near-sequential bandwidth (the pool does
  GB/s sequential vs 56K × 4 KB ≈ 224 MB/s random), and one read delivers thousands of packed entries
  — enough to contain a node's whole gather *and* its band-neighbourhood. This is the analogue of
  Nalimov's 8 KiB block scaled up for a modern NVMe (Nalimov's 8 KiB was sized for 2000-era disks).
  **Recommend 256 KB on-disk blocks** (tunable; A/B 64 KB / 256 KB / 1 MB).
- **Tens of MB (L3):** this is the *working-set residency* scale, not the I/O scale. Several recently
  block-loaded 256 KB blocks naturally coexist in L3 (32–96 MB on the Zen5 box); we don't read at this
  granularity, we *accumulate* it. A small in-process LRU of decoded blocks (a few hundred MB anon
  budget) holds the active gather + band working set, so repeat probes within a band hit warm.

So: **on-disk block = 256 KB (NVMe unit); decoded-block LRU = a few hundred MB (DRAM/L3 residency);
sparse index = ~16–32 MB (always resident).** Three scales, three structures, composed.

### 4.3 Key → block → disk-offset mapping

- **Implicit/arithmetic is impossible** (variable entry-count per block from BuRR compression) → use
  the **explicit sparse index** (§4.1). It is the static read-only case, so it can be a flat sorted
  `[u64 first_key][u48 off][u24 len]` array, binary-searched — or, since the key set is *static after
  the solve's write phase*, an MPHF/fence array. During the solve (write phase) the store is
  append-only frozen segments (the existing BuRR freeze), so the index is built incrementally as
  blocks are sealed.
- **Within a band**, the routing key's high bits are constant, so a per-band sub-index over just the
  Hilbert-descriptor bits is even smaller and denser — natural if we keep one sidecar file per pc-band
  (which also makes the band the unit of freeze/snapshot, aligning with the existing per-segment
  resume).

### 4.4 Prefetch policy — load the gather's block ahead of the descent

The α-β move loop knows the gather *before* it probes it (it enumerates children to order them — the
counting-sort move ordering already materialises the child masks). So:

1. Compute all `nw` children's routing keys up front (cheap: pc-1 is known, the Hilbert descriptor is a
   small popcount/centroid update from the parent's).
2. They cluster (by construction) into 1–few blocks. Issue an **async block prefetch** (`io_uring`
   readahead, or a background pread thread) for those blocks *before* the move loop body runs.
3. By the time the loop probes child i, its block is resident. **The gather's NVMe latency is paid
   once, in parallel with the move-ordering compute, not nw times serially.**

This is the Syzygy/Nalimov "decompress one block, answer many probes from it" pattern, plus the
LSM/Korf "prefetch the partition you're about to scan". Note the n=18 umbrella already found
*frontier* io_uring prefetch a regression (`QUEENS_PF_URING`, "async frontier prefetch ~20–40%
regression") — **but that was prefetching scattered hash slots** (each prefetch a different random
4 KB, no amortisation). Prefetching a *locality block* is a different operation: one prefetch covers
the whole gather. The locality key is what makes prefetch finally pay.

### 4.5 OS page cache / ZFS ARC — avoid double-buffering

The umbrella's session --9 already learned this: **mmap caused a 108K/s major-fault storm + 88% ARC
miss; pread fixed it (ARC miss → 24%)**. Carry that forward:

- **Use `pread` (or `io_uring` read), not mmap**, for block-loads. The decoded-block LRU is our cache;
  we do not want the page cache to also cache the *raw compressed* blocks (double-buffer) nor to fault
  us page-by-page through a 256 KB block.
- **Cap ZFS ARC low** (the box-hygiene rule, `zfs_arc_max` ≈ 2 GB) so ARC doesn't evict our resident
  sparse index + decoded-block LRU. Consider `O_DIRECT` for the block reads if ARC double-buffering
  shows up in the profile — but `O_DIRECT` on ZFS is nuanced; measure pread-with-capped-ARC first
  (it's the known-good baseline). The 256 KB block aligns naturally to a 256 KB–1 MB ZFS recordset,
  so a block read is one record — no read-modify-write, no sub-record fault storm.

### 4.6 Composition with BuRR (the value-only retrieval layer)

The BuRR ribbon (`burr.rs`, `src/queens/store.rs`) is a value-only succinct retrieval structure
(~2–3 bits/key, no keys stored). It answers "value for this key" but **only for keys that were
inserted** — it has no membership and (today) needs the per-segment Bloom + the O(S) walk to know
*which* segment holds a key. **The locality routing key replaces that walk:**

- The routing key selects the **block** (deterministic, O(log B) resident, no Bloom walk).
- The BuRR ribbon is the **per-block payload**: each 256 KB block contains a small ribbon over *its*
  entries' fingerprints → values. A probe loads the block, queries its ribbon with the key's
  fingerprint, done. (A tiny per-block Bloom or the fingerprint-match handles the "key not present /
  near-frontier band we didn't store" case — but membership is now a *single* block's filter, not S.)
- This is the clean separation the RocksDB-eval is circling: **routing layer (locality key → block) +
  payload layer (BuRR ribbon, value-only)**. RocksDB would give us the routing layer with fence-keys
  but over a scatter key (locality 0) and with write-amplifying compaction; the custom locality key +
  fixed frozen blocks gives the *same* O(1) routing with locality > 0 and append-only writes (no
  compaction write-amp — the BuRR freeze is already append-only).

---

## 5. Prior art — survey and citations

(Two sub-agent literature surveys grounded the following; key sources cited inline.)

### 5.1 External-memory & disk-based search — locality by partition + sort

- **Korf, "Linear-time disk-based implicit graph search," JACM 55(6):1–40, 2008**
  (https://dl.acm.org/doi/10.1145/1455248.1455250). **Hash-based delayed duplicate detection (HBDDD)**
  uses **two orthogonal hash functions**: `hash1(state)` → *file assignment* (any two duplicates land
  in the same file — the locality-preserving partition; duplicate detection never probes outside a
  file), `hash2(state)` → in-RAM dedup within a file. The minimum memory requirement is just "largest
  bucket fits in RAM," tunable by `hash1`'s range. **This is the template for our pc-band routing**:
  our `hash1` = `pc-band` (the guaranteed-co-location partition), our within-block ribbon = the
  `hash2` payload. Korf & Schultze, "Large-Scale Parallel BFS," AAAI 2005
  (https://cdn.aaai.org/AAAI/2005/AAAI05-219.pdf): the concrete 15-puzzle partition — file named by
  the blank+tiles-1,2,3 positions (a perfect index, 21,852 files after symmetry), within-file a 28-bit
  *perfect hash* + 4-bit frontier bits = 32 bits/node, **no keys stored** (the MPHF-over-dense-index
  idea, identical in spirit to our BuRR-over-block).
- **Zhou & Hansen, "Structured Duplicate Detection," AAAI 2004**
  (https://cdn.aaai.org/AAAI/2004/AAAI04-108.pdf). Formalises the **duplicate-detection scope** via a
  state-space abstraction `p(·)`: the union of nblocks reachable in the *abstract* graph contains all
  duplicates of a node's successors (their Theorem 1), so only that scope need be resident. **Our
  pc-band IS such an abstraction** (`p(position) = pc`), and its abstract graph is a path (band k →
  band k-1), the simplest possible local structure — bounded out-degree 1, so the scope of a node is
  one neighbouring band. Cut RAM 16×–58× at +24% time on the 15-puzzle.
- **General technique:** replace random duplicate-probes with **sequential block reads** by routing
  potential-duplicates into the same partition, then either *sort* the partition (sorting-based DDD,
  `O((n+m)/B · log_{M/B})` I/O; Aggarwal–Vitter 1988 I/O model) or *perfect-hash* within it. Locality
  = the partition + the in-partition order.

### 5.2 Game tablebases on disk — dense index + small block + sparse index

- **Nalimov tablebases** (https://www.chessprogramming.org/Nalimov_Tablebases; Heinz & Haworth,
  *Space-Efficient Indexing of Chess Endgame Tables*, ICGA J. 2000,
  https://centaur.reading.ac.uk/4562/). A **symmetry-folded combinatorial index** (the a1-d1-d4
  triangle = the 10-square fundamental domain of the board's D4 group — *the same D4 we fold*) maps a
  position to a dense offset; data compressed into **8 KiB Huffman blocks** with an LRU block cache; a
  probe decompresses one block. Dense index ⇒ near-zero wasted slots.
- **Syzygy tablebases** (Ronald de Man; https://www.chessprogramming.org/Syzygy_Bases;
  https://github.com/syzygy1/tb). **The cleanest template for our sidecar.** RE-PAIR compression +
  canonical Huffman → small **fixed 32/64-byte blocks**; a **two-level sparse index**: a 6-byte
  sparse-index entry per `2^idxbits` index-section (4-byte block number + 2-byte within-block offset)
  + a 2-byte-per-block `SizeTable` of position counts. A probe: encode position → index; sparse index
  → approximate block; walk SizeTable a few steps → exact block; decompress that one block. **One
  block per probe, sparse index resident.** De Man chose RE-PAIR over higher ratios *because probe
  decompression must be fast* — exactly our 1–2-bit-value, read-many constraint. **Our §4.1 is this,
  scaled to 256 KB NVMe blocks with a BuRR ribbon instead of RE-PAIR+Huffman.**
- **Checkers — Schaeffer et al., "Checkers Is Solved," Science 317:1518, 2007**
  (https://www.science.org/doi/10.1126/science.1144079; "Building the Checkers 10-Piece Endgame
  Databases," ACG10 2003). 3.9×10¹³-position DB sliced by `(piece signature, side-to-move, rank of the
  most-advanced checker)` — the **slice = the locality partition**, and the N-piece DB depends only on
  the (N-1)-piece DB (a bounded slice-dependency graph, like our band k → band k-1). Compressed to
  ~154 positions/byte, decompressed per-block on demand. **The slicing-by-an-invariant-then-block
  pattern is exactly our pc-band-then-block.**
- **Awari — Romein & Bal, "Solving Awari with Parallel Retrograde Analysis," IEEE Computer 36(10),
  2003** (https://research.vu.nl/en/publications/solving-the-game-of-awari-using-parallel-retrograde-analysis).
  889 billion positions, solved by **layering on the monotone stone-count** (stones never increase —
  *exactly our monotone pc*); each layer a densely-packed combinatorial-ranked array; cross-cluster
  partition by a position hash + **message combining** to amortise communication. The monotone-count
  layering is the same structural gift we have in pc.

### 5.3 Cache-oblivious & space-filling-curve layouts

- **Cache-oblivious B-trees — Bender, Demaine, Farach-Colton, FOCS 2000**
  (https://erikdemaine.org/papers/FOCS2000b/paper.pdf); ideal-cache model: Frigo, Leiserson, Prokop,
  Ramachandran, FOCS 1999 (https://dl.acm.org/doi/10.1145/2071379.2071383). The **van Emde Boas
  recursive layout** stores a search tree so a root-to-leaf path crosses `O(log_B N)` blocks *for
  every B simultaneously* — optimal at L1, L2, L3, DRAM, and disk at once, with no block-size tuning.
  *Relevance:* if we ever make the **sparse index itself** a tree (it grows if blocks shrink), lay it
  vEB so it's locality-optimal across all our three scales (§4.2) without tuning. For the flat sorted
  sparse index it's overkill, but it's the right move if the index becomes multi-level.
- **Hilbert vs Z-order — Moon, Jagadish, Faloutsos, Saltz, IEEE TKDE 13(1):124–141, 2001**
  (https://aiichironakano.github.io/cs653/Moon-HilbertCurve-TKDE01.pdf). Hilbert is continuous (no
  jumps); Z-order teleports at every quadrant boundary. **Expected clusters (runs) ∝ query-region
  perimeter, not area**, and Hilbert strictly beats Z-order. **This is the direct justification for
  Candidate C over B** — a compact gather maps to ~½ the disk runs under Hilbert.

### 5.4 Block-oriented storage indexing

- **RocksDB BlockBasedTable** (https://github.com/facebook/rocksdb/wiki/Rocksdb-BlockBasedTable-Format;
  Index Block: https://github.com/facebook/rocksdb/wiki/Index-Block-Format; Prefix Seek:
  https://github.com/facebook/rocksdb/wiki/Prefix-Seek). 4 KB data blocks of **sorted, prefix-delta-
  encoded keys + restart points**; a **separator-key index** (one entry per data block) routes a
  lookup to one block; a **prefix bloom** lets a prefix-bounded `Seek` skip whole files/blocks without
  I/O. **Two lessons:** (1) the separator-key index is precisely the O(1) routing that kills our O(S)
  walk — *the RocksDB-eval's premise is sound* — but RocksDB would route over our **scatter** key
  (locality 0) and pay **compaction write-amplification**; (2) the **prefix bloom over a
  locality-bearing prefix** is the membership-skip we want, but it only pays if the prefix is
  locality-bearing — which is exactly what our routing key provides and `hash128` does not. So: take
  RocksDB's *routing idea*, supply it our *locality key*, and keep BuRR's *append-only no-compaction*
  freeze instead of RocksDB's compaction.
- **Minimal perfect hashing for static sets:** BBHash (Limasset et al., SEA 2017, ~3 bits/key),
  RecSplit (Esposito, Graf, Vigna, ALENEX 2020, ~1.56–1.8 bits/key; lower bound 1.44 bits/key). For
  the *post-solve, read-only* sparse index or even the whole key→slot map, an MPHF gives one slot, one
  probe, zero stored keys — the densest possible. *Relevance:* if a certified final artefact is built,
  the index can be an MPHF; during the live solve the append-only sparse index is simpler.

### 5.5 Structural game-value generalization (set-based / Partition Search / FPT)

- **Kobayashi, "On Structural Parameterizations of Node Kayles," CGGG 2021** (arXiv
  [2003.11775](https://arxiv.org/abs/2003.11775);
  https://link.springer.com/chapter/10.1007/978-3-030-90048-9_8). Our exact game is FPT in vertex-cover
  number (**O\*(3^τ)**), modular-width (**O\*(1.6031^μ)**), and has a **linear kernel** in neighborhood
  diversity. The value is a function of the **module values** (bottom-up over modular decomposition)
  and of the **twin-class multiset** — the formal basis for a generalized/structural TT key (§6B).
- **Stone, Sturtevant et al., "Set-Based Retrograde Analysis," IJCAI 2025** (arXiv
  [2411.09089](https://arxiv.org/abs/2411.09089);
  https://webdocs.cs.ualberta.ca/~nathanst/papers/stone2025bridge28.pdf). Stores **sets of
  equal-valued states** as DB/TT entries (4 orders of magnitude fewer sets than states in 24-card
  Bridge), crediting **Ginsberg's Partition Search** as the predecessor (sets-as-TT-entries). The
  generalized-entry / perfectly-dense-slice idea of §6B/§6A.4.

### 5.6 What the prior art tells us to do

Every successful disk-based game solve converges on the same three-part shape, and **we already have
two of the three parts**:

| Layer | Korf | Syzygy | Checkers | Awari | **Us (recommended)** |
|------------------|----------------------|------------------------|-----------------------|----------------------|-------------------------------|
| Locality partition | `hash1` → file | (none; dense index) | `(sig, stm, rank)` slice | n-stone layer | **pc-band** ✓ (have) |
| In-partition order | (sort / perfect hash) | combinatorial index | combinatorial rank | combinatorial rank | **Hilbert(canon descriptor)** ✗ (build this) |
| Block + sparse index | file = block | 32–64 B block + 6 B sparse idx | on-demand block | packed array | **256 KB block + sparse idx** ✗ (build this) |
| Value payload | 4-bit perfect-hash slot | RE-PAIR+Huffman | homebrew compress | value array | **BuRR ribbon** ✓ (have) |

The missing pieces are exactly the **in-partition locality order** and the **block+sparse-index
routing** — this proposal's deliverable.

---

## 6. Recommendation

**Build Candidate E:** `routing_key = pc_band ++ Hilbert(canonical occupancy descriptor) ++ fp_low`,
laid out as a **sorted, 256 KB-blocked, sparse-indexed sidecar with a per-block BuRR ribbon payload**,
prefetched per-gather, read via pread with capped ARC. Concretely:

1. **Key (cheap, derived from the already-computed canon):**
   - `canon(mask)` as today (correctness/sharing unchanged).
   - `pc = popcount(available)` → top 8 bits (band).
   - Hilbert index of `(centroid_r, centroid_c, 4×4 super-cell histogram)` computed on the canonical
     mask → next ~32–40 bits.
   - `fp = hash128(canon).fp` low bits → tiebreak / within-block balance.
   - All of this is a small arithmetic update from the parent's descriptor in the move loop, so it is
     not on the latency-bound critical path (resolve the band/centroid incrementally, à la the
     incremental iso-key carry in `graph.rs`).
2. **Sidecar:** one frozen file per pc-band (aligns with the existing per-segment freeze/snapshot),
   entries sorted by the intra-band Hilbert key, cut into 256 KB blocks, each block a BuRR ribbon over
   its entries; a resident flat sparse index `(first_key → off,len)` per band (~tens of MB total).
3. **Probe:** band → band-file; binary-search the band's sparse index → block; pread 256 KB;
   ribbon-query. **No O(S) walk.**
4. **Prefetch:** compute the gather's `nw` routing keys up front; async-pread their (1–few) blocks
   before the move loop; serve all `nw` probes from the resident blocks.
5. **Decoded-block LRU** (~few hundred MB) for band working-set residency; pread + ARC capped at 2 GB.

**Expected locality:** L ≈ 16–32 *if* the band hypothesis holds (one block-load serves a node's whole
gather), with a hard floor of L ≈ (band fits in a few blocks → gather served by a few reads)
guaranteed by the pc-band coordinate alone (§3.7). That converts the ~21,800× read-amplification into
an effective ~700–1,400× *raw* but ~1× *useful-per-gather* — i.e. it recovers roughly the gather size
(16–32×) in effective IOPS, plus the band-residency reuse on top.

**Why not just RocksDB (the queued fork):** RocksDB gives O(1) routing (kills the O(S) walk — the
eval's goal) but (a) routes over whatever key we hand it — if that's the scatter `hash128`, locality
= 0 and L = 1, so it fixes the *walk* but not the *amplification*; (b) compaction re-writes data =
write-amplification on the NVMe (the eval flags this as a risk). The locality key is **complementary
to or better than** RocksDB: hand RocksDB the `routing_key` (so its fence-keys become locality-bearing
and prefix-bloom-skippable) **or** build the custom append-only blocked sidecar (no compaction
write-amp, BuRR payload reused). **Recommend prototyping the key first, measuring L (§7), THEN deciding
the container** (custom sidecar vs RocksDB-with-locality-key) — because if L is high, the simple custom
append-only sidecar wins (no compaction); if L is marginal, RocksDB's maturity/async-I/O is worth the
write-amp. The key is the load-bearing decision; the container is downstream of the measured L.

**Risks, ranked:**
1. **(make-or-break) Residual locality too weak** — reuse dominated by long-range transpositions with
   no occupancy-space proximity ⇒ Hilbert buys little over plain pc-band. *Mitigation:* the pc-band
   floor still pays (§3.7); measure L *before* building the sidecar (§7). This is the one risk that
   could sink the Hilbert half (never the band half).
2. **Descriptor collisions vs over-spread** — too coarse a descriptor over-clusters (blocks overflow,
   skew); too fine under-clusters (gather splits). *Mitigation:* the fp-tiebreak + variable-entry
   blocks absorb skew (Syzygy does exactly this); tune the histogram granularity by the instrument.
3. **Prefetch mispredicts** — if the gather's keys *don't* cluster, the per-gather prefetch degenerates
   to nw scattered reads (the known `QUEENS_PF_URING` regression). *Mitigation:* prefetch is gated on
   measured intra-gather clustering; fall back to serial-probe if a gather spans > k blocks.
4. **Write-phase sort cost** — entries arrive in search order, must be sorted into routing-key order
   per band before freezing. *Mitigation:* the BuRR freeze already buffers+sorts a memtable per
   segment; sort by routing_key there (it's already paying a sort). This is free.

---

## 6A. Structural encoding / bit-shaving — the key as a STORAGE-SHRINK lever, tiered by slice density

The locality key's value is not only range-reads. Because it is **structural** (a deterministic
function of the canonical position, not a one-way hash), it is **collision-free and order-bearing** —
two properties a hash throws away — and those are exactly the properties that let per-entry storage
shrink toward the entropy floor. This section argues that a *sorted structural store* can match or
beat BuRR's keyless density **while also being routable and range-readable**, which reshapes §6's
recommendation.

### 6A.1 The entropy floor and the hash birthday penalty

- **What we store today:** `hash128` → a ~54-bit fingerprint per slot (the project routes/keys on
  `QUEENS_BURR_FP=54`). 54 bits is not the information content of a position; it is the **birthday
  bound** — to keep collisions over `N ≈ 10–18 B ≈ 2^34` keys negligibly rare, a *random* fingerprint
  needs ≈ `2·log2(N) + safety ≈ 68 + slack`, trimmed to 54 as a measured "recompute-not-wrong"
  tolerance (a 2^-54 collision is cross-checked against Jenrich and recomputed). The hash pays roughly
  **double the entropy** because random fingerprints collide at the square-root of their space.
- **What a structural bijection needs:** the canonical position set has only `N ≈ 2^33.5` members
  (10–18 B distinct after D4 + the selective iso reduction). A **bijective rank** `position →
  [0, N)` is **collision-free by construction** and needs only `log2(N) ≈ 34 bits`, and a
  *per-band* rank needs only `log2(band_size)` — the deep bands are far smaller than N, so an
  in-band ordinal is ~25–31 bits. **A structural key is ~½–⅗ the bits of the collision-safe hash and
  has zero collision risk** (the verdict is then exact, not probabilistic — a side correctness win:
  the structural store removes the 2^-54 birthday caveat from the final artefact entirely).

So even before compression, going structural is a ~2× key-bit reduction *and* an exactness upgrade.

### 6A.2 Two routes to the structural ordinal — rank/unrank vs raw+block-compress

There are two ways to realise a structural key, with different build cost:

- **(R) Near-minimal ranking/unranking of canonical positions.** A combinatorial rank of the
  D4-canonical occupancy directly into `[0, band_size)`. This is what Nalimov/Syzygy/checkers/Awari
  all do — a **symmetry-folded combinatorial index** (Nalimov's a1-d1-d4 triangle is *our* D4
  fundamental domain; checkers ranks by piece placement within a slice; Awari ranks stone
  distributions within a layer). *Pro:* the densest possible key (the position IS its offset → the
  bitmap tier of §6A.4 becomes possible). *Con:* an exact, efficient **unrank/rank over the
  D4-canonical-AND-iso-reduced set** is non-trivial — D4 folding has the diagonal-fixed-point
  subtlety (Nalimov handles it by a special-case sub-index), and the *selective graph-iso* merge
  (`iso_key`, pc ≤ 7) is **not** a clean combinatorial object (it merges by graph isomorphism, which
  has no closed-form rank). **Resolution: rank over D4 only** (a clean, classical combinatorial index
  over the 8-fold-folded occupancy) and let the iso-merge live *below* the deep bands (it applies at
  pc ≤ 7, which we don't store anyway). For the deep store, "canonical" = D4-canonical, and D4 has a
  tractable folded rank.

- **(C) Raw structural key + block-level compression.** Skip the clever rank: use the **sorted placed-
  queen set** (or the canonical occupancy bitmask) as the raw key — ~90+ bits raw (18 squares × ~9
  bits, or the 384-bit mask) — and recover the density at the **block** level by front-coding (§6A.3)
  and the bitmap tier (§6A.4). *Pro:* trivially correct, no rank/unrank machinery, no D4-fixed-point
  edge cases; the sort + block compression do the work. *Con:* the raw key is large *before*
  compression (irrelevant on disk after front-coding; relevant only if it sat in RAM, which it does
  not — only the sparse index is resident).

**Recommendation within this choice: start with (C)** (raw sorted key + block compression) because it
is correct-by-inspection and the block compression closes most of the gap; **graduate to (R)** (the
folded combinatorial rank) only for the *dense* bands where the rank unlocks the zero-key bitmap tier
(§6A.4) — the rank is worth its complexity exactly where it makes the position its own offset.

### 6A.3 Front-coding / prefix compression within a locality block

Once entries are **sorted by the locality key**, adjacent entries in a block share a long prefix.
Even with §2.2's caveat (siblings re-canonicalise), entries that land in the *same block* do so
*because* they are close in the canonical descriptor — so within a block, consecutive canonical masks
differ in a few low bits. Front-code the block:

```
  block header:  full first key (the block prefix)               ~90 bits once
  per entry:     [ shared-prefix length : ~6 bits ]
                 [ suffix delta : variable, few bits ]
                 [ value : 1–2 bits ]
```

This is the **RocksDB data-block restart-point scheme** (sorted, prefix-delta-encoded keys + periodic
full-key restarts for binary-searchability) applied to our keys. Quantify:

- A 256 KB block holds thousands of entries sharing a ~80–85-bit prefix. The prefix is amortised to
  ~0 bits/entry. The per-entry suffix is the *gap* to the previous key — for a near-dense block the
  gaps are small integers (a few bits each via a varint / Elias-γ code).
- **Achievable bits/key (medium-density block):** value (1–2) + suffix-delta (~3–8 bits) +
  restart overhead (amortised < 1) ≈ **5–11 bits/key** — already competitive with BuRR's ~2–3 *plus
  the ~1 B/key resident Bloom* (the Bloom is the hidden cost: the umbrella measures **~15 GB of
  resident Blooms** = ~7 bits/key of *RAM* on top of BuRR's disk bits). A front-coded sorted store has
  **no resident per-key structure at all** — only the ~tens-of-MB sparse block index — so its *total*
  (disk + RAM) cost already undercuts BuRR-with-Bloom for medium-density blocks.
- For the **dense** blocks, front-coding still carries a per-entry key suffix; the bitmap tier (next)
  removes even that.

### 6A.4 ★ Dense-slice compressed bitmaps — the floor (zero key overhead)

The make-or-break density idea: tier the representation by **slice density**, Roaring-bitmap style.

- **Define a SLICE = a contiguous structural-key range** = all canonical positions sharing a chosen
  high-order prefix (e.g. a fixed k-queen canonical prefix, or a `(pc-band, coarse-descriptor-cell)`
  pair). The slice has a **domain** = the set of all *possible* canonical completions in that range,
  and a **present** set = those actually stored.
- **Density = present / domain.** Three tiers:
  - **DENSE slice (present/domain ≳ ~⅛ — Roaring's array-vs-bitmap crossover region):** drop keys
    **entirely**. Direct-index: the position's rank *within the slice domain* IS its offset; the slice
    is a flat array of `value` (1–2 bits) per domain member, optionally run-length/Roaring-compressed
    over the present/absent pattern. **Lookup = O(1) (compute in-slice rank, index the array); storage
    = value-bits/position with ZERO key overhead.** This **beats BuRR's ~2–3 bits/key** (it's ~1–2
    bits/position and keyless and Bloomless) and is the absolute floor. This is precisely the
    Korf-15-puzzle / Awari / checkers move: a dense slice is a packed value array indexed by a
    combinatorial rank, no keys stored.
  - **MEDIUM slice:** front-coded sorted keys (§6A.3) — ~5–11 bits/key.
  - **SPARSE slice:** key-list, per-block Bloom + BuRR ribbon, or an MPHF over the slice's present set
    (BBHash ~3 bits/key, RecSplit ~1.56–1.8). BuRR survives *here* and only here.
- **The whole store is a per-slice tier choice**, recorded in the sparse index (2 bits of tier tag per
  slice). A probe: route to slice (the locality key's high bits) → read the slice's tier tag → dense:
  O(1) bitmap index; medium: front-coded scan; sparse: ribbon/MPHF. **All three are routable (no O(S)
  walk) and range-readable (a slice is a contiguous block range).**

**Is the dense tier reachable?** It is the make-or-break question for the floor, and it is *favourable*
in exactly our regime: **the deep bands (pc ≳ 24) are near-terminal — low branching, few legal
completions per prefix.** As pc rises (more queens placed), the number of *possible* canonical
completions sharing a deep prefix **collapses** (each additional placed queen sharply constrains the
rest via attack rays), so the slice **domain shrinks toward the present set** → density rises. This is
the opposite of the shallow tree (huge domains, sparse occupancy). The instrument must confirm it, but
the structural prior is strong: **deep = dense**, which is exactly where the bitmap floor pays, and
exactly the bands we store. The shallow sparse bands we *skip* (recompute), so we never pay sparse-tier
overhead on them.

**Choosing the slice key so the in-slice domain is small (thousands–millions):** the slice key must
(a) be a *prefix* of the routing key (so a slice is a contiguous range — already true for §3's
`pc_band ++ Hilbert(descriptor)`), and (b) fix enough of the position that the residual domain is
small. Candidates to **test for in-slice domain size**, in order:
1. `(pc_band, centroid-cell)` — pc + a coarse centre-of-mass bucket. Coarse; domain may be large.
2. `(pc_band, k-queen canonical prefix)` for k ≈ 6–10 — fixing the first k canonical queens collapses
   the domain hard (each fixes a square + clears its rays). Likely the sweet spot.
3. `(pc_band, 4×4 super-cell histogram)` — the §3.3 descriptor as the slice key; domain = completions
   matching the histogram.
4. Full `(pc_band, Hilbert-descriptor)` down to the block — the finest slice = a block; tests whether
   *block-level* density already supports the bitmap tier without a separate slice layer.

The instrument reports, per candidate slice key: **domain size** (distinct possible canonical
completions — measurable by the existing `count`/`reachable` enumeration restricted to the prefix),
**present count**, and **density = present/domain**, per pc-band. The slice key whose density crosses
the Roaring crossover (~⅛) for the bulk of deep entries, at a domain size of thousands–millions
(so the in-slice rank is a cheap table/arithmetic op), wins the dense tier.

### 6A.5 How this reshapes BuRR vs a sorted structural store

BuRR's *only* structural advantage was **keyless density** (~2–3 bits/key, no keys stored). The
analysis above removes that advantage on both flanks:

| Property | BuRR (current) | Sorted structural store (proposed) |
|----------------------------|------------------------------------|-----------------------------------------|
| Routing | **O(S) Bloom walk** (the problem) | O(1) range route (sparse index) |
| Range-read / block-load | no (scattered ribbon) | **yes** (contiguous slice = block) |
| Resident per-key cost | **~15 GB Blooms** (~7 bits/key RAM) | sparse index only (~tens of MB) |
| Dense-band bits/key | ~2–3 (disk) + Bloom | **~1–2, keyless** (bitmap tier) |
| Medium-band bits/key | ~2–3 + Bloom | ~5–11 (front-coded) |
| Sparse-band bits/key | ~2–3 + Bloom | ~3 (MPHF) or BuRR-as-the-sparse-tier |
| Collision risk | 2^-54 (probabilistic) | **0 (structural, exact)** |

**The reframing:** if the deep bands are dense (§6A.4's strong prior, to be measured), a **sorted
structural store matches or beats BuRR on density** (dense bitmap tier ≈ 1–2 keyless bits vs BuRR's
2–3 + Bloom) **while also being routable and range-readable** — i.e. it wins on *all three* axes BuRR
loses on (the O(S) walk, no range-read, the 15 GB resident Bloom) and **ties or wins on the one axis
BuRR led** (density). BuRR does not disappear: it becomes the **sparse-tier fallback** (the one slice
class where keyless bitmaps don't pay and front-coding is loose), invoked per-slice, not globally. The
sorted structural store *subsumes* BuRR as a special case while fixing its three pathologies.

**Revised recommendation (supersedes §6's "decide the container after L"):** the container decision is
now also driven by density, and the answer is clearer — **build the sorted structural store with
per-slice tiering** (dense→bitmap, medium→front-coded, sparse→MPHF/BuRR), keyed by `pc_band ++
Hilbert(D4-canon descriptor)`, blocked + sparse-indexed per §4. This is strictly better than both (a)
RocksDB-over-hash (no locality, compaction write-amp) and (b) BuRR-walk (O(S), Bloom RAM, no
range-read), *provided* the deep-band density measurement (§6A.4, §7 item 6) confirms the dense tier
is reachable for the bulk of stored entries. If density is low (the bands are sparser than the prior
suggests), fall back to front-coded medium tier everywhere — still routable, range-readable, and
Bloom-free, so still beating BuRR on RAM and routing even without the bitmap floor.

---

## 6B. Generalized / set-based TT entries — keying on structure, not on a single graph

The user raised three connected pointers — Kobayashi's structural parameterizations of Node Kayles,
set-based "setrograde" analysis, and Ginsberg's Partition Search — that all push in one direction:
**a TT entry can describe a SET of positions sharing a value, not a single canonical graph.** This is
a different and potentially larger lever than locality, and it interacts directly with the slice-key
design (§6A.4), so it belongs in this document as a flagged adjacent direction (not the core
recommendation — it is higher-risk).

### 6B.1 The prior art and what it says

- **Kobayashi, "On Structural Parameterizations of Node Kayles," WALCOM/CGGG 2021** (arXiv
  [2003.11775](https://arxiv.org/abs/2003.11775); Springer
  https://link.springer.com/chapter/10.1007/978-3-030-90048-9_8). Node Kayles — *our exact game* on a
  general graph — is FPT in three structural parameters, with concrete bounds (from the paper and its
  citers): **O\*(3^τ)** in the **vertex-cover number τ**; **O\*(1.6031^μ)** in the **modular-width μ**;
  and a **linear kernel** in **neighborhood diversity** (the number of twin classes — vertices with
  identical neighborhoods). The mechanism that matters for us: the **modular-width algorithm computes
  the game value bottom-up over the modular-decomposition tree**, *combining the values of child
  modules* by their quotient structure — i.e. **the game value of a position is a function of the
  game values of its modules**, not of the raw labelled graph. Neighborhood diversity collapses twin
  classes because **twins are interchangeable** — the value depends only on *how many* vertices are in
  each twin class, not which.

- **Set-based "setrograde" analysis — Stone, Sturtevant et al., IJCAI 2025 / arXiv
  [2411.09089](https://arxiv.org/abs/2411.09089).** Generalizes a *state* into a **set of states that
  all share the same game value**, and stores the *set* as the database/TT entry. Skips every state
  subsumed by an already-stored set ⇒ exponential state-space → much smaller set-space (24-card Bridge:
  **4 orders of magnitude fewer sets than states**, solved in a week on one machine; 28-card: 10^30
  states → 10^17 sets). Explicitly credits **Ginsberg's Partition Search** (Bridge) as the predecessor:
  Partition Search reasons about *sets* of states and uses those sets as **transposition-table
  entries** ("all deals matching this pattern have this value").

### 6B.2 The analog for the queen-graph solve

A generalized TT entry would assert: **"every available-graph matching this STRUCTURAL pattern has
value V"** — where the pattern is a module/twin/line-family signature, not a single canonical graph.
Two concrete, safe-by-construction forms grounded in Kobayashi:

1. **Twin-class (neighborhood-diversity) key.** Instead of keying the full graph, key the **multiset of
   twin classes** `(class neighborhood-signature → count)`. Kobayashi's linear kernel says the value
   depends only on this multiset — so two positions with the same twin-class multiset *provably* share
   a value. This is a **sound generalization**: it merges positions that the D4/iso canon does *not*
   merge (different graphs, same twin structure) → strictly more sharing, a smaller stored set. It is
   the principled version of the project's existing twin observations (`twin_vertices`, `ModuleStats`
   in `graph.rs`).

2. **Module-quotient key.** Decompose the available-graph by modular decomposition; key on the
   **quotient graph + each module's game-value** (computed by the bottom-up rule). A module whose game
   value is known need not be re-expanded; the entry generalizes over *all* internal labelings of that
   module with the same value. This is the Partition-Search "set as TT entry" idea instantiated via
   Kobayashi's combination rule.

### 6B.3 Why it is risky here — and the prior negative

The project has **already triaged the structural-reduction cluster and found it weak ON THE DEEP
TAIL** ([node-kayles lit-levers](handoffs/2026-06-20-node-kayles-lit-levers.md), probe #1):
`module_profile` over n=12/n=14 working sets showed **`reduces%` ≈ 0% across pc 13–20** — the deep
queen subgraphs are too *sparse* to carry size-≥3 modules (twin pairs 3.8% at pc 13 → ~0% by pc 18).
**The modular/twin structure that Kobayashi's FPT bounds exploit is largely absent in exactly the deep
bands we store.** So the *generic* module/twin generalization is measured-dead on the tail — consistent
with the component-nimber parking (`queens-component-nimber`, −74% nodes but 6.6× wall: the cutoff-free
nimber recursion is the cost killer).

**Where it could still pay (the untried crack):** the user's own framing — *"if the high-centrality
shapes admit safe generalization."* The negative was measured on the *generic* tail; it did not test
**(a) shallow/high-centrality nodes** (where modules/twins are common — the near-frontier, which we
*skip*, so a generalized entry there feeds the recompute), nor **(b) the twin-class multiset key as a
sharing key** (probe #1 measured module *reduction* — collapsing a position — not module *keying* —
merging two positions with the same twin multiset). (b) is sound (Kobayashi guarantees it) and is a
pure sharing win with no nimber recursion, so it sidesteps the cost killer that sank component-nimber.

### 6B.4 Interaction with the slice-key / density design

This is the productive connection: **a generalized (twin-class or module-quotient) key is a natural
SLICE KEY (§6A.4).** A slice = "all positions with this twin-class multiset" or "this module quotient"
is a structural equivalence class; if all members share a value, the slice is **maximally dense — one
value for the whole slice** (the ultimate bitmap-tier: a slice that is a single bit). So the
generalized-entry idea and the density-tier idea are the same lever viewed two ways: a sound structural
generalization *is* a perfectly-dense slice. The instrument should therefore additionally measure, for
the twin-class-multiset key: **how many distinct positions collapse per twin-multiset on the bands we
store** (the generalization factor) — if it is > 1 on a meaningful fraction of deep entries, it is both
extra sharing *and* a denser slice. The prior says this is ~1 on the deep tail (sparse) but **untested
as a *keying* (not reduction) measurement**, and untested at the band boundary where we transition from
skip to store. **Flag, measure cheaply alongside item 6, do not build on it yet.** It is the highest-
upside / highest-risk direction in this document; the locality + density core (§§3–6A) stands
independently of whether it pays.

---

## 7. Measurement plan — what the reuse-locality instrument must test

The instrument (separately being built) should, for a candidate routing-key function `k(·)`, run a
representative n=18 partial search (or replay a recorded probe/reuse trace) and report, **per
candidate key and per block-size**:

1. **Bucket population distribution** — entries per block under `k`: mean, p50, p99, max, and the
   overflow fraction (blocks > 256 KB). *Gate:* p99 within ~2× of mean (else the descriptor is too
   coarse / skewed; add fp-tiebreak bits or refine the histogram).
2. **The locality factor L itself** — over the recorded reuse-hit edges (a probe that hits a
   previously-stored entry), the fraction that fall in the **same block** as the probing node's gather
   block(s), i.e. **intra-block reuse-hit fraction**, and the derived L = useful-entries / block-loads.
   *This is THE number.* Report it for: pc-band-only, pc-band+Morton, pc-band+Hilbert, and `hash128`
   (the L=1 control).
3. **Gather clustering** — for each expanded node, how many distinct blocks its `nw` children's keys
   span (the per-gather block-span histogram). *Gate:* median span ≤ 2 (one prefetch covers the
   gather).
4. **Band-residency reuse** — fraction of reuse-hits served from a block already in the decoded-block
   LRU (warm) vs requiring a cold pread, as a function of LRU size. Sizes the LRU.
5. **Long-range transposition fraction** — of reuse edges, the fraction whose endpoints are *not*
   occupancy-close after canon (the residual the geometric coordinate cannot help). This directly
   measures Risk #1: if this fraction is high, Hilbert buys little and we ship pc-band-only.
6. **★ Slice density (the structural-encoding / bitmap-tier gate, §6A.4)** — for each candidate slice
   key, **per pc-band**: the **domain size** (distinct possible canonical completions in the slice —
   restrict the existing `count`/`reachable` enumeration to the slice prefix), the **present count**
   (stored entries), and **density = present/domain**. Report the *fraction of deep entries living in
   dense slices* (density ≥ ~⅛) at a domain size in the thousands–millions. *This decides the bitmap
   floor.* Also report the **front-coding ratio** (achieved bits/key after prefix-delta within a
   block) for the medium tier, and the **realised total bits/entry** (disk + amortised resident index)
   per tier vs BuRR's ~2–3 disk + ~7 RAM.

7. **Generalization factor (§6B, structural-merge probe — cheap add-on to item 6)** — for the
   **twin-class-multiset key** (and optionally the module-quotient key): on the bands we store, how
   many distinct D4/iso-canonical positions collapse to one twin-multiset (the sharing gain beyond
   canon), and do collapsed members share a value (a sound-merge sanity check — they must, by
   Kobayashi). *Prior says ~1 on the deep tail (sparse); this re-tests it as a KEYING measurement and
   at the skip/store band boundary, which probe #1 did not.* If > 1 on a meaningful fraction, it is
   both extra sharing and a perfectly-dense slice (§6B.4). Read-only; do not build on it without a
   positive.

**Exact slice-key functions to try first for density (item 6), in order:** (a) `(pc_band, k-queen
canonical prefix)` for k ∈ {6, 8, 10} — the strongest domain-collapse candidate; (b) `(pc_band, 4×4
histogram)`; (c) `(pc_band, centroid-cell)`; (d) the finest `(pc_band, Hilbert-block)`. The winner is
the coarsest slice key whose density crosses ⅛ for the bulk of deep entries at a tractable domain size.

**Exact routing-key functions to try first (locality, items 1–5), in order:**
1. `hash128` (control, L = 1).
2. `pc_band ++ fp_low` (the guaranteed floor — band partition, random within).
3. `pc_band ++ morton(centroid_r, centroid_c, pc) ++ fp_low` (cheap curve).
4. `pc_band ++ hilbert(centroid_r, centroid_c, 4×4 histogram) ++ fp_low` (the recommendation).
5. Sensitivity: histogram granularity (2×2 / 4×4 / 6×6) and band width (pc exact vs `pc>>1`).

**Decision rule:** ship #4 if its L is ≥ ~2× #2's *and* its gather-span median ≤ 2; else ship #2
(pc-band-only) — still a large win over the L=1 control and the O(S) walk. Build the sidecar/container
only after the key is chosen by measured L. **Do not build the block sidecar before the instrument
confirms L > floor for some key** — the pc-band floor is bankable, the Hilbert upside is the thing
under test, and the project's discipline is to measure the lever before paying for it.

8. **★ Store-shrink via a stronger canon (the §1.0.1 principle, item 1 — cheapest high-value test).**
   Reuse the existing `count --iso` / `iso_key_canon` / `--distinct` tooling to measure, **restricted
   to the deep stored bands (pc ≳ 24)**, the **deep-distinct-count reduction** of the heavier keys vs
   the current D4 + selective-iso default: full WL/IR graph-iso canon (`iso_key_canon`), and the
   twin-class-multiset key (§6B). *At n=18 the compute cost that killed these at n=16 is ~1000× cheaper
   than the lookups a smaller store removes* — so the metric is purely "how much smaller is the deep
   distinct set?", not wall. *Gate:* if a heavier canon cuts the deep distinct count ≥ ~1.5×, it pays
   for itself (fewer cold lookups + denser store) and should replace the deep-band key — independent of
   its per-node compute. This is read-only over an existing trace and should be run *first*, before any
   sidecar work, because it changes the size of the set everything else operates on.

---

## 8. How this composes with the existing n=18 work

- **It is the routing layer the disk-DDD/BuRR store (`store.rs`, landed) is missing.** Today: memtable
  freezes → sharded ribbon segments + per-segment Bloom → **O(S) Bloom walk** on every probe. This
  proposal replaces the walk with **pc-band → sparse-index → one block**, and re-purposes the BuRR
  ribbon as the per-block payload. It is the in-house answer to the RocksDB-eval's question, with a
  locality key RocksDB-over-`hash128` would not have.
- **The deep-band store decision is the enabler:** because we only store pc ≳ 24 (the high-reuse deep
  set), the band coordinate is already the store's slicing axis, and the band count is small — so
  pc-band routing is natural and the sidecar is per-band.
- **Validation gates unchanged:** a routing-key/store-layout change is byte-identical on the node set
  and verdict — the existing gates apply verbatim (`solver_lineage_agrees`; `solve 12 iso-flat
  --distinct` = 1,060,823; `iso-dense-*` second on n=12/n=14; **byte-identical node count vs the BuRR
  baseline at n=14 with forced freezes**). The routing key changes *where* an entry lives on disk,
  never *which* entries exist or *what* value they hold (canon for sharing is untouched; the routing
  ordinal is a second function of the same canonical object).
- **The structural store subsumes BuRR (§6A.5):** the same instrument run measures both locality (L,
  items 1–5) and density (item 6). If deep slices are dense, the recommended container is the **sorted
  structural store with per-slice tiering** (dense bitmap / medium front-coded / sparse MPHF-or-BuRR),
  which beats BuRR on routing, range-read, resident RAM (~15 GB Blooms → ~tens of MB index), *and*
  density — and makes the verdict exact (no 2^-54 birthday caveat). BuRR is retained only as the
  sparse-tier fallback, invoked per-slice.
- **Sequencing:** (1) build the reuse-locality + density instrument; (2) measure L (keys #1–5) AND
  slice density (item 6) on an n=18 partial trace; (3) pick the routing key by L and the slice key +
  tiers by density; (4) build the per-band blocked sidecar = sparse index + per-slice tiered payload
  (bitmap/front-coded/MPHF) + per-gather prefetch; (5) A/B vs the BuRR-walk baseline (throughput,
  iowait, pool IOPS, resident footprint, bits/entry) the way the RocksDB-eval would — the forks share
  one harness and the locality key can feed *either* container.

---

## 9. Appendix — the canonical-vs-locality resolution in one diagram

```
                 mask (available squares, 384-bit)
                          │
                   canon(mask)          ← D4 lex-min (UNCHANGED; the sharing/merge step)
                          │
            ┌─────────────┴──────────────┐
            │                            │
   pc = popcount             Hilbert(centroid, histogram)        ← BOTH read off the SAME
   (D4-invariant)            (D4-aligned: computed on canon)        canonical bitmask, so
            │                            │                          D4-equivalent positions
            └──────────┬─────────────────┘                         get the SAME routing key
                       │                                           (block) and geometrically
              routing_key high bits  (locality: clusters           close positions get NEARBY
              gathers + bands into blocks)                          keys (block-load).
                       │
                  ++ fp_low   ← hash128 fingerprint (uniform WITHIN a block; never crosses blocks)
                       │
              ───────────────────────────────────────────────
              sorted sidecar → 256 KB blocks → sparse index → pread one block → BuRR ribbon → value
```

The canon step that *scattered* the placed-queen-prefix key (§2.2) is the *same* step that *aligns*
the Hilbert descriptor (§2.4): canonicalise first, then read the locality ordinal off the canonical
form. Correctness (sharing) and locality (blocking) are two functions of one canonical object — not a
trade-off, once the locality ordinal is derived *after* canon rather than from the path *before* it.
```
