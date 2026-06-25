# Proposal: ranking the deep-band TT for n=18 — can a domain rank remove the fingerprint floor?

**Date**: 2026-06-24
**Status**: design exploration / decision-grade RFC (no code yet)
**Scope**: the bits/node of the **deep-band** store for n=18 Non-Attacking Queens (= Node Kayles on the
queen graph). Extends the ranking question opened in
[locality-preserving-tt-key §6A](proposal-2026-06-24-locality-preserving-tt-key.md) and grounded by the
[n=18 umbrella](handoffs/2026-06-23-queens-n18-umbrella.md) session --10 layout model. **The decision
this answers: is a sub-RAM (~4–6 GB) deep store achievable, and if so by which mechanism?**

---

## 0. TL;DR — the recommendation up front

- **★ The prize (a bijective rank that removes the 54-bit fingerprint floor) is REAL in principle but
  UNREACHABLE for this domain as a clean combinatorial rank — and the reason is a hard theorem, not an
  unfinished search.** The fingerprint disappears **iff** every storable offset corresponds to exactly
  one real position (a bijection over the stored domain). Two routes to such a bijection exist, and both
  are blocked:
  1. **Closed-form combinatorial rank over a tractable domain.** The only domain with a closed-form
     dense rank is *all k-subsets of the 324 squares* (the combinadic / combinatorial number system,
     §3.1). It is a true bijection and needs **zero fingerprint bits** — but it is **10²–10²¹× too
     sparse** (the non-attacking placements are a vanishing fraction of `C(324,k)`; measured ~10⁻²–10⁻⁶
     at k=9–14, 4.5×10⁻²¹ at the full board — §3.2). A bitmap over it is hopeless; the rank is exact but
     over the wrong set. **The *feasible* (non-attacking), and a fortiori the *reachable*, set has no
     known closed-form dense rank** — n-queens counting is beyond #P, so a closed enumerator (which a
     dense rank would imply) cannot exist (§3.3, OEIS A000170 is a table not a formula).
  2. **A learned/perfect-hash bijection over the materialized reachable set.** An MPHF (RecSplit ~1.56,
     BBHash ~3 bits/key) *is* a dense index over the discovered keys — but it is **NOT a bijection over
     a closed domain**: a lookup of an absent key returns a *valid-looking garbage slot*, so it
     **re-introduces a fingerprint** for miss-detection (confirmed across the MPHF literature — §4.2).
     **So MPHF does not remove the fp floor; it relocates it.**

