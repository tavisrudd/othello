import RelativeConicArcs.Q11A5PointOrbitsRepresentatives
import RelativeConicArcs.Q11A5PointOrbitsRows00
import RelativeConicArcs.Q11A5PointOrbitsRows01
import RelativeConicArcs.Q11A5PointOrbitsRows02
import RelativeConicArcs.Q11A5PointOrbitsRows03
import RelativeConicArcs.Q11A5PointOrbitsRows04
import RelativeConicArcs.Q11A5PointOrbitsRows05
import RelativeConicArcs.Q11A5PointOrbitsRows06
import RelativeConicArcs.Q11A5PointOrbitsRows07
import RelativeConicArcs.Q11A5PointOrbitsRows08
import RelativeConicArcs.Q11A5PointOrbitsRows09
import RelativeConicArcs.Q11A5PointOrbitsRows10
import RelativeConicArcs.Q11A5PointOrbitsRows11
import RelativeConicArcs.Q11A5PointOrbitsFixed00
import RelativeConicArcs.Q11A5PointOrbitsFixed01
import RelativeConicArcs.Q11A5PointOrbitsFixed02
import RelativeConicArcs.Q11A5PointOrbitsFixed03
import RelativeConicArcs.Q11A5PointOrbitsFixed04
import RelativeConicArcs.Q11A5PointOrbitsFixed05
import RelativeConicArcs.Q11A5PointOrbitsFixed06
import RelativeConicArcs.Q11A5PointOrbitsBasic
import RelativeConicArcs.Q11A5PointOrbitsMatrix00
import RelativeConicArcs.Q11A5PointOrbitsMatrix01
import RelativeConicArcs.Q11A5PointOrbitsMatrix02
import RelativeConicArcs.Q11A5PointOrbitsMatrix03
import RelativeConicArcs.Q11A5PointOrbitsMatrix04
import RelativeConicArcs.Q11A5PointOrbitsMatrix05
import RelativeConicArcs.Q11A5PointOrbitsMatrix06
import RelativeConicArcs.Q11A5PointOrbitsMatrix07
import RelativeConicArcs.Q11A5PointOrbitsMatrix08
import RelativeConicArcs.Q11A5PointOrbitsMatrix09
import RelativeConicArcs.Q11A5PointOrbitsMatrix10
import RelativeConicArcs.Q11A5PointOrbitsMatrix11
import RelativeConicArcs.Q11A5PointOrbitsSupport00
import RelativeConicArcs.Q11A5PointOrbitsSupport01
import RelativeConicArcs.Q11A5PointOrbitsSupport02
import RelativeConicArcs.Q11A5PointOrbitsSupport03
import RelativeConicArcs.Q11A5PointOrbitsSupport04
import RelativeConicArcs.Q11A5PointOrbitsSupport05
import RelativeConicArcs.Q11A5PointOrbitsSupport06
import RelativeConicArcs.Q11A5PointOrbitsSupport07
import RelativeConicArcs.Q11A5PointOrbitsSupport08
import RelativeConicArcs.Q11A5PointOrbitsSupport09
import RelativeConicArcs.Q11A5PointOrbitsSupport10
import RelativeConicArcs.Q11A5PointOrbitsSupport11
import RelativeConicArcs.Q11A5PointOrbitsSupportSummary
import RelativeConicArcs.Q11A5PointOrbitsPartition
import RelativeConicArcs.Q11A5PointOrbitsConic
import RelativeConicArcs.Q11A5PointOrbitsBrianchon

/-!
# The finite A5 point-orbit bridge for the Clebsch hexagon

The arithmetic action checks are compiled in bounded row leaves.  This public module only dispatches
to those opaque certificates and assembles the orbit, fixed-point, and Brianchon conclusions.
-/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

