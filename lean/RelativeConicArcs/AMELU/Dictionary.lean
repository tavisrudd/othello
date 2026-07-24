import RelativeConicArcs.AMELU.CSS
import RelativeConicArcs.CodingBridge

/-!
# Arc, code, and state dictionary

This module proves the convention-coherence implications joining the
six-party interface:

* a six-arc parity-check system has an exact linear `[6,3,4]` kernel;
* an exact linear `[6,3,4]` kernel has an absolutely maximally entangled
  equal-phase state; and
* projective equivalence of the ordered columns induces monomial code
  equivalence and local-Clifford equivalence of the code states.

The proofs use finite linear algebra and finite sums checked by the Lean
kernel.  No generated data, native evaluation, external certificate,
axiom, or admitted declaration is used.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The determinant form of the six-arc condition gives linear
independence of every displayed triple of columns. -/
theorem tripleLinearIndependent_of_isSixArc
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P)
    {i j k : Party} (hij : i ≠ j) (hik : i ≠ k) (hjk : j ≠ k) :
    LinearIndependent 𝔽 ![P i, P j, P k] := by
  apply Matrix.linearIndependent_rows_of_det_ne_zero
  simpa [selectedTripleMatrix] using hP.2 i j k hij hik hjk

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every subfamily of at most three columns of a six-arc is linearly
independent. -/
theorem smallLinearIndependent_of_isSixArc
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P)
    (S : Finset Party) (hS : S.card ≤ 3) :
    LinearIndependent 𝔽 (fun i : S => P i.1) := by
  apply RelativeConicArcs.CodingBridge.small_independent_of_triple_independent
    P (by simp) _ S hS
  intro T hT
  let e : T ≃ Fin 3 := Finset.equivFinOfCardEq hT
  let i : Party := (e.symm 0).1
  let j : Party := (e.symm 1).1
  let k : Party := (e.symm 2).1
  have hij : i ≠ j := by
    intro h
    have he : e.symm 0 = e.symm 1 := Subtype.ext h
    have : (0 : Fin 3) = 1 := e.symm.injective he
    omega
  have hik : i ≠ k := by
    intro h
    have he : e.symm 0 = e.symm 2 := Subtype.ext h
    have : (0 : Fin 3) = 2 := e.symm.injective he
    omega
  have hjk : j ≠ k := by
    intro h
    have he : e.symm 1 = e.symm 2 := Subtype.ext h
    have : (1 : Fin 3) = 2 := e.symm.injective he
    omega
  have hLI : LinearIndependent 𝔽 ![P i, P j, P k] :=
    tripleLinearIndependent_of_isSixArc hP hij hik hjk
  have hfamily :
      (![P i, P j, P k] : Fin 3 → (PlaneCoordinate → 𝔽)) =
        fun r => P (e.symm r).1 := by
    funext r
    fin_cases r <;> rfl
  rw [hfamily] at hLI
  exact (linearIndependent_equiv e.symm).mp (by
    simpa [Function.comp_def] using hLI)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The six columns span the ambient three-dimensional coordinate space. -/
theorem span_eq_top_of_isSixArc
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P) :
    Submodule.span 𝔽 (Set.range P) = ⊤ := by
  let f : Fin 3 → (PlaneCoordinate → 𝔽) := ![P 0, P 1, P 2]
  have hLI : LinearIndependent 𝔽 f := by
    exact tripleLinearIndependent_of_isSixArc hP (by decide) (by decide) (by decide)
  have hspan :
      Submodule.span 𝔽 (Set.range f) ≤ Submodule.span 𝔽 (Set.range P) := by
    apply Submodule.span_le.mpr
    rintro v ⟨r, rfl⟩
    fin_cases r <;> exact Submodule.subset_span (Set.mem_range_self _)
  have hlo := Submodule.finrank_mono hspan
  rw [finrank_span_eq_card hLI, Fintype.card_fin] at hlo
  apply Submodule.eq_top_of_finrank_eq
  have hhi := (Submodule.span 𝔽 (Set.range P)).finrank_le
  have hambient : Module.finrank 𝔽 (PlaneCoordinate → 𝔽) = 3 := by simp
  rw [hambient]
  omega

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A six-arc is a transparent codimension-three MDS parity-check system. -/
theorem codimThreeMDSColumns_of_isSixArc
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P) :
    RelativeConicArcs.CodingBridge.CodimThreeMDSColumns (K := 𝔽) P where
  ambient_finrank := by simp
  spans := span_eq_top_of_isSixArc hP
  small_independent := smallLinearIndependent_of_isSixArc hP

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The matrix-kernel and finite-linear-combination definitions of the
parity-check code agree. -/
theorem arcKernel_eq_parityCheckCode (P : Party → PlaneCoordinate → 𝔽) :
    arcKernel P = RelativeConicArcs.CodingBridge.parityCheckCode (K := 𝔽) P := by
  ext c
  rw [mem_arcKernel, RelativeConicArcs.CodingBridge.mem_parityCheckCode_iff]
  constructor
  · intro h
    funext r
    have hr := congrFun h r
    simpa [parityCheckMatrix, Matrix.mulVec, dotProduct, mul_comm] using hr
  · intro h
    funext r
    have hr := congrFun h r
    simpa [parityCheckMatrix, Matrix.mulVec, dotProduct, mul_comm] using hr

