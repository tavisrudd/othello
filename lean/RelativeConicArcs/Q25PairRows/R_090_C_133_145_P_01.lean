import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_133 : RowResult ⟨90, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_134 : RowResult ⟨90, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_90_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 4 6)

theorem row_90_135 : RowResult ⟨90, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_90_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 7)

theorem row_90_136 : RowResult ⟨90, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_90_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_137 : RowResult ⟨90, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_90_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_90_138 : RowResult ⟨90, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_90_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 6)

theorem row_90_139 : RowResult ⟨90, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_90_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_140 : RowResult ⟨90, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_90_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 6)

theorem row_90_141 : RowResult ⟨90, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_90_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_142 : RowResult ⟨90, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_90_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_143 : RowResult ⟨90, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_90_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_144 : RowResult ⟨90, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_90_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 4 5 6)

theorem row_90_145 : RowResult ⟨90, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_90_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
