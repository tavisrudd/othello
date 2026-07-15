import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_108 : RowResult ⟨38, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_109 : RowResult ⟨38, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_38_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_110 : RowResult ⟨38, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_38_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_38_111 : RowResult ⟨38, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_38_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_112 : RowResult ⟨38, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_38_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_113 : RowResult ⟨38, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_38_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 6)

theorem row_38_114 : RowResult ⟨38, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_38_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 5 7)

theorem row_38_115 : RowResult ⟨38, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_38_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_116 : RowResult ⟨38, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_38_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
