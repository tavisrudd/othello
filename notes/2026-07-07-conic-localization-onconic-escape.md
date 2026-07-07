# Route (B): conic localization of the escape crux — the (ON) refinement (2026-07-07)

Session 8 of the projective-cap program (open-math plan `2026-07-07-projcap-open-math-plan.md`,
route (B) "finer counting invariant"). The per-class feature hunt found one principled feature
that reorganizes the whole escape picture: **the unique conic through the projective 5-arc**.
Two new facts (one proven, one empirical-all-data) and several closed dead ends.

## 1. The conic localization lemma (proven, all q)

Let `S₃` be a legal size-3 grid position (3-cell partial-permutation affine cap in `F_q × F_q`).
Together with the two burned direction points `a=(1:0:0)`, `b=(0:1:0)` it forms a projective
5-arc (no 3 collinear: rows/cols give the `a,b`-lines, the cap gives the affine lines).

> **Lemma (unique conic + all its cells are legal).** There is a unique conic `C` through the
> 5-arc; it is nondegenerate, passes through `a,b`, and its affine part is the hyperbola
> `(r−ρ)(c−A) = B` (`B ≠ 0`) — the graph of the Möbius map through the 3 cells — with exactly
> `q−1` cells, one per row `≠ ρ`, one per column `≠ A`. **Every one of its `q−4` non-`S₃` cells
> is a legal extension of `S₃`.** Moreover `C`'s cell set is itself a legal position, and it is
> a **maximal** grid cap of even size `q−1`.

Proof sketch (all verified by machine counters, see §4):
- *Uniqueness/nondegeneracy:* a degenerate conic through a 5-arc splits into 2 lines ⇒ 3 arc
  points collinear, contradiction; two distinct nondegenerate conics share ≤ 4 points. A conic
  through `a` and `b` has the form `δ·rc + ε·r + ζ·c + γ = 0`; `δ = 0` degenerates to
  `L∞ · (line)`, excluded, so normalize `δ = 1` and complete to `(r−ρ)(c−A) = B` with
  `ρ = −ζ`, `A = −ε`, `B = ρA − γ ≠ 0` (else two lines through the 5-arc).
- *Fitting `S₃`:* the 3×3 linear system for `(ε, ζ, γ)` has determinant = the collinearity
  determinant of the 3 cells ≠ 0 (cap property) — the same determinant as in the total lemma.
- *Legality of every non-`S₃` conic cell `x`:* the conic meets each used row `r_i` (used col
  `c_i`) exactly in `S₃`'s own cell (functionality of the graph), so `x` avoids all used rows
  and cols; and `x, S_i, S_j` collinear would put 3 points of a nondegenerate conic on a line.
- *Maximality of `C` as a grid cap:* every cell off `C` except the center `(ρ, A)` shares a row
  or column with a `C`-cell; the center lies on the secant through every antipodal cell pair
  `{t, −t}` (in the parametrization `t = r−ρ`, cells `(t, B/t)`), so it is blocked too.

This **refines the total lemma**: `total = q²−9q+21 = (q−4) + #(off-conic legal)`, and the
`q−4` on-conic extensions are canonical.

Useful substrate lemma (checked, used in the failed law of §3.2): for every `u ∈ F_q^*`, the
map `ψ_u : (t, s) ↦ ((u/B)s, (B/u)t)` (translated coordinates `t = r−ρ`, `s = c−A`) is a
**grid-automorphism involution mapping `C` to itself** and acting on the conic parameter as
`t ↦ u/t`. So every "multiplicative reflection" of the conic is realized by a transpose-type
grid symmetry (axis = the line `s = (B/u)t`).

## 2. The (ON) refinement — the crux has an on-conic witness in ALL computed data

New solver mode `feat` in `2026-07-06-grid-cap-solver.rs` (per size-3 class, per legal
extension: game value + position relative to `C`: `on` / `ext`ernal / `int`ernal, the 0-vs-2
tangent dichotomy for q odd). Data over every canonical size-3 class:

| q  | classes | onP (P ext. on C) | onN | off-conic escapes | (ON) holds |
|---:|--------:|------------------:|----:|------------------:|:-----------|
| 5  | 1       | 1 (= q−4)         | 0   | 0                 | ✓          |
| 7  | 3       | 3 (= q−4)         | 0   | 4                 | ✓          |
| 9  | 5       | 5 (= q−4)         | 0   | 8–16              | ✓          |
| 11 | 8       | 2–5               | 2–5 | 8–16              | ✓          |
| 13 | 12      | 9 (= q−4)         | 0   | 37–40             | ✓          |
| 17 | 21      | **1**–3           | 10–12 | 3–8             | ✓          |
| 19 | 27      | 15 (= q−4)        | 0   | 196 (= rest)      | ✓ (bad=0)  |

> **(ON)** Every legal size-3 grid position has at least one legal size-4 extension **on its
> conic** that is a P-position: `onP(S₃) ≥ 1`.

(ON) ⟹ (ESC) ⟹ `PG(2,q) = P` (frame reduction). It holds in every computed class, including
the q=17 min-escape classes where the margin collapses to 5 — there `onP = 1`: the crux's
surviving witness **is on the conic**. The refinement cuts the search space for the witness
from `Θ(q²)` cells to the conic's `q−4`, i.e. the open kernel becomes **1-dimensional**:

