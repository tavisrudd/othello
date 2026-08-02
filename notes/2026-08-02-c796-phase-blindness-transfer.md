# C796 — does the golden orientation-sign construction transfer to the ame-lu phase gap? (2026-08-02)

**Lane**: `ame-lu`. Falsifier task. Read-only outside this report; `golden` was read and not
touched. No manuscript, queue, handoff, or Lean source edited.

**Verdict, up front: DOES NOT TRANSFER.** The two discarded layers are not the same kind of
object and not functions of one another. The golden layer is the component group of a compact
gauge group acting on the object, hence a finite elementary abelian 2-group; the ame-lu layer is
a compact abelian group with a positive-dimensional connected part, and a connected group admits
no nontrivial homomorphism to `Z/2` at all. Section 5 lists the four structural features the
golden construction uses that the ame-lu setting lacks. Section 6 answers the C794 question
without waiting for C794: its higher-moment programme is unusable here in principle, not merely
prematurely, because in the ame-lu setting every balanced cut's modulus data factors through the
same per-site data (Lemma D).

**But the lead should be closed upward, not sideways.** Two internal results proved here (§7)
show the ame-lu obstruction is smaller than C786 §4 states, for reasons entirely internal to the
MDS structure of the stabilizer label group and using no phase information whatsoever:

- **Theorem A.** For a stabilizer `AME(2m,q)` state with `m ≥ 2`, Proposition 9 alone yields
  `D ≤ 2√(q/c)·eps(U)` under the hypotheses *per-site spectral spread ≤ π* and *`D² ≤ q/4`*,
  with **no `ℓ¹` budget on `Σ_j ||h_j||_op` at all**. This strictly dominates the region of
  C786's Corollary 4 (which needs `t ≤ R_k ∼ k/e` as well), at the cost of a constant
  (`≈ π√q` versus `√(6q/5)`).
- **Theorem B.** C786 §4's named blocking example is false. For **every** stabilizer
  `AME(2m,2)` state with `m ≥ 2`, Proposition 9 gives `eps(H^{⊗2m})² ≥ 1` — nearly the maximal
  possible value, not a vacuous bound. The proof is three lines of binary-Singleton and needs no
  phase data. In particular `H^{⊗2m}` is never a symmetry of such a state.

Nothing in this report rests on a computation. Every statement is a proof or is explicitly
flagged as taken on another task's authority. No evidence bundle ships because no claim needs
one. No novelty is asserted anywhere; no literature audit has been run on this comparison.

---

## 0. Sources and what is taken on authority

Read in full: `notes/2026-08-01-c786-explicit-stability-threshold.md`,
`notes/2026-08-02-c788-general-balanced-cut-spectrum.md`,
`notes/golden-tasks/c794-conference-design-reconstruction.md`. Read in the relevant part:
`papers/golden-quantum-statistics/golden_quantum_statistics.tex` (abstract, introduction, the
Golden transfer section, "Why the determinant retains orientation" in full including
Theorem `thm:orbit-boundary`, Proposition `prop:unique-orientation-carrier` and the orientation-chambers
corollary, and "Balanced controls and calibrated readout" in full).

Verified by re-deriving: C786's Proposition 9 (the half-splitting bound), its Lemma 3 (per-site
contraction), its Lemma 6 (stabilizer overlap quantization), and the Golden left--right orbit
theorem and its minimal-degree proposition. These I use as proved.

Taken on the owning lane's authority, not re-derived: C788's balanced-cut spectrum theorem and
its aligned-four-set design corollaries; C794's seven-vertex census and Paley histograms; C786's
Proposition 7 (which C786 itself flags as depending on an unaudited manuscript proof); C774's
numerical ceiling `θ* = 1.4656`. None of my conclusions depend on any of these being correct —
they enter only as descriptions of what the golden programme is doing.

---

## 1. Both objects in the same balanced-cut coordinates

Fix a ground set `X` of `2d` objects (golden) or `n = 2m` parties (ame-lu), and a balanced
subset `T` resp. `A` of half size.

### 1.1 Golden

The fixed structure is a symmetric conference matrix `C` of order `2d`, `C² = qI`, `q = 2d−1`,
with its two `d`-dimensional eigenspaces `V_±` for `±√q`. The variable is a diagonal path
control `D_x`. The cut-indexed object is the cross block

```
K_T = Q_-^T D_T Q_+  :  V_+ → V_- ,       D_T = the ±1 sign involution of the cut T .
```

Two layers:

- **Modulus layer.** The squared singular spectrum of `K_T`, equivalently
  `Spec(H_T) = Spec(RR^T)/q = {1 − α_i²/q}` (C788). It is the complete invariant of the
  `O(V_-) × O(V_+)` double orbit. The filled-fermion probability `|det K_T|² = det(K_T^T K_T)` is
  a function of it.
- **Discarded layer.** `sgn det K_T ∈ {±1}`, one bit per cut. It is the extra label of the
  `SO(V_-) × SO(V_+)` orbit on the invertible locus.

### 1.2 ame-lu

The fixed structure is a stabilizer `AME(2m,q)` state `ψ`, `q = p^e`, with label group
`L ⊂ (F_q²)^n` and character `χ`. The variable is a product unitary `U = ⊗_j U_j`, with
`a_j(v) = q^{-1} Tr(W_v^† U_j)` and `p_j(v) = |a_j(v)|²`. The cut-indexed object is the pair of
half-products

```
u_A(ℓ) = ∏_{j∈A} |a_j(ℓ_j)| ,      v_A(ℓ) = ∏_{j∈A^c} |a_j(ℓ_j)|      (ℓ ∈ L) .
```

Two layers:

- **Modulus layer.** The pair `(u_A, v_A)` of unit vectors in `R^L`, and the bound
  `eps(U)² ≥ ||u_A − v_A||²`.
- **Discarded layer.** The phase function

  ```
  Φ(ℓ) = χ̄(ℓ) · ∏_j e^{i·arg a_j(ℓ_j)}      (ℓ ∈ L, defined where all a_j(ℓ_j) ≠ 0) ,
  ```

  through which the exact identity `⟨ψ|U|ψ⟩ = Σ_{ℓ∈L} Φ(ℓ) u_A(ℓ) v_A(ℓ)` factors.

### 1.3 A useful reformulation of the ame-lu cut object

Because `ψ` is `m`-uniform, its reduction to `A` is maximally mixed, so as a state of
`H_A ⊗ H_{A^c}` (both of dimension `q^m`) it is maximally entangled: `|ψ⟩ = (I ⊗ Γ_A)|Φ_max⟩`
for a unitary `Γ_A : H_A → H_{A^c}` determined by `ψ` and the cut. Then

```
⟨ψ|U|ψ⟩ = q^{-m} · Tr( U_A · (Γ_A^† U_{A^c} Γ_A)^T ) ,      U_A = ⊗_{j∈A} U_j .
```

**This is the sharpest way to see the mismatch.** The golden cut observable is a *determinant*
of a cross block; the ame-lu cut observable is a normalized *trace* of a product across the cut.
A determinant is the top exterior amplitude, so its modulus squared is a polynomial of which it
is a two-valued square root — that two-valuedness *is* the orientation sign. A trace has no
square-root structure: its modulus and its argument are independent real coordinates of one
complex number, and the argument varies continuously. There is no `Z/2` to be found.

---

## 2. What group does each discarded layer live in?

### 2.1 Golden: an elementary abelian 2-group, arising as `π_0` of the gauge group

Frame changes act by `K ↦ R_-^T K R_+` with `R_± ∈ O(d)`, and `det K ↦ det(R_-)det(R_+)·det K`.
Hence:

- The modulus layer is exactly the quotient of the space of blocks by the **full** compact group
  `G_gauge = O(V_-) × O(V_+)`.
- The discarded layer is exactly the residual action of
  `π_0(G_gauge) = (Z/2)²` through the product-of-parities character `(Z/2)² → Z/2`. For a single
  invertible cut, `sgn det K_T` is a torsor under that `Z/2`.
- Over the whole ensemble of balanced cuts (ten projective cuts at `d = 3`) the sign word lies in
  `{±1}^{10}`, and a re-orientation flips **all ten simultaneously**. So the discarded layer for
  the ensemble is

  ```
  G_gold = {±1}^{#cuts} / {±1}  ≅  (Z/2)^{#cuts − 1} ,
  ```

  an elementary abelian 2-group; the missing information beyond the *relative* sign word is
  exactly one bit. This is the content of the paper's remark that reversing the common
  orientation negates every signature but does not change the relative classifier, and of the
  distance-six simplex-code structure of the six protocols' sign words.

The golden recovery mechanism follows from this and is worth naming precisely: the layer is
recovered **by choosing a lift**, physically, via phase-referenced port frames. It is not
inferred from moduli. Calibration is an added laboratory resource, not a mathematical argument.

### 2.2 ame-lu: a compact abelian group with a nontrivial identity component

