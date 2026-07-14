import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_156 : RowResult ⟨97, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_97_157 : RowResult ⟨97, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_97_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 7)

theorem row_97_158 : RowResult ⟨97, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_97_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_97_159 : RowResult ⟨97, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_97_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 5 7)

theorem row_97_160 : RowResult ⟨97, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_97_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_161 : RowResult ⟨97, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_97_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 4 5 6)

theorem row_97_162 : RowResult ⟨97, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_97_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 5 6)

theorem row_97_163 : RowResult ⟨97, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_97_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_97_164 : RowResult ⟨97, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_97_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_97_165 : RowResult ⟨97, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_97_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_166 : RowResult ⟨97, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_97_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_167 : RowResult ⟨97, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_97_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
