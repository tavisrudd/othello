import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_220 : RowResult ⟨119, by decide⟩ ⟨220, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_119_221 : RowResult ⟨119, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_119_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_222 : RowResult ⟨119, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_119_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_223 : RowResult ⟨119, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_119_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_224 : RowResult ⟨119, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_119_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 4 7)

theorem row_119_225 : RowResult ⟨119, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_119_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_119_226 : RowResult ⟨119, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_119_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_119_227 : RowResult ⟨119, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_119_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_119_228 : RowResult ⟨119, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_119_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_119_229 : RowResult ⟨119, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_119_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_119_230 : RowResult ⟨119, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_119_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_119_231 : RowResult ⟨119, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_119_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_119_232 : RowResult ⟨119, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_119_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 7)

theorem row_119_233 : RowResult ⟨119, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_119_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_119_234 : RowResult ⟨119, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_119_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_119_235 : RowResult ⟨119, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_119_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
