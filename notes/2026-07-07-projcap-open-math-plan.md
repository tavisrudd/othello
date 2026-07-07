# Projective cap game — open-mathematics plan after the frame-reduction formalization

Date: 2026-07-07. Companion to `handoffs/2026-07-06-projective-cap-game-handoff.md` (sessions 1–6).
This note fixes what is settled, states the one open kernel precisely, and lays out the attack
routes with concrete next actions, so a fresh session can pick any route cold.

## 1. Settled (math and/or Lean)

| Result | Math status | Lean status |
|---|---|---|
| `PG(1,q)` trivial P; `PG(2,q)` q even = P (translation mirror on the residual) | proven (`2026-07-05-qeven-plane-theorem.md`) | not yet (see WP-2 below) |
| Frame reduction: `PG(2,q)=P ⟺ one frame position is P` | proven (`2026-07-06-frame-reduction.md`) | **DONE** — game half (`FiniteBuildGame.isP_empty_iff_isP_of_frame_chain`) + rank-3 geometry half (`ProjectiveCap/PlaneTransitivity.lean`: `CapTransitiveStatement 1..4`, `cap_extendable`, `exists_frame`, `initialPStatement_iff_isP_frame_of_finrank`) |
| Total lemma: every size-3 grid cap has exactly `q²−9q+21` legal extensions | proven all q | **DONE** (`ProjectiveCap/ExtensionCount.lean`) |
| Parity route: odd `q` + `bad` even ⇒ escape child exists; `OddEscapeGameStatement` follows from all-positions bad-evenness | proven; bad-evenness holds `q ≤ 9`, fails from `q = 11` | **DONE** (`ProjectiveCap/EscapeParity.lean`) |
| Outcome `P` for the whole computed ladder `q = 2,3,4,5,7,8,9,11,13,17,19` | computed, two independent solvers | certificates not yet formal (WP-3) |
| Single-involution mirrors (σ_c, antidiagonal, τ, σ_c·τ) | CLOSED — each fails at bounded q | n/a |
| Arc/area bound `bad = o(q²)`; boundary characterization "N ⟺ embeds in odd maximal cap" | CLOSED — `bad ≈ total` at q=17; converse fails q ≥ 11 | n/a |
| Exhaustive falsification | walled at `q = 23` on the 26 GB box (~×9 classes/step) | n/a |

## 2. The open kernel, precisely

For odd `q ≥ 11` (parity settles smaller q):

> **(ESC)** Every legal size-3 residual grid position `S₃` (3-cell partial-permutation affine cap
> in `F_q × F_q`) has at least one legal size-4 extension that is a P-position of the residual
> grid game — i.e. `escape(S₃) = total − bad = (q²−9q+21) − bad(S₃) ≥ 1`.

Formal name: `ProjectiveCap.Almost.OddEscapeGameStatement`. Via the frame reduction (ESC) for a
given q is equivalent to `PG(2,q) = P`. Known constraints on any proof of (ESC):

- It cannot be a fixed-involution mirror (all closed), cannot be naive parity (`bad` odd on a
  majority of classes by q=17), cannot be an area bound (`bad = 152` of `total = 157` at q=17),
  and cannot route through static arc-embedding (boundary characterization false from q=11).
- **It cannot maintain ANY symmetry invariant (added 2026-07-07):** no play-closed family of
  positions with nontrivial stabilizer exists for q = 11, 13, 17
  (`2026-07-07-resym-symmetric-family-dead.md`) — the winning strategy passes through
  stabilizer-free positions from size 6 on.
- min-escape over classes is **erratic**: `1, 7, 13, 13, 46, 5, 211` for `q = 5..19`. Whatever
  protects `escape ≥ 1` is a near-cancellation of two `Θ(q²)` quantities — the proof must produce
  a *witness cell*, not a size estimate.

## 3. Attack routes, priority order

### (A) Adaptive-strategy invariant — ~~the main proof bet~~ **CLOSED (2026-07-07, session 7)**
The resym experiment was run to full depth (`resym` mode in `2026-07-06-grid-cap-solver.rs`;
writeup `2026-07-07-resym-symmetric-family-dead.md`): the play-closed symmetric subfamily does
NOT exist for q = 11, 13, 17 — not for involutions (v0), not for ANY nontrivial stabilizer (v3,
whole automorphism group incl. Frobenius twists), not even filtered to true P-positions (v4).
Exhaustive verdict, not a sample (the reachable symmetric space is tens of states per q).
Witness at q=11, verified by the exact solver: from the transpose-symmetric P-position
{(0,0),(1,1),(2,3),(3,2)}, the break (4,9) has 5 winning replies — all 7 legal replies have
trivial stabilizer. The depth-1 "relaxed adaptive succeeds" was one-step-only; staying symmetric
is impossible from size 6. **No symmetry-shaped invariant can carry the uniform proof.** Route
(B) inherits "main proof bet" status; any strategy lemma will be certificate/potential-function
shaped, not `MirrorGood`-shaped.

### (B) Finer counting invariant — the main proof bet (was second; (A) closed 2026-07-07)
The total lemma's proof splits `total` as `(q−3)² − 3(q−4)` with per-pair-line traces of exact
size `q−4`. Hunt a refinement (mod 4, mod p, or weighted by pair-line incidence pattern) that
survives `bad` odd. Next actions: per-class regression of `escape`/`bad` against arc-geometric
features on the existing q = 11..19 data; test whether `bad` restricted to each pair-line trace
has an invariant parity/weight. Any such lemma slots into `EscapeParity.lean` alongside the
mod-2 version.

