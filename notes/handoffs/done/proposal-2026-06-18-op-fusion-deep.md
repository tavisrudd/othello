# Op-fusion / identity deep pass #2 — iso-window (`iso_flat.rs` + callees)

**Date**: 2026-06-18
**Scope**: PROPOSE-only, no code changes. Second/deeper pass over the iso-window kernel,
line-by-line, after the broad pass (which already claimed: closed/adj→`pext`; w8_get
edge-code→per-row `pext`; child_orient→`vpandnq`; filter_moves→`vpcompressb`; landed
branchless `tiny_edge_code`; rejected SIMD `lex_min8`). This pass hunts **finer** fusions,
common subexpressions, and structural identities those miss.

All symbols below were grep-verified to exist. Anchors honoured: `wins_inc` ~50% cycles,
`band_entry` ~20% (#1 branch-miss ~50%), `w8_get` ~6%; frontend-bound 27%, CPI ~1.1; gathers
lost (CPI-expensive on znver5) so every finding is scalar/branch/instruction-count-driven, not
"SIMD it". Gate for every change: `solve 12 iso-flat --distinct == 1,060,823` exactly +
`solver_lineage_agrees` (+ n=14 re-exp ≈1.0×). A finding that changes the *value* of a key or
fingerprint needs a `TT_HASH_ID`/`TT_CANON_ID` bump; one that only reorders work to produce a
**byte-identical** key/code needs neither.

---

## Ranked summary

| # | Finding | Cost attacked | Region | Fermi upside | Risk | ID bump |
|---|---------|---------------|--------|-------------|------|---------|
| 1 | **Fuse `tiny_table_index` decomposition into `enter_graph`** — one `each` + one set of k attack-row loads, not two; derive the labelled code from the rank-order `closed`/`adj` already built | redundant O(k²) pass + k row loads on #1 branch-miss site | `band_entry`/`enter_graph` | −1 decompose, −k `att08` loads, −k(k-1)/2 `get` per band entry (~20% region) | med | no (byte-identical code) |
| 2 | **Order the dispatch ladder by frequency: `pc<=7` first, `pc==8` second** in both `wins_inc` arms | branch sequence depth on the hottest per-move test | `wins_inc` move loop (~50%) | −1 compare on the dominant `pc<=7` path | low | no |
| 3 | **`hash128` skip the two constant tail words of `graph_bits`/`d4_bits`/`comp_nimber_bits`** keys | 2 of 4 mix rounds in every iso-band / D4 / nimber hash | `hash128` (every node) | −~40-50% of `hash128` work on band keys; const-fold the dead words | low | **yes** (`TT_HASH_ID`) — discrimination preserved |
| 4 | **`graph_bits` second word: drop the `mix64`** (route already mixes; fp half re-mixes) — or compute fp directly from `h` | one `mix64` (5 ops) per band/tiny key build | `graph_bits` (every iso-band node) | −1 `mix64` per band key | low | **yes** (`TT_HASH_ID`) |
| 5 | **`w8_get`: fuse vert-extraction into the code loop / `bzhi`-`tzcnt` scan instead of `each` closure** | `each`'s 4-word closure dispatch + second pass | `w8_get` (~6%) | −1 pass over `avail`, tighter scan | low | no (same code) |
| 6 | **`enter_graph` rank insertion-sort: hoist `rank[v]` reads / use `order8` subsequence** instead of per-vertex `rank[]` gather + shift | k gathers + O(k²) shifts per band entry | `enter_graph` | −k L1 gathers; replace sort with one filtered scan of `order8` | med | no |
| 7 | **`filter_moves` + first-child `att08` load fuse** — the loop already touches `att[sq]`; defer | extra `att08` reload in the move loop | `wins_inc`/`wins_tiny` | small (−reload, already L1) | low | no |
| 8 | **`avail.popcount()` recomputed** in `wins_inc` ORACLE arm and `node_pc` | redundant 4-word popcount | `wins_inc` entry | tiny (ORACLE off in prod) | low | no — **wash flag** |

Findings 1–4 are the load-bearing ones. 5–6 are real but smaller. 7–8 are documented washes /
near-washes. Detail below.

---

## Finding 1 — Fuse the band-entry double decomposition (HIGHEST VALUE)

### Current code
Production band entry on a `pc<=7` child runs **two independent decompositions of the same
`child0` mask**, each loading the same k attack rows:

`iso_flat.rs:931-935` (inside `enter_graph::<false>`):
```rust
let tidx = if COUNT { 0 } else { q.tiny_table_index(child0, pc) };
```
which (`graph.rs:1017-1039`) does:
```rust
let mut verts = [0u8; SMALL_CANON_MAX];
let mut n = 0usize;
mask.each(|v| { verts[n] = v as u8; n += 1; });      // PASS 1a: decompose child0 (ascending sq)
let code = match k { 2 => tiny_edge_code::<2>(&self.attack, &verts), ... };  // loads k attack rows, k(k-1)/2 edge_bit
SMALL_CANON_OFF[k] + code as usize
```

then **immediately after**, `iso_flat.rs:944-972`:
```rust
let rank = self.order_rank(q);
let mut verts = [0u8; MAXV_TINY];
let mut k0 = 0usize;
child0.each(|v| { ... insertion-sort by rank ... });  // PASS 1b: decompose child0 AGAIN (rank order)
for i in 0..k0 {
    let row = att08(att, verts[i]);                   // loads the SAME k attack rows again
    let mut c = 0u8;
    for (j, &vj) in verts.iter().enumerate().take(k0) {
        c |= (row.get(vj as u32) as u8) << j;         // builds closed[]/adj[] (rank order)
    }
    g.closed[i] = c; g.adj[i] = c & !(1u8 << i);
}
```

So per band entry: `child0` is bit-scanned twice, and **each of the k attack rows is loaded
twice and re-tested** — once to build the ascending-square `tiny_edge_code` (the `tidx`), once
to build the rank-order `closed`/`adj`. This is on the **#1 branch-miss site** and the
~20%-cycles `band_entry` region.

### The identity / fusion
`tidx`'s labelled edge code and `enter_graph`'s `adj`/`closed` masks are the **same graph** in
two different vertex labellings (ascending-square vs q.order-rank). They are a permutation of
each other, and the permutation is known once you have the rank-sorted `verts[]`. Concretely:

1. Decompose `child0` **once**, in **ascending-square order** (the cheap `each`/`tzcnt` scan,
   no sort) into `sq_verts[0..k]`.
2. Build the full per-vertex closed masks **once** in ascending-square labelling — load each
   attack row once, test all k squares: `c[i] = Σ_j (att08(verts[i]).get(verts[j]) << j)`.
   - From this you get the **ascending-square edge code** directly (the upper triangle of `c`,
     bits `i<j`) → `tidx = SMALL_CANON_OFF[k] + code` with **no second row load**. This is
     bit-identical to today's `tiny_edge_code` (same `i<j` low-to-high convention).
3. To get the **rank-order** `closed`/`adj` the search carries: compute `rank_of[i] =
   order_rank[sq_verts[i]]` (k L1 gathers), then permute the ascending-square `c[]` bit-masks
   into rank order — a pure-register relabelling (`MAXV_TINY=8`, so each `closed[i]` is one
   `u8`; the permutation is a small gather of bits). No attack-row reload.

The relabelling in step 3 is byte-cheaper than the current re-scan because it touches no `Bits`
(256-bit) attack rows — only the k `u8` masks already in registers.

### Cost attacked / Fermi
Per band entry today: **2 mask bit-scans + 2×k attack-row (`Bits`, 256-bit) loads + 2×k(k-1)/2
edge tests**. Fused: **1 bit-scan + 1×k row loads + 1×k(k-1)/2 tests + a k-element register
relabelling.** That halves the attack-row traffic and the edge-test count, and removes one full
`each` closure (4-word dispatch) on the #1 branch-miss site. At k≈4-7 the saved work is
~k(k-1)/2 ≈ 6-21 `edge_bit`s + k row loads + one scan **per band entry**; band entries are a
large fraction of nodes deep in the tree. Even at a conservative one-third of the `band_entry`
region's ~20% cycles, this is a **single-digit-percent wall win** — the largest concrete lever
in this pass.

### Correctness / gate
The fused `tidx` is bit-identical to `tiny_table_index` (same ascending-square labelling, same
`i<j` packing — the existing `iso_key_tiny_table_pc` comment at `graph.rs:980-984` already
asserts this convention). The rank-order `closed`/`adj` is bit-identical to today's (same
insertion-sort rank order, same self-blocking bit semantics). Node set and both keys
byte-identical ⇒ **no `--distinct` change, no re-exp change, no ID bump.** `solve 12 --distinct`
must stay `1,060,823`. The `COUNT` path is unaffected (it skips `tidx` already — `tidx=0`).

