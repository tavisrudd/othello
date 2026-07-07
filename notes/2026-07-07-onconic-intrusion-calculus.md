# (ON) attack, session 9 (F2): the intrusion calculus on the conic

**Date:** 2026-07-07 (Fable F2 block, time-boxed). Route (B) continuation of
[conic localization](2026-07-07-conic-localization-onconic-escape.md). Outcome: **(ON) is now
PROVED for q = 5 and q = 7** (previously empirical), the on-conic subtree is uniformized (its
value is an invariant of a 6-point subset of `P¹` mod the full `PGL(2,q)`), the one-intruder
structure is solved exactly (a parity formula, machine-verified), and the remaining hard core is
isolated as a precise obstruction statement (§6). Verifier:
[`2026-07-07-onconic-intrusion-check.py`](2026-07-07-onconic-intrusion-check.py) — all claims
green for q = 7 (exhaustive), q = 11 (exhaustive), q = 13 (60-config sample); zero failures.

## 1. Uniformization: the grid game is the arc game, and a,b are not special

Since rows are the lines through `b = (0:1:0)` and columns the lines through `a = (1:0:0)`, a
grid position `S` is legal iff `S ∪ {a, b}` is an arc of `PG(2, q)`, and a cell is a legal move
iff it extends that arc. So the grid game **is** arc-building on `PG(2, q)` from the pre-played
pair `{a, b}`: positions = arcs containing `{a, b}`, terminals = complete arcs through `{a, b}`
minus the pair, and the grid parity of a terminal is the parity of the complete arc's size.
(Odd maximal grid caps — the parity-defect seeds of the whole program — are exactly the odd-size
complete arcs through 2 points, i.e. by 2-transitivity of `PGL(3,q)` on arcs' point pairs, all
odd-size complete arcs up to projectivity.)

Consequences for an **on-conic** `S₄` (kernel (d): `S₄ ⊂ 𝒞_aff`, so the played set
`S₄ ∪ {a, b}` is six points ON the conic `𝒞`):

> **Lemma I.** The subtree (hence the game value) above an on-conic `S₄` depends only on the
> 6-point subset `{∞, 0, t₁, t₂, t₃, t₄} ⊂ P¹(F_q)` of conic parameters **up to the full
> `PGL(2, q)`** — not merely up to the `{0, ∞}`-stabilizer.

*Proof.* The subtree is determined by the played arc up to `PGL(3, q)` (collineations commute
with the rules; `a, b` enter only as played points). A collineation matching two such 6-point
arcs maps the conic through the first (unique through any 5 of the points) to the conic through
the second, hence identifies the two conics; the stabilizer of a conic acts on it as
`PGL(2, q)` on `P¹`. ∎

This collapses the (ON) witness search beyond the working note's formulation: the witness
values live on 6-subsets of `P¹` mod `PGL(2,q)` (moduli: 3 cross-ratio-type parameters), and
distinct size-3 grid classes can share on-conic child values. **Falsifiable consistency
prediction (delegated as C5):** in the q = 17 feat data, any two on-conic S₄'s whose 6-point
parameter sets are `PGL(2, 17)`-equivalent must have the same game value.

## 2. The free conic, and intruders as involutions

> **Lemma II (free conic).** At any position whose played set lies on `𝒞`, every unplayed cell
> of `𝒞_aff` is a legal move. (Rows/columns: `𝒞_aff` is functional; collinearity: a line meets
> `𝒞` in ≤ 2 points — and this includes the row/column constraints, since those are the secants
> through the played conic points `a, b`.) Hence if both players play only conic cells, the game
> is a pure move-counter: from `c` played conic points it lasts exactly `q + 1 − c` further
> moves and ends at the full conic (grid size `q − 1`, even, a maximal position).

An off-conic move `x` ("intruder") interacts with the conic through the classical projection
involution: for `x ∉ 𝒞`, define `σ_x : 𝒞 → 𝒞` by `σ_x(p) = ` the second intersection of line
`xp` with `𝒞` (`= p` when `xp` is tangent). For `q` odd, `x` lies on `τ_x ∈ {0, 2}` tangents
(`2` = external point, `0` = internal), and `σ_x` is exactly the involution of `PGL(2,q)` on the
parameter line whose fixed points are the `τ_x` tangency parameters. **The ψ_u involutions of
kernel (d) are the special case `x ∈ line ab`** (an involution swaps the parameters of `a, b`
iff its center lies on the secant `ab`); those centers are dead cells, which is why ψ_u acts as
a pure symmetry rather than a move.

