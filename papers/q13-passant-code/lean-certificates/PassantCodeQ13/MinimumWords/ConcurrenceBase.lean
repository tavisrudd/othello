import PassantCodeQ13.MinimumWords.OrbitS4
import PassantCodeQ13.MinimumWords.OrbitDihedral
import PassantCodeQ13.IndexedIncidenceTable

/-!
# The minimum-word hypergraph and its concurrence checks

The four 91-element projective orbits are joined into a 364-support hypergraph on the 78 internal
points.  This module defines that hypergraph, its pair and triple concurrence counts, the geometric
passant-join relation and passant rows, and the two exhaustive checks made on them: that pair
concurrence lies in `{7,9,12}` exactly for a passant join, and that every passant row is a seven-set
all of whose triples have concurrence zero.

Both checks are stated over an arbitrary list of internal-point indices, respectively of passant
rows, so that they can be discharged block by block.  The internal-point indices below 78 are
partitioned into three blocks of 26, and the checks over the whole range are proved equal to the
conjunction of the three block checks.

Two replacements make the checks reducible.  The four orbits are identified with the displayed
supports of `PassantCodeQ13.MinimumWords.OrbitData`, and incidence is read from the packed table of
`PassantCodeQ13.IndexedIncidenceTable`.  The bridges below prove that neither replacement changes
what is checked.
-/

namespace PassantCodeQ13.MinimumWords

open PassantCodeQ13.WeightTen

/-- The union of the four displayed projective support orbits. -/
def minimumSupportCodes : List Nat :=
  (supportOrbit representativeS4 ++ supportOrbit representativeDihedralA ++
    supportOrbit representativeDihedralB ++ supportOrbit representativeDihedralC).eraseDups

/-- Pair concurrence in an explicitly supplied encoded support hypergraph. -/
def pairConcurrenceIn (supports : List Nat) (first second : Nat) : Nat :=
  supports.countP fun support => support.testBit first && support.testBit second

/-- Triple concurrence in an explicitly supplied encoded support hypergraph. -/
def tripleConcurrenceIn (supports : List Nat) (first second third : Nat) : Nat :=
  supports.countP fun support =>
    support.testBit first && support.testBit second && support.testBit third

/-- Whether two indexed internal points lie on a common passant. -/
def hasPassantJoin (first second : Nat) : Bool :=
  (List.range 78).any fun line => incidentAt line first && incidentAt line second

/-- The passant-row supports at the listed line indices, as bit sets of internal-point indices. -/
def passantRowCodesOn (lines : List Nat) : List Nat :=
  lines.map fun line =>
    (List.range 78).foldl (fun support point =>
      if incidentAt line point then support ||| (1 <<< point) else support) 0

/-- The 78 geometric passant-row supports, encoded as bit sets of internal-point indices. -/
def passantRowCodes : List Nat :=
  passantRowCodesOn (List.range 78)

/-- The listed passant rows are seven-sets whose triples have concurrence zero in a hypergraph. -/
def rowTripleCheckOn (supports rows : List Nat) : Bool :=
  rows.all fun row =>
    let points := (List.range 78).filter row.testBit
    points.length == 7 &&
      (points.sublistsLen 3).all fun triple =>
        match triple with
        | [first, second, third] => tripleConcurrenceIn supports first second third == 0
        | _ => false

/-- Every geometric passant row has seven points and zero concurrence on each of its triples. -/
def passantRowTripleCheck : Bool :=
  rowTripleCheckOn minimumSupportCodes passantRowCodes

/-- Pair-concurrence comparison with geometric passant joins at the listed first indices. -/
def pairRecoveryCheckOn (supports firsts : List Nat) : Bool :=
  firsts.all fun first =>
    (List.range 78).all fun second =>
      first == second ||
        (hasPassantJoin first second ==
          ([7, 9, 12].contains (pairConcurrenceIn supports first second)))

/-- Exhaustive pair-concurrence comparison with geometric passant joins. -/
def pairRecoveryCheck : Bool :=
  pairRecoveryCheckOn minimumSupportCodes (List.range 78)

/-- Passant join read from the packed incidence table. -/
def tabulatedHasPassantJoin (first second : Nat) : Bool :=
  (List.range 78).any fun line =>
    tabulatedIncidentAt line first && tabulatedIncidentAt line second

/-- Pair-concurrence comparison using the tabulated passant-join relation. -/
def tabulatedPairRecoveryCheckOn (supports firsts : List Nat) : Bool :=
  firsts.all fun first =>
    (List.range 78).all fun second =>
      first == second ||
        (tabulatedHasPassantJoin first second ==
          ([7, 9, 12].contains (pairConcurrenceIn supports first second)))

/-- The passant-row supports at the listed line indices, read from the packed incidence table. -/
def tabulatedPassantRowCodesOn (lines : List Nat) : List Nat :=
  lines.map fun line =>
    (List.range 78).foldl (fun support point =>
      if tabulatedIncidentAt line point then support ||| (1 <<< point) else support) 0

/-- Two membership-wise equal predicates give the same universal test. -/
private theorem all_congr_of_mem {α : Type _} {list : List α} {left right : α → Bool}
    (agree : ∀ a ∈ list, left a = right a) : list.all left = list.all right := by
  induction list with
  | nil => rfl
  | cons head tail ih =>
    simp only [List.all_cons, agree head (List.mem_cons_self ..),
      ih fun a mem => agree a (List.mem_cons_of_mem _ mem)]

