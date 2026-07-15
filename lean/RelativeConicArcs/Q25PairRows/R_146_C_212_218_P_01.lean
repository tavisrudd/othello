import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_146_212 : RowResult ⟨146, by decide⟩ ⟨212, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_213 : RowResult ⟨146, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_146_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨235, by decide⟩, by decide⟩

theorem row_146_214 : RowResult ⟨146, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_146_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_215 : RowResult ⟨146, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_146_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_216 : RowResult ⟨146, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_146_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_217 : RowResult ⟨146, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_146_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_218 : RowResult ⟨146, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_146_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
