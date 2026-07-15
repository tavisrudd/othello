import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_167_210 : RowResult ⟨167, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_211 : RowResult ⟨167, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_167_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 4 6)

theorem row_167_212 : RowResult ⟨167, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_167_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 7)

theorem row_167_213 : RowResult ⟨167, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_167_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_167_214 : RowResult ⟨167, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_167_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_215 : RowResult ⟨167, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_167_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 4 5 6)

theorem row_167_216 : RowResult ⟨167, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_167_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_167_217 : RowResult ⟨167, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_167_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 6)

theorem row_167_218 : RowResult ⟨167, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_167_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_167_219 : RowResult ⟨167, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_167_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_220 : RowResult ⟨167, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_167_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
