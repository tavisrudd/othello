import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_149 : RowResult ⟨88, by decide⟩ ⟨149, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_88_150 : RowResult ⟨88, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_88_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_88_151 : RowResult ⟨88, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_88_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_88_152 : RowResult ⟨88, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_88_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_88_153 : RowResult ⟨88, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_88_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_88_154 : RowResult ⟨88, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_88_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_88_155 : RowResult ⟨88, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_88_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_88_156 : RowResult ⟨88, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_88_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_157 : RowResult ⟨88, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_88_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_88_158 : RowResult ⟨88, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_88_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_88_159 : RowResult ⟨88, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_88_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 4 7)

theorem row_88_160 : RowResult ⟨88, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_88_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 5 6)

theorem row_88_161 : RowResult ⟨88, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_88_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_162 : RowResult ⟨88, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_88_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 4 6)

theorem row_88_163 : RowResult ⟨88, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_88_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 6)

theorem row_88_164 : RowResult ⟨88, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_88_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_165 : RowResult ⟨88, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_88_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
