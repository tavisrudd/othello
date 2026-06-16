# Queens solver — hot-path & instrumentation map

**Date**: 2026-06-16 (snapshot — line numbers drift; grep the symbol if a line is off)
**Purpose**: Reference map of `rust/src/queens.rs` + `rust/src/bin/queens.rs` for the inner-loop
rewrite + measurement work. Companion to
[the inner-loop-rewrite handoff](handoffs/2026-06-16-queens-inner-loop-rewrite.md) and
[the theoretical floor doc](2026-06-16-queens-theoretical-floor.md).

## Quick reference (file:line)

| Component | File:Line |
|-----------|-----------|
| `Bits` struct (`[u64;4]`, 256-bit) | `queens.rs:65` |
| `Queens` struct (board/attack/order/sym) | `queens.rs:139` |
| `Queens::place` (`blocked.or(attack[sq])`) | `queens.rs:583` |
| `attack` table build | `queens.rs:520-537` |
| `Queens::canon` (D4 8-fold — **the re-fold to replace**) | `queens.rs:646` |
| `Queens::pos_key` (canon of `available`) | `queens.rs:668` |
| `symmetry` / `sym[t][s]` table | `queens.rs:492-506` |
| `iso_key` / `_ir` / `_canon` / `_fast` | `queens.rs:687` / `704` / `748` / `772` |
| `iso_key_fast_in::<const HIST>` (**monomorphisation template**) | `queens.rs:803` |
| `tally_components` (HIST=true entry) | `queens.rs:790` |
| `comp_canon` (+ tiny-component #18 shortcut) | `queens.rs:836` |
| `comp_canon_full` (WL + IR fallback) | `queens.rs:872` |
| `tiny_comp_key` (sorted-degree, k≤4) | `queens.rs:410` |
| `canon_cert` (branching IR certificate) | `queens.rs:432` |
| `wl_refine_in` (TMA-opt inner WL) | `queens.rs:311` |
| `Solver` trait | `queens.rs:1105-1159` |
| `Tt::wins_keyed` (**sequential cutoff search**) | `queens.rs:1355-1386` |
| `Tt::node_key` (D4 vs graph-iso selector) | `queens.rs:1329` |
| `Parallel::par_wins` (parity-YBWC) | `queens.rs:1495` |
| `Naive::wins` (no-memo ground truth) | `queens.rs:1178` |
| `graph_bits` (pack 64-bit key → `Bits`, sentinel bit 255) | `queens.rs:1237` |
| `make_solver` factory | `queens.rs:1944` |
| `QueensTt::get` / `put` / `prefetch` / `bump` | `queens.rs:2391` / `2407` / `2421` / `2366` |
| `Counter` (HLL + exact-set) / `attach_counter` | `queens.rs:1977` / `2504` |
| `Hll::add` (lock-free) | `queens.rs:2020` |
| `Cmd` enum (clap) / `count_mode` / main dispatch | `bin/queens.rs:110` / `1188` / `253` |
| `iso_report` / `comps_report` / `psym_report` / `roots_report` | `bin/queens.rs:1513` / `1473` / `1423` / `1285` |

## 1. Board representation

`Bits([u64; WORDS])`, `WORDS=4` ⇒ 256 bits (n≤16), 32 bytes. Derived lexicographic `Ord`/`Hash`
on the words — the total order used to pick the canonical representative.

```rust
pub fn is_available(&self, blocked: Bits, sq: u32) -> bool { self.board.get(sq) && !blocked.get(sq) }
pub fn no_moves(&self, blocked: Bits) -> bool { self.board.or(blocked) == blocked }
pub fn place(&self, blocked: Bits, sq: u32) -> Bits { blocked.or(self.attack[sq as usize]) }
```

`attack: Vec<Bits>` (n² entries), precomputed at construction: each square's row + column + both
diagonals (self-inclusive). `Bits` ops (`or`/`and`/`and_not`/`popcount`/`each`/`lowest`) are
plain `[u64;4]` loops — **scalar, not yet vectorised** (the rewrite target).

## 2. Canonicalisation (the cost the rewrite attacks)

`pos_key` canonicalises `available` (`board & !blocked`), not `blocked` — merges identical classes
while folding fewer bits (Lever 1).

```rust
fn canon(&self, mask: Bits) -> Bits {
    let mut best = mask;
    for t in 1..8 {                                  // 8 dihedral orientations
        let perm = &self.sym[t];
        let mut img = Bits::ZERO;
        mask.each(|s| img.set(perm[s as usize]));    // <-- per-bit scatter = the fat
        if img < best { best = img; }                // lexicographic min
    }
    best
}
```

The **rewrite replaces this re-fold** with 8 orientations held live + incremental update +
`vpminuq` reduction (see handoff "optimal node kernel").

`sym[t][s]` is a precomputed permutation table; `symmetry(t,r,c,n)` defines the 8 transforms
(identity, rot90/180/270, flip-h/v, transpose, anti-transpose).

Graph-iso keys (`iso_key*`) are the **cold measurement path** (WL refinement + IR certificate);
used freeze-time, not live (4.33× slower/node). `comp_canon` decomposes into components, with the
`tiny_comp_key` shortcut for k≤4 (#18) and a per-thread `COMP_CACHE` for k>4 (#19).

## 3. Movegen + recursion (where the canon is called per edge)

```rust
fn wins_keyed(&self, q: &Queens, blocked: Bits, key: Bits) -> bool {
    if let Some(w) = self.tt.get(key) { return w != 0; }   // TT probe
    self.tt.bump();                                          // count node expansion (miss)
    let mut result = false;
    for &sq in &q.order {                                    // forcing order: most-blocking first
        if !q.is_available(blocked, sq) { continue; }
        let child = q.place(blocked, sq);
        if q.no_moves(child) { result = true; break; }       // terminal fast path
        let ckey = self.node_key(q, child);                  // <-- CANON per edge (the b̄ multiplier)
        self.tt.prefetch(ckey);
        if !self.wins_keyed(q, child, ckey) { result = true; break; }  // negamax cutoff
    }
    self.tt.put(key, result as u8);
    result
}
```

`node_key` selects D4 (`pos_key`) or a graph-iso key (selective by `available.popcount() >
max_avail` → `QUEENS_KEY` / `QUEENS_KEY_MAX`, resolved once in the ctor).

`Parallel::par_wins` (the n≥15 default): **even/prove-a-loss plies fan all children across rayon**
(no α-β cutoff to lose → zero speculation), **odd/prove-a-win plies stay sequential** (cutoff
preserved). Drops to sequential below `par_depth` + `min_avail` (#20 size split).

## 4. Instrumentation pattern (the template to copy)

Zero production cost via a `const` generic resolved at the call site — the disabled branch never
reaches the instruction stream:

```rust
pub fn iso_key_fast(&self, mask: Bits) -> u64 {                 // production: HIST=false
    ISO_SCRATCH.with(|s| self.iso_key_fast_in::<false>(mask, &mut s.borrow_mut(), &mut []))
}
pub fn tally_components(&self, mask: Bits, hist: &mut [u64]) {  // measurement: HIST=true
    ISO_SCRATCH.with(|s| self.iso_key_fast_in::<true>(mask, &mut s.borrow_mut(), hist));
}
fn iso_key_fast_in<const HIST: bool>(&self, mask: Bits, s: &mut IsoScratch, hist: &mut [u64]) -> u64 {
    // ... main logic ...
    if HIST { hist[k.min(hist.len()-1)] += 1; }   // compile-time eliminated in production
    // ...
}
```

The TT also carries observation hooks: `QueensTt::get` → `Counter::feed(key)` (folds every probe
into a HyperLogLog), `put` → `Counter::record(key,val)` (exact set, eviction-proof). `attach_counter`
turns these on for `count` mode. `bump()` counts node expansions (TT misses).

## 5. CLI dispatch (where to add a measurement)

`Cmd` enum (clap `Subcommand`, `bin/queens.rs:110`): `Solve`, `Nimber`, `Count{ n, parallel,
exact, iso, comps, psym, roots, hll_p }`, `SelfPlay`, `Play`, `Freeze`, `VerifyArchive`. `count_mode`
(`:1188`) builds a counting solver, runs the search, then calls the sub-reports (`iso_report` /
`comps_report` / `psym_report`). A new measurement = a new `--flag` on `Cmd::Count` + a
`*_report(q, solver)` following `comps_report`'s shape (it reads `solver.working_set()` — the exact
recorded positions — and tallies).

## 6. Counters / atomics available for reuse

`QueensTt.nodes: AtomicU64` (via `bump()`), `Solver::nodes()`/`report()`/`working_set()`. For a new
per-node/per-edge tally, prefer the `const HIST` monomorphisation (zero production cost) over a new
atomic in the hot loop; if a running tally is needed, a thread-local (like `ISO_SCRATCH` /
`COMP_CACHE`) folded at the end avoids hot-path atomics.
