import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_65 : RowResult ⟨46, by decide⟩ ⟨65, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_66 : RowResult ⟨46, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_46_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_67 : RowResult ⟨46, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_46_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_68 : RowResult ⟨46, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_46_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_69 : RowResult ⟨46, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_46_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_70 : RowResult ⟨46, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_46_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_46_71 : RowResult ⟨46, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_46_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 1 4 6)

theorem row_46_72 : RowResult ⟨46, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_46_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_46_73 : RowResult ⟨46, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_46_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
