import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_157 : RowResult ⟨123, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_123_158 : RowResult ⟨123, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_123_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 7)

theorem row_123_159 : RowResult ⟨123, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_123_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_123_160 : RowResult ⟨123, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_123_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_161 : RowResult ⟨123, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_123_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_123_162 : RowResult ⟨123, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_123_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_123_163 : RowResult ⟨123, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_123_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
