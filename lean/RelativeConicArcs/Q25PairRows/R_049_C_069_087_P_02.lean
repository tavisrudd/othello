import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_69 : RowResult ⟨49, by decide⟩ ⟨69, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_70 : RowResult ⟨49, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_49_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_49_71 : RowResult ⟨49, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_49_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨88, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_49_72 : RowResult ⟨49, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_49_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨88, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_73 : RowResult ⟨49, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_49_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_74 : RowResult ⟨49, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_49_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 1 4 6)

theorem row_49_75 : RowResult ⟨49, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_49_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_49_76 : RowResult ⟨49, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_49_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_49_77 : RowResult ⟨49, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_49_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_49_78 : RowResult ⟨49, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_49_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_49_79 : RowResult ⟨49, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_49_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_49_80 : RowResult ⟨49, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_49_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_49_81 : RowResult ⟨49, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_49_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 2 4 7)

theorem row_49_82 : RowResult ⟨49, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_49_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 2 4 6)

theorem row_49_83 : RowResult ⟨49, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_49_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_49_84 : RowResult ⟨49, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_49_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 7)

theorem row_49_85 : RowResult ⟨49, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_49_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_86 : RowResult ⟨49, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_49_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_49_87 : RowResult ⟨49, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_49_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
