import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_216 : RowResult ⟨123, by decide⟩ ⟨216, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨42, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_123_217 : RowResult ⟨123, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_123_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_218 : RowResult ⟨123, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_123_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_219 : RowResult ⟨123, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_123_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_220 : RowResult ⟨123, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_123_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_123_221 : RowResult ⟨123, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_123_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 4 5 6)

theorem row_123_222 : RowResult ⟨123, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_123_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_123_223 : RowResult ⟨123, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_123_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