/-- Every reflected lift is nonsingular. -/
theorem matrices_nonsingular : ∀ g : GroupIndex, matrixDet g ≠ 0 := by
  intro g
  fin_cases g
  · exact matrix_nonsingular_row_0
  · exact matrix_nonsingular_row_1
  · exact matrix_nonsingular_row_2
  · exact matrix_nonsingular_row_3
  · exact matrix_nonsingular_row_4
  · exact matrix_nonsingular_row_5
  · exact matrix_nonsingular_row_6
  · exact matrix_nonsingular_row_7
  · exact matrix_nonsingular_row_8
  · exact matrix_nonsingular_row_9
  · exact matrix_nonsingular_row_10
  · exact matrix_nonsingular_row_11
  · exact matrix_nonsingular_row_12
  · exact matrix_nonsingular_row_13
  · exact matrix_nonsingular_row_14
  · exact matrix_nonsingular_row_15
  · exact matrix_nonsingular_row_16
  · exact matrix_nonsingular_row_17
  · exact matrix_nonsingular_row_18
  · exact matrix_nonsingular_row_19
  · exact matrix_nonsingular_row_20
  · exact matrix_nonsingular_row_21
  · exact matrix_nonsingular_row_22
  · exact matrix_nonsingular_row_23
  · exact matrix_nonsingular_row_24
  · exact matrix_nonsingular_row_25
  · exact matrix_nonsingular_row_26
  · exact matrix_nonsingular_row_27
  · exact matrix_nonsingular_row_28
  · exact matrix_nonsingular_row_29
  · exact matrix_nonsingular_row_30
  · exact matrix_nonsingular_row_31
  · exact matrix_nonsingular_row_32
  · exact matrix_nonsingular_row_33
  · exact matrix_nonsingular_row_34
  · exact matrix_nonsingular_row_35
  · exact matrix_nonsingular_row_36
  · exact matrix_nonsingular_row_37
  · exact matrix_nonsingular_row_38
  · exact matrix_nonsingular_row_39
  · exact matrix_nonsingular_row_40
  · exact matrix_nonsingular_row_41
  · exact matrix_nonsingular_row_42
  · exact matrix_nonsingular_row_43
  · exact matrix_nonsingular_row_44
  · exact matrix_nonsingular_row_45
  · exact matrix_nonsingular_row_46
  · exact matrix_nonsingular_row_47
  · exact matrix_nonsingular_row_48
  · exact matrix_nonsingular_row_49
  · exact matrix_nonsingular_row_50
  · exact matrix_nonsingular_row_51
  · exact matrix_nonsingular_row_52
  · exact matrix_nonsingular_row_53
  · exact matrix_nonsingular_row_54
  · exact matrix_nonsingular_row_55
  · exact matrix_nonsingular_row_56
  · exact matrix_nonsingular_row_57
  · exact matrix_nonsingular_row_58
  · exact matrix_nonsingular_row_59

