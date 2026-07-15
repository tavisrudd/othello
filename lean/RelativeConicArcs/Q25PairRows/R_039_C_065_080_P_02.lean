import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_65 : RowResult ⟨39, by decide⟩ ⟨65, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_39_66 : RowResult ⟨39, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_39_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 2 4 6)

theorem row_39_67 : RowResult ⟨39, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_39_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_68 : RowResult ⟨39, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_39_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_39_69 : RowResult ⟨39, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_39_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 1 4 7)

theorem row_39_70 : RowResult ⟨39, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_39_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_39_71 : RowResult ⟨39, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_39_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_39_72 : RowResult ⟨39, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_39_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_73 : RowResult ⟨39, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_39_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 2 4 7)

theorem row_39_74 : RowResult ⟨39, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_39_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_39_75 : RowResult ⟨39, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_39_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_39_76 : RowResult ⟨39, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_39_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_39_77 : RowResult ⟨39, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_39_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_39_78 : RowResult ⟨39, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_39_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_39_79 : RowResult ⟨39, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_39_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_39_80 : RowResult ⟨39, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_39_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
