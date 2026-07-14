import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_212 : RowResult ⟨38, by decide⟩ ⟨212, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_213 : RowResult ⟨38, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_38_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 6)

theorem row_38_214 : RowResult ⟨38, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_38_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 6)

theorem row_38_215 : RowResult ⟨38, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_38_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_216 : RowResult ⟨38, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_38_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 7)

theorem row_38_217 : RowResult ⟨38, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_38_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_218 : RowResult ⟨38, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_38_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 7)

theorem row_38_219 : RowResult ⟨38, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_38_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_220 : RowResult ⟨38, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_38_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_38_221 : RowResult ⟨38, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_38_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_38_222 : RowResult ⟨38, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_38_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
