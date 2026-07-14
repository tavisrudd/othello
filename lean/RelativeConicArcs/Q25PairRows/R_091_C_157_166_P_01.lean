import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_157 : RowResult ⟨91, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_91_158 : RowResult ⟨91, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_91_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_91_159 : RowResult ⟨91, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_91_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_91_160 : RowResult ⟨91, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_91_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_161 : RowResult ⟨91, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_91_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 7)

theorem row_91_162 : RowResult ⟨91, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_91_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_163 : RowResult ⟨91, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_91_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_91_164 : RowResult ⟨91, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_91_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_91_165 : RowResult ⟨91, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_91_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 5 7)

theorem row_91_166 : RowResult ⟨91, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_91_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
