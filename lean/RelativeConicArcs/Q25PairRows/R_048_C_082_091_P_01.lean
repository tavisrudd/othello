import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_82 : RowResult ⟨48, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_83 : RowResult ⟨48, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_48_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 7)

theorem row_48_84 : RowResult ⟨48, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_48_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_85 : RowResult ⟨48, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_48_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_86 : RowResult ⟨48, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_48_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_48_87 : RowResult ⟨48, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_48_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_88 : RowResult ⟨48, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_48_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 5 7)

theorem row_48_89 : RowResult ⟨48, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_48_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_48_90 : RowResult ⟨48, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_48_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_91 : RowResult ⟨48, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_48_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
