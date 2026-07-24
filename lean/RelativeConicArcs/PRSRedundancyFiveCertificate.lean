import RelativeConicArcs.PRSFoundation

/-!
# Finite certificate interface for redundancy-five cubic pencils

The compact finite table used by the redundancy-five projective Reed--Solomon classification
contains seventeen candidate sporadic `PGL₂`-orbit rows at field orders
`7, 8, 9, 11, 13, 17, 19`.  Each row contains a
canonical projective point index, orbit size, stabilizer order, complete pencil-member
histogram, and coefficient-Frobenius target.

The source is the public electronic artifact
`papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`.
That artifact specifies normalization, field models, exhaustive domains, generators,
and independent replay.  Lean kernel reduction checks the transcribed table and its arithmetic
consistency, but does not establish that these rows are the sporadic orbits or rerun the external
finite-field enumeration.  `CertificateValidation` exposes representative, stabilizer,
histogram, Frobenius, and exhaustion validation as separate hypotheses.
-/

namespace RelativeConicArcs.PRSRedundancyFiveCertificate

/-- Counts of the five factorization types among the projective members of a cubic
pencil.  The labels respectively mean linear times irreducible quadratic, three
distinct linear factors, one double and one simple linear factor, a triple linear
factor, and an irreducible cubic. -/
structure MemberHistogram where
  linearIrreducibleQuadratic : ℕ
  threeDistinctLinear : ℕ
  doubleAndSimpleLinear : ℕ
  tripleLinear : ℕ
  irreducibleCubic : ℕ
  deriving DecidableEq

/-- Total number of projective members represented by a histogram. -/
def MemberHistogram.total (h : MemberHistogram) : ℕ :=
  h.linearIrreducibleQuadratic + h.threeDistinctLinear +
    h.doubleAndSimpleLinear + h.tripleLinear + h.irreducibleCubic

/-- One canonical sporadic orbit in the redundancy-five finite certificate. -/
structure SporadicOrbitRecord where
  fieldOrder : ℕ
  canonicalIndex : ℕ
  orbitSize : ℕ
  stabilizerOrder : ℕ
  histogram : MemberHistogram
  frobeniusTargetIndex : ℕ
  semilinearRepresentativeIndex : ℕ
  deriving DecidableEq

private def hist (li three double triple irreducible : ℕ) : MemberHistogram :=
  ⟨li, three, double, triple, irreducible⟩

private def orbit (q rep size stabilizer : ℕ) (h : MemberHistogram)
    (frobeniusTarget semilinearRepresentative : ℕ) : SporadicOrbitRecord :=
  ⟨q, rep, size, stabilizer, h, frobeniusTarget, semilinearRepresentative⟩

/-- Transcribed candidate sporadic orbit inventory.  Repeated orbit sizes remain distinct because
the canonical index, stabilizer, histogram, and Frobenius target are retained. -/
def sporadicOrbitRecords : List SporadicOrbitRecord := [
  orbit 7 346 28 12 (hist 0 0 4 0 4) 346 346,
  orbit 7 345 112 3 (hist 6 0 1 0 1) 345 345,
  orbit 7 52 168 2 (hist 3 0 2 1 2) 52 52,
  orbit 7 366 168 2 (hist 4 0 2 0 2) 366 366,
  orbit 7 2416 168 2 (hist 4 0 2 0 2) 2416 2416,
  orbit 8 578 252 2 (hist 5 0 2 0 2) 580 578,
  orbit 8 580 252 2 (hist 5 0 2 0 2) 582 578,
  orbit 8 582 252 2 (hist 5 0 2 0 2) 578 578,
  orbit 9 6572 180 4 (hist 2 0 4 0 4) 6572 6572,
  orbit 9 766 360 2 (hist 6 0 2 0 2) 769 766,
  orbit 9 769 360 2 (hist 6 0 2 0 2) 766 766,
  orbit 11 14662 330 4 (hist 4 0 4 0 4) 14662 14662,
  orbit 11 14653 660 2 (hist 8 0 2 0 2) 14653 14653,
  orbit 13 2201 182 12 (hist 6 0 4 0 4) 2201 2201,
  orbit 13 28620 546 4 (hist 6 0 4 0 4) 28620 28620,
  orbit 17 83543 1224 4 (hist 10 0 4 0 4) 83543 83543,
  orbit 19 6863 570 12 (hist 12 0 4 0 4) 6863 6863
]

