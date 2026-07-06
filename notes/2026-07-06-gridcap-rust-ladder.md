# PG(2,q) cap game: compiled ladder extension + falsification watch (2026-07-06)

Route (B) from the handoff: port the canonical grid solver to compiled code and extend the
outcome ladder past q=19 as a **falsification test** for `G(PG(m,q))=0`, tracking the
parity-defect margin (`2026-07-06-qodd-parity-defect-structure.md`). Outcome: the ladder is
re-confirmed **P through q=19** with a **growing** safety margin, and the exhaustive canonical
state space is measured to grow ~×9 per q-step, hitting a hard memory wall (>10⁹ classes) at
q=23 on this 26 GB box. Brute-force falsification therefore stops at q=19; going further needs
the proof, not more compute.

## The solver

`2026-07-06-grid-cap-solver.rs` — standalone Rust (`rustc -O -C target-cpu=native`). Same
residual grid game as `2026-07-06-grid-canon2.py`: cells of `F_q×F_q`, legal =
partial-permutation matrix + affine cap, P1 first, `PG(2,q)=P ⟺ first-player loss`. Canonicalizes
`chosen` under the full grid automorphism group `G={(r,c)↦(ar+s,bc+t)}⋊swap`. Modes: `outcome`
(early-break root P/N), `defect` (full expansion, parity-defect diagnostics), `par` (parallel).

**Validation.** Reproduces the Python solvers **exactly**: identical outcomes for every q, and
identical deterministic `defect` diagnostics for q ≤ 13 (q=9: min-dev-size 4, 1 odd-maximal-cap;
q=13: 770 odd-maximal + 21 non-maximal odd-P, exact class count 9299). The parallel path matches
outcome P at every q and matches class counts within parallel nondeterminism (q=17 ≈ 1.756M).

### Performance work (this session)

- **Parallel `par` mode**: sharded work over a depth-4 frontier split; workers share transpositions
  through one memo. ~10× over single-thread at q=17.
- **Fixed-arena memo (Tiger-style)**: replaced a sharded `HashMap` (per-entry malloc, reallocs on
  growth, ~44 B/entry, OOM churn) with a **`Box<[u128]>` open-addressing arena sized once at startup
  and never grown** — no allocation in the hot loop, constant/predictable RSS. Each slot packs a
  126-bit key + value + occupied bit into 16 B (collision ≈ 10⁻²⁰ at 10⁹ keys).
- **Canon hotspot (was 93.9% of cycles)** — three validated passes (`defect` counts unchanged
  77/739/9299): (1) **order-independent set-hash** (sum of per-cell hashes, min over anchors) instead
  of sort + `Vec` + clone; (2) precompute each cell's (row,col) once — no div/mod in the O(|occ|³)
  inner loop; (3) hoist the per-`ui` translation out of the `(vi,sw)` loop + subtraction table + no
  per-cell swap branch. **Net 3.3× faster** (q=19: 36s → 11s); canon is still dominant but is now
  inherent O(|occ|³) anchor work.
- **Live monitoring**: `par` streams `tasks done/total · classes · classes/s` to stderr every 5s;
  the runner tees it to a `tail -f`-able log.

## Extended outcome ladder — P through q=19, then a memory wall

| q | root | canon classes (parallel) | notes |
|---:|:--:|---:|---|
| 13 | P | 7,973 | validated vs Python |
| 17 | P | 1,756,687 | validated vs Python |
| 19 | P | 16,740,800 | 11s (24 threads, opt) |
| 23 | ? | **> 946,000,000** (not finished) | arena guard tripped at 946M classes / ~11% of frontier tasks; true total > 10⁹ |
| 25,27,29,31 | ? | larger still | beyond 26 GB (see below) |

**Every solved case is P.** The exhaustive canonical class count grows **~×9 per q-step**
(q=17: 1.76M → q=19: 16.7M → q=23: >10⁹). At 16 B/class a billion classes is ~16 GB *plus*
open-addressing headroom, so q=23 needs a >2³⁰-slot (>17 GB) arena and — extrapolating — q ≥ 23
exceeds this box's 26 GB RAM. This is a resource wall of **exhaustive enumeration on a 26 GB box**,
not a fundamental limit: a larger-memory machine, a tighter key (marginal), or — the real lever —
a **proof** would go further. The exponential growth is itself a reason to prefer the proof route.

## The falsification signal: the parity-defect margin (the headline)

> **CORRECTION 2026-07-06 (`2026-07-06-escape-margin-erratic.md`).** "min-dev-size grows 4→6 ⇒
> the root gets safer" **overstates it.** By the frame chain, root=P ⟺ min-dev-size ≥ 4, and
> min-dev-size ∈ {0}∪{4,5,…} — it jumps from 0 (root N) straight to ≥4, so **4 vs 6 is endgame
> defect depth, not a root-safety buffer** (the root is equally P either way). The *accurate* fine
> safety measure is the per-size-3 **escape margin**, and it is **erratic**: min-escape swings
> `1,7,13,13,46,5,211` through q=19 (thinnest 5 at q=17, where `bad ≈ total`). The rigorous
> content of this section is just "root P, confirmed exhaustively through q=19."

`min-dev-size` = smallest position size whose P/N value disagrees with the naive parity law
"P iff |S| even". **The root (size 0) flips to N — a counterexample — exactly when it hits 0.**
It stays not just positive but **grows**:

| q | min-dev-size (root safety margin) | smallest odd maximal cap |
|---:|:--:|:--:|
| ≤7 | ∞ (pure parity, no defects) | none |
| 9 | 4 | 5 |
| 11 | 4 | 5 |
| 13 | 4 | 7 |
| 17 | 4 | 9 |
| 19 | **6** | 9 |

The defect region stays deep in the endgame and, if anything, retreats from the root as q grows
(4 through q=17, then 6 at q=19). Combined with the exhaustive P verdict through q=19, this is
strong evidence `G(PG(2,q))=0` is safe; a uniform proof would lower-bound min-dev-size ≥ 1 for all q.

## Artifacts

- `2026-07-06-grid-cap-solver.rs` — the compiled solver (outcome / defect / par modes).
- `2026-07-06-gridcap-par-frontier.sh`, `-primes.sh`, `-ladder*.sh` — runners (memory-capped).
- `2026-07-06-gridcap-*.log` — run logs (outcome, defect diagnostics, live progress).
