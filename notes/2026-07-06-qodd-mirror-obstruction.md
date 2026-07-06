# q-odd planar cap game: the single-involution mirror is NOT uniform (2026-07-06)

Follow-up to `2026-07-05-qodd-central-symmetry-findings.md`. That note killed the central-
symmetry mirror with local patches for `q ≥ 9`. This session **closes the entire fixed
single-involution mirror approach** — the *other* viable involution family (antidiagonal /
transpose-type), never previously tested as a bulk-forced mirror, also fails, at `q = 11`.
So no fixed involution mirror proves the q-odd planar case uniformly; the proof needs a
genuinely non-mirror (or adaptive) mechanism. New outcome datum: **PG(2,11) = P**.

## The residual grid game (recap)

After the opening pair `{a,b}` with `L=ab` at infinity, the residual is the q×q grid game
(`2026-07-05-grid-game.py`): legal position = partial permutation matrix (≤1/row, ≤1/col,
the two burned directions) that is also an affine cap. P1 moves first;
`PG(2,q)=P ⟺ this grid game is a first-player loss.`

A **mirror strategy** for P2 needs an involutive automorphism `φ` of the grid hypergraph.
By the fundamental theorem of affine geometry, automorphisms are affine maps with **monomial**
linear part (they must preserve collinearity AND the {row,col} parallel-class pair). The
involutions are exactly:

- **diagonal `diag(-1,-1)` + shift = central symmetry `σ_c`** (`σ_c(x)=2c-x`): one fixed
  point `c`; problem-set = **c's row ∪ c's col** ("the cross"), where `σ_c(x)` shares a
  **burned** direction with `x` ⇒ the mirror reply is an illegal burned 2-edge.
- **diagonal `diag(±1,∓1)` = reflection**: `φ(x)` shares a row (or col) with `x` for *every*
  `x` ⇒ the whole board is a problem-set. Not a mirror. (Dead.)
- **antidiagonal (swap-type) `φ(r,c) = (a·c+s, a⁻¹(r−s))`, `a∈F*`, `s∈F`**: one **fixed
  line** `ℓ` (the axis, direction `(a,1)`, a NON-burned direction), pointwise fixed;
  problem-set = `ℓ` (q cells). The φ-invariant non-axis lines are the "anti-axis" lines `M_p`
  through each axis point `p` (direction `(a,−1)`); on `M_p`, φ is the reflection `x↦2p−x`.

So there are exactly **two** viable mirror families: `σ_c` and the antidiagonals. (Over a
composite field there are also semilinear/Frobenius involutions, but `q=11` is prime and
already defeats every mirror below, so semilinearity cannot rescue uniformity either.)

## The permissive test

For each family we test the **most permissive** bulk-forced mirror strategy: P2 rigidly
replies `φ(x)` to every **bulk** move (where `φ(x)` differs from `x` in both row and col), and
replies **freely (any legal cell)** to a problem-set move, choosing the involution / center
optimally. This is strictly stronger than any specific patch (transpose cross-pairing,
adaptive row↔col, "reply on axis", "fill M_p"): if the permissive search loses, no
bulk-forced mirror of that family wins.

| mirror family | script | wins for q | first failing q |
|---|---|---:|---:|
| central symmetry `σ_c` (free cross, any center) | `2026-07-06-qodd-bulk-forced.py` | 3, 5, 7 | **9** |
| antidiagonal `φ` (free axis, all `a,s`) | `2026-07-06-mirror-family.py` | 3, 5, 7, 9 | **11** (all 100 φ) |

Both families die. Neither is uniform. The antidiagonal survives exactly one q-step further
than central symmetry, then fails identically. Restricted deterministic antidiagonal variants
fail even sooner (`2026-07-06-antidiag-axis-strategy.py`: "reply on the axis ℓ" dies at q=11;
`2026-07-06-antidiag-Mp-strategy.py`: "fill `M_p`" dies at q=5).

## Why every mirror dies: the poison mechanism

