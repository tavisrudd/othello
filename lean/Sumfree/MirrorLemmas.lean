import Mathlib.Algebra.Group.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic

/-!
Local mirror lemmas for the normal-play sum-free avoidance game.

These are the first formalization targets from the sum-free notes. Most of the
mirror lemmas below are kernel-complete; the remaining affine `F₃` theorem is
being split into small reviewable obligations before the final case split is
closed.
-/

namespace Sumfree

open Set

variable {G : Type*} [AddCommGroup G]

/-- A set is sum-free if it contains no Schur triple `a + b = c`. -/
def SumFree (A : Set G) : Prop :=
  forall ⦃a b c : G⦄, a ∈ A -> b ∈ A -> c ∈ A -> a + b = c -> False

/-- A move is legal if it is fresh and preserves sum-freeness. -/
def Legal (A : Set G) (x : G) : Prop :=
  x ∉ A ∧ SumFree (insert x A)

/-- Invariance under negation. -/
def NegInvariant (A : Set G) : Prop :=
  forall {x : G}, x ∈ A -> -x ∈ A

/-- Invariance under translation by an order-two element `v`. -/
def TauInvariant (v : G) (A : Set G) : Prop :=
  forall {x : G}, x ∈ A ↔ x + v ∈ A

private lemma add_self_eq_neg_of_neg_add_neg_eq {x c : G}
    (h : -x + -x = c) :
    x + x = -c := by
  have h' := congrArg Neg.neg h
  simpa [neg_add, add_comm] using h'

private lemma zero_of_neg_add_eq_neg {x b : G}
    (h : -x + b = -x) :
    b = 0 := by
  have h' := congrArg (fun t => x + t) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma neg_eq_self_of_neg_add_neg_eq_neg {x : G}
    (h : -x + -x = -x) :
    -x = x := by
  have hneg0 : -x = 0 := zero_of_neg_add_eq_neg h
  have hx0 : x = 0 := by
    have h' := congrArg Neg.neg hneg0
    simpa using h'
  simp [hx0]

private lemma neg_eq_self_of_neg_add_self_eq_neg {x : G}
    (h : -x + x = -x) :
    -x = x := by
  have hneg0 : -x = 0 := by
    simpa using h.symm
  have hx0 : x = 0 := by
    have h' := congrArg Neg.neg hneg0
    simpa using h'
  simp [hx0]

private lemma neg_eq_self_of_neg_add_self_eq_self {x : G}
    (h : -x + x = x) :
    -x = x := by
  have hx0 : x = 0 := by
    simpa using h.symm
  simp [hx0]

private lemma add_self_eq_of_neg_add_eq_self {x b : G}
    (h : -x + b = x) :
    x + x = b := by
  have h' := congrArg (fun t => x + t) h
  simpa [add_assoc, add_comm, add_left_comm] using h'.symm

private lemma left_add_eq_of_neg_add_eq {x b c : G}
    (h : -x + b = c) :
    x + c = b := by
  rw [← h]
  simp [add_comm]

private lemma right_add_eq_of_add_neg_eq {x a c : G}
    (h : a + -x = c) :
    x + c = a := by
  rw [← h]
  simp

private lemma neg_add_neg_eq_of_add_eq_neg {x a b : G}
    (h : a + b = -x) :
    -a + -b = x := by
  have h' := congrArg Neg.neg h
  simpa [neg_add, add_comm] using h'

private lemma add_self_eq_neg_of_self_add_eq_neg {x b : G}
    (h : x + b = -x) :
    x + x = -b := by
  have h' : -x + -b = x := by
    have h'' := congrArg Neg.neg h
    simpa [neg_add, add_comm] using h''
  exact add_self_eq_of_neg_add_eq_self h'

private lemma zero_of_add_right_eq_self {x v : G}
    (h : x + v = x) : v = 0 := by
  have h' := congrArg (fun t => -x + t) h
  simpa [add_assoc] using h'

private lemma neg_eq_self_of_add_self_eq_zero {v : G}
    (hv2 : v + v = 0) : -v = v := by
  have h' := congrArg (fun t => -v + t) hv2
  simpa [add_assoc] using h'.symm

private lemma eq_of_add_right_eq_zero_of_order_two {x v : G}
    (hv2 : v + v = 0) (h : x + v = 0) : x = v := by
  have hx : x = -v := by
    have h' := congrArg (fun t => t + -v) h
    simpa [add_assoc] using h'
  simpa [neg_eq_self_of_add_self_eq_zero hv2] using hx

private lemma add_v_add_v_eq_add_self {x v : G}
    (hv2 : v + v = 0) : (x + v) + (x + v) = x + x := by
  calc
    (x + v) + (x + v) = x + x + (v + v) := by abel
    _ = x + x := by simp [hv2]

private lemma add_self_eq_of_add_v_add_v_eq {x v c : G}
    (hv2 : v + v = 0) (h : (x + v) + (x + v) = c) :
    x + x = c := by
  rw [← h]
  exact (add_v_add_v_eq_add_self hv2).symm

