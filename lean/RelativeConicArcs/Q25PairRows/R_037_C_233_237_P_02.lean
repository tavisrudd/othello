import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_233 : RowResult ⟨37, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_37_234 : RowResult ⟨37, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_37_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_37_235 : RowResult ⟨37, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_37_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨66, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_37_236 : RowResult ⟨37, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_37_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_37_237 : RowResult ⟨37, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_37_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