omit [Fintype 𝔽] in
theorem hammingWeight_eq_hammingNorm (c : BasisLabel 𝔽) :
    RelativeConicArcs.CodingBridge.hammingWeight c = hammingNorm c :=
  rfl

/-- Every ordered six-arc has an exact linear `[6,3,4]` parity-check
kernel in the convention of `IsMDSCode634`. -/
theorem isMDSCode634_arcKernel
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P) :
    IsMDSCode634 (arcKernel P) := by
  let hcols := codimThreeMDSColumns_of_isSixArc hP
  rw [arcKernel_eq_parityCheckCode]
  constructor
  · simpa using hcols.code_finrank
  · obtain ⟨c, hc, hc0, hcweight⟩ :=
      hcols.exists_minimumWeight_word (by simp)
    apply le_antisymm
    · calc
        FiniteGeom.minDist
              (RelativeConicArcs.CodingBridge.parityCheckCode (K := 𝔽) P) ≤
            hammingNorm c := FiniteGeom.minDist_le_hammingNorm hc hc0
        _ = 4 := (hammingWeight_eq_hammingNorm c).symm.trans hcweight
    · apply FiniteGeom.le_minDist
      · exact (Submodule.ne_bot_iff _).mpr ⟨c, hc, hc0⟩
      · intro d hd hd0
        rw [← hammingWeight_eq_hammingNorm]
        exact hcols.minimumDistance_ge_four hd hd0

/-- Coordinate projection of a code onto the parties in `S`. -/
def codeProjection (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) :
    C →ₗ[𝔽] (S → 𝔽) where
  toFun c i := c.1 i.1
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- A code of distance four projects injectively onto every three-party
coordinate set. -/
theorem codeProjection_injective_of_card_three
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 3) :
    Function.Injective (codeProjection C S) := by
  intro x y hxy
  apply Subtype.ext
  by_contra hne
  let d : BasisLabel 𝔽 := x.1 - y.1
  have hdC : d ∈ C := C.sub_mem x.2 y.2
  have hd0 : d ≠ 0 := by
    intro hd
    apply hne
    exact sub_eq_zero.mp hd
  have hdweight : hammingNorm d ≤ 3 := by
    unfold hammingNorm
    calc
      (Finset.univ.filter fun i => d i ≠ 0).card ≤ (Sᶜ).card := by
        apply Finset.card_le_card
        intro i hi
        apply Finset.mem_compl.mpr
        intro hiS
        have heq := congrFun hxy ⟨i, hiS⟩
        exact (Finset.mem_filter.mp hi).2 (sub_eq_zero.mpr heq)
      _ = 3 := by
        rw [Finset.card_compl]
        change 6 - S.card = 3
        omega
  have hmin := FiniteGeom.minDist_le_hammingNorm hdC hd0
  rw [hC.2] at hmin
  omega

/-- On three parties the projection of an exact `[6,3,4]` code is
bijective. -/
theorem codeProjection_bijective_of_card_three
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 3) :
    Function.Bijective (codeProjection C S) := by
  have hinj := codeProjection_injective_of_card_three hC hS
  refine ⟨hinj, (LinearMap.injective_iff_surjective_of_finrank_eq_finrank ?_).mp hinj⟩
  rw [hC.1, Module.finrank_pi, Fintype.card_coe, hS]

