import RepairCodes.Imported
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# An asymptotically good q=9 repair-code family

The sole deep input is quarantined in `RepairCodes.Imported`: Stichtenoth's
self-dual TVZ family over `F_6561`.  Everything here is a checked reduction:

1. specialize its limiting distance `39/80` to the eventual bounds `d > n/3` and
   `19n ≤ 40d`;
2. use self-duality for the same ordinary dual-distance bound;
3. restrict scalars along a degree-four extension `L/F_9` and apply the proved trace bridge;
4. concatenate with the `[19,4,8]_9` axis–twisted-cubic seed.

The result has unbounded length, exact asymptotic rate `2/19`, eventual relative distance greater
than every fixed `c < 39/190` (hence greater than `1/5`), and a bundled exact coordinate
distribution/locality/row/threshold profile.
-/

namespace RepairCodes

open Filter Finset FiniteGeom

noncomputable section

/-- A limit at least `39/80` yields the elementary eventual integer bound `n ≤ 3d`.
Kept separate from the import so the analytic-to-discrete reduction is kernel checked. -/
theorem eventually_length_le_three_mul_distance
    (n d : ℕ → ℕ) (δ : ℝ)
    (hn : Tendsto n atTop atTop)
    (hd : Tendsto (fun j ↦ (d j : ℝ) / (n j : ℝ)) atTop (nhds δ))
    (hδ : (39 : ℝ) / 80 ≤ δ) :
    ∀ᶠ j in atTop, 15 ≤ n j ∧ n j ≤ 3 * d j := by
  have hthird : (1 : ℝ) / 3 < δ := lt_of_lt_of_le (by norm_num) hδ
  have hratio : ∀ᶠ j in atTop, (1 : ℝ) / 3 < (d j : ℝ) / (n j : ℝ) :=
    (tendsto_order.mp hd).1 _ hthird
  have hlength : ∀ᶠ j in atTop, 15 ≤ n j := (tendsto_atTop.mp hn) 15
  filter_upwards [hlength, hratio] with j hjlen hjratio
  refine ⟨hjlen, ?_⟩
  have hnpos : (0 : ℝ) < n j := by exact_mod_cast (lt_of_lt_of_le (by omega : 0 < 15) hjlen)
  have hmul : (n j : ℝ) / 3 < d j := by
    have := (lt_div_iff₀ hnpos).mp hjratio
    nlinarith
  have hreal : (n j : ℝ) < 3 * d j := by nlinarith
  exact_mod_cast (Nat.le_of_lt (by exact_mod_cast hreal : n j < 3 * d j))

/-- A limit at least `39/80` yields the near-limit integer bound `19n ≤ 40d` eventually.
This is the clean `19/40 < 39/80` specialization used for the paper's `1/5` concatenated
relative-distance constant. -/
theorem eventually_nineteen_mul_length_le_forty_mul_distance
    (n d : ℕ → ℕ) (δ : ℝ)
    (hd : Tendsto (fun j ↦ (d j : ℝ) / (n j : ℝ)) atTop (nhds δ))
    (hδ : (39 : ℝ) / 80 ≤ δ) :
    ∀ᶠ j in atTop, 19 * n j ≤ 40 * d j := by
  have htarget : (19 : ℝ) / 40 < δ := lt_of_lt_of_le (by norm_num) hδ
  have hratio : ∀ᶠ j in atTop, (19 : ℝ) / 40 < (d j : ℝ) / (n j : ℝ) :=
    (tendsto_order.mp hd).1 _ htarget
  filter_upwards [hratio] with j hjratio
  by_cases hn : n j = 0
  · simp [hn]
  · have hnpos : (0 : ℝ) < n j := by exact_mod_cast Nat.pos_of_ne_zero hn
    have hmul := (lt_div_iff₀ hnpos).mp hjratio
    have hreal : (19 : ℝ) * n j < 40 * d j := by nlinarith
    exact_mod_cast (Nat.le_of_lt (by exact_mod_cast hreal : 19 * n j < 40 * d j))

