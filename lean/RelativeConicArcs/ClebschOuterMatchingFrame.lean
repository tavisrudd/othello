import RelativeConicArcs.ClebschOuterJoubertFrame
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# One-factorizations of the six labels and the complementary triangle colouring

A one-factorization of the complete graph on the six labels is a family of five
perfect matchings, indexed here by a colour, such that every unordered pair of
distinct labels lies in exactly one of them.  Each matching is recorded as the
fixed-point-free involution of the six labels that it induces.

Such a family colours the three-element subsets.  Fix a triple `S` and write
`Sᶜ` for its complementary triple.  Each of the three edges inside `S` lies in a
matching, and that matching also contains an edge inside `Sᶜ`: having used one
edge of `S` it must pair the remaining label of `S` with a label of `Sᶜ`, which
leaves the other two labels of `Sᶜ` paired with each other.  So the three edges
inside `S` and the three edges inside `Sᶜ` are put in bijection, and since an
edge of a triple is named by the label it omits, this is a bijection from `S` to
`Sᶜ`.  Writing both triples in increasing order turns that bijection into a
permutation of three letters; the complementary triangle colouring of `S` is the
sign of that permutation times the sign of the permutation listing `S` before
`Sᶜ`, that is, minus one to the sum of the labels of `S` shifted by three.

The bijection is presented here without a choice function: the incidence matrix
whose `(k, l)` entry is one exactly when the edge of `S` omitting its `k`-th
label and the edge of `Sᶜ` omitting its `l`-th label lie in a common matching is
a permutation matrix, and its determinant is the sign wanted.

The six one-factorizations listed below produce exactly the six coefficient
words of `RelativeConicArcs.ClebschOuterJoubertFrame`, in the same order, and
every one-factorization produces one of those six words.  So the outer family of
signed translates of the triangle cubic is exactly the family of complementary
triangle colourings of the one-factorizations of the six labels, and since the
six words are pairwise distinct there are exactly six such colourings.

The converse half is proved by normalizing the colours.  Each matching of a
one-factorization uses a different label at the label `0`, so the colours can be
renamed to be listed by that label; the colouring does not see the names of the
colours, so this loses nothing.  A normalized family then chooses, for each of
the five labels other than `0`, one of the three matchings through the
corresponding edge at `0`, and among those two hundred and forty-three
candidates the partitioning condition selects exactly the six listed families.
That every fixed-point-free involution using a given label at `0` is one of the
three listed matchings is itself decided over all six-tuples of labels.

Every statement about the explicit tables is an exhaustive kernel decision over
its finite index domain: thirty ordered pairs of distinct labels for the
partitioning property, one hundred and twenty pairs of a one-factorization and a
triple for the colouring, the five-by-six-to-the-fifth tuples for the matching
classification, and the two hundred and forty-three normalized candidates.
-/

namespace RelativeConicArcs.ClebschOuterMatchingFrame

open RelativeConicArcs.ClebschOuterJoubertFrame

/-- A family of five involutions of the six labels is a one-factorization when
each is a fixed-point-free involution — that is, a perfect matching — and every
unordered pair of distinct labels lies in exactly one of them. -/
def IsOneFactorization (F : Fin 5 → Fin 6 → Fin 6) : Prop :=
  (∀ c i, F c (F c i) = i) ∧ (∀ c i, F c i ≠ i) ∧
    (∀ i j, i ≠ j → (Finset.univ.filter fun c => F c i = j).card = 1)

/-- The partitioning clause of a one-factorization, in the form it states: every
unordered pair of distinct labels lies in exactly one matching of the family. -/
theorem existsUnique_of_isOneFactorization {F : Fin 5 → Fin 6 → Fin 6}
    (hF : IsOneFactorization F) {i j : Fin 6} (hij : i ≠ j) :
    ∃! c, F c i = j := by
  obtain ⟨c, hc⟩ := Finset.card_eq_one.mp (hF.2.2 i j hij)
  refine ⟨c, ?_, fun d hd => ?_⟩
  · have hmem : c ∈ Finset.univ.filter fun e => F e i = j := by
      rw [hc]; exact Finset.mem_singleton_self c
    simpa using hmem
  · have hmem : d ∈ Finset.univ.filter fun e => F e i = j := by simp [hd]
    rw [hc] at hmem
    simpa using hmem

instance (F : Fin 5 → Fin 6 → Fin 6) : Decidable (IsOneFactorization F) := by
  unfold IsOneFactorization; infer_instance

/-- Two ordered pairs of labels lie in a common matching of the family. -/
def SameMatching (F : Fin 5 → Fin 6 → Fin 6) (i j i' j' : Fin 6) : Prop :=
  ∃ c, F c i = j ∧ F c i' = j'

