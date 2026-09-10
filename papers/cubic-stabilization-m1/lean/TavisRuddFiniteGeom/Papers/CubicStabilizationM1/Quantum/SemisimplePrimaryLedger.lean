import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleCoordinateObjects
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryLedger

/-!
# Semisimple-object weights of whole primary factors

Each full primary factor carries its actual odd object in the explicit
semisimple coordinate category. Eligible nonzero exact-residue rank-two
factors and full-even-rank-three factors contribute that entire object.
Scalar-leading rank-two factors and other ranks contribute zero. Actual
regular block comparisons and odd-object isomorphisms prove invariance.
Multiplicity coordinates provide an additive ledger target and reconstruct
actual semisimple objects, retaining all occurrence multiplicities.

A geometric realization by rational Hodge structures remains an external
category equivalence; these constructions do not encode integral lattices
or polarizations and never take invariant vectors in an odd fiber.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

universe u v

/-- Eligibility for the full-odd-object selector: a nonzero exact rank-two
atom or full even rank three. Scalar-leading rank-two blocks are ineligible. -/
noncomputable def ExactPrimaryBlock.selectsOddObject {K : Type*} [Field K] :
    ExactPrimaryBlock K → Prop
  | .rankTwo connection => rankTwoExactSpectrumAtom connection.loop ≠ 0
  | .scalarRankTwo _ _ _ => False
  | .other evenRank _ _ => evenRank=3

/-- The actual comparison preserves eligibility, including exact resonant
rank-two cases and full even ranks. -/
theorem ExactPrimaryBlockComparison.selectsOddObject_iff
    {K : Type*} [Field K] [CharZero K]
    {source target : ExactPrimaryBlock K} (comparison : ExactPrimaryBlockComparison source target) :
    source.selectsOddObject ↔ target.selectsOddObject := by
  have weights := comparison.weight_eq
  cases comparison with
  | rankTwo comparison =>
    have atoms := congrArg Prod.fst weights
    change rankTwoExactSpectrumAtom _ = rankTwoExactSpectrumAtom _ at atoms
    simp only [ExactPrimaryBlock.selectsOddObject, atoms]
  | scalarRankTwo => rfl
  | other evenEquiv oddEquiv =>
    have ranks := evenEquiv.finrank_eq
    simp only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] at ranks
    simp only [ExactPrimaryBlock.selectsOddObject, ranks]

/-- A whole primary block with its full odd semisimple object. -/
structure SemisimplePrimaryBlock (K : Type*) [Field K]
    (ι : Type u) (division : ι → Type v) [∀ i, DivisionRing (division i)] where
  evenBlock : ExactPrimaryBlock K
  oddObject : SemisimpleCoordinateObject ι division
  /-- The full odd rank is even, and bounds every simple multiplicity, as
  follows from an alternating Frobenius pairing and a faithful realization. -/
  dimensionCompatible : match evenBlock with
    | .other _ oddRank _ => Even oddRank ∧ ∀ i, oddObject.multiplicity i ≤ oddRank
    | _ => True

/-- Effective simple multiplicities of the entire selected odd object. -/
noncomputable def SemisimplePrimaryBlock.weight
    {K : Type*} [Field K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (block : SemisimplePrimaryBlock K ι division) : ι →₀ ℕ := by
  classical
  exact if block.evenBlock.selectsOddObject then block.oddObject.multiplicity else 0

/-- Actual regular/full-fiber block comparison plus an isomorphism of full
odd objects, without a supplied equality of selected weights. -/
structure SemisimplePrimaryBlockComparison
    {K : Type*} [Field K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)]
    (source target : SemisimplePrimaryBlock K ι division) where
  evenComparison : ExactPrimaryBlockComparison source.evenBlock target.evenBlock
  oddIso : source.oddObject.Iso target.oddObject

/-- Actual block and odd-object comparisons preserve the selected object weight. -/
theorem SemisimplePrimaryBlockComparison.weight_eq
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)]
    {source target : SemisimplePrimaryBlock K ι division}
    (comparison : SemisimplePrimaryBlockComparison source target) : source.weight=target.weight := by
  classical
  simp only [SemisimplePrimaryBlock.weight, comparison.evenComparison.selectsOddObject_iff,
    SemisimpleCoordinateObject.multiplicity_eq_of_iso comparison.oddIso]

/-- An isomorphism presentation realized by actual primary comparisons and
full odd-object equivalences. -/
structure SemisimplePrimaryPresentation (K : Type*) [Field K]
    (ι : Type u) (division : ι → Type v) [∀ i, DivisionRing (division i)] where
  regularIsomorphism : Setoid (SemisimplePrimaryBlock K ι division)
  comparisons : ∀ {source target}, regularIsomorphism.r source target →
    Nonempty (SemisimplePrimaryBlockComparison source target)

/-- The effective block presentation underlying the semisimple-object ledger. -/
def SemisimplePrimaryPresentation.toBlockPresentation
    {K : Type*} [Field K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division) :
    BlockPresentation where
  Block := SemisimplePrimaryBlock K ι division
  regularIsomorphism := presentation.regularIsomorphism

/-- The additive whole-odd-object fold, using multiplicity coordinates that
classify actual semisimple objects. -/
noncomputable def SemisimplePrimaryPresentation.fold
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division) :
    presentation.toBlockPresentation.EffectiveLedger →+ (ι →₀ ℕ) :=
  presentation.toBlockPresentation.foldBlocks SemisimplePrimaryBlock.weight (by
    intro source target related
    obtain ⟨comparison⟩ := presentation.comparisons related
    exact comparison.weight_eq)

