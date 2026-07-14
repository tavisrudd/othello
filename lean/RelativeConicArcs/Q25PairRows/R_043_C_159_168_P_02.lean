import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_159 : RowResult ⟨43, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_43_160 : RowResult ⟨43, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_43_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_161 : RowResult ⟨43, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_43_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_162 : RowResult ⟨43, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_43_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_43_163 : RowResult ⟨43, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_43_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 7)

theorem row_43_164 : RowResult ⟨43, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_43_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 5 6)

theorem row_43_165 : RowResult ⟨43, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_43_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_166 : RowResult ⟨43, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_43_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 6)

theorem row_43_167 : RowResult ⟨43, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_43_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_168 : RowResult ⟨43, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_43_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
