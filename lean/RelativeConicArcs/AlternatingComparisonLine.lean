import RelativeConicArcs.KneserPairEigenspace

/-!
# The equivariant comparison between the two five-label modules

Two modules carry an action of the alternating group on five letters: the
coordinate module `Fin 5 → K` with its permutation action, and the Kneser
coefficient module `Pair 5 → K` obtained by relabelling two-element subsets.
The pair-sum map `y ↦ ({i,j} ↦ y i + y j)` intertwines them.

This module proves that it is essentially the only intertwiner.  The argument is
the commutant computation: the alternating group is two-transitive on five
letters, so a linear endomorphism of the coordinate module commuting with it has
one constant diagonal entry and one constant off-diagonal entry, hence acts on
the sum-zero submodule as a scalar.  Transporting this along the pair-sum
isomorphism onto the Petersen `-2` eigenspace shows that every equivariant
comparison defined on the sum-zero submodule and landing in that eigenspace is a
scalar multiple of the pair-sum map.  Requiring the comparison to preserve the
sum of cubes then forces the cube of the scalar to be one, hence the scalar
itself to be one over an ordered field.

Two-transitivity is proved by explicit construction from transpositions together
with a parity correction rather than by a search over the symmetric group; only
the two auxiliary statements about avoiding a pair of labels are decided.  The
fields are unrestricted apart from the invertibility hypotheses stated on each
declaration.
-/

namespace RelativeConicArcs.AlternatingComparisonLine

open RelativeConicArcs.KneserPairEigenspace

section Transitivity

/-- Two distinct labels leave three others, so two distinct labels avoiding both
can always be chosen. -/
private theorem exists_pair_avoiding :
    ∀ k l : Fin 5, k ≠ l →
      ∃ a b : Fin 5, a ≠ b ∧ a ≠ k ∧ a ≠ l ∧ b ≠ k ∧ b ≠ l := by
  decide

/-- Every label has a companion distinct from it. -/
private theorem exists_ne_label : ∀ i : Fin 5, ∃ l : Fin 5, l ≠ i := by decide

/-- The alternating group on five letters is two-transitive: any ordered pair of
distinct labels is carried to any other by an even permutation.  The witness is a
product of at most two transpositions, corrected if necessary by a transposition
of two labels outside the target pair. -/
theorem exists_even_perm_apply_eq {i j k l : Fin 5} (hij : i ≠ j) (hkl : k ≠ l) :
    ∃ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 ∧ σ i = k ∧ σ j = l := by
  classical
  have h1 : (Equiv.swap i k) i = k := Equiv.swap_apply_left i k
  have hmk : (Equiv.swap i k) j ≠ k := by
    intro h
    have hji : (Equiv.swap i k) j = (Equiv.swap i k) i := by rw [h, h1]
    exact hij (Equiv.injective _ hji).symm
  have h2 : (Equiv.swap ((Equiv.swap i k) j) l) k = k :=
    Equiv.swap_apply_of_ne_of_ne (Ne.symm hmk) hkl
  have h3 : (Equiv.swap ((Equiv.swap i k) j) l) ((Equiv.swap i k) j) = l :=
    Equiv.swap_apply_left _ _
  set τ := (Equiv.swap ((Equiv.swap i k) j) l) * (Equiv.swap i k) with hτ
  have hτi : τ i = k := by rw [hτ, Equiv.Perm.mul_apply, h1, h2]
  have hτj : τ j = l := by rw [hτ, Equiv.Perm.mul_apply, h3]
  rcases Int.units_eq_one_or (Equiv.Perm.sign τ) with hs | hs
  · exact ⟨τ, hs, hτi, hτj⟩
  · obtain ⟨a, b, hab, hak, hal, hbk, hbl⟩ := exists_pair_avoiding k l hkl
    refine ⟨Equiv.swap a b * τ, ?_, ?_, ?_⟩
    · rw [map_mul, Equiv.Perm.sign_swap hab, hs]
      decide
    · rw [Equiv.Perm.mul_apply, hτi]
      exact Equiv.swap_apply_of_ne_of_ne (Ne.symm hak) (Ne.symm hbk)
    · rw [Equiv.Perm.mul_apply, hτj]
      exact Equiv.swap_apply_of_ne_of_ne (Ne.symm hal) (Ne.symm hbl)

