import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_302_303 : RowResult ⟨302, by decide⟩ ⟨303, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 4)

theorem row_302_304 : RowResult ⟨302, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_302_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 4)

theorem row_302_305 : RowResult ⟨302, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_302_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 4)

theorem row_302_306 : RowResult ⟨302, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_302_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 4)

theorem row_302_307 : RowResult ⟨302, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_302_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 4)

theorem row_302_308 : RowResult ⟨302, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_302_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 4)

theorem row_302_309 : RowResult ⟨302, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_302_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 4)

end RelativeConicArcs.Q25PairCertificate
