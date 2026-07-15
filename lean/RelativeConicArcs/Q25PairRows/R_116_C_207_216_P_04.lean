import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_207 : RowResult ⟨116, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_116_208 : RowResult ⟨116, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_116_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 4 7)

theorem row_116_209 : RowResult ⟨116, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_116_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_116_210 : RowResult ⟨116, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_116_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_116_211 : RowResult ⟨116, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_116_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 7)

theorem row_116_212 : RowResult ⟨116, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_116_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_116_213 : RowResult ⟨116, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_116_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_116_214 : RowResult ⟨116, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_116_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 5 6)

theorem row_116_215 : RowResult ⟨116, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_116_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_216 : RowResult ⟨116, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_116_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