/-- Sporadic records at one field order. -/
def sporadicRecordsAt (q : ℕ) : List SporadicOrbitRecord :=
  sporadicOrbitRecords.filter (fun r => r.fieldOrder = q)

/-- Number of sporadic syndrome points at one field order. -/
def sporadicPointCount (q : ℕ) : ℕ :=
  ((sporadicRecordsAt q).map (fun r => r.orbitSize)).sum

/-- Number of sporadic projective-linear orbits at one field order. -/
def sporadicProjectiveOrbitCount (q : ℕ) : ℕ :=
  (sporadicRecordsAt q).length

/-- Number of sporadic projective-semilinear orbits at one field order. -/
def sporadicSemilinearOrbitCount (q : ℕ) : ℕ :=
  (((sporadicRecordsAt q).map
    (fun r => r.semilinearRepresentativeIndex)).eraseDups).length

/-- The sporadic inventory has exactly the seven asserted field orders. -/
theorem sporadic_field_orders :
    (sporadicOrbitRecords.map (fun r => r.fieldOrder)).eraseDups =
      [7, 8, 9, 11, 13, 17, 19] := by
  decide

/-- Exact sporadic point totals in the seven exceptional fields. -/
theorem sporadic_point_counts :
    sporadicPointCount 7 = 644 ∧
    sporadicPointCount 8 = 756 ∧
    sporadicPointCount 9 = 900 ∧
    sporadicPointCount 11 = 990 ∧
    sporadicPointCount 13 = 728 ∧
    sporadicPointCount 17 = 1224 ∧
    sporadicPointCount 19 = 570 := by
  decide

/-- Exact projective-linear and projective-semilinear sporadic orbit counts. -/
theorem sporadic_orbit_counts :
    (sporadicProjectiveOrbitCount 7, sporadicSemilinearOrbitCount 7) = (5, 5) ∧
    (sporadicProjectiveOrbitCount 8, sporadicSemilinearOrbitCount 8) = (3, 1) ∧
    (sporadicProjectiveOrbitCount 9, sporadicSemilinearOrbitCount 9) = (3, 2) ∧
    (sporadicProjectiveOrbitCount 11, sporadicSemilinearOrbitCount 11) = (2, 2) ∧
    (sporadicProjectiveOrbitCount 13, sporadicSemilinearOrbitCount 13) = (2, 2) ∧
    (sporadicProjectiveOrbitCount 17, sporadicSemilinearOrbitCount 17) = (1, 1) ∧
    (sporadicProjectiveOrbitCount 19, sporadicSemilinearOrbitCount 19) = (1, 1) := by
  decide

/-- Every orbit size times its stabilizer is the order `q(q²-1)` of `PGL₂(F_q)`. -/
theorem sporadic_orbit_stabilizer :
    ∀ r ∈ sporadicOrbitRecords,
      r.orbitSize * r.stabilizerOrder =
        r.fieldOrder * (r.fieldOrder ^ 2 - 1) := by
  decide

/-- Every member histogram accounts for all `q+1` projective cubics in its pencil. -/
theorem sporadic_histogram_total :
    ∀ r ∈ sporadicOrbitRecords, r.histogram.total = r.fieldOrder + 1 := by
  decide

/-- Every recorded Frobenius target is another record over the same field with the
same orbit size, stabilizer, and member histogram. -/
theorem sporadic_frobenius_target :
    ∀ r ∈ sporadicOrbitRecords, ∃ t ∈ sporadicOrbitRecords,
      t.fieldOrder = r.fieldOrder ∧
      t.canonicalIndex = r.frobeniusTargetIndex ∧
      t.orbitSize = r.orbitSize ∧
      t.stabilizerOrder = r.stabilizerOrder ∧
      t.histogram = r.histogram := by
  decide

/-- Summary of the complete split-free classification at one certified field. -/
structure CertifiedFieldRecord where
  fieldOrder : ℕ
  classifiedSplitFreeCount : ℕ
  nonsporadicOrbitCount : ℕ
  projectiveOrbitCount : ℕ
  semilinearOrbitCount : ℕ
  sporadicPoints : ℕ
  exhaustive : Bool
  radiusFour : Bool
  deriving DecidableEq

