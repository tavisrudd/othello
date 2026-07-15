import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_161 : RowResult ⟨96, by decide⟩ ⟨161, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_162 : RowResult ⟨96, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_96_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_163 : RowResult ⟨96, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_96_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_96_164 : RowResult ⟨96, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_96_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_165 : RowResult ⟨96, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_96_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_96_166 : RowResult ⟨96, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_96_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
