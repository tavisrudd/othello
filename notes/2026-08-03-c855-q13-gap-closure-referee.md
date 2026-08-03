# C855 — adversarial referee report on the q=13 gap-closure note

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Target under review:** `notes/2026-08-03-c855-q13-scheme-gap-closure.md` (read in full).
**Background consulted:** `notes/2026-08-03-c855-q13-scheme-proofs.md` (checkpoint),
`notes/2026-08-03-c855-q13-scheme-checks.py` (replayed, exit 0, 56/56 PASS).

Method: every finite arithmetic claim was recomputed from scratch in throwaway scripts under the
session scratchpad, independently of the committed checks script — the scheme was rebuilt from
`Δ = y^2 - xz` on `PG(2,13)`, `PGL(2,13)` was rebuilt as `2×2` matrices mod scalars acting through
the symmetric square, its 15 conjugacy classes and full ordinary character table were built from the
formulas of input (I4) and validated by full orthonormality, and the `F_2` linear algebra on
`K = ker M` was done with bitset Gaussian elimination. Every representation-theoretic *inference*
was checked separately for a genuine gap; "the numerics agree" was never accepted as a structural
step.

---

## 1. Findings table

| # | claim (location) | verdict | severity |
|---|---|---|---|
| F1 | Lemma A1 — 2-regular classes and `π = (78,0,1,1,1,0)` (§1.2) | CONFIRMED | — |
| F2 | Lemma A2 — `π = 1 + ηSt + χ_{α_3} + χ_{α_6} + three order-14 `χ_θ`` (§1.3) | CONFIRMED | — |
| F3 | Lemma A3 — Hecke/double-coset derivation and the `(y,c,type)` table (§1.4 a–e) | CONFIRMED | — |
| F4 | Lemma A3 — eigenvalues `7, -3, 1, 3` and `2(ζ_7+ζ_7^{-1})`, parity claim (§1.4 f) | CONFIRMED | — |
| F5 | Lemma A3 — "internal points are the pairs with `ω ∉ μ_14 ∪ {0,∞}`" (§1.4 a) | GAP: false as written, contradicted two lines later by `P_0 = {0,∞}`; gives 77 points | MINOR |
| F6 | Lemma A3 — trichotomy rule "`c^2-4` zero ⇒ unipotent" (§1.4 e) | GAP: false at `c = -2` (split involution); the table itself is right | MINOR |
| F7 | Prop A4 — upper bound `v_2(det M) = 36`, char. polynomial (§1.5) | CONFIRMED (exact charpoly and exact determinant reproduced) | — |
| F8 | Prop A4 — lower bound via `e =` sum of 2-block idempotents of the three `χ_{θ_i}`, "a single `Z_2`-block" (§1.5) | GAP: the three `χ_{θ_i}` are **not** a union of 2-blocks, so `e ∉ Z_2[G]` and `L` is undefined; one-line repair given below, conclusion unaffected | MINOR |
| F9 | Lemma A5 — defect zero over `PSL(2,13)`, irreducibility, Galois 3-cycle (§1.6) | CONFIRMED | — |
| F10 | Theorem A — `K` irreducible, `End = F_8` (§1.7) | CONFIRMED (independently verified: enveloping algebra of dimension 432, commutant of dimension 3) | — |
| F11 | Theorem A proof — "each `e_iL` has rank 12" (§1.7) | GAP: same nonexistent idempotents as F8; repaired by Brauer-character additivity, which is all the proof uses | MINOR |
| F12 | Payoff bullet — "`K_1 = ker(A_9+I)|_K = 0` is automatic, since `A_9|_K` is a scalar of order 7" (§1.7) | GAP: Theorem A alone leaves `A_9\|_K = 1` open; `λ = 1` satisfies both constraints the note invokes. One-line repair given | MINOR |
| F13 | Payoff bullet — "the automorphism group of the code contains no more than the scheme automorphisms" (§1.7) | GAP: what is proved is that the *centraliser* of `G` is `F_8`, not a statement about `Aut` of the code | MINOR |
| F14 | Theorem B1 — `p^{10}_{3,9} = 2` by the two-line/Legendre mechanism (§2.1) | CONFIRMED (every algebraic step re-derived; count 2 for all 1092 ordered pairs) | — |
| F15 | "General mechanism" paragraph — every `p^r_{s,t}` reduces to two lines "on each of which one quadratic decides between 0 and 2 solutions" (§2.1) | GAP: false. Counterexamples computed: `p^9_{9,10} = 1` (all 1092 pairs) and `p^1_{1,1} = 3`. The degenerate branch (right-hand side zero, one solution, on the line `P_0P_1`) is real | MINOR (does not touch B1) |
| F16 | §2.2 canonical Gram model, `det G = 3 + 2b_{01}b_{02}b_{12}`, product-7 realised / product-6 not, `G^{-1}`, `Q(v) = 2`, 156 vectors | CONFIRMED | — |
| F17 | §2.2 `(G^{-1})_{01} = 0` and its geometric reading | CONFIRMED | — |
| F18 | Lemma B2 — fibres of size at most 2, criterion `c_k(v) = 0`, exceptional locus (§2.3) | CONFIRMED (66 fibres of size 1, 6 of size 2, split 3+3 exactly as cases (i)/(ii) predict) | — |
| F19 | Lemma B3 — `P_3` unique of signature `(3,1,9)`, `t = (6,4,3)` (§2.4) | CONFIRMED | — |
| F20 | Theorem B4 — the fourth anchor separates; 78 distinct signatures (§2.5) | CONFIRMED | — |
| F21 | Corollary B — `Aut(scheme) = PGL(2,13)` (§2.5) | GAP: valid only for colour-preserving automorphisms (those fixing each relation); relation-permuting automorphisms are not addressed | MINOR (scoping) |

