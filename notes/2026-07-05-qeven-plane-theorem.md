# Theorem: the projective cap game on PG(2,q) is P for every even q

**Statement.** For every prime power `q` with `q` even (characteristic 2), the cap
achievement game on the projective plane `PG(2,q)` is a second-player win: `G(PG(2,q))=0`.

Verified in outcome for `q=2,4,8` (`2026-07-05-proj-cap-results.md`) and the strategy
below verified stuck-free over all P1 lines for `q=2,4,8`
(`2026-07-05-qeven-mirror-verify.py`, 0 illegal replies).

## Setup

`|PG(2,q)| = q^2+q+1` is odd for every `q` (handoff R1), so no whole-board pairing exists;
P2 must burn the opening and mirror on a residual (handoff R0).

- P1 opens with a point `a`.
- P2 replies with any point `b ≠ a`. Let `L = ab` be their line.
- Take `L` as the **line at infinity**: `PG(2,q) \ L = AG(2,q)`, the affine plane of `q^2`
  points, and `a, b` are two of the `q+1` directions (parallel classes) at infinity.

**Residual game `H'` (handoff R2).** After `{a,b}`, the remaining `q-1` points of `L` are
forbidden (collinear with `a,b`), so all further play is on the `q^2` affine points, and a
set `S` of affine points is legal iff:

1. no three points of `S` are collinear (the cap condition, restricted to affine lines);
2. no two points of `S` lie on a common line of direction `a` (else `{a}∪` those two are
   collinear in `PG(2,q)`); **[burned direction a]**
3. no two points of `S` lie on a common line of direction `b`. **[burned direction b]**

So the residual is the affine cap game with **two burned parallel classes** — not the plain
`AG(2,q)` game. It is P1 to move into the empty residual.

## Strategy

`q` even ⇒ char 2. P2 fixes a nonzero affine vector `v` whose direction is **not** `a` or
`b` (possible: there are `q+1 ≥ 3` directions, exclude 2). Let `σ = τ_v` be translation by
`v`: `σ(x) = x+v`. Then:

- `σ² = τ_{2v} = τ_0 = id` (char 2), so `σ` is an **involution**;
- `σ` is **fixed-point-free** on the affine points (`x+v=x ⇒ v=0`);
- `σ` is an **automorphism of `H'`**: translations map affine lines to affine lines
  (preserving collinear triples) and preserve every parallel class (so they preserve the
  direction-`a` and direction-`b` 2-edges).

**P2's rule:** whenever P1 plays affine point `x`, P2 replies `σ(x) = x+v`.

## Correctness (the parity lemma)

P2 maintains the invariant that after each of P2's moves the chosen affine set `S` is
`σ`-symmetric (`σ(S)=S`). It holds initially (`S=∅`) and is preserved because P2 adds the
`σ`-orbit `{x, σ(x)}` each round (an involution orbit; `σ(x)≠x`). We show: **if `S` is
`σ`-symmetric and legal and P1 has a legal move `x` (i.e. `S∪{x}` legal), then `S∪{x,σ(x)}`
is legal** — so P2 can always answer, P1 runs out first, and P2 wins.

First, `σ(x) ∉ S∪{x}`: `σ(x)=x` is impossible (fpf); `σ(x)∈S` would give `x=σ(σ(x))∈S` by
symmetry, contradicting that `x` is a fresh legal move. So `σ(x)` is a genuine new point.

Now suppose for contradiction `S∪{x,σ(x)}` contains a forbidden set (an edge of `H'`). Since
`S∪{x}` is legal, that edge `e` must contain `σ(x)`.

- **If `x ∉ e`:** then `e ⊆ S∪{σ(x)}`. Apply `σ`: `σ(e) ⊆ σ(S)∪{x} = S∪{x}`, and `σ(e)` is
  an edge (σ is an automorphism). So `S∪{x}` contains an edge — contradiction.
- **So `x ∈ e` and `σ(x) ∈ e`:** the edge contains **both** `x` and `σ(x)=x+v`. Two sub-cases:
  - `e` is a **burned-direction 2-edge** `{x, x+v}`: then `x, x+v` share direction `a` or `b`,
    i.e. `v` has direction `a` or `b` — excluded by the choice of `v`. Impossible.
  - `e` is a **collinear 3-edge** `{x, x+v, w}` with `w ∈ S`: all three are collinear, and
    `x, x+v` span the direction-`v` line through `x`, so `w = x + t v` for some scalar `t`
    with `t ∉ {0,1}` (a distinct third point). By symmetry `w = x+tv ∈ S ⇒ σ(w) = x+(t+1)v ∈ S`.
    Then `S` already contains `x+tv` and `x+(t+1)v`, and together with `x = x+0·v` these are
    three points at scalars `0, t, t+1` on the direction-`v` line through `x`. In char 2 with
    `t ∉ {0,1}` the scalars `0, t, t+1` are **distinct**, so `{x, x+tv, x+(t+1)v}` is a
    collinear triple inside `S∪{x}` — contradicting that `S∪{x}` is legal.

Every case is impossible, so `S∪{x,σ(x)}` is legal. ∎

The load-bearing point: `σ`-symmetry forces the direction-`v` line through any *legal* P1
move `x` to be **empty** in `S` (any occupant would make `x` itself illegal), which is
exactly what kills the only dangerous 3-edge. The `v ∉ {a,b}` choice kills the 2-edges.

## Scope / why it does not lift

- **Needs `L` to be a hyperplane** so that `PG(m,q)\L` is affine and translations exist.
  A line is a hyperplane only when `m=2`. For `m ≥ 3` the opening pair deletes a line, not a
  hyperplane, the complement is not affine, and there is no translation mirror. So this proof
  is planar-only; `PG(m,2)` for `m≥3` (all P by compute) needs a different argument (handoff
  R5: a linear involution's fixed space has dim `≥ (m+1)/2`, too big to burn from one pair).
- **Needs char 2** for `σ=τ_v` to be an involution. For `q` odd, translations have odd order;
  the natural involutions (homologies, central symmetries) each leave a live fixed point or
  break on the two burned-direction lines through the center (handoff R4). q-odd planes are P
  in outcome (`q=3,5,7,9` computed) but the uniform proof is open.

## Companion (trivial) case

`PG(1,q)`: all `q+1` points are collinear, so a cap has ≤2 points; the game lasts exactly two
moves and P2 makes the last one — P for all `q`.
