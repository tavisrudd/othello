import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_82 : RowResult ⟨37, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_37_83 : RowResult ⟨37, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_37_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_84 : RowResult ⟨37, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_37_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_37_85 : RowResult ⟨37, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_37_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_86 : RowResult ⟨37, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_37_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_37_87 : RowResult ⟨37, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_37_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 6)

theorem row_37_88 : RowResult ⟨37, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_37_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 4 5 6)

theorem row_37_89 : RowResult ⟨37, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_37_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_37_90 : RowResult ⟨37, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_37_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
