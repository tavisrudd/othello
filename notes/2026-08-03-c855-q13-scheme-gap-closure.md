# C855 — closing the two gaps of the q=13 passant-code checkpoint (targets 3 and 4)

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream); consumed by Paper IV / C834
**Continues:** `notes/2026-08-03-c855-q13-scheme-proofs.md` — this note closes the two gaps
that checkpoint left open, namely target 3 (span of every minimum-word orbit) and
target 4 (four-anchor rigidity). It also closes, as a by-product, the structural half of
target 5 (the Madison–Wu instance `dim ker M = 36`), which the checkpoint had declared
blocked.

Everything below is a pen-and-paper derivation. Numerical confirmations were run and are
itemised in §5; **no step of any proof depends on a computation**, and every computation
listed there is a check of an already-derived statement.

---

## 0. Standing notation and the inputs used

`q = 13`, `C : XZ - Y^2 = 0` in `PG(2,13)`,

    Δ(x,y,z) = y^2 - xz,   β(P,Q) = 2y_Py_Q - x_Pz_Q - z_Px_Q,   ρ(P,Q) = β(P,Q)^2/(Δ(P)Δ(Q)),

so `β(P,P) = 2Δ(P)` and `β` is the polarisation of `Δ`. Squares mod 13 are `{1,3,4,9,10,12}`;
`-1 = 12` is a square, `2`, `11` are nonsquares. `Ω` is the set of the 78 internal points
(`Δ(P)` a nonsquare), `G = PGL(2,13)` of order 2184, `H = G_{P_0} = D_28` the normaliser of a
nonsplit torus, `A_r` the adjacency matrix of the relation `ρ = r`, `M = A_0`, and
`K = ker_{F_2} M` the `[78,36,12]_2` code of `thm:q13-tangent-code`.

Inputs taken as given (all established in the checkpoint or in the companion):

* **(I1)** the six `ρ`-values `{0,1,3,9,10,12}` with valencies `(7,14,14,14,14,14)`, and the
  secant/passant colouring `{0,1,3}` / `{9,10,12}` (checkpoint target 1, PROVED);
* **(I2)** the mod-2 algebra `A_0^2 = I + A_9 + A_{10} + A_{12}`, `A_0A_r = 0` for
  `r ∈ {9,10,12}`, `A_r^2 = A_{(r-2)^2}`, hence `A_0^3 = A_0` and
  `F_2^{78} = im A_0 ⊕ K` (checkpoint target 2, PROVED);
* **(I3)** `G` acts transitively on `Ω` with rank 7, the `ρ`-levels being its orbitals; the
  triple stabiliser of an ordered triple whose first relation is passant-type and second is
  secant-type is trivial (checkpoint target 4, PROVED);
* **(I4)** the ordinary character table of `PGL(2,q)` for `q` odd: irreducible characters
  `1`, `η` (the order-2 linear character with kernel `PSL(2,q)`), `St` and `η·St` of degree
  `q`, principal series `χ_α` of degree `q+1` indexed by pairs `{α,α^{-1}}` of characters of
  the split torus `C_{q-1}` with `α^2 ≠ 1`, and discrete series `χ_θ` of degree `q-1` indexed
  by pairs `{θ,θ^{-1}}` of characters of the nonsplit torus `C_{q+1}` with `θ^2 ≠ 1`. Values:
  `St` is `q, 1, -1, 0` on the identity, split regular, nonsplit regular and unipotent
  classes; `χ_α` is `q+1, α(s)+α(s^{-1}), 0, 1`; `χ_θ` is `q-1, 0, -(θ(t)+θ(t^{-1})), -1`.

Note that `dim K = 36` is **not** used as an input: §1.5 proves it.

---

## 1. GAP A — every minimum-word orbit spans `K`

### 1.1 What is actually needed

The minimum words are by definition elements of `K`, and each orbit is a `G`-stable set of
nonzero vectors. So the whole of target 3 follows from

> **Theorem A.** `K` is an irreducible `F_2[PGL(2,13)]`-module, with
> `End_{F_2G}(K) = F_8` and `dim_{F_8} K = 12`.

because then the `F_2`-span of any nonzero `G`-orbit inside `K` is a nonzero submodule,
hence all of `K`. This is the route the checkpoint flagged but did not attempt; it makes the
Gram identity `N_i^{T}N_i = A_{r_i}` unnecessary. Indeed it gives more than the companion
claims: *every single nonzero codeword generates `K` as a `G`-module*, so the span assertion
needs no orbit-by-orbit input whatsoever.

The proof has four steps: identify the ordinary constituents of the permutation module on
`Ω` (§1.3); compute the eigenvalues of `M` on each of them (§1.4); deduce
`dim K = 36` and that `K` is exactly the sum of the three 12-dimensional discrete-series
block components (§1.5); and show that those three components are Galois-conjugate
absolutely irreducible modules (§1.6), which forces `F_2`-irreducibility (§1.7).

### 1.2 Lemma A1 — fixed internal points of odd-order elements

*The 2-regular classes of `G = PGL(2,13)` are: the identity; the class of elements of
order 3; three classes of elements of order 7; the class of elements of order 13. The
permutation character `π = 1^G_H` of `G` on `Ω` takes the values*

    π(1) = 78,   π(3) = 0,   π(7a) = π(7b) = π(7c) = 1,   π(13) = 0.

*Proof.* Element orders in `PGL(2,13)` divide `13`, `q-1 = 12` or `q+1 = 14`; the odd ones
are `1, 3, 7, 13`. Semisimple classes of `PGL(2,q)` are parametrised by the eigenvalue ratio
up to inversion, so order 3 gives one class (ratio of order 3 in `F_13^*`) and order 7 gives
three classes (ratio of order 7 in `μ_14`, three pairs `{r,r^{-1}}`); all nonidentity
unipotents are conjugate in `PGL`. That is 6 classes.

For the values, realise `Ω` as the set of Frobenius-conjugate pairs `{z, z^{13}}` in
`P^1(F_{169}) \ P^1(F_{13})`; this is the standard identification of internal points with
the pairs of conjugate points cut out on a line by the polarity, and `|Ω| = (169-13)/2 = 78`.
Let `g ≠ 1` have odd order and fix `{z,z^{13}}`. If `g` swaps the two points then `g^2`
fixes `z`; but `g^2` again has odd order and is `≠ 1`, and a nonidentity element of
`PGL(2,13)` fixing `z ∉ P^1(F_{13})` must be a nonsplit torus element, whence `g` itself
fixes `z` — contradiction. So `g` fixes both `z` and `z^{13}`, i.e. `g` lies in the nonsplit
torus determined by that pair. An element of order 3 lies in a split torus and fixes only
the two `F_13`-rational points of its axis, so it fixes no internal point: `π(3) = 0`. A
unipotent element fixes exactly one point of `P^1` over every extension, so it cannot fix a
conjugate pair: `π(13) = 0`. An element of order 7 lies in a unique nonsplit torus, whose
fixed pair is a single internal point: `π(7) = 1`. ∎

