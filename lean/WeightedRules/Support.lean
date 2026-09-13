import WeightedRules.ConvergenceReflection

/-!
# Support certificates: least fixedness without replay

A valuation of a finite polynomial program is its least fixed point in the
information order exactly when it is fixed and every value is *supported*:
zero, or the base fact of its coordinate, or the product of one listed rule
whose two factors have strictly smaller rank under some well-founded ranking.
The ranking is what excludes an unsupported cycle, which is fixed but not
least. Checking a support certificate is one pass over the coordinates and
one pass over the rules; it does not recompute the Kleene iterate, so its
cost does not grow with the number of rounds the producer needed.

`justified_le` is the inductive step: a supported value lies below the next
iterate of any valuation that already dominates the lower-ranked coordinates.
Applied to the certified valuation itself it gives fixedness; applied along
the ranks to an arbitrary fixed valuation it gives leastness. The argument
uses only the idempotent-semiring laws, so it holds for every admitted scalar
algebra with decidable equality. The bounded min-plus checker at the end reads
the certificate as three lists in scalar order and converts an accepted
certificate into the existing replay-checked solution by proof, not by
replay, since both denote the unique least fixed point.
-/

namespace WeightedRules

variable {W : Type} {n : Nat}

/-- The information order is an equation, hence decidable with scalar equality. -/
instance (A : ScalarAlgebra W) [DecidableEq W] (a b : W) : Decidable (InfoLe A a b) :=
  inferInstanceAs (Decidable (A.add a b = b))

/-- Every alternative absorbs its left summand. -/
theorem le_add_left (A : ScalarAlgebra W) (a b : W) : InfoLe A a (A.add a b) := by
  unfold InfoLe
  rw [← A.add_assoc, A.add_idem]

/-- Every alternative absorbs its right summand. -/
theorem le_add_right (A : ScalarAlgebra W) (a b : W) : InfoLe A b (A.add a b) := by
  unfold InfoLe
  rw [A.add_comm a b, ← A.add_assoc, A.add_idem]

/-- An alternative of two values below a bound stays below it. -/
theorem add_le (A : ScalarAlgebra W) {a b c : W}
    (ha : InfoLe A a c) (hb : InfoLe A b c) : InfoLe A (A.add a b) c := by
  have h := add_mono A ha hb
  rwa [A.add_idem] at h

/-- Contributions stay below a valuation that dominates every listed product. -/
theorem contributions_le (A : ScalarAlgebra W) (rules : List (ProductRule n))
    (x : State W n)
    (h : ∀ r ∈ rules, InfoLe A (A.mul (x r.left) (x r.right)) (x r.output)) (i : Fin n) :
    InfoLe A (contributions A rules x i) (x i) := by
  induction rules with
  | nil => exact zero_le A _
  | cons r rs ih =>
    simp only [contributions]
    apply add_le A
    · by_cases hr : r.output = i
      · rw [if_pos hr]
        subst hr
        exact h r (by simp)
      · rw [if_neg hr]
        exact zero_le A _
    · exact ih fun s hs => h s (by simp [hs])

/-- A listed product lies below the contributions to its output. -/
theorem contribution_le (A : ScalarAlgebra W) (rules : List (ProductRule n))
    (x : State W n) {r : ProductRule n} (hr : r ∈ rules) :
    InfoLe A (A.mul (x r.left) (x r.right)) (contributions A rules x r.output) := by
  induction rules with
  | nil => simp at hr
  | cons s rs ih =>
    simp only [contributions]
    rcases List.mem_cons.mp hr with h | h
    · subst h
      rw [if_pos rfl]
      exact le_add_left A _ _
    · exact info_trans A (ih h) (le_add_right A _ _)

/-- The support claim for one coordinate: its value is zero, or the base fact
(witness `0`), or the product of rule `k` (witness `k + 1`) with both factors
of strictly smaller rank. -/
def justified (A : ScalarAlgebra W) [DecidableEq W] (P : Program W n) (x : State W n)
    (rank witness : Fin n → Nat) (i : Fin n) : Bool :=
  if x i = A.zero then true
  else
    match witness i with
    | 0 => decide (x i = P.inputs i)
    | k + 1 =>
      match P.rules[k]? with
      | some r => decide (r.output = i ∧ x i = A.mul (x r.left) (x r.right) ∧
          rank r.left < rank i ∧ rank r.right < rank i)
      | none => false

/-- A justified value lies below the next iterate of any valuation dominating
the lower-ranked coordinates. -/
theorem justified_le (A : ScalarAlgebra W) [DecidableEq W] (P : Program W n)
    (x : State W n) (rank witness : Fin n → Nat) (i : Fin n)
    (h : justified A P x rank witness i = true) (y : State W n)
    (hy : ∀ j, rank j < rank i → InfoLe A (x j) (y j)) :
    InfoLe A (x i) (step A P y i) := by
  unfold justified at h
  by_cases hz : x i = A.zero
  · rw [hz]
    exact zero_le A _
  rw [if_neg hz] at h
  unfold step
  cases hw : witness i with
  | zero =>
    rw [hw] at h
    rw [of_decide_eq_true h]
    exact le_add_left A _ _
  | succ k =>
    rw [hw] at h
    simp only [] at h
    cases hr : P.rules[k]? with
    | none => simp only [hr] at h; exact absurd h Bool.false_ne_true
    | some r =>
      simp only [hr] at h
      obtain ⟨ho, hx, hl, hrr⟩ := of_decide_eq_true h
      subst ho
      rw [hx]
      exact info_trans A (mul_mono A (hy _ hl) (hy _ hrr))
        (info_trans A (contribution_le A P.rules y (List.mem_of_getElem? hr))
          (le_add_right A _ _))

