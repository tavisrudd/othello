import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_131 : RowResult ⟨82, by decide⟩ ⟨131, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_132 : RowResult ⟨82, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_82_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 6)

theorem row_82_133 : RowResult ⟨82, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_82_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_134 : RowResult ⟨82, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_82_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_135 : RowResult ⟨82, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_82_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_82_136 : RowResult ⟨82, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_82_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 5 6)

theorem row_82_137 : RowResult ⟨82, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_82_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_82_138 : RowResult ⟨82, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_82_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_82_139 : RowResult ⟨82, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_82_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_140 : RowResult ⟨82, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_82_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
