import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_44 : RowResult ⟨43, by decide⟩ ⟨44, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_43_45 : RowResult ⟨43, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_43_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_43_46 : RowResult ⟨43, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_43_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_43_47 : RowResult ⟨43, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_43_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_43_48 : RowResult ⟨43, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_43_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_43_49 : RowResult ⟨43, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_43_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_43_50 : RowResult ⟨43, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_43_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_43_51 : RowResult ⟨43, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_43_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_43_52 : RowResult ⟨43, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_43_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_43_53 : RowResult ⟨43, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_43_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_43_54 : RowResult ⟨43, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_43_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_43_55 : RowResult ⟨43, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_43_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_43_56 : RowResult ⟨43, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_43_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_43_57 : RowResult ⟨43, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_43_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_58 : RowResult ⟨43, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_43_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_43_59 : RowResult ⟨43, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_43_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_60 : RowResult ⟨43, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_43_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨89, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_61 : RowResult ⟨43, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_43_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨87, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_43_62 : RowResult ⟨43, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_43_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨84, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_63 : RowResult ⟨43, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_43_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
