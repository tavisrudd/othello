# Queens — SoA / cold-side-car opportunities (research findings)

**Date**: 2026-06-16
**Type**: research findings (not a handoff, not a proposal — a snapshot of layout opportunities)
**Scope**: data-structure layout of the live D4 hot path — where explicit data/keying could go
implicit via array alignment, and which bits in hot L1d belong in cold side-cars.
**References**: [hot-path map](queens-hot-path-map.md) ·
[canon-kernel design](2026-06-16-canon-kernel-design.md) ·
[inner-loop-rewrite handoff](handoffs/2026-06-16-queens-inner-loop-rewrite.md) ·
`rust/src/queens.rs` · `rust/src/burr.rs`

## The frame

The search is TT/DRAM-latency- and L1i/frontend-bound, and per-node micro-opts wash (perf facts in
CLAUDE.md / the roadmap). So **none of the layout items below are stand-alone perf levers** — they
are L1d relief + Tiger-style discipline. The two with leverage are strategic, not cycle-shaving:
the implicit-keying = BuRR framing (§Q1.3) and the GFNI canon rewrite the inner-loop handoff
de-risks. Everything here is sized against that reality, with the negatives documented so they are
not re-proposed.

## What the live hot path pulls into L1d (per node)

Production path: `wins_keyed_in` → `node_key` → `pos_key` → `canon` → `hash128` → `index` →
`slots[i]`. Per-node working set beyond the TT probe:

| Source                       | What                                       | @ n=16         | Access            |
|------------------------------|--------------------------------------------|----------------|-------------------|
| `q.order` (`queens.rs:143`)  | `Vec<u32>`, scanned every node             | ~1 KB          | sequential        |
| `q.attack` (`queens.rs:142`) | `Vec<Bits>`, `place` indexes `[sq]`        | ~8 KB          | sq-random         |
| `q.sym` (`queens.rs:144`)    | `Vec<Vec<u32>>`, `canon` indexes `[t][s]`  | ~8 KB + chases | per-set-bit scatter |
| `q.board`                    | one `Bits`                                 | 32 B           | hot               |
| TT                           | `slots[index]`                             | DRAM           | random probe      |

`sym` is both the fattest non-TT source and the only pointer-chased one.

## Q1 — SoA / making explicit keying implicit via array alignment

### Q1.1 — `sym: Vec<Vec<u32>>` → flat `Box<[u8]>` (AoS-of-pointers, the textbook case)

Violates Tiger rule #2 (contiguous storage, never `Vec<Vec>`) directly. `canon` (`queens.rs:646`)
runs `for t in 1..8 { mask.each(|s| img.set(sym[t][s])) }`: per set bit it chases the outer pointer
`sym[t]`, then indexes `[s]` — two dependent loads. Flatten to one allocation indexed
`perm[t*n² + s]`, and since square indices are < 256 store `u8` not `u32` (CLAUDE "size to range").

- Wins: contiguity (one chase, not two) **and** width (≈8 KB → ≈2 KB at n=16, 4× less L1d).
- **Dependency that sets priority**: the GFNI rewrite (Variant A) replaces the per-bit scatter with
  bitboard transforms and stops touching `sym` for `canon` entirely. So do this **iff Step 1 does
  not validate**. `sym` survives regardless for `mirror` / `is_free_involution_loss`, so the flatten
  is never wasted, but its hot-loop payoff evaporates if the kernel lands.

### Q1.2 — `order: Vec<u32>` → `Box<[u8]>`

Scanned every node (`queens.rs:1430`); squares < 256. ~1 KB → ~256 B at n=16. Small, but unlike
`sym` it **survives the rewrite** (movegen still scans `order`), so it is not mooted. Pocket item.

### Q1.3 — implicit keying via row position = the BuRR ply-window lever (the strategic one)

Today every node carries an explicit 256-bit canonical key → `hash128` → a **55-bit fingerprint
stored in the slot** (`Slot`, `queens.rs:2215`) answering "which key lives here." That fingerprint
*is* the explicit keying.

The BuRR ply-window path is exactly the make-it-implicit move: when membership at a ply is known a
priori, `Archive` drops `fp_bits → 0` (`burr.rs:333-337`) — the key becomes implicit in the ribbon
**row position**, value-only (~1 bit/key). That is the SoA-implicit-keying trick at the archive
layer, and it is the load-bearing reason the ply-window freeze is the <30-min lever.