/-- An exact `[6,3,4]` code projects surjectively onto every subsystem of
at most three parties. -/
theorem codeProjection_surjective
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3) :
    Function.Surjective (codeProjection C S) := by
  classical
  obtain ⟨T, hST, -, hTcard⟩ := Finset.exists_subsuperset_card_eq
    (Finset.subset_univ S) hS (by simp : 3 ≤ Fintype.card Party)
  intro x
  let y : T → 𝔽 := fun i => if hi : i.1 ∈ S then x ⟨i.1, hi⟩ else 0
  obtain ⟨c, hc⟩ := (codeProjection_bijective_of_card_three hC hTcard).2 y
  refine ⟨c, ?_⟩
  funext i
  have hiT : i.1 ∈ T := hST i.2
  have hi := congrFun hc ⟨i.1, hiT⟩
  simpa [codeProjection, y, i.2] using hi

/-- Two codewords of a distance-four code that agree off at most three
parties are equal. -/
theorem codeword_eq_of_eq_outside
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3)
    {c d : BasisLabel 𝔽} (hc : c ∈ C) (hd : d ∈ C)
    (hout : ∀ i, i ∉ S → c i = d i) :
    c = d := by
  by_contra hne
  have hdiffC : c - d ∈ C := C.sub_mem hc hd
  have hdiff0 : c - d ≠ 0 := fun h => hne (sub_eq_zero.mp h)
  have hweight : hammingNorm (c - d) ≤ S.card := by
    unfold hammingNorm
    apply Finset.card_le_card
    intro i hi
    by_contra hiS
    exact (Finset.mem_filter.mp hi).2 (sub_eq_zero.mpr (hout i hiS))
  have hmin := FiniteGeom.minDist_le_hammingNorm hdiffC hdiff0
  rw [hC.2] at hmin
  omega

