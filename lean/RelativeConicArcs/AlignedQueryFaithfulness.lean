import RelativeConicArcs.AlignedFamilyFaithfulness
import RelativeConicArcs.AlignedQueryFamily

/-!
# Faithfulness from the query family of a single anchor

Faithfulness of the aligned four-set family reads every four-set of the point
set.  The decoder behind it reads far fewer: after one aligned four-point
anchor `Q` is known, it queries only the four-sets meeting `Q` in at least two
points, the family `selectedQueryFamily` whose size is `3n^2 - 23n + 45`.  This
module proves that those queries already determine the two-graph up to one
global complement bit, which is the sufficiency statement the count
accompanies.

The argument is the seven-point mechanism applied along a fixed anchor rather
than along a freshly chosen one.  Every seven-point subset containing `Q` is
normalized at a point of `Q`, and on it the tests read by
`sevenPoint_agreement` are exactly the tests meeting `Q` in three or in two
points; the anchor itself is the one test meeting `Q` in four.  Any three
further points lie with `Q` in a seven-point subset, so each such triple
receives a complement bit, and all these bits agree because every one of the
seven-point subsets contains the triple from `Q` on which the bit is
calibrated.  No search over four-sets outside the query family occurs.  The
anchor is a hypothesis of the sufficiency theorems, and it is never vacuous:
`exists_distinct_alignedAnchor` produces an aligned four-set of distinct points
on any point set with at least seven of them.

Nothing here is a finite enumeration.  The finite classifications used are the
ones already kernel-decided for the normalized seven-point signatures.
-/

namespace RelativeConicArcs
namespace AlignedTwoGraph

variable {α : Type*} {tau sigma : α → α → α → Bool}

/-- Four pairwise distinct labels span a four-element set. -/
theorem card_quadruple [DecidableEq α] {a b c d : α}
    (h : DistinctQuadruple a b c d) : ({a, b, c, d} : Finset α).card = 4 := by
  obtain ⟨hab, hac, had, hbc, hbd, hcd⟩ := h
  rw [Finset.card_insert_of_notMem (by simp [hab, hac, had]),
    Finset.card_insert_of_notMem (by simp [hbc, hbd]),
    Finset.card_insert_of_notMem (by simp [hcd]), Finset.card_singleton]

section SevenPoint

variable [DecidableEq α]

