import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_156 : RowResult ⟨61, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_157 : RowResult ⟨61, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_61_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 5 7)

theorem row_61_158 : RowResult ⟨61, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_61_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_61_159 : RowResult ⟨61, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_61_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_61_160 : RowResult ⟨61, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_61_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 4 5 6)

theorem row_61_161 : RowResult ⟨61, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_61_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
