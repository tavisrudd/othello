import RelativeConicArcs.PassantCodeQ13.LogicalSpine
import RelativeConicArcs.PassantCodeQ13.PencilJoins

/-!
# Pencil profiles of weight-ten words in the q=13 passant code

Fix a supported internal point of a binary codeword of weight ten.  The seven passant lines
through it partition the support points joined to it by a passant.  Each resulting fibre has odd
cardinality, because the corresponding parity-check row also contains the fixed point.  The other
support points are called secant neighbors; in the normalized conic model this agrees with the
usual secant/passant dichotomy for two distinct internal points.

The terminal theorem transports an arbitrary weight-ten codeword, without choosing projective
coordinates or a preferred support point, to exactly one of the two pencil profiles used by the
finite certificates: one fibre of size three and six singleton fibres with no secant neighbor, or
seven singleton fibres with two secant neighbors.  Its finite geometric inputs are the seven
passant lines through an internal point, uniqueness of the joining passant line, and the
identification of the complementary joins with conic secants.  All three are supplied by
`RelativeConicArcs.PassantCodeQ13.PencilJoins` and are checked by kernel reduction on the fixed
78-point normalized model.
-/

namespace RelativeConicArcs.PassantCodeQ13.WeightTen

open Finset

/-- The passant pencil through an internal point. -/
def passantPencil (base : InternalPoint) : Finset PassantLine :=
  Finset.univ.filter fun line => Incident line base

/-- Every internal point lies on exactly seven passant lines. -/
theorem passantPencil_card (base : InternalPoint) : (passantPencil base).card = 7 :=
  card_passantLines_through base

/-- Two distinct internal points lie on at most one common passant line. -/
theorem joining_passantLine_unique (base point : InternalPoint) (distinct : point ≠ base)
    (first second : PassantLine)
    (first_base : Incident first base) (first_point : Incident first point)
    (second_base : Incident second base) (second_point : Incident second point) :
    first = second :=
  passantLine_join_unique distinct first_base first_point second_base second_point

/-- Two internal points have secant join when a normalized conic-secant contains both. -/
def SecantJoin (first second : InternalPoint) : Prop :=
  ∃ line : WeightEight.SecantLine,
    WeightEight.lineValue line.1 first.1 = 0 ∧ WeightEight.lineValue line.1 second.1 = 0

instance (first second : InternalPoint) : Decidable (SecantJoin first second) := by
  unfold SecantJoin
  infer_instance

/-- Distinct internal points have secant join exactly when they do not have passant join. -/
theorem not_passantJoin_iff_secantJoin (base point : InternalPoint) (distinct : point ≠ base) :
    ¬WeightEight.PassantJoin base point ↔ SecantJoin base point :=
  no_common_passantLine_iff_common_secantLine distinct