/-- No reflected lift sends a canonical nonzero representative to zero. -/
theorem matrixVec_pointVec_ne_zero :
    ∀ g : GroupIndex, ∀ p : PointIndex, matrixVec g (pointVec p) ≠ 0 := by
  intro g
  fin_cases g
  · exact matrixVec_pointVec_ne_zero_row_0
  · exact matrixVec_pointVec_ne_zero_row_1
  · exact matrixVec_pointVec_ne_zero_row_2
  · exact matrixVec_pointVec_ne_zero_row_3
  · exact matrixVec_pointVec_ne_zero_row_4
  · exact matrixVec_pointVec_ne_zero_row_5
  · exact matrixVec_pointVec_ne_zero_row_6
  · exact matrixVec_pointVec_ne_zero_row_7
  · exact matrixVec_pointVec_ne_zero_row_8
  · exact matrixVec_pointVec_ne_zero_row_9
  · exact matrixVec_pointVec_ne_zero_row_10
  · exact matrixVec_pointVec_ne_zero_row_11
  · exact matrixVec_pointVec_ne_zero_row_12
  · exact matrixVec_pointVec_ne_zero_row_13
  · exact matrixVec_pointVec_ne_zero_row_14
  · exact matrixVec_pointVec_ne_zero_row_15
  · exact matrixVec_pointVec_ne_zero_row_16
  · exact matrixVec_pointVec_ne_zero_row_17
  · exact matrixVec_pointVec_ne_zero_row_18
  · exact matrixVec_pointVec_ne_zero_row_19
  · exact matrixVec_pointVec_ne_zero_row_20
  · exact matrixVec_pointVec_ne_zero_row_21
  · exact matrixVec_pointVec_ne_zero_row_22
  · exact matrixVec_pointVec_ne_zero_row_23
  · exact matrixVec_pointVec_ne_zero_row_24
  · exact matrixVec_pointVec_ne_zero_row_25
  · exact matrixVec_pointVec_ne_zero_row_26
  · exact matrixVec_pointVec_ne_zero_row_27
  · exact matrixVec_pointVec_ne_zero_row_28
  · exact matrixVec_pointVec_ne_zero_row_29
  · exact matrixVec_pointVec_ne_zero_row_30
  · exact matrixVec_pointVec_ne_zero_row_31
  · exact matrixVec_pointVec_ne_zero_row_32
  · exact matrixVec_pointVec_ne_zero_row_33
  · exact matrixVec_pointVec_ne_zero_row_34
  · exact matrixVec_pointVec_ne_zero_row_35
  · exact matrixVec_pointVec_ne_zero_row_36
  · exact matrixVec_pointVec_ne_zero_row_37
  · exact matrixVec_pointVec_ne_zero_row_38
  · exact matrixVec_pointVec_ne_zero_row_39
  · exact matrixVec_pointVec_ne_zero_row_40
  · exact matrixVec_pointVec_ne_zero_row_41
  · exact matrixVec_pointVec_ne_zero_row_42
  · exact matrixVec_pointVec_ne_zero_row_43
  · exact matrixVec_pointVec_ne_zero_row_44
  · exact matrixVec_pointVec_ne_zero_row_45
  · exact matrixVec_pointVec_ne_zero_row_46
  · exact matrixVec_pointVec_ne_zero_row_47
  · exact matrixVec_pointVec_ne_zero_row_48
  · exact matrixVec_pointVec_ne_zero_row_49
  · exact matrixVec_pointVec_ne_zero_row_50
  · exact matrixVec_pointVec_ne_zero_row_51
  · exact matrixVec_pointVec_ne_zero_row_52
  · exact matrixVec_pointVec_ne_zero_row_53
  · exact matrixVec_pointVec_ne_zero_row_54
  · exact matrixVec_pointVec_ne_zero_row_55
  · exact matrixVec_pointVec_ne_zero_row_56
  · exact matrixVec_pointVec_ne_zero_row_57
  · exact matrixVec_pointVec_ne_zero_row_58
  · exact matrixVec_pointVec_ne_zero_row_59

/-- Every displayed support map is a permutation of the six witness directions. -/
theorem supportPerm_permutation :
    ∀ g : GroupIndex,
      ((Finset.univ : Finset (Fin 6)).image (supportPerm g)).card = 6 := by
  intro g
  fin_cases g
  · exact supportPerm_permutation_row_0
  · exact supportPerm_permutation_row_1
  · exact supportPerm_permutation_row_2
  · exact supportPerm_permutation_row_3
  · exact supportPerm_permutation_row_4
  · exact supportPerm_permutation_row_5
  · exact supportPerm_permutation_row_6
  · exact supportPerm_permutation_row_7
  · exact supportPerm_permutation_row_8
  · exact supportPerm_permutation_row_9
  · exact supportPerm_permutation_row_10
  · exact supportPerm_permutation_row_11
  · exact supportPerm_permutation_row_12
  · exact supportPerm_permutation_row_13
  · exact supportPerm_permutation_row_14
  · exact supportPerm_permutation_row_15
  · exact supportPerm_permutation_row_16
  · exact supportPerm_permutation_row_17
  · exact supportPerm_permutation_row_18
  · exact supportPerm_permutation_row_19
  · exact supportPerm_permutation_row_20
  · exact supportPerm_permutation_row_21
  · exact supportPerm_permutation_row_22
  · exact supportPerm_permutation_row_23
  · exact supportPerm_permutation_row_24
  · exact supportPerm_permutation_row_25
  · exact supportPerm_permutation_row_26
  · exact supportPerm_permutation_row_27
  · exact supportPerm_permutation_row_28
  · exact supportPerm_permutation_row_29
  · exact supportPerm_permutation_row_30
  · exact supportPerm_permutation_row_31
  · exact supportPerm_permutation_row_32
  · exact supportPerm_permutation_row_33
  · exact supportPerm_permutation_row_34
  · exact supportPerm_permutation_row_35
  · exact supportPerm_permutation_row_36
  · exact supportPerm_permutation_row_37
  · exact supportPerm_permutation_row_38
  · exact supportPerm_permutation_row_39
  · exact supportPerm_permutation_row_40
  · exact supportPerm_permutation_row_41
  · exact supportPerm_permutation_row_42
  · exact supportPerm_permutation_row_43
  · exact supportPerm_permutation_row_44
  · exact supportPerm_permutation_row_45
  · exact supportPerm_permutation_row_46
  · exact supportPerm_permutation_row_47
  · exact supportPerm_permutation_row_48
  · exact supportPerm_permutation_row_49
  · exact supportPerm_permutation_row_50
  · exact supportPerm_permutation_row_51
  · exact supportPerm_permutation_row_52
  · exact supportPerm_permutation_row_53
  · exact supportPerm_permutation_row_54
  · exact supportPerm_permutation_row_55
  · exact supportPerm_permutation_row_56
  · exact supportPerm_permutation_row_57
  · exact supportPerm_permutation_row_58
  · exact supportPerm_permutation_row_59

