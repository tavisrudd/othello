import Mathlib

/-!
# Pair sums and the Kneser eigenspace

The vertices of `K(n,2)` are the two-element subsets of `Fin n`; two vertices
are adjacent when the subsets are disjoint.  This module proves by finite-sum
double counting that the pair-sum construction
`y ↦ ({i,j} ↦ y i + y j)` sends sum-zero vertex weights to eigenvectors with
eigenvalue `-(n-3)`.

For five vertices, incidence sums give the converse.  Thus over a field of
characteristic different from three and five, the standard four-dimensional
vertex module is linearly equivalent to the full `-2` eigenspace of the
Petersen graph.  No adjacency table or finite certificate is used.
-/

namespace RelativeConicArcs.KneserPairEigenspace

/-- The finite set of two-element subsets of `Fin n`. -/
def pairFinset (n : ℕ) : Finset (Finset (Fin n)) :=
  Finset.univ.powersetCard 2

/-- A vertex of the Kneser graph `K(n,2)`, represented by its two-element
subset of `Fin n`. -/
abbrev Pair (n : ℕ) := ↥(pairFinset n)

namespace Pair

/-- The two vertices belonging to a pair. -/
def vertices {n : ℕ} (p : Pair n) : Finset (Fin n) := p.1

@[simp]
theorem card_vertices {n : ℕ} (p : Pair n) : p.vertices.card = 2 :=
  (Finset.mem_powersetCard.mp p.property).2

end Pair

section Counting

variable {n : ℕ}

/-- The pairs containing a fixed vertex. -/
def incidentPairs (i : Fin n) : Finset (Pair n) :=
  Finset.univ.filter fun p => i ∈ p.vertices

/-- The pairs containing both specified vertices. -/
def commonIncidentPairs (i j : Fin n) : Finset (Pair n) :=
  Finset.univ.filter fun p => i ∈ p.vertices ∧ j ∈ p.vertices

/-- The pairs disjoint from a fixed pair. -/
def disjointPairs (p : Pair n) : Finset (Pair n) :=
  Finset.univ.filter fun q => Disjoint p.vertices q.vertices

/-- Exactly `n-1` two-subsets contain a fixed vertex. -/
theorem card_incidentPairs (i : Fin n) :
    (incidentPairs i).card = n - 1 := by
  classical
  let target :=
    (pairFinset n).filter fun p : Finset (Fin n) => ({i} : Finset (Fin n)) ⊆ p
  have himage :
      (incidentPairs i).image (fun p => p.1) = target := by
    ext p
    simp [incidentPairs, target, Pair.vertices, and_comm]
  have hcard :
      (incidentPairs i).card = target.card := by
    rw [← himage, Finset.card_image_of_injective]
    exact fun _ _ h => Subtype.ext h
  rw [hcard]
  have hsubset : ({i} : Finset (Fin n)) ⊆ Finset.univ := Finset.subset_univ _
  rw [show target =
      (Finset.univ.powersetCard 2).filter (({i} : Finset (Fin n)) ⊆ ·) by
        rfl]
  rw [Finset.card_filter_powersetCard_subset _ _ _ hsubset (by simp)]
  simp