No MAJOR finding. Every conclusion the note asserts is true; three of its stated *arguments*
(F8, F11, F12) do not establish what they claim, and each has a short repair given below.

---

## 2. Gap A — the representation theory

### F1, F2 — the permutation character (CONFIRMED, independently)

I rebuilt `PGL(2,13)` as normalised `2×2` matrices over `F_13` (order 2184 confirmed), computed its
15 conjugacy classes with sizes, classified each class by the discriminant `Tr^2 - 4det` (split /
nonsplit / unipotent) and by `Tr^2/det - 2 = r + r^{-1}`, and computed the permutation character `π`
on the 78 internal points directly by counting fixed points. Values on the 2-regular classes:
`π(1) = 78`, `π(order 3) = 0`, `π(7a) = π(7b) = π(7c) = 1`, `π(13) = 0` — Lemma A1 exactly.
(For the record, `π` on the two involution classes is 6 on the split one and 8 on the nonsplit one;
the note does not use these.)

I then built the full ordinary character table from the formulas of input (I4) — including explicit
characters of the split torus `C_12` and of `μ_14` realised inside `F_169` — and verified complete
orthonormality of all 15 characters against the computed class sizes. This validates (I4) itself as
well. Inner products with `π`:

    <π,π> = 7,  and the only nonzero multiplicities are
    <π,1> = <π,ηSt> = <π,χ_{α of order 3}> = <π,χ_{α of order 6}> = 1,
    <π,χ_θ> = 1 for exactly the three θ of order 14 (and 0 for the three of order 7).

This is Lemma A2 verbatim, obtained without using any step of the note's proof. I also checked the
note's own derivation by hand: the reflection split `7 + 7` follows from integrality of
`⟨π,η⟩ = (a-b)/28` with `a+b = 14`; `α(z_s) = (-1)^k` for `α(g) = ζ_12^k` gives exactly orders 3 and
6; `θ(z) = (-1)^k` for `θ(h) = ζ_14^k` gives exactly the order-14 characters. All correct.

Note in passing that Lemma A1 is never actually used downstream — Lemma A2 runs on the `D_28`
inner-product formula, and Lemma A5 uses the classes of `PSL`, not of `G`. That is a redundancy,
not a defect.

### F3, F4 — the Hecke computation (CONFIRMED)

I re-derived every step of §1.4 by hand and found no error:

* the unitary model `σ(ω) = ω^{-13}`, fixed set `μ_14`, group order `(169^2 - 2353)/12 = 2184`;
* `ρ(P_0,P) = 0 ⟺ ω^{14} = -1`, one coset of `μ_14`, `σ`-stable and disjoint from `μ_14`, hence 7
  internal neighbours;
* `T = Stab(0)` acts as multiplication by `μ_14`, with 13 orbits on `Ω'` (`0`, `∞`, 11 free), and
  `Ind_T^G 1` is multiplicity-free with 13 constituents (checked constituent by constituent), so
  the Hecke algebra is commutative and the eigenvalue formula `u'_χ = |T|^{-1}Σ_{d∈D}χ(d)` is
  legitimate — it returns the valency 14 on the trivial character, as it must;
* `g(0) = b/\bar a`, `g(0)^{14} = N(b)/N(a)`, `D = {N(a) = -N(b)}`, `det = 2N(a)`,
  `Tr^2/det = (1+ε)^2/(2ε) = (y+2)/2` with `ε = a^{12}`, hence `r + r^{-1} = c(y) = (y-2)/2 = 7(y-2)`;
* the realised `y` are `2, -2` and `{3,5,6,7,8,10}` (exactly the `y` with `y^2-4` a nonsquare), and
  the order-7 triple is `{7,8,10}` because it must sum to `-1`; every entry of the `(y, c, type)`
  table is correct, including `ord ε`, the element orders 4, 2, 7, 7, 13, 12, 14, 12, and the
  consistency check `η(g_ε) = -ε^7` (which follows from `(N(a)|13) = a^{84} = ε^7`);
* the four principal-block evaluations `7, -3, 1, 3` (character values `-1,1,-1,-1,0,-1,1,-1` for
  `ηSt`; `2,2,-1,-1` and `-2,2,1,1` for the two principal series — indices `9,6,11,7` base 2 all
  correct);
* the discrete-series bookkeeping: at `y = 3, 5` the ratio has order 7 with traces `7, 8`, at `y = 8`
  the ratio is `-r_0` because `c = 3 = -10`, and `θ(-1) = -1` flips that term, giving
  `-w_1 - w_2 + w_0 = 1 + 2w_0` via `w_0+w_1+w_2 = -1`, hence `u = 2w_0`.

Independent confirmation of the *result*: I computed the eigenvalue of `A_0` on each constituent
directly, as `u_χ = |G|^{-1} Σ_g \overline{χ(g)} · #\{P : ρ(P,gP) = 0\}`, which gives

    u(1) = 7,  u(ηSt) = -3,  u(χ_{α order 3}) = 1,  u(χ_{α order 6}) = 3,
    u(χ_θ) = -0.890084, 2.493959, -3.603875  =  the three roots of x^3+2x^2-8x-8.

So the eigenvalue-to-constituent assignment in the note's table, including which principal series
gets 1 and which gets 3, is exactly right, and the parity claim (four odd principal eigenvalues,
discrete-series eigenvalues `2 ×` an algebraic integer) holds.

### F5, F6 — two local slips in §1.4

`§1.4(a)` says the internal points are the pairs `{ω, ω^{-13}}` with `ω ∉ μ_14 ∪ {0,∞}`. But `σ`
swaps `0` and `∞`, so `{0,∞}` *is* an internal point — as §1.4(b) itself immediately assumes when
it sets `P_0 = {0,∞}`. The correct condition is `ω ∉ μ_14`, giving `|Ω'| = 170-14 = 156` and
`156/2 = 78`; the stated condition gives 77. Cosmetic, but it contradicts the very next paragraph.

`§1.4(e)` states the rule "`g_ε` is split, unipotent or nonsplit according as `c^2-4` is a nonzero
square, zero, or a nonsquare". At `c = -2` one has `c^2-4 = 0` and `r = -1`: the element is a *split
involution*, not unipotent. The table lists it correctly, so nothing downstream is affected; the
stated rule needs "zero and `c = 2`" for the unipotent case.

### F7 — Proposition A4's upper bound (CONFIRMED)

Exact computation of the characteristic polynomial of the integer matrix `A_0` returns

    (x-7)(x+3)^{13}(x-1)^{14}(x-3)^{14}(x^3+2x^2-8x-8)^{12},

