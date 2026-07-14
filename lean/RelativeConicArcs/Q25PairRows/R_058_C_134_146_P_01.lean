import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_134 : RowResult ⟨58, by decide⟩ ⟨134, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_135 : RowResult ⟨58, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_58_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_136 : RowResult ⟨58, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_58_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 5 6)

theorem row_58_137 : RowResult ⟨58, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_58_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_58_138 : RowResult ⟨58, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_58_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_139 : RowResult ⟨58, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_58_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 4 5 6)

theorem row_58_140 : RowResult ⟨58, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_58_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_58_141 : RowResult ⟨58, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_58_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 4 7)

theorem row_58_142 : RowResult ⟨58, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_58_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 7)

theorem row_58_143 : RowResult ⟨58, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_58_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_144 : RowResult ⟨58, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_58_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_58_145 : RowResult ⟨58, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_58_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_58_146 : RowResult ⟨58, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_58_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