/-- Distinct vertices lie in one common pair; a repeated vertex lies in all
`n-1` pairs through that vertex. -/
theorem card_commonIncidentPairs (i j : Fin n) :
    (commonIncidentPairs i j).card = if i = j then n - 1 else 1 := by
  classical
  by_cases hij : i = j
  · rw [if_pos hij]
    subst j
    have heq : commonIncidentPairs i i = incidentPairs i := by
      ext p
      simp [commonIncidentPairs, incidentPairs]
    rw [heq, card_incidentPairs]
  · simp only [if_neg hij]
    let target :=
      (pairFinset n).filter fun p : Finset (Fin n) =>
        ({i, j} : Finset (Fin n)) ⊆ p
    have himage :
        (commonIncidentPairs i j).image (fun p => p.1) = target := by
      ext p
      simp [commonIncidentPairs, target, Pair.vertices,
        Finset.insert_subset_iff, Finset.singleton_subset_iff,
        and_assoc, and_comm]
    have hcard :
        (commonIncidentPairs i j).card = target.card := by
      rw [← himage, Finset.card_image_of_injective]
      exact fun _ _ h => Subtype.ext h
    rw [hcard]
    have hsubset : ({i, j} : Finset (Fin n)) ⊆ Finset.univ :=
      Finset.subset_univ _
    rw [show target =
        (Finset.univ.powersetCard 2).filter
          (({i, j} : Finset (Fin n)) ⊆ ·) by rfl]
    rw [Finset.card_filter_powersetCard_subset _ _ _ hsubset (by simp [hij])]
    simp [hij]

/-- A pair has `choose (n-2) 2` disjoint two-subsets. -/
theorem card_disjointPairs (p : Pair n) :
    (disjointPairs p).card = Nat.choose (n - 2) 2 := by
  classical
  let target := (Finset.univ \ p.vertices).powersetCard 2
  have himage : (disjointPairs p).image (fun q => q.1) = target := by
    ext q
    simp only [Finset.mem_image, Finset.mem_powersetCard, target, disjointPairs]
    constructor
    · rintro ⟨r, hr, rfl⟩
      refine ⟨?_, Pair.card_vertices r⟩
      intro i hi
      apply Finset.mem_sdiff.mpr
      refine ⟨Finset.mem_univ _, ?_⟩
      exact fun hip => (Finset.disjoint_left.mp (Finset.mem_filter.mp hr).2) hip hi
    · rintro ⟨hqsub, hqcard⟩
      have hqpair : q ∈ pairFinset n := by
        exact Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _, hqcard⟩
      let r : Pair n := ⟨q, hqpair⟩
      refine ⟨r, ?_, rfl⟩
      rw [Finset.mem_filter]
      refine ⟨Finset.mem_univ _, Finset.disjoint_left.mpr ?_⟩
      intro i hip hiq
      exact (Finset.mem_sdiff.mp (hqsub hiq)).2 hip
  have hcard :
      (disjointPairs p).card = target.card := by
    rw [← himage, Finset.card_image_of_injective]
    exact fun _ _ h => Subtype.ext h
  rw [hcard]
  dsimp [target]
  rw [Finset.card_powersetCard]
  rw [Finset.card_sdiff_of_subset (Finset.subset_univ p.vertices)]
  simp [Pair.card_vertices]

variable {K : Type*} [CommRing K]

/-- Summing a constant over the pairs incident with a vertex multiplies it by
`n-1`. -/
theorem sum_incidentPairs_const (i : Fin n) (a : K) :
    ∑ _p ∈ incidentPairs i, a = (n - 1 : ℕ) • a := by
  rw [Finset.sum_const, card_incidentPairs]

/-- Double-counting pair endpoints: summing pair sums over all pairs is
`n-1` times the total vertex sum. -/
theorem sum_pairSums (y : Fin n → K) :
    ∑ p : Pair n, ∑ i ∈ p.vertices, y i =
      (n - 1 : ℕ) • ∑ i, y i := by
  classical
  calc
    ∑ p : Pair n, ∑ i ∈ p.vertices, y i =
        ∑ p : Pair n, ∑ i : Fin n, if i ∈ p.vertices then y i else 0 := by
          apply Finset.sum_congr rfl
          intro p _
          simp
    _ = ∑ i : Fin n, ∑ p : Pair n, if i ∈ p.vertices then y i else 0 := by
          rw [Finset.sum_comm]
    _ = ∑ i : Fin n, ∑ p ∈ incidentPairs i, y i := by
          apply Finset.sum_congr rfl
          intro i _
          simp only [incidentPairs]
          rw [← Finset.sum_filter]
    _ = ∑ i : Fin n, (n - 1 : ℕ) • y i := by
          apply Finset.sum_congr rfl
          intro i _
          exact sum_incidentPairs_const i (y i)
    _ = (n - 1 : ℕ) • ∑ i, y i := by
          rw [Finset.smul_sum]