identically the note's display, and the exact determinant is `-3668189482773649790337024`
`= 2^{36} × 53379182394909` with the odd cofactor equal to `7·(-3)^{13}·3^{14}·(8^{12}/2^{36})`.
So `v_2(det M) = 36`, and the elementary-divisor bound `dim_{F_2} ker M ≤ v_2(det M)` is correctly
applied. Independently, `rank_2 M = 42` and `dim K = 36`.

### F8 — Proposition A4's lower bound uses an idempotent that does not exist (MINOR, repairable)

The note writes: *"let `e ∈ Z_2[G]` be the sum of the 2-block idempotents of the three characters
`χ_{θ_i}` (a single `Z_2`-block, since the `χ_{θ_i}` are Galois-conjugate over `Q_2`)"*.

Galois conjugacy over `Q_2` gives one **rational** central idempotent, which is a completely
different thing from a **2-block** idempotent; integrality is exactly the missing content. And here
integrality fails. Two independent proofs:

*Structural.* `χ_θ(1) = 12` has `v_2 = 2` while `v_2(|PGL(2,13)|) = v_2(2184) = 3`, so no `χ_θ` has
defect zero and every block containing one has defect at least 1. The Sylow 2-subgroup is dihedral
of order 8, so every 2-block of `G` has defect group `C_2`, `C_4`, `V_4` or `D_8`, and by Brauer's
block theory the number of ordinary characters in such a block is `2` (cyclic `C_2`, inertial index
forced to 1), `4` (cyclic `C_4`, or Klein four), or `2^{3-2}+3 = 5` (dihedral of order 8). No union
of blocks has exactly 3 ordinary characters, so `{χ_{θ_1},χ_{θ_2},χ_{θ_3}}` is not one.

*Computational, decisive.* `e = Σ_i e_{χ_{θ_i}}` is rational, with coefficient at `g` equal to
`(12/2184)·s(g^{-1}) = s(g^{-1})/182`, where `s(g) = Σ_i χ_{θ_i}(g) ∈ Z`. I computed `s` on all 15
classes:

    s = 36 (identity), 6 (nonsplit involution), 0 (all split classes),
        1 (each order-7 class), -1 (each order-14 class), -3 (unipotent).

`182 = 2·7·13`, so `e ∈ Z_2[G]` would need `s(g)` even everywhere; it is odd on seven classes.
Hence `e ∉ Z_2[G]`, `L = e·Z_2[Ω]` is not defined, and the proof as written has no object to work
with.

*Repair (one sentence, and the rest of §1.5 is unchanged).* Take instead

    L := V ∩ Z_2[Ω],   V = the Q_2-span of the three χ_{θ_i}-isotypic components of Q_2[Ω].

`V` is a `Q_2[G]`-submodule because the three characters are Galois-conjugate over `Q_2` (2 has
order 3 modulo 7, so `Q(ζ_7)^+` is inert at 2), so `L` is a `G`-stable **saturated** `Z_2`-lattice
of rank 36; saturation is exactly what makes `L/2L ↪ F_2[Ω]` injective. `M` preserves `L`, acts on
`L ⊗ Q_2` with characteristic polynomial `(x^3+2x^2-8x-8)^{12} ≡ x^{36} (mod 2)`, hence is nilpotent
on `W = L/2L`, and `M^3 = M` then forces `M|_W = 0`. Everything after that stands.

With this repair, `dim_{F_2} ker M = 36` is a complete structural proof, and the verdict-table entry
"the external citation can be dropped" survives. I confirm `dim K = 36` numerically as well.

### F9 — Lemma A5 (CONFIRMED)

