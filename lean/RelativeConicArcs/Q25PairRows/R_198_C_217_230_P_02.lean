import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_198_217 : RowResult ⟨198, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_218 : RowResult ⟨198, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_198_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_219 : RowResult ⟨198, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_198_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_198_220 : RowResult ⟨198, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_198_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_198_221 : RowResult ⟨198, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_198_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_222 : RowResult ⟨198, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_198_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_223 : RowResult ⟨198, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_198_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 6)

theorem row_198_224 : RowResult ⟨198, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_198_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_198_225 : RowResult ⟨198, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_198_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_198_226 : RowResult ⟨198, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_198_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_198_227 : RowResult ⟨198, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_198_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_198_228 : RowResult ⟨198, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_198_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_198_229 : RowResult ⟨198, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_198_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_198_230 : RowResult ⟨198, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_198_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
