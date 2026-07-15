import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_210 : RowResult ⟨48, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_211 : RowResult ⟨48, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_48_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 4 5 6)

theorem row_48_212 : RowResult ⟨48, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_48_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 6)

theorem row_48_213 : RowResult ⟨48, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_48_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_214 : RowResult ⟨48, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_48_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_215 : RowResult ⟨48, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_48_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_216 : RowResult ⟨48, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_48_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_48_217 : RowResult ⟨48, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_48_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
