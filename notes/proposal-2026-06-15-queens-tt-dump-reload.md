# Proposal: Dumpable / reloadable QueensTt (n=16 checkpoint + resume + cross-run accumulation)

## Status

Draft — **queued for next session (decision recorded 2026-06-15, session 2026-06-15--10).**

### Session-7 decision (2026-06-15)

Build **Approach A (raw flat image) = Phase 1** as the MVP next session — `QueensTt::dump`
/ `load` (validated header + raw slot bytes), `solve … --resume <path>`, and a **SIGUSR2 →
dump-now** handler. Keep B2 (full-key sparse export) and the distributed extension as the
later phases per the Recommendation below; A is the simple, high-value first slice. Raw
read/write, **not** mmap (deferred — THP/TLB regression).

**Add a first-class payoff this proposal under-weights: a reproducible n=16 *benchmark
fixture*.** Session 7 made n=16 run multi-core for the first time (parity-YBWC fix, commit
`2f51aa5`; first live run ≈9.7B nodes, 1.4× re-exp, full 24 cores, ~tens of min vs Jenrich
23 h). All session, A/B measurement was forced onto n=14 (the *wrong* board — too short; the
parallel fan-out is a brief burst, not the n=16 regime) or onto cold partial-n=16 runs
(slow, noisy, contended). A **dumped mid-search n=16 state** (via SIGUSR2 on a live run) is a
deep, TT-oversubscribed fixture: load it, run a fixed time, compare nodes/s on the frontier
under code A vs B from the *identical* start state — no 36-min cold start. This is the clean
way to measure backlog **#20** (size-based parallel split — the single-core-tail fix) and all
future per-node / memory levers. So Phase 1 (Approach A, raw image) directly serves the
benchmark-fixture use; B2's mergeability isn't needed for it.

**Resume is automatic via TT warmth** (sharpening the CRDT framing below for the resume
case): load the table, re-run `first_player_wins`; already-solved root subtrees hit the
cached value instantly and fast-forward, unsolved ones continue — *the TT is the progress*,
no explicit move-list tracking. A mid-search snapshot is always a valid partial memo (each
slot is one atomic `u64`, never torn), so a SIGUSR2 dump under concurrent writes resumes
correctly (this resolves Open Q1 in favour of "good-enough-live").

**Checkpoint cadence + compression (user requirements, 2026-06-15) — fold into Phase 1/3:**
- **Periodic checkpoint every ~5 min** during a run (decides Open Q2 → time-based; default
  `--every 5m`, overridable), **plus a final save on normal exit**, **plus** the manual
  SIGUSR2 snapshot. A background timer (or a check at root-job boundaries) triggers the dump;
  good-enough-live consistency is fine (per above). Rotate/overwrite so disk stays bounded
  (keep latest + maybe one prior), since a full image is the TT size each time.
- **Compress the dumps** (decided): the raw image is mostly-zero early ⇒ highly compressible;
  stream through **zstd** (add the crate — ecosystem-deps rule). Early checkpoints become tiny;
  late ones shrink modestly. `load` decompresses on the way in. (Approach A already noted this.)
- **Deltas later (if possible — it is):** to avoid re-writing the whole image every 5 min,
  a checkpoint can be the **B2 full-key export of positions proven *since the last
  checkpoint*** (an epoch watermark). This is exactly the proposal's delta mechanism (Phase 2
  B2 + the `epoch` header field + the grow-only-CRDT property): deltas union-merge on load,
  order-independent. So: MVP = full compressed image every 5 min + final; **optimization =
  delta checkpoints (B2-since-epoch)** once Phase 2 lands. Keep the `epoch` header field from
  day one so deltas need no format change (already in the Recommendation).

**Build order for next session: do backlog #21 (PV no-grind) FIRST, then this dump/load.**
#21 is small and unblocks clean n=16 finishes; dump/load is the larger build that produces
the benchmark fixture + checkpoint/resume.

(The handoffs-queue entry `notes/handoffs/2026-06-15-tt-dump-load.md` is a thin pointer to
this proposal — this doc is the canonical design.)

## Problem

