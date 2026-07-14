import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_131 : RowResult ⟨37, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_132 : RowResult ⟨37, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_37_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_37_133 : RowResult ⟨37, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_37_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_134 : RowResult ⟨37, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_37_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 7)

theorem row_37_135 : RowResult ⟨37, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_37_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_37_136 : RowResult ⟨37, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_37_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_137 : RowResult ⟨37, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_37_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
