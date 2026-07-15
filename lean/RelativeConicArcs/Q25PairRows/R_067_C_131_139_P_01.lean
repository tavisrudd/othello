import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_67_131 : RowResult ⟨67, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_67_132 : RowResult ⟨67, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_67_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 4 7)

theorem row_67_133 : RowResult ⟨67, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_67_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_67_134 : RowResult ⟨67, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_67_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_67_135 : RowResult ⟨67, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_67_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_67_136 : RowResult ⟨67, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_67_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_67_137 : RowResult ⟨67, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_67_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 7)

theorem row_67_138 : RowResult ⟨67, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_67_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 6)

theorem row_67_139 : RowResult ⟨67, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_67_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