/-- Local fixedness and well-founded support: base facts and listed products
lie below the valuation, and every coordinate is justified. -/
def supported (A : ScalarAlgebra W) [DecidableEq W] (P : Program W n) (x : State W n)
    (rank witness : Fin n → Nat) : Bool :=
  decide (∀ i, InfoLe A (P.inputs i) (x i)) &&
    decide (∀ r ∈ P.rules, InfoLe A (A.mul (x r.left) (x r.right)) (x r.output)) &&
    decide (∀ i, justified A P x rank witness i = true)

/-- A supported valuation is the least fixed point in the information order. -/
theorem supported_least (A : ScalarAlgebra W) [DecidableEq W] (P : Program W n)
    (x : State W n) (rank witness : Fin n → Nat)
    (h : supported A P x rank witness = true) :
    step A P x = x ∧ ∀ y, step A P y = y → StateLe A x y := by
  simp only [supported, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨hin, hrules⟩, hjust⟩ := h
  have upper : ∀ i, InfoLe A (step A P x i) (x i) :=
    fun i => add_le A (hin i) (contributions_le A P.rules x hrules i)
  refine ⟨funext fun i => info_antisymm A (upper i)
    (justified_le A P x rank witness i (hjust i) x fun j _ => info_refl A _), ?_⟩
  intro y hy
  suffices key : ∀ m, ∀ i, rank i < m → InfoLe A (x i) (y i) from
    fun i => key (rank i + 1) i (Nat.lt_succ_self _)
  intro m
  induction m with
  | zero => exact fun i hi => absurd hi (Nat.not_lt_zero _)
  | succ m ih =>
    intro i hi
    have step_le := justified_le A P x rank witness i (hjust i) y
      fun j hj => ih j (by omega)
    rwa [hy] at step_le

/-- Bounded min-plus support certificate: values, ranks and rule witnesses in
scalar order, with exact coverage of the values. Missing rank or witness
entries read as zero and are then rejected by the justification check unless
the coordinate is zero or a base fact. -/
def checkSupportCertificate (P : Program Cost n) (values : List Cost)
    (ranks witnesses : List Nat) : Bool :=
  decide (values.length = n) &&
    supported boundedMinPlus P (listState values)
      (fun i => ranks[i.val]?.getD 0) (fun i => witnesses[i.val]?.getD 0)

/-- Acceptance proves least fixedness of the certified values. -/
theorem checkSupportCertificate_sound (P : Program Cost n) (values : List Cost)
    (ranks witnesses : List Nat)
    (accepted : checkSupportCertificate P values ranks witnesses = true) :
    IsLeastFixed P (listState values) := by
  simp only [checkSupportCertificate, Bool.and_eq_true] at accepted
  exact supported_least boundedMinPlus P (listState values) _ _ accepted.2

/-- A valuation with an accepted support certificate. -/
structure SupportedSolution {n : Nat} (P : Program Cost n) where
  values : List Cost
  ranks : List Nat
  witnesses : List Nat
  accepted : checkSupportCertificate P values ranks witnesses = true

/-- Every supported solution supplies a kernel proof of least fixedness. -/
theorem SupportedSolution.least {P : Program Cost n} (s : SupportedSolution P) :
    IsLeastFixed P (listState s.values) :=
  checkSupportCertificate_sound P s.values s.ranks s.witnesses s.accepted

/-- The certified values have exactly one entry per coordinate. -/
theorem SupportedSolution.length {P : Program Cost n} (s : SupportedSolution P) :
    s.values.length = n := by
  have h := s.accepted
  simp only [checkSupportCertificate, Bool.and_eq_true, decide_eq_true_eq] at h
  exact h.1

/-- A supported solution denotes the scalar-count iterate, like every
replay-checked solution. -/
theorem SupportedSolution.eq_iterate {P : Program Cost n} (s : SupportedSolution P) :
    listState s.values = iterate boundedMinPlus P n := by
  funext i
  apply info_antisymm boundedMinPlus
  · exact s.least.2 _ (boundedMinPlus_iterate_fixed P) i
  · exact iterate_le_fixed boundedMinPlus P _ s.least.1 n i

/-- The certified value list is the encoded scalar-count iterate. -/
theorem SupportedSolution.values_eq {P : Program Cost n} (s : SupportedSolution P) :
    s.values = List.ofFn (iterate boundedMinPlus P n) := by
  have hlen := s.length
  have heq := s.eq_iterate
  apply List.ext_getElem (by simp [hlen])
  intro i h1 h2
  have hi := congrFun heq ⟨i, hlen ▸ h1⟩
  simp only [listState, List.getElem?_eq_getElem h1, Option.getD_some] at hi
  rw [List.getElem_ofFn]
  exact hi

/-- Conversion to the replay-checked form by proof: the values are the
complete iterate, which the replay checker always accepts at the scalar
count. No replay is computed. -/
def SupportedSolution.toCheckedSolution {P : Program Cost n} (s : SupportedSolution P) :
    CheckedSolution P where
  rounds := n
  values := s.values
  accepted := by rw [s.values_eq]; exact checkCertificate_complete P

end WeightedRules
