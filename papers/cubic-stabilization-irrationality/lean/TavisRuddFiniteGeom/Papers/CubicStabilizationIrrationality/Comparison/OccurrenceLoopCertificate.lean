import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoLayerDescentPacket
import Mathlib.Algebra.Group.Action.End
import Mathlib.Data.Fintype.Basic

/-!
# Occurrence-indexed loop certificates

This module packages a finite loop computation on an occurrence-indexed
ledger.  Every occurrence has its own label type and its own actual
permutation.  The induced permutation of the total sigma type preserves the
occurrence index by construction, so a computation cannot silently move a
point between two isomorphic occurrences.

The smallest obstruction certificate assigns one natural-number power to
each target point and checks that source divisibility and target fixedness
disagree at that power.  It does not trust a separately reported orbit period.
An adapter from an actual group action must identify the selected generator
with the computed permutation before the certificate can feed the stable
ledger obstruction.

No numerical charge is stored.  A charge is only a coordinate used to compute
a permutation; changing coordinates is accepted here only through an explicit
fiberwise conjugacy.  Reversing the selected loop uses the inverse
permutation and preserves every fixedness test.

These are set-level implications.  They do not construct the geometric loop,
the marked primitive-factor ledger, or the comparison between that loop and
the computed permutations.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.OccurrenceLoopCertificate

open DescentPacket TwoLayerDescentPacket

universe uLedger uG uA

/-- An occurrence-indexed family of finite-label permutations.  Finiteness is
not required by the logical consumer; it is needed only by an external
enumerator producing the certificate. -/
structure Ledger where
  Occurrence : Type uLedger
  Label : Occurrence → Type uLedger
  loop : ∀ occurrence, Equiv.Perm (Label occurrence)

namespace Ledger

/-- The total labelled carrier.  The occurrence tag is part of every point. -/
abbrev Point (ledger : Ledger.{uLedger}) :=
  Σ occurrence, ledger.Label occurrence

/-- The permutation obtained by applying the selected loop inside each
occurrence. -/
def loopPermutation (ledger : Ledger.{uLedger}) :
    Equiv.Perm ledger.Point :=
  Equiv.Perm.sigmaCongrRight ledger.loop

@[simp]
theorem loopPermutation_apply
    (ledger : Ledger.{uLedger})
    (occurrence : ledger.Occurrence)
    (label : ledger.Label occurrence) :
    ledger.loopPermutation ⟨occurrence, label⟩ =
      ⟨occurrence, ledger.loop occurrence label⟩ :=
  rfl

/-- The selected loop cannot mix occurrences. -/
@[simp]
theorem loopPermutation_occurrence
    (ledger : Ledger.{uLedger}) (point : ledger.Point) :
    (ledger.loopPermutation point).1 = point.1 :=
  rfl

/-- No positive or zero power of the selected loop can mix occurrences. -/
theorem loopPermutation_pow_occurrence
    (ledger : Ledger.{uLedger}) (power : ℕ)
    (point : ledger.Point) :
    ((ledger.loopPermutation ^ power) point).1 = point.1 := by
  induction power generalizing point with
  | zero => simp
  | succ power inductionHypothesis =>
      rw [pow_succ]
      change
        ((ledger.loopPermutation ^ power) (ledger.loopPermutation point)).1 =
          point.1
      rw [inductionHypothesis, loopPermutation_occurrence]

/-- Reverse the orientation of the selected loop. -/
def reverse (ledger : Ledger.{uLedger}) :
    Ledger.{uLedger} where
  Occurrence := ledger.Occurrence
  Label := ledger.Label
  loop occurrence := (ledger.loop occurrence)⁻¹

@[simp]
theorem reverse_loopPermutation
    (ledger : Ledger.{uLedger}) :
    ledger.reverse.loopPermutation = ledger.loopPermutation⁻¹ :=
  rfl

end Ledger

/-- A relabelling is legal only when it is occurrence-indexed and conjugates
the actual loop permutations.  This is the typed replacement for changing a
numerical charge by hand. -/
structure FiberwiseRelabelling
    (source target : Ledger.{uLedger}) where
  occurrenceEquiv : source.Occurrence ≃ target.Occurrence
  labelEquiv : ∀ occurrence,
    source.Label occurrence ≃ target.Label (occurrenceEquiv occurrence)
  map_loop : ∀ occurrence label,
    labelEquiv occurrence (source.loop occurrence label) =
      target.loop (occurrenceEquiv occurrence) (labelEquiv occurrence label)

namespace FiberwiseRelabelling

/-- The total equivalence underlying a fiberwise relabelling. -/
def totalEquiv
    {source target : Ledger.{uLedger}}
    (relabel : FiberwiseRelabelling source target) :
    source.Point ≃ target.Point :=
  Equiv.sigmaCongr relabel.occurrenceEquiv relabel.labelEquiv

/-- A legal relabelling intertwines the computed loop permutations. -/
theorem map_loopPermutation
    {source target : Ledger.{uLedger}}
    (relabel : FiberwiseRelabelling source target)
    (point : source.Point) :
    relabel.totalEquiv (source.loopPermutation point) =
      target.loopPermutation (relabel.totalEquiv point) := by
  rcases point with ⟨occurrence, label⟩
  exact Sigma.ext rfl (heq_of_eq (relabel.map_loop occurrence label))

end FiberwiseRelabelling

/-- Inverting a permutation does not change which powers fix a point. -/
theorem inverse_power_fixed_iff
    {Point : Type*} (permutation : Equiv.Perm Point)
    (power : ℕ) (point : Point) :
    ((permutation⁻¹) ^ power) point = point ↔
      (permutation ^ power) point = point := by
  rw [inv_pow]
  simpa [eq_comm] using
    (Equiv.symm_apply_eq (permutation ^ power) (x := point) (y := point))

/-- The smallest finite certificate consumed by the obstruction: for each
target point, one computed power distinguishes its fixedness from the source
divisibility fingerprint. -/
structure FixednessCertificate
    (ledger : Ledger.{uLedger}) (sourcePeriod : ℕ) where
  power : ledger.Point → ℕ
  separated : ∀ point,
    ¬ (sourcePeriod ∣ power point ↔
      (ledger.loopPermutation ^ power point) point = point)

namespace FixednessCertificate

/-- Executable exhaustive check of a proposed witness-power table on a finite
tagged ledger. -/
def check
    {ledger : Ledger.{uLedger}} (sourcePeriod : ℕ)
    [Fintype (Ledger.Point ledger)] [DecidableEq (Ledger.Point ledger)]
    (power : ledger.Point → ℕ) : Bool :=
  decide (∀ point,
    ¬ (sourcePeriod ∣ power point ↔
      (ledger.loopPermutation ^ power point) point = point))

/-- A successful exhaustive Boolean check produces the logical certificate
consumed by the obstruction theorem. -/
def of_check_eq_true
    {ledger : Ledger.{uLedger}} (sourcePeriod : ℕ)
    [Fintype (Ledger.Point ledger)] [DecidableEq (Ledger.Point ledger)]
    (power : ledger.Point → ℕ)
    (checked : check sourcePeriod power = true) :
    FixednessCertificate ledger sourcePeriod where
  power := power
  separated := by
    exact of_decide_eq_true checked

/-- The same fixedness witnesses separate the reverse loop on the identical
tagged carrier. -/
theorem separated_inverse
    {ledger : Ledger.{uLedger}} {sourcePeriod : ℕ}
    (certificate : FixednessCertificate ledger sourcePeriod)
    (point : ledger.Point) :
    ¬ (sourcePeriod ∣ certificate.power point ↔
      (ledger.loopPermutation⁻¹ ^ certificate.power point) point = point) := by
  rw [inverse_power_fixed_iff]
  exact certificate.separated point

