import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_211 : RowResult ⟨96, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_212 : RowResult ⟨96, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_96_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 4 5 6)

theorem row_96_213 : RowResult ⟨96, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_96_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 7)

theorem row_96_214 : RowResult ⟨96, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_96_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_215 : RowResult ⟨96, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_96_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 6)

theorem row_96_216 : RowResult ⟨96, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_96_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_217 : RowResult ⟨96, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_96_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_218 : RowResult ⟨96, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_96_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_219 : RowResult ⟨96, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_96_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_220 : RowResult ⟨96, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_96_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_96_221 : RowResult ⟨96, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_96_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
