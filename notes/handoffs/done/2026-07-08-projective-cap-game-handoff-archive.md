# Handoff: Projective Cap Achievement Game

Date: 2026-07-06.

## Status table — PG(2,q) value + proof state

**KEEP THIS TABLE UP TO DATE** — update it in the same commit as any session block / review
that changes a cell (last updated 2026-07-08, q13 certificate assembly).

| q                | Value | Computational evidence                                        | Lean proof status                                                                                     | Remaining gap                                                    |
|------------------|-------|---------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| even (2, 4, 8, …)| **P** | not needed (verified q=4,8 anyway)                            | **★ UNCONDITIONAL, all even q** — `initialPStatement_of_even_card_finrank` / char-2 translation mirror | none — closed                                                     |
| 3                | P     | exhaustive solve                                              | none                                                                                                     | unproven; likely trivial (tiny board), just never queued          |
| 5                | **P** | exhaustive solve                                              | **★ PROVEN by mechanism** — `initialPStatement_of_card_eq_five_finrank`, clean axioms                  | none — closed                                                     |
| 7                | **P** | exhaustive solve                                              | **★ PROVEN by mechanism** — `initialPStatement_of_card_eq_seven_finrank`                               | none — closed                                                     |
| 9                | P     | exhaustive solve (~1s; non-prime, char 3)                     | none                                                                                                     | open; noted reducible to a ≤15-point warm-up certificate          |
| 11               | **P** | solver + esc campaign                                         | **★ PROVEN by certificate assembly** — `CertData/Q11Assembly.initialPStatement_finrank`, clean axioms | none — closed                                                     |
| 13               | **P** | solver (all on-conic buckets P)                               | **★ PROVEN by certificate assembly** — `CertData/Q13Assembly.initialPStatement_finrank`, clean axioms | none — closed                                                     |
| 17               | P     | esc campaign (gate discharged, C3); S4 buckets mixed 5P/5N    | none                                                                                                     | cert book queued (C30, route-C phase 5); mixed buckets make it the hard *mechanism* column |
| 19               | P     | esc campaign                                                  | none                                                                                                     | cert book queued (C30)                                            |
| 23               | **?** | not computed (C21: esc class 0 aborted at the 200M-memo cap, >36 min — campaign blocked; S₄-rooted bucket census = C29) | none                                                                                                     | the live falsification watch — any esc class at 0 kills the conjecture |
| all odd q        | conj. P | no counterexample through q=19                              | frame reduction + odd-escape composition are unconditional rank-3 theorems; the per-q escape input is what's missing | a uniform mechanism — post-C20 that means strategy-level: second-intrusion lemma in defect form, plus the untried composite-mirror plane variant (C32 v2 step 1, design note 2026-07-08) |

Scoreboard reading: **closed** — all even q, plus odd q=5, 7, 11, 13. **Certificate-route feasible
but ungated** — q=9 and q=3 (small; q=3 optional in C30). **Compute-only** — q=17, 19
(route-C books queued, C30; use the q=13 split layout as template). **Frontier** — q=23 (esc
campaign blocked per C21; inverted bucket census + the q≡2-mod-3 mixed-column law = C29), the
uniform odd-q mechanism (post-C20: strategies, not snapshot invariants; zone-steering ceiling
= C31), and — off this planes table — the even dimensions `PG(2m,q)`, m ≥ 2, odd q: the only
other open boards, now probed by the composite-mirror stuck-free harness (C32).

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

The affine proof does **not** transfer directly. Projective spaces have no translations, board
parity varies, and the affine odd-`q` self-blocking midpoint trick has no obvious projective
replacement. However, one large projective subfamily is now closed: for odd `q`, every
odd-dimensional projective space `PG(2m−1,q)` has a fixed-point-free nonsplit/elliptic involution,
and the ordinary mirror strategy proves it is P (R0 below).

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

### R0. Structural fact — fixed-point-free projective involutions exist exactly in the nonsplit odd case

**Correction (2026-07-08):** the earlier "no projective fpf involution" statement was false.
In odd characteristic, a projective involution can be:

- **split:** represented after scaling by `A² = I`, hence with `±1` eigenspaces and fixed
  projective subspaces;
- **nonsplit / elliptic:** represented by `A² = d I` for a nonsquare `d ∈ F_q^*`. Then `A` has no
  `F_q`-eigenvector, so it is fixed-point-free on projective points. This requires the vector
  dimension to be even.

Consequently, for every odd `q` and every `m ≥ 1`, `PG(2m−1,q)` is **P** by a whole-board mirror.
Choose a nonsquare `d` and decompose the `2m`-dimensional vector space into `m` planes with basis
`e_i,f_i`; define `A e_i = f_i`, `A f_i = d e_i`. Then `A² = dI`, so the induced collineation
`σ([v]) = [Av]` is an involution in `PGL` and has no fixed point. Since `σ` is a collineation, it
preserves caps. If a cap `S` is `σ`-invariant and P1 legally plays `x`, then `σx ∉ S∪{x}`; adding
`σx` is legal. Otherwise a line through `σx` and two old points maps under `σ⁻¹` to a line through
`x` and two old points, contradicting legality of `x`; and a line through `x,σx,z` with `z∈S`
would, by `σ`-invariance, also contain `σz∈S`, so `x` was already blocked by the old pair
`{z,σz}`. Thus P2 mirrors forever and P1 is the first player with no move.

Lean status (2026-07-08): the reusable mirror kernel is now checked in
[`../../lean/CapGame/Mirror.lean`](../../lean/CapGame/Mirror.lean) and
[`../../lean/ProjectiveCap/Mirror.lean`](../../lean/ProjectiveCap/Mirror.lean).  The key wrappers
are `Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` and
`Projective.initialPStatement_of_linearEquiv_sq_scalar_nonsquare`.  The coordinate elliptic theorem
is checked in
[`../../lean/ProjectiveCap/EllipticMirror.lean`](../../lean/ProjectiveCap/EllipticMirror.lean):
`Projective.initialPStatement_ellipticBlock_of_odd_card` proves the theorem in the standard model
`V = ι -> K × K` from `Odd (Fintype.card K)`, using `FiniteField.exists_nonsquare`.
`Projective.initialPStatement_of_odd_card_finrank_eq_two_mul` transports this to any finite-rank
model with `Module.finrank K V = 2 * n` and `0 < n`, which is the checked Lean form of
`PG(2n-1,q)`.

Novelty guard: the ingredients (pairing strategies and elliptic projective involutions) are
classical, but the literature pass recorded in
[`../2026-07-07-nofil-connection.md`](../2026-07-07-nofil-connection.md) and the C26 audit
[`../2026-07-08-codex-projective-nofil-novelty-audit.md`](../2026-07-08-codex-projective-nofil-novelty-audit.md)
found no indexed prior occurrence of this theorem for Nofil / impartial cap avoidance on
projective spaces. Public wording should claim a new application/theorem in this game, not a new
mirror method.

Reusable mirror lemma to formalize: the correct residual version is stronger than "legal moves are
`σ`-invariant." For a `σ`-invariant cap `S`, P2 may mirror a legal move `x` by `σx` only if the
two-move extension `S ∪ {x, σx}` is still a cap. Equivalently, beyond old-old-pair legality, no
selected point of `S` may lie on the mirror chord `xσx`. The weak condition "`σx` is legal from
`S` and `σ` has no fixed legal point" misses exactly this chord obstruction.

In even characteristic, projective involutions are unipotent (`1+N`, `N²=0`) with nonempty fixed
space, so there is no analogous whole-board projective involution mirror. The hard residual
odd-plane work remains `PG(2,q)` for odd `q`, whose vector dimension is `3` and admits no nonsplit
elliptic involution.

### R1. Parity, stated once

`|PG(m,q)| = 1 + q + ... + q^m` is **even iff (q odd and m odd)**, odd otherwise. In particular
**every `PG(2,q)` is odd** (`q^2+q+1 = q(q+1)+1`), so the plane always burns a move regardless of q's
parity. The even-board odd-`q` cases `PG(2m−1,q)` are now exactly the elliptic-involution mirror
family of R0.

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

Mirror-lemma guard (2026-07-08): "the fixed locus is dead" is not by itself enough. Selected fixed
points, burned directions, or other problem-set points can still sit on mirror chords `xσ(x)` and
make the reply illegal. A residual/fixed-locus complement theorem is valid only after checking the
pair-extension condition `S ∪ {x,σx}` is a cap for every legal `x`. The `σ_c` failure above is the
minimal example: the center can be dead, but the two burned-direction mirror chords still hit the
selected opening directions.

Adopted salvage from the fixed-locus idea: use mirrors as **terminal certificates and diagnostics**.
For a candidate involution `σ`, define `MirrorStepGood(S,σ)` by the pair-extension condition for
one position and `MirrorClosed(S,σ)` by requiring that condition for every mirror-pair follower.
Define `Obs_σ(S)` as the legal moves whose mirror reply fails because the mirror chord hits
selected/problem structure. `Obs_σ(T)=∅` for every mirror follower `T` gives a P certificate;
small/nonempty `Obs_σ(S)` is a useful defect skeleton, not a proof. This should feed certificate
compression and free-endgame lemmas, while the uniform odd-plane proof remains on the
conic/Node-Kayles defect lane.

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
- **q=2 column is now a Lean theorem, not a compute import.** `PG(m,2)` cap game is the
  `F_2^{m+1}` sum-free/nofil game on nonzero vectors. The right proof is the existing sum-free
  spare-order-two translation mirror, not a linear projective involution: after P1 plays `a`,
  choose `b ≠ a`, set `c = a+b`; the third point `c` on the line `{a,b,c}` is self-blocked, and
  translation by `c` pairs the remaining live vectors. In Lean this should factor through
  `Sumfree.Game.initial_isP_of_at_least_two_nonzero_orderTwo` /
  `initial_isP_of_rank_count_P_cases` plus the binary projective bridge
  `PG(m,2) ≃ F_2^{m+1} \ {0}`. Target statement:
  `Projective.InitialPStatement (K := ZMod 2) (V := V)` from `2 ≤ Module.finrank (ZMod 2) V`
  (`PG(n,2)` for `n ≥ 1`). Rank `1`/`PG(0,2)` is correctly excluded: it has one point and is N.
  **Lean status (2026-07-08): DONE** in
  [`../../lean/ProjectiveCap/Binary.lean`](../../lean/ProjectiveCap/Binary.lean), with
  `Projective.initialPStatement_binary_of_finrank_ge_two` and
  `Projective.initialPStatement_binary_of_projectiveDim_ge_one`.  The proof bridge uses
  `binaryPointEquivNonzero`, `binary_nonzeroValid_iff_cap`, and
  `Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`.
- Literature guard: Clark--Mancini--Van Hook's accessible abstract is about partizan misere
  tic-tac-toe / avoidance on projective binary Steiner triple systems, where players own colored
  points and the first monochromatic block loses. That is not our impartial shared nofil game.
  Verify the full paper before citing, but do not treat it as covering the theorem above. More
  broadly, current search supports novelty only in the conservative sense: the fixed-point-free
  elliptic involution proof appears new for Nofil / impartial cap avoidance on projective spaces,
  while the mirror pattern and projective involutions themselves are standard.

### R6. Reprioritized sequence

0. ~~Formalize `PG(n,2)` for every `n ≥ 1` via the binary projective-to-sum-free bridge and the
   existing spare-order-two translation mirror.~~ **DONE 2026-07-08**; theorem names above.
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

4. `2026-07-08-projective-mirror-proof-kernels.md`
   - Semi-formal theorem/proof kernels for the corrected pair-extension mirror lemma, the
     fixed-point-free projective collineation lemma, the odd-dimensional elliptic involution theorem,
     the binary projective theorem, and the central-inversion endgame condition.
   - Read this before formalizing C25/C27 or before using "fixed locus dead" as a mirror certificate.

5. `2026-07-04-proj-cap.py`
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
9. **THE ORDER-NINE REDUCTION LANDED IN LEAN** (commit `218b1ac`, axioms clean):
   `initialPStatement_of_intruderTerminalReply_finrank` — PG(2,9) = P **conditional on
   exactly one isolated kernel**, `IntruderTerminalReplyStatement` (every legal intruder
   above an on-conic S₄ has a legal reply ending the game — C13's exhaustively verified
   fact). All game theory is discharged: conic children are size 5 and clear the top gap
   EXACTLY (`2·5 = 10 = q+1`) landing on odd remainder ⇒ N via the free-endgame theorem;
   intruder children lose to the kernel's terminal reply
   (`isP_of_card_four_of_intruderTerminalReply` → `onConicEscapeStatement_of_...`).
   Kernel discharge routes: the σ_x tangency algebra (both roots of `vt²−2Bt+Bu = 0`
   played + the explicit `y`), or the C14 certificate checker (the q=9 cert is 33 nodes).
10. **C14 REVIEWED — sound scaffold; C17 queued with the constructive bridge design.**
   C14 (`lean/ProjectiveCap/Certificate.lean` + `ReplyBookDAG` in `CapGame/BuildGame.lean`,
   builds clean, no sorries) proves the full semantic chain: `ReplyBookDAG.ValidFor →
   isP_root` (via `isP_of_replyStrategy`), `GridClassCert.Valid → escape at S₃`, and the
   assembled `GridOddEscapeBookCertificate → Almost.OddEscapeGameStatement (ZMod p)`. Its
   one open gap is the `represents` selector (class rep → every position). **Fable design
   (C17): anchor normalization kills the gap constructively** — every size-3 cap's first two
   cells anchor to `{(0,0),(1,1)}` by an explicit translation+axis-scaling grid symmetry
   (partial-permutation guarantees the scalings are nonzero), so a book family indexed by
   the anchored THIRD cell (≈(q−2)(q−3) classes, ~70 at q=11) covers all positions by
   construction; `gridSymmetry_isP_image` (already proven) transports the escape back. No
   orbit-coverage enumeration ever enters Lean. C17 = anchored emitter + Lean-data generator
   prototype (q=5/7 elaboration-cost gate, kernel `decide` only) + transport lemma scaffold.
   Elaboration cost of per-obligation `decide` over `ZMod q` is the identified risk — the
   q=5/7 prototype is the go/no-go datum for unconditional PG(2,11) in Lean.
11. **C15 REPORTED — Lemma I survives every prime odd q; the moduli collapse is large and
   value-pure.** (`2026-07-07-codex-pgl2-orbit-census-q11-19.md`): raw on-conic children →
   full-PGL(2,q) orbit buckets = 56→4 (q=11), 108→5 (q=13), 273→10 (q=17, C5), 405→13
   (q=19); **zero mixed-value buckets anywhere**. Uniformization holds on all tested data;
   32 labeled buckets total now exist across the four odd q — exactly the C18 training
   table. C18's gate is OPEN (fit {11,13} / test {17,19}; order-theoretic dictionary).
   N-valued buckets exist only at q = 11 and 17 — whatever the cross-q law is, it must
   flip on those two columns.
