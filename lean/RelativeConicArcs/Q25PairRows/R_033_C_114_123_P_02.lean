import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_114 : RowResult ⟨33, by decide⟩ ⟨114, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_33_115 : RowResult ⟨33, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_33_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 5 7)

theorem row_33_116 : RowResult ⟨33, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_33_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_117 : RowResult ⟨33, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_33_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_118 : RowResult ⟨33, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_33_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_119 : RowResult ⟨33, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_33_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 4 5 6)

theorem row_33_120 : RowResult ⟨33, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_33_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_33_121 : RowResult ⟨33, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_33_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_122 : RowResult ⟨33, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_33_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_123 : RowResult ⟨33, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_33_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
