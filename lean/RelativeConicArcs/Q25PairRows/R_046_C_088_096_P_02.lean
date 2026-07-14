import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_88 : RowResult ⟨46, by decide⟩ ⟨88, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_46_89 : RowResult ⟨46, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_46_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 4 6)

theorem row_46_90 : RowResult ⟨46, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_46_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_46_91 : RowResult ⟨46, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_46_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_92 : RowResult ⟨46, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_46_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_93 : RowResult ⟨46, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_46_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_94 : RowResult ⟨46, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_46_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_46_95 : RowResult ⟨46, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_46_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_46_96 : RowResult ⟨46, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_46_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
