import PassantCodeQ13.MinimumWords.ConcurrenceBase

/-!
# The indexed local-extension certificate for passant-row uniqueness

An *admissible seven-set* of internal points is a set of seven points that are pairwise joined by a
passant and meet every minimum-word support in at most two points.  Every passant row is admissible,
and the certificate of this module is the finite content of the converse: an admissible seven-set is
the point set of a passant row.

Everything here is stated on internal-point indices below `78`, and on bit sets of such indices
packed into natural numbers.  Three constructions carry the geometry:

* `passantRowMask line` is the bit set of the internal points on the passant of index `line`, read
  from the packed incidence table of `PassantCodeQ13.IndexedIncidenceTable`, and `passantRowPoints`
  is the same row as the increasing list of its point indices;
* `passantJoinMask point` is the bit set of the indices joined to `point` by some passant, obtained
  as the union of the rows through `point`;
* `pairSupportUnion first second` is the union of the displayed minimum-word supports containing
  both indices, so its bit at a third index records whether some support contains all three, that
  is, whether the triple concurrence of the three indices is nonzero.

An admissible seven-set, listed in increasing order of index, is determined by its three least
elements together with four further elements, each above the previous one, each joined to all the
earlier ones.  `rowExtensionCheckAt` runs exactly that search at one first index: it ranges over the
second and third elements through the join masks, discards a triple of nonzero concurrence, and then
extends four times through `extensionCheck`, at each step restricting the pool of available indices
to those joined to the index just chosen.  At depth four it asks whether the seven indices meet every
support at most twice — in the equivalent form that no support contains three of them — and if so
requires the list to be one of the displayed rows.

The soundness theorem `rowExtensionCheckAt_sound` states the resulting implication for an arbitrary
increasing list of seven indices below `78`: if every first index passes the check, and the seven
indices are pairwise joined and have zero triple concurrence on distinct triples, then they are the
points of a passant row.  No step of the argument enumerates the seven-subsets of the `78` indices;
the search domain is the passant-join relation.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open PassantCodeQ13.WeightTen

/-- A bit of a union accumulated over a list of bit sets is set exactly where one selected member
has it. -/
private theorem testBit_foldl_lor (select : Nat → Bool) (bit : Nat) :
    ∀ (elements : List Nat) (initial : Nat),
      (elements.foldl (fun mask element =>
          if select element then mask ||| element else mask) initial).testBit bit =
        (initial.testBit bit ||
          elements.any fun element => select element && element.testBit bit)
  | [], initial => by simp
  | element :: rest, initial => by
      rw [List.foldl_cons, testBit_foldl_lor select bit rest, List.any_cons]
      by_cases selected : select element = true
      · rw [if_pos selected, Nat.testBit_or, selected]
        simp [Bool.or_assoc]
      · have not_selected : select element = false := by simpa using selected
        rw [if_neg selected, not_selected]
        simp

/-- The internal points on the passant of one index whose own index is below a bound, as a bit
set. -/
def rowMaskBelow (bound line : Nat) : Nat :=
  (List.range bound).foldl (fun mask point =>
    if tabulatedIncidentAt line point then mask ||| (1 <<< point) else mask) 0

/-- Raising the bound by one adds the point of that index when it lies on the row. -/
private theorem rowMaskBelow_succ (bound line : Nat) :
    rowMaskBelow (bound + 1) line =
      if tabulatedIncidentAt line bound then rowMaskBelow bound line ||| (1 <<< bound)
      else rowMaskBelow bound line := by
  rw [rowMaskBelow, List.range_succ, List.foldl_append]
  rfl

