import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_134_214 : RowResult ⟨134, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_134_215 : RowResult ⟨134, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_134_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 4 5 6)

theorem row_134_216 : RowResult ⟨134, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_134_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 6)

theorem row_134_217 : RowResult ⟨134, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_134_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_134_218 : RowResult ⟨134, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_134_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_134_219 : RowResult ⟨134, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_134_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 6)

theorem row_134_220 : RowResult ⟨134, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_134_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_134_221 : RowResult ⟨134, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_134_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_134_222 : RowResult ⟨134, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_134_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 5 7)

theorem row_134_223 : RowResult ⟨134, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_134_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_134_224 : RowResult ⟨134, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_134_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 7)

theorem row_134_225 : RowResult ⟨134, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_134_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_134_226 : RowResult ⟨134, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_134_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_134_227 : RowResult ⟨134, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_134_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_134_228 : RowResult ⟨134, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_134_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_134_229 : RowResult ⟨134, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_134_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_134_230 : RowResult ⟨134, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_134_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_134_231 : RowResult ⟨134, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_134_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
