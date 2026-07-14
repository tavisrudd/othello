import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_134_181 : RowResult ⟨134, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_134_182 : RowResult ⟨134, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_134_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

theorem row_134_183 : RowResult ⟨134, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_134_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_184 : RowResult ⟨134, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_134_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 6)

theorem row_134_185 : RowResult ⟨134, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_134_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_186 : RowResult ⟨134, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_134_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_187 : RowResult ⟨134, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_134_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_134_188 : RowResult ⟨134, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_134_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_134_189 : RowResult ⟨134, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_134_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 7)

theorem row_134_190 : RowResult ⟨134, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_134_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 7)

theorem row_134_191 : RowResult ⟨134, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_134_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
