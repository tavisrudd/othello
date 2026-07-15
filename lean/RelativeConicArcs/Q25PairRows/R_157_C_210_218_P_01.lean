import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_157_210 : RowResult ⟨157, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_157_211 : RowResult ⟨157, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_157_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 4 7)

theorem row_157_212 : RowResult ⟨157, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_157_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_157_213 : RowResult ⟨157, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_157_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_157_214 : RowResult ⟨157, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_157_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_157_215 : RowResult ⟨157, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_157_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 7)

theorem row_157_216 : RowResult ⟨157, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_157_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_157_217 : RowResult ⟨157, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_157_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 6)

theorem row_157_218 : RowResult ⟨157, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_157_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
