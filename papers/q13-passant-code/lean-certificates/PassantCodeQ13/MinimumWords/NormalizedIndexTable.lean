import PassantCodeQ13.MinimumWords.Base

/-!
# Constant-time internal indexing of normalized representatives

`internalIndex` locates a point of `PG(2,13)` by scanning `internalCoordinateList`, so evaluating it
once per acted point makes an orbit expansion quadratic in the size of the plane.  This module
replaces the scan by a single packed lookup table.

Every normalized homogeneous representative occupies a known position in `projectiveTripleList`:
the affine representative `(1,y,z)` sits at `13 * y + z`, the representative `(0,1,z)` at
`169 + z`, and `(0,0,1)` at `182`.  `internalIndexTable` stores the internal index of the
representative at each of those 183 positions in a seven-bit field, using the value `78` — the
length of `internalCoordinateList` — for a point that is not internal, exactly as `internalIndex`
reports a failed lookup.  Reading a field is one shift and one mask on a natural number, so it
costs a fixed amount of kernel reduction independent of the plane.

The agreement of the table with `internalIndex` is checked by kernel reduction over all 183
normalized representatives, and `normalizeTriple` is proved to land among them, so the table may be
substituted wherever a point arises as the image of the projective action.  Every finite check in
this module is exhaustive over the stated domain and is discharged by kernel reduction.
-/

namespace PassantCodeQ13.MinimumWords

open RelativeConicArcs.PassantCodeQ13

/-- Position of a normalized homogeneous representative inside `projectiveTripleList`. -/
def normalizedPosition (point : Triple) : Nat :=
  if point.x = 1 then 13 * point.y.val + point.z.val
  else if point.y = 1 then 169 + point.z.val
  else 182

/-- Internal indices of all normalized representatives, packed seven bits per position. -/
def internalIndexTable : Nat :=
  projectiveTripleList.foldl
    (fun table point => table ||| internalIndex point <<< (7 * normalizedPosition point)) 0

/-- Internal index of a normalized representative, read from the packed table. -/
def tabulatedInternalIndex (point : Triple) : Nat :=
  (internalIndexTable >>> (7 * normalizedPosition point)) &&& 127

/-- The packed table reproduces the scanning index at every normalized representative. -/
theorem tabulatedInternalIndex_agrees_on_projectiveTripleList :
    projectiveTripleList.all
      (fun point => tabulatedInternalIndex point == internalIndex point) = true := by
  decide +kernel

/-- The packed table reproduces the scanning index at a normalized representative. -/
theorem tabulatedInternalIndex_eq_internalIndex {point : Triple}
    (mem : point ∈ projectiveTripleList) :
    tabulatedInternalIndex point = internalIndex point := by
  have := List.all_eq_true.mp tabulatedInternalIndex_agrees_on_projectiveTripleList point mem
  simpa using this

/-- Every affine representative is a normalized representative. -/
theorem affineTriple_mem_projectiveTripleList (y z : Field13) :
    affineTriple y z ∈ projectiveTripleList := by
  revert y z
  decide +kernel

/-- Every representative at infinity is a normalized representative. -/
theorem infiniteTriple_mem_projectiveTripleList (z : Field13) :
    infiniteTriple z ∈ projectiveTripleList := by
  revert z
  decide +kernel

/-- The vertical representative is a normalized representative. -/
theorem verticalTriple_mem_projectiveTripleList :
    verticalTriple ∈ projectiveTripleList := by
  decide +kernel

/-- Normalization lands among the normalized representatives. -/
theorem normalizeTriple_mem_projectiveTripleList (point : Triple) :
    normalizeTriple point ∈ projectiveTripleList := by
  unfold normalizeTriple
  split
  · exact affineTriple_mem_projectiveTripleList _ _
  · split
    · exact infiniteTriple_mem_projectiveTripleList _
    · exact verticalTriple_mem_projectiveTripleList

/-- The projective action lands among the normalized representatives. -/
theorem act_mem_projectiveTripleList (matrix : Matrix2) (point : Triple) :
    act matrix point ∈ projectiveTripleList :=
  normalizeTriple_mem_projectiveTripleList _

/-- Support encoding that reads each internal index from the packed table. -/
def tabulatedEncodeSupport (support : List Triple) : Nat :=
  support.foldl (fun answer point => answer ||| (1 <<< tabulatedInternalIndex point)) 0

/-- Both support encodings fold the same step over a list of normalized representatives. -/
private theorem foldl_encode_congr :
    ∀ {support : List Triple}, (∀ point ∈ support, point ∈ projectiveTripleList) →
      ∀ answer : Nat,
        support.foldl (fun answer point => answer ||| (1 <<< tabulatedInternalIndex point)) answer =
          support.foldl (fun answer point => answer ||| (1 <<< internalIndex point)) answer
  | [], _, _ => rfl
  | point :: rest, mem, answer => by
    simp only [List.foldl_cons,
      tabulatedInternalIndex_eq_internalIndex (mem point (List.mem_cons_self ..))]
    exact foldl_encode_congr (fun q hq => mem q (List.mem_cons_of_mem _ hq)) _

/-- The two encodings agree on a support of normalized representatives. -/
theorem tabulatedEncodeSupport_eq_encodeSupport (support : List Triple)
    (mem : ∀ point ∈ support, point ∈ projectiveTripleList) :
    tabulatedEncodeSupport support = encodeSupport support :=
  foldl_encode_congr mem 0

/-- Orbit of a displayed support, expanded through the packed index table. -/
def tabulatedSupportOrbit (support : List Triple) : List Nat :=
  (projectiveMatrices.map fun matrix =>
    tabulatedEncodeSupport (support.map (act matrix))).eraseDups

/-- The tabulated expansion computes the orbit. -/
theorem tabulatedSupportOrbit_eq_supportOrbit (support : List Triple) :
    tabulatedSupportOrbit support = supportOrbit support := by
  unfold tabulatedSupportOrbit supportOrbit
  congr 1
  refine List.map_congr_left fun matrix _ => ?_
  refine tabulatedEncodeSupport_eq_encodeSupport _ fun point mem => ?_
  obtain ⟨source, _, rfl⟩ := List.mem_map.mp mem
  exact act_mem_projectiveTripleList _ _

end PassantCodeQ13.MinimumWords
