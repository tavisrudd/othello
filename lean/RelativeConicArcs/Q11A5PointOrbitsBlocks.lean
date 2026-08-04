import RelativeConicArcs.Q11BrianchonPetersen

/-!
# Displayed point blocks for the order-eleven Clebsch witness

Points of `PG(2,11)` are indexed canonically by `Fin 133`: index `p < 121` is `[1 : y : z]` with
`y = p / 11` and `z = p % 11`, index `121 ≤ p < 132` is `[0 : 1 : p - 121]`, and index `132` is
`[0 : 0 : 1]`.  `pointVec` realizes that dictionary and `canonicalIndex` inverts it on nonzero
homogeneous vectors.

This module displays the seven point blocks of the plane in that indexing, together with the
six-element witness index set, the twelve-element standard-conic index set, and the embedding of
affine Brianchon codes into canonical indices.  The blocks are displayed rather than computed:
recording them explicitly avoids the large kernel term produced by repeatedly constructing and
deduplicating images of the 133 canonical points.

What is proved here and in the accompanying block theorems is finite combinatorics of the displayed
sets — that they partition the plane with the recorded sizes, and which block is the witness, the
conic, and the Brianchon set.  That these blocks are precisely the orbits of the icosahedral `A5`
action on `PG(2,11)` is an exhaustive verification over sixty explicit projectivities, checked in
the separately versioned order-eleven certificate library and consumed here as a pinned trust fact;
no declaration in this module depends on it.
-/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

open Q11Coding

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

abbrev Scalar := ZMod 11
abbrev Vec3 := Fin 3 → Scalar
abbrev PointIndex := Fin 133

/-- Canonical representatives `[1:y:z]`, `[0:1:z]`, `[0:0:1]`. -/
def pointVec (p : PointIndex) : Vec3 :=
  if _ : p.1 < 121 then
    ![1, ((p.1 / 11 : ℕ) : Scalar), ((p.1 % 11 : ℕ) : Scalar)]
  else if _ : p.1 < 132 then ![0, 1, ((p.1 - 121 : ℕ) : Scalar)]
  else ![0, 0, 1]

/-- Convert a homogeneous vector to the canonical point index.  The final branch also makes the
function total at zero; the certificate library verifies that this branch is never used by the
normalized projective action on the 133 canonical representatives. -/
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

/-- The six witness directions in canonical point indexing. -/
def witnessIndex (i : Fin 6) : PointIndex := ![110, 100, 51, 93, 125, 18] i

def witnessSet : Finset PointIndex := Finset.univ.image witnessIndex

/-- Representatives of the seven point blocks, ordered by first canonical index. -/
def orbitRepresentative (i : Fin 7) : PointIndex := ![0, 1, 2, 3, 4, 6, 18] i

def orbitSize (i : Fin 7) : Nat := ![12, 30, 30, 10, 15, 30, 6] i

/-- The seven point blocks in canonical indexing. -/
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

/-- The block label of a canonical point.  The last block is the default; the partition theorem
verifies that the preceding tests and this default cover exactly one block. -/
def orbitIndex (p : PointIndex) : Fin 7 :=
  if p ∈ orbitPoints 0 then 0
  else if p ∈ orbitPoints 1 then 1
  else if p ∈ orbitPoints 2 then 2
  else if p ∈ orbitPoints 3 then 3
  else if p ∈ orbitPoints 4 then 4
  else if p ∈ orbitPoints 5 then 5
  else 6

/-- Canonical indices of the standard conic `XZ-Y^2=0`. -/
def standardConicIndices : Finset PointIndex :=
  {0, 12, 26, 42, 49, 58, 69, 82, 97, 103, 111, 132}

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
