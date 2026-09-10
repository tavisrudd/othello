import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactResidueSelectors

/-!
# Effective ledgers of exact primary weights

An adapted rank-two block carries its actual loop matrix series and horizontal
nondegenerate pairing. Its comparison data are regular horizontal matrix series
with regular inverses, rather than an assumed invariant weight. Other blocks
retain the dimensions of their full even and odd coordinate spaces, and their
comparisons are linear equivalences of those spaces. Centered rank-two blocks
with zero leading operator are retained with zero weight; they do not define
an adapted nilpotent line or a canonical residue selector. These data prove invariance
of the pair consisting of the exact discriminant spectrum and the rank-three
odd weight. The universal effective-ledger fold retains all occurrences.

The regular-isomorphism equivalence relation and its realization by the stated
comparisons are supplied. Geometric QDM blocks and their comparisons are not
constructed by this algebraic interface.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- An adapted formal rank-two connection with the horizontal nondegenerate
pairing needed to transport its canonical modified residue. -/
structure AdaptedRankTwoConnection (K : Type*) [Field K] where
  loop : PowerSeries (Matrix (Fin 2) (Fin 2) K)
  pairing : PowerSeries (Matrix (Fin 2) (Fin 2) K)
  leadingUnit : K
  adapted : PowerSeries.coeff 0 loop = adaptedLeadingOperator leadingUnit
  leadingNonzero : leadingUnit ≠ 0
  pairingNonzero : (PowerSeries.coeff 0 pairing).det ≠ 0
  horizontalPairing : IsHorizontalPairing loop pairing

/-- An actual regular horizontal comparison and its regular horizontal inverse. -/
structure RegularRankTwoComparison {K : Type*} [Field K]
    (source target : AdaptedRankTwoConnection K) where
  comparison : PowerSeries (Matrix (Fin 2) (Fin 2) K)
  inverse : PowerSeries (Matrix (Fin 2) (Fin 2) K)
  horizontal : IsHorizontalLoopComparison source.loop target.loop comparison
  inverseHorizontal : IsHorizontalLoopComparison target.loop source.loop inverse
  leftInverse : comparison*inverse=1
  rightInverse : inverse*comparison=1

/-- An eligible adapted rank-two block, an ineligible centered rank-two
block with zero leading operator, or a block of a different full even rank.
The scalar-leading case retains its actual loop and full odd dimension. -/
inductive ExactPrimaryBlock (K : Type*) [Field K]
  | rankTwo (connection : AdaptedRankTwoConnection K)
  | scalarRankTwo (loop : PowerSeries (Matrix (Fin 2) (Fin 2) K))
      (centered : PowerSeries.coeff 0 loop=0) (oddRank : ℕ)
  | other (evenRank oddRank : ℕ) (notTwo : evenRank ≠ 2)

/-- The exact spectrum and the half-odd-dimension selector form an additive
pair of effective weights. -/
noncomputable def ExactPrimaryBlock.weight {K : Type*} [Field K] :
    ExactPrimaryBlock K → (K →₀ ℕ) × ℕ
  | .rankTwo connection => (rankTwoExactSpectrumAtom connection.loop,0)
  | .scalarRankTwo _ _ _ => 0
  | .other evenRank oddRank _ => (0,if evenRank=3 then oddRank/2 else 0)

