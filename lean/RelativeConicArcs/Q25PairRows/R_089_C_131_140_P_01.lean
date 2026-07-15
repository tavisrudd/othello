import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_131 : RowResult ⟨89, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_132 : RowResult ⟨89, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_89_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_89_133 : RowResult ⟨89, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_89_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_134 : RowResult ⟨89, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_89_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_89_135 : RowResult ⟨89, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_89_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 4 5 6)

theorem row_89_136 : RowResult ⟨89, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_89_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_137 : RowResult ⟨89, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_89_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_89_138 : RowResult ⟨89, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_89_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 7)

theorem row_89_139 : RowResult ⟨89, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_89_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 6)

theorem row_89_140 : RowResult ⟨89, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_89_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