private lemma add_self_eq_add_v_of_add_v_add_self_eq {x v c : G}
    (hv2 : v + v = 0) (h : (x + v) + x = c) :
    x + x = c + v := by
  rw [← h]
  calc
    x + x = ((x + v) + x) + v := by
      rw [show ((x + v) + x) + v = x + x + (v + v) by abel]
      simp [hv2]
    _ = (x + v) + x + v := rfl

private lemma add_self_eq_add_v_of_self_add_add_v_eq {x v c : G}
    (hv2 : v + v = 0) (h : x + (x + v) = c) :
    x + x = c + v := by
  rw [← h]
  calc
    x + x = (x + (x + v)) + v := by
      rw [show (x + (x + v)) + v = x + x + (v + v) by abel]
      simp [hv2]
    _ = x + (x + v) + v := rfl

private lemma add_tau_right_eq_of_add_v_add_eq {x v a b : G}
    (h : (x + v) + a = b) : x + (a + v) = b := by
  rw [← h]
  abel

private lemma add_tau_left_eq_of_add_add_v_eq {x v a b : G}
    (h : a + (x + v) = b) : (a + v) + x = b := by
  rw [← h]
  abel

private lemma add_tau_left_eq_of_add_eq_add_v {x v a b : G}
    (hv2 : v + v = 0) (h : a + b = x + v) :
    (a + v) + b = x := by
  have h' := congrArg (fun t => t + v) h
  calc
    (a + v) + b = (a + b) + v := by abel
    _ = (x + v) + v := h'
    _ = x + (v + v) := by abel
    _ = x := by simp [hv2]

private lemma eq_v_of_add_v_add_self_eq_self {x v : G}
    (hv2 : v + v = 0) (h : (x + v) + x = x) : x = v := by
  have hy0 : x + v = 0 := by
    have h' := congrArg (fun t => t + -x) h
    simpa [add_assoc, add_comm, add_left_comm] using h'
  exact eq_of_add_right_eq_zero_of_order_two hv2 hy0

private lemma eq_v_of_self_add_add_v_eq_self {x v : G}
    (hv2 : v + v = 0) (h : x + (x + v) = x) : x = v := by
  have hy0 : x + v = 0 := by
    have h' := congrArg (fun t => t + -x) h
    simpa [add_assoc, add_comm, add_left_comm] using h'
  exact eq_of_add_right_eq_zero_of_order_two hv2 hy0

private lemma eq_v_of_add_self_eq_add_v {x v : G}
    (h : x + x = x + v) : x = v := by
  have h' := congrArg (fun t => -x + t) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma zero_of_add_v_add_self_eq_add_v {x v : G}
    (h : (x + v) + x = x + v) : x = 0 := by
  have h' := congrArg (fun t => t + -(x + v)) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma zero_of_self_add_add_v_eq_add_v {x v : G}
    (h : x + (x + v) = x + v) : x = 0 := by
  have h' := congrArg (fun t => t + -(x + v)) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma eq_v_of_self_add_eq_add_v {x v b : G}
    (h : x + b = x + v) : b = v := by
  have h' := congrArg (fun t => -x + t) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma eq_v_of_add_self_eq_add_v' {x v a : G}
    (h : a + x = x + v) : a = v := by
  have h' := congrArg (fun t => t + -x) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma eq_neg_of_add_v_add_eq_self {x v a : G}
    (h : (x + v) + a = x) : a = -v := by
  have h0 : v + a = 0 := by
    calc
      v + a = -x + ((x + v) + a) := by abel
      _ = -x + x := by rw [h]
      _ = 0 := by simp
  exact eq_neg_of_add_eq_zero_right h0

private lemma eq_neg_of_add_add_v_eq_self {x v a : G}
    (h : a + (x + v) = x) : a = -v := by
  have h0 : v + a = 0 := by
    calc
      v + a = -x + (a + (x + v)) := by abel
      _ = -x + x := by rw [h]
      _ = 0 := by simp
  exact eq_neg_of_add_eq_zero_right h0

private lemma zero_of_add_v_add_eq_add_v {x v b : G}
    (h : (x + v) + b = x + v) : b = 0 := by
  calc
    b = -(x + v) + ((x + v) + b) := by abel
    _ = -(x + v) + (x + v) := by rw [h]
    _ = 0 := by simp

private lemma zero_of_add_add_v_eq_add_v {x v a : G}
    (h : a + (x + v) = x + v) : a = 0 := by
  calc
    a = -(x + v) + (a + (x + v)) := by abel
    _ = -(x + v) + (x + v) := by rw [h]
    _ = 0 := by simp

/--
Negation mirror step.

