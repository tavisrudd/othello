import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_131 : RowResult ⟨94, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_132 : RowResult ⟨94, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_94_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_133 : RowResult ⟨94, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_94_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_94_134 : RowResult ⟨94, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_94_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_94_135 : RowResult ⟨94, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_94_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_94_136 : RowResult ⟨94, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_94_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_94_137 : RowResult ⟨94, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_94_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