end Counting

section Operators

variable {n : ℕ} {K : Type*} [CommRing K]

/-- The sum of vertex weights on a two-subset. -/
def pairSum (y : Fin n → K) (p : Pair n) : K :=
  ∑ i ∈ p.vertices, y i

/-- The disjointness adjacency operator of the Kneser graph `K(n,2)`. -/
def adjacency (x : Pair n → K) (p : Pair n) : K :=
  ∑ q : Pair n, if Disjoint p.vertices q.vertices then x q else 0

/-- The sum of edge weights on pairs incident with a vertex. -/
def incidenceSum (x : Pair n → K) (i : Fin n) : K :=
  ∑ p ∈ incidentPairs i, x p

/-- The sum of all pair weights. -/
def totalPairSum (x : Pair n → K) : K :=
  ∑ p, x p

/-- Two distinct two-subsets either are disjoint or meet in exactly one
vertex. -/
theorem card_inter_vertices (p q : Pair n) :
    (p.vertices ∩ q.vertices).card =
      if Disjoint p.vertices q.vertices then 0 else if p = q then 2 else 1 := by
  classical
  by_cases hd : Disjoint p.vertices q.vertices
  · rw [if_pos hd]
    exact Finset.card_eq_zero.mpr (Finset.disjoint_iff_inter_eq_empty.mp hd)
  · rw [if_neg hd]
    by_cases hpq : p = q
    · subst q
      simp [Pair.card_vertices]
    · rw [if_neg hpq]
      have hpos : 0 < (p.vertices ∩ q.vertices).card := by
        rw [Finset.card_pos]
        apply Finset.nonempty_of_ne_empty
        intro hempty
        exact hd (Finset.disjoint_iff_inter_eq_empty.mpr hempty)
      have hle : (p.vertices ∩ q.vertices).card ≤ 2 := by
        simpa [Pair.card_vertices] using
          Finset.card_le_card (Finset.inter_subset_left : p.vertices ∩ q.vertices ⊆ p.vertices)
      have hne : (p.vertices ∩ q.vertices).card ≠ 2 := by
        intro hcard
        have hep : p.vertices ∩ q.vertices = p.vertices :=
          Finset.eq_of_subset_of_card_le Finset.inter_subset_left (by
            rw [hcard, Pair.card_vertices])
        have heq : p.vertices ∩ q.vertices = q.vertices :=
          Finset.eq_of_subset_of_card_le Finset.inter_subset_right (by
            rw [hcard, Pair.card_vertices])
        apply hpq
        apply Subtype.ext
        exact hep.symm.trans heq
      omega

/-- Summing incidence totals over the two endpoints of a pair counts an edge
weight once for each common endpoint. -/
theorem sum_incidenceSum_over_pair (x : Pair n → K) (p : Pair n) :
    ∑ i ∈ p.vertices, incidenceSum x i =
      ∑ q : Pair n, (p.vertices ∩ q.vertices).card • x q := by
  classical
  calc
    ∑ i ∈ p.vertices, incidenceSum x i =
        ∑ i ∈ p.vertices,
          ∑ q : Pair n, if i ∈ q.vertices then x q else 0 := by
      apply Finset.sum_congr rfl
      intro i _
      simp only [incidenceSum, incidentPairs]
      rw [← Finset.sum_filter]
    _ = ∑ q : Pair n,
          ∑ i ∈ p.vertices, if i ∈ q.vertices then x q else 0 := by
      rw [Finset.sum_comm]
    _ = ∑ q : Pair n, (p.vertices ∩ q.vertices).card • x q := by
      apply Finset.sum_congr rfl
      intro q _
      rw [← Finset.sum_filter]
      simp [Finset.filter_mem_eq_inter]

