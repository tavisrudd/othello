import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_134 : RowResult ⟨43, by decide⟩ ⟨134, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_43_135 : RowResult ⟨43, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_43_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 4 7)

theorem row_43_136 : RowResult ⟨43, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_43_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_43_137 : RowResult ⟨43, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_43_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_43_138 : RowResult ⟨43, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_43_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 7)

theorem row_43_139 : RowResult ⟨43, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_43_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_140 : RowResult ⟨43, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_43_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 5 6)

theorem row_43_141 : RowResult ⟨43, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_43_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 4 5 6)

theorem row_43_142 : RowResult ⟨43, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_43_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_143 : RowResult ⟨43, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_43_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
