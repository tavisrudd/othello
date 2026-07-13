import RepairCodes.ProjectiveAxisTwistedCubicLift
import RepairCodes.Asymptotic

/-!
# An asymptotic family from the projectively completed q=9 seed

The completed `[20,4,9]_9` seed improves the concatenated parameters to exact rate
`1/10` and eventual relative distance above every `c < 351/1600`.  The only deep
existence input remains `Imported.stichtenoth_selfDual_TVZ_6561`; all scaling,
distance, scalar-restriction, and bounded-repair claims below are kernel checked.
-/

namespace RepairCodes

open Filter Finset FiniteGeom

noncomputable section

/-- Scaling the TVZ distance by the completed seed gives the limit lower bound
`9(39/80)/20 = 351/1600`. -/
theorem eventually_projective_scaled_lift_distance_gt
    (n d : ℕ → ℕ) (δ c : ℝ)
    (hn : Tendsto n atTop atTop)
    (hd : Tendsto (fun j => (d j : ℝ) / (n j : ℝ)) atTop (nhds δ))
    (hδ : (39 : ℝ) / 80 ≤ δ)
    (hc : c < (351 : ℝ) / 1600) :
    ∀ᶠ j in atTop, c * (20 * n j : ℕ) < 9 * (d j : ℝ) := by
  have htarget : (20 * c) / 9 < δ := by
    apply lt_of_lt_of_le _ hδ
    nlinarith [hc]
  have hratio : ∀ᶠ j in atTop, (20 * c) / 9 < (d j : ℝ) / (n j : ℝ) :=
    (tendsto_order.mp hd).1 _ htarget
  have hpositive : ∀ᶠ j in atTop, 1 ≤ n j := (tendsto_atTop.mp hn) 1
  filter_upwards [hpositive, hratio] with j hjpos hjratio
  have hnpos : (0 : ℝ) < n j := by exact_mod_cast (Nat.zero_lt_of_lt hjpos)
  have hmul := (lt_div_iff₀ hnpos).mp hjratio
  push_cast
  nlinarith

variable {F L : Type*}
variable [Field F] [Fintype F] [DecidableEq F] [CharP F 3]
variable [Field L] [Fintype L] [DecidableEq L] [Algebra F L]
variable [FiniteDimensional F L] [Algebra.IsSeparable F L]

/-- The completed lift has two equally large coordinate classes. -/
def HasProjectiveQ9LiftCoordinateDistribution
    (iota : Type*) [Fintype iota] [DecidableEq iota] : Prop :=
  Disjoint (projectiveQ9LiftCubicCoordinates iota F)
      (projectiveQ9LiftAxisCoordinates iota F) ∧
    projectiveQ9LiftCubicCoordinates iota F ∪
      projectiveQ9LiftAxisCoordinates iota F = univ ∧
    (projectiveQ9LiftCubicCoordinates iota F).card = 10 * Fintype.card iota ∧
    (projectiveQ9LiftAxisCoordinates iota F).card = 10 * Fintype.card iota

/-- Exact radius-four repair profile at one completed lifted coordinate. -/
def HasProjectiveQ9LiftCoordinateProfile
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (C : Submodule F (iota × ProjectiveAxisTwistedCubicIndex F → F))
    (p : iota × ProjectiveAxisTwistedCubicIndex F) : Prop :=
  match p.2 with
  | .inl _ =>
      HasExactLocalityAt C p 3 ∧
        matchingNumber (repairHypergraph C p 4) = 4 ∧
        transversalNumber (repairHypergraph C p 4) = 8 ∧
        transversalNumber (repairHypergraph C p 4) - 1 = 7
  | .inr _ =>
      HasExactLocalityAt C p 2 ∧
        matchingNumber (repairHypergraph C p 4) = 7 ∧
        transversalNumber (repairHypergraph C p 4) = 15 ∧
        transversalNumber (repairHypergraph C p 4) - 1 = 14

/-- Complete projective-family property.  Repair data is explicitly the bounded
radius-four port, not the concatenated code's unbounded full repair port. -/
def HasProjectiveQ9UniformRepairFamily (hdeg : Module.finrank F L = 4) : Prop :=
  ∃ (n : ℕ → ℕ) (O : (j : ℕ) → Submodule L (Fin (n j) → L)),
    Tendsto (fun j => Fintype.card
      (Fin (n j) × ProjectiveAxisTwistedCubicIndex F)) atTop atTop ∧
    (∀ c : ℝ, c < (351 : ℝ) / 1600 →
      ∀ᶠ j in atTop,
        c * Fintype.card (Fin (n j) × ProjectiveAxisTwistedCubicIndex F) <
          minDist (projectiveQ9ExtensionLiftCode hdeg (O j))) ∧
    (∀ᶠ j in atTop,
      10 * Module.finrank F (projectiveQ9ExtensionLiftCode hdeg (O j)) =
          Fintype.card (Fin (n j) × ProjectiveAxisTwistedCubicIndex F) ∧
      Fintype.card (Fin (n j) × ProjectiveAxisTwistedCubicIndex F) ≤
          5 * minDist (projectiveQ9ExtensionLiftCode hdeg (O j)) ∧
      HasProjectiveQ9LiftCoordinateDistribution (F := F) (Fin (n j)) ∧
      ∀ p : Fin (n j) × ProjectiveAxisTwistedCubicIndex F,
        HasProjectiveQ9LiftCoordinateProfile
          (projectiveQ9ExtensionLiftCode hdeg (O j)) p)

