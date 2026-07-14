import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_99 : RowResult ⟨61, by decide⟩ ⟨99, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_100 : RowResult ⟨61, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_61_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_61_101 : RowResult ⟨61, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_61_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_61_102 : RowResult ⟨61, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_61_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_61_103 : RowResult ⟨61, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_61_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_61_104 : RowResult ⟨61, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_61_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_61_105 : RowResult ⟨61, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_61_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_61_106 : RowResult ⟨61, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_61_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_107 : RowResult ⟨61, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_61_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_61_108 : RowResult ⟨61, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_61_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_109 : RowResult ⟨61, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_61_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_110 : RowResult ⟨61, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_61_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_111 : RowResult ⟨61, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_61_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 6)

theorem row_61_112 : RowResult ⟨61, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_61_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_113 : RowResult ⟨61, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_61_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
