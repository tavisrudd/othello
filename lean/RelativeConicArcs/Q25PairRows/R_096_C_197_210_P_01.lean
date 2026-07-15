import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_197 : RowResult ⟨96, by decide⟩ ⟨197, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_198 : RowResult ⟨96, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_96_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_96_199 : RowResult ⟨96, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_96_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_96_200 : RowResult ⟨96, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_96_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_96_201 : RowResult ⟨96, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_96_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_96_202 : RowResult ⟨96, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_96_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_96_203 : RowResult ⟨96, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_96_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_96_204 : RowResult ⟨96, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_96_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_96_205 : RowResult ⟨96, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_96_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_96_206 : RowResult ⟨96, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_96_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

theorem row_96_207 : RowResult ⟨96, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_96_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_208 : RowResult ⟨96, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_96_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_96_209 : RowResult ⟨96, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_96_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_96_210 : RowResult ⟨96, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_96_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