/-- A semantic passant neighbor of a fixed internal point. -/
abbrev PassantNeighbor (base : InternalPoint) :=
  {point : InternalPoint // point ≠ base ∧ WeightEight.PassantJoin base point}

/-- The unique passant line joining a fixed point to one of its passant neighbors. -/
noncomputable def joiningPassantLine (base : InternalPoint) (point : PassantNeighbor base) :
    {line : PassantLine // line ∈ passantPencil base} := by
  let line := Classical.choose point.2.2
  have line_data := Classical.choose_spec point.2.2
  exact ⟨line, Finset.mem_filter.mpr ⟨Finset.mem_univ line, line_data.1⟩⟩

/-- The chosen joining line contains its passant neighbor. -/
theorem joiningPassantLine_incident (base : InternalPoint) (point : PassantNeighbor base) :
    Incident (joiningPassantLine base point).1 point.1 := by
  exact (Classical.choose_spec point.2.2).2

/-- Joining-line equality is equivalent to incidence with a line in the base pencil. -/
theorem joiningPassantLine_eq_iff_incident (base : InternalPoint) (point : PassantNeighbor base)
    (line : {line : PassantLine // line ∈ passantPencil base}) :
    joiningPassantLine base point = line ↔ Incident line.1 point.1 := by
  constructor
  · intro equal
    rw [← equal]
    exact joiningPassantLine_incident base point
  · intro incident
    apply Subtype.ext
    apply joining_passantLine_unique base point.1 point.2.1
    · exact (Finset.mem_filter.mp (joiningPassantLine base point).2).2
    · exact joiningPassantLine_incident base point
    · exact (Finset.mem_filter.mp line.2).2
    · exact incident

/-- Passant neighbors of `base` that belong to a specified support. -/
def supportedPassantNeighbors (support : Finset InternalPoint) (base : InternalPoint) :
    Finset (PassantNeighbor base) :=
  Finset.univ.filter fun point => point.1 ∈ support

/-- The size of the support fibre on a line of the passant pencil. -/
noncomputable def fibreSize (support : Finset InternalPoint) (base : InternalPoint)
    (line : {line : PassantLine // line ∈ passantPencil base}) : ℕ :=
  ((supportedPassantNeighbors support base).filter fun point =>
    joiningPassantLine base point = line).card

/-- The number of other support points not joined to the base point by a passant. -/
def secantNeighborCount (support : Finset InternalPoint) (base : InternalPoint) : ℕ :=
  ((support.erase base).filter fun point => ¬WeightEight.PassantJoin base point).card

private theorem zmodTwo_eq_zero_or_one (value : ZMod 2) : value = 0 ∨ value = 1 := by
  revert value
  decide

private theorem word_eq_one_of_mem_support (word : InternalPoint → ZMod 2)
    {point : InternalPoint} (point_mem : point ∈ CodingBridge.hammingSupport word) :
    word point = 1 := by
  exact (zmodTwo_eq_zero_or_one (word point)).resolve_left
    (CodingBridge.mem_hammingSupport.mp point_mem)

private theorem fibreSize_eq_incident_card
    (support : Finset InternalPoint) (base : InternalPoint)
    (line : {line : PassantLine // line ∈ passantPencil base}) :
    fibreSize support base line =
      ((support.erase base).filter fun point => Incident line.1 point).card := by
  classical
  let source := (supportedPassantNeighbors support base).filter fun point =>
    joiningPassantLine base point = line
  let target := (support.erase base).filter fun point => Incident line.1 point
  let forward : {point // point ∈ source} → {point // point ∈ target} := fun point => by
    have source_data : point.1 ∈ supportedPassantNeighbors support base ∧
        joiningPassantLine base point.1 = line := Finset.mem_filter.mp point.2
    have supported_data : point.1.1 ∈ support :=
      (Finset.mem_filter.mp source_data.1).2
    have line_incident := (joiningPassantLine_eq_iff_incident base point.1 line).mp source_data.2
    exact ⟨point.1.1, Finset.mem_filter.mpr ⟨Finset.mem_erase.mpr
      ⟨point.1.2.1, supported_data⟩, line_incident⟩⟩
  have forward_injective : Function.Injective forward := by
    intro first second equal
    apply Subtype.ext
    apply Subtype.ext
    simpa [forward] using congrArg Subtype.val equal
  have forward_surjective : Function.Surjective forward := by
    intro point
    have target_data := Finset.mem_filter.mp point.2
    have erased_data := Finset.mem_erase.mp target_data.1
    have join : WeightEight.PassantJoin base point.1 :=
      ⟨line.1, (Finset.mem_filter.mp line.2).2, target_data.2⟩
    let neighbor : PassantNeighbor base := ⟨point.1, erased_data.1, join⟩
    have neighbor_supported : neighbor ∈ supportedPassantNeighbors support base := by
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ neighbor, erased_data.2⟩
    have neighbor_line : joiningPassantLine base neighbor = line :=
      (joiningPassantLine_eq_iff_incident base neighbor line).mpr target_data.2
    let sourcePoint : {point // point ∈ source} :=
      ⟨neighbor, Finset.mem_filter.mpr ⟨neighbor_supported, neighbor_line⟩⟩
    refine ⟨sourcePoint, ?_⟩
    apply Subtype.ext
    rfl
  change source.card = target.card
  simpa only [Fintype.card_coe] using Fintype.card_congr (Equiv.ofBijective forward
    ⟨forward_injective, forward_surjective⟩)

set_option maxRecDepth 4096 in
private theorem fibreSize_odd
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (base : InternalPoint) (base_mem : base ∈ CodingBridge.hammingSupport word)
    (line : {line : PassantLine // line ∈ passantPencil base}) :
    Odd (fibreSize (CodingBridge.hammingSupport word) base line) := by
  classical
  let support := CodingBridge.hammingSupport word
  let incidentSupport := support.filter fun point => Incident line.1 point
  have row_zero := (mem_passantCode_iff_row_sums word).mp word_mem line.1
  have row_as_card :
      (∑ point : InternalPoint,
        word point * ConicPassantCode.incidenceBit Incident line.1 point) =
        (incidentSupport.card : ZMod 2) := by
    have word_indicator : ∀ point, word point = if point ∈ support then 1 else 0 := by
      intro point
      by_cases point_mem : point ∈ support
      · simp [point_mem, word_eq_one_of_mem_support word point_mem]
      · have point_zero : word point = 0 := by
          apply not_ne_iff.mp
          simpa [support, CodingBridge.mem_hammingSupport] using point_mem
        simp [point_mem, point_zero]
    let term : InternalPoint → ZMod 2 := fun point =>
      word point * ConicPassantCode.incidenceBit Incident line.1 point
    have restrict_to_incidentSupport :
        (∑ point ∈ incidentSupport, term point) = ∑ point : InternalPoint, term point := by
      apply Finset.sum_subset (Finset.subset_univ incidentSupport)
      intro point _ point_not_mem
      by_cases point_mem : point ∈ support
      · have not_incident : ¬Incident line.1 point := by
          intro incident
          exact point_not_mem (Finset.mem_filter.mpr ⟨point_mem, incident⟩)
        simp [term, word_indicator, ConicPassantCode.incidenceBit, not_incident]
      · simp [term, word_indicator, point_mem]
    rw [← restrict_to_incidentSupport]
    rw [show (incidentSupport.card : ZMod 2) =
        ∑ point ∈ incidentSupport, (1 : ZMod 2) by simp]
    apply Finset.sum_congr rfl
    intro point point_mem
    have point_data := Finset.mem_filter.mp point_mem
    simp [term, ConicPassantCode.incidenceBit, point_data.2,
      word_eq_one_of_mem_support word point_data.1]
  have incidentSupport_even : Even incidentSupport.card := by
    rw [row_as_card] at row_zero
    exact ZMod.natCast_eq_zero_iff_even.mp row_zero
  have base_incident : Incident line.1 base := (Finset.mem_filter.mp line.2).2
  have base_in_incidentSupport : base ∈ incidentSupport := by
    exact Finset.mem_filter.mpr ⟨base_mem, base_incident⟩
  have erase_eq : incidentSupport.erase base =
      (support.erase base).filter fun point => Incident line.1 point := by
    ext point
    simp [incidentSupport, and_assoc]
  have fibre_card : fibreSize support base line = incidentSupport.card - 1 := by
    rw [fibreSize_eq_incident_card, ← erase_eq, Finset.card_erase_of_mem base_in_incidentSupport]
  rw [fibre_card]
  obtain ⟨half, half_eq⟩ := incidentSupport_even
  refine ⟨half - 1, ?_⟩
  have incident_positive : 0 < incidentSupport.card := Finset.card_pos.mpr ⟨base, base_in_incidentSupport⟩
  omega

private theorem total_partition
    (support : Finset InternalPoint) (base : InternalPoint) (base_mem : base ∈ support) :
    (∑ line : {line : PassantLine // line ∈ passantPencil base},
      fibreSize support base line) + secantNeighborCount support base = support.card - 1 := by
  classical
  let neighbors := support.erase base
  let passantNeighbors := neighbors.filter fun point => WeightEight.PassantJoin base point
  have supported_card : (supportedPassantNeighbors support base).card = passantNeighbors.card := by
    let forward : {point // point ∈ supportedPassantNeighbors support base} →
        {point // point ∈ passantNeighbors} := fun point => by
      have supported_data : point.1.1 ∈ support := (Finset.mem_filter.mp point.2).2
      exact ⟨point.1.1, Finset.mem_filter.mpr ⟨Finset.mem_erase.mpr
        ⟨point.1.2.1, supported_data⟩, point.1.2.2⟩⟩
    have bijective : Function.Bijective forward := by
      constructor
      · intro first second equal
        apply Subtype.ext
        apply Subtype.ext
        simpa [forward] using congrArg Subtype.val equal
      · intro point
        have point_data := Finset.mem_filter.mp point.2
        have erased_data := Finset.mem_erase.mp point_data.1
        let neighbor : PassantNeighbor base := ⟨point.1, erased_data.1, point_data.2⟩
        refine ⟨⟨neighbor, Finset.mem_filter.mpr ⟨Finset.mem_univ neighbor, erased_data.2⟩⟩, ?_⟩
        rfl
    simpa only [Fintype.card_coe] using Fintype.card_congr (Equiv.ofBijective forward bijective)
  have fibre_sum :
      ∑ line : {line : PassantLine // line ∈ passantPencil base},
          fibreSize support base line = (supportedPassantNeighbors support base).card := by
    rw [show ∑ line : {line : PassantLine // line ∈ passantPencil base},
        fibreSize support base line =
        ∑ line ∈ (Finset.univ : Finset {line : PassantLine // line ∈ passantPencil base}),
          #{point ∈ supportedPassantNeighbors support base |
            joiningPassantLine base point = line} by simp [fibreSize]]
    exact (Finset.card_eq_sum_card_fiberwise fun _ _ => Finset.mem_univ _).symm
  have neighbor_partition : passantNeighbors.card + secantNeighborCount support base = neighbors.card := by
    change (neighbors.filter fun point => WeightEight.PassantJoin base point).card +
      (neighbors.filter fun point => ¬WeightEight.PassantJoin base point).card = neighbors.card
    exact Finset.card_filter_add_card_filter_not _
  rw [fibre_sum, supported_card, neighbor_partition, Finset.card_erase_of_mem base_mem]

/-- The two exhaustive pencil profiles for a ten-point support at one of its points. -/
def WeightTenPencilProfile (support : Finset InternalPoint) (base : InternalPoint) : Prop :=
    (secantNeighborCount support base = 0 ∧
      ∃ exceptional : {line : PassantLine // line ∈ passantPencil base},
        fibreSize support base exceptional = 3 ∧
        ∀ line, line ≠ exceptional →
          fibreSize support base line = 1) ∨
    (secantNeighborCount support base = 2 ∧
      ∀ line : {line : PassantLine // line ∈ passantPencil base},
        fibreSize support base line = 1)

/-- Every supported point of an arbitrary weight-ten word has one of the two exhaustive pencil
profiles: `(3,1,1,1,1,1,1;0)` or `(1,1,1,1,1,1,1;2)`. -/
theorem arbitrary_weightTen_word_has_pencil_profile
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (weight : CodingBridge.hammingWeight word = 10)
    (base : InternalPoint) (base_mem : base ∈ CodingBridge.hammingSupport word) :
    WeightTenPencilProfile (CodingBridge.hammingSupport word) base := by
  classical
  let support := CodingBridge.hammingSupport word
  let pencil := {line : PassantLine // line ∈ passantPencil base}
  have pencil_card : Fintype.card pencil = 7 := by
    dsimp [pencil]
    simpa only [Fintype.card_coe] using passantPencil_card base
  let index : Fin 7 ≃ pencil :=
    (finCongr pencil_card.symm).trans (Fintype.equivFin pencil).symm
  let indexedSize : Fin 7 → ℕ := fun position => fibreSize support base (index position)
  have indexed_odd : ∀ position, Odd (indexedSize position) := fun position =>
    fibreSize_odd word word_mem base base_mem (index position)
  have indexed_positive : ∀ position, 0 < indexedSize position := fun position =>
    (indexed_odd position).pos
  have partition := total_partition support base base_mem
  have support_card : support.card = 10 := weight
  have support_card_minus_one : support.card - 1 = 9 := by omega
  rw [support_card_minus_one] at partition
  have indexed_sum : (∑ position, indexedSize position) =
      9 - secantNeighborCount support base := by
    have reindex : (∑ position, indexedSize position) =
        ∑ line : pencil, fibreSize support base line := by
      exact Equiv.sum_comp index (fun line => fibreSize support base line)
    rw [reindex]
    have partition_nine :
        (∑ line : pencil, fibreSize support base line) +
          secantNeighborCount support base = 9 := by
      exact partition
    exact Nat.eq_sub_of_add_eq partition_nine
  have seven_nonempty : 7 ≤ 9 - secantNeighborCount support base := by
    rw [← indexed_sum]
    calc
      7 = ∑ _position : Fin 7, 1 := by simp
      _ ≤ ∑ position, indexedSize position :=
        Finset.sum_le_sum fun position _ => indexed_positive position
  have secant_even : Even (secantNeighborCount support base) := by
    have sum_odd : Odd (∑ position, indexedSize position) := by
      have h01 := (indexed_odd 0).add_odd (indexed_odd 1)
      have h012 := h01.add_odd (indexed_odd 2)
      have h0123 := h012.add_odd (indexed_odd 3)
      have h01234 := h0123.add_odd (indexed_odd 4)
      have h012345 := h01234.add_odd (indexed_odd 5)
      have h0123456 := h012345.add_odd (indexed_odd 6)
      simpa [Fin.sum_univ_succ, add_assoc] using h0123456
    have partition_nine :
        (∑ position, indexedSize position) + secantNeighborCount support base = 9 := by
      rw [indexed_sum]
      have secant_le : secantNeighborCount support base ≤ 9 := by
        have := seven_nonempty
        omega
      omega
    obtain ⟨half, sum_eq⟩ := sum_odd
    refine ⟨4 - half, ?_⟩
    omega
  rcases LogicalSpine.weightTen_secant_count_is_zero_or_two
      (secantNeighborCount support base) secant_even seven_nonempty with isolated | cycle
  · left
    refine ⟨isolated, ?_⟩
    have total_nine : ∑ position, indexedSize position = 9 := by omega
    obtain ⟨exceptional, exceptional_three, other_one⟩ :=
      LogicalSpine.seven_positive_odd_fibres_sum_nine indexedSize indexed_positive indexed_odd
        total_nine
    refine ⟨index exceptional, exceptional_three, ?_⟩
    intro line line_ne
    obtain ⟨position, rfl⟩ := index.surjective line
    exact other_one position fun equal => line_ne (congrArg index equal)
  · right
    refine ⟨cycle, ?_⟩
    have total_seven : ∑ position, indexedSize position = 7 := by omega
    have all_one := LogicalSpine.seven_positive_fibres_sum_seven indexedSize indexed_positive
      total_seven
    intro line
    obtain ⟨position, rfl⟩ := index.surjective line
    exact all_one position

end RelativeConicArcs.PassantCodeQ13.WeightTen