/-- A pair belongs to exactly the two incidence stars indexed by its
vertices. -/
theorem sum_incidenceSum (x : Pair n → K) :
    ∑ i, incidenceSum x i = 2 • totalPairSum x := by
  classical
  calc
    ∑ i, incidenceSum x i =
        ∑ i : Fin n, ∑ p : Pair n, if i ∈ p.vertices then x p else 0 := by
          apply Finset.sum_congr rfl
          intro i _
          simp only [incidenceSum, incidentPairs]
          rw [← Finset.sum_filter]
    _ = ∑ p : Pair n, ∑ i : Fin n, if i ∈ p.vertices then x p else 0 := by
          rw [Finset.sum_comm]
    _ = ∑ p : Pair n, 2 • x p := by
          apply Finset.sum_congr rfl
          intro p _
          rw [← Pair.card_vertices p]
          simp
    _ = 2 • totalPairSum x := by
          change (∑ p : Pair n, 2 • x p) = 2 • ∑ p : Pair n, x p
          exact Finset.smul_sum.symm

/-- Summing adjacency over all pairs counts every pair weight once for each
disjoint pair. -/
theorem sum_adjacency (x : Pair n → K) :
    ∑ p, adjacency x p =
      Nat.choose (n - 2) 2 • totalPairSum x := by
  classical
  calc
    ∑ p, adjacency x p =
        ∑ p : Pair n, ∑ q : Pair n,
          if Disjoint p.vertices q.vertices then x q else 0 := by
      rfl
    _ = ∑ q : Pair n, ∑ p : Pair n,
          if Disjoint p.vertices q.vertices then x q else 0 := by
      rw [Finset.sum_comm]
    _ = ∑ q : Pair n, ∑ p ∈ disjointPairs q, x q := by
      apply Finset.sum_congr rfl
      intro q _
      simp only [disjointPairs]
      rw [← Finset.sum_filter]
      congr 1
      ext p
      simp [disjoint_comm]
    _ = ∑ q : Pair n, Nat.choose (n - 2) 2 • x q := by
      apply Finset.sum_congr rfl
      intro q _
      rw [Finset.sum_const, card_disjointPairs]
    _ = Nat.choose (n - 2) 2 • totalPairSum x := by
      change (∑ q : Pair n, Nat.choose (n - 2) 2 • x q) =
        Nat.choose (n - 2) 2 • ∑ q : Pair n, x q
      exact Finset.smul_sum.symm