### 1.3 Lemma A2 — the ordinary decomposition of the permutation character

    π = 1 + η·St + χ_{α_3} + χ_{α_6} + χ_{θ_1} + χ_{θ_2} + χ_{θ_3},

*where `α_3`, `α_6` are the split-torus characters of order 3 and 6, and `θ_1, θ_2, θ_3` are
the three pairs `{θ,θ^{-1}}` of nonsplit-torus characters of **order 14**. In particular
each of the three degree-12 discrete series occurs with multiplicity exactly 1, and the
three discrete series of order-7 parameter do not occur at all.*

*Proof.* `H = N_G(T_{ns}) = D_{28}`, so
`⟨π, χ⟩ = (1/28)[ Σ_{t ∈ T_{ns}} χ(t) + Σ_{r} χ(r) ]`, the second sum over the 14 reflections
of `D_{28}`. Every reflection is an involution, and `PGL(2,13)` has two classes of
involutions: the split ones (eigenvalue ratio `-1` in `F_13^*`, contained in `PSL(2,13)`
because `13 ≡ 1 (mod 4)`) and the nonsplit ones (the involution of `T_{ns}`, outside
`PSL`). Applying the formula to `χ = η`, whose value is `+1` on `PSL` and `-1` outside and
which sums to 0 over the cyclic group `T_{ns}` of order 14, gives
`⟨π,η⟩ = (1/28)(0 + a - b)` with `a + b = 14`; integrality forces `a = b = 7`. **So the 14
reflections split as 7 split-type and 7 nonsplit-type involutions**, and `⟨π,η⟩ = 0`.

Now evaluate. `T_{ns} ≅ C_{14}` consists of the identity and 13 nonsplit regular elements,
and `η|_{T_{ns}}` is the nontrivial character of order 2 (because `T_{ns} ∩ PSL` has index 2
in `T_{ns}`), so over `T_{ns}`: `Σ 1 = 14`; `Σ St = 13 + 13·(-1) = 0`;
`Σ ηSt = 13 + Σ_{t≠1}(-1)η(t) = 13 - (0 - 1) = 14`; `Σ χ_α = 14 + 13·0 = 14`;
`Σ χ_θ = 12 - Σ_{t≠1}(θ(t)+θ(t^{-1})) = 12 - (0 - 2) = 14`.
Over the reflections: `St` is `1` on split and `-1` on nonsplit involutions, so
`Σ St = 0` and `Σ ηSt = 7·1·1 + 7·(-1)(-1) = 14`; `χ_α` vanishes on nonsplit involutions and
equals `2α(z_s)` on the split one (`z_s` the involution of the split torus), so
`Σ χ_α = 14 α(z_s)`; `χ_θ` vanishes on split involutions and equals `-2θ(z)` on the
nonsplit one (`z` the involution of `T_{ns}`), so `Σ χ_θ = -14 θ(z)`.

Hence `⟨π,1⟩ = 1`, `⟨π,St⟩ = 0`, `⟨π,ηSt⟩ = 1`,
`⟨π,χ_α⟩ = (1+α(z_s))/2` and `⟨π,χ_θ⟩ = (1-θ(z))/2`. Writing `g` for a generator of the
split torus `C_{12}`, `z_s = g^6`, so `α(z_s) = 1` exactly when `α` has odd order or order 6,
i.e. for `α` of order 3 and 6; and `θ(z) = -1` exactly when `θ` has order 14. Degrees check:
`1 + 13 + 14 + 14 + 12 + 12 + 12 = 78`. ∎