/-- The support permutations are 60 distinct elements. -/
theorem supportPerm_injective : Function.Injective supportPerm := by
  intro g h heq
  fin_cases g
  · exact supportPerm_injective_row_0 h heq
  · exact supportPerm_injective_row_1 h heq
  · exact supportPerm_injective_row_2 h heq
  · exact supportPerm_injective_row_3 h heq
  · exact supportPerm_injective_row_4 h heq
  · exact supportPerm_injective_row_5 h heq
  · exact supportPerm_injective_row_6 h heq
  · exact supportPerm_injective_row_7 h heq
  · exact supportPerm_injective_row_8 h heq
  · exact supportPerm_injective_row_9 h heq
  · exact supportPerm_injective_row_10 h heq
  · exact supportPerm_injective_row_11 h heq
  · exact supportPerm_injective_row_12 h heq
  · exact supportPerm_injective_row_13 h heq
  · exact supportPerm_injective_row_14 h heq
  · exact supportPerm_injective_row_15 h heq
  · exact supportPerm_injective_row_16 h heq
  · exact supportPerm_injective_row_17 h heq
  · exact supportPerm_injective_row_18 h heq
  · exact supportPerm_injective_row_19 h heq
  · exact supportPerm_injective_row_20 h heq
  · exact supportPerm_injective_row_21 h heq
  · exact supportPerm_injective_row_22 h heq
  · exact supportPerm_injective_row_23 h heq
  · exact supportPerm_injective_row_24 h heq
  · exact supportPerm_injective_row_25 h heq
  · exact supportPerm_injective_row_26 h heq
  · exact supportPerm_injective_row_27 h heq
  · exact supportPerm_injective_row_28 h heq
  · exact supportPerm_injective_row_29 h heq
  · exact supportPerm_injective_row_30 h heq
  · exact supportPerm_injective_row_31 h heq
  · exact supportPerm_injective_row_32 h heq
  · exact supportPerm_injective_row_33 h heq
  · exact supportPerm_injective_row_34 h heq
  · exact supportPerm_injective_row_35 h heq
  · exact supportPerm_injective_row_36 h heq
  · exact supportPerm_injective_row_37 h heq
  · exact supportPerm_injective_row_38 h heq
  · exact supportPerm_injective_row_39 h heq
  · exact supportPerm_injective_row_40 h heq
  · exact supportPerm_injective_row_41 h heq
  · exact supportPerm_injective_row_42 h heq
  · exact supportPerm_injective_row_43 h heq
  · exact supportPerm_injective_row_44 h heq
  · exact supportPerm_injective_row_45 h heq
  · exact supportPerm_injective_row_46 h heq
  · exact supportPerm_injective_row_47 h heq
  · exact supportPerm_injective_row_48 h heq
  · exact supportPerm_injective_row_49 h heq
  · exact supportPerm_injective_row_50 h heq
  · exact supportPerm_injective_row_51 h heq
  · exact supportPerm_injective_row_52 h heq
  · exact supportPerm_injective_row_53 h heq
  · exact supportPerm_injective_row_54 h heq
  · exact supportPerm_injective_row_55 h heq
  · exact supportPerm_injective_row_56 h heq
  · exact supportPerm_injective_row_57 h heq
  · exact supportPerm_injective_row_58 h heq
  · exact supportPerm_injective_row_59 h heq

