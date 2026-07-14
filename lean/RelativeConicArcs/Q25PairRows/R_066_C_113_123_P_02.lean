import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_113 : RowResult ⟨66, by decide⟩ ⟨113, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_114 : RowResult ⟨66, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_66_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 4 7)

theorem row_66_115 : RowResult ⟨66, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_66_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 5 6)

theorem row_66_116 : RowResult ⟨66, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_66_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 6)

theorem row_66_117 : RowResult ⟨66, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_66_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_66_118 : RowResult ⟨66, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_66_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_119 : RowResult ⟨66, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_66_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 4 5 6)

theorem row_66_120 : RowResult ⟨66, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_66_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_66_121 : RowResult ⟨66, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_66_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_66_122 : RowResult ⟨66, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_66_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_66_123 : RowResult ⟨66, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_66_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