n=16 win/loss is the open frontier. A full run is **long (hours to days) and
fragile**: project discipline is to not fire one off casually during development —
size it with HyperLogLog and extrapolate first (`CLAUDE.md`) — but the eventual goal
*is* to complete it, and a single uninterrupted multi-day run loses everything to one
reboot, preemption, or thermal derail. Today the transposition table (`QueensTt`,
`rust/src/queens.rs:1051`) is a pure in-RAM `Box<[AtomicU64]>` that dies with the
process. That means:

- **No crash/preempt/reboot survival.** A multi-hour partial search throws away every
  proven sub-position if the box reboots, the run is killed, or it thermally derails.
- **No cross-run accumulation.** Two separate n=16 attempts can't pool their solved
  positions; each starts cold.
- **No warm start / opening book.** We can't ship or reuse a precomputed set of
  proven subgames to seed a fresh search.

We want `QueensTt` to be **dumpable to disk and reloadable into a fresh process**, so
a long run becomes a checkpoint/resume problem and proven work is permanent.

## Context

### The property that makes this easy

A `Slot` (`rust/src/queens.rs:1078`) stores the **resolved** win/loss bit or the
**true** Sprague-Grundy nimber of the canonical `available`-mask position — an
absolute combinatorial fact, not a depth/window-qualified search artifact. (The
lockless-TT correctness argument at `:1044` already leans on "the value stored for a
key is deterministic".) Consequences:

- A dump is a **permanent partial proof**, valid forever — unlike a normal
  alpha-beta TT entry, which carries depth + lower/upper/exact flags and is only
  usable inside a window.
- Reload is **trivially sound**: no staleness, no depth bookkeeping; even concurrent
  writers for the same key agree, so last-writer-wins on replay is fine.

### The representation is already dump-ready

`slots: Box<[AtomicU64]>` (`:1052`) is `2^bits` contiguous plain `u64`s — POD by
construction, no pointers, no `Vec`-in-slot (Tiger-style hot-struct rules #1–#2).
There is nothing to *serialize*; we write the bytes (satisfies rule #8, "operate on
the in-memory rep across stages", with no new dep). Each slot packs used(1) + val(8)
+ a 55-bit **fingerprint** of the key (not the key itself); the slot index is
`route & index_mask` where `route` is an *independent* hash half (`hash128`,
`:1217`). The only non-slot state — `index_mask`, `nodes`, `counter` — is derivable
from `bits` or non-persistent.

### The invariants a reload depends on

Because the slot stores a fingerprint, **not** the key, the routing is unrecoverable
unless the reader reproduces it exactly. A dump is sound to reload only into a table
with the *same*:

- **`bits`** — index is `route & index_mask` (`:1240`); a different size re-routes
  every entry and the route bits can't be recomputed from a stored fp. **You cannot
  re-key an image/sparse dump into a different size.**
- **`hash128` identity** (`:1217`) — both the route and fp halves' seeds/constants.
- **`canon` / `pos_key` version** (`:250` / `:272`) — the key *is* the canonical
  mask. A canon change doesn't make results *wrong* (a re-routed entry just misses
  and re-searches), but it silently voids every hit, making the dump useless. Must be
  tagged so a stale dump is rejected, not quietly wasted.
- **`n`** and a **`Slot`-layout / format version** + **arch/endianness** tag (raw LE
  `u64`; fine same-box, cheap insurance against a future cross-arch mistake).

A header mismatch must be a **hard error**.

### Prior art in our own roadmap

`notes/handoffs/2026-06-15-queens-memory-roadmap.md` **Chunk 4** ("LSM-tree TT with
BuRR archive") already wants to *"periodically freeze the solved entries into an
immutable layer."* A dump-by-key of proven positions is exactly that freeze
primitive, one rung below the BuRR-compressed layer. So this work is the **first
concrete step of the load-bearing chunk**, not a detour.

`mmap`-backed persistence (make the file *be* the table) was considered and
**deferred**: file-backed mappings generally don't get the transparent huge pages our
anonymous `vec![0u64; …]` + `MADV_HUGEPAGE` gets (`zeroed_huge_atomics`, `:1119`), and
the search is TLB/DRAM-latency-bound — the Session-5 huge-page win rests on the anon
mapping. Trading that for free persistence needs an interleaved A/B before it's even a
candidate. Out of scope here.

---

## Approach A: Raw image dump

### Architecture

Treat `slots` as a flat byte array. Write `header || raw_bytes(&slots)`; reload by
`read_exact` straight into a fresh `zeroed_huge_atomics(2^bits)` buffer.

```
Header (fixed, ~64 B):
  magic: [u8; 8] = b"QNSTT\0\0\0"
  format_version: u32        // Slot layout: FP_BITS, shifts, val semantics
  hash_id: u32               // version of hash128 seeds/constants
  canon_id: u32              // version of canon/pos_key
  n: u8
  bits: u8
  arch: u8                   // 1 = x86_64-LE
  _pad
  fill: u64                  // reporting only
Body:
  2^bits * 8 bytes, the AtomicU64 storage verbatim
```

- Dump: one `BufWriter::write_all` over `slice::from_raw_parts(slots.as_ptr() as
  *const u8, slots.len()*8)`. The empty slots are zeros → the image compresses well
  (or stream through zstd) if disk size matters.
- Reload: validate header, alloc, `read_exact` into the buffer. (No need to pre-zero;
  the read overwrites every byte — though keeping the lazy huge-page alloc is free.)

### Trade-offs

**Strengths:**
- Dead simple — ~half a day, one writer + one reader, no per-entry logic.
- Reload is sequential streaming I/O, ~tens of seconds even at tens of GB.
- Exact bit-for-bit table reconstruction (load factor, every slot preserved).

**Weaknesses:**
- Size = **full `2^bits·8`** regardless of fill (≈64 GB at bits=33), even for a 5%-full
  early checkpoint. Wasteful for the common "checkpoint often, early" pattern.
- **Not mergeable** — two images can't be unioned without materializing both tables.
- Locked to the exact `bits` it was dumped at.

---

## Approach B: Sparse `(index, val)` export

### Architecture

Scan slots once; emit only **used** ones as `(index, val)`. Since the slot doesn't
contain its index (route is independent of fp), the index is stored explicitly, but
delta-encoded: iterate ascending, write `varint(Δindex)` + `val: u8`. Reload allocates
a zeroed table and **scatters** each entry back by writing `Slot::pack`-equivalent
bytes at `index`.

```
Header: same as A, minus the body-is-image assumption (add entry_count: u64)
Body: repeated { varint(delta_index), val: u8 }   // ascending index order
```

Subtlety: the reader must re-derive the slot's **fingerprint** from the index alone —
which it can't (fp is an independent hash half, not stored per-entry in this compact
form). Two resolutions:

- **B1 (compact, fixed-size only):** store `(varint Δindex, u8 val)` *and* the low
  bits of the fp needed to re-pack the slot. But the slot needs the *full* 55-bit fp
  to answer future `get`s correctly... so we must store the fp too →
  `(varint Δindex, u64 slot)` ≈ the slot verbatim + its index. ~9–13 B/entry.
- **B2 (re-keyable, portable):** store the **full canonical key** + val:
  `(Bits = [u64;4] = 32 B, u8 val)` = 33 B/entry. The reader recomputes `hash128(key)`
  → route+fp → `put`. This is **size-independent** (reload into any `bits`), survives a
  hash/canon version bump (re-derives everything), and is the true "frozen solved set".

In practice B2 is the one worth building: 33 B/entry, `O(fill)`, fully portable and
mergeable. B1 is just "image, but skipping empty slots" and keeps every fragility of A.

### Trade-offs (B2)

**Strengths:**
- Size = `O(fill)`, not capacity — early/frequent checkpoints are cheap.
- **Mergeable & re-keyable:** replaying two exports unions their proven sets; reload
  into a *different* `bits` works (recomputes route), and a `hash_id`/`canon_id` bump
  only needs a re-`put`, not a re-search.
- **Directly the Chunk-4 freeze primitive** — an immutable, sorted-by-key set of
  proven positions is one transform below the BuRR layer.

**Weaknesses:**
- 33 B/entry is 4× the live slot; at high fill the export can exceed the image. (Fine —
  the win is at low/medium fill, which is when you checkpoint a still-growing run.)
- Reload is `O(fill)` random `put`s (re-hash + scatter), slower than A's streaming read.
- Loses exact slot placement / load-factor reproduction (re-`put` may land entries in
  different slots under a different `bits`) — irrelevant for correctness, only for
  diagnostics.

---

## Approach comparison

| Criterion                    | A: raw image            | B2: full-key sparse export      |
|------------------------------|-------------------------|---------------------------------|
| Implementation effort        | ~½ day                  | ~1 session                      |
| On-disk size                 | full `2^bits·8` (~64 GB)| `O(fill)`, 33 B/used entry      |
| Reload speed                 | streaming, fast         | `O(fill)` random scatter        |
| Re-key into different `bits` | no                      | **yes**                         |
| Survives hash/canon bump     | no                      | **yes** (re-`put`)              |
| Mergeable across runs        | no                      | **yes**                         |
| Cross-run accumulation       | no                      | **yes**                         |
| Chunk-4 freeze stepping-stone| no                      | **yes**                         |
| New deps                     | none (opt. zstd)        | none                            |

---

## Open questions

1. **Snapshot consistency.** Relaxed loads are per-slot atomic, so a *live* dump is a
   valid subset (it just misses in-flight `put`s). Do we want exactly-consistent
   (dump after a rayon barrier / between root jobs) or good-enough-live? Both are
   *correct*; live is simpler and loses only the most recent writes. Lean live.
2. **Checkpoint cadence.** Time-based (every N minutes), root-job-boundary, or
   fill-threshold? A root-job boundary is the natural quiescent point and gives a
   clean consistent snapshot for free.
3. **Disk pressure at n=16.** Even `O(fill)` is billions of entries. Do we cap a
   checkpoint to "solved-only above ply P" (ply-windowing, an existing roadmap lever)
   to bound size? That also makes the export a cleaner Chunk-4 layer.
4. **Where to gate `bits`.** `tt_bits` (`rust/src/bin/queens.rs:71`) currently derives
   size from `n` with a `QUEENS_TT_BITS` override. Resume must pin the *dumped* `bits`,
   not re-derive — header carries it; CLI should refuse a conflicting override (A) or
   re-key (B2).
5. **Format reuse for `PnTt`?** Out of scope (tiny-board experiment), but the header
   scheme should not actively preclude it.
6. **Cluster-wide invariants (distributed extension).** For nodes to merge each
   other's deltas, all must agree on **canon** (else the same position has different
   keys and never merges). Full-key deltas relax `bits`/`hash_id` coupling (re-key on
   load); fingerprint-form deltas need the whole cluster pinned to one
   `(bits, hash_id, canon_id)`. Which wire form? (Lean full-key.)
7. **Delta watermark.** What marks "new since last sync"? An epoch counter in the
   header + a per-node epoch-local proven-key buffer (the Phase-2 export hook *is* the
   delta source) is the simplest; no global sequence needed because merge is
   order-independent (CRDT).

## Recommendation

**Build Approach B2 (full-key sparse export) as the primary format, with Approach A
(raw image) as a one-function fallback for fixed-size crash-resume.**

Justification:
1. **B2 is the only format that does what n=16 actually needs.** The whole point is
   surviving across runs/reboots and *accumulating* proven positions; A can't merge or
   re-key, so it only covers single-box same-`bits` crash-resume — a subset.
2. **B2 is the Chunk-4 freeze primitive.** The roadmap names "freeze solved entries
   into an immutable layer" as load-bearing for n=16. A sorted full-key export of
   proven positions *is* that freeze, one transform below BuRR. Building it now is
   forward progress on the main line, not a side quest.
3. **The exact, final values are what permit it.** Our TT stores resolved verdicts, so
   a re-`put` on reload is sound with zero depth/bound bookkeeping — the cost that
   makes engine-TT persistence painful simply isn't here.
4. **A is nearly free as a safety net.** The image writer/reader is ~50 LOC sharing
   the same header; keep it for "the run died, resume at the same `bits` fast."
5. **Both are pure in-memory-rep byte work** — no serde, no new dep, satisfies hot-struct
   rule #8.

Design the format **delta-ready from day one** (cheap now, expensive to retrofit): an
`epoch: u32` header field and full-key as the canonical wire form, so a B2 export
"since epoch E" is a cluster delta with no format change. See the Distributed
extension below.

mmap-backed persistence stays **deferred** until someone benches the THP/TLB
regression interleaved A/B — it threatens the exact latency lever the search rests on.

### Implementation phases

**Phase 1 — header + A (image), the minimal validateable slice.**
- Define the header struct + `format_version`/`hash_id`/`canon_id`/`n`/`bits`/`arch`
  constants. `QueensTt::dump_image(&self, path)` and `load_image(path, expected) ->
  io::Result<Self>` with hard-error header validation.
- **Validation gate (the round-trip test):** solve, `dump_image`, reload in a *fresh
  process*, re-solve → assert ~all-hits, **identical verdict**, and exact distinct
  counts hold: `solve 12 --distinct` = 1,060,823; `solve 14 --distinct` ≈ 49.3M, re-exp
  ≈ 1.0×. Plus `solver_lineage_agrees` (n≤9). A distinct-count drift ⇒ a key/route
  mismatch slipped the header check.

**Phase 2 — B2 (full-key sparse export).**
- `dump_keys(&self, path)`: scan used slots... but the slot lacks the full key. So B2
  needs the key available at `put` time: either (a) the search re-derives the key when
  exporting (it has the `available` mask in hand at each node — export at solve time,
  not from a cold table), or (b) add a parallel key-log. Cleanest: an **export hook in
  the search** that streams `(canon_key, val)` for each proven node to the writer,
  decoupled from the live fp-only TT. Decide (a) vs (b) at Phase-2 start — this is the
  one real design fork.
- `load_keys(path, expected) -> Self`: zeroed alloc, replay `put(key, val)` per entry.
  Re-key into any `bits`.
- Same round-trip gate as Phase 1, plus a **merge test**: dump two partial runs, load
  both, assert the union solves with strictly fewer nodes than either alone and the
  same verdict.

**Phase 3 — checkpoint cadence + CLI.**
- `queens solve <n> --checkpoint <path> [--every <dur>]` and `--resume <path>`. Gate
  `bits` against the header. Snapshot at root-job boundaries (Open Q1/Q2).

**Phase 4 (later, gated on roadmap) — feed the export into Chunk-4's BuRR build.**
- The sorted full-key export becomes the input key set for the static retrieval layer.

**Phase 5 (scale-out, separate work stream) — delta-gossip cluster.** See the
Distributed extension below; built entirely on the Phase-2 export hook + epoch header.

---

## Distributed extension (scale-out via delta-gossip)

The single-box A/B formats generalise to a cluster with almost no new format work,
because of one property established above.

### The enabling property: the TT is a grow-only CRDT

Every entry is a **final, deterministic** verdict (win/loss bit or true nimber of a
canonical key); it is never invalidated, and two workers that prove the same position
store the *same* value. So the table is a state-based CRDT — a grow-only set /
join-semilattice under union: merge is **commutative, associative, idempotent**.
Deltas may arrive out of order, duplicated, or be lost-and-resent; the merged state
still converges. This is the cleanest possible distributed-state story, and it is
exactly what dump/load provides:

- **Dump = full-state snapshot** → warm-start / initial sync.
- **Delta = a B2 export since an epoch watermark** → steady-state sync.

The Phase-2 export hook already streams `(canon_key, val)` per newly-proven node; a
delta is that buffer flushed periodically rather than once at the end. Merge on the
receiver is `load` with put-semantics. Deltas *are* dump/load with a watermark — no
new conceptual machinery.

### Reframe the prize (Fermi first)

Distribution does **not** buy parallel speedup here: we're TT/DRAM-latency-bound with
an ~18× per-box ceiling (`QueensTt` comment, `rust/src/queens.rs:1044`), and the run
is compute-days regardless. The wall (per the memory roadmap) is that n=16's working
set (~billions distinct, ~9.2B central) **exceeds one 26 GB box**, so a single box
evicts → re-expands → drifts toward Jenrich's 71B nodes. **Distribution's prize is
aggregate RAM that holds the working set so re-expansion dies** — it is the
*scale-out* answer to the same memory wall that Chunk-4 BuRR answers by *scale-up
compression*. They compose (compressed layers over a small cluster).

Corollary that dominates the design: **the hot path must never block on the network.**
A remote probe is ~10–100 µs vs ~100 ns local DRAM — 100–1000× worse on a search
that is *already* latency-bound. Any design with a synchronous remote get/put on the
node hot path is dead on arrival.

### Two viable architectures

**C1 — Replicated + delta-gossip (recommended; reuses dump/load directly).** Each
node keeps its own local TT; the hot path is local-only. Nodes periodically ship
deltas (newly-proven keys since last flush) and union-merge them. Eventually
consistent: a node may re-search a position another already proved until the delta
lands — bounded, self-correcting redundancy traded for zero network on the hot path.
Low effort: it *is* the proposal's export/load with an epoch watermark.

**C2 — TDS, Transposition-table-Driven work Scheduling (literature's peak).** Romein,
Bal, Schaeffer & Plaat (~1999–2002): instead of fetching a remote entry, *send the
work* to the node owning that key's slot (route bits → node id); the owner looks up
locally and returns a hit or schedules its children to *their* owners. Converts random
remote reads into async message-passing that overlaps with compute, with perfect TT
locality. Strongest performer, but a large restructuring — message-driven search +
distributed termination detection — not a bolt-on to dump/load. Keep in reserve if C1's
delta-lag redundancy proves too costly.

### Delta mechanics

**Wire form** — sorted `(canon_key, val)` since an epoch watermark:
- **Full-key (32 B + 1 bit, the B2 format):** bits- and hash-version-agnostic
  (recompute `hash128(key)` on load), so nodes may even run *different* table sizes
  and still merge. Sorted canonical masks share high words → delta-encode +
  entropy-code to a few bytes/entry.
- **Fingerprint-slot form (~8–12 B):** smaller, but couples the whole cluster to one
  `(bits, hash_id, canon_id)`. Only worth it under a pinned cluster geometry.
- All nodes must agree on **canon** regardless (the header invariants become
  cluster-wide constants), else identical positions get different keys and never merge.

**Dedup / what *not* to ship:**
- **Watermark per peer** (epoch/log offset): exact and simple; ships cross-node
  duplicates (two nodes independently prove P, both log it), but union dedups by key —
  only bandwidth wasted, never correctness.
- **Anti-entropy filter exchange:** ship a cuckoo/ribbon filter of "what I hold"
  (roadmap lever #15); peer sends only the complement. A false positive just skips a
  ship → recipient re-searches → safe, slightly lossy.

**The core tuning knob — ply-stratified shipping.** Shallow positions (near root) are
*few and massively shared* — the high-reuse "opening book." Deep frontier positions
are *many and rarely re-hit* — cheap to recompute, not worth the wire. So **eagerly
broadcast shallow proofs, lazily/never ship the deep tail.** This bounds delta volume
to the valuable stratum and dovetails with ply-windowing. It is what makes delta-gossip
beat naive ship-everything.

**Scale path:** periodically compact accumulated deltas into a **BuRR layer (~1.1
bit/key)** and pull layers across the cluster — Chunk 4, distributed. A delta becomes
"a new immutable layer id you don't yet have" (RocksDB-over-the-network).

### Two freebies

- **Bandwidth is not the constraint.** Shipping every distinct proven position once
  cluster-wide is ~billions × a few compressed bytes = tens of GB over a multi-day run
  → sub-MB/s average. The constraints are the sync *policy* and aggregate *memory*,
  not the wire.
- **Fault tolerance falls out.** A monotone proof-set means losing a node loses only
  its *un-shipped* deltas — recoverable by recomputation, no corruption, no rollback.
  Checkpoint/resume (Phase 3) + delta-gossip = a naturally crash-tolerant cluster.

### Distributed recommendation

Pursue **C1 (replicated + ply-stratified delta-gossip)** on the Phase-2 export hook,
hot path local-only, with the long-term scale path being **Chunk-4 BuRR layers pulled
across the cluster.** Keep **C2 (TDS)** in reserve. Never put a synchronous remote
probe on the node hot path. The only format prerequisite is the `epoch` header field
and full-key wire form (folded into the Recommendation above).
