import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_156 : RowResult ⟨108, by decide⟩ ⟨156, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_108_157 : RowResult ⟨108, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_108_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 4 6)

theorem row_108_158 : RowResult ⟨108, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_108_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 6)

theorem row_108_159 : RowResult ⟨108, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_108_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 4 5 6)

theorem row_108_160 : RowResult ⟨108, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_108_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_108_161 : RowResult ⟨108, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_108_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_162 : RowResult ⟨108, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_108_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 4 7)

theorem row_108_163 : RowResult ⟨108, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_108_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_164 : RowResult ⟨108, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_108_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 5 6)

theorem row_108_165 : RowResult ⟨108, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_108_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_166 : RowResult ⟨108, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_108_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
