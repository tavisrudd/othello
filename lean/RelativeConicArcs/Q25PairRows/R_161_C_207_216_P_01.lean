import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_161_207 : RowResult ⟨161, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_161_208 : RowResult ⟨161, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_161_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_161_209 : RowResult ⟨161, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_161_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_161_210 : RowResult ⟨161, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_161_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_161_211 : RowResult ⟨161, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_161_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 6)

theorem row_161_212 : RowResult ⟨161, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_161_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_161_213 : RowResult ⟨161, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_161_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 4 5 6)

theorem row_161_214 : RowResult ⟨161, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_161_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_161_215 : RowResult ⟨161, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_161_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_161_216 : RowResult ⟨161, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_161_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
