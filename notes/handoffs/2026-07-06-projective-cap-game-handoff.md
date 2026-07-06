# Handoff: Projective Cap Achievement Game

Date: 2026-07-06.

## Target

Study the normal-play impartial game on finite projective space `PG(m,q)`.

- Board: points of `PG(m,q)`, i.e. 1-dimensional subspaces of `F_q^{m+1}`.
- Legal position: a cap, meaning no three selected points are collinear.
- Move: add one unselected point while preserving the cap condition.
- Normal play: player with no legal move loses.

Main conjecture:

> For all `m >= 1` and all prime powers `q`, the cap achievement game on `PG(m,q)` is a
> second-player win: `G(PG(m,q)) = 0`.

This is the natural sequel to the proven affine theorem:

> `AG(n,q)` cap achievement game is P for all `n >= 1` and prime powers `q`.

The affine proof does **not** transfer directly. In projective space there are no translations, board
parity varies, and the affine odd-`q` self-blocking midpoint trick has no obvious projective
replacement.

## Existing Context To Read First

Read these notes before doing new work:

1. `2026-07-04-capset-game-theorem.md`
   - Finished affine theorem.
   - Key tools: whole-board translation mirror in even characteristic; move-then-reflect mirror in
     odd characteristic; parity lemma on invariant lines.

2. `2026-07-04-sumfree-variants.md`
   - Contains the projective-cap motivation.
   - Important equivalence: `PG(k-1,2)` cap game equals the `F_2^k` sum-free game, because over
     `F_2` each projective point is a nonzero vector and each line is `{a,b,a+b}`.

3. `2026-07-04-nodekayles-pairing-lemmas.md`
   - General mirror/pairing patterns: P0 whole-board pairing, P0' move-and-mirror, odd-order
     obstruction.
   - These are graph Node-Kayles statements, not directly hypergraph-cap statements, but the proof
     patterns are the reusable part.

4. `2026-07-04-proj-cap.py`
   - First brute projective-cap probe.
   - Practical cleanup needed before reuse: it imports `gf`, but the local finite-field helper is
     currently named `2026-07-04-gf.py`.

5. `Projective Geometric Algebra: Illustrated`
   - Use as geometric intuition for projective incidence, duality, joins/meets, collineations, and
     fixed loci of transformations.
   - Do **not** import metric/real-field assumptions into the finite-field proof. The game is over
     `F_q`, and the proof must be stated in finite projective geometry / linear algebra terms.
   - The most relevant bridge topics are: projective frames, homogeneous coordinates, perspectivities,
     involutions, homologies/elations, and how transformations act on lines and fixed subspaces.

## Known Data

From prior notes, all small tested cases are P:

- `PG(1,2)`, `PG(2,2)`, `PG(3,2)`;
- `PG(1,3)`, `PG(2,3)`;
- `PG(1,4)`;
- `PG(1,5)`.

This is evidence only. Treat the conjecture as open.

Special sanity checks:

- `PG(1,q)` is just a projective line with `q+1` points. Since any three points on it are collinear,
  the game ends after two moves when `q+1 >= 2`, so it is trivially P.
- `PG(m,2)` has lines of size 3 and board size `2^{m+1}-1` odd. No whole-board fixed-point-free
  pairing can exist. Any P proof here must be genuinely move-then-mirror or non-pairing.

## First Deliverable

Produce a reliable table:

| case | points | opening orbits | outcome | root Grundy if feasible | notes |
|---|---:|---:|---:|---:|---|

Minimum cases:

- `PG(m,2)` for `m=1,2,3,4` if feasible;
- `PG(2,q)` for `q=2,3,4,5`;
- `PG(3,3)` only if a canonical solver makes it feasible.

For each case, classify first-move orbits under `PGL(m+1,q)` or a sound subgroup. Projective space is
point-transitive, so the empty root has one opening orbit, but the second move and later positions
need orbit data.

## Solver Plan

Start with an exact outcome solver, then add canonicalization only as needed.

### Representation

- Points: normalized nonzero vectors modulo scalar multiplication.
- Lines: precompute line masks. For two distinct points `i,j`, the projective line is
  `span(P_i, P_j)` modulo nonzero scalar.
- Position: bitset of chosen points.
- Forbidden mask from a cap `A`: for every pair `a,b in A`, forbid all other points on line `ab`.
- Legal mask: `all_points & ~A & ~forbidden`.

For `PG(2,q)`, every pair determines a line of `q+1` points and the line table is small.

### Correctness Gates

Before trusting canonicalization:

- Validate that every line has exactly `q+1` points.
- Validate that every pair of distinct points lies on exactly one line.
- Validate direct cap checking against incremental forbidden masks.
- Cross-check raw solver vs canonical solver on the smallest cases.
- For `q=2`, cross-check `PG(k-1,2)` against the existing `F_2^k` sum-free solver outcomes.

### Canonicalization

Likely stages:

1. Raw bitmask solver for tiny cases.
2. Full `PGL` enumeration for small `m,q`.
3. Canonical frame method:
   - choose a projective frame from selected/unselected structure;
   - normalize with a `GL` basis;
   - minimize the image of the bitset.
4. If needed, use incidence-graph canonicalization:
   - bipartite graph with point vertices and line vertices;
   - selected points colored differently from unselected;
   - canonicalize using local IR or external nauty/bliss if allowed.

Avoid making canonicalization load-bearing until raw/cross-check data validates it.

## Proof Attacks

### Attack 1: Projective Move-Then-Mirror

Try to replicate the affine odd-`q` proof.

Affine proof shape:

1. P1 opens `a`.
2. P2 replies `b`.
3. The reflection center `c=(a+b)/2` lies on line `ab`.
4. Since `a,b,c` are collinear, `c` is forever unplayable.
5. Point reflection through `c` fixes only `c`, pairs the rest, and the line-parity lemma proves
   mirror replies are legal.

Projective analogue needed:

- After two selected points `a,b`, find an involutive collineation `sigma` such that:
  - `sigma(a)=b`;
  - its fixed locus is already unplayable or safely excluded;
  - every non-fixed point `y` is paired with `sigma(y)` on a line whose selected intersection has
    controlled parity or size;
  - adding `sigma(y)` after legal `y` cannot create a collinear triple.

Candidate collineations:

- homology: fixes a hyperplane pointwise and a center off it;
- elation: characteristic-dependent, fixes a hyperplane and has center on it;
- harmonic homology / projective reflection when available;
- coordinate swap in a basis with `a=[1:0:...]`, `b=[0:1:...]`.

This is where the PGA book is likely useful: it can guide the search for the right geometric
transformation and its fixed locus. Translate any candidate back into a matrix over `F_q` before
trusting it.

Likely obstruction:

- Projective involutions usually have a fixed subspace, not a single fixed point.
- A fixed hyperplane is too large to be automatically blocked by the opening pair.

Goal of this attack:

- Either find a fixed-locus-blocking trick, or prove why every simple involution leaves a live fixed
  point and therefore cannot be a direct mirror.

### Attack 2: Reduce To Quotient Or Residual Geometry

After opening pair `{a,b}`, the line `L=ab` has all remaining points on `L` forbidden. The residual
play happens on `PG(m,q) \ L` with additional constraints from later lines.

Look for a decomposition:

- Projection from `L` onto a complementary `PG(m-2,q)`;
- partition of off-line points into planes through `L`;
- pairing of points inside each affine chart determined by deleting `L`;
- relation to `AG(m,q)` or a bundle of affine spaces.

Key idea to test:

> Does deleting the opening line turn the remaining projective geometry into an affine-like geometry
> where a translation/reflection mirror becomes available fiberwise?

This is plausible because `PG(m,q) \ H` is affine when deleting a hyperplane. But the opening pair
deletes only a line, not a hyperplane, unless `m=2`.

Special case `PG(2,q)`:

- Deleting the opening line leaves `q^2` affine points.
- This case may be directly reducible to `AG(2,q)`-style pairing.
- Prove `PG(2,q)` first if possible; it may expose the right geometry.

### Attack 3: Plane-First Proof

Since any three collinear points lie inside a projective plane, attempt an induction by planes.

Potential statement:

> In `PG(m,q)`, after two moves on a line, P2 can maintain a symmetric cap separately in each plane
> through that line.

There are many planes through a line in `PG(m,q)`. Each off-line point determines such a plane with
the opening line. If the game decomposes or almost-decomposes by these planes, the problem reduces to
`PG(2,q)` residuals.

Need to check couplings:

- A line through two off-line points in different planes may leave both planes, so planes through the
  opening line may not be independent.
- If the mirror maps each such cross-plane line to itself or to a paired line, a global proof might
  still work.

### Attack 4: Strategy-Stealing Is Not Valid

Do not use strategy stealing casually. This is a building/avoidance game: adding a point removes
future moves. Monotonicity fails in the needed direction.

Every N/P claim needs an explicit strategy, nimber argument, or exhaustive certificate.

### Attack 5: Search For Counterexamples

The conjecture may be false. Search should try to break it, not just confirm it.