12. **C17 REPORTED (commit `dce7aed`) — anchored family works end-to-end natively; the Lean
   data route STOPPED exactly at the designed gate.** Anchored emitter + certcheck PASS for
   q = 5/7/11/13 (6/20/72/110 classes, every witness on-conic, canonical mode regression
   clean); `GridCap`/`AffineCap` Lean decidability landed, plus a `validFor_of_finiteRows`
   bridge. The q=5 `by decide` prototype FAILED in elaborator instance synthesis
   (maxRecDepth on the monolithic ∀∃ closure Decidable — NOT kernel arithmetic, NOT the
   book data). Codex's proposed fix = the reflection route; approved and queued as **C19**:
   computable Bool checker over list data + soundness reflection into the C14 layer, per-class
   proofs become `by decide` on `checker = true` (single Bool instance, kernel evaluation,
   axiom profile unchanged) + the anchor-transport lemmas. Assembly payoff when C19 lands:
   `OddEscapeGameStatement (ZMod 11)` ⇒ **unconditional PG(2,11)**.
13. **C18 REVIEWED — NULL LAW, and the null is trustworthy + informative.** Report
   (`2026-07-07-codex-ml-moduli-attribution.md`) checks out: bucket table = C15's census
   exactly (4/5/10/13 = 32 buckets; q=17 splits 5 N / 5 P; q=11 1 N / 3 P; q=13, q=19 all-P),
   baselines arithmetically consistent (forward majority 8/9 train, 18/23 test), the mandated
   fit-{11,13}/test-{17,19} protocol was honored, pure-stdlib + sklearn agree, and no candidate
   beats the all-P majority held-out. **What died:** every shallow law over STATIC features of
   the 6-subset — configuration, q-arithmetic, cross-ratio, quadratic-character, AND the §6
   order-theoretic features (ord of products of involutions fixing 2-subsets of the six played
   points). **What did NOT die:** the intrusion-residual reading of session-9 §6. C18's ord
   features are involutions anchored on the *played* points; the calculus says the law lives in
   the census of *legal intruders* `x` (τ_x, τ_played, M-parity) and the second-intruder orbit
   structure `ord(σ_x σ_{x'})` — a game-labeled census C18 never computed. Strongest attribution
   (involution product orders) points the same way. Follow-ups queued: **C20** = winning-intrusion
   census at q = 11/13/17 (attack option (i) of the intrusion calculus, = C18's "richer structural
   features" made precise); **C21** = the q=23 single-class esc sizing probe C18's phase 2 skipped
   (esc mode's q=17/19 gate is DISCHARGED per C3, and the box is now free — queens G(17) done,
   sum-free z5 terminated). Fable lane pivots to attack option (ii): the second-intrusion answer
   lemma.
14. **★ SESSION 11 (Fable, 2026-07-08) — THE CONIC RESIDUAL IS NODE-KAYLES; the cycle bulk
   is Grundy-DEAD.** Full writeup [`2026-07-08-nk-involution-residual.md`](../2026-07-08-nk-involution-residual.md),
   verifier `2026-07-08-nk-involution-check.py` (ALL OK, q=11 exhaustive + q=13 sampled).
   (a) **Kill-set law** (Lemma V): playing a conic cell kills exactly its σ_x-images, one per
   intruder ⇒ conic-restricted play = Node-Kayles on a static union of |X| matchings — the
   cap-game residual joins the project's Node-Kayles program. (b) **Spectrum law** (Lemma VI):
   two-intruder components on P¹ = free-orbit cycles C_{2d}, d = ord(σ_xσ_{x'}) ∈
   divisors(q±1) ∪ {p}, + the xx'-secant K₂ + tangency-ended paths. (c) **★ Cycle deadness**
   (Cor. VII): G(C_even) = 0 ALWAYS (Dawson zeros are even; DP-verified to 400) ⇒ the Θ(q)
   cycle bulk cancels exactly and the restricted value = Dawson path-XOR of the O(1)-per-
   intruder DEFECT SKELETON (tangency paths, secant pair, kill-scars) — a mechanism-level
   candidate for the observed erratic near-cancellation, and the reason static 6-subset
   feature dictionaries (C18) had to fail. Grundy equality machine-checked exactly (NK3).
   (d) **q=11 full-game census**: N-valued on-conic S₄ win ONLY by intruding (300/300);
   self-polar-answer (H1) and conic-answer (H2) defense mechanisms both REFUTED — the
   defense is inherently multi-intruder. C20 amended: defect-spectrum + restricted-Grundy
   features, "defect-XOR decides?" is the lead hypothesis. **ADDENDUM (same session): the
   q=11 Fermi spot-test landed two laws** — necessity `P ⇒ defXOR = 0 ∧ zone even`
   (381/381) and the empty-conic zone-2 endgame law (P ⟺ the two zone cells don't
   conflict, 328/328): the sampled two-intruder layer is COMPLETELY decided by the joint
   NK snapshot (conic defect-XOR + zone conflict graph). C20 re-amended: test the
   necessity law at q=13/17 first; q=11 is done. Fable next: prove the necessity law
   (joint-snapshot lemma); second-intrusion lemma in defect form after C20's data.
15. **C19 REVIEWED (commit `cac2875`) — the reflection route WORKS; q=5/7/11 book validity
   is kernel-checked.** `lean/ProjectiveCap/CertCheck.lean` (Bool checker + soundness chain
   `checkBook_sound → GridClassCert.Valid`) + generated `CertData/Q{5,7,11}.lean`; the C17
   maxRecDepth wall was beaten by SPLITTING the reflected obligations (per-node step checks
   chunked over cell lists) — no `maxRecDepth`, no `native_decide`, no sorries. Independently
   verified in review: `lake build` clean, Q5/Q7 rebuilt (2.4s/8.8s), and `#print axioms` on
   generated `class*_valid` = exactly `[propext, Classical.choice, Quot.sound]`. Q11 accepted
   on the report's byte-compare evidence (~25 min elaboration, just under the 30-min gate —
   q=13 needs per-class file splitting, deferred). **Open half → C22:** the transport lemmas
   (anchor-normalization grid symmetries + assembly into
   `GridOddEscapeBookCertificate.represents`) — until C22 lands, `OddEscapeGameStatement
   (ZMod 11)` and the unconditional PG(2,11) payoff remain UNASSEMBLED; the rules-only book
   validity (all 72 anchored q=11 classes) is done.
16. **C20 REVIEWED (commit `38d177b`) — SOUND; the joint-snapshot necessity law is DEAD beyond
   q=11.** Report (`2026-07-08-codex-intrusion-census.md`) checks out: every number reproduces
   from the raw states jsonl (violations 468 @ q13 / 3455 @ q17, all slice tables, the first
   counterexample verbatim); the q=9 gate and the C15/C5 bucket-label gate both held. The review
   closed the one un-gated hole — the second amendment said "don't redo q=11", which removed the
   only cross-implementation check on the NEW defect/zone feature code — by re-running the
   census script at q=11 (1s): it reproduces Fable's session-11 ground truth exactly (0
   necessity violations across all 4 buckets; slice zoneG=0 ⟺ P purely), so the q=13
   counterexample is trustworthy. **Review findings beyond the report:** (a) **the q=11 laws
   were a small-zone endgame artifact** — max zone size is 2 at q=11 vs 10 (q=13) / 38 (q=17);
   the snapshot decides only while the intruder zone is an O(1) endgame, and stops the moment
   it grows. (b) At q=13 the (defXOR=0, zone-even) slice IS purely classified by zone NK
   Grundy ({0,3}→P, {1,2}→N; zoneG=3 carries only 2 samples) — the report undersold this as
   "almost decisive" — but every zoneG class is mixed at q=17, so no zoneG law survives either.
   (c) Zero "bad" components across all 56,497 reply states ⇒ Lemma VI's path/cycle taxonomy
   holds wholesale at q=13/17 — a fresh confirmation of the spectrum law at scale. (d) Positive
   structural datum: q=17 N-buckets win ONLY by intruding (28/28 winning first moves are
   intrusions, 0 conic) — extends the q=11 multi-intruder-defense picture (300/300) up a
   column. **Consequence for the Fable lane: the item-14 queued "prove the necessity law
   (joint-snapshot lemma)" target is MOOT as a general-q statement** — the law is false at
   q=13; what survives is the zone-2 endgame law (a legitimate small-zone lemma) and the
   second-intrusion lemma in defect form, now with C20's labeled data to steer it (the
   per-state `ord(σ_xσ_x')` field sits unanalyzed in the states jsonl).
17. **C22 LANDED (Codex, 2026-07-08) — PG(2,11) is now UNCONDITIONAL in Lean.**
   New generated assembly `lean/ProjectiveCap/CertData/Q11Assembly.lean` imports the 72 checked
   anchored q=11 class books and closes the remaining transport/represents gap.  The selector
   maps anchored third cells `(a,b)` with `a,b ∈ {2..10}`, `a ≠ b`, to `class0..class71`;
   invalid anchored cells are discharged by direct row/column/diagonal contradiction lemmas
   instead of a full `GridCap` decision procedure.  The generic bridge extracts a three-point
   set via `Finset.card_eq_three`, applies `anchorAxisAffine`, proves the image is
   `{(0,0),(1,1),x}`, selects the corresponding valid class, and packages
   `GridOddEscapeTransportBookCertificate`.  Payoff theorem:
   `ProjectiveCap.Certificate.CertData.Q11.initialPStatement_finrank`.  Validation:
   `nix develop --command lake build ProjectiveCap.CertData.Q11Assembly` PASS; Q11 data build
   took 1518s on first import, cached assembly rebuild 35s.  Axiom gate:
   `[propext, Classical.choice, Quot.sound]` only.

   **Q13 ADDENDUM (same route, Codex 2026-07-08) — PG(2,13) is now UNCONDITIONAL in Lean.**
   Generated split certificate data `lean/ProjectiveCap/CertData/Q13/` has `Base.lean` plus
   `Class0.lean` through `Class109.lean`, with import aggregator `Q13.lean` and payoff module
   `Q13Assembly.lean` from `notes/2026-07-08-q13-split-to-lean.py`.  The same transport assembly
   closes `ProjectiveCap.Certificate.CertData.Q13.initialPStatement_finrank`.  Validation:
   byte-identical regeneration into `/tmp/q13-regen`; no `sorry`/`admit`/`native_decide`/
   `maxRecDepth`/new `axiom`/`unsafe` in the q13 path; `nix_lake_build_each
   ProjectiveCap.CertData.Q13.Base ProjectiveCap.CertData.Q13.Class{0..109}
   ProjectiveCap.CertData.Q13 ProjectiveCap.CertData.Q13Assembly` PASS.  Per-class files stayed
   far under the 30-min gate (observed range about 2.5-3.8 min/class); final axiom gate:
   `[propext, Classical.choice, Quot.sound]` only.  Operational note: the naive raw aggregate
   build previously OOM-killed unrelated session processes; future generated-cert builds must use
   the OOM-tagged staged wrapper recorded in `CLAUDE.md`.

18. **Queue additions from the day-review gap scan (Fable, 2026-07-08): C29 + C30.** Reviewing
   the post-5pm cascade surfaced two attacks planned nowhere. (a) **Mixed-column mod-3 law
   candidate (C29):** among unconfined-intruder columns q ≥ 11, N-valued on-conic buckets
   exist exactly at `q ≡ 2 (mod 3)` (11, 17 mixed vs 13, 19 all-P) ⟺ `3 | q+1` ⟺ order-3
   PGL(2,q) elements are elliptic ⟺ order-3 `σ_xσ_x'` products land in Grundy-dead C₆ cycles
   rather than tangency-path defects. This is a COLUMN-level existence law C18's bucket-level
   null never tested. C29 = the ord-field mechanism table on the existing C20 states data
   (flagged unanalyzed in item 16) + an INVERTED census (bucket first by PGL 6-subset
   canonicalization, then one S₄-rooted solve per bucket — bypasses C21's aborted
   size-3-rooted esc solves) at q = 23/25/29/31, predictions mixed/all-P/mixed/all-P; any
   miss refutes. (b) **C30 = route-C phase 5:** q=17/19 certificate books — every
   feasibility gate already measured (C3 memo peak, C19 splitting, C22/Q13 transport);
   q=13's staged split build is now landed and is the template.
   Payoff = the whole computed prime ladder ≤ 19 unconditional. Status table updated in the
   same edit.
19. **Second queue batch from the gap scan (Fable, 2026-07-08): C31 + C32.** (a) **C31 =
   zone-steering ceiling census:** the C20 review's surviving proof shape ("P2 steers the
   zone back to the O(1) regime where the endgame laws hold") made precise as a recursive
   minimax quantity `Z(S)` over the C20 P reply-states at q=13/17 — either a small uniform
   bound B (⇒ proof shape = steering lemma + small-zone endgame law as terminal certificate)
   or a verbatim counterexample that kills the picture. (b) **C32 = even-dimensional
   composite mirror, PG(4,3) stuck-free probe:** `PG(2m,q)` m ≥ 2 odd q are the only open
   boards besides planes and appeared in no plan. Odd point count + no fpf involution (R0,
   vector dim odd) ⇒ single-map mirrors dead, but a hyperplane `H ≅ PG(2m−1,q)` carries the
   C25 elliptic involution and the complement is affine — so composite/adaptive mirrors are
   the natural shape, with C27's mirror-chord condition as the exact coupling obstruction
   (affine mirror chords each carry one direction point of `H`). Deliverable = a
   stuck-free strategy simulation over ALL P1 play (the q-even planar verification pattern):
   any stuck-free candidate is a theorem candidate for all even dimensions at odd q — which
   would leave PLANES as literally the only open boards; failures yield the `Obs` histogram
   one dimension up. Deferred from the same scan: NK pairing-lemma cross-pollination on the
   union-matching residual — overlaps C28 and targets the restricted Grundy (not the
   undecided zone part); revisit after C28 + C31 report.
20. **C32 DEEPENED to v2 (Fable, 2026-07-08) — the composite mirror's shape is FORCED, and
   the plane variant is genuinely untried.** Full analysis in
   [`2026-07-08-evendim-composite-mirror-design.md`](../2026-07-08-evendim-composite-mirror-design.md).
   Corrections + derivations: (a) the v1 candidate "translation `τ_v` on the affine part" was
   an ERROR — translations have order p, not 2, for odd q; moreover NO fpf affine involution
   of the odd-count affine part exists at all (any affine involution has a `q^{dim U₊}`-point
   fixed subspace), so the affine component is forced to point-reflection `σ_c` (midpoint-
   seeded, center self-blocks) or reflection towers. (b) Poison structure: a selected `h ∈ H`
   poisons the pencil line through `c` in direction `h` (a chord meets `H` once, so
   ρ-invariance cannot double it); but P2's ρ-discipline makes `S ∩ H` ρ-invariant, so
   poisoned pencils come in ρ-PAIRS — the **double-pencil-burn** exception rule (answer the
   first `h`-pencil entry in the `ρh`-pencil; both lines die whole: even, σ-invariant
   removal) is the candidate patch. (c) H-internal soundness = C25 restricted to `H` (H-pair
   chords stay in `H`). (d) What remains is a finite list of LOCAL escape-like obligations
   (exception-cell existence chief among them) — the same reduction shape route C used, now
   for the strategy itself. (e) **The plane transfer is untried**: the 2026-07-05 σ_c failure
   was post-frame-reduction (burned opening pair + partial-permutation constraints); this
   composite never burns an opening pair, and `|S ∩ ℓ| ≤ 2` caps the poison at two pencils —
   one plane obligation (ℓ-reply existence) already falls to a max-cap counting argument.
   C32 v2 reordered: plane q=9/11/13 FIRST (ground truth + mandatory diff against the grid
   findings), then PG(4,3). Unlock ladder: PG(4,3) stuck-free ⇒ all even dims odd q modulo
   local obligations (with C25 + even-q: everything but planes); plane stuck-free at q=11/13
   ⇒ candidate uniform odd-plane mechanism ⇒ the full conjecture; failure ⇒ the failing
   obligation becomes a better-posed open kernel than "find a mechanism". Lean distance is
   short in every branch (C27 step lemma + C25 ρ + formalized midpoint trick + C19 cert tech
   for exception tables).

