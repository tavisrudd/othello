import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_81 : RowResult ⟨39, by decide⟩ ⟨81, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_82 : RowResult ⟨39, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_39_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_83 : RowResult ⟨39, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_39_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_39_84 : RowResult ⟨39, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_39_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_85 : RowResult ⟨39, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_39_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 4 5 6)

theorem row_39_86 : RowResult ⟨39, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_39_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_39_87 : RowResult ⟨39, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_39_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_88 : RowResult ⟨39, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_39_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_89 : RowResult ⟨39, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_39_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
