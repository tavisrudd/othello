import RelativeConicArcs.PRSFoundation

/-!
# Redundancy-five projective Reed--Solomon cubic pencils

The characteristic-free `2 × 4` Hankel matrix attached to a five-coordinate syndrome is developed
alongside homogeneous split squarefree binary cubics, the tangent,
conjugate-secant, osculating-pair, characteristic-three nucleus, and wild-family
count synthesis, and the finite-certificate boundary.

Lean checks the displayed algebra and derives the numerical formulas from stated cardinality and
orbit-count hypotheses.  Four further inputs remain visible:

* Seroussi and Roth, *On MDS Extensions of Generalized Reed--Solomon Codes*,
  IEEE Transactions on Information Theory 32 (1986), 349--354,
  DOI `10.1109/TIT.1986.1057188`, Theorem 1 and Corollary 2 on pp. 350--351;
* Aubry and Perret, *Coverings of Singular Curves over Finite Fields*,
  Manuscripta Mathematica 88 (1995), 467--478,
  DOI `10.1007/BF02567835`, Theorem 4 on pp. 474--475;
* the geometric classification of the separable cubic-cover strata.  A five-coordinate
  syndrome annihilates a pencil of binary cubics, that is a line of `PG(3, q)` relative to
  the twisted cubic, and a completely split squarefree cubic is a plane meeting that curve
  in three distinct rational points; so this input is the determination of which lines lie
  in such a plane.  For every characteristic and every `q ≥ 23` that determination is
  Blokhuis, Pellikaan, and Szőnyi, *The Extended Coset Leader Weight Enumerator of a Twisted
  Cubic Code*, Designs, Codes and Cryptography 90 (2022), 2223--2247,
  DOI `10.1007/s10623-022-01060-0`, Theorem 7.1 for the partition of lines and
  Proposition 7.4 for the verdict on each class, with the genus-one double-point-scheme
  bound behind the `q ≥ 23` threshold in their Remark 6.12.  For the generic class in
  characteristic other than two and three, the exact number of split squarefree members of
  the pencil is Kaipa and Pradhan, *Incidence of Lines, Points and Planes in `PG(3, q)` with
  Respect to the Twisted Cubic*, arXiv:2509.15332 (2025), Theorem 1.3.  Neither work treats
  projective Reed--Solomon syndromes, covering radius, or deep holes.  The threshold this
  module requires of that input is `q ≥ 20` rather than `q ≥ 23`: `ExactSplitWitnessCount`
  records the count relation and the tame Riemann--Hurwitz branch budget as hypotheses,
  `ExactSplitWitnessCount.fibreSquarePoints_le_twelve` bounds a split-free fibre square by
  twelve, and `fieldOrder_le_nineteen_of_splitFree` derives the field bound from that and
  the Aubry--Perret range.  In characteristic two the branch budget sharpens to
  `d₂ + d₃ ≤ 2`, since ramification is wild there; a split-free fibre square then has at
  most six rational points and
  `splitMembers_pos_of_characteristicTwoBranchBudget` rules out a split-free pencil over
  every binary field of order at least sixteen, so the classification needs the finite
  certificate only at the field orders listed in `requiredBridgeFieldOrders`;
* semantic validation of the public finite certificate.

No external result or finite-field computation is declared as an axiom.  The synthesis
theorem consumes these inputs as hypotheses and keeps split-free syndrome
classification separate from coding-theoretic covering-radius promotion.
-/

namespace RelativeConicArcs.PRSRedundancyFive

/-- Five divided-power coordinates of a redundancy-five syndrome. -/
structure Syndrome (R : Type*) where
  a0 : R
  a1 : R
  a2 : R
  a3 : R
  a4 : R
  deriving DecidableEq

/-- Ordinary symmetric-power coefficients of a binary cubic
`c₃ T³ + c₂ T²U + c₁ TU² + c₀ U³`. -/
structure Cubic (R : Type*) where
  c0 : R
  c1 : R
  c2 : R
  c3 : R

/-- A homogeneous linear factor `uT + vU`. -/
structure LinearFactor (R : Type*) where
  u : R
  v : R

/-- Product of three homogeneous linear factors, in ordinary binary-cubic
coordinates. -/
def cubicProduct {R : Type*} [CommRing R]
    (x y z : LinearFactor R) : Cubic R where
  c0 := x.v * y.v * z.v
  c1 := x.u * y.v * z.v + x.v * y.u * z.v + x.v * y.v * z.u
  c2 := x.u * y.u * z.v + x.u * y.v * z.u + x.v * y.u * z.u
  c3 := x.u * y.u * z.u

/-- Projective determinant of two homogeneous linear factors. -/
def factorDet {R : Type*} [CommRing R] (x y : LinearFactor R) : R :=
  x.u * y.v - x.v * y.u

/-- A binary cubic is completely split and squarefree when it is a product of
three pairwise projectively distinct homogeneous linear factors. -/
def IsSplitSquarefree {K : Type*} [Field K] (c : Cubic K) : Prop :=
  ∃ x y z, factorDet x y ≠ 0 ∧ factorDet x z ≠ 0 ∧
    factorDet y z ≠ 0 ∧ cubicProduct x y z = c

