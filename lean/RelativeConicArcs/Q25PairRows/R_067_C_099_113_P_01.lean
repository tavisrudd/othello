import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_67_99 : RowResult ⟨67, by decide⟩ ⟨99, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_100 : RowResult ⟨67, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_67_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_67_101 : RowResult ⟨67, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_67_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_67_102 : RowResult ⟨67, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_67_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_67_103 : RowResult ⟨67, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_67_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_67_104 : RowResult ⟨67, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_67_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_67_105 : RowResult ⟨67, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_67_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_67_106 : RowResult ⟨67, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_67_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_67_107 : RowResult ⟨67, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_67_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_67_108 : RowResult ⟨67, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_67_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_67_109 : RowResult ⟨67, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_67_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 2 5 6)

theorem row_67_110 : RowResult ⟨67, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_67_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_67_111 : RowResult ⟨67, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_67_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_112 : RowResult ⟨67, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_67_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 7)

theorem row_67_113 : RowResult ⟨67, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_67_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
