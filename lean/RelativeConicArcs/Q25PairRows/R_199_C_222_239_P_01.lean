import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_199_222 : RowResult ⟨199, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_199_223 : RowResult ⟨199, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_199_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 6)

theorem row_199_224 : RowResult ⟨199, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_199_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 6)

theorem row_199_225 : RowResult ⟨199, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_199_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_199_226 : RowResult ⟨199, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_199_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_199_227 : RowResult ⟨199, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_199_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_199_228 : RowResult ⟨199, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_199_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_199_229 : RowResult ⟨199, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_199_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_199_230 : RowResult ⟨199, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_199_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_199_231 : RowResult ⟨199, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_199_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_199_232 : RowResult ⟨199, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_199_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 6)

theorem row_199_233 : RowResult ⟨199, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_199_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_199_234 : RowResult ⟨199, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_199_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 7)

theorem row_199_235 : RowResult ⟨199, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_199_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_199_236 : RowResult ⟨199, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_199_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 7)

theorem row_199_237 : RowResult ⟨199, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_199_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_199_238 : RowResult ⟨199, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_199_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_199_239 : RowResult ⟨199, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_199_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