Paper source: cyclic Lemma 1, but the proof is group-general. The two excluded
obstructions are the fixed point `-x = x` and the order-three collision
`x + x = -x`.
-/
theorem neg_mirror_legal
    {A : Set G} {x : G}
    (hA : SumFree A)
    (hneg : NegInvariant A)
    (hx : Legal A x)
    (hx_ne_neg : -x ≠ x)
    (hx_no_o3 : x + x ≠ -x) :
    Legal (insert x A) (-x) := by
  constructor
  · intro hmem
    rcases hmem with hxneg | hAneg
    · exact hx_ne_neg hxneg
    · exact hx.1 (by simpa using hneg hAneg)
  · intro a b c ha hb hc hsum
    have hxmem : x ∈ insert x A := Or.inl rfl
    have hAins {z : G} (hz : z ∈ A) : z ∈ insert x A := Or.inr hz
    have hxins {z : G} (hz : z = x) : z ∈ insert x A := by
      rw [hz]
      exact hxmem
    have hAzero {z : G} (hz : z ∈ A) (hz0 : z = 0) : False := by
      subst z
      exact hA hz hz hz (by simp)
    have hnegA {z : G} (hz : z ∈ A) : -z ∈ A := hneg hz
    have classify {z : G} (hz : z ∈ insert (-x) (insert x A)) :
        z = -x ∨ z = x ∨ z ∈ A := by
      rcases hz with hz_neg | hz_rest
      · exact Or.inl hz_neg
      · rcases hz_rest with hz_x | hz_A
        · exact Or.inr (Or.inl hz_x)
        · exact Or.inr (Or.inr hz_A)
    rcases classify ha with haNeg | haX | haA
    · rcases classify hb with hbNeg | hbX | hbA
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : -x + -x = -x := by simpa [haNeg, hbNeg, hcNeg] using hsum
          exact hx_ne_neg (neg_eq_self_of_neg_add_neg_eq_neg h)
        · have h : -x + -x = x := by simpa [haNeg, hbNeg, hcX] using hsum
          exact hx_no_o3 (add_self_eq_neg_of_neg_add_neg_eq h)
        · have h : -x + -x = c := by simpa [haNeg, hbNeg] using hsum
          exact hx.2 hxmem hxmem (hAins (hnegA hcA))
            (add_self_eq_neg_of_neg_add_neg_eq h)
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : -x + x = -x := by simpa [haNeg, hbX, hcNeg] using hsum
          exact hx_ne_neg (neg_eq_self_of_neg_add_self_eq_neg h)
        · have h : -x + x = x := by simpa [haNeg, hbX, hcX] using hsum
          exact hx_ne_neg (neg_eq_self_of_neg_add_self_eq_self h)
        · have h : c = 0 := by
            have h' : -x + x = c := by simpa [haNeg, hbX] using hsum
            simpa using h'.symm
          exact hAzero hcA h
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : -x + b = -x := by simpa [haNeg, hcNeg] using hsum
          exact hAzero hbA (zero_of_neg_add_eq_neg h)
        · have h : -x + b = x := by simpa [haNeg, hcX] using hsum
          exact hx.2 hxmem hxmem (hAins hbA) (add_self_eq_of_neg_add_eq_self h)
        · have h : -x + b = c := by simpa [haNeg] using hsum
          exact hx.2 hxmem (hAins hcA) (hAins hbA) (left_add_eq_of_neg_add_eq h)
    · rcases classify hb with hbNeg | hbX | hbA
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : -x + x = -x := by simpa [add_comm, haX, hbNeg, hcNeg] using hsum
          exact hx_ne_neg (neg_eq_self_of_neg_add_self_eq_neg h)
        · have h : -x + x = x := by simpa [add_comm, haX, hbNeg, hcX] using hsum
          exact hx_ne_neg (neg_eq_self_of_neg_add_self_eq_self h)
        · have h : c = 0 := by
            have h' : -x + x = c := by simpa [add_comm, haX, hbNeg] using hsum
            simpa using h'.symm
          exact hAzero hcA h
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : x + x = -x := by simpa [haX, hbX, hcNeg] using hsum
          exact hx_no_o3 h
        · exact hx.2 (hxins haX) (hxins hbX) (hxins hcX) hsum
        · exact hx.2 (hxins haX) (hxins hbX) (hAins hcA) hsum
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : x + b = -x := by simpa [haX, hcNeg] using hsum
          exact hx.2 hxmem hxmem (hAins (hnegA hbA))
            (add_self_eq_neg_of_self_add_eq_neg h)
        · exact hx.2 (hxins haX) (hAins hbA) (hxins hcX) hsum
        · exact hx.2 (hxins haX) (hAins hbA) (hAins hcA) hsum
    · rcases classify hb with hbNeg | hbX | hbA
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : -x + a = -x := by simpa [add_comm, hbNeg, hcNeg] using hsum
          exact hAzero haA (zero_of_neg_add_eq_neg h)
        · have h : -x + a = x := by simpa [add_comm, hbNeg, hcX] using hsum
          exact hx.2 hxmem hxmem (hAins haA) (add_self_eq_of_neg_add_eq_self h)
        · have h : a + -x = c := by simpa [hbNeg] using hsum
          exact hx.2 hxmem (hAins hcA) (hAins haA) (right_add_eq_of_add_neg_eq h)
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : x + a = -x := by simpa [add_comm, hbX, hcNeg] using hsum
          exact hx.2 hxmem hxmem (hAins (hnegA haA))
            (add_self_eq_neg_of_self_add_eq_neg h)
        · exact hx.2 (hAins haA) (hxins hbX) (hxins hcX) hsum
        · exact hx.2 (hAins haA) (hxins hbX) (hAins hcA) hsum
      · rcases classify hc with hcNeg | hcX | hcA
        · have h : a + b = -x := by simpa [hcNeg] using hsum
          exact hx.2 (hAins (hnegA haA)) (hAins (hnegA hbA)) hxmem
            (neg_add_neg_eq_of_add_eq_neg h)
        · exact hx.2 (hAins haA) (hAins hbA) (hxins hcX) hsum
        · exact hA haA hbA hcA hsum