> **Lemma III (one-intruder structure; machine-verified).** Let the played set be `c` points on
> `𝒞` (for the (ON) setting, `c = 6`) and let `x` be a legal off-conic move with `τ_x`
> tangencies of which `τ_played` touch played points. Then:
> 1. `σ_x` maps played conic points to unplayed ones (else `x` sits on a played secant and is
>    illegal); the surviving conic cells are `R' = R \ σ_x(played)`, `|R| = q + 1 − c`.
> 2. `R'` decomposes under `σ_x` into full 2-cycles ("pairs") and fixed tangency points
>    ("singletons") — no orphaned half-pairs. Playing one cell of a pair kills exactly the other
>    (their secant passes through `x`); singletons kill nothing; cross-pair interaction requires
>    a second intruder.
> 3. If play stays on the conic thereafter, the number of remaining conic moves is
>    `M = #pairs + #singletons = (q + 1 − 2c + τ_x)/2` — **independent of the position of `x`
>    beyond its tangency type**, and independent of `τ_played`.
> 4. A legal intruder must satisfy `τ_x ≤ 2·τ_played + (q + 1 − 2c)` (the images in (1) need
>    room inside `R` minus its tangency points). In particular for `2c = q + 1` only internal
>    points or external points with a played tangency can intrude, and for `2c > q + 1` no
>    intrusion with `τ_x = 0` and `τ_played` small exists at all — the count form of the top-gap
>    bound: any arc with an off-conic point carries at most `(q + 3)/2` conic points.

*Proof sketch.* (1) legality; (2) a widow's partner is played, making the widow illegal, so
widows are already excluded from `R'`; secants between two conic points contain no third conic
point, so pairs only interact through intruders; (3) count `|R'| = (q + 1 − c) − (c − τ_played)`
and `#singletons = τ_x − τ_played`, then `M = (|R'| + #singletons)/2`; the `τ_played` terms
cancel. (4) the `c − τ_played` images are distinct unplayed non-tangency points. Every claim,
including the exact kill-set `σ_x(played)`, verified with zero failures: q = 7 and q = 11
exhaustively (all C(q−1, 4) on-conic S₄ × all legal intruders), q = 13 sampled; the verifier
also confirms the intrusion census respects (4) — the type `(τ_x, τ_played) = (2, 0)` is absent
at q = 11 (`q + 1 − 2c = 0`) and present at q = 13. ∎(machine)

## 3. Theorem: (ON) holds for q = 5 and q = 7

> **Theorem IV.** For `q ∈ {5, 7}`, every legal size-3 grid position has a P-position size-4
> extension on its conic; in fact **every** on-conic size-4 position is P.

*Proof.* By Lemma III(4) with `c = 6`: a legal intruder needs `τ_x ≤ 2τ_played − (11 − q)`.
For `q = 5`: `τ_x ≤ 2τ_played − 6 < 0`, impossible. For `q = 7`: `τ_x ≤ 2τ_played − 4` forces
`τ_x = 2, τ_played = 3+` — but `τ_played ≤ τ_x ≤ 2`: impossible (confirmed exhaustively: all 15
on-conic S₄ at q = 7 have zero legal off-conic cells). So the subtree above any on-conic `S₄`
is conic-only; by Lemma II it is a bare counter of `q + 1 − 6 = q − 5` moves — even for odd `q`
— ending at the maximal full conic. The mover at `S₄` therefore makes the game's last move
never: with `q − 5` moves remaining and alternation, the opponent of the mover makes the final
move. Hence `S₄` is a P-position. Every size-3 position has `q − 4 ≥ 1` on-conic extensions
(kernel (d), Theorem 9), all P. ∎

(For `q = 5` the on-conic `S₄` is already the full `𝒞_aff` — terminal, even — recovering the
unique-escape datum `min-escape = 1`. For `q = 7` this proves the observed `onP = q − 4 = 3` in
every class.) Both cases were previously known only by exhaustive computation; this is the first
proved instance of the (ON) mechanism. `q = 9` is within reach of the same calculus: Lemma
III(4) confines intruders to external points with both tangencies at played points — at most the
15 pairwise intersections of the 6 played tangent lines, and after any such intrusion `M = 0`
(the conic is dead), so the residual is a tiny intruder-only game; this reduction is a candidate
per-q certificate but was not pushed in the time-box (q ≤ 9 already has the parity proof).

