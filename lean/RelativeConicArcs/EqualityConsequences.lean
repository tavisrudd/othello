import RelativeConicArcs.Affine
import RelativeConicArcs.MatchingDesignRigidity
import RelativeConicArcs.Nucleus

/-!
# Arithmetic and parity consequences of zero defect

This module records consequences of the prescribed-hole defect identity that require no finite
enumeration.  It proves the discrete defect gap, the factorization governing equality for a line
hole, the integer sieve used for odd arc size, and the tangent count forced by the exceptional
even-characteristic parameter pair.

The oval and hyperoval converses require an abstract API for the nucleus of an arbitrary oval.
The projective-coordinate development defines nucleus geometry only for the standard conic, so
this module proves the characteristic-two arithmetic reduction but not the arbitrary
oval--nucleus converse.
-/

namespace RelativeConicArcs

open Configuration Finset

section DefectGap

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- If the maximum secant index is at least three, a nonzero scaled defect is at least two less
than that maximum index. -/
theorem scaledDefect_eq_zero_or_half_sub_two_le {A H : Finset P}
    (hA : Arc (L := L) A) (hdisj : Disjoint A H) (hm : 3 ≤ A.card / 2) :
    scaledDefect (L := L) A H = 0 ∨
      (((A.card / 2 - 2 : ℕ) : ℤ) ≤ scaledDefect (L := L) A H) := by
  classical
  by_cases hzero : scaledDefect (L := L) A H = 0
  · exact Or.inl hzero
  · right
    have hnotpatterns :
        ¬ ((∀ x ∈ coveredRequired (L := L) A H,
              pointIndex (L := L) A x = 1 ∨
                pointIndex (L := L) A x = A.card / 2) ∧
            ∀ y ∈ H, pointIndex (L := L) A y = 0 ∨
              pointIndex (L := L) A y = A.card / 2) := by
      exact fun h => hzero ((scaledDefect_eq_zero_iff (L := L) hA hdisj).2 h)
    have hstability := stability_bound (L := L) hA hdisj
    rcases not_and_or.mp hnotpatterns with hrequired | hhole
    · push Not at hrequired
      obtain ⟨x, hx, hxneone, hxnehalf⟩ := hrequired
      have hrange : 2 ≤ pointIndex (L := L) A x ∧
          pointIndex (L := L) A x < A.card / 2 := by
        have hpos : 0 < pointIndex (L := L) A x :=
          (Finset.mem_filter.mp hx).2
        have hxparts := (Finset.mem_filter.mp hx).1
        have hxA : x ∉ A := fun hxA =>
          (Finset.mem_sdiff.mp hxparts).2 (Finset.mem_union_left H hxA)
        have hle := pointIndex_le_half_card (L := L) hA hxA
        omega
      have hxintermediate : x ∈ intermediateRequired (L := L) A H := by
        exact Finset.mem_filter.mpr ⟨hx, hrange⟩
      have hcard : 1 ≤ (intermediateRequired (L := L) A H).card :=
        Finset.one_le_card.mpr ⟨x, hxintermediate⟩
      have hnonneg : 0 ≤ (((A.card / 2 - 1 : ℕ) : ℤ) *
          (intermediateHoles (L := L) A H).card) := by positivity
      have hcoeff : 0 ≤ ((A.card / 2 - 2 : ℕ) : ℤ) := by positivity
      have hmul : ((A.card / 2 - 2 : ℕ) : ℤ) ≤
          ((A.card / 2 - 2 : ℕ) : ℤ) *
            (intermediateRequired (L := L) A H).card := by
        nth_rewrite 1 [← mul_one ((A.card / 2 - 2 : ℕ) : ℤ)]
        exact Int.mul_le_mul_of_nonneg_left (by exact_mod_cast hcard) hcoeff
      omega
    · push Not at hhole
      obtain ⟨y, hy, hynezero, hynehalf⟩ := hhole
      have hyA : y ∉ A := fun hyA =>
        (Finset.disjoint_left.mp hdisj) hyA hy
      have hle := pointIndex_le_half_card (L := L) hA hyA
      have hyrange : 0 < pointIndex (L := L) A y ∧
          pointIndex (L := L) A y < A.card / 2 := by
        omega
      have hyintermediate : y ∈ intermediateHoles (L := L) A H := by
        exact Finset.mem_filter.mpr ⟨hy, hyrange⟩
      have hcard : 1 ≤ (intermediateHoles (L := L) A H).card :=
        Finset.one_le_card.mpr ⟨y, hyintermediate⟩
      have hnonneg : 0 ≤ (((A.card / 2 - 2 : ℕ) : ℤ) *
          (intermediateRequired (L := L) A H).card) := by positivity
      have hcoeff : 0 ≤ ((A.card / 2 - 1 : ℕ) : ℤ) := by positivity
      have hmul : ((A.card / 2 - 1 : ℕ) : ℤ) ≤
          ((A.card / 2 - 1 : ℕ) : ℤ) *
            (intermediateHoles (L := L) A H).card := by
        nth_rewrite 1 [← mul_one ((A.card / 2 - 1 : ℕ) : ℤ)]
        exact Int.mul_le_mul_of_nonneg_left (by exact_mod_cast hcard) hcoeff
      omega

end DefectGap

section ArcCardinality

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

omit [DecidableEq L] in
/-- Every nonempty arc in a finite projective plane of order `q` has at most `q+2` points. -/
theorem arc_card_le_planeOrder_add_two {A : Finset P} (hA : Arc (L := L) A)
    (hnonempty : A.Nonempty) :
    A.card ≤ PlaneOrder P L + 2 := by
  classical
  obtain ⟨p, hp⟩ := hnonempty
  let f : {x // x ∈ A.erase p} → {l : L // p ∈ l} := fun x =>
    ⟨Configuration.HasLines.mkLine (by
      exact fun h => (Finset.mem_erase.mp x.2).1 h.symm),
      (Configuration.HasLines.mkLine_ax (P := P) (L := L) _).1⟩
  have hf : Function.Injective f := by
    intro x y hxy
    apply Subtype.ext
    by_contra hne
    have hline : Configuration.HasLines.mkLine
          (fun h => (Finset.mem_erase.mp x.2).1 h.symm) =
        Configuration.HasLines.mkLine
          (fun h => (Finset.mem_erase.mp y.2).1 h.symm) :=
      Subtype.ext_iff.mp hxy
    have hpx := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)).1
    have hxx := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)).2
    have hyy := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp y.2).1 h.symm)).2
    exact hA hp (Finset.mem_erase.mp x.2).2 (Finset.mem_erase.mp y.2).2
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)
      (fun h => (Finset.mem_erase.mp y.2).1 h.symm) hne
      ⟨_, hpx, hxx, hline ▸ hyy⟩
  have hle := Fintype.card_le_of_injective f hf
  rw [Fintype.card_coe, Finset.card_erase_of_mem hp,
    ← Nat.card_eq_fintype_card, ← Configuration.lineCount,
    Configuration.ProjectivePlane.lineCount_eq] at hle
  calc
    A.card = (A.card - 1) + 1 :=
      (Nat.sub_add_cancel (Finset.one_le_card.mpr ⟨p, hp⟩)).symm
    _ ≤ (PlaneOrder P L + 1) + 1 := Nat.add_le_add_right hle 1
    _ = PlaneOrder P L + 2 := by omega

end ArcCardinality

section Arithmetic