/--
Translation mirror step for a nonzero order-two translation.

Paper source: cyclic Lemma 2, group-general.
-/
theorem tau_mirror_legal
    {A : Set G} {v x : G}
    (hv2 : v + v = 0)
    (hv0 : v ≠ 0)
    (hA : SumFree A)
    (htau : TauInvariant v A)
    (hx : Legal A x)
    (hx_ne_v : x ≠ v) :
    Legal (insert x A) (x + v) := by
  constructor
  · intro hmem
    rcases hmem with hEqX | hAxy
    · exact hv0 (zero_of_add_right_eq_self hEqX)
    · exact hx.1 ((htau (x := x)).mpr hAxy)
  · intro a b c ha hb hc hsum
    have hxmem : x ∈ insert x A := Or.inl rfl
    have hAins {z : G} (hz : z ∈ A) : z ∈ insert x A := Or.inr hz
    have hxins {z : G} (hz : z = x) : z ∈ insert x A := by
      rw [hz]
      exact hxmem
    have htauA {z : G} (hz : z ∈ A) : z + v ∈ A := (htau (x := z)).mp hz
    have hAzero {z : G} (hz : z ∈ A) (hz0 : z = 0) : False := by
      subst z
      exact hA hz hz hz (by simp)
    have hAv (hvA : v ∈ A) : False := by
      have h0A : 0 ∈ A := by
        have hvvA : v + v ∈ A := htauA hvA
        simpa [hv2] using hvvA
      exact hA h0A h0A h0A (by simp)
    have hAnegv {z : G} (hzA : z ∈ A) (hz : z = -v) : False := by
      have hvA : v ∈ A := by
        simpa [hz, neg_eq_self_of_add_self_eq_zero hv2] using hzA
      exact hAv hvA
    have classify {z : G} (hz : z ∈ insert (x + v) (insert x A)) :
        z = x + v ∨ z = x ∨ z ∈ A := by
      rcases hz with hz_y | hz_rest
      · exact Or.inl hz_y
      · rcases hz_rest with hz_x | hz_A
        · exact Or.inr (Or.inl hz_x)
        · exact Or.inr (Or.inr hz_A)
    rcases classify ha with haY | haX | haA
    · rcases classify hb with hbY | hbX | hbA
      · rcases classify hc with hcY | hcX | hcA
        · have h : (x + v) + (x + v) = x + v := by simpa [haY, hbY, hcY] using hsum
          exact hx_ne_v (eq_v_of_add_self_eq_add_v (add_self_eq_of_add_v_add_v_eq hv2 h))
        · have h : (x + v) + (x + v) = x := by simpa [haY, hbY, hcX] using hsum
          exact hx.2 hxmem hxmem hxmem (add_self_eq_of_add_v_add_v_eq hv2 h)
        · have h : (x + v) + (x + v) = c := by simpa [haY, hbY] using hsum
          exact hx.2 hxmem hxmem (hAins hcA) (add_self_eq_of_add_v_add_v_eq hv2 h)
      · rcases classify hc with hcY | hcX | hcA
        · have h : (x + v) + x = x + v := by simpa [haY, hbX, hcY] using hsum
          have hx0 : x = 0 := zero_of_add_v_add_self_eq_add_v h
          exact hx.2 hxmem hxmem hxmem (by simp [hx0])
        · have h : (x + v) + x = x := by simpa [haY, hbX, hcX] using hsum
          exact hx_ne_v (eq_v_of_add_v_add_self_eq_self hv2 h)
        · have h : (x + v) + x = c := by simpa [haY, hbX] using hsum
          exact hx.2 hxmem hxmem (hAins (htauA hcA))
            (add_self_eq_add_v_of_add_v_add_self_eq hv2 h)
      · rcases classify hc with hcY | hcX | hcA
        · have h : (x + v) + b = x + v := by simpa [haY, hcY] using hsum
          exact hAzero hbA (zero_of_add_v_add_eq_add_v h)
        · have h : (x + v) + b = x := by simpa [haY, hcX] using hsum
          exact hAnegv hbA (eq_neg_of_add_v_add_eq_self h)
        · have h : (x + v) + b = c := by simpa [haY] using hsum
          exact hx.2 hxmem (hAins (htauA hbA)) (hAins hcA)
            (add_tau_right_eq_of_add_v_add_eq h)
    · rcases classify hb with hbY | hbX | hbA
      · rcases classify hc with hcY | hcX | hcA
        · have h : x + (x + v) = x + v := by simpa [haX, hbY, hcY] using hsum
          have hx0 : x = 0 := zero_of_self_add_add_v_eq_add_v h
          exact hx.2 hxmem hxmem hxmem (by simp [hx0])
        · have h : x + (x + v) = x := by simpa [haX, hbY, hcX] using hsum
          exact hx_ne_v (eq_v_of_self_add_add_v_eq_self hv2 h)
        · have h : x + (x + v) = c := by simpa [haX, hbY] using hsum
          exact hx.2 hxmem hxmem (hAins (htauA hcA))
            (add_self_eq_add_v_of_self_add_add_v_eq hv2 h)
      · rcases classify hc with hcY | hcX | hcA
        · have h : x + x = x + v := by simpa [haX, hbX, hcY] using hsum
          exact hx_ne_v (eq_v_of_add_self_eq_add_v h)
        · exact hx.2 (hxins haX) (hxins hbX) (hxins hcX) hsum
        · exact hx.2 (hxins haX) (hxins hbX) (hAins hcA) hsum
      · rcases classify hc with hcY | hcX | hcA
        · have h : x + b = x + v := by simpa [haX, hcY] using hsum
          exact hAv (by simpa [eq_v_of_self_add_eq_add_v h] using hbA)
        · exact hx.2 (hxins haX) (hAins hbA) (hxins hcX) hsum
        · exact hx.2 (hxins haX) (hAins hbA) (hAins hcA) hsum
    · rcases classify hb with hbY | hbX | hbA
      · rcases classify hc with hcY | hcX | hcA
        · have h : a + (x + v) = x + v := by simpa [hbY, hcY] using hsum
          exact hAzero haA (zero_of_add_add_v_eq_add_v h)
        · have h : a + (x + v) = x := by simpa [hbY, hcX] using hsum
          exact hAnegv haA (eq_neg_of_add_add_v_eq_self h)
        · have h : a + (x + v) = c := by simpa [hbY] using hsum
          exact hx.2 (hAins (htauA haA)) hxmem (hAins hcA)
            (add_tau_left_eq_of_add_add_v_eq h)
      · rcases classify hc with hcY | hcX | hcA
        · have h : a + x = x + v := by simpa [hbX, hcY] using hsum
          exact hAv (by simpa [eq_v_of_add_self_eq_add_v' h] using haA)
        · exact hx.2 (hAins haA) (hxins hbX) (hxins hcX) hsum
        · exact hx.2 (hAins haA) (hxins hbX) (hAins hcA) hsum
      · rcases classify hc with hcY | hcX | hcA
        · have h : a + b = x + v := by simpa [hcY] using hsum
          exact hx.2 (hAins (htauA haA)) (hAins hbA) hxmem
            (add_tau_left_eq_of_add_eq_add_v hv2 h)
        · exact hx.2 (hAins haA) (hAins hbA) (hxins hcX) hsum
        · exact hA haA hbA hcA hsum

/--
The translation mirror's exceptional point self-blocks once a nonempty
`tau_v`-invariant position exists. This fact is stronger than the order-two
mirror setting: the proof only uses translation-invariance, not `v + v = 0`.

Paper source: cyclic Lemma 3, group-general.
-/
theorem tau_self_blocks
    {A : Set G} {v : G}
    (hne : A.Nonempty)
    (htau : TauInvariant v A) :
    ¬ Legal A v := by
  intro hvleg
  rcases hne with ⟨z, hz⟩
  have hzv : z + v ∈ A := (htau.mp hz)
  exact hvleg.2 (Or.inr hz) (Or.inl rfl) (Or.inr hzv) rfl

section CharThree

variable {V : Type*} [AddCommGroup V]

/-- Affine reflection used for the `F_3^n` first-player mirror. -/
def sigmaF3 (o y : V) : V :=
  -o - y

/-- Invariance under the affine reflection `y |-> -o-y`. -/
def SigmaInvariant (o : V) (A : Set V) : Prop :=
  forall {x : V}, x ∈ A ↔ sigmaF3 o x ∈ A

private lemma add_self_eq_neg_of_char3
    (hchar3 : forall z : V, z + z + z = 0) (z : V) :
    z + z = -z := by
  have h := hchar3 z
  have h' := congrArg (fun t => t + -z) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private lemma sigmaF3_involutive (o y : V) :
    sigmaF3 o (sigmaF3 o y) = y := by
  unfold sigmaF3
  abel

private lemma sigmaF3_fixed_eq_center
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : sigmaF3 o y = y) : y = o := by
  unfold sigmaF3 at h
  have hy : y + y = -y := add_self_eq_neg_of_char3 hchar3 y
  have h' : -o = y + y := by
    calc
      -o = (-o - y) + y := by abel
      _ = y + y := by rw [h]
  have hneg : -o = -y := by simpa [hy] using h'
  have h2 := congrArg Neg.neg hneg
  simpa using h2.symm

private lemma neg_add_neg_eq_self_of_char3'
    (hchar3 : forall z : V, z + z + z = 0) (z : V) :
    -z + -z = z := by
  simpa using add_self_eq_neg_of_char3 hchar3 (-z)

private lemma sigmaF3_add_self
    (hchar3 : forall z : V, z + z + z = 0) (o y : V) :
    sigmaF3 o y + sigmaF3 o y = o + y := by
  unfold sigmaF3
  rw [show (-o - y) + (-o - y) = (-o + -o) + (-y + -y) by abel]
  rw [neg_add_neg_eq_self_of_char3' hchar3 o,
      neg_add_neg_eq_self_of_char3' hchar3 y]

private lemma sigmaF3_add_arg (o y : V) :
    sigmaF3 o y + y = -o := by
  unfold sigmaF3
  abel

private lemma arg_add_sigmaF3 (o y : V) :
    y + sigmaF3 o y = -o := by
  rw [add_comm, sigmaF3_add_arg]

private lemma arg_add_arg_eq_base_of_sigma_eq_zero
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : sigmaF3 o y = 0) :
    y + y = o := by
  have hy : y = -o := by
    have h' := congrArg (fun t => t + y) h
    simpa [sigmaF3, sub_eq_add_neg, add_assoc, add_comm, add_left_comm] using h'.symm
  rw [hy]
  exact neg_add_neg_eq_self_of_char3' hchar3 o

private lemma base_eq_zero_of_sigma_add_self_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : sigmaF3 o y + sigmaF3 o y = y) :
    o = 0 := by
  have h' : o + y = y := by
    rw [← sigmaF3_add_self hchar3 o y]
    exact h
  exact zero_of_add_right_eq_self (x := y) (v := o) (by simpa [add_comm] using h')

private lemma arg_add_arg_eq_base_of_sigma_add_self_eq_self
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : sigmaF3 o y + sigmaF3 o y = sigmaF3 o y) :
    y + y = o := by
  have hz0 : sigmaF3 o y = 0 := zero_of_add_right_eq_self h
  exact arg_add_arg_eq_base_of_sigma_eq_zero hchar3 hz0

