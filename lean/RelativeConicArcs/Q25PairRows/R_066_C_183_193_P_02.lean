import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_183 : RowResult ⟨66, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_66_184 : RowResult ⟨66, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_66_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 7)

theorem row_66_185 : RowResult ⟨66, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_66_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_66_186 : RowResult ⟨66, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_66_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 7)

theorem row_66_187 : RowResult ⟨66, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_66_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_188 : RowResult ⟨66, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_66_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_66_189 : RowResult ⟨66, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_66_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_190 : RowResult ⟨66, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_66_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_191 : RowResult ⟨66, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_66_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 6)

theorem row_66_192 : RowResult ⟨66, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_66_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 6)

theorem row_66_193 : RowResult ⟨66, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_66_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
