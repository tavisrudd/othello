import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_138_231 : RowResult ⟨138, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_138_232 : RowResult ⟨138, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_138_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 6)

theorem row_138_233 : RowResult ⟨138, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_138_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 6)

theorem row_138_234 : RowResult ⟨138, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_138_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 7)

theorem row_138_235 : RowResult ⟨138, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_138_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 4 5 6)

theorem row_138_236 : RowResult ⟨138, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_138_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 7)

theorem row_138_237 : RowResult ⟨138, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_138_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_138_238 : RowResult ⟨138, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_138_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
