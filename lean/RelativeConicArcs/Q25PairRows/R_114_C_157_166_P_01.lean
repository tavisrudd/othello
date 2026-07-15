import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_157 : RowResult ⟨114, by decide⟩ ⟨157, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_158 : RowResult ⟨114, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_114_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_114_159 : RowResult ⟨114, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_114_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_160 : RowResult ⟨114, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_114_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_114_161 : RowResult ⟨114, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_114_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 4 5 6)

theorem row_114_162 : RowResult ⟨114, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_114_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_163 : RowResult ⟨114, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_114_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 5 6)

theorem row_114_164 : RowResult ⟨114, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_114_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 6)

theorem row_114_165 : RowResult ⟨114, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_114_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_166 : RowResult ⟨114, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_114_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