Each step checks out. The restriction map from order-14 characters `θ` of `C_14` to characters of
`C_7` is a bijection onto the nontrivial ones (the odd residues mod 14 hit every nonzero residue mod
7 exactly once), so `χ_θ|_{PSL}` is one of the three degree-12 discrete series of `PSL(2,13)`, which
are irreducible because `q ≡ 1 (mod 4)` (the characters that split for `PSL(2,13)` are the
principal-series ones of degree 7). `v_2(12) = 2 = v_2(|PSL(2,13)|)` gives defect zero directly; the
note's alternative route via vanishing on 2-singular classes is also correct — I confirmed from the
class list that the elements of `PSL(2,13)` have orders `1,2,3,6,7,13`, so the 2-singular ones have
order 2 and 6, both split regular semisimple, where every discrete series vanishes. Reduction of a
defect-zero character is irreducible; irreducible on restriction implies irreducible; and the
Frobenius `x ↦ x^2` permutes the three pairs `{ϑ,ϑ^{-1}}` in a 3-cycle because 2 has order 3 in
`(Z/7)^*/{±1}`.

### F10, F11 — Theorem A (conclusion CONFIRMED; one step repaired)

The conclusion is independently verified by explicit computation on the actual 36-dimensional `K`:

* restricting the `PGL(2,13)`-action to `K` and closing the generated matrix algebra gives
  **dimension 432 over `F_2`**, which is exactly `dim_{F_2} M_{12}(F_8)`;
* the commutant of the group action on `K` has **dimension 3**, so `End_{F_2G}(K) = F_8`;
* 20 random nonzero vectors of `K` each spin under `G` to the full 36 dimensions.

By the double-centraliser theorem those first two facts already prove `K` irreducible with
endomorphism field `F_8`. So Theorem A is true.

The written proof, however, again invokes individual idempotents: *"each `e_iL` has rank 12 and
reduces to the irreducible `φ_i`"*. Over `\bar Z_2` the individual `e_i` is a block idempotent only
if `χ_{θ_i}` is alone in its 2-block, i.e. has defect zero for `G` — and it does not (defect 1, as
above). The repair is again short and costs nothing: the reduction `\bar F_2 ⊗ L/2L` has Brauer
character equal to the sum of the three `φ_i` (Brauer characters are determined by ordinary
character values on 2-regular classes and are additive on composition series), so its composition
factors are precisely `φ_1, φ_2, φ_3`, each once. That is the only input the irreducibility argument
uses; the parenthetical claim of semisimplicity is a *consequence* of the theorem (an irreducible
`F_2G`-module with commutative endomorphism field has semisimple scalar extension), not a needed
premise, and should be moved after the conclusion or dropped.

The Galois-descent step itself is correct: for `0 ≠ U ⊆ K` defined over `F_2`, the composition-factor
multiset of `\bar F_2 ⊗ U` is a nonempty `Gal(\bar F_2/F_2)`-stable sub-multiset of a single Galois
orbit of size 3, hence everything, hence `dim U = 36`. And the endomorphism-field conclusion `F_8`
from "3 pairwise non-isomorphic absolutely irreducible summands" is standard and correct.

### F12 — the `K_1 = 0` payoff bullet has a missing exclusion (MINOR, repairable)

The note asserts: *"`K_1 = ker(A_9+I)|_K = 0` is automatic, since `A_9|_K` is a scalar of order 7 in
`F_8^*`."* Theorem A gives only `A_9|_K ∈ End_{F_2G}(K) = F_8`. Write `λ = A_9|_K`. The two
constraints the note has available are

    (I + B + B^2 + B^4)|_K = 0   (from A_0^2 = I + A_9 + A_10 + A_12 and A_0|_K = 0),
    λ + λ^2 + λ^4 = 1,

and over `F_2` the polynomial `x^4+x^2+x+1 = (x+1)(x^3+x^2+1)` has the root `λ = 1` alongside the
three roots of order 7 — and `λ = 1` also satisfies `λ+λ^2+λ^4 = 1+1+1 = 1`. So neither constraint
excludes `λ = 1`, which is precisely the case `K_1 = K`. The claim is therefore not automatic as
stated.

*Repair (one line).* From input (I2), `A_rA_0 = 0` for `r ∈ {9,10,12}` and `T = I + A_0^2` is the
projection onto `K`, so `A_r = A_rT`: each `A_r` is determined by its restriction to `K`. If
`λ = 1` then `A_{10}|_K = λ^2 = λ = A_9|_K`, whence `A_{10} = A_9` as matrices — false, they are
adjacency matrices of different relations. Hence `λ ≠ 1`, `λ` has order 7, and `A_9 + I` is
invertible on `K`. I confirm computationally that `A_9|_K` lies in the 3-dimensional commutant and
has multiplicative order exactly 7.

