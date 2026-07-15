import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_133 : RowResult ⟨60, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_134 : RowResult ⟨60, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_60_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_135 : RowResult ⟨60, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_60_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 6)

theorem row_60_136 : RowResult ⟨60, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_60_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_137 : RowResult ⟨60, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_60_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_60_138 : RowResult ⟨60, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_60_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_139 : RowResult ⟨60, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_60_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 4 7)

theorem row_60_140 : RowResult ⟨60, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_60_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 7)

theorem row_60_141 : RowResult ⟨60, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_60_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_142 : RowResult ⟨60, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_60_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 4 6)

theorem row_60_143 : RowResult ⟨60, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_60_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
