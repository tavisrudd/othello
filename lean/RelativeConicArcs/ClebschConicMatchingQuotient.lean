import RelativeConicArcs.Conic
import Mathlib.FieldTheory.Finite.Basic

/-!
# The conic pairing-forgetting quotient

On the standard conic `C : XZ − Y² = 0` in the projective plane, parametrized by the Veronese
embedding `ν : P¹ → C`, `ν(s,t) = [s² : st : t²]`, two distinct conic points `ν(sᵢ,tᵢ), ν(sⱼ,tⱼ)`
span a secant line.  With the canonical scaling

```
L_ij = tᵢtⱼ X − (sᵢtⱼ + tᵢsⱼ) Y + sᵢsⱼ Z,
```

the secant restricts on the conic to a product of two linear forms on `P¹`:

```
ν*L_ij = (tᵢ s − sᵢ t)(tⱼ s − sⱼ t).
```

Two structural polynomial identities, valid over any commutative ring, organize the section algebra:
this pullback factorization, and the Plücker straightening identity

```
L_ab L_cd − L_ac L_bd = [a,d][b,c] (XZ − Y²),      [i,j] = sᵢ tⱼ − tᵢ sⱼ,
```

which is the plane lift of the four-endpoint switch `{ab,cd} ↦ {ac,bd}` on a matching and writes each
switch difference as an explicit multiple of the conic form.

It follows that the secant product `∏_{{i,j}∈M} L_ij` of a perfect matching `M` of a `2r`-point
endpoint set, restricted to the conic, factors as `∏ᵢ (tᵢ s − sᵢ t)` over the endpoints alone: the
restriction forgets the matching.  Over a field this makes the map from the free vector space on the
perfect matchings to the section space rank one, with kernel the augmentation hyperplane
`{∑ a_M [M] : ∑ a_M = 0}` of dimension `(2r−1)!! − 1`, spanned by the switch differences.  Over a
finite field `𝔽_q` the conic has `q + 1` rational points; below the boundary `2r = q + 1` the
restricted section has zero set exactly its endpoint set, while at the boundary `2r = q + 1` the
section is proportional to `s^q t − s t^q` and vanishes at every rational point.

Perfect matchings are presented by their fixed-point-free involution (mate map).  This development is
symbolic and enumerates no matching data.
-/

namespace RelativeConicArcs
namespace ConicMatchingQuotient

open Finset

/-! ## The secant form, conic form, and Plücker bracket (weakest ring) -/

section PolynomialCore

variable {R : Type*} [CommRing R]

/-- Conic form value `Q(X,Y,Z) = X·Z − Y²` of the standard conic `C : XZ = Y²`. -/
def conicForm (X Y Z : R) : R := X * Z - Y ^ 2

/-- Canonically scaled secant line through the conic points `ν(sᵢ,tᵢ)` and `ν(sⱼ,tⱼ)`, evaluated
at the plane point `(X,Y,Z)`:  `L_ij = tᵢtⱼ X − (sᵢtⱼ + tᵢsⱼ) Y + sᵢsⱼ Z`. -/
def secant (si ti sj tj X Y Z : R) : R :=
  ti * tj * X - (si * tj + ti * sj) * Y + si * sj * Z

/-- Plücker bracket `[i,j] = sᵢtⱼ − tᵢsⱼ`; it vanishes iff `ν(sᵢ,tᵢ) = ν(sⱼ,tⱼ)` projectively. -/
def bracket (si ti sj tj : R) : R := si * tj - ti * sj

/-- The Veronese linear factor `tᵢs − sᵢt` produced by pulling back a secant through `ν(sᵢ,tᵢ)`. -/
def veroneseFactor (si ti s t : R) : R := ti * s - si * t

/-- **Conic pullback.**  The Veronese map `ν(s,t) = (s², st, t²)` lands on the conic. -/
@[simp] theorem conicForm_veronese (s t : R) : conicForm (s ^ 2) (s * t) (t ^ 2) = 0 := by
  simp only [conicForm]; ring