/-- Membership in the kernel of the characteristic-free `2 × 4` Hankel matrix
with rows `(a₀,a₁,a₂,a₃)` and `(a₁,a₂,a₃,a₄)`. -/
def inHankelKernel {R : Type*} [CommRing R]
    (a : Syndrome R) (c : Cubic R) : Prop :=
  a.a0 * c.c0 + a.a1 * c.c1 + a.a2 * c.c2 + a.a3 * c.c3 = 0 ∧
  a.a1 * c.c0 + a.a2 * c.c1 + a.a3 * c.c2 + a.a4 * c.c3 = 0

/-- Split-freeness detected by the concrete Hankel pencil. -/
def IsSplitFree {K : Type*} [Field K] (a : Syndrome K) : Prop :=
  ¬ PRSFoundation.HasSplitSquarefreeKernelMember inHankelKernel
    IsSplitSquarefree a

/-- The concrete redundancy-five Hankel dictionary. -/
def hankelKernelDictionary (K : Type*) [Field K] :
    PRSFoundation.HankelKernelDictionary (Syndrome K) (Cubic K) where
  inHankelKernel := inHankelKernel
  isSplitSquarefree := IsSplitSquarefree
  isSplitFree := IsSplitFree
  splitFree_iff_no_kernel_member := fun _ => Iff.rfl

/-- The affine quartic normal-rational-curve column `(1,t,t²,t³,t⁴)`. -/
def normalRationalCurve {R : Type*} [CommRing R] (t : R) : Syndrome R :=
  ⟨1, t, t ^ 2, t ^ 3, t ^ 4⟩

/-- The normal-rational-curve point at infinity. -/
def normalRationalCurveInfinity {R : Type*} [CommRing R] : Syndrome R :=
  ⟨0, 0, 0, 0, 1⟩

/-- Linear combination of three syndrome vectors. -/
def syndromeLinearCombination {R : Type*} [CommRing R]
    (α β γ : R) (a b c : Syndrome R) : Syndrome R :=
  ⟨α * a.a0 + β * b.a0 + γ * c.a0,
   α * a.a1 + β * b.a1 + γ * c.a1,
   α * a.a2 + β * b.a2 + γ * c.a2,
   α * a.a3 + β * b.a3 + γ * c.a3,
   α * a.a4 + β * b.a4 + γ * c.a4⟩

/-- Scalar multiplication of a syndrome representative. -/
def scaleSyndrome {R : Type*} [CommRing R]
    (u : R) (a : Syndrome R) : Syndrome R :=
  ⟨u * a.a0, u * a.a1, u * a.a2, u * a.a3, u * a.a4⟩

/-- The affine factor `T - tU`. -/
def affineRootFactor {R : Type*} [CommRing R] (t : R) : LinearFactor R :=
  ⟨1, -t⟩

/-- The factor `U`, representing the root at infinity. -/
def infinityRootFactor {R : Type*} [CommRing R] : LinearFactor R :=
  ⟨0, 1⟩

/-- Every linear combination of three affine quartic normal-rational-curve
points is annihilated by the cubic having those three roots.  The identity is
valid over every commutative ring and hence in every characteristic. -/
theorem affine_span_product_mem_hankelKernel {R : Type*} [CommRing R]
    (x y z α β γ : R) :
    inHankelKernel
      (syndromeLinearCombination α β γ
        (normalRationalCurve x) (normalRationalCurve y)
        (normalRationalCurve z))
      (cubicProduct (affineRootFactor x) (affineRootFactor y)
        (affineRootFactor z)) := by
  constructor <;>
    simp only [syndromeLinearCombination, normalRationalCurve,
      cubicProduct, affineRootFactor] <;>
    ring

/-- The same Hankel identity when one of the three roots is the projective
point at infinity. -/
theorem affine_pair_infinity_span_product_mem_hankelKernel
    {R : Type*} [CommRing R] (x y α β γ : R) :
    inHankelKernel
      (syndromeLinearCombination α β γ
        (normalRationalCurve x) (normalRationalCurve y)
        normalRationalCurveInfinity)
      (cubicProduct (affineRootFactor x) (affineRootFactor y)
        infinityRootFactor) := by
  constructor <;>
    simp only [syndromeLinearCombination, normalRationalCurve,
      normalRationalCurveInfinity, cubicProduct, affineRootFactor,
      infinityRootFactor] <;>
    ring