/-- End-to-end completed-seed family theorem. -/
theorem stichtenoth_projective_q9_uniform_repair_family
    (hFcard : Fintype.card F = 9) (hLcard : Fintype.card L = 6561)
    (hdeg : Module.finrank F L = 4) :
    HasProjectiveQ9UniformRepairFamily hdeg := by
  unfold HasProjectiveQ9UniformRepairFamily
  obtain ⟨n, O, δ, hself, hdim, hn, hdist, hδ⟩ :=
    Imported.stichtenoth_selfDual_TVZ_6561 L hLcard
  refine ⟨n, O, ?_, ?_, ?_⟩
  · have hmul : Tendsto (fun j => 20 * n j) atTop atTop := by
      apply tendsto_atTop.mpr
      intro b
      filter_upwards [(tendsto_atTop.mp hn) b] with j hj
      omega
    simpa only [Fintype.card_prod, Fintype.card_fin,
      card_projectiveAxisTwistedCubicIndex, hFcard, Nat.mul_comm] using hmul
  · intro c hc
    have hscaled := eventually_projective_scaled_lift_distance_gt n
      (fun j => minDist (O j)) δ c hn hdist hδ hc
    have hn18 : ∀ᶠ j in atTop, 18 ≤ n j := (tendsto_atTop.mp hn) 18
    filter_upwards [hscaled, hn18] with j hjscaled hj18
    have hO0 : O j ≠ ⊥ := by
      intro hbot
      have hdj := hdim j
      rw [hbot] at hdj
      simp at hdj
      omega
    obtain ⟨hlen, -, hdistLift⟩ :=
      projectiveQ9ExtensionLiftCode_parameters hFcard hdeg (O j) hO0
    rw [hlen]
    simp only [Fintype.card_fin]
    have hdistReal : ((9 * minDist (O j) : ℕ) : ℝ) ≤
        (minDist (projectiveQ9ExtensionLiftCode hdeg (O j)) : ℝ) := by
      exact_mod_cast hdistLift
    exact hjscaled.trans_le (by simpa using hdistReal)
  · have hgood := eventually_length_le_three_mul_distance n
      (fun j => minDist (O j)) δ hn hdist hδ
    have hclean := eventually_projective_scaled_lift_distance_gt n
      (fun j => minDist (O j)) δ ((1 : ℝ) / 5) hn hdist hδ (by norm_num)
    have hn18 : ∀ᶠ j in atTop, 18 ≤ n j := (tendsto_atTop.mp hn) 18
    filter_upwards [hgood, hclean, hn18] with j hj hjclean hj18
    have hdual : dualDist (O j) = minDist (O j) := by
      unfold dualDist
      rw [← hself j]
    have hd6 : 6 ≤ dualDist (O j) := by rw [hdual]; omega
    have hO0 : O j ≠ ⊥ := by
      intro hbot
      have hdj := hdim j
      rw [hbot] at hdj
      simp at hdj
      omega
    obtain ⟨hlen, hdimLift, hdistLift⟩ :=
      projectiveQ9ExtensionLiftCode_parameters hFcard hdeg (O j) hO0
    refine ⟨?_, ?_, ?_, ?_⟩
    · rw [hdimLift, hlen]
      have hdj := hdim j
      simp only [Fintype.card_fin]
      omega
    · rw [hlen]
      simp only [Fintype.card_fin]
      have hcleanNat : 4 * n j < 9 * minDist (O j) := by
        have hcleanReal : (4 : ℝ) * n j < 9 * minDist (O j) := by
          push_cast at hjclean ⊢
          norm_num at hjclean ⊢
          nlinarith
        exact_mod_cast hcleanReal
      omega
    · unfold HasProjectiveQ9LiftCoordinateDistribution
      exact ⟨projectiveQ9Lift_coordinate_partition.1,
        projectiveQ9Lift_coordinate_partition.2,
        (projectiveQ9Lift_coordinate_counts hFcard).1,
        (projectiveQ9Lift_coordinate_counts hFcard).2⟩
    · rintro ⟨x, z⟩
      have hlocal := projectiveQ9ExtensionLiftCode_exact_locality
        hFcard hdeg (O j) hd6 x z
      have hrow := projectiveQ9ExtensionLiftCode_row_invariants
        hFcard hdeg (O j) hd6 x z
      cases z <;> exact ⟨hlocal, hrow.1, hrow.2.1, hrow.2.2⟩

/-- Concrete `F_9 ⊂ F_6561` corollary. -/
theorem concrete_projective_q9_uniform_repair_family :
    HasProjectiveQ9UniformRepairFamily finrank_q9OuterField :=
  stichtenoth_projective_q9_uniform_repair_family
    card_q9BaseField card_q9OuterField finrank_q9OuterField

#print axioms eventually_projective_scaled_lift_distance_gt
#print axioms stichtenoth_projective_q9_uniform_repair_family
#print axioms concrete_projective_q9_uniform_repair_family

end
end RepairCodes
