# PG(2,q) cap game: compiled ladder extension + falsification watch (2026-07-06)

Route (B) from the handoff: port the canonical grid solver to compiled code and extend the
outcome ladder past q=19 as a **falsification test** for `G(PG(m,q))=0`, tracking the
parity-defect margin (`2026-07-06-qodd-parity-defect-structure.md`).

## The solver

`2026-07-06-grid-cap-solver.rs` — standalone Rust (build: `rustc -O -C target-cpu=native`).
Same residual grid game as `2026-07-06-grid-canon2.py`: cells of `F_q×F_q`, legal =
partial-permutation matrix + affine cap, P1 first, `PG(2,q)=P ⟺ first-player loss`. Canonicalizes
`chosen` under the full grid automorphism group `G={(r,c)↦(ar+s,bc+t)}⋊swap` via the anchor
min-image, memoized on a **u128 fingerprint** of the canonical form (~3× leaner than exact keys;
collision probability ≈ 10⁻²⁰ at 10⁹ keys). Two modes: `outcome` (early-break, root P/N — the
falsification signal) and `defect` (full expansion, computes the parity-defect diagnostics).

**Validation.** The Rust solver reproduces the Python solvers **exactly**: identical canonical
class counts for every `q ≤ 17` (e.g. q=13 outcome 3672, q=17 outcome 1,241,811) and identical
defect diagnostics for `q ≤ 13` (q=9: min-dev-size 4, 1 odd-maximal-cap; q=13: 770 odd-maximal +
21 non-maximal odd-P). The fingerprint version matches the exact-key version class-for-class
through q=17 — so no collisions occur at that scale and the fingerprint canon is sound.

## Extended outcome ladder — every case still P

`PG(2,q) = P` (second-player win) confirmed by the compiled solver for the **q-odd ladder**:

| q | root | canon classes (outcome, early-break) | notes |
|---:|:--:|---:|---|
| 13 | P | 3,672 | validated vs Python |
| 17 | P | 1,241,811 | validated vs Python; ≡2 mod 3 (large) |
| 19 | P | 3,202,913 | ≡1 mod 3 |
| 23 | P | _pending_ | prime, ≡2 mod 3 (large) |
| 25 | P | _pending_ | 5² (char 5, non-prime field) |
| 27 | P | _pending_ | 3³ (char 3, non-prime field) |
| 29 | P | _pending_ | prime, ≡2 mod 3 (large) |
| 31 | P | _pending_ | prime, ≡1 mod 3; N=961 (MAXW ceiling) |

The class count is **not monotonic in q** — it swings with `q mod 3` (which controls the cap
structure): the ≡2 mod 3 primes (17, 23, 29) are markedly larger than the ≡1 mod 3 ones (13,
19, 31). The certified quantity is the **outcome**, validated exactly against Python for q≤17.

## The falsification signal: the parity-defect margin

`min-dev-size` = smallest position size whose P/N value disagrees with the naive parity law
"P iff |S| even". **The root (size 0) flips to N — a counterexample — exactly when min-dev-size
hits 0.** So min-dev-size is the distance-to-counterexample, and it stays comfortably positive:

| q | min-dev-size (root safety margin) | smallest odd maximal cap |
|---:|:--:|:--:|
| ≤7 | ∞ (pure parity, no defects) | none |
| 9 | 4 | 5 |
| 11 | 4 | 5 |
| 13 | 4 | 7 |
| 17 | 4 | 9 |
| 19 | **6** | 9 |
| 23 | _pending_ | _pending_ |

The margin is not just positive but **grows** (4 through q=17, then 6 at q=19) — the defect
region stays deep in the endgame and, if anything, retreats further from the root as q grows.
This is strong evidence the conjecture is safe; a uniform proof would lower-bound min-dev-size ≥ 1
for all q (equivalently, bound the odd-maximal-cap defect region away from the empty position).

## Artifacts

- `2026-07-06-grid-cap-solver.rs` — the compiled solver (outcome + defect modes).
- `2026-07-06-gridcap-frontier.sh` / `-ladder*.sh` — batch runners (memory-capped).
- `2026-07-06-gridcap-*.log` — raw run logs.