/-- Nonzero scaling of a syndrome representative preserves every member of
its Hankel kernel. -/
theorem inHankelKernel_scale_iff {K : Type*} [Field K]
    (u : K) (hu : u ≠ 0) (a : Syndrome K) (c : Cubic K) :
    inHankelKernel (scaleSyndrome u a) c ↔ inHankelKernel a c := by
  constructor
  · rintro ⟨h0, h1⟩
    constructor
    · have hscaled :
          u * (a.a0 * c.c0 + a.a1 * c.c1 + a.a2 * c.c2 + a.a3 * c.c3) = 0 := by
          calc
            u * (a.a0 * c.c0 + a.a1 * c.c1 + a.a2 * c.c2 + a.a3 * c.c3) =
                (u * a.a0) * c.c0 + (u * a.a1) * c.c1 +
                  (u * a.a2) * c.c2 + (u * a.a3) * c.c3 := by ring
            _ = 0 := h0
      exact (mul_eq_zero.mp hscaled).resolve_left hu
    · have hscaled :
          u * (a.a1 * c.c0 + a.a2 * c.c1 + a.a3 * c.c2 + a.a4 * c.c3) = 0 := by
          calc
            u * (a.a1 * c.c0 + a.a2 * c.c1 + a.a3 * c.c2 + a.a4 * c.c3) =
                (u * a.a1) * c.c0 + (u * a.a2) * c.c1 +
                  (u * a.a3) * c.c2 + (u * a.a4) * c.c3 := by ring
            _ = 0 := h1
      exact (mul_eq_zero.mp hscaled).resolve_left hu
  · rintro ⟨h0, h1⟩
    constructor
    · calc
        (scaleSyndrome u a).a0 * c.c0 + (scaleSyndrome u a).a1 * c.c1 +
              (scaleSyndrome u a).a2 * c.c2 + (scaleSyndrome u a).a3 * c.c3 =
            u * (a.a0 * c.c0 + a.a1 * c.c1 + a.a2 * c.c2 + a.a3 * c.c3) := by
              simp only [scaleSyndrome]
              ring
        _ = 0 := by rw [h0, mul_zero]
    · calc
        (scaleSyndrome u a).a1 * c.c0 + (scaleSyndrome u a).a2 * c.c1 +
              (scaleSyndrome u a).a3 * c.c2 + (scaleSyndrome u a).a4 * c.c3 =
            u * (a.a1 * c.c0 + a.a2 * c.c1 + a.a3 * c.c2 + a.a4 * c.c3) := by
              simp only [scaleSyndrome]
              ring
        _ = 0 := by rw [h1, mul_zero]

/-- Split-freeness is invariant under nonzero scaling of a syndrome representative. -/
theorem isSplitFree_scale_iff {K : Type*} [Field K]
    (u : K) (hu : u ≠ 0) (a : Syndrome K) :
    IsSplitFree (scaleSyndrome u a) ↔ IsSplitFree a := by
  unfold IsSplitFree PRSFoundation.HasSplitSquarefreeKernelMember
  constructor
  · intro hfree ⟨c, hkernel, hsplit⟩
    exact hfree ⟨c, (inHankelKernel_scale_iff u hu a c).2 hkernel, hsplit⟩
  · intro hfree ⟨c, hkernel, hsplit⟩
    exact hfree ⟨c, (inHankelKernel_scale_iff u hu a c).1 hkernel, hsplit⟩

/-- Converse span criterion identifying the Hankel predicate with three-column span incidence.
The forward polynomial identities are the two preceding theorems. -/
structure HankelSpanCriterionInput (K : Type*) [Field K] where
  liesInThreeColumnSpan : Syndrome K → Prop
  span_iff_hasSplitSquarefreeKernelMember :
    ∀ a, liesInThreeColumnSpan a ↔
      PRSFoundation.HasSplitSquarefreeKernelMember inHankelKernel
        IsSplitSquarefree a

/-- Under the converse span input, the concrete Hankel predicate says exactly
that the syndrome lies on no span of three distinct normal-rational-curve
columns. -/
theorem isSplitFree_iff_not_liesInThreeColumnSpan
    {K : Type*} [Field K] (input : HankelSpanCriterionInput K)
    (a : Syndrome K) :
    IsSplitFree a ↔ ¬ input.liesInThreeColumnSpan a := by
  change
    (¬ PRSFoundation.HasSplitSquarefreeKernelMember inHankelKernel
      IsSplitSquarefree a) ↔ ¬ input.liesInThreeColumnSpan a
  exact (not_congr (input.span_iff_hasSplitSquarefreeKernelMember a)).symm

/-- The three arithmetic shapes of the additional cyclic-cover family. -/
inductive CyclicFamilyCase
  | osculatingConjugate
  | osculatingRational
  | characteristicThree
  deriving DecidableEq

/-- Exact characteristic and congruence condition selecting the deep cyclic-cover
family. -/
def CyclicFamilyCase.FieldCondition
    (c : CyclicFamilyCase) (characteristic q : ℕ) : Prop :=
  match c with
  | .osculatingConjugate => characteristic ≠ 3 ∧ q % 3 = 1
  | .osculatingRational => characteristic ≠ 3 ∧ q % 3 = 2
  | .characteristicThree => characteristic = 3

/-- Twice the size of the additional cyclic-cover family. -/
def cyclicFamilyCardDoubled (c : CyclicFamilyCase) (q : ℕ) : ℕ :=
  match c with
  | .osculatingConjugate => q * (q - 1)
  | .osculatingRational => q * (q + 1)
  | .characteristicThree => q ^ 2 + 1

/-- Twice the closed-form nonsporadic deep syndrome count. -/
def nonsporadicDeepCardDoubled (c : CyclicFamilyCase) (q : ℕ) : ℕ :=
  match c with
  | .osculatingConjugate => q ^ 2 * (q + 3)
  | .osculatingRational => q * (q + 1) * (q + 2)
  | .characteristicThree => q ^ 3 + 3 * q ^ 2 + q + 1

/-- Concrete tangent, conjugate-secant, arithmetic cyclic-cover, sporadic, and
deep-family data.  The cyclic set means the conjugate osculating-pair family,
the rational osculating-pair family, or the disjoint union of the fixed nucleus
and wild Artin--Schreier family according to `cyclicCase`. -/
structure FamilyData (S : Type*) (q : ℕ) [DecidableEq S] where
  tangent : Finset S
  sigma : Finset S
  osculatingConjugate : Finset S
  osculatingRational : Finset S
  nucleus : Finset S
  wildArtinSchreier : Finset S
  cyclic : Finset S
  sporadic : Finset S
  deep : Finset S
  tangentSigmaDisjoint : Disjoint tangent sigma
  tangentSigmaCyclicDisjoint : Disjoint (tangent ∪ sigma) cyclic
  nonsporadicSporadicDisjoint :
    Disjoint ((tangent ∪ sigma) ∪ cyclic) sporadic
  deep_eq : deep = ((tangent ∪ sigma) ∪ cyclic) ∪ sporadic
  fieldOrderPositive : 0 < q
  characteristic : ℕ
  characteristicPositive : 0 < characteristic
  tangent_card : tangent.card = q * (q + 1)
  sigma_card_doubled : 2 * sigma.card = q * (q ^ 2 - 1)
  cyclicCase : CyclicFamilyCase
  cyclic_eq :
    cyclic = match cyclicCase with
      | .osculatingConjugate => osculatingConjugate
      | .osculatingRational => osculatingRational
      | .characteristicThree => nucleus ∪ wildArtinSchreier
  nucleusWildDisjoint : Disjoint nucleus wildArtinSchreier
  osculatingConjugate_card_doubled :
    2 * osculatingConjugate.card = q * (q - 1)
  osculatingRational_card_doubled :
    2 * osculatingRational.card = q * (q + 1)
  nucleus_card : nucleus.card = 1
  wildArtinSchreier_card_doubled :
    2 * wildArtinSchreier.card = q ^ 2 - 1
  cyclicCaseCondition : cyclicCase.FieldCondition characteristic q

namespace FamilyData

/-- The individual osculating-pair or nucleus/wild formulas give the selected
cyclic-family cardinality. -/
theorem cyclic_card_doubled {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q) :
    2 * data.cyclic.card =
      cyclicFamilyCardDoubled data.cyclicCase q := by
  cases hcase : data.cyclicCase with
  | osculatingConjugate =>
      rw [data.cyclic_eq, hcase]
      exact data.osculatingConjugate_card_doubled
  | osculatingRational =>
      rw [data.cyclic_eq, hcase]
      exact data.osculatingRational_card_doubled
  | characteristicThree =>
      rw [data.cyclic_eq, hcase,
        Finset.card_union_of_disjoint data.nucleusWildDisjoint]
      obtain ⟨k, hk⟩ :=
        Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt data.fieldOrderPositive)
      subst q
      have hexpand : (k + 1) ^ 2 = k ^ 2 + 2 * k + 1 := by ring
      have hsquare : (k + 1) ^ 2 - 1 = k ^ 2 + 2 * k := by
        omega
      rw [cyclicFamilyCardDoubled, data.nucleus_card]
      calc
        2 * (1 + data.wildArtinSchreier.card) =
            2 + 2 * data.wildArtinSchreier.card := by omega
        _ = 2 + ((k + 1) ^ 2 - 1) := by
          rw [data.wildArtinSchreier_card_doubled]
        _ = (k + 1) ^ 2 + 1 := by
          rw [hsquare, hexpand]
          omega

/-- The three family formulas simplify to the stated all-field closed forms. -/
theorem family_arithmetic {q : ℕ} (hq : 0 < q) (c : CyclicFamilyCase) :
    2 * (q * (q + 1)) + q * (q ^ 2 - 1) +
        cyclicFamilyCardDoubled c q =
      nonsporadicDeepCardDoubled c q := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt hq)
  have hsquare : (k + 1) ^ 2 - 1 = k ^ 2 + 2 * k := by
    have hexpand : (k + 1) ^ 2 = k ^ 2 + 2 * k + 1 := by ring
    omega
  rw [hsquare]
  cases c <;> simp [cyclicFamilyCardDoubled, nonsporadicDeepCardDoubled] <;> ring

/-- Twice the deep syndrome cardinality is the appropriate closed form
plus twice the certified sporadic contribution. -/
theorem deep_card_doubled {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q) :
    2 * data.deep.card =
      nonsporadicDeepCardDoubled data.cyclicCase q +
        2 * data.sporadic.card := by
  rw [data.deep_eq,
    Finset.card_union_of_disjoint data.nonsporadicSporadicDisjoint,
    Finset.card_union_of_disjoint data.tangentSigmaCyclicDisjoint,
    Finset.card_union_of_disjoint data.tangentSigmaDisjoint]
  calc
    2 * (((data.tangent.card + data.sigma.card) + data.cyclic.card) +
        data.sporadic.card) =
      2 * data.tangent.card + 2 * data.sigma.card +
        2 * data.cyclic.card + 2 * data.sporadic.card := by omega
    _ = 2 * (q * (q + 1)) + q * (q ^ 2 - 1) +
        cyclicFamilyCardDoubled data.cyclicCase q +
        2 * data.sporadic.card := by
      rw [data.tangent_card, data.sigma_card_doubled,
        data.cyclic_card_doubled]
    _ = nonsporadicDeepCardDoubled data.cyclicCase q +
        2 * data.sporadic.card := by
      rw [family_arithmetic data.fieldOrderPositive data.cyclicCase]

/-- In the absence of a sporadic contribution, the exact count is one half of
the appropriate closed numerator. -/
theorem deep_card_of_sporadic_empty {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q) (hsporadic : data.sporadic = ∅) :
    data.deep.card = nonsporadicDeepCardDoubled data.cyclicCase q / 2 := by
  have hdoubled := data.deep_card_doubled
  rw [hsporadic, Finset.card_empty, Nat.mul_zero, Nat.add_zero] at hdoubled
  apply Nat.eq_div_of_mul_eq_right (by decide : (2 : ℕ) ≠ 0)
  simpa [Nat.mul_comm] using hdoubled

/-- Exact total when the deep cyclic family is the conjugate osculating-pair
family, equivalently the non-three characteristic case `q ≡ 1 (mod 3)`. -/
theorem deep_card_osculatingConjugate {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q)
    (hcase : data.cyclicCase = .osculatingConjugate)
    (hsporadic : data.sporadic = ∅) :
    data.deep.card = q ^ 2 * (q + 3) / 2 := by
  rw [data.deep_card_of_sporadic_empty hsporadic, hcase]
  rfl

/-- Exact total when the deep cyclic family is the rational
osculating-pair family, equivalently the non-three characteristic case
`q ≡ 2 (mod 3)`. -/
theorem deep_card_osculatingRational {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q)
    (hcase : data.cyclicCase = .osculatingRational)
    (hsporadic : data.sporadic = ∅) :
    data.deep.card = q * (q + 1) * (q + 2) / 2 := by
  rw [data.deep_card_of_sporadic_empty hsporadic, hcase]
  rfl

/-- Exact total in characteristic three, where the cyclic family is the
disjoint union of the fixed nucleus and wild Artin--Schreier orbit. -/
theorem deep_card_characteristicThree {S : Type*} {q : ℕ} [DecidableEq S]
    (data : FamilyData S q)
    (hcase : data.cyclicCase = .characteristicThree)
    (hsporadic : data.sporadic = ∅) :
    data.deep.card = (q ^ 3 + 3 * q ^ 2 + q + 1) / 2 := by
  rw [data.deep_card_of_sporadic_empty hsporadic, hcase]
  rfl

end FamilyData

/-- Arithmetic cases controlling the number of nonsporadic
`PGL₂` and `PΓL₂` orbits. -/
inductive OrbitArithmeticCase
  | evenCharacteristic
  | oddNonthreeModFourOne
  | oddNonthreeModFourThree
  | characteristicThreeModFourOne
  | characteristicThreeModFourThree
  deriving DecidableEq

/-- Exact characteristic and congruence condition selecting the nonsporadic
orbit-count row. -/
def OrbitArithmeticCase.FieldCondition
    (c : OrbitArithmeticCase) (characteristic q : ℕ) : Prop :=
  match c with
  | .evenCharacteristic => characteristic = 2
  | .oddNonthreeModFourOne =>
      characteristic ≠ 2 ∧ characteristic ≠ 3 ∧ q % 4 = 1
  | .oddNonthreeModFourThree =>
      characteristic ≠ 2 ∧ characteristic ≠ 3 ∧ q % 4 = 3
  | .characteristicThreeModFourOne =>
      characteristic = 3 ∧ q % 4 = 1
  | .characteristicThreeModFourThree =>
      characteristic = 3 ∧ q % 4 = 3

/-- Number of nonsporadic projective-linear orbits.  Frobenius preserves
these individual orbits, so this is also the nonsporadic semilinear count. -/
def nonsporadicOrbitCount : OrbitArithmeticCase → ℕ
  | .evenCharacteristic => 4
  | .oddNonthreeModFourOne => 4
  | .oddNonthreeModFourThree => 5
  | .characteristicThreeModFourOne => 5
  | .characteristicThreeModFourThree => 6

/-- Numerical projective and projective-semilinear orbit-count hypotheses.
Their group-action justification lies outside this structure. -/
structure OrbitData (case : OrbitArithmeticCase) where
  sporadicProjectiveOrbitCount : ℕ
  sporadicSemilinearOrbitCount : ℕ
  projectiveOrbitCount : ℕ
  semilinearOrbitCount : ℕ
  projectiveOrbitCount_eq :
    projectiveOrbitCount =
      nonsporadicOrbitCount case + sporadicProjectiveOrbitCount
  semilinearOrbitCount_eq :
    semilinearOrbitCount =
      nonsporadicOrbitCount case + sporadicSemilinearOrbitCount

/-- The exact split-witness count on the trivial-gcd separable stratum in odd
characteristic, as an arithmetic relation between the rational-point count of the
off-diagonal fibre square and the member types of the pencil.

`fibreSquarePoints` is the number of rational points of the fibre square, `splitMembers`
the number of completely split squarefree members of the pencil, `doubleRootMembers` the
number of members with a rational double root and a distinct rational simple root, and
`cubeMembers` the number of members that are perfect cubes of a rational linear form.
The count relation is proved by summing the rational roots of the residual quadratic over
the points of the projective line, one pencil member at a time; the branch budget is the
tame Riemann--Hurwitz bound for a different of degree four. -/
structure ExactSplitWitnessCount where
  fibreSquarePoints : ℕ
  splitMembers : ℕ
  doubleRootMembers : ℕ
  cubeMembers : ℕ
  countRelation :
    fibreSquarePoints = 6 * splitMembers + 3 * doubleRootMembers + cubeMembers
  branchBudget : doubleRootMembers + 2 * cubeMembers ≤ 4

/-- A split-free pencil has at most twelve rational points on its fibre square. -/
theorem ExactSplitWitnessCount.fibreSquarePoints_le_twelve
    (c : ExactSplitWitnessCount) (hsplit : c.splitMembers = 0) :
    c.fibreSquarePoints ≤ 12 := by
  have hb := c.branchBudget
  have hrel := c.countRelation
  omega

/-- The contribution `3 d₂ + d₃` of the non-split members to the fibre-square point count
is at most twelve.  This is the tame branch budget rewritten in the weights with which the
two member types enter the count relation. -/
theorem ExactSplitWitnessCount.nonSplitWeight_le_twelve (c : ExactSplitWitnessCount) :
    3 * c.doubleRootMembers + c.cubeMembers ≤ 12 := by
  have hb := c.branchBudget
  omega

/-- The sharper branch budget available when ramification is wild, that is in
characteristic two, is `d₂ + d₃ ≤ 2`; it bounds the non-split contribution by six.  The
hypothesis is supplied rather than derived, since this structure records no field. -/
theorem ExactSplitWitnessCount.nonSplitWeight_le_six_of_characteristicTwoBranchBudget
    (c : ExactSplitWitnessCount)
    (hwild : c.doubleRootMembers + c.cubeMembers ≤ 2) :
    3 * c.doubleRootMembers + c.cubeMembers ≤ 6 := by
  omega

/-- A split-free pencil satisfying the characteristic-two branch budget has at most six
rational points on its fibre square. -/
theorem ExactSplitWitnessCount.fibreSquarePoints_le_six_of_characteristicTwoBranchBudget
    (c : ExactSplitWitnessCount)
    (hwild : c.doubleRootMembers + c.cubeMembers ≤ 2)
    (hsplit : c.splitMembers = 0) :
    c.fibreSquarePoints ≤ 6 := by
  have hrel := c.countRelation
  omega

/-- Two-sided bound on the number of completely split squarefree members of the pencil.
The hypotheses are the exact count relation, an upper bound `B` on the non-split weight
`3 d₂ + d₃`, and a two-sided bound on the rational points of the fibre square of
Aubry--Perret shape, `|#Y - (q + 1)| ≤ 2 √q`, which holds when the fibre square is
geometrically integral of arithmetic genus one.  Instantiating `B` by
`nonSplitWeight_le_twelve` gives the bound valid in every characteristic, and by
`nonSplitWeight_le_six_of_characteristicTwoBranchBudget` the sharper characteristic-two
form.  The main term `(q + 1) / 6` is the expected density of the completely split
Frobenius class for geometric monodromy `S₃`; the field order `q` enters only through the
supplied point bound. -/
theorem ExactSplitWitnessCount.splitMembers_bounds
    (c : ExactSplitWitnessCount) {q B : ℕ}
    (hweight : 3 * c.doubleRootMembers + c.cubeMembers ≤ B)
    (hlower : (q : ℝ) + 1 - 2 * Real.sqrt q ≤ c.fibreSquarePoints)
    (hupper : (c.fibreSquarePoints : ℝ) ≤ (q : ℝ) + 1 + 2 * Real.sqrt q) :
    ((q : ℝ) + 1 - 2 * Real.sqrt q - B) / 6 ≤ c.splitMembers ∧
      (c.splitMembers : ℝ) ≤ ((q : ℝ) + 1 + 2 * Real.sqrt q) / 6 := by
  have hrel : (c.fibreSquarePoints : ℝ) =
      6 * (c.splitMembers : ℝ) + 3 * (c.doubleRootMembers : ℝ) +
        (c.cubeMembers : ℝ) := by
    exact_mod_cast c.countRelation
  have hweightR : 3 * (c.doubleRootMembers : ℝ) + (c.cubeMembers : ℝ) ≤ (B : ℝ) := by
    exact_mod_cast hweight
  have hnonneg : (0 : ℝ) ≤ 3 * (c.doubleRootMembers : ℝ) + (c.cubeMembers : ℝ) := by
    positivity
  exact ⟨by linarith, by linarith⟩

