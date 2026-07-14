import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_98 : RowResult ⟨41, by decide⟩ ⟨98, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_99 : RowResult ⟨41, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_41_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 2 5 7)

theorem row_41_100 : RowResult ⟨41, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_41_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_41_101 : RowResult ⟨41, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_41_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_41_102 : RowResult ⟨41, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_41_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_41_103 : RowResult ⟨41, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_41_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_41_104 : RowResult ⟨41, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_41_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_41_105 : RowResult ⟨41, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_41_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_41_106 : RowResult ⟨41, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_41_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_107 : RowResult ⟨41, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_41_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_41_108 : RowResult ⟨41, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_41_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_109 : RowResult ⟨41, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_41_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_110 : RowResult ⟨41, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_41_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 5 7)

theorem row_41_111 : RowResult ⟨41, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_41_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 7)

theorem row_41_112 : RowResult ⟨41, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_41_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 4 7)

theorem row_41_113 : RowResult ⟨41, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_41_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_114 : RowResult ⟨41, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_41_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 4 6)

theorem row_41_115 : RowResult ⟨41, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_41_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_116 : RowResult ⟨41, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_41_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
