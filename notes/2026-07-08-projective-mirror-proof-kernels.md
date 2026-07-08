# Projective cap game: mirror proof kernels (2026-07-08)

Purpose: semi-formalize the mirror/fixed-locus material from the 2026-07-08 discussion while the
Lean job is busy. This note is proof-shape only: no new computation and no Lean build.

The main correction is that a mirror strategy is not certified merely by saying that legal moves
are carried to legal moves. In a cap game, the reply `sigma x` must be legal **after** `x` has been
played. The missing obstruction is the mirror chord `x, sigma x`.

## 1. Abstract pair-extension mirror lemma

Setting:

- `B` is a finite board.
- `Valid : Finset B -> Prop` is the legal-position predicate.
- The game is the normal-play build game: a move from `S` is a point `x notin S` such that
  `Valid (S union {x})`.
- `sigma : B ~= B` is an involution.

One-step pair condition at a position `S`:

1. `Valid S`.
2. `S` is `sigma`-invariant.
3. For every legal move `x` from `S`:
   - `sigma x != x`;
   - `sigma x notin S`;
   - `Valid (S union {x, sigma x})`.

This condition alone is only a first-reply certificate. To prove that `S` is P, it must be closed
under the mirror replies.

Closed mirror condition at `S`:

- For every valid `sigma`-invariant follower `T` containing `S` that can arise by repeatedly adding
  mirror pairs, the one-step pair condition holds at `T`.

Conclusion:

> If the closed mirror condition holds at `S`, then `S` is a P-position.

Proof:

P2 answers every legal `x` with `sigma x`. The assumptions make the reply fresh and legal after
`x`. The new position is

```text
S' = S union {x, sigma x},
```

which is valid and `sigma`-invariant, and is again in the closed mirror class. Since the board is
finite, this copycat strategy cannot leave P2 without a reply; hence P1 is first stuck.

Lean translation:

- This is best stated as a reusable `FiniteBuildGame` lemma.
- Do not state the weaker condition "`sigma` maps legal moves to legal moves." That is insufficient
  for cap games.
- Separate the one-step predicate from the closed strategy predicate:

```text
MirrorStepGood(S, sigma) :=
  Valid S
  and sigma-invariant S
  and forall legal x from S,
      sigma x != x
      and sigma x notin S
      and Valid (S union {x, sigma x})

MirrorClosed(S, sigma) :=
  forall T in the mirror-pair closure above S,
    MirrorStepGood(T, sigma)
```

Then prove:

```text
MirrorClosed(S, sigma)
=> IsP S
```

For many applications, the closure is automatic because `MirrorStepGood` is proved for every valid
`sigma`-invariant `S` in a class.

## 2. Projective fixed-point-free collineation mirror lemma

Setting:

- `X = PG(V)` over a finite field.
- `Valid S` means `S` is a cap: no three selected points are collinear.
- `sigma` is a projective collineation.
- `sigma^2 = id` on projective points.
- `sigma` has no fixed projective point.

Claim:

> If `S` is a `sigma`-invariant cap and `x` is legal from `S`, then
> `S union {x, sigma x}` is a cap.

Proof obligations:

Freshness:

- If `sigma x in S`, then by `sigma`-invariance and involutivity, `x in S`, contradiction.
- If `sigma x = x`, contradiction to fixed-point-freeness.

Cap check:

Since `S union {x}` is a cap, any new violation after adding `sigma x` must contain `sigma x`.

Case 1: a line through `sigma x` and two old selected points `a,b in S`.

- Apply `sigma^{-1}`.
- Collinearity is preserved, so `x, sigma a, sigma b` are collinear.
- Since `S` is invariant, `sigma a, sigma b in S`.
- Thus `x` was illegal from `S`, contradiction.

Case 2: a line through `sigma x`, `x`, and one old selected point `z in S`.

