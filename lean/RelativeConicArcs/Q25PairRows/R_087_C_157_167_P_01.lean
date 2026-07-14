import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_157 : RowResult ⟨87, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_87_158 : RowResult ⟨87, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_87_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_87_159 : RowResult ⟨87, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_87_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 4 5 6)

theorem row_87_160 : RowResult ⟨87, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_87_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 5 7)

theorem row_87_161 : RowResult ⟨87, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_87_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_162 : RowResult ⟨87, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_87_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 6)

theorem row_87_163 : RowResult ⟨87, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_87_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_87_164 : RowResult ⟨87, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_87_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_165 : RowResult ⟨87, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_87_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_166 : RowResult ⟨87, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_87_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_167 : RowResult ⟨87, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_87_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