instance (F : Fin 5 → Fin 6 → Fin 6) (i j i' j' : Fin 6) :
    Decidable (SameMatching F i j i' j') := by
  unfold SameMatching; infer_instance

/-- The increasing complementary triple of each of the twenty increasing
triples, in the order used by `tripleLabel`. -/
def complementLabel : Fin 20 → Fin 6 × Fin 6 × Fin 6 :=
  ![(3, 4, 5), (2, 4, 5), (2, 3, 5), (2, 3, 4), (1, 4, 5),
    (1, 3, 5), (1, 3, 4), (1, 2, 5), (1, 2, 4), (1, 2, 3),
    (0, 4, 5), (0, 3, 5), (0, 3, 4), (0, 2, 5), (0, 2, 4),
    (0, 2, 3), (0, 1, 5), (0, 1, 4), (0, 1, 3), (0, 1, 2)]

/-- The listed complementary triples really are complementary: no label occurs
both in a triple and in its listed complement, and the six labels of the two
triples together are all six labels. -/
theorem complementLabel_disjoint (n : Fin 20) (i : Fin 6) :
    (i = (tripleLabel n).1 ∨ i = (tripleLabel n).2.1 ∨ i = (tripleLabel n).2.2) ↔
      ¬ (i = (complementLabel n).1 ∨ i = (complementLabel n).2.1 ∨
        i = (complementLabel n).2.2) := by
  decide +kernel +revert

/-- The edge of a triple obtained by omitting its `k`-th label, as an ordered
pair of the two remaining labels. -/
def omittedEdge (S : Fin 6 × Fin 6 × Fin 6) : Fin 3 → Fin 6 × Fin 6 :=
  ![(S.2.1, S.2.2), (S.1, S.2.2), (S.1, S.2.1)]

/-- The incidence matrix between the three edges inside a triple and the three
edges inside its complement: the entry at `(k, l)` is one exactly when the two
edges lie in a common matching of the family. -/
def crossIncidence (F : Fin 5 → Fin 6 → Fin 6) (n : Fin 20) :
    Matrix (Fin 3) (Fin 3) ℤ :=
  Matrix.of fun k l =>
    if SameMatching F (omittedEdge (tripleLabel n) k).1 (omittedEdge (tripleLabel n) k).2
        (omittedEdge (complementLabel n) l).1 (omittedEdge (complementLabel n) l).2
      then 1 else 0

/-- The sign of the permutation listing a triple before its increasing
complement: minus one to the number of inversions of that listing, which is the
sum of the labels of the triple less three. -/
def complementSign (n : Fin 20) : ℤ :=
  if ((tripleLabel n).1.val + (tripleLabel n).2.1.val + (tripleLabel n).2.2.val) % 2 = 0
    then -1 else 1

/-- The complementary triangle colouring of a one-factorization: the sign of the
bijection it induces from a triple to its complement, corrected by the sign of
the listing of the triple before its complement. -/
def matchingColouring (F : Fin 5 → Fin 6 → Fin 6) (n : Fin 20) : ℤ :=
  complementSign n * Matrix.det (crossIncidence F n)

/-- Six one-factorizations of the six labels.  The colour `c` is the matching
containing the edge joining the label `0` to the label `c + 1`, so the five
colours are listed in the order of the partner of the label `0`. -/
def oneFactorization : Fin 6 → Fin 5 → Fin 6 → Fin 6 :=
  ![![![1, 0, 3, 2, 5, 4],
     ![2, 4, 0, 5, 1, 3],
     ![3, 5, 4, 0, 2, 1],
     ![4, 3, 5, 1, 0, 2],
     ![5, 2, 1, 4, 3, 0]],
    ![![1, 0, 3, 2, 5, 4],
     ![2, 5, 0, 4, 3, 1],
     ![3, 4, 5, 0, 1, 2],
     ![4, 2, 1, 5, 0, 3],
     ![5, 3, 4, 1, 2, 0]],
    ![![1, 0, 4, 5, 2, 3],
     ![2, 3, 0, 1, 5, 4],
     ![3, 4, 5, 0, 1, 2],
     ![4, 5, 3, 2, 0, 1],
     ![5, 2, 1, 4, 3, 0]],
    ![![1, 0, 4, 5, 2, 3],
     ![2, 5, 0, 4, 3, 1],
     ![3, 2, 1, 0, 5, 4],
     ![4, 3, 5, 1, 0, 2],
     ![5, 4, 3, 2, 1, 0]],
    ![![1, 0, 5, 4, 3, 2],
     ![2, 3, 0, 1, 5, 4],
     ![3, 5, 4, 0, 2, 1],
     ![4, 2, 1, 5, 0, 3],
     ![5, 4, 3, 2, 1, 0]],
    ![![1, 0, 5, 4, 3, 2],
     ![2, 4, 0, 5, 1, 3],
     ![3, 2, 1, 0, 5, 4],
     ![4, 5, 3, 2, 0, 1],
     ![5, 3, 4, 1, 2, 0]]]

