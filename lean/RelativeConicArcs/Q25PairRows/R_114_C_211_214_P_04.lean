import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_211 : RowResult ⟨114, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_212 : RowResult ⟨114, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_114_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_114_213 : RowResult ⟨114, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_114_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 4 5 6)

theorem row_114_214 : RowResult ⟨114, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_114_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
