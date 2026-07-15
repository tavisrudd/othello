import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_168 : RowResult ⟨74, by decide⟩ ⟨168, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_169 : RowResult ⟨74, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_74_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_74_170 : RowResult ⟨74, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_74_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_74_171 : RowResult ⟨74, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_74_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_172 : RowResult ⟨74, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_74_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 4 5 6)

theorem row_74_173 : RowResult ⟨74, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_74_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_174 : RowResult ⟨74, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_74_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
