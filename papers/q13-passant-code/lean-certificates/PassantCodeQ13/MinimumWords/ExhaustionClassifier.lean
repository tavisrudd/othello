import PassantCodeQ13.MinimumWords.Exhaustion

/-!
# Transparent classifiers for fixed-point exhaustion

Generated balanced trees are accelerating classifiers only.  Kernel checks prove their behavior on
the complete semantic half-domains; symbolic reasoning turns equality of full syndromes into a
contradiction.  No ordering or coverage assertion about generated data is trusted.
-/

namespace PassantCodeQ13.MinimumWords

/-- A transparent balanced decision tree over exact incidence syndromes. -/
inductive SyndromeClassifier where
  | reject
  | branch (pivot : Nat) (left right : SyndromeClassifier)

/-- Exact membership decision performed by a generated balanced tree. -/
def SyndromeClassifier.accepts (classifier : SyndromeClassifier) (target : Nat) : Bool :=
  match classifier with
  | .reject => false
  | .branch pivot left right =>
      if target == pivot then true
      else if target < pivot then left.accepts target else right.accepts target

/-- Computational check for one distinguished-fibre shard of the five-one profile. -/
def fiveOneShardCheck (special : Nat) (classifier : SyndromeClassifier) : Bool :=
  ((fiveOneLeft special).all fun leftPoints =>
    classifier.accepts (xorCachedColumns leftPoints)) &&
  ((fiveOneRight special).all fun rightPoints =>
    !classifier.accepts
      (cachedColumnSyndromes.getD 0 0 ^^^ xorCachedColumns rightPoints))

end PassantCodeQ13.MinimumWords
