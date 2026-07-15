import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_64 : RowResult ⟨43, by decide⟩ ⟨64, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_65 : RowResult ⟨43, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_43_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 2 5 7)

theorem row_43_66 : RowResult ⟨43, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_43_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_67 : RowResult ⟨43, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_43_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_68 : RowResult ⟨43, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_43_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 1 4 6)

theorem row_43_69 : RowResult ⟨43, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_43_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨90, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_70 : RowResult ⟨43, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_43_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_43_71 : RowResult ⟨43, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_43_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 2 4 7)

theorem row_43_72 : RowResult ⟨43, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_43_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 4 5 6)

theorem row_43_73 : RowResult ⟨43, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_43_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_43_74 : RowResult ⟨43, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_43_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨89, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_75 : RowResult ⟨43, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_43_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_43_76 : RowResult ⟨43, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_43_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_43_77 : RowResult ⟨43, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_43_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_43_78 : RowResult ⟨43, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_43_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_43_79 : RowResult ⟨43, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_43_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_43_80 : RowResult ⟨43, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_43_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_43_81 : RowResult ⟨43, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_43_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 2 5 7)

theorem row_43_82 : RowResult ⟨43, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_43_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 2 5 6)

theorem row_43_83 : RowResult ⟨43, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_43_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