private lemma arg_add_base_eq_of_sigma_add_self_eq
    (hchar3 : forall z : V, z + z + z = 0) {o y t : V}
    (h : sigmaF3 o y + sigmaF3 o y = t) :
    y + o = t := by
  rw [← h, sigmaF3_add_self hchar3 o y, add_comm]

private lemma arg_add_arg_eq_base_of_sigma_add_arg_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : sigmaF3 o y + y = y) :
    y + y = o := by
  have hz0 : sigmaF3 o y = 0 := by
    have h' := congrArg (fun t => t + -y) h
    simpa [add_assoc, add_comm, add_left_comm] using h'
  exact arg_add_arg_eq_base_of_sigma_eq_zero hchar3 hz0

private lemma old_add_old_eq_base_of_sigma_add_arg_eq_old
    (hchar3 : forall z : V, z + z + z = 0) {o y t : V}
    (h : sigmaF3 o y + y = t) :
    t + t = o := by
  have ht : t = -o := by
    rw [← h, sigmaF3_add_arg]
  rw [ht]
  exact neg_add_neg_eq_self_of_char3' hchar3 o

private lemma arg_add_old_eq_base_of_sigma_add_old_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {o y d : V}
    (h : sigmaF3 o y + d = y) :
    y + d = o := by
  have hd : d = y - sigmaF3 o y := by
    calc
      d = -(sigmaF3 o y) + (sigmaF3 o y + d) := by abel
      _ = -(sigmaF3 o y) + y := by rw [h]
      _ = y - sigmaF3 o y := by abel
  rw [hd]
  unfold sigmaF3
  abel_nf
  have hy3 := hchar3 y
  abel_nf at hy3
  rw [hy3]
  simp

