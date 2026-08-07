import PassantCodeQ13.MinimumWords.Reconstruction
import RelativeConicArcs.PassantCodeQ13.Reconstruction

/-!
# Decoded supports and the displayed order of the internal points

The four projective minimum-word orbits are carried as `78`-bit codes, one bit per internal-point
index.  This module decodes such a code into the semantic internal-point type, forms the decoded
hypergraph of the four orbits, and fixes the dictionary between the two presentations of a finite
set of internal points: the displayed order lists the points of a set by increasing index, and the
displayed index of a point is its position in that order.

One executable test on the semantic type is defined here and identified with its semantic meaning
elsewhere: the concurrence count of a triple in the encoded minimum-word family.  The property `GeometricRowsHaveZeroTripleConcurrence` names the
statement that no decoded minimum-word support contains three points of a passant row.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open Finset
open RelativeConicArcs.PassantCodeQ13

/-- Decode a 78-bit support into the normalized semantic internal-point type. -/
def decodedSupport (support : Nat) : Finset InternalPoint :=
  (Finset.univ.filter fun index : Fin 78 => support.testBit index.1).image internalPointAt

/-- Bit membership in an encoded support is semantic membership after decoding. -/
theorem mem_decodedSupport (support : Nat) (index : Fin 78) :
    internalPointAt index ∈ decodedSupport support ↔ support.testBit index.1 = true := by
  constructor
  · intro membership
    obtain ⟨sourceIndex, source_mem, equality⟩ := Finset.mem_image.mp membership
    have source_eq : sourceIndex = index := internalPointAt_bijective.injective equality
    subst sourceIndex
    exact (Finset.mem_filter.mp source_mem).2
  · intro bit
    exact Finset.mem_image.mpr
      ⟨index, Finset.mem_filter.mpr ⟨Finset.mem_univ _, bit⟩, rfl⟩

/-- The semantic support hypergraph formed by the four displayed projective orbits. -/
def semanticMinimumSupports : Finset (Finset InternalPoint) :=
  minimumSupportCodes.toFinset.image decodedSupport

/-- The semantic internal points in the fixed displayed order. -/
def internalPointOrder : List InternalPoint :=
  List.ofFn internalPointAt

/-- The displayed semantic point order has no repetitions. -/
theorem internalPointOrder_nodup : internalPointOrder.Nodup := by
  rw [internalPointOrder, List.nodup_ofFn]
  exact internalPointAt_bijective.injective

/-- Restrict the displayed point order to a finite vertex set. -/
def verticesInOrder (vertices : Finset InternalPoint) : List InternalPoint :=
  internalPointOrder.filter fun point => point ∈ vertices

/-- Restricting the displayed order recovers the original finite set. -/
theorem verticesInOrder_toFinset (vertices : Finset InternalPoint) :
    (verticesInOrder vertices).toFinset = vertices := by
  ext point
  have point_mem : point ∈ internalPointOrder := by
    rw [internalPointOrder, List.mem_ofFn']
    exact internalPointAt_bijective.surjective point
  simp [verticesInOrder, point_mem]

/-- Restriction of the displayed order has no repetitions. -/
theorem verticesInOrder_nodup (vertices : Finset InternalPoint) :
    (verticesInOrder vertices).Nodup :=
  internalPointOrder_nodup.filter _

/-- The restricted displayed list has the cardinality of its finite set. -/
theorem verticesInOrder_length (vertices : Finset InternalPoint) :
    (verticesInOrder vertices).length = vertices.card := by
  have card_identity := List.card_toFinset (l := verticesInOrder vertices)
  rw [List.dedup_eq_self.mpr (verticesInOrder_nodup vertices),
    verticesInOrder_toFinset] at card_identity
  exact card_identity.symm

@[simp] theorem mem_verticesInOrder (point : InternalPoint) (vertices : Finset InternalPoint) :
    point ∈ verticesInOrder vertices ↔ point ∈ vertices := by
  rw [← List.mem_toFinset, verticesInOrder_toFinset]

/-- Displayed index of a semantic internal point. -/
def internalPointIndex (point : InternalPoint) : Nat :=
  internalPointOrder.idxOf point

/-- The displayed semantic point at an index has that same executable index. -/
theorem internalPointIndex_internalPointAt (index : Fin 78) :
    internalPointIndex (internalPointAt index) = index.1 := by
  let listIndex : Fin internalPointOrder.length :=
    Fin.cast (by simp [internalPointOrder]) index
  have point_eq : internalPointOrder.get listIndex = internalPointAt index := by
    change (List.ofFn internalPointAt).get listIndex = internalPointAt index
    rw [List.get_ofFn]
    apply congrArg internalPointAt
    apply Fin.ext
    rfl
  have indexed := List.get_idxOf internalPointOrder_nodup listIndex
  rw [point_eq] at indexed
  simpa [listIndex, internalPointIndex] using indexed

/-- Executable minimum-layer triple concurrence through displayed point indices. -/
def indexedTripleConcurrence (first second third : InternalPoint) : Nat :=
  tripleConcurrenceIn minimumSupportCodes (internalPointIndex first)
    (internalPointIndex second) (internalPointIndex third)

/-- Every geometric passant row has zero concurrence on its triples in the decoded minimum layer. -/
def GeometricRowsHaveZeroTripleConcurrence : Prop :=
  ∀ line : PassantLine, ∀ first second third : InternalPoint,
    Incident line first → Incident line second → Incident line third →
      first ≠ second → first ≠ third → second ≠ third →
      RelativeConicArcs.ConicPassantCode.tripleConcurrence
        semanticMinimumSupports first second third = 0

end PassantCodeQ13.MinimumWords.RowUniqueness