/-- Each of the six listed families is a one-factorization. -/
theorem isOneFactorization_oneFactorization (t : Fin 6) :
    IsOneFactorization (oneFactorization t) := by
  refine ⟨?_, ?_, ?_⟩ <;> decide +kernel +revert

/-- The complementary triangle colouring of the `t`-th listed one-factorization
is the `t`-th coefficient word of the outer family.  This identifies the six
signed translates of the triangle cubic of the fixed conference matrix with the
coloured-triangle forms of six one-factorizations of the six labels. -/
theorem matchingColouring_oneFactorization (t : Fin 6) (n : Fin 20) :
    matchingColouring (oneFactorization t) n = outerColouring t n := by
  decide +kernel +revert

/-- The six listed one-factorizations are pairwise distinct, since their
complementary triangle colourings are the six pairwise distinct coefficient
words. -/
theorem oneFactorization_injective : Function.Injective oneFactorization := by
  intro t t' h
  refine outerColouring_injective (funext fun n => ?_)
  rw [← matchingColouring_oneFactorization t n, ← matchingColouring_oneFactorization t' n, h]

/-- The three perfect matchings of the six labels containing the edge joining
the label `0` to the label `c + 1`. -/
def matchingThrough : Fin 5 → Fin 3 → Fin 6 → Fin 6 :=
  ![![![1, 0, 3, 2, 5, 4], ![1, 0, 4, 5, 2, 3], ![1, 0, 5, 4, 3, 2]],
    ![![2, 3, 0, 1, 5, 4], ![2, 4, 0, 5, 1, 3], ![2, 5, 0, 4, 3, 1]],
    ![![3, 2, 1, 0, 5, 4], ![3, 4, 5, 0, 1, 2], ![3, 5, 4, 0, 2, 1]],
    ![![4, 2, 1, 5, 0, 3], ![4, 3, 5, 1, 0, 2], ![4, 5, 3, 2, 0, 1]],
    ![![5, 2, 1, 4, 3, 0], ![5, 3, 4, 1, 2, 0], ![5, 4, 3, 2, 1, 0]]]

/-- Every fixed-point-free involution of the six labels sending `0` to `c + 1`
is one of the three listed matchings through that edge.  The statement is
decided over all six-tuples of labels: a fixed-point-free involution is exactly
such a tuple satisfying the two displayed conditions. -/
private theorem tuple_eq_matchingThrough :
    ∀ (c : Fin 5) (v1 v2 v3 v4 v5 : Fin 6),
      (∀ i, ![c.succ, v1, v2, v3, v4, v5] (![c.succ, v1, v2, v3, v4, v5] i) = i) →
      (∀ i, ![c.succ, v1, v2, v3, v4, v5] i ≠ i) →
      ∃ g : Fin 3, ∀ i, ![c.succ, v1, v2, v3, v4, v5] i = matchingThrough c g i := by
  decide +kernel

/-- Every fixed-point-free involution of the six labels is one of the three
matchings through the edge it uses at the label `0`. -/
theorem exists_eq_matchingThrough (m : Fin 6 → Fin 6)
    (hinv : ∀ i, m (m i) = i) (hfix : ∀ i, m i ≠ i) (c : Fin 5) (h0 : m 0 = c.succ) :
    ∃ g : Fin 3, m = matchingThrough c g := by
  have hm : ∀ i, ![c.succ, m 1, m 2, m 3, m 4, m 5] i = m i := by
    intro i; fin_cases i
    · exact h0.symm
    all_goals rfl
  obtain ⟨g, hg⟩ := tuple_eq_matchingThrough c (m 1) (m 2) (m 3) (m 4) (m 5)
    (by intro i; rw [hm, hm]; exact hinv i) (by intro i; rw [hm]; exact hfix i)
  exact ⟨g, funext fun i => by rw [← hm i]; exact hg i⟩

/-- A one-factorization whose colours are ordered by the partner they give the
label `0` is one of the six listed.  The choice of one matching through each
edge at `0` is a function from the five colours to three values, and the
partitioning condition selects exactly the six listed families among those two
hundred and forty-three candidates. -/
private theorem rooted_classification :
    ∀ g : Fin 5 → Fin 3,
      IsOneFactorization (fun c => matchingThrough c (g c)) →
      ∃ t : Fin 6, ∀ c i, matchingThrough c (g c) i = oneFactorization t c i := by
  decide +kernel

/-- Renaming the colours of a one-factorization along a permutation gives a
one-factorization. -/
theorem isOneFactorization_comp (F : Fin 5 → Fin 6 → Fin 6)
    (hF : IsOneFactorization F) (σ : Equiv.Perm (Fin 5)) :
    IsOneFactorization (fun c => F (σ c)) := by
  refine ⟨fun c i => hF.1 (σ c) i, fun c i => hF.2.1 (σ c) i, fun i j hij => ?_⟩
  rw [← hF.2.2 i j hij]
  refine Finset.card_equiv σ (fun c => ?_)
  simp

/-- Renaming the colours does not change which pairs lie in a common
matching. -/
theorem sameMatching_comp (F : Fin 5 → Fin 6 → Fin 6) (σ : Equiv.Perm (Fin 5))
    (i j i' j' : Fin 6) :
    SameMatching (fun c => F (σ c)) i j i' j' ↔ SameMatching F i j i' j' := by
  constructor
  · rintro ⟨c, h1, h2⟩
    exact ⟨σ c, h1, h2⟩
  · rintro ⟨c, h1, h2⟩
    exact ⟨σ.symm c, by simpa using h1, by simpa using h2⟩

/-- The complementary triangle colouring does not depend on the names of the
colours. -/
theorem matchingColouring_comp (F : Fin 5 → Fin 6 → Fin 6) (σ : Equiv.Perm (Fin 5))
    (n : Fin 20) :
    matchingColouring (fun c => F (σ c)) n = matchingColouring F n := by
  have : crossIncidence (fun c => F (σ c)) n = crossIncidence F n := by
    ext k l
    simp only [crossIncidence, Matrix.of_apply]
    exact if_congr (sameMatching_comp F σ _ _ _ _) rfl rfl
  rw [matchingColouring, matchingColouring, this]

/-- The complementary triangle colouring of every one-factorization of the six
labels is one of the six coefficient words of the outer family.  With the
converse statement `matchingColouring_oneFactorization` this identifies the
outer family with the family of complementary triangle colourings of the
one-factorizations, and in particular shows that there are exactly six such
colourings. -/
theorem exists_outerColouring_of_isOneFactorization (F : Fin 5 → Fin 6 → Fin 6)
    (hF : IsOneFactorization F) :
    ∃ t : Fin 6, ∀ n, matchingColouring F n = outerColouring t n := by
  have hne : ∀ c, F c 0 ≠ 0 := fun c => hF.2.1 c 0
  have hroot : ∀ c, ((F c 0).pred (hne c)).succ = F c 0 := fun c => Fin.succ_pred _ _
  have hinj : Function.Injective fun c => (F c 0).pred (hne c) := by
    intro c c' h
    have hval : F c 0 = F c' 0 := by
      rw [← hroot c, ← hroot c']
      exact congrArg Fin.succ h
    obtain ⟨d, _, huniq⟩ := existsUnique_of_isOneFactorization hF (Ne.symm (hne c))
    rw [huniq c rfl, huniq c' hval.symm]
  obtain ⟨σ, hσ⟩ : ∃ σ : Equiv.Perm (Fin 5), ∀ c, (F (σ c) 0).pred (hne (σ c)) = c := by
    let e := Equiv.ofBijective (fun c => (F c 0).pred (hne c))
      (Finite.injective_iff_bijective.mp hinj)
    exact ⟨e.symm, fun c => e.apply_symm_apply c⟩
  have hGroot : ∀ c, F (σ c) 0 = c.succ := by
    intro c
    rw [← hroot (σ c), hσ c]
  have hGmatch : ∀ c, ∃ g : Fin 3, F (σ c) = matchingThrough c g := fun c =>
    exists_eq_matchingThrough _ (hF.1 (σ c)) (hF.2.1 (σ c)) c (hGroot c)
  choose g hg using hGmatch
  have hGeq : (fun c => F (σ c)) = fun c => matchingThrough c (g c) := funext hg
  have hGfac : IsOneFactorization fun c => matchingThrough c (g c) := by
    rw [← hGeq]; exact isOneFactorization_comp F hF σ
  obtain ⟨t, ht⟩ := rooted_classification g hGfac
  refine ⟨t, fun n => ?_⟩
  rw [← matchingColouring_comp F σ n, hGeq]
  rw [show (fun c => matchingThrough c (g c)) = oneFactorization t from
    funext fun c => funext fun i => ht c i]
  exact matchingColouring_oneFactorization t n

/-- The `t`-th outer cubic is the coloured-triangle cubic of the complementary
triangle colouring of the `t`-th one-factorization, coefficient by
coefficient. -/
theorem outerCubic_eq_matchingColouringCubic {R : Type*} [CommRing R]
    (x : Fin 6 → R) (t : Fin 6) :
    ClebschOuterSegreRelations.outerCubic x t =
      colouringCubic (fun n => ((matchingColouring (oneFactorization t) n : ℤ) : R)) x := by
  rw [outerCubic_eq_colouringCubic x t]
  simp only [matchingColouring_oneFactorization]

end RelativeConicArcs.ClebschOuterMatchingFrame
