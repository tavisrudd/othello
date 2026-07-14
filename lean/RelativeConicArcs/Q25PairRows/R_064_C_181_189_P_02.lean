import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_181 : RowResult ⟨64, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_182 : RowResult ⟨64, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_64_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 5 7)

theorem row_64_183 : RowResult ⟨64, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_64_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_184 : RowResult ⟨64, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_64_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_64_185 : RowResult ⟨64, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_64_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_186 : RowResult ⟨64, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_64_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_187 : RowResult ⟨64, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_64_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_64_188 : RowResult ⟨64, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_64_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_64_189 : RowResult ⟨64, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_64_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
