import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_132 : RowResult ⟨62, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_133 : RowResult ⟨62, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_62_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_134 : RowResult ⟨62, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_62_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_135 : RowResult ⟨62, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_62_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_136 : RowResult ⟨62, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_62_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_137 : RowResult ⟨62, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_62_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 6)

theorem row_62_138 : RowResult ⟨62, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_62_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
