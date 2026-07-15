import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_133 : RowResult ⟨85, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_134 : RowResult ⟨85, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_85_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_85_135 : RowResult ⟨85, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_85_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 6)

theorem row_85_136 : RowResult ⟨85, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_85_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 4 5 6)

theorem row_85_137 : RowResult ⟨85, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_85_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_85_138 : RowResult ⟨85, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_85_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_139 : RowResult ⟨85, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_85_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_140 : RowResult ⟨85, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_85_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 7)

theorem row_85_141 : RowResult ⟨85, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_85_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 5 6)

theorem row_85_142 : RowResult ⟨85, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_85_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_143 : RowResult ⟨85, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_85_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_144 : RowResult ⟨85, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_85_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 5 7)

theorem row_85_145 : RowResult ⟨85, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_85_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
