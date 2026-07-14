import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_112 : RowResult ⟨58, by decide⟩ ⟨112, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_113 : RowResult ⟨58, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_58_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_114 : RowResult ⟨58, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_58_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_58_115 : RowResult ⟨58, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_58_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_116 : RowResult ⟨58, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_58_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_117 : RowResult ⟨58, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_58_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_58_118 : RowResult ⟨58, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_58_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