/-- A row bit is set exactly at the incident points below the bound. -/
private theorem testBit_rowMaskBelow (bound line point : Nat) :
    (rowMaskBelow bound line).testBit point =
      (decide (point < bound) && tabulatedIncidentAt line point) := by
  induction bound with
  | zero => simp [rowMaskBelow]
  | succ bound induction_hypothesis =>
      rw [rowMaskBelow_succ]
      by_cases incident : tabulatedIncidentAt line bound = true
      · rw [if_pos incident, Nat.testBit_or, induction_hypothesis,
          show (1 <<< bound) = 2 ^ bound by simp [Nat.shiftLeft_eq],
          Nat.testBit_two_pow]
        rcases Nat.lt_trichotomy point bound with below | equal | above
        · have : point < bound + 1 := by omega
          simp [below, this, Nat.ne_of_gt below]
        · subst equal
          simp [incident]
        · have : ¬point < bound + 1 := by omega
          simp [Nat.not_lt_of_gt above, this, Nat.ne_of_lt above]
      · have not_incident : tabulatedIncidentAt line bound = false := by simpa using incident
        rw [if_neg incident, induction_hypothesis]
        rcases Nat.lt_trichotomy point bound with below | equal | above
        · have : point < bound + 1 := by omega
          simp [below, this]
        · subst equal
          simp [not_incident]
        · have : ¬point < bound + 1 := by omega
          simp [Nat.not_lt_of_gt above, this]

/-- The internal points on the passant of one index, as a bit set of internal-point indices. -/
def passantRowMask (line : Nat) : Nat := rowMaskBelow 78 line

/-- A row bit is set exactly at the incident internal-point indices. -/
theorem testBit_passantRowMask (line point : Nat) :
    (passantRowMask line).testBit point =
      (decide (point < 78) && tabulatedIncidentAt line point) :=
  testBit_rowMaskBelow 78 line point

/-- The bit sets of the `78` displayed passant rows. -/
def passantRowMasks : List Nat := (List.range 78).map passantRowMask

/-- The internal points joined to one index by a passant, as a bit set of internal-point indices.
It is the union of the rows through that index, so it also contains the index itself. -/
def passantJoinMask (point : Nat) : Nat :=
  passantRowMasks.foldl (fun mask row => if row.testBit point then mask ||| row else mask) 0

/-- The join mask has a bit exactly where some displayed passant contains both indices. -/
theorem testBit_passantJoinMask {first second : Nat} (first_lt : first < 78)
    (second_lt : second < 78) :
    (passantJoinMask first).testBit second = hasPassantJoin first second := by
  rw [passantJoinMask, passantRowMasks,
    testBit_foldl_lor (fun row : Nat => row.testBit first) second,
    ← tabulatedHasPassantJoin_eq_hasPassantJoin first_lt second_lt]
  simp [tabulatedHasPassantJoin, testBit_passantRowMask, first_lt, second_lt,
    Function.comp_def]

/-- The union of the displayed minimum-word supports containing two internal-point indices. -/
def pairSupportUnion (first second : Nat) : Nat :=
  minimumWordSupports.foldl (fun mask support =>
    if support.testBit first && support.testBit second then mask ||| support else mask) 0

/-- The union of the supports through two indices has a bit exactly where some displayed support
contains all three indices. -/
theorem testBit_pairSupportUnion (first second third : Nat) :
    (pairSupportUnion first second).testBit third =
      minimumWordSupports.any fun support =>
        support.testBit first && support.testBit second && support.testBit third := by
  rw [pairSupportUnion, testBit_foldl_lor
    (fun support : Nat => support.testBit first && support.testBit second) third]
  simp [Bool.and_assoc]

/-- Zero triple concurrence in the displayed minimum-word supports is a vanishing union bit. -/
theorem testBit_pairSupportUnion_eq_false_iff (first second third : Nat) :
    (pairSupportUnion first second).testBit third = false ↔
      tripleConcurrenceIn minimumWordSupports first second third = 0 := by
  rw [testBit_pairSupportUnion, tripleConcurrenceIn, List.countP_eq_zero]
  simp

/-- The internal-point indices that a bit set selects above a bound, in increasing order. -/
def selectedAbove (mask lower : Nat) : List Nat :=
  (List.range 78).filter fun index => decide (lower < index) && mask.testBit index

/-- A selected index above the bound occurs in the selection. -/
theorem mem_selectedAbove {mask lower index : Nat} (bounded : index < 78) (above : lower < index)
    (selected : mask.testBit index = true) : index ∈ selectedAbove mask lower :=
  List.mem_filter.mpr ⟨List.mem_range.mpr bounded, by simp [above, selected]⟩

/-- The internal points of one displayed passant row, in increasing order of index. -/
def passantRowPoints (line : Nat) : List Nat :=
  (List.range 78).filter (tabulatedIncidentAt line)