## 4. What the parity formula says — and does not say

After one intrusion the conic-only continuation from the mover's seat is won by the mover iff
`M = (q − 11 + τ_x)/2` is odd (`c = 6`): with `q ≡ 1 (mod 4)` iff `x` is internal, with
`q ≡ 3 (mod 4)` iff `x` is external. So the intruder's *tangency type* is a parity switch the
attacker chooses — P1 will intrude with the type making `M` even, and any (ON) defense must
answer with a second intrusion or exploit the intruder zone. **One-intruder parity therefore
cannot decide (ON) by itself**, and the data confirms it must not: `onN > 0` occurs at
`q ∈ {11, 17}` and `onN = 0` at `q ∈ {13, 19}`, which straddle both residues mod 4.

## 5. The multi-intruder hard core

With two intruders `x, x'` the surviving conic cells must be free in *both* involutions; the
joint structure is the orbit partition of the dihedral group `⟨σ_x, σ_{x'}⟩`, governed by
`ord(σ_x σ_{x'})`, a divisor of `q ± 1` (rotation subgroups of `PGL(2, q)`). Each further
intruder overlays another involution, and the intruders themselves must form an arc avoiding
played secants (their zone shrinks quadratically). Endgame termination = every conic survivor
dead and the intruder arc complete; reaching it needs `Θ(√q)`-many intruders (each kills at most
`played`-many conic points; complete arcs have size `Ω(√q)` — Lunelli–Sce, and probabilistically
`O(√q log^c q)` suffices, Kim–Vu), so the dangerous lines of play are long and genuinely
game-theoretic — consistent with the failure of every static/boundary characterization from
q = 11 on.

## 6. Precise obstruction statement (the F2 deliverable)

> **(ON) reduces to the intruder calculus.** For a 6-subset `T ⊂ P¹(F_q)` mod `PGL(2, q)`
> (Lemma I), the position is P iff the mover has no winning intrusion (conic moves preserve the
> class structure and only shift the counter). A first intrusion `x` is winning iff, in the
> residual game — state: the pair/singleton structure of `R'` under `σ_x` + the intruder-zone
> arc — the mover-after-`x` loses. (ON) states: every 5-subset extends to a 6-subset `T` with
> no winning intrusion. The one-intruder layer is solved (Lemma III: parity `M`, existence
> constraint); **the open core is the two-plus-intruder residual, whose state is the orbit
> structure of products of conic involutions — arithmetic of the divisors of `q ± 1`.** This is
> the first structural bridge from the game value to the arithmetic of `q`, and it is exactly
> where the observed erraticness (onN at 11, 17 but not 5, 7, 9, 13, 19; escape-margin swings;
> character-law failures) can enter: those laws are functions of the 6-subset only, while the
> residual depends on element orders in `PGL(2, q)`.

Attack options it opens (next sessions): (i) classify winning first intrusions at q = 11, 13,
17 by their `(τ_x, τ_played)` type and `ord(σ_x σ_{x'})` census against the feat values — if a
small invariant of the residual decides them, the per-q certificates (route C) compress
enormously; (ii) prove a "second-intrusion answer" lemma — after P1's parity-fixing intrusion,
P2 intrudes to restore `M`'s parity and pair the intruder zone — the candidate uniform
mechanism, now with exact bookkeeping available; (iii) q = 9 finishing move as a warm-up
certificate (§3).

## 7. Verification

`2026-07-07-onconic-intrusion-check.py` (single-core, trivial memory): claims C1–C4 of Lemma
III + the q = 7 no-intrusion fact; output
`q=7 ... no-intrusion configs=15 ... FAILS=0`, `q=11 ... FAILS=0` (intrusion census
`{(0,0): 800, (2,1): 960, (2,2): 1200}` — no `(2,0)`, per Lemma III(4)),
`q=13 ... FAILS=0` (census includes `(2,0): 113`), `ALL OK`. Lemma I's consistency prediction
against the q = 17 feat logs is delegated (Codex C5).
