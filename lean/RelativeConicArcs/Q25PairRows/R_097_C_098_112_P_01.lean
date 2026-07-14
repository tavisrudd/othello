import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_98 : RowResult ⟨97, by decide⟩ ⟨98, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_97_99 : RowResult ⟨97, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_97_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_97_100 : RowResult ⟨97, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_97_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_97_101 : RowResult ⟨97, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_97_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_97_102 : RowResult ⟨97, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_97_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_97_103 : RowResult ⟨97, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_97_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_97_104 : RowResult ⟨97, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_97_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_97_105 : RowResult ⟨97, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_97_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_97_106 : RowResult ⟨97, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_97_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_97_107 : RowResult ⟨97, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_97_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 7)

theorem row_97_108 : RowResult ⟨97, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_97_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_97_109 : RowResult ⟨97, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_97_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_97_110 : RowResult ⟨97, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_97_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_97_111 : RowResult ⟨97, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_97_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_97_112 : RowResult ⟨97, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_97_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
