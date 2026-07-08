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

## Review Corrections (2026-07-05)

A review pass reworked the math below. These supersede the looser statements later in the doc; read
them first, they change the priorities.

**Lean status (2026-07-07).** Cross-references below name the current files; do not rename Lean files
to match older prose. The residual grid vocabulary has started in
[`../../lean/ProjectiveCap/Grid.lean`](../../lean/ProjectiveCap/Grid.lean). The finite
normal-play "add one legal point" kernel is in
[`../../lean/CapGame/BuildGame.lean`](../../lean/CapGame/BuildGame.lean), with the affine cap game in
[`../../lean/CapGame/Affine.lean`](../../lean/CapGame/Affine.lean). The projective cap game is in
[`../../lean/ProjectiveCap/Projective.lean`](../../lean/ProjectiveCap/Projective.lean), and the
residual grid game is in
[`../../lean/ProjectiveCap/GridGame.lean`](../../lean/ProjectiveCap/GridGame.lean). The game-valued
escape/bad split is formalized there as `EscapeExtensions`, `BadExtensions`,
`legalExtensions_card_eq_escape_add_bad`, and
`oddEscapeStatement_iff_escapeExtensions_nonempty`. The normalized residual seed facts are in
[`../../lean/ProjectiveCap/GridSeed.lean`](../../lean/ProjectiveCap/GridSeed.lean):
`StandardResidualSeed`, `standardResidualSeed_card`, and `standardResidualSeed_gridCap`. The first
counting prerequisites are in
[`../../lean/ProjectiveCap/GridCounting.lean`](../../lean/ProjectiveCap/GridCounting.lean):
`UsedRows`, `UsedCols`, `FreeFreeCells`, `PairLine`, `PairLineBlockedBy`,
`card_usedRows_of_card_three`, and `card_usedCols_of_card_three`. Stable theorem targets are named in
[`../../lean/ProjectiveCap/StableFacts.lean`](../../lean/ProjectiveCap/StableFacts.lean), whose
`legalGridExtensions_eq_gridGame` theorem ties the old stable extension set to the real grid-game
extension set. The
odd-plane escape target is isolated in
[`../../lean/ProjectiveCap/Almost/OddEscape.lean`](../../lean/ProjectiveCap/Almost/OddEscape.lean).
The game-valued residual target is `ProjectiveCap.Almost.OddEscapeGameStatement`; it is still a
target statement, not a theorem (it is open mathematics for general odd `q`).

**UPDATE 2026-07-07 (session 6):** the **total lemma is now a Lean theorem** —
[`../../lean/ProjectiveCap/ExtensionCount.lean`](../../lean/ProjectiveCap/ExtensionCount.lean)
proves `Stable.SizeThreeExtensionCountStatement` (`sizeThreeExtensionCount`; the
`q²−9q+21` count for every size-3 grid cap, every finite field). The **parity route is
formalized** in
[`../../lean/ProjectiveCap/EscapeParity.lean`](../../lean/ProjectiveCap/EscapeParity.lean):
`oddEscapeGameStatement_of_forall_even_bad` reduces `OddEscapeGameStatement` for odd `q` to the
bad-parity hypothesis (`Even (BadExtensions S₃).card` for all `S₃`) — exactly the regime that
settles `q ≤ 9` in prose. The **frame-reduction game skeleton is formalized**: the
`FiniteBuildGame` kernel now has `win_map`/`isP_map` (value transport along validity-preserving
board permutations), `SizeValueConstant`, `win_iff_not_win_succ`, and
`isP_empty_iff_isP_of_frame_chain`
([`../../lean/CapGame/BuildGame.lean`](../../lean/CapGame/BuildGame.lean)); the projective wrapper
`Projective.initialPStatement_iff_isP_frame`
([`../../lean/ProjectiveCap/Projective.lean`](../../lean/ProjectiveCap/Projective.lean)) collapses
the conjecture to one frame position, with the remaining geometric obligations named as
hypotheses: `CapTransitiveStatement k` for `k = 1..4` (PGL-transitivity on points / pairs /
triangles / frames, cap-preserving) and cap extendability at sizes `≤ 3`. All new theorems check
with axioms `[propext, Classical.choice, Quot.sound]` only. The old
`ProjectiveCap/Affine.lean` and `ProjectiveCap/BuildGame.lean` files are compatibility imports only;
new affine work should use the `CapGame` namespace.

### R0. Structural fact — projective space has NO fixed-point-free collineation involution

For **every** `(m,q)`. Odd char: an involution in `PGL(m+1,q)` splits into `±1` eigenspaces, each a
nonempty fixed subspace. Even char: an involution is unipotent `1+N`, `N^2=0`, with nonempty fixed
space `ker N`. Either way the fixed locus is nonempty. This is the clean reason affine is easy and
projective is hard: affine has translations (fpf) as a whole-board mirror; projective has none. So a
whole-board pairing NEVER exists here — every case must burn opening moves and mirror on a residual.

### R1. Parity, stated once

`|PG(m,q)| = 1 + q + ... + q^m` is **even iff (q odd and m odd)**, odd otherwise. In particular
**every `PG(2,q)` is odd** (`q^2+q+1 = q(q+1)+1`), so the plane always burns a move regardless of q's
parity. Even the even-board cases (e.g. `PG(3,3)`, 40 points) get no free pairing, by R0.

### R2. The residual after the opening line is a CONSTRAINED affine game, not `AG(2,q)`

This is load-bearing and fixes a repeated mis-statement below (Attack 2, "Expected Patterns").
After P1 plays `a`, P2 plays `b`, the line `L=ab` is the line at infinity and `a,b` are two
*directions*. A later collinear triple `{a,x,y}` = two affine points on a direction-`a` line. So the
residual hypergraph on the `q^2` affine points is:

> residual cap  ⟺  affine cap  AND  ≤1 point per direction-`a` line  AND  ≤1 point per direction-`b` line.

Affine caps with **two burned parallel classes**. The affine theorem is about the *unconstrained*
game and does not apply directly. Every mirror argument must be checked against these two extra
2-point edges.

### R3. q-even planes are provable NOW (write as a lemma)

`PG(2,q)`, `q` even. P1 plays `a`; P2 plays any `b`; `L=ab`. On the residual hypergraph `H'` (R2),
any translation `τ_v` is an automorphism (translations preserve collinear triples AND parallel
classes ⇒ they preserve both burned-direction edges). Pick `v` **not** in direction `a` or `b`. In
char 2, `τ_v` is a **fixed-point-free involution automorphism of `H'`** (`τ_v^2=id` since `2v=0`;
fpf since `v≠0`). The `v ∉ {dir a, dir b}` choice is exactly what keeps `x, τ(x)` off a shared
burned-direction line. fpf involution automorphism ⇒ whole-residual pairing (P0 lemma,
`nodekayles-pairing-lemmas`) ⇒ residual is a 2nd-player win; P1 moves first into the empty residual
⇒ P2 wins ⇒ `G(PG(2,q))=0`. Needs the legality/parity lemma written against `H'`, but it is a lemma,
not an open problem. **DONE 2026-07-05** — full proof + parity lemma in
`2026-07-05-qeven-plane-theorem.md`; strategy verified stuck-free over all P1 lines for
`q=2,4,8` (`2026-07-05-qeven-mirror-verify.py`).