/-- Forced fibre-square invariants just below the geometric threshold.  For
`17 ≤ q ≤ 19` a split-free pencil whose fibre square meets the Aubry--Perret range,
written in the squared integer form `(q + 1 - Y) ^ 2 ≤ 4 * q` with `Y ≤ q + 1`, has
exactly twelve rational points on its fibre square, four members with a rational double
root, and no member that is a perfect cube.  The manuscript states the range for odd `q`,
which is where prime powers occur; the arithmetic needs only `17 ≤ q ≤ 19`. -/
theorem ExactSplitWitnessCount.fibreSquareInvariants_of_splitFree
    (c : ExactSplitWitnessCount) {q : ℕ}
    (hsplit : c.splitMembers = 0)
    (hlow : 17 ≤ q) (hhigh : q ≤ 19)
    (hle : c.fibreSquarePoints ≤ q + 1)
    (hbound : (q + 1 - c.fibreSquarePoints) ^ 2 ≤ 4 * q) :
    c.fibreSquarePoints = 12 ∧ c.doubleRootMembers = 4 ∧ c.cubeMembers = 0 := by
  have hrel := c.countRelation
  have hb := c.branchBudget
  have hten : 10 ≤ c.fibreSquarePoints := by
    by_contra hlt
    have h9 : 9 ≤ q + 1 - c.fibreSquarePoints := by omega
    have hsq : 81 ≤ (q + 1 - c.fibreSquarePoints) ^ 2 := by
      calc (81 : ℕ) = 9 ^ 2 := by norm_num
        _ ≤ (q + 1 - c.fibreSquarePoints) ^ 2 := Nat.pow_le_pow_left h9 2
    omega
  omega

/-- The redundancy-five field threshold, derived rather than assumed.  If a geometrically
integral fibre square of arithmetic genus one meets the Aubry--Perret range, written here
in the squared integer form `(q + 1 - Y) ^ 2 ≤ 4 * q` with `Y ≤ q + 1`, and if the pencil
is split-free so that `Y ≤ 12`, then the field order is at most nineteen. -/
theorem fieldOrder_le_nineteen_of_splitFree
    {q Y : ℕ} (hle : Y ≤ q + 1) (hbound : (q + 1 - Y) ^ 2 ≤ 4 * q)
    (htwelve : Y ≤ 12) : q ≤ 19 := by
  by_contra hq
  have h20 : 20 ≤ q := Nat.lt_of_not_le hq
  have hd : q - 11 ≤ q + 1 - Y := by omega
  have hsq : (q - 11) ^ 2 ≤ (q + 1 - Y) ^ 2 := Nat.pow_le_pow_left hd 2
  have hgt : 4 * q < (q - 11) ^ 2 := by
    have h : q - 11 + 11 = q := by omega
    nlinarith [h, h20, Nat.sub_le q 11]
  omega

/-- The field bound available in characteristic two, where a split-free fibre square has
at most six rational points.  If such a fibre square meets the Aubry--Perret range,
written in the squared integer form `(q + 1 - Y) ^ 2 ≤ 4 * q` with `Y ≤ q + 1`, then the
field order is at most twelve. -/
theorem fieldOrder_le_twelve_of_characteristicTwoSplitFree
    {q Y : ℕ} (hle : Y ≤ q + 1) (hbound : (q + 1 - Y) ^ 2 ≤ 4 * q)
    (hsix : Y ≤ 6) : q ≤ 12 := by
  by_contra hq
  have h13 : 13 ≤ q := Nat.lt_of_not_le hq
  have hd : q - 5 ≤ q + 1 - Y := by omega
  have hsq : (q - 5) ^ 2 ≤ (q + 1 - Y) ^ 2 := Nat.pow_le_pow_left hd 2
  have hgt : 4 * q < (q - 5) ^ 2 := by
    have h : q - 5 + 5 = q := by omega
    nlinarith [h, h13, Nat.sub_le q 5]
  omega

/-- No binary field of order at least sixteen carries a split-free pencil whose fibre
square is geometrically integral of arithmetic genus one.  The hypotheses are the
characteristic-two branch budget `d₂ + d₃ ≤ 2` and the Aubry--Perret range in its squared
integer form; the conclusion is that the pencil has a completely split squarefree member.
At `q = 16` the range already forces at least nine rational points on the fibre square,
against the six the budget allows. -/
theorem splitMembers_pos_of_characteristicTwoBranchBudget
    (c : ExactSplitWitnessCount) {q : ℕ}
    (hwild : c.doubleRootMembers + c.cubeMembers ≤ 2)
    (hq : 16 ≤ q)
    (hle : c.fibreSquarePoints ≤ q + 1)
    (hbound : (q + 1 - c.fibreSquarePoints) ^ 2 ≤ 4 * q) :
    0 < c.splitMembers := by
  by_contra hzero
  have hsplit : c.splitMembers = 0 := Nat.eq_zero_of_not_pos hzero
  have hsix :=
    c.fibreSquarePoints_le_six_of_characteristicTwoBranchBudget hwild hsplit
  have := fieldOrder_le_twelve_of_characteristicTwoSplitFree hle hbound hsix
  omega