/-- The support family contains the identity and is closed under composition. -/
theorem support_family_closed :
    (∀ i : Fin 6, supportPerm 0 i = i) ∧
    ∀ g h : GroupIndex, ∃ k : GroupIndex, ∀ i : Fin 6,
      supportPerm k i = supportPerm g (supportPerm h i) := by
  constructor
  · exact support_family_identity
  · intro g
    fin_cases g
    · exact support_family_closed_row_0
    · exact support_family_closed_row_1
    · exact support_family_closed_row_2
    · exact support_family_closed_row_3
    · exact support_family_closed_row_4
    · exact support_family_closed_row_5
    · exact support_family_closed_row_6
    · exact support_family_closed_row_7
    · exact support_family_closed_row_8
    · exact support_family_closed_row_9
    · exact support_family_closed_row_10
    · exact support_family_closed_row_11
    · exact support_family_closed_row_12
    · exact support_family_closed_row_13
    · exact support_family_closed_row_14
    · exact support_family_closed_row_15
    · exact support_family_closed_row_16
    · exact support_family_closed_row_17
    · exact support_family_closed_row_18
    · exact support_family_closed_row_19
    · exact support_family_closed_row_20
    · exact support_family_closed_row_21
    · exact support_family_closed_row_22
    · exact support_family_closed_row_23
    · exact support_family_closed_row_24
    · exact support_family_closed_row_25
    · exact support_family_closed_row_26
    · exact support_family_closed_row_27
    · exact support_family_closed_row_28
    · exact support_family_closed_row_29
    · exact support_family_closed_row_30
    · exact support_family_closed_row_31
    · exact support_family_closed_row_32
    · exact support_family_closed_row_33
    · exact support_family_closed_row_34
    · exact support_family_closed_row_35
    · exact support_family_closed_row_36
    · exact support_family_closed_row_37
    · exact support_family_closed_row_38
    · exact support_family_closed_row_39
    · exact support_family_closed_row_40
    · exact support_family_closed_row_41
    · exact support_family_closed_row_42
    · exact support_family_closed_row_43
    · exact support_family_closed_row_44
    · exact support_family_closed_row_45
    · exact support_family_closed_row_46
    · exact support_family_closed_row_47
    · exact support_family_closed_row_48
    · exact support_family_closed_row_49
    · exact support_family_closed_row_50
    · exact support_family_closed_row_51
    · exact support_family_closed_row_52
    · exact support_family_closed_row_53
    · exact support_family_closed_row_54
    · exact support_family_closed_row_55
    · exact support_family_closed_row_56
    · exact support_family_closed_row_57
    · exact support_family_closed_row_58
    · exact support_family_closed_row_59


/-- The matrices realize their displayed support permutations on the certified Q11 witness. -/
theorem action_on_witness :
    ∀ g : GroupIndex, ∀ i : Fin 6,
      pointAction g (witnessIndex i) = witnessIndex (supportPerm g i) := by
  intro g
  fin_cases g
  · exact action_on_witness_row_0
  · exact action_on_witness_row_1
  · exact action_on_witness_row_2
  · exact action_on_witness_row_3
  · exact action_on_witness_row_4
  · exact action_on_witness_row_5
  · exact action_on_witness_row_6
  · exact action_on_witness_row_7
  · exact action_on_witness_row_8
  · exact action_on_witness_row_9
  · exact action_on_witness_row_10
  · exact action_on_witness_row_11
  · exact action_on_witness_row_12
  · exact action_on_witness_row_13
  · exact action_on_witness_row_14
  · exact action_on_witness_row_15
  · exact action_on_witness_row_16
  · exact action_on_witness_row_17
  · exact action_on_witness_row_18
  · exact action_on_witness_row_19
  · exact action_on_witness_row_20
  · exact action_on_witness_row_21
  · exact action_on_witness_row_22
  · exact action_on_witness_row_23
  · exact action_on_witness_row_24
  · exact action_on_witness_row_25
  · exact action_on_witness_row_26
  · exact action_on_witness_row_27
  · exact action_on_witness_row_28
  · exact action_on_witness_row_29
  · exact action_on_witness_row_30
  · exact action_on_witness_row_31
  · exact action_on_witness_row_32
  · exact action_on_witness_row_33
  · exact action_on_witness_row_34
  · exact action_on_witness_row_35
  · exact action_on_witness_row_36
  · exact action_on_witness_row_37
  · exact action_on_witness_row_38
  · exact action_on_witness_row_39
  · exact action_on_witness_row_40
  · exact action_on_witness_row_41
  · exact action_on_witness_row_42
  · exact action_on_witness_row_43
  · exact action_on_witness_row_44
  · exact action_on_witness_row_45
  · exact action_on_witness_row_46
  · exact action_on_witness_row_47
  · exact action_on_witness_row_48
  · exact action_on_witness_row_49
  · exact action_on_witness_row_50
  · exact action_on_witness_row_51
  · exact action_on_witness_row_52
  · exact action_on_witness_row_53
  · exact action_on_witness_row_54
  · exact action_on_witness_row_55
  · exact action_on_witness_row_56
  · exact action_on_witness_row_57
  · exact action_on_witness_row_58
  · exact action_on_witness_row_59