/-- The codewords whose restriction to `S` equals `x`. -/
abbrev CodeFiber (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party)
    (x : S → 𝔽) :=
  {c : C // codeProjection C S c = x}

/-- Environments producing codewords with prescribed subsystem label `x`
are exactly the corresponding code fiber. -/
def environmentFiberEquivCodeFiber
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) (x : S → 𝔽) :
    {e : (i : {i : Party // i ∉ S}) → 𝔽 // assembleLabel S x e ∈ C} ≃
      CodeFiber C S x where
  toFun e := ⟨⟨assembleLabel S x e.1, e.2⟩, by
    funext i
    simp [codeProjection]⟩
  invFun c := ⟨fun i => c.1.1 i.1, by
    have hc := c.2
    have heq : assembleLabel S x (fun i => c.1.1 i.1) = c.1.1 := by
      funext i
      by_cases hi : i ∈ S
      · have hci := congrFun hc ⟨i, hi⟩
        simpa [codeProjection, assembleLabel, hi] using hci.symm
      · simp [assembleLabel, hi]
    rw [heq]
    exact c.1.2⟩
  left_inv e := by
    apply Subtype.ext
    funext i
    simp [assembleLabel, i.2]
  right_inv c := by
    apply Subtype.ext
    apply Subtype.ext
    funext i
    by_cases hi : i ∈ S
    · have hci := congrFun c.2 ⟨i, hi⟩
      simpa [codeProjection, assembleLabel, hi] using hci.symm
    · simp [assembleLabel, hi]

/-- A nonempty fiber of a linear map is a translate of its kernel. -/
noncomputable def codeFiberEquivKer
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {S : Finset Party} {x : S → 𝔽}
    (hsurj : Function.Surjective (codeProjection C S)) :
    CodeFiber C S x ≃ LinearMap.ker (codeProjection C S) := by
  let c₀ : C := Classical.choose (hsurj x)
  have hc₀ : codeProjection C S c₀ = x := Classical.choose_spec (hsurj x)
  exact
    { toFun := fun c => ⟨c.1 - c₀, by
        rw [LinearMap.mem_ker, map_sub, c.2, hc₀, sub_self]⟩
      invFun := fun k => ⟨c₀ + k.1, by
        rw [map_add, hc₀, LinearMap.mem_ker.mp k.2, add_zero]⟩
      left_inv := by
        intro c
        apply Subtype.ext
        simp
      right_inv := by
        intro k
        apply Subtype.ext
        simp }

/-- The projection kernel has dimension `3-|S|`. -/
theorem finrank_ker_codeProjection
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3) :
    Module.finrank 𝔽 (LinearMap.ker (codeProjection C S)) = 3 - S.card := by
  have hrange : LinearMap.range (codeProjection C S) = ⊤ :=
    LinearMap.range_eq_top.mpr (codeProjection_surjective hC hS)
  have hdim := (codeProjection C S).finrank_range_add_finrank_ker
  rw [hrange, finrank_top, Module.finrank_pi, Fintype.card_coe, hC.1] at hdim
  omega

/-- Every subsystem label on at most three parties occurs
`|𝔽|^(3-|S|)` times in an exact `[6,3,4]` code. -/
theorem card_codeFiber
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3) (x : S → 𝔽) :
    Nat.card (CodeFiber C S x) = Fintype.card 𝔽 ^ (3 - S.card) := by
  have hcardKer :
      Nat.card (LinearMap.ker (codeProjection C S)) =
        Nat.card 𝔽 ^ Module.finrank 𝔽 (LinearMap.ker (codeProjection C S)) :=
    Module.natCard_eq_pow_finrank
      (K := 𝔽) (V := LinearMap.ker (codeProjection C S))
  rw [Nat.card_congr (codeFiberEquivKer (codeProjection_surjective hC hS)),
    hcardKer, finrank_ker_codeProjection hC hS, Nat.card_eq_fintype_card]

omit [DecidableEq 𝔽] in
/-- Squaring the state normalization gives `|𝔽|⁻³`. -/
theorem codeStateNormalization_mul_conj :
    codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽) =
      ((((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ : ℝ) : ℂ) := by
  have hq : 0 < (Fintype.card 𝔽 : ℝ) := by positivity
  have hpow : 0 < (Fintype.card 𝔽 : ℝ) ^ 3 := pow_pos hq _
  change
    (((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ : ℝ) : ℂ) *
        conj ((((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ : ℝ) : ℂ)) =
      ((((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ : ℝ) : ℂ)
  rw [Complex.conj_ofReal, ← Complex.ofReal_mul]
  congr 1
  calc
    (Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ *
          (Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ =
        (Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3) *
          Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ 3))⁻¹ :=
      (_root_.mul_inv_rev _ _).symm
    _ = ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ := by
      rw [Real.mul_self_sqrt hpow.le]

/-- The finite set of environments that complete `x` to a codeword. -/
noncomputable def environmentFiberFinset
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) (x : S → 𝔽) :
    Finset ((i : {i : Party // i ∉ S}) → 𝔽) := by
  classical
  exact Finset.univ.filter fun e => assembleLabel S x e ∈ C

/-- The environment assignments completing a fixed subsystem label to a
codeword have the same cardinality as the corresponding code fiber. -/
theorem card_environmentFiber
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3) (x : S → 𝔽) :
    (environmentFiberFinset C S x).card =
      Fintype.card 𝔽 ^ (3 - S.card) := by
  classical
  let p : ((i : {i : Party // i ∉ S}) → 𝔽) → Prop :=
    fun e => assembleLabel S x e ∈ C
  calc
    (environmentFiberFinset C S x).card = Fintype.card {e // p e} := by
      rw [environmentFiberFinset]
      exact (Fintype.card_subtype p).symm
    _ = Nat.card {e // p e} := Fintype.card_eq_nat_card
    _ = Nat.card (CodeFiber C S x) :=
      Nat.card_congr (environmentFiberEquivCodeFiber C S x)
    _ = Fintype.card 𝔽 ^ (3 - S.card) := card_codeFiber hC hS x

/-- If two completions with the same environment are codewords, their
subsystem labels coincide. -/
theorem subsystemLabel_eq_of_assemble_mem
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3)
    {x y : S → 𝔽} {e : (i : {i : Party // i ∉ S}) → 𝔽}
    (hx : assembleLabel S x e ∈ C) (hy : assembleLabel S y e ∈ C) :
    x = y := by
  have hlabels := codeword_eq_of_eq_outside hC hS hx hy (by
    intro i hi
    simp [assembleLabel, hi])
  funext i
  have hi := congrFun hlabels i.1
  simpa [assembleLabel, i.2] using hi

/-- Distinct subsystem labels give a zero off-diagonal marginal entry. -/
theorem marginalEntry_equalPhaseState_of_ne
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3)
    {x y : S → 𝔽} (hxy : x ≠ y) :
    marginalEntry (equalPhaseState C) S x y = 0 := by
  classical
  unfold marginalEntry
  apply Finset.sum_eq_zero
  intro e _
  by_cases hx : assembleLabel S x e ∈ C
  · by_cases hy : assembleLabel S y e ∈ C
    · exact (hxy (subsystemLabel_eq_of_assemble_mem hC hS hx hy)).elim
    · simp [equalPhaseState, hx, hy]
  · simp [equalPhaseState, hx]

omit [DecidableEq 𝔽] in
/-- The fiber cardinality times the squared code-state normalization is
the reciprocal subsystem dimension. -/
theorem fiberCard_mul_normalization
    {S : Finset Party} (hS : S.card ≤ 3) :
    ((Fintype.card 𝔽 ^ (3 - S.card) : ℕ) : ℂ) *
        codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽) =
      (((((Fintype.card 𝔽 : ℝ) ^ S.card)⁻¹ : ℝ)) : ℂ) := by
  rw [mul_assoc, codeStateNormalization_mul_conj]
  norm_cast
  have hq0 : (Fintype.card 𝔽 : ℝ) ≠ 0 := by positivity
  field_simp
  norm_cast
  rw [← pow_add, Nat.sub_add_cancel hS]

/-- A diagonal marginal entry of an exact `[6,3,4]` equal-phase code
state is the reciprocal subsystem dimension. -/
theorem marginalEntry_equalPhaseState_self
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card ≤ 3) (x : S → 𝔽) :
    marginalEntry (equalPhaseState C) S x x =
      (((((Fintype.card 𝔽 : ℝ) ^ S.card)⁻¹ : ℝ)) : ℂ) := by
  classical
  unfold marginalEntry
  have hterm (e : (i : {i : Party // i ∉ S}) → 𝔽) :
      equalPhaseState C (assembleLabel S x e) *
          conj (equalPhaseState C (assembleLabel S x e)) =
        if assembleLabel S x e ∈ C then
          codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽)
        else 0 := by
    by_cases he : assembleLabel S x e ∈ C <;>
      simp [equalPhaseState, he]
  simp_rw [hterm]
  rw [← Finset.sum_filter]
  change
    (∑ e ∈ environmentFiberFinset C S x,
      codeStateNormalization 𝔽 * conj (codeStateNormalization 𝔽)) =
      _
  rw [Finset.sum_const, card_environmentFiber hC hS x]
  simpa [nsmul_eq_mul, mul_assoc] using fiberCard_mul_normalization (𝔽 := 𝔽) hS

/-- The finite set of codewords of `C`, viewed inside the ambient
computational-basis labels. -/
noncomputable def codewordFinset
    (C : Submodule 𝔽 (BasisLabel 𝔽)) : Finset (BasisLabel 𝔽) := by
  classical
  exact Finset.univ.filter fun x => x ∈ C

/-- An exact dimension-three code contains `|𝔽|³` words. -/
theorem card_codewordFinset
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    (codewordFinset C).card = Fintype.card 𝔽 ^ 3 := by
  classical
  have hcardC :
      Nat.card C = Nat.card 𝔽 ^ Module.finrank 𝔽 C :=
    Module.natCard_eq_pow_finrank (K := 𝔽) (V := C)
  calc
    (codewordFinset C).card = Fintype.card C := by
      rw [codewordFinset]
      exact (Fintype.card_subtype fun x : BasisLabel 𝔽 => x ∈ C).symm
    _ = Nat.card C := Fintype.card_eq_nat_card
    _ = Nat.card 𝔽 ^ Module.finrank 𝔽 C := hcardC
    _ = Fintype.card 𝔽 ^ 3 := by rw [Nat.card_eq_fintype_card, hC.1]

/-- The equal-phase state of an exact dimension-three code is normalized. -/
theorem isNormalized_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    IsNormalized (equalPhaseState C) := by
  classical
  have hnorm :
      Complex.normSq (codeStateNormalization 𝔽) =
        ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ := by
    apply Complex.ofReal_injective
    simpa [Complex.mul_conj] using codeStateNormalization_mul_conj (𝔽 := 𝔽)
  unfold IsNormalized
  have hterm (x : BasisLabel 𝔽) :
      Complex.normSq (equalPhaseState C x) =
        if x ∈ C then ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹ else 0 := by
    by_cases hx : x ∈ C <;> simp [equalPhaseState, hx, hnorm]
  simp_rw [hterm]
  rw [← Finset.sum_filter]
  change
    (∑ x ∈ codewordFinset C, ((Fintype.card 𝔽 : ℝ) ^ 3)⁻¹) = 1
  rw [Finset.sum_const, card_codewordFinset hC]
  simp only [nsmul_eq_mul, Nat.cast_pow]
  have hq0 : (Fintype.card 𝔽 : ℝ) ^ 3 ≠ 0 := by positivity
  exact mul_inv_cancel₀ hq0

/-- The equal-phase state of every exact linear `[6,3,4]` code is an
absolutely maximally entangled six-party state. -/
theorem isAME_equalPhaseState
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    IsAME (equalPhaseState C) := by
  refine ⟨isNormalized_equalPhaseState hC, ?_⟩
  intro S hS x y
  by_cases hxy : x = y
  · subst y
    simpa using marginalEntry_equalPhaseState_self hC hS x
  · simp [hxy, marginalEntry_equalPhaseState_of_ne hC hS hxy]

/-- The equal-phase kernel state of every ordered six-arc is absolutely
maximally entangled. -/
theorem isAME_equalPhaseState_arcKernel
    {P : Party → PlaneCoordinate → 𝔽} (hP : IsSixArc P) :
    IsAME (equalPhaseState (arcKernel P)) :=
  isAME_equalPhaseState (isMDSCode634_arcKernel hP)

/-- The state selected by a complete convention dictionary is absolutely
maximally entangled. -/
theorem ConventionDictionary.state_isAME
    [Algebra (ZMod (ringChar 𝔽)) 𝔽] (d : ConventionDictionary 𝔽) :
    IsAME d.state :=
  isAME_equalPhaseState d.arcCode.kernel_isMDSCode634

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Projectively equivalent ordered column systems have monomially
equivalent parity-check kernels, with the action directions fixed in the
shared interface. -/
theorem projectivelyEquivalent_arcKernel_monomiallyEquivalent
    {P Q : Party → PlaneCoordinate → 𝔽}
    (hPQ : ProjectivelyEquivalent P Q) :
    MonomiallyEquivalent (arcKernel P) (arcKernel Q) := by
  obtain ⟨g, π, u, hQ⟩ := hPQ
  let transform : BasisLabel 𝔽 → BasisLabel 𝔽 :=
    fun x j => (u (π j) : 𝔽) * x (π j)
  have hbridge (x : BasisLabel 𝔽) :
      x ∈ arcKernel Q ↔ transform x ∈ arcKernel P := by
    rw [arcKernel_eq_parityCheckCode, arcKernel_eq_parityCheckCode,
      RelativeConicArcs.CodingBridge.mem_parityCheckCode_iff,
      RelativeConicArcs.CodingBridge.mem_parityCheckCode_iff]
    have hsum :
        g (∑ j, transform x j • P j) = ∑ i, x i • Q i := by
      rw [map_sum]
      calc
        (∑ j, g (transform x j • P j)) =
            ∑ j, ((u (π j) : 𝔽) * x (π j)) • g (P j) := by
              apply Finset.sum_congr rfl
              intro j _
              simp [transform]
        _ = ∑ i, ((u i : 𝔽) * x i) • g (P (π.symm i)) := by
              rw [← Equiv.sum_comp π
                (fun i => ((u i : 𝔽) * x i) • g (P (π.symm i)))]
              simp
        _ = ∑ i, x i • Q i := by
              apply Finset.sum_congr rfl
              intro i _
              rw [hQ i]
              simp [smul_smul, mul_comm]
    constructor
    · intro hx
      apply g.injective
      rw [map_zero, hsum, hx]
    · intro hx
      rw [← hsum, hx, map_zero]
  refine ⟨π, fun i => (u i)⁻¹, ?_⟩
  intro x
  constructor
  · intro hx
    refine ⟨transform x, (hbridge x).mp hx, ?_⟩
    funext i
    simp [monomialLabel, transform]
  · rintro ⟨c, hc, hcx⟩
    apply (hbridge x).mpr
    have htransform : transform x = c := by
      funext j
      have hj := congrFun hcx (π j)
      simp only [monomialLabel, Equiv.symm_apply_apply] at hj
      calc
        transform x j = (u (π j) : 𝔽) * x (π j) := rfl
        _ = (u (π j) : 𝔽) * ((↑((u (π j))⁻¹) : 𝔽) * c j) := by rw [hj]
        _ = c j := by simp
    simpa [htransform] using hc

/-- The computational-basis permutation induced by multiplication by a
nonzero field element. -/
def multiplierMatrix (a : 𝔽ˣ) : LocalMatrix 𝔽 :=
  fun y x => if y = (a : 𝔽) * x then 1 else 0

/-- A nonzero field multiplier is unitary in the computational basis. -/
theorem isUnitaryMatrix_multiplierMatrix (a : 𝔽ˣ) :
    IsUnitaryMatrix (multiplierMatrix a) := by
  classical
  intro x y
  rw [Finset.sum_eq_single ((a : 𝔽) * x)]
  · simp [multiplierMatrix, mul_left_cancel₀ (Units.ne_zero a)]
  · intro z _ hz
    simp [multiplierMatrix, hz]
  · simp

omit [Fintype 𝔽] in
/-- Applying a multiplier matrix to a basis state sends `x` to `a*x`. -/
@[simp]
theorem multiplierMatrix_apply (a : 𝔽ˣ) (x y : 𝔽) :
    multiplierMatrix a y x = if y = (a : 𝔽) * x then 1 else 0 :=
  rfl

/-- Conjugating `W(a,b)` by a basis multiplier sends its label to
`(r*a,r⁻¹*b)` with no additional projective phase. -/
theorem conjugate_weyl_multiplier (w : WeylConvention 𝔽)
    (r : 𝔽ˣ) (a b : 𝔽) :
    matrixProduct
        (matrixProduct (multiplierMatrix r) (weylMatrix w a b))
        (multiplierMatrix r).conjTranspose =
      weylMatrix w ((r : 𝔽) * a) ((↑(r⁻¹) : 𝔽) * b) := by
  classical
  ext y x
  simp [matrixProduct, Matrix.mul_apply, multiplierMatrix, weylMatrix,
    Matrix.conjTranspose_apply, mul_assoc]
  rw [Finset.sum_eq_single ((↑(r⁻¹) : 𝔽) * x)]
  · simp [mul_add, mul_assoc, mul_left_comm, mul_comm]
  · intro z _ hz
    by_cases hzx : x = (r : 𝔽) * z
    · exfalso
      apply hz
      calc
        z = (↑(r⁻¹) : 𝔽) * ((r : 𝔽) * z) := by simp
        _ = (↑(r⁻¹) : 𝔽) * x := by rw [hzx]
    · simp [hzx]
  · simp

/-- Every nonzero computational-basis multiplier normalizes the
finite-field Weyl axes. -/
theorem isCliffordMatrix_multiplierMatrix (w : WeylConvention 𝔽) (r : 𝔽ˣ) :
    IsCliffordMatrix w (multiplierMatrix r) := by
  refine ⟨isUnitaryMatrix_multiplierMatrix r, ?_⟩
  intro a b
  refine ⟨(r : 𝔽) * a, (↑(r⁻¹) : 𝔽) * b, 1, one_ne_zero, ?_⟩
  simpa using conjugate_weyl_multiplier w r a b

/-- The unique input label carried to `y` by the tensor product of the
displayed multiplier matrices. -/
def inverseMultiplierLabel (u : Party → 𝔽ˣ) (y : BasisLabel 𝔽) :
    BasisLabel 𝔽 :=
  fun i => (↑((u i)⁻¹) : 𝔽) * y i

/-- A tensor product of multiplier matrices relabels state amplitudes by
the inverse coordinate multipliers. -/
theorem localAction_multiplierMatrix (u : Party → 𝔽ˣ) (ψ : State 𝔽)
    (y : BasisLabel 𝔽) :
    localAction (fun i => multiplierMatrix (u i)) ψ y =
      ψ (inverseMultiplierLabel u y) := by
  classical
  unfold localAction
  rw [Finset.sum_eq_single (inverseMultiplierLabel u y)]
  · simp [multiplierMatrix, inverseMultiplierLabel]
  · intro x _ hx
    have hbad : ∃ i, y i ≠ (u i : 𝔽) * x i := by
      by_contra h
      push Not at h
      apply hx
      funext i
      calc
        x i = (↑((u i)⁻¹) : 𝔽) * ((u i : 𝔽) * x i) := by simp
        _ = (↑((u i)⁻¹) : 𝔽) * y i := by rw [h i]
        _ = inverseMultiplierLabel u y i := rfl
    obtain ⟨i, hi⟩ := hbad
    have hprod :
        (∏ j, multiplierMatrix (u j) (y j) (x j)) = 0 := by
      apply Finset.prod_eq_zero (Finset.mem_univ i)
      simp [multiplierMatrix, hi]
    rw [hprod, zero_mul]
  · simp

/-- The preimage codeword associated with the monomial convention
`y_i = u_i c_{π⁻¹i}`. -/
def inverseMonomialPreimage (π : Equiv.Perm Party) (u : Party → 𝔽ˣ)
    (y : BasisLabel 𝔽) : BasisLabel 𝔽 :=
  fun j => (↑((u (π j))⁻¹) : 𝔽) * y (π j)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Membership in monomially equivalent codes is membership of the
explicit inverse image. -/
theorem mem_of_monomiallyEquivalent
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    {π : Equiv.Perm Party} {u : Party → 𝔽ˣ}
    (hmono : ∀ x, x ∈ D ↔ ∃ c ∈ C, monomialLabel π u c = x)
    (y : BasisLabel 𝔽) :
    y ∈ D ↔ inverseMonomialPreimage π u y ∈ C := by
  constructor
  · intro hy
    obtain ⟨c, hc, hcy⟩ := (hmono y).mp hy
    have heq : inverseMonomialPreimage π u y = c := by
      funext j
      have hj := congrFun hcy (π j)
      simp only [monomialLabel, Equiv.symm_apply_apply] at hj
      calc
        inverseMonomialPreimage π u y j =
            (↑((u (π j))⁻¹) : 𝔽) * y (π j) := rfl
        _ = (↑((u (π j))⁻¹) : 𝔽) * ((u (π j) : 𝔽) * c j) := by rw [← hj]
        _ = c j := by simp
    simpa [heq] using hc
  · intro hy
    apply (hmono y).mpr
    refine ⟨inverseMonomialPreimage π u y, hy, ?_⟩
    funext i
    simp [monomialLabel, inverseMonomialPreimage]

/-- Monomial code equivalence is realized by local basis multipliers and
a party permutation, hence gives local-Clifford equivalence of the
equal-phase states. -/
theorem monomiallyEquivalent_equalPhaseState_locallyCliffordEquivalent
    (w : WeylConvention 𝔽) {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hCD : MonomiallyEquivalent C D) :
    LocallyCliffordEquivalent w (equalPhaseState C) (equalPhaseState D) := by
  obtain ⟨π, u, hmono⟩ := hCD
  refine ⟨π, fun i => multiplierMatrix (u i), 1,
    fun i => isCliffordMatrix_multiplierMatrix w (u i), by simp, ?_⟩
  funext y
  rw [localAction_multiplierMatrix]
  change
    equalPhaseState C (inverseMonomialPreimage π u y) =
      (1 : ℂ) * equalPhaseState D y
  rw [one_mul]
  have hmem := mem_of_monomiallyEquivalent hmono y
  by_cases hy : y ∈ D
  · have hc := hmem.mp hy
    simp [equalPhaseState, hy, hc]
  · have hc : inverseMonomialPreimage π u y ∉ C := by
      exact fun hc => hy (hmem.mpr hc)
    simp [equalPhaseState, hy, hc]

/-- Projective equivalence of ordered six-arc representatives induces
local-Clifford equivalence of their equal-phase kernel states. -/
theorem projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent
    (w : WeylConvention 𝔽) {P Q : Party → PlaneCoordinate → 𝔽}
    (hPQ : ProjectivelyEquivalent P Q) :
    LocallyCliffordEquivalent w
      (equalPhaseState (arcKernel P)) (equalPhaseState (arcKernel Q)) :=
  monomiallyEquivalent_equalPhaseState_locallyCliffordEquivalent w
    (projectivelyEquivalent_arcKernel_monomiallyEquivalent hPQ)

end RelativeConicArcs.AMELU
