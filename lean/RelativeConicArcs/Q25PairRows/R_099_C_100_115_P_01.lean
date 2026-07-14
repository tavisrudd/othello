import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_100 : RowResult ⟨99, by decide⟩ ⟨100, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_99_101 : RowResult ⟨99, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_99_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_99_102 : RowResult ⟨99, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_99_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_99_103 : RowResult ⟨99, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_99_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_99_104 : RowResult ⟨99, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_99_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_99_105 : RowResult ⟨99, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_99_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_99_106 : RowResult ⟨99, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_99_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_99_107 : RowResult ⟨99, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_99_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_99_108 : RowResult ⟨99, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_99_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_99_109 : RowResult ⟨99, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_99_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 7)

theorem row_99_110 : RowResult ⟨99, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_99_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 5 7)

theorem row_99_111 : RowResult ⟨99, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_99_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 4 5 6)

theorem row_99_112 : RowResult ⟨99, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_99_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_113 : RowResult ⟨99, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_99_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_114 : RowResult ⟨99, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_99_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_99_115 : RowResult ⟨99, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_99_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
