import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_147 : RowResult ⟨58, by decide⟩ ⟨147, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_148 : RowResult ⟨58, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_58_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 7)

theorem row_58_149 : RowResult ⟨58, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_58_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_150 : RowResult ⟨58, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_58_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_58_151 : RowResult ⟨58, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_58_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_58_152 : RowResult ⟨58, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_58_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_58_153 : RowResult ⟨58, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_58_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_58_154 : RowResult ⟨58, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_58_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_58_155 : RowResult ⟨58, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_58_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_58_156 : RowResult ⟨58, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_58_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_157 : RowResult ⟨58, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_58_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_58_158 : RowResult ⟨58, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_58_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
