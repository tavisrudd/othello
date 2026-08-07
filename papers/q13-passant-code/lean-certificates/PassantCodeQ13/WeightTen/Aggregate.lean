import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre0
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre1
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre2
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre3
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre4
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre5
import PassantCodeQ13.WeightTen.IsolatedProfile.Fibre6
import PassantCodeQ13.WeightTen.CycleProfile.Residue0
import PassantCodeQ13.WeightTen.CycleProfile.Residue1
import PassantCodeQ13.WeightTen.CycleProfile.Residue2
import PassantCodeQ13.WeightTen.CycleProfile.Residue3
import PassantCodeQ13.WeightTen.CycleProfile.Residue4
import PassantCodeQ13.WeightTen.CycleProfile.Residue5
import PassantCodeQ13.WeightTen.CycleProfile.Residue6

/-!
# Aggregate q=13 weight-ten certificate

The local partition is checked from the normalized conic incidence relation.  The isolated-profile
leaves cover each possible distinguished passant fibre.  The cycle-profile leaves partition all
unordered pairs of the thirty-five secant neighbors by the first endpoint's coordinate index
modulo seven.  The aggregate joins the fourteen independently elaborated syndrome-disjointness
terminals, which are checked by native evaluation, with two checks of its own that are discharged by
kernel reduction: the incidence partition at the base point, and the exhaustiveness of the seven
residue shards.

The second of those is stated as a permutation of lists of pairs and proved by sorting both sides.
The sort is the insertion sort of this module, ordered by an encoding of a pair as a natural
number, rather than the library merge sort: insertion sort recurses structurally and the kernel
therefore reduces it, whereas the library sort is defined by well-founded recursion and does not
reduce.  It is proved here to permute its input, so the equality of the two sorted lists transports
to the permutation without any claim about the order the encoding induces.
-/

namespace PassantCodeQ13.WeightTen

/-- The fixed-base incidence partition consists of seven six-point passant fibres and thirty-five
secant neighbors. -/
theorem local_partition : localPartitionCheck = true := by
  decide +kernel

/-- Every isolated-profile shard has disjoint left and right syndrome images. -/
theorem all_isolated_profiles_disjoint :
    isolatedProfileCheck 0 = true ∧ isolatedProfileCheck 1 = true ∧
      isolatedProfileCheck 2 = true ∧ isolatedProfileCheck 3 = true ∧
      isolatedProfileCheck 4 = true ∧ isolatedProfileCheck 5 = true ∧
      isolatedProfileCheck 6 = true :=
  ⟨IsolatedProfile.fibre0_syndrome_disjoint, IsolatedProfile.fibre1_syndrome_disjoint,
    IsolatedProfile.fibre2_syndrome_disjoint, IsolatedProfile.fibre3_syndrome_disjoint,
    IsolatedProfile.fibre4_syndrome_disjoint, IsolatedProfile.fibre5_syndrome_disjoint,
    IsolatedProfile.fibre6_syndrome_disjoint⟩

/-- Every cycle-profile residue shard has disjoint left and right syndrome images. -/
theorem all_cycle_profiles_disjoint :
    cycleProfileCheck 0 = true ∧ cycleProfileCheck 1 = true ∧
      cycleProfileCheck 2 = true ∧ cycleProfileCheck 3 = true ∧
      cycleProfileCheck 4 = true ∧ cycleProfileCheck 5 = true ∧
      cycleProfileCheck 6 = true :=
  ⟨CycleProfile.residue0_syndrome_disjoint, CycleProfile.residue1_syndrome_disjoint,
    CycleProfile.residue2_syndrome_disjoint, CycleProfile.residue3_syndrome_disjoint,
    CycleProfile.residue4_syndrome_disjoint, CycleProfile.residue5_syndrome_disjoint,
    CycleProfile.residue6_syndrome_disjoint⟩

/-- Encode a pair of point indices below 78 as the natural number used to order pairs. -/
def encodePair : List Nat → Nat
  | [first, second] => 78 * first + second
  | _ => 0

/-- Insert a pair into a list of pairs, before the first entry of no smaller encoding. -/
def insertByKey (pair : List Nat) : List (List Nat) → List (List Nat)
  | [] => [pair]
  | head :: rest =>
      if encodePair pair ≤ encodePair head then pair :: head :: rest
      else head :: insertByKey pair rest

/-- Repeated insertion by the encoding, recursing structurally so that the kernel reduces it on
displayed data. -/
def sortByKey : List (List Nat) → List (List Nat)
  | [] => []
  | head :: rest => insertByKey head (sortByKey rest)

/-- Inserting a pair permutes the list into which it is inserted, whatever the encoding does. -/
theorem insertByKey_perm (pair : List Nat) :
    ∀ pairs : List (List Nat), List.Perm (insertByKey pair pairs) (pair :: pairs) := by
  intro pairs
  induction pairs with
  | nil => simp [insertByKey]
  | cons head rest inductionHypothesis =>
      by_cases ordered : encodePair pair ≤ encodePair head
      · simp [insertByKey, ordered]
      · rw [insertByKey, if_neg ordered]
        exact (inductionHypothesis.cons head).trans (List.Perm.swap pair head rest)

/-- Repeated insertion permutes its input. -/
theorem sortByKey_perm :
    ∀ pairs : List (List Nat), List.Perm (sortByKey pairs) pairs := by
  intro pairs
  induction pairs with
  | nil => simp [sortByKey]
  | cons head rest inductionHypothesis =>
      exact (insertByKey_perm head (sortByKey rest)).trans (inductionHypothesis.cons head)

/-- The concatenated residue shards and the unordered pairs of secant neighbors are carried to the
same list by repeated insertion. -/
theorem sortByKey_shards_eq :
    sortByKey ((List.range 7).flatMap cyclePairs) = sortByKey (secantNeighbors.sublistsLen 2) := by
  decide +kernel

/-- The seven residue shards contain exactly the unordered pairs of secant neighbors, with the same
multiplicity. -/
theorem cycle_pair_partition :
    List.Perm ((List.range 7).flatMap cyclePairs) (secantNeighbors.sublistsLen 2) := by
  have shards : List.Perm (sortByKey ((List.range 7).flatMap cyclePairs))
      ((List.range 7).flatMap cyclePairs) := sortByKey_perm _
  rw [sortByKey_shards_eq] at shards
  exact shards.symm.trans (sortByKey_perm _)

end PassantCodeQ13.WeightTen
