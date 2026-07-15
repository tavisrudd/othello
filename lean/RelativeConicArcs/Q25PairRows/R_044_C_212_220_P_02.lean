import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_212 : RowResult ⟨44, by decide⟩ ⟨212, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_44_213 : RowResult ⟨44, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_44_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_44_214 : RowResult ⟨44, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_44_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

theorem row_44_215 : RowResult ⟨44, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_44_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨68, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_44_216 : RowResult ⟨44, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_44_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_217 : RowResult ⟨44, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_44_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_218 : RowResult ⟨44, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_44_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_44_219 : RowResult ⟨44, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_44_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 6)

theorem row_44_220 : RowResult ⟨44, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_44_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
