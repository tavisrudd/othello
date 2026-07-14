import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_132 : RowResult ⟨91, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_133 : RowResult ⟨91, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_91_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_134 : RowResult ⟨91, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_91_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 6)

theorem row_91_135 : RowResult ⟨91, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_91_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_136 : RowResult ⟨91, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_91_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 7)

theorem row_91_137 : RowResult ⟨91, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_91_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_91_138 : RowResult ⟨91, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_91_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_139 : RowResult ⟨91, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_91_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 4 6)

theorem row_91_140 : RowResult ⟨91, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_91_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 4 5 6)

theorem row_91_141 : RowResult ⟨91, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_91_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 6)

theorem row_91_142 : RowResult ⟨91, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_91_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_91_143 : RowResult ⟨91, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_91_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