end Transitivity

section Commutant

variable {K : Type*} [Field K]

/-- A linear endomorphism of the five-coordinate module commuting with every even
permutation of the labels has a constant diagonal entry and a constant
off-diagonal entry: it is a combination of the identity and the operator summing
all coordinates. -/
theorem exists_scalars_of_alternating_equivariant
    (T : (Fin 5 → K) →ₗ[K] (Fin 5 → K))
    (hT : ∀ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 →
      ∀ y : Fin 5 → K, T (fun i => y (σ i)) = fun i => T y (σ i)) :
    ∃ a b : K, ∀ y : Fin 5 → K, ∀ i, T y i = a * y i + b * ∑ j, y j := by
  classical
  set M : Fin 5 → Fin 5 → K :=
    fun i j => T (Pi.single j (1 : K) : Fin 5 → K) i with hM
  have hentry : ∀ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 →
      ∀ i j, M (σ i) (σ j) = M i j := by
    intro σ hσ i j
    have hsingle :
        (fun i => (Pi.single (σ j) (1 : K) : Fin 5 → K) (σ i)) =
          (Pi.single j (1 : K) : Fin 5 → K) := by
      funext m
      by_cases h : m = j
      · subst h; simp
      · rw [Pi.single_eq_of_ne (fun hc => h (σ.injective hc)), Pi.single_eq_of_ne h]
    have := congrFun (hT σ hσ (Pi.single (σ j) (1 : K) : Fin 5 → K)) i
    rw [hsingle] at this
    exact this.symm
  have hdiag : ∀ i, M i i = M 0 0 := by
    intro i
    obtain ⟨l, hl⟩ := exists_ne_label i
    obtain ⟨σ, hσ, hσ0, _⟩ :=
      exists_even_perm_apply_eq (i := (0 : Fin 5)) (j := (1 : Fin 5))
        (k := i) (l := l) (by decide) (Ne.symm hl)
    have := hentry σ hσ 0 0
    rw [hσ0] at this
    exact this
  have hoff : ∀ i j, i ≠ j → M i j = M 0 1 := by
    intro i j hij
    obtain ⟨σ, hσ, hσ0, hσ1⟩ :=
      exists_even_perm_apply_eq (i := (0 : Fin 5)) (j := (1 : Fin 5))
        (k := i) (l := j) (by decide) hij
    have := hentry σ hσ 0 1
    rw [hσ0, hσ1] at this
    exact this
  refine ⟨M 0 0 - M 0 1, M 0 1, ?_⟩
  intro y i
  have hexpand : y = ∑ j, y j • (Pi.single j (1 : K) : Fin 5 → K) := by
    funext m
    rw [Finset.sum_apply]
    simp [Pi.single_apply]
  have hTy : T y i = ∑ j, y j * M i j := by
    conv_lhs => rw [hexpand]
    rw [map_sum]
    rw [Finset.sum_apply]
    refine Finset.sum_congr rfl ?_
    intro j _
    rw [map_smul]
    simp [hM]
  rw [hTy]
  have hsplit : ∀ j, y j * M i j =
      M 0 1 * y j + (if i = j then (M 0 0 - M 0 1) * y j else 0) := by
    intro j
    by_cases h : i = j
    · subst h; rw [hdiag i, if_pos rfl]; ring
    · rw [hoff i j h, if_neg h]; ring
  rw [Finset.sum_congr rfl fun j _ => hsplit j, Finset.sum_add_distrib,
    ← Finset.mul_sum, Finset.sum_ite_eq]
  simp
  ring

/-- On the sum-zero submodule an equivariant endomorphism is multiplication by
the difference of its two constants. -/
theorem apply_eq_smul_of_sum_eq_zero {a b : K} {T : (Fin 5 → K) →ₗ[K] (Fin 5 → K)}
    (hT : ∀ y : Fin 5 → K, ∀ i, T y i = a * y i + b * ∑ j, y j)
    {y : Fin 5 → K} (hy : ∑ i, y i = 0) :
    T y = fun i => a * y i := by
  funext i
  rw [hT y i, hy]
  ring