/-- The point lists of the `78` displayed passant rows. -/
def passantRowPointLists : List (List Nat) := (List.range 78).map passantRowPoints

/-- No displayed minimum-word support contains three of the listed indices. -/
def noSupportOnTriple (points : List Nat) : Bool :=
  (points.sublistsLen 3).all fun triple =>
    match triple with
    | [first, second, third] => !(pairSupportUnion first second).testBit third
    | _ => true

/-- Check every increasing extension of a partial vertex list by `remaining` further indices, each
drawn from `pool` and joined to all indices chosen before it.  An index in `forbidden` is discarded:
that bit set is the union of the supports through two already chosen indices, so an index it selects
completes a triple of nonzero concurrence.  At depth zero a list on which no support carries three
indices is required to be a displayed passant row. -/
def extensionCheck (chosen pool : List Nat) (forbidden : Nat) : Nat → Bool
  | 0 => if noSupportOnTriple chosen then decide (chosen ∈ passantRowPointLists) else true
  | remaining + 1 => pool.all fun index =>
      if forbidden.testBit index then true
      else extensionCheck (chosen ++ [index])
        (pool.filter fun other => decide (index < other) && (passantJoinMask index).testBit other)
        forbidden remaining

/-- The complete local-extension check at one first internal-point index: every increasing seven-set
of pairwise joined indices whose triples have zero concurrence, and whose least index is the given
one, is a displayed passant row. -/
def rowExtensionCheckAt (first : Nat) : Bool :=
  (selectedAbove (passantJoinMask first) first).all fun second =>
    (selectedAbove (passantJoinMask first &&& passantJoinMask second) second).all fun third =>
      if (pairSupportUnion first second).testBit third then true
      else extensionCheck [first, second, third]
        (selectedAbove
          (passantJoinMask first &&& passantJoinMask second &&& passantJoinMask third) third)
        (pairSupportUnion first second) 4

/-- The internal-point indices in one residue class modulo seven.  The seven classes partition the
indices below `78`, and the local-extension check is discharged one class at a time. -/
def residueIndices (residue : Nat) : List Nat :=
  (List.range 78).filter fun index => index % 7 == residue

/-- Every displayed index lies in the class of its own residue. -/
theorem mem_residueIndices {first : Nat} (bounded : first < 78) :
    first ∈ residueIndices (first % 7) :=
  List.mem_filter.mpr ⟨List.mem_range.mpr bounded, by simp⟩

/-- A successful extension check classifies every admissible completion of the chosen list. -/
theorem extensionCheck_sound :
    ∀ (remaining : Nat) (chosen extra pool : List Nat) (forbidden : Nat),
      extensionCheck chosen pool forbidden remaining = true →
      extra.length = remaining →
      (∀ index ∈ extra, index < 78) →
      extra.Pairwise (· < ·) →
      (∀ index ∈ extra, index ∈ pool) →
      (∀ index ∈ extra, forbidden.testBit index = false) →
      (∀ index ∈ extra, ∀ other ∈ extra, index ≠ other → hasPassantJoin index other = true) →
      noSupportOnTriple (chosen ++ extra) = true →
      chosen ++ extra ∈ passantRowPointLists
  | 0, chosen, extra, pool, forbidden, check, length, _, _, _, _, _, admissible => by
      have extra_nil : extra = [] := List.eq_nil_of_length_eq_zero length
      subst extra_nil
      rw [List.append_nil] at admissible ⊢
      rw [extensionCheck, if_pos admissible] at check
      exact of_decide_eq_true check
  | remaining + 1, chosen, extra, pool, forbidden, check, length, bounded, sorted, in_pool,
      allowed, joined, admissible => by
      match extra, length with
      | index :: rest, length =>
        have index_mem : index ∈ index :: rest := List.mem_cons_self ..
        have sorted_tail : rest.Pairwise (· < ·) := (List.pairwise_cons.mp sorted).2
        have index_lt : ∀ other ∈ rest, index < other := (List.pairwise_cons.mp sorted).1
        have step := (List.all_eq_true.mp check) index (in_pool index index_mem)
        rw [if_neg (by simp [allowed index index_mem])] at step
        have restricted : ∀ other ∈ rest,
            other ∈ pool.filter fun candidate =>
              decide (index < candidate) && (passantJoinMask index).testBit candidate := by
          intro other other_mem
          have other_mem_extra : other ∈ index :: rest := List.mem_cons_of_mem _ other_mem
          have join := joined index index_mem other other_mem_extra
            (Nat.ne_of_lt (index_lt other other_mem))
          refine List.mem_filter.mpr ⟨in_pool other other_mem_extra, ?_⟩
          rw [testBit_passantJoinMask (bounded index index_mem) (bounded other other_mem_extra),
            join]
          simp [index_lt other other_mem]
        have admissible_shift : noSupportOnTriple ((chosen ++ [index]) ++ rest) = true := by
          rwa [List.append_assoc, List.cons_append, List.nil_append]
        have classified := extensionCheck_sound remaining (chosen ++ [index]) rest
          (pool.filter fun candidate =>
            decide (index < candidate) && (passantJoinMask index).testBit candidate)
          forbidden step (by simpa using length)
          (fun other other_mem => bounded other (List.mem_cons_of_mem _ other_mem))
          sorted_tail restricted
          (fun other other_mem => allowed other (List.mem_cons_of_mem _ other_mem))
          (fun first first_mem second second_mem distinct =>
            joined first (List.mem_cons_of_mem _ first_mem) second
              (List.mem_cons_of_mem _ second_mem) distinct)
          admissible_shift
        rwa [List.append_assoc, List.cons_append, List.nil_append] at classified

