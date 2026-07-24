import RelativeConicArcs.PRSPolarInduction

/-!
# Finite classification records for redundancies six and seven

This module transcribes the compact field summaries used by the projective Reed--Solomon
redundancy-six and redundancy-seven classifications.  The source is
`papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`0a6c4066dff9983a9c2124bca27fbbe4e273b9868125a04c30071df3783b6725`.
The source artifact specifies the finite-field models, normalization, exhaustive search domains,
orbit records, and independent replay.

Lean kernel reduction checks the arithmetic of the transcribed summaries, including persistent,
modular-central, and exceptional totals.  It does not reconstruct the finite fields, identify the
recorded representatives with Hankel syndromes, prove orbit exhaustion, or promote a split-free
table to a coding-theoretic deep-hole table.  The validation structures below keep those semantic
obligations separate.  In particular, the redundancy-seven rows at field orders `7`, `8`, and `9`
carry no covering-radius assertion.
-/

namespace RelativeConicArcs.PRSRedundancySixSevenCertificate

/-- One finite-field summary for the redundancy-six split-free syndrome classification. -/
structure RedundancySixFieldRecord where
  fieldOrder : ℕ
  classifiedSplitFreeCount : ℕ
  persistentCount : ℕ
  exceptionalCount : ℕ
  projectiveOrbitCount : ℕ
  semilinearOrbitCount : ℕ
  radiusFiveReported : Bool
  deriving DecidableEq

private def r6field (q total persistent exceptional pgl pgamma : ℕ) :
    RedundancySixFieldRecord :=
  ⟨q, total, persistent, exceptional, pgl, pgamma, true⟩

/-- Complete field-summary domain transcribed for redundancy six. -/
def redundancySixFieldRecords : List RedundancySixFieldRecord := [
  r6field 7 5376 224 5152 20 20,
  r6field 8 5037 324 4713 13 7,
  r6field 9 2250 450 1800 8 5,
  r6field 11 1584 792 792 4 4,
  r6field 13 1820 1274 546 3 3,
  r6field 16 2312 2312 0 2 2,
  r6field 17 2754 2754 0 2 2,
  r6field 19 3800 3800 0 4 4,
  r6field 23 6624 6624 0 2 2,
  r6field 25 8450 8450 0 3 3,
  r6field 27 10584 10584 0 2 2
]

/-- Every redundancy-six row has the persistent cardinality `q(q+1)²/2`. -/
theorem redundancySix_persistent_counts :
    ∀ r ∈ redundancySixFieldRecords,
      2 * r.persistentCount = r.fieldOrder * (r.fieldOrder + 1) ^ 2 := by
  decide

/-- Persistent and exceptional counts exhaust every transcribed redundancy-six row. -/
theorem redundancySix_count_exhaustion :
    ∀ r ∈ redundancySixFieldRecords,
      r.classifiedSplitFreeCount = r.persistentCount + r.exceptionalCount := by
  decide

/-- Every redundancy-six summary explicitly reports covering radius five.  This Boolean is a
transcription of the public record, not a semantic proof about a formal code. -/
theorem redundancySix_rows_report_radius_five :
    ∀ r ∈ redundancySixFieldRecords, r.radiusFiveReported = true := by
  decide

/-- Exact small-field exceptional orbit counts for redundancy six. -/
structure ExceptionalOrbitInventory where
  fieldOrder : ℕ
  projectiveOrbitCount : ℕ
  semilinearOrbitCount : ℕ
  deriving DecidableEq

/-- The complete redundancy-six exceptional inventory below the uniform geometric range.
At field orders `8` and `9`, coefficient Frobenius fuses projective-linear orbits. -/
def redundancySixExceptionalInventories : List ExceptionalOrbitInventory := [
  ⟨7, 18, 18⟩,
  ⟨8, 11, 5⟩,
  ⟨9, 4, 2⟩,
  ⟨11, 2, 2⟩,
  ⟨13, 1, 1⟩
]

/-- The exact projective and semilinear redundancy-six exceptional count sequences. -/
theorem redundancySix_exceptional_orbit_counts :
    redundancySixExceptionalInventories.map
        (fun r => (r.fieldOrder, r.projectiveOrbitCount, r.semilinearOrbitCount)) =
      [(7, 18, 18), (8, 11, 5), (9, 4, 2), (11, 2, 2), (13, 1, 1)] := by
  rfl

/-- One finite-field summary for the redundancy-seven split-free syndrome classification.
`centralCount` records the characteristic-two central nucleus point separately from both the
persistent tangent/sigma union and the genuinely exceptional residue. -/
structure RedundancySevenFieldRecord where
  fieldOrder : ℕ
  classifiedSplitFreeCount : ℕ
  persistentCount : ℕ
  centralCount : ℕ
  exceptionalCount : ℕ
  projectiveOrbitCount : ℕ
  semilinearOrbitCount : ℕ
  radiusSixReported : Bool
  deriving DecidableEq

private def r7field (q total persistent central exceptional pgl pgamma : ℕ)
    (radius : Bool) : RedundancySevenFieldRecord :=
  ⟨q, total, persistent, central, exceptional, pgl, pgamma, radius⟩

/-- Complete field-summary domain transcribed for redundancy seven.  Covering radius six is
reported only from field order `11` onward. -/
def redundancySevenFieldRecords : List RedundancySevenFieldRecord := [
  r7field 7 55860 224 0 55636 197 197 false,
  r7field 8 50776 324 1 50451 124 50 false,
  r7field 9 28350 450 0 27900 58 33 false,
  r7field 11 3080 792 0 2288 10 10 true,
  r7field 13 1274 1274 0 0 3 3 true,
  r7field 16 2312 2312 0 0 3 3 true,
  r7field 17 2754 2754 0 0 5 5 true,
  r7field 19 3800 3800 0 0 3 3 true,
  r7field 23 6624 6624 0 0 5 5 true,
  r7field 25 8450 8450 0 0 3 3 true,
  r7field 27 10584 10584 0 0 4 4 true,
  r7field 29 13050 13050 0 0 5 5 true,
  r7field 31 15872 15872 0 0 3 3 true,
  r7field 32 17425 17424 1 0 5 5 true
]

/-- Every redundancy-seven row has the same persistent tangent/sigma cardinality
`q(q+1)²/2`. -/
theorem redundancySeven_persistent_counts :
    ∀ r ∈ redundancySevenFieldRecords,
      2 * r.persistentCount = r.fieldOrder * (r.fieldOrder + 1) ^ 2 := by
  decide

/-- Persistent, central, and exceptional counts exhaust every transcribed redundancy-seven row. -/
theorem redundancySeven_count_exhaustion :
    ∀ r ∈ redundancySevenFieldRecords,
      r.classifiedSplitFreeCount =
        r.persistentCount + r.centralCount + r.exceptionalCount := by
  decide

/-- The exact radius boundary in the public redundancy-seven summaries. -/
theorem redundancySeven_radius_reporting_boundary :
    ∀ r ∈ redundancySevenFieldRecords,
      r.radiusSixReported = (11 ≤ r.fieldOrder) := by
  decide

/-- The complete small-field exceptional orbit inventory for redundancy seven.  These are the
orbits outside the tangent/sigma union and the central nucleus point. -/
def redundancySevenExceptionalInventories : List ExceptionalOrbitInventory := [
  ⟨7, 194, 194⟩,
  ⟨8, 119, 45⟩,
  ⟨9, 54, 29⟩,
  ⟨11, 5, 5⟩
]

/-- The exact projective and semilinear redundancy-seven exceptional count sequences. -/
theorem redundancySeven_exceptional_orbit_counts :
    redundancySevenExceptionalInventories.map
        (fun r => (r.fieldOrder, r.projectiveOrbitCount, r.semilinearOrbitCount)) =
      [(7, 194, 194), (8, 119, 45), (9, 54, 29), (11, 5, 5)] := by
  rfl

/-- Semantic validation boundary for the redundancy-six public finite records.  Arithmetic
reduction of the summaries does not discharge any of these obligations. -/
structure RedundancySixCertificateValidation where
  /-- The formal syndrome predicate agrees with the recorded split-free search predicate. -/
  syndromePredicateChecked : RedundancySixFieldRecord → Prop
  /-- The recorded projective and semilinear orbit decompositions are exhaustive. -/
  orbitExhaustionChecked : RedundancySixFieldRecord → Prop
  /-- The definition-level search proves covering radius five for the represented code. -/
  radiusSemanticsChecked : RedundancySixFieldRecord → Prop
  allSyndromePredicatesChecked :
    ∀ r ∈ redundancySixFieldRecords, syndromePredicateChecked r
  allOrbitExhaustionsChecked :
    ∀ r ∈ redundancySixFieldRecords, orbitExhaustionChecked r
  allRadiusSemanticsChecked :
    ∀ r ∈ redundancySixFieldRecords, radiusSemanticsChecked r

/-- Semantic validation boundary for the redundancy-seven public finite records.  The radius
obligation is required only on rows that report radius six. -/
structure RedundancySevenCertificateValidation where
  /-- The formal syndrome predicate agrees with the recorded split-free search predicate. -/
  syndromePredicateChecked : RedundancySevenFieldRecord → Prop
  /-- The recorded projective and semilinear orbit decompositions are exhaustive. -/
  orbitExhaustionChecked : RedundancySevenFieldRecord → Prop
  /-- A radius-six report has been connected to the represented projective Reed--Solomon code. -/
  radiusSemanticsChecked : RedundancySevenFieldRecord → Prop
  allSyndromePredicatesChecked :
    ∀ r ∈ redundancySevenFieldRecords, syndromePredicateChecked r
  allOrbitExhaustionsChecked :
    ∀ r ∈ redundancySevenFieldRecords, orbitExhaustionChecked r
  reportedRadiusSemanticsChecked :
    ∀ r ∈ redundancySevenFieldRecords,
      r.radiusSixReported = true → radiusSemanticsChecked r

end RelativeConicArcs.PRSRedundancySixSevenCertificate
