import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_207 : RowResult ⟨73, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_208 : RowResult ⟨73, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_73_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 7)

theorem row_73_209 : RowResult ⟨73, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_73_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_73_210 : RowResult ⟨73, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_73_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_211 : RowResult ⟨73, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_73_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_212 : RowResult ⟨73, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_73_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_73_213 : RowResult ⟨73, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_73_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨236, by decide⟩, by decide⟩

theorem row_73_214 : RowResult ⟨73, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_73_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_73_215 : RowResult ⟨73, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_73_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 7)

theorem row_73_216 : RowResult ⟨73, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_73_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 7)

theorem row_73_217 : RowResult ⟨73, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_73_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