### Cheapest A/B
n=16 partial-throughput (or n=14 full): branch-miss-rate and CPI on `band_entry`, plus M/s.
Node-count-independent. Validate `solve 12 iso-flat --distinct` first (must be exact).

### Implementation note
`enter_graph` should build the ascending-square `c[]` once and produce both `tidx` (from the
triangle) and the rank-permuted `closed`/`adj`. The current split exists because `tiny_table_index`
is a `Queens` method reused by the `--distinct` key path; keep that method for `COUNT`, but
inline the fused single-pass build into `enter_graph::<false>` so production never calls it.

---

## Finding 2 — Reorder the per-move dispatch ladder by frequency

### Current code
Both `wins_inc` arms test `pc` in this order (`iso_flat.rs:730-749` and `777-794`):
```rust
let lost = if WINDOW && !ORACLE && !COUNT && pc == 8 {
    !self.w8_get(att, child0)
} else if !ORACLE && pc <= 7 {
    !self.band_entry::<COUNT>(q, att, child0, pc, nodes)
} else if pc <= self.iso_max_avail { ... }
else { ... wins_inc recursion ... };
```

The order is `pc==8` → `pc<=7` → `pc<=iso_max` → D4-recurse.

### The observation
The n=14 put histogram (`tt.rs:223` `N14_PUTS_FROM9`) and the iso-band design mean the deep tree
is **dominated by the `pc<=7` band** — it's "the deepest, highest-node-count region" per the
code's own comments (`iso_flat.rs:726-728`). Yet the ladder tests `pc==8` *first*, so every
band-entry node pays an extra `pc==8` compare-and-not-taken before reaching its `pc<=7` arm.

