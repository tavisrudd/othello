import RelativeConicArcs.Q25LineMaskComposition

/-!
# Obstruction-mask composition for exact Q25 repair counts

The lower-bound row certificates mark legal candidates.  This companion layer proves the reverse
inclusion from three compact obstruction masks: freshness failures, old-secant incidences, and
candidate-carrier incidences.  It reuses the shared line and carrier certificates and introduces
no candidate-by-candidate positive witnesses.
-/

namespace RelativeConicArcs
namespace Q25ExactnessComposition

open Q25Coordinates Q25PairCertificate Q25MinimumChecker Q25MinimumMask
open Q25LineMaskChecker Q25LineMaskComposition Q25CarrierLineData FiniteFields

/-- Every clear allowed bit is covered by at least one obstruction mask. -/
def MaskComplementCovered (allowed fresh secant carrier : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit allowed n = false →
    maskBit fresh n = true ∨ maskBit secant n = true ∨ maskBit carrier n = true

instance (allowed fresh secant carrier : OrbitMask) :
    Decidable (MaskComplementCovered allowed fresh secant carrier) := by
  unfold MaskComplementCovered
  infer_instance

/-- Every freshness-obstruction bit really overlaps the old normalized row. -/
def FreshBlockedSound (a b c : OrbitCode) (blocked : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit blocked n = true →
    ¬ PairFresh (normalizedConfig a b c) (orbitCodeOfNumber n)

instance (a b c : OrbitCode) (blocked : OrbitMask) :
    Decidable (FreshBlockedSound a b c blocked) := by
  unfold FreshBlockedSound PairFresh
  infer_instance

/-- Every secant-obstruction bit occurs on one certified old-point join. -/
def SecantBlockedSound (a b c : OrbitCode)
    (lineNumber : Fin 8 → Fin 8 → Fin 651) (blocked : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit blocked n = true →
    ∃ i j : Fin 8,
      configPoint a b c i ≠ configPoint a b c j ∧
      maskBit (lineMaskOfNumber (lineNumber i j)) n = true

instance (a b c : OrbitCode) (lineNumber : Fin 8 → Fin 8 → Fin 651)
    (blocked : OrbitMask) : Decidable (SecantBlockedSound a b c lineNumber blocked) := by
  unfold SecantBlockedSound
  infer_instance

/-- Every carrier-obstruction bit has a concrete old point on the checked candidate carrier. -/
def CarrierBlockedSound (a b c : OrbitCode) (blocked : OrbitMask) : Prop :=
  ∀ n : Fin 310, maskBit blocked n = true →
    ∃ i : Fin 8,
      lineDot (vec (lineOfNumber (carrierLineNumber n)))
        (vec (configPoint a b c i)) = 0

instance (a b c : OrbitCode) (blocked : OrbitMask) :
    Decidable (CarrierBlockedSound a b c blocked) := by
  unfold CarrierBlockedSound
  infer_instance

/-- Complete negative certificate for one row. -/
structure RowExactnessCertificate (a b c : OrbitCode)
    (allowed freshBlocked secantBlocked carrierBlocked : OrbitMask)
    (secants : SecantCompositionCertificate a b c allowed) : Prop where
  cover : MaskComplementCovered allowed freshBlocked secantBlocked carrierBlocked
  fresh : FreshBlockedSound a b c freshBlocked
  secant : SecantBlockedSound a b c secants.lineNumber secantBlocked
  carrier : CarrierBlockedSound a b c carrierBlocked

/-- A reflected-legal candidate cannot lie under any certified obstruction, so its allowed bit is
set. -/
theorem maskBit_eq_true_of_reflectedLegal
    {a b c : OrbitCode} {allowed freshBlocked secantBlocked carrierBlocked : OrbitMask}
    {secants : SecantCompositionCertificate a b c allowed}
    (hexact : RowExactnessCertificate a b c allowed freshBlocked secantBlocked
      carrierBlocked secants) {n : Fin 310}
    (hlegal : ReflectedLegal (normalizedConfig a b c) (orbitCodeOfNumber n)) :
    maskBit allowed n = true := by
  cases hallowed : maskBit allowed n with
  | true => rfl
  | false =>
      exfalso
      rcases hexact.cover n hallowed with hfresh | hsecant | hcarrier
      · exact (hexact.fresh n hfresh) hlegal.1
      · obtain ⟨i, j, hij, hline⟩ := hexact.secant n hsecant
        have hlineZero :
            lineDot (vec (lineOfNumber (secants.lineNumber i j)))
              (vec (orbitIdx (orbitCodeOfNumber n))) = 0 :=
          ((lineMaskCertificateOfNumber (secants.lineNumber i j)).exact n).mp hline
        have hdetZero :
            Matrix.det ![vec (configPoint a b c i), vec (configPoint a b c j),
              vec (orbitIdx (orbitCodeOfNumber n))] = 0 :=
          (det_zero_iff_lineDot_zero (secants.witness i j hij) _).2 hlineZero
        exact (hlegal.2.1 (configPoint a b c i) (configPoint_mem a b c i)
          (configPoint a b c j) (configPoint_mem a b c j) hij) hdetZero
      · obtain ⟨i, hlineZero⟩ := hexact.carrier n hcarrier
        have hbase :
            Matrix.det ![vec (orbitIdx (orbitCodeOfNumber n)),
              vec (conjIdx (orbitIdx (orbitCodeOfNumber n))),
              vec (configPoint a b c i)] = 0 :=
          (det_zero_iff_lineDot_zero (carrierLineCertificateOfNumber n).witness _).2 hlineZero
        have htarget :
            Matrix.det ![vec (orbitIdx (orbitCodeOfNumber n)),
              vec (configPoint a b c i),
              vec (conjIdx (orbitIdx (orbitCodeOfNumber n)))] = 0 := by
          have hswap :
              Matrix.det ![vec (orbitIdx (orbitCodeOfNumber n)),
                vec (configPoint a b c i),
                vec (conjIdx (orbitIdx (orbitCodeOfNumber n)))] =
              -Matrix.det ![vec (orbitIdx (orbitCodeOfNumber n)),
                vec (conjIdx (orbitIdx (orbitCodeOfNumber n))),
                vec (configPoint a b c i)] := by
            simp [Matrix.det_fin_three]
            ring
          rw [hswap, hbase, neg_zero]
        exact (hlegal.2.2 (configPoint a b c i) (configPoint_mem a b c i)) htarget

/-- Exactness masks give the reverse inclusion missing from the lower-bound certificate. -/
theorem legalOrbitSet_subset_maskOrbitSet
    {a b c : OrbitCode} {allowed freshBlocked secantBlocked carrierBlocked : OrbitMask}
    {secants : SecantCompositionCertificate a b c allowed}
    (hexact : RowExactnessCertificate a b c allowed freshBlocked secantBlocked
      carrierBlocked secants) :
    legalOrbitSet (normalizedConfig a b c) ⊆ maskOrbitSet allowed := by
  intro o ho
  have hpair : LegalPair (normalizedConfig a b c) o := (Finset.mem_filter.mp ho).2
  have hreflected : ReflectedLegal (normalizedConfig a b c) o :=
    (legalPair_iff_reflectedLegal (normalizedConfig_isConjInvariant a b c) o).1 hpair
  apply Finset.mem_filter.mpr
  refine ⟨Finset.mem_univ o, ?_⟩
  exact maskBit_eq_true_of_reflectedLegal hexact (n := orbitNumberFin o) (by
    simpa [orbitNumberFin] using hreflected)

theorem card_legalOrbitSet_le_maskOrbitSet
    {a b c : OrbitCode} {allowed freshBlocked secantBlocked carrierBlocked : OrbitMask}
    {secants : SecantCompositionCertificate a b c allowed}
    (hexact : RowExactnessCertificate a b c allowed freshBlocked secantBlocked
      carrierBlocked secants) :
    (legalOrbitSet (normalizedConfig a b c)).card ≤ (maskOrbitSet allowed).card :=
  Finset.card_le_card (legalOrbitSet_subset_maskOrbitSet hexact)

end Q25ExactnessComposition
end RelativeConicArcs
