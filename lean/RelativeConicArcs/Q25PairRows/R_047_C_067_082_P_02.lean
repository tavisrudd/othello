import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_67 : RowResult ⟨47, by decide⟩ ⟨67, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_68 : RowResult ⟨47, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_47_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨89, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_69 : RowResult ⟨47, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_47_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_70 : RowResult ⟨47, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_47_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_47_71 : RowResult ⟨47, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_47_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_72 : RowResult ⟨47, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_47_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 1 4 6)

theorem row_47_73 : RowResult ⟨47, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_47_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_74 : RowResult ⟨47, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_47_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 2 4 7)

theorem row_47_75 : RowResult ⟨47, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_47_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_47_76 : RowResult ⟨47, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_47_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_47_77 : RowResult ⟨47, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_47_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_47_78 : RowResult ⟨47, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_47_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_47_79 : RowResult ⟨47, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_47_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_47_80 : RowResult ⟨47, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_47_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_47_81 : RowResult ⟨47, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_47_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_82 : RowResult ⟨47, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_47_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
