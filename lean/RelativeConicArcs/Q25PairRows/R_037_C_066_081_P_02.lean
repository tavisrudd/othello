import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_66 : RowResult ⟨37, by decide⟩ ⟨66, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_67 : RowResult ⟨37, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_37_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 1 4 7)

theorem row_37_68 : RowResult ⟨37, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_37_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_37_69 : RowResult ⟨37, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_37_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 2 5 7)

theorem row_37_70 : RowResult ⟨37, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_37_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_37_71 : RowResult ⟨37, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_37_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 2 5 6)

theorem row_37_72 : RowResult ⟨37, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_37_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_73 : RowResult ⟨37, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_37_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_74 : RowResult ⟨37, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_37_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_75 : RowResult ⟨37, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_37_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_37_76 : RowResult ⟨37, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_37_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_37_77 : RowResult ⟨37, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_37_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_37_78 : RowResult ⟨37, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_37_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_37_79 : RowResult ⟨37, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_37_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_37_80 : RowResult ⟨37, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_37_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_37_81 : RowResult ⟨37, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_37_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
