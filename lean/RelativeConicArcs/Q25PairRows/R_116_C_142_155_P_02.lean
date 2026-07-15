import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_142 : RowResult ⟨116, by decide⟩ ⟨142, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_143 : RowResult ⟨116, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_116_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_144 : RowResult ⟨116, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_116_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_116_145 : RowResult ⟨116, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_116_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_116_146 : RowResult ⟨116, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_116_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_116_147 : RowResult ⟨116, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_116_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_148 : RowResult ⟨116, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_116_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 5 7)

theorem row_116_149 : RowResult ⟨116, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_116_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_116_150 : RowResult ⟨116, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_116_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_116_151 : RowResult ⟨116, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_116_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_116_152 : RowResult ⟨116, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_116_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_116_153 : RowResult ⟨116, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_116_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_116_154 : RowResult ⟨116, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_116_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_116_155 : RowResult ⟨116, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_116_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