/-- Every real constant below the limiting concatenated bound `39/190` is eventually a strict
relative-distance lower bound before the finite lift is applied.  The factor is
`8 * (39/80) / 19 = 39/190`. -/
theorem eventually_scaled_lift_distance_gt
    (n d : ℕ → ℕ) (δ c : ℝ)
    (hn : Tendsto n atTop atTop)
    (hd : Tendsto (fun j ↦ (d j : ℝ) / (n j : ℝ)) atTop (nhds δ))
    (hδ : (39 : ℝ) / 80 ≤ δ)
    (hc : c < (39 : ℝ) / 190) :
    ∀ᶠ j in atTop, c * (19 * n j : ℕ) < 8 * (d j : ℝ) := by
  have htarget : (19 * c) / 8 < δ := by
    apply lt_of_lt_of_le _ hδ
    nlinarith [hc]
  have hratio : ∀ᶠ j in atTop, (19 * c) / 8 < (d j : ℝ) / (n j : ℝ) :=
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

/-- The three coordinate types form a disjoint exhaustive partition with the q=9 blockwise
multiplicities used in the paper. -/
def HasQ9LiftCoordinateDistribution (iota : Type*) [Fintype iota] [DecidableEq iota] : Prop :=
  (Disjoint (q9LiftCubicCoordinates iota F) (q9LiftFiniteAxisCoordinates iota F) ∧
      Disjoint (q9LiftCubicCoordinates iota F) (q9LiftInfinityAxisCoordinates iota F) ∧
      Disjoint (q9LiftFiniteAxisCoordinates iota F) (q9LiftInfinityAxisCoordinates iota F) ∧
      q9LiftCubicCoordinates iota F ∪ q9LiftFiniteAxisCoordinates iota F ∪
          q9LiftInfinityAxisCoordinates iota F = Finset.univ) ∧
    (q9LiftCubicCoordinates iota F).card = 9 * Fintype.card iota ∧
    (q9LiftFiniteAxisCoordinates iota F).card = 9 * Fintype.card iota ∧
    (q9LiftInfinityAxisCoordinates iota F).card = Fintype.card iota

/-- The exact locality, matching/transversal row, and guaranteed helper-failure threshold at one
coordinate of a q=9 extension lift. -/
def HasQ9LiftCoordinateProfile {iota : Type*} [Fintype iota] [DecidableEq iota]
    (C : Submodule F (iota × AxisTwistedCubicIndex F → F))
    (p : iota × AxisTwistedCubicIndex F) : Prop :=
  match p.2 with
  | .inl _ =>
      HasExactLocalityAt C p 3 ∧
        matchingNumber (repairHypergraph C p 3) = 4 ∧
        transversalNumber (repairHypergraph C p 3) = 7 ∧
        transversalNumber (repairHypergraph C p 3) - 1 = 6
  | .inr (Sum.inl _) =>
      HasExactLocalityAt C p 2 ∧
        matchingNumber (repairHypergraph C p 3) = 6 ∧
        transversalNumber (repairHypergraph C p 3) = 12 ∧
        transversalNumber (repairHypergraph C p 3) - 1 = 11
  | .inr (Sum.inr _) =>
      HasExactLocalityAt C p 2 ∧
        matchingNumber (repairHypergraph C p 3) = 7 ∧
        transversalNumber (repairHypergraph C p 3) = 13 ∧
        transversalNumber (repairHypergraph C p 3) - 1 = 12

/-- The complete paper-facing asymptotic family property: unbounded block length, exact rate
`2/19`, every eventual relative-distance bound below `39/190` (including `1/5`), and the bundled
disjoint coordinate distribution with exact locality, rows, and helper-failure thresholds. -/
def HasQ9UniformRepairFamily (hdeg : Module.finrank F L = 4) : Prop :=
  ∃ (n : ℕ → ℕ) (O : (j : ℕ) → Submodule L (Fin (n j) → L)),
    Tendsto (fun j ↦ Fintype.card
      (Fin (n j) × AxisTwistedCubicIndex F)) atTop atTop ∧
    (∀ c : ℝ, c < (39 : ℝ) / 190 →
      ∀ᶠ j in atTop,
        c * Fintype.card (Fin (n j) × AxisTwistedCubicIndex F) <
          minDist (q9ExtensionLiftCode hdeg (O j))) ∧
    (∀ᶠ j in atTop,
      19 * Module.finrank F (q9ExtensionLiftCode hdeg (O j)) =
          2 * Fintype.card (Fin (n j) × AxisTwistedCubicIndex F) ∧
      Fintype.card (Fin (n j) × AxisTwistedCubicIndex F) ≤
          5 * minDist (q9ExtensionLiftCode hdeg (O j)) ∧
      HasQ9LiftCoordinateDistribution (F := F) (Fin (n j)) ∧
      ∀ p : Fin (n j) × AxisTwistedCubicIndex F,
        HasQ9LiftCoordinateProfile (q9ExtensionLiftCode hdeg (O j)) p)

