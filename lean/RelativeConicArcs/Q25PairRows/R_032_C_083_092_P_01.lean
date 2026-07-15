import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_83 : RowResult ⟨32, by decide⟩ ⟨83, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_32_84 : RowResult ⟨32, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_32_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_32_85 : RowResult ⟨32, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_32_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_32_86 : RowResult ⟨32, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_32_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_32_87 : RowResult ⟨32, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_32_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 4 6)

theorem row_32_88 : RowResult ⟨32, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_32_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_32_89 : RowResult ⟨32, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_32_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_32_90 : RowResult ⟨32, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_32_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 2 5 6)

theorem row_32_91 : RowResult ⟨32, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_32_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 5 7)

theorem row_32_92 : RowResult ⟨32, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_32_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
