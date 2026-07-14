import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_185 : RowResult ⟨69, by decide⟩ ⟨185, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_186 : RowResult ⟨69, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_69_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_187 : RowResult ⟨69, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_69_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_188 : RowResult ⟨69, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_69_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_69_189 : RowResult ⟨69, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_69_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 7)

theorem row_69_190 : RowResult ⟨69, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_69_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 7)

theorem row_69_191 : RowResult ⟨69, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_69_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_192 : RowResult ⟨69, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_69_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_69_193 : RowResult ⟨69, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_69_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_194 : RowResult ⟨69, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_69_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 6)

theorem row_69_195 : RowResult ⟨69, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_69_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