- Let `L` be the line through `x` and `sigma x`.
- Because `sigma` swaps `x` and `sigma x`, the line `L` is `sigma`-invariant.
- Hence `sigma z` also lies on `L`, and `sigma z in S`.
- Since `sigma` is fixed-point-free, `sigma z != z`.
- The old pair `z, sigma z` lies on a line containing `x`, so `x` was illegal from `S`, contradiction.

Therefore the pair-extension condition holds.

Conclusion:

> A fixed-point-free projective collineation involution gives a whole-board P strategy for the cap
> game.

## 3. Odd-dimensional projective spaces over odd fields

Theorem:

> For odd `q` and every `m >= 1`, the cap game on `PG(2m-1,q)` is P.

Coordinate construction:

- Let `K = F_q`, `q` odd.
- Let `V` have dimension `2m`.
- Choose a nonsquare `delta in K^*`.
- On each two-dimensional block with coordinates `(a,b)`, define

```text
T(a,b) = (delta * b, a).
```

Then:

```text
T^2(a,b) = (delta * a, delta * b) = delta * (a,b),
```

so `T^2 = delta * id`.

Projective involution:

- The induced map `[v] |-> [T v]` is a projective collineation.
- Its square is `[v] |-> [delta v] = [v]`, so it is an involution in projective space.

No fixed points:

- If `[T v] = [v]`, then `T v = lambda v` for some `lambda in K^*`.
- Applying `T` again gives `delta v = T^2 v = lambda^2 v`.
- Since `v != 0`, `lambda^2 = delta`, impossible because `delta` is nonsquare.

Apply the fixed-point-free collineation mirror lemma.

Lean checklist:

1. Prove the coordinate theorem for `Fin m -> K x K` or an equivalent `Fin (2*m) -> K` model.
2. Package `T` as a linear equivalence.
3. Show the induced projective map is involutive because `T^2` is scalar.
4. Show no projective fixed point by the nonsquare contradiction.
5. Transport to an arbitrary even-dimensional `V` by a linear equivalence.

## 4. Binary projective spaces

Theorem:

> For every `n >= 1`, the cap game on `PG(n,2)` is P.

Reason for the model:

- Projective points over `F_2` are exactly nonzero vectors of `F_2^{n+1}`.
- The line through distinct nonzero vectors `u,v` is

```text
{u, v, u + v}.
```

- Thus caps are exactly subsets with no distinct `u,v,w` satisfying `u+v+w=0`.

Strategy:

1. P1 plays `a`.
2. P2 chooses `b != a`, possible because `n >= 1` gives vector dimension at least `2`.
3. Let `c = a + b`.
4. The point `c` is immediately blocked by the selected pair `{a,b}`.
5. On all remaining nonzero vectors except `a,b,c`, pair

```text
tau(x) = x + c.
```

`tau` swaps `a` and `b`, sends `c` to `0`, and restricts to a fixed-point-free involution on the
unselected playable residual.

Invariant after P2 moves:

- The selected set `S` contains `a,b`.
- `S` is `tau`-invariant.
- `c notin S`.
- `S` is a cap.

Pair-extension proof:

Let `x` be legal from `S`, and set `y = tau(x) = x+c`.

Freshness:

- `x != c`, since `c` is blocked by `{a,b}`.
- Hence `y != 0`, so `y` is a projective point.
- If `y in S`, then `x = tau(y) in S` by invariance, contradiction.

Suppose adding `y` after `x` creates a forbidden line.

Case 1: `y = u + v` for old selected `u,v in S`.

- Since `S` is `tau`-invariant, `tau(u)=u+c in S`.
- Then

```text
x = y + c = u + v + c = tau(u) + v.
```

- The two old points `tau(u)` and `v` are distinct; otherwise `y=c`, which would force `x=0`.
- Thus `x` was already illegal, contradiction.

Case 2: `x + y + z = 0` for some old selected `z in S`.

