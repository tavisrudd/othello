import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_131 : RowResult ⟨65, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_132 : RowResult ⟨65, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_65_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_133 : RowResult ⟨65, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_65_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 4 5 6)

theorem row_65_134 : RowResult ⟨65, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_65_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_65_135 : RowResult ⟨65, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_65_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 7)

theorem row_65_136 : RowResult ⟨65, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_65_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_137 : RowResult ⟨65, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_65_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_65_138 : RowResult ⟨65, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_65_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_139 : RowResult ⟨65, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_65_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_140 : RowResult ⟨65, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_65_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