/-- The total of pair sums incident with a vertex. -/
theorem incidenceSum_pairSum (hn : 2 ≤ n) (y : Fin n → K) (i : Fin n) :
    incidenceSum (pairSum y) i =
      (n - 2 : ℕ) • y i + ∑ j, y j := by
  classical
  calc
    incidenceSum (pairSum y) i =
        ∑ p ∈ incidentPairs i,
          ∑ j : Fin n, if j ∈ p.vertices then y j else 0 := by
      simp only [incidenceSum, pairSum]
      apply Finset.sum_congr rfl
      intro p _
      simp
    _ = ∑ j : Fin n,
          ∑ p ∈ incidentPairs i, if j ∈ p.vertices then y j else 0 := by
      rw [Finset.sum_comm]
    _ = ∑ j : Fin n, ∑ p ∈ commonIncidentPairs i j, y j := by
      apply Finset.sum_congr rfl
      intro j _
      simp only [commonIncidentPairs, incidentPairs]
      rw [← Finset.sum_filter]
      congr 1
      ext p
      simp
    _ = ∑ j : Fin n,
          (if i = j then n - 1 else 1 : ℕ) • y j := by
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.sum_const, card_commonIncidentPairs]
    _ = (n - 1 : ℕ) • y i + ∑ j ∈ Finset.univ.erase i, y j := by
      calc
        ∑ j : Fin n, (if i = j then n - 1 else 1 : ℕ) • y j =
            (if i = i then n - 1 else 1 : ℕ) • y i +
              ∑ j ∈ Finset.univ.erase i,
                (if i = j then n - 1 else 1 : ℕ) • y j :=
          (Finset.sum_erase_add Finset.univ
            (fun j => (if i = j then n - 1 else 1 : ℕ) • y j)
            (Finset.mem_univ i)).symm.trans (add_comm _ _)
        _ = (n - 1 : ℕ) • y i + ∑ j ∈ Finset.univ.erase i, y j := by
          rw [if_pos rfl]
          congr 1
          apply Finset.sum_congr rfl
          intro j hj
          have hne : i ≠ j := by
            intro h
            exact (Finset.mem_erase.mp hj).1 h.symm
          simp [hne]
    _ = (n - 2 : ℕ) • y i + ∑ j, y j := by
      have hn : n - 1 = (n - 2) + 1 := by omega
      rw [hn, add_smul]
      have htotal :
          (∑ j : Fin n, y j) = (∑ j ∈ Finset.univ.erase i, y j) + y i :=
        (Finset.sum_erase_add Finset.univ y (Finset.mem_univ i)).symm
      rw [htotal]
      simp

