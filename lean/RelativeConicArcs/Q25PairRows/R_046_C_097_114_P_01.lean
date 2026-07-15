import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_97 : RowResult ⟨46, by decide⟩ ⟨97, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_46_98 : RowResult ⟨46, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_46_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 4 5 6)

theorem row_46_99 : RowResult ⟨46, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_46_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_100 : RowResult ⟨46, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_46_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_46_101 : RowResult ⟨46, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_46_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_46_102 : RowResult ⟨46, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_46_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_46_103 : RowResult ⟨46, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_46_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_46_104 : RowResult ⟨46, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_46_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_46_105 : RowResult ⟨46, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_46_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_46_106 : RowResult ⟨46, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_46_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 7)

theorem row_46_107 : RowResult ⟨46, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_46_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_46_108 : RowResult ⟨46, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_46_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_109 : RowResult ⟨46, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_46_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 2 5 7)

theorem row_46_110 : RowResult ⟨46, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_46_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 4 5 6)

theorem row_46_111 : RowResult ⟨46, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_46_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 4 6)

theorem row_46_112 : RowResult ⟨46, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_46_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_113 : RowResult ⟨46, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_46_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_46_114 : RowResult ⟨46, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_46_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
