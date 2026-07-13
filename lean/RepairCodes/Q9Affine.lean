import RepairCodes.Q9Seed
import Mathlib.LinearAlgebra.Dimension.Free

/-!
# The q=9 repair hypergraph as the affine plane `AG(2,3)`

The axis repair edges of the concrete `[10,4,6]₉` seed are already characterized in
`Q9Seed` as distinct zero-sum triples of `𝔽₉`. This file transports that description to the
two-dimensional additive space over `ZMod 3` and evaluates its matching and transversal numbers.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

local instance : Fintype GF9 := Fintype.ofFinite GF9
local instance : DecidableEq GF9 := Classical.decEq _

/-- Three-element zero-sum subsets of a finite additive group. In an elementary abelian
three-group these are exactly the affine lines. -/
def zeroSumTripleHypergraph (A : Type*) [AddCommGroup A] [Fintype A] [DecidableEq A] :
    Finset (Finset A) :=
  (Finset.univ.powersetCard 3).filter fun s => ∑ x ∈ s, x = 0

@[simp]
theorem mem_zeroSumTripleHypergraph {A : Type*} [AddCommGroup A] [Fintype A] [DecidableEq A]
    {s : Finset A} :
    s ∈ zeroSumTripleHypergraph A ↔ s.card = 3 ∧ ∑ x ∈ s, x = 0 := by
  simp [zeroSumTripleHypergraph]

/-- Zero-sum triple hypergraphs are functorial under additive equivalences. -/
theorem relabel_zeroSumTripleHypergraph {A B : Type*} [AddCommGroup A] [AddCommGroup B]
    [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B] (e : A ≃+ B) :
    relabelHypergraph e.toEquiv (zeroSumTripleHypergraph A) = zeroSumTripleHypergraph B := by
  ext t
  constructor
  · intro ht
    obtain ⟨s, hs, rfl⟩ := Finset.mem_image.mp ht
    rw [mem_zeroSumTripleHypergraph] at hs ⊢
    refine ⟨by simpa using hs.1, ?_⟩
    have hsum : ∑ x ∈ s.map e.toEquiv.toEmbedding, x = e (∑ x ∈ s, x) := by
      rw [Finset.sum_map]
      simp
    rw [hsum, hs.2, map_zero]
  · intro ht
    rw [mem_zeroSumTripleHypergraph] at ht
    let s := t.map e.symm.toEquiv.toEmbedding
    have hsmap : s.map e.toEquiv.toEmbedding = t := by
      simp [s, Finset.map_map]
    apply Finset.mem_image.mpr
    refine ⟨s, ?_, hsmap⟩
    rw [mem_zeroSumTripleHypergraph]
    refine ⟨?_, ?_⟩
    · simpa [s] using ht.1
    · have hsum : ∑ x ∈ s, x = e.symm (∑ x ∈ t, x) := by
        change (∑ x ∈ t.map e.symm.toEquiv.toEmbedding, x) = e.symm (∑ x ∈ t, x)
        rw [Finset.sum_map]
        simp
      rw [hsum, ht.2, map_zero]

/-- Coordinate model of `AG(2,3)`. -/
abbrev AG23 := Fin 2 → ZMod 3

private instance decidableIsMatchingAG23
    (H M : Finset (Finset AG23)) : Decidable (IsMatching H M) := by
  unfold IsMatching
  infer_instance