/-- Inclusion-exclusion expresses disjointness adjacency through the total
pair sum and the two endpoint-incidence sums. -/
theorem adjacency_eq_total_sub_incidence (x : Pair n → K) (p : Pair n) :
    adjacency x p =
      totalPairSum x - ∑ i ∈ p.vertices, incidenceSum x i + x p := by
  classical
  rw [sum_incidenceSum_over_pair]
  have hx :
      x p = ∑ q : Pair n, if q = p then x q else 0 := by simp
  rw [hx]
  simp only [adjacency, totalPairSum]
  rw [← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro q _
  rw [card_inter_vertices]
  by_cases hd : Disjoint p.vertices q.vertices
  · have hqp : q ≠ p := by
      intro h
      subst q
      have hempty := (Finset.disjoint_self_iff_empty p.vertices).mp hd
      have := Pair.card_vertices p
      simp [hempty] at this
    simp [hd, hqp]
  · by_cases hpq : p = q
    · subst q
      have hne : p.vertices ≠ ∅ := by
        intro hempty
        have := Pair.card_vertices p
        simp [hempty] at this
      simp [hne]
      ring
    · simp [hd, hpq, Ne.symm hpq]

/-- Pair sums of sum-zero vertex weights form the
`-(n-3)`-eigenspace supplied by the standard vertex representation. -/
theorem adjacency_pairSum_of_sum_eq_zero (hn : 3 ≤ n) (y : Fin n → K)
    (hy : ∑ i, y i = 0) (p : Pair n) :
    adjacency (pairSum y) p = -((n - 3 : ℕ) • pairSum y p) := by
  rw [adjacency_eq_total_sub_incidence]
  rw [show totalPairSum (pairSum y) = 0 by
    simpa [totalPairSum, pairSum, hy] using sum_pairSums y]
  simp_rw [incidenceSum_pairSum (by omega : 2 ≤ n), hy, add_zero]
  simp only [zero_sub]
  rw [← Finset.smul_sum]
  change -((n - 2 : ℕ) • pairSum y p) + pairSum y p =
    -((n - 3 : ℕ) • pairSum y p)
  rw [show n - 2 = (n - 3) + 1 by omega]
  simp [add_smul]

/-- On the sum-zero vertex space, the pair-sum map is injective whenever
`n-2` is a unit. -/
theorem pairSum_eq_zero_of_sum_eq_zero (hn : 2 ≤ n)
    (hunit : IsUnit (((n - 2 : ℕ) : K))) (y : Fin n → K)
    (hy : ∑ i, y i = 0) (hpair : ∀ p, pairSum y p = 0) :
    y = 0 := by
  funext i
  have hi := incidenceSum_pairSum hn y i
  have hinc : incidenceSum (pairSum y) i = 0 := by
    simp [incidenceSum, hpair]
  rw [hinc, hy, add_zero] at hi
  have hzN : (n - 2 : ℕ) • y i = 0 := by
    simpa using hi.symm
  have hz : ((n - 2 : ℕ) : K) * y i = 0 := by
    change ((n - 2 : ℕ) : K) • y i = 0
    rw [Nat.cast_smul_eq_nsmul]
    exact hzN
  apply hunit.mul_left_cancel
  simpa using hz

/-- Two sum-zero vertex weights with the same pair sums are equal when
`n-2` is a unit. -/
theorem pairSum_injective_on_sumZero (hn : 2 ≤ n)
    (hunit : IsUnit (((n - 2 : ℕ) : K))) {y z : Fin n → K}
    (hy : ∑ i, y i = 0) (hz : ∑ i, z i = 0)
    (hpair : pairSum y = pairSum z) :
    y = z := by
  let d : Fin n → K := fun i => y i - z i
  have hdSum : ∑ i, d i = 0 := by
    simp only [d, Finset.sum_sub_distrib, hy, hz, sub_zero]
  have hdPair : ∀ p, pairSum d p = 0 := by
    intro p
    have hp := congrFun hpair p
    simp only [pairSum, d, Finset.sum_sub_distrib]
    exact sub_eq_zero.mpr hp
  have hd := pairSum_eq_zero_of_sum_eq_zero hn hunit d hdSum hdPair
  funext i
  have := congrFun hd i
  exact sub_eq_zero.mp (by simpa [d] using this)

/-- The disjointness adjacency operator preserves addition of pair
weightings. -/
theorem adjacency_add (x z : Pair n → K) :
    adjacency (x + z) = adjacency x + adjacency z := by
  funext p
  simp only [adjacency, Pi.add_apply]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro q _
  by_cases h : Disjoint p.vertices q.vertices <;> simp [h]

/-- The disjointness adjacency operator preserves scalar multiplication of
pair weightings. -/
theorem adjacency_smul (a : K) (x : Pair n → K) :
    adjacency (a • x) = a • adjacency x := by
  funext p
  simp only [adjacency, Pi.smul_apply]
  rw [Finset.smul_sum]
  apply Finset.sum_congr rfl
  intro q _
  by_cases h : Disjoint p.vertices q.vertices <;> simp [h]

end Operators

section Petersen

variable {K : Type*} [Field K]

/-- A pair weighting is a `-2` eigenvector for the Petersen adjacency
operator. -/
def IsPetersenNegTwoEigenvector (x : Pair 5 → K) : Prop :=
  ∀ p, adjacency x p = -(2 : K) * x p

/-- The total pair weight of a Petersen `-2` eigenvector vanishes when five
is nonzero. -/
theorem totalPairSum_eq_zero_of_petersenEigen
    (h5 : (5 : K) ≠ 0) {x : Pair 5 → K}
    (hx : IsPetersenNegTwoEigenvector x) :
    totalPairSum x = 0 := by
  have hsum :
      (3 : K) * totalPairSum x = -(2 : K) * totalPairSum x := by
    calc
      (3 : K) * totalPairSum x = ∑ p, adjacency x p := by
        simpa [nsmul_eq_mul] using (sum_adjacency x).symm
      _ = ∑ p, (-(2 : K) * x p) := by
        apply Finset.sum_congr rfl
        intro p _
        exact hx p
      _ = -(2 : K) * totalPairSum x := by
        simp [totalPairSum, Finset.mul_sum]
  have hzero : (5 : K) * totalPairSum x = 0 := by
    linear_combination hsum
  exact (mul_eq_zero.mp hzero).resolve_left h5

/-- Over a field where three and five are nonzero, every Petersen `-2`
eigenvector is the pair sum of a unique sum-zero vertex weighting. -/
theorem existsUnique_pairSum_of_petersenEigen
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0)
    (x : Pair 5 → K) (hx : IsPetersenNegTwoEigenvector x) :
    ∃! y : Fin 5 → K, (∑ i, y i = 0) ∧ pairSum y = x := by
  let y : Fin 5 → K := fun i => (3 : K)⁻¹ * incidenceSum x i
  have htotal : totalPairSum x = 0 :=
    totalPairSum_eq_zero_of_petersenEigen h5 hx
  have hySum : ∑ i, y i = 0 := by
    simp only [y, ← Finset.mul_sum]
    rw [sum_incidenceSum, htotal]
    simp
  have hyPair : pairSum y = x := by
    funext p
    have hp := adjacency_eq_total_sub_incidence x p
    rw [hx p, htotal, zero_sub] at hp
    have hinc :
        ∑ i ∈ p.vertices, incidenceSum x i = 3 * x p := by
      linear_combination hp
    simp only [pairSum, y, ← Finset.mul_sum, hinc]
    field_simp [h3]
  refine ⟨y, ⟨hySum, hyPair⟩, ?_⟩
  intro z hz
  rcases hz with ⟨hzSum, hzPair⟩
  exact pairSum_injective_on_sumZero (n := 5) (K := K) (by omega)
    (by norm_num; exact h3) hzSum hySum
    (hzPair.trans hyPair.symm)

