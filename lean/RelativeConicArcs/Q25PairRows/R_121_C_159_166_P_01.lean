import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_159 : RowResult ⟨121, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_160 : RowResult ⟨121, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_121_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_121_161 : RowResult ⟨121, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_121_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 2 5 6)

theorem row_121_162 : RowResult ⟨121, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_121_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_163 : RowResult ⟨121, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_121_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 5 7)

theorem row_121_164 : RowResult ⟨121, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_121_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_165 : RowResult ⟨121, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_121_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_166 : RowResult ⟨121, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_121_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