### F13 — the code-automorphism bullet is mis-stated (MINOR, scoping)

*"The automorphism group of the code contains no more than the scheme automorphisms: any linear map
commuting with `G` on `K` is an `F_8`-scalar."* The second clause is proved; the first does not
follow from it. `Aut` of a binary code is a group of coordinate permutations, and there is no reason
for such a permutation to commute with `G` — that is what one would be trying to prove. What §1.7
actually establishes is `C_{End(K)}(G) = F_8`. Restate the bullet as a centraliser statement, or
derive the code-automorphism claim from Corollary B instead (which is where it belongs).

---

## 3. Gap B — the geometry

### F14 — Theorem B1 (CONFIRMED)

I re-derived the whole proof symbolically over `F_13` and confirm every constant:
`b^2 = 10 ⇒ b = ±6`; the Gram determinant of `U` is `n^2(4-b^2) = -6n^2 ≠ 0`; the two relation
equations give `β(P_0,P_2) = n(2α+bγ)`, `β(P_1,P_2) = n(bα+2γ)`,
`Δ(P_2) = n(α^2+bαγ+γ^2) + δ^2c`; the ratio condition is linear because `9/3 = 3 = 4^2`, and with
`b = 6` the two branches are `α = 2γ` (from `s = 4`, via `-2α = 22γ`) and `α = 0` (from `s = -4`,
via `14α = -26γ`); substitution gives `δ^2/γ^2 = -n/c` on `L_+` (using `10^2 = 9` and
`α^2+6αγ+γ^2 = 4γ^2`) and `δ^2/γ^2 = 7n/(3c) = 11n/c` on `L_-` (using `6^2 = 10` and `7/3 = 11`);
`-1` is a square and `11` is a nonsquare, so exactly one branch is solvable and it contributes
exactly two points. The side conditions are all justified: `2α+bγ = 0` would force `Δ(P_2) = 0`;
`γ = 0` leaves the excluded point `e`; both right-hand sides are nonzero; and `P_2` is automatically
internal because `Δ(P_2) = β^2/(3Δ(P_0))` with `3` a square and `Δ(P_0)` a nonsquare.

Brute force over **all** 1092 ordered pairs with `ρ = 10` gives the count 2 in every case. The
corollary `78·14·2 = 2184` and simple transitivity follow.

I also checked the unstated point that the two lines are always distinct: they coincide only if
`s(b^2-4) = 0`, i.e. only in the excluded cases `t = 0` or `ρ(P_0,P_1) = 4`.

### F15 — the "General mechanism" paragraph is false as stated (MINOR; B1 unaffected)

The paragraph claims that for any `r` and nonzero `s,t` the reduction yields "two lines through the
pole of `P_0P_1`, on each of which one quadratic in `δ/γ` decides between 0 and 2 solutions". If
that were right, every `p^r_{s,t}` with `r,s,t ≠ 0` would be 0, 2 or 4. It is not: I computed the
full array and found

    p^9_{9,10} = 1  (verified over all 1092 ordered pairs with ρ = 9, and in every case
                     the unique P_2 is collinear with P_0 and P_1, i.e. it is the δ = 0 point),
    p^1_{1,1} = 3,

among others (odd entries occur for `(9,9,10)`, `(10,10,12)` and their permutations; the value 3
occurs for `(1,1,1)`, `(1,3,3)`, `(9,10,12)` and relatives). The missing branch is the degenerate
one: the right-hand side of the quadratic can vanish, in which case the line contributes exactly one
solution, the point of `⟨P_0,P_1⟩` itself. Theorem B1 explicitly rules this out for its own
parameters (`-n/c` and `11n/c` are nonzero), so B1 is untouched; but the general paragraph — and
strengthening candidate 6, which is built on it — must add "or exactly one solution when the
right-hand side vanishes". The checkpoint's parity remark ("`p` is even" by the pair-stabilising
involution) is likewise conditional on the involution acting freely, which fails exactly in that
degenerate case.

### F16, F17 — the canonical Gram model (CONFIRMED)