/-- **Secant pullback.**  `ν*(L_ij) = (tᵢs − sᵢt)(tⱼs − sⱼt)`: the secant restricts on the conic to
the product of the two Veronese linear factors of its endpoints. -/
theorem secant_veronese (si ti sj tj s t : R) :
    secant si ti sj tj (s ^ 2) (s * t) (t ^ 2)
      = veroneseFactor si ti s t * veroneseFactor sj tj s t := by
  simp only [secant, veroneseFactor]; ring

/-- **Four-endpoint switch identity** (Plücker straightening; the plane lift of the matching switch
`{ab,cd} ↦ {ac,bd}`):  `L_ab L_cd − L_ac L_bd = [a,d][b,c]·(XZ − Y²)`.  Every switch difference is
thus an explicit multiple of the conic form. -/
theorem secant_switch (sa ta sb tb sc tc sd td X Y Z : R) :
    secant sa ta sb tb X Y Z * secant sc tc sd td X Y Z
      - secant sa ta sc tc X Y Z * secant sb tb sd td X Y Z
      = bracket sa ta sd td * bracket sb tb sc tc * conicForm X Y Z := by
  simp only [secant, bracket, conicForm]; ring

/-- The switch difference lies in the conic ideal: it is divisible by `conicForm X Y Z`. -/
theorem conicForm_dvd_secant_switch (sa ta sb tb sc tc sd td X Y Z : R) :
    conicForm X Y Z ∣
      secant sa ta sb tb X Y Z * secant sc tc sd td X Y Z
        - secant sa ta sc tc X Y Z * secant sb tb sd td X Y Z :=
  ⟨bracket sa ta sd td * bracket sb tb sc tc, by rw [secant_switch]; ring⟩

/-- The Veronese factor of endpoint `(sᵢ,tᵢ)` at the point `(s,t)` is the negated Plücker bracket
`−[i, ·]`; in particular it vanishes exactly when the two projective points coincide. -/
theorem veroneseFactor_eq_neg_bracket (si ti s t : R) :
    veroneseFactor si ti s t = - bracket si ti s t := by
  simp only [veroneseFactor, bracket]; ring

end PolynomialCore

/-! ## Parent-forgetting of the matching product

A perfect matching of an endpoint set is presented as a list `M : List (ι × ι)` of endpoint pairs;
`P_M = ∏_{{i,j}∈M} L_ij`.  Pulling back along `ν` and applying `secant_veronese` factorwise turns the
matching product into the product of the Veronese linear factors over the flattened endpoint list.
Since two perfect matchings of the same set have the same endpoint multiset, their pullbacks agree:
the factorization map forgets the parent matching. -/

section Forgetting

variable {R : Type*} [CommRing R] {ι : Type*}

/-- Pullback of a matching's secant product equals the product of the Veronese linear factors over
its flattened endpoint list. -/
theorem matchingProduct_veronese (sc tc : ι → R) (s t : R) (M : List (ι × ι)) :
    (M.map fun p => secant (sc p.1) (tc p.1) (sc p.2) (tc p.2) (s ^ 2) (s * t) (t ^ 2)).prod
      = ((M.flatMap fun p => [p.1, p.2]).map fun i => veroneseFactor (sc i) (tc i) s t).prod := by
  induction M with
  | nil => simp
  | cons p M ih =>
    rw [List.map_cons, List.prod_cons, secant_veronese, List.flatMap_cons, List.map_append,
      List.prod_append, ih]
    simp [mul_assoc]

