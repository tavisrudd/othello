import RelativeConicArcs.Q11A5PointOrbitsBlocks

/-!
# The sixty normalized projectivities of the order-eleven icosahedral action

This base module records sixty normalized projective transformations of `PG(2,11)` as row-major
`3 × 3` matrix codes over `F_11`, each normalized by making its first nonzero entry equal to one,
together with the sixty induced permutations of the six witness-column directions.  It defines the
resulting action on the 133 canonical point indices of
`RelativeConicArcs.Q11A5PointOrbitsBlocks`, the iterated support permutations and the exact
order-five predicate, and the per-element fixed-point sets and their order-five union.

Nothing is proved here.  The bounded matrix, support, row, and fixed-point modules verify by kernel
reduction that these matrices are invertible, preserve the displayed six-arc, act on every
projective point as recorded, and have the stated fixed sets; the tactic macros below are the
shared normalization those bounded checks use.  This is a finite bridge, not the pencil-and-paper
derivation that the projective stabilizer is the icosahedral `A5` representation.  Every finite
assertion downstream uses kernel-checked `norm_num` or ordinary `decide`; there is no
`native_decide`, external oracle, or new axiom.
-/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

open Q11Coding

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

abbrev GroupIndex := Fin 60
abbrev MatrixCode := Fin 9 → Fin 11

/-- Sixty row-major `3 × 3` matrices over `F_11`, each normalized by making
its first nonzero entry equal to one.  The matrix checker proves that every
entry represents an invertible projective transformation and that the sixty
transformations are distinct. -/
def matrixCode (g : GroupIndex) : MatrixCode :=
  ![
    ![1, 0, 0, 0, 1, 0, 0, 0, 1],
    ![7, 6, 6, 8, 9, 8, 6, 6, 7],
    ![10, 9, 10, 2, 3, 1, 7, 7, 10],
    ![4, 3, 4, 0, 1, 10, 0, 0, 3],
    ![3, 2, 4, 0, 1, 4, 0, 0, 4],
    ![6, 5, 7, 10, 0, 3, 2, 2, 6],
    ![8, 7, 6, 6, 7, 2, 10, 10, 8],
    ![5, 4, 3, 0, 1, 7, 0, 0, 9],
    ![9, 8, 3, 0, 1, 9, 0, 0, 5],
    ![2, 1, 7, 7, 8, 5, 8, 8, 2],
    ![3, 2, 4, 9, 0, 10, 5, 4, 3],
    ![6, 5, 7, 2, 4, 3, 8, 7, 6],
    ![7, 6, 6, 6, 8, 3, 2, 1, 7],
    ![1, 0, 0, 3, 5, 0, 9, 8, 3],
    ![9, 8, 3, 5, 7, 10, 4, 3, 4],
    ![2, 1, 7, 8, 10, 2, 10, 9, 10],
    ![5, 4, 3, 4, 6, 0, 1, 0, 0],
    ![8, 7, 6, 10, 1, 6, 7, 6, 6],
    ![10, 9, 10, 7, 9, 2, 6, 5, 7],
    ![4, 3, 4, 1, 3, 7, 3, 2, 4],
    ![9, 8, 3, 8, 4, 4, 1, 5, 9],
    ![2, 1, 7, 2, 9, 9, 2, 6, 10],
    ![6, 5, 7, 6, 2, 3, 6, 10, 6],
    ![3, 2, 4, 10, 6, 7, 4, 8, 4],
    ![4, 3, 4, 6, 2, 3, 9, 2, 5],
    ![10, 9, 10, 10, 6, 7, 10, 3, 6],
    ![5, 4, 3, 2, 9, 9, 3, 7, 5],
    ![8, 7, 6, 8, 4, 4, 8, 1, 10],
    ![7, 6, 6, 7, 3, 0, 7, 0, 0],
    ![1, 0, 0, 7, 3, 0, 5, 9, 9],
    ![1, 0, 0, 6, 9, 0, 3, 9, 4],
    ![7, 6, 6, 4, 7, 9, 7, 2, 8],
    ![10, 9, 10, 1, 4, 3, 10, 5, 2],
    ![4, 3, 4, 2, 5, 4, 1, 7, 4],
    ![2, 1, 7, 9, 1, 10, 2, 8, 8],
    ![9, 8, 3, 10, 2, 0, 5, 0, 0],
    ![8, 7, 6, 3, 6, 10, 8, 3, 2],
    ![5, 4, 3, 8, 0, 4, 4, 10, 9],
    ![3, 2, 4, 7, 10, 5, 9, 4, 9],
    ![6, 5, 7, 5, 8, 3, 6, 1, 6],
    ![8, 8, 2, 5, 4, 9, 10, 6, 2],
    ![0, 0, 5, 0, 10, 4, 9, 5, 1],
    ![0, 0, 1, 0, 10, 7, 1, 8, 5],
    ![6, 6, 7, 1, 0, 8, 2, 9, 6],
    ![0, 0, 9, 0, 10, 1, 5, 1, 5],
    ![10, 10, 8, 9, 8, 10, 7, 3, 7],
    ![7, 7, 10, 3, 2, 3, 6, 2, 2],
    ![0, 0, 3, 0, 10, 0, 4, 0, 0],
    ![2, 2, 6, 4, 3, 6, 8, 4, 6],
    ![0, 0, 4, 0, 10, 2, 3, 10, 1],
    ![10, 9, 10, 3, 2, 10, 2, 6, 10],
    ![4, 3, 4, 9, 8, 5, 1, 5, 9],
    ![9, 8, 3, 1, 0, 7, 5, 9, 9],
    ![2, 1, 7, 5, 4, 0, 7, 0, 0],
    ![6, 5, 7, 4, 3, 3, 10, 3, 6],
    ![3, 2, 4, 4, 3, 3, 9, 2, 5],
    ![1, 0, 0, 5, 4, 0, 3, 7, 5],
    ![7, 6, 6, 1, 0, 7, 8, 1, 10],
    ![8, 7, 6, 9, 8, 5, 6, 10, 6],
    ![5, 4, 3, 3, 2, 10, 4, 8, 4]
  ] g

