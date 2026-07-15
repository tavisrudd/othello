import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_134 : RowResult ⟨40, by decide⟩ ⟨134, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_40_135 : RowResult ⟨40, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_40_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 7)

theorem row_40_136 : RowResult ⟨40, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_40_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_137 : RowResult ⟨40, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_40_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_40_138 : RowResult ⟨40, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_40_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_139 : RowResult ⟨40, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_40_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_140 : RowResult ⟨40, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_40_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
