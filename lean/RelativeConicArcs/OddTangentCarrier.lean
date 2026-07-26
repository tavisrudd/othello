import RelativeConicArcs.SquareRootCarrier
import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Data.Fintype.Sum

/-!
# Algebra and compatibility for odd tangent-twisted carriers

For an odd arc in characteristic two, a maximum-index centre leaves one arc point unmatched.
Removing the corresponding tangent factor leaves a square on the centre's dual line.  This module
formalizes the algebra that is independent of the ambient projective construction:

* uniqueness and rescaling of a square root after a linear factor is chosen;
* the nonzero zeroth conductor at two distinct parameters on one tangent fiber;
* the fixed-point-free partner involution and its exact ordered- and unordered-pair counts;
* the complete multipartite compatibility graph determined by tangent-contact labels; and
* invariance of first-conductor nonvanishing after multiplication by one common linear factor.

The module does not construct the dual Chow product, identify geometric tangent fibers, prove the
regular-oval conductor count, or prove that compatible linewise roots extend to a plane form.
-/

namespace RelativeConicArcs

section CharacteristicTwoAlgebra

variable {K : Type*} [Field K] [CharP K 2]

private theorem add_self_eq_zero_charTwo (x : K) : x + x = 0 := by
  have htwo : (2 : K) = 0 := CharP.cast_eq_zero K 2
  calc
    x + x = 2 * x := by ring
    _ = 0 := by rw [htwo, zero_mul]

private theorem add_eq_zero_iff_eq_charTwo {x y : K} : x + y = 0 ↔ x = y := by
  constructor
  · intro h
    calc
      x = x + 0 := by simp
      _ = x + (y + y) := by rw [add_self_eq_zero_charTwo]
      _ = (x + y) + y := by ring
      _ = y := by rw [h]; simp
  · rintro rfl
    exact add_self_eq_zero_charTwo x

/-- Over a characteristic-two field, two elements with the same square are equal. -/
theorem sq_injective_charTwo {x y : K} (h : x ^ 2 = y ^ 2) : x = y := by
  have hfactor : (x - y) * (x + y) = 0 := by
    calc
      (x - y) * (x + y) = x ^ 2 - y ^ 2 := by ring
      _ = 0 := sub_eq_zero.mpr h
  rcases mul_eq_zero.mp hfactor with hxy | hxy
  · exact sub_eq_zero.mp hxy
  · exact add_eq_zero_iff_eq_charTwo.mp hxy

omit [CharP K 2] in
/-- Rescaling a chosen tangent factor by a square and the root by the inverse scalar preserves
the odd factorization `F = λ g²`. -/
theorem oddTangentFactorization_rescale
    {F tangentFactor g s : K} (h : F = tangentFactor * g ^ 2) (hs : s ≠ 0) :
    F = (s ^ 2 * tangentFactor) * (s⁻¹ * g) ^ 2 := by
  rw [h]
  field_simp [hs]

/-- The square of the zeroth conductor for two parameters on one tangent fiber.  The factor `r`
is the nonzero value of the remaining Chow product at the tangent node. -/
def oddZerothConductorSq (r κ μ : K) : K :=
  r * (κ + μ)

/-- Distinct tangent parameters give a nonzero zeroth conductor when the residual Chow factor is
nonzero. -/
theorem oddZerothConductorSq_ne_zero
    {r κ μ : K} (hr : r ≠ 0) (hκμ : κ ≠ μ) :
    oddZerothConductorSq r κ μ ≠ 0 := by
  apply mul_ne_zero hr
  exact fun hsum => hκμ (add_eq_zero_iff_eq_charTwo.mp hsum)

/-- Translation by a nonzero conductor label pairs the nonzero tangent parameters other than the
label itself. -/
def tangentConductorPartner (δ κ : K) : K :=
  κ + δ

/-- Applying the tangent-conductor partner map twice returns the original parameter. -/
theorem tangentConductorPartner_involutive (δ : K) :
    Function.Involutive (tangentConductorPartner δ) := by
  intro κ
  unfold tangentConductorPartner
  rw [add_assoc, add_self_eq_zero_charTwo, add_zero]

