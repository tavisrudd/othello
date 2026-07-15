import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_132 : RowResult ⟨31, by decide⟩ ⟨132, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 4 5 6)

theorem row_31_133 : RowResult ⟨31, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_31_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_134 : RowResult ⟨31, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_31_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_31_135 : RowResult ⟨31, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_31_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_31_136 : RowResult ⟨31, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_31_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 4 6)

theorem row_31_137 : RowResult ⟨31, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_31_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_31_138 : RowResult ⟨31, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_31_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_139 : RowResult ⟨31, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_31_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_140 : RowResult ⟨31, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_31_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_141 : RowResult ⟨31, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_31_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 5 6)

theorem row_31_142 : RowResult ⟨31, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_31_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
