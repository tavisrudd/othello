import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_68 : RowResult ⟨34, by decide⟩ ⟨68, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_69 : RowResult ⟨34, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_34_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_70 : RowResult ⟨34, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_34_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_34_71 : RowResult ⟨34, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_34_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_34_72 : RowResult ⟨34, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_34_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_73 : RowResult ⟨34, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_34_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_74 : RowResult ⟨34, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_34_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 1 4 7)

theorem row_34_75 : RowResult ⟨34, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_34_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_34_76 : RowResult ⟨34, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_34_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_34_77 : RowResult ⟨34, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_34_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_34_78 : RowResult ⟨34, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_34_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_34_79 : RowResult ⟨34, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_34_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_34_80 : RowResult ⟨34, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_34_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_34_81 : RowResult ⟨34, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_34_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 2 5 6)

theorem row_34_82 : RowResult ⟨34, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_34_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 4 5 6)

theorem row_34_83 : RowResult ⟨34, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_34_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_84 : RowResult ⟨34, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_34_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
