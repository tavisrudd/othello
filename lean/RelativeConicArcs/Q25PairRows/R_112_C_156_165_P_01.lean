import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_156 : RowResult ⟨112, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_157 : RowResult ⟨112, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_112_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_158 : RowResult ⟨112, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_112_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_112_159 : RowResult ⟨112, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_112_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_112_160 : RowResult ⟨112, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_112_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_161 : RowResult ⟨112, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_112_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 2 4 7)

theorem row_112_162 : RowResult ⟨112, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_112_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 6)

theorem row_112_163 : RowResult ⟨112, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_112_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_112_164 : RowResult ⟨112, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_112_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 4 5 6)

theorem row_112_165 : RowResult ⟨112, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_112_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