`2026-07-06-trace-fail.py` extracts P1's defeating line (q=11, antidiagonal): P1 plays an
**axis** cell, P2 must reply off the mirror (breaking φ-symmetry), and several moves later a
**forced bulk mirror `φ(w)` is illegal**. The clean lemma:

> With `S` φ-symmetric and legal and `w` a legal bulk move, `φ(w)` is legal. The only line
> that can carry a forbidden triple is `M = wφ(w)`, which is φ-invariant; `φ|_M` is a
> nontrivial involution on the affine line `M` with a **single** fixed point `p_M = M∩ℓ`
> (the axis). Since `S∩M` is φ-symmetric and a cap allows ≤2 points per line, a poisoning
> third point on `M` must be the fixed point `p_M` **on the axis**.

So the mirror is poisoned **iff an occupied problem-set point sits on a live mirror line**.
Once P1 forces a non-symmetric reply on the problem-set, that reply (or the axis point P1
played) lands on a mirror line and detonates later. For central symmetry the problem-set is
in the burned directions, so *no* symmetric reply even exists (`σ_c(x)` is itself illegal).
For the antidiagonal the axis is pointwise-fixed, so axis moves *can* be answered
symmetrically within `ℓ` — but the axis points then poison their anti-axis lines `M_p`, and
because the antidiagonal **swaps rows↔columns**, an unpaired reply `z₀` also leaves a row/col
"shadow" hole (`φ(z₀)∉S`) that poisons via the row/col channel. Every patch trades one poison
channel for another.

## New outcome data

`PG(2,11) = P` (root Grundy 0), 11,289,645 memo states, `2026-07-05-proj-cap-fast.py`. The
q-odd ladder is now **P for q = 3,5,7,9,11** — the conjecture survives every computed case,
including past the q=9 where the σ_c mirror first broke.

## The sharpened open problem

The q-odd planar cap game is P in outcome for all computed q, but **no fixed single-involution
mirror strategy is uniform** — both viable families fail at bounded q with an identified poison
mechanism. A uniform proof must therefore be one of:

1. **Adaptive mirror** — re-choose the involution after each problem-set move so the position
   stays symmetric under the *current* involution. (The obstruction: re-symmetrizing an
   already-asymmetric `S` under a new monomial involution is generally impossible.)
2. **Sprague–Grundy decomposition** of the grid game into a disjunctive sum. **Caveat — this
   is unpromising for a planar cap game:** a disjunctive sum needs the *available* points to
   partition into blocks with no constraint (collinear triple / row / col) crossing blocks, but
   in a plane **every pair of points lies on a line**, so any third available point can complete
   a cross-block triple — the constraint hypergraph on the available set stays connected
   throughout play. Decomposition is far more natural in `m ≥ 3` (points can be genuinely
   "far apart") than in the plane.
3. **Non-constructive parity/counting** argument that does not exhibit an explicit pairing.

Attack priority: the mirror route (documented here) is closed. Given the decomposition caveat,
the most promising planar routes are the adaptive mirror (1) and counting (3); decomposition (2)
is better aimed at the `m ≥ 3` lift. The even-q planar theorem (`2026-07-05-qeven-plane-theorem.md`) and the affine theorem
stand — those work precisely because a fixed fpf involution *does* exist there (translation in
char 2 / midpoint reflection with a single dead fixed point in the unconstrained affine game).

## Artifacts

- `2026-07-06-qodd-bulk-forced.py` — σ_c bulk-forced + free cross + any center; wins q≤7, fails q=9.
- `2026-07-06-mirror-family.py` — all antidiagonal involutions, free axis; wins q≤9, fails q=11.
- `2026-07-06-antidiag-axis-strategy.py` — antidiagonal + reply-on-axis; fails q=11.
- `2026-07-06-antidiag-Mp-strategy.py` — antidiagonal + fill-`M_p`; fails q=5 (row/col shadow).
- `2026-07-06-antidiag-free-large.py` — single-φ free antidiagonal at large q (q=11 fails).
- `2026-07-06-trace-fail.py` — extracts P1's defeating line; confirms the poison mechanism.