/-- Equality in the corrected affine capacity equation for an even size `k=2n` has the two
factorization roots from the line-hole specialization. -/
theorem even_affine_equality_roots_arithmetic {n q : ℕ} (hn : 3 ≤ n)
    (hq : 1 ≤ q) (hqk : 2 * n ≤ q ^ 2)
    (heq : n * (q ^ 2 - 2 * n) + Nat.choose (2 * n) 2 +
          6 * Nat.choose (2 * n) 4 =
        n * (Nat.choose (2 * n) 2 * (q - 1))) :
    q = 2 * n - 2 ∨ q = Nat.choose (2 * n - 1) 2 + 1 := by
  have hsubsq : q ^ 2 - 2 * n + 2 * n = q ^ 2 :=
    Nat.sub_add_cancel hqk
  have hsubq : q - 1 + 1 = q := Nat.sub_add_cancel hq
  have hchooseTwo := two_mul_choose_two (2 * n)
  have hchooseTwoPred := two_mul_choose_two (2 * n - 1)
  have hchooseFour := Conic.twentyFour_mul_choose_four (2 * n)
  have heqz : (n : ℤ) * ((q ^ 2 - 2 * n : ℕ) : ℤ) +
          (Nat.choose (2 * n) 2 : ℤ) +
          6 * (Nat.choose (2 * n) 4 : ℤ) =
        (n : ℤ) * ((Nat.choose (2 * n) 2 : ℤ) * ((q - 1 : ℕ) : ℤ)) := by
    exact_mod_cast heq
  have hsubsqz : ((q ^ 2 - 2 * n : ℕ) : ℤ) + (2 * n : ℕ) =
      (q ^ 2 : ℕ) := by
    exact_mod_cast hsubsq
  have hsubqz : ((q - 1 : ℕ) : ℤ) + 1 = q := by
    exact_mod_cast hsubq
  have hchooseTwoz : (2 : ℤ) * (Nat.choose (2 * n) 2 : ℤ) =
      ((2 * n : ℕ) : ℤ) * ((2 * n - 1 : ℕ) : ℤ) := by
    exact_mod_cast hchooseTwo
  have hchooseTwoPredz : (2 : ℤ) * (Nat.choose (2 * n - 1) 2 : ℤ) =
      ((2 * n - 1 : ℕ) : ℤ) * ((2 * n - 1 - 1 : ℕ) : ℤ) := by
    exact_mod_cast hchooseTwoPred
  have hchooseFourz : (24 : ℤ) * (Nat.choose (2 * n) 4 : ℤ) =
      ((2 * n : ℕ) : ℤ) * ((2 * n - 1 : ℕ) : ℤ) *
        ((2 * n - 2 : ℕ) : ℤ) * ((2 * n - 3 : ℕ) : ℤ) := by
    exact_mod_cast hchooseFour
  have hnsubone : ((2 * n - 1 : ℕ) : ℤ) = 2 * (n : ℤ) - 1 := by omega
  have hnsubtwo : ((2 * n - 2 : ℕ) : ℤ) = 2 * (n : ℤ) - 2 := by omega
  have hnsubthree : ((2 * n - 3 : ℕ) : ℤ) = 2 * (n : ℤ) - 3 := by omega
  have hnsubtwice : ((2 * n - 1 - 1 : ℕ) : ℤ) = 2 * (n : ℤ) - 2 := by omega
  push_cast at heqz hsubsqz hsubqz hchooseTwoz hchooseTwoPredz hchooseFourz
  have hqsubz : ((q - 1 : ℕ) : ℤ) = (q : ℤ) - 1 := by linarith
  have hqsqsubz : ((q ^ 2 - 2 * n : ℕ) : ℤ) =
      (q : ℤ) ^ 2 - 2 * (n : ℤ) := by nlinarith
  rw [hnsubone] at hchooseTwoz hchooseTwoPredz hchooseFourz
  rw [hnsubtwo] at hchooseFourz
  rw [hnsubthree] at hchooseFourz
  rw [hnsubtwice] at hchooseTwoPredz
  have hchooseTwoValue : (Nat.choose (2 * n) 2 : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) := by
    have hrhs : 2 * (n : ℤ) * (2 * (n : ℤ) - 1) =
        2 * ((n : ℤ) * (2 * (n : ℤ) - 1)) := by ring
    rw [hrhs] at hchooseTwoz
    omega
  have hchooseTwoPredValue : (Nat.choose (2 * n - 1) 2 : ℤ) =
      (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) := by
    have hrhs : (2 * (n : ℤ) - 1) * (2 * (n : ℤ) - 2) =
        2 * ((2 * (n : ℤ) - 1) * ((n : ℤ) - 1)) := by ring
    rw [hrhs] at hchooseTwoPredz
    omega
  have hsixChooseFourValue : 6 * (Nat.choose (2 * n) 4 : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) *
        (2 * (n : ℤ) - 3) := by
    have hrhs : 2 * (n : ℤ) * (2 * (n : ℤ) - 1) * (2 * (n : ℤ) - 2) *
          (2 * (n : ℤ) - 3) =
        4 * ((n : ℤ) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) *
          (2 * (n : ℤ) - 3)) := by ring
    have hlhs : 24 * (Nat.choose (2 * n) 4 : ℤ) =
        4 * (6 * (Nat.choose (2 * n) 4 : ℤ)) := by ring
    rw [hrhs, hlhs] at hchooseFourz
    omega
  rw [hqsqsubz] at heqz
  rw [hchooseTwoValue] at heqz
  rw [hsixChooseFourValue] at heqz
  rw [hqsubz] at heqz
  have hfactored :
      (n : ℤ) * ((q : ℤ) ^ 2 - 2 * (n : ℤ) +
          (2 * (n : ℤ) - 1) +
          (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) * (2 * (n : ℤ) - 3)) =
        (n : ℤ) * ((n : ℤ) * (2 * (n : ℤ) - 1) * ((q : ℤ) - 1)) := by
    calc
      _ = (n : ℤ) * ((q : ℤ) ^ 2 - 2 * (n : ℤ)) +
            (n : ℤ) * (2 * (n : ℤ) - 1) +
            (n : ℤ) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) *
              (2 * (n : ℤ) - 3) := by ring
      _ = (n : ℤ) * ((n : ℤ) * (2 * (n : ℤ) - 1) *
            ((q : ℤ) - 1)) := heqz
      _ = _ := by ring
  have hnzero : (n : ℤ) ≠ 0 := by omega
  have hinside :
      (q : ℤ) ^ 2 - 2 * (n : ℤ) +
          (2 * (n : ℤ) - 1) +
          (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) * (2 * (n : ℤ) - 3) =
        (n : ℤ) * (2 * (n : ℤ) - 1) * ((q : ℤ) - 1) := by
    exact mul_left_cancel₀ hnzero hfactored
  have hfactor :
      ((q : ℤ) - ((2 * n - 2 : ℕ) : ℤ)) *
          ((q : ℤ) - ((Nat.choose (2 * n - 1) 2 + 1 : ℕ) : ℤ)) = 0 := by
    push_cast
    rw [hnsubtwo, hchooseTwoPredValue]
    linear_combination hinside
  rcases mul_eq_zero.mp hfactor with hfirst | hsecond
  · left
    exact_mod_cast sub_eq_zero.mp hfirst
  · right
    exact_mod_cast sub_eq_zero.mp hsecond

/-- A complete affine arc of even size attaining equality has one of the two line-hole orders. -/
theorem completeAffine_equality_order {P L : Type*} [Membership P L]
    [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
    [Configuration.ProjectivePlane P L]
    {A : Finset P} {linfty : L} {n : ℕ}
    (hcomplete : CompleteAffine (L := L) A linfty)
    (hcard : A.card = 2 * n) (hn : 3 ≤ n)
    (heq : (A.card / 2) * (PlaneOrder P L ^ 2 - A.card) +
          Nat.choose A.card 2 + 6 * Nat.choose A.card 4 =
        (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1))) :
    PlaneOrder P L = A.card - 2 ∨
      PlaneOrder P L = Nat.choose (A.card - 1) 2 + 1 := by
  let q := PlaneOrder P L
  have hq : 1 ≤ q := by
    dsimp [q]
    exact Nat.le_of_lt (Configuration.ProjectivePlane.one_lt_order P L)
  have hunion :
      (A ∪ pointsOnLine (P := P) linfty).card ≤ Fintype.card P :=
    Finset.card_le_univ _
  rw [Finset.card_union_of_disjoint hcomplete.2.1,
    card_pointsOnLine (P := P) linfty,
    RelativeConicArcs.card_points (P := P) (L := L)] at hunion
  have hqk : 2 * n ≤ q ^ 2 := by
    dsimp [q]
    omega
  have heq' : n * (q ^ 2 - 2 * n) + Nat.choose (2 * n) 2 +
        6 * Nat.choose (2 * n) 4 =
      n * (Nat.choose (2 * n) 2 * (q - 1)) := by
    simpa [q, hcard] using heq
  have hroots := even_affine_equality_roots_arithmetic hn hq hqk heq'
  simpa [q, hcard] using hroots

