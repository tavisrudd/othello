import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_67_140 : RowResult ⟨67, by decide⟩ ⟨140, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_67_141 : RowResult ⟨67, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_67_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_67_142 : RowResult ⟨67, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_67_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 6)

theorem row_67_143 : RowResult ⟨67, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_67_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_144 : RowResult ⟨67, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_67_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 5 6)

theorem row_67_145 : RowResult ⟨67, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_67_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_67_146 : RowResult ⟨67, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_67_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_147 : RowResult ⟨67, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_67_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_148 : RowResult ⟨67, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_67_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
