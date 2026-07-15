import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_165_207 : RowResult ⟨165, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_165_208 : RowResult ⟨165, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_165_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_165_209 : RowResult ⟨165, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_165_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_165_210 : RowResult ⟨165, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_165_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 4 7)

theorem row_165_211 : RowResult ⟨165, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_165_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_165_212 : RowResult ⟨165, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_165_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_165_213 : RowResult ⟨165, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_165_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_165_214 : RowResult ⟨165, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_165_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_165_215 : RowResult ⟨165, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_165_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

theorem row_165_216 : RowResult ⟨165, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_165_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
