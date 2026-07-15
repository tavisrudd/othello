import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_224 : RowResult ⟨40, by decide⟩ ⟨224, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_225 : RowResult ⟨40, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_40_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_40_226 : RowResult ⟨40, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_40_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_40_227 : RowResult ⟨40, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_40_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_40_228 : RowResult ⟨40, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_40_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_40_229 : RowResult ⟨40, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_40_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_40_230 : RowResult ⟨40, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_40_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_40_231 : RowResult ⟨40, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_40_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_40_232 : RowResult ⟨40, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_40_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_40_233 : RowResult ⟨40, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_40_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_40_234 : RowResult ⟨40, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_40_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_40_235 : RowResult ⟨40, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_40_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 7)

theorem row_40_236 : RowResult ⟨40, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_40_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
