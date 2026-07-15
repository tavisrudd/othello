import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_163 : RowResult ⟨69, by decide⟩ ⟨163, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_69_164 : RowResult ⟨69, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_69_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 7)

theorem row_69_165 : RowResult ⟨69, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_69_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 4 5 6)

theorem row_69_166 : RowResult ⟨69, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_69_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_69_167 : RowResult ⟨69, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_69_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_69_168 : RowResult ⟨69, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_69_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_69_169 : RowResult ⟨69, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_69_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