### R4. q-odd planes are the real open kernel — the obstruction is concrete and bounded

`q` odd has no translation involution (`τ_v` has order `p`, odd). The two natural involutions each
fail on a small, explicit set:

1. **Homology, axis `L=ab`, center `o` off `L`.** The `q+1` axis points are all dead (2 played +
   `q-1` forbidden), so the axis is handled — but the center `o` is off `L`, hence **live**, and is
   the unique other fixed point. By the central-collineation property `{x,σ(x),o}` are always
   collinear, so the *first completed mirror pair kills `o`*. Gap: if P1's first post-opening move
   is `o` itself, P2 is thrown out of the mirror into `{a,b,o}` with no automatic continuation. (NOT
   a clean P2 loss — once `o` is played every `σ`-pair also collides with `o`, so P1 can't steal the
   mirror either — but P2's strategy is undefined there.)
2. **Central-symmetry residual route.** After an affine reply, `σ_c(x)=2c−x` with `c` on line
   `x1x2` (dead). `σ_c ∈ Aut(H')` with one fixed point `c` (dead), pairing the ordinary-cap
   structure — **except** on the two lines through `c` in directions `a` and `b`, where `x` and
   `σ_c(x)` form a burned-direction pair ⇒ illegal reply. Failure set = exactly those two lines
   (`q` points each).

Closing either failure set is the theorem. This is far more tractable than "involutions have fixed
subspaces." Because it might genuinely FAIL, treat `PG(2,{5,7,9})` as a falsification test, not a
confirmation.

**UPDATE 2026-07-05 — central symmetry route ATTACKED and found INSUFFICIENT (evidence):** full
analysis in `2026-07-05-qodd-central-symmetry-findings.md`. Grid reformulation (residual = q×q
partial-permutation-matrix + cap; each row/col holds ≤1 cell ever). Among collineation involutions
only central symmetry `σ_c` is viable (reflections force burned pairs). The **`σ_c` parity lemma
HOLDS** off the center's row/col (machine-verified 0 violations, `q=3..11`, incl. composite q=9;
`2026-07-05-sigma-lemma-test.py`). BUT `σ_c` cannot mirror the center's row/col (image lands on the
same full line), and both patches tried — fixed transpose cross-pairing (works q=3 only) and
adaptive row↔col answering (works q≤7, **FAILS q=9,11**) — break `σ_c`-symmetry, which poisons later
bulk replies for `q≥9`. So **central symmetry + local patch is insufficient for q≥9**; the small-case
(q≤7) success was misleading. The q-odd proof needs a genuinely different mechanism (Grundy
decomposition, or a strategy that keeps the center's row+col permanently balanced without breaking
global symmetry). Outcome stays P (computed q≤9).

