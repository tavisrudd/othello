import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_184 : RowResult ⟨57, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_185 : RowResult ⟨57, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_57_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_186 : RowResult ⟨57, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_57_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_187 : RowResult ⟨57, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_57_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_188 : RowResult ⟨57, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_57_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_57_189 : RowResult ⟨57, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_57_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 4 5 6)

theorem row_57_190 : RowResult ⟨57, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_57_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_191 : RowResult ⟨57, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_57_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 6)

theorem row_57_192 : RowResult ⟨57, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_57_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
