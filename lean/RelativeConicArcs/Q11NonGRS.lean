import RelativeConicArcs.Q11Coding

/-!
# Algebraic closure of the q=11 non-GRS argument

The classical normal-rational-curve/GRS dictionary supplies exactly the predicate below: a
projectively GRS column system in dimension three lies on a nonzero homogeneous quadratic.
This file kernel-checks the remaining implication for the displayed six columns.
-/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate Matrix

/-- The algebraic consequence of being projectively GRS that is used in the manuscript. -/
def HasGRSQuadratic (v : Fin 6 → Vec (ZMod 11)) : Prop :=
  ∃ c : Fin 6 → ZMod 11, c ≠ 0 ∧ ∀ i, dotProduct (quadraticFeatures (v i)) c = 0

/-- The six displayed parity-check columns do not satisfy the GRS quadratic consequence. -/
theorem witness_not_hasGRSQuadratic : ¬ HasGRSQuadratic witnessVec := by
  rintro ⟨c, hc, hvanish⟩
  apply hc
  apply no_nonzero_quadratic_vanishing c
  funext i
  simpa [quadraticEvaluationMatrix, Matrix.mulVec] using hvanish i

/-- Any external projectively-GRS predicate that entails the standard NRC quadratic consequence
is false for the displayed witness.  Instantiating the premise is precisely the classical
normal-rational-curve/GRS dictionary. -/
theorem witness_not_projectivelyGRS_of_implies_quadratic
    (ProjectivelyGRS : (Fin 6 → Vec (ZMod 11)) → Prop)
    (dictionary : ∀ v, ProjectivelyGRS v → HasGRSQuadratic v) :
    ¬ ProjectivelyGRS witnessVec := by
  intro hgrs
  exact witness_not_hasGRSQuadratic (dictionary witnessVec hgrs)

#print axioms witness_not_hasGRSQuadratic
#print axioms witness_not_projectivelyGRS_of_implies_quadratic

end RelativeConicArcs.Examples.Q11Coding