/-- Field orders whose split-free classification is a logical dependency on the finite
certificate.  The binary field of order sixteen is absent because
`splitMembers_pos_of_characteristicTwoBranchBudget` closes it geometrically; the
certificate's own domain, which does include that field, is recorded separately as
`RelativeConicArcs.PRSRedundancyFiveCertificate.certifiedBridgeFieldOrders`. -/
def requiredBridgeFieldOrders : List ℕ :=
  [7, 8, 9, 11, 13, 17, 19]

/-- Field orders at which the split-free classification follows from the geometric
argument rather than from the finite certificate: every `q ≥ 20`, and in characteristic
two every `q ≥ 16`. -/
def GeometricClassificationRange (characteristic q : ℕ) : Prop :=
  q ≥ 20 ∨ (characteristic = 2 ∧ q ≥ 16)

/-- The binary field of order sixteen lies in the geometric range, so the finite
certificate's row there is an independent check rather than a logical dependency. -/
theorem geometricClassificationRange_two_sixteen :
    GeometricClassificationRange 2 16 :=
  Or.inr ⟨rfl, le_refl 16⟩

/-- External inputs for covering-radius promotion, high-field geometry, finite-certificate
validation, and agreement with the concrete split-free predicate. -/
structure ExceptionalCoverClassificationInput
    (K CertificateEvidence : Type*) (q : ℕ)
    [Field K] [Fintype K] [DecidableEq K] where
  coveringRadius : PRSFoundation.CoveringRadiusInput (Syndrome K)
  families : FamilyData (Syndrome K) q
  fieldOrder_eq_card : q = Fintype.card K
  fieldCharacteristic : CharP K families.characteristic
  orbitCase : OrbitArithmeticCase
  orbitCaseCondition : orbitCase.FieldCondition families.characteristic q
  fieldOrderAtLeastSeven : q ≥ 7
  classificationRange :
    GeometricClassificationRange families.characteristic q ∨
      q ∈ requiredBridgeFieldOrders
  seroussiRothCompleteness : Prop
  aubryPerretPointBound : Prop
  cubicCoverStrataClassified : Prop
  finiteCertificateValidation : CertificateEvidence
  seroussiRothGivesRadiusRange :
    q ≥ 7 → seroussiRothCompleteness → coveringRadius.radiusRange
  splitFreePredicatesAgree :
    ∀ s, coveringRadius.isSplitFree s ↔ IsSplitFree s
  geometricRange_splitFree_iff_mem_deepFamilies :
    GeometricClassificationRange families.characteristic q →
    aubryPerretPointBound →
    cubicCoverStrataClassified →
    ∀ s, IsSplitFree s ↔ s ∈ families.deep
  certified_splitFree_iff_mem_deepFamilies :
    q ∈ requiredBridgeFieldOrders →
    CertificateEvidence →
    ∀ s, IsSplitFree s ↔ s ∈ families.deep

/-- Complete redundancy-five synthesis.  It yields the coding-theoretic
classification, exact total count including the sporadic contribution, and the
projective/projective-semilinear orbit consequences, while retaining every
external mathematical input as a theorem hypothesis. -/
theorem redundancyFiveSynthesis
    {K CertificateEvidence : Type*} {q : ℕ}
    [Field K] [Fintype K] [DecidableEq K]
    (input : ExceptionalCoverClassificationInput K CertificateEvidence q)
    (orbits : OrbitData input.orbitCase)
    (hSeroussiRoth : input.seroussiRothCompleteness)
    (hGeometricRange :
      GeometricClassificationRange input.families.characteristic q →
      input.aubryPerretPointBound ∧ input.cubicCoverStrataClassified) :
    (∀ s, input.coveringRadius.isDeep s ↔ s ∈ input.families.deep) ∧
      2 * input.families.deep.card =
        nonsporadicDeepCardDoubled input.families.cyclicCase q +
          2 * input.families.sporadic.card ∧
      (orbits.projectiveOrbitCount, orbits.semilinearOrbitCount) =
        (nonsporadicOrbitCount input.orbitCase + orbits.sporadicProjectiveOrbitCount,
         nonsporadicOrbitCount input.orbitCase +
           orbits.sporadicSemilinearOrbitCount) := by
  have hradius := input.seroussiRothGivesRadiusRange
    input.fieldOrderAtLeastSeven hSeroussiRoth
  have hexhaustion : ∀ s, IsSplitFree s ↔ s ∈ input.families.deep := by
    rcases input.classificationRange with hq | hq
    · exact input.geometricRange_splitFree_iff_mem_deepFamilies hq
        (hGeometricRange hq).1 (hGeometricRange hq).2
    · exact input.certified_splitFree_iff_mem_deepFamilies hq
        input.finiteCertificateValidation
  refine ⟨?_, input.families.deep_card_doubled, ?_⟩
  · intro s
    exact (input.coveringRadius.deep_iff_splitFree hradius s).trans
      ((input.splitFreePredicatesAgree s).trans (hexhaustion s))
  · rw [orbits.projectiveOrbitCount_eq, orbits.semilinearOrbitCount_eq]

end RelativeConicArcs.PRSRedundancyFive
