import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_134 : RowResult ⟨33, by decide⟩ ⟨134, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 4 5 6)

theorem row_33_135 : RowResult ⟨33, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_33_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_33_136 : RowResult ⟨33, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_33_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 5 7)

theorem row_33_137 : RowResult ⟨33, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_33_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_33_138 : RowResult ⟨33, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_33_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_139 : RowResult ⟨33, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_33_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_140 : RowResult ⟨33, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_33_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_141 : RowResult ⟨33, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_33_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_142 : RowResult ⟨33, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_33_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
