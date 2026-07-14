import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_180_281 : RowResult ⟨180, by decide⟩ ⟨281, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_180_282 : RowResult ⟨180, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_180_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_180_283 : RowResult ⟨180, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_180_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_180_284 : RowResult ⟨180, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_180_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_180_285 : RowResult ⟨180, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_180_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_180_286 : RowResult ⟨180, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_180_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_180_287 : RowResult ⟨180, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_180_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_180_288 : RowResult ⟨180, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_180_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_180_289 : RowResult ⟨180, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_180_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_180_290 : RowResult ⟨180, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_180_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_180_291 : RowResult ⟨180, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_180_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_180_292 : RowResult ⟨180, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_180_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_180_293 : RowResult ⟨180, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_180_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_180_294 : RowResult ⟨180, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_180_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_180_295 : RowResult ⟨180, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_180_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_180_296 : RowResult ⟨180, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_180_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_180_297 : RowResult ⟨180, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_180_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_180_298 : RowResult ⟨180, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_180_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_180_299 : RowResult ⟨180, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_180_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_180_300 : RowResult ⟨180, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_180_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_180_301 : RowResult ⟨180, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_180_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_180_302 : RowResult ⟨180, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_180_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_180_303 : RowResult ⟨180, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_180_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_180_304 : RowResult ⟨180, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_180_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_180_305 : RowResult ⟨180, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_180_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_180_306 : RowResult ⟨180, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_180_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_180_307 : RowResult ⟨180, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_180_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_180_308 : RowResult ⟨180, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_180_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_180_309 : RowResult ⟨180, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_180_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
