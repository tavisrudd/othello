import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_97 : RowResult ⟨49, by decide⟩ ⟨97, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_49_98 : RowResult ⟨49, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_49_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_99 : RowResult ⟨49, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_49_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 6)

theorem row_49_100 : RowResult ⟨49, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_49_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_49_101 : RowResult ⟨49, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_49_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_49_102 : RowResult ⟨49, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_49_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_49_103 : RowResult ⟨49, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_49_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_49_104 : RowResult ⟨49, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_49_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_49_105 : RowResult ⟨49, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_49_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_49_106 : RowResult ⟨49, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_49_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_49_107 : RowResult ⟨49, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_49_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_49_108 : RowResult ⟨49, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_49_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 4 7)

theorem row_49_109 : RowResult ⟨49, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_49_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 7)

theorem row_49_110 : RowResult ⟨49, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_49_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_111 : RowResult ⟨49, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_49_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 5 7)

theorem row_49_112 : RowResult ⟨49, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_49_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_113 : RowResult ⟨49, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_49_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 4 5 6)

theorem row_49_114 : RowResult ⟨49, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_49_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_115 : RowResult ⟨49, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_49_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