## Handoff Summary

The affine cap game is solved because affine space has exactly the mirrors needed. The projective
cap game is the next high-value test: same cap relation, less translation symmetry, harder fixed
loci. Start with `PG(2,q)` and `PG(m,2)`. Either find a projective move-then-mirror that burns the
fixed locus, or extract the obstruction/counterexample. The first proof target should be `PG(2,q)`;
the first algebraic target should be `PG(m,2)` after opening pair `{a,b}` removes the 2D subspace
`<a,b>`.

## Archived 2026-07-11 from the current handoff (session-history / settled sub-probes)

This section holds prose relocated **verbatim** from
[`../2026-07-06-projective-cap-game-handoff.md`](../2026-07-06-projective-cap-game-handoff.md) on
2026-07-11 during a current-state cleanup pass.  Each block is settled session history or a
settled / no-longer-load-bearing sub-probe.  The live handoff retains the frontier levers (the A5
value-blind anchor; the C74 2026-07-11 value-blind-selector impossibility; the Cluster-2
amortized/ledger potential; and the gated q=29 census + arc-depletion arithmetic), the Status Table,
the Closed Higher-Dimensional Families, the Odd-Plane Kernel, the Lean/Solver maps, and condensed
one-line digests that point back here.  Nothing here is deleted; relative report links are preserved
as originally written (they were authored to resolve from the live handoff's `notes/handoffs/`
location, so from this `done/` file some `../` report links sit one level shallow — follow them
from the live handoff).

### Near-Term Queue task-amendment trail (C41–C74 "Fable Nth pass" additions)

Why archived: settled queue-amendment bookkeeping; the open items were collapsed into the live handoff's follow-up bullets + frontier levers, and the operational task IDs live in the codex task queue.

- **Counterexample-readiness additions (Fable, 2026-07-09 second pass):** **C41** trap ⇒ N
  converse in Lean (reported/proved; D1 may use the equivalence); **C42** fixed-q census propagation
  (rescoped same day after the on-conic child type-alignment verdict, then reported **NEGATIVE**
  — no census mechanism; see Recently reported); **C43** exact-solved `PG(4,3) = P`, closing the
  former even-dimensional evidence vacuum but not the uniform family; **C44** GF(25) path + q=25 Baer
  bucket census (the A4 falsification watch, previously without a task ID; q=25's depletion
  status is now the key covariate).  The former q=23 direct-B3-discharge rider is superseded by
  **C53** (full-PGL bridge — parts 1–2 now a verified Lean theorem, `Sym2Bridge`) and **C54**
  (q=23 bucket-label certification, now reported PASS).  Tier placement is in the queue's
  priority-ordering amendment.
- **Publishable-constraint additions (Fable, 2026-07-09 third pass):** **C45** defect-skeleton
  realizability theorem (dihedral classification of the conic endgame spectra; makes the mined
  even-cycle cancellation and split/elliptic order-dichotomy facts corollaries of one theorem);
  **C46** t-ply conic-depletion inequality ladder (`live_on >= q - c(t)` and the trap ply-depth
  constraint `T(q)`); **C47** minimal-counterexample constraint package (odd-perfect-number-style
  theorem list, gated on C42 — gate since DISCHARGED, C42 negative, so its dichotomy row takes
  the negative branch).  All three publish constraints on the conjecture independent of its
  resolution.
- **Adjacent-publishable additions (Fable, 2026-07-09 fourth pass):** **C48** mirror-theorem
  harvest on classical varieties (the generic fpf-involution Lean lemma applied to hyperbolic
  quadrics / Hermitian curves and surfaces — new P families at lemma-application cost, with the
  trivial-parity boards flagged); **C50** kernel-checked Grundy certificate format (machine-
  verified game-value sequences, newly enabled by C35's nimber oracle); **C49** Node-Kayles
  nimber tables for kings/knights/bishops (D6 siblings, queens box idle time; rooks are
  forced-length parity, the sanity base case).  Priority order C48 > C50 > C49; C35's
  non-decomposition verdict also unblocks C38 with true-nimber data.
- **Dual/isomorphism assessment additions (Fable, 2026-07-09 sixth pass):** **C55** d-lattice
  side-switch diagnostic (Tier B top — a mechanism candidate for the arc-depleted-orders
  dichotomy: the flip pairs 11/13 and 17/19 share a divisor lattice across opposite
  split/elliptic sides, so by Lemma VI the same configuration's defect skeleton genuinely
  differs across the pair; paired-contrast test on the 119 flipping configurations, with a
  falsifiable q=23/q=25 prediction if positive) — **REPORTED 2026-07-10 NEGATIVE** (with C64; see
  Recently reported); **C56** group-indexed cross-q type alignment
  (the C36 retry, gated on a C55 positive — **stays closed-gated, C55 negative**); **C57** zone
  conflict-graph quasi-randomness probe
  (either verdict turns the zone-mining negatives into one structural statement); **C58**
  cap game on the four order-9 projective planes (order vs Desarguesian structure — the one
  spinoff-bridges item with a direct claim on the main program; spec in
  [`2026-07-09-spinoff-bridges-duals-isomorphisms.md`](2026-07-09-spinoff-bridges-duals-isomorphisms.md)).
  Outward-facing spinoffs (code-extension games, SET/sum-free games, games-on-groups, matroid
  and design capacity games) stay in that note, not the queue; the Opus literature/priority
  check on them has REPORTED (revised order F, A, B, C, E, D; D folded into A, E rescoped;
  report: [`../2026-07-09-spinoff-bridges-litcheck.md`](../2026-07-09-spinoff-bridges-litcheck.md)).
- **Broader-sweep additions (Fable, 2026-07-09 seventh pass):** a second category sweep
  (list + spinoff-value table in the spinoff-bridges note §New Candidate Mappings) added
  main-problem tasks per Fable's call: **C59** arc-stability constraint import (Voloch/Ball
  second-largest-complete-arc bounds ⇒ large terminals are conic-contained by theorem; extends
  C46/C47) and **C60** Singer-model circulant probe (the plane as a cyclic difference-set
  board; bounded diagnostic).  Igusa invariants noted in C56 as candidate canonical cross-q
  coordinates; an amortized-potential method note added for the steering/termination lane.
  The sweep's spinoff-only items (no-three-in-line game, Sidon-set games, quantum caps,
  misère siblings, placement complexes, etc.) are in the spinoff note; the second-pass Opus lit
  check on them has REPORTED (same report file; proceed: no-three-in-line, Singer/Sidon,
  quantum caps, positional comparisons; notable import: arXiv:2404.05305 already applies
  hypergraph containers to our collinearity hypergraph).
- **Mathematician-lens sweep (Fable delegate, 2026-07-09):**
  [`../2026-07-09-mathematician-lens-sweep.md`](../2026-07-09-mathematician-lens-sweep.md) —
  six lenses (Tao/Erdős/Conway/Alon/Segre/Lovász), constraint-checked attacks with kill-tests,
  deduped against C55–C60 and the spinoff sweeps.  Top shortlist: Conway reply-automaton over
  (defect spectrum, interface, zone summary) as the falsifiable form of the Good-closure lemma;
  Tao inverted selector search scored on the q=19/q=23 zero-xor corpora; Lovász LP/dual fitting
  of the amortized potential (infeasibility dual = machine-readable impossibility lemma); Erdős
  completion-poset mechanism for the q∈{11,17} flips + the Z(23) measurement.  **Top-5 queued
  2026-07-09 (eighth pass): C61 reply automaton, C62 selector-library scoring, C63 potential
  LP/dual, C64 completion poset (beside C55), C65 Z(23) measurement (Tier A — run first).**
  Near-misses queued for later as **C66/C67/C68** (grid-terminal spectrum, coupling-defect
  spectroscopy, D(q) sequence — gated on post-C61–C65 triage).  The queue now opens with a
  consolidated **CURRENT TOP OF QUEUE** snapshot (ninth pass) that supersedes the amendment
  trail for ordering: C65 first, then the dichotomy cluster (C55/C64→C56) and the open-core
  cluster (C62/C63/C61), with the independent lanes (C30, C43/C44, C58, C59, C50) in parallel.
- **Brainstorm-frame runs (Fable delegates, 2026-07-09/10):**
  (1) [proof-shape census](../2026-07-09-frame-proof-shape-census.md) — survivors: S10
  discharging/unavoidable-set (STRONG; forced lemma = finite steering alphabet; its
  bounded-interface risk is exactly what C65 arbitrates), S11 entropy compression (MEDIUM;
  forced lemma = geometric selector, feeds C62), S9 KSS fixed-point (long shot; verified that
  no published outcome⇔topology bridge exists).  Its proposed "C61" task name collides with
  the queued C61 and substantially overlaps it — merge at triage, do not double-queue.
  (2) [genericity test](../2026-07-10-frame-genericity-test.md) — verdict **STRUCTURAL**:
  PG(2,5)/PG(2,7) are P against 400/400 generic-N matched random boards; P-frequency
  *oscillates in density bands* (the q=9 agreement is band coincidence); a soft/typicality
  proof is ruled out, conic localization is not disposable scaffolding, and C58's evidential
  asymmetry sharpens (order-9 all-P weak, any N doubly informative).  The band discovery also
  warns the Es1 random-sub-board spinoff to measure full retention curves.  **C58 has since
  REPORTED all-P** (2026-07-10): the two verdicts *bracket* the mechanism rather than conflict —
  genericity rules out the generic-hypergraph level, C58 rules out the Desargues-specific level, so
  the load-bearing layer is the oval/complete-arc structure all four order-9 planes share.  This
  strengthens A5 (stated at that level; the depleted orders 11/17 are primes with no
  non-Desarguesian planes) and softly steers Ψ geometrization toward arc-level coordinates.
  (3) [random-turn/Richman values](../2026-07-10-frame-random-turn-values.md) — the
  protocol-perturbation hope is closed **by theorem**: for impartial normal play, every
  symmetric move-selection protocol is information-free (fair random-turn ≡ 1/2, p-biased ≡ p,
  continuous Richman ≡ 1/2; proved in the report; discrete bidding closed by
  Kant–Larsson–Rai–Upasany EJC 2024), machine-verified on 18.7M positions; PSSW transfer is
  exactly zero (partisan win-set theory).  Salvage: the random-*play* annealed value rho
  contradicts truth at the empty board exactly at q=11 (the first arc-depleted order), and
  **rho-greedy found a winning move at 100% of all 11.8M N-positions across every board**
  while failing (~0.5–0.7%) on random-board controls — a structural selector-candidate law.
  Consequence: the missing potential must be alternation-anchored (amortized/ledger form);
  rho-greedy added to C62's library with an `s4rho` traversal prerequisite (rho is
  tree-defined — a mining selector, not the S11 geometric selector).
- **Codex-assessment adjustments (Fable eleventh pass, 2026-07-10):** Codex 5.6 Max's program
  assessment was cross-checked against the reports and adopted with one reframe.  New tasks:
  **C70** exact reservoir-slack collision charge (untruncate `Psi`'s `max(0,·)` reservoir term
  into the exact blocker/secant/conic-point collision multiplicity + a move-pair Δ formula —
  satisfies the C63 reopen condition and is the best candidate explanation of the q=17/q=19
  selector splits); **C71** three-involution transition theorem (the first structurally
  unclassified intruder layer; success = derive `Psi`'s `6·components − 4·intruders`
  coefficients); **C72** PGL permutation-module / Johnson-scheme decomposition of `f_q` (A5-lane
  **concentration instrument** for the §6 link-sum near-point-mass — not a reopened Cluster-1
  config-dictionary hunt; flip/control discipline with q=13/19 controls mandatory).  Framing
  shifts: (i) the **C61 successor is existential** — characterize the algebraic set of admissible
  `Psi`-decreasing replies and prove it nonempty (= the S11 geometric-selector lemma; C61's six
  forced conflicts kill q-blind lookup, not a q-varying realization of one finite-field formula;
  no more deterministic argmin variants), and (ii) **C44's q=25 census outcomes are
  pre-registered** against the (ON)-vs-conjecture bifurcation (a zero-witness class kills (ON)
  only — pivot to off-conic escape structure; a cheap off-conic escape-margin rider at q=11/17
  is queued in the C44 entry to quantify that fallback before q=25 forces the question).
  Priority among new work: C70 > C71 ≥ C72, consistent with C65's amortized-potential-primary
  verdict; the running q=25 census stays the decisive compute datum.