/-- Every increasing list of seven pairwise joined internal-point indices whose distinct triples have
zero concurrence in the displayed minimum-word supports is the point list of a displayed passant
row. -/
theorem rowExtensionCheckAt_sound (points : List Nat) (length : points.length = 7)
    (bounded : ∀ index ∈ points, index < 78) (sorted : points.Pairwise (· < ·))
    (joined : ∀ first ∈ points, ∀ second ∈ points, first ≠ second →
      hasPassantJoin first second = true)
    (concurrence : ∀ first ∈ points, ∀ second ∈ points, ∀ third ∈ points,
      first ≠ second → first ≠ third → second ≠ third →
        tripleConcurrenceIn minimumWordSupports first second third = 0)
    (check : ∀ first < 78, rowExtensionCheckAt first = true) :
    points ∈ passantRowPointLists := by
  have nodup : points.Nodup := sorted.imp fun less => Nat.ne_of_lt less
  have admissible : noSupportOnTriple points = true := by
    apply List.all_eq_true.mpr
    intro triple triple_mem
    obtain ⟨sublist, triple_length⟩ := List.mem_sublistsLen.mp triple_mem
    match triple, triple_length with
    | [first, second, third], _ =>
      have triple_nodup : ([first, second, third] : List Nat).Nodup := nodup.sublist sublist
      have subset := sublist.subset
      have distinct : first ≠ second ∧ first ≠ third ∧ second ≠ third := by
        have data : (first ≠ second ∧ first ≠ third) ∧ second ≠ third := by
          simpa [List.nodup_cons, not_or] using triple_nodup
        exact ⟨data.1.1, data.1.2, data.2⟩
      have first_mem : first ∈ [first, second, third] := by simp
      have second_mem : second ∈ [first, second, third] := by simp
      have third_mem : third ∈ [first, second, third] := by simp
      have zero := concurrence first (subset first_mem) second (subset second_mem) third
        (subset third_mem) distinct.1 distinct.2.1 distinct.2.2
      simpa using (testBit_pairSupportUnion_eq_false_iff first second third).mpr zero
  match points, length with
  | first :: second :: third :: rest, length =>
    have first_mem : first ∈ first :: second :: third :: rest := by simp
    have second_mem : second ∈ first :: second :: third :: rest := by simp
    have third_mem : third ∈ first :: second :: third :: rest := by simp
    have sorted_pairs := List.pairwise_cons.mp sorted
    have first_lt_second : first < second := sorted_pairs.1 second (by simp)
    have first_lt_third : first < third := sorted_pairs.1 third (by simp)
    have sorted_second := List.pairwise_cons.mp sorted_pairs.2
    have second_lt_third : second < third := sorted_second.1 third (by simp)
    have first_lt : first < 78 := bounded first first_mem
    have second_lt : second < 78 := bounded second second_mem
    have third_lt : third < 78 := bounded third third_mem
    have join_first_second : hasPassantJoin first second = true :=
      joined first first_mem second second_mem (Nat.ne_of_lt first_lt_second)
    have join_first_third : hasPassantJoin first third = true :=
      joined first first_mem third third_mem (Nat.ne_of_lt first_lt_third)
    have join_second_third : hasPassantJoin second third = true :=
      joined second second_mem third third_mem (Nat.ne_of_lt second_lt_third)
    have second_selected : second ∈ selectedAbove (passantJoinMask first) first :=
      mem_selectedAbove second_lt first_lt_second
        (by rw [testBit_passantJoinMask first_lt second_lt]; exact join_first_second)
    have third_selected :
        third ∈ selectedAbove (passantJoinMask first &&& passantJoinMask second) second := by
      refine mem_selectedAbove third_lt second_lt_third ?_
      rw [Nat.testBit_and, testBit_passantJoinMask first_lt third_lt,
        testBit_passantJoinMask second_lt third_lt, join_first_third, join_second_third]
      rfl
    have seed_zero : tripleConcurrenceIn minimumWordSupports first second third = 0 :=
      concurrence first first_mem second second_mem third third_mem
        (Nat.ne_of_lt first_lt_second) (Nat.ne_of_lt first_lt_third)
        (Nat.ne_of_lt second_lt_third)
    have seed_bit : (pairSupportUnion first second).testBit third = false :=
      (testBit_pairSupportUnion_eq_false_iff first second third).mpr seed_zero
    have inner := (List.all_eq_true.mp
      ((List.all_eq_true.mp (check first first_lt)) second second_selected)) third third_selected
    rw [if_neg (by simp [seed_bit])] at inner
    have rest_length : rest.length = 4 := by simpa using length
    have sorted_third := List.pairwise_cons.mp sorted_second.2
    have classified := extensionCheck_sound 4 [first, second, third] rest
      (selectedAbove
        (passantJoinMask first &&& passantJoinMask second &&& passantJoinMask third) third)
      (pairSupportUnion first second)
      inner rest_length
      (fun index index_mem => bounded index (by simp [index_mem]))
      (List.pairwise_cons.mp sorted_second.2).2
      (by
        intro index index_mem
        have index_mem_points : index ∈ first :: second :: third :: rest := by simp [index_mem]
        have index_lt : index < 78 := bounded index index_mem_points
        have third_lt_index : third < index := sorted_third.1 index index_mem
        refine mem_selectedAbove index_lt third_lt_index ?_
        rw [Nat.testBit_and, Nat.testBit_and,
          testBit_passantJoinMask first_lt index_lt,
          testBit_passantJoinMask second_lt index_lt,
          testBit_passantJoinMask third_lt index_lt,
          joined first first_mem index index_mem_points
            (Nat.ne_of_lt (lt_trans first_lt_third third_lt_index)),
          joined second second_mem index index_mem_points
            (Nat.ne_of_lt (lt_trans second_lt_third third_lt_index)),
          joined third third_mem index index_mem_points (Nat.ne_of_lt third_lt_index)]
        rfl)
      (by
        intro index index_mem
        have index_mem_points : index ∈ first :: second :: third :: rest := by simp [index_mem]
        have third_lt_index : third < index := sorted_third.1 index index_mem
        refine (testBit_pairSupportUnion_eq_false_iff first second index).mpr ?_
        exact concurrence first first_mem second second_mem index index_mem_points
          (Nat.ne_of_lt first_lt_second)
          (Nat.ne_of_lt (lt_trans first_lt_third third_lt_index))
          (Nat.ne_of_lt (lt_trans second_lt_third third_lt_index)))
      (fun index index_mem other other_mem distinct =>
        joined index (by simp [index_mem]) other (by simp [other_mem]) distinct)
      (by simpa using admissible)
    simpa using classified

end PassantCodeQ13.MinimumWords.RowUniqueness