Good probes:

- Full outcome for larger `PG(2,q)`.
- Post-opening child value after a representative point.
- Whether every possible P2 reply to P1 opening has at least one losing continuation for P1.
- If root is P, classify which second replies to a fixed opening are winning.

If a counterexample appears:

- Verify with two independent solvers.
- Extract minimal losing/winning line.
- Classify by `q` parity, `q mod 3`, and dimension.

## Expected Patterns To Test

For `PG(2,q)`:

- P1 opens `a`.
- P2 may reply `b`.
- The rest of line `ab` is forbidden.
- Remaining points form `AG(2,q)` after deleting line `ab`.

Question:

> Is there a P2 reply `b` such that the residual cap game on the affine complement is exactly, or
> strategically equivalent to, the affine cap game?

For `q=2`:

- `PG(m,2)` equals nonzero vectors in `F_2^{m+1}` with lines `{x,y,x+y}`.
- Existing conjecture/data says this is P for `m=1,2,3`.
- Because board size is odd, the first P1 move must be "burned"; after P1 chooses `a`, P2 needs a
  reply `b` that makes `a+b` forbidden. The remaining nonzero vectors excluding `{a,b,a+b}` may
  admit a linear involution with no fixed live point.

Candidate in `F_2` coordinates:

- Choose independent `a,b`.
- The 2D subspace `<a,b>` has three nonzero points `{a,b,a+b}`, all removed/forbidden after the
  opening pair.
- Try an involution that swaps `a,b` and fixes the quotient. Its fixed space intersects `<a,b>` in
  `a+b`, which is forbidden. But it may also fix many live points outside `<a,b>`.
- Need either a fixed-point-free map on the residual or a higher-rank pairing of fixed fibers.

This is the smallest concrete algebraic problem and should be attacked first by hand.

## Success Criteria

Tier 1:

- Exact, reproducible table for `PG(2,q)` over several `q`, plus `PG(3,2)` and `PG(4,2)`.
- Classification of winning second replies after the unique opening orbit.

Tier 2:

- A human proof for all `PG(2,q)`.
- Clear explanation of why the proof does or does not lift to `m>=3`.

Tier 3:

- Full theorem for all `PG(m,q)`, or a verified counterexample with structural explanation.

## What To Avoid

- Do not conflate affine and projective caps. The affine theorem deletes the hard fixed point by a
  midpoint/self-blocking argument that is not automatically available projectively.
- Do not call small-case P data a theorem.
- Do not rely on one canonical solver without raw cross-checks on smaller cases.
- Do not over-index on whole-board pairings: odd board sizes rule them out, and projective
  involutions often have fixed subspaces.
- Do not treat the famous extremal cap-set problem as load-bearing. This is about game outcome, not
  maximum cap size.

## Likely Paper Shape If Successful

Title direction:

> The projective cap achievement game

Possible structure:

1. Define affine and projective cap achievement games.
2. Recall/prove affine `AG(n,q)` is P for all prime powers.
3. Prove `PG(1,q)` trivial P.
4. Prove `PG(2,q)` by residual affine geometry or projective involution.
5. Lift to all `PG(m,q)`, or state dimension-specific theorem plus counterexamples.
6. Include exact solver/certificate appendix for small cases.
7. Distinguish from Set, Projective Set, extremal cap sets, and general-position games.

If the full projective theorem fails, the paper can still be valuable:

- affine theorem;
- projective small-dimensional classification;
- first counterexample family or obstruction theorem;
- reusable mirror/fixed-locus framework for incidence-geometry games.

## Immediate Next Commands

Work in `../notes`, not Rust source.

First fix or wrap the old probe:

```bash
cd ../notes
cp 2026-07-04-gf.py gf.py
python3 2026-07-04-proj-cap.py
```

Then replace it with a cleaner script that:

- caches line masks;
- validates projective-space axioms;
- emits opening-reply tables;
- optionally computes full Grundy for tiny cases;
- has a raw/canonical cross-check mode.

Keep all runs under a memory cap when exploring larger cases:

```bash
ulimit -Sv 2097152
```

## Handoff Summary

The affine cap game is solved because affine space has exactly the mirrors needed. The projective
cap game is the next high-value test: same cap relation, less translation symmetry, harder fixed
loci. Start with `PG(2,q)` and `PG(m,2)`. Either find a projective move-then-mirror that burns the
fixed locus, or extract the obstruction/counterexample. The first proof target should be `PG(2,q)`;
the first algebraic target should be `PG(m,2)` after opening pair `{a,b}` removes the 2D subspace
`<a,b>`.
