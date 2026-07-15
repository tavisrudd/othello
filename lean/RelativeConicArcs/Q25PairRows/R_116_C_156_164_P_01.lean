import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_156 : RowResult ⟨116, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_157 : RowResult ⟨116, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_116_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_158 : RowResult ⟨116, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_116_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_116_159 : RowResult ⟨116, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_116_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_116_160 : RowResult ⟨116, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_116_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 4 7)

theorem row_116_161 : RowResult ⟨116, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_116_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 7)

theorem row_116_162 : RowResult ⟨116, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_116_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_116_163 : RowResult ⟨116, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_116_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_164 : RowResult ⟨116, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_116_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
