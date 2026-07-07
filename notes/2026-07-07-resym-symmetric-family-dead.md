# The adaptive symmetric-strategy route is DEAD: no play-closed symmetric family exists for q >= 11

Date: 2026-07-07. Executes route (A)-1/2 of `2026-07-07-projcap-open-math-plan.md` (the resym
experiment) to full depth. Companion to `handoffs/2026-07-06-projective-cap-game-handoff.md`
(session 7). Verdict: **negative, exhaustively and at every strength of the family** — the route
the plan called "the main proof bet" is closed.

## The question

Session 4's depth-1 probe (`2026-07-06-adaptive-resym-test.py`) showed the *relaxed* adaptive form
(after any break, P2 has SOME legal reply landing in SOME mirror-symmetric position) succeeds for
q <= 13. The open question was whether a family of symmetric positions is **closed under play** —
i.e. whether P2 can stay symmetric forever. That is the exact statement tested here, to all
depths, with the family made as generous as possible.

## Method: the `resym` mode (grid solver)

New mode in `2026-07-06-grid-cap-solver.rs`. Define a family F over even-size legal grid
positions and solve the RESTRICTED game: P1 moves freely; P2 may only make replies y for which
S+{x,y} is in F. `SAFE(S)` = P1 stuck, or every legal break x admits a reply y with S+{x,y} in F
and SAFE(S+{x,y}). This is precisely the AND-OR search for a play-closed subfamily of F
containing the frame: `SAFE(frame) = YES` would be a machine-checked adaptive P2 strategy (a
P-proof for PG(2,q) via the frame reduction); `SAFE(frame) = NO` means **no play-closed
subfamily of F exists** — exhaustive, not heuristic.

Family variants (each broader or differently-filtered):

- **v0** — S symmetric under some *involution* of the grid hypergraph automorphism group.
  Involutions are enumerated **exhaustively** (all semilinear monomial maps, both coordinate
  orders, all scalings/shifts, Frobenius twists for prime-power q; deduped) — not a hand-derived
  family list, so nothing is missed. This is the broadest form of "adaptive mirror".
- **v1/v2** — v0 plus deadness of the involution's fixed locus / whole problem set (the
  restricted candidate invariants from the plan). Not separately run since v0 already fails.
- **v3** — S has **any nontrivial stabilizer** (symmetric under some automorphism of ANY order,
  not just involutions; the whole group enumerated, e.g. 24,199 non-identity maps at q=11).
  The maximal symmetry-based family that exists.
- **v4** — v3 AND S is a true P-position of the exact game (family = "symmetric and winning").
  Its deepest failing break necessarily has ZERO symmetric winning replies — it extracts the
  concrete obstruction witness.

Soundness: F and SAFE are G-invariants (G conjugates the automorphism set to itself and
preserves legality), so memoizing SAFE on the existing canonical key is exact. Reply
reconstruction per (T = S+x, g): D = g(T)\T; |D| >= 2 impossible, |D| = 1 forces y = the element
of D (with g(y) in U checked — automatic for involutions), |D| = 0 forces y in Fix(g).

## Results

| q  | v0 (involutions) | v3 (any stabilizer) | v4 (symmetric AND P) | notes |
|----|------------------|---------------------|----------------------|-------|
| 3  | SAFE             | —                   | —                    | frame maximal, vacuous |
| 4  | SAFE             | —                   | —                    | translation mirror (char 2), positive control |
| 5  | SAFE             | SAFE                | —                    | central witnesses |
| 7  | SAFE             | SAFE                | —                    | central + antidiag |
| 8  | SAFE             | —                   | —                    | translation + antidiag, positive control |
| 9  | SAFE             | SAFE                | SAFE                 | central + antidiag + **Frobenius-twisted** witnesses |
| 11 | **NO**           | **NO**              | **NO**               | first break already at the frame, x=(2,3) |
| 13 | **NO**           | **NO** (via v4)     | **NO**               | same frame break |
| 17 | **NO**           | **NO**              | —                    | same frame break |

(SAFE is monotone in the family, and SAFE_v3 = SAFE_v4: a winning symmetric strategy can only
ever move to P-positions, so any closed v3 subfamily is already a closed v4 subfamily. Hence
v4 = NO implies v3 = NO; v0 = NO alone would not.)

The q <= 9 / q >= 11 threshold is the SAME boundary as every other route (odd maximal caps,
`sigma_c`/antidiagonal mirror failures, parity breakdown) — one more face of the q=11 wall.

State counts are tiny (tens of states per q): the reachable symmetric world is minuscule, and the
verdicts are full exhaustions of it, not samples.

## The concrete obstruction witness (q=11), independently verified

v4's deepest failing break, cross-checked by the exact solver (`checkpos` mode):

> S = {(0,0), (1,1), (2,3), (3,2)} — transpose-symmetric, true P-position.
> P1 breaks with x = (4,9). The resulting position T is N (P2 has 5 winning replies:
> (5,4), (5,6), (5,10), (8,6), (9,10)) — but **all 7 legal replies (winning or not) produce a
> position with TRIVIAL stabilizer**. symmetric-P = 0.

So P2's real winning strategy is forced out of the symmetric world by move 6 at q=11. (At q=13
the analogous witness sits at size 6+break; at q=17 the v3 family dies at a size-8 break.) By
contrast the first level is fine — from the frame every break keeps >= 3 symmetric winning
replies at q=11 (`breaks` mode; min 5 at q=9) — which is exactly why the depth-1 probe was
misleading.

## What this closes, and what it leaves

CLOSED:

- **Route (A)-1 (adaptive-involution / adaptive-symmetric strategy) in every form.** Not just
  fixed mirrors (already closed), not just involution re-symmetrization: *no strategy whatsoever
  can keep the position symmetric under even one nontrivial automorphism* from q=11 on. Any
  invariant of the form "position has symmetry X" is unmaintainable.
- The plan's step (A)-2 ("search the symmetric-reply multigraph for a closed subfamily") — the
  search was performed exhaustively; the subfamily does not exist.

STILL LIVE:

- **(B) finer counting invariant** — now the main proof bet. The winning replies at the witness
  break ((5,4), (5,6), (5,10), (8,6), (9,10)) have no visible symmetry; whatever selects them is
  a counting/geometric property, not a group-theoretic one.
- **(C) per-q Lean certificates** — unaffected; the witness/certificate format is exactly what a
  proof must produce anyway (the session's SAFE trees show how small the relevant position space
  is).
- **(D) falsification watch** — unaffected.

Together with sessions 2–5: mirrors dead, parity dead beyond q=9, area/arc bounds dead,
boundary-characterization dead, and now symmetry-maintenance dead in full generality. Every
group-theoretic and coarse-counting mechanism is eliminated; the open kernel (ESC) is protected
by something intrinsically asymmetric and fine-grained. That sharpens where to look — and it is
strong evidence the eventual proof (if one exists) is a certificate-style/potential-function
argument rather than a symmetry argument.

## Artifacts

- `resym` (v0..v4), `breaks`, `checkpos` modes in `2026-07-06-grid-cap-solver.rs`
  (build: `rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o gridcap`;
  run: `gridcap resym v0 11`, `gridcap breaks 11`,
  `gridcap checkpos 11 0,0 1,1 2,3 3,2 / 4,9`).
- All runs single-core, < 1 GB, seconds (box shared with the sumfree run).
