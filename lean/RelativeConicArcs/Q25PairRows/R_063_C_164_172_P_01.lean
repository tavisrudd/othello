import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_164 : RowResult ⟨63, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_165 : RowResult ⟨63, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_63_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_166 : RowResult ⟨63, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_63_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_63_167 : RowResult ⟨63, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_63_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_168 : RowResult ⟨63, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_63_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 7)

theorem row_63_169 : RowResult ⟨63, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_63_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_63_170 : RowResult ⟨63, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_63_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_63_171 : RowResult ⟨63, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_63_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 6)

theorem row_63_172 : RowResult ⟨63, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_63_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
