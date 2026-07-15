import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_61 : RowResult ⟨60, by decide⟩ ⟨61, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 4 6)

theorem row_60_62 : RowResult ⟨60, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_60_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 4 6)

theorem row_60_63 : RowResult ⟨60, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_60_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 4 6)

theorem row_60_64 : RowResult ⟨60, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_60_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 4 6)

theorem row_60_65 : RowResult ⟨60, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_60_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 4 6)

theorem row_60_66 : RowResult ⟨60, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_60_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 4 6)

theorem row_60_67 : RowResult ⟨60, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_60_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 4 6)

theorem row_60_68 : RowResult ⟨60, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_60_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 4 6)

theorem row_60_69 : RowResult ⟨60, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_60_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_60_70 : RowResult ⟨60, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_60_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_60_71 : RowResult ⟨60, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_60_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_60_72 : RowResult ⟨60, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_60_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_60_73 : RowResult ⟨60, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_60_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_60_74 : RowResult ⟨60, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_60_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_60_75 : RowResult ⟨60, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_60_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_60_76 : RowResult ⟨60, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_60_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_60_77 : RowResult ⟨60, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_60_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_60_78 : RowResult ⟨60, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_60_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_60_79 : RowResult ⟨60, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_60_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_60_80 : RowResult ⟨60, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_60_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_60_81 : RowResult ⟨60, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_60_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_82 : RowResult ⟨60, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_60_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_83 : RowResult ⟨60, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_60_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_60_84 : RowResult ⟨60, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_60_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 2 5 6)

theorem row_60_85 : RowResult ⟨60, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_60_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 6)

theorem row_60_86 : RowResult ⟨60, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_60_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_60_87 : RowResult ⟨60, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_60_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 4 6)

theorem row_60_88 : RowResult ⟨60, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_60_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_89 : RowResult ⟨60, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_60_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_90 : RowResult ⟨60, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_60_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 7)

theorem row_60_91 : RowResult ⟨60, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_60_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_92 : RowResult ⟨60, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_60_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