/-- Integer sieve behind the odd-size equality spectrum.  Here `Q = k-1` and
`R = choose(Q,2)-1`; writing `Q=2n` removes division from the statement. -/
theorem odd_equality_formula_spectrum {n q s : ℤ} (hn : 3 ≤ n)
    (hq : 2 * n ≤ q) (hs0 : 0 ≤ s) (hs1 : s ≤ q + 1)
    (hformula : s = q - (q - 2 * n) * (q - (n * (2 * n - 1) - 1))) :
    q = 2 * n ∨
      q = n * (2 * n - 1) - 1 ∨
      q = n * (2 * n - 1) := by
  let R := n * (2 * n - 1) - 1
  have hformulaR : s = q - (q - 2 * n) * (q - R) := by
    simpa [R] using hformula
  have hgap : 2 * n + 2 < R := by
    dsimp [R]
    nlinarith
  by_cases hqR : q ≤ R
  · by_cases hqQ : q = 2 * n
    · exact Or.inl hqQ
    · by_cases hqeqR : q = R
      · exact Or.inr (Or.inl hqeqR)
      · have hleft : 1 ≤ q - 2 * n := by omega
        have hright : 1 ≤ R - q := by omega
        have hprod : 1 ≤ (q - 2 * n) * (R - q) := by
          have := mul_le_mul hleft hright (by omega) (by omega)
          simpa using this
        have hprodle : (q - 2 * n) * (R - q) ≤ 1 := by
          nlinarith [hformulaR]
        have hleftone : q - 2 * n = 1 := by nlinarith
        have hrightone : R - q = 1 := by nlinarith
        omega
  · have hqR' : R + 1 ≤ q := by omega
    by_cases hnext : q = R + 1
    · right
      right
      simpa [R] using hnext
    · have hfar : R + 2 ≤ q := by omega
      have hnonneg : 0 ≤ q - 2 * n := by omega
      have hmul : 2 * (q - 2 * n) ≤ (q - 2 * n) * (q - R) := by
        have := mul_le_mul_of_nonneg_right (by omega : 2 ≤ q - R) hnonneg
        simpa [mul_comm] using this
      have hqle : q ≤ 4 * n := by
        nlinarith [hformulaR]
      have : 4 * n < R + 2 := by
        dsimp [R]
        nlinarith
      omega

/-- An odd divisor of a power of two is one. -/
theorem odd_dvd_two_pow_eq_one {d e : ℕ} (hodd : Odd d) (hdvd : d ∣ 2 ^ e) :
    d = 1 := by
  apply Nat.eq_one_of_dvd_coprimes (hodd.coprime_two_right.pow_right e) dvd_rfl hdvd

/-- Among the three odd-size equality orders, a power of two can only be the first root. -/
theorem odd_equality_spectrum_power_two {n q e : ℕ} (hn : 3 ≤ n)
    (hqpow : q = 2 ^ e)
    (hspectrum : q = 2 * n ∨
      q = n * (2 * n - 1) - 1 ∨ q = n * (2 * n - 1)) :
    q = 2 * n := by
  rcases hspectrum with hfirst | hsecond | hthird
  · exact hfirst
  · exfalso
    let d := 2 * n + 1
    have hodd : Odd d := ⟨n, by simp [d, Nat.add_comm]⟩
    have hfactorIdentity :
        n * (2 * n - 1) - 1 = (n - 1) * (2 * n + 1) := by
      have hnOne : 1 ≤ n := by omega
      have htwoNOne : 1 ≤ 2 * n := by omega
      have hprodOne : 1 ≤ n * (2 * n - 1) :=
        Nat.mul_pos (by omega) (by omega)
      have hz : (n : ℤ) * (2 * (n : ℤ) - 1) - 1 =
          ((n : ℤ) - 1) * (2 * (n : ℤ) + 1) := by ring
      exact_mod_cast hz
    have hpowIdentity : 2 ^ (e + 3) = 8 * (n - 1) * d := by
      calc
        2 ^ (e + 3) = 8 * (2 ^ e) := by ring
        _ = 8 * q := by rw [← hqpow]
        _ = 8 * (n * (2 * n - 1) - 1) := by rw [hsecond]
        _ = 8 * (n - 1) * d := by rw [hfactorIdentity]; simp [d, mul_assoc]
    have hdvd : d ∣ 2 ^ (e + 3) := by
      refine ⟨8 * (n - 1), ?_⟩
      simpa [mul_comm, mul_left_comm, mul_assoc] using hpowIdentity
    have hdOne := odd_dvd_two_pow_eq_one hodd hdvd
    dsimp [d] at hdOne
    omega
  · exfalso
    let d := 2 * n - 1
    have hodd : Odd d := ⟨n - 1, by
      dsimp [d]
      omega⟩
    have hdvd : d ∣ 2 ^ e := by
      refine ⟨n, ?_⟩
      rw [← hqpow, hthird]
      simp [d, mul_comm]
    have hdOne := odd_dvd_two_pow_eq_one hodd hdvd
    dsimp [d] at hdOne
    omega

/-- Integer sieve for the even equality formula.  If the number `s` of maximum-index holes lies
between zero and the hole-set cardinality, then the order is one of the three factorization
values. -/
theorem even_equality_formula_spectrum {n q s : ℤ} (hn : 3 ≤ n)
    (hqLower : 2 * n - 2 ≤ q) (hs0 : 0 ≤ s) (hsUpper : s ≤ q + 1)
    (hformula : s = q + 1 -
      (q - (2 * n - 2)) * (q - ((2 * n - 1) * (n - 1)))) :
    q = 2 * n - 2 ∨
      q = (2 * n - 1) * (n - 1) ∨
      q = (2 * n - 1) * (n - 1) + 1 := by
  let Q := 2 * n - 2
  let B := (2 * n - 1) * (n - 1)
  have hQ : 4 ≤ Q := by dsimp [Q]; omega
  have hB : 2 * B = Q * (Q + 1) := by
    dsimp [Q, B]
    ring
  have hQB : Q < B := by
    nlinarith
  by_cases hqB : q ≤ B
  · have hqQ : 0 ≤ q - Q := by dsimp [Q]; omega
    have hBq : 0 ≤ B - q := by omega
    have hprod : 0 ≤ (q - Q) * (B - q) :=
      mul_nonneg hqQ hBq
    have hzero : (q - Q) * (B - q) = 0 := by
      dsimp [Q, B] at hprod ⊢
      nlinarith
    rcases mul_eq_zero.mp hzero with hfirst | hsecond
    · left
      dsimp [Q] at hfirst ⊢
      omega
    · right
      left
      dsimp [B] at hsecond ⊢
      omega
  · have hBq : B < q := lt_of_not_ge hqB
    by_cases hnext : q = B + 1
    · right
      right
      simpa [B] using hnext
    · have hqBtwo : B + 2 ≤ q := by omega
      have hqLarge : 2 * Q + 1 < q := by
        nlinarith
      have hleft : 0 ≤ q - Q := by omega
      have hfactor : 2 ≤ q - B := by omega
      have hprodLower :
          2 * (q - Q) ≤ (q - Q) * (q - B) := by
        simpa [mul_comm] using mul_le_mul_of_nonneg_left hfactor hleft
      have hprodLarge : q + 1 < (q - Q) * (q - B) := by
        omega
      dsimp [Q, B] at hprodLarge
      nlinarith

