import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_136 : RowResult ⟨74, by decide⟩ ⟨136, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_137 : RowResult ⟨74, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_74_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_74_138 : RowResult ⟨74, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_74_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_74_139 : RowResult ⟨74, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_74_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_140 : RowResult ⟨74, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_74_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_74_141 : RowResult ⟨74, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_74_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_142 : RowResult ⟨74, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_74_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_143 : RowResult ⟨74, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_74_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
