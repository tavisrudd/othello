import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_134 : RowResult ⟨63, by decide⟩ ⟨134, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_63_135 : RowResult ⟨63, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_63_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_63_136 : RowResult ⟨63, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_63_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_63_137 : RowResult ⟨63, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_63_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_63_138 : RowResult ⟨63, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_63_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 6)

theorem row_63_139 : RowResult ⟨63, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_63_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_63_140 : RowResult ⟨63, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_63_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_63_141 : RowResult ⟨63, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_63_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
