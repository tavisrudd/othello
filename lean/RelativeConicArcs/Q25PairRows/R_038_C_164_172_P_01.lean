import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_164 : RowResult ⟨38, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_165 : RowResult ⟨38, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_38_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_38_166 : RowResult ⟨38, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_38_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_167 : RowResult ⟨38, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_38_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_168 : RowResult ⟨38, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_38_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 7)

theorem row_38_169 : RowResult ⟨38, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_38_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_170 : RowResult ⟨38, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_38_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_38_171 : RowResult ⟨38, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_38_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_172 : RowResult ⟨38, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_38_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
