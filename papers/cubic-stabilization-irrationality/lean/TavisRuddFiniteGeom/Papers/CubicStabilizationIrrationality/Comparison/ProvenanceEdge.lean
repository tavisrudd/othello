import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Dependent provenance for crossed-edge outputs

For an upper-triangular crossed edge, a target common value can arise either
from the native common map or from the crossed moving map. The provenance
witness below is indexed by the actual target value. Reclassifying a native
output as moving-produced therefore requires a genuine moving source whose
crossed image is that same value; changing a phantom tag is insufficient.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProvenanceEdge

open FixedPhaseReader

universe uι uR uC₀ uC₁ uM₀ uM₁

variable
    {R : Type uR} [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]

/-- Evidence that a particular target common value arose through one of the
two named component maps of a crossed edge. -/
inductive CommonOutput
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) : C₁ → Type _
  | native (x : C₀) : CommonOutput edge (edge.commonMap x)
  | fromMoving (x : M₀) : CommonOutput edge (edge.crossedMap x)

/-- A target common value paired with map-indexed provenance evidence. -/
def WitnessedCommonOutput
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) :=
  Σ value, CommonOutput edge value

/-- Construct the witnessed output of a native common input. -/
def nativeOutput
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) (x : C₀) :
    WitnessedCommonOutput edge :=
  ⟨edge.commonMap x, CommonOutput.native x⟩

/-- Construct the witnessed common output of a moving input. -/
def movingOutput
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) (x : M₀) :
    WitnessedCommonOutput edge :=
  ⟨edge.crossedMap x, CommonOutput.fromMoving x⟩

/-- The underlying target value of a witnessed common output. -/
def WitnessedCommonOutput.value
    {edge : CrossedEdge R source target C₀ C₁ M₀ M₁}
    (output : WitnessedCommonOutput edge) : C₁ :=
  output.1

@[simp]
theorem nativeOutput_value
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) (x : C₀) :
    (nativeOutput edge x).value = edge.commonMap x :=
  rfl

@[simp]
theorem movingOutput_value
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) (x : M₀) :
    (movingOutput edge x).value = edge.crossedMap x :=
  rfl

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProvenanceEdge
