import RelativeConicArcs.ClebschTwoGraph
import Mathlib.Data.Fintype.Defs
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Aligned four-sets of a two-graph

This module isolates the Boolean reconstruction mechanism for aligned
four-sets.  A triangle bit satisfies the two-graph four-set parity law.
Rooting at one vertex turns the triangle bits into graph-edge bits, and an
aligned four-set is one on which the four triangle bits agree.

The seven-vertex core is written in the normalized coordinates used by the
proof: an aligned four-set has zero internal edges, each of the three outside
cuts has its fourth coordinate fixed to zero, and three further bits record
the outside edges.  The public intermediate theorem identifies the sole
two-point ambiguity (interchanging two distinct balanced cuts); the
three-outside-point theorem checks that the three pair signatures eliminate
it.  The third-point elimination is a symbolic argument from that classifier.

Every finite step in this module is discharged by kernel reduction, including
the anchor-signature classification over the eight normalized cuts and the pair
classifier over its 16,384 cases.  Neither compiled evaluation, nor generated
data, nor an external program, nor an unproved mathematical axiom is used
anywhere in the module.

Anchor existence is proved in this module.  Both halves of Ramsey's equality
for triangles are available: six points force a monochromatic triple, by a
pigeonhole step over the thirty-two Boolean words on five vertices, and five
points do not, by the pentagon colouring.  Consequently a rooted two-graph on
six labelled points contains an aligned four-set through the root with no
supplied monochromatic triple.
-/

namespace RelativeConicArcs
namespace AlignedTwoGraph

attribute [local instance] Fintype.decidableForallFintype

/-- The four-set parity law for ordered triangle bits.  Permutation invariance
of the triangle arguments is recorded separately when it is needed. -/
def FourSetParity {α : Type*} (tau : α → α → α → Bool) : Prop :=
  ∀ a b c d,
    Bool.xor (tau a b c)
      (Bool.xor (tau a b d) (Bool.xor (tau a c d) (tau b c d))) = false

/-- Four vertices are aligned when their four triangle bits coincide. -/
def Aligned {α : Type*} (tau : α → α → α → Bool)
    (a b c d : α) : Prop :=
  tau a b c = tau a b d ∧
    tau a b c = tau a c d ∧
    tau a b c = tau b c d

/-- Global complementation of all triangle bits. -/
def complement {α : Type*} (tau : α → α → α → Bool) : α → α → α → Bool :=
  fun a b c => !(tau a b c)

/-- Complementing every triangle bit preserves aligned four-sets. -/
theorem aligned_complement_iff {α : Type*} (tau : α → α → α → Bool)
    (a b c d : α) :
    Aligned (complement tau) a b c d ↔ Aligned tau a b c d := by
  unfold Aligned complement
  cases tau a b c <;> cases tau a b d <;> cases tau a c d <;>
    cases tau b c d <;> decide

/-- The rooted graph attached to a triangle-bit function. -/
def rootedEdge {α : Type*} (tau : α → α → α → Bool) (r i j : α) : Bool :=
  tau r i j

/-- The four-set parity law reconstructs a triangle from its three rooted
edges. -/
theorem triangle_eq_rooted_xor {α : Type*} (tau : α → α → α → Bool)
    (hfour : FourSetParity tau) (r i j k : α) :
    tau i j k = Bool.xor (rootedEdge tau r i j)
      (Bool.xor (rootedEdge tau r i k) (rootedEdge tau r j k)) := by
  have h := hfour r i j k
  simp only [rootedEdge] at h ⊢
  revert h
  cases tau r i j <;> cases tau r i k <;> cases tau r j k <;>
    cases tau i j k <;> decide

/-- A monochromatic triangle in the rooted graph gives an aligned four-set
containing the root. -/
theorem aligned_of_rooted_monochromatic_triangle {α : Type*}
    (tau : α → α → α → Bool) (hfour : FourSetParity tau)
    (r i j k : α)
    (hij : rootedEdge tau r i j = rootedEdge tau r i k)
    (hik : rootedEdge tau r i k = rootedEdge tau r j k) :
    Aligned tau r i j k := by
  have htriangle := triangle_eq_rooted_xor tau hfour r i j k
  unfold Aligned
  unfold rootedEdge at hij hik htriangle
  refine ⟨hij, hij.trans hik, ?_⟩
  have hlast : tau i j k = tau r i j := by
    calc
      tau i j k = Bool.xor (tau r i j)
          (Bool.xor (tau r i k) (tau r j k)) := htriangle
      _ = tau r i j := by
        rw [← hij, ← hij.trans hik]
        cases tau r i j <;> decide
  exact hlast.symm

/-- The anchor step in conditional form: any supplied monochromatic triple
among six rooted vertices yields one of the twenty tested aligned four-sets.
The triple is produced without hypotheses in `exists_alignedAnchor`. -/
theorem alignedAnchor_of_ramseyTriple {α : Type*}
    (tau : α → α → α → Bool) (hfour : FourSetParity tau)
    (r : α) (v : Fin 6 → α)
    (hramsey : ∃ i j k : Fin 6,
      rootedEdge tau r (v i) (v j) = rootedEdge tau r (v i) (v k) ∧
      rootedEdge tau r (v i) (v k) = rootedEdge tau r (v j) (v k)) :
    ∃ i j k : Fin 6, Aligned tau r (v i) (v j) (v k) := by
  obtain ⟨i, j, k, hij, hik⟩ := hramsey
  exact ⟨i, j, k, aligned_of_rooted_monochromatic_triangle tau hfour
    r (v i) (v j) (v k) hij hik⟩

/-- Among five Boolean values three are equal, indexed increasingly.  This is
the pigeonhole step of the six-point Ramsey argument, isolated so that the
kernel check ranges over the thirty-two Boolean words rather than over
colourings of the fifteen pairs.  The words are supplied as five separate
Boolean arguments, so the check enumerates two values five times and never
builds a function-space enumeration. -/
private theorem three_equal_of_five (g : Fin 5 → Bool) :
    ∃ a b c : Fin 5, a < b ∧ b < c ∧ g a = g b ∧ g b = g c := by
  have hword : ∀ b₀ b₁ b₂ b₃ b₄ : Bool, ∃ a b c : Fin 5, a < b ∧ b < c ∧
      ![b₀, b₁, b₂, b₃, b₄] a = ![b₀, b₁, b₂, b₃, b₄] b ∧
      ![b₀, b₁, b₂, b₃, b₄] b = ![b₀, b₁, b₂, b₃, b₄] c := by
    decide
  have hval : ∀ t : Fin 5, ![g 0, g 1, g 2, g 3, g 4] t = g t := by
    intro t
    fin_cases t <;> rfl
  obtain ⟨a, b, c, hab, hbc, h1, h2⟩ := hword (g 0) (g 1) (g 2) (g 3) (g 4)
  exact ⟨a, b, c, hab, hbc, by rw [← hval a, ← hval b]; exact h1,
    by rw [← hval b, ← hval c]; exact h2⟩

/-- A two-colouring of the pairs on five points with no monochromatic triple:
the pentagon and its complementary pentagram are both five-cycles, and a
five-cycle contains no triangle.  With the six-point statement below this is
the sharpness half of Ramsey's equality for triangles. -/
def pentagonColouring : Fin 5 → Fin 5 → Bool :=
  ![![false, true, false, false, true],
    ![true, false, true, false, false],
    ![false, true, false, true, false],
    ![false, false, true, false, true],
    ![true, false, false, true, false]]

/-- Five points do not force a monochromatic triple, so the six-point bound is
sharp.  Checked by kernel reduction over the increasing triples of a
five-element set. -/
theorem no_monochromatic_triple_five :
    ∀ i j k : Fin 5, i < j → j < k →
      ¬(pentagonColouring i j = pentagonColouring i k ∧
        pentagonColouring i k = pentagonColouring j k) := by
  decide

/-- The six-point half of Ramsey's theorem for triangles, `R(3,3) ≤ 6`, in the
form the anchor argument uses: for every two-colouring `f` of the ordered pairs
from six points there are three points `i < j < k` whose three pairs receive
the same colour.  Only the values of `f` on increasing pairs are read, so `f`
is not assumed symmetric; instantiating at a symmetric colouring recovers the
classical statement, and conversely any `f` induces one.  Together with
`no_monochromatic_triple_five` this gives the equality `R(3,3) = 6`.

