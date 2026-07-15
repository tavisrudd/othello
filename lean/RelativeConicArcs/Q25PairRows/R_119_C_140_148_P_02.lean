import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_140 : RowResult ⟨119, by decide⟩ ⟨140, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_141 : RowResult ⟨119, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_119_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_142 : RowResult ⟨119, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_119_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_143 : RowResult ⟨119, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_119_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 4 7)

theorem row_119_144 : RowResult ⟨119, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_119_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 6)

theorem row_119_145 : RowResult ⟨119, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_119_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_119_146 : RowResult ⟨119, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_119_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_147 : RowResult ⟨119, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_119_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_119_148 : RowResult ⟨119, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_119_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
