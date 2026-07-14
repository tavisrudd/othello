import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_218 : RowResult ⟨73, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_219 : RowResult ⟨73, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_73_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_73_220 : RowResult ⟨73, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_73_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_73_221 : RowResult ⟨73, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_73_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_222 : RowResult ⟨73, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_73_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_223 : RowResult ⟨73, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_73_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 6)

theorem row_73_224 : RowResult ⟨73, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_73_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 6)

theorem row_73_225 : RowResult ⟨73, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_73_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_73_226 : RowResult ⟨73, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_73_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_73_227 : RowResult ⟨73, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_73_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_73_228 : RowResult ⟨73, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_73_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_73_229 : RowResult ⟨73, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_73_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_73_230 : RowResult ⟨73, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_73_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_73_231 : RowResult ⟨73, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_73_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_232 : RowResult ⟨73, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_73_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_233 : RowResult ⟨73, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_73_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 7)

theorem row_73_234 : RowResult ⟨73, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_73_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
