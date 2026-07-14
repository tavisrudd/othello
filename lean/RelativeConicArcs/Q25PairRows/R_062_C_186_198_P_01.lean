import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_186 : RowResult ⟨62, by decide⟩ ⟨186, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_187 : RowResult ⟨62, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_62_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

theorem row_62_188 : RowResult ⟨62, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_62_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_62_189 : RowResult ⟨62, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_62_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 5 6)

theorem row_62_190 : RowResult ⟨62, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_62_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_62_191 : RowResult ⟨62, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_62_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_192 : RowResult ⟨62, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_62_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 7)

theorem row_62_193 : RowResult ⟨62, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_62_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 5 7)

theorem row_62_194 : RowResult ⟨62, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_62_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_195 : RowResult ⟨62, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_62_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_62_196 : RowResult ⟨62, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_62_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 4 5 6)

theorem row_62_197 : RowResult ⟨62, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_62_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_198 : RowResult ⟨62, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_62_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
