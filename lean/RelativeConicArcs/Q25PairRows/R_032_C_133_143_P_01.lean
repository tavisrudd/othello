import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_133 : RowResult ⟨32, by decide⟩ ⟨133, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 4 5 6)

theorem row_32_134 : RowResult ⟨32, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_32_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 6)

theorem row_32_135 : RowResult ⟨32, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_32_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_32_136 : RowResult ⟨32, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_32_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_32_137 : RowResult ⟨32, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_32_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_32_138 : RowResult ⟨32, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_32_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_32_139 : RowResult ⟨32, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_32_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 4 7)

theorem row_32_140 : RowResult ⟨32, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_32_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_32_141 : RowResult ⟨32, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_32_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_32_142 : RowResult ⟨32, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_32_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 4 6)

theorem row_32_143 : RowResult ⟨32, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_32_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