/-- Every reflected projectivity preserves the compact orbit-block label. -/
theorem orbitIndex_pointAction :
    ∀ g : GroupIndex, ∀ p : PointIndex,
      orbitIndex (pointAction g p) = orbitIndex p := by
  intro g
  fin_cases g
  · exact orbitIndex_pointAction_row_0
  · exact orbitIndex_pointAction_row_1
  · exact orbitIndex_pointAction_row_2
  · exact orbitIndex_pointAction_row_3
  · exact orbitIndex_pointAction_row_4
  · exact orbitIndex_pointAction_row_5
  · exact orbitIndex_pointAction_row_6
  · exact orbitIndex_pointAction_row_7
  · exact orbitIndex_pointAction_row_8
  · exact orbitIndex_pointAction_row_9
  · exact orbitIndex_pointAction_row_10
  · exact orbitIndex_pointAction_row_11
  · exact orbitIndex_pointAction_row_12
  · exact orbitIndex_pointAction_row_13
  · exact orbitIndex_pointAction_row_14
  · exact orbitIndex_pointAction_row_15
  · exact orbitIndex_pointAction_row_16
  · exact orbitIndex_pointAction_row_17
  · exact orbitIndex_pointAction_row_18
  · exact orbitIndex_pointAction_row_19
  · exact orbitIndex_pointAction_row_20
  · exact orbitIndex_pointAction_row_21
  · exact orbitIndex_pointAction_row_22
  · exact orbitIndex_pointAction_row_23
  · exact orbitIndex_pointAction_row_24
  · exact orbitIndex_pointAction_row_25
  · exact orbitIndex_pointAction_row_26
  · exact orbitIndex_pointAction_row_27
  · exact orbitIndex_pointAction_row_28
  · exact orbitIndex_pointAction_row_29
  · exact orbitIndex_pointAction_row_30
  · exact orbitIndex_pointAction_row_31
  · exact orbitIndex_pointAction_row_32
  · exact orbitIndex_pointAction_row_33
  · exact orbitIndex_pointAction_row_34
  · exact orbitIndex_pointAction_row_35
  · exact orbitIndex_pointAction_row_36
  · exact orbitIndex_pointAction_row_37
  · exact orbitIndex_pointAction_row_38
  · exact orbitIndex_pointAction_row_39
  · exact orbitIndex_pointAction_row_40
  · exact orbitIndex_pointAction_row_41
  · exact orbitIndex_pointAction_row_42
  · exact orbitIndex_pointAction_row_43
  · exact orbitIndex_pointAction_row_44
  · exact orbitIndex_pointAction_row_45
  · exact orbitIndex_pointAction_row_46
  · exact orbitIndex_pointAction_row_47
  · exact orbitIndex_pointAction_row_48
  · exact orbitIndex_pointAction_row_49
  · exact orbitIndex_pointAction_row_50
  · exact orbitIndex_pointAction_row_51
  · exact orbitIndex_pointAction_row_52
  · exact orbitIndex_pointAction_row_53
  · exact orbitIndex_pointAction_row_54
  · exact orbitIndex_pointAction_row_55
  · exact orbitIndex_pointAction_row_56
  · exact orbitIndex_pointAction_row_57
  · exact orbitIndex_pointAction_row_58
  · exact orbitIndex_pointAction_row_59

/-- Each explicit block is invariant under every reflected projectivity. -/
theorem orbitPoints_invariant (g : GroupIndex) (i : Fin 7) (p : PointIndex) :
    p ∈ orbitPoints i ↔ pointAction g p ∈ orbitPoints i := by
  rw [mem_orbitPoints_iff_orbitIndex i p,
    mem_orbitPoints_iff_orbitIndex i (pointAction g p), orbitIndex_pointAction g p]

