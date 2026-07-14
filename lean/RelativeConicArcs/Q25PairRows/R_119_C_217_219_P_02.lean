import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_217 : RowResult ⟨119, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_218 : RowResult ⟨119, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_119_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 7)

theorem row_119_219 : RowResult ⟨119, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_119_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
