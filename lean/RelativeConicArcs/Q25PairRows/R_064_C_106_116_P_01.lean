import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_106 : RowResult ⟨64, by decide⟩ ⟨106, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_107 : RowResult ⟨64, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_64_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_64_108 : RowResult ⟨64, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_64_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 5 6)

theorem row_64_109 : RowResult ⟨64, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_64_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_64_110 : RowResult ⟨64, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_64_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_111 : RowResult ⟨64, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_64_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 4 5 6)

theorem row_64_112 : RowResult ⟨64, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_64_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_113 : RowResult ⟨64, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_64_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 5 7)

theorem row_64_114 : RowResult ⟨64, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_64_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 6)

theorem row_64_115 : RowResult ⟨64, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_64_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_116 : RowResult ⟨64, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_64_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
