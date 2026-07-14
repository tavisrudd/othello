import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_131 : RowResult ⟨61, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_61_132 : RowResult ⟨61, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_61_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_133 : RowResult ⟨61, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_61_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_61_134 : RowResult ⟨61, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_61_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_135 : RowResult ⟨61, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_61_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_136 : RowResult ⟨61, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_61_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 6)

theorem row_61_137 : RowResult ⟨61, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_61_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_61_138 : RowResult ⟨61, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_61_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 7)

theorem row_61_139 : RowResult ⟨61, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_61_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