**PROGRESS (2026-07-07, session 8 — the CONIC LOCALIZATION):** full writeup
[`2026-07-07-conic-localization-onconic-escape.md`](2026-07-07-conic-localization-onconic-escape.md).
The principled per-class feature is the **unique conic through the projective 5-arc** (= the
Möbius graph `(r−ρ)(c−A)=B` through the 3 cells). Proven: all `q−4` of its non-`S₃` cells are
LEGAL extensions (refines the total lemma; the conic is itself an even maximal grid cap).
Empirical on ALL classes q=5..19: **(ON) `onP ≥ 1`** — the escape crux always has a witness ON
the conic (q=17 min-escape classes: the single surviving conic witness). (ON) ⟹ (ESC); the
open kernel is now **1-dimensional** (the conic parameter line). Dead ends closed: "on-conic ⟹
P" (fails q=11,17 though TRUE at q=5,7,9,13,19), product-point/symmetric-completion law (the
`t₄=tᵢtⱼ/tₖ` extensions = the ψ_u-symmetrizable S₄'s; existence fails at 4/21 q=17 classes),
any quadratic-character law on the conic (q=13 all-P vs q=17 1-of-13 is incompatible with any
fixed character formula), off-conic escape parity (fails q=13). Tool: `feat` mode in
`2026-07-06-grid-cap-solver.rs`.

### (C) Per-q Lean certificates — guaranteed formal value
The computed ladder `q = 11..19` can be made machine-checked without new mathematics: for each
canonical size-3 class, emit a witness escape cell plus a P-certificate of the size-4 child
(bounded reply tree — game depth from size 4 is at most the max cap size, branching collapses
fast). `FiniteBuildGame.NCert`/`PCert`/`PairReplyBook` already exist as the target format; orbit
transport uses `win_map`. Deliverable: `OddEscapeGameStatement (K := GF(q))` as a theorem for
each computed q. This also forces the certificate format a general proof would instantiate.
(Emission side: a `cert` mode in `2026-07-06-grid-cap-solver.rs`.)

### (D) Falsification continuation — opportunistic
q = 23 needs a > 17 GB arena or a tighter canonical key. Watch **min-escape**, not min-dev-size:
the crash to 5 at q = 17 is the live danger signal; if any class ever hits 0 the conjecture is
false and (A)/(B) pivot to characterizing the counterexample. Cheaper than full solves: enumerate
size-3 classes only, compute `bad` via the boundary game (size-4 subtree solves), extremal-class
extrapolation before whole-game enumeration.

### (E) The `m ≥ 3` lift — after the plane
Plane-first decomposition through the opening line; Sprague–Grundy aimed at `m ≥ 3` (in-plane
decomposition is dead: every pair of points is collinear with a third). The q=2 column imports
from the F_2^{m+1} sum-free solver. Blocked on the planar theorem; do not start here.

## 4. Lean work-package queue (in order)

- **WP-1 Frame⇄grid bridge.** The projective layer (`Projective.InitialPStatement`, frame
  reduction) and the residual grid layer (`GridGame`, `OddEscapeGameStatement`) are formally
  disconnected. Formalize the opening-pair reduction (R2 of the handoff): after the opening pair,
  the projective cap game on the residual is isomorphic to the grid game (burned rows/cols = the
  two directions). Deliverable: `IsP frame ↔` a grid-game statement, composing with
  `initialPStatement_iff_isP_frame_of_finrank` to give
  `InitialPStatement ↔ (grid escape statement)`. This is the largest remaining structural gap.
- **WP-2 q-even theorem in Lean.** Char-2 translation mirror on the grid residual: `τ_v`,
  `v` off both burned directions, is an fpf cap-preserving involution; the `MirrorGood` /
  `isP_of_replyStrategy` machinery from `CapGame/Affine.lean` transfers nearly verbatim to
  `GridGame`. With WP-1 this yields formal `PG(2,q) = P` for q even — the first full projective
  outcome theorem in Lean.
- **WP-3 Certificate checker for (C).** `NCert`/`PCert` instantiation at `GF(q)` + a small
  elaborator-friendly certificate format emitted by the Rust solver.
- **WP-4 PGL packaging (optional polish).** `mapEquiv` currently packages `V ≃ₗ[K] V`; a
  `MulAction`-based restatement via mathlib's `Projectivization.Action` would align with
  upstream, but nothing downstream needs it yet.

## 5. Recommended next session

~~Math: start (A)-1/2 (the resym-mode experiment)~~ **DONE 2026-07-07 — negative; (A) closed.**
~~Math: route (B) — per-class regression of `escape`/`bad` against arc-geometric features.~~
**DONE 2026-07-07 session 8 — the CONIC LOCALIZATION + (ON)** (see the PROGRESS block under
route (B)): the crux witness is on the unique conic through the 5-arc in all computed data; the
kernel is now 1-dimensional. Next math: attack **(ON)** on the conic parameter line — the
6-point configuration `{0,∞,t₁,t₂,t₃,t₄}` on `P¹` mod the `{0,∞}`-stabilizer; any candidate
must explain q=13 (all q−4 conic extensions P) vs q=17 (classes with exactly 1 of 13) without
a fixed character formula (ruled out). Route (C) per-q Lean certificates is the parallel
guaranteed-value track; the conic localization lemma is itself a new Lean-shaped target next to
`ExtensionCount.lean`. Route (D) falsification got cheaper: per-S₃ subtree solves could push
the (ON)/escape table to q=23 without the global arena (blocked on the box until the G(17)
nimber run frees RAM).
Lean: WP-1 (frame⇄grid bridge), then WP-2 (q-even theorem) — both are closed-form formalization
tasks with no open-math risk.
