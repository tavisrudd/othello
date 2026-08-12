import TavisRuddFiniteGeom.Papers.Q13PassantCode.Geometry
import TavisRuddFiniteGeom.Certificates.Q13PassantCode.Semantic.Geometry

/-!
# Compatibility of the q=13 certificate coordinates with the paper coordinates

The certificate package and the paper development deliberately use separate
Mathlib-level implementations of the normalized conic over `ZMod 13`.  This
module gives the coordinate identification used to transport checked finite
facts into the paper namespace.  The certificate package imports no paper
module; all comparison data is confined to this downstream adapter.
-/

namespace TavisRuddFiniteGeom.Papers.Q13PassantCode.CertificateCompatibility

local notation "Certificate" => TavisRuddFiniteGeom.Certificates.Q13PassantCode.Semantic
local notation "Paper" => TavisRuddFiniteGeom.Papers.Q13PassantCode

/-- The coordinatewise identification of the two normalized triple types. -/
def tripleToCertificate : Paper.Triple → Certificate.Triple
  | ⟨x, y, z⟩ => ⟨x, y, z⟩

/-- The inverse coordinatewise identification of normalized triples. -/
def tripleToPaper : Certificate.Triple → Paper.Triple
  | ⟨x, y, z⟩ => ⟨x, y, z⟩

/-- The coordinate identification from the paper model to the certificate model is bijective. -/
theorem tripleToCertificate_bijective : Function.Bijective tripleToCertificate := by
  constructor
  · intro first second equal
    cases first
    cases second
    cases equal
    rfl
  · intro point
    refine ⟨tripleToPaper point, ?_⟩
    cases point
    rfl

/-- The fixed list of normalized projective representatives agrees coordinatewise. -/
theorem projectiveTripleList_compatibility :
    Paper.projectiveTripleList.map tripleToCertificate = Certificate.projectiveTripleList := by
  rfl

/-- The coordinate identification preserves the conic discriminant. -/
theorem pointDiscriminant_compatibility (point : Paper.Triple) :
    Certificate.pointDiscriminant (tripleToCertificate point) = Paper.pointDiscriminant point := by
  cases point
  rfl

/-- The coordinate identification preserves the dual conic discriminant. -/
theorem lineDiscriminant_compatibility (line : Paper.Triple) :
    Certificate.lineDiscriminant (tripleToCertificate line) = Paper.lineDiscriminant line := by
  cases line
  rfl

/-- The coordinate identification preserves evaluation of a dual line on a point. -/
theorem lineValue_compatibility (line point : Paper.Triple) :
    Certificate.lineValue (tripleToCertificate line) (tripleToCertificate point) =
      Paper.lineValue line point := by
  cases line
  cases point
  rfl

/-- A witness for transport of the finite coordinate, incidence, and code semantics. -/
structure TransportWitness where
  triple_bijective : Function.Bijective tripleToCertificate
  projective_list : Paper.projectiveTripleList.map tripleToCertificate = Certificate.projectiveTripleList
  point_discriminant : ∀ point, Certificate.pointDiscriminant (tripleToCertificate point) =
    Paper.pointDiscriminant point
  line_discriminant : ∀ line, Certificate.lineDiscriminant (tripleToCertificate line) =
    Paper.lineDiscriminant line
  line_value : ∀ line point, Certificate.lineValue (tripleToCertificate line)
    (tripleToCertificate point) = Paper.lineValue line point

/-- The displayed coordinate formulas supply the finite-model transport witness. -/
def transportWitness : TransportWitness where
  triple_bijective := tripleToCertificate_bijective
  projective_list := projectiveTripleList_compatibility
  point_discriminant := pointDiscriminant_compatibility
  line_discriminant := lineDiscriminant_compatibility
  line_value := lineValue_compatibility

end TavisRuddFiniteGeom.Papers.Q13PassantCode.CertificateCompatibility
