import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_199 : RowResult ⟨71, by decide⟩ ⟨199, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_200 : RowResult ⟨71, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_71_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_71_201 : RowResult ⟨71, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_71_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_71_202 : RowResult ⟨71, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_71_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_71_203 : RowResult ⟨71, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_71_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_71_204 : RowResult ⟨71, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_71_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_71_205 : RowResult ⟨71, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_71_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_71_206 : RowResult ⟨71, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_71_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

theorem row_71_207 : RowResult ⟨71, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_71_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_208 : RowResult ⟨71, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_71_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_209 : RowResult ⟨71, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_71_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_71_210 : RowResult ⟨71, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_71_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_211 : RowResult ⟨71, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_71_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_212 : RowResult ⟨71, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_71_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 5 7)

theorem row_71_213 : RowResult ⟨71, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_71_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 6)

theorem row_71_214 : RowResult ⟨71, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_71_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
