import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_99 : RowResult ⟨73, by decide⟩ ⟨99, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_73_100 : RowResult ⟨73, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_73_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_73_101 : RowResult ⟨73, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_73_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_73_102 : RowResult ⟨73, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_73_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_73_103 : RowResult ⟨73, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_73_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_73_104 : RowResult ⟨73, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_73_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_73_105 : RowResult ⟨73, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_73_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_73_106 : RowResult ⟨73, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_73_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_73_107 : RowResult ⟨73, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_73_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_73_108 : RowResult ⟨73, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_73_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 7)

theorem row_73_109 : RowResult ⟨73, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_73_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_110 : RowResult ⟨73, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_73_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_73_111 : RowResult ⟨73, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_73_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 4 6)

theorem row_73_112 : RowResult ⟨73, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_73_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_113 : RowResult ⟨73, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_73_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_114 : RowResult ⟨73, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_73_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
