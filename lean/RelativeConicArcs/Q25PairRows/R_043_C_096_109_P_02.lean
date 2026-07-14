import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_96 : RowResult ⟨43, by decide⟩ ⟨96, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_97 : RowResult ⟨43, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_43_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_98 : RowResult ⟨43, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_43_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_99 : RowResult ⟨43, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_43_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_43_100 : RowResult ⟨43, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_43_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_43_101 : RowResult ⟨43, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_43_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_43_102 : RowResult ⟨43, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_43_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_43_103 : RowResult ⟨43, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_43_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_43_104 : RowResult ⟨43, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_43_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_43_105 : RowResult ⟨43, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_43_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_43_106 : RowResult ⟨43, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_43_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_107 : RowResult ⟨43, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_43_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_43_108 : RowResult ⟨43, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_43_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 5 7)

theorem row_43_109 : RowResult ⟨43, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_43_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