/-- The corresponding permutations of the six witness-column directions. -/
def supportPerm (g : GroupIndex) : Fin 6 → Fin 6 :=
  ![
    ![0, 1, 2, 3, 4, 5],
    ![0, 1, 3, 2, 5, 4],
    ![0, 2, 1, 4, 3, 5],
    ![0, 2, 4, 1, 5, 3],
    ![0, 3, 1, 5, 2, 4],
    ![0, 3, 5, 1, 4, 2],
    ![0, 4, 2, 5, 1, 3],
    ![0, 4, 5, 2, 3, 1],
    ![0, 5, 3, 4, 1, 2],
    ![0, 5, 4, 3, 2, 1],
    ![1, 0, 2, 3, 5, 4],
    ![1, 0, 3, 2, 4, 5],
    ![1, 2, 0, 5, 3, 4],
    ![1, 2, 5, 0, 4, 3],
    ![1, 3, 0, 4, 2, 5],
    ![1, 3, 4, 0, 5, 2],
    ![1, 4, 3, 5, 0, 2],
    ![1, 4, 5, 3, 2, 0],
    ![1, 5, 2, 4, 0, 3],
    ![1, 5, 4, 2, 3, 0],
    ![2, 0, 1, 4, 5, 3],
    ![2, 0, 4, 1, 3, 5],
    ![2, 1, 0, 5, 4, 3],
    ![2, 1, 5, 0, 3, 4],
    ![2, 3, 4, 5, 0, 1],
    ![2, 3, 5, 4, 1, 0],
    ![2, 4, 0, 3, 1, 5],
    ![2, 4, 3, 0, 5, 1],
    ![2, 5, 1, 3, 0, 4],
    ![2, 5, 3, 1, 4, 0],
    ![3, 0, 1, 5, 4, 2],
    ![3, 0, 5, 1, 2, 4],
    ![3, 1, 0, 4, 5, 2],
    ![3, 1, 4, 0, 2, 5],
    ![3, 2, 4, 5, 1, 0],
    ![3, 2, 5, 4, 0, 1],
    ![3, 4, 1, 2, 0, 5],
    ![3, 4, 2, 1, 5, 0],
    ![3, 5, 0, 2, 1, 4],
    ![3, 5, 2, 0, 4, 1],
    ![4, 0, 2, 5, 3, 1],
    ![4, 0, 5, 2, 1, 3],
    ![4, 1, 3, 5, 2, 0],
    ![4, 1, 5, 3, 0, 2],
    ![4, 2, 0, 3, 5, 1],
    ![4, 2, 3, 0, 1, 5],
    ![4, 3, 1, 2, 5, 0],
    ![4, 3, 2, 1, 0, 5],
    ![4, 5, 0, 1, 2, 3],
    ![4, 5, 1, 0, 3, 2],
    ![5, 0, 3, 4, 2, 1],
    ![5, 0, 4, 3, 1, 2],
    ![5, 1, 2, 4, 3, 0],
    ![5, 1, 4, 2, 0, 3],
    ![5, 2, 1, 3, 4, 0],
    ![5, 2, 3, 1, 0, 4],
    ![5, 3, 0, 2, 4, 1],
    ![5, 3, 2, 0, 1, 4],
    ![5, 4, 0, 1, 3, 2],
    ![5, 4, 1, 0, 2, 3]
  ] g

