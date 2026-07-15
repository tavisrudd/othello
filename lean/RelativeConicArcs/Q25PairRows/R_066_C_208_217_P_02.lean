import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_208 : RowResult ⟨66, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_66_209 : RowResult ⟨66, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_66_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_66_210 : RowResult ⟨66, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_66_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_66_211 : RowResult ⟨66, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_66_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 7)

theorem row_66_212 : RowResult ⟨66, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_66_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_66_213 : RowResult ⟨66, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_66_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_66_214 : RowResult ⟨66, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_66_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_66_215 : RowResult ⟨66, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_66_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 4 5 6)

theorem row_66_216 : RowResult ⟨66, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_66_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

theorem row_66_217 : RowResult ⟨66, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_66_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