/-- If an even equality order is a power of two, the middle factorization root is impossible. -/
theorem even_equality_spectrum_power_two {n q e : ℕ} (hn : 3 ≤ n)
    (hqpow : q = 2 ^ e)
    (hspectrum : q = 2 * n - 2 ∨
      q = (2 * n - 1) * (n - 1) ∨
      q = (2 * n - 1) * (n - 1) + 1) :
    q = 2 * n - 2 ∨ q = (2 * n - 1) * (n - 1) + 1 := by
  rcases hspectrum with hfirst | hmiddle | hupper
  · exact Or.inl hfirst
  · exfalso
    let d := 2 * n - 1
    have hodd : Odd d := ⟨n - 1, by
      dsimp [d]
      omega⟩
    have hdvd : d ∣ 2 ^ e := by
      refine ⟨n - 1, ?_⟩
      rw [← hqpow, hmiddle]
    have hdOne := odd_dvd_two_pow_eq_one hodd hdvd
    dsimp [d] at hdOne
    omega
  · exact Or.inr hupper

end Arithmetic

section GeometricSpectrum

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- Hole points whose secant index is the maximum `floor(k/2)`. -/
noncomputable def maximumIndexHoles (A H : Finset P) : Finset P := by
  classical
  exact H.filter fun y => pointIndex (L := L) A y = A.card / 2

/-- At zero defect, hole incidence equals the maximum index times the number of maximum-index
holes. -/
theorem holeIncidence_eq_half_mul_card_maximumIndexHoles {A H : Finset P}
    (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) :
    holeIncidence (L := L) A H =
      (A.card / 2) * (maximumIndexHoles (L := L) A H).card := by
  classical
  have hpatterns := (scaledDefect_eq_zero_iff (L := L) hA hdisj).mp hzero
  rw [holeIncidence, maximumIndexHoles]
  calc
    (∑ y ∈ H, pointIndex (L := L) A y) =
        ∑ y ∈ H, if pointIndex (L := L) A y = A.card / 2
          then A.card / 2 else 0 := by
      apply Finset.sum_congr rfl
      intro y hy
      rcases hpatterns.2 y hy with hzeroIndex | hhalf
      · simp [hzeroIndex]
      · simp [hhalf]
    _ = ∑ y ∈ H.filter
          (fun y => pointIndex (L := L) A y = A.card / 2), A.card / 2 := by
      rw [Finset.sum_filter]
    _ = (A.card / 2) *
          (H.filter fun y => pointIndex (L := L) A y = A.card / 2).card := by
      simp [mul_comm]

/-- For even arc size, zero defect and any prescribed hole set of cardinality `q+1` force the
three possible orders `k-2`, `choose(k-1,2)`, and `choose(k-1,2)+1`.  No geometric property of
the holes is used. -/
theorem even_completeOutside_zeroDefect_order_spectrum {A H : Finset P} {n : ℕ}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1)
    (hcard : A.card = 2 * n) (hn : 3 ≤ n)
    (hzero : scaledDefect (L := L) A H = 0) :
    PlaneOrder P L = A.card - 2 ∨
      PlaneOrder P L = Nat.choose (A.card - 1) 2 ∨
      PlaneOrder P L = Nat.choose (A.card - 1) 2 + 1 := by
  classical
  let q := PlaneOrder P L
  let s := (maximumIndexHoles (L := L) A H).card
  have hm : A.card / 2 = n := by omega
  have hinc : holeIncidence (L := L) A H = n * s := by
    simpa [s, hm] using
      holeIncidence_eq_half_mul_card_maximumIndexHoles
        (L := L) hcomplete.1 hcomplete.2.1 hzero
  have hempty : uncovered (L := L) A H = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := L)).mp hcomplete |>.2.2
  have hcovered : coveredRequired (L := L) A H = requiredLocus A H := by
    rw [← covered_union_uncovered (L := L) A H, hempty, Finset.union_empty]
  have hcoveredCard : (coveredRequired (L := L) A H).card = q ^ 2 - A.card := by
    rw [hcovered]
    simpa [q] using
      Conic.card_requiredLocus_of_card_holes (P := P) (L := L) hcomplete.2.1 hH
  have hnonempty : A.Nonempty := by
    rw [Finset.nonempty_iff_ne_empty]
    intro hemptyA
    have : A.card = 0 := by simp [hemptyA]
    omega
  have harcBound := arc_card_le_planeOrder_add_two (L := L) hcomplete.1 hnonempty
  have hqLower : 2 * n - 2 ≤ q := by
    dsimp [q]
    omega
  have hsubset : maximumIndexHoles (L := L) A H ⊆ H :=
    Finset.filter_subset _ _
  have hsUpper : s ≤ q + 1 := by
    have := Finset.card_le_card hsubset
    dsimp [s, q]
    omega
  have hqk : 2 * n ≤ q ^ 2 := by
    have hqTwo : 2 ≤ q := by
      dsimp [q]
      exact Configuration.ProjectivePlane.one_lt_order P L
    nlinarith
  have hzeroz := hzero
  rw [scaledDefect, hm, hcard, hinc, hcoveredCard, hcard] at hzeroz
  have hqsub : q - 1 + 1 = q := Nat.sub_add_cancel (by
    dsimp [q]
    exact Nat.le_of_lt (Configuration.ProjectivePlane.one_lt_order P L))
  have hqsqsub : q ^ 2 - 2 * n + 2 * n = q ^ 2 :=
    Nat.sub_add_cancel hqk
  have hchooseTwo := two_mul_choose_two (2 * n)
  have hchooseFour := Conic.twentyFour_mul_choose_four (2 * n)
  have hqsubz : ((q - 1 : ℕ) : ℤ) = (q : ℤ) - 1 := by
    have hcast : ((q - 1 : ℕ) : ℤ) + 1 = (q : ℤ) := by
      exact_mod_cast hqsub
    linarith
  have hqsqsubz : ((q ^ 2 - 2 * n : ℕ) : ℤ) =
      (q : ℤ) ^ 2 - 2 * (n : ℤ) := by
    have : ((q ^ 2 - 2 * n : ℕ) : ℤ) + 2 * (n : ℤ) =
        (q : ℤ) ^ 2 := by exact_mod_cast hqsqsub
    nlinarith
  have hchooseTwoz : (2 : ℤ) * (Nat.choose (2 * n) 2 : ℤ) =
      ((2 * n : ℕ) : ℤ) * ((2 * n - 1 : ℕ) : ℤ) := by
    exact_mod_cast hchooseTwo
  have hchooseFourz : (24 : ℤ) * (Nat.choose (2 * n) 4 : ℤ) =
      ((2 * n : ℕ) : ℤ) * ((2 * n - 1 : ℕ) : ℤ) *
        ((2 * n - 2 : ℕ) : ℤ) * ((2 * n - 3 : ℕ) : ℤ) := by
    exact_mod_cast hchooseFour
  push_cast at hzeroz hchooseTwoz hchooseFourz
  have hnsubone : ((2 * n - 1 : ℕ) : ℤ) = 2 * (n : ℤ) - 1 := by omega
  have hnsubtwo : ((2 * n - 2 : ℕ) : ℤ) = 2 * (n : ℤ) - 2 := by omega
  have hnsubthree : ((2 * n - 3 : ℕ) : ℤ) = 2 * (n : ℤ) - 3 := by omega
  rw [hnsubone] at hchooseTwoz
  rw [hnsubone, hnsubtwo, hnsubthree] at hchooseFourz
  have hchooseTwoValue : (Nat.choose (2 * n) 2 : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) := by
    have hrhs : (2 * (n : ℤ)) * (2 * (n : ℤ) - 1) =
        2 * ((n : ℤ) * (2 * (n : ℤ) - 1)) := by ring
    rw [hrhs] at hchooseTwoz
    omega
  have hsixChooseFourValue : 6 * (Nat.choose (2 * n) 4 : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) *
        (2 * (n : ℤ) - 3) := by
    have hrhs : (2 * (n : ℤ)) * (2 * (n : ℤ) - 1) *
          (2 * (n : ℤ) - 2) * (2 * (n : ℤ) - 3) =
        4 * ((n : ℤ) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) *
          (2 * (n : ℤ) - 3)) := by ring
    have hlhs : 24 * (Nat.choose (2 * n) 4 : ℤ) =
        4 * (6 * (Nat.choose (2 * n) 4 : ℤ)) := by ring
    rw [hrhs, hlhs] at hchooseFourz
    omega
  rw [hqsubz, hqsqsubz, hchooseTwoValue, hsixChooseFourValue] at hzeroz
  have hnzero : (n : ℤ) ≠ 0 := by omega
  have hfactored :
      (n : ℤ) * (((n : ℤ) * (2 * (n : ℤ) - 1) * ((q : ℤ) - 1)) -
        ((2 * (n : ℤ) - 1) * ((n : ℤ) - 1) * (2 * (n : ℤ) - 3)) -
        (s : ℤ) - ((q : ℤ) ^ 2 - 2 * (n : ℤ))) = 0 := by
    linear_combination hzeroz
  have hinside :
      ((n : ℤ) * (2 * (n : ℤ) - 1) * ((q : ℤ) - 1)) -
        ((2 * (n : ℤ) - 1) * ((n : ℤ) - 1) * (2 * (n : ℤ) - 3)) -
        (s : ℤ) - ((q : ℤ) ^ 2 - 2 * (n : ℤ)) = 0 :=
    (mul_eq_zero.mp hfactored).resolve_left hnzero
  have hformula : (s : ℤ) = (q : ℤ) + 1 -
      ((q : ℤ) - (2 * (n : ℤ) - 2)) *
        ((q : ℤ) - ((2 * (n : ℤ) - 1) * ((n : ℤ) - 1))) := by
    linear_combination -hinside
  have hqLowerz : ((2 * n - 2 : ℕ) : ℤ) ≤ (q : ℤ) := by
    exact_mod_cast hqLower
  rw [hnsubtwo] at hqLowerz
  have hroots := even_equality_formula_spectrum
    (n := (n : ℤ)) (q := (q : ℤ)) (s := (s : ℤ))
    (by exact_mod_cast hn) hqLowerz
    (Int.natCast_nonneg s) (by exact_mod_cast hsUpper) hformula
  have hchoosePred : Nat.choose (2 * n - 1) 2 =
      (2 * n - 1) * (n - 1) := by
    have h := two_mul_choose_two (2 * n - 1)
    have hsub : 2 * n - 1 - 1 = 2 * (n - 1) := by omega
    rw [hsub] at h
    have hrhs : (2 * n - 1) * (2 * (n - 1)) =
        2 * ((2 * n - 1) * (n - 1)) := by ring
    rw [hrhs] at h
    omega
  have hnminusone : ((n - 1 : ℕ) : ℤ) = (n : ℤ) - 1 := by omega
  have hprodCast :
      (((2 * n - 1) * (n - 1) : ℕ) : ℤ) =
        (2 * (n : ℤ) - 1) * ((n : ℤ) - 1) := by
    push_cast
    rw [hnsubone, hnminusone]
  rcases hroots with hfirst | hsecond | hthird
  · left
    have hfirst' : (q : ℤ) = ((2 * n - 2 : ℕ) : ℤ) := by
      rw [hnsubtwo]
      exact hfirst
    have hnat : q = 2 * n - 2 := by exact_mod_cast hfirst'
    dsimp [q] at hnat
    rw [hcard]
    exact hnat
  · right
    left
    have hsecond' :
        (q : ℤ) = (((2 * n - 1) * (n - 1) : ℕ) : ℤ) := by
      rw [hprodCast]
      exact hsecond
    have hnat : q = (2 * n - 1) * (n - 1) := by exact_mod_cast hsecond'
    dsimp [q] at hnat
    rw [hcard]
    simp only [hchoosePred]
    exact hnat
  · right
    right
    have hthird' :
        (q : ℤ) = (((2 * n - 1) * (n - 1) + 1 : ℕ) : ℤ) := by
      rw [Nat.cast_add, hprodCast]
      norm_num
      exact hthird
    have hnat : q = (2 * n - 1) * (n - 1) + 1 := by
      exact_mod_cast hthird'
    dsimp [q] at hnat
    rw [hcard]
    simp only [hchoosePred]
    exact hnat