/-- **Parent forgetting.**  Two matchings whose endpoint lists agree up to permutation — in
particular any two perfect matchings of the same endpoint set — have equal Veronese pullbacks. -/
theorem matchingProduct_veronese_congr (sc tc : ι → R) (s t : R) (M N : List (ι × ι))
    (h : List.Perm (M.flatMap fun p => [p.1, p.2]) (N.flatMap fun p => [p.1, p.2])) :
    (M.map fun p => secant (sc p.1) (tc p.1) (sc p.2) (tc p.2) (s ^ 2) (s * t) (t ^ 2)).prod
      = (N.map fun p => secant (sc p.1) (tc p.1) (sc p.2) (tc p.2) (s ^ 2) (s * t) (t ^ 2)).prod := by
  rw [matchingProduct_veronese, matchingProduct_veronese]
  exact (h.map _).prod_eq

end Forgetting

/-! ## Augmentation kernel of the restriction map

Every perfect matching of a fixed endpoint set restricts to the *same* nonzero section `F` on the
conic (parent forgetting).  Modelling the free `K`-space on the matchings as `ι → K`, the restriction
map is `a ↦ (∑ᵢ aᵢ)·F`; for `F ≠ 0` its kernel is exactly the augmentation hyperplane
`{a : ∑ᵢ aᵢ = 0}`, of dimension `(2r−1)!! − 1`. -/

section Augmentation

variable (K : Type*) [Field K] (ι : Type*) [Fintype ι]

/-- The augmentation (total) functional `a ↦ ∑ᵢ aᵢ` on the free space on the matchings. -/
def sumFunctional : (ι → K) →ₗ[K] K := ∑ i, LinearMap.proj i

@[simp] theorem sumFunctional_apply (a : ι → K) : sumFunctional K ι a = ∑ i, a i := by
  simp [sumFunctional, LinearMap.sum_apply]

/-- The augmentation submodule `{a : ∑ᵢ aᵢ = 0}` of the free space on the matchings. -/
def augmentation : Submodule K (ι → K) := LinearMap.ker (sumFunctional K ι)

@[simp] theorem mem_augmentation {a : ι → K} : a ∈ augmentation K ι ↔ ∑ i, a i = 0 := by
  simp [augmentation, LinearMap.mem_ker]

/-- **Restriction kernel = augmentation.**  Since all matchings restrict to the common nonzero
section `F`, the restriction map `a ↦ (∑ᵢ aᵢ)·F = (F • sum)a` has kernel exactly the augmentation
hyperplane. -/
theorem ker_restriction {F : K} (hF : F ≠ 0) :
    LinearMap.ker (F • sumFunctional K ι) = augmentation K ι := by
  ext a
  rw [LinearMap.mem_ker, LinearMap.smul_apply, sumFunctional_apply, smul_eq_mul, mul_eq_zero,
    mem_augmentation]
  exact or_iff_right hF

/-- **Augmentation dimension.**  The augmentation hyperplane has dimension `card ι − 1`
(`= (2r−1)!! − 1` for the `(2r−1)!!` perfect matchings of a `2r`-set). -/
theorem finrank_augmentation [Nonempty ι] [DecidableEq ι] :
    Module.finrank K (augmentation K ι) = Fintype.card ι - 1 := by
  have hsurj : Function.Surjective (sumFunctional K ι) := by
    intro c
    exact ⟨Pi.single (Classical.arbitrary ι) c, by simp⟩
  have hrange : Module.finrank K (LinearMap.range (sumFunctional K ι)) = 1 := by
    rw [LinearMap.range_eq_top.mpr hsurj, Submodule.topEquiv.finrank_eq, Module.finrank_self]
  have hpi : Module.finrank K (ι → K) = Fintype.card ι := Module.finrank_pi K
  have hrk := (sumFunctional K ι).finrank_range_add_finrank_ker
  rw [hrange, hpi] at hrk
  rw [augmentation]
  omega

end Augmentation

/-! ## Full-rational-evaluation boundary over a finite field

Over a finite field `𝔽_q` the conic has `q + 1` rational points.  Below the boundary `2r < q + 1` a
matching section `∏_{i∈S} (tᵢ s − sᵢ t)` has zero set exactly its endpoint set `S`; at the boundary
`2r = q + 1` the single endpoint set is all of `C(𝔽_q)`, the common section is proportional to
`s^q t − s t^q`, and it vanishes at every rational point. -/

