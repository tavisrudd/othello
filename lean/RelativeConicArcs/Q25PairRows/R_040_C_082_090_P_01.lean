import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_82 : RowResult ⟨40, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_40_83 : RowResult ⟨40, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_40_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_84 : RowResult ⟨40, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_40_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_40_85 : RowResult ⟨40, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_40_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 7)

theorem row_40_86 : RowResult ⟨40, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_40_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_40_87 : RowResult ⟨40, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_40_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_88 : RowResult ⟨40, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_40_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_89 : RowResult ⟨40, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_40_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_90 : RowResult ⟨40, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_40_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
