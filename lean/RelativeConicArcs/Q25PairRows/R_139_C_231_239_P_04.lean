import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_231 : RowResult ⟨139, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_139_232 : RowResult ⟨139, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_139_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_139_233 : RowResult ⟨139, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_139_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_139_234 : RowResult ⟨139, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_139_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_139_235 : RowResult ⟨139, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_139_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_139_236 : RowResult ⟨139, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_139_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_139_237 : RowResult ⟨139, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_139_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_139_238 : RowResult ⟨139, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_139_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_139_239 : RowResult ⟨139, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_139_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
