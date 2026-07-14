import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_67 : RowResult ⟨36, by decide⟩ ⟨67, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_68 : RowResult ⟨36, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_36_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_69 : RowResult ⟨36, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_36_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 2 4 7)

theorem row_36_70 : RowResult ⟨36, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_36_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_36_71 : RowResult ⟨36, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_36_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 2 4 6)

theorem row_36_72 : RowResult ⟨36, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_36_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_73 : RowResult ⟨36, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_36_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_74 : RowResult ⟨36, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_36_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_75 : RowResult ⟨36, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_36_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_36_76 : RowResult ⟨36, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_36_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_36_77 : RowResult ⟨36, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_36_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_36_78 : RowResult ⟨36, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_36_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_36_79 : RowResult ⟨36, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_36_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_36_80 : RowResult ⟨36, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_36_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_36_81 : RowResult ⟨36, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_36_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
