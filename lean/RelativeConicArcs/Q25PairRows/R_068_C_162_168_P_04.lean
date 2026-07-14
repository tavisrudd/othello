import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_162 : RowResult ⟨68, by decide⟩ ⟨162, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_163 : RowResult ⟨68, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_68_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 7)

theorem row_68_164 : RowResult ⟨68, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_68_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 6)

theorem row_68_165 : RowResult ⟨68, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_68_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_166 : RowResult ⟨68, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_68_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_68_167 : RowResult ⟨68, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_68_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 6)

theorem row_68_168 : RowResult ⟨68, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_68_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