**UPDATE 2026-07-06 — the ENTIRE single-involution mirror approach is CLOSED (evidence):** full
analysis in `2026-07-06-qodd-mirror-obstruction.md`. The grid hypergraph's automorphism involutions
are exactly two families (fundamental theorem of affine geometry ⇒ monomial affine maps):
central symmetry `σ_c` and the **antidiagonal (transpose-type)** involutions. The antidiagonal was
previously dismissed ("fixed locus = a whole live line") but **never tested as a bulk-forced mirror
with free handling of that line** — and it is genuinely *better* than `σ_c`: its problem-set is a
single fixed line `ℓ` in a NON-burned direction, pointwise fixed (so axis moves CAN be answered
symmetrically). Under the most permissive bulk-forced test (force `φ` on the bulk, reply FREELY to
problem-set moves, best involution): **`σ_c` wins q≤7 fails q=9; the antidiagonal wins q≤9 fails
q=11 (all 100 φ)**. Neither is uniform. Poison mechanism pinned (`2026-07-06-trace-fail.py`): a
mirror `φ(w)` is illegal iff an occupied problem-set point sits on the φ-invariant line `wφ(w)` (its
axis-intersection); every problem-set reply eventually detonates. The antidiagonal has an EXTRA
row/col-swap poison channel (an unpaired reply's `φ`-shadow leaves a row/col hole). **So the uniform
q-odd proof cannot be a fixed-involution mirror — it needs an adaptive-involution or non-mirror
(Grundy-decomposition / counting) mechanism.** New outcome datum: **PG(2,11)=P** (11.3M states,
`2026-07-05-proj-cap-fast.py`); the q-odd ladder is P for q=3,5,7,9,11. `σ_c` scripts:
`2026-07-06-qodd-bulk-forced.py`; antidiagonal: `2026-07-06-mirror-family.py` (+ axis / M_p /
free-large / trace variants).

### R5. Feasibility — the plan is too pessimistic

- **Caps are small.** Max cap in `PG(2,q)` = `q+1` (q odd) / `q+2` (q even); in `PG(3,q)` = `q^2+1`
  (ovoid). So game DEPTH is tiny: `PG(2,9)` is depth ≤ 11 on 91 points, `PG(3,3)` depth ≤ 10 on 40.
  All easily solvable — push the table well past `q=5`.
- **`PGL(m+1,q)` is 2-transitive on points** ⇒ the opening *pair* `{a,b}` is a single orbit ⇒ **all
  second replies are game-equivalent** (identical Grundy). This kills the "classify winning second
  replies" deliverable — they are all the same value. Orbit branching starts only at cap size >
  `m+2`.
- **q=2 column is free:** `PG(m,2)` cap game ≡ `F_2^{m+1}` sum-free game. `PG(4,2)=F_2^5`. **Import
  from the existing sum-free solver**, don't re-derive.
- q=2, `m≥3` caveat: a linear involution `1+N` in `GL(k,2)` has fixed space `dim ≥ k/2` — too big to
  block from one opening pair, so `PG(m,2)` `m≥3` needs a non-linear or non-pairing strategy. This is
  the hard q=2 frontier.

### R6. Reprioritized sequence

0. Import `PG(m,2)` outcomes from the `F_2^{m+1}` sum-free solver (free data).
1. Solve `PG(2,q)` for `q=3,5,7,8,9` exactly — falsification test for the q-odd case.
2. Write the q-even planar lemma (R3) + verify on `PG(2,{2,4,8})`.
3. Attack the q-odd kernel (R4): handle the center move / the two burned-direction lines.
4. `PG(3,3)`, `PG(4,2)` for the `m≥3` picture.

Attack 5 (counterexample search) is now co-equal with the proof attacks, not last. Attack 3
(plane-first induction) is weakest — deprioritize behind 1/2.

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

- Deleting the opening line leaves `q^2` affine points — but the residual game is the CONSTRAINED
  affine game of R2 (two burned parallel classes), not plain `AG(2,q)`. See R2/R3/R4.
- q even: reducible now (R3, translation mirror survives the constraint). q odd: obstructed (R4).
- Prove `PG(2,q)` first; it exposes the right geometry.

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
- Remaining points form `AG(2,q)` after deleting line `ab`, but the residual GAME carries two burned
  parallel classes (R2) — it is not the plain affine cap game.

Question (refined by R2–R4):

> The residual is affine caps with ≤1 point per direction-`a`/`b` line. For q even a translation
> mirror `τ_v` (`v ∉ {dir a, dir b}`) fpf-pairs it (R3). For q odd every candidate involution leaves
> a live fixed point or breaks on the two burned-direction lines through the center (R4). Close that.

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

## Progress

**2026-07-05 (session 1) — R6 steps 1 + partial 0/4 DONE, all P.** Built the fast exact
solver `2026-07-05-proj-cap-fast.py` (bitmask + incremental forbidden + axiom-validation
gate). Results table: `2026-07-05-proj-cap-results.md`. Cross-checked against the raw probe
and against an independent F_2^k sum-free solver (`2026-07-05-sumfree-f2-crosscheck.py`) —
identical outcomes AND memo-state counts on the q=2 column (strong correctness signal).

Computed, **every case P** (root Grundy 0):
- `PG(2,q)` for `q = 2,3,4,5,7,8,9` — the whole planar ladder. **Every q-odd plane
  (3,5,7,9) is P**, including the non-prime char-3 field `q=9`. This is the falsification
  test (R6-1) and the conjecture passed: the q-odd case (obstructed for the single-
  involution proof, R4) is a 2nd-player win in outcome. Strategy exists; uniform proof does
  not yet.
- `PG(3,2)`, `PG(4,2)` (= F_2^4/F_2^5), `PG(3,3)` (m=3 odd char).

Feasibility: caps are small ⇒ tiny depth ⇒ `PG(2,9)` solves in ~1s, no canonicalization.
Only blow-up = `PG(5,2)` (= F_2^6 sum-free, large binary caps, memo > 1.3 GB, killed) —
needs the sum-free import or a canonical solver; off critical path.

**q-even planar theorem (R6-2) DONE:** `2026-07-05-qeven-plane-theorem.md` — full proof
(translation mirror `τ_v`, `v ∉ {a,b}`) with the parity lemma worked out (the 3-edge case
is killed by σ-symmetry forcing the direction-`v` line through any legal P1 move empty).
Strategy verified stuck-free for `q=2,4,8` (0 illegal replies).

**q-odd kernel (R6-3) ATTACKED:** `2026-07-05-qodd-central-symmetry-findings.md`. Grid
reformulation + `σ_c` parity lemma confirmed (q≤11) + evidence-backed NEGATIVE: central
symmetry + local special-line patch is insufficient for q≥9 (the two special lines poison the
mirror; q≤7 success was small-case luck). The uniform q-odd proof remains open and now needs a
non-central-symmetry idea.

**2026-07-06 (session 2) — the WHOLE single-involution mirror approach CLOSED; PG(2,11)=P.**
Details in `2026-07-06-qodd-mirror-obstruction.md`. Enumerated the grid hypergraph's involution
automorphisms (monomial affine ⇒ exactly two families: central symmetry + antidiagonal). Tested
the antidiagonal/transpose mirror — never tried before — as a bulk-forced mirror with free axis
handling: it is strictly better than `σ_c` (problem-set = 1 pointwise-fixed line vs the 2-line
cross) and wins q≤9, but **fails q=11 (all 100 φ)**. `σ_c` (free cross, any center) fails q=9.
Neither uniform; poison mechanism identified (occupied problem-point on a φ-invariant mirror
line; antidiagonal has an extra row/col-swap channel). Also computed **PG(2,11)=P** (11.3M
states) and built a **canonical grid solver** (`2026-07-06-grid-canon.py` translation⋊swap;
`2026-07-06-grid-canon2.py` full group incl. torus) — canonicalizes the residual grid game
under the grid automorphism group; validated vs the naive projective solver (all P, q≤13);
state collapse ~3000× (q=13: 3672 full-group states vs ~3×10⁸ naive). New: **PG(2,13)=P**,
**PG(2,17)=P**, **PG(2,19)=P** (q=17: 15.5M states ~15 min; q=19: 11.7M states). q-odd ladder
now **P for q=3,5,7,9,11,13,17,19**. (Pure CPython walls around here; q=23 OOMs the 13 GB cap;
a compiled port would extend cheaply.)

**2026-07-06 (session 3) — the PARITY-DEFECT STRUCTURE: the two failed routes are ONE
failure, seeded by odd maximal caps at exactly q=9.** Full analysis in
`2026-07-06-qodd-parity-defect-structure.md`. Attacked the counting/parity route. Key facts:
- **The game is EXACTLY parity ("P iff |S| even") for q ≤ 7** (0 defects, verified both naive
  and canonical full-expansion solvers). That is precisely why mirror AND parity both work
  trivially there — below q=9 there is nothing to steer around.
- **The first ODD maximal cap appears at q=9 (size 5)** — the SAME q where `σ_c` first fails
  and one below the antidiagonal's q=11. So all three route-failures share one cause: odd
  maximal caps don't exist below q=9. A maximal cap is a P-position (mover stuck), so odd
  maximal caps are the ONLY seeds of parity-deviation; they back-propagate (even-but-N =
  "can complete an odd maximal cap"; deeper non-maximal odd-but-P) into a defect region.
- **The defect region stays in the endgame: minimum deviating size = 4 for q = 9, 11, 13**
  (root at size 0 safe by margin ≥ 4). It GROWS with q (q=13 has far more non-maximal odd-P
  classes than q=11) but has not reached the root.
- **Sharpened reformulation:** `PG(2,q)=P ⟺ the odd-maximal-cap defects never reach the root
  ⟺ P2 can steer to an even maximal cap`. Two sufficient sub-statements: (1) *all size-2
  positions are P* (⟺ all size-3 N ⟺ every 3-cell partial-perm cap extends to a size-4
  P-position) ⇒ root P immediately; (2) a structural bound on odd maximal caps holding the
  defect region away from the root for all q.
- **This MOTIVATES extending the ladder as a real FALSIFICATION test** (not confirmation):
  watch the **minimum deviating size** — if it ever drops toward 0/1 the root flips
  (`PG(2,q)` becomes N = counterexample); if it stays bounded below, that bound is the proof.
Artifacts: `2026-07-06-grid-maximal-parity.py`, `-maximal-parity-sample.py`, `-invariant-hunt.py`,
`-exception-structure.py`, `-exception-canon.py`.

**2026-07-06 (session 3 cont.) — route (B) DONE: compiled parallel fixed-arena solver;
ladder re-confirmed P through q=19 with GROWING margin; exhaustive wall at q=23.** Full
writeup `2026-07-06-gridcap-rust-ladder.md`. Ported the canonical grid solver to Rust
(`2026-07-06-grid-cap-solver.rs`, modes outcome/defect/par), validated **exactly** vs Python
(deterministic defect counts 77/739/9299; outcomes P every q). Perf: canon was 93.9% of cycles
⇒ replaced sort+Vec+clone with an **order-independent set-hash min over anchors**, precomputed
per-cell (r,c), hoisted the per-anchor translation, subtraction table ⇒ **3.3× faster**
(q=19 36s→11s). Memory: replaced the sharded HashMap (OOM churn) with a **fixed `Box<[u128]>`
open-addressing arena** (Tiger-style: sized once, never grown, 16 B/slot, constant RSS). Live
throughput monitoring on stderr. **Findings:**
- **Outcome P re-confirmed q≤19** (fast, independent code path). **min-dev-size margin GROWS:
  4 (q=9,11,13,17) → 6 (q=19)** — the root stays far from a flip and, if anything, gets safer.
- **Exhaustive WALL at q=23**: the canonical class count grows **~×9 per q-step** (q=17 1.76M →
  q=19 16.7M → q=23 **>946M and not finished**, ~11% of frontier tasks). q≥23 needs a >2³⁰-slot
  (>17 GB) arena and extrapolates past this 26 GB box. This is a resource wall of exhaustive
  enumeration on this box — NOT a fundamental limit (bigger RAM / tighter key / a proof go
  further) — but it means **brute-force falsification stops at q=19**. The ×9 growth is itself
  a reason to prefer the proof route.
- Net: the compute route is exhausted on this box; **the uniform proof (route A below) is now
  the clear priority** — the exponential state-space growth says brute force won't settle it.

**2026-07-06 (session 4) — route (A): the FRAME REDUCTION (collapses the whole game to ONE
position) + a growing ESCAPE MARGIN falsification signal.** Full writeup
`2026-07-06-frame-reduction.md`. Two contributions:
- **★ Frame reduction (proved + exhaustively verified, all q):**
  `PG(2,q)=P ⟺ the projective FRAME (4 points in general position, no 3 collinear) is a
  P-position.` Proof: `PGL(3,q)` is transitive on points/pairs/triangles/**frames**, so sizes
  0..4 are EACH a single game-value orbit; the normal-play recursion then gives the value chain
  `∅(P) → point(N) → pair(P) → triangle(N) → frame(P)`, so `v(∅)=v(frame)`. Size 4 is the floor
  (size 5 splits into orbits). Verified two ways: projective solver (`2026-07-06-frame-orbit-verify.py`,
  sizes 1..4 single orbit + chain, q≤7) and grid solver (`2026-07-06-frame-reduction-verify.py`,
  q≤9). **Unifies even+odd** (both restate as "the frame is P"; even's `τ_v` proof is one such
  proof) and **sharpens the odd target to a single, maximally-symmetric (`S_4`) position.** The
  defect note's "all size-2 grid positions are P" sub-statement is exactly this, now collapsed
  to ONE position (size-2 grid = a single orbit too) and lifted to the coordinate-free frame.
- **Single-involution route re-closed in frame language, incl. the previously-UNTESTABLE
  transpose.** The frame's Klein-4 stabiliser {id, σ_c, τ, σ_c·τ}; σ_c and τ have DEAD fixed
  loci (they land on the burned opening line / frame diagonal). `2026-07-06-frame-mirror-test.py`:
  **τ (transpose) wins only q=3** (problem set = the 2 frame-antidiagonals `r+c=0,2`), **σ_c wins
  q≤7**, **σ_c·τ (centre antidiagonal) wins q≤9, fails q=11** (live fixed line `r+c=1`). τ was
  never testable before — the old scripts build size-2 by P2 replying `φ(x₁)`, which needs
  `φ(x₁)≠x₁`, and τ fixes x₁; the frame is τ-symmetric so τ is legitimate there. All three fail
  at bounded q ⇒ no uniform single involution (consistent with `2026-07-06-qodd-mirror-obstruction.md`).
- **Adaptive re-symmetrisation** (`2026-07-06-adaptive-resym-test.py`, depth-1): the direct form
  (new `φ'` answers the break `x` with its mirror partner `y=φ'(x)`) **fails at q≥11**; the
  relaxed form (any legal `y` landing in *some* symmetric position) always succeeds — so adaptive
  is not trivially dead, but its natural pairing form breaks.
- **★ ESCAPE MARGIN — a quantitative falsification signal + concrete proof target**
  (`2026-07-06-escape-margin.py`). The crux is now: *every legal size-3 grid position has a P
  size-4 child.* Measured the number of P size-4 children (the "escape margin") over ALL size-3
  positions: **minimum = 1 (q=5), 7 (q=7), 13 (q=9), 13 (q=11)** (q=3 vacuous: frame is already
  a size-2 maximal cap). Stays **bounded away from 0** ⇒ crux holds in every computed case; the
  tight q=5 (unique escape) relaxes with q. NOT a linear law — an early `3q−14` fit on q=5,7,9 is
  BROKEN by q=11 (13, not 19); the minimum plateaus at 13 for q=9,11, and the histogram has only
  two escape classes at q=9,11 (both min 13), hinting a `q`-independent "tightest-triangle" floor.
  If the minimum ever hit 0 the root flips (counterexample); it doesn't.
- **★★ TOTAL LEMMA (proven, all q) + a PARITY PROOF for q≤9 + a sharp reduced crux.** Full
  writeup `2026-07-06-escape-count-lemma.md`. **Lemma:** every size-3 grid position has EXACTLY
  `total = (q-3)² − 3(q-4) = q²−9q+21` legal size-4 extensions — *constant* (independent of the
  position) and, for odd q, *odd*. Proof (uses only cap + partial-perm, so all q): `(q-3)²` free-
  free cells minus the 3 pair-lines, each meeting the free-free grid in exactly `q-4` points (its
  4 used-row/col points `{t_i,t_j, L∩row_{r_k}, L∩col_{c_k}}` are distinct by the cap property),
  and pair-lines meet only at vertices. Verified all size-3 positions + every proof internal
  (`|FF|=(q-3)²`, `|L∩FF|=q-4`, pairs-meet-at-verts) for q≤11 (`2026-07-06-total-lemma-verify.py`),
  total=43 constant at q=11 (`2026-07-06-escape-parity.py`). **Consequence:** `escape = total −
  bad`, total odd ⇒ `escape ≡ 1 − bad (mod 2)`, so **escape odd ⟺ bad even**. Computed: **bad is
  even for ALL size-3 positions at q≤9** ⇒ escape odd ≥ 1 ⇒ frame P ⇒ **`PG(2,q)=P` for q≤9 by a
  PARITY PROOF** (no strategy/casework; q=3 vacuous). At q=11 bad is odd on 24200/145200 positions
  (escape=18 even) — parity BREAKS (same odd-maximal-cap threshold as every other route), though
  escape stays ≥13. **Reduced crux (whole odd conjecture in one inequality):** `PG(2,q)=P ⟺
  bad(S₃) < q²−9q+21 ∀S₃` — i.e. the cells covered by **odd maximal caps (complete arcs)** through
  a 3-cap never exhaust its `q²−9q+21` free-free extensions. This is an arc-theoretic bound; the
  parity proof is exactly the "bad-even" (q≤9) regime. **Boundary characterization VALIDATED**
  (`2026-07-06-boundary-char-verify.py`, exhaustive q≤9, 0 mismatches, q=9: 51840=51840): a size-4
  position is `N` ⟺ it **embeds in an odd maximal cap** — so size-4 game value is a static
  geometric property and `bad` is genuinely arc-theoretic (re-check as deeper defects enter q≥13).
  Total lemma + internals confirmed q≤13 (`total(13)=73`).

**2026-07-06 (session 5) — the escape MARGIN is ERRATIC and `bad ≈ total` at q=17: sub-attack 1
(area bound) is DEAD, the falsification test is LIVE.** Full writeup
`2026-07-06-escape-margin-erratic.md`. Added a compiled **`escape` mode** to the Rust grid solver
(per-size-3-class escape = #P size-4 children, `bad = total − escape`, bad-parity split,
min-escape representative; single-threaded, light footprint — box was core-busy with the sumfree
run). Validated **exactly** against an independent raw-bitmask solver
(`2026-07-06-escape-spotcheck.py`, no canon/shared memo) on the min-escape reps: q=11→13/43,
q=13→46/73, **q=17→5/157**. Extended the escape/bad-parity table past the pure-Python q=11 wall:
- **min-escape = `1,7,13,13,46,5,211` (q=5,7,9,11,13,17,19)** — **erratic, NOT growing**; crashes
  to **5 at q=17** then back to the max **211 at q=19**. **At q=17 `bad = 152` of `total = 157`**
  (odd maximal caps cover 97% of a 3-cap's extensions) ⇒ **`bad` is Θ(q²) ≈ total**. This
  **refutes** the escape-count-lemma/frame-reduction claim that "`total` (O(q²)) outgrows `bad`"
  (correction banners added to both notes).
- **Sub-attack 1 (bound `bad = o(q²)` by arc theory) is CLOSED** — no room for an area bound; the
  crux `escape ≥ 1` is a *delicate near-cancellation* of two Θ(q²) quantities. **Sub-attack 2
  (refined parity) weakened**: `bad`-odd fraction 0,0,0,25%,25%,**57%**,0% (q=5..19) — parity
  covers a minority by q=17.
- **min-dev-size ↔ escape link (correction):** root=P ⟺ min-escape ≥ 1 ⟺ min-dev-size ≥ 4, and
  min-dev-size ∈ {0}∪{4,5,…} (jumps 0→≥4). So the gridcap-ladder note's "margin grows 4→6 ⇒ root
  safer" is a misreading — 4-vs-6 is endgame defect depth, not a root buffer; the *accurate* fine
  safety measure is the erratic min-escape. **Cross-check CONFIRMED:** min-dev-size=6 at q=19 ⇒
  every size-4 P ⇒ min-escape = total = 211 (bad=0, pure parity at low sizes) — the escape run
  gives exactly `211:27`, so two independent code paths agree. The margin swings 5 (q=17) → 211
  (q=19), proving it is arc-driven and unpredictable.
- **Boundary characterization "size-4 N ⟺ embeds in odd maximal cap" TESTED (`boundary` mode) —
  FAILS at q=11,13,17** (holds q≤9 only): only `N ⟹ embeds` survives; embedding becomes
  near-universal (all 192 classes embed at q=13, all 735 at q=17) so `bad` is NOT arc-computable.
  Closes the cheap-falsification-shortcut idea.
- **Net:** the counting/area/arc routes of (A) are dead; the conjecture is protected only by
  exhaustive checks (walled at q=19), not by any margin. **Live routes:** (i) a direct
  adaptive-strategy proof; (ii) a finer-than-mod-2 invariant surviving `bad` odd. Artifacts:
  `escape` + `boundary` modes in `2026-07-06-grid-cap-solver.rs`, `-escape-spotcheck.py`,
  `-escape-q17/q19.log`, `-boundary-q17.log`, `-escape-margin-erratic.md`.

**2026-07-07 (session 6) — LEAN: total lemma PROVEN, parity route FORMALIZED, frame reduction
SKELETONIZED.** All in `lean/` (full `lake build` green; axioms = the standard three, no `sorry`):
- **★ `ProjectiveCap/ExtensionCount.lean` — `Stable.SizeThreeExtensionCountStatement` is now a
  theorem** (`sizeThreeExtensionCount` / `card_legalGridExtensions_of_card_three`): every size-3
  grid cap has exactly `q²−9q+21` legal extensions, over every finite field (vacuous below the
  first size-3 cap, so no `q ≥ 4` side condition needed). Proof as in the prose note: legal =
  free-free minus the 3 pair-lines; each pair-line is row-parametrized (`lineRowPoint`) and meets
  the free-free grid in exactly `q−4` cells (the 4 excluded rows `{a₁,b₁,c₁,d}` distinct by the
  cap property); traces pairwise disjoint via a Cramer-identity two-secants lemma
  (`collinear_of_collinear_pair`, `linear_combination`); ℤ-cast assembly. En route: decidability
  instances for `Collinear`/`PairLineBlockedBy` (kills classical-instance mismatch),
  determinant-symmetry lemmas, `legalGridExtensions_eq_filter_freeFree`.
- **`ProjectiveCap/EscapeParity.lean` — the parity route formalized**: for odd `q` the legal count
  is odd (`odd_card_gridGame_legalExtensions`), so `Even bad ⇒ escape ≥ 1`
  (`escapeExtensions_nonempty_of_even_bad`), so `OddEscapeGameStatement` follows from the
  all-positions bad-parity hypothesis (`oddEscapeGameStatement_of_forall_even_bad`). This is the
  exact formal shape of the prose parity proof for `q ≤ 9`; the hypothesis is known TRUE for
  `q ≤ 9`, FALSE from `q = 11` (bad-odd defects), so the remaining gap is per-`q` discharge
  (small-field computation) or the open general-`q` argument.
- **`CapGame/BuildGame.lean` — kernel extended with the frame-chain machinery**: `move_map` /
  `win_map` / `isP_map` (game-value transport along any validity-preserving board permutation —
  previously missing, needed by every symmetry argument), `SizeValueConstant`,
  `sizeValueConstant_of_transitive`, `win_iff_not_win_succ` (value alternation across a
  single-valued size layer), and `isP_empty_iff_isP_of_frame_chain` (sizes 1–4 single-valued +
  extendability ≤ 3 ⇒ `IsP ∅ ↔ IsP F` for any valid size-4 `F`).
- **`ProjectiveCap/Projective.lean` — `initialPStatement_iff_isP_frame`**: the frame reduction for
  the actual projective cap game, with the geometric obligations as named hypotheses
  (`CapTransitiveStatement k`, `k = 1..4`, + extendability). Formalizing those from mathlib's
  projectivization (PGL transitivity on points/pairs/triangles/frames) is the next Lean work
  package; the game-theoretic half is done.

**2026-07-07 (session 6 cont.) — ★ the GEOMETRY HALF of the frame reduction is FORMALIZED: the
Lean frame reduction is now UNCONDITIONAL for rank-3 spaces.**
`ProjectiveCap/PlaneTransitivity.lean` (built on mathlib's `Projectivization`
Basic/Independence/Subspace API):
- **Collinearity bridge**: `collinear_iff_dependent` / `not_collinear_iff_independent` — our
  set-based `IsCollinear` triple predicate ⟺ mathlib `Dependent`/`Independent` of the point
  triple (forward via `finrank` monotonicity into the witness subspace; backward constructing
  the spanned line, two-secants handled by `linearIndependent_finSnoc`).
- **`mapEquiv`**: the point permutation induced by `g : V ≃ₗ[K] V`, with cap transport
  (`cap_map_mapEquiv`) — the `hValid` hypothesis of `CapTransitiveStatement` — plus point-image
  helpers (`mapEquiv_mk_eq_mk`, `mapEquiv_eq_of_rep_eq`).
- **Transitivity `k = 1..4`** (`capTransitiveStatement_one/two/three/four`, `finrank K V = 3`):
  k ≤ 3 by extending independent rep tuples to bases (`exists_cons_li`) and `Basis.equiv`;
  k = 4 via the classical **frame normal form** (`quad_normal_form`: scaled reps of a 4-cap's
  first three points form a basis whose coordinate sum represents the fourth; all three
  coordinates nonzero by the cap property).
- **Extendability** (`cap_extendable`): caps of size ≤ 3 always extend — sizes 0/1/2 by basis
  extension, size 3 by the coordinate-sum frame completion (`li_with_sum12/13/23`,
  `cap_quad_of_independent`).
- **`exists_frame`** + the headline **`initialPStatement_iff_isP_frame_of_finrank`**: for ANY
  rank-3 `V` (any field), `InitialPStatement ↔ IsP (frame)` with no remaining hypotheses beyond
  `finrank K V = 3`. Axioms: the standard three, no `sorry`. Full `lake build` green.

**2026-07-07 (session 7) — ★ route (A)-1/2 EXECUTED TO FULL DEPTH: the adaptive
symmetric-strategy route is DEAD for q ≥ 11, in every form.** Full writeup
[`2026-07-07-resym-symmetric-family-dead.md`](../2026-07-07-resym-symmetric-family-dead.md).
Added a `resym` mode to the Rust grid solver: solve the game with P2 RESTRICTED to replies
landing in a symmetric family F — the exhaustive AND-OR search for a play-closed symmetric
subfamily containing the frame (`SAFE(frame)=YES` ⟺ such a subfamily exists ⟺ an adaptive
symmetric P2 strategy exists). Families tested, each exhaustively enumerated (semilinear
monomial maps incl. Frobenius twists): **v0** = symmetric under some involution, **v3** =
symmetric under ANY nontrivial automorphism (the maximal symmetry family; 24k–148k maps),
**v4** = v3 ∧ true P-position. **Result: SAFE for q ≤ 9 (all variants, incl. even-q positive
controls via the translation mirror); NO for q = 11, 13, 17** (v0+v3+v4 at 11; v0+v4 at 13,
v3 follows since SAFE_v3=SAFE_v4; v0+v3 at 17). The session-4 depth-1 "relaxed adaptive always
succeeds" was a mirage — one re-symmetrization is always possible, staying symmetric is not.
**Concrete obstruction witness (q=11, verified independently by the exact solver via the new
`checkpos`/`breaks` modes): S = {(0,0),(1,1),(2,3),(3,2)} (transpose-symmetric, true P), break
x=(4,9): 5 winning replies exist, ALL 7 legal replies have trivial stabilizer** — P2 is forced
out of the symmetric world by move 6. The reachable symmetric space is tiny (tens of states/q),
so these are full exhaustions. The q≤9 / q≥11 threshold matches every other route's wall.
**Consequence: no invariant of the form "position has symmetry X" can carry the uniform proof;
route (B) finer counting / potential-function is now the main bet, (C) per-q certificates
unaffected.** Artifacts: `resym`(v0..v4)/`breaks`/`checkpos` modes in
`2026-07-06-grid-cap-solver.rs`.

**2026-07-07 (session 8) — ★ route (B) first strike: the CONIC LOCALIZATION — the escape crux
has an on-conic witness in ALL computed data.** Full writeup
[`2026-07-07-conic-localization-onconic-escape.md`](../2026-07-07-conic-localization-onconic-escape.md).
Added a `feat` mode to the Rust grid solver (per size-3 class × legal extension: game value ×
conic position on/external/internal). Two results:
- **Conic localization lemma (proven, all q):** the projective 5-arc (2 burned directions +
  S₃) lies on a unique conic — affinely the Möbius-graph hyperbola `(r−ρ)(c−A)=B` — and ALL
  `q−4` of its non-S₃ cells are legal extensions (machine-checked every class q≤19); the conic
  is an even maximal grid cap (its center `(ρ,A)` is blocked by every antipodal secant pair).
  Refines the total lemma: `total = (q−4) + off-conic`.
- **(ON), empirical q=5..19:** every size-3 class has `onP ≥ 1` — a P size-4 extension ON its
  conic. Sharper crux than (ESC) (implies it via the frame reduction); the q=17 min-escape=5
  classes have exactly `onP=1` — the surviving witness is on the conic. The kernel is now
  1-dimensional (4th point on the conic parameter line mod the `{0,∞}`-stabilizer).
- **Dead ends closed:** "on-conic ⟹ P" (true q=5,7,9,13,19(!); fails q=11,17); the
  product-point law `t₄ = tᵢtⱼ/tₖ` (= the ψ_u-symmetrizable completions — every conic
  reflection `t↦u/t` IS a grid automorphism, new substrate lemma — but existence fails 4/21
  classes at q=17); any quadratic-character law on the conic (q=13 all-P vs q=17 1-of-13 is
  character-incompatible); off-conic escape parity (fails q=13).
- **Route (D) note:** per-S₃ subtree solves (private memo) could push the (ON)/escape table to
  q=23 without the walled global arena — size it AFTER the G(17) nimber run frees the box.

**2026-07-07 (session 8 cont.) — published prior art for the GENUS found: nofil.**
[`2026-07-07-nofil-connection.md`](../2026-07-07-nofil-connection.md): Huggan–Huntemann–Stevens
(JCD 2022, arXiv:2103.13501) play the identical game on Steiner triple systems; deciding nofil
positions on STS is **PSPACE-complete** (Node-Kayles endgame embedding) — import as motivation:
structured-family theorems are the tractable frontier, and `PG(2,q)` sits just past it. Our
exports: the affine theorem = nofil's first infinite determined STS family (`AG(n,3)`, value 0,
cross-checked against their STS(9)); the `PG(m,2)` column (P for m ≤ 4) breaks their v mod 6
nim-parity trend and is a clean open conjecture in their language (smallest open case
`STS(63)` = `F₂⁶` sum-free). Cite in the projective paper.

**2026-07-07 (session 9, Fable F2) — ★ the INTRUSION CALCULUS: (ON) PROVED for q=5,7; the
on-conic subtree uniformized; the hard core isolated.** Full writeup
[`2026-07-07-onconic-intrusion-calculus.md`](../2026-07-07-onconic-intrusion-calculus.md),
verifier `2026-07-07-onconic-intrusion-check.py` (all green, q=7/11 exhaustive, q=13 sample).
Grid game reframed as pure arc-building on `PG(2,q)` from the pre-played `{a,b}` (rows/cols =
secants through a,b; odd maximal grid caps = odd complete arcs). Results: (i) **Lemma I** —
an on-conic S₄'s value depends only on its 6-point parameter subset of `P¹` mod the FULL
`PGL(2,q)` (a,b are not special in the subtree; 5 points pin the conic ⇒ stab(𝒞) ≅ PGL(2));
consistency prediction vs q=17 feat data delegated (Codex C5). (ii) **Lemma III** — one
intruder `x` = the classical projection involution `σ_x` on the conic (ψ_u = centers on line
ab); survivors = σ_x-pairs + tangency singletons exactly; conic-only continuation length
`M = (q+1−2c+τ_x)/2`; legal-intruder constraint `τ_x ≤ 2τ_played + (q+1−2c)` (count form of
the top-gap `m ≤ (q+3)/2`). (iii) **Theorem — (ON) holds for q=5,7 by proof** (no legal
intrusion exists at c=6 ⇒ conic-only parity; first proved instances; q=9 reducible to a ≤15-
point intruder game, not pushed). (iv) **Obstruction statement**: one-intruder parity cannot
decide (ON) (the mover picks τ_x; onN data {11,17} vs {13,19} straddles q mod 4); the open
core is the ≥2-intruder residual whose state = dihedral orbit structure of `⟨σ_x, σ_x'⟩` —
element orders divide `q±1` — the first structural bridge from game value to the arithmetic
of q, and the identified entry point of the observed erraticness. Next options in the note §6:
winning-intrusion census keyed on `(τ_x, τ_played, ord(σσ'))`, a second-intrusion answer
lemma (candidate uniform mechanism), q=9 warm-up certificate.

**Open-math plan written**: [`2026-07-07-projcap-open-math-plan.md`](../2026-07-07-projcap-open-math-plan.md)
— settled-results table, the open kernel (ESC) with its known proof constraints, attack routes
(A adaptive-invariant / B finer counting / C per-q Lean certificates / D falsification / E m≥3)
with concrete next actions, and the Lean work-package queue (WP-1 frame⇄grid bridge, WP-2 q-even
theorem in Lean, WP-3 certificate checker, WP-4 PGL packaging). Recommended next session: math =
route (A) resym experiment; Lean = WP-1 then WP-2.

**Next:** (3'') mirror CLOSED, naive parity CLOSED (odd maximal caps), brute-force falsification
CLOSED at q=19 (memory wall), single-involution re-closed from the frame,
adaptive direct-pairing closed at q≥11. **Escape margin is ERRATIC (session 5): min-escape swings
1→46→5→211 through q=19, `bad ≈ total` at q=17, so the area/counting sub-attacks of (A) are
DEAD.** Live routes, priority order:
- **(A) Prove the reduced crux `bad(S₃) < q²−9q+21`** — still the WHOLE odd theorem (frame
  reduction + total lemma), parity proof settles q≤9. **BUT the two counting sub-attacks are now
  DEAD/weak (session 5):**
  1. ~~**Bound `bad` by arc theory** (`bad = o(q²)`).~~ **CLOSED** — at q=17 `bad = 152` of
     `total = 157`, i.e. `bad` is **Θ(q²) ≈ total**; there is no area room for an `o(q²)` bound.
     (The min-escape triangle's `bad = 0,0,8` at q=5,7,9 looked bounded but was small-q luck; odd
     complete arcs proliferate and cover ~97% of extensions by q=17.)
  2. **Refined parity for the bad-odd defects** — **WEAKENED**: `bad`-odd is now the *majority*
     (12/21 = 57% of size-3 classes at q=17), so parity covers a minority. Still the only counting
     handle if a secondary invariant can be found, but it is not close to sufficient alone.
  **What's actually live for a proof:** the crux `escape ≥ 1` is a *delicate near-cancellation* of
  two Θ(q²) quantities (`escape = total − bad`), so it needs FINE structure, not a size bound:
  ~~(i) a **direct adaptive-strategy** proof~~ **CLOSED (session 7,
  `2026-07-07-resym-symmetric-family-dead.md`): no play-closed symmetric family exists for
  q ≥ 11 — even "symmetric under ANY nontrivial automorphism ∧ true P" fails; P2's winning
  strategy is forced through stabilizer-free positions by size 6.** What survives: (ii) a
  **finer-than-mod-2 invariant / counting or potential-function argument** that survives `bad`
  odd and explains why `escape ≥ 1` persists even when `bad ≈ total` — necessarily asymmetric
  in form.
  **Falsification-shortcut lead — TESTED and CLOSED (session 5, `boundary` mode).** The boundary
  characterization "size-4 N ⟺ embeds in an odd maximal cap" (validated q≤9) **FAILS at q=11,13,17**:
  only `N ⟹ embeds` survives, the converse dies as odd maximal caps proliferate (embed-in-odd-maximal
  vs game-N classes = 80/50 at q=11, **192/61** at q=13 with all 192 embedding, **735/671** at q=17
  with all embedding). So `bad` is **not** arc-computable and there is no cheap way past the q=19
  exhaustive wall; `bad` stays a genuine game quantity.
- **(B) DONE — compiled parallel fixed-arena solver** (`2026-07-06-grid-cap-solver.rs`,
  `2026-07-06-gridcap-rust-ladder.md`): ladder re-confirmed P through q=19, margin grows 4→6,
  exhaustive wall at q=23 (>10⁹ classes, ~×9/step). Reusable tool. Pushing q≥23 needs a
  bigger-RAM box or a much tighter key (marginal) — low ROI vs (A).
- (a) adaptive-involution / (b) counting — subsumed by (A)'s framing. **Sprague–Grundy
  decomposition unpromising in the plane** (every pair collinear ⇒ no independent blocks);
  aim decomposition at the `m ≥ 3` lift.
- (0) import q=2 column beyond PG(4,2) from the F_2^{m+1} sum-free solver.
- (4) canonical solver for PG(5,2)/larger + the `m ≥ 3` decomposition probe.

**2026-07-07 (session 10, Fable) — Lean residual-gap triage + intrusion calculus formalized
(game half).** Reviewed the full `lean/ProjectiveCap` state after Codex's WP-1/WP-2/C2 pass:
q-even is an UNCONDITIONAL theorem (`PlaneOutcome.initialPStatement_of_even_card_finrank` —
even `|K|` + rank 3 ⇒ `InitialPStatement`, no residual hypotheses); q-odd composes to rank-3
outcome from any of four residual hypotheses, of which THREE are false as universal statements
(grid-wide bad-parity: fails q ≥ 11; on-conic bad-parity: fails at q = 11, even-onP classes in
the feat table; ψ-pairing criterion: seed-invariance forces `tᵢ² = tⱼtₖ`, generic seeds have no
such `u`) — only `OnConicEscapeStatement` (= (ON)) is the live universal gap. Landed:
1. **Doc-guards** on all dead-hypothesis routes (`PlaneOutcome`/`ConicLocalization`/
   `EscapeParity` — "per-q use only, do not proof-search"), commit `a13f41d`.
2. **`ProjectiveCap/IntrusionCalculus.lean` (new, sorry-free)** — the session-9 intrusion
   calculus's game-theoretic layer: `freeConic_mem_legalExtensions` (Lemma II: every unplayed
   conic cell legal while play stays on the conic), `legalExtensions_eq_sdiff_of_conicOnlyAbove`,
   **`isP_iff_even_card_sdiff_of_conicOnlyAbove` (the bare-counter theorem: no intrusion above ⇒
   value = parity of unplayed conic cells, strong induction on the deficiency)**,
   `isP_of_card_four_of_conicOnlyAbove` (odd q: on-conic S₄ + no intrusion ⇒ P),
   `onConicEscapeStatement_of_noIntrusionAboveFour` (Theorem IV game half), and the rank-3
   composition `initialPStatement_of_noIntrusionAboveFour_finrank`. The one remaining input is
   `NoIntrusionAboveFourStatement` — Theorem IV's finite-geometry kernel (tangency bound), TRUE
   for q = 5, 7 / FALSE from q = 11 (per-q target, warned in-file). Proving it at GF(5)/GF(7)
   makes q = 5, 7 the first odd planes proven in Lean by mechanism rather than enumeration.
3. **Codex C12 queued** (task-queue note): Rust `cert` mode — per-class witness escape cell +
   P-reply-book emitter + independent `certcheck`, format targeting
   `FiniteBuildGame.PairReplyBook`/`PCert` (route C, phase 1). C3's esc-gate PASS + C8's canon
   validation are the substrate; C5's PGL(2,17) orbit collapse (273 → 10 value-constant buckets)
   is the compression signal for orbit-level books.
Codex queue C1–C10 all reported; C11 correctly NO-GO. C12 delegated to an Opus sub-agent
(Codex out of tokens); z5 killed (datapoint in the sumfree-compute handoff), box freed.
4. **★ THE ORDER-FIVE PLANE, PROVEN IN LEAN BY MECHANISM**
   (`PlaneOutcome.initialPStatement_of_card_eq_five_finrank`, axioms = `[propext,
   Classical.choice, Quot.sound]`, no `native_decide`): `Fintype.card K = 5` + rank 3 ⇒
   `InitialPStatement`. The q = 5 no-intrusion kernel turned out to need NO computation:
   `|S₄| = 4 = q − 1` forces the on-conic S₄ to be the whole affine conic
   (`Finset.eq_of_subset_of_card_le`), which is a MAXIMAL grid cap in odd characteristic
   (`maximalGridCap_hyperbolaCells_of_two_ne_zero`, already proven) — so no intruder is ever
   legal, vacuously (`noIntrusionAboveFourStatement_of_card_eq_five`). Helpers added:
   `two_ne_zero_of_odd_card` (shift `x ↦ x+1` fpf-involution pairing) and
   `conicOnlyAbove_of_forall_legal_mem` (legality is antitone in the position ⇒ the
   no-intrusion obligation collapses to the size-four seed alone — this is the q = 7 kernel
   shrinker). First odd-order projective plane theorem in Lean; PG(2,5) previously known only
   by exhaustive computation.
   ~~**q = 7 status:** parked pending route choice.~~ **USER CHOSE (a); DONE same session.**
5. **★ THE ORDER-SEVEN PLANE, PROVEN — the σ_x secant-involution kernel formalized**
   (`initialPStatement_of_card_eq_seven_finrank`, axioms clean, commit `ae1a346`). The
   synthetic argument, entirely in grid language with no P¹ machinery and NO computation:
   for a putative legal off-conic intruder `x = (ρ+u, A+v)` of an on-conic S₄, the secant
   map `σ(t) = B(t−u)/(tv−B)` (the parameter of the second intersection of line x·p_t with
   the conic) satisfies — all by row/col/cap legality + off-conic `uv ≠ B`:
   σ(t) ≠ 0 (row), σ(t) ∉ T∖{t} (secants), σ(t) ≠ B/v (off-conic makes this algebraic),
   σ injective (det = B(uv−B) ≠ 0), denominators tv−B ≠ 0 (col). So non-fixed played params
   inject into K*∖(T∪{B/v}) — at q=7 that has ONE element (v≠0) ⇒ ≥3 of the 4 played params
   are fixed points of σ; but fixed points satisfy vt²−2Bt+Bu=0 and 3 distinct roots force
   v = 0 (pair-subtraction), contradiction; v=0 case: σ affine with the unique fixed point
   u/2 vs ≥2 forced — needs 2B ≠ 0 (odd card). Lemma names:
   `collinear_hyperbolaParamPoint_of_secant` (the secant criterion),
   `offConic_not_legal_of_card_eq_seven` (the kernel),
   `noIntrusionAboveFourStatement_of_card_eq_seven`. The σ_x fixed-point/injectivity
   micro-lemmas are the seed vocabulary for the general intrusion calculus (Lemma III) —
   the q ≥ 9 analysis reuses them with |K*∖(T∪{B/v})| = q−6 free landings.
   **Both computed-only odd planes PG(2,5) and PG(2,7) are now Lean theorems by mechanism;
   next odd-plane formal targets need the multi-intruder theory (q=9 warm-up: intruders
   confined to pairwise tangent-intersections, then M = 0 — note §3) or route-C
   certificates (q = 11..19).**
6. **★ THE TOP-GAP THEOREM — the kernel generalized to ALL odd q** (commit `20b5411`,
   axioms clean): the q=7 secant argument run with symbolic cardinality is
   `offConic_not_legal_of_add_one_le_two_mul_card` — once an on-conic position holds more
   than half the conic (`q + 1 ≤ 2·|S|`), NO off-conic cell is ever legal (Lemma III(4) in
   full generality; the only extra ingredients were `|S| ≤ q−1` and `|S|+1 ≤ q−1` fed to the
   pigeonhole). Corollaries: `conicOnlyAbove_of_add_one_le_two_mul_card` (supersets keep the
   bound) and **`isP_iff_even_card_sdiff_of_add_one_le_two_mul_card` — the FREE-ENDGAME
   theorem: past half-conic, the game value is exactly the parity of the unplayed conic
   cells, for every odd plane**. The q=7 kernel is now a one-line corollary (`8 ≤ 2·4`).
   This is the first general-q piece of the intrusion calculus in Lean — the q=9 design and
   the multi-intruder theory sit on it (intrusions only exist in the window
   `4 ≤ |S| < (q+1)/2`).
7. **C12 DELIVERED (Opus delegate) — the full certificate ladder q = 5..19, certcheck PASS
   at every q** (`2026-07-07-codex-cert-emitter-report.md`): `cert`/`certcheck` modes added
   (additive; existing modes byte-identical), per-class witness + P-reply-book DAGs matching
   the `FiniteBuildGame.PairReplyBook`/`PCert` shape via `isP_of_replyStrategy`, dedup keeps
   the largest book ~29.6K nodes (q=19; 85 MB file, 565s wall). **Every witness at every q
   is ON-conic** — cert-grade corroboration of (ON) including the q=17 min-escape classes.
   Checker adversarially validated (tampered certs FAIL correctly). WP-3 (Lean checker,
   Codex C14) is now unblocked. Cert files = REGEN ON DEMAND (user decision): `notes/certs/`
   gitignored, the `cert`/`certcheck` solver modes committed (`14c73cf`) so regeneration is
   durable (~10 min for the whole ladder).
8. **C13 REPORTED (Codex) — the q=9 intrusion mechanism is maximally rigid**
   (`2026-07-07-codex-q9-intrusion-probe.md`): exhaustive over all 70 on-conic S₄'s of a
   normalized conic (2 PGL(2,9) classes). Census = ONLY `(τ_x, τ_played) = (2,2)` intruders
   (Lemma III(4) sharp), every intrusion kills the whole remaining conic, and **every
   intruded child has exactly ONE legal reply, which is terminal** — P2's answer is a unique
   forced second intrusion ending the game. Conic first moves are answered on the conic
   (parity). So every on-conic S₄ at q=9 is P with residual depth 1 — the q=9 Lean proof
   shape is now pinned: (a) the free-endgame theorem for conic moves, (b) the
   `(2,2)`-tangency algebra + unique-terminal-reply lemma for intruders.

## Handoff Summary

The affine cap game is solved because affine space has exactly the mirrors needed. The projective
cap game is the next high-value test: same cap relation, less translation symmetry, harder fixed
loci. Start with `PG(2,q)` and `PG(m,2)`. Either find a projective move-then-mirror that burns the
fixed locus, or extract the obstruction/counterexample. The first proof target should be `PG(2,q)`;
the first algebraic target should be `PG(m,2)` after opening pair `{a,b}` removes the 2D subspace
`<a,b>`.