(That `π` is multiplicity-free with 7 constituents re-derives (I3)'s rank 7 independently.)

### 1.4 Lemma A3 — the spectrum of `M`

*On the seven constituents of `C[Ω]`, `M = A_0` acts by the scalars*

| constituent | `1` | `η·St` | `χ_{α_3}` | `χ_{α_6}` | `χ_{θ_i}` |
|---|---|---|---|---|---|
| dimension   | 1   | 13     | 14        | 14        | 12 (each) |
| eigenvalue  | 7   | `-3`   | 1         | 3         | `2(ϑ_i(r_0) + ϑ_i(r_0)^{-1})` |

*where `ϑ_i = θ_i|_{μ_7}` runs over the three pairs of order-7 characters of `μ_7` and `r_0`
is a fixed element of `μ_7` specified in the proof. In particular each discrete-series
eigenvalue is `2` times an algebraic integer, and the other four eigenvalues are odd.*

*Proof.* **(a) The unitary model.** Identify `P^1(F_{169})` with a coordinate `ω` in which
the Frobenius conjugation `σ` is `ω ↦ ω^{-13}`. A Möbius transformation
`ω ↦ (aω+b)/(cω+d)` commutes with `σ` iff `c = b^{13} = \bar b` and `d = \bar a`; hence

    G = PGL(2,13) ≅ { [[a, b],[\bar b, \bar a]] : a,b ∈ F_{169}, N(a) ≠ N(b) } / F_13^*,

which has `(169^2 - (1 + 12·14^2))/12 = 2184` elements, and `P^1(F_{13})` is the fixed set
`{ω : ω^{-13} = ω} = μ_{14}`. The internal points are the pairs `{ω, ω^{-13}}` with
`ω ∉ μ_{14} ∪ {0,∞}`.

**(b) The harmonic relation in this chart.** Fix the internal point `P_0 = {0,∞}` and let
`P = {ω,ω^{-13}}`. By the cross-ratio form of `ρ` (checkpoint target 1(e)),
`ρ(P_0,P) = 4(χ+1)^2/(χ-1)^2` with `χ` the cross-ratio `(z_0,\bar z_0 ; w, \bar w)`, which in
this chart is `ω/ω^{-13} = ω^{14}`. Hence

    ρ(P_0,P) = 0  ⟺  ω^{14} = -1.

The 14 such `ω` form one coset of `μ_{14}` and one `T`-orbit (`T = μ_{14}` the stabiliser of
`0`), giving the 7 harmonic neighbours of `P_0` — the valency-7 statement again.

**(c) A Hecke-algebra eigenvalue formula.** Let `Ω' = G/T = P^1(F_{169}) \ P^1(F_{13})`
(156 points) and let `\tilde A` be the adjacency matrix of the orbital `{ω : ω^{14} = -1}`
of `T` on `Ω'`, of valency 14. `T` has 13 orbits on `Ω'` (the two fixed points `0,∞` and 11
free orbits), and `Ind_T^G 1 = 1 + ηSt + Σ_{5}χ_α + Σ_{6}χ_θ` has exactly 13 constituents by
the computation in Lemma A2 restricted to `T` alone; so `Ind_T^G 1` is multiplicity-free and
the orbital operators are simultaneously diagonalised. For a multiplicity-one constituent
`χ` and the Hecke element `h = |T|^{-1} Σ_{d ∈ D} d`, where `D = {g : g(0) ∈ O}` and `O` is
the orbit, the eigenvalue is `u'_χ = |T|^{-1} Σ_{d∈D} χ(d)` (the operator `ρ_χ(h)` has image
the one-dimensional space `V_χ^T`, so its trace is the eigenvalue).

The projection `Ω' → Ω` is the 2:1 map `G/T → G/N_G(T)`; a function pulled back from `Ω`
has `(\tilde A f)(ω) = 2 (A_0 f)(\bar ω)`, so `\tilde A` restricts to `2A_0` on `C[Ω]` and

    u_χ(A_0) = u'_χ(\tilde A)/2.

**(d) The double coset.** With `g = [[a,b],[\bar b,\bar a]]` one has `g(0) = b/\bar a`, so
`g(0)^{14} = N(b)/N(a)`, and `D = { g : N(a) = -N(b) }`. The character value `χ(g)` depends
only on `(Tr, det) = (a + \bar a, 2N(a))`, i.e. only on `a`, and for each `a` there are
exactly 14 admissible `b`; dividing by the 12 scalars,

    u'_χ = (1/14)·(14/12)·Σ_{a ∈ F_{169}^*} χ(g_a) = Σ_{ε ∈ μ_{14}} χ(g_ε),

since `a ↦ ε := a^{12}` identifies `F_{169}^*/F_{13}^*` with `μ_{14}` and `g_a` depends only
on `ε`.

**(e) Which class is `g_ε`.** With `y := ε + ε^{-1} ∈ F_{13}` one computes
`Tr^2/det = (a+\bar a)^2/(2N(a)) = (ε + ε^{-1} + 2)/2`, so the eigenvalue ratio `r` of `g_ε`
satisfies

    r + r^{-1} = c(y) := (y - 2)/2.

The values `y` realised by `ε ∈ μ_{14}` are `y = 2` (`ε = 1`), `y = -2` (`ε = -1`), and the
six `y` with `y^2 - 4` a nonsquare, namely `y ∈ {3,5,6,7,8,10}`, each from a pair
`{ε, ε^{-1}}`. Since `ε^7 = ±1` separates order-7 from order-14 parameters and the three `y`
belonging to `ε ∈ μ_7` sum to `-1`, that triple is `{7,8,10}` and the order-14 triple is
`{3,5,6}`. Now `c(y) = 7(y-2)`, and `g_ε` is split, unipotent or nonsplit according as
`c^2-4` is a nonzero square, zero, or a nonsquare:

| `y` | 2 | `-2` | 3 | 5 | 6 | 7 | 8 | 10 |
|---|---|---|---|---|---|---|---|---|
| `ord ε` | 1 | 2 | 14 | 14 | 14 | 7 | 7 | 7 |
| `c` | 0 | `-2` | 7 | 8 | 2 | 9 | 3 | 4 |
| type of `g_ε` | split, `ord 4` | split involution | nonsplit, `ord 7` | nonsplit, `ord 7` | unipotent | split, `ord 12` | nonsplit, `ord 14` | split, `ord 12` |

(For `y = 6` one gets `c = 2`, `r = 1`, and `g_ε ≠ 1` because `N(b) = -N(a) ≠ 0`, so `g_ε`
is unipotent.) A consistency check: `η(g_ε) = (2N(a)|13) = -ε^7`, which is `+1` exactly for
`ε` of order 14 or `ε = -1`, i.e. exactly on the classes of order 7, 13, 2-split above —
precisely the classes lying in `PSL(2,13)`.

**(f) Evaluation.** `u_χ(A_0) = (1/2)[χ(g_1) + χ(g_{-1}) + 2Σ_{y ∈ {3,5,6,7,8,10}} χ(g_y)]`.

* `χ = 1`: `(1/2)(1 + 1 + 2·6) = 7`. ✓ (the valency)
* `χ = ηSt`: values are `-1, 1, -1, -1, 0, -1, 1, -1` in the table's column order, giving
  `(1/2)(-1 + 1 + 2(-1-1+0-1+1-1)) = -3`.
* `χ = χ_α`, `α` of order 3: with `2` a primitive root mod 13, `α(r) = ω^{ind r}`; the split
  classes have `r = 5, -1, 7, 11` with indices `9,6,11,7`, so `α(r)+α(r^{-1})` is
  `2, 2, -1, -1`; nonsplit classes give 0 and the unipotent gives 1. Sum
  `(1/2)(2 + 2 + 2(0 + 0 + 1 - 1 + 0 - 1)) = 1`.
* `χ = χ_α`, `α` of order 6: the same four split classes give `-2, 2, 1, 1`, so
  `(1/2)(-2 + 2 + 2(0+0+1+1+0+1)) = 3`.
* `χ = χ_θ` with `θ` of order 14: `χ_θ` vanishes on split classes and equals `-1` at the
  unipotent, so only `y ∈ {3,5,8}` and `y = 6` contribute. Write `μ_7 = {1, r_1, r_2, r_0, …}`
  with `r_1, r_2, r_0` representing the three pairs, labelled so that
  `r_j + r_j^{-1}` has `c`-value `7, 8, 10` respectively. Then the class at `y = 3` has
  parameter `r_1`, at `y = 5` parameter `r_2`, and at `y = 8` (where `c = 3 = -10`) parameter
  `-r_0`. With `w_j := ϑ(r_j) + ϑ(r_j)^{-1}` (`ϑ = θ|_{μ_7}`, of order 7) and
  `θ(-1) = -1`, the three discrete-series values sum to
  `-[w_1 + w_2 - w_0] = -[(-1 - w_0) - w_0] = 1 + 2w_0`, using `w_1+w_2+w_0 = Σ_{x≠1}ϑ(x) = -1`.
  Hence `u = (1/2)·2·[(1 + 2w_0) + (-1)] = 2w_0`.

As `θ` runs over the three order-14 pairs, `ϑ` runs over the three order-7 pairs and `2w_0`
runs over the three conjugates of `2(ζ_7 + ζ_7^{-1})`, i.e. over the roots of
`x^3 + 2x^2 - 8x - 8`. ∎

### 1.5 Proposition A4 — `dim_{F_2} ker M = 36`, structurally

By Lemma A3 the characteristic polynomial of `M` over `Z` is

    (x-7)(x+3)^{13}(x-1)^{14}(x-3)^{14}·(x^3 + 2x^2 - 8x - 8)^{12},

so `det M = 7·(-3)^{13}·1^{14}·3^{14}·8^{12}`, an odd number times `2^{36}`. Since the
`F_2`-nullity of an integer matrix is at most the number of elementary divisors divisible by
`2`, which is at most `v_2(det M)`,

    dim_{F_2} ker M ≤ 36.

For the reverse inequality, let `e ∈ Z_2[G]` be the sum of the 2-block idempotents of the
three characters `χ_{θ_i}` (a single `Z_2`-block, since the `χ_{θ_i}` are Galois-conjugate
over `Q_2`), and put `L = e·Z_2[Ω]`, a `Z_2`-lattice of rank 36 by Lemma A2, and
`W = L/2L ⊆ F_2[Ω]`. Because `M` is a `G`-endomorphism it preserves `L`, and on `L ⊗ Q_2` it
acts with the three eigenvalues `2w_i`; the characteristic polynomial of `M|_L` is
`(x^3+2x^2-8x-8)^{12} ≡ x^{36} (mod 2)`, so `M` is **nilpotent** on `W`. Since `M^3 = M`
(input (I2)), nilpotence forces `M|_W = 0`, i.e. `W ⊆ K`. Hence `dim K ≥ 36` and therefore

    dim K = 36  and  K = W = the reduction of the discrete-series block.

∎

This is a complete structural proof of the single Madison–Wu instance the companion
consumes, so `\cite{MadisonWu2012}` can be dropped from `thm:q13-tangent-code` in the same
way the checkpoint dropped Hollmann–Xiang: the checkpoint's target 5 verdict ("blocked
structurally at pinning `dim K`") is superseded. The mechanism is worth naming: the four
"principal-block" eigenvalues `7, -3, 1, 3` are odd, so `M` is invertible mod 2 there, while
the discrete-series eigenvalues are `2 ×` (algebraic integer), so `M` dies mod 2 there. The
nullity 36 is `3 × 12` for the reason that there are three Galois-conjugate discrete series
of degree `q-1 = 12` in the permutation character.

### 1.6 Lemma A5 — the three block constituents are Galois-conjugate absolutely irreducibles

*Let `φ_i` be the Brauer character of `\bar F_2 ⊗ e_i Z_2[Ω]`, `i = 1,2,3`. Then each `φ_i`
is irreducible of degree 12, the three are pairwise distinct, and `Gal(\bar F_2/F_2)`
permutes them cyclically.*

*Proof.* Restrict `χ_{θ_i}` to `PSL(2,13)`: `θ_i` has order 14, so `θ_i|_{C_7}` is a
nontrivial character of `C_7` and `χ_{θ_i}|_{PSL}` is the corresponding discrete series of
`PSL(2,13)`, irreducible of degree 12. Now `|PSL(2,13)| = 2^2·3·7·13`, so `|PSL|_2 = 4`
divides 12, and `PSL(2,13)` has Sylow 2-subgroups of order 4 that are elementary abelian,
so its 2-singular classes are those of elements of order 2 and 6 — both split regular
semisimple, where every discrete series vanishes. Hence `χ_{θ_i}|_{PSL}` lies in a 2-block of
**defect zero**; its reduction mod 2 is therefore irreducible (and projective) of dimension
12. An `F_2[G]`-module whose restriction to a subgroup is irreducible is irreducible, so
`φ_i` is irreducible of degree 12.

The values of `φ_i` on the three classes of order 7 are `-(ϑ_i(r) + ϑ_i(r)^{-1})`, i.e. the
three Gaussian periods of `Q(ζ_7)^{+}`; these distinguish the `φ_i` pairwise, and the
Frobenius `x ↦ x^2` of `Gal(\bar F_2/F_2)` acts on 7th roots of unity by squaring, which
permutes the three pairs `{ϑ, ϑ^{-1}}` in a 3-cycle (`2` has order 3 in `(Z/7)^*/{±1}`).
Hence the three `φ_i` form one Galois orbit of length 3, each realisable over `F_8` and over
no smaller field. ∎

### 1.7 Theorem A and its corollary

**Theorem A.** `K` is irreducible as an `F_2[PGL(2,13)]`-module; `\bar F_2 ⊗ K ≅ φ_1 ⊕ φ_2 ⊕ φ_3`,
and `End_{F_2G}(K) ≅ F_8`.

*Proof.* By Proposition A4, `K = W = L/2L` with `L` the discrete-series block lattice, so
`\bar F_2 ⊗ K` has composition factors exactly `φ_1, φ_2, φ_3`, each with multiplicity 1
(each `e_iL` has rank 12 and reduces to the irreducible `φ_i`, so `\bar F_2 ⊗ K` is in fact
semisimple). Let `0 ≠ U ⊆ K` be an `F_2[G]`-submodule. Then `\bar F_2 ⊗ U` is a
`\bar F_2[G]`-submodule whose multiset of composition factors is a nonempty sub-multiset of
`{φ_1,φ_2,φ_3}`, and it is stable under `Gal(\bar F_2/F_2)` because `U` is defined over
`F_2`. By Lemma A5 that Galois group permutes `{φ_1,φ_2,φ_3}` transitively, so the
sub-multiset is all of it and `dim U = 36 = dim K`, i.e. `U = K`. Hence `K` is irreducible.
Its endomorphism algebra is a finite division algebra, hence a field, and it is `F_8`
because `K ⊗ \bar F_2` splits into 3 non-isomorphic absolutely irreducible summands. ∎

**Corollary A (target 3, closed).** *Every `PGL(2,13)`-orbit of minimum words of `K` spans
`K`; more strongly, every single nonzero word of `K` generates `K` as an `F_2[G]`-module.*

*Proof.* The `F_2`-span of the `G`-orbit of a nonzero `w ∈ K` is a nonzero submodule of `K`,
hence equals `K`. ∎

The Gram identity `N_i^{T}N_i = A_{r_i}` is therefore **not needed** for the span
assertion. It remains true — the sibling confirmation run reports
`(N_1^{T}N_1, …, N_4^{T}N_4) = (A_9, A_9, A_{12}, A_{10})` mod 2 for all four orbits, and
check C7 below independently reproduces the `A_{12}` entry for the orbit whose 12 points the
companion lists — and it remains a useful invariant of the four orbits, but the theorem is
now independent of it. Note that it is not a complete orbit invariant: two of the four orbits
share the Gram `A_9`.

Two further payoffs, both directly consumable by Paper IV:

* `End_{F_2G}(K) = F_8` and `A_9|_K` is an `F_8`-scalar of multiplicative order 7, with
  `A_{10}|_K = (A_9|_K)^2` and `A_{12}|_K = (A_9|_K)^4` its two Frobenius conjugates. This
  identifies packet 6's "hidden field" as the field of definition of the discrete-series
  block, and explains the 3-cycle `A_9 → A_{10} → A_{12}` of checkpoint §2.3 as Galois
  conjugation. In particular `K_1 = ker(A_9 + I)|_K = 0` is automatic, since `A_9|_K` is a
  scalar of order 7 in `F_8^*`.
* The automorphism group of the code contains no more than the scheme automorphisms: any
  linear map commuting with `G` on `K` is an `F_8`-scalar.

---

## 2. GAP B — four-anchor rigidity

The checkpoint proved that a triple with a passant-type first relation and a secant-type
second relation has trivial stabiliser. The two residual items were the intersection number
`p^{10}_{3,9} = 2` and the four-class sign elimination. Both are settled below.

### 2.1 Theorem B1 — `p^{10}_{3,9} = 2`, and the general mechanism

*Let `P_0, P_1` be internal with `ρ(P_0,P_1) = 10`. Then there are exactly two internal
points `P_2` with `ρ(P_0,P_2) = 3` and `ρ(P_1,P_2) = 9`.*

*Proof.* Normalise the representatives so that `Δ(P_0) = Δ(P_1) = n` for one fixed nonsquare
`n` (possible since `Δ(λP) = λ^2Δ(P)` sweeps a whole square class), and write
`β(P_0,P_1) = nb`; then `b^2 = ρ(P_0,P_1) = 10`, so `b = ±6`, and replacing `P_1` by `-P_1`
if necessary we may take `b = 6`.

The plane `U = ⟨P_0,P_1⟩` has `β`-Gram determinant `n^2(4-b^2) = -6n^2 ≠ 0`, so `U` is
nondegenerate; let `e` span `U^{⊥}` and put `c = Δ(e) ≠ 0`. Write `P_2 = αP_0 + γP_1 + δe`.
Then

    β(P_0,P_2) = n(2α + bγ),   β(P_1,P_2) = n(bα + 2γ),
    Δ(P_2)     = n(α^2 + bαγ + γ^2) + δ^2 c.

**Step 1 (the ratio condition is linear).** Dividing the two relation equations,

    (bα+2γ)^2 / (2α+bγ)^2 = 9/3 = 3,

(the denominator cannot vanish, since `2α+bγ = 0` would force `Δ(P_2) = 0`). As `3 = 4^2` is
a square mod 13, this is equivalent to `bα + 2γ = s(2α + bγ)` with `s = ±4`. With `b = 6`:

* `s = 4` gives `-2α = 22γ`, i.e. `α = 2γ`;
* `s = -4` gives `14α = -26γ`, i.e. `α = 0`.

So `P_2` lies on one of the two lines `L_+ = ⟨2P_0 + P_1, e⟩` and `L_- = ⟨P_1, e⟩`. (Neither
line contributes the point `e` itself, which would force `Δ(e) = 0`.)

**Step 2 (each line gives 2 or 0 points).** Substituting into `β(P_0,P_2)^2 = 3Δ(P_0)Δ(P_2)`:

* on `L_+` (`α = 2γ`): `2α+bγ = 10γ` and `α^2+bαγ+γ^2 = 17γ^2 = 4γ^2`, giving
  `9nγ^2 = 3(4nγ^2 + cδ^2)`, i.e. `δ^2/γ^2 = -n/c`;
* on `L_-` (`α = 0`): `2α+bγ = 6γ` and `α^2+bαγ+γ^2 = γ^2`, giving
  `10nγ^2 = 3(nγ^2 + cδ^2)`, i.e. `δ^2/γ^2 = 7n/(3c) = 11·(n/c)`.

Here `γ ≠ 0` on both lines (`γ = 0` leaves the point `e`, already excluded), and `δ ≠ 0`
because the displayed right-hand sides `-n/c` and `11n/c` are nonzero. So each line carries
exactly 2 solutions if its right-hand side is a square in `F_{13}^*`, and none otherwise.

**Step 3 (exactly one line works).** Put `κ = n/c`. Since `-1` is a square, `L_+` contributes
iff `κ` is a square; since `11` is a nonsquare, `L_-` contributes iff `κ` is a nonsquare.
Exactly one of these holds, so `p^{10}_{3,9} = 2`. ∎

Note that the argument never needs to know the square class of `κ` — the two cases are
exchanged by a nonsquare factor and are exhaustive and exclusive. It also never needs
`P_2` to be checked internal: `ρ(P_0,P_2) = 3` is a nonzero square and `Δ(P_0)` is a
nonsquare, so `Δ(P_2)` is a nonsquare automatically.

**General mechanism.** For any `r` and any nonzero `s,t`, the same two steps compute
`p^{r}_{s,t}`: the ratio `t/s` is automatically a square (all nonzero `ρ`-values are
squares), so the pair of relation equations always reduces to two lines through the pole of
`P_0P_1`, on each of which one quadratic in `δ/γ` decides between 0 and 2 solutions. This
replaces the checkpoint's remark that "the `r ≠ s` case defeats the line-pair pencil trick
of §2.3": the correct pencil here is not the pencil of the two conics but the pencil of
lines through `U^{⊥}`, and the mixed case is *easier*, not harder, than the equal case.

**Corollary (simple transitivity).** By (I3) the stabiliser of such a triple is trivial, so
the number of ordered triples with pattern `(10,3,9)` is
`78 · 14 · p^{10}_{3,9} = 78·14·2 = 2184 = |G|`, and `G` acts **simply transitively** on
them. This is exactly the companion's `2184`, now derived rather than counted.

Two structural remarks fall out. First, the reflection of `V` fixing `U` pointwise and
negating `e` lies in `O(Δ)`, hence in `PGL(2,13)`; it fixes `P_0` and `P_1` and interchanges
the two solutions `P_2`, which re-proves the checkpoint's parity argument (`p` is even) and
identifies the pair-stabilising involution concretely. Second, `p ∈ {2,4}` was the
checkpoint's residual ambiguity; the two-line decomposition shows the four intersection
points of the two conics `Γ_3(P_0)` and `Γ_9(P_1)` always split as `2` rational and `2`
conjugate over `F_{169}`.

### 2.2 The canonical Gram model of a `(10,3,9)` triple

By the corollary, all ordered triples with pattern `(10,3,9)` are `G`-equivalent, so every
statement about the four-anchor signature may be verified in one model.

Normalise `Δ(P_i) = n` (one fixed nonsquare) for `i = 0,1,2`, and write
`β(P_i,P_j) = n b_{ij}`, so `b_{01}^2 = 10`, `b_{02}^2 = 3`, `b_{12}^2 = 9`, i.e.
`(b_{01},b_{02},b_{12}) = (±6, ±4, ±3)`. Replacing `P_i` by `-P_i` flips two of the three
signs, so the sign class is pinned by one invariant. Let

    G = [[2, b_{01}, b_{02}],[b_{01}, 2, b_{12}],[b_{02}, b_{12}, 2]],

the Gram matrix of `β` divided by `n`. The Gram matrix of `β` in the standard coordinates has
determinant `-2`, so `n^3 det G` must lie in the square class of `-2 = 11`; as `n^3` is a
nonsquare and `11` is a nonsquare, **`det G` must be a square**. Expanding,

    det G = 8 - 2(b_{01}^2 + b_{02}^2 + b_{12}^2) + 2 b_{01}b_{02}b_{12}
          = 8 - 2(10+3+9) + 2 b_{01}b_{02}b_{12} = 3 + 2 b_{01}b_{02}b_{12},

so `det G` depends only on the product `b_{01}b_{02}b_{12}`, which is exactly the invariant
left over after the sign flips (flipping `P_i` changes two of the three factors). The choice
`(6,4,3)` gives product `7` and `det G = 4` (a square); the opposite product `6` gives
`det G = 2` (a nonsquare) and is not realised. Hence, after replacing some `P_i` by `-P_i`,

    G = [[2,6,4],[6,2,3],[4,3,2]],    det G = 4,
    G^{-1} = [[2,0,9],[0,10,11],[9,11,5]].

Given a normalised internal point `P` (i.e. `Δ(P) = n`, determined up to `P ↦ -P`) with
coordinate vector `u` in the basis `(P_0,P_1,P_2)`, set `v = Gu`, so that
`β(P,P_i) = n v_i` and `ρ(P,P_i) = v_i^2`. The condition `Δ(P) = n` reads

    Q(v) := v^{T}G^{-1}v = 2.

Thus the 78 internal points correspond bijectively to the `156` vectors with `Q(v) = 2`,
modulo `v ↦ -v` (`156 = 169 - 13` is the correct level-set size for the nonsquare class of a
nondegenerate ternary form over `F_{13}`), and

    the three-anchor signature of P is (v_0^2, v_1^2, v_2^2).

One structural feature of the `(10,3,9)` pattern deserves naming, because it is what makes
the whole sign analysis collapse: `(G^{-1})_{01} = 0`, equivalently `2b_{01} = b_{02}b_{12}`
(`12 = 12`). In geometric terms `G^{-1}` is the Gram matrix of the dual basis, whose vectors
are the poles of the three sides of the triangle `P_0P_1P_2`; so

> **in a `(10,3,9)` triangle the pole of the side `P_1P_2` lies on the side `P_0P_2`.**

### 2.3 Lemma B2 — three-anchor fibres have size at most 2

*Two internal points have the same three-anchor signature iff their vectors `v, v'` satisfy
`v'_i = ±v_i`. Modulo the global sign, the candidates for a partner of `v` are `D_kv`
(`D_k` negating the `k`-th coordinate, `k = 0,1,2`), and `D_kv` again satisfies `Q = 2` iff*

    c_k(v) := Σ_{j ≠ k} (G^{-1})_{kj} v_k v_j = 0.

*With the canonical `G` this reads*

    c_0 = 9 v_0 v_2,   c_1 = 11 v_1 v_2,   c_2 = v_2 (9v_0 + 11 v_1).

*Consequently every three-anchor fibre has size 1 or 2, and size 2 occurs exactly when
either (i) `v_0,v_1,v_2 ≠ 0` and `9v_0 + 11v_1 = 0`, with partner `(v_0,v_1,-v_2)`, or
(ii) `v_2 = 0` and `v_0,v_1 ≠ 0`, with partner `(-v_0,v_1,0)`.*

*Proof.* `ρ(P,P_i) = v_i^2` determines `v_i` up to sign, and `Q(D_kv) - Q(v) = -4c_k(v)`,
whence the criterion. The displayed `c_k` are read off from `G^{-1}`, whose `(0,1)` entry
vanishes. If all `v_i ≠ 0` then `c_0` and `c_1` are nonzero, so the only possible partner is
`D_2v` and it occurs iff `9v_0+11v_1 = 0`. If exactly one `v_i = 0` the remaining cases are:
`v_0 = 0` (then `D_0v = v`, and `c_1, c_2 ≠ 0`, fibre size 1), `v_1 = 0` (then `D_1v = v`,
`c_0, c_2 ≠ 0`, fibre size 1), `v_2 = 0` (then `c_0 = c_1 = c_2 = 0`, `D_2v = v` and
`D_0v = -D_1v`, fibre size 2). If two coordinates vanish, all the `D_k` act trivially modulo
the global sign and the fibre has size 1. ∎

This is the sharp form of the checkpoint's "at most four sign classes": the correct bound is
**two**, and the exceptional locus is a single line condition.

### 2.4 Lemma B3 — `P_3` is the unique internal point of signature `(3,1,9)`

*In the canonical model the vector of `P_3` is `w = (-4, 1, 3)` up to sign, and its
coordinate vector is `t = G^{-1}w = (6,4,3)`.*

*Proof.* Signature `(3,1,9)` means `w_0 = ±4`, `w_1 = ±1`, `w_2 = ±3`; fix `w_2 = 3` using the
global sign. Expanding `Q(w) = 2` with `G^{-1}` gives
`2·3 + 10·1 + 5·9 + 2(9w_0w_2 + 11w_1w_2) = 2`, i.e. `9 + 5w_0w_2 + 9w_1w_2 = 2`, i.e.
(with `w_2 = 3`) `2w_0 + w_1 = 6`. Of the four sign choices only `(w_0,w_1) = (-4,1)`
satisfies it. Then `t = G^{-1}w = (6,4,3)`. ∎

So the companion's clause "`P_3` is the unique internal point with relation signature
`(3,1,9)`" is a one-line square-class computation, not a scan of 78 points.

### 2.5 Theorem B4 — the four-anchor signature separates all 78 internal points

*For `P` with vector `v`, `β(P,P_3) = n(v·t)`, so the fourth entry of the signature is
`(v·t)^2` with `t = (6,4,3)`. This separates the two members of every size-2 fibre.*

*Proof.* By Lemma B2 there are only two kinds of size-2 fibre.

*Case (i): `9v_0 + 11v_1 = 0`, partner `v' = (v_0,v_1,-v_2)` with `v_2 ≠ 0`.* Then
`v·t = t_0v_0+t_1v_1+t_2v_2` and `v'·t = t_0v_0+t_1v_1-t_2v_2`; their squares agree iff
`t_2v_2 = 0` or `t_0v_0 + t_1v_1 = 0`. The first fails because `t_2 = 3 ≠ 0` and `v_2 ≠ 0`.
For the second, `9v_0 + 11v_1 = 0` gives `(v_0,v_1) = v_0(1, 11)` (using `4/11 = 11`
after `11^{-1} = 6`), so `t_0v_0+t_1v_1 = v_0(t_0 + 11t_1) = v_0·(6 + 44) = 11 v_0 ≠ 0`.

*Case (ii): `v_2 = 0`, `v_0,v_1 ≠ 0`, partner `v' = (-v_0,v_1,0)`.* Then `v·t = t_0v_0+t_1v_1`
and `v'·t = -t_0v_0+t_1v_1`; their squares agree iff `t_0v_0 = 0` or `t_1v_1 = 0`, and
`t_0 = 6 ≠ 0`, `t_1 = 4 ≠ 0`.

Finally the anchors themselves are separated by the diagonal convention (equivalently, by
`ρ(P,P) = 4` not being one of the six relation values). Hence the map
`P ↦ (ρ(P,P_0),ρ(P,P_1),ρ(P,P_2),ρ(P,P_3))` is injective on `Ω`. ∎

**Corollary B (target 4, closed).** *The four points `P_0,P_1,P_2,P_3` are a geometric base:
`G` acts simply transitively on the ordered `(10,3,9)`-triples (Theorem B1), the fourth
anchor is canonically determined (Lemma B3), and the four-anchor signature separates points
(Theorem B4). Hence a scheme automorphism can be composed with a unique element of `G` so as
to fix `P_0,P_1,P_2`; it then fixes `P_3` and every internal point, so
`Aut(scheme) = PGL(2,13)`.*

The checkpoint's "at most four sign classes, finishing not done" is thus replaced by an
exact statement: the fibres have size at most 2, the exceptional locus is the line
`9v_0 + 11v_1 = 0` together with the plane section `v_2 = 0`, and the fourth anchor
separates because `t = (6,4,3)` has `t_0, t_1, t_2` and `t_0 + 11t_1` all nonzero. No scan
over 78 points appears anywhere.

---

## 3. Incidental: an explicit description of three of the four minimum-word orbits

This was found while setting up the `F_{169}` chart of §1.4 and is recorded because it makes
three of the four orbits of `thm:q13-tangent-code` completely explicit.

For a secant line with conic points `A, B`, take the Möbius coordinate on `P^1(F_{169})`
sending `A ↦ 0`, `B ↦ ∞`, and for an internal point `P = {z, \bar z}` put
`ζ(P; A,B) = ((z-A)/(z-B))^{12} ∈ μ_{14}`. This is invariant under the split torus fixing
`A,B` and is inverted by the reflection swapping them, so its level sets `{ζ, ζ^{-1}}` are
exactly the seven orbits of `D_{24} = N_G(\text{split torus})` on `Ω`: one of size 6
(`ζ = -1`) and six of size 12.

Moreover `ζ(P)^7 = (β(P,A)β(P,B) | 13)`, the Legendre symbol: indeed if `P` corresponds to
the binary quadratic form `f` with roots `z, \bar z`, then `f(A) = x·N(z-A)` and likewise at
`B`, so `ζ^7 = (N(z-A)/N(z-B))^{6} = (f(A)/f(B)|13) = (β(P,A)β(P,B)|13)`.

**Observed (check C7 in §5):** the three `D_{24}`-orbits of size 12 with `ζ` of order 14
(equivalently `ζ^7 = -1` and `ζ ≠ -1`, equivalently `β(P,A)β(P,B)` a nonsquare with `P`
outside the exceptional sextet) are minimum words of `K`; the three with `ζ ∈ μ_7` are not.
This exhibits `3 × 91 = 273` of the 364 minimum words in closed form, indexed by
(secant line) × (order-14 class in `μ_{14}` up to inversion), and it explains the stabiliser
`D_{24}` and the orbit length 91 structurally.

The parallel with Lemma A2 is not a coincidence worth ignoring: the three discrete series
occurring in the permutation character are exactly those with **order-14** torus parameter,
and the three `D_{24}`-orbits that are codewords are exactly those with **order-14**
cross-ratio invariant. A proof that the order-14 level sets lie in `ker M` (equivalently,
that every passant line meets each of them evenly) is not attempted here; it is the natural
next structural target, and it would give a closed-form construction of three quarters of
the minimum layer. Logged as a lead, not a deliverable.

---

## 4. Verdict table

| gap | verdict |
|---|---|
| A — span of every minimum-word orbit (checkpoint target 3) | **proved.** `K` is an irreducible `F_2[PGL(2,13)]`-module with `End = F_8` (Theorem A), so every nonzero word — a fortiori every orbit — generates `K`. The Gram identity `N_i^{T}N_i = A_{r_i}` is no longer needed. |
| B(i) — `p^{10}_{3,9} = 2` (checkpoint target 4) | **proved.** Theorem B1: the two relation equations reduce to two lines through the pole of `P_0P_1`, and exactly one of them meets the level set, because the two solvability conditions differ by the nonsquare 11. Gives simple transitivity on the 2184 triples. |
| B(ii) — four-class sign elimination (checkpoint target 4) | **proved, and sharpened.** Lemma B2: fibres of the three-anchor signature have size at most **2** (not 4), with an explicit exceptional locus; Lemma B3: `P_3` is unique by a square-class computation; Theorem B4: the fourth anchor separates because `t = (6,4,3)` has `t_0,t_1,t_2, t_0+11t_1` all nonzero. |
| bonus — `dim_{F_2} ker M = 36` (checkpoint target 5, Madison–Wu) | **proved.** Proposition A4, from the spectrum of Lemma A3: `v_2(det M) = 36` bounds the nullity above, and the discrete-series block reduces into `ker M` because its eigenvalues are `2 ×` an algebraic integer and `M^3 = M`. The external citation can be dropped. |
| bonus — `K_1 = ker(A_9+I)|_K = 0` | **proved.** `A_9|_K` is an `F_8`-scalar of order 7 (Theorem A), so `A_9 + I` is invertible on `K`. |
| lead — closed form for three of the four minimum-word orbits | **stated with computational confirmation, proof open.** §3. |

Nothing in targets 3 and 4 is now blocked. The only remaining checkpoint item is target 6
(Hassett–Tschinkel transfer), untouched here.

---

## 5. Computations run (confirmations only; no proof depends on them)

Throwaway scripts under the session scratchpad, not committed; the committed confirmation
script for the checkpoint's numeric claims is being written separately. Each item below
records exactly what was checked.

* **C1** — enumeration of the 183 points of `PG(2,13)`, giving 78 internal, 91 external,
  14 conic points, and the `ρ`-value set `{0,1,3,9,10,12}` with valencies
  `(7,14,14,14,14,14)`. Confirms (I1).
* **C2** — the mod-2 identities `A_0^2 = I + A_9+A_{10}+A_{12}`, `A_0A_r = 0` for
  `r ∈ {9,10,12}`, `A_9^2 = A_{10}`, `A_{10}^2 = A_{12}`, `A_{12}^2 = A_9`, `A_1^2 = A_1`,
  `A_3^2 = A_1`, `A_0^3 = A_0`. Confirms (I2).
* **C3** — `rank_2 A_0 = 42`, `rank_2 A_9 = 36`, `dim K = 36`, and
  `rank((A_9+I)|_K) = 36` (i.e. `K_1 = 0`). Confirms Proposition A4 and the `K_1` corollary.
* **C4** — the real spectrum of `A_0`: eigenvalues `7` (multiplicity 1), `3` (14), `1` (14),
  `-3` (13) and the three roots of `x^3+2x^2-8x-8` (12 each). Confirms Lemmas A2 and A3
  simultaneously, since the multiplicities are the degrees `1,14,14,13,12,12,12`.
* **C5** — for all 1092 ordered pairs with `ρ = 10`, the count of `P_2` with signature
  `(3,9)` is 2 in every case, so `p^{10}_{3,9} = 2` exactly and constant. Confirms Theorem
  B1; the sibling confirmation run reports the same.
* **C6** — the companion's anchors `P_0=(1:0:2)`, `P_1=(1:1:7)`, `P_2=(1:0:7)`,
  `P_3=(1:1:3)` have `ρ`-pattern `(10,3,9)` and `P_3`-signature `(3,1,9)`; their normalised
  Gram is `[[2,7,4],[7,2,10],[4,10,2]]`, which is the canonical `[[2,6,4],[6,2,3],[4,3,2]]`
  after `P_1 ↦ -P_1`, with `det = 4`. In the canonical model: `|{Q(v)=2}| = 156`;
  three-anchor fibres have sizes only 1 and 2, six of them of size 2, matching the criterion
  of Lemma B2 on all 78 classes with zero mismatches; the unique signature-`(3,1,9)` class is
  `±(-4,1,3)` with `t = ±(6,4,3)`; and the four-anchor signature takes 78 distinct values.
  Confirms §2.2–§2.5.
* **C7** — the companion's explicit 12-point support is a weight-12 word of `K`; its
  `PGL(2,13)`-orbit has size 91 and its Gram reduces mod 2 to `A_{12}`, matching the
  companion's fourth entry. The same 12 points are exactly the `ζ`-level set for the secant
  through the conic points of parameters 4 and 5, and among that secant's seven `D_{24}`
  orbits the three codewords are exactly the three with `ζ` of order 14. Confirms §3 and the
  companion's `N_i^{T}N_i` entry for that orbit.

---

## 6. Strengthening candidates

Candidates only — each is a claim Paper I could make more broadly or frame more cleanly on
the strength of what is proved above. No novelty assessment is offered.

1. **Madison–Wu for every `q ≡ 1 (mod 4)`, by the same mechanism.** Claim: for the
   internal-point/passant-line incidence matrix `M` over `F_2`,
   `dim ker M = (q-1)^2/4`, because `ker M` is the mod-2 reduction of the sum of the
   discrete-series 2-blocks whose torus parameter `θ` satisfies `θ(z) = -1`, of which there
   are `(q-1)/4` pairs, each of degree `q-1`. Every ingredient of §1.3–§1.5 is written in a
   `q`-independent form except the two explicit `F_{13}` tables in Lemma A3(e,f). Cost:
   redo Lemma A3(e,f) with `q` general — the split/nonsplit trichotomy becomes a Legendre
   condition on `c(y) = (y-2)/2`, and the discrete-series eigenvalue should come out as
   `2 ×` a Gaussian period again. Moderate, self-contained. Lands: companion (replacing the
   citation), or a short standalone lemma in Paper IV. **Flag:** `q ≡ 3 (mod 4)` needs the
   parallel count separately — the naive character count there gives `(q^2-1)/4`, not
   `(q-1)^2/4`, so the roles of internal/external (and the valency of `ρ = 0`) shift and the
   argument must be redone, not transported.
2. **A basis-free description of the code.** Claim: `K` is canonically the mod-2 reduction of
   the order-14 discrete-series block of the permutation module on the internal points; the
   passant code `im M` is the complementary block. This replaces "the kernel of a `78 × 78`
   incidence matrix" by an intrinsic, representation-theoretic definition and makes the
   `[78,36]` parameters, the `F_8` structure, and the `A_9/A_{10}/A_{12}` Frobenius 3-cycle
   one statement instead of four. Cost: none beyond §1 — it is a restatement of Proposition
   A4 and Theorem A. Lands: main paper (framing paragraph), companion (proof).
3. **A stronger span statement than the manuscript makes.** Claim: `K` has **no** proper
   nonzero `PGL(2,13)`-invariant subcode, so every nonzero word generates it; "each of the
   four minimum orbits spans `K`" is a special case. Cost: none — Theorem A. Lands: main
   paper statement of `thm:q13-tangent-code`; it also makes the theorem robust to any future
   correction of the minimum-word orbit count.
4. **Three anchors nearly suffice.** Claim: the three-anchor signature `(ρ(P,P_0),ρ(P,P_1),
   ρ(P,P_2))` already separates 66 of the 78 internal points, with exactly six fibres of
   size 2; the fourth anchor is needed only on that explicit 12-point locus. Cost: none —
   Lemma B2. Lands: companion (it sharpens the rigidity clause and shortens the reduction).
5. **The rigidity hypothesis is weaker than stated.** Claim: the pattern `(10,3,9)` plays no
   special role. By (I3) plus the two-line method of Theorem B1, *any* ordered pattern whose
   first relation is passant-type and second is secant-type has trivial stabiliser, and its
   intersection number is computable by the same two-line reduction; simple transitivity
   holds whenever that number is 2. Cost: run the two-line computation for the remaining
   patterns (a short uniform calculation, one Legendre condition per line). Lands: companion.
6. **The full intersection array without search.** Claim: `p^{r}_{s,t}` for all `r,s,t ≠ 0`
   is given uniformly by the two-line reduction — the ratio condition is always linear
   because every nonzero `ρ`-value is a square — so the scheme's entire intersection array
   is a table of Legendre symbols rather than an enumeration. Cost: bookkeeping over the
   `5 × 5 × 5` patterns plus the `r = 0` degenerate cases. Lands: companion; it would retire
   the displayed integer intersection-number table entirely.
7. **A closed-form family of minimum words for general odd `q`.** Claim: for each secant line
   and each class `{ζ,ζ^{-1}}` of primitive elements of `μ_{q+1}`, the cross-ratio level set
   of §3 is a word of `K` of weight `q-1` with stabiliser the split-torus normaliser
   `D_{2(q-1)}`, giving `\binom{q+1}{2}·φ(q+1)/2` explicit words; at `q = 13` this is
   `91 × 3 = 273` of the 364 minimum words, of weight `12 = q-1`. Cost: prove the level sets
   lie in `ker M` (equivalently, that every passant line meets one evenly) — currently only
   checked at `q = 13`; plus a separate lower bound to conclude `d(K) = q-1`. Lands: Paper IV
   if it becomes a general construction, companion if it stays a `q = 13` description.
8. **The Gram identity is not the orbit invariant it looks like.** Claim: `N_i^{T}N_i` mod 2
   takes the value `A_9` on two of the four orbits, so it does not separate the orbit types
   and should not be presented as doing so; the `S_4` versus `D_{24}` stabiliser distinction
   is what separates them. Cost: none — a wording correction. Lands: companion.
9. **Both external citations become removable.** Claim: with Hollmann–Xiang replaced by
   checkpoint targets 1 and 4, and Madison–Wu by Proposition A4, `sec:q13-tangent-code`
   becomes self-contained apart from Segre's lemma of tangents. Cost: none beyond editing.
   Lands: companion.