/-- **End-to-end uniform-family repair theorem.**  From the single cited Stichtenoth import,
construct extension-field outer codes whose q=9 concatenations have unbounded length, exact
rate `2/19`, every eventual relative-distance bound below `39/190`, and the bundled exact
coordinate distribution, locality, repair rows, and helper-failure thresholds.

The theorem's axiom report contains exactly the quarantined Stichtenoth theorem in addition
to Lean's standard logical axioms. -/
theorem stichtenoth_q9_uniform_repair_family
    (hFcard : Fintype.card F = 9) (hLcard : Fintype.card L = 6561)
    (hdeg : Module.finrank F L = 4) : HasQ9UniformRepairFamily hdeg := by
  unfold HasQ9UniformRepairFamily
  obtain ⟨n, O, δ, hself, hdim, hn, hdist, hδ⟩ :=
    Imported.stichtenoth_selfDual_TVZ_6561 L hLcard
  refine ⟨n, O, ?_, ?_, ?_⟩
  · have hmul : Tendsto (fun j ↦ 19 * n j) atTop atTop := by
      apply tendsto_atTop.mpr
      intro b
      filter_upwards [(tendsto_atTop.mp hn) b] with j hj
      omega
    simpa only [Fintype.card_prod, Fintype.card_fin,
      card_axisTwistedCubicIndex, hFcard, Nat.mul_comm] using hmul
  · intro c hc
    have hscaled := eventually_scaled_lift_distance_gt n
      (fun j ↦ minDist (O j)) δ c hn hdist hδ hc
    have hgood := eventually_length_le_three_mul_distance n
      (fun j ↦ minDist (O j)) δ hn hdist hδ
    filter_upwards [hscaled, hgood] with j hjscaled hjgood
    have hO0 : O j ≠ ⊥ := by
      intro hbot
      have hdimj := hdim j
      rw [hbot] at hdimj
      simp at hdimj
      omega
    obtain ⟨hlen, -, hdistLift⟩ :=
      q9ExtensionLiftCode_parameters hFcard hdeg (O j) hO0
    rw [hlen]
    simp only [Fintype.card_fin]
    have hdistReal : ((8 * minDist (O j) : ℕ) : ℝ) ≤
        (minDist (q9ExtensionLiftCode hdeg (O j)) : ℝ) := by
      exact_mod_cast hdistLift
    exact hjscaled.trans_le (by simpa using hdistReal)
  · have hgood := eventually_length_le_three_mul_distance n
      (fun j ↦ minDist (O j)) δ hn hdist hδ
    have hsharp := eventually_nineteen_mul_length_le_forty_mul_distance n
      (fun j ↦ minDist (O j)) δ hdist hδ
    filter_upwards [hgood, hsharp] with j hj hjsharp
    have hdual : dualDist (O j) = minDist (O j) := by
      unfold dualDist
      rw [← hself j]
    have hd5 : 5 ≤ dualDist (O j) := by rw [hdual]; omega
    have hO0 : O j ≠ ⊥ := by
      intro hbot
      have hdimj := hdim j
      rw [hbot] at hdimj
      simp at hdimj
      omega
    obtain ⟨hlen, hdimLift, hdistLift⟩ :=
      q9ExtensionLiftCode_parameters hFcard hdeg (O j) hO0
    refine ⟨?_, ?_, ?_, ?_⟩
    · rw [hdimLift, hlen]
      have := hdim j
      simp only [Fintype.card_fin]
      omega
    · rw [hlen]
      simp only [Fintype.card_fin]
      omega
    · unfold HasQ9LiftCoordinateDistribution
      exact ⟨q9Lift_coordinate_type_partition,
        q9Lift_coordinate_type_counts hFcard⟩
    · rintro ⟨x, z⟩
      have hrow := q9ExtensionLiftCode_row_invariants hFcard hdeg (O j) hd5 x z
      have hthreshold := q9ExtensionLiftCode_failure_thresholds hFcard hdeg (O j) hd5 x z
      cases z with
      | inl a =>
          obtain ⟨hexists, hnoTwo⟩ :=
            q9ExtensionLiftCode_cubic_exact_locality_three hdeg (O j) hd5 x a
          have hlocal : HasExactLocalityAt
              (q9ExtensionLiftCode hdeg (O j)) (x, .inl a) 3 := by
            refine ⟨hexists, ?_⟩
            intro s hs hnonempty
            obtain ⟨R, hR⟩ := hnonempty
            exact hnoTwo R (repairHypergraph_mono_radius (by omega) hR)
          exact ⟨hlocal, hrow.1, hrow.2, hthreshold⟩
      | inr y =>
          obtain ⟨hexists, hnoOne⟩ :=
            q9ExtensionLiftCode_axis_exact_locality_two hdeg (O j) hd5 x y
          have hlocal : HasExactLocalityAt
              (q9ExtensionLiftCode hdeg (O j)) (x, .inr y) 2 := by
            refine ⟨hexists, ?_⟩
            intro s hs hnonempty
            obtain ⟨R, hR⟩ := hnonempty
            exact hnoOne R (repairHypergraph_mono_radius (by omega) hR)
          cases y with
          | inl b => exact ⟨hlocal, hrow.1, hrow.2, hthreshold⟩
          | inr u => cases u; exact ⟨hlocal, hrow.1, hrow.2, hthreshold⟩

