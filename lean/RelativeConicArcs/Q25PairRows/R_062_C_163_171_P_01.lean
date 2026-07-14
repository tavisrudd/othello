import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_163 : RowResult ⟨62, by decide⟩ ⟨163, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_164 : RowResult ⟨62, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_62_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_165 : RowResult ⟨62, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_62_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_166 : RowResult ⟨62, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_62_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_167 : RowResult ⟨62, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_62_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 7)

theorem row_62_168 : RowResult ⟨62, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_62_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_169 : RowResult ⟨62, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_62_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_170 : RowResult ⟨62, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_62_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_62_171 : RowResult ⟨62, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_62_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