> **(ON) restated:** for every 3-subset `{t₁,t₂,t₃} ⊂ F_q^*` (mod the `t↦kt`, `t↦k/t`
> stabilizer and the finer class structure), some 4th parameter `t₄` gives a P-position
> `S₃ ∪ {(t₄, B/t₄)}` of the grid game.

Status: **empirical through q=19** (the exhaustive wall). It is strictly stronger than (ESC),
so it is also a sharper falsification target: a class with all `q−4` conic extensions N kills
(ON) without killing the conjecture — worth watching separately.

## 3. Dead ends closed this session (so nobody re-hunts them)

1. **"On-conic ⟹ P"**: true for q ∈ {5,7,9,13,19} (all conic extensions are escapes!) but
   FALSE at q=11 (onN up to 5) and q=17 (onN up to 12). The all-P/most-N alternation across q
   is as erratic as the arc counts.
2. **Product-point / symmetric-completion law**: the 3 points `t₄ = tᵢtⱼ/tₖ` are exactly the
   extensions making `S₄` invariant under an involution `t ↦ u/t` (a genuine grid symmetry, by
   the `ψ_u` lemma). At the three q=17 `onP=1` classes the unique P conic point IS a product
   point — but the law fails in general: existence ("some legal product point is P") fails at
   4 of 21 q=17 classes (and the q=7/q=13 classes where the product points degenerate into
   `S₃` itself), and pointwise it is weakly correlated at best (q=17: 24 P vs 28 N on product
   points). The session-7 resym verdict extends: even this *local* symmetry heuristic does not
   decide values.
3. **Quadratic-character laws for the on-conic value**: impossible. q=13 has ALL `q−4` conic
   extensions P while q=17 has classes with exactly 1 of 13 — no fixed character formula in
   `(t₁..t₄, B)` can produce both. (Checked empirically against `χ(t₄/tᵢ)`, `χ(∏(t₄−tᵢ))`,
   cross-ratios, `χ(B)`; no separation.)
4. **Off-conic escape parity**: "extP+intP even" (⟹ `escape ≡ onP mod 2`) holds q ≤ 11 but
   fails at q=13 (3 classes with 37 off-conic escapes).
5. **Completion-count potential function**: count the maximal caps containing each size-4
   position, split by parity (odd/even completions — the COUNT version of the session-5
   boundary characterization, untested until now). At q=11 the on-conic values obey a clean
   majority law — P ⟺ #even-completions > #odd-completions (N always (odd,even)=(24,16); P
   ∈ {(2,28),(9,20),(15,27)}) — but at q=13 the law is violated by **102 of 108** on-conic
   S₄'s (odd completions dominate numerically, e.g. (197,144), yet every one is P). The raw
   completion-parity census does not capture the steering strategy once odd maximal caps
   proliferate. (Scratchpad `completions.py` / `comp_on.py`.)

## 4. Validation

- `feat` mode sanity counters, all green for q = 5,7,9,11,13,17,19 (`sanity=OK` incl. the
  non-prime `q=9` via GF(9) tables): conic has exactly `q−1` affine cells, functional per
  row/col; `legal_on = q−4` in every class (the lemma's machine check); off-conic tangent
  counts always ∈ {0,2}; per-class `escape`/`bad` totals reproduce the escape-mode histograms
  (`2026-07-06-escape-margin-erratic.md`) exactly.
- Analysis scripts (scratchpad, session-local): `analyze_onconic.py`, `prodpoint_law.py` —
  prime-q arithmetic cross-checked against the Rust GF tables via the conic reconstruction
  (conic cells re-derived from the logged `pos=on` lines, hyperbola relation asserted per cell).

## 5. Consequences for the attack routes

- Route (B) now has a concrete refined target: prove **(ON)**, or find the finer invariant on
  the *conic parameter line* `F_q^*` — the problem is 1-dimensional there. The natural
  formulation is about the 6-point configuration `{0, ∞, t₁, t₂, t₃, t₄}` on `P¹` mod the
  `{0,∞}`-stabilizer.
- The q=19 anomaly (`bad = 0` — EVERY size-4 position P) and q=13 (`onN = 0`) vs q=11/17
  (`onN > 0`) says the on-conic value law, like everything else here, tracks the irregular
  abundance of odd complete arcs. Any (ON) proof must survive that.
- **Falsification extension past q=19 (route D) got cheaper**: (ON)/escape of ONE S₃ class
  needs only the subtree above that S₃ (size ≥ 3 positions containing it), not the full-game
  arena that walled at q=23. The size-3 class count is tiny (~tens), so a per-class subtree
  solve with a private memo may fit where the global arena did not. Estimate before running;
  **blocked on the box** until the G(17) nimber run frees the RAM (small-probe-only regime).

## 6. Artifacts

- `feat` mode in `2026-07-06-grid-cap-solver.rs` (this session).
- Logs: scratchpad `feat-small.log` (q=5,7,9), `feat-q11/13/17/19.log` (regenerable in
  seconds–minutes; the CLS/FEAT-SUMMARY lines above are the durable record).
