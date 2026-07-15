import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_213 : RowResult ⟨61, by decide⟩ ⟨213, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_61_214 : RowResult ⟨61, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_61_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_61_215 : RowResult ⟨61, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_61_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 7)

theorem row_61_216 : RowResult ⟨61, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_61_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 7)

theorem row_61_217 : RowResult ⟨61, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_61_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 6)

theorem row_61_218 : RowResult ⟨61, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_61_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_219 : RowResult ⟨61, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_61_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_220 : RowResult ⟨61, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_61_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_61_221 : RowResult ⟨61, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_61_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_61_222 : RowResult ⟨61, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_61_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
