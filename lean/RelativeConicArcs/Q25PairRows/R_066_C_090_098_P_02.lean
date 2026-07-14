import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_90 : RowResult ⟨66, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_66_91 : RowResult ⟨66, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_66_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 6)

theorem row_66_92 : RowResult ⟨66, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_66_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_66_93 : RowResult ⟨66, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_66_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_66_94 : RowResult ⟨66, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_66_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 5 7)

theorem row_66_95 : RowResult ⟨66, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_66_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_66_96 : RowResult ⟨66, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_66_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨157, by decide⟩, by decide⟩

theorem row_66_97 : RowResult ⟨66, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_66_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_98 : RowResult ⟨66, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_66_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
