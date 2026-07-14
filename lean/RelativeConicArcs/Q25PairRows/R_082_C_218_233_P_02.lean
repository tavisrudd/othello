import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_218 : RowResult ⟨82, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_219 : RowResult ⟨82, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_82_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_82_220 : RowResult ⟨82, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_82_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_82_221 : RowResult ⟨82, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_82_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_222 : RowResult ⟨82, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_82_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 7)

theorem row_82_223 : RowResult ⟨82, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_82_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_224 : RowResult ⟨82, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_82_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_82_225 : RowResult ⟨82, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_82_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_82_226 : RowResult ⟨82, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_82_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_82_227 : RowResult ⟨82, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_82_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_82_228 : RowResult ⟨82, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_82_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_82_229 : RowResult ⟨82, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_82_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_82_230 : RowResult ⟨82, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_82_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_82_231 : RowResult ⟨82, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_82_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 4 5 6)

theorem row_82_232 : RowResult ⟨82, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_82_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

theorem row_82_233 : RowResult ⟨82, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_82_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
