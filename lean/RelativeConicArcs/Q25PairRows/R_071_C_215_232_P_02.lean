import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_215 : RowResult ⟨71, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_216 : RowResult ⟨71, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_71_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_71_217 : RowResult ⟨71, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_71_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_71_218 : RowResult ⟨71, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_71_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_219 : RowResult ⟨71, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_71_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 4 6)

theorem row_71_220 : RowResult ⟨71, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_71_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_71_221 : RowResult ⟨71, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_71_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 6)

theorem row_71_222 : RowResult ⟨71, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_71_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 7)

theorem row_71_223 : RowResult ⟨71, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_71_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 4 5 6)

theorem row_71_224 : RowResult ⟨71, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_71_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_225 : RowResult ⟨71, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_71_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_71_226 : RowResult ⟨71, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_71_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_71_227 : RowResult ⟨71, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_71_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_71_228 : RowResult ⟨71, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_71_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_71_229 : RowResult ⟨71, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_71_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_71_230 : RowResult ⟨71, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_71_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_71_231 : RowResult ⟨71, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_71_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 7)

theorem row_71_232 : RowResult ⟨71, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_71_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨216, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