def matrixEntry (g : GroupIndex) (i j : Fin 3) : Scalar :=
  ((matrixCode g ⟨i.1 * 3 + j.1, by omega⟩).1 : Nat)

def matrixVec (g : GroupIndex) (v : Vec3) : Vec3 := fun i =>
  matrixEntry g i 0 * v 0 + matrixEntry g i 1 * v 1 + matrixEntry g i 2 * v 2

def matrixDet (g : GroupIndex) : Scalar :=
  matrixEntry g 0 0 *
      (matrixEntry g 1 1 * matrixEntry g 2 2 - matrixEntry g 1 2 * matrixEntry g 2 1) -
    matrixEntry g 0 1 *
      (matrixEntry g 1 0 * matrixEntry g 2 2 - matrixEntry g 1 2 * matrixEntry g 2 0) +
    matrixEntry g 0 2 *
      (matrixEntry g 1 0 * matrixEntry g 2 1 - matrixEntry g 1 1 * matrixEntry g 2 0)

/-- The normalized projective action on all 133 canonical points. -/
def pointAction (g : GroupIndex) (p : PointIndex) : PointIndex :=
  canonicalIndex (matrixVec g (pointVec p))

macro "q11_witness_action_norm" : tactic =>
  `(tactic|
    norm_num [pointAction, canonicalIndex, matrixVec, matrixEntry, matrixCode, pointVec,
      witnessIndex, supportPerm] <;> decide)

macro "q11_orbit_action_norm" : tactic =>
  `(tactic|
    norm_num [orbitIndex, orbitPoints, pointAction, canonicalIndex, matrixVec, matrixEntry,
      matrixCode, pointVec] <;> decide)

macro "q11_representative_orbit_norm" : tactic =>
  `(tactic|
    norm_num [pointOrbit, orbitRepresentative, orbitPoints, pointAction, canonicalIndex,
      matrixVec, matrixEntry, matrixCode, pointVec] <;> decide)

macro "q11_fixed_union_norm" : tactic =>
  `(tactic|
    norm_num [orderFiveFixedUnion, fixedPoints, OrderFive, supportPower, supportPerm,
      pointAction, canonicalIndex, matrixVec, matrixEntry, matrixCode, pointVec, witnessSet,
      witnessIndex, standardConicIndices] <;> decide)

/-- Iteration of a normalized support permutation. -/
def supportPower (g : GroupIndex) : Nat → Fin 6 → Fin 6
  | 0 => id
  | n + 1 => fun i => supportPerm g (supportPower g n i)

/-- Exact order five, using primality of five: fifth power identity but not identity. -/
def OrderFive (g : GroupIndex) : Prop :=
  (∀ i : Fin 6, supportPower g 5 i = i) ∧ ∃ i : Fin 6, supportPerm g i ≠ i

instance (g : GroupIndex) : Decidable (OrderFive g) := by
  unfold OrderFive
  infer_instance

/-- Image of one point under the 60 normalized projectivities. -/
def pointOrbit (p : PointIndex) : Finset PointIndex :=
  Finset.univ.image fun g : GroupIndex => pointAction g p

/-- Fixed points of one normalized projectivity. -/
def fixedPoints (g : GroupIndex) : Finset PointIndex :=
  Finset.univ.filter fun p => pointAction g p = p

/-- The union of fixed points of the 24 order-five elements is exactly the six-point witness plus
the twelve-point conic. -/
def orderFiveFixedUnion : Finset PointIndex :=
  ((Finset.univ : Finset GroupIndex).filter OrderFive).biUnion fixedPoints

/-! Action arithmetic is checked in the separately compiled `Q11A5PointOrbitsRows*` leaves. -/

end RelativeConicArcs.Examples.Q11A5PointOrbits
