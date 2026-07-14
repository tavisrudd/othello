import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_110_156 : RowResult ⟨110, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_157 : RowResult ⟨110, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_110_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_110_158 : RowResult ⟨110, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_110_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_110_159 : RowResult ⟨110, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_110_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_160 : RowResult ⟨110, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_110_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 6)

theorem row_110_161 : RowResult ⟨110, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_110_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_162 : RowResult ⟨110, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_110_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 4 5 6)

theorem row_110_163 : RowResult ⟨110, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_110_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_110_164 : RowResult ⟨110, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_110_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_165 : RowResult ⟨110, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_110_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
