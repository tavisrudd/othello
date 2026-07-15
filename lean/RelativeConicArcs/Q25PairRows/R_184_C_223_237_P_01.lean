import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_184_223 : RowResult ⟨184, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_184_224 : RowResult ⟨184, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_184_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 7)

theorem row_184_225 : RowResult ⟨184, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_184_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_184_226 : RowResult ⟨184, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_184_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_184_227 : RowResult ⟨184, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_184_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_184_228 : RowResult ⟨184, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_184_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_184_229 : RowResult ⟨184, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_184_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_184_230 : RowResult ⟨184, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_184_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_184_231 : RowResult ⟨184, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_184_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_184_232 : RowResult ⟨184, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_184_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 4 5 6)

theorem row_184_233 : RowResult ⟨184, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_184_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_184_234 : RowResult ⟨184, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_184_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 6)

theorem row_184_235 : RowResult ⟨184, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_184_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_184_236 : RowResult ⟨184, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_184_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_184_237 : RowResult ⟨184, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_184_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
