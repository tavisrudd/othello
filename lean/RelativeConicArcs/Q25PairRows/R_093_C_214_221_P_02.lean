import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_214 : RowResult ⟨93, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_93_215 : RowResult ⟨93, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_93_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_216 : RowResult ⟨93, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_93_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_217 : RowResult ⟨93, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_93_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_93_218 : RowResult ⟨93, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_93_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 6)

theorem row_93_219 : RowResult ⟨93, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_93_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_220 : RowResult ⟨93, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_93_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_93_221 : RowResult ⟨93, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_93_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
