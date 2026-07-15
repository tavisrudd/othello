import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_208 : RowResult ⟨81, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_209 : RowResult ⟨81, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_81_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_81_210 : RowResult ⟨81, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_81_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_81_211 : RowResult ⟨81, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_81_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_81_212 : RowResult ⟨81, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_81_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_81_213 : RowResult ⟨81, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_81_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_81_214 : RowResult ⟨81, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_81_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 7)

theorem row_81_215 : RowResult ⟨81, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_81_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 4 5 6)

theorem row_81_216 : RowResult ⟨81, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_81_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_217 : RowResult ⟨81, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_81_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
