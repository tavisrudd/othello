import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_207 : RowResult ⟨90, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_90_208 : RowResult ⟨90, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_90_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_209 : RowResult ⟨90, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_90_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_90_210 : RowResult ⟨90, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_90_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 4 7)

theorem row_90_211 : RowResult ⟨90, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_90_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_212 : RowResult ⟨90, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_90_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_90_213 : RowResult ⟨90, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_90_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_214 : RowResult ⟨90, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_90_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_215 : RowResult ⟨90, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_90_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

theorem row_90_216 : RowResult ⟨90, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_90_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
