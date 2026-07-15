import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_182_218 : RowResult ⟨182, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_182_219 : RowResult ⟨182, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_182_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_182_220 : RowResult ⟨182, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_182_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_182_221 : RowResult ⟨182, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_182_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 4 7)

theorem row_182_222 : RowResult ⟨182, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_182_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 7)

theorem row_182_223 : RowResult ⟨182, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_182_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_182_224 : RowResult ⟨182, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_182_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_182_225 : RowResult ⟨182, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_182_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_182_226 : RowResult ⟨182, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_182_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_182_227 : RowResult ⟨182, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_182_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_182_228 : RowResult ⟨182, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_182_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_182_229 : RowResult ⟨182, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_182_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_182_230 : RowResult ⟨182, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_182_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_182_231 : RowResult ⟨182, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_182_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 7)

theorem row_182_232 : RowResult ⟨182, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_182_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

theorem row_182_233 : RowResult ⟨182, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_182_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_182_234 : RowResult ⟨182, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_182_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