/-- For odd arc size, zero defect and a prescribed hole set of conic cardinality force the three
orders in the manuscript's odd equality spectrum.  The proof uses only the hole cardinality, not
coordinates or nonsingularity. -/
theorem odd_completeOutside_zeroDefect_order_spectrum {A H : Finset P} {n : ℕ}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1)
    (hcard : A.card = 2 * n + 1) (hn : 3 ≤ n)
    (hzero : scaledDefect (L := L) A H = 0) :
    PlaneOrder P L = A.card - 1 ∨
      PlaneOrder P L = Nat.choose (A.card - 1) 2 - 1 ∨
      PlaneOrder P L = Nat.choose (A.card - 1) 2 := by
  classical
  let q := PlaneOrder P L
  let s := (maximumIndexHoles (L := L) A H).card
  have hm : A.card / 2 = n := by omega
  have hinc : holeIncidence (L := L) A H = n * s := by
    simpa [s, hm] using
      holeIncidence_eq_half_mul_card_maximumIndexHoles
        (L := L) hcomplete.1 hcomplete.2.1 hzero
  have hempty : uncovered (L := L) A H = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := L)).mp hcomplete |>.2.2
  have hcovered : coveredRequired (L := L) A H = requiredLocus A H := by
    rw [← covered_union_uncovered (L := L) A H, hempty, Finset.union_empty]
  have hcoveredCard : (coveredRequired (L := L) A H).card = q ^ 2 - A.card := by
    rw [hcovered]
    simpa [q] using
      Conic.card_requiredLocus_of_card_holes (P := P) (L := L) hcomplete.2.1 hH
  have hnonempty : A.Nonempty := by
    rw [Finset.nonempty_iff_ne_empty]
    intro hemptyA
    have : A.card = 0 := by simp [hemptyA]
    omega
  have harcBound := arc_card_le_planeOrder_add_two (L := L) hcomplete.1 hnonempty
  have hqLowerPred : 2 * n - 1 ≤ q := by
    dsimp [q]
    omega
  have hsubset : maximumIndexHoles (L := L) A H ⊆ H :=
    Finset.filter_subset _ _
  have hsUpper : s ≤ q + 1 := by
    have := Finset.card_le_card hsubset
    dsimp [s, q]
    omega
  have hqk : 2 * n + 1 ≤ q ^ 2 := by
    have hqTwo : 2 ≤ q := by
      dsimp [q]
      exact Configuration.ProjectivePlane.one_lt_order P L
    nlinarith
  have hzeroz := hzero
  rw [scaledDefect, hm, hcard, hinc, hcoveredCard, hcard] at hzeroz
  have hqsub : q - 1 + 1 = q := Nat.sub_add_cancel (by
    dsimp [q]
    exact Nat.le_of_lt (Configuration.ProjectivePlane.one_lt_order P L))
  have hqsqsub : q ^ 2 - (2 * n + 1) + (2 * n + 1) = q ^ 2 :=
    Nat.sub_add_cancel hqk
  have hchooseTwo := two_mul_choose_two (2 * n + 1)
  have hchooseFour := Conic.twentyFour_mul_choose_four (2 * n + 1)
  have hqsubz : ((q - 1 : ℕ) : ℤ) = (q : ℤ) - 1 := by
    have hcast : ((q - 1 : ℕ) : ℤ) + 1 = (q : ℤ) := by
      exact_mod_cast hqsub
    linarith
  have hqsqsubz : ((q ^ 2 - (2 * n + 1) : ℕ) : ℤ) =
      (q : ℤ) ^ 2 - (2 * (n : ℤ) + 1) := by
    have : ((q ^ 2 - (2 * n + 1) : ℕ) : ℤ) + (2 * (n : ℤ) + 1) =
        (q : ℤ) ^ 2 := by exact_mod_cast hqsqsub
    nlinarith
  have hchooseTwoz : (2 : ℤ) * (Nat.choose (2 * n + 1) 2 : ℤ) =
      ((2 * n + 1 : ℕ) : ℤ) * ((2 * n : ℕ) : ℤ) := by
    have hs : 2 * n + 1 - 1 = 2 * n := by omega
    rw [hs] at hchooseTwo
    exact_mod_cast hchooseTwo
  have hchooseFourz : (24 : ℤ) * (Nat.choose (2 * n + 1) 4 : ℤ) =
      ((2 * n + 1 : ℕ) : ℤ) * ((2 * n : ℕ) : ℤ) *
        ((2 * n - 1 : ℕ) : ℤ) * ((2 * n - 2 : ℕ) : ℤ) := by
    have hs1 : 2 * n + 1 - 1 = 2 * n := by omega
    have hs2 : 2 * n + 1 - 2 = 2 * n - 1 := by omega
    have hs3 : 2 * n + 1 - 3 = 2 * n - 2 := by omega
    rw [hs1, hs2, hs3] at hchooseFour
    exact_mod_cast hchooseFour
  push_cast at hzeroz hchooseTwoz hchooseFourz
  have hnsubone : ((2 * n - 1 : ℕ) : ℤ) = 2 * (n : ℤ) - 1 := by omega
  have hnsubtwo : ((2 * n - 2 : ℕ) : ℤ) = 2 * (n : ℤ) - 2 := by omega
  rw [hnsubone, hnsubtwo] at hchooseFourz
  have hchooseTwoValue : (Nat.choose (2 * n + 1) 2 : ℤ) =
      (2 * (n : ℤ) + 1) * (n : ℤ) := by
    have hrhs : (2 * (n : ℤ) + 1) * (2 * (n : ℤ)) =
        2 * ((2 * (n : ℤ) + 1) * (n : ℤ)) := by ring
    rw [hrhs] at hchooseTwoz
    omega
  have hsixChooseFourValue : 6 * (Nat.choose (2 * n + 1) 4 : ℤ) =
      (2 * (n : ℤ) + 1) * (n : ℤ) * (2 * (n : ℤ) - 1) *
        ((n : ℤ) - 1) := by
    have hrhs : (2 * (n : ℤ) + 1) * (2 * (n : ℤ)) *
          (2 * (n : ℤ) - 1) * (2 * (n : ℤ) - 2) =
        4 * ((2 * (n : ℤ) + 1) * (n : ℤ) *
          (2 * (n : ℤ) - 1) * ((n : ℤ) - 1)) := by ring
    have hlhs : 24 * (Nat.choose (2 * n + 1) 4 : ℤ) =
        4 * (6 * (Nat.choose (2 * n + 1) 4 : ℤ)) := by ring
    rw [hrhs, hlhs] at hchooseFourz
    omega
  rw [hqsubz, hqsqsubz, hchooseTwoValue, hsixChooseFourValue] at hzeroz
  have hnzero : (n : ℤ) ≠ 0 := by omega
  have hfactored :
      (n : ℤ) * (((n : ℤ) * (2 * (n : ℤ) + 1) * ((q : ℤ) - 1)) -
        ((2 * (n : ℤ) + 1) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1)) -
        (s : ℤ) - ((q : ℤ) ^ 2 - (2 * (n : ℤ) + 1))) = 0 := by
    linear_combination hzeroz
  have hinside :
      ((n : ℤ) * (2 * (n : ℤ) + 1) * ((q : ℤ) - 1)) -
        ((2 * (n : ℤ) + 1) * (2 * (n : ℤ) - 1) * ((n : ℤ) - 1)) -
        (s : ℤ) - ((q : ℤ) ^ 2 - (2 * (n : ℤ) + 1)) = 0 :=
    (mul_eq_zero.mp hfactored).resolve_left hnzero
  have hformula : (s : ℤ) =
      (q : ℤ) - ((q : ℤ) - 2 * (n : ℤ)) *
        ((q : ℤ) - ((n : ℤ) * (2 * (n : ℤ) - 1) - 1)) := by
    have hexpanded : (s : ℤ) =
        -((q : ℤ) ^ 2) +
          (n : ℤ) * (2 * (n : ℤ) + 1) * (q : ℤ) -
          2 * (n : ℤ) * ((n : ℤ) - 1) * (2 * (n : ℤ) + 1) := by
      linear_combination -hinside
    calc
      (s : ℤ) = _ := hexpanded
      _ = _ := by ring
  have hqLower : 2 * (n : ℤ) ≤ (q : ℤ) := by
    have hsnonneg : (0 : ℤ) ≤ (s : ℤ) := Int.natCast_nonneg s
    have hpredCast : (2 * (n : ℤ) - 1) ≤ (q : ℤ) := by
      rw [← hnsubone]
      exact_mod_cast hqLowerPred
    by_contra hnot
    have hqeq : (q : ℤ) = 2 * (n : ℤ) - 1 := by omega
    rw [hqeq] at hformula
    have hncast : (3 : ℤ) ≤ n := by exact_mod_cast hn
    have hsvalue : (s : ℤ) =
        -2 * (n : ℤ) ^ 2 + 5 * (n : ℤ) - 1 := by
      linear_combination hformula
    have hfactorLower : (3 : ℤ) ≤ (n : ℤ) * (2 * (n : ℤ) - 5) := by
      have hright : (1 : ℤ) ≤ 2 * (n : ℤ) - 5 := by omega
      have := mul_le_mul hncast hright (by omega) (by omega)
      simpa using this
    have hid : -2 * (n : ℤ) ^ 2 + 5 * (n : ℤ) - 1 =
        -((n : ℤ) * (2 * (n : ℤ) - 5)) - 1 := by ring
    rw [hid] at hsvalue
    omega
  have hnz : (3 : ℤ) ≤ (n : ℤ) := by exact_mod_cast hn
  have hs0z : (0 : ℤ) ≤ (s : ℤ) := Int.natCast_nonneg s
  have hsUpperz : (s : ℤ) ≤ (q : ℤ) + 1 := by exact_mod_cast hsUpper
  have hroots := odd_equality_formula_spectrum hnz hqLower hs0z hsUpperz hformula
  have hchooseQ : Nat.choose (2 * n) 2 = n * (2 * n - 1) := by
    have h := two_mul_choose_two (2 * n)
    have hrhs : 2 * n * (2 * n - 1) = 2 * (n * (2 * n - 1)) := by ring
    rw [hrhs] at h
    omega
  have hprodCast : ((n * (2 * n - 1) : ℕ) : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) := by
    push_cast
    rw [hnsubone]
  have hprodPos : 1 ≤ n * (2 * n - 1) := by
    exact Nat.mul_pos (by omega) (by omega)
  have hprodSubCast : ((n * (2 * n - 1) - 1 : ℕ) : ℤ) =
      (n : ℤ) * (2 * (n : ℤ) - 1) - 1 := by
    rw [Nat.cast_sub hprodPos, hprodCast]
    norm_num
  rcases hroots with hfirst | hsecond | hthird
  · left
    have hnat : q = 2 * n := by exact_mod_cast hfirst
    dsimp [q] at hnat
    rw [hcard]
    omega
  · right
    left
    have hsecond' : (q : ℤ) = ((n * (2 * n - 1) - 1 : ℕ) : ℤ) := by
      rw [hprodSubCast]
      exact hsecond
    have hnat : q = n * (2 * n - 1) - 1 := by exact_mod_cast hsecond'
    dsimp [q] at hnat
    rw [hcard]
    simp only [Nat.add_sub_cancel, hchooseQ]
    exact hnat
  · right
    right
    have hthird' : (q : ℤ) = ((n * (2 * n - 1) : ℕ) : ℤ) := by
      rw [hprodCast]
      exact hthird
    have hnat : q = n * (2 * n - 1) := by exact_mod_cast hthird'
    dsimp [q] at hnat
    rw [hcard]
    simp only [Nat.add_sub_cancel, hchooseQ]
    exact hnat

