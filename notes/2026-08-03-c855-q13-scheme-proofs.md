# C855 — structural proofs for the q=13 passant-code minimum-word layer

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream), serving Paper IV / C834 as well
**Status:** CHECKPOINT — run stopped early by author quota request. Everything below is
derived on paper; **no computation was run to confirm any of it**, and no Lean was touched.
Marked verification points are exactly the places where a bounded numeric check is still owed.

Target of the work: the `thm:q13-tangent-code` companion rows of
`notes/2026-08-02-c855-paper-i-assertion-inventory.md`, against the proof body at
`papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex` lines 366–599.

---

## 0. Setup and notation used throughout

Fix `q = 13`, the conic `C: XZ - Y^2 = 0` in `PG(2,13)`, and

    Δ(x,y,z) = y^2 - xz,
    β(P,Q)   = 2 y_P y_Q - x_P z_Q - z_P x_Q,        so β(P,P) = 2Δ(P),
    ρ(P,Q)   = β(P,Q)^2 / (Δ(P) Δ(Q)).

`β` is the polarisation of `Δ`; `Δ(λP) = λ^2 Δ(P)`, so the square class of `Δ(P)` is a
projective invariant and `ρ` is a projective invariant of an unordered pair. Squares mod 13
are `{1,3,4,9,10,12}`; nonsquares are `{2,5,6,7,8,11}`; `-1 = 12` is a square.

Two standard facts are used as the only geometric inputs:

* **(G1)** `P` is external iff `Δ(P)` is a nonzero square, internal iff `Δ(P)` is a nonsquare.
  (Proof: the polar of `P` is `{X : β(P,X) = 0}`; for `P = (1,0,z)` the polar is `Z = -zX`,
  which meets `C` iff `-z = Δ(P)` is a square. Two conic points on the polar ⟺ external.)
* **(G2)** A line `ℓ` is passant iff its pole is internal, secant iff its pole is external;
  a passant line carries `(q+1)/2 = 7` internal and `7` external points; a secant line carries
  `(q-1)/2 = 6` internal points. Internal points lie on no tangent.

**Orthogonal chart.** For internal `P` put `W = P^⊥` (the 2-space under `β` carrying the polar
line). Then `V = ⟨P⟩ ⊥ W`, `Δ(aP + w) = a^2 Δ(P) + Δ(w)`, and `Δ|_W` is **anisotropic**
(the polar of an internal point is passant, so it has no conic point). An anisotropic binary
form over `F_q` is a scalar multiple of the norm form of `F_{q^2}`, hence takes **each nonzero
value exactly `q+1 = 14` times** on `W`, and its nonzero level sets are cosets of the cyclic
norm-one group `C_14`, on which that group acts **simply transitively**. This single chart
drives targets 1, 2, 4 and 5.

---

## Target 1 — invariant formulas and the six relation values: **PROVED**

Write `d = Δ(P)` (a nonsquare) and take any `Q` not on the polar of `P`; normalising the
`P`-coefficient to `1` gives `Q = P + w` with `w ∈ W`, and these are exactly the `169` points
off the polar line. Put `u = Δ(w)/d`. Then

    β(P,Q) = 2d,      Δ(Q) = d(1 + u),      ρ(P,Q) = 4/(1 + u).                (★)

**(a) The value set.** `Δ(P)Δ(Q)` is a product of two nonsquares, hence a square, and
`β^2` is a square; so `ρ` is `0` or a nonzero square. `ρ = 4` would force `u = 0`, i.e.
`Δ(w) = 0` with `w ≠ 0`, contradicting anisotropy of `Δ|_W` — equivalently, an internal point
lies on no tangent. Hence

    ρ(P,Q) ∈ {squares} ∪ {0} \ {4} = {0, 1, 3, 9, 10, 12},

which is exactly the companion's six values, derived rather than tabulated.

**(b) Which `u` occur.** `Q` internal ⟺ `Δ(Q) = d(1+u)` nonsquare ⟺ `1+u` a nonzero square
⟺ `u ∈ {0,2,3,8,9,11}`; and `u ≠ 0` for `w ≠ 0`. So `u ∈ {2,3,8,9,11}`, and (★) gives
`ρ = 10, 1, 12, 3, 9` respectively. Each nonzero `u` value is realised by exactly `14` vectors
`w`, so:

**(c) Valencies.** `k_0 = 7` (the internal points of the passant polar of `P`; `ρ = 0` ⟺
`β = 0` ⟺ `Q` on the polar of `P`), and `k_1 = k_3 = k_9 = k_10 = k_12 = 14`.
Total `7 + 5·14 = 77` ✓.

**(d) Join type.** The restriction of `Δ` to the line `PQ` is the binary form
`u^2Δ(P) + uvβ + v^2Δ(Q)` with discriminant `β^2 - 4Δ(P)Δ(Q) = Δ(P)Δ(Q)(ρ - 4)`, and
`Δ(P)Δ(Q)` is a square. Hence

    PQ secant ⟺ ρ - 4 is a nonzero square,   PQ passant ⟺ ρ - 4 is a nonsquare.

`ρ - 4` for `ρ = 0,1,3,9,10,12` is `9,10,12,5,6,8`; so

    secant-type relations  {0, 1, 3},        passant-type relations  {9, 10, 12}.

This is the structural origin of the companion's split, and it is what makes the mod-2 algebra
work in target 2.

**(e) Cross-ratio form (optional, for Paper IV).** In the `F_{q^2}` model (internal points ↔
conjugate pairs `{z, z^q}` in `P^1(F_{q^2}) \ P^1(F_q)`), with `A = N(z-w)`, `B = N(z-w̄)`
and `χ = A/B`,

    ρ = 4 (χ+1)^2 / (χ-1)^2,

so `ρ = 0` is exactly the harmonic relation and `ρ = 4` the degenerate one. This makes the
`PGL(2,13)`-invariance of `ρ` transparent.

*Formalisation shape.* One definition (`ρ`), the chart lemma (★), the anisotropy of `Δ|_W`,
and a `decide` over the residue table mod 13. No search over `78^2` pairs.

*What C834 can consume.* Everything: this replaces the companion's "substituting one
representative of each ρ-relation" by a chart computation, and gives the valency vector
`(7,14,14,14,14,14)` and the secant/passant colouring as theorems. This is the natural
foundation for Paper IV packet 4 (pair recovery) and packet 6 (hidden field).

---

## Target 2 — modulo-two intersection algebra: **PROVED** (all three families)

Let `A_r` be the adjacency matrix of `ρ = r`, over `F_2`.

### 2.1 `A_0^2 = I + A_9 + A_10 + A_12`

`(A_0^2)(P,Q)` counts internal points on `polar(P) ∩ polar(Q)`. On the diagonal this is `7 ≡ 1`.
For `P ≠ Q` the two distinct passant lines meet in exactly one point, namely the **pole of the
line `PQ`**, and by (G2) that pole is internal iff `PQ` is passant. By target 1(d), `PQ` is
passant iff `ρ(P,Q) ∈ {9,10,12}`. Hence `A_0^2 = I + A_9 + A_10 + A_12`. ∎

