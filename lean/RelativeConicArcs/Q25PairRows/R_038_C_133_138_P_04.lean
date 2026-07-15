import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_133 : RowResult ⟨38, by decide⟩ ⟨133, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_134 : RowResult ⟨38, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_38_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_38_135 : RowResult ⟨38, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_38_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 4 5 6)

theorem row_38_136 : RowResult ⟨38, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_38_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_137 : RowResult ⟨38, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_38_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_38_138 : RowResult ⟨38, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_38_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
