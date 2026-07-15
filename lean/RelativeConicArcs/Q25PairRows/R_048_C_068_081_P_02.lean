import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_68 : RowResult ⟨48, by decide⟩ ⟨68, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_69 : RowResult ⟨48, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_48_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_70 : RowResult ⟨48, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_48_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_48_71 : RowResult ⟨48, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_48_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_48_72 : RowResult ⟨48, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_48_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_73 : RowResult ⟨48, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_48_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 1 4 6)

theorem row_48_74 : RowResult ⟨48, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_48_73
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_48_75 : RowResult ⟨48, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_48_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_48_76 : RowResult ⟨48, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_48_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_48_77 : RowResult ⟨48, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_48_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_48_78 : RowResult ⟨48, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_48_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_48_79 : RowResult ⟨48, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_48_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_48_80 : RowResult ⟨48, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_48_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_48_81 : RowResult ⟨48, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_48_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
