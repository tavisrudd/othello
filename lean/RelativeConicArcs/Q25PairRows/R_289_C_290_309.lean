import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_289_290 : RowResult ⟨289, by decide⟩ ⟨290, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 4 5)

theorem row_289_291 : RowResult ⟨289, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_289_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 4 5)

theorem row_289_292 : RowResult ⟨289, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_289_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 4 5)

theorem row_289_293 : RowResult ⟨289, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_289_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 4 5)

theorem row_289_294 : RowResult ⟨289, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_289_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 4 5)

theorem row_289_295 : RowResult ⟨289, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_289_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 4 5)

theorem row_289_296 : RowResult ⟨289, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_289_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 4 5)

theorem row_289_297 : RowResult ⟨289, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_289_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 4 5)

theorem row_289_298 : RowResult ⟨289, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_289_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 4 5)

theorem row_289_299 : RowResult ⟨289, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_289_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 4 5)

theorem row_289_300 : RowResult ⟨289, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_289_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_289_301 : RowResult ⟨289, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_289_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_289_302 : RowResult ⟨289, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_289_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_289_303 : RowResult ⟨289, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_289_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_289_304 : RowResult ⟨289, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_289_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_289_305 : RowResult ⟨289, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_289_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_289_306 : RowResult ⟨289, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_289_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_289_307 : RowResult ⟨289, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_289_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_289_308 : RowResult ⟨289, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_289_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_289_309 : RowResult ⟨289, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_289_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
