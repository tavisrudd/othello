import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_64 : RowResult ⟨33, by decide⟩ ⟨64, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_65 : RowResult ⟨33, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_33_64
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_66 : RowResult ⟨33, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_33_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 4 5 6)

theorem row_33_67 : RowResult ⟨33, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_33_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_68 : RowResult ⟨33, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_33_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_69 : RowResult ⟨33, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_33_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 2 5 6)

theorem row_33_70 : RowResult ⟨33, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_33_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_33_71 : RowResult ⟨33, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_33_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_72 : RowResult ⟨33, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_33_71
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_73 : RowResult ⟨33, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_33_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
