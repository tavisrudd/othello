import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_147_210 : RowResult ⟨147, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_147_211 : RowResult ⟨147, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_147_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 4 5 6)

theorem row_147_212 : RowResult ⟨147, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_147_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_147_213 : RowResult ⟨147, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_147_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_147_214 : RowResult ⟨147, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_147_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_147_215 : RowResult ⟨147, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_147_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_147_216 : RowResult ⟨147, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_147_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_147_217 : RowResult ⟨147, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_147_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
