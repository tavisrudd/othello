import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_166 : RowResult ⟨73, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_73_167 : RowResult ⟨73, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_73_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_73_168 : RowResult ⟨73, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_73_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_169 : RowResult ⟨73, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_73_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_170 : RowResult ⟨73, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_73_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_73_171 : RowResult ⟨73, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_73_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 4 5 6)

theorem row_73_172 : RowResult ⟨73, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_73_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_173 : RowResult ⟨73, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_73_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
