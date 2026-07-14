import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_208 : RowResult ⟨89, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_209 : RowResult ⟨89, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_89_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_89_210 : RowResult ⟨89, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_89_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_211 : RowResult ⟨89, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_89_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_212 : RowResult ⟨89, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_89_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_213 : RowResult ⟨89, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_89_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_214 : RowResult ⟨89, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_89_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 6)

theorem row_89_215 : RowResult ⟨89, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_89_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 7)

theorem row_89_216 : RowResult ⟨89, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_89_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_217 : RowResult ⟨89, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_89_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 6)

theorem row_89_218 : RowResult ⟨89, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_89_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 6)

theorem row_89_219 : RowResult ⟨89, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_89_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 7)

theorem row_89_220 : RowResult ⟨89, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_89_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
