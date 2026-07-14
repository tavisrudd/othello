import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_136 : RowResult ⟨84, by decide⟩ ⟨136, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_84_137 : RowResult ⟨84, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_84_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_84_138 : RowResult ⟨84, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_84_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_139 : RowResult ⟨84, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_84_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_140 : RowResult ⟨84, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_84_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_84_141 : RowResult ⟨84, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_84_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_142 : RowResult ⟨84, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_84_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
