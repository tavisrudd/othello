import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_191 : RowResult ⟨139, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_192 : RowResult ⟨139, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_139_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_193 : RowResult ⟨139, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_139_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_194 : RowResult ⟨139, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_139_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 7)

theorem row_139_195 : RowResult ⟨139, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_139_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_139_196 : RowResult ⟨139, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_139_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_197 : RowResult ⟨139, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_139_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 5 6)

theorem row_139_198 : RowResult ⟨139, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_139_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_199 : RowResult ⟨139, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_139_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_200 : RowResult ⟨139, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_139_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_139_201 : RowResult ⟨139, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_139_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_139_202 : RowResult ⟨139, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_139_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_139_203 : RowResult ⟨139, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_139_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_139_204 : RowResult ⟨139, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_139_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_139_205 : RowResult ⟨139, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_139_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_139_206 : RowResult ⟨139, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_139_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