end Commutant

section Comparison

variable {K : Type*} [Field K]

/-- Relabelling a Kneser vertex along a permutation of the five labels. -/
def pairMap (σ : Equiv.Perm (Fin 5)) (p : Pair 5) : Pair 5 :=
  ⟨p.vertices.image σ, by
    rw [pairFinset, Finset.mem_powersetCard]
    exact ⟨Finset.subset_univ _, by
      rw [Finset.card_image_of_injective _ σ.injective]
      exact p.card_vertices⟩⟩

/-- The pair-sum map intertwines the permutation action on labels with the
relabelling action on Kneser vertices. -/
theorem pairSum_comp (σ : Equiv.Perm (Fin 5)) (y : Fin 5 → K) (p : Pair 5) :
    pairSum (fun i => y (σ i)) p = pairSum y (pairMap σ p) := by
  classical
  rw [pairSum, pairSum]
  show ∑ i ∈ p.vertices, y (σ i) = ∑ i ∈ p.vertices.image σ, y i
  rw [Finset.sum_image (fun x _ z _ h => σ.injective h)]

/-- Relabelling preserves sum-zero vectors. -/
theorem sum_comp_eq_zero (σ : Equiv.Perm (Fin 5)) {y : Fin 5 → K}
    (hy : ∑ i, y i = 0) : ∑ i, y (σ i) = 0 := by
  rw [Equiv.sum_comp σ y, hy]

/-- The projection of the coordinate module onto its sum-zero submodule along the
constants, available whenever five is invertible. -/
def sumZeroProjection : (Fin 5 → K) →ₗ[K] (Fin 5 → K) where
  toFun y := fun i => y i - (5 : K)⁻¹ * ∑ j, y j
  map_add' := by
    intro y z
    funext i
    simp [Finset.sum_add_distrib]
    ring
  map_smul' := by
    intro a y
    funext i
    simp [← Finset.mul_sum]
    ring

/-- The projection commutes with relabelling. -/
theorem sumZeroProjection_comp (σ : Equiv.Perm (Fin 5))
    (y : Fin 5 → K) :
    sumZeroProjection (fun i => y (σ i)) = fun i => sumZeroProjection (K := K) y (σ i) := by
  funext i
  simp only [sumZeroProjection, LinearMap.coe_mk, AddHom.coe_mk]
  rw [Equiv.sum_comp σ y]

/-- The projection lands in the sum-zero submodule. -/
theorem sum_sumZeroProjection (h5 : (5 : K) ≠ 0) (y : Fin 5 → K) :
    ∑ i, sumZeroProjection y i = 0 := by
  simp only [sumZeroProjection, LinearMap.coe_mk, AddHom.coe_mk]
  rw [Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ]
  simp
  field_simp
  ring

/-- The projection is the identity on sum-zero vectors. -/
theorem sumZeroProjection_of_sum_eq_zero {y : Fin 5 → K}
    (hy : ∑ i, y i = 0) : sumZeroProjection y = y := by
  funext i
  simp [sumZeroProjection, hy]

