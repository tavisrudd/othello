import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_65 : RowResult ⟨41, by decide⟩ ⟨65, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_41_66 : RowResult ⟨41, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_41_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 1 4 6)

theorem row_41_67 : RowResult ⟨41, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_41_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_68 : RowResult ⟨41, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_41_67
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_69 : RowResult ⟨41, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_41_68
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_41_70 : RowResult ⟨41, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_41_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_41_71 : RowResult ⟨41, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_41_70
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_41_72 : RowResult ⟨41, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_41_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 2 4 6)

theorem row_41_73 : RowResult ⟨41, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_41_72
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