The proof is the classical pigeonhole argument.  Three of the five pairs at the
first point share a colour; if any pair among those three points also has that
colour it closes a monochromatic triple with the first point, and otherwise
the three points carry the opposite colour on all three of their pairs. -/
theorem exists_monochromatic_triple (f : Fin 6 → Fin 6 → Bool) :
    ∃ i j k : Fin 6, i < j ∧ j < k ∧ f i j = f i k ∧ f i k = f j k := by
  obtain ⟨a, b, c, hab, hbc, hga, hgb⟩ :=
    three_equal_of_five (fun t => f 0 t.succ)
  by_cases h1 : f a.succ b.succ = f 0 a.succ
  · exact ⟨0, a.succ, b.succ, Fin.succ_pos a, Fin.succ_lt_succ_iff.mpr hab,
      hga, hga.symm.trans h1.symm⟩
  · by_cases h2 : f a.succ c.succ = f 0 a.succ
    · exact ⟨0, a.succ, c.succ, Fin.succ_pos a,
        Fin.succ_lt_succ_iff.mpr (hab.trans hbc), hga.trans hgb,
        (hga.trans hgb).symm.trans h2.symm⟩
    · by_cases h3 : f b.succ c.succ = f 0 b.succ
      · exact ⟨0, b.succ, c.succ, Fin.succ_pos b,
          Fin.succ_lt_succ_iff.mpr hbc, hgb, hgb.symm.trans h3.symm⟩
      · have e1 : f a.succ b.succ = !(f 0 a.succ) := by
          cases hv : f a.succ b.succ <;> cases hw : f 0 a.succ <;> simp_all
        have e2 : f a.succ c.succ = !(f 0 a.succ) := by
          cases hv : f a.succ c.succ <;> cases hw : f 0 a.succ <;> simp_all
        have e3 : f b.succ c.succ = !(f 0 a.succ) := by
          have e3' : f b.succ c.succ = !(f 0 b.succ) := by
            cases hv : f b.succ c.succ <;> cases hw : f 0 b.succ <;> simp_all
          rw [e3', hga]
        exact ⟨a.succ, b.succ, c.succ, Fin.succ_lt_succ_iff.mpr hab,
          Fin.succ_lt_succ_iff.mpr hbc, e1.trans e2.symm, e2.trans e3.symm⟩

/-- Existence of an aligned four-set through the root on six labelled points,
with no supplied monochromatic triple: the triple is produced by the six-point
Ramsey bound applied to the rooted edges.  The three indices are returned in
increasing order, hence are distinct; whether the six points themselves are
distinct, and distinct from the root, is a property of `v` and `r` that the
caller supplies. -/
theorem exists_alignedAnchor {α : Type*}
    (tau : α → α → α → Bool) (hfour : FourSetParity tau)
    (r : α) (v : Fin 6 → α) :
    ∃ i j k : Fin 6, i < j ∧ j < k ∧ Aligned tau r (v i) (v j) (v k) := by
  obtain ⟨i, j, k, hij, hjk, hone, htwo⟩ :=
    exists_monochromatic_triple (fun s t => rootedEdge tau r (v s) (v t))
  exact ⟨i, j, k, hij, hjk,
    aligned_of_rooted_monochromatic_triangle tau hfour r (v i) (v j) (v k)
      hone htwo⟩

/-- A cut from an outside point to a normalized aligned four-set.  Its value
is the three-bit word formed by the first three coordinates; the fourth is
fixed to zero. -/
abbrev NormalizedCut := Fin 8

/-- Read one of the four cut coordinates, including the normalized zero. -/
def cutBit (p : NormalizedCut) : Fin 4 → Bool
  | 0 => p.val.testBit 0
  | 1 => p.val.testBit 1
  | 2 => p.val.testBit 2
  | 3 => false

/-- Equality of two bits, returned as a bit. -/
def equalBit (a b : Bool) : Bool := decide (a = b)

/-- The four tests using an outside point and three points of the anchor.  The
coordinate is the omitted anchor point. -/
def anchorSignature (p : NormalizedCut) : Fin 4 → Bool
  | 0 => equalBit (cutBit p 1) (cutBit p 2) && equalBit (cutBit p 2) (cutBit p 3)
  | 1 => equalBit (cutBit p 0) (cutBit p 2) && equalBit (cutBit p 2) (cutBit p 3)
  | 2 => equalBit (cutBit p 0) (cutBit p 1) && equalBit (cutBit p 1) (cutBit p 3)
  | 3 => equalBit (cutBit p 0) (cutBit p 1) && equalBit (cutBit p 1) (cutBit p 2)

/-- The balanced cut with coordinates `1,1,0`: the outside point is joined to
the first two anchor coordinates and not to the third.  With the fourth
coordinate normalized to zero, it splits the anchor into the pair carrying
coordinates `0,1` and the pair carrying coordinate `2` and the root, whence the
name. -/
def balancedCut12 : NormalizedCut := 3

/-- The balanced cut with coordinates `1,0,1`: it splits the anchor into the
pair carrying coordinates `0,2` and the pair carrying coordinate `1` and the
root. -/
def balancedCut13 : NormalizedCut := 5

/-- The balanced cut with coordinates `0,1,1`: it splits the anchor into the
pair carrying coordinate `0` and the root, and the pair carrying coordinates
`1,2`. -/
def balancedCut14 : NormalizedCut := 6

/-- The three normalized balanced cuts of a four-point anchor. -/
def IsBalancedCut (p : NormalizedCut) : Prop :=
  p = balancedCut12 ∨ p = balancedCut13 ∨ p = balancedCut14

instance (p : NormalizedCut) : Decidable (IsBalancedCut p) := by
  unfold IsBalancedCut
  infer_instance

/-- Exactly the three balanced cuts have empty anchor signature. -/
theorem anchorSignature_eq_false_iff_balanced :
    ∀ p : NormalizedCut,
      (∀ i, anchorSignature p i = false) ↔ IsBalancedCut p := by
  decide

/-- Whether a pair of anchor points passes the aligned test with two outside
points having cuts `p,s` and mutual edge bit `e`. -/
def pairAligned (p s : NormalizedCut) (e : Bool) (i j : Fin 4) : Bool :=
  equalBit (Bool.xor (cutBit p i) (cutBit s i))
      (Bool.xor (cutBit p j) (cutBit s j)) &&
    equalBit e (Bool.xor (cutBit p j) (cutBit s i))

/-- The six two-anchor-point tests, in the order
`01,02,03,12,13,23`. -/
def pairSignature (p s : NormalizedCut) (e : Bool) : Fin 6 → Bool
  | 0 => pairAligned p s e 0 1
  | 1 => pairAligned p s e 0 2
  | 2 => pairAligned p s e 0 3
  | 3 => pairAligned p s e 1 2
  | 4 => pairAligned p s e 1 3
  | 5 => pairAligned p s e 2 3

/-- Equal one-point and pair signatures recover two labelled cuts and their
mutual edge.  The only exception interchanges two distinct balanced cuts and
leaves the edge fixed. -/
theorem pairSignature_classification :
    ∀ p s p' s' : NormalizedCut, ∀ e e' : Bool,
      (∀ i, anchorSignature p i = anchorSignature p' i) →
      (∀ i, anchorSignature s i = anchorSignature s' i) →
      (∀ q, pairSignature p s e q = pairSignature p' s' e' q) →
      (p = p' ∧ s = s' ∧ e = e') ∨
        (IsBalancedCut p ∧ IsBalancedCut s ∧ p ≠ s ∧
          p' = s ∧ s' = p ∧ e' = e) := by
  decide

/-- The three mutual edges among the three outside points. -/
abbrev OutsideEdges := Fin 3 → Bool

/-- Normalized data for a seven-point two-graph around an aligned four-point
anchor. -/
structure NormalizedSevenData where
  cut : Fin 3 → NormalizedCut
  edge : OutsideEdges

/-- The pair of outside-point labels indexed by an edge coordinate. -/
def outsidePair : Fin 3 → Fin 3 × Fin 3
  | 0 => (0, 1)
  | 1 => (0, 2)
  | 2 => (1, 2)

/-- All selected tests meeting the fixed anchor in at least two points. -/
def normalizedSevenSignature (d : NormalizedSevenData) :
    (Fin 3 → Fin 4 → Bool) × (Fin 3 → Fin 6 → Bool) :=
  (fun x => anchorSignature (d.cut x), fun q =>
    pairSignature (d.cut (outsidePair q).1)
      (d.cut (outsidePair q).2) (d.edge q))

/-- Pointwise equality of all one-outside-point and two-outside-point tests. -/
def SameNormalizedSevenSignature (d e : NormalizedSevenData) : Prop :=
  (∀ x i, (normalizedSevenSignature d).1 x i =
    (normalizedSevenSignature e).1 x i) ∧
  (∀ q t, (normalizedSevenSignature d).2 q t =
    (normalizedSevenSignature e).2 q t)

instance (d e : NormalizedSevenData) : Decidable (SameNormalizedSevenSignature d e) := by
  unfold SameNormalizedSevenSignature
  infer_instance

/-- The result of comparing the signatures belonging to one labelled pair of
outside points. -/
def PairOutcome (p s p' s' : NormalizedCut) (e e' : Bool) : Prop :=
  (p = p' ∧ s = s' ∧ e = e') ∨
    (p ≠ s ∧ p' = s ∧ s' = p ∧ e' = e)

/-- Equal signatures for a labelled outside pair give either exact recovery
or the distinct-cut swap allowed by the finite classifier. -/
theorem pairOutcome_of_same_signatures
    (p s p' s' : NormalizedCut) (e e' : Bool)
    (hp : ∀ i, anchorSignature p i = anchorSignature p' i)
    (hs : ∀ i, anchorSignature s i = anchorSignature s' i)
    (hpair : ∀ q, pairSignature p s e q = pairSignature p' s' e' q) :
    PairOutcome p s p' s' e e' := by
  rcases pairSignature_classification p s p' s' e e' hp hs hpair with h | h
  · exact Or.inl h
  · exact Or.inr ⟨h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2⟩

/-- If all three outside pairs are either exact or distinct-balanced swaps,
then every pair is exact.  This is the third-outside-point elimination. -/
theorem threePairOutcomes_eliminate_swaps
    (p₀ p₁ p₂ p₀' p₁' p₂' : NormalizedCut)
    (e₀₁ e₀₂ e₁₂ e₀₁' e₀₂' e₁₂' : Bool)
    (h₀₁ : PairOutcome p₀ p₁ p₀' p₁' e₀₁ e₀₁')
    (h₀₂ : PairOutcome p₀ p₂ p₀' p₂' e₀₂ e₀₂')
    (h₁₂ : PairOutcome p₁ p₂ p₁' p₂' e₁₂ e₁₂') :
    p₀ = p₀' ∧ p₁ = p₁' ∧ p₂ = p₂' ∧
      e₀₁ = e₀₁' ∧ e₀₂ = e₀₂' ∧ e₁₂ = e₁₂' := by
  rcases h₀₁ with ⟨h₀₁a, h₀₁b, h₀₁e⟩ |
      ⟨h₀₁n, h₀₁a, h₀₁b, h₀₁e⟩ <;>
    rcases h₀₂ with ⟨h₀₂a, h₀₂b, h₀₂e⟩ |
      ⟨h₀₂n, h₀₂a, h₀₂b, h₀₂e⟩ <;>
      rcases h₁₂ with ⟨h₁₂a, h₁₂b, h₁₂e⟩ |
        ⟨h₁₂n, h₁₂a, h₁₂b, h₁₂e⟩ <;>
        subst_vars <;> simp_all

/-- On seven labelled points the selected aligned-four-set tests recover all
normalized cut and outside-edge data.  In particular, the third outside point
eliminates the order ambiguity between two distinct balanced cuts. -/
theorem normalizedSevenSignature_injective :
    ∀ d e : NormalizedSevenData, SameNormalizedSevenSignature d e → d = e := by
  intro d e h
  have h₀₁ : PairOutcome (d.cut 0) (d.cut 1) (e.cut 0) (e.cut 1)
      (d.edge 0) (e.edge 0) :=
    pairOutcome_of_same_signatures _ _ _ _ _ _
      (h.1 0) (h.1 1) (h.2 0)
  have h₀₂ : PairOutcome (d.cut 0) (d.cut 2) (e.cut 0) (e.cut 2)
      (d.edge 1) (e.edge 1) :=
    pairOutcome_of_same_signatures _ _ _ _ _ _
      (h.1 0) (h.1 2) (h.2 1)
  have h₁₂ : PairOutcome (d.cut 1) (d.cut 2) (e.cut 1) (e.cut 2)
      (d.edge 2) (e.edge 2) :=
    pairOutcome_of_same_signatures _ _ _ _ _ _
      (h.1 1) (h.1 2) (h.2 2)
  have hall := threePairOutcomes_eliminate_swaps
    _ _ _ _ _ _ _ _ _ _ _ _ h₀₁ h₀₂ h₁₂
  rcases hall with ⟨hc₀, hc₁, hc₂, he₀₁, he₀₂, he₁₂⟩
  cases d with
  | mk dc de =>
    cases e with
    | mk ec ee =>
      congr
      · funext x
        fin_cases x
        · exact hc₀
        · exact hc₁
        · exact hc₂
      · funext q
        fin_cases q
        · exact he₀₁
        · exact he₀₂
        · exact he₁₂

/-- Three labels are pairwise distinct. -/
def DistinctTriple {α : Type*} (a b c : α) : Prop :=
  a ≠ b ∧ a ≠ c ∧ b ≠ c

/-- Two triangle-bit functions agree on a labelled triple after applying one
fixed global complement bit. -/
def AgreesWithComplementBit {α : Type*}
    (tau sigma : α → α → α → Bool) (epsilon : Bool)
    (a b c : α) : Prop :=
  sigma a b c = Bool.xor (tau a b c) epsilon

/-- The complement bit is unique as soon as it is calibrated on one triple. -/
theorem complementBit_unique {α : Type*}
    (tau sigma : α → α → α → Bool) (a b c : α) (epsilon delta : Bool)
    (he : AgreesWithComplementBit tau sigma epsilon a b c)
    (hd : AgreesWithComplementBit tau sigma delta a b c) :
    epsilon = delta := by
  unfold AgreesWithComplementBit at he hd
  cases tau a b c <;> cases sigma a b c <;> cases epsilon <;> cases delta <;>
    simp_all

/-- One calibrated triangle on which the two orientations agree forces the
global complement bit to be zero. -/
theorem calibratedTriangle_forces_no_complement {α : Type*}
    (tau sigma : α → α → α → Bool) (a b c : α) (epsilon : Bool)
    (hglobal : AgreesWithComplementBit tau sigma epsilon a b c)
    (hcalibrated : sigma a b c = tau a b c) : epsilon = false := by
  have hzero : AgreesWithComplementBit tau sigma false a b c := by
    simpa [AgreesWithComplementBit] using hcalibrated
  exact complementBit_unique tau sigma a b c epsilon false hglobal hzero

/-- Local seven-point complement choices globalize when every pair of
distinct triples is contained in one seven-point restriction.  The
co-containment and local-faithfulness work is expressed by `hpair`; the proof
here checks that all resulting complement bits agree on their overlaps. -/
theorem global_agreement_of_common_seven_restrictions {α : Type*}
    (tau sigma : α → α → α → Bool)
    (r₀ r₁ r₂ : α) (hr : DistinctTriple r₀ r₁ r₂)
    (hpair : ∀ a b c x y z,
      DistinctTriple a b c → DistinctTriple x y z →
      ∃ epsilon,
        AgreesWithComplementBit tau sigma epsilon a b c ∧
        AgreesWithComplementBit tau sigma epsilon x y z) :
    ∃ epsilon, ∀ a b c, DistinctTriple a b c →
      AgreesWithComplementBit tau sigma epsilon a b c := by
  obtain ⟨epsilon, hbase, _hbaseAgain⟩ :=
    hpair r₀ r₁ r₂ r₀ r₁ r₂ hr hr
  refine ⟨epsilon, ?_⟩
  intro a b c habc
  obtain ⟨delta, hbase', habc'⟩ := hpair r₀ r₁ r₂ a b c hr habc
  have heq := complementBit_unique tau sigma r₀ r₁ r₂ epsilon delta
    hbase hbase'
  simpa [heq] using habc'

/-- The triangle bit of a Boolean signing. -/
def edgeTriangle {α : Type*} (g : α → α → Bool) (a b c : α) : Bool :=
  Bool.xor (g a b) (Bool.xor (g a c) (g b c))

/-- Equivalence of two Boolean signings by vertex switching and an optional
global sign reversal. -/
def SwitchingNegationEquivalent {α : Type*}
    (g h : α → α → Bool) : Prop :=
  ∃ (switch : α → Bool) (epsilon : Bool), ∀ i j,
    h i j = Bool.xor (g i j)
      (Bool.xor (switch i) (Bool.xor (switch j) epsilon))

/-- Boolean cancellation for the rooted-triangle reconstruction formula. -/
theorem edgeBit_eq_of_triangleXor_eq
    (hri hrj hij gri grj gij epsilon : Bool)
    (htriangle : Bool.xor hri (Bool.xor hrj hij) =
      Bool.xor (Bool.xor gri (Bool.xor grj gij)) epsilon) :
    hij = Bool.xor gij
      (Bool.xor (Bool.xor hri gri) (Bool.xor (Bool.xor hrj grj) epsilon)) := by
  cases hri <;> cases hrj <;> cases hij <;> cases gri <;> cases grj <;>
    cases gij <;> cases epsilon <;> simp_all

/-- Triangle bits determine every labelled signing up to vertex switching and
global negation.  A root supplies the switching function. -/
theorem signing_eq_up_to_switching_and_negation {α : Type*}
    (g h : α → α → Bool) (r : α) (epsilon : Bool)
    (htriangle : ∀ i j,
      edgeTriangle h r i j = Bool.xor (edgeTriangle g r i j) epsilon) :
    SwitchingNegationEquivalent g h := by
  refine ⟨fun i => Bool.xor (h r i) (g r i), epsilon, ?_⟩
  intro i j
  exact edgeBit_eq_of_triangleXor_eq
    (h r i) (h r j) (h i j) (g r i) (g r j) (g i j) epsilon
    (htriangle i j)

/-- The zero-diagonal symmetric four-by-four matrix with its six upper-edge
entries listed in lexicographic order. -/
def fourSigningMatrix {R : Type*} [CommRing R] (a b c d e f : R) :
    Matrix (Fin 4) (Fin 4) R :=
  ![![0, a, b, c],
    ![a, 0, d, e],
    ![b, d, 0, f],
    ![c, e, f, 0]]

/-- The sum of the three signed Hamilton-cycle products on four vertices. -/
def fourCycleSum {R : Type*} [CommRing R] (a b c d e f : R) : R :=
  a * b * e * f + a * c * d * f + b * c * d * e

/-- For six involutive edge signs, the principal four-by-four determinant is
`3 - 2*w`, where `w` is the sum of the three Hamilton-cycle products. -/
theorem det_fourSigningMatrix_eq_three_sub_two_cycleSum
    {R : Type*} [CommRing R] (a b c d e f : R)
    (ha : a ^ 2 = 1) (hb : b ^ 2 = 1) (hc : c ^ 2 = 1)
    (hd : d ^ 2 = 1) (he : e ^ 2 = 1) (hf : f ^ 2 = 1) :
    Matrix.det (fourSigningMatrix a b c d e f) =
      3 - 2 * fourCycleSum a b c d e f := by
  calc
    Matrix.det (fourSigningMatrix a b c d e f) =
      a ^ 2 * f ^ 2 + b ^ 2 * e ^ 2 + c ^ 2 * d ^ 2 -
        2 * fourCycleSum a b c d e f := by
          rw [Matrix.det_succ_row_zero]
          simp [fourSigningMatrix, fourCycleSum, Matrix.det_fin_three,
            Fin.sum_univ_succ, Fin.succAbove]
          ring
    _ = 3 - 2 * fourCycleSum a b c d e f := by rw [ha, hb, hc, hd, he, hf]; ring

/-- The algebraic simplification of the selected-query polynomial.  The three
terms are the proposed contributions from tests meeting a fixed four-point
anchor in four, three, and two points.  This identity does not define the
query family or prove that those proposed tests are distinct. -/
theorem selectedQueryCount_eq (n : ℤ) :
    1 + 4 * (n - 4) + 3 * (n - 4) * (n - 5) =
      3 * n ^ 2 - 23 * n + 45 := by
  ring

/-- A six-element set has twenty unordered triples.  This identity counts the
four-sets formed by a root and a triple of six further points; existence of an
aligned one among them is `exists_alignedAnchor`.  No declaration in this
module formalizes a search procedure or bounds its cost. -/
theorem sixPointAnchor_testCount : Nat.choose 6 3 = 20 := by
  decide

end AlignedTwoGraph
end RelativeConicArcs