private lemma old_add_sigma_old_eq_arg_of_sigma_add_old_eq_old
    {o y d e : V} (h : sigmaF3 o y + d = e) :
    d + sigmaF3 o e = y := by
  rw [← h]
  unfold sigmaF3
  abel

private lemma arg_add_arg_eq_sigma_old_of_arg_add_old_eq_sigma
    (hchar3 : forall z : V, z + z + z = 0) {o y d : V}
    (h : y + d = sigmaF3 o y) :
    y + y = sigmaF3 o d := by
  unfold sigmaF3 at h ⊢
  have hd : d = -o - y - y := by
    calc
      d = -y + (y + d) := by abel
      _ = -y + (-o - y) := by rw [h]
      _ = -o - y - y := by abel
  calc
    y + y = -y := add_self_eq_neg_of_char3 hchar3 y
    _ = -o - d := by
      rw [hd]
      calc
        -y = y + y := (add_self_eq_neg_of_char3 hchar3 y).symm
        _ = -o - (-o - y - y) := by abel

private lemma base_eq_zero_of_arg_add_arg_eq_sigma
    (hchar3 : forall z : V, z + z + z = 0) {o y : V}
    (h : y + y = sigmaF3 o y) :
    o = 0 := by
  have hy : y + y = -y := add_self_eq_neg_of_char3 hchar3 y
  have hs : -y = sigmaF3 o y := by simpa [hy] using h
  unfold sigmaF3 at hs
  have h' := congrArg (fun t => t + y) hs
  have : -o = 0 := by simpa [add_assoc, add_comm, add_left_comm] using h'
  have hneg := congrArg Neg.neg this
  simpa using hneg