private def field (q count base pgl pgamma sporadic : ℕ) : CertifiedFieldRecord :=
  ⟨q, count, base, pgl, pgamma, sporadic, true, true⟩

/-- The nineteen fields in the public finite comparison certificate. -/
def certifiedFieldRecords : List CertifiedFieldRecord := [
  field 7 889 5 10 10 644,
  field 8 1116 4 7 5 756,
  field 9 1391 5 8 7 900,
  field 11 1848 5 7 7 990,
  field 13 2080 4 6 6 728,
  field 16 2432 4 4 4 0,
  field 17 4131 4 5 5 1224,
  field 19 4541 5 6 6 570,
  field 23 6900 5 5 5 0,
  field 25 8750 4 4 4 0,
  field 27 10949 6 6 6 0,
  field 29 13485 4 4 4 0,
  field 31 16337 5 5 5 0,
  field 32 17952 4 4 4 0,
  field 37 27380 4 4 4 0,
  field 41 37023 4 4 4 0,
  field 43 42527 5 5 5 0,
  field 47 55272 5 5 5 0,
  field 49 62426 4 4 4 0
]

/-- Fields below the geometric point-count threshold whose classification is
closed by the finite bridge. -/
def finiteBridgeFieldOrders : List ℕ :=
  [7, 8, 9, 11, 13, 16, 17, 19]

/-- Exact field domain of the public finite certificate. -/
theorem certified_field_orders :
    certifiedFieldRecords.map (fun r => r.fieldOrder) =
      [7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 29, 31, 32,
        37, 41, 43, 47, 49] := by
  rfl

/-- The certified comparison band has no sporadic orbit at `16` or from `23`
through `49` in the recorded prime-power sample. -/
theorem certified_comparison_band_has_no_sporadic :
    ∀ r ∈ certifiedFieldRecords,
      r.fieldOrder ∈ [16, 23, 25, 27, 29, 31, 32, 37, 41, 43, 47, 49] →
        r.sporadicPoints = 0 := by
  decide

/-- Every field row explicitly records both exhaustive split-free coverage and
covering radius four.  These booleans report the public certificate result; the
semantic validation structure below states the proof obligations behind them. -/
theorem certified_rows_report_exhaustion_and_radius :
    ∀ r ∈ certifiedFieldRecords, r.exhaustive = true ∧ r.radiusFour = true := by
  decide

/-- The field summaries agree with the complete sporadic table, including both
projective and semilinear Frobenius fusion. -/
theorem certified_orbit_summaries_agree_with_sporadic_records :
    ∀ r ∈ certifiedFieldRecords,
      r.sporadicPoints = sporadicPointCount r.fieldOrder ∧
      r.projectiveOrbitCount =
        r.nonsporadicOrbitCount +
          sporadicProjectiveOrbitCount r.fieldOrder ∧
      r.semilinearOrbitCount =
        r.nonsporadicOrbitCount +
          sporadicSemilinearOrbitCount r.fieldOrder := by
  decide

/-- Explicit trust boundary for a checker of the public finite records.  Supplying
this structure means checking the mathematical semantics of every canonical
representative, stabilizer, member histogram, Frobenius target, and field exhaustion;
equality of the small arithmetic table alone is insufficient. -/
structure CertificateValidation where
  canonicalRepresentativeChecked : SporadicOrbitRecord → Prop
  stabilizerChecked : SporadicOrbitRecord → Prop
  histogramChecked : SporadicOrbitRecord → Prop
  frobeniusChecked : SporadicOrbitRecord → Prop
  fieldExhaustionChecked : CertifiedFieldRecord → Prop
  allCanonicalRepresentativesChecked :
    ∀ r ∈ sporadicOrbitRecords, canonicalRepresentativeChecked r
  allStabilizersChecked :
    ∀ r ∈ sporadicOrbitRecords, stabilizerChecked r
  allHistogramsChecked :
    ∀ r ∈ sporadicOrbitRecords, histogramChecked r
  allFrobeniusTargetsChecked :
    ∀ r ∈ sporadicOrbitRecords, frobeniusChecked r
  allFieldExhaustionsChecked :
    ∀ r ∈ certifiedFieldRecords, fieldExhaustionChecked r

end RelativeConicArcs.PRSRedundancyFiveCertificate
