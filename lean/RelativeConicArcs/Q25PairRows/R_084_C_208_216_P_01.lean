import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_208 : RowResult ⟨84, by decide⟩ ⟨208, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_84_209 : RowResult ⟨84, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_84_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 6)

theorem row_84_210 : RowResult ⟨84, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_84_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_84_211 : RowResult ⟨84, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_84_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 7)

theorem row_84_212 : RowResult ⟨84, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_84_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_213 : RowResult ⟨84, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_84_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_214 : RowResult ⟨84, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_84_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 6)

theorem row_84_215 : RowResult ⟨84, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_84_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_216 : RowResult ⟨84, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_84_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
