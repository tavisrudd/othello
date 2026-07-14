import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_156 : RowResult ⟨39, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_157 : RowResult ⟨39, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_39_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 4 5 6)

theorem row_39_158 : RowResult ⟨39, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_39_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_39_159 : RowResult ⟨39, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_39_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_39_160 : RowResult ⟨39, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_39_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_161 : RowResult ⟨39, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_39_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_162 : RowResult ⟨39, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_39_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_39_163 : RowResult ⟨39, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_39_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 4 6)

theorem row_39_164 : RowResult ⟨39, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_39_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 6)

theorem row_39_165 : RowResult ⟨39, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_39_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