- **Codex round-1 theorem frontier + Fable review (twelfth pass, 2026-07-10):**
  [`../2026-07-10-codex-odd-plane-round1-report.md`](../2026-07-10-codex-odd-plane-round1-report.md),
  independently verified (XHIST reproduced from a from-scratch implementation; the fiber identity
  reproduces the committed q=25 bucket histogram 6/120/180/360/720 exactly — the size-6 bucket is
  the Baer subline `P¹(F₅)` with stabilizer `PGL(2,5)`; the secant packet rerun from the rescued
  scripts and cross-matched against the C44 rider's distribution).  PROVED: involutive-completion
  lemma (15 constructions per five-frame, ≥2 of 3 pairings per distinguished point always
  defined); `fiber(B) = 30(q−1)/|Stab(B)|`; and the **q=17 (ON) statement from bucket
  stabilizers** (capacity 15 > q−4 = 13, N stabilizers ≤ C2) — the first structural explanation
  of the knife edge, with its limits equally proven (q=11's V4 N-bucket absorbs exactly 15; the
  constant gives nothing for q ≥ 19).  REFUTED: stabilizer-specialness ⇒ P (q=11 N bucket has V4)
  — the C68b "P = rare/special" lead survives only as a correlation, not an implication.  FOUND
  (post-hoc): the q=17 **secant packet** — the three knife-edge classes' five P escapes are one
  line through the unique on-conic witness, so the off-conic pivot layer at q=17 is *parasitic on
  the witness it would replace*, sharpening the rider's co-depletion warning.  Queued **C73**
  (value-blind `L(A)` secant theorem — the pivot's structure question, meaningful whichever way
  q=25 lands) and **C74** (`Ω(q)` capacity family — mandatory for uniformity, 15 saturates at
  q=19).  Scripts rescued from `/tmp` into `rust/scripts/` (`a5_incidence.py`, `a5_stab.py`,
  `escape_lines.py`); Tranchida involution-triples dictionary (arXiv:2411.10299) + the fiber
  identity forwarded mid-run to the C71/C72 agents.  One report defect: its "no active solver
  process observed" is wrong — the q=25 census was and is running (sandboxed process view).

### "Recently reported" bullets (2026-07-09/10 per-task iteration logs)

Why archived: settled per-task result bookkeeping; load-bearing residue condensed into the live handoff's Near-Term Queue digest (config-mechanism negatives C55/C64/C69; selector-family negatives C61/C62/C63; q=25 round-2 / C73–C74-capacity resolved by the completed q=25 census).  The three retained frontier bullets (A5 anchor, q=29 census sizing, q=25 census complete) stay in the live handoff.

- **q=25 R7-decider (2026-07-10, mid-census) — `f_10 = P` ⇒ `min-witness(25) ≥ 4`: the knife
  edge REBOUNDS at the first square order; (ON) survives q=25.**  Bucket 10 (rep `[1,2,6,8]`,
  size-720 generic, 223.8M positions) labeled P by the running census, resolving the C74
  dichotomy (`0 or ≥3`) on the rebound branch: `R7 = 6f_10 + 3f_14 + 6f_16 + 6f_17 ≥ 6`, and
  with the disclosed row bounds the global minimum sits at the R4–R6 floor of 4.  The C68
  min-witness slide `2 → 1` does NOT continue; the A5 anchor `maxonN(q) ≤ q−5` holds at q=25
  with margin; the A4/Baer falsification watch weakens.  Census 11/28, ALL P (including the
  size-720 generics where q=17-style depletion strikes first) — `ν(25)` tracking toward 0
  (non-depleted).  Remaining: buckets 14/16/17 refine `L`'s ON form per the C74 §6 tree ("non-
  depleted ∧ L-fails" is logically impossible, so an all-P tail sends the `L` stress-test null);
  the concurrence point `(1:15:9)` is a post-census targeted off-conic solve.  With the rebound,
  the open A5 arithmetic question shifts to which orders beyond {11,17} deplete at all.
- **Codex round-2 umbrella (2026-07-10; verified by Fable) — kill-set top-k refuted at q=23;
  tied-line concurrence found; (L_forall) named.**
  [`../2026-07-10-codex-odd-plane-round2-report.md`](../2026-07-10-codex-odd-plane-round2-report.md).
  (i) The predeclared kill-set-sorted top-k (k ≤ 4) reply rule is exact at the q=19 root (148/148
  at k=4) but has **11 exact all-N-top-four failures** among 1,091 q=23 maintenance obligations
  (first P replies at ranks 6/10/13/27; the decisive class needs a reply deleting all three
  isolated live vertices) — neither `D=∅`-first nor min-|K| is a uniform bounded selector; the
  rigid residual (7 incidence classes, 8/11 under one follower) routes the selector program to
  **generic discharge + explicit exception classes**.  (ii) The tied `d=4` max lines of a class
  **concur at one value-blind legal off-conic point, exact P in 10/10** labeled tie families —
  incl. both q=11 knife-edge classes, closing C73's ON-form gap at the selector-existence layer;
  post-hoc, not promoted; frozen q=25 prediction: R7's common Veronese point `(1:15:9)` is P.
  (iii) **(L_forall)** ("every max-incidence line carries a P child") named as the robust
  localized anchor — implies the conjecture, independent of (ON), survives min-witness 0.
  Fable re-ran both scripts: concurrence 10/10 verbatim; kill-set failure ranks/classes verbatim.
  Recommended round 3: the involution-pencil lemma, the q=25 targeted unblind (buckets
  10/14/16/17 + `(1:15:9)`), the 7-class exception analysis.
- **C74 (2026-07-10, Codex round 2; verified by Fable) — the L(A) algebra is completely solved;
  the stabilizer-capacity route is closed with proof; q=25 is forced into a sharp dichotomy.**
  [`../2026-07-10-codex-c74-capacity-family.md`](../2026-07-10-codex-c74-capacity-family.md).
  Three proved theorems: (i) **line-pencil** — normalizing `L(A)`'s endpoints to `(0,∞)`, the
  secant's off-conic cells are the involution pencil `τ_a(t)=a/t` with the illegal cells exactly
  the pair products `P2(U)` of the other four frame points, giving `nlegal = q − d`,
  `d ∈ {4,5,6}` (so C73's max-incidence extremum = minimal pair-product collision, field-uniform
  incl. GF(25)); (ii) **supply ledger** — the round-1 fifteen involutions land `3/1/0` per
  `d=4/5/6` line, so `L(A)` maximizes the local share of the 15-unit supply; (iii) **tie
  theorem** — `d=4` maximizers biject with the involutions of `Stab(A)` (0,1,3,5; zero ⇒ fifteen
  tied `d=5` lines), retro-explaining every C73 tie count (q=11 knife-edge = D10 ⇒ 5 tied lines;
  q=17 = 21× unique).  Fable re-ran the verification: supply=15 on all 68 classes, min/tie
  histograms verbatim, fan matrices regress to round-1 `M_11`/`M_17` exactly.  **Stabilizer
  barrier:** legal pencil centers are provably non-stabilizing, and any
  automorphism-of-completion family has supply ≤ 838 = O(1) — so the Ω(q) capacity route via
  stabilizers is dead by theorem, and the program's sharpest open lemma is now one-dimensional
  and explicit: `IsP(A∪{w})` or some legal pencil center `z_a` (`a ∉ P2(U)`) gives
  `IsP(A∪{z_a})` — a one-intruder N-absorption statement on the Lemma-V/VI classified layer,
  with the q=11 knife-edge's mixed 4P/2N pencil as the mandatory base case.  **Label-blind q=25
  matrix:** 8 five-set orbits; with the census's 7 disclosed P buckets, the sole open row is
  `R7 = {10:6, 14:3, 16:6, 17:6}`, so **min-witness(25) = 0 or ≥ 3** — the `2 → 1` knife-edge
  slide cannot continue gently; the pivot is bucket 14, and the "non-depleted ∧ L-fails" cell is
  logically impossible.  Scripts `rust/scripts/c74_line_pencil.py`, `c74_fan_orbits.py`.
- **C73 (2026-07-10, Claude/Opus) — value-blind secant selector: POSITIVE; failure gate 2
  REFUTED.**  `L(A)` = the **maximum-legal-incidence** frame-point/on-conic candidate secant —
  computed from S3 + conic + legality only, no P/N input — carries a P escape on **68/68**
  size-3 classes across q = 11, 13, 17, 19 (plus q=5,7), with unique argmax 21/21 at q=17 and
  the packet recovered 3/3 at the extremal classes.  Null control at the discriminating
  depleted order q=17: a random candidate secant carries a P escape 49% of the time (on-conic P
  21%) vs L1's 100%/100%.  The on-conic point of `L(A)` is itself P at 21/21 (q=17), 12/12,
  27/27 — failing only at the two q=11 knife-edge tie classes (5-way tie, N conic point, the
  off-conic P's still on the line; the round-1 §1D pattern).  Predeclared-then-unblinded with
  negatives recorded: all product-point selectors (L2/L3/L4) fail — the incidence extremum, not
  product-point membership, is load-bearing.  **Consequence: the off-conic pivot layer is NOT
  irreducibly witness-anchored at q=17** — pure incidence recovers the witness value-blind — so
  the C44 branch-(ii)/co-depletion risk is *reduced* (residual worry: the q=11 knife-edge tie
  signature may recur at larger depleted orders).  Un-closed step: the local recursion lemma is
  tested (existence, 0 failures), not proved — the game-value reduction needs the tree.
  **q=25 pre-registration CLOSED BY CENSUS (2026-07-10):** the on-conic census is all-P (28/28),
  so q=25 has no extremal N class — the ON form is vacuously safe (predicted fragility had nothing
  to fail on) and the ESC-form solve is decision-moot (C74 §6: "non-depleted ∧ L-fails" is
  logically impossible).  Sole un-scored residual: the off-conic `(1:15:9)` concurrence point
  (not covered by the on-conic census) — optional selector-existence datum, no longer
  decision-bearing.  Report:
  [`../2026-07-10-codex-c73-secant-packet.md`](../2026-07-10-codex-c73-secant-packet.md);
  scripts `rust/scripts/c73_*.py`.
- **C70 (2026-07-10, Claude/Opus) — exact collision charge: formulas PROVED, but the truncation
  was hiding a deterministic drift, not a discriminator.**  The untruncated collision
  multiplicity is exact and machine-verified (`M = E + delta0col`, 935,702 states, 0 exceptions;
  `R_code = max(0, M − g(q,k))` with `g` deterministic in (q, ply)), and the move-pair form is
  `ΔM = −|K_u ∪ K_v| − [F(k+2)−F(k)]` — but `M` is `zone_v` plus a ply potential, provably
  invariant across replies at a fixed obligation, so it cannot advance the C61 successor: naive
  substitution is catastrophic, refit only relocates the q=19 hard surface (12 → 10, four new
  parents), and reply-family averaging inherits from the truncated charge plus a constant.
  Verdict: do not promote `Psi_exact`; keep truncated `Psi`.  **Synthesis with C71:** across
  both halves of `dPsi` the only reply-varying quantities are now kill-set incidences
  (`|K_u ∪ K_v| = −Δzone_v` in the reservoir half; C71's `D(z)` gate for `dC` in the structural
  half) — the existential selector lemma should be stated over kill-set incidence data.  Report:
  [`../2026-07-10-codex-c70-collision-charge.md`](../2026-07-10-codex-c70-collision-charge.md);
  script `rust/scripts/c70_collision_charge.py`.
- **C71 (2026-07-10, Claude/Opus) — three-involution transition: NOT a function of center
  geometry (missing coordinate named); `Psi` coefficient check POSITIVE.**  Every 2→3-intruder
  transition mined exactly from the q=13/17/19 Grundy dumps (1,167 / 153,266 / 1,063,392 rows;
  new `s4triple` solver mode).  The map (before-skeleton, center-triangle geometry) →
  after-skeleton is **not a function** even at the finest PGL-invariant key (violating fraction
  28% → 89% → 94%, growing with q; single-key fan-out up to 12) — the center-triangle-invariant
  search is measured futile; the missing coordinate is the **labelled embedding of the live
  conic cells** against `sigma_z` and z's kill-lines (confirms the C45 §4 prediction, now with
  reproducible witnesses).  Positive half: `dPsi = [6·dC − 4] + [dReservoir − 2·dXor0]` exactly —
  the structural part of every 2→3 move is `6·dC − 4` by construction, so `Psi`-descent on
  3+-intruder states reduces to a `dC` rule (needs the labelled coordinate) **plus the C70
  reservoir charge**.  Single-move `Psi`-nonincrease: 100% (q=13, q=17), 99.9976% (q=19) — all
  26 exceptions one PGL orbit (`P[5] → P[1,1,1]`, equilateral all-external d=5 center triangle;
  opponent moves, not reply failures — the C71 analogue of C63's 12 q=19 tie rows).  Proved
  gate: `D(z) = ∅ ⇒ dC ≤ 0` (adding a matching only merges; component creation is gated by the
  kill-set) — the lever for C70/C61 replies: keep the kill-set off the live-path interior.
  Tranchida (arXiv:2411.10299, forwarded mid-run) supplied the center dictionary.  Report:
  [`../2026-07-10-codex-c71-third-intruder.md`](../2026-07-10-codex-c71-third-intruder.md);
  analyzer `rust/scripts/c71_transition_analysis.py`.
- **C72 (2026-07-10, Claude/Opus) — f_q Johnson-scheme decomposition: NEGATIVE (read b), with an
  exact identity as a by-product.**  No harmonic/design identity forces near-constant link sums:
  at the depleted orders `f_q`'s spectral mass sits in the TOP Johnson components and migrates up
  with q (`V_6` share 0.079 → 0.726 from q=11 to q=17; `V_0` share `= 1 − ν(q)`), so any
  low-component reading is a q=11 artifact (flip/control fail, the C64/C69 lesson).  The observed
  `onP` near-point-mass is the link operator `W₅,₆` *discarding* the dominant link-invisible
  `V_6` mass, not `f_q` being low-degree — spectral corroboration of C42.  **Gift:** PGL
  3-transitivity gives the exact q-uniform identity `f_q ⊥ V_1 ⊕ V_2 ⊕ V_3`, reducing the §6
  class-stability question to bounding the `V_4 ⊕ V_5` mass (which is arithmetic — A5 keeps the
  anchor).  Report:
  [`../2026-07-10-codex-c72-fq-decomposition.md`](../2026-07-10-codex-c72-fq-decomposition.md);
  script `rust/scripts/c72_fq_decomposition.py`.
- **C44 item-7 rider (2026-07-10, Claude/Opus) — off-conic escape margin: modest, trending
  adverse, co-depletes at q=17.**  Worst-class off-conic escapes `8 → 4` across the depleted
  orders; at q=17 the three knife-edge on-conic classes (onP=1) are exactly the three worst
  off-conic classes (off=4 — nearly the whole 5-escape total), where q=11 anti-aligns (knife-edge
  class has off=16).  The round-1 secant packet explains the q=17 alignment: all five escapes are
  one secant through the on-conic witness.  Report:
  [`../2026-07-10-offconic-escape-margin.md`](../2026-07-10-offconic-escape-margin.md); script
  `rust/scripts/c44_offconic_escape_margin.py`.
- **C68 follow-on (2026-07-10, Claude) — N-bucket density ν(q); the min-witness suppression is
  marginal.**  Exact on-conic S4 bucket census (`s4arena --all`, q=5..19). `ν(q)` (state-weighted
  N-fraction) `= 0` off the depleted orders, `0.357` (q=11), `0.791` (q=17) — positive and
  ~doubling; #N-buckets `1 → 5`.  **Key:** a random null (`E[fully-N classes] = ncls·ν^(q−4)`) gives
  `0.006` at q=11 but **`1.000` at q=17** vs 0 observed — so min-witness ≥ 1 at q=17 holds by
  essentially the exact margin a random model expects it to fail by; the trend (ν doubling) is
  adverse.  A5 must bound the extremal size-3 class-type against a rising N-density, not lean on "no
  fully-N class through q=19."  Structure: onP is bimodal (few PGL class-types; min-witness =
  extremal-type count), and value separates cleanly by bucket fiber size (P = rare/special
  completions, N = generic) → **A5 lead: every 5-point frame `{∞,0,t1,t2,t3}` admits a special (P)
  completion.**  Tooling: built + validated `s4arena` (arena-backed S4 labeling, commit `60c87fb`);
  q=25 bucket 0 certified P (213.5M positions); the 8 GB `--log2 29` q=25 census is **COMPLETE
  (2026-07-10): 28/28 buckets P, `ν(25)=0`, not depleted** — the ν-doubling trend does NOT continue
  past q=17 (breaks at the first square order).  Report:
  [`../2026-07-10-codex-a5-nbucket-density.md`](../2026-07-10-codex-a5-nbucket-density.md);
  scripts `c68b_nbucket_density.py`; q=25 census sizing in
  [`../2026-07-09-codex-q25-baer-census.md`](../2026-07-09-codex-q25-baer-census.md).
- **C68 (2026-07-10, Claude) — D(q) depletion-fraction sequence; first A5 measurement.**  Exact
  `D(q)` = max over size-3 classes of the on-conic N-fraction (q=5..19 from feat dumps, q=23 from
  the C54 bucket labels).  Result: **`D(q) = 0` at every non-arc-depleted order** (5,7,9,13,19,23;
  every on-conic child P, min-witness = q−4) and **`D(q) > 0` exactly at the arc-depleted `{11,17}`**
  (`D(11)=5/7≈0.714`, `D(17)=12/13≈0.923` — corrects the E2 `≈0.79` guess).  The knife edge
  **sharpens** along the depleted subsequence rather than relaxing: min-witness (min on-conic P
  escapes) `2 → 1`, safety margin `(q−4)−maxonN` `2 → 1`; "recovery" to q−4 happens only at the
  non-depleted orders (trivially, maxonN=0 there).  Consequences: (i) the strong E2 form
  "`D(q) ≤ 1−c` bounded away from 1" is **not supported** — the two depleted points climb toward 1;
  (ii) the (ON) route only needs **min-witness ≥ 1**, so the proof-usable A5 anchor is
  **`maxonN(q) ≤ q−5`** (no size-3 class has all q−4 on-conic children N), not a bounded fraction;
  (iii) at q=17 the depletion is class-wide (every class has onN ≥ 10, best class onP=3), so even the
  least-depleted class is worse than q=11's worst.  The conjecture is safe throughout (root has 5
  total escapes at the q=17 knife edge, 4 off-conic); it is the (ON) *route's* on-conic margin that
  is thin.  Decisive missing datum: `D` at the next depleted order (>23) — routes into C44
  (GF(25)/q=25 census).  Script `rust/scripts/c68_depletion_fraction.py`; report:
  [`../2026-07-09-codex-depletion-fraction.md`](../2026-07-09-codex-depletion-fraction.md).