/-- On a seven-point set containing a four-point anchor aligned for the first
two-graph, the tests meeting that anchor in at least two points already force
the two two-graphs to differ by one complement bit.  The anchor is supplied
rather than searched for, and no test disjoint from it or meeting it in a
single point is read. -/
theorem exists_complementBit_on_seven_of_anchor
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    {q₀ q₁ q₂ q₃ : α} (hQ : DistinctQuadruple q₀ q₁ q₂ q₃)
    (hanchor : Aligned tau q₀ q₁ q₂ q₃)
    (S : Finset α) (hS : S.card = 7)
    (hq₀ : q₀ ∈ S) (hq₁ : q₁ ∈ S) (hq₂ : q₂ ∈ S) (hq₃ : q₃ ∈ S)
    (hsel : ∀ a b c d : α, a ∈ S → b ∈ S → c ∈ S → d ∈ S →
      DistinctQuadruple a b c d →
      2 ≤ (({a, b, c, d} : Finset α) ∩ {q₀, q₁, q₂, q₃}).card →
      (Aligned tau a b c d ↔ Aligned sigma a b c d)) :
    ∃ epsilon : Bool, ∀ a b c : α, a ∈ S → b ∈ S → c ∈ S → DistinctTriple a b c →
      AgreesWithComplementBit tau sigma epsilon a b c := by
  classical
  obtain ⟨hq₀₁, hq₀₂, hq₀₃, hq₁₂, hq₁₃, hq₂₃⟩ := hQ
  set Q : Finset α := {q₀, q₁, q₂, q₃} with hQdef
  have hQcard : Q.card = 4 :=
    card_quadruple ⟨hq₀₁, hq₀₂, hq₀₃, hq₁₂, hq₁₃, hq₂₃⟩
  have hQsub : Q ⊆ S := by
    intro x hx
    simp only [hQdef, Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl | rfl
    · exact hq₀
    · exact hq₁
    · exact hq₂
    · exact hq₃
  -- The three points of the seven-set outside the anchor.
  set U : Finset α := S \ Q with hUdef
  have hUcard : U.card = 3 := by
    rw [hUdef, Finset.card_sdiff, Finset.inter_eq_left.mpr hQsub, hS, hQcard]
  obtain ⟨x₀, x₁, x₂, hx₀₁, hx₀₂, hx₁₂, hUeq⟩ := Finset.card_eq_three.mp hUcard
  have hxmem : ∀ y ∈ ({x₀, x₁, x₂} : Finset α), y ∈ S ∧ y ∉ Q := by
    intro y hy
    have hyU : y ∈ U := by rw [hUeq]; exact hy
    rw [hUdef, Finset.mem_sdiff] at hyU
    exact hyU
  have hx₀ := hxmem x₀ (by simp)
  have hx₁ := hxmem x₁ (by simp)
  have hx₂ := hxmem x₂ (by simp)
  -- Index the seven points with the anchor first and its root at index zero.
  set p : Fin 7 → α := ![q₀, q₁, q₂, q₃, x₀, x₁, x₂] with hp
  have hpQ : ∀ u : Fin 7, u ∈ ({0, 1, 2, 3} : Finset (Fin 7)) → p u ∈ Q := by
    intro u hu
    simp only [Finset.mem_insert, Finset.mem_singleton] at hu
    rcases hu with rfl | rfl | rfl | rfl <;> simp [hp, hQdef]
  have hpS : ∀ t : Fin 7, p t ∈ S := by
    intro t
    fin_cases t <;> simp only [hp]
    · exact hq₀
    · exact hq₁
    · exact hq₂
    · exact hq₃
    · exact hx₀.1
    · exact hx₁.1
    · exact hx₂.1
  have hpsurj : ∀ a ∈ S, ∃ t : Fin 7, p t = a := by
    intro a ha
    by_cases hQa : a ∈ Q
    · simp only [hQdef, Finset.mem_insert, Finset.mem_singleton] at hQa
      rcases hQa with rfl | rfl | rfl | rfl
      · exact ⟨0, by simp [hp]⟩
      · exact ⟨1, by simp [hp]⟩
      · exact ⟨2, by simp [hp]⟩
      · exact ⟨3, by simp [hp]⟩
    · have haU : a ∈ U := Finset.mem_sdiff.mpr ⟨ha, hQa⟩
      rw [hUeq] at haU
      simp only [Finset.mem_insert, Finset.mem_singleton] at haU
      rcases haU with rfl | rfl | rfl
      · exact ⟨4, by simp [hp]⟩
      · exact ⟨5, by simp [hp]⟩
      · exact ⟨6, by simp [hp]⟩
  have hpinj : Function.Injective p := by
    intro a b hab
    refine Finset.inj_on_of_surj_on_of_card_le (t := S) (fun t _ => p t)
      (fun t _ => hpS t) (fun y hy => ?_) ?_ (Finset.mem_univ a) (Finset.mem_univ b) hab
    · obtain ⟨t, ht⟩ := hpsurj y hy
      exact ⟨t, Finset.mem_univ t, ht⟩
    · simp [hS]
  -- Shift both two-graphs so that the anchor bit vanishes.
  set eT : Bool := tau (p 0) (p 1) (p 2) with heT
  set eS : Bool := sigma (p 0) (p 1) (p 2) with heS
  have hanchorT : Aligned tau (p 0) (p 1) (p 2) (p 3) := by
    simpa [hp] using hanchor
  have hanchorS : Aligned sigma (p 0) (p 1) (p 2) (p 3) := by
    have hmem : ∀ t : Fin 7, p t ∈ S := hpS
    refine (hsel (p 0) (p 1) (p 2) (p 3) (hmem 0) (hmem 1) (hmem 2) (hmem 3) ?_ ?_).mp
      hanchorT
    · exact ⟨fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide),
        fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide),
        fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide)⟩
    · exact two_le_card_inter_of_two_common (p 0) (p 1)
        (fun h => absurd (hpinj h) (by decide)) (by simp) (hpQ 0 (by decide))
        (by simp) (hpQ 1 (by decide))
  have hnT : NormalizedAnchor (xorBit tau eT) (p 0) (p 1) (p 2) (p 3) :=
    normalizedAnchor_of_aligned ((aligned_xorBit_iff tau eT _ _ _ _).mpr hanchorT)
      (by simp [xorBit, heT])
  have hnS : NormalizedAnchor (xorBit sigma eS) (p 0) (p 1) (p 2) (p 3) :=
    normalizedAnchor_of_aligned ((aligned_xorBit_iff sigma eS _ _ _ _).mpr hanchorS)
      (by simp [xorBit, heS])
  have hagree := sevenPoint_agreement p (triangleSymmetric_xorBit hsymT eT)
    (fourSetParity_xorBit hparT eT) (triangleSymmetric_xorBit hsymS eS)
    (fourSetParity_xorBit hparS eS) hnT hnS
    (by
      intro i j k l hij hik hil hjk hjl hkl hinter
      rw [aligned_xorBit_iff, aligned_xorBit_iff]
      refine hsel (p i) (p j) (p k) (p l) (hpS i) (hpS j) (hpS k) (hpS l)
        ⟨fun h => hij (hpinj h), fun h => hik (hpinj h), fun h => hil (hpinj h),
          fun h => hjk (hpinj h), fun h => hjl (hpinj h), fun h => hkl (hpinj h)⟩ ?_
      -- Two anchor indices among `i, j, k, l` give two anchor points.
      obtain ⟨u, hu, v, hv, huv⟩ := Finset.one_lt_card.mp (by omega : 1 <
        ((({i, j, k, l} : Finset (Fin 7)) ∩ {0, 1, 2, 3}).card))
      rw [Finset.mem_inter] at hu hv
      have hmemp : ∀ w : Fin 7, w ∈ ({i, j, k, l} : Finset (Fin 7)) →
          p w ∈ ({p i, p j, p k, p l} : Finset α) := by
        intro w hw
        simp only [Finset.mem_insert, Finset.mem_singleton] at hw
        rcases hw with rfl | rfl | rfl | rfl <;> simp
      exact two_le_card_inter_of_two_common (p u) (p v) (fun h => huv (hpinj h))
        (hmemp u hu.1) (hpQ u hu.2) (hmemp v hv.1) (hpQ v hv.2))
  refine ⟨Bool.xor eT eS, ?_⟩
  intro a b c ha hb hc habc
  obtain ⟨ia, rfl⟩ := hpsurj a ha
  obtain ⟨ib, rfl⟩ := hpsurj b hb
  obtain ⟨ic, rfl⟩ := hpsurj c hc
  have hne : ia ≠ ib ∧ ia ≠ ic ∧ ib ≠ ic :=
    ⟨fun h => habc.1 (congrArg p h), fun h => habc.2.1 (congrArg p h),
      fun h => habc.2.2 (congrArg p h)⟩
  have := hagree ia ib ic hne.1 hne.2.1 hne.2.2
  simp only [xorBit_apply] at this
  unfold AgreesWithComplementBit
  revert this
  cases tau (p ia) (p ib) (p ic) <;> cases sigma (p ia) (p ib) (p ic) <;>
    cases eT <;> cases eS <;> simp