/-- Reconstruct an actual semisimple coordinate object from the ledger fold. -/
noncomputable def SemisimplePrimaryPresentation.safeObject
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division)
    (ledger : presentation.toBlockPresentation.EffectiveLedger) : SemisimpleCoordinateObject ι division :=
  SemisimpleCoordinateObject.ofMultiplicity division (presentation.fold ledger)

/-- Equal folded multiplicities give an actual isomorphism of the unlabelled
safe objects, rather than an equality of their total dimensions. -/
noncomputable def SemisimplePrimaryPresentation.safeObjectIso
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division)
    (left right : presentation.toBlockPresentation.EffectiveLedger)
    (equal : presentation.fold left=presentation.fold right) :
    (presentation.safeObject left).Iso (presentation.safeObject right) :=
  SemisimpleCoordinateObject.isoOfMultiplicityEq _ _ (by
    simpa only [safeObject, SemisimpleCoordinateObject.multiplicity_ofMultiplicity] using equal)

/-- Zero numerical exact-primary weight forces zero full-odd-object weight.
In even rank three, parity turns a vanishing half-odd rank into odd rank zero;
the actual object's simple multiplicities are then all zero. -/
theorem SemisimplePrimaryBlock.weight_zero_of_numeric_zero
    {K : Type*} [Field K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (block : SemisimplePrimaryBlock K ι division)
    (numericZero : block.evenBlock.weight=0) : block.weight=0 := by
  classical
  rcases block with ⟨evenBlock,oddObject,compatible⟩
  cases evenBlock with
  | rankTwo connection =>
    have atomZero := congrArg Prod.fst numericZero
    change rankTwoExactSpectrumAtom connection.loop=0 at atomZero
    simp [weight, ExactPrimaryBlock.selectsOddObject, atomZero]
  | scalarRankTwo loop centered oddRank => simp [weight, ExactPrimaryBlock.selectsOddObject]
  | other evenRank oddRank notTwo =>
    by_cases rankThree : evenRank=3
    · have halfZero := congrArg Prod.snd numericZero
      change (if evenRank=3 then oddRank/2 else 0)=0 at halfZero
      rw [if_pos rankThree] at halfZero
      have oddZero : oddRank=0 := by
        obtain ⟨n,hn⟩ := compatible.1
        omega
      have multiplicityZero : oddObject.multiplicity=0 := by
        ext i
        have bounded := compatible.2 i
        rw [oddZero] at bounded
        exact Nat.eq_zero_of_le_zero bounded
      simp [weight, ExactPrimaryBlock.selectsOddObject, rankThree, multiplicityZero]
    · simp [weight, ExactPrimaryBlock.selectsOddObject, rankThree]

/-- The numerical exact-primary fold on the same full-object block presentation. -/
noncomputable def SemisimplePrimaryPresentation.numericFold
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division) :
    presentation.toBlockPresentation.EffectiveLedger →+ ((K →₀ ℕ) × ℕ) :=
  presentation.toBlockPresentation.foldBlocks (fun block => block.evenBlock.weight) (by
    intro source target related
    obtain ⟨comparison⟩ := presentation.comparisons related
    exact comparison.evenComparison.weight_eq)

/-- Vanishing of the effective numerical fold forces vanishing of the full
semisimple-object fold, with no cancellation among occurrences. -/
theorem SemisimplePrimaryPresentation.fold_zero_of_numericFold_zero
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division)
    (ledger : presentation.toBlockPresentation.EffectiveLedger)
    (numericZero : presentation.numericFold ledger=0) : presentation.fold ledger=0 := by
  induction ledger using Multiset.induction_on with
  | empty => exact map_zero _
  | @cons component tail ih =>
    rw [← Multiset.singleton_add, map_add] at numericZero ⊢
    obtain ⟨headZero,tailZero⟩ := add_eq_zero.mp numericZero
    rw [ih tailZero, add_zero]
    induction component using Quotient.inductionOn with
    | h block =>
      change presentation.toBlockPresentation.foldBlocks SemisimplePrimaryBlock.weight (by
        intro left right related
        obtain ⟨comparison⟩ := presentation.comparisons related
        exact comparison.weight_eq)
        {presentation.toBlockPresentation.component block}=0
      rw [BlockPresentation.foldBlocks_singleton]
      apply block.weight_zero_of_numeric_zero
      change presentation.toBlockPresentation.foldBlocks (fun block => block.evenBlock.weight) (by
        intro left right related
        obtain ⟨comparison⟩ := presentation.comparisons related
        exact comparison.evenComparison.weight_eq)
        {presentation.toBlockPresentation.component block}=0 at headZero
      rw [BlockPresentation.foldBlocks_singleton] at headZero
      exact headZero

/-- Additivity of the ledger gives an actual direct-sum isomorphism of its
reconstructed semisimple safe objects. -/
noncomputable def SemisimplePrimaryPresentation.safeObjectAddIso
    {K : Type*} [Field K] [CharZero K] {ι : Type u} {division : ι → Type v}
    [∀ i, DivisionRing (division i)] (presentation : SemisimplePrimaryPresentation K ι division)
    (left right : presentation.toBlockPresentation.EffectiveLedger) :
    (presentation.safeObject (left+right)).Iso
      ((presentation.safeObject left).sum (presentation.safeObject right)) :=
  SemisimpleCoordinateObject.isoOfMultiplicityEq _ _ (by
    simp only [safeObject, SemisimpleCoordinateObject.multiplicity_sum,
      SemisimpleCoordinateObject.multiplicity_ofMultiplicity, map_add])

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
