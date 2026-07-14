import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_161 : RowResult ⟨84, by decide⟩ ⟨161, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_162 : RowResult ⟨84, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_84_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 5 7)

theorem row_84_163 : RowResult ⟨84, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_84_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_84_164 : RowResult ⟨84, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_84_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_165 : RowResult ⟨84, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_84_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 4 5 6)

theorem row_84_166 : RowResult ⟨84, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_84_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_167 : RowResult ⟨84, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_84_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_168 : RowResult ⟨84, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_84_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 4 6)

theorem row_84_169 : RowResult ⟨84, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_84_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_84_170 : RowResult ⟨84, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_84_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