`pc==8` is a single popcount value (one thin slice); `pc<=7` is seven values and the bulk of
deep nodes. Putting `pc<=7` first means the common case hits on the first compare.

But note the guards differ: the `pc==8` arm needs `WINDOW && !ORACLE && !COUNT`, the `pc<=7`
arm needs `!ORACLE`. Since `WINDOW`/`ORACLE`/`COUNT` are **const generics**, the compiler already
const-folds the ladder per monomorphisation. In the production `WINDOW=true,ORACLE=false,
COUNT=false` instantiation both guards are live, so reordering to
```rust
let lost = if !ORACLE && pc <= 7 {
    !self.band_entry::<COUNT>(...)
} else if WINDOW && !ORACLE && !COUNT && pc == 8 {
    !self.w8_get(att, child0)
} else if ...
```
makes the dominant path a single `pc<=7` compare. The `pc<=7` and `pc==8` ranges are disjoint, so
the reorder is semantically identical.

### Cost / Fermi / gate
−1 retired compare+branch per band-entry move on the hottest region. Frontend-bound at 27%, so a
removed always-first branch on the dominant path is a real (small, low-single-digit-%) win and
pure upside — no value changes, **no ID bump**, byte-identical node set. A/B: CPI/branch-miss on
n=16. **Confirm the compiler isn't already reordering** (it may, via profile-less heuristics) —
if the disassembly already leads with `pc<=7`, flag as wash.