/-- The standard vertex submodule on five vertices consists of the
sum-zero weightings. -/
def standardSubmodule : Submodule K (Fin 5 → K) where
  carrier := {y | ∑ i, y i = 0}
  zero_mem' := by simp
  add_mem' := by
    intro y z hy hz
    change ∑ i, (y i + z i) = 0
    rw [Finset.sum_add_distrib, hy, hz, add_zero]
  smul_mem' := by
    intro a y hy
    change ∑ i, a * y i = 0
    rw [← Finset.mul_sum, hy, mul_zero]

/-- Summation of the five vertex coordinates as a linear map. -/
def vertexTotalLinear : (Fin 5 → K) →ₗ[K] K where
  toFun y := ∑ i, y i
  map_add' := by
    intro y z
    exact Finset.sum_add_distrib
  map_smul' := by
    intro a y
    exact (Finset.mul_sum Finset.univ y a).symm

/-- The standard submodule is the kernel of coordinate summation. -/
theorem standardSubmodule_eq_ker :
    standardSubmodule (K := K) = LinearMap.ker (vertexTotalLinear (K := K)) :=
  rfl

/-- The sum-zero vertex module on five vertices has dimension four. -/
theorem finrank_standardSubmodule :
    Module.finrank K (standardSubmodule (K := K)) = 4 := by
  rw [standardSubmodule_eq_ker]
  have hsurj : Function.Surjective (vertexTotalLinear (K := K)) := by
    intro a
    let y : Fin 5 → K := fun i => if i = 0 then a else 0
    refine ⟨y, ?_⟩
    simp [vertexTotalLinear, y]
  have hrange :
      LinearMap.range (vertexTotalLinear (K := K)) = ⊤ :=
    LinearMap.range_eq_top.mpr hsurj
  have hdim :=
    LinearMap.finrank_range_add_finrank_ker (vertexTotalLinear (K := K))
  rw [hrange] at hdim
  norm_num at hdim ⊢
  omega

/-- The full `-2` eigenspace of the Petersen adjacency operator. -/
def petersenNegTwoEigenspace : Submodule K (Pair 5 → K) where
  carrier := {x | IsPetersenNegTwoEigenvector x}
  zero_mem' := by
    intro p
    simp [adjacency]
  add_mem' := by
    intro x z hx hz p
    rw [congrFun (adjacency_add x z) p, Pi.add_apply, hx p, hz p]
    simp only [Pi.add_apply]
    ring
  smul_mem' := by
    intro a x hx p
    rw [congrFun (adjacency_smul a x) p, Pi.smul_apply, hx p]
    simp only [smul_eq_mul, Pi.smul_apply]
    ring

