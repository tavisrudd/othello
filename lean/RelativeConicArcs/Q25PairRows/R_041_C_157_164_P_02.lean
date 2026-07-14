import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_157 : RowResult ⟨41, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_41_158 : RowResult ⟨41, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_41_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_41_159 : RowResult ⟨41, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_41_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_160 : RowResult ⟨41, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_41_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_161 : RowResult ⟨41, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_41_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 7)

theorem row_41_162 : RowResult ⟨41, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_41_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_163 : RowResult ⟨41, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_41_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_164 : RowResult ⟨41, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_41_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