/-- The order-five fixed-point union is exactly the witness plus the standard conic. -/
theorem order_five_fixed_union :
    orderFiveFixedUnion = witnessSet ∪ standardConicIndices ∧
      orderFiveFixedUnion.card = 18 := by
  have hset : orderFiveFixedUnion = witnessSet ∪ standardConicIndices := by
    ext p
    fin_cases p
    · exact orderFiveFixedUnion_mem_0
    · exact orderFiveFixedUnion_mem_1
    · exact orderFiveFixedUnion_mem_2
    · exact orderFiveFixedUnion_mem_3
    · exact orderFiveFixedUnion_mem_4
    · exact orderFiveFixedUnion_mem_5
    · exact orderFiveFixedUnion_mem_6
    · exact orderFiveFixedUnion_mem_7
    · exact orderFiveFixedUnion_mem_8
    · exact orderFiveFixedUnion_mem_9
    · exact orderFiveFixedUnion_mem_10
    · exact orderFiveFixedUnion_mem_11
    · exact orderFiveFixedUnion_mem_12
    · exact orderFiveFixedUnion_mem_13
    · exact orderFiveFixedUnion_mem_14
    · exact orderFiveFixedUnion_mem_15
    · exact orderFiveFixedUnion_mem_16
    · exact orderFiveFixedUnion_mem_17
    · exact orderFiveFixedUnion_mem_18
    · exact orderFiveFixedUnion_mem_19
    · exact orderFiveFixedUnion_mem_20
    · exact orderFiveFixedUnion_mem_21
    · exact orderFiveFixedUnion_mem_22
    · exact orderFiveFixedUnion_mem_23
    · exact orderFiveFixedUnion_mem_24
    · exact orderFiveFixedUnion_mem_25
    · exact orderFiveFixedUnion_mem_26
    · exact orderFiveFixedUnion_mem_27
    · exact orderFiveFixedUnion_mem_28
    · exact orderFiveFixedUnion_mem_29
    · exact orderFiveFixedUnion_mem_30
    · exact orderFiveFixedUnion_mem_31
    · exact orderFiveFixedUnion_mem_32
    · exact orderFiveFixedUnion_mem_33
    · exact orderFiveFixedUnion_mem_34
    · exact orderFiveFixedUnion_mem_35
    · exact orderFiveFixedUnion_mem_36
    · exact orderFiveFixedUnion_mem_37
    · exact orderFiveFixedUnion_mem_38
    · exact orderFiveFixedUnion_mem_39
    · exact orderFiveFixedUnion_mem_40
    · exact orderFiveFixedUnion_mem_41
    · exact orderFiveFixedUnion_mem_42
    · exact orderFiveFixedUnion_mem_43
    · exact orderFiveFixedUnion_mem_44
    · exact orderFiveFixedUnion_mem_45
    · exact orderFiveFixedUnion_mem_46
    · exact orderFiveFixedUnion_mem_47
    · exact orderFiveFixedUnion_mem_48
    · exact orderFiveFixedUnion_mem_49
    · exact orderFiveFixedUnion_mem_50
    · exact orderFiveFixedUnion_mem_51
    · exact orderFiveFixedUnion_mem_52
    · exact orderFiveFixedUnion_mem_53
    · exact orderFiveFixedUnion_mem_54
    · exact orderFiveFixedUnion_mem_55
    · exact orderFiveFixedUnion_mem_56
    · exact orderFiveFixedUnion_mem_57
    · exact orderFiveFixedUnion_mem_58
    · exact orderFiveFixedUnion_mem_59
    · exact orderFiveFixedUnion_mem_60
    · exact orderFiveFixedUnion_mem_61
    · exact orderFiveFixedUnion_mem_62
    · exact orderFiveFixedUnion_mem_63
    · exact orderFiveFixedUnion_mem_64
    · exact orderFiveFixedUnion_mem_65
    · exact orderFiveFixedUnion_mem_66
    · exact orderFiveFixedUnion_mem_67
    · exact orderFiveFixedUnion_mem_68
    · exact orderFiveFixedUnion_mem_69
    · exact orderFiveFixedUnion_mem_70
    · exact orderFiveFixedUnion_mem_71
    · exact orderFiveFixedUnion_mem_72
    · exact orderFiveFixedUnion_mem_73
    · exact orderFiveFixedUnion_mem_74
    · exact orderFiveFixedUnion_mem_75
    · exact orderFiveFixedUnion_mem_76
    · exact orderFiveFixedUnion_mem_77
    · exact orderFiveFixedUnion_mem_78
    · exact orderFiveFixedUnion_mem_79
    · exact orderFiveFixedUnion_mem_80
    · exact orderFiveFixedUnion_mem_81
    · exact orderFiveFixedUnion_mem_82
    · exact orderFiveFixedUnion_mem_83
    · exact orderFiveFixedUnion_mem_84
    · exact orderFiveFixedUnion_mem_85
    · exact orderFiveFixedUnion_mem_86
    · exact orderFiveFixedUnion_mem_87
    · exact orderFiveFixedUnion_mem_88
    · exact orderFiveFixedUnion_mem_89
    · exact orderFiveFixedUnion_mem_90
    · exact orderFiveFixedUnion_mem_91
    · exact orderFiveFixedUnion_mem_92
    · exact orderFiveFixedUnion_mem_93
    · exact orderFiveFixedUnion_mem_94
    · exact orderFiveFixedUnion_mem_95
    · exact orderFiveFixedUnion_mem_96
    · exact orderFiveFixedUnion_mem_97
    · exact orderFiveFixedUnion_mem_98
    · exact orderFiveFixedUnion_mem_99
    · exact orderFiveFixedUnion_mem_100
    · exact orderFiveFixedUnion_mem_101
    · exact orderFiveFixedUnion_mem_102
    · exact orderFiveFixedUnion_mem_103
    · exact orderFiveFixedUnion_mem_104
    · exact orderFiveFixedUnion_mem_105
    · exact orderFiveFixedUnion_mem_106
    · exact orderFiveFixedUnion_mem_107
    · exact orderFiveFixedUnion_mem_108
    · exact orderFiveFixedUnion_mem_109
    · exact orderFiveFixedUnion_mem_110
    · exact orderFiveFixedUnion_mem_111
    · exact orderFiveFixedUnion_mem_112
    · exact orderFiveFixedUnion_mem_113
    · exact orderFiveFixedUnion_mem_114
    · exact orderFiveFixedUnion_mem_115
    · exact orderFiveFixedUnion_mem_116
    · exact orderFiveFixedUnion_mem_117
    · exact orderFiveFixedUnion_mem_118
    · exact orderFiveFixedUnion_mem_119
    · exact orderFiveFixedUnion_mem_120
    · exact orderFiveFixedUnion_mem_121
    · exact orderFiveFixedUnion_mem_122
    · exact orderFiveFixedUnion_mem_123
    · exact orderFiveFixedUnion_mem_124
    · exact orderFiveFixedUnion_mem_125
    · exact orderFiveFixedUnion_mem_126
    · exact orderFiveFixedUnion_mem_127
    · exact orderFiveFixedUnion_mem_128
    · exact orderFiveFixedUnion_mem_129
    · exact orderFiveFixedUnion_mem_130
    · exact orderFiveFixedUnion_mem_131
    · exact orderFiveFixedUnion_mem_132
  exact ⟨hset, by rw [hset]; decide⟩

/-- The full triple-point set is invariant under every reflected projectivity. -/
theorem triplePointSet_invariant :
    ∀ g : GroupIndex, ∀ p : PointIndex,
      p ∈ triplePointSet ↔ pointAction g p ∈ triplePointSet := by
  intro g p
  rw [triplePointSet_eq_brianchonSet, ← brianchon_points_one_orbit.2]
  exact orbitPoints_invariant g 3 p

#print axioms matrices_nonsingular
#print axioms matrixVec_pointVec_ne_zero
#print axioms pointVec_witnessIndex
#print axioms action_on_witness
#print axioms supportPerm_permutation
#print axioms supportPerm_injective
#print axioms support_family_closed
#print axioms order_five_count
#print axioms mem_orbitPoints_iff_orbitIndex
#print axioms orbitIndex_pointAction
#print axioms orbitPoints_invariant
#print axioms representative_pointOrbit
#print axioms point_orbit_partition
#print axioms mem_standardConicIndices_iff
#print axioms unique_six_orbit
#print axioms unique_twelve_orbit
#print axioms order_five_fixed_union
#print axioms brianchon_points_one_orbit
#print axioms triplePointSet_invariant

end RelativeConicArcs.Examples.Q11A5PointOrbits
