import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_182 : RowResult ⟨96, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_183 : RowResult ⟨96, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_96_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 6)

theorem row_96_184 : RowResult ⟨96, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_96_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_185 : RowResult ⟨96, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_96_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 7)

theorem row_96_186 : RowResult ⟨96, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_96_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_187 : RowResult ⟨96, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_96_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_188 : RowResult ⟨96, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_96_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_96_189 : RowResult ⟨96, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_96_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_96_190 : RowResult ⟨96, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_96_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