end FixednessCertificate

/-- An actual group generator realizes a computed ledger when its permutation
on every tagged point is exactly the ledger permutation. -/
def Realizes
    (G : Type uG) [Group G]
    (generator : G) (ledger : Ledger.{uLedger})
    [MulAction G ledger.Point] : Prop :=
  (MulAction.toPermHom G ledger.Point) generator = ledger.loopPermutation

/-- Realization of one generator determines the action of every natural power
of that generator. -/
theorem pow_smul_eq_loopPermutation_pow
    {G : Type uG} [Group G]
    {ledger : Ledger.{uLedger}}
    [MulAction G ledger.Point]
    {generator : G}
    (realizes : Realizes G generator ledger)
    (power : ℕ) (point : ledger.Point) :
    generator ^ power • point =
      (ledger.loopPermutation ^ power) point := by
  change
    ((MulAction.toPermHom G ledger.Point) (generator ^ power)) point =
      (ledger.loopPermutation ^ power) point
  rw [map_pow, realizes]

/-- Reversing the actual generator realizes the inverse permutation on the
same tagged carrier.  Together with `Ledger.reverse_loopPermutation`, this is
the reverse-orientation adapter without installing a second action instance. -/
theorem realizes_inverse
    {G : Type uG} [Group G]
    {ledger : Ledger.{uLedger}}
    [MulAction G ledger.Point]
    {generator : G}
    (realizes : Realizes G generator ledger) :
    (MulAction.toPermHom G ledger.Point) generator⁻¹ =
      ledger.loopPermutation⁻¹ := by
  rw [map_inv, realizes]

/-- No point certified by the finite fixedness table can have the selected
exact period for the actual loop action.  This is the form consumed by a
pathwise edge ledger: the certificate is checked only at the final vertex,
while typed equivariant edges telescope period support globally. -/
theorem no_selectedPeriod_of_certificate
    {G : Type uG} [Group G]
    {ledger : Ledger.{uLedger}}
    [MulAction G ledger.Point]
    {generator : G} {sourcePeriod : ℕ}
    (realizes : Realizes G generator ledger)
    (certificate : FixednessCertificate ledger sourcePeriod)
    (point : ledger.Point) :
    ¬ HasPowerFixednessPeriod G generator sourcePeriod point := by
  intro targetFixedness
  apply certificate.separated point
  rw [← pow_smul_eq_loopPermutation_pow realizes]
  exact (targetFixedness (certificate.power point)).symm

/-- A source exact-period witness and an occurrence-indexed finite certificate
exclude an equivariant stable-ledger equivalence.  After geometry has already
identified the exhaustive marked target packet with `ledger.Point`, the
remaining adapter is `realizes`, the equality between its selected loop action
and the computed tagged permutation. -/
theorem sourceSum_not_equivariantlyEquivalent_of_certificate
    {G : Type uG} {A B : Type uA}
    [Group G] [MulAction G A] [MulAction G B]
    (generator : G) (sourcePoint : A) (sourcePeriod : ℕ)
    (sourceFixedness :
      HasPowerFixednessPeriod G generator sourcePeriod
        (Sum.inl sourcePoint : A ⊕ B))
    (ledger : Ledger.{uLedger})
    [MulAction G ledger.Point]
    (realizes : Realizes G generator ledger)
    (certificate : FixednessCertificate ledger sourcePeriod) :
    ¬ Nonempty (EquivariantEquiv G (A ⊕ B) ledger.Point) := by
  apply
    sourceSum_not_equivariantlyEquivalent_of_fixednessFingerprintSeparated
      sourcePoint
  intro point
  refine ⟨generator ^ certificate.power point, ?_⟩
  rw [sourceFixedness, pow_smul_eq_loopPermutation_pow realizes]
  exact certificate.separated point

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.OccurrenceLoopCertificate