/-- Two membership-wise equal predicates give the same existential test. -/
private theorem any_congr_of_mem {α : Type _} {list : List α} {left right : α → Bool}
    (agree : ∀ a ∈ list, left a = right a) : list.any left = list.any right := by
  induction list with
  | nil => rfl
  | cons head tail ih =>
    simp only [List.any_cons, agree head (List.mem_cons_self ..),
      ih fun a mem => agree a (List.mem_cons_of_mem _ mem)]

/-- The tabulated passant join agrees with the coordinate one on indices below 78. -/
theorem tabulatedHasPassantJoin_eq_hasPassantJoin {first second : Nat} (hfirst : first < 78)
    (hsecond : second < 78) :
    tabulatedHasPassantJoin first second = hasPassantJoin first second :=
  any_congr_of_mem fun line mem => by
    have hline := List.mem_range.mp mem
    simp only [tabulatedIncidentAt_eq_incidentAt hline hfirst,
      tabulatedIncidentAt_eq_incidentAt hline hsecond]

/-- The tabulated comparison checks the same pairs as the coordinate one. -/
theorem tabulatedPairRecoveryCheckOn_eq (supports firsts : List Nat)
    (bounded : ∀ first ∈ firsts, first < 78) :
    tabulatedPairRecoveryCheckOn supports firsts = pairRecoveryCheckOn supports firsts :=
  all_congr_of_mem fun first memFirst =>
    all_congr_of_mem fun second memSecond => by
      simp only [tabulatedHasPassantJoin_eq_hasPassantJoin (bounded first memFirst)
        (List.mem_range.mp memSecond)]

/-- Both row encodings fold the same step over point indices below 78. -/
private theorem foldl_row_congr {line : Nat} (hline : line < 78) :
    ∀ {points : List Nat}, (∀ point ∈ points, point < 78) → ∀ support : Nat,
      points.foldl (fun support point =>
          if tabulatedIncidentAt line point then support ||| (1 <<< point) else support) support =
        points.foldl (fun support point =>
          if incidentAt line point then support ||| (1 <<< point) else support) support
  | [], _, _ => rfl
  | point :: rest, bounded, support => by
    simp only [List.foldl_cons,
      tabulatedIncidentAt_eq_incidentAt hline (bounded point (List.mem_cons_self ..))]
    exact foldl_row_congr hline (fun q hq => bounded q (List.mem_cons_of_mem _ hq)) _

/-- The tabulated passant rows are the geometric ones. -/
theorem tabulatedPassantRowCodesOn_eq (lines : List Nat) (bounded : ∀ line ∈ lines, line < 78) :
    tabulatedPassantRowCodesOn lines = passantRowCodesOn lines := by
  unfold tabulatedPassantRowCodesOn passantRowCodesOn
  refine List.map_congr_left fun line mem => ?_
  exact foldl_row_congr (bounded line mem) (fun point memPoint => List.mem_range.mp memPoint) 0

/-- Indices 0 through 25, of the internal points and equally of the passant lines. -/
def indexBlockOne : List Nat := List.range 26

/-- Indices 26 through 51, of the internal points and equally of the passant lines. -/
def indexBlockTwo : List Nat := (List.range 26).map (· + 26)

/-- Indices 52 through 77, of the internal points and equally of the passant lines. -/
def indexBlockThree : List Nat := (List.range 26).map (· + 52)

/-- The three blocks partition the indices below 78 in order. -/
theorem indexBlocks_cover :
    List.range 78 = indexBlockOne ++ indexBlockTwo ++ indexBlockThree := by
  decide

/-- Every index of the first block is below 78. -/
theorem indexBlockOne_bounded : ∀ index ∈ indexBlockOne, index < 78 := by decide

/-- Every index of the second block is below 78. -/
theorem indexBlockTwo_bounded : ∀ index ∈ indexBlockTwo, index < 78 := by decide

/-- Every index of the third block is below 78. -/
theorem indexBlockThree_bounded : ∀ index ∈ indexBlockThree, index < 78 := by decide

/-- The pair comparison over a concatenation is the conjunction of its parts. -/
theorem pairRecoveryCheckOn_append (supports left right : List Nat) :
    pairRecoveryCheckOn supports (left ++ right) =
      (pairRecoveryCheckOn supports left && pairRecoveryCheckOn supports right) := by
  simp only [pairRecoveryCheckOn, List.all_append]

/-- The row check over a concatenation is the conjunction of its parts. -/
theorem rowTripleCheckOn_append (supports left right : List Nat) :
    rowTripleCheckOn supports (left ++ right) =
      (rowTripleCheckOn supports left && rowTripleCheckOn supports right) := by
  simp only [rowTripleCheckOn, List.all_append]

/-- Passant rows are read off a concatenation of line indices blockwise. -/
theorem passantRowCodesOn_append (left right : List Nat) :
    passantRowCodesOn (left ++ right) = passantRowCodesOn left ++ passantRowCodesOn right := by
  simp only [passantRowCodesOn, List.map_append]

/-- The four orbits together are the displayed minimum-word supports. -/
theorem minimumSupportCodes_eq : minimumSupportCodes = minimumWordSupports := by
  unfold minimumSupportCodes
  rw [supportOrbit_representativeS4_eq, supportOrbit_representativeDihedralA_eq,
    supportOrbit_representativeDihedralB_eq, supportOrbit_representativeDihedralC_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
