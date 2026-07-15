import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_211 : RowResult ⟨94, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_212 : RowResult ⟨94, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_94_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_213 : RowResult ⟨94, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_94_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_94_214 : RowResult ⟨94, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_94_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

theorem row_94_215 : RowResult ⟨94, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_94_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_216 : RowResult ⟨94, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_94_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_94_217 : RowResult ⟨94, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_94_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
