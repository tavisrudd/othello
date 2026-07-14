import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_98_131 : RowResult ⟨98, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_98_132 : RowResult ⟨98, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_98_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_98_133 : RowResult ⟨98, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_98_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 7)

theorem row_98_134 : RowResult ⟨98, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_98_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 7)

theorem row_98_135 : RowResult ⟨98, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_98_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_136 : RowResult ⟨98, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_98_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_98_137 : RowResult ⟨98, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_98_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_98_138 : RowResult ⟨98, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_98_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_139 : RowResult ⟨98, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_98_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