section SubBoundary

variable {K : Type*} [Field K]

/-- **Sub-boundary section, zero set.**  For an endpoint index set `S` with data `(s·,t·)`, the
section `∏_{i∈S} (tᵢ s − sᵢ t)` vanishes at `(s,t)` iff `(s,t)` is projectively one of the endpoints
(some bracket `[i, (s,t)]` vanishes).  Thus the zero set of the word is exactly the endpoint set and
distinct endpoint sets give distinct words. -/
theorem prod_veroneseFactor_eq_zero_iff {ι : Type*} (S : Finset ι)
    (sc tc : ι → K) (s t : K) :
    (∏ i ∈ S, veroneseFactor (sc i) (tc i) s t) = 0 ↔ ∃ i ∈ S, bracket (sc i) (tc i) s t = 0 := by
  rw [Finset.prod_eq_zero_iff]
  simp only [veroneseFactor_eq_neg_bracket, neg_eq_zero]

/-- **Sub-boundary section, nonvanishing.**  If `(s,t)` is projectively distinct from every endpoint
(`bracket [i, (s,t)] ≠ 0` for all `i ∈ S`), the section is nonzero at `(s,t)`.  Below the boundary
this produces a nonzero word of weight `q + 1 − 2r`. -/
theorem prod_veroneseFactor_ne_zero {ι : Type*} (S : Finset ι)
    (sc tc : ι → K) (s t : K) (h : ∀ i ∈ S, bracket (sc i) (tc i) s t ≠ 0) :
    (∏ i ∈ S, veroneseFactor (sc i) (tc i) s t) ≠ 0 := by
  rw [Ne, prod_veroneseFactor_eq_zero_iff]
  rintro ⟨i, hiS, hi⟩
  exact h i hiS hi

end SubBoundary

section Boundary

variable {K : Type*} [Field K] [Fintype K]

/-- The boundary binary form `s^q t − s t^q`, `q = |K|`, to which the full-endpoint section
`∏_{p ∈ C(𝔽_q)} (t_p s − s_p t)` is projectively proportional. -/
def boundaryForm (s t : K) : K := s ^ Fintype.card K * t - s * t ^ Fintype.card K

/-- **Full-rational boundary.**  The boundary section vanishes at every rational point of `𝔽_q`,
because `a^q = a` there.  Hence at `2r = q + 1` every perfect-matching product evaluates to the zero
word — the sharp separation from the sub-boundary restriction kernel. -/
theorem boundaryForm_eq_zero (s t : K) : boundaryForm s t = 0 := by
  simp only [boundaryForm, FiniteField.pow_card]; ring

end Boundary

/-! ## Switch connectivity of the matching graph

The augmentation kernel is spanned by the local four-endpoint switches `{ab,cd} ↦ {ac,bd}`, because
the graph of perfect matchings joined by switches is connected.  Matchings of a `2n`-endpoint set are
presented as fixed-point-free involutions (mate maps) on `Fin (2n)`; for each fixed endpoint set
connectivity is a finite statement.  Formalized here: switches are reversible in every size, and the
base four-endpoint generator is a complete switch triangle, so every perfect matching of a `4`-set is
switch-connected to a base.  The general `2n` connectivity follows from this generator by the standard
"force one desired edge by a switch and induct on the remaining endpoints" argument. -/

section Connectivity

variable {m : ℕ}

/-- A perfect matching, presented by its mate map: a fixed-point-free involution of `Fin m`
(`σ ∘ σ = id` and `σ x ≠ x`). -/
abbrev IsMatching (σ : Fin m → Fin m) : Prop :=
  (∀ x, σ (σ x) = x) ∧ (∀ x, σ x ≠ x)

