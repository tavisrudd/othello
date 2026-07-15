import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_207 : RowResult ⟨74, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_208 : RowResult ⟨74, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_74_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 5 7)

theorem row_74_209 : RowResult ⟨74, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_74_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 7)

theorem row_74_210 : RowResult ⟨74, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_74_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_74_211 : RowResult ⟨74, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_74_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_212 : RowResult ⟨74, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_74_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_74_213 : RowResult ⟨74, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_74_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_74_214 : RowResult ⟨74, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_74_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
