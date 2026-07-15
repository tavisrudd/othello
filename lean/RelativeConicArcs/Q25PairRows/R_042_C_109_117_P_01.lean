import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_109 : RowResult ⟨42, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_110 : RowResult ⟨42, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_42_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_111 : RowResult ⟨42, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_42_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 5 6)

theorem row_42_112 : RowResult ⟨42, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_42_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 7)

theorem row_42_113 : RowResult ⟨42, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_42_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_114 : RowResult ⟨42, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_42_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_115 : RowResult ⟨42, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_42_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_116 : RowResult ⟨42, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_42_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_117 : RowResult ⟨42, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_42_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
