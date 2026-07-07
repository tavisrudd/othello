import Sumfree.Game
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# Cyclic `ZMod n` sum-free game bridges

This file records concrete cyclic consequences of the abstract mirror theorems
in `Sumfree.Game`.  It is intentionally partial: the full mod-6 theorem still
needs the order-three extra-reply cases.
-/

namespace Sumfree
namespace CyclicZMod

open Sumfree.Game

section AbstractPairs

variable {H : Type*} [AddCommGroup H]

private theorem zero_of_add_self_eq_self {x : H} (h : x + x = x) : x = 0 := by
  have h' := congrArg (fun z => z + -x) h
  simpa [add_assoc] using h'

private theorem zero_of_add_right_eq_left {x y : H} (h : x + y = x) : y = 0 := by
  have h' := congrArg (fun z => -x + z) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

private theorem zero_of_add_left_eq_right {x y : H} (h : x + y = y) : x = 0 := by
  have h' := congrArg (fun z => z + -y) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

variable [DecidableEq H]

/--
Abstract two-point validity lemma used by the even `3 ∣ n` cyclic branch.
The pair consists of an order-two blocker `m` and an order-three anchor `t`.
-/
theorem valid_pair_orderTwo_orderThree {m t : H}
    (hm2 : m + m = 0) (hm0 : m ≠ 0)
    (ht2 : t + t = -t) (ht0 : t ≠ 0)
    (hm_ne_negt : m ≠ -t) :
    Valid (insert t ({m} : Finset H)) := by
  intro a b c ha hb hc hsum
  simp only [Finset.mem_coe, Finset.mem_insert, Finset.mem_singleton] at ha hb hc
  rcases ha with haT | haM
  · rcases hb with hbT | hbM
    · rcases hc with hcT | hcM
      · have h : t + t = t := by simpa [haT, hbT, hcT] using hsum
        exact ht0 (zero_of_add_self_eq_self h)
      · have h : t + t = m := by simpa [haT, hbT, hcM] using hsum
        have hm_eq_negt : m = -t := by
          rw [← h]
          exact ht2
        exact hm_ne_negt hm_eq_negt
    · rcases hc with hcT | hcM
      · have h : t + m = t := by simpa [haT, hbM, hcT] using hsum
        exact hm0 (zero_of_add_right_eq_left h)
      · have h : t + m = m := by simpa [haT, hbM, hcM] using hsum
        exact ht0 (zero_of_add_left_eq_right h)
  · rcases hb with hbT | hbM
    · rcases hc with hcT | hcM
      · have h : m + t = t := by simpa [haM, hbT, hcT] using hsum
        exact hm0 (zero_of_add_left_eq_right h)
      · have h : m + t = m := by simpa [haM, hbT, hcM] using hsum
        exact ht0 (zero_of_add_right_eq_left h)
    · rcases hc with hcT | hcM
      · have h : m + m = t := by simpa [haM, hbM, hcT] using hsum
        exact ht0 (by simpa [hm2] using h.symm)
      · have h : m + m = m := by simpa [haM, hbM, hcM] using hsum
        exact hm0 (by simpa [hm2] using h.symm)

end AbstractPairs

private theorem natCast_ne_zero_of_pos_of_lt {n a : ℕ} [NeZero n]
    (ha0 : 0 < a) (han : a < n) :
    (a : ZMod n) ≠ 0 := by
  intro hzero
  have hdiv : n ∣ a := (ZMod.natCast_eq_zero_iff a n).1 hzero
  exact (Nat.not_dvd_of_pos_of_lt ha0 han) hdiv

/-- Odd cyclic groups have no nonzero order-two obstruction. -/
theorem nonzeroOrderTwoElements_card_eq_zero_of_odd {n : ℕ} [NeZero n] (hn : Odd n) :
    (NonzeroOrderTwoElements (G := ZMod n)).card = 0 := by
  apply Finset.card_eq_zero.mpr
  ext x
  constructor
  · intro hx
    rcases (mem_nonzeroOrderTwoElements (G := ZMod n) (v := x)).1 hx with ⟨hx2, hx0⟩
    exact (hx0 ((ZMod.add_self_eq_zero_iff_eq_zero hn).mp hx2)).elim
  · intro hx
    simp at hx