---

## Finding 3 — `hash128` over keys with constant/derived words: skip dead mix rounds

### Current code
`hash128` (`tt.rs:621-632`) folds **all four** key words through two independent mixers:
```rust
pub(crate) fn hash128(key: Bits) -> (u64, u64) {
    let mut route = 0u64;
    let mut fp = 0x2545_F491_4F6C_DD1Du64;
    for &w in &key.0 {
        route = (route ^ w).wrapping_mul(0x9E37_79B9_7F4A_7C15);
        route ^= route >> 29;
        fp = (fp ^ w).wrapping_mul(0xFF51_AFD7_ED55_8CCD);
        fp ^= fp >> 32;
    }
    (route, fp)
}
```
Four iterations = 4 multiplies + 4 shifts + 4 xors **per half**.

But the iso-band keys feed in **constant** high words:
- `graph_bits(h)` (`mod.rs:138-140`) = `[h, mix64(h^C), 0x150_600D_600D_600D, 0]` — **word[3] is
  a literal constant `0`, word[2] is a literal constant**. Two of the four `hash128` words are
  run-constant.
- `d4_bits(k)` (`mod.rs:148-156`) = `[w0, w1, w2^…, 0xD400_D4D4_D4D4_D4D4]` — **word[3] is a
  literal constant**; word[2] is derived.
- `comp_nimber_bits(h)` (`iso_flat.rs:166-173`) = `[h, mix64(h^C), 0x4E49…, 0x4E49…0000_0000]`
  — **words [2] and [3] are literal constants**.

For a constant word `wc`, its contribution to `route`/`fp` is a **fixed transform** of the
running accumulator — but the transform is nonlinear (`xor`, `mul`, `shift`), so it can't be
fully folded into the seed across a variable preceding accumulator. However: the **last** word
being constant means the final iteration's `^ wc` is a constant xor, and for `graph_bits`
specifically the constant words are the **last two** (`w[2]`, `w[3]`), so the last two loop
iterations are `acc -> mix(acc ^ const2) -> mix(acc ^ const3)` — a fixed 2-round function
`f(acc)` that LLVM **cannot** see because `hash128` is generic over all keys.

### The fusion
Provide a **specialised hash for each tagged-key family** that the iso-band builds, e.g.
`hash128_graph(h: u64) -> (u64, u64)` that:
1. Folds word[0]=`h` and word[1]=`mix64(h^C)` through the two mixers (2 rounds), then
2. Applies the **precomputed closed-form** of the last two constant-word rounds.

