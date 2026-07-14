import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_106_160 : RowResult ⟨106, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_106_161 : RowResult ⟨106, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_106_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_106_162 : RowResult ⟨106, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_106_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_106_163 : RowResult ⟨106, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_106_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_106_164 : RowResult ⟨106, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_106_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_106_165 : RowResult ⟨106, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_106_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 5 7)

theorem row_106_166 : RowResult ⟨106, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_106_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