Write `Maps(L, U(1))` for `U(1)`-valued functions on `L`. The phase layer `Φ` lies in the
subgroup generated by

- the stabilizer character `χ ∈ Hom(L, U(1)) = L̂ ≅ L ≅ (Z/p)^{2me}` — finite, a `p`-group; and
- the image of the restriction map `∏_j Maps(F_q² , U(1)) → Maps(L, U(1))` given by site-local
  argument functions, modulo the `U(1)^n` of per-site global phases and the diagonal `U(1)` of
  the state's own phase.

Call this group `G_ame`. Three facts about it decide question 1.

1. **`G_ame` is not the component group of anything acting on the problem.** The modulus map
   `U_j ↦ (|a_j(v)|)_v` is not a quotient map by a group action on `U(q)`. The operations that do
   preserve the modulus profile — conjugation `U_j ↦ W_w U_j W_w^†` by a Weyl operator, which
   multiplies `a_j(v)` by the character `v ↦ ψ(⟨w,v⟩)` — are **not** symmetries of the defect
   functional: `⟨ψ|W_w U W_w^†|ψ⟩` is an overlap taken in the translated state `W_w^†ψ`, a
   different stabilizer state, unless `w` is a codeword. So there is no gauge group whose orbits
   are the fibres of the modulus map, and correspondingly no `π_0` to serve as the discarded
   layer. (A dimension count says the fibres are generically finite: `dim U(q)/U(1) = q² − 1`
   equals the number of free moduli `q² − 1`. Finite is not the same as *torsor*, and this is
   where the analogy is most tempting and most wrong.)
2. **The identity component of `G_ame` is a positive-dimensional torus**, of dimension up to
   `n(q² − 1) − n`, coming from the arguments of the `a_j(v)` at labels off the peak. A connected
   topological group admits **no nontrivial continuous homomorphism to `Z/2`**. So the site-argument
   part of the ame-lu layer has no `Z/2` quotient whatsoever — canonical or otherwise.
3. **The finite part `L̂` is a `p`-group.** For odd `p` it has no subgroup of index two, hence no
   `Z/2` quotient at all. For `p = 2` it has `2^{2me} − 1` of them and a balanced cut selects none
   of them: what a cut supplies is the bijection `π_A : L → (F_q²)^A` and the MDS transition map
   `M_A`, neither of which distinguishes a hyperplane of `L̂`.

**Answer to question 1.** Golden: `Z/2` per cut, globally `(Z/2)^{#cuts−1}`, arising as `π_0` of
the port-frame gauge group. ame-lu: `L̂ × (torus)`, with no distinguished two-element quotient,
and for odd characteristic no two-element quotient at all.

---

## 3. Is either a function of the other?

**No, in both directions, and the failures are of different kinds.**

**ame-lu phase data → a golden-style sign.** By §2.2(2)–(3) there is no homomorphism to `Z/2`
carrying the connected part, and for odd `p` none carrying the finite part either. One could of
course *choose* a non-canonical bit (e.g. threshold some argument), but that is not a quotient and
carries no covariance, so nothing built from it can play the role the orientation sign plays in
the golden argument, where the whole force comes from `det K_T` being an equivariant relative
invariant.

**A cut-attached `Z/2` in the ame-lu setting exists, but is the wrong object.** The one honest
candidate is arithmetic rather than analytic: writing `L` in cut coordinates as the graph of the
`F_q`-linear transition map `M_A : (F_q²)^A → (F_q²)^{A^c}` (the systematic generator of the MDS
code across the cut), the quadratic residue symbol of `det M_A ∈ F_q^*` is a genuine `Z/2`-valued
function of a balanced cut for odd `q`, and it is formally parallel to `sgn det R` for the golden
cross block. **But it is a function of `ψ` alone, not of `U`.** The discarded layer of Proposition 9
is a function of `U`. So this candidate map does not have the discarded layer as its domain and
cannot reproduce anything. I record it because it is the only place in the ame-lu setting where a
cut does select a sign, and because ruling it out is what makes the negative verdict tight rather
than merely plausible.

**Golden sign → ame-lu phase.** Not applicable: the golden sign is one bit of gauge lift, and the
ame-lu layer is a continuum of unknowns about an unknown operator.

**The one genuine shared mechanism, and why it is a rhyme.** Both are instances of "an invariant is
the image of a modulus map with a nontrivial fibre, and the open problem lives in the fibre." That
is where the resemblance ends, and the two fibres degenerate on *opposite* loci:

- The golden fibre collapses exactly on `det K_T = 0`, the **degenerate** locus, where the two
  orientation chambers merge (the paper's orientation-chambers corollary).
- The ame-lu fibre collapses exactly on the **Clifford** locus, where each `p_j` is a point mass
  and only one global phase survives — which is the **rigid** locus, where the answer is already
  known in closed form by C786's Lemma 6.

An analogy in which the two structures degenerate on opposite kinds of locus is not a transfer.

---

## 4. Where the difficulty sits in each programme

This is the observation that makes the verdict decisive rather than merely technical.

- The **golden** problem is entirely a discrete-layer problem. Its continuous gauge (`SO × SO`)
  is fully quotiented by the modulus invariant, exactly and with no loss; every remaining question
  is about a finite 2-group.
- The **ame-lu** problem is the reverse. Its discrete layer — the finite group `G(ψ)` of exact
  product-Clifford symmetries — is *already completely solved*, with a uniform gap
  `|⟨ψ|φ⟩| ≤ p^{-1/2}` that does not degrade with the party count (C786's Lemma 6, and the reason
  its Theorem 8 could delete the manuscript's compactness step). The entire open problem is on the
  connected part: bounding `|⟨ψ|U|ψ⟩|` away from 1 for local factors far from Clifford.

So the golden construction is a tool for the layer where ame-lu already has a **better** tool, and
is silent on the layer where ame-lu is stuck.

---

## 5. Verdict: DOES NOT TRANSFER

The golden construction relies on four structural features, and the ame-lu setting lacks all four.

1. **A compact gauge group acting on the object, whose full quotient is the modulus invariant and
   whose `π_0` is the discarded layer.** ame-lu has no such group: the modulus map is not a
   quotient map, and the modulus-preserving operations (Weyl conjugation) are not symmetries of
   the defect functional (§2.2(1)).
2. **A top exterior amplitude.** The golden observable is a determinant, whose modulus squared is
   a polynomial admitting exactly two square roots; that is the entire source of the `Z/2`. The
   ame-lu cut observable is a normalized trace (§1.3), which has no such structure.
3. **The cut acting on the object rather than on the bookkeeping.** In golden, `T` *is* the
   control `D_T`, so distinct cuts probe distinct transfers and the cut ensemble genuinely encodes
   `C` — that is what makes C788's spectra vary with `T` and makes C794's higher moments a route
   to sign recovery at all. In ame-lu the cut is only a bipartition used to apply Cauchy--Schwarz;
   see Lemma D below.
4. **A physical calibration resource to supply the missing lift.** Golden recovers the sign by
   freezing phase-referenced port frames — an addition to the apparatus, not an inference. There
   is no analogue: `eps(U)` is defined from `|⟨ψ|U|ψ⟩|` and the arguments are simply unknown, with
   nothing to calibrate against.

Additional evidence in the same direction: the inverted degeneracy loci (§3), the characteristic
obstruction (no `Z/2` quotient at all for odd `p`, §2.2(3)), and the inverted location of the
difficulty (§4).

**The lead can be closed.** No C786 successor should import anything from the golden orientation
construction or from calibrated readout.

---

## 6. Question 4: C794 is unusable here, now or after completion

The question was whether C794's higher-moment construction is usable before C794 completes.
Neither before nor after, and for a reason that does not depend on C794's outcome.

> **Lemma D (cut-aggregation futility).** For every balanced `A`, the pair `(u_A, v_A)` is a
> function of the site modulus profiles `(p_j)_{j=1..n}` alone. Consequently the entire family
> `{(u_A, v_A) : A balanced}` over all `C(2m,m)` cuts, and every statistic of that family, factors
> through `(p_j)_j`.

**Proof.** Immediate from the definition `u_A(ℓ) = ∏_{j∈A}|a_j(ℓ_j)|`: the cut selects which
factors enter, and the factors themselves are cut-independent. ∎

Compare the golden side, where the whole C788/C794 programme exists precisely because
`Spec(H_T)` genuinely *varies* with `T` and its variation counts aligned four-sets in `T`, i.e.
signed data of `C`. There the cut ensemble carries information about the object; here it carries
none beyond the single-site data.

Therefore: two product unitaries with identical site modulus profiles are indistinguishable by any
aggregation of Proposition 9 over any set of cuts, and by any moment of the cut ensemble. C794 is
in the business of extracting object-information from the variation of a cut ensemble. In the
ame-lu setting the cut ensemble does not vary in the required sense. The ame-lu side does not need
to wait for C794; it should not use it.

---

## 7. Internal upgrades: the ame-lu obstruction is smaller than C786 §4 states

Running the falsifier forced me to write Proposition 9 in coordinates where the *code* structure
of `L` is visible. Two results fall out, both proved by hand, both using **only moduli** and no
phase data at all. They are the useful product of this task.

Throughout: `ψ` is a stabilizer `AME(2m,q)` state, `n = 2m`, `L ⊂ (F_q²)^n` its label group, an
`F_q`-subspace with `|L| = q^{2m}` and minimum Hamming weight `m+1` (the `m`-uniformity condition).
By Singleton this is exactly MDS over the alphabet `F_q²`. `A` is a balanced cut,
`η_j = 1 − p_j(0) = 1 − |q^{-1}Tr U_j|²`, `H = Σ_j η_j`, `η = max_j η_j`.

### 7.1 The weight-`(m+1)` family

> **Lemma C (cut-transversal codewords).** For each `j ∈ A^c` let
> `L_j = {ℓ ∈ L : supp(ℓ) ⊆ A ∪ {j}}`. Then `|L_j| = q²`; every nonzero `ℓ ∈ L_j` has support
> exactly `A ∪ {j}`; and for every coordinate `i ∈ A ∪ {j}` the evaluation `ℓ ↦ ℓ_i` is a
> bijection `L_j → F_q²`.

**Proof.** `L_j` is the kernel of the projection `L → (F_q²)^{A^c∖{j}}`. That projection is
surjective because it factors the projection `π_{A^c}`, which is bijective; so
`|L_j| = q^{2m}/q^{2(m−1)} = q²`. A nonzero `ℓ ∈ L_j` has weight `≥ m+1` and support inside a set
of size `m+1`, so its support is that set. For `i ∈ A ∪ {j}`, the kernel of `ℓ ↦ ℓ_i` on `L_j`
consists of codewords supported in a set of size `m`, hence of weight `≤ m`, hence zero; the two
sets have the same cardinality `q²`. ∎

Write `ℓ^{j,w}` for the element of `L_j` with `j`-coordinate `w`. Mirroring `A ↔ A^c` gives, for
each `i ∈ A`, a family supported on `A^c ∪ {i}`. For `m ≥ 2` the two families meet `L` in disjoint
sets (their supports meet `A` in `m` and in `1` coordinates respectively).

### 7.2 Theorem A — stability with no `ℓ¹` budget

> **Theorem A.** Let `m ≥ 2`. With the notation above,
> ```
> ||u_A − v_A||²  ≥  ( ½(1 − H) − η^{m−1} ) · H .
> ```
> In particular if `H ≤ 1/4` and `m ≥ 3` then `eps(U)² ≥ ||u_A − v_A||² ≥ H/4`.

**Proof.** All terms of `||u − v||² = Σ_{ℓ∈L}(u(ℓ) − v(ℓ))²` are nonnegative, so it is at least
the sum over the two families of Lemma C. Fix `j ∈ A^c`. Since `ℓ^{j,w}` vanishes on `A^c ∖ {j}`,

```
v(ℓ^{j,w}) = |a_j(w)| ∏_{i ∈ A^c ∖{j}} |a_i(0)| ,      so
Σ_{w≠0} v(ℓ^{j,w})² = η_j ∏_{i ∈ A^c∖{j}} (1 − η_i)  ≥  η_j (1 − H) .
```

Since `ℓ^{j,w}` has all `A`-coordinates nonzero, `p_i(ℓ_i) ≤ 1 − p_i(0) = η_i` for every `i ∈ A`.
Fixing one `i_0 ∈ A` and using that `w ↦ ℓ_{i_0}^{j,w}` is injective (Lemma C),

```
Σ_{w≠0} u(ℓ^{j,w})²  =  Σ_{w≠0} ∏_{i∈A} p_i(ℓ_i^{j,w})
                     ≤  ( ∏_{i∈A∖{i_0}} η_i ) Σ_{w≠0} p_{i_0}(ℓ_{i_0}^{j,w})
                     ≤  ∏_{i∈A} η_i .
```

Summing the `u` bound over the `m` values of `j ∈ A^c` and using
`∏_{i∈A} η_i ≤ η^{m−1}·min_{i∈A}η_i ≤ η^{m−1}·(1/m)Σ_{i∈A}η_i`,

```
Σ_{j∈A^c} Σ_{w≠0} u(ℓ^{j,w})²  ≤  m ∏_{i∈A} η_i  ≤  η^{m−1} Σ_{i∈A} η_i .
```

Now `(x − y)² ≥ x²/2 − y²`, valid for all reals since it rearranges to `(x/√2 − √2 y)² ≥ 0`.
Applying it termwise and adding the mirror family (which contributes
`½(1−H)Σ_{i∈A}η_i − η^{m−1}Σ_{j∈A^c}η_j`) gives the displayed bound. For the last sentence,
`H ≤ 1/4` and `m ≥ 3` give `η^{m−1} ≤ H^{m−1} ≤ H² ≤ 1/16`, so the bracket is at least
`3/8 − 1/16 = 5/16 ≥ 1/4`. ∎

> **Corollary A'.** Suppose every site has spectral spread `s_j ≤ π` (so C786's Lemma 3 applies
> with `c = 4/π²`, or `c ≥ 1 − s²/12` for small spread) and `D² = Σ_j ||h_j||_F² ≤ q/4`. Then for
> `m ≥ 3`,
> ```
> eps(U)²  ≥  c D² / (4q) ,        i.e.       D  ≤  2 √(q/c) · eps(U) .
> ```

**Proof.** C786's Lemma 3 gives `p_j(0) = |q^{-1}Tr e^{ih_j}|² ≤ 1 − c ||h_j||_F²/q`, i.e.
`η_j ≥ c||h_j||_F²/q`, so `H ≥ cD²/q`. In the other direction
`1 − |E e^{iX}|² = 1 − E cos(X − X') ≤ ½E(X−X')² = Var X = ||h_j||_F²/q`, so `H ≤ D²/q ≤ 1/4` and
Theorem A applies. ∎

**Why this matters for the lane.** Compare C786's Corollary 4, which delivers the manuscript's
constant under three hypotheses: per-site spread `≤ 1/2`, `D ≤ √q/2`, **and** the `ℓ¹` budget
`t = Σ_j||h_j||_op ≤ R_k`. Corollary A' keeps the `ℓ²` hypothesis (identical: `D ≤ √q/2`),
*relaxes* the spread hypothesis from `1/2` to `π`, and **deletes the `ℓ¹` budget entirely**. The
price is the constant: `2√(q/c)` is `≈ π√q` at spread `π` and `≈ 2.02√q` at spread `1/2`, against
C786's `√(6q/5) ≈ 1.095√q`. So the two are complementary in exactly the way C786's §2.3 wanted:
its own remark that "the constraint traded away is the global `ℓ¹` budget over sites" is realized
here in full, by Proposition 9 rather than by the moment method.

Consistency with C786's Proposition 5 (the ceiling) is exact and worth checking, because it is the
example that must break any unconditional claim of this shape. There `h_j = (2π/q)diag(q−1,−1,…,−1)`
makes `e^{ih_j}` a scalar, so `η_j = 0`, `H = 0`, and Theorem A gives `eps² ≥ 0`. The hypothesis
of Corollary A' fails at exactly the right place: that `h_j` has spread `2π`, where C786's Lemma 3
has `c(s) ≤ 0` and is vacuous. So Corollary A''s per-site spread condition is not decorative — it
is the exact residue of the ceiling.

**What Theorem A does not do.** It does not touch the threshold `eps_0` of C786's Theorem 8. That
chain needs "`eps` small ⟹ each `U_j` near a Clifford," which is its Step A, and that is where
the marginal dilution `q^{-(m+1)/2}` lives. Theorem A starts from knowing the `U_j` are near the
scalars. The improvement is to the shape of the local stability region, not to the global
threshold. I record this rather than compounding the two.

### 7.3 Theorem B — the named blocking example is false

C786 §4 identifies the operative obstruction to Proposition 9 as phase-blindness, and names one
concrete blocking example: at `q = 2`, `U_j = H` (Hadamard) at every site, giving `p_j` uniform on
`{X,Z}`, "whenever `L` is symmetric enough under the splitting" making `⟨u,v⟩ = 1` and the bound
vacuous. That hypothesis is never satisfiable.

First, an exact evaluation replacing the informal "symmetric enough". With `p_j` uniform on
`{X,Z}` at every site, `u(ℓ)v(ℓ) = 2^{-m}` when every `ℓ_j ∈ {X,Z}` and `0` otherwise, so

```
⟨u, v⟩ = 2^{-m} · | L ∩ {X,Z}^{2m} | ,
```

and Cauchy--Schwarz `⟨u,v⟩ ≤ 1` already forces `|L ∩ {X,Z}^{2m}| ≤ 2^m`. The bound is vacuous
exactly when that count attains `2^m`.

> **Theorem B.** Let `ψ` be any stabilizer `AME(2m,2)` state with `m ≥ 2`. Then
> `|L ∩ {X,Z}^{2m}| ≤ 2^{m−1}`, hence `⟨u,v⟩ ≤ 1/2` for every balanced cut, hence
> ```
> eps(H^{⊗2m})²  ≥  2 − 2⟨u,v⟩  ≥  1 .
> ```
> In particular `H^{⊗2m}` is never a symmetry of such a state, and Proposition 9 detects this,
> using no phase information.

**Proof.** Identify local labels with `F_2²`: `X = (1,0)`, `Z = (0,1)`, `Y = (1,1)`. Then
`{X,Z} = X + {0, Y}`, so `S := {X,Z}^{2m} = 𝟙_X + V` where `V = {0,Y}^{2m}` is an `F_2`-subspace of
`(F_2²)^{2m}` of dimension `2m` and `𝟙_X` is the all-`X` vector. `L` is an `F_2`-subspace, so
`L ∩ S` is either empty or a coset of `L ∩ V`; either way `|L ∩ S| ≤ |L ∩ V|`.

Now `L ∩ V` is an `F_2`-linear code of length `2m` (identifying `V ≅ F_2^{2m}` by the
`Y`-coordinate), and its nonzero elements have Hamming weight `≥ m+1` because they are nonzero
codewords of `L`. Singleton for binary codes gives `dim(L ∩ V) ≤ 2m − (m+1) + 1 = m`, with equality
only if `L ∩ V` is a binary `[2m, m, m+1]` MDS code. The binary MDS codes are exactly the trivial
ones — `[n,n,1]`, `[n,n−1,2]`, `[n,1,n]` — and matching parameters forces `m ≤ 1`. Hence for
`m ≥ 2`, `dim(L ∩ V) ≤ m − 1` and `|L ∩ S| ≤ 2^{m−1}`. ∎

So the one concrete blocker C786 offers for its central open problem does not exist, and the bound
at that configuration is not merely nonvacuous but within a factor `√2` of the maximum possible
defect. The mechanism of the refutation is instructive and is not about phases at all: `⟨u,v⟩` is
a *count of codewords in a structured subset of `L`*, and the MDS/Singleton constraints on `L`
force that count down.

### 7.4 A free strengthening of Proposition 9

For any `ℓ ∈ L`, `W_ℓ|ψ⟩ = χ(ℓ)|ψ⟩`, so replacing `U` by `W_ℓ^† U` leaves `eps(U)` unchanged while
translating each site profile, `p_j ↦ p_j(· + ℓ_j)`. Hence Proposition 9 may be optimized over the
code:

```
eps(U)²  ≥  max_{A balanced}  max_{ℓ ∈ L}  || u_A^{(ℓ)} − v_A^{(ℓ)} ||² .
```

This is free and C786 does not record it. It is the correct handle for extending Theorem A from
"each `U_j` near a scalar" to "each `U_j` near a Weyl operator with labels forming a codeword,"
which is the first half of "near a Clifford". Whether it reaches the full Clifford statement — and
so whether Proposition 9 can replace Step A of C786's Theorem 8 and beat marginal dilution — is
the open question, now posed against a bound that no longer has a known blocker.

---

## 8. The six-objects, three-three-cut coincidence: explicitly checked, and it is a coincidence

Both flagship examples are six objects under a three-three balanced cut, at different parameter
values. There is no shared arithmetic.

- **Golden.** `2d = 6` is the smallest *realized nontrivial* symmetric conference order: order two
  is the trivial one-mode case and order four does not exist, so six is where the subject starts.
  Its `5` is `q = 2d − 1`, forced by `C² = qI`; it is an eigenvalue-squared of a real matrix, not
  a field order, and it is a *function of the size*. (Paley constructions do use `F_5`, but the
  paper's `q` is defined by `C² = qI`.) C788 further shows six is an exceptional endpoint —
  cut-independence of the exchange spectrum holds iff `d ≤ 3` — so the `6` there is a genuine
  terminal special case.
- **ame-lu.** `n = 6` is `2m` with `m = 3`, chosen because the manuscript's worked code is the
  `[6,3,4]_q` MDS code. `AME(4,q)` states exist for `q ≥ 3`, so six is *not* forced as the smallest
  case; it is a convenient one. Its `q` is a free prime power (the local dimension), unconstrained
  by the party count, and the whole point of C786 is to let `m` grow.

So one `6` is "the smallest order at which a real symmetric sign matrix with `C² = qI` exists and
the last order at which its cut spectra are uniform"; the other `6` is "twice the dimension of a
conveniently small MDS code". The `5` and the `q` are different kinds of parameter (a size-forced
eigenvalue versus a free field order). Nothing is being chased numerically. Stated explicitly, as
required.

---

## 9. What is proved, what is checked, what is judgment

**Proved here, by hand, every step above:** Lemma C, Theorem A, Corollary A', Theorem B, Lemma D,
the exact evaluation `⟨u,v⟩ = 2^{-m}|L ∩ {X,Z}^{2m}|`, the maximally-entangled reformulation
`⟨ψ|U|ψ⟩ = q^{-m}Tr(U_A(Γ_A^†U_{A^c}Γ_A)^T)`, the group identifications of §2, the strengthening
of §7.4, and the consistency checks against C786's Propositions 5 and 9.

**Checked by re-derivation, not re-proved from scratch:** C786's Proposition 9, Lemma 3, Lemma 6;
the golden left--right orbit theorem and minimal-degree proposition.

**Taken on the owning lane's authority:** everything in §0's second list. None of the verdict
depends on any of it being correct.

**Judgment, not proof:** that the four features in §5 are the *right* list rather than one of
several possible lists; that the inverted degeneracy loci (§3) and the inverted location of
difficulty (§4) are evidence rather than decoration; that the correct successor move for the lane
is §7.4 rather than a further search for a phase-based repair.

---

## 10. Mystery ledger

- **Is the phase layer the real obstruction to Proposition 9?** *Settled, negatively, and this is
  the finding of the task.* C786 §4 names phase-blindness as the obstruction and offers one
  concrete blocker; Theorem B shows the blocker does not exist for any stabilizer `AME(2m,2)`
  state with `m ≥ 2`, and Theorem A shows that in the near-scalar regime the moduli alone already
  recover the manuscript's conclusion with a *larger* region than the moment route. The residual
  blind directions of Proposition 9 are not "phase" directions; they are directions where the site
  modulus profiles are cut-balanced, which is a statement about moduli.
- **Does anything of the golden orientation programme transfer?** *Settled, negatively*, on four
  independent structural grounds (§5), each sufficient on its own.
- **Can C794 help?** *Settled, negatively and permanently*, by Lemma D: the ame-lu cut ensemble
  carries no information beyond the per-site profiles, so no cut-moment statistic exists to be
  imported into.
- **Open, and now the right target:** does `u_A = v_A` for all balanced `A`, optimized over the
  `L`-translations of §7.4, force `U` to be a product Clifford up to small generators? An
  affirmative answer would let Proposition 9 replace Step A of C786's Theorem 8 and would beat the
  marginal-dilution barrier, which is the lane's stated most valuable target. The evidence gap is
  a classification of the equality case of the Cauchy--Schwarz step, for which Lemma C's
  weight-`(m+1)` family is the natural first constraint. Owner: an ame-lu successor to C786, not
  this task.
- **Open, low value:** does Theorem B generalize past `q = 2`? The general blocker would be `U_j`
  with `p_j` uniform on a subset `S_j ⊂ F_q²`, and `⟨u,v⟩` is again a codeword count in a
  structured set; the binary-Singleton step would need a `q`-ary replacement. Recorded because it
  would upgrade Theorem B from a refuted example to a general statement that Proposition 9 has no
  vacuous configurations.
- **Surprising and unexplained: one item, and it is now explained.** Going in, the two programmes
  looked alike because both say "a modulus invariant is blind to a sign or phase and recovering it
  is open." The resemblance dissolves once one asks *what acts*: golden's modulus map is the
  quotient by a compact gauge group and its blindness is `π_0`; ame-lu's modulus map is not a
  quotient by anything, and its blindness is a fibre of a finite-to-one map between spaces of
  equal dimension. Same sentence, different mathematics. Nothing else in the comparison remains
  unexplained.

---

## 11. Recommendation to the lane

Close the transfer lead. Do not open a golden-import task. The C786 successor should instead take
Theorem A, Theorem B, and the `L`-translation strengthening of §7.4 as its starting point, and
attack the equality case of Proposition 9's Cauchy--Schwarz step directly — the object C786
correctly identified as the right global handle, now without its supposed blocker.

For the manuscript, C786's §5 item 6 ("Add Proposition 9 if the open problem is to be flagged to a
referee; otherwise it can be dropped") should be reweighted: with Theorem A, Proposition 9 is no
longer only a flag for an open problem, it proves a stability statement on a region strictly larger
than the moment route's. That is a placement decision for the lane, not for this task, and no
manuscript text was touched.
