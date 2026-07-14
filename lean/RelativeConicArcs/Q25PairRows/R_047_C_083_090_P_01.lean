import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_83 : RowResult ⟨47, by decide⟩ ⟨83, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_47_84 : RowResult ⟨47, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_47_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_47_85 : RowResult ⟨47, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_47_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_86 : RowResult ⟨47, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_47_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_47_87 : RowResult ⟨47, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_47_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 4 7)

theorem row_47_88 : RowResult ⟨47, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_47_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_89 : RowResult ⟨47, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_47_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_47_90 : RowResult ⟨47, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_47_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