/-- One four-endpoint switch `{ab,cd} ↦ {ac,bd}`: `σ` pairs `a↔b, c↔d`, `τ` pairs `a↔c, b↔d`, and
the two agree off `{a,b,c,d}`. -/
abbrev IsSwitch (σ τ : Fin m → Fin m) : Prop :=
  ∃ a b c d : Fin m, a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d ∧
    σ a = b ∧ σ b = a ∧ σ c = d ∧ σ d = c ∧
    τ a = c ∧ τ c = a ∧ τ b = d ∧ τ d = b ∧
    ∀ x, x ≠ a → x ≠ b → x ≠ c → x ≠ d → σ x = τ x

/-- **Switch reversibility.**  A four-endpoint switch is undone by a four-endpoint switch (relabel
`a,b,c,d ↦ a,c,b,d`), so switch adjacency is symmetric in every size. -/
theorem isSwitch_symm {σ τ : Fin m → Fin m} (h : IsSwitch σ τ) : IsSwitch τ σ := by
  obtain ⟨a, b, c, d, hab, hac, had, hbc, hbd, hcd, hσa, hσb, hσc, hσd,
    hτa, hτc, hτb, hτd, hoff⟩ := h
  refine ⟨a, c, b, d, hac, hab, had, hbc.symm, hcd, hbd, hτa, hτc, hτb, hτd,
    hσa, hσb, hσc, hσd, ?_⟩
  intro x hxa hxc hxb hxd
  exact (hoff x hxa hxb hxc hxd).symm

/-- Switch adjacency: one four-endpoint switch in either direction. -/
def SwitchAdj (σ τ : Fin m → Fin m) : Prop := IsSwitch σ τ ∨ IsSwitch τ σ

/-- Two matchings are switch-connected if joined by a finite path of switches. -/
def SwitchConnected : (Fin m → Fin m) → (Fin m → Fin m) → Prop :=
  Relation.ReflTransGen SwitchAdj

/-- The three perfect matchings of the `4`-endpoint set, as mate maps. -/
def m0123 : Fin 4 → Fin 4 := ![1, 0, 3, 2]   -- `{01, 23}`
def m0213 : Fin 4 → Fin 4 := ![2, 3, 0, 1]   -- `{02, 13}`
def m0312 : Fin 4 → Fin 4 := ![3, 2, 1, 0]   -- `{03, 12}`

/-- The three mate maps are perfect matchings. -/
theorem isMatching_base : IsMatching m0123 ∧ IsMatching m0213 ∧ IsMatching m0312 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- **Base four-endpoint generator.**  Any two of the three `4`-set matchings differ by a single
switch: the switch graph on the `4`-set is complete, hence connected. -/
theorem base_switch_triangle :
    IsSwitch m0123 m0213 ∧ IsSwitch m0123 m0312 ∧ IsSwitch m0213 m0312 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

set_option maxRecDepth 4000 in
/-- **Base connectivity.**  Every perfect matching of the `4`-endpoint set is switch-connected to the
base matching `{01,23}`. -/
theorem base_switchConnected (σ : Fin 4 → Fin 4) (h : IsMatching σ) :
    SwitchConnected m0123 σ := by
  have key : ∀ σ : Fin 4 → Fin 4, IsMatching σ → σ = m0123 ∨ σ = m0213 ∨ σ = m0312 := by decide
  obtain ⟨h1, h2, _⟩ := base_switch_triangle
  rcases key σ h with rfl | rfl | rfl
  · exact Relation.ReflTransGen.refl
  · exact Relation.ReflTransGen.single (Or.inl h1)
  · exact Relation.ReflTransGen.single (Or.inl h2)

end Connectivity

/-! ## Axiom audit of the module's terminals -/

#print axioms secant_veronese
#print axioms secant_switch
#print axioms conicForm_dvd_secant_switch
#print axioms matchingProduct_veronese_congr
#print axioms ker_restriction
#print axioms finrank_augmentation
#print axioms boundaryForm_eq_zero
#print axioms prod_veroneseFactor_ne_zero
#print axioms isSwitch_symm
#print axioms base_switchConnected

end ConicMatchingQuotient
end RelativeConicArcs