/-- A concrete model of `F_9`. -/
abbrev Q9BaseField := GaloisField 3 2

/-- A concrete model of `F_6561 = F_{9^4}`. -/
abbrev Q9OuterField := GaloisField 3 8

noncomputable instance : Fintype Q9BaseField := Fintype.ofFinite Q9BaseField
noncomputable instance : Fintype Q9OuterField := Fintype.ofFinite Q9OuterField
noncomputable instance : DecidableEq Q9BaseField := Classical.decEq Q9BaseField
noncomputable instance : DecidableEq Q9OuterField := Classical.decEq Q9OuterField

/-- A chosen `F_3`-embedding `F_9 → F_6561`; it exists because `2 ∣ 8`. -/
noncomputable def q9BaseToOuter : Q9BaseField →ₐ[ZMod 3] Q9OuterField := by
  exact Classical.choice (FiniteField.nonempty_algHom_of_finrank_dvd (by
    rw [GaloisField.finrank 3 (by norm_num : (2 : ℕ) ≠ 0),
      GaloisField.finrank 3 (by norm_num : (8 : ℕ) ≠ 0)]
    norm_num))

noncomputable instance : Algebra Q9BaseField Q9OuterField :=
  q9BaseToOuter.toRingHom.toAlgebra

noncomputable instance : IsScalarTower (ZMod 3) Q9BaseField Q9OuterField :=
  .of_algebraMap_eq (fun x ↦ by
    change (algebraMap (ZMod 3) Q9OuterField) x =
      q9BaseToOuter ((algebraMap (ZMod 3) Q9BaseField) x)
    exact (q9BaseToOuter.commutes x).symm)

theorem card_q9BaseField : Fintype.card Q9BaseField = 9 := by
  rw [Fintype.card_eq_nat_card, GaloisField.card 3 2 (by norm_num)]
  norm_num

theorem card_q9OuterField : Fintype.card Q9OuterField = 6561 := by
  rw [Fintype.card_eq_nat_card, GaloisField.card 3 8 (by norm_num)]
  norm_num

theorem finrank_q9OuterField : Module.finrank Q9BaseField Q9OuterField = 4 := by
  have h := Module.finrank_mul_finrank (ZMod 3) Q9BaseField Q9OuterField
  rw [GaloisField.finrank 3 (by norm_num : (2 : ℕ) ≠ 0),
    GaloisField.finrank 3 (by norm_num : (8 : ℕ) ≠ 0)] at h
  omega

/-- **Concrete unconditional corollary (modulo the one cited import).**  There is an
unbounded family over the actual `GaloisField 3 2` model of `F_9` with exact rate `2/19`, every
eventual relative-distance bound below `39/190`, and the bundled exact coordinate profiles. -/
theorem concrete_q9_uniform_repair_family :
    HasQ9UniformRepairFamily finrank_q9OuterField :=
  stichtenoth_q9_uniform_repair_family card_q9BaseField card_q9OuterField
    finrank_q9OuterField

#print axioms eventually_length_le_three_mul_distance
#print axioms eventually_nineteen_mul_length_le_forty_mul_distance
#print axioms eventually_scaled_lift_distance_gt
#print axioms stichtenoth_q9_uniform_repair_family
#print axioms concrete_q9_uniform_repair_family

end
end RepairCodes