/-- In an even nonzero cyclic group, `n / 2` is the nonzero order-two element. -/
theorem half_mem_nonzeroOrderTwoElements_of_even {n : ℕ} [NeZero n] (hn : Even n) :
    ((n / 2 : ℕ) : ZMod n) ∈ NonzeroOrderTwoElements (G := ZMod n) := by
  refine (mem_nonzeroOrderTwoElements (G := ZMod n) (v := ((n / 2 : ℕ) : ZMod n))).2
    ⟨?_, ?_⟩
  · have htwon : 2 * (n / 2) = n := Nat.two_mul_div_two_of_even hn
    have hcast : (((2 * (n / 2) : ℕ) : ZMod n) = 0) := by
      rw [htwon, ZMod.natCast_self]
    simpa [Nat.cast_mul, two_mul] using hcast
  · intro hzero
    have hdiv : n ∣ n / 2 := (ZMod.natCast_eq_zero_iff (n / 2) n).1 hzero
    have htwon : 2 * (n / 2) = n := Nat.two_mul_div_two_of_even hn
    have hhalf_pos : 0 < n / 2 := by
      by_contra hnot
      have hzero' : n / 2 = 0 := Nat.eq_zero_of_not_pos hnot
      have hnzero : n = 0 := by
        rw [← htwon, hzero', mul_zero]
      exact (NeZero.ne n) hnzero
    have hnpos : 0 < n := Nat.pos_iff_ne_zero.2 (NeZero.ne n)
    have hhalf_lt : n / 2 < n := Nat.div_lt_self hnpos (by decide : 1 < 2)
    exact (Nat.not_dvd_of_pos_of_lt hhalf_pos hhalf_lt) hdiv

/-- In an even nonzero cyclic group, every nonzero order-two element is `n / 2`. -/
theorem eq_half_of_mem_nonzeroOrderTwoElements {n : ℕ} [NeZero n] {x : ZMod n}
    (hx : x ∈ NonzeroOrderTwoElements (G := ZMod n)) :
    x = ((n / 2 : ℕ) : ZMod n) := by
  rcases (mem_nonzeroOrderTwoElements (G := ZMod n) (v := x)).1 hx with ⟨hx2, hx0⟩
  have hxneg : -x = x := by
    have h := congrArg (fun t => -x + t) hx2
    simpa [add_assoc] using h.symm
  rcases (ZMod.neg_eq_self_iff x).1 hxneg with hxzero | hxval
  · exact (hx0 hxzero).elim
  · have hxval' : x.val = n / 2 := by omega
    calc
      x = (x.val : ZMod n) := (ZMod.natCast_zmod_val x).symm
      _ = ((n / 2 : ℕ) : ZMod n) := by rw [hxval']

/-- If `3 ∤ n`, the cyclic order-three obstruction forces `x = 0`. -/
theorem eq_zero_of_orderThree_obstruction_of_not_three_dvd {n : ℕ}
    (h3 : ¬ 3 ∣ n) {x : ZMod n} (hx3 : x + x = -x) :
    x = 0 := by
  have hsum : x + x + x = 0 := by
    rw [hx3]
    simp
  have hmul : ((3 : ℕ) : ZMod n) * x = 0 := by
    calc
      ((3 : ℕ) : ZMod n) * x = ((2 : ZMod n) + 1) * x := by norm_num
      _ = (2 : ZMod n) * x + 1 * x := by rw [add_mul]
      _ = x + x + x := by rw [two_mul, one_mul]
      _ = 0 := hsum
  let u : (ZMod n)ˣ :=
    ZMod.unitOfCoprime 3 ((Nat.Prime.coprime_iff_not_dvd Nat.prime_three).2 h3)
  rw [← ZMod.coe_unitOfCoprime 3 ((Nat.Prime.coprime_iff_not_dvd Nat.prime_three).2 h3)] at hmul
  rw [mul_comm] at hmul
  exact (Units.mul_left_eq_zero u).mp hmul

/-- Cyclic groups with `3 ∤ n` have no nonzero order-three obstruction. -/
theorem nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd {n : ℕ} [NeZero n]
    (h3 : ¬ 3 ∣ n) :
    (NonzeroOrderThreeElements (G := ZMod n)).card = 0 := by
  apply Finset.card_eq_zero.mpr
  ext x
  constructor
  · intro hx
    rcases (mem_nonzeroOrderThreeElements (G := ZMod n) (v := x)).1 hx with ⟨hx3, hx0⟩
    exact (hx0 (eq_zero_of_orderThree_obstruction_of_not_three_dvd h3 hx3)).elim
  · intro hx
    simp at hx

/--
The odd cyclic, no-3-torsion cases of the mod-6 theorem: if `n` is odd and
`3 ∤ n`, the empty sum-free game on `ZMod n` is P.
-/
theorem initial_isP_of_odd_of_not_three_dvd {n : ℕ}
    [NeZero n] (hn : Odd n) (h3 : ¬ 3 ∣ n) :
    Game.IsP (∅ : Finset (ZMod n)) :=
  initial_isP_of_no_nonzero_orderTwo_or_three
    (G := ZMod n)
    (nonzeroOrderTwoElements_card_eq_zero_of_odd hn)
    (nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd h3)

/--
The even cyclic, no-3-torsion cases of the mod-6 theorem: if `n` is even and
`3 ∤ n`, opening the unique order-two element wins.
-/
theorem initial_win_of_even_of_not_three_dvd {n : ℕ}
    [NeZero n] (hn : Even n) (h3 : ¬ 3 ∣ n) :
    Game.Win (∅ : Finset (ZMod n)) :=
  initial_win_of_unique_orderTwo_no_nonzero_orderThree
    (G := ZMod n)
    (m := ((n / 2 : ℕ) : ZMod n))
    (half_mem_nonzeroOrderTwoElements_of_even hn)
    (fun hx => eq_half_of_mem_nonzeroOrderTwoElements hx)
    (nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd h3)

/-- In `ZMod (3*k)`, the point `k` is an order-three anchor. -/
theorem third_add_self_eq_neg {k : ℕ} :
    ((k : ZMod (3 * k)) + (k : ZMod (3 * k)) = -(k : ZMod (3 * k))) := by
  have h : ((3 * k : ℕ) : ZMod (3 * k)) = 0 := ZMod.natCast_self (3 * k)
  have h' : ((k * 3 : ℕ) : ZMod (3 * k)) = 0 := by
    simpa [mul_comm] using h
  have hsum : (k : ZMod (3 * k)) + k + k = 0 := by
    convert h' using 1
    rw [Nat.cast_mul]
    ring_nf
  calc
    (k : ZMod (3 * k)) + k =
        ((k : ZMod (3 * k)) + k + k) + (-(k : ZMod (3 * k))) := by abel
    _ = 0 + (-(k : ZMod (3 * k))) := by rw [hsum]
    _ = -(k : ZMod (3 * k)) := by simp

/-- The anchor `k : ZMod (3*k)` is nonzero when the modulus is nonzero. -/
theorem third_ne_zero {k : ℕ} [NeZero (3 * k)] :
    (k : ZMod (3 * k)) ≠ 0 := by
  intro hzero
  have hdiv : 3 * k ∣ k := (ZMod.natCast_eq_zero_iff k (3 * k)).1 hzero
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (3 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  have hlt : k < 3 * k := by omega
  exact (Nat.not_dvd_of_pos_of_lt hkpos hlt) hdiv

/--
The only solutions of `x+x=-x` in `ZMod (3*k)` are `0`, `k`, and `-k`.
-/
theorem eq_zero_or_eq_third_or_eq_neg_third_of_orderThree
    {k : ℕ} [NeZero (3 * k)] {x : ZMod (3 * k)}
    (hx : x + x = -x) :
    x = 0 ∨ x = (k : ZMod (3 * k)) ∨ x = -(k : ZMod (3 * k)) := by
  have hsum : x + x + x = 0 := by
    rw [hx]
    simp
  have hcast : ((3 * x.val : ℕ) : ZMod (3 * k)) = 0 := by
    rw [Nat.cast_mul, ZMod.natCast_zmod_val]
    calc
      ((3 : ZMod (3 * k)) * x) = x + x + x := by ring
      _ = 0 := hsum
  have hdiv : 3 * k ∣ 3 * x.val :=
    (ZMod.natCast_eq_zero_iff (3 * x.val) (3 * k)).1 hcast
  have hkdiv : k ∣ x.val :=
    (Nat.mul_dvd_mul_iff_left (by norm_num : 0 < 3)).1 hdiv
  rcases hkdiv with ⟨d, hd⟩
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (3 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  have hxlt : x.val < 3 * k := ZMod.val_lt x
  have hdlt : d < 3 := by
    have hlt : k * d < k * 3 := by
      simpa [hd, mul_comm, mul_left_comm, mul_assoc] using hxlt
    exact (Nat.mul_lt_mul_left hkpos).1 hlt
  interval_cases d
  · left
    exact (ZMod.val_eq_zero x).mp (by simp [hd])
  · right
    left
    calc
      x = (x.val : ZMod (3 * k)) := (ZMod.natCast_zmod_val x).symm
      _ = (k : ZMod (3 * k)) := by simp [hd]
  · right
    right
    calc
      x = (x.val : ZMod (3 * k)) := (ZMod.natCast_zmod_val x).symm
      _ = ((2 * k : ℕ) : ZMod (3 * k)) := by simp [hd, mul_comm]
      _ = (k : ZMod (3 * k)) + k := by
        rw [Nat.cast_mul]
        ring
      _ = -(k : ZMod (3 * k)) := third_add_self_eq_neg

/-- If `k` is odd, then `3*k` is odd. -/
theorem odd_three_mul {k : ℕ} (hk : Odd k) : Odd (3 * k) := by
  rcases hk with ⟨a, rfl⟩
  use 3 * a + 1
  omega

/-- For odd `k`, the only solution of `x+x=-k` in `ZMod (3*k)` is `x=k`. -/
theorem eq_third_of_anchorDouble_of_odd
    {k : ℕ} [NeZero (3 * k)] (hk : Odd k) {x : ZMod (3 * k)}
    (hx : x + x = -(k : ZMod (3 * k))) :
    x = (k : ZMod (3 * k)) := by
  have ht : (k : ZMod (3 * k)) + k = -(k : ZMod (3 * k)) :=
    third_add_self_eq_neg
  have hdiff : (x - (k : ZMod (3 * k))) + (x - (k : ZMod (3 * k))) = 0 := by
    calc
      (x - (k : ZMod (3 * k))) + (x - (k : ZMod (3 * k))) =
          (x + x) - ((k : ZMod (3 * k)) + k) := by abel
      _ = 0 := by rw [hx, ht]; simp
  have hzero := (ZMod.add_self_eq_zero_iff_eq_zero (odd_three_mul hk)).mp hdiff
  exact sub_eq_zero.mp hzero

/-- The anchored order-three strategy's fixed-point obstruction cannot occur for odd `3*k`. -/
theorem anchored_fixed_obstruction_absent_of_odd_three_mul
    {k : ℕ} [NeZero (3 * k)] (hk : Odd k)
    {S : Finset (ZMod (3 * k))} {y : ZMod (3 * k)}
    (_hgood : AnchoredNegGood (G := ZMod (3 * k)) (k : ZMod (3 * k)) S)
    (hymove : Move S y) :
    -y ≠ y := by
  intro hy
  have hylegal : Legal (S : Set (ZMod (3 * k))) y := legal_of_move hymove
  have hy0 : y ≠ 0 := legal_ne_zero hylegal
  have hy2 : y + y = 0 := by
    calc
      y + y = y + -y := by simp [hy]
      _ = 0 := by simp
  exact hy0 ((ZMod.add_self_eq_zero_iff_eq_zero (odd_three_mul hk)).mp hy2)

/-- The anchored order-three strategy's `y+y=-y` obstruction cannot be a legal move. -/
theorem anchored_orderThree_obstruction_absent_of_three_mul
    {k : ℕ} [NeZero (3 * k)]
    {S : Finset (ZMod (3 * k))} {y : ZMod (3 * k)}
    (hgood : AnchoredNegGood (G := ZMod (3 * k)) (k : ZMod (3 * k)) S)
    (hymove : Move S y) :
    y + y ≠ -y := by
  intro hy3
  rcases hgood with ⟨_hvalid, htS, _hsym⟩
  have hylegal : Legal (S : Set (ZMod (3 * k))) y := legal_of_move hymove
  have hy0 : y ≠ 0 := legal_ne_zero hylegal
  rcases eq_zero_or_eq_third_or_eq_neg_third_of_orderThree (k := k) hy3 with
    hyzero | hyt | hynegt
  · exact hy0 hyzero
  · exact hymove.1 (by simpa [hyt] using htS)
  · have htIns : (k : ZMod (3 * k)) ∈ insert y (S : Set (ZMod (3 * k))) :=
      Or.inr (by simpa [Finset.mem_coe] using htS)
    have hyIns : y ∈ insert y (S : Set (ZMod (3 * k))) := Or.inl rfl
    exact hylegal.2 htIns htIns hyIns (by simpa [hynegt] using third_add_self_eq_neg (k := k))

/-- The anchored order-three strategy's `y+y=-t` obstruction cannot occur for odd `3*k`. -/
theorem anchored_anchorDouble_obstruction_absent_of_odd_three_mul
    {k : ℕ} [NeZero (3 * k)] (hk : Odd k)
    {S : Finset (ZMod (3 * k))} {y : ZMod (3 * k)}
    (hgood : AnchoredNegGood (G := ZMod (3 * k)) (k : ZMod (3 * k)) S)
    (hymove : Move S y) :
    y + y ≠ -(k : ZMod (3 * k)) := by
  intro hy
  rcases hgood with ⟨_hvalid, htS, _hsym⟩
  have hyt : y = (k : ZMod (3 * k)) :=
    eq_third_of_anchorDouble_of_odd (k := k) hk hy
  exact hymove.1 (by simpa [hyt] using htS)

/--
The cyclic `n ≡ 3 (mod 6)` branch: for odd `k`, opening the order-three
anchor `k : ZMod (3*k)` wins.
-/
theorem initial_win_of_three_mul_odd {k : ℕ}
    [NeZero (3 * k)] (hk : Odd k) :
    Game.Win (∅ : Finset (ZMod (3 * k))) :=
  initial_win_of_orderThree_anchor
    (G := ZMod (3 * k))
    (t := (k : ZMod (3 * k)))
    third_add_self_eq_neg
    third_ne_zero
    (anchored_fixed_obstruction_absent_of_odd_three_mul (k := k) hk)
    (anchored_orderThree_obstruction_absent_of_three_mul (k := k))
    (anchored_anchorDouble_obstruction_absent_of_odd_three_mul (k := k) hk)

/-- In `ZMod (6*k)`, the point `2*k` is an order-three anchor. -/
theorem six_third_add_self_eq_neg {k : ℕ} :
    (((2 * k : ℕ) : ZMod (6 * k)) + ((2 * k : ℕ) : ZMod (6 * k)) =
      -((2 * k : ℕ) : ZMod (6 * k))) := by
  have h : ((6 * k : ℕ) : ZMod (6 * k)) = 0 := ZMod.natCast_self (6 * k)
  have h' : ((k * 6 : ℕ) : ZMod (6 * k)) = 0 := by
    simpa [mul_comm] using h
  have hsum :
      ((2 * k : ℕ) : ZMod (6 * k)) + ((2 * k : ℕ) : ZMod (6 * k)) +
        ((2 * k : ℕ) : ZMod (6 * k)) = 0 := by
    convert h' using 1
    trans ((k : ZMod (6 * k)) * (6 : ZMod (6 * k)))
    · rw [Nat.cast_mul]
      ring_nf
    · rw [Nat.cast_mul]
      norm_num
  calc
    ((2 * k : ℕ) : ZMod (6 * k)) + ((2 * k : ℕ) : ZMod (6 * k)) =
        (((2 * k : ℕ) : ZMod (6 * k)) + ((2 * k : ℕ) : ZMod (6 * k)) +
          ((2 * k : ℕ) : ZMod (6 * k))) +
          (-((2 * k : ℕ) : ZMod (6 * k))) := by abel
    _ = 0 + (-((2 * k : ℕ) : ZMod (6 * k))) := by rw [hsum]
    _ = -((2 * k : ℕ) : ZMod (6 * k)) := by simp

/-- The modulus `6*k` is even. -/
theorem even_six_mul {k : ℕ} : Even (6 * k) := by
  use 3 * k
  ring

/-- The unique order-two point in `ZMod (6*k)` is represented by `3*k`. -/
theorem half_six_mul {k : ℕ} : (6 * k) / 2 = 3 * k := by
  omega

/-- The point `2*k : ZMod (6*k)` is nonzero when the modulus is nonzero. -/
theorem six_third_ne_zero {k : ℕ} [NeZero (6 * k)] :
    ((2 * k : ℕ) : ZMod (6 * k)) ≠ 0 := by
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (6 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  exact natCast_ne_zero_of_pos_of_lt
    (n := 6 * k) (a := 2 * k) (by positivity) (by omega)

/-- The point `3*k : ZMod (6*k)` is nonzero when the modulus is nonzero. -/
theorem six_half_ne_zero {k : ℕ} [NeZero (6 * k)] :
    ((3 * k : ℕ) : ZMod (6 * k)) ≠ 0 := by
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (6 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  exact natCast_ne_zero_of_pos_of_lt
    (n := 6 * k) (a := 3 * k) (by positivity) (by omega)

/-- The order-three anchor and order-two blocker in `ZMod (6*k)` are distinct. -/
theorem six_third_ne_half {k : ℕ} [NeZero (6 * k)] :
    ((2 * k : ℕ) : ZMod (6 * k)) ≠ ((3 * k : ℕ) : ZMod (6 * k)) := by
  intro h
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (6 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  have h2val : (((2 * k : ℕ) : ZMod (6 * k))).val = 2 * k :=
    ZMod.val_natCast_of_lt (by omega)
  have h3val : (((3 * k : ℕ) : ZMod (6 * k))).val = 3 * k :=
    ZMod.val_natCast_of_lt (by omega)
  have hval := congrArg ZMod.val h
  omega

/-- In `ZMod (6*k)`, `-(2*k)` is represented by `4*k`. -/
theorem six_neg_third_eq_four_mul {k : ℕ} :
    (-((2 * k : ℕ) : ZMod (6 * k)) : ZMod (6 * k)) =
      ((4 * k : ℕ) : ZMod (6 * k)) := by
  calc
    (-((2 * k : ℕ) : ZMod (6 * k)) : ZMod (6 * k)) =
        ((2 * k : ℕ) : ZMod (6 * k)) + ((2 * k : ℕ) : ZMod (6 * k)) :=
          (six_third_add_self_eq_neg (k := k)).symm
    _ = ((4 * k : ℕ) : ZMod (6 * k)) := by
      trans ((k : ZMod (6 * k)) * (4 : ZMod (6 * k)))
      · rw [Nat.cast_mul]
        ring_nf
      · rw [Nat.cast_mul]
        ring_nf

/-- The order-two blocker is not the missing mate of the order-three anchor. -/
theorem six_half_ne_neg_third {k : ℕ} [NeZero (6 * k)] :
    ((3 * k : ℕ) : ZMod (6 * k)) ≠ -((2 * k : ℕ) : ZMod (6 * k)) := by
  intro h
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (6 * k)) (by simp [hk])
  have hkpos : 0 < k := Nat.pos_iff_ne_zero.2 hk0
  have h3val : (((3 * k : ℕ) : ZMod (6 * k))).val = 3 * k :=
    ZMod.val_natCast_of_lt (by omega)
  have h4val : (((4 * k : ℕ) : ZMod (6 * k))).val = 4 * k :=
    ZMod.val_natCast_of_lt (by omega)
  have h' : ((3 * k : ℕ) : ZMod (6 * k)) = ((4 * k : ℕ) : ZMod (6 * k)) := by
    exact h.trans (six_neg_third_eq_four_mul (k := k))
  have hval := congrArg ZMod.val h'
  omega

/--
The only solutions of `x+x=-x` in `ZMod (6*k)` are `0`, `2*k`, and `-(2*k)`.
-/
theorem eq_zero_or_eq_six_third_or_eq_neg_six_third_of_orderThree
    {k : ℕ} [NeZero (6 * k)] {x : ZMod (6 * k)}
    (hx : x + x = -x) :
    x = 0 ∨
      x = ((2 * k : ℕ) : ZMod (6 * k)) ∨
        x = -((2 * k : ℕ) : ZMod (6 * k)) := by
  have hsum : x + x + x = 0 := by
    rw [hx]
    simp
  have hcast : ((3 * x.val : ℕ) : ZMod (6 * k)) = 0 := by
    rw [Nat.cast_mul, ZMod.natCast_zmod_val]
    calc
      ((3 : ZMod (6 * k)) * x) = x + x + x := by ring
      _ = 0 := hsum
  have hdiv : 6 * k ∣ 3 * x.val :=
    (ZMod.natCast_eq_zero_iff (3 * x.val) (6 * k)).1 hcast
  have hdiv' : 3 * (2 * k) ∣ 3 * x.val := by
    simpa [mul_assoc, mul_comm, mul_left_comm] using hdiv
  have htwokdiv : 2 * k ∣ x.val :=
    (Nat.mul_dvd_mul_iff_left (by norm_num : 0 < 3)).1 hdiv'
  rcases htwokdiv with ⟨d, hd⟩
  have hk0 : k ≠ 0 := by
    intro hk
    exact (NeZero.ne (6 * k)) (by simp [hk])
  have htwokpos : 0 < 2 * k := by positivity
  have hxlt : x.val < 6 * k := ZMod.val_lt x
  have hdlt : d < 3 := by
    have hlt : (2 * k) * d < (2 * k) * 3 := by
      simpa [hd, mul_assoc, mul_comm, mul_left_comm] using hxlt
    exact (Nat.mul_lt_mul_left htwokpos).1 hlt
  interval_cases d
  · left
    exact (ZMod.val_eq_zero x).mp (by simp [hd])
  · right
    left
    calc
      x = (x.val : ZMod (6 * k)) := (ZMod.natCast_zmod_val x).symm
      _ = ((2 * k : ℕ) : ZMod (6 * k)) := by simp [hd]
  · right
    right
    calc
      x = (x.val : ZMod (6 * k)) := (ZMod.natCast_zmod_val x).symm
      _ = ((4 * k : ℕ) : ZMod (6 * k)) := by
        simp [hd, mul_comm, mul_left_comm]
      _ = -((2 * k : ℕ) : ZMod (6 * k)) :=
        (six_neg_third_eq_four_mul (k := k)).symm

/--
The solutions of `x+x=-(2*k)` in `ZMod (6*k)` are `2*k` and `2*k+3*k`.
-/
theorem eq_six_third_or_six_third_add_half_of_anchorDouble
    {k : ℕ} [NeZero (6 * k)] {x : ZMod (6 * k)}
    (hx : x + x = -((2 * k : ℕ) : ZMod (6 * k))) :
    x = ((2 * k : ℕ) : ZMod (6 * k)) ∨
      x = ((2 * k : ℕ) : ZMod (6 * k)) + ((3 * k : ℕ) : ZMod (6 * k)) := by
  let t : ZMod (6 * k) := ((2 * k : ℕ) : ZMod (6 * k))
  let d : ZMod (6 * k) := x - t
  have ht : t + t = -t := by
    simpa [t] using (six_third_add_self_eq_neg (k := k))
  have hd2 : d + d = 0 := by
    change (x - t) + (x - t) = 0
    calc
      (x - t) + (x - t) = (x + x) - (t + t) := by abel
      _ = 0 := by rw [hx, ht]; simp [t]
  by_cases hd0 : d = 0
  · left
    have : x = t := by
      have := sub_eq_zero.mp hd0
      simpa [d] using this
    simpa [t] using this
  · right
    have hdmem : d ∈ NonzeroOrderTwoElements (G := ZMod (6 * k)) :=
      (mem_nonzeroOrderTwoElements (G := ZMod (6 * k)) (v := d)).2 ⟨hd2, hd0⟩
    have hdhalf : d = (((6 * k) / 2 : ℕ) : ZMod (6 * k)) :=
      eq_half_of_mem_nonzeroOrderTwoElements (n := 6 * k) hdmem
    have hdm : d = ((3 * k : ℕ) : ZMod (6 * k)) := by
      simpa [half_six_mul] using hdhalf
    have hx' : x = t + ((3 * k : ℕ) : ZMod (6 * k)) := by
      calc
        x = d + t := by simp [d]
        _ = t + ((3 * k : ℕ) : ZMod (6 * k)) := by rw [hdm]; abel
    simpa [t] using hx'

/-- The fixed-point obstruction cannot be a legal move in the even `6*k` anchored state. -/
theorem anchoredWith_fixed_obstruction_absent_of_six_mul
    {k : ℕ} [NeZero (6 * k)]
    {S : Finset (ZMod (6 * k))} {y : ZMod (6 * k)}
    (hgood : AnchoredNegGoodWith
      (G := ZMod (6 * k))
      ((2 * k : ℕ) : ZMod (6 * k))
      ((3 * k : ℕ) : ZMod (6 * k)) S)
    (hymove : Move S y) :
    -y ≠ y := by
  intro hy
  rcases hgood with ⟨_hanchored, hmS⟩
  have hylegal : Legal (S : Set (ZMod (6 * k))) y := legal_of_move hymove
  have hy2 : y + y = 0 := by
    calc
      y + y = y + -y := by simp [hy]
      _ = 0 := by simp
  by_cases hy0 : y = 0
  · exact (legal_ne_zero hylegal) hy0
  · have hymem : y ∈ NonzeroOrderTwoElements (G := ZMod (6 * k)) :=
      (mem_nonzeroOrderTwoElements (G := ZMod (6 * k)) (v := y)).2 ⟨hy2, hy0⟩
    have hyhalf : y = (((6 * k) / 2 : ℕ) : ZMod (6 * k)) :=
      eq_half_of_mem_nonzeroOrderTwoElements (n := 6 * k) hymem
    have hym : y = ((3 * k : ℕ) : ZMod (6 * k)) := by
      simpa [half_six_mul] using hyhalf
    exact hymove.1 (by simpa [hym] using hmS)

/-- The `y+y=-y` obstruction cannot be a legal move in the even `6*k` anchored state. -/
theorem anchoredWith_orderThree_obstruction_absent_of_six_mul
    {k : ℕ} [NeZero (6 * k)]
    {S : Finset (ZMod (6 * k))} {y : ZMod (6 * k)}
    (hgood : AnchoredNegGoodWith
      (G := ZMod (6 * k))
      ((2 * k : ℕ) : ZMod (6 * k))
      ((3 * k : ℕ) : ZMod (6 * k)) S)
    (hymove : Move S y) :
    y + y ≠ -y := by
  intro hy3
  rcases hgood with ⟨⟨_hvalid, htS, _hsym⟩, _hmS⟩
  have hylegal : Legal (S : Set (ZMod (6 * k))) y := legal_of_move hymove
  have hy0 : y ≠ 0 := legal_ne_zero hylegal
  rcases eq_zero_or_eq_six_third_or_eq_neg_six_third_of_orderThree (k := k) hy3 with
    hyzero | hyt | hynegt
  · exact hy0 hyzero
  · exact hymove.1 (by simpa [hyt] using htS)
  · have htIns :
        ((2 * k : ℕ) : ZMod (6 * k)) ∈ insert y (S : Set (ZMod (6 * k))) :=
      Or.inr (by simpa [Finset.mem_coe] using htS)
    have hyIns : y ∈ insert y (S : Set (ZMod (6 * k))) := Or.inl rfl
    exact hylegal.2 htIns htIns hyIns
      (by simpa [hynegt] using six_third_add_self_eq_neg (k := k))

/-- The `y+y=-t` obstruction is blocked by either `t` or the permanent order-two point `m`. -/
theorem anchoredWith_anchorDouble_obstruction_absent_of_six_mul
    {k : ℕ} [NeZero (6 * k)]
    {S : Finset (ZMod (6 * k))} {y : ZMod (6 * k)}
    (hgood : AnchoredNegGoodWith
      (G := ZMod (6 * k))
      ((2 * k : ℕ) : ZMod (6 * k))
      ((3 * k : ℕ) : ZMod (6 * k)) S)
    (hymove : Move S y) :
    y + y ≠ -((2 * k : ℕ) : ZMod (6 * k)) := by
  intro hy
  rcases hgood with ⟨⟨_hvalid, htS, _hsym⟩, hmS⟩
  have hylegal : Legal (S : Set (ZMod (6 * k))) y := legal_of_move hymove
  rcases eq_six_third_or_six_third_add_half_of_anchorDouble (k := k) hy with hyt | hytm
  · exact hymove.1 (by simpa [hyt] using htS)
  · have htIns :
        ((2 * k : ℕ) : ZMod (6 * k)) ∈ insert y (S : Set (ZMod (6 * k))) :=
      Or.inr (by simpa [Finset.mem_coe] using htS)
    have hmIns :
        ((3 * k : ℕ) : ZMod (6 * k)) ∈ insert y (S : Set (ZMod (6 * k))) :=
      Or.inr (by simpa [Finset.mem_coe] using hmS)
    have hyIns : y ∈ insert y (S : Set (ZMod (6 * k))) := Or.inl rfl
    exact hylegal.2 htIns hmIns hyIns (by simp [hytm])

/-- The cyclic `n ≡ 0 (mod 6)` branch: the empty game on `ZMod (6*k)` is P. -/
theorem initial_isP_of_six_mul {k : ℕ} [NeZero (6 * k)] :
    Game.IsP (∅ : Finset (ZMod (6 * k))) := by
  let t : ZMod (6 * k) := ((2 * k : ℕ) : ZMod (6 * k))
  let m : ZMod (6 * k) := ((3 * k : ℕ) : ZMod (6 * k))
  have ht2 : t + t = -t := by
    simpa [t] using six_third_add_self_eq_neg (k := k)
  have ht0 : t ≠ 0 := by
    simpa [t] using six_third_ne_zero (k := k)
  have hmMem : m ∈ NonzeroOrderTwoElements (G := ZMod (6 * k)) := by
    have hmem := half_mem_nonzeroOrderTwoElements_of_even (n := 6 * k) (even_six_mul (k := k))
    simpa [m, half_six_mul] using hmem
  have hm2 : m + m = 0 := (mem_nonzeroOrderTwoElements (G := ZMod (6 * k)) (v := m)).1 hmMem |>.1
  have hm0 : m ≠ 0 := (mem_nonzeroOrderTwoElements (G := ZMod (6 * k)) (v := m)).1 hmMem |>.2
  have htm : t ≠ m := by
    simpa [t, m] using six_third_ne_half (k := k)
  have hm_ne_negt : m ≠ -t := by
    simpa [t, m] using six_half_ne_neg_third (k := k)
  have hvalidPair : Valid (insert t ({m} : Finset (ZMod (6 * k)))) :=
    valid_pair_orderTwo_orderThree (m := m) (t := t) hm2 hm0 ht2 ht0 hm_ne_negt
  have hgoodPair :
      AnchoredNegGoodWith (G := ZMod (6 * k)) t m (insert t ({m} : Finset (ZMod (6 * k)))) := by
    refine ⟨⟨hvalidPair, by simp, ?_⟩, by simp⟩
    have hnegm : -m = m := by
      have h := congrArg (fun z => -m + z) hm2
      simpa [add_assoc] using h.symm
    intro z hz hzt
    simp only [Finset.mem_coe, Finset.mem_insert, Finset.mem_singleton] at hz ⊢
    rcases hz with hzT | hzM
    · exact (hzt hzT).elim
    · right
      simp [hzM, hnegm]
  have hpairP : IsP (insert t ({m} : Finset (ZMod (6 * k)))) :=
    anchoredNegGoodWith_isP_of_live_obstructions
      (G := ZMod (6 * k)) (t := t) (m := m) ht2
      (by
        intro S y hgood hymove
        simpa [t, m] using
          anchoredWith_fixed_obstruction_absent_of_six_mul (k := k) hgood hymove)
      (by
        intro S y hgood hymove
        simpa [t, m] using
          anchoredWith_orderThree_obstruction_absent_of_six_mul (k := k) hgood hymove)
      (by
        intro S y hgood hymove
        simpa [t, m] using
          anchoredWith_anchorDouble_obstruction_absent_of_six_mul (k := k) hgood hymove)
      hgoodPair
  have hmove : Move ({m} : Finset (ZMod (6 * k))) t := by
    exact ⟨by simp [htm], hvalidPair⟩
  have hchildWin : Win ({m} : Finset (ZMod (6 * k))) :=
    FiniteBuildGame.win_of_move_to_isP hmove hpairP
  exact (initial_isP_iff_orderTwo_child_win (G := ZMod (6 * k)) (m := m) hm2 hm0).2 hchildWin

/-- Divisibility wrapper for the cyclic `n ≡ 0 (mod 6)` branch. -/
theorem initial_isP_of_six_dvd {n : ℕ} [NeZero n] (h6 : 6 ∣ n) :
    Game.IsP (∅ : Finset (ZMod n)) := by
  rcases h6 with ⟨k, rfl⟩
  exact initial_isP_of_six_mul (k := k)

/-- Equality wrapper for the cyclic `n ≡ 3 (mod 6)` branch. -/
theorem initial_win_of_eq_three_mul_odd {n k : ℕ} [NeZero n]
    (hn : n = 3 * k) (hk : Odd k) :
    Game.Win (∅ : Finset (ZMod n)) := by
  subst n
  exact initial_win_of_three_mul_odd (k := k) hk

end CyclicZMod
end Sumfree
