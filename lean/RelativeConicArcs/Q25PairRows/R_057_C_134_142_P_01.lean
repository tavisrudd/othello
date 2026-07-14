import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_134 : RowResult ⟨57, by decide⟩ ⟨134, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_135 : RowResult ⟨57, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_57_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_136 : RowResult ⟨57, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_57_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_137 : RowResult ⟨57, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_57_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_57_138 : RowResult ⟨57, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_57_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 4 5 6)

theorem row_57_139 : RowResult ⟨57, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_57_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 6)

theorem row_57_140 : RowResult ⟨57, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_57_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_141 : RowResult ⟨57, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_57_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_142 : RowResult ⟨57, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_57_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
