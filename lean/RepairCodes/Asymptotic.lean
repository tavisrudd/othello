import RepairCodes.Imported
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# An asymptotically good q=9 repair-code family

The sole deep input is quarantined in `RepairCodes.Imported`: Stichtenoth's
self-dual TVZ family over `F_6561`.  Everything here is a checked reduction:

1. specialize its limiting distance `39/80` to the conservative eventual bound `d > n/3`;
2. use self-duality for the same ordinary dual-distance bound;
3. restrict scalars along a degree-four extension `L/F_9` and apply the proved trace bridge;
4. concatenate with the `[19,4,8]_9` axis–twisted-cubic seed.

The result has unbounded length, exact asymptotic rate `2/19`, eventual relative distance at
least `8/57`, and exact blockwise repair rows `(4,7)`, `(6,12)`, `(7,13)`.
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

variable {F L : Type*}
variable [Field F] [Fintype F] [DecidableEq F] [CharP F 3]
variable [Field L] [Fintype L] [DecidableEq L] [Algebra F L]
variable [FiniteDimensional F L] [Algebra.IsSeparable F L]

/-- The complete paper-facing asymptotic family property: unbounded block length, exact rate
`2/19`, eventual relative distance at least `8/57`, and all three exact q=9 repair rows. -/
def HasQ9UniformRepairFamily (hdeg : Module.finrank F L = 4) : Prop :=
  ∃ (n : ℕ → ℕ) (O : (j : ℕ) → Submodule L (Fin (n j) → L)),
    Tendsto (fun j ↦ Fintype.card
      (Fin (n j) × AxisTwistedCubicIndex F)) atTop atTop ∧
    (∀ᶠ j in atTop,
      19 * Module.finrank F (q9ExtensionLiftCode hdeg (O j)) =
          2 * Fintype.card (Fin (n j) × AxisTwistedCubicIndex F) ∧
      8 * Fintype.card (Fin (n j) × AxisTwistedCubicIndex F) ≤
          57 * minDist (q9ExtensionLiftCode hdeg (O j)) ∧
      ∀ (x : Fin (n j)) (z : AxisTwistedCubicIndex F),
        (∃ R, R ∈ repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) ∧
          match z with
          | .inl _ =>
              matchingNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 4 ∧
                transversalNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 7
          | .inr (Sum.inr _) =>
              matchingNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 7 ∧
                transversalNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 13
          | .inr (Sum.inl _) =>
              matchingNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 6 ∧
                transversalNumber
                  (repairHypergraph (q9ExtensionLiftCode hdeg (O j)) (x, z) 3) = 12)

/-- **End-to-end uniform-family repair theorem.**  From the single cited Stichtenoth import,
construct extension-field outer codes whose q=9 concatenations have unbounded length, exact
rate `2/19`, eventual relative distance at least `8/57`, and the exact repair row at every
coordinate.

The theorem's axiom report contains exactly the quarantined Stichtenoth theorem in addition
to Lean's standard logical axioms. -/
theorem stichtenoth_q9_uniform_repair_family
    (hFcard : Fintype.card F = 9) (hLcard : Fintype.card L = 6561)
    (hdeg : Module.finrank F L = 4) : HasQ9UniformRepairFamily hdeg := by
  unfold HasQ9UniformRepairFamily
  obtain ⟨n, O, δ, hself, hdim, hn, hdist, hδ⟩ :=
    Imported.stichtenoth_selfDual_TVZ_6561 L hLcard
  refine ⟨n, O, ?_, ?_⟩
  · have hmul : Tendsto (fun j ↦ 19 * n j) atTop atTop := by
      apply tendsto_atTop.mpr
      intro b
      filter_upwards [(tendsto_atTop.mp hn) b] with j hj
      omega
    simpa only [Fintype.card_prod, Fintype.card_fin,
      card_axisTwistedCubicIndex, hFcard, Nat.mul_comm] using hmul
  · have hgood := eventually_length_le_three_mul_distance n
      (fun j ↦ minDist (O j)) δ hn hdist hδ
    filter_upwards [hgood] with j hj
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
    refine ⟨?_, ?_, ?_⟩
    · rw [hdimLift, hlen]
      have := hdim j
      simp only [Fintype.card_fin]
      omega
    · rw [hlen]
      simp only [Fintype.card_fin]
      omega
    · intro x z
      exact ⟨q9ExtensionLiftCode_allSymbol_locality_three hdeg (O j) hd5 x z,
        q9ExtensionLiftCode_row_invariants hFcard hdeg (O j) hd5 x z⟩

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
unbounded family over the actual `GaloisField 3 2` model of `F_9` with exact rate `2/19`,
eventual relative distance at least `8/57`, and exact all-coordinate repair rows. -/
theorem concrete_q9_uniform_repair_family :
    HasQ9UniformRepairFamily finrank_q9OuterField :=
  stichtenoth_q9_uniform_repair_family card_q9BaseField card_q9OuterField
    finrank_q9OuterField

#print axioms eventually_length_le_three_mul_distance
#print axioms stichtenoth_q9_uniform_repair_family
#print axioms concrete_q9_uniform_repair_family

end
end RepairCodes
