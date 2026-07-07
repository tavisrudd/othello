# Paper kernel (d): conic localization of the size-3 grid positions, and the ψ_u involutions

**Date:** 2026-07-07 (F1 pass). Paper-ready version of §1 and the ψ_u substrate of
[2026-07-07-conic-localization-onconic-escape.md](2026-07-07-conic-localization-onconic-escape.md).
Changes vs the working note: fully written proofs (uniqueness/nondegeneracy, legality, maximality);
the maximality claim is scoped to `q` odd with the `q`-even anomaly recorded; the off-conic count
is put in closed form `(q − 5)²`.

## 1. Setting: the residual grid game

Fix a prime power `q`. The **grid game** is the impartial normal-play game on the cell set
`F_q × F_q`: a **position** is a set `S` of cells that is simultaneously

- a **partial permutation** — no two cells share a row or a column — and
- an **affine cap** — no three cells are collinear as points of `AG(2, q)`;

a move adds one cell preserving both conditions. (Provenance: this is the residual of the
`PG(2, q)` cap game after the opening pair `{a, b}`, with the line `ab` at infinity: the burned
directions `a = (1:0:0)`, `b = (0:1:0)` contribute the row/column constraints. By the frame
reduction, `PG(2,q) = P ⟺` the size-2 grid seed is P; the escape crux (ESC) — *every legal size-3
grid position has a size-4 P-extension* — implies it. See `2026-07-06-frame-reduction.md`; the
present kernel is self-contained given the definition above.)

Embed `AG(2, q) ⊂ PG(2, q)` by `(r, c) ↦ (r : c : 1)` and set `a = (1:0:0)`, `b = (0:1:0)`. Lines
of `PG(2, q)` through `a` meet the affine part in the **columns** `{c = const}`; lines through `b`
meet it in the **rows** `{r = const}`; the line `ab` is `{z = 0}`. An **arc** is a point set with
no three collinear.

> **Lemma 8 (the 5-arc).** Let `S₃ = {(r_i, c_i)}_{i=1,2,3}` be a size-3 grid position. Then
> `S₃ ∪ {a, b}` is a 5-arc in `PG(2, q)`.

*Proof.* A collinear triple inside the 5 points either (i) contains both `a, b` — but the third
point would lie on `ab = {z = 0}`, and cells have `z = 1`; (ii) contains exactly `a` — then the
two cells lie on a common line through `a`, i.e. share a column, contradicting the partial
permutation; (iii) contains exactly `b` — same with rows; or (iv) consists of the three cells —
excluded by the cap condition. ∎

## 2. The conic localization theorem

> **Theorem 9 (conic localization).** Let `S₃` be a size-3 grid position. Then:
> 1. There is a **unique** conic `𝒞 ⊂ PG(2, q)` through the 5-arc `S₃ ∪ {a, b}`; it is
>    nondegenerate, and its affine part is the hyperbola
>    `𝒞_aff = { (r, c) : (r − ρ)(c − A) = B }` for uniquely determined `ρ, A ∈ F_q` and
>    `B ∈ F_q^*`. `𝒞_aff` has exactly `q − 1` cells: one in each row `r ≠ ρ` and one in each
>    column `c ≠ A`, the graph of the Möbius map `r ↦ A + B/(r − ρ)`.
> 2. Every one of the `q − 4` cells of `𝒞_aff \ S₃` is a **legal extension** of `S₃` (i.e.
>    `S₃ ∪ {x}` is a position).
> 3. `𝒞_aff` is itself a position, and for `q` odd it is an inclusion-**maximal** position, of
>    even size `q − 1`.

*Proof.*

**(1) Existence, uniqueness, normal form.** Write conics as zero sets of nonzero quadratic forms
`Q(r, c, z) = α r² + β c² + γ z² + δ rc + ε rz + ζ cz` up to scalars. `Q(a) = 0` forces `α = 0`;
`Q(b) = 0` forces `β = 0`. Suppose `Q` vanishes on the 5-arc. If `δ = 0` then
`Q = z · (ε r + ζ c + γ z)` (nonzero, so the second factor is a genuine line); the three cells
have `z = 1 ≠ 0`, hence lie on the line `ε r + ζ c + γ z = 0` — contradicting the cap condition.
So `δ ≠ 0`; normalize `δ = 1`. The affine equation is `rc + ε r + ζ c + γ = 0`, and the three
cell conditions form the linear system `r_i c_i + ε r_i + ζ c_i + γ = 0` in `(ε, ζ, γ)` whose
coefficient matrix has rows `(r_i, c_i, 1)` — its determinant is the collinearity determinant of
the three cells, nonzero by the cap condition. Hence `(ε, ζ, γ)` — and so the conic — is unique.
Completing the product, `rc + εr + ζc + γ = (r − ρ)(c − A) − B` with `ρ = −ζ`, `A = −ε`,
`B = ρA − γ`.

