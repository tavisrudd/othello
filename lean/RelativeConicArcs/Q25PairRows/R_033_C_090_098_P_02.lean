import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_90 : RowResult ⟨33, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_33_91 : RowResult ⟨33, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_33_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_33_92 : RowResult ⟨33, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_33_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_93 : RowResult ⟨33, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_33_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_94 : RowResult ⟨33, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_33_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_95 : RowResult ⟨33, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_33_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_33_96 : RowResult ⟨33, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_33_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_97 : RowResult ⟨33, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_33_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 2 5 7)

theorem row_33_98 : RowResult ⟨33, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_33_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
