import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_90 : RowResult ⟨57, by decide⟩ ⟨90, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_91 : RowResult ⟨57, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_57_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 5 6)

theorem row_57_92 : RowResult ⟨57, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_57_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 4 6)

theorem row_57_93 : RowResult ⟨57, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_57_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_94 : RowResult ⟨57, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_57_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_57_95 : RowResult ⟨57, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_57_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_57_96 : RowResult ⟨57, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_57_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_97 : RowResult ⟨57, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_57_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 7)

theorem row_57_98 : RowResult ⟨57, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_57_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_99 : RowResult ⟨57, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_57_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 2 5 7)

theorem row_57_100 : RowResult ⟨57, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_57_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_57_101 : RowResult ⟨57, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_57_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_57_102 : RowResult ⟨57, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_57_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_57_103 : RowResult ⟨57, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_57_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_57_104 : RowResult ⟨57, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_57_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_57_105 : RowResult ⟨57, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_57_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_57_106 : RowResult ⟨57, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_57_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_107 : RowResult ⟨57, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_57_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 6)

theorem row_57_108 : RowResult ⟨57, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_57_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 4 5 6)

theorem row_57_109 : RowResult ⟨57, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_57_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 2 4 6)

theorem row_57_110 : RowResult ⟨57, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_57_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
