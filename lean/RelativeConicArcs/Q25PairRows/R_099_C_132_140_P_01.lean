import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_132 : RowResult ⟨99, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_133 : RowResult ⟨99, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_99_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_99_134 : RowResult ⟨99, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_99_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 7)

theorem row_99_135 : RowResult ⟨99, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_99_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_99_136 : RowResult ⟨99, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_99_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_137 : RowResult ⟨99, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_99_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_99_138 : RowResult ⟨99, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_99_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_139 : RowResult ⟨99, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_99_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 6)

theorem row_99_140 : RowResult ⟨99, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_99_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
