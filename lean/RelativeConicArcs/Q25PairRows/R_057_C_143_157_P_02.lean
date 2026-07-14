import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_143 : RowResult ⟨57, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_144 : RowResult ⟨57, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_57_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 4 6)

theorem row_57_145 : RowResult ⟨57, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_57_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_57_146 : RowResult ⟨57, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_57_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_147 : RowResult ⟨57, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_57_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 7)

theorem row_57_148 : RowResult ⟨57, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_57_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_149 : RowResult ⟨57, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_57_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_150 : RowResult ⟨57, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_57_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_57_151 : RowResult ⟨57, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_57_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_57_152 : RowResult ⟨57, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_57_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_57_153 : RowResult ⟨57, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_57_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_57_154 : RowResult ⟨57, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_57_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_57_155 : RowResult ⟨57, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_57_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_57_156 : RowResult ⟨57, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_57_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 4 6)

theorem row_57_157 : RowResult ⟨57, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_57_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