The Gram matrix of `β` in the standard coordinates is `[[0,0,-1],[0,2,0],[-1,0,0]]` of determinant
`-2`, so `n^3 det G` lies in the square class of `-2 = 11`; `n^3` and `11` are both nonsquares, so
`det G` is a square. `det[[2,p,q],[p,2,r],[q,r,2]] = 8 - 2(p^2+q^2+r^2) + 2pqr` gives
`det G = 3 + 2b_{01}b_{02}b_{12}`; the product is `±72 = 7` or `6`, giving `det G = 4` (square,
realised) and `2` (nonsquare, not realised). I recomputed
`G^{-1} = [[2,0,9],[0,10,11],[9,11,5]]` and confirmed `|{v : Q(v) = 2}| = 156`, hence 78 projective
classes — consistent with `13^2 - 13` for the nonsquare level set of a nondegenerate ternary form.
`(G^{-1})_{01} = 0 ⟺ 2b_{01} = b_{02}b_{12}`, i.e. `12 = 12`; the geometric reading is correct
(`β(P_0^*,P_1^*) = 0` says the pole of `P_1P_2` lies on the polar of `P_1^*`, which is the line
`P_0P_2`).

Independently, the companion's anchors `P_0=(1:0:2)`, `P_1=(1:1:7)`, `P_2=(1:0:7)`, `P_3=(1:1:3)`
have `ρ`-pattern `(10,3,9)` and `P_3`-signature `(3,1,9)`. My normalisation of the same triple
produced off-diagonals `(7,9,3)` rather than the note's `(7,4,10)` — a different choice of square
root at each point — but the invariant product is `7` in both cases, so both sit in the canonical
`det G = 4` class, as the note's sign analysis predicts.

### F18, F19, F20 — Lemmas B2, B3 and Theorem B4 (CONFIRMED)

`Q(D_kv) - Q(v) = -4c_k(v)` is right, and `-4 ≠ 0` mod 13, so the criterion is exact. With the
canonical `G^{-1}` the three `c_k` are as displayed. The case analysis is complete and each case is
correct, including the subcases with one or two vanishing coordinates. Direct enumeration over the
78 classes gives **66 fibres of size 1 and 6 of size 2** — and the six large fibres split as three
with `v_2 = 0` (case ii) and three with all `v_i ≠ 0` and `9v_0+11v_1 = 0` (case i, verified:
`9·4+11·5 = 0`, `9·5+11·3 = 0`, `9·6+11·1 = 0`), exactly the predicted exceptional locus.

Lemma B3: expanding `Q(w) = 2` with `w_2 = 3` gives `9 + 5w_0w_2 + 9w_1w_2 = 2`, i.e.
`2w_0 + w_1 = 6`, satisfied among the four sign choices only by `(w_0,w_1) = (-4,1)`; and
`t = G^{-1}(-4,1,3) = (6,4,3)`. Enumeration finds exactly one class of signature `(3,1,9)`, namely
`±(-4,1,3)`, with `t = ±(6,4,3)`.

Theorem B4: in case (i), `9v_0+11v_1 = 0` gives `v_1 = 11v_0` and
`t_0v_0+t_1v_1 = v_0(6+44) = 11v_0 ≠ 0`, while `t_2v_2 = 3v_2 ≠ 0`; in case (ii),
`t_0 = 6 ≠ 0 ≠ 4 = t_1`. The four-anchor signature takes 78 distinct values on the 78 internal
points, confirmed by enumeration, and the anchors themselves are separated by `ρ(P,P) = 4` not being
a relation value.

### F21 — Corollary B's scope (MINOR)

The argument shows that a permutation of `Ω` preserving **each** relation `ρ = r`, after composition
with a suitable element of `G`, fixes `P_0,P_1,P_2`, hence `P_3`, hence every point. That is the
colour-preserving automorphism group of the scheme. A permutation that permutes the relations among
themselves is not covered, and `Aut(scheme) = PGL(2,13)` should be stated with that reading made
explicit (or accompanied by the standard remark that the passant/secant colouring is intrinsic, via
`ρ - 4`, so no relation-permuting automorphism can mix the two families).

---

