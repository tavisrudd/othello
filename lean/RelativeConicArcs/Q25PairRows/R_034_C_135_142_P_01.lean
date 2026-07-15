import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_135 : RowResult ⟨34, by decide⟩ ⟨135, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 5 6)

theorem row_34_136 : RowResult ⟨34, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_34_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_137 : RowResult ⟨34, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_34_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_34_138 : RowResult ⟨34, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_34_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_139 : RowResult ⟨34, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_34_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_140 : RowResult ⟨34, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_34_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_141 : RowResult ⟨34, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_34_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_142 : RowResult ⟨34, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_34_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
