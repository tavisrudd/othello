# Projective cap achievement game — exact small-case results (2026-07-05)

Solver: `2026-07-05-proj-cap-fast.py` (bitmask positions, incremental forbidden masks,
memo on the chosen mask). Axioms validated per case (every line has `q+1` points; every
pair on exactly one line; line count `= N(N-1)/((q+1)q)`). Cross-checked two ways:
against the raw probe `2026-07-04-proj-cap.py` on every overlapping tiny case, and
against an independent F_2^k sum-free solver (`2026-07-05-sumfree-f2-crosscheck.py`) for
the whole q=2 column — **identical outcomes AND identical memo-state counts** across the
two independent code paths (PG(3,2)=791, PG(4,2)=311926 on both).

Outcome = value for the player to move at the empty root: **P** = 2nd-player win (root
Grundy 0), **N** = 1st-player win. Opening orbits: `PGL(m+1,q)` is point-transitive, so
the first move is always 1 orbit; it is also 2-transitive, so the opening *pair* is 1
orbit and every second reply is game-equivalent.

| case      | points | opening orbits | outcome | root Grundy | states  | notes                              |
|-----------|-------:|---------------:|:-------:|:-----------:|--------:|------------------------------------|
| PG(1,2)   |      3 |              1 | P       | 0           |       6 | trivial: all points collinear      |
| PG(1,3)   |      4 |              1 | P       | 0           |       8 | trivial                            |
| PG(1,4)   |      5 |              1 | P       | 0           |      10 | trivial                            |
| PG(1,5)   |      6 |              1 | P       | 0           |      12 | trivial                            |
| PG(2,2)   |      7 |              1 | P       | 0           |      30 | = F_2^3 sum-free                   |
| PG(2,3)   |     13 |              1 | P       | 0           |     120 | q odd                              |
| PG(2,4)   |     21 |              1 | P       | 0           |     514 | q even (char 2)                    |
| PG(2,5)   |     31 |              1 | P       | 0           |    2098 | q odd ★ falsification test         |
| PG(2,7)   |     57 |              1 | P       | 0           |   28651 | q odd ★ falsification test         |
| PG(2,8)   |     73 |              1 | P       | 0           |  130936 | q even (char 2)                    |
| PG(2,9)   |     91 |              1 | P       | 0           |  493556 | q=3^2 ★ non-prime field, odd char  |
| PG(3,2)   |     15 |              1 | P       | 0           |     791 | = F_2^4 sum-free                   |
| PG(4,2)   |     31 |              1 | P       | 0           |  311926 | = F_2^5 sum-free                   |
| PG(3,3)   |     40 |              1 | P       | 0           |   55909 | m=3, odd char                      |

## Reading

- **Every computed case is P.** The conjecture `G(PG(m,q))=0` survives every test.
- **Every q-odd plane is P** — `PG(2,{3,5,7,9})`, including the non-prime char-3 field
  `q=9`. This is the important result of the session: the q-odd planar case, where the
  natural single-involution mirror is obstructed (handoff R4), is nonetheless a
  second-player win in outcome. So P2 has a winning strategy there; what we lack is a
  clean *uniform proof*, not the verdict.
- q-even planes (`q=2,4,8`) are P, consistent with the translation-mirror lemma (R3).
- The m≥3 cases `PG(3,2)`, `PG(4,2)`, `PG(3,3)` are P, extending the picture past the
  plane in both characteristics.

## Feasibility notes

- Caps are small (`PG(2,q)` max cap `q+1`/`q+2`; `PG(3,q)` max cap `q^2+1`), so game depth
  is tiny and even `PG(2,9)` (91 points) solves in ~1s with plain memoization, no
  canonicalization. `PG(3,3)` (40 pts) is 56k states.
- The one blow-up so far is `PG(5,2)` (63 pts = F_2^6 sum-free): binary caps in dimension
  6 get large, memo ballooned past ~1.3 GB with no sign of stopping. It needs either the
  existing F_2^6 sum-free result imported, or a canonical solver. Not on the critical path.

## Next

- Import the q=2 column beyond `PG(4,2)` from the `F_2^{m+1}` sum-free solver (R6-0).
- Write up the q-even planar theorem (R3) — the data (`q=2,4,8` all P) matches.
- The proof frontier is the q-odd planar kernel (R4) and q=2 `m≥3` (linear-mirror fixed
  space too big).