`B ≠ 0`: if `B = 0`, then homogeneously `Q = (r − ρz)(c − Az)`, a pair of lines; the three cells
would lie on the union of the row `r = ρ` and the column `c = A`, so two of them would share a
row or a column — contradicting the partial permutation.

Nondegeneracy: if `Q` factored into linear forms over the algebraic closure, the five arc points
would lie on two lines, so three of them on one line `L`; but two distinct points of `PG(2, q)`
determine a unique line over any extension field, so `L` is the `F_q`-line through two of them
and the three points are collinear in `PG(2, q)` — contradicting Lemma 8. So `Q` is irreducible:
`𝒞` is a nondegenerate conic.

Cells: `(r − ρ)(c − A) = B ≠ 0` forces `r ≠ ρ` and then determines `c = A + B/(r − ρ) ≠ A`
uniquely; as `r` ranges over the `q − 1` values `≠ ρ`, the map `r ↦ A + B/(r − ρ)` is a bijection
onto the `q − 1` column values `≠ A`. (Consistency: the projective conic has `q + 1` points; at
`z = 0` the equation reduces to `rc = 0`, giving exactly `a` and `b`; `q − 1` affine cells + 2.)

**(2) Legality.** Let `x ∈ 𝒞_aff \ S₃`. Rows: the conic has exactly one cell in each row, and the
cell of `𝒞_aff` in row `r_i` is `S_i` itself (each `S_i ∈ 𝒞_aff`); `x ≠ S_i`, so `x`'s row avoids
all used rows; columns identically. Collinearity: `{x, S_i, S_j}` are three distinct points of the
irreducible conic `𝒞`; a line meets an irreducible conic in at most 2 points (a cubic-free
restriction argument: `Q` restricted to a parametrized line is a nonzero quadratic polynomial —
nonzero since `Q` has no linear factor — with at most 2 roots). So `S₃ ∪ {x}` is a partial
permutation and a cap: a position. ∎(2)

**(3) Maximality for `q` odd.** `𝒞_aff` is a position by the row/column bijections of (1) and the
2-point line bound of (2). Let `x = (r, c) ∉ 𝒞_aff`. If `r ≠ ρ`, row `r` contains a (unique,
different) conic cell, so `x` shares a row with `𝒞_aff` and is illegal. If `r = ρ` and `c ≠ A`,
column `c` contains a conic cell: illegal. The remaining cell is the **center** `(ρ, A)`. In
translated coordinates `t = r − ρ`, `s = c − A` the conic cells are `P_t = (t, B/t)`, `t ∈ F_q^*`,
and the center is the origin. For any `t ∈ F_q^*` (nonempty since `q ≥ 3`), the two cells `P_t`
and `P_{−t} = −P_t` are distinct (`q` odd) and the origin lies on the secant through them (the
three points are `0, v, −v` with `v = (t, B/t)`). So adding the center completes a collinear
triple: illegal. Every cell off `𝒞_aff` is illegal, and `|𝒞_aff| = q − 1` is even. ∎

**Remark (the `q`-even anomaly).** For `q` even the center is *legal* after `𝒞_aff`: distinct
conic cells `P_{t₁}, P_{t₂}` are collinear with the origin iff `t₁ B/t₂ = t₂ B/t₁` iff
`t₁² = t₂²` iff `t₁ = t₂` in characteristic 2 — so no secant of `𝒞_aff` passes through the
center, and `𝒞_aff ∪ {(ρ, A)}` is a strictly larger position (the familiar fact that a conic in
even characteristic has a nucleus). Part (3) is therefore genuinely a `q`-odd statement; the
escape program lives at `q` odd (the `q`-even planes are settled by the translation mirror).

> **Corollary 10 (refined extension count).** Every size-3 grid position has exactly
> `q² − 9q + 21` legal extensions (the total lemma — proved in
> `2026-07-06-escape-count-lemma.md`, formalized as `sizeThreeExtensionCount` in
> `lean/ProjectiveCap/ExtensionCount.lean`), of which exactly `q − 4` lie on its conic and
> exactly `q² − 10q + 25 = (q − 5)²` lie off it.

*Proof.* Theorem 9(2) gives `q − 4` on-conic legal extensions; on-conic legal extensions are
exactly the non-`S₃` conic cells (conic cells are the only cells "on the conic", and all of them
are legal); subtract from the total. ∎

## 3. The ψ_u involutions: every multiplicative reflection of the conic is a grid symmetry

A **grid symmetry** is a bijection of `F_q × F_q` preserving both defining conditions (mapping
rows and columns to rows and columns — possibly exchanging the two families — and preserving
affine collinearity); grid symmetries map positions to positions and commute with the game rules,
so they act on the game tree. All invertible affine maps that are monomial in the coordinates
qualify.

