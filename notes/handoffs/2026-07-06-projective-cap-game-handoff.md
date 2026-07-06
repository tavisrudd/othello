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
state collapse ~3000× (q=13: 3672 full-group states vs ~3×10⁸ naive). New: **PG(2,13)=P**.
q-odd ladder now **P for q=3,5,7,9,11,13**. (Pure CPython walls at q≥17, ~30+ min/step; a
compiled solver would extend cheaply — a background canon1 run for q=17,19,23 was launched.)

**Next:** (3'') the mirror route is CLOSED — pursue a NON-mirror mechanism. For the PLANE:
(a) **adaptive-involution** strategy — re-symmetrize after each problem-set move (obstruction:
re-symmetrizing an asymmetric S under a new monomial involution is generally impossible).
(b) **non-constructive parity/counting** argument (no explicit pairing). NOTE: **Sprague–Grundy
decomposition is unpromising in the plane** — every pair of points lies on a line, so the
available set never partitions into independent blocks; decomposition is better aimed at the
`m ≥ 3` lift (points can be genuinely far apart). Also: (c) **DONE PG(2,13)=P** via the new
canonical grid solver; to push further (q=17,19,23,25,27,…) **port the grid-canon solver to
Rust/compiled** — pure CPython walls at q≥17 (canon cost × state count). (0) import q=2 column
beyond PG(4,2) from the F_2^{m+1} sum-free solver. (4) canonical solver for PG(5,2)/larger +
the `m ≥ 3` decomposition probe.

## Handoff Summary

The affine cap game is solved because affine space has exactly the mirrors needed. The projective
cap game is the next high-value test: same cap relation, less translation symmetry, harder fixed
loci. Start with `PG(2,q)` and `PG(m,2)`. Either find a projective move-then-mirror that burns the
fixed locus, or extract the obstruction/counterexample. The first proof target should be `PG(2,q)`;
the first algebraic target should be `PG(m,2)` after opening pair `{a,b}` removes the 2D subspace
`<a,b>`.
