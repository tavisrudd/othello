import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_93 : RowResult ⟨34, by decide⟩ ⟨93, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_94 : RowResult ⟨34, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_34_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 4 6)

theorem row_34_95 : RowResult ⟨34, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_34_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_34_96 : RowResult ⟨34, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_34_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_34_97 : RowResult ⟨34, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_34_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_98 : RowResult ⟨34, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_34_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_99 : RowResult ⟨34, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_34_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 7)

theorem row_34_100 : RowResult ⟨34, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_34_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_34_101 : RowResult ⟨34, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_34_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_34_102 : RowResult ⟨34, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_34_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_34_103 : RowResult ⟨34, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_34_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_34_104 : RowResult ⟨34, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_34_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_34_105 : RowResult ⟨34, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_34_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_34_106 : RowResult ⟨34, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_34_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_34_107 : RowResult ⟨34, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_34_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_34_108 : RowResult ⟨34, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_34_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_109 : RowResult ⟨34, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_34_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