end GeometricSpectrum

section ExceptionalCandidate

open Conic Nucleus Projectivization
open scoped LinearAlgebra.Projectivization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPoint : DecidableEq (Point K) :=
  Classical.decEq (Point K)

/-- Secants meeting the standard conic in two points. -/
noncomputable def bisecantSecantsStandardConic (A : Finset (Point K)) :
    Finset (Point K) :=
  (secants (L := Point K) A).filter fun l =>
    (lineSlice (standardConic (K := K)) l).card = 2

/-- Secants disjoint from the standard conic. -/
noncomputable def externalSecantsStandardConic (A : Finset (Point K)) :
    Finset (Point K) :=
  (secants (L := Point K) A).filter fun l =>
    (lineSlice (standardConic (K := K)) l).card = 0

/-- On the upper even equality branch `q = choose(2n-1,2)+1`, zero defect forces one
standard-conic incidence for every arc secant. -/
theorem upper_even_equality_branch_holeIncidence
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n) (hn : 3 ≤ n)
    (hq : Fintype.card K = Nat.choose (2 * n - 1) 2 + 1)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    holeIncidence (L := Point K) A (standardConic (K := K)) =
      Nat.choose A.card 2 := by
  have hempty : uncovered (L := Point K) A (standardConic (K := K)) = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := Point K)).mp hcomplete |>.2.2
  have hcovered :
      coveredRequired (L := Point K) A (standardConic (K := K)) =
        requiredLocus A (standardConic (K := K)) := by
    rw [← covered_union_uncovered (L := Point K) A (standardConic (K := K)),
      hempty, Finset.union_empty]
  have hconicCard :
      (standardConic (K := K)).card =
        PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact Conic.standardConic_card (K := K)
  have hcoveredCard :
      (coveredRequired (L := Point K) A (standardConic (K := K))).card =
        Fintype.card K ^ 2 - A.card := by
    rw [hcovered]
    simpa [ProjectiveBridge.planeOrder_eq_card] using
      Conic.card_requiredLocus_of_card_holes hcomplete.2.1 hconicCard
  have hchooseTwo := two_mul_choose_two (2 * n)
  have hchooseTwoPred := two_mul_choose_two (2 * n - 1)
  have hchooseFour := Conic.twentyFour_mul_choose_four (2 * n)
  have hchooseTwoValue : Nat.choose (2 * n) 2 = n * (2 * n - 1) := by
    have hrhs : 2 * n * (2 * n - 1) = 2 * (n * (2 * n - 1)) := by
      simp [Nat.mul_assoc]
    rw [hrhs] at hchooseTwo
    omega
  have hchooseTwoPredValue :
      Nat.choose (2 * n - 1) 2 = (2 * n - 1) * (n - 1) := by
    have hsub : 2 * n - 1 - 1 = 2 * (n - 1) := by omega
    rw [hsub] at hchooseTwoPred
    have hrhs :
        (2 * n - 1) * (2 * (n - 1)) =
          2 * ((2 * n - 1) * (n - 1)) := by ring
    rw [hrhs] at hchooseTwoPred
    omega
  have hsixChooseFourValue :
      6 * Nat.choose (2 * n) 4 =
        n * (2 * n - 1) * (n - 1) * (2 * n - 3) := by
    have hsubtwo : 2 * n - 2 = 2 * (n - 1) := by omega
    rw [hsubtwo] at hchooseFour
    have hrhs :
        2 * n * (2 * n - 1) * (2 * (n - 1)) * (2 * n - 3) =
          4 * (n * (2 * n - 1) * (n - 1) * (2 * n - 3)) := by ring
    have hlhs :
        24 * Nat.choose (2 * n) 4 =
          4 * (6 * Nat.choose (2 * n) 4) := by ring
    rw [hrhs, hlhs] at hchooseFour
    omega
  have hqValue :
      Fintype.card K = (2 * n - 1) * (n - 1) + 1 := by
    simpa [hchooseTwoPredValue] using hq
  have hqPos : 1 ≤ Fintype.card K := by omega
  have hqLinear : 2 * n ≤ Fintype.card K := by
    have hnsub : 1 ≤ n - 1 := by omega
    have hmul :
        2 * n - 1 ≤ (2 * n - 1) * (n - 1) :=
      Nat.le_mul_of_pos_right _ hnsub
    rw [hqValue]
    omega
  have hqSq : 2 * n ≤ Fintype.card K ^ 2 := by
    nlinarith
  have hsixChooseFourValueZ :
      6 * (Nat.choose (2 * n) 4 : ℤ) =
        (n * (2 * n - 1) * (n - 1) * (2 * n - 3) : ℕ) := by
    exact_mod_cast hsixChooseFourValue
  have hzeroz := hzero
  rw [scaledDefect, hcard, hcoveredCard, ProjectiveBridge.planeOrder_eq_card,
    hcard, hchooseTwoValue, hsixChooseFourValueZ] at hzeroz
  have hhalf : 2 * n / 2 = n := by omega
  rw [hhalf] at hzeroz
  have hqSubCast : ((Fintype.card K - 1 : ℕ) : ℤ) =
      (Fintype.card K : ℤ) - 1 := by
    rw [Nat.cast_sub hqPos]
    norm_num
  have hqSqSubCast : ((Fintype.card K ^ 2 - 2 * n : ℕ) : ℤ) =
      (Fintype.card K : ℤ) ^ 2 - 2 * (n : ℤ) := by
    rw [Nat.cast_sub hqSq]
    push_cast
    ring
  have hzeroz' := hzeroz
  simp only [Nat.cast_mul] at hzeroz'
  rw [hqSubCast, hqSqSubCast] at hzeroz'
  rw [hqValue] at hzeroz'
  push_cast at hzeroz'
  have htwoNSubOne : ((2 * n - 1 : ℕ) : ℤ) = 2 * (n : ℤ) - 1 := by
    omega
  have hnSubOne : ((n - 1 : ℕ) : ℤ) = (n : ℤ) - 1 := by
    omega
  have htwoNSubThree : ((2 * n - 3 : ℕ) : ℤ) = 2 * (n : ℤ) - 3 := by
    omega
  rw [htwoNSubOne, hnSubOne, htwoNSubThree] at hzeroz'
  ring_nf at hzeroz'
  have htarget :
      (holeIncidence (L := Point K) A (standardConic (K := K)) : ℤ) =
        n * (2 * n - 1) := by
    linear_combination -hzeroz'
  rw [hcard, hchooseTwoValue]
  rw [← htwoNSubOne] at htarget
  exact_mod_cast htarget