end SevenPoint

/-- Sufficiency of the query family of a single anchor.  On a finite point set
with at least seven points, fix a four-point anchor aligned for the first
two-graph.  If the two two-graphs agree on which four-sets meeting that anchor
in at least two points are aligned, then their triangle bits agree on every
triple of distinct points after one global complement.

Only the tests of the anchor's query family are read, so this is the exact
statement that the `3n^2 - 23n + 45` tests counted by
`card_selectedQueryFamily` suffice for a decoder working from one anchor. -/
theorem exists_complementBit_of_selectedQuery_eq [Fintype α] [DecidableEq α]
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    (hcard : 7 ≤ Fintype.card α)
    {q₀ q₁ q₂ q₃ : α} (hQ : DistinctQuadruple q₀ q₁ q₂ q₃)
    (hanchor : Aligned tau q₀ q₁ q₂ q₃)
    (hsel : ∀ a b c d : α, DistinctQuadruple a b c d →
      2 ≤ (({a, b, c, d} : Finset α) ∩ {q₀, q₁, q₂, q₃}).card →
      (Aligned tau a b c d ↔ Aligned sigma a b c d)) :
    ∃ epsilon : Bool, ∀ a b c : α, DistinctTriple a b c →
      sigma a b c = Bool.xor (tau a b c) epsilon := by
  classical
  have hanchorTriple : DistinctTriple q₀ q₁ q₂ := ⟨hQ.1, hQ.2.1, hQ.2.2.2.1⟩
  -- Every triple lies with the anchor in a seven-point subset.
  have hseven : ∀ a b c : α, DistinctTriple a b c →
      ∃ epsilon, AgreesWithComplementBit tau sigma epsilon q₀ q₁ q₂ ∧
        AgreesWithComplementBit tau sigma epsilon a b c := by
    intro a b c habc
    have hle : ({q₀, q₁, q₂, q₃, a, b, c} : Finset α).card ≤ 7 := by
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      exact (Finset.card_singleton c).le
    obtain ⟨S, hsub, hS⟩ :=
      Finset.exists_superset_card_eq (s := ({q₀, q₁, q₂, q₃, a, b, c} : Finset α))
        (n := 7) hle hcard
    have hmem : ∀ w ∈ ({q₀, q₁, q₂, q₃, a, b, c} : Finset α), w ∈ S := fun w hw => hsub hw
    obtain ⟨epsilon, hagree⟩ :=
      exists_complementBit_on_seven_of_anchor hsymT hparT hsymS hparS hQ hanchor S hS
        (hmem q₀ (by simp)) (hmem q₁ (by simp)) (hmem q₂ (by simp)) (hmem q₃ (by simp))
        (fun a' b' c' d' _ _ _ _ hd hi => hsel a' b' c' d' hd hi)
    exact ⟨epsilon,
      hagree q₀ q₁ q₂ (hmem q₀ (by simp)) (hmem q₁ (by simp)) (hmem q₂ (by simp))
        hanchorTriple,
      hagree a b c (hmem a (by simp)) (hmem b (by simp)) (hmem c (by simp)) habc⟩
  obtain ⟨epsilon, hbase, -⟩ := hseven q₀ q₁ q₂ hanchorTriple
  refine ⟨epsilon, ?_⟩
  intro a b c habc
  obtain ⟨delta, hbase', habc'⟩ := hseven a b c habc
  have heq := complementBit_unique tau sigma q₀ q₁ q₂ epsilon delta hbase hbase'
  rw [heq]
  exact habc'

