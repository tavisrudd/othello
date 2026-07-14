import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_162 : RowResult ⟨61, by decide⟩ ⟨162, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_163 : RowResult ⟨61, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_61_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_164 : RowResult ⟨61, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_61_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_165 : RowResult ⟨61, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_61_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_166 : RowResult ⟨61, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_61_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 7)

theorem row_61_167 : RowResult ⟨61, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_61_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_168 : RowResult ⟨61, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_61_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_169 : RowResult ⟨61, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_61_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 4 7)

theorem row_61_170 : RowResult ⟨61, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_61_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