/-- The unique sum-zero vertex weighting whose pair sums give a Petersen
`-2` eigenvector. -/
noncomputable def petersenVertexWeight
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0)
    (x : petersenNegTwoEigenspace (K := K)) : Fin 5 → K :=
  Classical.choose
    (existsUnique_pairSum_of_petersenEigen h3 h5 x.1 x.2)

/-- The reconstructed Petersen vertex weighting has coordinate sum zero. -/
theorem petersenVertexWeight_sum
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0)
    (x : petersenNegTwoEigenspace (K := K)) :
    ∑ i, petersenVertexWeight h3 h5 x i = 0 :=
  (Classical.choose_spec
    (existsUnique_pairSum_of_petersenEigen h3 h5 x.1 x.2)).1.1

/-- Pair sums of the reconstructed vertex weighting recover the original
Petersen eigenvector. -/
theorem pairSum_petersenVertexWeight
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0)
    (x : petersenNegTwoEigenspace (K := K)) :
    pairSum (petersenVertexWeight h3 h5 x) = x.1 :=
  (Classical.choose_spec
    (existsUnique_pairSum_of_petersenEigen h3 h5 x.1 x.2)).1.2

/-- Pair sums give a linear equivalence from the standard four-dimensional
vertex module to the full Petersen `-2` eigenspace. -/
noncomputable def standardEquivPetersenNegTwo
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0) :
    standardSubmodule (K := K) ≃ₗ[K] petersenNegTwoEigenspace (K := K) where
  toFun y := ⟨pairSum y.1, by
    intro p
    simpa [IsPetersenNegTwoEigenvector, nsmul_eq_mul] using
      adjacency_pairSum_of_sum_eq_zero (K := K) (n := 5) (by omega)
        y.1 y.2 p⟩
  invFun x := ⟨petersenVertexWeight h3 h5 x,
    petersenVertexWeight_sum h3 h5 x⟩
  left_inv y := by
    apply Subtype.ext
    exact pairSum_injective_on_sumZero (n := 5) (K := K) (by omega)
      (by norm_num; exact h3)
      (petersenVertexWeight_sum h3 h5
        ⟨pairSum y.1, by
          intro p
          simpa [IsPetersenNegTwoEigenvector, nsmul_eq_mul] using
            adjacency_pairSum_of_sum_eq_zero (K := K) (n := 5) (by omega)
              y.1 y.2 p⟩)
      y.2
      (pairSum_petersenVertexWeight h3 h5
        ⟨pairSum y.1, by
          intro p
          simpa [IsPetersenNegTwoEigenvector, nsmul_eq_mul] using
            adjacency_pairSum_of_sum_eq_zero (K := K) (n := 5) (by omega)
              y.1 y.2 p⟩)
  right_inv x := by
    apply Subtype.ext
    exact pairSum_petersenVertexWeight h3 h5 x
  map_add' y z := by
    apply Subtype.ext
    funext p
    simp [pairSum, Finset.sum_add_distrib]
  map_smul' a y := by
    apply Subtype.ext
    funext p
    simp [pairSum, Finset.mul_sum]

/-- The full Petersen `-2` eigenspace has dimension four in characteristics
different from three and five. -/
theorem finrank_petersenNegTwoEigenspace
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0) :
    Module.finrank K (petersenNegTwoEigenspace (K := K)) = 4 := by
  rw [← finrank_standardSubmodule (K := K)]
  exact LinearEquiv.finrank_eq (standardEquivPetersenNegTwo h3 h5).symm

end Petersen

end RelativeConicArcs.KneserPairEigenspace
