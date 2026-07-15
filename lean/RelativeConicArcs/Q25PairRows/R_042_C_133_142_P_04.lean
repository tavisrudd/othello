import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_133 : RowResult ⟨42, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_42_134 : RowResult ⟨42, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_42_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_42_135 : RowResult ⟨42, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_42_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨66, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_42_136 : RowResult ⟨42, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_42_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_137 : RowResult ⟨42, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_42_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 7)

theorem row_42_138 : RowResult ⟨42, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_42_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 7)

theorem row_42_139 : RowResult ⟨42, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_42_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_140 : RowResult ⟨42, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_42_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 4 5 6)

theorem row_42_141 : RowResult ⟨42, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_42_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_142 : RowResult ⟨42, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_42_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