The last-two-rounds-on-`acc` map is a pure function of `acc` with constants baked in. For each
half it's: `acc = mix(acc ^ K2); acc = mix(acc ^ K3)` where `mix(x) = (x).wrapping_mul(M); x ^=
x>>S`. That's still 2 mul+2 shift+2 xor — so naively it saves nothing in op count. **The real
win is two-fold:**

(a) The `route` and `fp` halves for words 2 and 3 use **constant inputs**, so `route ^ w` and
`fp ^ w` become `route ^ K` — the compiler can fold the xor-with-constant but **not** skip the
multiply. Net op saving here is small (2 xors → folded), so by itself this is marginal.

(b) The structural win: because `graph_bits`/`comp_nimber_bits` carry **no information** in
words 2-3 (they're tags, identical for every key in the namespace), those two rounds add
**zero discrimination** — they only spread already-fixed bits. The minimal correct hash for a
band key is: route/fp derived from `h` and `mix64(h^C)` (the only varying inputs) plus the
**namespace tag mixed in once**. I.e. compute `(route, fp)` from a **2-word fold** of `[h,
mix64(h^C)]` then xor in a per-namespace constant pair. That **halves** `hash128`'s loop (2
rounds, not 4) for every band-entry, tiny, and nimber key.

This is the quantification the prompt asked for: **2 of 4 rounds are dead mixing** on band/D4/
nimber keys — they process constant tag words that never discriminate. Halving the fold is
~−2 mul −2 shift −4 xor per key build.

### Cost / Fermi
`hash128` runs on **every** node (band entry, tiny, D4 child, nimber). For the band/iso path it's
called via `graph_key`/`iso_node_key`→`hash128`. Cutting 4 rounds to 2 is **~−50% of `hash128`'s
ALU work** on those keys. `hash128` isn't the top hog but it's ubiquitous and frontend-bound code;
removing 2 mul-chains/key tightens the critical recurrence (each round depends on the prior). Call
it low-single-digit-% wall, broadly applied.

### Correctness / gate — needs `TT_HASH_ID` bump
This **changes the fingerprint and route values** (a different hash). Discrimination is preserved
as long as the 2-word fold of `[h, mix64(h^C)]` is injective enough in the 55-bit fp + routing
bits — it is, because `h` is the full 64-bit iso key and `mix64(h^C)` is an independent avalanche
of it, so the fp half still sees 64 bits of key entropy mixed by an independent constant. The
collision rate stays ~2⁻⁵⁵. Because route/fp **change**, bump `TT_HASH_ID` (`tt.rs:312`) — allowed
per the prompt since discrimination holds. Gate: `solve 12 iso-flat --distinct == 1,060,823`
(distinct count is over the *keys*, which don't change — only their hash does, so the HLL fold
must still see the same `Bits` keys; **the `--distinct` path uses the full 256-bit `Bits` key, not
this specialised hash**, so the count is invariant). Re-exp must hold ≈1.0× at n=14 (a worse hash
would raise collisions → re-exp). **A/B the re-exp explicitly.**

⚠️ Subtlety: D4 keys (`d4_bits`) only have **one** constant word (word[3]); word[2] is derived
from `w[2]^w[3]^const`. So for D4 keys only the **last** round is constant-input — the saving is
1 round, not 2. Keep `graph_bits`/`comp_nimber_bits` (2 constant words) as the high-value targets;
D4 is a smaller win and on the *non*-band path.

---

## Finding 4 — `graph_bits` word[1]: the `mix64` may be redundant against `hash128`

### Current code
`graph_bits(h)` (`mod.rs:138-140`):
```rust
Bits([h, mix64(h ^ 0x9E37_79B9_7F4A_7C15), 0x150_600D_600D_600D, 0])
```
word[1] is `mix64(h ^ C)` — a full SplitMix64 finalizer (5 ops) — computed **so that `hash128`
sees two decorrelated words of the key**. But `hash128` *itself* already runs each word through
independent strong mixers (`route` uses `0x9E3779B9…` + shift-29; `fp` uses `0xFF51AFD7…` +
shift-32). Feeding word[0]=`h` and word[1]=`mix64(h^C)` means `h` is mixed twice before it
reaches the fp half.

### The observation
If Finding 3 is taken (specialised 2-word hash from `[h, mix64(h^C)]`), then `mix64(h^C)` is the
**only** decorrelating word and is load-bearing — keep it. **But** consider collapsing
`graph_bits` + `hash128` into a **single `(route, fp)` derivation directly from `h`**:
- `route = mix_a(h)`, `fp = mix_b(h)` where `mix_a`/`mix_b` are two independent 64-bit finalizers.
This is what the band key fundamentally is: a 64-bit iso key `h` hashed to a (route, fp) pair. The
intermediate `Bits([h, mix64(h^C), tag2, 0])` → `hash128`'s 4-round fold is a **roundabout
2-finalizer**. A direct `(mix_a(h), mix_b(h))` is 2 finalizers (~10 ops) vs `mix64` (5) +
4-round `hash128` (~24 ops) = **~−19 ops per band/tiny key build**.

The namespace tag (to keep graph keys disjoint from D4/nimber keys in the **same** flat TT) folds
in as a constant xor into the seed of `mix_b` — one xor, not two tag words through 4 rounds.

### Cost / Fermi
This is Finding 3 taken to its limit: **`graph_bits → hash128` for an iso-band key becomes two
finalizers of `h` plus a constant tag xor.** Removes the `mix64` *and* 2 of the 4 hash rounds.
~−19 ALU ops per band/tiny key — these are on the hottest deep path (`graph_key` at
`iso_flat.rs:881-885`, `iso_node_key` at `487-496`). Aggregate: this is the single biggest
*instruction-count* reduction in the pass after Finding 1, because it collapses three layers
(`graph_bits`, `mix64`, `hash128`) that each independently re-mix the same 64 bits.

### Correctness / gate — needs `TT_HASH_ID` bump
Changes route/fp ⇒ bump `TT_HASH_ID`. The namespace disjointness (graph vs D4 vs nimber) **must**
be preserved — today it's via distinct constant tag words in `graph_bits`/`d4_bits`/
`comp_nimber_bits`; replace with distinct seed constants in the per-family finalizers, and verify
the three families can still coexist in the flat TT without aliasing (they collide only at the
~2⁻⁵⁵ fp rate, *and* their routes differ by construction). **This is an architecture-adjacent
change to the keying** (it merges the namespace-tagging layer into the hash) — per CLAUDE.md
intent-mode rules, **surface to the user before implementing**; it locks in the keying scheme.
Gate: exact `--distinct` (key `Bits` unchanged on the COUNT path; only production hash changes)
+ n=14 re-exp ≈1.0× (a 2-finalizer hash of a 64-bit `h` is a strong, standard construction;
re-exp must confirm no collision regression).

**Sequencing**: Finding 3 and 4 overlap; 4 subsumes 3 for graph/nimber keys. Do them as one
design: "specialised band-key hash". Measure re-exp carefully — this is the one place a weaker
hash could silently raise the node count.

---

## Finding 5 — `w8_get`: fuse vert extraction into the code loop

### Current code (`iso_flat.rs:300-320`)
```rust
let mut verts = [0u8; 8];
let mut n = 0usize;
avail.each(|v| { verts[n] = v as u8; n += 1; });   // PASS 1: scan avail (closure, 4-word)
let mut code = 0usize;
let mut bit = 0u32;
for i in 0..8 {
    let row = att08(att, verts[i]);
    for &vj in verts.iter().take(8).skip(i + 1) {
        code |= (row.get(vj as u32) as usize) << bit;
        bit += 1;
    }
}
dense8.get(8, code)
```

### The observation
`avail.each` is a closure over the 4-word `Bits` with a `FnMut` and an internal `while w!=0`
loop — it's the same `tzcnt`/`blsr` scan written as a higher-order call. For a known
**exactly-8-vertex** mask, a direct flat scan (`for each word: while w!=0 { tzcnt; blsr }`)
inlined into `verts[]` extraction avoids the closure-call shape and lets LLVM keep `n` in a
register without the `FnMut` capture. This is the same change the broad pass found for the *code*
build (per-row `pext`); here the target is the **extraction half**, which the broad pass didn't
touch.

Also: the inner `code` build is identical in shape to `tiny_edge_code` / `iso_key8_direct`
(`graph.rs:1055-1063`) — they could share one branchless `const K` helper to avoid three copies
drifting. The broad pass already proposed `pext` for the per-row edge bits; this finding is the
**extraction** + **dedup** with `iso_key8_direct`.

### Cost / Fermi / gate
`w8_get` is ~6% cycles. Removing the closure dispatch + a half-pass is a fraction of that —
low-single-digit-% of 6%, so **small** but pure upside, byte-identical `code` ⇒ no ID bump,
`solve 12` unaffected (w8_get only fires at pc==8 under WINDOW). A/B: CPI on the pc==8 slice.
Flag: likely a near-wash if LLVM already inlines `each` fully; verify in disassembly first.

---

## Finding 6 — `enter_graph` rank sort: replace gather+insertion-sort with an `order8` filter

### Current code (`iso_flat.rs:944-957`)
```rust
let rank = self.order_rank(q);
let mut verts = [0u8; MAXV_TINY];
let mut k0 = 0usize;
child0.each(|v| {
    let v = v as u8;
    let r = rank[v as usize];                 // L1 gather per vertex
    let mut j = k0;
    while j > 0 && rank[verts[j - 1] as usize] > r {   // L1 gather per shift compare
        verts[j] = verts[j - 1];
        j -= 1;
    }
    verts[j] = v;
    k0 += 1;
});
```
This produces `verts[]` = the `child0` squares **sorted by q.order rank** (ascending in
`order8`). It does k `rank[]` gathers for the keys plus O(k²) `rank[]` gathers in the shift
comparisons.

### The observation
The desired output is exactly "`child0`'s squares in `q.order` sequence". The solver **already
carries `order8` / the filtered `moves` list in q.order**. The `enter_graph` callsite is reached
from `band_entry`, whose parent passed `moves` (a q.order subsequence) down — and `child0 ⊆
avail ⊆ moves`. So the rank-sorted `verts[]` is obtainable by **filtering the parent's `moves`
list by membership in `child0`** — a single pass, no `rank[]` gathers, no insertion sort:
```rust
for &sq in pmoves { if avail_has8(child0, sq) { verts[k0] = sq; k0 += 1; } }
```
This is the same trick `filter_moves` (`iso_flat.rs:132-150`) already uses for the move list —
applied to the vertex extraction. It removes the O(k²) rank-gather insertion sort entirely and
reuses the byte-compressed `child0` membership test.

⚠️ Caveat: `band_entry`/`enter_graph` currently don't receive `pmoves`. Threading it in is a
signature change (cheap — it's already in registers at the `wins_inc` callsite). The result is
**byte-identical** (`order8` is the global q.order; the parent's `moves` is its subsequence; both
yield the same relative order for `child0`'s squares).

### Cost / Fermi / gate
−k `rank[]` gathers −O(k²) shift-compares per band entry, replaced by one ≤|moves| scan. On the
#1 branch-miss region. Mid value (smaller than Finding 1 but same region). Byte-identical node set
and keys ⇒ **no ID bump**, `solve 12 --distinct` exact. Combine with Finding 1 — both rework
`enter_graph`'s decomposition, so do them together: one fused pass that (a) filters `pmoves` into
rank-order `verts[]`, (b) loads each row once to build `closed`/`adj`, (c) derives `tidx` from the
same masks. A/B: branch-miss/CPI on `band_entry`.

---

## Finding 7 — first-child `att08` reload (minor)

In `wins_tiny`'s non-prove arm (`iso_flat.rs:856-868`) the loop does `avail.and_not(att08(att,
sq))` per move, and the `prove_loss` arm at `838` likewise. These are unavoidable per-child. No
fusion found beyond what's there — the `att08` load is the child computation. **Flagged as
examined, no change.** (The broad pass's `child_orient → vpandnq` covers the D4 arm's 7 and-nots;
the tiny arm has only the single `[0]` and-not, already minimal.)

---

## Finding 8 — `popcount` recompute in `wins_inc` entry (WASH)

`wins_inc` computes `node_pc = if MODE==M_NORMAL {0} else {avail.popcount()}` (`iso_flat.rs:692-
696`), then the ORACLE arm computes `avail.popcount()` **again** at `700`. In the production
`MODE=M_NORMAL, ORACLE=false` monomorphisation **both are const-folded away** (node_pc=0 unused,
ORACLE arm dead), so this is a **wash in production** — only the (off-by-default) oracle/segment
builds recompute. No action. **Flagged so a future reader doesn't "fix" a dead-in-prod path.**

Likewise `child0.popcount()` at the dispatch (`729`, `776`) is computed once and threaded as `pc`
into `band_entry`/`iso_node_key`/`w8_get` — already CSE'd. Good. (`iso_node_key` takes `pc` and
does **not** recompute it; `iso_key_tiny_table_pc` takes `pc` too — verified no double popcount.)

---

## Cross-cutting notes (verified, not separate findings)

- **`iso_key_fast` / `comp_canon` / WL path is DEAD** at the default `iso_max_avail=7`
  (`node_key`/`iso_node_key` reach it only at `pc>7 && pc<=iso_max_avail`). The entire
  `wl_refine_in`/`comp_canon_full`/`canon5_key`/`canon6_key`/`IsoScratch` machinery in `graph.rs`
  is unreachable from the production iso-window hot path — **do not spend op-fusion effort there.**
  Confirmed: only callers are `iso_key_fast`/`tally_components` (cold) and the `pc==8 &&
  tiny8_direct` experimental branch (off by default).
- **`d4_bits` word[2]/[3] dead entropy** (the prompt's note): word[3] is the literal constant
  `0xD400_D4D4_D4D4_D4D4`; word[2] = `w2 ^ w3.rotate_left(32) ^ const`. So the D4 key carries
  real info only in words 0,1, and a *folded* word 2. `hash128` still grinds all four. Finding 3
  applies (1 dead round for D4); the D4 path is **not** the iso-band hot path, so lower priority.
- **`comp_nimber_bits`** (`iso_flat.rs:166-173`) calls `mix64(h ^ const)` for word[1] and carries
  two constant tail words — same shape as `graph_bits`. Findings 3/4 apply identically. But the
  nimber oracle is **off by default**, so this is only relevant if Lever-B is revived. Note it,
  don't prioritise.
- **`solve_local`** (`iso_flat.rs:1012-1031`) is already optimal: `alive & !g.closed[i]`,
  `rem &= rem-1` (`blsr`), `trailing_zeros` (`tzcnt`), 128-byte L1 memo. No fusion — the only
  per-node op is one `u8` and-not and a memo load. Leave it.
- **`expand_graph` prefetch-gather** (`iso_flat.rs:1073-1086`) pre-issues all child prefetches —
  correct MLP design, no change.

---

## Recommended sequencing

1. **Finding 1 + Finding 6 together** — one rewrite of `enter_graph`'s decomposition into a
   single fused pass (filter `pmoves`→rank verts, one row-load to build `closed`/`adj`, derive
   `tidx` from the same masks). Byte-identical, no ID bump, biggest concrete win, on the #1
   branch-miss site. Gate: `solve 12 --distinct` exact + n=14 re-exp + A/B branch-miss.
2. **Finding 2** — reorder the dispatch ladder (`pc<=7` first). Trivial, byte-identical, verify
   the compiler isn't already doing it.
3. **Finding 3 → Finding 4 as one "specialised band-key hash" design** — surface to the user
   first (touches the keying scheme + needs `TT_HASH_ID` bump). Biggest instruction-count cut but
   the one place a weaker hash could raise re-exp, so measure re-exp explicitly.
4. **Finding 5** — `w8_get` extraction fuse + dedup with `iso_key8_direct`; small, verify against
   disassembly for wash.

All gates: `solve 12 iso-flat --distinct == 1,060,823` exactly, `solver_lineage_agrees`, n=14
re-exp ≈1.0×. A/B interleaved (this box thermally throttles ~1s on a ~12s n=14), on n=16
partial-throughput CPI/branch-miss (node-count-independent) per the prompt.