- Since `y=x+c`, this gives `z=c`.
- But `c notin S`, contradiction.

Thus `S union {x,y}` is a cap, and P2 mirrors.

Lean route:

- Prefer not to reprove all of this directly if the existing sum-free theorem applies.
- Bridge `Projectivization (ZMod 2) V` to `{v // v != 0}`.
- Prove/projectively reuse that collinearity is `x+y+z=0`.
- Invoke `Sumfree.Game.initial_isP_of_at_least_two_nonzero_orderTwo` or the rank wrapper.

## 5. Correct central-inversion endgame lemma for odd projective planes

This is not a proof of the odd-plane theorem. It is a sound endgame certificate shape.

Residual grid model:

- After opening projective points at infinity, legal affine positions are:
  - affine caps;
  - at most one point in each burned row;
  - at most one point in each burned column.

Let `sigma_c(x) = 2c - x` be central inversion about an affine point `c`.

Sufficient hypotheses for a mirror:

1. `S` is a valid residual position.
2. `S` is `sigma_c`-invariant.
3. `c notin S`.
4. `c` is not legal from `S`.
5. No legal move lies on either burned-direction line through `c` (the row and column through `c`
   in normalized coordinates).

Claim:

> Under these hypotheses, `S` is P by central-inversion mirroring.

Proof sketch:

- `sigma_c` preserves affine collinearity and swaps rows with rows / columns with columns, so
  old-old obstructions pull back exactly as usual.
- The mirror chord through `x` and `sigma_c x` is the affine line through `c` and `x`.
- If an old selected point `z` lies on that chord, then `sigma_c z` is also selected and lies on
  the same chord. Unless `z=c`, the old pair `z, sigma_c z` already made `x` illegal.
- The case `z=c` is excluded by `c notin S`.
- Burned row/column pair violations occur exactly when `x` lies on one of the two burned-direction
  lines through `c`; those moves are excluded by hypothesis.
- The fixed point `c` is not legal, so no legal move is fixed.

This packages the useful part of the old central-symmetry attempt: the center being dead is not
enough; the two burned-direction mirror-chord fibers must also be neutralized.

## 6. MirrorStepGood, MirrorClosed, and obstruction sets

Definitions for solvers/certificates:

```text
MirrorStepGood(S, sigma) :=
  sigma is an involutive residual automorphism
  and S is valid and sigma-invariant
  and for every legal x from S:
      sigma x != x
      and sigma x notin S
      and Valid(S union {x, sigma x})

MirrorClosed(S, sigma) :=
  every mirror-pair follower T above S satisfies MirrorStepGood(T, sigma)

Obs_sigma(S) :=
  { x legal from S | not Valid(S union {x, sigma x}) or sigma x = x or sigma x in S }.
```

Uses:

1. `Obs_sigma(T)=empty` for every mirror-pair follower `T` above `S` is a P certificate.
2. Small `Obs_sigma(S)` is a defect skeleton, not a proof.
3. In certificate books, `MirrorClosed` can be a terminal `PCert` leaf instead of expanding an
   explicit reply subtree. A one-step `MirrorStepGood` leaf is not sound unless a separate theorem
   proves closure.
4. In diagnostics, obstruction types should be separated:
   - fixed legal point;
   - mirror chord through selected point;
   - burned row/column pair;
   - other residual-rule failure.

## 7. Current priority from these kernels

Proofs to formalize first:

1. Abstract pair-extension mirror lemma.
2. Projective fixed-point-free collineation mirror lemma.
3. Odd-dimensional odd-`q` elliptic involution theorem.
4. Binary projective theorem via the sum-free bridge.

Support tooling:

1. `MirrorStepGood` / `MirrorClosed` census on existing q=11/q=13/q=17 data.
2. Certificate leaf format for `MirrorClosed`.

Do not restart:

- broad "fixed locus dead implies mirror" claims;
- uniform fixed-involution proof attempts for odd projective planes.
