import RelativeConicArcs.Q25ResidualCoverData.Schema

/-!
# Semantic bridge for the C151 residual-cover payload

The generated residual-cover tree stores compact coordinate witnesses.  This handwritten layer
states what those records mean and connects them to the existing projective cap and residual-action
theorems.  In particular, the stored `legalCount`, `classIndex`, and `orbitSize` fields are not used
as proof inputs here.
-/

namespace RelativeConicArcs
namespace Q25ResidualCoverData

open Q25Coordinates Q25PairCertificate Q25Normalization Q25MinimumMask Q25ResidualAction
  FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

/-- The normalized row with fixed first orbit number `5`. -/
def rowConfig (b c : Fin 310) : Finset Idx25 :=
  normalizedConfig (orbitCodeOfNumber ⟨5, by decide⟩)
    (orbitCodeOfNumber b) (orbitCodeOfNumber c)

/-- The normalized representative named by a valid transport payload. -/
def ValidRowPayload.canonicalConfig (p : ValidRowPayload) : Finset Idx25 :=
  rowConfig p.canonicalB p.canonicalC

/-- A bad-row payload names a concrete collinear triple in its normalized row. -/
def BadRowPayload.Valid (b : Fin 310) (p : BadRowPayload) : Prop :=
  BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩)
    (orbitCodeOfNumber b) (orbitCodeOfNumber p.c) p.i p.j p.k

instance (b : Fin 310) (p : BadRowPayload) : Decidable (p.Valid b) := by
  unfold BadRowPayload.Valid
  infer_instance

theorem BadRowPayload.not_rawCap {b : Fin 310} {p : BadRowPayload}
    (h : p.Valid b) : ¬ RawCap (rowConfig b p.c) := by
  exact not_rawCap_of_badWitness h

/-- Executable source-to-canonical residual transport claimed by a valid-row payload. -/
def ValidRowPayload.TransportValid (b : Fin 310) (p : ValidRowPayload) : Prop :=
  imagPart p.y ≠ 0 ∧ imagPart p.z ≠ 0 ∧
    (rowConfig b p.c).image (residualApply p.y p.z) = p.canonicalConfig

instance (b : Fin 310) (p : ValidRowPayload) : Decidable (p.TransportValid b) := by
  unfold ValidRowPayload.TransportValid
  infer_instance

theorem ValidRowPayload.map_eq_canonicalConfig {b : Fin 310} {p : ValidRowPayload}
    (h : p.TransportValid b) :
    (rowConfig b p.c).map (residualEmbedding p.y p.z h.1 h.2.1) = p.canonicalConfig := by
  rw [Finset.map_eq_image]
  exact h.2.2

theorem ValidRowPayload.canonical_rawCap {b : Fin 310} {p : ValidRowPayload}
    (h : p.TransportValid b) (hsource : RawCap (rowConfig b p.c)) :
    RawCap p.canonicalConfig := by
  rw [← ValidRowPayload.map_eq_canonicalConfig h]
  exact (rawCap_map_residualEmbedding p.y p.z h.1 h.2.1 _).2 hsource

/-- A checked residual transporter preserves the exact legal-orbit cardinality. -/
theorem ValidRowPayload.legalCard_eq {b : Fin 310} {p : ValidRowPayload}
    (h : p.TransportValid b) (hsource : RawCap (rowConfig b p.c)) :
    (legalOrbitSet (rowConfig b p.c)).card = (legalOrbitSet p.canonicalConfig).card := by
  exact card_legalOrbitSet_residual p.y p.z h.1 h.2.1
    (ValidRowPayload.map_eq_canonicalConfig h) hsource
    (ValidRowPayload.canonical_rawCap h hsource)

/-- The third orbit number carried by either kind of residual row. -/
def ResidualRowPayload.c : ResidualRowPayload → Fin 310
  | .bad p => p.c
  | .valid p => p.c

/-- The semantic certificate proposition attached to either payload constructor. -/
def ResidualRowPayload.ValidFor (b : Fin 310) : ResidualRowPayload → Prop
  | .bad p => p.Valid b
  | .valid p => p.TransportValid b

instance (b : Fin 310) (p : ResidualRowPayload) : Decidable (p.ValidFor b) := by
  cases p <;> simp only [ResidualRowPayload.ValidFor] <;> infer_instance

end Q25ResidualCoverData
end RelativeConicArcs
