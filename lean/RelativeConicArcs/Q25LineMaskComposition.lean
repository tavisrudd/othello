import RelativeConicArcs.Q25CarrierLineData.All

/-!
# Boolean composition of C151 line masks

These lemmas turn a clear bit in a checked canonical-line mask into the determinant inequalities
needed by `ReflectedLegal`.  Generated row certificates can therefore reduce only finite Boolean
relations between literal masks; the projective geometry is shared by the 651 line certificates.
-/

namespace RelativeConicArcs
namespace Q25LineMaskComposition

open Q25Coordinates Q25PairCertificate Q25MinimumChecker Q25MinimumMask Q25LineMaskChecker
open Q25CarrierLineData FiniteFields

/-- Every allowed bit is clear in an obstruction mask. -/
def MaskAvoids (allowed blocked : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit allowed n = true → maskBit blocked n = false

instance (allowed blocked : OrbitMask) : Decidable (MaskAvoids allowed blocked) := by
  unfold MaskAvoids
  infer_instance

/-- Word-level disjointness for the five-word mask representation. -/
def MaskWordDisjoint (allowed blocked : OrbitMask) : Prop :=
  ∀ w : Fin 5, (allowed w &&& blocked w) = 0

instance (allowed blocked : OrbitMask) : Decidable (MaskWordDisjoint allowed blocked) := by
  unfold MaskWordDisjoint
  infer_instance

theorem maskAvoids_of_wordDisjoint {allowed blocked : OrbitMask}
    (hdisjoint : MaskWordDisjoint allowed blocked) : MaskAvoids allowed blocked := by
  intro n hn
  have hbit := congrArg (fun x : Nat => x.testBit (n.val % 64))
    (hdisjoint (wordIndex n))
  simp only [Nat.testBit_land] at hbit
  change (allowed (wordIndex n)).testBit (n.val % 64) = true at hn
  change (blocked (wordIndex n)).testBit (n.val % 64) = false
  rw [hn] at hbit
  simpa using hbit

/-- Every point of a normalized configuration occurs in its stable eight-entry presentation. -/
theorem exists_configPoint_of_mem (a b c : OrbitCode) {p : Idx25}
    (hp : p ∈ normalizedConfig a b c) :
    ∃ i : Fin 8, configPoint a b c i = p := by
  simp [normalizedConfig, fixedPair, orbitPair] at hp
  rcases hp with h | h | h | h | h | h | h | h
  · exact ⟨6, h.symm⟩
  · exact ⟨4, h.symm⟩
  · exact ⟨2, h.symm⟩
  · exact ⟨0, h.symm⟩
  · exact ⟨1, h.symm⟩
  · exact ⟨3, h.symm⟩
  · exact ⟨5, h.symm⟩
  · exact ⟨7, h.symm⟩

/-- Generated per-row secant data: every distinct ordered pair of old points has a canonical line
witness, and the proposed legal mask avoids that line's incidence mask. -/
structure SecantCompositionCertificate (a b c : OrbitCode) (allowed : OrbitMask) where
  lineNumber : Fin 8 → Fin 8 → Fin 651
  scale : Fin 8 → Fin 8 → K25
  witness : ∀ i j : Fin 8, configPoint a b c i ≠ configPoint a b c j →
    LineWitnessValid (configPoint a b c i) (configPoint a b c j)
      (lineOfNumber (lineNumber i j)) (scale i j)
  symmetric : ∀ i j : Fin 8, lineNumber i j = lineNumber j i
  avoids : ∀ i j : Fin 8, i < j →
    MaskWordDisjoint allowed (lineMaskOfNumber (lineNumber i j))

/-- The proposed legal mask is fresh relative to the normalized row. -/
def FreshMaskSafe (a b c : OrbitCode) (allowed : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit allowed n = true →
    PairFresh (normalizedConfig a b c) (orbitCodeOfNumber n)

instance (a b c : OrbitCode) (allowed : OrbitMask) : Decidable (FreshMaskSafe a b c allowed) := by
  unfold FreshMaskSafe PairFresh
  infer_instance

/-- The candidate carrier avoids the two normalized fixed points, and its certified fixed line is
clear at one representative of each occupied nonfixed orbit.  Conjugation supplies the other three
old points. -/
def CarrierMaskSafe (a b c : OrbitCode) (allowed : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit allowed n = true →
    lineDot (vec (lineOfNumber (carrierLineNumber n))) (vec .vertical) ≠ 0 ∧
    lineDot (vec (lineOfNumber (carrierLineNumber n))) (vec (.infinity 0)) ≠ 0 ∧
    maskBit (lineMaskOfNumber (carrierLineNumber n)) (orbitNumberFin a) = false ∧
    maskBit (lineMaskOfNumber (carrierLineNumber n)) (orbitNumberFin b) = false ∧
    maskBit (lineMaskOfNumber (carrierLineNumber n)) (orbitNumberFin c) = false

instance (a b c : OrbitCode) (allowed : OrbitMask) : Decidable (CarrierMaskSafe a b c allowed) := by
  unfold CarrierMaskSafe
  infer_instance

theorem lineDot_ne_zero_of_maskBit_false {l : Idx25} {mask : OrbitMask} {n : Fin 310}
    (hmask : LineMaskCertificate l mask) (hclear : maskBit mask n = false) :
    lineDot (vec l) (vec (orbitIdx (orbitCodeOfNumber n))) ≠ 0 := by
  intro hz
  have hbit : maskBit mask n = true := (hmask.exact n).2 hz
  rw [hclear] at hbit
  exact Bool.false_ne_true hbit

theorem det_ne_zero_of_maskBit_false {a b l : Idx25} {r : K25} {mask : OrbitMask}
    {n : Fin 310} (hwitness : LineWitnessValid a b l r)
    (hmask : LineMaskCertificate l mask) (hclear : maskBit mask n = false) :
    Matrix.det ![vec a, vec b, vec (orbitIdx (orbitCodeOfNumber n))] ≠ 0 := by
  exact (det_ne_zero_iff_lineDot_ne_zero hwitness _).2
    (lineDot_ne_zero_of_maskBit_false hmask hclear)

theorem det_ne_zero_of_maskAvoids {a b l : Idx25} {r : K25}
    {allowed blocked : OrbitMask} {n : Fin 310}
    (hwitness : LineWitnessValid a b l r) (hmask : LineMaskCertificate l blocked)
    (havoids : MaskAvoids allowed blocked) (hn : maskBit allowed n = true) :
    Matrix.det ![vec a, vec b, vec (orbitIdx (orbitCodeOfNumber n))] ≠ 0 := by
  exact det_ne_zero_of_maskBit_false hwitness hmask (havoids n hn)

theorem lineDot_orbitIdx_ne_zero_of_maskBit_false {l : Idx25} {mask : OrbitMask}
    (hmask : LineMaskCertificate l mask) (o : OrbitCode)
    (hclear : maskBit mask ⟨orbitNumber o, orbitNumber_lt o⟩ = false) :
    lineDot (vec l) (vec (orbitIdx o)) ≠ 0 := by
  simpa using lineDot_ne_zero_of_maskBit_false hmask hclear

theorem lineDot_conjOrbitIdx_ne_zero_of_maskBit_false {l : Idx25} {mask : OrbitMask}
    (hfixed : conjIdx l = l) (hmask : LineMaskCertificate l mask) (o : OrbitCode)
    (hclear : maskBit mask ⟨orbitNumber o, orbitNumber_lt o⟩ = false) :
    lineDot (vec l) (vec (conjIdx (orbitIdx o))) ≠ 0 := by
  exact lineDot_conj_ne_zero hfixed
    (lineDot_orbitIdx_ne_zero_of_maskBit_false hmask o hclear)

/-- Reorder the carrier determinant from `(candidate, conjugate, old)` to the orientation used by
`ReflectedLegal`. -/
theorem carrier_det_ne_zero_of_lineDot_ne_zero {o : OrbitCode} {l : Idx25} {r : K25}
    (hcarrier : CarrierLineCertificate o l r) {p : Idx25}
    (hp : lineDot (vec l) (vec p) ≠ 0) :
    Matrix.det ![vec (orbitIdx o), vec p, vec (conjIdx (orbitIdx o))] ≠ 0 := by
  have hbase :
      Matrix.det ![vec (orbitIdx o), vec (conjIdx (orbitIdx o)), vec p] ≠ 0 :=
    (det_ne_zero_iff_lineDot_ne_zero hcarrier.witness p).2 hp
  have hswap :
      Matrix.det ![vec (orbitIdx o), vec (conjIdx (orbitIdx o)), vec p] =
        -Matrix.det ![vec (orbitIdx o), vec p, vec (conjIdx (orbitIdx o))] := by
    simp [Matrix.det_fin_three]
    ring
  intro hz
  apply hbase
  rw [hswap, hz]
  simp

theorem carrier_det_orbitIdx_ne_zero_of_maskBit_false {o old : OrbitCode} {l : Idx25}
    {r : K25} {mask : OrbitMask} (hcarrier : CarrierLineCertificate o l r)
    (hmask : LineMaskCertificate l mask)
    (hclear : maskBit mask ⟨orbitNumber old, orbitNumber_lt old⟩ = false) :
    Matrix.det ![vec (orbitIdx o), vec (orbitIdx old), vec (conjIdx (orbitIdx o))] ≠ 0 := by
  exact carrier_det_ne_zero_of_lineDot_ne_zero hcarrier
    (lineDot_orbitIdx_ne_zero_of_maskBit_false hmask old hclear)

theorem carrier_det_conjOrbitIdx_ne_zero_of_maskBit_false {o old : OrbitCode} {l : Idx25}
    {r : K25} {mask : OrbitMask} (hcarrier : CarrierLineCertificate o l r)
    (hmask : LineMaskCertificate l mask)
    (hclear : maskBit mask ⟨orbitNumber old, orbitNumber_lt old⟩ = false) :
    Matrix.det ![vec (orbitIdx o), vec (conjIdx (orbitIdx old)),
      vec (conjIdx (orbitIdx o))] ≠ 0 := by
  exact carrier_det_ne_zero_of_lineDot_ne_zero hcarrier
    (lineDot_conjOrbitIdx_ne_zero_of_maskBit_false hcarrier.fixed hmask old hclear)

theorem rawExtension_of_secantComposition {a b c : OrbitCode} {allowed : OrbitMask}
    (hsecants : SecantCompositionCertificate a b c allowed) {n : Fin 310}
    (hn : maskBit allowed n = true) :
    RawExtension (normalizedConfig a b c) (orbitIdx (orbitCodeOfNumber n)) := by
  intro p hp q hq hpq
  rcases exists_configPoint_of_mem a b c hp with ⟨i, rfl⟩
  rcases exists_configPoint_of_mem a b c hq with ⟨j, rfl⟩
  have hij : i ≠ j := by
    intro hij
    subst j
    exact hpq rfl
  have havoids : MaskAvoids allowed (lineMaskOfNumber (hsecants.lineNumber i j)) := by
    rcases lt_or_gt_of_ne hij with hij | hji
    · exact maskAvoids_of_wordDisjoint (hsecants.avoids i j hij)
    · rw [hsecants.symmetric i j]
      exact maskAvoids_of_wordDisjoint (hsecants.avoids j i hji)
  exact det_ne_zero_of_maskAvoids (hsecants.witness i j hpq)
    (lineMaskCertificateOfNumber (hsecants.lineNumber i j))
    havoids hn

theorem carrier_avoidance_of_maskSafe {a b c : OrbitCode} {allowed : OrbitMask}
    (hsafe : CarrierMaskSafe a b c allowed) {n : Fin 310}
    (hn : maskBit allowed n = true) :
    ∀ p ∈ normalizedConfig a b c,
      Matrix.det ![vec (orbitIdx (orbitCodeOfNumber n)), vec p,
        vec (conjIdx (orbitIdx (orbitCodeOfNumber n)))] ≠ 0 := by
  intro p hp
  rcases exists_configPoint_of_mem a b c hp with ⟨i, rfl⟩
  have hs := hsafe n hn
  have hcarrier := carrierLineCertificateOfNumber n
  have hmask := lineMaskCertificateOfNumber (carrierLineNumber n)
  fin_cases i
  · exact carrier_det_ne_zero_of_lineDot_ne_zero hcarrier hs.1
  · exact carrier_det_ne_zero_of_lineDot_ne_zero hcarrier hs.2.1
  · exact carrier_det_orbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.1
  · exact carrier_det_conjOrbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.1
  · exact carrier_det_orbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.2.1
  · exact carrier_det_conjOrbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.2.1
  · exact carrier_det_orbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.2.2
  · exact carrier_det_conjOrbitIdx_ne_zero_of_maskBit_false hcarrier hmask hs.2.2.2.2

/-- Complete generated payload for one residual representative.  Only `witness` contains field
arithmetic; the remaining fields are finite relations between literal masks and dispatch tables. -/
structure RowCompositionCertificate (a b c : OrbitCode) (allowed : OrbitMask) where
  card_le : 32 ≤ (maskOrbitSet allowed).card
  fresh : FreshMaskSafe a b c allowed
  secants : SecantCompositionCertificate a b c allowed
  carrier : CarrierMaskSafe a b c allowed

theorem RowCompositionCertificate.toReflectedMaskCertificate
    {a b c : OrbitCode} {allowed : OrbitMask}
    (hrow : RowCompositionCertificate a b c allowed) :
    ReflectedMaskCertificate (normalizedConfig a b c) allowed := by
  refine ⟨hrow.card_le, ?_⟩
  intro n hn
  exact ⟨hrow.fresh n hn, rawExtension_of_secantComposition hrow.secants hn,
    carrier_avoidance_of_maskSafe hrow.carrier hn⟩

end Q25LineMaskComposition
end RelativeConicArcs
