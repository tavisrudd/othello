import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_184_213 : RowResult ⟨184, by decide⟩ ⟨213, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_184_214 : RowResult ⟨184, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_184_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_184_215 : RowResult ⟨184, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_184_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_184_216 : RowResult ⟨184, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_184_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_184_217 : RowResult ⟨184, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_184_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 4 5 6)

theorem row_184_218 : RowResult ⟨184, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_184_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_184_219 : RowResult ⟨184, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_184_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 4 6)

theorem row_184_220 : RowResult ⟨184, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_184_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_184_221 : RowResult ⟨184, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_184_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_184_222 : RowResult ⟨184, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_184_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
