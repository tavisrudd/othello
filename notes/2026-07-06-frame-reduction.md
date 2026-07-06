# PG(2,q) cap game: the FRAME REDUCTION (2026-07-06)

Route (A) from the projective-cap handoff. A clean, verified reduction that collapses the
whole planar cap game — an infinite game tree — to the game value of **one** maximally
symmetric position, the **projective frame**. It unifies the even and odd cases into a single
statement and sharpens the open q-odd kernel to a local, finite-geometry question. No new
outcome is proved, but the target is now a single position with full `S_4` symmetry, which is
the right object for the arc/maximal-cap attack.

## Statement

> **Frame reduction.** For every prime power `q`,
> `PG(2,q) = P`  ⟺  the projective **frame** (any 4 points in general position, no 3
> collinear) is a **P-position** in the cap achievement game.

A frame is also called a quadrangle or a projective 4-frame; PGL(3,q) acts (sharply)
transitively on ordered frames, so "the frame" is well defined up to the game symmetry.

## Proof

Work in `PG(2,q)`; `PGL(3,q)` preserves collinearity, hence acts on cap-game positions
preserving game value. Standard transitivity facts (fundamental theorem of projective
geometry):

- transitive on **points** (size 1),
- transitive on ordered **pairs** (size 2) — in fact 2-transitive,
- transitive on **triangles** = 3 points, no 3 collinear (size 3),
- (sharply) transitive on **frames** = 4 points, no 3 collinear (size 4).

So **each of sizes 0,1,2,3,4 is a single orbit**, and the game value is constant on each. Write
`v(k)` for the common value of a size-`k` cap (`P` or `N`).

Every size ≤ 3 cap is non-terminal (a triangle always extends to a frame: pick a point off its
three sides — one exists for all `q ≥ 2`, e.g. the Fano centre at `q=2`), so the normal-play
recursion applies at each level. Because each level is one orbit, "some child is P" and "the
child is P" coincide, giving a chain of equivalences:

```
v(0)=P  ⟺  every size-1 child is N  ⟺  v(1)=N
v(1)=N  ⟺  some  size-2 child is P  ⟺  v(2)=P
v(2)=P  ⟺  every size-3 child is N  ⟺  v(3)=N
v(3)=N  ⟺  some  size-4 child is P  ⟺  v(4)=P
```

Hence `v(0)=P ⟺ v(4)=P`, i.e. `PG(2,q)=P ⟺` the frame is a P-position. ∎

The chain also records the exact small-cap value pattern, the same for every `q`:

```
∅ (P)  →  point (N)  →  pair (P)  →  triangle (N)  →  frame (P if the conjecture holds)
```

The reduction bottoms out at size 4 because size 5 is the **first size with more than one
orbit** (5 points in general position split by the conic/other invariant), so no further
transitivity collapse is available.

## Verification

Exhaustive, two independent code paths, all consistent:

- `2026-07-06-frame-orbit-verify.py` (projective solver): for `q=3,4,5,7`, sizes 1..4 are each
  a single game-value orbit — `size1=[N] size2=[P] size3=[N] size4=[P]` — and `root == frame`
  value. Confirms the transitivity input by direct enumeration, not just by citing group theory.
- `2026-07-06-frame-reduction-verify.py` (residual grid solver): for `q=2,3,4,5,7,9`, all size-1
  grid positions share a value and all size-2 grid positions share a value (single orbits), and
  `value(empty grid) == value({(0,0),(1,1)})`. The grid position `{(0,0),(1,1)}` (opening pair
  at infinity + two affine points) is exactly the projective frame.

Both hold for even and odd `q`, so the reduction is `q`-agnostic.

## Consequences

**Unifies even and odd.** For even `q`, `PG(2,q)=P` is already proved
(`2026-07-05-qeven-plane-theorem.md`, whole-board translation mirror `τ_v`). The reduction
restates every planar case, both parities, as the single assertion *the frame is P*. The even
proof is a proof that this holds; the odd case is the open instance.

**The odd target is now one position with `S_4` symmetry.** The frame stabiliser in `PGL(3,q)`
is `S_4` (the 4 frame points permuted). Its Klein-4 subgroup that also fixes the opening line
`AB` setwise is, in grid coordinates on `F_q×F_q` (frame = `{(0,0),(1,1)}` + the two infinite
directions `A,B`):

