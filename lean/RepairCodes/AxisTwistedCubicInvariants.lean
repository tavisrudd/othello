import RepairCodes.AxisTwistedCubic

/-!
# Extremal invariants of twisted-cubic–axis repair hypergraphs

This module starts from the exact code-derived repair classification in
`RepairCodes.AxisTwistedCubic` and proves the matching/transversal formulas.  It does not replace
the repair hypergraph by a selected family.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- A three-cubic repair through an axis target forces that target to be the unique completion. -/
theorem axisRepair_threeCubic_target_eq [CharP 𝔽 3]
    {y : 𝔽 ⊕ Unit} {s t u : 𝔽}
    (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u)
    (hR : ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∈
        axisTwistedCubicRepairHypergraph (.inr y) 3) :
    y = twistedCubicTripleAxisIndex ![s, t, u] := by
  have hretarget := repairHypergraph_retarget hR
    (show (Sum.inl s : AxisTwistedCubicIndex 𝔽) ∈
      {(Sum.inl s : AxisTwistedCubicIndex 𝔽), Sum.inl t, Sum.inl u} by simp)
  have hR' : {(.inl t : AxisTwistedCubicIndex 𝔽), .inl u, .inr y} ∈
      axisTwistedCubicRepairHypergraph (.inl s) 3 := by
    change {(.inl t : AxisTwistedCubicIndex 𝔽), .inl u, .inr y} ∈
      repairHypergraph axisTwistedCubicCode (.inl s) 3
    convert hretarget using 1
    ext z
    simp only [Finset.mem_insert, Finset.mem_erase, Finset.mem_singleton]
    aesop
  exact cubicRepair_axis_eq_of_mem hst hsu htu hR'