/-- On at least seven points every two-graph has an aligned four-set of
pairwise distinct points.  A root together with six further points already
contains one, by the six-point bound behind the triangle Ramsey equality, so the
anchor hypothesis of the two sufficiency theorems above is never vacuous. -/
theorem exists_distinct_alignedAnchor [Fintype α] [DecidableEq α]
    (hpar : FourSetParity tau) (hcard : 7 ≤ Fintype.card α) :
    ∃ q₀ q₁ q₂ q₃ : α, DistinctQuadruple q₀ q₁ q₂ q₃ ∧ Aligned tau q₀ q₁ q₂ q₃ := by
  classical
  obtain ⟨S, -, hS⟩ :=
    Finset.exists_superset_card_eq (s := (∅ : Finset α)) (n := 7) (by simp) hcard
  obtain ⟨r, hr⟩ : ∃ r, r ∈ S := Finset.card_pos.mp (by omega) |>.imp fun _ h => h
  set T : Finset α := S.erase r with hTdef
  have hT : T.card = 6 := by rw [hTdef, Finset.card_erase_of_mem hr, hS]
  have hrT : r ∉ T := fun h => (Finset.mem_erase.mp h).1 rfl
  let eqv : Fin 6 ≃ {x // x ∈ T} := (Fintype.equivFinOfCardEq (by simpa using hT)).symm
  let v : Fin 6 → α := fun t => (eqv t : α)
  have hvT : ∀ t, v t ∈ T := fun t => (eqv t).2
  have hvinj : Function.Injective v := by
    intro a b hab
    exact eqv.injective (Subtype.ext hab)
  have hrne : ∀ t : Fin 6, r ≠ v t := fun t h => hrT (h ▸ hvT t)
  obtain ⟨i, j, k, hij, hjk, hanchor⟩ := exists_alignedAnchor tau hpar r v
  have hik : i < k := hij.trans hjk
  exact ⟨r, v i, v j, v k,
    ⟨hrne i, hrne j, hrne k, fun h => hij.ne (hvinj h), fun h => hik.ne (hvinj h),
      fun h => hjk.ne (hvinj h)⟩,
    hanchor⟩

/-- Sufficiency of the query family, stated through the family itself.  If the
two two-graphs agree on which members of `selectedQueryFamily` of the anchor are
aligned, then they differ by one global complement bit on every triple of
distinct points. -/
theorem exists_complementBit_of_selectedQueryFamily_eq [Fintype α] [DecidableEq α]
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    (hcard : 7 ≤ Fintype.card α)
    {q₀ q₁ q₂ q₃ : α} (hQ : DistinctQuadruple q₀ q₁ q₂ q₃)
    (hanchor : Aligned tau q₀ q₁ q₂ q₃)
    (hsel : ∀ a b c d : α, DistinctQuadruple a b c d →
      ({a, b, c, d} : Finset α) ∈ selectedQueryFamily ({q₀, q₁, q₂, q₃} : Finset α) →
      (Aligned tau a b c d ↔ Aligned sigma a b c d)) :
    ∃ epsilon : Bool, ∀ a b c : α, DistinctTriple a b c →
      sigma a b c = Bool.xor (tau a b c) epsilon := by
  refine exists_complementBit_of_selectedQuery_eq hsymT hparT hsymS hparS hcard hQ
    hanchor ?_
  intro a b c d hd hi
  exact hsel a b c d hd (mem_selectedQueryFamily.mpr ⟨card_quadruple hd, hi⟩)

end AlignedTwoGraph
end RelativeConicArcs
