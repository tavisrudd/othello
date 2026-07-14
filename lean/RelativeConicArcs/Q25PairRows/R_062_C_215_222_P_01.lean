import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_215 : RowResult ⟨62, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_216 : RowResult ⟨62, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_62_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_62_217 : RowResult ⟨62, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_62_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 7)

theorem row_62_218 : RowResult ⟨62, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_62_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_62_219 : RowResult ⟨62, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_62_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_220 : RowResult ⟨62, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_62_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_62_221 : RowResult ⟨62, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_62_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_222 : RowResult ⟨62, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_62_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