/-- Three distinct cubic helpers repair exactly their completing axis coordinate. -/
theorem mem_axisRepairHypergraph_threeCubic_iff [CharP 𝔽 3]
    {y : 𝔽 ⊕ Unit} {s t u : 𝔽}
    (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∈
        axisTwistedCubicRepairHypergraph (.inr y) 3 ↔
      y = twistedCubicTripleAxisIndex ![s, t, u] := by
  constructor
  · exact axisRepair_threeCubic_target_eq hst hsu htu
  · intro hy
    subst y
    let v : Fin 3 → 𝔽 := ![s, t, u]
    have hv : Function.Injective v := by
      intro i j hij
      fin_cases i <;> fin_cases j <;> simp_all [v]
    have hbase := cubicTripleRepairHelpers_mem hv
    have hretarget := repairHypergraph_retarget hbase
      (show (.inr (twistedCubicTripleAxisIndex ![s, t, u]) :
          AxisTwistedCubicIndex 𝔽) ∈ cubicTripleRepairHelpers v by
        simp [cubicTripleRepairHelpers, v])
    have herase : (cubicTripleRepairHelpers v).erase
        (.inr (twistedCubicTripleAxisIndex ![s, t, u])) =
        {(.inl t : AxisTwistedCubicIndex 𝔽), .inl u} := by
      ext z
      simp only [cubicTripleRepairHelpers, v, Fin.isValue, Matrix.cons_val_zero,
        Matrix.cons_val_one, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton]
      aesop
    rw [herase] at hretarget
    change {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u} ∈
      repairHypergraph axisTwistedCubicCode
        (.inr (twistedCubicTripleAxisIndex ![s, t, u])) 3
    simpa [v] using hretarget

/-- A support with two cubic helpers and one additional axis helper cannot repair an axis target:
retargeting it to a cubic coordinate would contradict the cubic support classification. -/
theorem axisRepair_twoCubic_oneAxis_not_mem [CharP 𝔽 3]
    {y z : 𝔽 ⊕ Unit} {s t : 𝔽} (hst : s ≠ t) (hyz : y ≠ z) :
    ({(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inr z} :
      Finset (AxisTwistedCubicIndex 𝔽)) ∉
        axisTwistedCubicRepairHypergraph (.inr y) 3 := by
  intro hR
  have hretarget := repairHypergraph_retarget hR
    (show (Sum.inl s : AxisTwistedCubicIndex 𝔽) ∈
      {(Sum.inl s : AxisTwistedCubicIndex 𝔽), Sum.inl t, Sum.inr z} by simp)
  have hR' : {(.inl t : AxisTwistedCubicIndex 𝔽), .inr y, .inr z} ∈
      axisTwistedCubicRepairHypergraph (.inl s) 3 := by
    change {(.inl t : AxisTwistedCubicIndex 𝔽), .inr y, .inr z} ∈
      repairHypergraph axisTwistedCubicCode (.inl s) 3
    convert hretarget using 1
    ext a
    simp only [Finset.mem_insert, Finset.mem_erase, Finset.mem_singleton]
    aesop
  exact cubicRepair_oneCubic_twoAxis_not_mem hst hyz hR'

/-- Every radius-three axis repair either contains a canonical axis-pair repair or is exactly a
three-cubic completion repair. -/
theorem axisRepair_contains_canonical [CharP 𝔽 3] {y : 𝔽 ⊕ Unit}
    {R : Finset (AxisTwistedCubicIndex 𝔽)}
    (hR : R ∈ axisTwistedCubicRepairHypergraph (.inr y) 3) :
    (∃ z w : 𝔽 ⊕ Unit, y ≠ z ∧ y ≠ w ∧ z ≠ w ∧
      ({(.inr z : AxisTwistedCubicIndex 𝔽), .inr w} :
        Finset (AxisTwistedCubicIndex 𝔽)) ⊆ R) ∨
    (∃ s t u : 𝔽, s ≠ t ∧ s ≠ u ∧ t ≠ u ∧
      y = twistedCubicTripleAxisIndex ![s, t, u] ∧
      R = {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u}) := by
  have hcardle : R.card ≤ 3 := (mem_repairHypergraph.mp hR).2.1
  have hcardge : 2 ≤ R.card := by
    by_contra h
    have hle : R.card ≤ 1 := by omega
    exact axisCoordinate_no_repairEdge_radius_one y R
      (mem_repairHypergraph_of_mem_of_card_le hR hle)
  have hcard : R.card = 2 ∨ R.card = 3 := by omega
  rcases hcard with h2 | h3
  · have hR2 := mem_repairHypergraph_of_mem_of_card_le hR h2.le
    obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := axisRepairPair_shape hR2
    exact Or.inl ⟨z, w, hyz, hyw, hzw, Finset.Subset.rfl⟩
  · obtain ⟨a, b, c, hab, hac, hbc, hReq⟩ := Finset.card_eq_three.mp h3
    have hsub := (mem_repairHypergraph.mp hR).1
    have hyR : (.inr y : AxisTwistedCubicIndex 𝔽) ∉ R := by
      intro hy
      exact (Finset.mem_erase.mp (hsub hy)).1 rfl
    subst R
    cases a with
    | inl s =>
      cases b with
      | inl t =>
        cases c with
        | inl u =>
          have hst : s ≠ t := by simpa using hab
          have hsu : s ≠ u := by simpa using hac
          have htu : t ≠ u := by simpa using hbc
          have hy := axisRepair_threeCubic_target_eq hst hsu htu hR
          exact Or.inr ⟨s, t, u, hst, hsu, htu, hy, rfl⟩
        | inr z =>
          have hst : s ≠ t := by simpa using hab
          have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
          exact (axisRepair_twoCubic_oneAxis_not_mem hst hyz hR).elim
      | inr z =>
        cases c with
        | inl t =>
          have hst : s ≠ t := by simpa using hac
          have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
          have hR' : {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inr z} ∈
              axisTwistedCubicRepairHypergraph (.inr y) 3 := by
            convert hR using 1
            ext q
            simp only [Finset.mem_insert, Finset.mem_singleton]
            tauto
          exact (axisRepair_twoCubic_oneAxis_not_mem hst hyz hR').elim
        | inr w =>
          have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
          have hyw : y ≠ w := by simpa using fun h => hyR (by simp [h])
          have hzw : z ≠ w := by simpa using hbc
          exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩
    | inr z =>
      cases b with
      | inl s =>
        cases c with
        | inl t =>
          have hst : s ≠ t := by simpa using hbc
          have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
          have hR' : {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inr z} ∈
              axisTwistedCubicRepairHypergraph (.inr y) 3 := by
            convert hR using 1
            ext q
            simp only [Finset.mem_insert, Finset.mem_singleton]
            tauto
          exact (axisRepair_twoCubic_oneAxis_not_mem hst hyz hR').elim
        | inr w =>
          have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
          have hyw : y ≠ w := by simpa using fun h => hyR (by simp [h])
          have hzw : z ≠ w := by simpa using hac
          exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩
      | inr w =>
        have hyz : y ≠ z := by simpa using fun h => hyR (by simp [h])
        have hyw : y ≠ w := by simpa using fun h => hyR (by simp [h])
        have hzw : z ≠ w := by simpa using hab
        exact Or.inl ⟨z, w, hyz, hyw, hzw, by simp⟩

/-- **Exact paper-facing axis clutter.** Its minimal edges are precisely pairs of other axis
coordinates and three-cubic completion triples. -/
theorem mem_minimalAxisRepairHypergraph_iff [CharP 𝔽 3] {y : 𝔽 ⊕ Unit}
    {R : Finset (AxisTwistedCubicIndex 𝔽)} :
    R ∈ minimalAxisTwistedCubicRepairHypergraph (.inr y) 3 ↔
      (∃ z w : 𝔽 ⊕ Unit, y ≠ z ∧ y ≠ w ∧ z ≠ w ∧
        R = {(.inr z : AxisTwistedCubicIndex 𝔽), .inr w}) ∨
      (∃ s t u : 𝔽, s ≠ t ∧ s ≠ u ∧ t ≠ u ∧
        y = twistedCubicTripleAxisIndex ![s, t, u] ∧
        R = {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u}) := by
  rw [minimalAxisTwistedCubicRepairHypergraph, minimalRepairHypergraph,
    mem_minimalHyperedges]
  constructor
  · rintro ⟨hR, hminimal⟩
    rcases axisRepair_contains_canonical hR with hpair | hcubic
    · obtain ⟨z, w, hyz, hyw, hzw, hsub⟩ := hpair
      let B : Finset (AxisTwistedCubicIndex 𝔽) := {.inr z, .inr w}
      have hB2 : B ∈ axisTwistedCubicRepairHypergraph (.inr y) 2 :=
        mem_axisRepairHypergraph_two_iff.mpr ⟨z, w, hyz, hyw, hzw, rfl⟩
      have hB3 : B ∈ axisTwistedCubicRepairHypergraph (.inr y) 3 :=
        repairHypergraph_mono_radius (by omega) hB2
      have hRB := hminimal B hB3 hsub
      exact Or.inl ⟨z, w, hyz, hyw, hzw, Finset.Subset.antisymm hRB hsub⟩
    · exact Or.inr hcubic
  · intro hshape
    refine ⟨?_, ?_⟩
    · rcases hshape with hpair | hcubic
      · obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := hpair
        exact repairHypergraph_mono_radius (by omega)
          (mem_axisRepairHypergraph_two_iff.mpr ⟨z, w, hyz, hyw, hzw, rfl⟩)
      · obtain ⟨s, t, u, hst, hsu, htu, hy, rfl⟩ := hcubic
        exact (mem_axisRepairHypergraph_threeCubic_iff hst hsu htu).mpr hy
    · intro B hB hBR
      rcases hshape with hpair | hcubic
      · obtain ⟨z, w, -, -, hzw, rfl⟩ := hpair
        have hBge : 2 ≤ B.card := by
          by_contra h
          have hle : B.card ≤ 1 := by omega
          exact axisCoordinate_no_repairEdge_radius_one y B
            (mem_repairHypergraph_of_mem_of_card_le hB hle)
        have hRcard : ({(.inr z : AxisTwistedCubicIndex 𝔽), .inr w} :
            Finset (AxisTwistedCubicIndex 𝔽)).card = 2 := by simp [hzw]
        have hBle := Finset.card_le_card hBR
        have hEq : B = {(.inr z : AxisTwistedCubicIndex 𝔽), .inr w} := by
          apply Finset.eq_of_subset_of_card_le hBR
          omega
        simp [hEq]
      · obtain ⟨s, t, u, hst, hsu, htu, -, rfl⟩ := hcubic
        have hBge : 2 ≤ B.card := by
          by_contra h
          have hle : B.card ≤ 1 := by omega
          exact axisCoordinate_no_repairEdge_radius_one y B
            (mem_repairHypergraph_of_mem_of_card_le hB hle)
        by_cases hB2 : B.card ≤ 2
        · have hcard2 : B.card = 2 := by omega
          have hBtwo := mem_repairHypergraph_of_mem_of_card_le hB hB2
          obtain ⟨z, w, -, -, -, hBeq⟩ := axisRepairPair_shape hBtwo
          have hzB : (.inr z : AxisTwistedCubicIndex 𝔽) ∈ B := by simp [hBeq]
          have hzR := hBR hzB
          simp at hzR
        · have hBcardle : B.card ≤ 3 :=
            (Finset.card_le_card hBR).trans_eq (by simp [hst, hsu, htu])
          have hBcard : B.card = 3 := by omega
          have hEq : B = {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u} := by
            apply Finset.eq_of_subset_of_card_le hBR
            simp [hst, hsu, htu, hBcard]
          simp [hEq]

private def axisPart (E : Finset (AxisTwistedCubicIndex 𝔽)) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  E.filter fun z => z.isRight

/-- A matching in the minimal axis repair clutter satisfies `6|M|≤5q`: pair edges consume two
axis vertices and cubic edges consume three cubic vertices, on disjoint grounds of sizes `q` and
`q`. -/
theorem minimalAxisRepair_matching_weight_bound [CharP 𝔽 3] (y : 𝔽 ⊕ Unit)
    {M : Finset (Finset (AxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) M) :
    6 * M.card ≤ 5 * Fintype.card 𝔽 := by
  classical
  have hweight (E) (hE : E ∈ M) :
      3 * (axisPart E).card + 2 * (cubicPart E).card = 6 := by
    rcases mem_minimalAxisRepairHypergraph_iff.mp (hM.1 hE) with hpair | hcubic
    · obtain ⟨z, w, -, -, hzw, rfl⟩ := hpair
      simp [axisPart, cubicPart, hzw]
    · obtain ⟨s, t, u, hst, hsu, htu, -, rfl⟩ := hcubic
      simp [axisPart, cubicPart, hst, hsu, htu]
  have haxisPairwise :
      (M : Set (Finset (AxisTwistedCubicIndex 𝔽))).PairwiseDisjoint axisPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hcubicPairwise :
      (M : Set (Finset (AxisTwistedCubicIndex 𝔽))).PairwiseDisjoint cubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have haxisSub : M.biUnion axisPart ⊆
      (univ.erase y).map Function.Embedding.inr := by
    intro a ha
    obtain ⟨E, hEM, haE⟩ := Finset.mem_biUnion.mp ha
    rcases mem_minimalAxisRepairHypergraph_iff.mp (hM.1 hEM) with hpair | hcubic
    · obtain ⟨z, w, hyz, hyw, -, rfl⟩ := hpair
      have ha' := (Finset.mem_filter.mp haE).1
      cases a with
      | inl s => simp [axisPart] at haE
      | inr v =>
        simp only [Finset.mem_insert, Finset.mem_singleton, Sum.inr.injEq] at ha'
        rcases ha' with rfl | rfl
        · simp [hyz]
        · simp [hyw]
    · obtain ⟨s, t, u, -, -, -, -, rfl⟩ := hcubic
      simp [axisPart] at haE
  have hcubicSub : M.biUnion cubicPart ⊆ univ.map Function.Embedding.inl := by
    intro a ha
    obtain ⟨E, hEM, haE⟩ := Finset.mem_biUnion.mp ha
    have haleft := (Finset.mem_filter.mp haE).2
    cases a with
    | inl s => simp
    | inr v => simp at haleft
  have haxisCard : (∑ E ∈ M, (axisPart E).card) ≤ Fintype.card 𝔽 := by
    rw [← Finset.card_biUnion haxisPairwise]
    have := Finset.card_le_card haxisSub
    simpa using this
  have hcubicCard : (∑ E ∈ M, (cubicPart E).card) ≤ Fintype.card 𝔽 := by
    rw [← Finset.card_biUnion hcubicPairwise]
    have := Finset.card_le_card hcubicSub
    simpa using this
  have htotal : 6 * M.card =
      3 * (∑ E ∈ M, (axisPart E).card) +
        2 * (∑ E ∈ M, (cubicPart E).card) := by
    calc
      6 * M.card = ∑ E ∈ M, 6 := by simp
      _ = ∑ E ∈ M, (3 * (axisPart E).card + 2 * (cubicPart E).card) := by
        apply Finset.sum_congr rfl
        intro E hE
        exact (hweight E hE).symm
      _ = 3 * (∑ E ∈ M, (axisPart E).card) +
          2 * (∑ E ∈ M, (cubicPart E).card) := by
        simp only [Finset.mul_sum, Finset.sum_add_distrib]
  rw [htotal]
  omega

/-- The minimal axis repair clutter has matching number at most `⌊5q/6⌋`. -/
theorem minimalAxisRepair_matchingNumber_le [CharP 𝔽 3] (y : 𝔽 ⊕ Unit) :
    matchingNumber (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) ≤
      (5 * Fintype.card 𝔽) / 6 := by
  apply matchingNumber_le_of_forall
  intro M hM
  have h := minimalAxisRepair_matching_weight_bound y hM
  omega

/-- Every transversal of the minimal axis repair clutter contains at least `q-1` vertices,
already forced by the complete graph of pair repairs on the `q` other axis coordinates. -/
theorem minimalAxisRepair_transversal_card_ge [CharP 𝔽 3] (y : 𝔽 ⊕ Unit)
    {T : Finset (AxisTwistedCubicIndex 𝔽)}
    (hT : IsTransversal (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) T) :
    Fintype.card 𝔽 - 1 ≤ T.card := by
  classical
  let ground : Finset (𝔽 ⊕ Unit) := univ.erase y
  let covered : Finset (𝔽 ⊕ Unit) := ground.filter fun z => Sum.inr z ∈ T
  let uncovered : Finset (𝔽 ⊕ Unit) := ground \ covered
  have hUcard : uncovered.card ≤ 1 := by
    by_contra h
    have hlt : 1 < uncovered.card := by omega
    obtain ⟨z, hz, w, hw, hzw⟩ := Finset.one_lt_card.mp hlt
    have hyz : y ≠ z := Ne.symm (Finset.mem_erase.mp (Finset.mem_sdiff.mp hz).1).1
    have hyw : y ≠ w := Ne.symm (Finset.mem_erase.mp (Finset.mem_sdiff.mp hw).1).1
    have hzT : Sum.inr z ∉ T := by
      intro hzT
      have : z ∈ covered := by
        simp [covered, (Finset.mem_sdiff.mp hz).1, hzT]
      exact (Finset.mem_sdiff.mp hz).2 this
    have hwT : Sum.inr w ∉ T := by
      intro hwT
      have : w ∈ covered := by
        simp [covered, (Finset.mem_sdiff.mp hw).1, hwT]
      exact (Finset.mem_sdiff.mp hw).2 this
    have hedge : {(.inr z : AxisTwistedCubicIndex 𝔽), .inr w} ∈
        minimalAxisTwistedCubicRepairHypergraph (.inr y) 3 := by
      apply mem_minimalAxisRepairHypergraph_iff.mpr
      exact Or.inl ⟨z, w, hyz, hyw, hzw, rfl⟩
    obtain ⟨v, hv⟩ := hT hedge
    simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton] at hv
    rcases hv.2 with hvz | hvw
    · exact hzT (hvz ▸ hv.1)
    · exact hwT (hvw ▸ hv.1)
  have hcoveredSub : covered.map Function.Embedding.inr ⊆ T := by
    intro a ha
    obtain ⟨z, hz, rfl⟩ := Finset.mem_map.mp ha
    exact (Finset.mem_filter.mp hz).2
  have hcardGround : ground.card = Fintype.card 𝔽 := by simp [ground]
  have hcardSplit : covered.card + uncovered.card = ground.card := by
    rw [show uncovered = ground \ covered by rfl, Finset.card_sdiff]
    have hcsub : covered ⊆ ground := Finset.filter_subset _ _
    rw [Finset.inter_eq_left.mpr hcsub]
    have hle := Finset.card_le_card hcsub
    omega
  have hcovered : Fintype.card 𝔽 - 1 ≤ covered.card := by omega
  exact hcovered.trans (by simpa using Finset.card_le_card hcoveredSub)

/-- Hence the minimal axis repair clutter has `τ≥q-1`. -/
theorem minimalAxisRepair_le_transversalNumber [CharP 𝔽 3] (y : 𝔽 ⊕ Unit) :
    Fintype.card 𝔽 - 1 ≤
      transversalNumber (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) := by
  apply le_transversalNumber_of_forall
  · refine ⟨univ, ?_⟩
    intro E hE
    rw [Finset.univ_inter]
    exact axisTwistedCubicRepair_edge_nonempty (mem_minimalHyperedges.mp hE).1
  · exact fun _ hT => minimalAxisRepair_transversal_card_ge y hT

/-- Every axis coordinate has strict `τ>ν` for `q≥9`, without using a cap-set estimate. -/
theorem minimalAxisRepair_tau_gt_nu [CharP 𝔽 3] (hq : 9 ≤ Fintype.card 𝔽)
    (y : 𝔽 ⊕ Unit) :
    matchingNumber (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) <
      transversalNumber (minimalAxisTwistedCubicRepairHypergraph (.inr y) 3) := by
  have hν := minimalAxisRepair_matchingNumber_le y
  have hτ := minimalAxisRepair_le_transversalNumber y
  omega

/-- The same strict gap holds for the complete all-support repair hypergraph, by the proved
minimal-clutter invariance. -/
theorem axisRepair_tau_gt_nu [CharP 𝔽 3] (hq : 9 ≤ Fintype.card 𝔽)
    (y : 𝔽 ⊕ Unit) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inr y) 3) <
      transversalNumber (axisTwistedCubicRepairHypergraph (.inr y) 3) := by
  rw [← matchingNumber_minimalAxisTwistedCubicRepairHypergraph,
    ← transversalNumber_minimalAxisTwistedCubicRepairHypergraph]
  exact minimalAxisRepair_tau_gt_nu hq y

/-- **Uniform all-symbol repair gap.** Every coordinate of `S_q`, for `q=3^h≥9`, has strictly
larger transversal number than matching number in its complete radius-three repair hypergraph. -/
theorem axisTwistedCubic_allSymbol_tau_gt_nu [CharP 𝔽 3]
    (hq : 9 ≤ Fintype.card 𝔽) (x : AxisTwistedCubicIndex 𝔽) :
    matchingNumber (axisTwistedCubicRepairHypergraph x 3) <
      transversalNumber (axisTwistedCubicRepairHypergraph x 3) := by
  cases x with
  | inl x => exact cubicRepair_tau_gt_nu hq x
  | inr y => exact axisRepair_tau_gt_nu hq y

private def cubicPart (E : Finset (AxisTwistedCubicIndex 𝔽)) :
    Finset (AxisTwistedCubicIndex 𝔽) :=
  E.filter fun z => z.isLeft

/-- Every matching of cubic-coordinate repairs consumes two distinct cubic helpers per edge. -/
theorem cubicRepair_matching_card_bound [CharP 𝔽 3] (x : 𝔽)
    {M : Finset (Finset (AxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching (axisTwistedCubicRepairHypergraph (.inl x) 3) M) :
    2 * M.card ≤ Fintype.card 𝔽 - 1 := by
  classical
  have hpart (E) (hE : E ∈ M) : (cubicPart E).card = 2 := by
    obtain ⟨s, t, -, -, hst, rfl⟩ := mem_cubicRepairHypergraph_iff.mp (hM.1 hE)
    rw [show cubicPart
        {(.inl s : AxisTwistedCubicIndex 𝔽), .inl t,
          .inr (twistedCubicTripleAxisIndex ![x, s, t])} = {Sum.inl s, Sum.inl t} by
      ext z
      cases z <;> simp [cubicPart]]
    simp [hst]
  have hpairwise : (M : Set (Finset (AxisTwistedCubicIndex 𝔽))).PairwiseDisjoint cubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsub : M.biUnion cubicPart ⊆
      (univ.erase x).map Function.Embedding.inl := by
    intro z hz
    obtain ⟨E, hEM, hzE⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨s, t, hxs, hxt, -, rfl⟩ := mem_cubicRepairHypergraph_iff.mp (hM.1 hEM)
    have hzleft := (Finset.mem_filter.mp hzE).2
    cases z with
    | inr y => simp at hzleft
    | inl u =>
      have hzu := (Finset.mem_filter.mp hzE).1
      simp only [Finset.mem_insert, Finset.mem_singleton, Sum.inl.injEq,
        Sum.inl_ne_inr, or_false] at hzu
      rcases hzu with rfl | rfl
      · simp [hxs.symm]
      · simp [hxt.symm]
  calc
    2 * M.card = ∑ E ∈ M, 2 := by simp [Nat.mul_comm]
    _ = ∑ E ∈ M, (cubicPart E).card := by
      apply Finset.sum_congr rfl
      intro E hE
      exact (hpart E hE).symm
    _ = (M.biUnion cubicPart).card := (Finset.card_biUnion hpairwise).symm
    _ ≤ ((univ.erase x).map Function.Embedding.inl).card := Finset.card_le_card hsub
    _ = Fintype.card 𝔽 - 1 := by simp

/-- Cubic-coordinate disjoint availability is at most `(q-1)/2`. -/
theorem cubicRepair_matchingNumber_le [CharP 𝔽 3] (x : 𝔽) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) ≤
      (Fintype.card 𝔽 - 1) / 2 := by
  apply matchingNumber_le_of_forall
  intro M hM
  have h := cubicRepair_matching_card_bound x hM
  omega

/-- All cubic helpers except one form a transversal. -/
theorem cubicRepair_transversal_of_erase [CharP 𝔽 3] (x a₀ : 𝔽) :
    IsTransversal (axisTwistedCubicRepairHypergraph (.inl x) 3)
      (((univ.erase x).erase a₀).map Function.Embedding.inl) := by
  intro E hE
  obtain ⟨s, t, hxs, hxt, hst, rfl⟩ := mem_cubicRepairHypergraph_iff.mp hE
  by_cases hs : s = a₀
  · subst s
    exact ⟨Sum.inl t, by simp [hxt, hst.symm]⟩
  · exact ⟨Sum.inl s, by simp [hxs.symm, hs]⟩

/-- Every cubic-coordinate repair transversal has at least `q-2` vertices. -/
theorem cubicRepair_transversal_card_ge [CharP 𝔽 3] (x : 𝔽)
    {T : Finset (AxisTwistedCubicIndex 𝔽)}
    (hT : IsTransversal (axisTwistedCubicRepairHypergraph (.inl x) 3) T) :
    Fintype.card 𝔽 - 2 ≤ T.card := by
  classical
  let ground : Finset 𝔽 := univ.erase x
  let covered : Finset 𝔽 := ground.filter fun s => Sum.inl s ∈ T
  let uncovered : Finset 𝔽 := ground \ covered
  by_cases hU : uncovered = ∅
  · have hsub : ground.map Function.Embedding.inl ⊆ T := by
      intro z hz
      obtain ⟨s, hs, rfl⟩ := Finset.mem_map.mp hz
      have hsC : s ∈ covered := by
        by_contra hsC
        have : s ∈ uncovered := by simp [uncovered, hs, hsC]
        simp [hU] at this
      exact (Finset.mem_filter.mp hsC).2
    have hcard : Fintype.card 𝔽 - 1 ≤ T.card := by
      have := Finset.card_le_card hsub
      simpa [ground] using this
    omega
  · obtain ⟨a₀, ha₀⟩ := Finset.nonempty_iff_ne_empty.mpr hU
    have hxa₀ : x ≠ a₀ := by
      exact Ne.symm (Finset.mem_erase.mp (Finset.mem_sdiff.mp ha₀).1).1
    let color : 𝔽 → 𝔽 ⊕ Unit := fun b => twistedCubicTripleAxisIndex ![x, a₀, b]
    let colors : Finset (𝔽 ⊕ Unit) := (uncovered.erase a₀).image color
    have hcolorSub : colors.map Function.Embedding.inr ⊆ T := by
      intro z hz
      obtain ⟨c, hc, rfl⟩ := Finset.mem_map.mp hz
      obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp hc
      have hba : b ≠ a₀ := (Finset.mem_erase.mp hb).1
      have hbU : b ∈ uncovered := (Finset.mem_erase.mp hb).2
      have haGround := (Finset.mem_sdiff.mp ha₀).1
      have hbGround := (Finset.mem_sdiff.mp hbU).1
      have hxb : x ≠ b := Ne.symm (Finset.mem_erase.mp hbGround).1
      have haT : Sum.inl a₀ ∉ T := by
        intro haT
        have : a₀ ∈ covered := by simp [covered, haGround, haT]
        exact (Finset.mem_sdiff.mp ha₀).2 this
      have hbT : Sum.inl b ∉ T := by
        intro hbT
        have : b ∈ covered := by simp [covered, hbGround, hbT]
        exact (Finset.mem_sdiff.mp hbU).2 this
      have hedge : {(.inl a₀ : AxisTwistedCubicIndex 𝔽), .inl b,
          .inr (color b)} ∈ axisTwistedCubicRepairHypergraph (.inl x) 3 := by
        apply mem_cubicRepairHypergraph_iff.mpr
        exact ⟨a₀, b, hxa₀, hxb, hba.symm, rfl⟩
      obtain ⟨v, hv⟩ := hT hedge
      simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton] at hv
      rcases hv.2 with hv0 | hvb | hvc
      · exact (haT (hv0 ▸ hv.1)).elim
      · exact (hbT (hvb ▸ hv.1)).elim
      · simpa [hvc] using hv.1
    have hcoveredSub : covered.map Function.Embedding.inl ⊆ T := by
      intro z hz
      obtain ⟨s, hs, rfl⟩ := Finset.mem_map.mp hz
      exact (Finset.mem_filter.mp hs).2
    have hcolorsCard : colors.card = uncovered.card - 1 := by
      rw [Finset.card_image_iff.mpr]
      · rw [Finset.card_erase_of_mem ha₀]
      · intro b hb c hc hEq
        exact twistedCubicTripleAxisIndex_injective_third hxa₀ hEq
    have hdisj : Disjoint (covered.map Function.Embedding.inl)
        (colors.map Function.Embedding.inr) := by
      simp [Finset.disjoint_left]
    have hunionSub : covered.map Function.Embedding.inl ∪
        colors.map Function.Embedding.inr ⊆ T := Finset.union_subset hcoveredSub hcolorSub
    have hcardCU : covered.card + uncovered.card = Fintype.card 𝔽 - 1 := by
      rw [show uncovered = ground \ covered by rfl, Finset.card_sdiff]
      have hcsub : covered ⊆ ground := Finset.filter_subset _ _
      rw [Finset.inter_eq_left.mpr hcsub]
      have hcovle := Finset.card_le_card hcsub
      simp [ground] at hcovle ⊢
      omega
    have hle := Finset.card_le_card hunionSub
    rw [Finset.card_union_of_disjoint hdisj, Finset.card_map, Finset.card_map,
      hcolorsCard] at hle
    omega

/-- Cubic-coordinate transversal number is exactly `q-2`. -/
theorem cubicRepair_transversalNumber [CharP 𝔽 3] (x : 𝔽) :
    transversalNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) =
      Fintype.card 𝔽 - 2 := by
  apply le_antisymm
  · have hT := cubicRepair_transversal_of_erase x (x + 1)
    have hle := transversalNumber_le_card hT
    have hq2 : 2 ≤ Fintype.card 𝔽 := by
      let f : Fin 2 → 𝔽 := ![x, x + 1]
      apply Fintype.card_le_of_injective f
      intro i j hij
      fin_cases i <;> fin_cases j <;> simp_all [f]
    simp at hle
    omega
  · apply le_transversalNumber_of_forall
    · exact ⟨_, cubicRepair_transversal_of_erase x (x + 1)⟩
    · exact fun _ hT => cubicRepair_transversal_card_ge x hT

/-- Cubic coordinates already have the strict repair gap for every finite characteristic-three
field of order at least nine. -/
theorem cubicRepair_tau_gt_nu [CharP 𝔽 3] (hq : 9 ≤ Fintype.card 𝔽) (x : 𝔽) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) <
      transversalNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) := by
  rw [cubicRepair_transversalNumber]
  have hν := cubicRepair_matchingNumber_le x
  omega

#print axioms cubicRepair_matchingNumber_le
#print axioms cubicRepair_transversalNumber
#print axioms cubicRepair_tau_gt_nu
#print axioms mem_axisRepairHypergraph_threeCubic_iff
#print axioms mem_minimalAxisRepairHypergraph_iff

end RepairCodes
