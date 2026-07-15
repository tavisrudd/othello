import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_210 : RowResult ⟨144, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_144_211 : RowResult ⟨144, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_144_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 6)

theorem row_144_212 : RowResult ⟨144, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_144_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_144_213 : RowResult ⟨144, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_144_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_144_214 : RowResult ⟨144, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_144_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

theorem row_144_215 : RowResult ⟨144, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_144_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_216 : RowResult ⟨144, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_144_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_217 : RowResult ⟨144, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_144_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_218 : RowResult ⟨144, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_144_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 7)

theorem row_144_219 : RowResult ⟨144, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_144_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 6)

theorem row_144_220 : RowResult ⟨144, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_144_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
