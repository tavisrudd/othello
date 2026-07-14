import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_216 : RowResult ⟨139, by decide⟩ ⟨216, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_139_217 : RowResult ⟨139, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_139_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_218 : RowResult ⟨139, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_139_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_219 : RowResult ⟨139, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_139_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 7)

theorem row_139_220 : RowResult ⟨139, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_139_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_139_221 : RowResult ⟨139, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_139_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 4 7)

theorem row_139_222 : RowResult ⟨139, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_139_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_223 : RowResult ⟨139, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_139_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_224 : RowResult ⟨139, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_139_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_225 : RowResult ⟨139, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_139_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_139_226 : RowResult ⟨139, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_139_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_139_227 : RowResult ⟨139, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_139_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_139_228 : RowResult ⟨139, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_139_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_139_229 : RowResult ⟨139, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_139_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_139_230 : RowResult ⟨139, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_139_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