(Since `A_0` is `M` up to row order — polarity identifies an internal point with its passant
polar — this is exactly the companion's first displayed identity.)

### 2.2 `A_0 A_r = 0` for `r ∈ {9,10,12}` — i.e. every passant-relation neighbourhood is a codeword

Fix internal `P` and `r ≠ 0`. The `r`-neighbourhood of `P` is the rational point set of the conic

    Γ_r(P) :  F(X) = β(P,X)^2 - r Δ(P) Δ(X) = 0.

In the chart, `F(aP+w) = a^2Δ(P)^2(4-r) - rΔ(P)Δ(w)`, so `Γ_r(P)` is nonsingular for
`r ∉ {0,4}`, and its rational points are the `14` points with `Δ(w) = a^2 Δ(P)(4-r)/r`, i.e.
`u = (4-r)/r`, i.e. `ρ(P,X) = r` — all internal. So `Γ_r(P)(F_13) = S_r(P)`, exactly `14` points.

**Tangent-pole lemma.** The tangent to `Γ_r(P)` at `R` is the polar (w.r.t. `F`) of `R`, namely
`{X : β(Y_R, X) = 0}` with `Y_R = 2β(P,R) P - rΔ(P) R`. Hence its pole w.r.t. `C` is `Y_R`, and

    Δ(Y_R) = 4β^2Δ(P) - 2rΔ(P)β^2 + r^2Δ(P)^2Δ(R)
           = β^2 Δ(P) (4 - r)        (using β^2 = rΔ(P)Δ(R)),

where `β = β(P,R) ≠ 0`. So `Y_R` is internal ⟺ `4-r` is a square ⟺ `r-4` is a square
(as `-1` is a square) ⟺ `r` is **secant-type**. By (G2), the tangent line at `R` is passant
iff `r ∈ {0,1,3}`, and **secant iff `r ∈ {9,10,12}`**.

Therefore for `r` passant-type no passant line is tangent to `Γ_r(P)`, so every passant line
meets `S_r(P)` in `0` or `2` points. Since `A_0` is the point/passant-line incidence, this says
`A_0 A_r = 0` over `F_2`, i.e. `im(A_r) ⊆ K = ker A_0`. ∎

*Corollary (dual conic).* The same computation shows the pole locus of the tangents of
`Γ_r(P)` is `Γ_{4-r}(P)`; for passant-type `r`, `4-r ∈ {8,7,5}` is a nonsquare, consistent with
those poles being external.

### 2.3 `A_r^2 = A_{(r-2)^2}` for every `r ≠ 0` — hence the Frobenius 3-cycle

Normalise representatives so that `Δ(P) = Δ(Q) = n` for a fixed nonsquare `n` (possible since
`Δ(λP) = λ^2Δ(P)` sweeps all nonsquares). Write `β = β(P,Q) = n b`, so `ρ(P,Q) = b^2`; changing
`Q ↦ -Q` flips `b`, so `b` is well defined up to sign. Then

    F_P(X) - F_Q(X) = β(P,X)^2 - β(Q,X)^2 = β(P-Q, X) · β(P+Q, X),

a **line pair in the pencil**, the two lines being the polars `ℓ_- = polar(P-Q)` and
`ℓ_+ = polar(P+Q)`. Hence, as point sets,

    Γ_r(P) ∩ Γ_r(Q) = Γ_r(P) ∩ (ℓ_- ∪ ℓ_+).

The point `ℓ_- ∩ ℓ_+` is the pole of `⟨P-Q, P+Q⟩ = PQ`, call it `Y`; `β(P,Y) = 0` gives
`ρ(P,Y) = 0 ≠ r`, so `Y ∉ Γ_r(P)` and there is no inclusion–exclusion correction:

    |Γ_r(P) ∩ Γ_r(Q)| = |Γ_r(P) ∩ ℓ_-| + |Γ_r(P) ∩ ℓ_+|.

Each term is `0,1,2` and is odd exactly when the line is tangent, i.e. (tangent-pole lemma read
backwards) exactly when its pole lies on `Γ_{4-r}(P)`. Now

    Δ(P±Q) = 2n ± β,   β(P, P±Q) = 2n ± β,   so   ρ(P, P±Q) = (2n ± β)/n = 2 ± b.

So the `ℓ_∓` term is odd iff `2 ∓ b = 4 - r` iff `b = ±(r-2)`. The two cases are exclusive
(`r ≠ 2`), hence

    (A_r^2)(P,Q) ≡ 1  ⟺  b^2 = (r-2)^2  ⟺  ρ(P,Q) = (r-2)^2,

and on the diagonal the count is the valency `14 ≡ 0`. Therefore `A_r^2 = A_{(r-2)^2}`. ∎

Specialising: `(9-2)^2 = 10`, `(10-2)^2 = 12`, `(12-2)^2 = 9`, so

    A_9^2 = A_10,   A_10^2 = A_12,   A_12^2 = A_9,

the companion's three identities, plus the bonus `A_1^2 = A_1` and `A_3^2 = A_1`.

### 2.4 Consequences (the "conceptually forces rank 36" clause)

* `A_0^3 = A_0(I + A_9+A_10+A_12) = A_0` by 2.2. So `F_2^{78} = im(A_0) ⊕ ker(A_0)` and
  `T := A_9+A_10+A_12 = I + A_0^2` is the **idempotent projection onto `K` along `im A_0`**.
* With `B := A_9` we get `B^2 = A_10`, `B^4 = A_12`, `B^8 = B`, and on `K`
  `0 = A_0^2 x = (I + B + B^2 + B^4)x`. So `Bx = 0` and `x ∈ K` force `x = 0`: **`B` is
  injective on `K`**, `im B ⊆ K` by 2.2, hence `B(K) = K` and `rank_2 A_9 = rank_2 A_10 =
  rank_2 A_12 = dim K`.
* Since `t^4+t^2+t+1 = (t+1)(t^3+t^2+1)` with the cubic irreducible, `K = K_1 ⊕ K_8` with
  `K_1 = ker(B+I)|_K` and `K_8` an `F_8`-space. If `K_1 = 0` then `K ≅ F_8^{dim K/3}` — this
  is precisely Paper IV's "hidden field" packet 6, and the three passant relations
  `A_9, A_10, A_12` are the three Frobenius conjugates of the `F_8`-scalar.
* Also, summing all relations, `I + Σ_r A_r = J`, and every `x ∈ K` has even weight
  (each internal point lies on `7` passants, so the row sum of `M` is the all-ones functional),
  so `Jx = 0` and therefore `(A_1 + A_3)x = 0` for all `x ∈ K` as well.

So the mod-2 algebra forces `rank_2 A_r = dim K` for the three passant relations; the numeric
value `36` is exactly the Madison–Wu input handled in target 5.

*Formalisation shape.* Three lemmas (2.1, 2.2, 2.3), each a short chart/pole computation plus a
residue-table `decide`; then pure `F_2` linear algebra. **No `78 × 78` matrix product and no
representative-pair enumeration is required anywhere.**

*What C834 can consume.* Directly: this is a complete, search-free replacement for the
companion's displayed integer intersection-number table. It also hands Paper IV the `F_8`
structure of packet 6 as a two-line consequence rather than a construction.

*Verification still owed:* a bounded script confirming (i) the six values and valencies,
(ii) the three mod-2 identity families, (iii) `A_0^3 = A_0`, (iv) `rank_2 M = 42`. Not run.

---

## Target 3 — span of each minimum-word orbit: **PARTIAL (operator half proved)**

The companion's argument is: `N_i^T N_i = (A_9, A_9, A_12, A_10)` over `F_2`, hence
`rank N_i ≥ 36`, hence each orbit spans `K`.

* **Proved here:** `im(A_r) ⊆ K` and `A_r|_K` bijective for `r ∈ {9,10,12}` (§2.2, §2.4), so
  `rank_2 A_r = dim K` — the entire operator half of the argument, and the step the companion
  states as "`B` is injective on the 36-dimensional space `K`".
* **Not proved here:** the Gram identification `N_i^T N_i = A_{r_i}`. That is genuinely
  minimum-word data (Paper IV territory), not scheme data.
* **Consistency check derived on paper (unverified):** `N^T N` mod 2 is `PGL(2,13)`-invariant,
  hence lies in the mod-2 Bose–Mesner algebra, so `N^TN = 14·I + Σ_r c_r A_r` with the mass
  identity `273 c_0 + 546 Σ_{r≠0} c_r = 4·91·binom(12,2) = 24024` over all four orbits. With
  the companion's concurrence values (`7,9,12` on passant joins, `6,8` on secant joins) this
  forces `(c_0,c_1,c_3) = (8,6,6)` and `(c_9,c_10,c_12) = (12, {7,9})`, whose mod-2 reduction
  is `A_10 + A_12` — exactly the sum `A_9 + A_9 + A_12 + A_10` of the four orbit Grams. The
  companion's numbers are internally consistent with the labelling derived in target 1.
* **Better route flagged, not attempted:** if `K` is irreducible as an `F_2[PGL(2,13)]`-module
  (equivalently, `K_8` is an irreducible `F_8[PGL(2,13)]`-module of `F_8`-dimension 12), then
  the row space of any `N_i` is a nonzero invariant subspace of `K`, hence all of `K`, and the
  Gram computation is not needed at all. `dim_{F_8} K = 12` and `|PSL(2,13)| = 2^2·3·7·13`
  make this plausible; it is a cheap `MeatAxe`-style check that was not run.

*Verdict:* promising with named gap — the gap is `N_i^TN_i = A_{r_i}` (or, preferably, the
`F_2[PGL(2,13)]`-irreducibility of `K`).

*What C834 can consume:* the rank statement `rank_2 A_9 = rank_2 A_10 = rank_2 A_12 = dim K`
and the injectivity mechanism, both search-free.

---

## Target 4 — four-anchor rigidity: **PARTIAL (triple-stabiliser triviality PROVED structurally)**

The companion needs: (A) `2184` ordered triples with pattern
`(ρ(P_0,P_1), ρ(P_0,P_2), ρ(P_1,P_2)) = (10,3,9)`; (B) the stabiliser of such a triple in
`PGL(2,13)` is trivial; (C) `P_3` is the unique point with signature `(3,1,9)`; (D) the
four-anchor signature separates all 78 internal points.

**Point stabiliser (proved).** `|PGL(2,13)| = 2184`, there are `78 = q(q-1)/2` internal points
and the action is transitive, so the point stabiliser has order `28`: it is the normaliser
`D_28` of a nonsplit torus. In the chart of §0 the torus `C_14` is the norm-one group acting on
`W`, and:

* it acts **simply transitively** on each of the five `14`-point relations `Γ_r(P)` (these are
  norm level sets, i.e. cosets of `C_14`);
* it acts on the polar line `P(W)` through the quotient of order `7`, giving two orbits of
  size `7`, which must be the internal and the external septet.

Hence all six `ρ`-levels are **single orbits of the point stabiliser**, so `PGL(2,13)` has rank
`7` on the internal points and the `ρ`-levels are exactly its orbitals. Consequently the pair
stabiliser of any relation of valency 14 has order `28/14 = 2`.

**(B) Triple stabiliser is trivial — proved, and in stronger generality.** Let `τ ≠ 1` fix
`P_0` and `P_1`. As an involution of `PG(2,13)` preserving `C`, `τ` is a harmonic homology with
centre `c` and axis `ℓ = polar(c)`, and its fixed points are `{c} ∪ ℓ`.

* If `c` is external then `ℓ` is secant, `c` is not internal, so all fixed internal points lie
  on the secant `ℓ`; then `P_0P_1 = ℓ` is secant, so `ρ(P_0,P_1) ∈ {0,1,3}` — contradicting
  `ρ(P_0,P_1) = 10`.
* If `c` is internal then `ℓ` is passant. `P_0 = c` would force `ρ(P_0,P_1) = 0`; so both
  `P_0,P_1 ∈ ℓ`, hence `P_0P_1 = ℓ` is passant, consistent with `ρ(P_0,P_1) = 10`. The fixed
  internal points are then `c` and the seven internal points of `ℓ`. Any fixed `P_2` satisfies
  either `P_2 = c`, giving `ρ(P_0,P_2) = 0`, or `P_2 ∈ ℓ`, giving a passant join and hence
  `ρ(P_0,P_2) ∈ {9,10,12}`. Both contradict `ρ(P_0,P_2) = 3`.

So: **whenever `ρ(P_0,P_1)` is passant-type and `ρ(P_0,P_2)` is secant-type, the ordered triple
has trivial stabiliser in `PGL(2,13)`.** This replaces the companion's "direct substitution in
the symmetric-square action" by a two-case harmonic-homology argument.

**(A) residual.** Given (B), `|X| = 1092 · p^{10}_{3,9}` and the pair-stabilising involution
acts freely on the `p` candidates, so `p` is even; two conics meet in at most `4` points, so
`p ∈ {2,4}`, and `p = 2` ⟺ simple transitivity. **Excluding `p = 4` is the one residual finite
datum of this target** (one intersection number, or equivalently: the two conics
`Γ_3(P_0)`, `Γ_9(P_1)` meet in exactly two rational points). The `r ≠ s` case defeats the
line-pair pencil trick of §2.3; a mixed-pencil analysis was not attempted.

**(C)/(D) reduction (partial, structural shape).** Normalise `P` with `Δ(P) = n` fixed. Knowing
`ρ(P,P_i)` determines `β(P,P_i)^2`, hence `β(P,P_i) = ε_i b_i` up to a sign `ε_i`. Since
`P_0,P_1,P_2` are not collinear (shown in (B): a secant-type relation to `P_2` forbids
`P_2 ∈ P_0P_1`) they are a basis, and `β` is nondegenerate, so the triple
`(β(P,P_0),β(P,P_1),β(P,P_2))` determines `P`. Hence the three-anchor signature has fibres of
size at most `2^3/±1 = 4`, and the fourth anchor `P_3 = c_0P_0+c_1P_1+c_2P_2` imposes
`(Σ c_i ε_i b_i)^2 = known`, a single quadratic condition on the remaining sign class.
So the "78-point exhaustive signature check" reduces to **at most four sign classes**, not 78
points. Finishing this cleanly (showing the specific `P_3` separates all four classes) was not
done. Note C834 already reports the four-anchor signature-injectivity leaf as kernel-checked,
so this reduction is an economy measure, not a blocker.

*Verdict:* promising with named gap; the gap is exactly `p^{10}_{3,9} = 2` plus the four-class
sign elimination. The stabiliser-triviality clause, which was the substantive step, is proved.

*What C834 can consume:* the rank-7 / orbital identification (which also justifies calling the
`ρ`-levels an association scheme), the pair-stabiliser order 2, and the harmonic-homology
argument for trivial triple stabilisers. All replace substitution checks.

---

## Target 5 — Madison–Wu and Hollmann–Xiang, in the exact form consumed: **SPLIT**

**Hollmann–Xiang (elliptic scheme): PROVED in the consumed form.** The companion consumes only
"the `ρ`-levels are the six classes of an association scheme on the 78 internal points, with
`A_0 = M` up to row order". Target 1 gives the six levels and their valencies; target 4's
orbit analysis shows each level is a single point-stabiliser orbit, so the levels are exactly
the orbitals of `PGL(2,13)` and therefore form a symmetric 6-class association scheme.
`A_0 = M` is the polarity identification (`ρ = 0` ⟺ `β = 0` ⟺ incidence with the passant
polar). **The citation can be dropped from the companion and replaced by this derivation.**

**Madison–Wu (nullity `(q-1)^2/4 = 36`): NOT PROVED structurally.** What is consumed is the
single instance `dim_{F_2} ker M = 36`, equivalently `rank_2 M = 42`.

* What §2.4 supplies for free: `F_2^{78} = im A_0 ⊕ K`; `T = I + A_0^2` is the projection onto
  `K`; `K` is a module over `F_2[t]/(t^7+1)` with `(t+1)(t^3+t^2+1)` annihilating it, so
  `dim K = dim K_1 + 3m`. That gives `3 | dim K` as soon as `K_1 = 0`, but not the value `36`.
* Recommended resolution, since only the instance is consumed: **cite C834's kernel-checked
  rank computation instead of Madison–Wu.** The C834 card records the independent bit-row rank
  calculation and the rank-42 transport as already kernel-reduced, so Paper I's companion can
  reference the formal artifact rather than an external theorem.

*Verdict:* Hollmann–Xiang — proved (citation removable). Madison–Wu — blocked structurally at
"pin down `dim K` exactly"; precise blocker is that the mod-2 Bose–Mesner algebra determines
the ranks only relative to `dim K`. Discharge by the existing C834 kernel-checked rank, not by
a new structural proof.

---

## Target 6 — Hassett–Tschinkel determinantal transfer: **NOT STARTED**

Stretch item, gated on 1–5. `notes/2026-08-03-c855-dye-orbit-uniqueness.md` was not read and
`PaperIOrientationTraceDual` was not inspected. No claim is made here.

---

## Checkpoint summary

| target | verdict at checkpoint |
|---|---|
| 1 invariant formulas and six relation values | **proved** — chart formula `ρ = 4/(1+u)`, values forced by square classes, valencies `(7,14,14,14,14,14)`, secant/passant split by the character of `ρ-4` |
| 2 mod-2 intersection algebra | **proved** — all three families, including the general law `A_r^2 = A_{(r-2)^2}`; forces `rank_2 A_r = dim K` |
| 3 span of every minimum-word orbit | **partial** — operator half proved; gap is `N_i^TN_i = A_{r_i}`, or better, `F_2[PGL(2,13)]`-irreducibility of `K` |
| 4 four-anchor rigidity | **partial** — trivial triple stabiliser proved structurally; gap is `p^{10}_{3,9} = 2` and a four-class sign elimination |
| 5 Madison–Wu / Hollmann–Xiang | **split** — Hollmann–Xiang proved in the consumed form; Madison–Wu instance to be discharged by C834's kernel-checked rank 42 |
| 6 Hassett–Tschinkel transfer | **not started** |

**Owed before any of this is quotable:** a bounded confirmation script
(`notes/2026-08-03-c855-q13-scheme-checks.py`, not yet written) verifying the six values, the
valencies, the three mod-2 identity families, `A_0^3 = A_0`, `rank_2 M = 42`, and
`p^{10}_{3,9}`. Every derivation above is pen-and-paper only.

---

## Computational confirmation (2026-08-03)

Script: `notes/2026-08-03-c855-q13-scheme-checks.py` (pure Python, no dependencies, ~2 s).
Replay: `python3 notes/2026-08-03-c855-q13-scheme-checks.py` from the repository root; exit
status `0` iff every check passes. All **56 checks PASS**; nothing above needs correction.

| check                                                     | result                                            |
|-----------------------------------------------------------|---------------------------------------------------|
| counts, (G1)/(G2), passant `7+7`, secant `6` internal      | PASS                                               |
| chart `(★)`, `ρ = 4/(1+u)`, `u ∈ {2,3,8,9,11}`             | PASS (all off-polar pairs, every internal `P`)     |
| six values `{0,1,3,9,10,12}`, `ρ = 4` only on diagonal     | PASS                                               |
| valencies `(7,14,14,14,14,14)`                             | PASS                                               |
| secant/passant split `{0,1,3}` vs `{9,10,12}`              | PASS                                               |
| `A_0 = M` under pole relabelling                           | PASS                                               |
| `A_0^2 = I+A_9+A_10+A_12`; `A_0A_r = 0`; `A_0^3 = A_0`     | PASS                                               |
| general law `A_r^2 = A_{(r-2)^2}` (incl. `A_1^2=A_1`)      | PASS                                               |
| `rank_2 M = 42`, `dim K = 36`, `rank_2 A_{9,10,12} = 36`   | PASS                                               |
| `K_1 = 0`, so `K ≅ F_8^12`                                 | PASS                                               |
| tangent-pole lemma and `Γ_r(P)` = 14 internal points       | PASS                                               |
| `p^{10}_{3,9} = 2`; `2184` ordered `(10,3,9)` triples      | PASS — target 4's residual datum is now confirmed  |
| rank 7, stabiliser orbits `1,7,14×5`, `|D_28| = 28`        | PASS                                               |
| min weight of `K` is `12`, exactly `364` words             | PASS (exhaustive: two disjoint information sets)   |
| `364 = 4 × 91`, stabilisers one `S_4` + three `D_24`       | PASS                                               |
| concurrences `(c_0,c_1,c_3)=(8,6,6)`, `(c_9,c_10,c_12)=(12,7,9)`, mass `24024` | PASS            |
| per-orbit Gram mod 2 = `(A_9,A_9,A_12,A_10)`               | PASS — closes target 3's named gap numerically     |

Framing note: the weight-12 layer lives in `K = ker M` on the 78 internal coordinates, on the
**dual** side. The span of the 78 passant lines inside `F_2^{183}` has full dimension 78 and
contains none of the 364 words; each word is orthogonal to every passant line.