/-- Every equivariant comparison from the sum-zero coordinate module to the
Petersen `-2` eigenspace is a scalar multiple of the pair-sum map.  The
comparison is a linear map `Φ` on the whole coordinate module, intertwining the
label action with the relabelling action; `T` is its coordinate representative,
carrying every vector into the sum-zero submodule and satisfying
`pairSum ∘ T = Φ` there.  A representative exists for any `Φ` sending sum-zero
vectors to Petersen `-2` eigenvectors, since
`RelativeConicArcs.KneserPairEigenspace.existsUnique_pairSum_of_petersenEigen`
makes the pair-sum map a bijection from the sum-zero submodule onto that
eigenspace; it is a hypothesis here rather than a construction.  The conclusion
is asserted on the sum-zero submodule, which is the domain of the comparison. -/
theorem exists_scalar_of_equivariant_comparison
    (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0)
    (Φ : (Fin 5 → K) →ₗ[K] (Pair 5 → K))
    (hΦ : ∀ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 →
      ∀ y : Fin 5 → K, Φ (fun i => y (σ i)) = fun p => Φ y (pairMap σ p))
    (T : (Fin 5 → K) →ₗ[K] (Fin 5 → K))
    (hTsum : ∀ y : Fin 5 → K, ∑ i, T y i = 0)
    (hTpair : ∀ y : Fin 5 → K, ∑ i, y i = 0 → pairSum (T y) = Φ y) :
    ∃ c : K, ∀ y : Fin 5 → K, ∑ i, y i = 0 → Φ y = fun p => c * pairSum y p := by
  have hinj : ∀ {u v : Fin 5 → K}, ∑ i, u i = 0 → ∑ i, v i = 0 →
      pairSum u = pairSum v → u = v := by
    intro u v hu hv huv
    exact pairSum_injective_on_sumZero (n := 5) (K := K) (by omega)
      (by norm_num; exact h3) hu hv huv
  -- On sum-zero vectors the representative inherits the equivariance of `Φ`.
  have hTzero : ∀ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 →
      ∀ y : Fin 5 → K, ∑ i, y i = 0 →
        T (fun i => y (σ i)) = fun i => T y (σ i) := by
    intro σ hσ y hy
    refine hinj (hTsum _) (sum_comp_eq_zero σ (hTsum y)) ?_
    funext p
    rw [hTpair _ (sum_comp_eq_zero σ hy), hΦ σ hσ y, pairSum_comp σ (T y) p,
      hTpair y hy]
  -- Composing with the projection makes the equivariance unconditional.
  set S := T.comp (sumZeroProjection (K := K)) with hS
  have hSequiv : ∀ σ : Equiv.Perm (Fin 5), Equiv.Perm.sign σ = 1 →
      ∀ y : Fin 5 → K, S (fun i => y (σ i)) = fun i => S y (σ i) := by
    intro σ hσ y
    rw [hS]
    simp only [LinearMap.comp_apply]
    rw [sumZeroProjection_comp σ y,
      hTzero σ hσ _ (sum_sumZeroProjection h5 y)]
  obtain ⟨a, b, hab⟩ := exists_scalars_of_alternating_equivariant S hSequiv
  refine ⟨a, ?_⟩
  intro y hy
  have hSy : S y = T y := by
    rw [hS]
    simp only [LinearMap.comp_apply, sumZeroProjection_of_sum_eq_zero hy]
  have hTy : T y = fun i => a * y i := by
    rw [← hSy]
    exact apply_eq_smul_of_sum_eq_zero hab hy
  have hpair := hTpair y hy
  rw [hTy] at hpair
  rw [← hpair]
  funext p
  rw [pairSum, pairSum, Finset.mul_sum]

end Comparison

section Normalization

/-- Preserving the sum of cubes forces the cube of the comparison scalar to be
one.  The witness is the primitive vector fixed by a label stabilizer, whose sum
of cubes is sixty. -/
theorem cube_eq_one_of_preserves_sum_cubes {K : Type*} [Field K]
    (h60 : (60 : K) ≠ 0) (c : K)
    (h : ∀ y : Fin 5 → K, ∑ i, y i = 0 → ∑ i, (c * y i) ^ 3 = ∑ i, y i ^ 3) :
    c ^ 3 = 1 := by
  have hy : ∑ i, (![4, -1, -1, -1, -1] : Fin 5 → K) i = 0 := by
    simp [Fin.sum_univ_five]
    ring
  have := h _ hy
  simp only [Fin.sum_univ_five] at this
  simp [Matrix.cons_val_zero, Matrix.cons_val_one] at this
  have h60' : (60 : K) * c ^ 3 = 60 * 1 := by linear_combination this
  exact mul_left_cancel₀ h60 h60'

/-- Over an ordered field the comparison scalar is one, since cubing is
injective. -/
theorem eq_one_of_cube_eq_one {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]
    {c : K} (hc : c ^ 3 = 1) : c = 1 := by
  have hfactor : (c - 1) * (c ^ 2 + c + 1) = 0 := by linear_combination hc
  have hpos : 0 < c ^ 2 + c + 1 := by nlinarith [sq_nonneg (2 * c + 1)]
  have := (mul_eq_zero.mp hfactor).resolve_right (ne_of_gt hpos)
  linarith

end Normalization

end RelativeConicArcs.AlternatingComparisonLine