omit [CharP K 2] in
/-- A nonzero conductor label has no fixed tangent parameter. -/
theorem tangentConductorPartner_ne_self
    {δ κ : K} (hδ : δ ≠ 0) :
    tangentConductorPartner δ κ ≠ κ := by
  intro h
  change κ + δ = κ at h
  apply hδ
  calc
    δ = (κ + δ) - κ := by ring
    _ = κ - κ := by rw [h]
    _ = 0 := by ring

/-- Away from the omitted parameter `δ`, the conductor partner of a nonzero parameter is nonzero. -/
theorem tangentConductorPartner_ne_zero
    {δ κ : K} (hκδ : κ ≠ δ) :
    tangentConductorPartner δ κ ≠ 0 := by
  intro h
  exact hκδ (add_eq_zero_iff_eq_charTwo.mp h)

/-- Ordered nonzero parameter pairs whose normalized squared conductor is `δ`. -/
abbrev NonzeroOrderedConductorPairs (δ : K) : Type _ :=
  {p : K × K // p.1 ≠ 0 ∧ p.2 ≠ 0 ∧ p.1 + p.2 = δ}

/-- Tangent parameters left after deleting zero and the conductor label. -/
abbrev ExcludedTangentParameters (δ : K) : Type _ :=
  {κ : K // κ ≠ 0 ∧ κ ≠ δ}

/-- A parameter different from zero and `δ` determines the unique ordered nonzero pair with sum
`δ`, and every such ordered pair arises this way. -/
def excludedTangentParametersEquivOrderedPairs (δ : K) :
    ExcludedTangentParameters δ ≃ NonzeroOrderedConductorPairs δ where
  toFun κ :=
    ⟨(κ.1, tangentConductorPartner δ κ.1),
      κ.property.1,
      tangentConductorPartner_ne_zero (δ := δ) (κ := κ.1) κ.property.2,
      by
        change κ.1 + (κ.1 + δ) = δ
        rw [← add_assoc, add_self_eq_zero_charTwo, zero_add]⟩
  invFun p :=
    ⟨p.1.1, p.2.1, by
      intro h
      have hp := p.2.2.2
      rw [h] at hp
      have : p.1.2 = 0 := by
        apply add_left_cancel (a := δ)
        simp [hp]
      exact p.2.2.1 this⟩
  left_inv κ := rfl
  right_inv p := by
    apply Subtype.ext
    apply Prod.ext
    · rfl
    · dsimp
      have hp := p.2.2.2
      have hself := add_self_eq_zero_charTwo p.1.1
      calc
        p.1.1 + δ = p.1.1 + (p.1.1 + p.1.2) := by rw [hp]
        _ = p.1.2 := by rw [← add_assoc, hself, zero_add]

omit [CharP K 2] in
/-- Deleting zero and a nonzero conductor label leaves exactly `|K| - 2` tangent parameters. -/
theorem card_excludedTangentParameters
    [Fintype K] [DecidableEq K] {δ : K} (hδ : δ ≠ 0) :
    Fintype.card (ExcludedTangentParameters δ) = Fintype.card K - 2 := by
  have hcompl :=
    Fintype.card_subtype_compl (fun κ : K => κ = 0 ∨ κ = δ)
  have htwo :
      Fintype.card {κ : K // κ = 0 ∨ κ = δ} = 2 :=
    Fintype.card_subtype_eq_or_eq_of_ne hδ.symm
  simpa only [ExcludedTangentParameters, not_or, htwo] using hcompl

/-- For a nonzero label `δ`, the ordered nonzero pairs with normalized conductor `δ` have
cardinality `|K| - 2`. -/
theorem card_nonzeroOrderedConductorPairs
    [Fintype K] [DecidableEq K] {δ : K} (hδ : δ ≠ 0) :
    Fintype.card (NonzeroOrderedConductorPairs δ) = Fintype.card K - 2 := by
  calc
    Fintype.card (NonzeroOrderedConductorPairs δ) =
        Fintype.card (ExcludedTangentParameters δ) :=
      Fintype.card_congr (excludedTangentParametersEquivOrderedPairs δ).symm
    _ = Fintype.card K - 2 := card_excludedTangentParameters hδ

/-- The partner map preserves the tangent parameters left after deleting zero and `δ`. -/
def excludedTangentPartner (δ : K) :
    ExcludedTangentParameters δ → ExcludedTangentParameters δ :=
  fun κ =>
    ⟨tangentConductorPartner δ κ.1,
      tangentConductorPartner_ne_zero κ.property.2,
      by
        intro h
        apply κ.property.1
        apply add_right_cancel (b := δ)
        simpa [tangentConductorPartner] using h⟩

/-- The partner map on the reduced tangent-parameter set is an involution. -/
theorem excludedTangentPartner_involutive (δ : K) :
    Function.Involutive (excludedTangentPartner δ) := by
  intro κ
  apply Subtype.ext
  exact tangentConductorPartner_involutive δ κ.1

/-- For a nonzero label, the reduced partner involution has no fixed point. -/
theorem excludedTangentPartner_ne_self
    {δ : K} (hδ : δ ≠ 0) (κ : ExcludedTangentParameters δ) :
    excludedTangentPartner δ κ ≠ κ := by
  intro h
  exact tangentConductorPartner_ne_self hδ (congrArg Subtype.val h)

/-- The conductor matching joins each reduced tangent parameter to its unique partner.  Its edges
are the unordered nonzero parameter pairs with sum `δ`. -/
def tangentConductorMatching (δ : K) :
    SimpleGraph (ExcludedTangentParameters δ) :=
  SimpleGraph.fromRel fun κ μ => μ = excludedTangentPartner δ κ

/-- Adjacency in the finite conductor matching is decidable when equality in the field is
decidable. -/
instance instDecidableRelTangentConductorMatching
    [DecidableEq K] (δ : K) :
    DecidableRel (tangentConductorMatching δ).Adj := by
  unfold tangentConductorMatching
  infer_instance

/-- Adjacency in the conductor matching is equality with the partner parameter. -/
theorem tangentConductorMatching_adj_iff
    {δ : K} (hδ : δ ≠ 0) (κ μ : ExcludedTangentParameters δ) :
    (tangentConductorMatching δ).Adj κ μ ↔
      μ = excludedTangentPartner δ κ := by
  rw [tangentConductorMatching, SimpleGraph.fromRel_adj]
  constructor
  · rintro ⟨_, h | h⟩
    · exact h
    · have hpartner := congrArg (excludedTangentPartner δ) h
      have hreverse : excludedTangentPartner δ κ = μ := by
        simpa only [excludedTangentPartner_involutive δ μ] using hpartner
      exact hreverse.symm
  · intro h
    refine ⟨?_, Or.inl h⟩
    intro hκμ
    apply excludedTangentPartner_ne_self hδ κ
    calc
      excludedTangentPartner δ κ = μ := h.symm
      _ = κ := hκμ.symm

/-- Every reduced tangent parameter has degree one in the conductor matching. -/
theorem tangentConductorMatching_degree_eq_one
    [Fintype K] [DecidableEq K]
    {δ : K} (hδ : δ ≠ 0) (κ : ExcludedTangentParameters δ) :
    (tangentConductorMatching δ).degree κ = 1 := by
  classical
  apply Finset.card_eq_one.mpr
  refine ⟨excludedTangentPartner δ κ, ?_⟩
  ext μ
  simp only [SimpleGraph.mem_neighborFinset, tangentConductorMatching_adj_iff hδ,
    Finset.mem_singleton]

/-- Unordered nonzero parameter pairs whose normalized squared conductor is `δ`. -/
abbrev NonzeroUnorderedConductorPairs (δ : K) : Type _ :=
  (tangentConductorMatching δ).edgeSet

/-- For a nonzero label `δ`, the unordered nonzero pairs with normalized conductor `δ` have
cardinality `(|K| - 2) / 2`.  They are the edges of a near-perfect matching on the nonzero
tangent parameters. -/
theorem card_nonzeroUnorderedConductorPairs
    [Fintype K] [DecidableEq K] {δ : K} (hδ : δ ≠ 0) :
    Fintype.card (NonzeroUnorderedConductorPairs δ) =
      (Fintype.card K - 2) / 2 := by
  classical
  rw [(tangentConductorMatching δ).card_edgeSet]
  have hdouble :
      2 * (tangentConductorMatching δ).edgeFinset.card =
        Fintype.card K - 2 := by
    calc
      2 * (tangentConductorMatching δ).edgeFinset.card =
          ∑ κ, (tangentConductorMatching δ).degree κ :=
        (tangentConductorMatching δ).sum_degrees_eq_twice_card_edges.symm
      _ = Fintype.card (ExcludedTangentParameters δ) := by
        simp only [tangentConductorMatching_degree_eq_one hδ, Finset.sum_const,
          Finset.card_univ, smul_eq_mul, mul_one]
      _ = Fintype.card K - 2 := card_excludedTangentParameters hδ
  omega

end CharacteristicTwoAlgebra

section TangentFiberCompatibility

variable {P C : Type*}

/-- The compatibility graph joins two carrier centres exactly when their tangent-contact labels
are different. -/
def tangentFiberCompatibilityGraph (contact : P → C) : SimpleGraph P :=
  SimpleGraph.fromRel fun x y => contact x ≠ contact y

@[simp]
theorem tangentFiberCompatibilityGraph_adj_iff
    (contact : P → C) (x y : P) :
    (tangentFiberCompatibilityGraph contact).Adj x y ↔ contact x ≠ contact y := by
  unfold tangentFiberCompatibilityGraph
  rw [SimpleGraph.fromRel_adj]
  constructor
  · rintro ⟨_, h | h⟩
    · exact h
    · exact h.symm
  · intro h
    exact ⟨fun hxy => h (congrArg contact hxy), Or.inl h⟩

/-- A set is a clique in the tangent-fiber compatibility graph exactly when it contains at most
one centre with each tangent-contact label. -/
theorem tangentFiberCompatibilityGraph_isClique_iff_injOn
    (contact : P → C) (Y : Set P) :
    (tangentFiberCompatibilityGraph contact).IsClique Y ↔
      Set.InjOn contact Y := by
  constructor
  · intro hclique x hx y hy hcontact
    by_contra hxy
    exact (tangentFiberCompatibilityGraph_adj_iff contact x y).mp
      (hclique hx hy hxy) hcontact
  · intro hinj x hx y hy hxy
    rw [tangentFiberCompatibilityGraph_adj_iff]
    exact fun hcontact => hxy (hinj hx hy hcontact)

/-- Every finite compatibility clique has at most as many vertices as there are tangent-contact
labels. -/
theorem tangentFiberCompatibilityGraph_clique_card_le
    [Fintype C] [DecidableEq C] [DecidableEq P]
    (contact : P → C) (Y : Finset P)
    (hclique : (tangentFiberCompatibilityGraph contact).IsClique (Y : Set P)) :
    Y.card ≤ Fintype.card C := by
  have hinj : Set.InjOn contact (Y : Set P) :=
    (tangentFiberCompatibilityGraph_isClique_iff_injOn contact Y).mp hclique
  calc
    Y.card = (Y.image contact).card := (Finset.card_image_iff.mpr hinj).symm
    _ ≤ Finset.univ.card := Finset.card_le_card (Finset.subset_univ _)
    _ = Fintype.card C := Finset.card_univ

/-- If every tangent-contact label has a chosen centre, their images form a compatibility clique
whose cardinality is the number of labels.  Together with the upper bound, this gives the exact
clique number of a complete multipartite compatibility graph. -/
theorem exists_tangentFiberCompatibilityGraph_clique_card_eq
    [Fintype C] [DecidableEq C] [DecidableEq P]
    (contact : P → C) (chooseCenter : C → P)
    (hsection : Function.LeftInverse contact chooseCenter) :
    ∃ Y : Finset P,
      (tangentFiberCompatibilityGraph contact).IsClique (Y : Set P) ∧
      Y.card = Fintype.card C := by
  let Y := Finset.univ.image chooseCenter
  refine ⟨Y, ?_, ?_⟩
  · rw [tangentFiberCompatibilityGraph_isClique_iff_injOn]
    intro x hx y hy hxy
    rcases Finset.mem_image.mp hx with ⟨a, _, rfl⟩
    rcases Finset.mem_image.mp hy with ⟨b, _, rfl⟩
    exact congrArg chooseCenter (by simpa [hsection a, hsection b] using hxy)
  · dsimp [Y]
    rw [Finset.card_image_of_injective Finset.univ hsection.injective, Finset.card_univ]

end TangentFiberCompatibility

section OrdinaryGlobalizationCriterion

variable {P C L : Type*} [Membership P L]

/-- A finite set of carrier centres is tangent-fiber transversal when no two centres have the
same tangent-contact label. -/
def TangentFiberTransversal (contact : P → C) (Y : Finset P) : Prop :=
  Set.InjOn contact (Y : Set P)

/-- If ordinary globalization forces both tangent-fiber transversality and the arc condition, and
the carrier extension theorem supplies globalization from those two conditions, then ordinary
globalization is exactly the tangent-fiber-transversal arc condition.

The hypotheses separate the two geometric conductor obstructions from the global extension input;
this theorem checks their logical composition without asserting those projective inputs. -/
theorem ordinaryGlobalizes_iff_of_transversal_arc_criteria
    (contact : P → C) (ordinaryGlobalizes : Finset P → Prop)
    (htransversal :
      ∀ Y, ordinaryGlobalizes Y → TangentFiberTransversal contact Y)
    (harc :
      ∀ Y, ordinaryGlobalizes Y → Arc (L := L) Y)
    (hextend :
      ∀ Y, TangentFiberTransversal contact Y → Arc (L := L) Y →
        ordinaryGlobalizes Y)
    (Y : Finset P) :
    ordinaryGlobalizes Y ↔
      TangentFiberTransversal contact Y ∧ Arc (L := L) Y := by
  constructor
  · intro h
    exact ⟨htransversal Y h, harc Y h⟩
  · rintro ⟨htrans, hYarc⟩
    exact hextend Y htrans hYarc

end OrdinaryGlobalizationCriterion

section CommonFactorTransfer

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- Multiplying all three linewise roots by one ambient factor scales their first conductor by
the value of that factor at the common point.  The derivative of the factor contributes a common
linear jet and cancels against the relation among the three directions. -/
theorem oddCarrierConductor_mul_commonFactor
    (v : Fin 3 → V) (c d : Fin 3 → K)
    (hrel : ∑ i, c i • v i = 0)
    (factorDerivative : V →ₗ[K] K) (factorValue rootValue : K) :
    carrierConductor c
        (fun i => factorValue * d i + rootValue * factorDerivative (v i)) =
      factorValue * carrierConductor c d :=
  carrierConductor_change_of_trivialization
    v c d hrel factorDerivative factorValue rootValue

/-- A nonzero common factor preserves nonvanishing of the first conductor. -/
theorem oddCarrierConductor_mul_commonFactor_ne_zero_iff
    (v : Fin 3 → V) (c d : Fin 3 → K)
    (hrel : ∑ i, c i • v i = 0)
    (factorDerivative : V →ₗ[K] K) (factorValue rootValue : K)
    (hfactor : factorValue ≠ 0) :
    carrierConductor c
          (fun i => factorValue * d i + rootValue * factorDerivative (v i)) ≠ 0 ↔
      carrierConductor c d ≠ 0 := by
  rw [oddCarrierConductor_mul_commonFactor v c d hrel factorDerivative]
  simp [hfactor]

end CommonFactorTransfer

end RelativeConicArcs
