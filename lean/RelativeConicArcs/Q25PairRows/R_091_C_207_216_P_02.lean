import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_207 : RowResult ⟨91, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_91_208 : RowResult ⟨91, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_91_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_209 : RowResult ⟨91, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_91_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_91_210 : RowResult ⟨91, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_91_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_211 : RowResult ⟨91, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_91_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 7)

theorem row_91_212 : RowResult ⟨91, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_91_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 6)

theorem row_91_213 : RowResult ⟨91, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_91_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_91_214 : RowResult ⟨91, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_91_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_91_215 : RowResult ⟨91, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_91_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_91_216 : RowResult ⟨91, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_91_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
