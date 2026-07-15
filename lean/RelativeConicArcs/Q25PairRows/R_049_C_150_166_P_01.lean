import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_150 : RowResult ⟨49, by decide⟩ ⟨150, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_49_151 : RowResult ⟨49, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_49_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_49_152 : RowResult ⟨49, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_49_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_49_153 : RowResult ⟨49, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_49_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_49_154 : RowResult ⟨49, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_49_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_49_155 : RowResult ⟨49, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_49_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_49_156 : RowResult ⟨49, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_49_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 5 7)

theorem row_49_157 : RowResult ⟨49, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_49_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_158 : RowResult ⟨49, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_49_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_49_159 : RowResult ⟨49, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_49_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 7)

theorem row_49_160 : RowResult ⟨49, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_49_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 4 5 6)

theorem row_49_161 : RowResult ⟨49, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_49_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_162 : RowResult ⟨49, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_49_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_163 : RowResult ⟨49, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_49_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_164 : RowResult ⟨49, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_49_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 6)

theorem row_49_165 : RowResult ⟨49, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_49_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_166 : RowResult ⟨49, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_49_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