Work in the translated coordinates `t = r − ρ`, `s = c − A` of a fixed conic
`𝒞_aff = { (t, B/t) : t ∈ F_q^* }`.

> **Lemma 11 (ψ_u).** For `u ∈ F_q^*` define `ψ_u(t, s) = ((u/B)·s, (B/u)·t)`. Then:
> 1. `ψ_u` is an involutive grid symmetry (linear; exchanges the row and column families).
> 2. `ψ_u(𝒞_aff) = 𝒞_aff`, acting on the conic parameter as the multiplicative reflection
>    `t ↦ u/t`.
> 3. Its fixed-point set is the line `s = (B/u)·t` through the center (pointwise fixed — a
>    transpose-type "axis"); for `q` odd the axis meets `𝒞_aff` in 2 or 0 cells according as `u`
>    is or is not a square in `F_q^*` (the fixed conic parameters solve `t² = u`).

*Proof.* (1) `ψ_u` is linear and invertible; `ψ_u² (t, s) = ((u/B)(B/u) t, (B/u)(u/B) s) =
(t, s)`. It maps `{t = const}` (columns of the translated grid) to `{s = const}` (rows) and vice
versa, hence preserves the partial-permutation condition, and being linear it preserves
collinearity. (2) `ψ_u(t, B/t) = ((u/B)(B/t), (B/u) t) = (u/t, B/(u/t))`, again a conic cell,
with parameter `u/t`; the parameter map `t ↦ u/t` is an involution of `F_q^*`. (3) `ψ_u(t, s) =
(t, s)` iff `s = (B/u) t` (the two component equations coincide); on the conic, `t = u/t` iff
`t² = u`, which for `q` odd has 2 solutions if `χ(u) = 1` and none if `χ(u) = −1`. ∎

Interpretation for the program: the stabilizer of a conic inside PGL(3, q) acts on its parameter
line `P¹(F_q)` as PGL(2, q); Lemma 11 realizes the reflections `t ↦ u/t` — the involutions of
that action fixing the parameter pair `{0, ∞}` setwise-with-swap... precisely: exchanging the two
burned directions `a ↔ b` — **inside the grid-symmetry group itself**. Consequently any
completion `S₄ = S₃ ∪ {x}` whose four conic parameters are invariant under some `t ↦ u/t` is
grid-isomorphic to its reflected image, and value analyses on the conic may quotient by these
reflections. (This is the substrate for the product-point analysis; the tempting law "some
ψ-symmetrizable completion is a P-position" is **false** in general — it fails in 4 of 21
size-3 classes at `q = 17` — see the working note §3.2.)

## 4. The (ON) refinement (conjecture; the paper's open kernel)

> **(ON).** For `q` odd, every size-3 grid position `S₃` has at least one legal extension **on
> its conic** that is a P-position of the grid game.

(ON) ⟹ (ESC) ⟹ `PG(2, q) = P` (frame reduction). Status: **empirical**, exhaustively verified
for `q = 5, 7, 9, 11, 13, 17, 19` (every canonical size-3 class; solver `feat` mode with sanity
counters — conic cell count `q − 1`, per-row/column functionality, `q − 4` on-conic legal
extensions in every class, off-conic tangent counts `∈ {0, 2}` — all green, including the
non-prime `q = 9`). At the `q = 17` minimum-escape classes (escape margin 5) exactly one escape
lies on the conic — the crux's surviving witness is on-conic in all computed data. By Corollary
10 the refinement shrinks the witness search from `(q − 5)² + q − 4` cells to the conic's
`q − 4`: the open kernel becomes one-dimensional, a statement about 4-point configurations
`{t₁, t₂, t₃, t₄} ⊂ F_q^*` on the parameter line modulo the `{0, ∞}`-stabilizer (rotations
`t ↦ kt` and the reflections of Lemma 11).

Cautions established by the data (working note §3): (ON) is strictly stronger than (ESC), so a
class with all `q − 4` conic extensions N would kill (ON) without killing the conjecture; the
on-conic value pattern is erratic across `q` (all conic extensions P at `q ∈ {5, 7, 9, 13, 19}`;
`onN` up to 12 of 13 at `q = 17`), is not decided by any quadratic-character formula in
`(t₁, …, t₄, B)` (the `q = 13` vs `q = 17` data are character-incompatible), and is not decided
by completion-count parity (fails at `q = 13`).

## 5. Provenance

- Lemma 8, Theorem 9, Corollary 10, Lemma 11: proved here; machine-checked per class for
  `q ≤ 19` (feat-mode counters, above). The total-lemma input to Corollary 10 is a Lean theorem.
- (ON): empirical through the `q = 19` exhaustive wall; the per-class subtree solver (day-plan
  task O2) is the instrument for extending the test to `q = 23` once box RAM frees.
- Lean scaffold for Theorem 9 / Lemma 11 statements: delegated to Codex (task C2,
  [queue](2026-07-07-codex-task-queue.md)).