- **★★ THE CORRECTED CRUX (this supersedes the task's optimistic §3 framing).** The task asks "does a
  bijective rank eliminate the ~54-bit fp?" The precise answer: **a bijection over a CLOSED domain does;
  a dense index over an OPEN/materialized set does not.** The deep queen set is open (defined by
  reachability, discovered incrementally, no closed form), so **no ranking scheme removes the fp floor
  without an independent membership oracle.** The ~7–8 bit/node prize (`log2(42) + value`) assumed a
  bijection over the reachable domain — but that bijection is exactly the thing that does not exist for
  an implicitly-defined set. **The realistic floor is therefore set by miss-detection, not by rank
  entropy.** (§3, §4, §5.)

- **★ BUT the fp floor is much smaller than 54 bits once the set is dense, and that is the actual win.**
  The 54 bits is a *birthday bound over a hash domain of 2^128 routing space*. Over a **dense, sliced,
  sorted** store the residual ambiguity to resolve is tiny: within a slice of ~`D` candidate positions,
  a miss-vs-present decision needs only ~`log2(D) + safety` bits, not 54. The deep store's real bits/node
  is then **value (2) + miss-guard (≈ a per-slice Bloom or a short structural suffix, ~3–11 bits) ≈
  5–13 bits/node → ~2–8 GB at 2.8–5 B** (§5). **This fits a 32–64 GB box outright and approaches a
  laptop at the low end — without ever needing the (nonexistent) reachable-domain bijection.** The path
  to sub-RAM is **density + sorting + a cheap miss-guard**, not a magic rank.

- **★ The coordinator's duplication-tolerant, paged, per-shard-dense store is a STRONG alternative that
  sidesteps the canonical-vs-locality deadlock — and it COMPOSES with the ranking work rather than
  competing.** Shard by **access-locality** (the DFS subtree / placed-queen prefix), page a shard in on
  subtree entry and out on exit (tiny resident footprint), **accept cross-shard duplication** (a
  transposition reached from two subtrees lives in both — the duplication is bounded by the measured
  parent-key blowup ≈1.65×, and the lost cross-shard sharing is re-expansion the project *already chose
  to pay*). This **resolves the deadlock the prior proposal proved** (no single canonical key is both
  transposition-sharing and locality-preserving — siblings scatter under D4 re-canon): we stop demanding
  one key be both, and **duplicate instead of share across shards while ranking densely within a shard**.
  The open question it turns on — **is a subtree-local domain dense enough that per-shard ranking pays?**
  — is measurable and is the single highest-value new measurement (§6).

- **Recommendation, ranked:**
  1. **Build the density/rank instrument first** (§7) — it is the shared gate for *both* paths and is
     read-only over an existing trace. Measure: (a) per-band in-band distinct counts (the bits/node
     floor); (b) **per-slice density** = present/domain for slice keys `(pc, k-queen prefix)`,
     `(pc, centroid)`, the dense-bitmap-tier gate; (c) **per-shard (subtree-local) density and
     duplication factor** for the access-local shard key (the coordinator's path); (d) the realistic
     miss-guard bits per tier.
  2. **Default container = a sorted, per-band, slice-tiered structural store** (dense slice → packed
     value array indexed by an in-slice rank, zero key bits; medium → front-coded; sparse → MPHF+fp or
     BuRR), keyed `pc_band ++ structural-prefix`. This is the §6A store from the locality proposal, now
     grounded: it does **not** need the reachable-domain bijection — it needs *per-slice* density, which
     the deep bands plausibly have (deep = near-terminal = few completions per prefix).
  3. **If per-shard density beats global density (measured), switch to the paged-shard store** — it adds
     paging-locality and resolves the canonical tension at the cost of a bounded (~1.65×) on-disk
     duplication, which is cheap on the 1.4 TB pool. The two are not exclusive: **rank-within-shard is
     the per-shard density mechanism for the paged-shard store.**
  4. **MPHF is the fallback for sparse slices only** (and re-incurs a small fp); the background-rebuild
     architecture (§4.4) is viable (BBHash builds 10¹⁰ keys in <7 min) but is **strictly worse than the
     combinatorial in-slice rank where the slice is dense** — use it only where density fails.

- **The one-line decision:** the **sub-RAM deep store is achievable (~2–8 GB) via density + sorting +
  a cheap miss-guard**, NOT via a fingerprint-free reachable-domain rank (which does not exist). The fp
  is not removed; it is **shrunk from a 54-bit global birthday bound to a ~3–11-bit per-slice/per-shard
  miss-guard.** Both the global slice-tiered store and the duplication-tolerant paged-shard store reach
  this; the choice between them is the **per-shard-vs-global density** measurement.

---

## 1. The problem and what is already settled

n=18 squares index `r*18+c ∈ [0,324)`; a position = the placed (non-attacking) queen set ≡ the
available mask `board & !blocked`; `pc` = available popcount, decreasing as queens are placed. The board
bitset is `[u64;6]` (384 bits) on the migrated branch. **We store only the DEEP bands (pc ≳ 24)** —
~2.8–5 B distinct, the high-reuse / expensive-to-recompute ones — and **skip/recompute the near-frontier
(pc 18–~23)**, the bulk of nodes but cheap getK leaves (forced by the ~1000× lookup-vs-recompute
inversion; umbrella session --10). The deep value payload is 1–2 bits (win/loss/unknown). The dev box
is 26 GB; the n=18 distinct total is ~10–18 B.

**Measured facts to GROUND on (do not re-derive — umbrella session --10):**

| fact | value | source |
|------|-------|--------|
| deep node count irreducible by canonicalization | `iso_key_fast` merges deep set only **1.045×** vs D4 | `M_MODEL` strong, n=18 cont. |
| deep distinct (post-skip [18,23]) | **~2.8–5 B** (~28% of 10–18 B) | `M_MODEL` skip sweep |
| parent-key (no-canon) blowup, plateaus | **~1.65×**, opening-stable (1.575–1.66 across verdicts) | `M_MODEL` E/N |
| general compression of sorted masks | xz-9 **57.7 b/node**, zstd-19 70.8 (sparse 175 k sample) | dump compress |
| current hash slot | 55-bit fp + val ≈ **56 b/node** | `tt.rs` `Slot` |
| reachable domain / proof DAG | **~42×** (n=12: 44.9 M reachable vs 1.06 M stored) | `count --reachable` |

**Sizing the options at the deep set (computed):**

| store | bits/node | 2.8 B | 4 B | 5 B | fp regime |
|-------|-----------|-------|-----|-----|-----------|
| hash slot (today) | 56 | 19.6 GB | 28.0 GB | 35.0 GB | 2⁻⁵⁵ birthday |
| xz-of-masks | 57.7 | 20.2 GB | 28.9 GB | 36.1 GB | exact (keys stored) |
| in-band structural ordinal (key only) | ~28 | 9.8 GB | 14 GB | 17.5 GB | exact (sorted) |
| **domain-rank prize (IF it existed)** | **~7.4** | **2.6 GB** | **3.7 GB** | **4.6 GB** | **fp-free** |
| MPHF(1.56)+val, **no fp** (only if domain bijection) | 3.56 | 1.25 GB | 1.78 GB | 2.23 GB | fp-free — **unavailable** |
| **MPHF(1.56)+val+miss-guard fp(~32)** (realistic) | ~35.6 | 12.4 GB | 17.8 GB | 22.2 GB | 2⁻³² guard |
| **★ dense slice-tier: val + per-slice miss-guard ~3–11** | **5–13** | **1.8–4.6 GB** | **2.5–6.5 GB** | **3.1–8.1 GB** | per-slice guard |

The last row is the achievable target. The "prize" row is the theoretical floor that the rest of this
document shows is **not reachable as a closed rank**, but whose effect (a few-GB store) is **largely
recovered** by the dense slice-tier row — because the miss-guard over a *dense* slice is ~3–11 bits, not
the 32 a global MPHF needs.

---

## 2. The central tension, restated precisely

There are two candidate floors for bits/node:

1. **No ranking (hash membership):** a certified TT needs a collision-safe fingerprint (54–55 bits;
   a false key-match = a wrong value = a wrong verdict). fp(54) + value(2) ≈ 56 b/node → ~20–35 GB. The
   hash TT, an MPHF-with-fp, and xz-of-masks all converge here.

2. **With a domain ranking:** if a canonical position ranks to a dense offset within the **reachable**
   domain (density present/reachable ≈ 1/42), a bitmap/dense array over that domain costs
   `log2(42) + value ≈ 7.4 bits/node → ~3–5 GB → laptop`. **This is the prize.**

The task's question 3 is the load-bearing one: **does a bijective rank remove the fp (because every
offset is a real position, so there are no false matches to guard against)?** The answer decides whether
floor (2) or floor (1) governs. **Sections 3–5 resolve it: floor (2) requires a bijection over the
stored domain, which does not exist for this domain; but a *partial* domain rank (over dense slices)
recovers most of the prize anyway.**

---

## 3. Combinatorial ranking of the positions (task Q1)

### 3.1 The combinadic — a true bijection, but over the wrong domain

The **combinatorial number system** (combinadics; Knuth TAOCP 4A §7.2.1.3; Kreher & Stinson) ranks a
k-subset `{c_k > … > c_1}` of an n-set to

```
rank = C(c_k, k) + C(c_{k-1}, k-1) + … + C(c_1, 1)
```

a **bijection** `[0, C(n,k)) ↔ {k-subsets}`, with `O(k)` rank and `O(k log n)` unrank against a
precomputed Pascal table (k ≤ 18 ⇒ ~18 ops). For us: the placed-queen set is a k-subset of the 324
squares, so this **directly ranks the placed-queen set to a dense, gap-free, fingerprint-free offset** —
*over all k-subsets*. Every offset in `[0, C(324,k))` is a real k-subset; an absent-key lookup is
structurally impossible (the domain *is* the index space). **This is a genuine fp-free bijection.**

### 3.2 …but the non-attacking constraint makes that domain hopelessly sparse

The placed queens must be **non-attacking** — a tiny fraction of all k-subsets. Computed sparsity over
324 squares:

| k | `C(324,k)` (rankable superset) | feasible/superset (order) |
|---|--------------------------------|---------------------------|
| 9 | 9.7×10¹⁶ | ~10⁻²–10⁻³ |
| 12 | 2.3×10²¹ | ~10⁻⁴–10⁻⁵ |
| 14 | 1.2×10²⁴ | ~10⁻⁶ |
| 18 (full board) | 1.5×10²⁹ | Q(18)/C(324,18) = **4.5×10⁻²¹** |

So a bitmap/array indexed by the combinadic rank over the superset is **3–21 orders of magnitude too
large** — the fp-free bijection is exact but addresses a set the deep store cannot afford to allocate.
**(A "rank over all k-subsets, store a present-bit" design is dead on arrival.)**

### 3.3 No closed-form rank exists for the feasible (or reachable) set

The reason is a hardness result, not an unfinished search: **n-queens counting is beyond #P**; `Q(n)`
(OEIS A000170) is a computed table with no closed form, known exactly only through n=27. A closed-form
dense **rank** of the feasible set would imply a closed-form **count** (rank of the last element + 1), so
it cannot exist while the count has none. The reachable set (the proof DAG) is a *further* implicit
subset (~1/42 of reachable-canonical, itself a subset of feasible), defined by game reachability with no
closed description at all. **Verdict: there is no tractable combinatorial bijection over the set we
actually store. Q1's "(b) is the reachable subset rankable, or only a rankable superset?" resolves to:
only the superset is closed-form rankable, and it is unusably sparse.**

### 3.4 D4-canonical ranking — the Nalimov fold, and its fixed-point tax

Q1(c) asks about ranking within the symmetry-reduced space (Nalimov's a1-d1-d4 triangle). The prior art
(game tablebases, §below) **does** rank under D4 — but always **within a fundamental domain**, accepting
a small fixed-point waste, never via a clean closed-form *orbit* rank:

- **Burnside/Pólya gives the orbit COUNT cheaply, but NOT an efficient orbit RANK.** No general
  constant-time bijection `canonical-rep → [0, #orbits)` is known (the research surveyed the literature
  and found none; it is well-supported but not a cited impossibility).
- **What Nalimov/Syzygy actually do:** fold the *first* piece into the 10-square triangle (the D4
  fundamental domain — the *same* D4 we fold); if it lands on a symmetry axis (a fixed point), spend the
  **residual symmetry** folding the *next* piece into the "large" triangle. The axis cases appear as
  fewer pre-enumerated entries (Nalimov pre-tabulates 462 king-king placements rather than ranking them
  arithmetically). **They eat the fixed-point waste** — Nalimov measured **+9.8% "broken"/illegal slots**
  over the theoretical minimum — as cheaper than a perfect orbit rank.

This matters because it shows the fold-then-rank pattern is real and battle-tested **but only over a
domain with a closed enumeration (all legal piece placements)**. For queens that domain is the
non-attacking-placements set, which (§3.3) has no closed enumeration — so the Nalimov fold has nothing
tractable to rank *within*. **D4-canonical ranking does not rescue us; it inherits §3.3's wall.**

---

## 4. Game-tablebase position indexing — the closest prior art (task Q2)

The research studied Nalimov (chess), Syzygy (chess), Chinook (checkers), Awari. Every solved-game
tablebase converges on the **same shape**, and the comparison tells us exactly why it works for them and
what we lack.

### 4.1 How they rank, by system

| system | rank mechanism | symmetry | illegal positions | value | bits/pos | per-pos key? |
|--------|----------------|----------|-------------------|-------|----------|--------------|
| **Nalimov** (chess) | per-piece-type combinadic `C(q,k)` in a mixed-radix Horner product; 2 kings pre-tabulated (462/1806) | **D4 fold to 10-sq triangle**; diagonal fixed point ⇒ fold 2nd piece | **+9.8% "broken" slots**, marked, not compressed out | 1 byte DTM | ~1 B raw, 8 KiB Kadatch blocks | **none** — index *is* identity |
| **Syzygy** (chess) | combinadic + table-driven canon (`TRIANGLE`,`KK_IDX`); two-level sparse index + SizeTable | D4 pawnless, h-flip pawnful | **"don't care" values** — illegal probe returns compressor-chosen garbage; correctness needs never probing illegal | WDL (5 val ≈2.3 b) | ~0.35 b/pos (Re-Pair+Huffman) | **none** (only a whole-file checksum) |
| **Checkers** (Chinook) | per-type `C(squares,k)` rank within a `(piece-sig, stm, leading-rank)` slice | weak (dark-square board); leans on game-structure slicing | same-square excluded structurally; other illegals = cheap compressor runs | **W/L/D = 2 bits** | 154 pos/byte ≈ 0.05 b/pos | **none** |
| **Awari** | composition-rank (stars-and-bars) within a monotone stone-count layer | 180° (not folded into master count) | ~none (state = pure count distribution) | score ~7 b raw | **2 b/pos** (Lincke-Marzetta) | **none** |

### 4.2 ★ The miss-detection property — confirmed, and exactly why it doesn't transfer

**Confirmed across ALL four systems: they store ZERO per-position key/fingerprint/checksum.** The
computed index *is* the position identity — a dense direct-addressed array, not a hash table. This is
precisely the task's Q3 insight, and **the research confirms the reasoning is sound**: *a bijection over
the legal domain means every slot is a real position, so there is no "is this the right position?" check
to make, hence no fingerprint.* (Nalimov: "every placement has its own unique index … where the
information is located"; python-chess on Syzygy: "No per-position key or checksum exists.")

**Why it transfers to combinadics but NOT to us:** the tablebases rank over a domain with a **closed
enumeration** (all legal k-piece placements = `C(squares,k)` folded), so they have a closed-form
bijection and pay only the small fixed-point/illegal waste. **We do not** — the non-attacking + reachable
constraint has no closed enumeration (§3.3). So the very property that lets them drop the fingerprint
(a closed-domain bijection) is the property we cannot construct. The tablebases also reveal the *cost
they pay instead*: Syzygy's "illegal probe → garbage value" is **exactly the failure mode a fingerprint
guards against** — they avoid it not by a fingerprint but by *never probing an illegal position* (the
engine only computes indices for legal positions). **We cannot make that guarantee** — our search probes
positions whose presence in the store is unknown (that is the whole point of a TT lookup: "have I solved
this?"). **So we need miss-detection that Syzygy structurally avoids.** This is the precise reason the
fp cannot be fully removed for our use case.

### 4.3 What we CAN borrow (the productive transfer)

- **Slice by a monotone invariant, then rank within the slice** (checkers' `(sig,stm,rank)`, Awari's
  stone-count layer). **Our `pc` band is exactly this monotone slicing axis** — and the deep store is
  already sliced on it. Within a band, the residual domain is far smaller, so an in-band ordinal is
  ~28 bits (key-only), and a *dense* in-band slice supports a packed value array (§5).
- **Two-level sparse index + SizeTable for variable-fill blocks** (Syzygy) — the routing layer, resident
  in tens of MB, replacing the O(S) Bloom walk. (This is the locality proposal's §4 sidecar.)
- **Fast-decompress over max-ratio** (de Man chose Re-Pair for probe speed) — our per-probe budget is
  tight; pick a block codec that decodes fast (front-coding / a small range coder), not the densest.
- **Eat a small slot waste rather than a perfect rank** (Nalimov's +9.8%) — a dense *slice* with a few
  absent positions is fine; do not chase a gap-free orbit rank.

---

## 5. The fingerprint/correctness floor — can it be removed? (task Q3, the decision)

**The reasoning in the task is correct but conditional, and the condition fails for our domain.** Stated
precisely:

> A lookup of a non-present position is safe **without a fingerprint** if and only if the position-↔-offset
> map is a **bijection over a closed domain that the search only ever probes within**. Then every offset
> is a real position whose stored value (incl. an "unknown" code) is correct, and there are no false
> matches. **This is true for the combinadic over all k-subsets (§3.1) and for the tablebases (§4.2) —
> and false for any index over the OPEN reachable set.**

The deep queen store fails the condition twice:
1. **No closed domain to bijection over** (§3.3): the reachable set is open/implicit.
2. **The search probes outside the stored set by design**: a TT lookup asks "is this solved?" — most
   deep probes during discovery are *misses*. The tablebases never do this (they only probe legal,
   already-solved positions). So even *with* a perfect index over the discovered keys (an MPHF), an
   absent-key probe lands on a valid-looking slot and **must be rejected by a fingerprint** — the MPHF
   literature confirms MPHFs "return an arbitrary value in `[0,|S|)`" for absent keys with "no built-in
   false-positive detection." **MPHF relocates the fp; it does not remove it.**

**⇒ The fp floor cannot be fully removed for an incremental, open-set TT. The task's "the ranking removes
the correctness floor" is true only under a closed-domain bijection we cannot build.** This is the
single most important correction this document makes.

**BUT — and this is the recovery — the fp floor SHRINKS dramatically once the store is dense and sliced.**
The 54 bits is a birthday bound over a *global* hash routing space (~2^128). Replace global hashing with
**routing to a small slice** (`pc_band ++ structural-prefix`), and the residual identity to confirm is
only "which of the ~`D` positions in this slice's domain is this, and is it present?":

- **Dense slice (present/domain ≳ ⅛):** store a packed value array indexed by the **in-slice rank**
  (the position's combinadic/positional rank *within the slice's local domain* — small, e.g. thousands).
  Present/absent is the value itself (`unknown` code). **Miss-guard cost ≈ the in-slice domain bits
  already paid by the rank + ~0 extra**; a wrong value is impossible iff the in-slice rank is a bijection
  over the slice domain — which it can be, because a *slice* domain (positions sharing a k-queen prefix)
  is small enough to enumerate (§6A.4 of the locality proposal). **This is the dense tier: ~1–2 b/pos,
  keyless, and *locally* fp-free** (the bijection holds within the slice, which the search does probe
  within once routed). **The prize is recovered per-slice where density holds.**
- **Medium slice:** front-coded sorted keys (~5–11 b/key) + value; the sorted suffix-delta *is* the
  miss-guard (an absent key won't match any stored suffix). Exact, no probabilistic fp.
- **Sparse slice:** MPHF over the slice's present set + a **short fp sized to the slice**, not 54:
  rejecting an absent key among `~D` candidates needs ~`log2(D/ε)` bits, e.g. a 16–24-bit per-slice fp
  for ε≈2⁻⁸ over a million-entry slice — **far below 54**, because the slice has already pinned the high
  bits. Or a per-slice Bloom (~10 b/key) gating the MPHF.

**Realistic deep bits/node:** value(2) + per-slice miss-guard(3–11) ≈ **5–13 b/node → ~2–8 GB at
2.8–5 B** (table §1). **This fits a 32–64 GB box outright** and approaches the laptop target at the dense
end — *without* the nonexistent reachable-domain bijection, and with the verdict **exact** on the dense/
medium tiers (no 2⁻⁵⁴ caveat) and a tunable, far-below-54 probabilistic guard only on the sparse tier.

**The answer to Q3, in one line:** a bijective rank removes the fp **only over a closed domain the search
stays within** — which we do not have; so the fp is **not removed but shrunk**, from a 54-bit global
birthday bound to a 3–11-bit per-slice miss-guard, by *density + slicing + sorting*. That shrink is most
of the prize.

---

## 6. ★ The duplication-tolerant, paged, per-shard-dense store (the coordinator's architecture)

This is a first-class alternative that **dissolves the canonical-vs-locality deadlock** the prior
proposal proved (siblings re-canonicalise into different D4 orbits ⇒ ~7/8 of sibling pairs scatter under
any occupancy-ordering key, so **no single canonical key is both transposition-sharing AND
locality-preserving**). The paged-shard design stops demanding one key be both.

### 6.1 The architecture

- **Shard by ACCESS-LOCALITY, not a canonical key.** The search is DFS; positions touched close in time
  share a subtree = a placed-queen prefix. **Shard = the subtree (first-k-queen prefix).** A shard is the
  **page unit**: paged in when the DFS enters the subtree, evicted when it leaves ⇒ resident footprint =
  only the current root-to-node path's shards.
- **Accept cross-shard DUPLICATION.** A position reached via transposition from two subtrees lives in
  **both** shards. Disk is cheap (1.4 TB pool). The **duplication factor = avg shards a position appears
  in ≈ the measured parent-key blowup E/N**, which **plateaus at ~1.65×** (opening-stable across verdicts,
  umbrella session --10) — *and is a hard upper bound* (full-subtree-prefix keying is the extreme; coarser
  shard prefixes duplicate less). The **lost cross-shard sharing = re-expansion**, which **the project
  already chose to pay** (skip-the-near-frontier + recompute). So duplication is *more of a cost already
  accepted*, paid on cheap disk instead of scarce RAM.
- **The deadlock dissolves:** each shard is **local** (a subtree, contiguous on disk, one range read) and
  we **duplicate instead of share** across shards. The reuse we KEEP is **intra-shard** (a paged-in
  subtree's internal transpositions, which ARE access-local); cross-shard reuse is dropped (re-expanded).
  No key needs to be both shared and local — the prior impossibility result simply does not apply.

### 6.2 The three evaluation axes (task ask 1, 4)

| axis | paged-shard store | global slice-tiered rank store |
|------|-------------------|--------------------------------|
| **Resident RAM (the binding constraint)** | **only the current path's shards** + the shard index (a prefix → disk-offset map, ~tens of MB). Likely **single-digit GB resident** regardless of total. **Strongest on the binding axis.** | the resident sparse index (~tens of MB) + decoded-block LRU (~hundreds of MB) + (sparse-tier) per-slice fps. Also small, but the *whole* sorted store is one logical object. |
| **Total on-disk** | **~1.65× the deep set** (duplication) × per-shard bits/node. At ~5–13 b/node × 1.65 × 5 B ≈ **5–13 GB on disk.** Cheap on 1.4 TB. | **1× the deep set** (no duplication) × bits/node ≈ 2–8 GB. Smaller on disk, but disk is not the constraint. |
| **Re-expansion cost** | duplication is **free** (same position stored twice, not recomputed); the cost is **lost cross-shard transpositions = recompute**. Bounded: cross-shard reuse is the *non-subtree-local* transpositions; intra-shard reuse is kept. **Magnitude = the (1−intra-shard-reuse-fraction) of deep reuse edges — the key unknown to measure (§6.4).** | keeps **all** transposition sharing (one canonical entry). Zero extra re-expansion beyond the already-chosen skip. |
| **Implementation complexity** | **moderate-high**: a paged shard store, shard lifecycle (page-in on entry / evict on exit), the DFS↔shard mapping, dedup-within-shard, the duplication accounting. New machinery. | **moderate**: the sorted slice-tiered store + sparse index + per-slice tier dispatch. Reuses BuRR as the sparse tier; the locality proposal already specs it. |
| **Canonical tension** | **resolved** (duplicate, don't share) | **present but managed** (canon for sharing; a second ordinal for locality — the locality proposal's resolution) |

### 6.3 ★ Per-shard vs global density — the question the whole comparison turns on (task ask 2)

The coordinator's key uncertainty: **is a subtree-local domain dense enough that per-shard ranking/bitmap
pays — or is the subtree still ~1/42 sparse, so sharding buys paging-locality but not density?**

**The structural prior cuts FOR per-shard density, and strongly:**
- A subtree-shard fixes the **first k placed queens** = fixes k squares + clears all their attack rays.
  Each fixed queen sharply constrains the residual board. So the shard's **local domain** (possible
  completions consistent with the prefix) is **far smaller than the global k-subset domain** — and the
  *reachable* completions within a fixed prefix are a *larger fraction* of that shrunken local domain
  than 1/42, because the prefix has already pruned most of the infeasible/unreachable directions globally.
- This is exactly the **§5 dense-slice mechanism with the slice = the shard**. The shard prefix is the
  strongest possible domain-collapse slice key (§6A.4 of the locality proposal ranked `(pc, k-queen
  prefix)` as the top density candidate). **So per-shard ranking is the *same* lever as per-slice dense
  ranking — the paged-shard store and the dense-slice global store are the same density mechanism viewed
  through two cache architectures.** This is the composition the coordinator pointed at: **shard for
  paging/locality/duplication; rank within shard for density.**

**The risk (the measurement must settle it):** if even a subtree-local domain is sparse (the reachable
completions are still a tiny fraction of the prefix-consistent completions), then sharding gives paging
but each shard needs MPHF+fp anyway — **density still requires the (nonexistent) global rank, and the
paged-shard store wins only on resident RAM, not on bits/node.** The deep-band structural prior (deep =
near-terminal = few completions) says density should rise sharply with the prefix depth k, but **this is
the single highest-value thing to measure** before committing.

### 6.4 Paging architecture and the Korf SDD connection (task ask 3)

This is **Structured Duplicate Detection** (Zhou & Hansen, AAAI 2004) and **Hash-based DDD** (Korf, JACM
2008) territory, and the mapping is exact:

- **The shard = the SDD "duplicate-detection scope."** SDD partitions the state space by an abstraction
  `p(·)`; all duplicates of a node's successors lie in the union of abstract-neighbour blocks, so only
  that scope need be resident. **Our subtree-prefix shard is such an abstraction**, and the DFS guarantees
  the scope is the current path's shards (the abstract graph is a tree — bounded scope). Korf's HBDDD
  `hash1` = "route every potential duplicate to the same file" — here `hash1` = the shard prefix, and
  **duplicates within a shard are caught (resident); duplicates across shards are deliberately NOT
  caught** (the duplication-tolerant choice). This is a *principled relaxation* of SDD: we trade
  complete duplicate detection (resident scope = all neighbour blocks) for a smaller resident scope (just
  the path) by accepting cross-shard duplicates.
- **Page-in / evict on the DFS frontier.** Enter a subtree ⇒ page its shard (one contiguous range read,
  NVMe-efficient — the 256 KB–1 MB transfer unit, not a 4 KB random read). Leave ⇒ evict (or LRU-keep for
  near-future re-entry via a sibling transposition). **Shard misses = subtree first-entries**; the working
  set = the shards on the active path + a small LRU of recently-left siblings. The DFS access pattern is
  highly sequential at the shard grain (you descend, then ascend, then descend a sibling), so the
  page-in rate is bounded by the subtree-entry rate, **not** the per-node probe rate — the structural win
  over the scattered-hash store.
- **mmap vs explicit paging:** the umbrella already measured **mmap → a 108K/s major-fault storm + 88%
  ARC miss; pread fixed it (24%)** — so **explicit paged reads (pread/io_uring of a whole shard range),
  not mmap-per-position**, with a capped ARC. The shard is the natural pread granularity; the decoded
  shard sits in an LRU; eviction is explicit. This also makes the **shard the freeze/snapshot unit**
  (aligns with the existing per-segment resume).
- **Caveat from the umbrella:** single-box io_uring *frontier* prefetch measured negative — but that was
  prefetching **scattered hash slots**. Prefetching a **whole shard range** is the operation io_uring is
  good at (one large sequential read), and is the case the umbrella's session --9 conclusion did *not*
  test. The paged-shard store is the architecture that finally makes the disk reads sequential.

### 6.5 The shard-key measurement (replacing the shape key that fragmented)

The instrument already found a **SHAPE-based shard key (pc + 3×3 occupancy histogram) FRAGMENTS** — 148 k
shards for 175 k masks ≈ singletons — and *hurts* compression (xz 71 vs 57.7 b/node raw-sorted). **Shape
does not cluster** (consistent with the prior proposal's "siblings scatter under canon" — shape is a
canon-derived descriptor and inherits the scatter). **The access-local subtree-prefix shard key is the
candidate to model instead.** The instrument should measure, for shard key = first-k-queen prefix
(k ∈ {6, 8, 10, 12}), per pc-band:

1. **Duplication factor** = avg # shards each deep position appears in (the on-disk blowup; expect ≤1.65×,
   decreasing as k decreases). Report the distribution, not just the mean (a heavy tail = a few
   high-transposition positions duplicated widely).
2. **Per-shard density** = present / shard-local-domain (the §6.3 question). Domain = reachable
   completions consistent with the prefix, restricted to the band; measure via the existing `count
   --reachable` enumeration *restricted to the prefix*. **The decision number: does density cross ~⅛
   (the Roaring/dense-tier crossover) for the bulk of deep entries at a tractable shard-domain size
   (thousands–millions)?**
3. **Paging pattern** = shard-miss rate under a DFS replay at a realistic shard-LRU budget: shards
   paged-in per unit search, resident shard count (the RAM number), and the intra-shard reuse fraction
   (the reuse we KEEP) vs cross-shard (the reuse we re-expand — the §6.2 re-expansion cost). Replay the
   `M_MODEL` get-stream under the shard layout (the umbrella already proposed a block-cache LRU replay).
4. **Per-shard compression** = bits/node after sorting + front-coding *within* a shard, and the dense-tier
   fraction. Compare to the global-sorted 57.7 b/node and the per-slice dense target ~5–13.

---

## 7. Recommendation + measurement plan (task Q5)

### 7.1 Is the sub-RAM (~4–6 GB) deep store achievable? — YES, but not by the fp-free rank

- **Achievable via density + slicing + a cheap miss-guard: ~2–8 GB** (§5 table), fits 32–64 GB outright.
- **NOT achievable via a fingerprint-free reachable-domain rank** — that bijection does not exist (§3.3).
  The ~7.4-bit "prize" is recovered to ~5–13 bits by per-slice density; the residual gap (vs the prize)
  is the unavoidable per-slice miss-guard the open-set TT requires (§5).
- **Both containers reach the target:** the global slice-tiered store (smaller on disk, keeps all
  sharing) and the paged-shard store (smaller resident RAM, resolves the canonical tension, ~1.65× disk).
  **The choice is decided by the §6.3 per-shard-vs-global density measurement and the §6.4 paging/re-exp
  measurement.**

### 7.2 The first measurable step (read-only, no build, gates the fork)

**Build the density/duplication instrument and run it on an n=18 partial trace (or the `M_MODEL`
get-stream).** It is the shared gate for *both* paths. In priority order:

1. **★ Per-shard density + duplication for the subtree-prefix shard key** (§6.5 items 1–2), k ∈ {6,8,10,12}.
   *This is the single highest-value measurement* — it decides whether the paged-shard store gives
   density (not just paging) and whether per-slice ranking is dense globally too (same lever). *Gate:*
   density ≥ ⅛ for the bulk of deep entries at a tractable domain ⇒ the dense bitmap/rank tier is real.
2. **Per-band in-band distinct counts** (the bits/node floor per band) and the **realistic miss-guard
   bits** per tier (dense ~0 / medium front-coding ratio / sparse per-slice-fp width for a target ε).
   *Gate:* total bits/node ≤ ~13 ⇒ sub-RAM store confirmed.
3. **Paging pattern + intra-vs-cross-shard reuse** via the DFS replay (§6.5 item 3). *Gate:* resident
   shard RAM single-digit GB AND cross-shard re-expansion within the already-accepted skip cost.
4. **Confirm the §3/§4/§5 reasoning empirically on a small board** (cheap sanity): implement the
   **combinadic rank/unrank** over k-subsets, verify bijectivity on n≤12 (round-trip rank∘unrank = id),
   and measure the **feasible/superset density per band** to confirm the §3.2 sparsity that kills the
   superset-bitmap — so the "no global bitmap, yes per-slice bitmap" conclusion is grounded in our own
   numbers, not just the literature.
5. **(if MPHF tier is needed) prototype an MPHF over the dumped deep keys** at the deep-mask dump
   (`/tmp/queens-deep-masks.bin` per the task) — BBHash for build speed (10¹⁰ keys <7 min, ~3 b/key) —
   and measure the **per-slice fp width** actually needed for safe miss-detection over a real slice. This
   confirms the sparse-tier bits/node and the background-rebuild cadence (§4.4: BBHash rebuild of a 5 B
   stream ≈ minutes ⇒ a periodic idle-core rebuild keeps up; RecSplit only with GPU/SIMD).

### 7.3 Build order after the gate

- **If per-shard density is high (≥⅛ for the bulk):** build the **paged-shard store** — shard = subtree
  prefix, page via pread of a contiguous shard range, dense in-shard rank/bitmap payload, explicit LRU,
  capped ARC. It wins the binding (resident RAM) axis and resolves the canonical tension; the ~1.65× disk
  duplication is cheap. **Rank-within-shard is the per-shard density mechanism** — the two paths compose.
- **If per-shard density is NOT higher than global:** build the **global slice-tiered sorted store**
  (locality proposal §6A) — sliced by `pc_band ++ k-queen prefix`, dense→bitmap / medium→front-coded /
  sparse→MPHF+short-fp, with the Syzygy-style sparse index. Sharding then buys nothing density-wise; keep
  the single canonical store and pay the locality cost via the routing key, not duplication.
- **Either way, MPHF lives only in the sparse tier** with a per-slice (not 54-bit) fp; the combinadic is
  used only as the *in-slice* rank where a slice domain is small enough to enumerate (the dense tier).

### 7.4 Validation gates (unchanged)

A store-layout/key change is byte-identical on the node set and verdict — the existing gates apply
verbatim: `solver_lineage_agrees`; `solve 12 iso-flat --distinct` = **1,060,823**; `iso-dense-*` second
on n=12/n=14; **byte-identical node count vs the BuRR baseline at n=14 with forced freezes**. Duplication
in the paged-shard store changes *where/how-many-times* a position is stored, never *which* positions
exist or *what* value they hold — so the verdict and distinct-count gates are unaffected (the duplication
factor is a storage metric, measured separately, not a correctness one). **A wrong value must remain
impossible** on the dense/medium tiers (exact, by the in-slice bijection / sorted-suffix match) and
astronomically unlikely on the sparse tier (per-slice fp sized to a chosen ε, cross-checked against
Jenrich + `check_cert.py`).

---

## 8. Summary of the decision

| question | answer |
|----------|--------|
| **Q1** Combinatorial rank of the positions? | Closed-form rank exists **only over all k-subsets** (combinadic, fp-free bijection) — but it is **10²–10²¹× too sparse** (non-attacking is a vanishing fraction). The **feasible/reachable set has no closed-form rank** (n-queens counting is beyond #P). D4 fold (Nalimov triangle) is real but inherits the same wall. |
| **Q2** Game-tablebase prior art? | Nalimov/Syzygy/checkers/Awari all **slice by a monotone invariant + combinadic-rank within the slice + store ZERO per-position key** — because they rank over a **closed legal domain the engine stays within**. We borrow the slicing (our `pc` band) and the sparse-index routing, but **cannot borrow the fp-free property** — our domain is open and we probe misses. |
| **Q3** Can the fp floor be removed? | **Only by a bijection over a closed domain the search stays within — which we do not have.** MPHF relocates the fp (absent-key garbage), does not remove it. **The fp is not removed but SHRUNK** — from a 54-bit global birthday bound to a **3–11-bit per-slice miss-guard** — by density + slicing + sorting. That shrink recovers most of the ~7-bit prize. |
| **Q4** MPHF fallback + background rebuild? | Viable (BBHash 5 B keys ≈ minutes on idle cores; RecSplit needs GPU/SIMD at this scale) but **strictly worse than the in-slice combinatorial rank where the slice is dense** — use MPHF only on **sparse slices**, with a short per-slice fp. The background-rebuild architecture keeps up but is the fallback, not the core. |
| **Q5** Recommendation? | **Sub-RAM (~2–8 GB) deep store is achievable** via density + slicing + a cheap miss-guard (NOT the fp-free rank). **Two containers reach it:** the global slice-tiered sorted store, and the **duplication-tolerant paged-shard store** (resolves the canonical-vs-locality deadlock, wins the resident-RAM axis, ~1.65× cheap disk duplication). **They compose** (shard for paging+locality+duplication; rank-within-shard for density). **First step: the density/duplication instrument** — measure per-shard vs global density (§6.3) and the paging/re-exp pattern (§6.4); that one measurement picks the container. |

**The headline correction for the umbrella:** the task hoped a bijective rank would both compress to
~7 bits/node *and* remove the 54-bit fingerprint. The fingerprint removal needs a closed-domain
bijection that **provably does not exist for the reachable queen set** (beyond-#P counting). What *is*
real: a **dense, sliced, sorted** store shrinks the fingerprint to a per-slice miss-guard and the value
to a packed array, landing at **~5–13 bits/node (~2–8 GB)** — a 32–64 GB-box fit, exact on the dense
tier, no magic rank required. The **paged-shard store** is the architecture that *also* solves the
canonical-vs-locality deadlock, by duplicating across access-local shards instead of sharing — paying a
bounded ~1.65× on cheap disk to win the scarce-RAM axis. **Build the instrument, measure per-shard
density, then pick the container.**
