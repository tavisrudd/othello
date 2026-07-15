import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_135 : RowResult ⟨68, by decide⟩ ⟨135, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_68_136 : RowResult ⟨68, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_68_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_137 : RowResult ⟨68, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_68_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_68_138 : RowResult ⟨68, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_68_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 7)

theorem row_68_139 : RowResult ⟨68, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_68_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_140 : RowResult ⟨68, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_68_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 4 6)

theorem row_68_141 : RowResult ⟨68, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_68_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 5 6)

theorem row_68_142 : RowResult ⟨68, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_68_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_143 : RowResult ⟨68, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_68_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 6)

theorem row_68_144 : RowResult ⟨68, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_68_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 5 7)

theorem row_68_145 : RowResult ⟨68, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_68_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_68_146 : RowResult ⟨68, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_68_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_147 : RowResult ⟨68, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_68_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
