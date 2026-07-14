import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_132 : RowResult ⟨93, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_93_133 : RowResult ⟨93, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_93_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_93_134 : RowResult ⟨93, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_93_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_93_135 : RowResult ⟨93, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_93_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_93_136 : RowResult ⟨93, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_93_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_93_137 : RowResult ⟨93, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_93_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_93_138 : RowResult ⟨93, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_93_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 7)

theorem row_93_139 : RowResult ⟨93, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_93_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