## 4. Strengthening candidates — sanity level only

1. **Madison–Wu for all `q ≡ 1 (mod 4)`.** Plausible and correctly scoped; I checked the count —
   `θ(z) = -1` means `θ(h) = ζ_{q+1}^k` with `k` odd, and since `(q+1)/2` is odd for `q ≡ 1 (mod 4)`
   that character is excluded, leaving `(q-1)/2` characters, i.e. `(q-1)/4` pairs of degree `q-1`,
   total `(q-1)^2/4`. The `q ≡ 3 (mod 4)` flag is also arithmetically right: there `(q+1)/2` is even
   and one gets `(q+1)/4` pairs, i.e. `(q^2-1)/4`.
2. **Basis-free description of the code.** Sound as framing; note it must be phrased in terms of the
   saturated discrete-series lattice rather than a "block", per F8.
3. **Stronger span statement.** Correct and immediate from Theorem A; verified computationally
   (every random nonzero word generates `K`).
4. **Three anchors nearly suffice.** Correct as stated — exactly 66 separated points and six fibres
   of size 2, i.e. a 12-point exceptional locus.
5. **The rigidity hypothesis is weaker than stated.** Plausible; the trivial-stabiliser half is
   already proved in the checkpoint, but "its intersection number is computable by the same two-line
   reduction" must carry the degenerate branch of F15.
6. **The full intersection array without search.** Overreaches as written: not every `p^r_{s,t}` is
   in `{0,2,4}` (`p^9_{9,10} = 1`, `p^1_{1,1} = 3`). The uniform two-line reduction survives, but
   the claim must be "two lines, each contributing 0, 1 or 2 points" with the Legendre condition
   plus a vanishing test.
7. **Closed-form family of minimum words for general odd `q`.** Plausible and correctly scoped as
   needing a proof; the count is consistent (`binom(14,2)·φ(14)/2 = 91·3 = 273` of 364 at `q = 13`).
8. **The Gram identity is not the orbit invariant it looks like.** Correct — the committed checks
   script itself reports the multiset `(A_9, A_9, A_{12}, A_{10})`, so the invariant takes a
   repeated value and cannot separate the four orbits.
9. **Both external citations become removable.** Correct given F8's repair; purely editorial.

---

## 5. Verdict

* **Gap A (Theorem A, target 3): sound with stated minor repairs.** The conclusion — `K` is an
  irreducible `F_2[PGL(2,13)]`-module with `End = F_8` and `dim_{F_8} K = 12`, so every nonzero
  codeword generates `K` — is correct and independently verified (enveloping algebra of dimension
  432, commutant of dimension 3). Two written steps need fixing: the individual block idempotents
  `e_i` in §1.7 (replace by Brauer-character additivity) and the `K_1 = 0` bullet, which must
  exclude `A_9|_K = 1` (one line, via `A_r = A_rT`). Lemmas A1, A2, A3, A5 are correct as written
  apart from two cosmetic slips (F5, F6).
* **Proposition A4 (`dim_{F_2} ker M = 36`): sound with a stated minor repair.** The upper bound is
  exactly right (verified char. polynomial and determinant). The lower bound as written rests on a
  sum of 2-block idempotents that provably does not lie in `Z_2[G]` — the three order-14 discrete
  series are not a union of 2-blocks — and must be replaced by the saturated lattice
  `L = V ∩ Z_2[Ω]`. With that substitution the proof is complete and the Madison–Wu citation can
  indeed be dropped.
* **Gap B (four-anchor rigidity): sound as written.** Theorem B1, the canonical Gram model, Lemma
  B2, Lemma B3 and Theorem B4 all survive an independent recomputation with no corrections needed;
  the sharpened fibre bound (66 + 6·2) is exactly right. The only defect in §2 is the informal
  "General mechanism" paragraph, whose uniform "0 or 2 solutions per line" claim is refuted by
  `p^9_{9,10} = 1` and `p^1_{1,1} = 3`; that paragraph and strengthening candidate 6 need the
  degenerate branch added. Corollary B should say "colour-preserving".

No claim in the verdict table of the note under review is false; three arguments need repair, all
local, and none of them costs more than a sentence.
