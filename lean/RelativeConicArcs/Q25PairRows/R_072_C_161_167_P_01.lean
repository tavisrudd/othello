import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_161 : RowResult ⟨72, by decide⟩ ⟨161, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_162 : RowResult ⟨72, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_72_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_163 : RowResult ⟨72, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_72_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_72_164 : RowResult ⟨72, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_72_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_72_165 : RowResult ⟨72, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_72_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 5 7)

theorem row_72_166 : RowResult ⟨72, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_72_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_167 : RowResult ⟨72, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_72_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
