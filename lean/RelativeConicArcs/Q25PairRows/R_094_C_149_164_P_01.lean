import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_149 : RowResult ⟨94, by decide⟩ ⟨149, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_94_150 : RowResult ⟨94, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_94_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_94_151 : RowResult ⟨94, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_94_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_94_152 : RowResult ⟨94, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_94_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_94_153 : RowResult ⟨94, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_94_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_94_154 : RowResult ⟨94, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_94_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_94_155 : RowResult ⟨94, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_94_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_94_156 : RowResult ⟨94, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_94_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 5 7)

theorem row_94_157 : RowResult ⟨94, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_94_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_94_158 : RowResult ⟨94, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_94_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_94_159 : RowResult ⟨94, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_94_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_94_160 : RowResult ⟨94, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_94_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 4 6)

theorem row_94_161 : RowResult ⟨94, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_94_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_94_162 : RowResult ⟨94, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_94_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_94_163 : RowResult ⟨94, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_94_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_94_164 : RowResult ⟨94, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_94_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