/-- At `(q,k)=(4096,92)`, the zero-defect equation itself fixes conic incidence at `4186`. -/
theorem exceptional_candidate_holeIncidence
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hq : Fintype.card K = 4096) (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    holeIncidence (L := Point K) A (standardConic (K := K)) = 4186 := by
  have hempty : uncovered (L := Point K) A (standardConic (K := K)) = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := Point K)).mp hcomplete |>.2.2
  have hcovered :
      coveredRequired (L := Point K) A (standardConic (K := K)) =
        requiredLocus A (standardConic (K := K)) := by
    rw [← covered_union_uncovered (L := Point K) A (standardConic (K := K)),
      hempty, Finset.union_empty]
  have hconicCard :
      (standardConic (K := K)).card =
        PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card, hq]
    simpa [hq] using (Conic.standardConic_card (K := K))
  have hcoveredCard :
      (coveredRequired (L := Point K) A (standardConic (K := K))).card =
        PlaneOrder (Point K) (Point K) ^ 2 - A.card := by
    rw [hcovered]
    exact Conic.card_requiredLocus_of_card_holes hcomplete.2.1 hconicCard
  rw [scaledDefect, hcoveredCard, ProjectiveBridge.planeOrder_eq_card,
    hq, hcard] at hzero
  norm_num [Nat.choose] at hzero
  omega