/-- Comparison evidence is matrix horizontality in rank two and full coordinate
space equivalence in every other even rank. No weight equality is a field. -/
inductive ExactPrimaryBlockComparison {K : Type*} [Field K] :
    ExactPrimaryBlock K → ExactPrimaryBlock K → Type _
  | rankTwo {source target : AdaptedRankTwoConnection K}
      (comparison : RegularRankTwoComparison source target) :
      ExactPrimaryBlockComparison (.rankTwo source) (.rankTwo target)
  | scalarRankTwo {source target : PowerSeries (Matrix (Fin 2) (Fin 2) K)}
      {sourceZero : PowerSeries.coeff 0 source=0} {targetZero : PowerSeries.coeff 0 target=0}
      {sourceOdd targetOdd : ℕ}
      (comparison inverse : PowerSeries (Matrix (Fin 2) (Fin 2) K))
      (horizontal : IsHorizontalLoopComparison source target comparison)
      (inverseHorizontal : IsHorizontalLoopComparison target source inverse)
      (leftInverse : comparison*inverse=1) (rightInverse : inverse*comparison=1)
      (oddEquiv : (Fin sourceOdd → K) ≃ₗ[K] (Fin targetOdd → K)) :
      ExactPrimaryBlockComparison (.scalarRankTwo source sourceZero sourceOdd)
        (.scalarRankTwo target targetZero targetOdd)
  | other {e o e' o' : ℕ} {ne : e ≠ 2} {ne' : e' ≠ 2}
      (evenEquiv : (Fin e → K) ≃ₗ[K] (Fin e' → K))
      (oddEquiv : (Fin o → K) ≃ₗ[K] (Fin o' → K)) :
      ExactPrimaryBlockComparison (.other e o ne) (.other e' o' ne')

/-- Actual block comparisons preserve both effective weights. -/
theorem ExactPrimaryBlockComparison.weight_eq {K : Type*} [Field K] [CharZero K]
    {source target : ExactPrimaryBlock K} (comparison : ExactPrimaryBlockComparison source target) :
    source.weight=target.weight := by
  cases comparison with
  | @rankTwo source target comparison =>
    apply Prod.ext
    · exact (rankTwoExactSpectrumAtom_regularComparison (by
        apply isUnit_iff_ne_zero.mpr; norm_num)
        comparison.horizontal comparison.inverseHorizontal source.adapted target.adapted
        (isUnit_iff_ne_zero.mpr source.leadingNonzero) (isUnit_iff_ne_zero.mpr target.leadingNonzero)
        (isUnit_iff_ne_zero.mpr source.pairingNonzero) (isUnit_iff_ne_zero.mpr target.pairingNonzero)
        source.horizontalPairing target.horizontalPairing
        comparison.leftInverse comparison.rightInverse).symm
    · rfl
  | scalarRankTwo => rfl
  | other evenEquiv oddEquiv =>
    have he := evenEquiv.finrank_eq
    have ho := oddEquiv.finrank_eq
    simp only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] at he ho
    simp only [ExactPrimaryBlock.weight, he, ho]

/-- A regular-isomorphism presentation whose related blocks have concrete
comparison evidence; invariance of the weight is proved from that evidence. -/
structure ExactPrimaryPresentation (K : Type*) [Field K] where
  regularIsomorphism : Setoid (ExactPrimaryBlock K)
  comparisons : ∀ {source target}, regularIsomorphism.r source target →
    Nonempty (ExactPrimaryBlockComparison source target)

/-- The block presentation underlying the exact primary ledger. -/
def ExactPrimaryPresentation.toBlockPresentation {K : Type*} [Field K]
    (presentation : ExactPrimaryPresentation K) : BlockPresentation where
  Block := ExactPrimaryBlock K
  regularIsomorphism := presentation.regularIsomorphism

/-- The actual comparison evidence proves the weight invariant under the
presentation's regular-isomorphism relation. -/
theorem ExactPrimaryPresentation.weight_invariant {K : Type*} [Field K] [CharZero K]
    (presentation : ExactPrimaryPresentation K) {source target : ExactPrimaryBlock K}
    (related : presentation.regularIsomorphism.r source target) : source.weight=target.weight := by
  obtain ⟨comparison⟩ := presentation.comparisons related
  exact comparison.weight_eq

/-- The exact primary weight extends to the effective ledger, retaining all
occurrence multiplicities and using no subtraction or exponent quotient. -/
noncomputable def ExactPrimaryPresentation.fold {K : Type*} [Field K] [CharZero K]
    (presentation : ExactPrimaryPresentation K) :
    presentation.toBlockPresentation.EffectiveLedger →+ ((K →₀ ℕ) × ℕ) :=
  presentation.toBlockPresentation.foldBlocks ExactPrimaryBlock.weight
    presentation.weight_invariant

/-- The fold has precisely the constructed primary weight on every occurrence. -/
theorem ExactPrimaryPresentation.fold_singleton {K : Type*} [Field K] [CharZero K]
    (presentation : ExactPrimaryPresentation K) (block : ExactPrimaryBlock K) :
    presentation.fold {presentation.toBlockPresentation.component block} = block.weight :=
  presentation.toBlockPresentation.foldBlocks_singleton _ _ block

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
