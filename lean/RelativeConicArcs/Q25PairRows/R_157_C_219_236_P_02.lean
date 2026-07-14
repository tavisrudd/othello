import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_157_219 : RowResult ⟨157, by decide⟩ ⟨219, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_157_220 : RowResult ⟨157, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_157_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_157_221 : RowResult ⟨157, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_157_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_157_222 : RowResult ⟨157, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_157_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 7)

theorem row_157_223 : RowResult ⟨157, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_157_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_157_224 : RowResult ⟨157, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_157_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_157_225 : RowResult ⟨157, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_157_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_157_226 : RowResult ⟨157, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_157_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_157_227 : RowResult ⟨157, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_157_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_157_228 : RowResult ⟨157, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_157_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_157_229 : RowResult ⟨157, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_157_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_157_230 : RowResult ⟨157, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_157_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_157_231 : RowResult ⟨157, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_157_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 4 7)

theorem row_157_232 : RowResult ⟨157, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_157_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

theorem row_157_233 : RowResult ⟨157, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_157_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 6)

theorem row_157_234 : RowResult ⟨157, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_157_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 7)

theorem row_157_235 : RowResult ⟨157, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_157_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_157_236 : RowResult ⟨157, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_157_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