private instance decidableIsTransversalAG23
    (H : Finset (Finset AG23)) (T : Finset AG23) : Decidable (IsTransversal H T) := by
  unfold IsTransversal
  infer_instance

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The twelve affine lines of `AG(2,3)` have matching number three and transversal number five. -/
theorem ag23_zeroSum_invariants :
    matchingNumber (zeroSumTripleHypergraph AG23) = 3 ∧
      transversalNumber (zeroSumTripleHypergraph AG23) = 5 := by
  let H := zeroSumTripleHypergraph AG23
  let rows : Finset (Finset AG23) := Finset.univ.image fun a : ZMod 3 =>
    Finset.univ.filter fun p : AG23 => p 0 = a
  have hMthree : IsMatching H rows ∧ rows.card = 3 := by decide
  obtain ⟨hM, hMcard⟩ := hMthree
  have hnu_ge : 3 ≤ matchingNumber H := by
    rw [← hMcard]
    exact card_le_matchingNumber hM
  have hnu_le : matchingNumber H ≤ 3 := by
    unfold matchingNumber
    refine csSup_le ⟨0, ∅, ⟨empty_subset _, by intro a ha; simp at ha⟩, card_empty⟩ ?_
    rintro n ⟨M', hM', rfl⟩
    have hpw : (M' : Set (Finset AG23)).PairwiseDisjoint id := by
      intro a ha b hb hab
      exact hM'.2 ha hb hab
    have hunion : (M'.biUnion id).card = 3 * M'.card := by
      rw [Finset.card_biUnion hpw]
      calc
        (∑ s ∈ M', s.card) = ∑ _s ∈ M', 3 := by
          apply Finset.sum_congr rfl
          intro s hs
          exact (mem_zeroSumTripleHypergraph.mp (hM'.1 hs)).1
        _ = 3 * M'.card := by simp [Nat.mul_comm]
    have hle : (M'.biUnion id).card ≤ 9 := by
      calc
        (M'.biUnion id).card ≤ Finset.univ.card := Finset.card_le_card (Finset.subset_univ _)
        _ = 9 := by decide
    rw [hunion] at hle
    omega
  let cap : Finset AG23 := Finset.univ.filter fun p => p 0 ∈ ({0, 1} : Finset (ZMod 3)) ∧
    p 1 ∈ ({0, 1} : Finset (ZMod 3))
  let T : Finset AG23 := Finset.univ \ cap
  have hTfive : IsTransversal H T ∧ T.card = 5 := by decide
  obtain ⟨hT, hTcard⟩ := hTfive
  have htau_le : transversalNumber H ≤ 5 := by
    rw [← hTcard]
    exact transversalNumber_le_card hT
  have hTne : ({n | ∃ T, IsTransversal H T ∧ T.card = n} : Set ℕ).Nonempty :=
    ⟨5, T, hT, hTcard⟩
  have htau_ge : 5 ≤ transversalNumber H := by
    have hbound : ∀ T, IsTransversal H T → 5 ≤ T.card := by decide
    unfold transversalNumber
    exact le_csInf hTne (by rintro n ⟨T', hT', rfl⟩; exact hbound T' hT')
  constructor
  · have hge : 3 ≤ matchingNumber (zeroSumTripleHypergraph AG23) := by simpa [H] using hnu_ge
    have hle : matchingNumber (zeroSumTripleHypergraph AG23) ≤ 3 := by simpa [H] using hnu_le
    omega
  · have hge : 5 ≤ transversalNumber (zeroSumTripleHypergraph AG23) := by simpa [H] using htau_ge
    have hle : transversalNumber (zeroSumTripleHypergraph AG23) ≤ 5 := by simpa [H] using htau_le
    omega

/-- A basis identifies the additive group of `𝔽₉` with the coordinate plane over `ZMod 3`. -/
noncomputable def gf9AG23LinearEquiv : GF9 ≃ₗ[ZMod 3] AG23 :=
  (Module.finBasisOfFinrankEq (ZMod 3) GF9
    (GaloisField.finrank 3 (n := 2) (by decide))).equivFun

/-- Embedding of the nine finite seed coordinates; its unique missing coordinate is the axis. -/
noncomputable def q9FiniteEmbedding : GF9 ↪ Fin 10 :=
  ⟨q9FiniteIndex, q9FiniteIndex_injective⟩

/-- A zero-sum triple of field parameters maps to an actual axis repair edge. -/
theorem q9FiniteImage_mem_repair {S : Finset GF9} (hS : S ∈ zeroSumTripleHypergraph GF9) :
    S.map q9FiniteEmbedding ∈ q9AxisRepairHypergraph := by
  have hScard : S.card = 3 := (mem_zeroSumTripleHypergraph.mp hS).1
  have hSsum : ∑ x ∈ S, x = 0 := (mem_zeroSumTripleHypergraph.mp hS).2
  let R : Finset (Fin 10) := S.map q9FiniteEmbedding
  have hRcard : R.card = 3 := by simpa [R] using hScard
  have hsub : R ⊆ Finset.univ.erase q9Axis := by
    intro j hj
    obtain ⟨t, -, rfl⟩ := Finset.mem_map.mp hj
    exact Finset.mem_erase.mpr ⟨q9FiniteIndex_ne_axis t, Finset.mem_univ _⟩
  let eS : Fin 3 ≃ S := (S.equivFinOfCardEq hScard).symm
  let g : Fin 3 → R := fun i => ⟨q9FiniteIndex (eS i), by
    exact Finset.mem_map.mpr ⟨eS i, (eS i).property, rfl⟩⟩
  have hg : Function.Injective g := by
    intro i j hij
    apply eS.injective
    apply Subtype.ext
    exact q9FiniteIndex_injective (congrArg Subtype.val hij)
  let er : Fin 3 ≃ R := Equiv.ofBijective g
    ((Fintype.bijective_iff_injective_and_card _).2 ⟨hg, by
      rw [Fintype.card_fin, Fintype.card_coe, hRcard]⟩)
  have her (i : Fin 3) : (er i : Fin 10) = q9FiniteIndex (eS i) := rfl
  have hsum : q9IndexParam (er 0) + q9IndexParam (er 1) + q9IndexParam (er 2) = 0 := by
    simp only [her, q9IndexParam_finiteIndex]
    have henum : (eS 0 : GF9) + eS 1 + eS 2 = ∑ i : Fin 3, (eS i : GF9) := by
      rw [Fin.sum_univ_three]
    rw [henum]
    rw [Equiv.sum_comp eS]
    calc
      (∑ x : S, (x : GF9)) = ∑ x ∈ S, x := by
        rw [← S.sum_attach]
        rfl
      _ = 0 := hSsum
  exact q9AxisRepair_edge_of_zeroSum hsub hRcard er hsum

/-- The zero-sum triple hypergraph of the additive group of `𝔽₉` already has the desired sharp
invariants. The remaining code-facing step is to transport along `q9FiniteIndex` into the ten
seed coordinates, where the axis is an isolated vertex. -/
theorem gf9_zeroSum_invariants :
    matchingNumber (zeroSumTripleHypergraph GF9) = 3 ∧
      transversalNumber (zeroSumTripleHypergraph GF9) = 5 := by
  let e : GF9 ≃+ AG23 := gf9AG23LinearEquiv.toAddEquiv
  have hmap := relabel_zeroSumTripleHypergraph e
  have hnu := matchingNumber_relabelHypergraph e.toEquiv
    (zeroSumTripleHypergraph GF9)
  have htau := transversalNumber_relabelHypergraph e.toEquiv
    (zeroSumTripleHypergraph GF9)
  rw [hmap] at hnu htau
  exact ⟨hnu.symm.trans ag23_zeroSum_invariants.1,
    htau.symm.trans ag23_zeroSum_invariants.2⟩

end

end RepairCodes
