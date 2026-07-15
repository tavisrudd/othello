import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_132 : RowResult ⟨81, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_81_133 : RowResult ⟨81, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_81_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_134 : RowResult ⟨81, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_81_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 4 5 6)

theorem row_81_135 : RowResult ⟨81, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_81_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 4 6)

theorem row_81_136 : RowResult ⟨81, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_81_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_137 : RowResult ⟨81, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_81_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_81_138 : RowResult ⟨81, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_81_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_81_139 : RowResult ⟨81, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_81_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_81_140 : RowResult ⟨81, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_81_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 5 6)

theorem row_81_141 : RowResult ⟨81, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_81_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