- The **live** cascade-as-TT-tier cannot drop fingerprints (it needs them for membership routing).
- So the open Chunk-4 design choice is precisely *which positions have a-priori-known membership* so
  their key can go implicit. **Framing the freeze that way — push `fp_bits=0` wherever a ply window
  has known membership — is where this idea pays**, not in the live DFS slot.

### Q1.4 — attack-table layout for the rewrite (only if Variant B)

Variant B of the kernel maintains 8 orientation frames and needs `attack_t[sq]` ≈ 64 KB, which
spills L1d into L2 (canon-kernel design §kernel). The hot access is "all 8 frames of `attack[sq]`
for one sq," so if B is used, store **AoS-by-square** (`[sq][t]`, the 8 frames contiguous) not
SoA-by-orientation (`[t][sq]`, 8 scattered lines). The cleaner answer is **Variant A recompute**,
which has *zero* attack-table L1d footprint — which is why the design says start with A. Pre-register
this only as the fallback layout if Step 1 shows A borderline.

## Q2 — cold side-cars (bits in hot L1d that belong cold)

### Q2.1 — box the measurement state out of the hot structs (clean, low-risk)

Two hot structs the search holds by `&self` inline measurement-only fields:

- `QueensTt.counter: Option<Counter>` (`queens.rs:2194`) — `Counter` is `Hll{Vec}` +
  `Option<Mutex<HashMap>>`, ≈80 B inline; production is `None` but it pads the header
  (`slots`/`len`/`nodes`) onto a second line.
- `Tt.tally: Tally` (`queens.rs:1244`) — 5×`AtomicU64` + `[AtomicU64;8]` ≈ 104 B, plus the
  `branching` flag; never touched when `branching=false`.

Fix per Tiger rule #6 (cold fields in a sibling): `Option<Box<Counter>>` /
`Option<Box<Measurement>>`. `None` becomes a null word; both hot structs collapse to one cache line.
This is hygiene, not a perf lever (the structs are read-mostly, hot fields already first) — fold it
into the next edit of `Tt` / `QueensTt`.

### Q2.2 — already SoA on the cold side (no action)

`IsoScratch` (`queens.rs:209`) is already the parallel-array SoA pattern the question is reaching
for — per-local-vertex arrays (`col`/`nxt`/`base`/`sigs`/…), `u8`/`u16`/`u64` each sized to range,
zero-alloc per call. It is the freeze/graph-key path, so its (large) footprint never hits the live
DFS L1d. Cited as the in-repo template, not a target.

## Documented negatives (considered, rejected — do not re-propose)

- **De-contend the `nodes` atomic** (`queens.rs:2191`, bumped per distinct node). Looks like the
  cross-core sharing a lockless TT removes, but Fermi: at ~20–33k cyc/distinct-node × 24 cores ≈
  ~5M bumps/s to one line; ~5M cross-core transfers × ~100 ns ≈ ~0.5 s aggregate stall over a
  ~2500 s solve ≈ **~0.02%**. Per-node work dwarfs the bump frequency. Not worth a thread-local fold.
- **SoA the TT `Slot`** into a `used`/`val` bit-plane + a separate `fp` array. Wrong: the probe needs
  `{used, fp, val}` at one address; splitting doubles the random DRAM round-trips per probe on a
  latency-bound table. The one-`u64` self-describing slot is AoS *because* the table is
  latency-bound. Keep it.
- **Widen `fp` into the dead `val` bits** for the win/loss search (val is 1 bit, slot reserves 8 for
  nimber). Collision is already ~2⁻⁵⁵ and cross-checked vs Jenrich — no benefit. Skip.

## Priority (when the tree is free; no code yet)

| # | Item                                          | Why / dependency                                  |
|---|-----------------------------------------------|---------------------------------------------------|
| 1 | Frame the freeze around implicit keying (Q1.3)| Strategic; feeds the Chunk-4 decision owed the user|
| 2 | Box `counter`/`tally` cold side-cars (Q2.1)   | Free discipline; fold into next `Tt`/`QueensTt` edit|
| 3 | Shrink `order` u32→u8 (Q1.2)                   | Free; survives the rewrite                        |
| 4 | Flatten+shrink `sym` (Q1.1)                    | Only if Step 1 kernel does **not** validate       |
| — | `nodes` atomic, slot split, fp widen          | Negatives above — skip                            |

Through-line: items 2–4 are L1d relief + discipline, not perf levers (the search is
latency/frontend-bound; micro-opts wash). The teeth are item 1 (implicit keying = BuRR) and the
GFNI canon rewrite already in flight.
