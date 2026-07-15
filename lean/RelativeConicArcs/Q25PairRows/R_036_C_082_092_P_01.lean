import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_82 : RowResult ⟨36, by decide⟩ ⟨82, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_83 : RowResult ⟨36, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_36_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_36_84 : RowResult ⟨36, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_36_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 2 5 6)

theorem row_36_85 : RowResult ⟨36, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_36_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_36_86 : RowResult ⟨36, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_36_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 4 6)

theorem row_36_87 : RowResult ⟨36, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_36_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 4 5 6)

theorem row_36_88 : RowResult ⟨36, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_36_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_36_89 : RowResult ⟨36, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_36_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_90 : RowResult ⟨36, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_36_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_91 : RowResult ⟨36, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_36_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 7)

theorem row_36_92 : RowResult ⟨36, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_36_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
