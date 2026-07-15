import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_106_207 : RowResult ⟨106, by decide⟩ ⟨207, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 6)

theorem row_106_208 : RowResult ⟨106, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_106_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 4 5 6)

theorem row_106_209 : RowResult ⟨106, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_106_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_106_210 : RowResult ⟨106, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_106_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_211 : RowResult ⟨106, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_106_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_212 : RowResult ⟨106, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_106_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_106_213 : RowResult ⟨106, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_106_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_106_214 : RowResult ⟨106, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_106_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_106_215 : RowResult ⟨106, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_106_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_216 : RowResult ⟨106, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_106_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
