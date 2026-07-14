import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_132 : RowResult ⟨87, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_133 : RowResult ⟨87, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_87_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 6)

theorem row_87_134 : RowResult ⟨87, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_87_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_135 : RowResult ⟨87, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_87_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_136 : RowResult ⟨87, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_87_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_137 : RowResult ⟨87, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_87_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 6)

theorem row_87_138 : RowResult ⟨87, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_87_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 4 5 6)

theorem row_87_139 : RowResult ⟨87, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_87_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 4 7)

theorem row_87_140 : RowResult ⟨87, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_87_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_141 : RowResult ⟨87, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_87_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_142 : RowResult ⟨87, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_87_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