- **C50 (2026-07-10) — tiny kernel prototype PASS; literal scaling NO-GO.** Added a complete
  mex certificate contract, standalone rules-only emitter/checker, and reflected Lean checker.
  The generated 3×3 queens book proves `grundy (queenGraph 3) univ = 2` from 10 nodes/25 edges;
  exact axioms `[propext, Classical.choice, Quot.sound]`. Growth is small on disk through n=6,
  but literal Lean reflection is the bottleneck: n=4 (50 nodes) takes 12.89 s / 4.27 GB RSS and
  n=5 (308 nodes) hits the default 200k-heartbeat limit. Per the stop gate, no C35 adapter was
  built; use indexed or chunked lookup before scale-up. Report:
  [`../2026-07-09-codex-grundy-cert-format.md`](../2026-07-09-codex-grundy-cert-format.md).
- **C58 (2026-07-10, Claude) — all-P, order vs Desarguesian structure resolved.**  Exact-solved the
  cap game on all four projective planes of order 9 — `PG(2,9)`, Hall, dual Hall, Hughes — via a new
  standalone incidence-input solver (`rust/scripts/c58_cap_solve.rs`; the coordinatized grid solver
  cannot represent non-Desarguesian planes).  Planes built + verified in
  `rust/scripts/c58_order9_planes.py` (axioms + Desargues counterexample search; Hall from a
  reversed-regulus spread, Hughes from Dembowski's near-field construction cross-checked byte-for-
  byte against the published GEM-database incidence table).  **All four are P** (first-player loss);
  the four are pairwise non-isomorphic (distinct complete-arc spectra — PG(2,9) has the Segre
  `9⁵−9² = 58968` conics as its only ovals).  PG(2,9) incidence-input calibration reproduces the
  known P.  No N geometry: not a counterexample and not the "conjecture is about Desarguesian
  structure" verdict; instead the reverse constraint — the odd-plane P-property is
  **Desargues-independent at order 9**, so conic localization is Desargues-specific scaffolding, not
  the load-bearing mechanism.  Game value does not separate Hall from its (non-isomorphic) dual.
  Report: [`../2026-07-09-codex-order9-planes.md`](../2026-07-09-codex-order9-planes.md).
- **C59 (2026-07-10) — POSITIVE import, exact large-terminal bounds.**  Imported the verified
  Segre/Voloch/Ball–Lavrauw thresholds from `2026-07-07-relatedwork-o4.md`.  Every residual-game
  terminal is a complete arc, hence is either the full conic (`q+1`) or has size at most the exact
  arithmetic-type bound `B(q)` in the report.  Existing solved S4 DAGs pass the terminal-profile
  gate at q=11,13,17,19; sourced complete-arc spectra pass independently at q=23,27,29.  Kestenband
  supplies a non-conic arc at odd-square q; a maximal extension supplies some non-conic complete arc
  in the proved interval, but the import does not identify its exact size or make it the sole large
  terminal.  Combined with C46/C47, this constrains early depletion, minimum terminal length, and
  the top terminal band.  It is **not** a `Good`-closure or a game-value theorem.  Script
  `rust/scripts/c59_arc_stability_check.py`.  Report:
  [`../2026-07-10-codex-arc-stability-import.md`](../2026-07-10-codex-arc-stability-import.md).