private lemma old_add_arg_eq_sigma_other_of_old_add_old_eq_sigma
    {o y d e : V} (h : d + e = sigmaF3 o y) :
    d + y = sigmaF3 o e := by
  calc
    d + y = (d + e + y) - e := by abel
    _ = (sigmaF3 o y + y) - e := by rw [h]
    _ = sigmaF3 o e := by unfold sigmaF3; abel

/--
The affine `F₃` mirror reply is fresh once the centre `o` is already occupied.

If `sigmaF3 o y = y`, then `y = o` in exponent three; otherwise membership of
`sigmaF3 o y` in the old symmetric position reflects back to illegal membership
of `y`.
-/
theorem f3_affine_mirror_fresh
    {A : Set V} {o y : V}
    (hchar3 : forall z : V, z + z + z = 0)
    (hsigma : SigmaInvariant o A)
    (hy : Legal A y)
    (hy_ne_o : y ≠ o) :
    sigmaF3 o y ∉ insert y A := by
  intro hmem
  rcases hmem with hz_y | hz_A
  · exact hy_ne_o (sigmaF3_fixed_eq_center hchar3 hz_y)
  · exact hy.1 ((hsigma (x := y)).mpr hz_A)

/--
Affine mirror step in exponent-three groups.

This is the local theorem behind `F3^n = N`: after opening `o`, the
first player replies to `y` with `-o-y`.
-/
theorem f3_affine_mirror_legal
    {A : Set V} {o y : V}
    (hchar3 : forall z : V, z + z + z = 0)
    (hA : SumFree A)
    (hoA : o ∈ A)
    (hsigma : SigmaInvariant o A)
    (hy : Legal A y)
    (hy_ne_o : y ≠ o)
    (ho0 : o ≠ 0) :
    Legal (insert y A) (sigmaF3 o y) := by
  constructor
  · exact f3_affine_mirror_fresh hchar3 hsigma hy hy_ne_o
  · intro p q r hp hq hr hsum
    have hyMem : y ∈ insert y A := Or.inl rfl
    have hoMem : o ∈ insert y A := Or.inr hoA
    have hYins {t : V} (ht : t = y) : t ∈ insert y A := by
      rw [ht]
      exact hyMem
    have hAins {t : V} (ht : t ∈ A) : t ∈ insert y A := Or.inr ht
    have hSigA {t : V} (ht : t ∈ A) : sigmaF3 o t ∈ A :=
      (hsigma (x := t)).mp ht
    have hSigIns {t : V} (ht : t ∈ A) : sigmaF3 o t ∈ insert y A :=
      hAins (hSigA ht)
    have hAzero {t : V} (ht : t ∈ A) (ht0 : t = 0) : False := by
      subst t
      exact hA ht ht ht (by simp)
    have hyZero (hy0 : y = 0) : False := by
      subst y
      exact hy.2 hyMem hyMem hyMem (by simp)
    have classify {t : V} (ht : t ∈ insert (sigmaF3 o y) (insert y A)) :
        t = sigmaF3 o y ∨ t = y ∨ t ∈ A := by
      rcases ht with ht_sigma | ht_rest
      · exact Or.inl ht_sigma
      · rcases ht_rest with ht_y | ht_A
        · exact Or.inr (Or.inl ht_y)
        · exact Or.inr (Or.inr ht_A)
    rcases classify hp with hpSigma | hpY | hpA
    · rcases classify hq with hqSigma | hqY | hqA
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : sigmaF3 o y + sigmaF3 o y = sigmaF3 o y := by
            simpa [hpSigma, hqSigma, hrSigma] using hsum
          exact hy.2 hyMem hyMem hoMem
            (arg_add_arg_eq_base_of_sigma_add_self_eq_self hchar3 h)
        · have h : sigmaF3 o y + sigmaF3 o y = y := by
            simpa [hpSigma, hqSigma, hrY] using hsum
          exact ho0 (base_eq_zero_of_sigma_add_self_eq_arg hchar3 h)
        · have h : sigmaF3 o y + sigmaF3 o y = r := by
            simpa [hpSigma, hqSigma] using hsum
          exact hy.2 hyMem hoMem (hAins hrA)
            (arg_add_base_eq_of_sigma_add_self_eq hchar3 h)
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : sigmaF3 o y + y = sigmaF3 o y := by
            simpa [hpSigma, hqY, hrSigma] using hsum
          exact hyZero (zero_of_add_right_eq_self h)
        · have h : sigmaF3 o y + y = y := by
            simpa [hpSigma, hqY, hrY] using hsum
          exact hy.2 hyMem hyMem hoMem
            (arg_add_arg_eq_base_of_sigma_add_arg_eq_arg hchar3 h)
        · have h : sigmaF3 o y + y = r := by
            simpa [hpSigma, hqY] using hsum
          exact hA hrA hrA hoA
            (old_add_old_eq_base_of_sigma_add_arg_eq_old hchar3 h)
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : sigmaF3 o y + q = sigmaF3 o y := by
            simpa [hpSigma, hrSigma] using hsum
          exact hAzero hqA (zero_of_add_right_eq_self h)
        · have h : sigmaF3 o y + q = y := by
            simpa [hpSigma, hrY] using hsum
          exact hy.2 hyMem (hAins hqA) hoMem
            (arg_add_old_eq_base_of_sigma_add_old_eq_arg hchar3 h)
        · have h : sigmaF3 o y + q = r := by
            simpa [hpSigma] using hsum
          exact hy.2 (hAins hqA) (hSigIns hrA) hyMem
            (old_add_sigma_old_eq_arg_of_sigma_add_old_eq_old h)
    · rcases classify hq with hqSigma | hqY | hqA
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : sigmaF3 o y + y = sigmaF3 o y := by
            simpa [add_comm, hpY, hqSigma, hrSigma] using hsum
          exact hyZero (zero_of_add_right_eq_self h)
        · have h : sigmaF3 o y + y = y := by
            simpa [add_comm, hpY, hqSigma, hrY] using hsum
          exact hy.2 hyMem hyMem hoMem
            (arg_add_arg_eq_base_of_sigma_add_arg_eq_arg hchar3 h)
        · have h : sigmaF3 o y + y = r := by
            simpa [add_comm, hpY, hqSigma] using hsum
          exact hA hrA hrA hoA
            (old_add_old_eq_base_of_sigma_add_arg_eq_old hchar3 h)
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : y + y = sigmaF3 o y := by
            simpa [hpY, hqY, hrSigma] using hsum
          exact ho0 (base_eq_zero_of_arg_add_arg_eq_sigma hchar3 h)
        · exact hy.2 (hYins hpY) (hYins hqY) (hYins hrY) hsum
        · exact hy.2 (hYins hpY) (hYins hqY) (hAins hrA) hsum
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : y + q = sigmaF3 o y := by
            simpa [hpY, hrSigma] using hsum
          exact hy.2 hyMem hyMem (hSigIns hqA)
            (arg_add_arg_eq_sigma_old_of_arg_add_old_eq_sigma hchar3 h)
        · exact hy.2 (hYins hpY) (hAins hqA) (hYins hrY) hsum
        · exact hy.2 (hYins hpY) (hAins hqA) (hAins hrA) hsum
    · rcases classify hq with hqSigma | hqY | hqA
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : sigmaF3 o y + p = sigmaF3 o y := by
            simpa [add_comm, hqSigma, hrSigma] using hsum
          exact hAzero hpA (zero_of_add_right_eq_self h)
        · have h : sigmaF3 o y + p = y := by
            simpa [add_comm, hqSigma, hrY] using hsum
          exact hy.2 hyMem (hAins hpA) hoMem
            (arg_add_old_eq_base_of_sigma_add_old_eq_arg hchar3 h)
        · have h : sigmaF3 o y + p = r := by
            simpa [add_comm, hqSigma] using hsum
          exact hy.2 (hAins hpA) (hSigIns hrA) hyMem
            (old_add_sigma_old_eq_arg_of_sigma_add_old_eq_old h)
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : y + p = sigmaF3 o y := by
            simpa [add_comm, hqY, hrSigma] using hsum
          exact hy.2 hyMem hyMem (hSigIns hpA)
            (arg_add_arg_eq_sigma_old_of_arg_add_old_eq_sigma hchar3 h)
        · exact hy.2 (hAins hpA) (hYins hqY) (hYins hrY) hsum
        · exact hy.2 (hAins hpA) (hYins hqY) (hAins hrA) hsum
      · rcases classify hr with hrSigma | hrY | hrA
        · have h : p + q = sigmaF3 o y := by
            simpa [hrSigma] using hsum
          exact hy.2 (hAins hpA) hyMem (hSigIns hqA)
            (old_add_arg_eq_sigma_other_of_old_add_old_eq_sigma h)
        · exact hy.2 (hAins hpA) (hAins hqA) (hYins hrY) hsum
        · exact hA hpA hqA hrA hsum

end CharThree

end Sumfree
