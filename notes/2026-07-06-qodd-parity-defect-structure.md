# q-odd planar cap game: the parity-defect structure (2026-07-06)

Follow-up to `2026-07-06-qodd-mirror-obstruction.md` (mirror route CLOSED). This session
attacked the **counting/parity route** (handoff R4 route 3) and found the clean structural
reason every prior route breaks at exactly **q = 9** — and a sharp reformulation of the open
problem. No uniform proof yet, but the obstruction is now one concrete, localized phenomenon:
**odd maximal caps**.

## The naive parity law and where it breaks

Grid game = `PG(2,q)` residual (`2026-07-05-grid-game.py`): cells of `F_q × F_q`, legal =
partial-permutation matrix (≤1/row, ≤1/col) AND affine cap (no 3 collinear); P1 first;
`PG(2,q)=P ⟺ grid game is a first-player loss`.

A maximal legal position has no available move ⇒ the mover is stuck ⇒ it is a **P-position**
(previous player wins). So **if every maximal cap had even size**, every play line would last
an even number of moves, P2 would always make the last move, and `PG(2,q)=P` would follow with
**no strategy at all**, uniformly for all q.

**This is exactly true for q ≤ 7 and FALSE for q ≥ 9.** (`2026-07-06-grid-maximal-parity.py`
enumerates all maximal caps; `2026-07-06-maximal-parity-sample.py` samples large q.)

| q | maximal-cap sizes (all reachable) | all even? |
|---:|---|:--:|
| 3 | 2 | yes |
| 5 | 4 | yes |
| 7 | 4, 6 | yes |
| 9 | 4, 5, 6, 8 | **NO** (size 5) |
| 11 | 5, 6, 7, 8, 10 | **NO** (5, 7) |
| 13 | 6, 7, 8, 10, 12 | **NO** (7) |

The first **odd** maximal cap appears at **q = 9** (size 5). This is the *same* q where the
central-symmetry mirror `σ_c` first fails (`2026-07-05-qodd-central-symmetry-findings.md`) and
one below where the antidiagonal mirror fails (q=11). All three routes break for the same
reason: **odd maximal caps do not exist below q=9**, so below q=9 the game is pure parity and
*any* even-preserving pairing (or none) wins; at/above q=9 they exist and must be steered
around.

## The full P/N labelling: defects are seeded ONLY by odd maximal caps

Solving the grid game and labelling every position P/N (full expansion, canonical solver
`2026-07-06-exception-canon.py`; naive cross-check `2026-07-06-invariant-hunt.py`), and
comparing to the naive law "P iff |S| even":

| q | root | deviating sizes (size,#P,#N as canonical classes) | odd-but-P classes (maximal / non-max) |
|---:|:--:|---|---|
| 7 | P | *none* (pure parity) | 0 / 0 |
| 9 | P | (4, 22, 5), (5, 1, 29) | 1 / 0  (the size-5 odd max cap) |
| 11 | P | (4,30,50),(5,43,229),(6,147,164),(7,40,16) | 41 / 42 |
| 13 | P | (4,131,61),(5,21,1363),(6,1249,2826),(7,770,2319) | 770 / 21 |

Reading:

- **Every deviation from parity traces back to an odd maximal cap.** The odd maximal caps are
  odd-size P-positions (the mover is stuck). By backward induction they turn some even parents
  into N ("even-but-N": a mover who can *complete* an odd maximal cap wins) and, deeper, some
  odd positions into P ("non-maximal odd-but-P": all children are even-but-N). With no odd
  maximal caps (q ≤ 7) there are no seeds ⇒ pure parity.
- At **q = 9** the seed is a single canonical size-5 maximal cap; the propagation reaches only
  sizes 4–5 and dies — the root (size 0) is untouched.
- At **q = 11, 13** more odd maximal caps (size 7, plus a stray size-5 at q=11) seed a larger
  defect region reaching sizes 4–7, including *non-maximal* odd-P positions. Still the region
  does **not** reach size ≤ 3: **the minimum deviating size is 4 for q = 9, 11, 13.**

## The sharpened open problem

The naive parity proof is dead (odd maximal caps exist), and the single-involution mirror is
dead (`2026-07-06-qodd-mirror-obstruction.md`). But the two failures are now **one** failure,
and the theorem reduces to a sharp statement:

> `PG(2,q) = P` ⟺ the parity defects seeded by odd maximal caps never propagate to the root
> ⟺ P2 has a strategy that avoids every **odd maximal cap** (forces the game to end on an
> even maximal cap).

The load-bearing empirical fact is the **margin**: the minimum deviating size stays at 4 (root
at size 0 is safe by ≥ 4) for every computed q. The early game is pure parity — small positions
(size ≤ 3) always follow the law because there is enough room to reach an even (P) continuation;
the defects live only in the endgame where room runs out. A uniform proof must lower-bound this
margin (show the defect region cannot reach the root) for all q. Two concrete sub-statements
that would each suffice, in increasing strength:

1. **All size-2 positions are P** (equivalently, all size-3 positions are N). Since the size-1
   position is unique up to the grid automorphism group and is N iff it has a P size-2 child,
   this gives root P immediately. Reduces to: *every 3-cell partial-permutation cap extends to a
   P-position of size 4* — a finite geometric extension statement, still recursive in size-4
   P-ness but far more local than the whole game.
2. A structural theorem on **odd maximal caps** (size, count, or a covering/avoidance property)
   strong enough to bound the defect region away from the root for all q.

## Falsification framing (this MOTIVATES extending the ladder)

The conjecture `G(PG(m,q))=0` is **not** obviously safe: the defect region *grows* with q
(q=13 has far more non-maximal odd-P classes than q=11). The whole question is whether it ever
reaches the root. So extending the outcome ladder past q=19 (via a compiled port of the
canonical grid solver, `2026-07-06-grid-canon2.py`) is a genuine **falsification test**, not
mere confirmation — and the quantity to watch is the **minimum deviating size**: if it ever
drops toward 0/1, the root is about to flip (`PG(2,q)` would become N, a counterexample). If it
stays bounded below, that bound is the proof.

## Artifacts

- `2026-07-06-grid-maximal-parity.py` — enumerate all maximal caps, check size parity (q≤7 all even).
- `2026-07-06-maximal-parity-sample.py` — random maximal fills; odd maximal caps appear at q≥9.
- `2026-07-06-invariant-hunt.py` — naive full P/N solve, parity-exception tally (q≤9).
- `2026-07-06-exception-structure.py` — signature of q=9 exceptions (odd-P = maximal; even-N one step away).
- `2026-07-06-exception-canon.py` — canonical full-expansion P/N + defect tally (q≤13).
