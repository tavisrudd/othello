import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_186_218 : RowResult ⟨186, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_219 : RowResult ⟨186, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_186_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 7)

theorem row_186_220 : RowResult ⟨186, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_186_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_186_221 : RowResult ⟨186, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_186_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_222 : RowResult ⟨186, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_186_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_223 : RowResult ⟨186, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_186_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_186_224 : RowResult ⟨186, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_186_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_186_225 : RowResult ⟨186, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_186_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_186_226 : RowResult ⟨186, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_186_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_186_227 : RowResult ⟨186, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_186_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_186_228 : RowResult ⟨186, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_186_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_186_229 : RowResult ⟨186, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_186_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_186_230 : RowResult ⟨186, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_186_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_186_231 : RowResult ⟨186, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_186_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
