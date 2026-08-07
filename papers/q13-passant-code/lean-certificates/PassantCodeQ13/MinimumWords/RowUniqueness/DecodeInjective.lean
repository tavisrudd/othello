import PassantCodeQ13.MinimumWords.RowUniqueness.Base

/-!
# Injectivity of support decoding

A support is encoded as a natural number whose set bits are the positions of its points in the
displayed internal-point order, and decoding reads those bits back as internal points.  Two encoded
supports below `2 ^ 78` with the same decoding therefore agree in every bit: the bits below 78 are
the memberships of the decoded sets, and the bits from 78 upwards vanish on both.  Hence decoding is
injective on any family of codes below `2 ^ 78`, and in particular on the encoded minimum-word
family, whose 364 members are checked to lie below that bound by kernel reduction over the displayed
supports.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13

/-- Decoding determines a code below `2 ^ 78`. -/
theorem decodedSupport_injective_of_lt {first second : ℕ} (first_lt : first < 2 ^ 78)
    (second_lt : second < 2 ^ 78) (decoded : decodedSupport first = decodedSupport second) :
    first = second := by
  refine Nat.eq_of_testBit_eq fun column => ?_
  by_cases bounded : column < 78
  · have membership := congrArg (fun family => internalPointAt ⟨column, bounded⟩ ∈ family) decoded
    have first_bit := mem_decodedSupport first ⟨column, bounded⟩
    have second_bit := mem_decodedSupport second ⟨column, bounded⟩
    by_cases set_first : first.testBit column = true
    · have : internalPointAt ⟨column, bounded⟩ ∈ decodedSupport second := by
        rw [← decoded]
        exact first_bit.mpr set_first
      rw [set_first, second_bit.mp this]
    · have not_second : internalPointAt ⟨column, bounded⟩ ∉ decodedSupport second := by
        rw [← decoded]
        exact fun member => set_first (first_bit.mp member)
      rw [Bool.eq_false_iff.mpr set_first,
        Bool.eq_false_iff.mpr fun set_second => not_second (second_bit.mpr set_second)]
  · rw [Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le first_lt (Nat.pow_le_pow_right (by norm_num)
      (Nat.le_of_not_lt bounded))),
      Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le second_lt (Nat.pow_le_pow_right (by norm_num)
        (Nat.le_of_not_lt bounded)))]

/-- Every displayed minimum-word support is below `2 ^ 78`.  Decided over the 364 supports. -/
theorem minimumWordSupports_lt :
    minimumWordSupports.all (fun support => support < 2 ^ 78) = true := by
  decide +kernel

/-- Decoding is injective on the four-orbit support list. -/
theorem decodedSupport_injOn :
    Set.InjOn decodedSupport minimumSupportCodes.toFinset := by
  intro first first_mem second second_mem decoded
  have bound : ∀ code ∈ minimumSupportCodes, code < 2 ^ 78 := by
    intro code member
    rw [minimumSupportCodes_eq] at member
    have := List.all_eq_true.mp minimumWordSupports_lt code member
    simpa using this
  exact decodedSupport_injective_of_lt (bound first (List.mem_toFinset.mp first_mem))
    (bound second (List.mem_toFinset.mp second_mem)) decoded

end PassantCodeQ13.MinimumWords.RowUniqueness
