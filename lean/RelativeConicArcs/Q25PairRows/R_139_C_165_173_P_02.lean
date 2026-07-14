import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_165 : RowResult ⟨139, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_166 : RowResult ⟨139, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_139_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_167 : RowResult ⟨139, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_139_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_168 : RowResult ⟨139, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_139_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 4 7)

theorem row_139_169 : RowResult ⟨139, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_139_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 7)

theorem row_139_170 : RowResult ⟨139, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_139_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_139_171 : RowResult ⟨139, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_139_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_172 : RowResult ⟨139, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_139_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_173 : RowResult ⟨139, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_139_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
