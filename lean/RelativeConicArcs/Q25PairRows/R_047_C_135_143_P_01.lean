import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_135 : RowResult ⟨47, by decide⟩ ⟨135, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_136 : RowResult ⟨47, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_47_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 5 6)

theorem row_47_137 : RowResult ⟨47, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_47_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_47_138 : RowResult ⟨47, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_47_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_139 : RowResult ⟨47, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_47_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_140 : RowResult ⟨47, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_47_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_141 : RowResult ⟨47, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_47_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_142 : RowResult ⟨47, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_47_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 7)

theorem row_47_143 : RowResult ⟨47, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_47_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