/-- At the parameter pair `(q,k)=(4096,92)`, zero defect and conic incidence `4186` force exactly
`46` tangent secants. -/
theorem exceptional_candidate_tangentSecants_card (h2 : (2 : K) = 0)
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (hinc : holeIncidence (L := Point K) A (standardConic (K := K)) = 4186) :
    (tangentSecants (L := Point K) A (standardConic (K := K))).card = 46 := by
  by_cases hnu : standardNucleus (K := K) ∈ A
  · have hmod := (nucleus_mem_arc_constraints h2 hcomplete.1 hnu).2.2
    rw [hinc, hcard] at hmod
    norm_num [Nat.ModEq] at hmod
  · have hconstraints := nucleus_not_mem_arc_constraints h2 hcomplete hnu
    have hcases :=
      pointIndex_eq_zero_or_one_or_half_of_scaledDefect_eq_zero
        (L := Point K) hcomplete.1 hcomplete.2.1 hzero hnu
    have hindex : pointIndex (L := Point K) A (standardNucleus (K := K)) = 46 := by
      rcases hcases with h0 | h1 | hm
      · omega
      · have hmod := hconstraints.2.2.2.2
        rw [hinc, h1] at hmod
        norm_num [Nat.ModEq] at hmod
      · omega
    rw [hconstraints.2.2.1, hindex]

/-- At `(q,k)=(4096,92)`, a zero-defect relative-complete arc has exactly `46` tangent,
`2070` bisecant, and `2070` external secants relative to the standard conic. -/
theorem exceptional_candidate_secant_type_cards (h2 : (2 : K) = 0)
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hq : Fintype.card K = 4096) (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    (tangentSecants (L := Point K) A (standardConic (K := K))).card = 46 ∧
      (bisecantSecantsStandardConic A).card = 2070 ∧
      (externalSecantsStandardConic A).card = 2070 := by
  classical
  let T := tangentSecants (L := Point K) A (standardConic (K := K))
  let B := bisecantSecantsStandardConic A
  let E := externalSecantsStandardConic A
  have hinc := exceptional_candidate_holeIncidence hcomplete hq hcard hzero
  have hT : T.card = 46 := by
    dsimp [T]
    exact exceptional_candidate_tangentSecants_card h2 hcomplete hcard hzero hinc
  have hcases (l : Point K) :
      (lineSlice (standardConic (K := K)) l).card = 0 ∨
      (lineSlice (standardConic (K := K)) l).card = 1 ∨
      (lineSlice (standardConic (K := K)) l).card = 2 := by
    by_cases hnu : standardNucleus (K := K) ∈ l
    · exact Or.inr (Or.inl ((standardConic_tangent_iff_mem_nucleus h2 l).mpr hnu))
    · rcases standardConic_nontangent_card h2 l hnu with hzero | htwo
      · exact Or.inl hzero
      · exact Or.inr (Or.inr htwo)
  have hpartition : secants (L := Point K) A = (T ∪ B) ∪ E := by
    ext l
    simp only [Finset.mem_union, T, B, E, tangentSecants,
      bisecantSecantsStandardConic, externalSecantsStandardConic,
      Finset.mem_filter]
    constructor
    · intro hl
      rcases hcases l with hzero | hone | htwo
      · exact Or.inr ⟨hl, hzero⟩
      · exact Or.inl (Or.inl ⟨hl, hone⟩)
      · exact Or.inl (Or.inr ⟨hl, htwo⟩)
    · rintro ((⟨hl, _⟩ | ⟨hl, _⟩) | ⟨hl, _⟩) <;> exact hl
  have hTB : Disjoint T B := by
    rw [Finset.disjoint_left]
    intro l hlT hlB
    have hone := (mem_tangentSecants.mp hlT).2
    have htwo := (Finset.mem_filter.mp hlB).2
    omega
  have hTE : Disjoint T E := by
    rw [Finset.disjoint_left]
    intro l hlT hlE
    have hone := (mem_tangentSecants.mp hlT).2
    have hzero := (Finset.mem_filter.mp hlE).2
    omega
  have hBE : Disjoint B E := by
    rw [Finset.disjoint_left]
    intro l hlB hlE
    have htwo := (Finset.mem_filter.mp hlB).2
    have hzero := (Finset.mem_filter.mp hlE).2
    omega
  have hTBE : Disjoint (T ∪ B) E := Finset.disjoint_union_left.mpr ⟨hTE, hBE⟩
  have hsumT :
      (∑ l ∈ T, (lineSlice (standardConic (K := K)) l).card) = T.card := by
    rw [Finset.card_eq_sum_ones]
    apply Finset.sum_congr rfl
    intro l hl
    exact (mem_tangentSecants.mp hl).2
  have hsumB :
      (∑ l ∈ B, (lineSlice (standardConic (K := K)) l).card) = 2 * B.card := by
    calc
      _ = ∑ _l ∈ B, 2 := by
        apply Finset.sum_congr rfl
        intro l hl
        exact (Finset.mem_filter.mp hl).2
      _ = 2 * B.card := by simp [mul_comm]
  have hsumE :
      (∑ l ∈ E, (lineSlice (standardConic (K := K)) l).card) = 0 := by
    apply Finset.sum_eq_zero
    intro l hl
    exact (Finset.mem_filter.mp hl).2
  have hincTypes : T.card + 2 * B.card = 4186 := by
    rw [Nucleus.holeIncidence_eq_sum_lineSlice, hpartition,
      Finset.sum_union hTBE, Finset.sum_union hTB, hsumT, hsumB, hsumE,
      Nat.add_zero] at hinc
    exact hinc
  have htotal : T.card + B.card + E.card = 4186 := by
    have hsecants := card_secants hcomplete.1
    rw [hpartition, Finset.card_union_of_disjoint hTBE,
      Finset.card_union_of_disjoint hTB, hcard] at hsecants
    norm_num [Nat.choose] at hsecants
    omega
  dsimp [T, B, E] at hT hincTypes htotal ⊢
  omega

/-- In characteristic two, the odd zero-defect equality spectrum collapses to the oval-size
parameter `k=q+1`.  This theorem proves the arithmetic reduction; identifying the resulting arc
with an arbitrary oval and its nucleus is a separate geometric statement. -/
theorem odd_standardConic_zeroDefect_charTwo_order [CharP K 2]
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n + 1) (hn : 3 ≤ n)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    Fintype.card K = A.card - 1 := by
  have hconicCard :
      (standardConic (K := K)).card =
        PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact Conic.standardConic_card (K := K)
  have hspectrum :=
    odd_completeOutside_zeroDefect_order_spectrum
      (P := Point K) (L := Point K) hcomplete hconicCard hcard hn hzero
  rw [ProjectiveBridge.planeOrder_eq_card, hcard] at hspectrum
  have hchooseQ : Nat.choose (2 * n) 2 = n * (2 * n - 1) := by
    have h := two_mul_choose_two (2 * n)
    have hrhs : 2 * n * (2 * n - 1) = 2 * (n * (2 * n - 1)) := by ring
    rw [hrhs] at h
    omega
  simp only [Nat.add_sub_cancel, hchooseQ] at hspectrum
  obtain ⟨e, _hprime, hpow⟩ := FiniteField.card K 2
  have hfirst := odd_equality_spectrum_power_two hn hpow hspectrum
  rw [hcard]
  omega

end ExceptionalCandidate

#print axioms scaledDefect_eq_zero_or_half_sub_two_le
#print axioms even_affine_equality_roots_arithmetic
#print axioms completeAffine_equality_order
#print axioms odd_equality_formula_spectrum
#print axioms odd_equality_spectrum_power_two
#print axioms even_equality_formula_spectrum
#print axioms even_equality_spectrum_power_two
#print axioms holeIncidence_eq_half_mul_card_maximumIndexHoles
#print axioms even_completeOutside_zeroDefect_order_spectrum
#print axioms odd_completeOutside_zeroDefect_order_spectrum
#print axioms exceptional_candidate_holeIncidence
#print axioms exceptional_candidate_tangentSecants_card
#print axioms exceptional_candidate_secant_type_cards
#print axioms odd_standardConic_zeroDefect_charTwo_order

end RelativeConicArcs