| element | grid map | projective type | fixed locus |
|---|---|---|---|
| `id` | `(r,c)↦(r,c)` | — | all |
| `σ_c` | `(r,c)↦(1-r,1-c)` | homology, centre `(½,½)`, **axis = line AB** | axis (dead) + centre (dead) |
| `τ` | `(r,c)↦(c,r)` (transpose) | homology / harmonic, **axis = a diagonal** | main diagonal `r=c` = line `CD` (dead) |
| `σ_c·τ` | `(r,c)↦(1-c,1-r)` | homology, **axis = antidiagonal `r+c=1`** | line `r+c=1` (**live**) |

For `σ_c` and `τ` the *fixed locus is entirely dead* (it lands on the opening line `AB` or the
frame line `CD`, both burned) — so, unlike the general-position mirror analysis, fixed points
are **not** the obstruction here.

## Why no single frame-stabiliser involution is uniform (new data, incl. the transpose)

`2026-07-06-frame-mirror-test.py`: bulk-forced mirror from the frame, free reply on the
problem set, best over the choice.

| involution `φ` | problem set (why the mirror breaks) | wins for `q` | first fail |
|---|---|---:|---:|
| `τ` (transpose) | the two antidiagonals `r+c=0`, `r+c=2` through the frame points `(0,0),(1,1)` (a mirror pair on such a line makes a collinear triple with the frame point) | `3` | `5` |
| `σ_c` (central) | the centre cross `r=½ ∪ c=½` (a mirror pair shares a burned row/col) | `3,5,7` | `9` |
| `σ_c·τ` (centre antidiagonal) | its live fixed line `r+c=1` | `3,5,7,9` | `11` |

**The transpose `τ` was previously untestable.** The earlier mirror scripts
(`2026-07-06-mirror-family.py`) build the size-2 position by having P2 reply `φ(x₁)` to P1's
opening `x₁`, which structurally **requires `φ(x₁) ≠ x₁`** — and `τ` fixes `x₁`. The frame
reduction removes that constraint: the size-2 position is the `τ`-symmetric frame
`{(0,0),(1,1)}`, so `τ` is a legitimate mirror there. It still fails (at `q=5`), because its
problem set is the two frame-antidiagonals — a bounded (≤2 points each, cap limit) but fatal
set, the same poison shape as `σ_c`'s cross. So the transpose closes rather than opens the
single-involution route: **all three Klein-4 involutions fail at bounded `q`**, the best being
the centre antidiagonal at `q ≤ 9`. This matches, in frame language, the prior single-involution
closure (`2026-07-06-qodd-mirror-obstruction.md`).

## Adaptive re-symmetrisation: the direct form breaks at q≥11

`2026-07-06-adaptive-resym-test.py`. After P1 forces a move `x` on `σ_c`'s cross (breaking the
mirror), can P2 reply `y` so the position `{frame, x, y}` is symmetric under some *other*
monomial-affine involution (the only hypergraph automorphisms, by the fundamental theorem of
affine geometry) with dead fixed locus?

- **Direct re-pairing** (the new `φ'` must answer `x` with `y`, i.e. `φ'(x)=y`): OK for every
  break at `q=9`, but **fails at `q=11,13`** — some forced breaks (e.g. `x=(6,5)` at `q=11`)
  admit no involution pairing `x` with any legal reply.
- **Relaxed** (any legal `y` landing `{frame,x,y}` in *some* mirror-symmetric position, `φ'`
  need not pair `x,y`): always possible at `q=9,11,13`.

So the adaptive-mirror route is **not trivially dead** — a symmetric position stays reachable —
but its natural "answer the break with its new mirror partner" form breaks at `q=11`. A working
adaptive proof would need `φ'` to fix the just-played `x` (as a dead point of `S`) and re-pair
the *bulk*, and to keep doing so through every subsequent break; whether that is maintainable
for all `q` is open (and, per the obstruction note, the re-symmetrisation of an accumulating
asymmetric `S` is the hard part).

## The sharpened crux (what a uniform proof must show)

Combining the reduction with the parity-defect structure
(`2026-07-06-qodd-parity-defect-structure.md`, defects have grid min-deviating-size ≥ 4):

> `PG(2,q)=P` ⟺ the frame is P ⟺ **every size-3 grid position has a P size-4 child** ⟺ every
> 3-cell partial-permutation cap extends to a size-4 P-position.

The frame is P because its (odd, size-3) children are all N, which holds as long as the
parity-defect region does not reach grid-size 3 — empirically min-dev-size is 4..6 and *grows*
with `q`. A defective size-4 position is an **even-`N`** one: a position from which the mover
completes an **odd maximal cap** in one move. So the crux is the local statement:

> every 3-cell legal grid position has a legal 4th cell whose size-4 position is **not** a trap
> of only odd-maximal-completable children — equivalently, has an even-`P` size-4 child.

This is a finite geometric extension/avoidance statement about odd maximal caps (arcs), now the
concrete open kernel. It is the natural place to bring arc theory: odd maximal caps first appear
at `q=9` (size 5), and bounding how close their "completion shadow" can get to a 3-cap is what a
uniform planar proof needs.

## The escape margin (a positive falsification signal + proof target)

> **CORRECTION 2026-07-06 (`2026-07-06-escape-margin-erratic.md`).** Extending this table past
> the q=11 wall with a compiled `escape` mode kills the optimism below. min-escape is **erratic,
> not "bounded away from 0 / relaxing as q grows"**: `1,7,13,13,46,5` for q=5,7,9,11,13,17 — it
> **crashes to 5 at q=17**, where `bad = 152` of `total = 157`. So **"`total` outgrows `bad`" is
> false** (`bad` is Θ(q²) ≈ total), and the crux is a delicate near-cancellation. The
> "`3q−14`/plateau" reading and the arc-scarcity proof target are both refuted. The margin tracks
> odd-complete-arc abundance (irregular in q), and the falsification test is genuinely live.

`2026-07-06-escape-margin.py` computes, over ALL legal size-3 grid positions, the number of P
size-4 children each has — the **escape margin**. The crux needs the minimum ≥ 1; a `0` would
flip the root to N (counterexample).

| q | min escape margin | full histogram (`#P-children : count`) |
|---:|---:|---|
| 3 | — (vacuous) | frame is a size-2 maximal cap; no size-3 positions |
| 5 | **1** | `1:400` (every triangle has a *unique* safe extension — tight) |
| 7 | **7** | `7:5880` |
| 9 | **13** | `13:25920  21:10368` |
| 11 | **13** | `13:121000  18:24200` |

The minimum stays **bounded away from 0** (1, 7, 13, 13) — the crux holds comfortably in every
computed case, and the tight `q=5` case (a unique escape) relaxes as `q` grows. It is **not** a
clean linear law (an earlier `3q−14` fit on `q=5,7,9` is broken by `q=11`, whose minimum is 13,
not 19; the minimum plateaus at 13 for `q=9,11`).

(Here a "size-3 grid position" is a 3-cell partial-permutation cap — **not** the projective
triangle, which is the grid size-1 object; the escape crux lives one level below the frame:
grid size-3 → size-4, i.e. projective size-5 → size-6.)

**The decomposition that matters for a proof.** For a size-3 grid position, `escape = (total
legal size-4 extensions) − (bad extensions)`, where a **bad** extension is one to an **even-`N`**
size-4 position — i.e. one from which the mover completes an **odd maximal cap** in one move.
Tracking the min-escape 3-cell position (`{(0,0),(1,1),(2,3)}` up to symmetry across computed `q`):

| q | total ext | bad ext (odd-maximal-completable) | escape = P ext |
|---:|---:|---:|---:|
| 5 | 1 | 0 | 1 |
| 7 | 7 | 0 | 7 |
| 9 | 21 | 8 | 13 |

Bad extensions are **exactly 0 for `q ≤ 7`** (no odd maximal caps exist — pure parity) and first
appear at `q=9` (8 of the 21), matching the parity-defect seed. The escape stays positive because
**`total` (≈ area, `O(q²)`) outgrows `bad`**. So the crux `escape ≥ 1` becomes: *the number of
size-4 extensions of a 3-cell position that are one move from an odd maximal cap never reaches the
total number of extensions.* This is a finite arc-theoretic counting statement — bound `bad` above
(via the structure/scarcity of odd maximal caps) and `total` below. That is the concrete open
target; min-escape (finer than min-dev-size) is the quantity to watch as the ladder extends.

## Artifacts

- `2026-07-06-frame-reduction-verify.py` — grid: sizes 1,2 single-orbit + `root==frame`, q≤9.
- `2026-07-06-frame-orbit-verify.py` — projective: sizes 1..4 single game-value orbit + chain, q≤7.
- `2026-07-06-frame-mirror-test.py` — mirror from the frame for the Klein-4 involutions (incl. τ).
- `2026-07-06-adaptive-resym-test.py` — depth-1 adaptive re-symmetrisation (direct fails q≥11).
- `2026-07-06-escape-margin.py` — #P size-4 children per size-3 position (min escape 1,7,13,13
  for q=5,7,9,11) + total/bad/P decomposition of the min-escape triangle.
