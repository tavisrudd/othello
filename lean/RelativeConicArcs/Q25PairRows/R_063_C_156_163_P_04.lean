import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_156 : RowResult ⟨63, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_63_157 : RowResult ⟨63, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_63_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_63_158 : RowResult ⟨63, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_63_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_63_159 : RowResult ⟨63, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_63_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_63_160 : RowResult ⟨63, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_63_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 4 7)

theorem row_63_161 : RowResult ⟨63, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_63_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_63_162 : RowResult ⟨63, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_63_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 4 5 6)

theorem row_63_163 : RowResult ⟨63, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_63_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