- **C55 (2026-07-10, Claude) — NEGATIVE, the arc-depleted dichotomy has no group-side mechanism.**
  H-side-switch tested on both instruments the task names.  Abstract C18 involution-product
  dictionary: no net directional side-switch (flip net ≈ 0, ≤ control; shared-lattice `d` switch at
  the same rate flip vs control).  Actual legal-intruder secant skeleton (Lemma VI): the split-share
  rise depleted→full is a generic q-effect, identical for flip and control (17/19: +0.044 vs +0.041
  over 100 vs 30 configs), and the within-order test reverses the prediction (q=11 N children secant
  share 0.029 > P's 0.015).  Minimal-witness solve: secant share smooth/monotone in q, no discrete
  signature at the N,P,N,P flips.  No q=23/25 prediction (mechanism dead).  Scripts
  `rust/scripts/c55_side_switch.py`, `c55_intruder_skeleton.py`.  Report:
  [`../2026-07-09-codex-d-lattice-side-switch.md`](../2026-07-09-codex-d-lattice-side-switch.md).
- **C64 (2026-07-10, Claude) — NEGATIVE, the dichotomy has no extremal-side mechanism.**  Full/exact
  completion enumeration (q=11/13 all configs, q=17/19 seeded 40+30 sample, no truncation; validated
  by independent brute-force `is_arc`/`is_maximal`).  No completion-spectrum property (min size,
  count parity, move parity, size-parity availability) is constant-within-{11,17}/{13,19} and
  differs-across while separating flip from control.  The 11/13 count-parity near-miss is a
  small-field artifact (all 11 flips share one spectrum at q=11) that collapses at 17/19.  Structural
  reason: `has_odd = has_even = True` for every config at every order, so the value lives in the full
  game tree, not any coarse terminal (maximal-arc) summary.  Script
  `rust/scripts/c64_completion_poset.py`.  Report:
  [`../2026-07-09-codex-completion-poset.md`](../2026-07-09-codex-completion-poset.md).
  **Consequence (C55 + C64 both negative):** S1 was promoted as C69 (now also NEGATIVE — see next).
- **C69 (promoted S1) (2026-07-10, Claude) — NEGATIVE; Cluster 1 closed at the config-mechanism
  level.**  The algebraic-geometry-side candidate.  Tangent envelope provably non-discriminating
  (`0/1716` concurrent tangent triples; dual conic always q+1 points; all chords secant).  The
  arithmetic candidates — genus-2 hyperelliptic trace `a2 = Σχ(f(x))` of the 6 branch points, the
  residual tangent/secant partition, χ of Igusa-flavored resultants — all fail the flip/control
  discipline.  Near-hit: `a2=0` for all 11 N-flip configs at q=11 and `(0,−4,0,−4)` for the two
  distinct NPNP double-flips — a q=11 small-field artifact that dissolves at q=17 (N-flips spread
  over `a2∈{−4,0,4}`) and is not sufficient (9 P-controls share `a2=0` at q=11).  Same shape as
  C64's count-parity near-hit.  Script `rust/scripts/c69_envelope.py`.  Report:
  [`../2026-07-10-codex-envelope-invariants.md`](../2026-07-10-codex-envelope-invariants.md).
  **Program consequence: all three configuration-level dichotomy mechanisms (C55 group / C64
  extremal / C69 algebraic) are dead.**  The arc-depleted dichotomy has no config→value dictionary;
  the (ON) uniform route must engage the q-dependent A5 arc-depletion arithmetic directly.  No
  fourth mechanism candidate is queued.
- **C62:** exact selector scoring makes rho-greedy the clear mining order but refutes it as a law:
  `3,144/3,144` q=13 P hits, `1,051,553/1,052,204` q=17, and
  `2,610,869/2,622,214` in the q=19 `[1,2,3,4]` root. Every exact obligation still has some P
  reply with `Delta Psi < 0`, including the q=19 root. The existing 5,734 q=23 zero-xor/live P
  witnesses decrease Psi 95.692% of the time. Polar and character families do not define a clean
  regime; route the localized rho failures and Psi charge to C61. Report:
  [`../2026-07-09-codex-selector-library-scoring.md`](../2026-07-09-codex-selector-library-scoring.md).
- **C63:** exact LP extraction over all q=13/q=17 full-PGL S4 buckets found the integer
  selected-strategy ledger
  `Psi = reservoir_slack + 6*defect_components - 4*selected_intruders - 2*[conic_xor=0]`.
  It strictly decreases on all 3,144 q=13 and 1,052,204 q=17 verified P-to-P reply transitions
  and on C65's q=23 extremal line (`110 -> 30 -> -19 -> -34`).  Held-out replay passes.  Scope:
  the current replies are exact-value/Z-selected, so Psi is the C62 selector-scoring and C61
  charging target, not yet a uniform proved invariant.  Report:
  [`../2026-07-09-codex-potential-lp-dual.md`](../2026-07-09-codex-potential-lp-dual.md).
- **C65:** native recursive steering census gives the honest full-C31 q=23 interval
  `40 <= Z(23) <= 136`.  The complete `[1,2,3,8]` selected corpus has exact max 40; the complete
  maintenance-approved `[1,3,4,9]` corpus has exact max 36; 20 other bucket screens max at 36..39.
  The Z=40 extremum is an immediate repair cost from zone 119 (`live_on=6`, defect spectrum
  `4,1,1`) and descends to child Z=7, then 0.  Route verdict: make the amortized-potential lane
  primary and retain small-Z as its post-repair terminal layer.  Report:
  [`../2026-07-09-codex-z23-measurement.md`](../2026-07-09-codex-z23-measurement.md).
- **C54:** all 22 q=23 full-PGL S4 bucket dumps pass independent rules-only proof-DAG checking:
  `241,627,613/241,627,613` records reached, `988,106,416` legal edges enumerated, zero failures.
  With C53, q=23 is computed and rules-certified at the S4 bucket layer; Lean assembly remains.
- **C29:** mixed-column mod-3 law refuted; q=23 has 22/22 on-conic buckets P.
- **C31:** recursive zone-steering census supports the route; max steering ceiling is 2 at q=13
  and 9 at q=17.
- **C31 follow-up:** every tested q=13/q=17 C20 P reply-state can answer each opponent move with a
  winning reply whose grandchild has `Z <= 2`; q=17 high ceilings are immediate-zone costs.
- **C31 repair mining:** score-9 q=17 repairs are all intruder -> intruder, conic-emptying,
  `defxor = 0`, zone-Grundy-0 moves.
- **Repair geometry mining:** score-9 q=17 repairs are state-level guard intruders: the same
  already-legal internal clean conic-killer answers both worst opponent moves; no single
  line-type/product-order rule explains them.
- **Repair follow-up checks:** score-9 is a two-orbit finite-certificate target; polarity does not
  explain the guard, and empty-conic alone does not imply zone Grundy 0.
- **q=19/q25 mining:** q=19 C20 and steering data are durable in `notes/data/`; q=19 has
  `max Z = 16`.  A Rust `s4` sizing mode shows the ad hoc q=25 probe `[1,2,3,4]` is P at about
  26.3M memo entries, while the first full-PGL canonical bucket representative `[1,2,3,5]` exceeds
  the 100M memo cap.  GF(25) feature mining needs a dedicated prime-power path before broad runs.
  The S4 dump/query manual records the current q=25 partial-dump query workflow and perf profile.
  New `s4xormine --start/--limit` chunking makes q=25 targeted steering feasible in slices:
  `[1,2,3,4]` processed root moves 0..107 with 107 hits before a 50M cap abort, then root moves
  108..167 with 60/60 hits.  All selected q=25 witnesses in these chunks have full unused
  row/column support (`zone_rows = zone_cols = 19`).
- **q>=9 pattern-mining sweep:** the current prioritized mining agenda is
  [`../2026-07-08-q-ge-9-pattern-mining-agenda.md`](../2026-07-08-q-ge-9-pattern-mining-agenda.md).
  It identifies q=17 score-9 guards, q=13/17/19 one-pair descent, q=23 bucket-level mining, q=25
  partial-dump mining, and systematic ply-depth rows as the next useful structure checks.
- **S4 ply-depth tooling:** `s4mine` now supplies the first non-interactive ply-summary layer over
  raw/BuRR S4 dumps.  It reports unknowns explicitly, so capped q=25 runs remain usable for
  geometry/branching without pretending to know child values.
- **S4 conic-depletion lemma candidate:** the ML/joint-summary pass over q=9,11,13,17,19,23,25
  root samples found the two-ply lower bounds
  `off/off >= max(0,q-19)`, `off/on >= max(0,q-13)`, and `on/on = q-7` for live affine-conic
  cells after an S4 root reply.  This is proof-shaped by row/column plus secant incidence counting.
  Consequence: q=17/q=19 are the empty-conic boundary cases, while q>=23 cannot empty the live
  conic at this layer and needs positive-live-conic steering.  Semi-formal proof note:
  [`../2026-07-08-s4-two-ply-conic-depletion.md`](../2026-07-08-s4-two-ply-conic-depletion.md).
- **Live-conic steering plan for q>=23:** the next mining target is value-aware best-reply rows and
  live-conic residual graph features, with q=23 as the exact large-prime column and q=25 as a
  coverage-aware prime-power shape test.  Plan:
  [`../2026-07-09-live-conic-steering-plan.md`](../2026-07-09-live-conic-steering-plan.md).
- **First live-conic best-reply pass:** all q=19 exact buckets and two q=23 exact samples have a
  known P reply for every first move.  q=23 witnesses leave positive conic residuals
  `live_on = 6..12`; all known q=19/q=23/q=25 witness conic graphs are path/cycle/isolate unions
  with `conic_other = 0`.  Added conic-only Node-Kayles summaries show cycle xor is always 0 in
  these rows; the remaining conic residue is path/isolate xor.  Mining note:
  [`../2026-07-09-live-conic-bestreply-mining.md`](../2026-07-09-live-conic-bestreply-mining.md).
- **q=23 zero-xor steering:** new `s4xormine` targeted solving covers all 22 q=23 S4 bucket
  representatives.  Across 5,734 first moves, every one has a P-valued reply with live-conic
  Node-Kayles xor 0; the witness always appears within the first four zero-xor candidates sorted by
  `live_on`.  The witnesses are positive-live (`live_on >= 4`), so the next proof target is the
  maintenance of conic-xor zero under coupled off-conic intruder play.  First zone probe on the q=23 root shows that
  this off-conic legal-zone conflict graph is already one dense component (`zone_v = 100..117`,
  `zone_nk_known = 0`), so the next attack should look for geometric re-steering invariants rather
  than direct full-zone Grundy computation.  The expanded probe shows
  `zone_rows = zone_cols = 17` throughout all q=23 selected witnesses, i.e. the off-conic zone still
  hits every unused row and column after the six selected cells.  Full-bucket expanded sweep:
  5,734 selected P witnesses, all within four zero-xor candidates, with `zone_v = 100..120`,
  `zone_comp = zone_other = 1`, and `zone_nk_known = 0`.  The root-only density cutoff did not
  generalize, and Fable's line-capacity review kills the reservoir->Hall/pairing target: the
  row-bound gives min degree `q - 22`, while a counting-only balanced matching lever needs
  `q >= 38`.  Use the reservoir instead as a base-layer move-availability lemma for re-steering.
  For a legal `k`-cell grid position in the normalized conic graph model, each unused row/column
  has at least `q - k - binom(k,2) - 1` legal off-conic cells; at `k=6` this is `q - 22`, giving
  full unused row/column support for `q >= 23`, but the same loose bound is already vacuous at
  `k=7` when `q=23`.
- **q=23 one-pair maintenance:** bucket representative `1,3,4,9` has now been checked through one
  further coupled off-conic move/reply pair.  The naive first zero-xor P follower is not always
  maintainable, but an existential selector succeeds for all 259 first moves in the bucket.  Its
  accepted followers cover 28,646/28,646 off-conic obligations with P-valued zero-xor replies;
  94.718% of those replies descend to `live_on <= 2`.  This is one bucket only and does not prove
  termination; 1,513 accepted replies retain `live_on = 3..6`.
- **C32 composite mirror probe:** primary point-reflection composite is closed negative.  q=3/5/7
  plane variants are stuck-free, but q=9/11/13 fail for every affine seed; q=9 fails after a
  double-pencil exception breaks later bulk reflection, while q=11/q=13 fail by infinity-reply
  exhaustion after reflected affine play.  PG(4,3) with fixed elliptic `rho` fails the seed
  obligation for all 80 affine seeds.  Report:
  [`../2026-07-08-codex-evendim-composite-mirror.md`](../2026-07-08-codex-evendim-composite-mirror.md).
- **C33 line-capacity follow-up:** Fable's review redirected the q>=23 zone plan.  The
  reservoir->Hall/pairing route is dead below q=38 and should not be pursued at the frontier.
  Zero-xor steering is now a live-conic-xor maintenance problem: prove preservability of a
  re-zeroing reply after coupled off-conic intruder moves, then prove termination in P2's favour.
  The six-cell `q - 22` row/column support lemma is only a base-layer move-availability fact.
  Report: [`../2026-07-09-codex-line-capacity-followup.md`](../2026-07-09-codex-line-capacity-followup.md).
- **C37 shared-key agreement:** raw S4 dump intersections now cross-validate the exact q=19 and
  q=23 bucket corpora.  q=19 has 1,531,020 unique raw keys across 13 roots with 155,219 shared keys;
  q=23 has 217,478,689 unique raw keys across 22 roots with 18,319,494 shared keys; every shared
  key has equal P/N value, and the q=19-vs-q=23 cross-q guard has zero shared keys.  Report:
  [`../2026-07-09-codex-shared-key-agreement.md`](../2026-07-09-codex-shared-key-agreement.md).
- **C36 cross-q type alignment:** depth-2 S4 mining over exact q=17/q=19/q=23 bucket dumps found
  that the intended q-blind coarse shape is still too coarse (one q=19 within-type P/N collision).
  A strict normalized-coordinate type passes self-consistency and has 1,364 shared S5/S6 types
  across at least two q columns, with 281 nonconstant values.  The obstruction is mostly S6 and is
  now tabulated in `rust/s4-dumps/2026-07-09/c36-analysis/nonconstant-strict-types.tsv`.  Report:
  [`../2026-07-09-codex-cross-q-type-alignment.md`](../2026-07-09-codex-cross-q-type-alignment.md).
- **C41 trap converse:** added `ProjectiveCap.TrapConverse` and proved
  `GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`, closing the missing
  trapped-size-3 ⇒ root-N direction.  The proof uses the arbitrary-position frame-grid bridge,
  four-cap transitivity, and `FiniteBuildGame.isP_map`; build and axiom gate pass with only
  `[propext, Classical.choice, Quot.sound]`.  Report:
  [`../2026-07-09-codex-trap-converse.md`](../2026-07-09-codex-trap-converse.md).
- **C35 Grundy oracle / coupling residual:** `s4gdump` now emits exact `u8` Grundy raw dumps,
  `s4gcheck` validates `g=0` against existing P/N raw dumps on shared canonical keys, and
  `s4gmeasure` compares true S5/S6 nimbers with conic and zone Node-Kayles shadows.  Validation
  passed with zero mismatches at q=9/13/17/19.  q=17 root sizing: P/N `64,728` records and `0.18s`
  versus Grundy `186,466` records, `0.84s`, max Grundy `6`; q=19 root Grundy is `2,691,979`
  records in `17.01s`, max Grundy `6`.  The decomposition verdict is negative: conic xor alone
  misses most S6 states, and even where the zone Grundy is computable (`q=13` all sampled states,
  `q=17` subset), `g != g_conic XOR g_zone` on most rows.  Report:
  [`../2026-07-09-codex-nimber-oracle.md`](../2026-07-09-codex-nimber-oracle.md).
- **C38 forced-skeleton distillation:** added `s4gdistill`, an exact raw-Grundy traversal that
  counts winning children at every N node and emits forced-node rows.  Exactness passed with
  `seen == records` and zero missing child values on q=9/q=13 roots, all 10 q=17 full-PGL bucket
  roots, the two q=17 score-9 representative roots, and the q=19 `1,2,3,4` root.  Forced nodes are
  common but not universal: q=17 full bucket corpus has `487,302 / 1,074,873` N nodes forced
  (45.34%); q=19 root has `815,846 / 1,908,007` (42.76%).  q=17 forced nodes concentrate at plies
  7-9 (97.91%), and the two C31 score-9 guard intruders appear as unique conic-emptying internal
  forced replies in the representative roots.  Report:
  [`../2026-07-09-codex-tablebase-distillation.md`](../2026-07-09-codex-tablebase-distillation.md).
- **On-conic child type alignment (size-3→size-4 layer):** within-q value-constancy on exact
  orbits PASSES with zero violations for both the burned-pair stabilizer and full PGL at q ≤ 19
  (reproducing the C5/C15 buckets), but the q-independent finite-type collapse is **refuted**:
  119 shared integral configurations flip value across q, systematically — N exactly at the
  arc-depleted orders q ∈ {11,17}, P at the full orders 13/19.  The on-conic concentration is
  q-driven (arc abundance), not type-driven; no finite type→value table exists.  Full-PGL transport
  is fixed-q only: a solved q gives no cross-q prediction.  C42 is rescoped to the fixed-q
  census/propagation half; the anchor half of the uniform (ON) bound merges into arc-depletion
  arithmetic (falsification-map A5).  Report:
  [`../2026-07-09-onconic-child-type-alignment.md`](../2026-07-09-onconic-child-type-alignment.md).
- **C42 fixed-q census propagation:** the surviving value-free propagation half is also closed
  negative.  Using the same exact stabilizer-orbit machinery over the on-disk feat censuses, every
  all-P q=13/q=19 size-3 class has a distinct full stabilizer-orbit census vector (`12/12` and
  `27/27` distinct vectors).  The onP point masses at those orders are therefore not caused by
  uniform geometry; they hold because every visible stabilizer orbit is P-valued.  At q=11 and
  q=17 the P-count variation is small (`2..5`, `1..3`) but scattered across all P-valued
  stabilizer orbits (`10/10`, `21/21`), with no clean sub-census characterization.  Report:
  [`../2026-07-09-codex-type-census-uniformity.md`](../2026-07-09-codex-type-census-uniformity.md).
- **C30 certificate books:** anchored books are generated and independently rules-checked for
  q=17 and q=19.  q=17: `210/210` PASS, histogram `5:30 10:120 11:60`, all on-conic witnesses,
  no capped books, 111 MB cert.  q=19: `272/272` PASS, histogram `211:272`, all on-conic
  witnesses, no capped books, 863 MB cert.  The original q17 monolithic generated `Class0.lean`
  failed after 31:23 and 11.9 GB RSS, but the refactored split sample now compiles q17/Class0
  through its top module.  Report:
  [`../2026-07-08-codex-route-c-phase5.md`](../2026-07-08-codex-route-c-phase5.md).

### Interleaved 2026-07-09 session handoff notes

Why archived: session-history process notes (scripts added, dumps generated, next-lane pointers).

Handoff note 2026-07-09 / Codex: added `rust/scripts/projcap_composite_mirror_probe.py`, ran the
C32 plane and PG(4,3) primary checks above, wrote the report, and marked C32 reported in the queue.
Next active queue item is C30 unless the proof lane pivots to the steering/base-law agenda or to a
new, non-primary even-dimensional mirror design.

Handoff note 2026-07-09 / Codex C33: applied Fable's line-capacity corrections to this handoff and
the live-conic notes, re-parsed the existing full q=23 `s4xormine` logs as a first-ply
preservability check (`5734/5734` zero-xor P hits; selected `zone_rows = zone_cols = 17`; no new
solves), and marked C33 reported.  Next proof/mining target in this lane is the one-more-zone-move
maintenance check from q=23 zero-xor followers.

Handoff note 2026-07-09 / Codex C33 one-pair follow-up: extended `s4xormine` with exact maintenance
rows and an existential `--require-maintenance` selector.  The first selected zero-xor P follower
has 3/108 exact failures, refuting the naive selection rule.  A complete 26-chunk census of q=23
bucket `1,3,4,9` found maintainable zero-xor P followers for all 259 first moves, covering
28,646/28,646 selected off-conic obligations with no unknown/cap status and a 22,575,285-entry
maximum chunk memo.  Next: pressure the rule on other buckets and isolate the 1,513 accepted
`live_on = 3..6` residuals; true game-nimber coupling remains the separate C35 measurement.

Handoff note 2026-07-09 / Codex C37: added `rust/scripts/s4_raw_isect.py`, generated the missing 20
q=23 exact raw S4 bucket dumps under `rust/s4-dumps/2026-07-09/c37-q23-raw/`, and ran raw-only
shared-key agreement checks.  q=19 all-bucket: 1,725,015 total records, 1,531,020 unique keys,
155,219 shared keys, zero disagreement keys.  q=23 all-bucket: 241,627,613 total records,
217,478,689 unique keys, 18,319,494 shared keys, zero disagreement keys.  q=19 union versus q=23
union has zero shared keys.  Full pairwise logs are in `rust/s4-dumps/2026-07-09/c37-*.txt`.
At that point the next queue item by Fable's priority was C36.

Handoff note 2026-07-09 / Codex C36: added `rust/scripts/projcap_cross_q_type_alignment.py`,
generated missing q=17 exact S4 bucket dumps under `rust/s4-dumps/2026-07-09/c36-q17-raw/`, mined
45 exact q=17/q=19/q=23 bucket roots to depth 2 under `rust/s4-dumps/2026-07-09/c36-logs/`, and
wrote the C36 report.  Coarse conic-defect + zone shape has one self-consistency collision; strict
normalized-coordinate type has zero self-consistency collisions, 1,364 shared S5/S6 types, and 281
nonconstant cross-q value rows.

Handoff note 2026-07-09 / Codex C35: added exact S4 Grundy dump/check/measure modes to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, generated q=9/q=13/q=17/q=19 Grundy
raw roots under `rust/s4-dumps/2026-07-09/c35/`, and wrote
`notes/2026-07-09-codex-nimber-oracle.md`.  The q=17 sizing gate is safe (`186,466` Grundy records,
`0.84s`, `27 MB RSS`, max Grundy `6`; P/N baseline `64,728` records, `0.18s`).  Shared-key
validation has zero P/N mismatches.  The conic⊕zone disjunctive-sum hypothesis is empirically
false at S5/S6: even with fully computable q=13 zone Grundies, `g = g_conic XOR g_zone` fails on
most rows.  This note's original next-step pointer to C41/C42 is now superseded: both have reported.

Handoff note 2026-07-09 / Codex C42: added
`rust/scripts/onconic_census_propagation.py`, generated fixed-q census TSVs under
`rust/s4-dumps/2026-07-09/c42-census/`, and wrote
`notes/2026-07-09-codex-type-census-uniformity.md`.  The P-orbit projection reproduces the
alignment/witness onP histograms exactly, but the full value-free stabilizer census is maximally
non-uniform at the all-P orders (`q=13`: `12/12` distinct vectors; `q=19`: `27/27`).  C42 therefore
closes the fixed-q propagation half negative; the uniform (ON) route now has to engage the
q-dependent arc-depletion arithmetic directly.

Handoff note 2026-07-09 / Codex C41: added `lean/ProjectiveCap/TrapConverse.lean`, imported it from
`lean/ProjectiveCap.lean`, and wrote `notes/2026-07-09-codex-trap-converse.md`.  The new theorem
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank` proves the rank-three
escape/root-P equivalence both ways; a found residual trap is now a Lean-certified projective
counterexample once its residual game facts are certified.  Verified with
`nix develop --command lake build ProjectiveCap.TrapConverse ProjectiveCap`; axiom gate is exactly
`[propext, Classical.choice, Quot.sound]`.  C48 is currently claimed by Opus; next Codex lanes are
C30 certificate engineering, C43/C44 compute sizing, C50 kernel-checked Grundy certificates, or a
selector-specific split over the C38/C39 S4 artifacts.

Handoff note 2026-07-09 / Codex C38: added native `s4gdistill` to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, generated q=17 exact Grundy dumps
for all 10 full-PGL bucket roots plus the two C31 score-9 representatives, and wrote
`notes/2026-07-09-codex-tablebase-distillation.md`.  Exact forced-skeleton traversal passed with
zero missing states/children on q=9/q=13, the q=17 corpus, and q=19 root.  Main numbers:
q=17 full buckets `487,302 / 1,074,873` N nodes forced; q=19 root
`815,846 / 1,908,007`; q=17 forced nodes are 97.91% at plies 7-9.  C39 below completes the
remoteness/suspense follow-up; remaining mining is a selector-specific split over the
`c38-forced/*.forced.rows` / `c39-remoteness/*.remote.out` artifacts.  C50 and C30 remain
independent engineering/proof lanes.

Handoff note 2026-07-09 / Codex C39: added native `s4gremote` to
`notes/2026-07-06-grid-cap-solver.rs`, updated the S4 manual, ran it exactly on q=13 root, all 10
q=17 full-PGL S4 bucket roots, the two q=17 score-9 representatives, and optional q=19 root, and
wrote `notes/2026-07-09-codex-remoteness-probe.md`.  Main result: q=17 full corpus has max
remoteness 10, but only `19,710 / 1,537,648` states have remoteness at least 4 and only 105 attain
10.  Remoteness parity is the expected normal-play tautology (`P` even, `N` odd).  C31-style
`defxor` and zone size stratify average suspense but do not decide value or remoteness.  Verdict:
useful diagnostic, not a standalone dynamic monovariant; next mining should be selector-specific or
return to C30/C43/C44/C50.

Handoff note 2026-07-09 / Claude(Opus) C48: mirror-theorem harvest on classical varieties, all
steps done incl. Lean.  Added `rust/scripts/projcap_mirror_harvest.py` (honest form construction of
each board, exhaustive cap solves, involution + C27 pair-extension gates), wrote
`notes/2026-07-09-codex-mirror-harvest.md`, and landed
`lean/ProjectiveCap/HyperbolicQuadricMirror.lean` (imported from `ProjectiveCap.lean`; built via
`nix develop --command lake build ProjectiveCap.HyperbolicQuadricMirror`; axioms
`[propext, Classical.choice, Quot.sound]`).  New family: **`Q⁺(2m−1,q) = P` for every odd q, every
m ≥ 2** (`initialSubCapP_blockQuadric_of_odd_card`) via the C25 elliptic block mirror, which is a
factor-`δ` similarity of `Σaᵢbᵢ`.  General reusable proposition:
`initialSubCapP_of_fpf_collinearity_preserving` (fpf collinearity-preserving involution preserving a
sub-board ⇒ that cap/Nofil sub-board game is P; cap step reuses
`mirrorStepGood_of_collinearity_preserving` verbatim, only `Q x → Q (σ x)` is new).  Negatives
(mirror fails; outcome may still be P): `Q⁻(2m−1,q)`, `Q(2m,q)`, `H(2,q²)`, `H(3,q²)` — the
isometry group carries no fpf involution (machine witnesses + arguments in the report).  Trivial
rows: ovoids `Q⁻(3,q)` (free placement), `H(2,4)=AG(2,3)`.  See the Classical-Varieties subsection
under Closed Higher-Dimensional Families.  Next Codex/Claude lanes unchanged.

Handoff note 2026-07-10 / Codex C30: emitted anchored q=17 and q=19 Route-C certificate books under
`/tmp/c30-certs/` with `target/gridcap-c30`, then ran independent `certcheck`.  q=17:
`210/210` PASS, `1,009,758` nodes, `2,345,728` rows, escape histogram `5:30 10:120 11:60`, all
on-conic witnesses, no caps; anchored histogram is exactly 10x the canonical `5:3 10:12 11:6`.
q=19: `272/272` PASS, `7,601,462` nodes, `15,354,851` rows, escape histogram `211:272`, all
on-conic witnesses, no caps; full emission took `1:38:13`, peak RSS `867,612 KB`, and certcheck
took `0:09.76`, peak RSS `1,835,428 KB`.  Lean sample generation stayed in `/tmp`: q17 Base
compiled, but q17 `Class0.lean` failed after `31:23.21`, peak RSS `11,914,984 KB`, at
`class0_nodeChunks_check` with `maxRecDepth` in the aggregate chunk `simp`.  No q17/q19 Lean data
was committed.  Next C30 step is to refactor the generated checker proof shape before attempting
q17/q19 Lean assembly; otherwise move to C43/C44/C50 or the steering-proof lanes.

Handoff note 2026-07-10 / Codex C30 Lean split: refactored `ProjectiveCap.CertCheck` and
`notes/2026-07-08-q13-split-to-lean.py` so generated certs use indexed child references
(`RowRefData`/`StepRefData`), one-node semantic step chunks, 10-node subgroup aggregation, and
separate `ClassNBase` / `ClassNStepGroupM` / `ClassN` modules.  Flat q17/Class0 validation under
`/tmp/c30-flat-q17-v9` passed: `Base.lean`, `Class0Base.lean`, all 15 `Class0StepGroup*.lean`
leaves, and the top `Class0.lean` compile with `choom -n 1000 -- lean`; no q17/q19 generated Lean
data was committed.  Next C30 step is full q17 split generation/build with leaves first and
aggregate last; q19 remains a sizing/user-launch decision after q17 is clean.

Handoff note 2026-07-09 / Codex C54: added `s4pncheck`, documented its early-break reply-book
contract, and ran the complete 22-root q=23 suite with `scripts/s4-c54-check-suite.sh`.  Every one
of the `241,627,613` raw records was reached and checked; all 22 P roots passed with zero missing
P-row children, bad terminal labels, value-equation failures, or unreachable records.  Aggregate
wall was `4,077.68s`, peak RSS `371,836 KB`.  Report:
[`../2026-07-09-codex-q23-bucket-certification.md`](../2026-07-09-codex-q23-bucket-certification.md).
Next independent lanes are C43/C44/C50 or the C30 generated-checker refactor.

Handoff note 2026-07-09 / Codex C65: added native `s4zcensus` to the grid-cap solver and its S4
manual, measured the complete q=23 `[1,2,3,8]` selected corpus and complete `[1,3,4,9]`
maintenance-approved corpus, screened 25 seeds in each other bucket, and independently reproduced
the Z=40 extremum with the original Python C31 recursion.  The full-C31 result is deliberately an
interval, `40..136`, because all P replies were not value-enumerated.  The extremum pays immediate
zone 40 but has child Z=7.  Next open-core route is C63 amortized-potential LP/dual (C62 remains the
cheap selector-library precursor); the bounded small-Z route is now terminal-layer support rather
than the primary invariant.

### 2026-07-10 dated Handoff Notes

Why archived: settled 2026-07-10 session notes (C30 build-sizing, C44 bucket cross-check, C55/C64/C69 config-mechanism closes, C61/C62/C63 selector iteration, Fable steering corrections, PG(4,3) doc sync); residue condensed into the live handoff digest.

2026-07-10 C62 (Codex): added exact `s4selectors` full-expansion traversal, bottom-up random-play
rho, 17 selector families/hybrids, exact P/Delta-Psi tie scoring, and rho failure TSVs. Pure rho is
perfect at q=13 but has 651 q=17 and 11,345 q=19-root value misses, mostly at plies 4--6; no
geometric family improves it or merits a character-sum handoff. Selector-independent decreasing-Psi
existence passes every q=13/q=17 obligation and all 2,622,214 obligations in the exact q=19 root.
The existing q=23 witness logs give 5,487/5,734 strict Psi decreases, but cannot score exact rho
without a full Grundy dump. Next open-core task: C61 on the localized rho failure automaton.

2026-07-10 C63 (Codex): added exact `s4potential` transition extraction and
`s4potentialprobe`, fitted the declared feature span with SciPy/HiGHS, rejected the circular v1
depth-only solution, and obtained the four-term integer Psi candidate above.  Full exact integer
replay has zero failures at q=13/q=17; the q=13-only geometric fit had 71 q=17 transfer failures,
which drove the cross-column refit.  No infeasibility dual was needed, but the script implements
the sparse Farkas certificate path.  Solver checkpoint including the prior C65/C38/C39 diagnostics
was committed as `fd8dc1e`; C63 report/script/manual/queue updates remain the session's follow-up
change.  Next open-core move: score C62 selector families by `Delta Psi < 0`, then use Psi as C61's
state charge if a geometric selector covers every obligation.

2026-07-10 C30 continuation (Codex): anchored q17 Lean closure is no longer the preferred route.
The checker optimizations cut the representative leaf from ~6:55 to ~3:00 but not enough for
210 anchored classes.  Generated/checked canonical q17 instead (`21/21` classes, `100,526` nodes,
`232,221` rows), added Lean coordinate-swap/grid-symmetry composition support, and extended the
split generator with `--assembly-mode canonical`.  The generated canonical assembly stub-checks in
21.8s.  The remaining barrier was `ClassNBase`; moving node-cap proofs into
`ClassNNodeGroup*` leaves made real q17/Class0 timings viable: `Class0Base` 0:53.89,
`Class0NodeGroup0` 0:43.63, `Class0StepGroup14` 2:57.48.  Next: run a leaf-first full q17
canonical build from the v5 split (`Base`, all `Class*Base`, all node/step leaves, class tops,
`Q17`, `Q17Assembly`) and check the final axiom profile.

2026-07-10 C55 + C64 (Claude): closed both direct mechanism candidates for the arc-depleted-orders
dichotomy — the load-bearing unknown of the (ON) route — **both NEGATIVE**, run in parallel while
Codex held Cluster 2 (C62/C63).  C55 (group-side, d-lattice side-switch): added
`rust/scripts/c55_side_switch.py` + `c55_intruder_skeleton.py`; H-side-switch shows no differential
between the 119 flipping configs and matched controls on either the abstract C18 involution-product
dictionary or the actual legal-intruder secant skeleton, and the within-order test reverses the
prediction (q=11 N children carry MORE secants than P).  C64 (extremal-side, completion poset,
delegated + verified): added `rust/scripts/c64_completion_poset.py`; no completion-spectrum property
satisfies the constant-within/differ-across discipline while separating flip from control, and
`has_odd=has_even=True` universally means the value lives in the full tree, not the terminal layer.
Commits `9d2f796` (C55), `185c7a4` (C64).  **Consequence:** C56 stays closed-gated (needed a C55
positive); **S1 (Segre envelope invariants) is promoted as C69** — the algebraic-geometry-side
candidate is now the only Cluster-1 lever standing.  Next Cluster-1 move: C69, which must explain
*why the same integral configuration changes value across q* (the degree of freedom C55's static
group data and C64's terminal-layer data both lacked).

2026-07-10 C69 / S1 (Claude): ran the promoted algebraic-geometry mechanism and it is also
**NEGATIVE** — added `rust/scripts/c69_envelope.py`, commit `8ac7e60`.  The tangent envelope is
provably non-discriminating; the genus-2 hyperelliptic trace `a2` of the 6 branch points, the
residual tangent/secant partition, and χ of Igusa-flavored resultants all fail the flip/control
discipline.  The only near-hit (`a2=0` for all N-flip configs at q=11; `(0,−4,0,−4)` for the two
distinct NPNP double-flips) is a q=11 small-field artifact that dissolves at q=17 — the identical
failure shape as C64's count-parity near-hit, and a recurring lesson: q=11 is the smallest
arc-depleted order and its two/three-valued invariants land on the value "by luck," then disperse as
q grows.  **All three configuration-level dichotomy mechanism candidates (C55/C64/C69) returned
NEGATIVE on the tested families.**  Record this as "no *static* config→value dictionary **found**
among the tested families; mechanism search DE-PRIORITIZED in favor of A5" — *not* "no dictionary
exists."  Two scope limits keep it a "not found": (i) every discriminator was tested only at
q ∈ {11, 17} vs {13, 19}, so an invariant that separates only at a larger arc-depleted order would
have been invisible; (ii) both near-hits were q=11 small-field artifacts that dissolved at q=17,
which validates the discipline but exposes how thin the two-order corpus is.  All three tested
*static* invariants; the untested angle is a *dynamic* discriminator — and Ψ (the C63 amortized
potential) postdates all three, so per "levers compound" it is worth a flip/control trajectory probe
before A5 starts cold.  The (ON) uniform lower bound now engages the q-dependent **A5 arc-depletion
arithmetic** directly; note A5 *is* still the dictionary question, answered q-dependently rather than
by a config-side invariant.  **Re-entry condition:** reopen Cluster-1 mechanism hunting only if A5
names a concrete quantity to test as a config invariant, a larger arc-depleted order (q ≥ 23) widens
the corpus, or a Ψ-trajectory discriminator separates flip from control.  No fourth static candidate
is queued.  The live (ON) levers are Cluster 2 (open-core / amortized-potential, Codex) and A5.

2026-07-10 Fable steering corrections applied (Claude): the day's Fable-model review of the 07:00–09:00
work returned three corrections (proceed on all lanes, no re-route); all three applied.
(1) **Softened the Cluster-1 close** in this handoff + the task queue — "no *static* config→value
dictionary *found*, mechanism search DE-PRIORITIZED for A5," not "does not exist"; added the two
scope limits (tested only q ∈ {11,17} vs {13,19}; both near-hits were q=11 artifacts) and an explicit
re-entry condition.  (2) **Held-out q=19 Ψ replay** (Fable's overfit gate) — froze the q13+q17-fit
integer Ψ and replayed it against the exact q=19 root under the *fixed C31 selector* (`s4potential`),
not C62's existence quantifier: **2,622,202/2,622,214 strict decreases, 12 failures**, all the same
single canonical ply-4 parent = exactly C62's 12 rho/ΔΨ split cases.  Verdict: Ψ is *not* overfit
(existence transfers — C62 already showed every q19 obligation has a ΔΨ<0 P reply), but the raw C31
selector does not transfer; geometrize Ψ, but the selector to prove ΔΨ<0 for is C61's automaton, and
its hard surface is these 12 (write-up appended to `2026-07-09-codex-potential-lp-dual.md`;
`rust/scripts/c63-q19-replay.py`).  (3) **Ψ dynamic flip/control probe** — added the convention-safe
solver mode `s4potentialprobecells` (fits+transports the conic from explicit cells; commit `4a32a80`)
and `rust/scripts/c69_psi_flip_probe.py`; **NEGATIVE** — Ψ's coupled features (defect/intruders/xor)
are identical flip vs control at every order, the only separations are the reservoir/zone *size* term
at the depleted order where controls are P and flips are N (the within-order N-vs-P value correlate
C55 already saw, not a cross-q mechanism), nothing survives on the value-neutral jump or at q_full,
and the 11/13 pair shows nothing.  The negative extends to the dynamic ledger; hardens A5-only
(`notes/2026-07-10-psi-dynamic-flip-probe.md`).

2026-07-10 C61 (Codex): finite-state reply-automaton quotient reported **NEGATIVE for the tested
state alphabet** (`notes/2026-07-09-codex-reply-automaton.md`; analyzer
`rust/scripts/c61_reply_automaton.py`).  Over the exact forced skeleton (q=9/13, all ten q=17
full-PGL roots, q=19 `[1,2,3,4]`), six q=17/q=19 conflicts remain even after full C36-style
normalized-coordinate refinement; every row is a genuinely forced node.  One pair switches from a
conic-emptying internal reply at q=17 to a non-emptying external reply at q=19.  No adversarial
replay was due because the table already conflicts.  Scope is precise: this refutes the tested
q-blind quotient, not every finite-state strategy.  Next refinement should add an order-sensitive
zone/interface orbit at those six pairs while retaining C63's `Psi` as the charge.

2026-07-10 C61/C63 q=19 hard-surface follow-up (Codex): extended `s4selectors --fail-out` to
separate existential family coverage from deterministic tie safety and replayed the frozen q=19
Grundy table.  The 12 fixed-C31 `Psi` failures at the single ply-4 parent all have an internal P
override with the same signature (`live_on=6`, three defect components, nonzero conic xor,
`Delta Psi=-42..-41`).  Seven simple families contain such an override in all 12, so no new
candidate family is needed; however, none is tie-safe on all 12.  `psi_min` is safe on 8 and
`zero_xor_live_min` on the complementary 4.  The remaining exact target is one geometric tie
coordinate (start with the embedded zone-conflict orbit), not a broader selector search.  Report:
`notes/2026-07-10-codex-q19-psi-selector-hard-surface.md`; analyzer:
`rust/scripts/c61_q19_hard_surface.py`.

2026-07-10 C61 tie-coordinate resolution (Codex): the candidate's sorted local conflict-ray
profile in the live off-conic zone graph supplies the missing q=19 coordinate.
`zero_live_ray_lex_max` is deterministically safe on all 12 hard rows (first tested family to pass).
Full exact replay prevents promotion: across five q=13 roots, ten q=17 roots, and the q=19
`[1,2,3,4]` DAG it increases `all_psi` substantially but decreases `p_hit`; the first counterexample
is already a q=13 ply-4 root where lexicographic maximization selects an N reply over a P reply.
Verdict: **local positive / uniform negative**.  The tie surface is closed, but this is not a
q-blind winning selector or `Good`-closure; no broader feature search follows from it.  Details and
reproduction are appended to `notes/2026-07-10-codex-q19-psi-selector-hard-surface.md`.

2026-07-10 C63 post-C61 route audit (Codex): the suggested “v1 with post-repair descent depth” was
already executed in C63 Round 1 and returned the proof-circular exact-strategy coordinate
`Phi=descent_depth`.  No repeat LP is due.  Two-pair amortization also cannot rescue the new ray
selector: its minimal q=13 root failure moves immediately to an exact N-position, so the adversary
wins before any later recovery line.  Keep `Psi` as the proof-admissible charge, but reopen C63 only
after a value-blind selector maintains the candidate Good class or a genuinely new non-oracle
coordinate appears.  The correction is appended to `2026-07-09-codex-potential-lp-dual.md`.

2026-07-10 C59: ran the arc-stability import lane independently of the Cluster-2/C61 work. Added
`rust/scripts/c59_arc_stability_check.py` and
`notes/2026-07-10-codex-arc-stability-import.md`; marked C59 REPORTED in the queue and added the
Recently-reported bullet above.  Deliverable: every residual-game terminal is the full conic or is
at most the exact applicable integer arc-to-conic bound `B(q)`.  The required existing-data gate
passes at q=11,13,17,19, and the sourced spectra agree at q=23,27,29.  The C47 package now contains
the terminal-band row.  Kestenband is recorded at its verified strength: existence of a non-conic
arc, whose maximal extension lies in an explicit interval; no exact second-largest value at q=25 or
q=31 is inferred.  The result is a terminal constraint, not a `Good`-closure or a value theorem.

2026-07-10 C30 full-build sizing gate (Codex): counted 326 node-check and 326 step-check leaves in
the v5 q17 canonical tree and compiled two fresh representative node leaves (`0:55.51` and
`0:56.18`, about 2.6 GB RSS each). Together with the real representative step-leaf timing
(`2:57.48`, 4.87 GB RSS) and class-base timing (`0:53.89`), the sequential build projects above
21.5 hours before class tops/assembly. This exceeds C30's explicit ~10 h per-q stop gate, so the
full build was not launched. No repository Lean data was written; next action is an explicit user
launch decision or a further checker/build-shape reduction.

2026-07-10 C44 bucket-2 cross-check (Codex): the 4 GB `s4arena` run filled at 214,748,361 entries
on q25 bucket 2 `[1,2,6,17]`, but chunked `s4xormine` closed it: all 329/329 legal first moves have
an exact P-valued reply, with zero no-candidate/no-hit/abort rows across a disjoint interval cover.
Thus bucket 2 is P by the root game equation and C53 full-PGL transport. Together with Claude's
arena labels for buckets 0 and 1, q25 now has at least 3/28 buckets labeled, all P. Details and
verbatim boundary summaries are in `2026-07-09-codex-q25-baer-census.md`.

2026-07-10 PG(4,3) documentation sync (Codex): propagated C43's exact **`PG(4,3) = P`** result
through the canonical handoff, D1 manuscript skeleton, repo work summary, stepping-stone proposal,
task queue, and the C32/C43 reports.  Current wording now distinguishes the failed C32 mirror
policy from the P board outcome, records the 25,258-state independently cross-checked solve, and
keeps the higher-even-dimensional odd-field family correctly open beyond this first datum.

## 2026-07-11 C77 (Claude, lane C / Cluster-2) — amortized-bank reservoir artifact + defect≤q−5 sublemma

**The amortized-bank "debt growth" is a reservoir bookkeeping artifact, not the game getting harder —
and the fix is a clean uniform lemma.** Two new solve-free instruments (`s4ledger --pv`, `s4spike` in
`notes/2026-07-06-grid-cap-solver.rs`). (1) The minimax bank debt is a *single first-intrusion spike*
(Ψ rises only at ply5, monotone after); the first probe's "flat 22 through q19" was an artifact of
q17/q19 being the only orders whose Ψ-envelope peaks at the first intrusion — the raw envelope actually
grows (22/22/65/71/≥98/≥142 across q17/19/23/25/27/29). (2) The growth is *entirely* the C63
`reservoir_slack` term `f5 = zone_v − reservoir_floor`, whose loose Hall floor `(q−k)(q−k−C(k,2)−1)`
melts to 0 with depth and releases raw support into Ψ. Capping `f5` by the move budget `(q+1)−k` cuts
the debt ~10×; dropping reservoir entirely (`6·defect − 4·intruders − 2·[xor]`) gives **debt 0**
through the checked depth. (3) Why: `max_defect_excess = 0` at every order — `defect_components ≤
defect_root = q−5` for every reachable state, so `DROP ≤ 6·defect_root = DROP_root + 2`. **Reshaped
lever:** drop the reservoir summand; the concrete on-box, reservoir/Hall-free sublemma is
`defect_components ≤ q−5` for all reachable residual states. **Two crux caveats:** DROP is not a
per-edge Lyapunov (defect-recovery jumps grow 8→34 but stay below root), and a peak-bound is **not yet
a P-certificate** (the real remaining crux). **Cheap cross-lane lead:** both live lanes now hit the
same `q−5` (A5 `maxonN ≤ q−5`; `defect_root = q−5`) — check whether they are one object before more
probes. Report:
[`../../2026-07-11-c77-ledger-spike-structure.md`](../../2026-07-11-c77-ledger-spike-structure.md)
(§6–8); first probe
[`../../2026-07-11-c77-ledger-bank-probe.md`](../../2026-07-11-c77-ledger-bank-probe.md).

## 2026-07-11 C75 (Claude, lane C / Cluster-2) — value-blind selector impossibility

**The value-blind reply selector is impossible in the program feature space** — a structural
explanation of Codex's C61/C62/C63 "every selector family is uniform-negative" wall. Reusing the
on-disk exact Grundy dumps (no re-solve), dumped every legal reply's full value-blind feature vector +
Grundy label at the hard root-frame obligations of the q=13/17/19 root DAGs and asked whether any
function of the features picks a winning reply everywhere. **19 of 108 hard obligations contain a
winning (P, ΔΨ<0) reply and a losing (N) reply that are byte-identical on all 17 features** {geom,
live, comp, xor_zero, Ψ, ΔΨ, χ, polar, ray-profile} — a superset of every coordinate the selector
families use. Verified witness (q=13, opp `11,0`): P `6,6`(g0) and N `12,3`(g2) identical on every
feature. Consequences: (i) the wall is feature-*completeness*, not coordinate-choice — no selector
(linear or nonlinear) over these invariants wins; (ii) an **order-sensitive** rule does not escape it
(every twin is within a single q); (iii) the feature map is Stab-invariant but not orbit-injective
(collapses a P-orbit onto an N-orbit); (iv) the deficit **grows with q** (6% → 7% → 39%), so it is
structural and worsening, the opposite of the C64/C69 small-field near-hits. **Named next step:** any
winning selector needs a strictly finer PGL-invariant coordinate; the 19 witness pairs are the
concrete design target. This also re-weights the (ON) route toward the **amortized/ledger** potential
(a bank tolerating ΔΨ≥0), since a pointwise winning selector over the present invariants is ruled out.
A correctness fix was load-bearing: the stock `root_replies` dump omitted χ/polar (naive check
reported 82 false twins; true count 19 with them added), so the solver's `root_replies` emitter was
patched to carry them. Report:
[`../../2026-07-11-c75-value-blind-selector-impossibility.md`](../../2026-07-11-c75-value-blind-selector-impossibility.md);
script `rust/scripts/c75_linear_selector_lp.py`; solver `gridcap-c75`.

## 2026-07-11 arc-depletion-arithmetic probe (Claude, lane A, delegated + verified)

Tested whether an arc-theoretic invariant of `PG(2,q)` characterizes the depleted set `{11,17}` (C68's
open margin question). **No arc invariant fits** — `m'(2,q)` (Ball–Lavrauw arXiv:1705.10940) and every
natural transform of it flag a *different* set ({7,9,11,13}, {9,13,17}, or {9,11}), never {11,17};
consistent with the value living in the game tree (C55/C64/C69 negatives). The only rule fitting all
nine tested orders (incl. the load-bearing undepleted q=23/25) is purely arithmetic and mechanism-free:
**q is a twin-lower prime with q−2 composite** (q, q+2 prime; q−2 composite) — the minimal repair of
the failed mod-6 rule. **Prediction: q=29 DEPLETED** (twin (29,31)); q=31, q=47 undepleted. Cheapest
positive test is q=29 — the census the program already wants (settles C68's min-witness margin 2→1→?).
But q=29 alone cannot separate twin-primality from a "≡5 mod 6 window-interior" null; only a **non-twin
≡5 mod 6 prime (q=47/53)** does (twin-rule says undepleted, residue says depleted). Flagged suspect:
twin-primality has no known link to PG(2,q) arc/oval structure — a 2-point correlate, presented as
falsifiable, not a proven mechanism. Report:
[`../../2026-07-11-arc-depletion-arithmetic-probe.md`](../../2026-07-11-arc-depletion-arithmetic-probe.md).

## 2026-07-11 C77 (Codex) — all-depth DROP peak proof; A5 cross-lane identification negative

Closed C77's pending on-box sublemma without a solve.  For any descendant `S` of a four-on-conic
root, `defect_components(S)` is at most the number of live conic vertices, hence at most `q−5`.
If an off-conic intruder exists, DROP's `−4·intruders` charge puts the value below the root; if none
exists and `S` is proper, another on-conic selection leaves at most `q−6` components.  At the root,
the `q−5` isolated vertices have xor zero because q is odd.  Therefore
`DROP(S) ≤ 6(q−5)−2 = DROP(root)` for every depth and odd q.  The q23 solve is not needed to settle
DROP debt zero.

The apparent A5 coincidence does not collapse the lanes.  `maxonN` is a class-extremal count of
game-value-N children; `defect_components` is a value-blind graph count on one chosen S4 root and is
always `q−5` at that root.  The only correspondence chooses a P child first, which assumes exactly
the desired (ON) conclusion.  C77's remaining residue is therefore game-semantic: a peak bound is
not a P-certificate.  Full proof and controls are appended in
[`../../2026-07-11-c77-ledger-spike-structure.md`](../../2026-07-11-c77-ledger-spike-structure.md) §9.

## 2026-07-11 C77 continuation (Codex) — game semantics localizes to C74 pencil absorption

After closing the value-blind DROP peak bound, tested the actual game-semantic residue. C61's generic
reply quotient stays blocked, and simple quadratic-character/order signatures of the C74 pencil
parameter fail across q=11/q=17. The positive result is an exact absorption target: every maximum
pencil at q=11/13/17/19 has at most `q−8` N-valued legal off-conic centers, with equality at q=17.
C74's `d≤5` then leaves at least two P centers, so a uniform proof would establish odd escape
directly rather than (ON).

The mandatory q=11 knife-edge base also compresses cleanly. Across its ten tied pencils there are
32 distinct P centers; every exact winning-reply graph has a perfect matching, and the 32 graphs have
only four isomorphism types (multiplicities 10/2/10/10). This is a four-type first-reply certificate,
not yet a uniform theorem: its edges use exact P/N values and matched followers still need recursive
books. New durable scripts and full audit:
[`../../2026-07-11-c77-game-semantic-reply-graphs.md`](../../2026-07-11-c77-game-semantic-reply-graphs.md).

## 2026-07-11 C77 continuation (Codex) — Low4 isolates the pencil absorption signal

The C74/C77 N-absorption target now has a concrete value-blind candidate family. On a maximum
(`min d`) pencil, order legal centers by the remaining off-conic support `zone_v` and include the
entire tie through the fourth center. Every `Low4` packet through q19 contains at least three P
centers. This is highly specific: q11 non-maximum lines fail 264/264, q17 non-maximum lines fail
1332/1344. The unique minimum-zone selector itself fails on six q13 and six q17 maximum pencils, so
the usable statement is set-valued, not pointwise.

Added solver mode `fanmoves` to solve an S3 fan once and list every S4 root's P children, plus
off-conic support in `s4potentialprobecells`. Tight q17 N centers have 4–16 P children, excluding a
unique forced-move mechanism. The open theorem is now: prove the maximum-pencil `Low4` packet
contains P (observed ≥3), which implies `Ncenters≤q−8` and hence odd escape.

## 2026-07-11 C77 continuation (Codex) — five-spoke collision reduction

Derived the exact geometry behind `Low4`. The S3 root has `(q−5)^2` legal off-conic extensions.
For a pencil center z, its five center-to-frame spokes are disjoint away from z, so their legal
off-conic loads give `zone_v=(q−5)^2+4−Σs_e`. Secant loads are `q−1−d_e` by C74; tangent loads are
`q−δ_e`, with `δ_e` the four-point chord-intersection count. Hence
`zone_v=q²−15q+34+Σδ_e−t`, `δ_e∈{4,5,6}`, `t≤2`. The durable probe verifies both formulas on all
2,876 maximum-pencil centers at q11/13/17/19.

Consequently Low4 is purely the fourth-order packet of a bounded five-term collision score. At the
six tight q17 pencils its layers are `24:1P`, `26:2P+2N`, `28:7N`. Equal score/tangency types can be
both P and N elsewhere, so the remaining assertion that Low4 contains P cannot be another scalar
classifier; it must relate the recursive games of multiple packet centers.

## 2026-07-11 C77 continuation (Codex) — balanced subtype and Baer-subline exception

The full spoke-defect vector isolates a sharper candidate: on a maximum pencil of primary collision
count d, centers of sorted type `(d,5,5,6,6)` are P in all 760 exact q11/13/17/19 occurrences.
A value-blind PGL orbit census finds this balanced type on every tested prime-field maximum pencil
for q=11 through 31. GF(25) supplies the necessary exception: for `A={0,1,2,3,4}` and each endpoint
`w=infinity`, all legal centers have type `(4,6,6,6,6)`. The six-set is the embedded
`P¹(F5)` and has stabilizer 120. Thus unconditional balanced-center existence is false. The refined
proof target splits into generic balanced-center existence/P-purity and a separate Baer/subfield
endpoint lemma; Low4 remains the uniform fallback. No Lean formalization should precede settlement
of that branch theorem, though the stable five-spoke incidence identity is ready later.

## 2026-07-11 C77 correction (Codex) — exact d=4 selector and two subfield families

The prior entry's unique-Baer interpretation was too narrow. Normalizing any d=4 pencil to
`A={0,±1,±x}`, `(e,w)=(0,∞)` gives four explicit rational side-collision parameters. A legal
parameter is balanced exactly when it is a singleton among those four and differs from the common
two-pair collision parameter. This formula has zero mismatches over every x in primes through 101
and GF(9/25/27/49/121/125/343). It finds two persistent empty-selector families: characteristic 5
at `x=±2`, and characteristic 7 at `x∈{±2,±3}`. GF(125) and GF(343) confirm both are inherited
prime-subfield configurations, the latter from the already separate q=7 geometry. The field-uniform
equality case split and the d=5 branch remain open; no Lean formalization is warranted yet.

## 2026-07-11 C77 continuation (Codex) — d=5 certificate ledger

Normalized the unique d=5 product collision to `A={0,1,r,s,rs}` and factored every nonprimary
spoke-collision equation. The resulting twelve explicit pairing certificates reproduce the exact
balanced parameters with zero mismatches on all maximum forms tested at q19/23/25/27/29/31/37/49.
A legal center is balanced exactly at certificate degree two. Every form has 2--4 such parameters
and obeys `T≥10`, forbidden certificate weight `F≤3`, `n1≤4`, and maximum legal degree two. Since
`T-F=n1+2n2`, these four bounds force `n2≥2`. Proving the four bounded algebraic inequalities is now
the complete d=5 geometric obligation.

## 2026-07-11 C77 continuation (Codex) — one d=5 ledger bound proved

Writing each certificate as a directed edge `f→g` exposes four exact quotient identities:
`C(1,r)=C(s,rs)`, `C(1,s)=C(r,rs)`, and their two reversals. Eight certificates therefore occur in
four equal pairs; only the four cross edges `1↔rs`, `r↔s` can be singleton labels. This proves
`n1≤4` uniformly. The d=5 obligation is down to three bounds: `T≥10`, forbidden weight `≤3`, and
legal degree `≤2`. Primary-d5 nonmaximum controls violate at least one of exactly these three, so
their algebraic proofs should construct the hidden d4 line from the forbidden pole/equality.
