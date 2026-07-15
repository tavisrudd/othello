import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_159_206 : RowResult ⟨159, by decide⟩ ⟨206, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_159_207 : RowResult ⟨159, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_159_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 6)

theorem row_159_208 : RowResult ⟨159, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_159_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_159_209 : RowResult ⟨159, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_159_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 6)

theorem row_159_210 : RowResult ⟨159, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_159_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_159_211 : RowResult ⟨159, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_159_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_159_212 : RowResult ⟨159, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_159_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_159_213 : RowResult ⟨159, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_159_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨236, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
