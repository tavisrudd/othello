import RelativeConicArcs.Q11BrianchonPetersen

/-!
# Data for the finite A5 point-orbit bridge for the Clebsch hexagon

This base module records sixty normalized projective matrices over `F_11`,
the canonical 133 representatives of `PG(2,11)`, and the explicit orbit
data.  The bounded matrix, support, row, and fixed-point modules verify by
kernel reduction that these matrices are invertible, preserve the displayed
six-arc, act on every projective point as recorded, and have the stated fixed
sets.

This is a finite bridge, not the pencil-and-paper derivation that the projective stabilizer is the
icosahedral `A5` representation.  Every finite assertion uses kernel-checked `norm_num` or ordinary
`decide`; there is no `native_decide`, external oracle, or new axiom.
-/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

open Q11Coding

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

abbrev Scalar := ZMod 11
abbrev Vec3 := Fin 3 → Scalar
abbrev PointIndex := Fin 133
abbrev GroupIndex := Fin 60
abbrev MatrixCode := Fin 9 → Fin 11

/-- Canonical representatives `[1:y:z]`, `[0:1:z]`, `[0:0:1]`. -/
def pointVec (p : PointIndex) : Vec3 :=
  if _ : p.1 < 121 then
    ![1, ((p.1 / 11 : ℕ) : Scalar), ((p.1 % 11 : ℕ) : Scalar)]
  else if _ : p.1 < 132 then ![0, 1, ((p.1 - 121 : ℕ) : Scalar)]
  else ![0, 0, 1]

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

/-- Convert a homogeneous vector to the canonical point index.  The final branch also makes the
function total at zero; `matrixVec_pointVec_ne_zero` below verifies that this branch is never used
by the normalized projective action on the 133 canonical representatives. -/
def canonicalIndex (v : Vec3) : PointIndex :=
  if h0 : v 0 ≠ 0 then
    let y := v 1 / v 0
    let z := v 2 / v 0
    ⟨y.val * 11 + z.val, by have hy := y.val_lt; have hz := z.val_lt; omega⟩
  else if h1 : v 1 ≠ 0 then
    let z := v 2 / v 1
    ⟨121 + z.val, by have hz := z.val_lt; omega⟩
  else
    132

/-- The normalized projective action on all 133 canonical points. -/
def pointAction (g : GroupIndex) (p : PointIndex) : PointIndex :=
  canonicalIndex (matrixVec g (pointVec p))

/-- The six witness directions in canonical point indexing. -/
def witnessIndex (i : Fin 6) : PointIndex := ![110, 100, 51, 93, 125, 18] i

def witnessSet : Finset PointIndex := Finset.univ.image witnessIndex

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

/-- Representatives of the seven point orbits, ordered by first canonical index. -/
def orbitRepresentative (i : Fin 7) : PointIndex := ![0, 1, 2, 3, 4, 6, 18] i

def orbitSize (i : Fin 7) : Nat := ![12, 30, 30, 10, 15, 30, 6] i

/-- The seven point-orbit blocks in canonical indexing.  Recording the blocks explicitly avoids
the large kernel term produced by repeatedly constructing and deduplicating 133-element images. -/
def orbitPoints (i : Fin 7) : Finset PointIndex :=
  ![
    {0, 12, 26, 42, 49, 58, 69, 82, 97, 103, 111, 132},
    {1, 5, 13, 15, 16, 21, 34, 35, 50, 52, 53, 54, 61, 63, 67,
      73, 80, 83, 89, 91, 95, 98, 101, 104, 107, 108, 114, 115, 116, 120},
    {2, 7, 8, 14, 19, 33, 37, 41, 44, 46, 57, 60, 65, 66, 68,
      75, 77, 78, 79, 92, 96, 102, 105, 118, 119, 121, 122, 124, 127, 131},
    {3, 9, 36, 40, 59, 62, 70, 72, 86, 87},
    {4, 17, 24, 27, 29, 30, 31, 43, 47, 56, 74, 85, 90, 106, 112},
    {6, 10, 11, 20, 22, 23, 25, 28, 32, 38, 39, 45, 48, 55, 64,
      71, 76, 81, 84, 88, 94, 99, 109, 113, 117, 123, 126, 128, 129, 130},
    {18, 51, 93, 100, 110, 125}
  ] i

/-- The block label of a canonical point.  The last block is the default; the partition
certificate below verifies that the preceding tests and this default cover exactly one block. -/
def orbitIndex (p : PointIndex) : Fin 7 :=
  if p ∈ orbitPoints 0 then 0
  else if p ∈ orbitPoints 1 then 1
  else if p ∈ orbitPoints 2 then 2
  else if p ∈ orbitPoints 3 then 3
  else if p ∈ orbitPoints 4 then 4
  else if p ∈ orbitPoints 5 then 5
  else 6

/-- Image of one point under the 60 normalized projectivities. -/
def pointOrbit (p : PointIndex) : Finset PointIndex :=
  Finset.univ.image fun g : GroupIndex => pointAction g p

/-! Action arithmetic is checked in the separately compiled `Q11A5PointOrbitsRows*` leaves. -/





























































/-- Canonical indices of the standard conic `XZ-Y^2=0`. -/
def standardConicIndices : Finset PointIndex :=
  {0, 12, 26, 42, 49, 58, 69, 82, 97, 103, 111, 132}

/-- Fixed points of one normalized projectivity. -/
def fixedPoints (g : GroupIndex) : Finset PointIndex :=
  Finset.univ.filter fun p => pointAction g p = p

/-- The union of fixed points of the 24 order-five elements is exactly the six-point witness plus
the twelve-point conic. -/
def orderFiveFixedUnion : Finset PointIndex :=
  ((Finset.univ : Finset GroupIndex).filter OrderFive).biUnion fixedPoints

/-- Embed an affine `(y,z)` code as the canonical index of `[1:y:z]`. -/
def codeIndex (p : Q11BrianchonPetersen.AffinePointCode) : PointIndex :=
  ⟨p.1.1 * 11 + p.2.1, by have hy := p.1.2; have hz := p.2.2; omega⟩

theorem codeIndex_injective : Function.Injective codeIndex := by
  intro a b h
  have hv := congrArg Fin.val h
  change a.1.1 * 11 + a.2.1 = b.1.1 * 11 + b.2.1 at hv
  have ha := a.1.2
  have hb := b.1.2
  have hza := a.2.2
  have hzb := b.2.2
  apply Prod.ext <;> apply Fin.ext
  · omega
  · omega

def codeEmbedding : Q11BrianchonPetersen.AffinePointCode ↪ PointIndex :=
  ⟨codeIndex, codeIndex_injective⟩

def brianchonSet : Finset PointIndex :=
  Q11BrianchonPetersen.brianchonPointCodes.map codeEmbedding

def triplePointSet : Finset PointIndex :=
  Q11BrianchonPetersen.tripleChordIntersectionCodes.map codeEmbedding

end RelativeConicArcs.Examples.Q11A5PointOrbits
