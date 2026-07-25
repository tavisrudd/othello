import RelativeConicArcs.PRSPolarInduction

/-!
# Algebraic terminals for stable coherent-polar components

This module checks three coordinate calculations used in the all-degree contained-component
argument for binary divided-power syndromes.

First, it proves the Plücker factorizations for the symmetric, exchanged, and anti-invariant
factorizations of a symmetric bidegree-`(2,2)` ordered-root incidence.  Second, it shows that a
linear contraction family indexed by a two-dimensional free module lies in a lower nucleus
exactly when its two coordinate contractions do.  Third, it proves the coefficient-block
overlap responsible for termination of the characteristic-two cyclic-plane descendant: if the
first and last columns of an `(m+1) × 5` consecutive catalecticant vanish and `m ≥ 3`, every
coefficient represented by that catalecticant vanishes.

The module does not formalize the algebraic-geometric classification of the lower bad scheme,
the density of squarefree marker products, saturation of the cyclic ideal, or the assertion that
every contained row space lies in one classified irreducible component.  Those statements remain
outside this coordinate-algebra boundary.
-/

namespace RelativeConicArcs.PRSStableComponents

section PluckerFactorizations

variable {R : Type*} [CommRing R]

/-- The Plücker relation for a product of two symmetric `(1,1)` forms factors as the product of
their two rank-one determinants. -/
theorem symmetricFactor_plucker
    (a b c A B C : R) :
    (a * A) * (c * C) -
          (a * B + b * A) * (b * C + c * B) +
          (b * B) * (a * C + c * A + b * B) =
      (a * c - b ^ 2) * (A * C - B ^ 2) := by
  ring

/-- The Plücker relation for a `(1,1)` form multiplied by its transposed form has the collision
factor `a*d-b*c` and the residual cyclic factor `a*d-b²+b*c-c²`. -/
theorem exchangedFactor_plucker
    (a b c d : R) :
    (a ^ 2) * (d ^ 2) -
          (a * (b + c)) * (d * (b + c)) +
          (b * c) * (2 * a * d + b ^ 2 + c ^ 2 - b * c) =
      (a * d - b * c) * (a * d - b ^ 2 + b * c - c ^ 2) := by
  ring

/-- Two anti-invariant factors are proportional to the diagonal bracket.  Their only nonzero
Plücker coordinates are `z₂=-μ` and `z₃=3μ`, so the Plücker relation is `-3μ²`. -/
theorem antiInvariantFactor_plucker (μ : R) :
    (0 : R) * 0 - 0 * 0 + (-μ) * (3 * μ) = -(3 : R) * μ ^ 2 := by
  ring

end PluckerFactorizations

section CoherentFanoIdentities

variable {R : Type*} [CommRing R]

/-- The first coherent-Fano coefficient combination equals six times the leading consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_first_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d2 * d4 - d0 * d3 ^ 2 - d1 ^ 2 * d4 +
          2 * d1 * d2 * d3 - d2 ^ 3) =
      -3 * (d0 * d3 ^ 2 - d1 ^ 2 * d4) -
      2 * (d0 * d1 * d5 - 2 * d0 * d2 * d4 - 3 * d0 * d3 ^ 2 +
        3 * d1 ^ 2 * d4 + d1 * d2 * d3) +
      (2 * d0 * d1 * d5 + 2 * d0 * d2 * d4 - 9 * d0 * d3 ^ 2 +
        3 * d1 ^ 2 * d4 - 4 * d1 * d2 * d3 + 6 * d2 ^ 3) -
      6 * (d1 ^ 2 * d4 - 3 * d1 * d2 * d3 + 2 * d2 ^ 3) := by
  ring

/-- The second coherent-Fano coefficient combination equals six times the next consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_second_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d2 * d5 - d0 * d3 * d4 - d1 ^ 2 * d5 +
          d1 * d2 * d4 + d1 * d3 ^ 2 - d2 ^ 2 * d3) =
      -6 * (d0 * d3 * d4 - 3 * d1 * d2 * d4 + 2 * d1 * d3 ^ 2) +
      9 * (2 * d0 * d3 * d4 - d1 ^ 2 * d5 -
        2 * d1 * d2 * d4 + d1 * d3 ^ 2) +
      6 * (d0 * d2 * d5 - 3 * d0 * d3 * d4 + d1 ^ 2 * d5 +
        2 * d1 * d2 * d4 - 3 * d1 * d3 ^ 2 + 2 * d2 ^ 2 * d3) -
      3 * (d1 ^ 2 * d5 + 2 * d1 * d2 * d4 -
        9 * d1 * d3 ^ 2 + 6 * d2 ^ 2 * d3) := by
  ring

/-- The third coherent-Fano coefficient combination equals six times the reversal-paired
consecutive `3 × 3` Hankel minor. -/
theorem coherentFano_third_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d3 * d5 - d0 * d4 ^ 2 - d1 * d2 * d5 +
          d1 * d3 * d4 + d2 ^ 2 * d4 - d2 * d3 ^ 2) =
      -3 * (d0 * d4 ^ 2 + 2 * d1 * d3 * d4 -
        9 * d2 ^ 2 * d4 + 6 * d2 * d3 ^ 2) +
      6 * (d0 * d3 * d5 + d0 * d4 ^ 2 - 3 * d1 * d2 * d5 +
        2 * d1 * d3 * d4 - 3 * d2 ^ 2 * d4 + 2 * d2 * d3 ^ 2) -
      9 * (d0 * d4 ^ 2 - 2 * d1 * d2 * d5 +
        2 * d1 * d3 * d4 - d2 ^ 2 * d4) -
      6 * (d1 * d2 * d5 - 3 * d1 * d3 * d4 + 2 * d2 ^ 2 * d4) := by
  ring

/-- The fourth coherent-Fano coefficient combination equals six times the trailing consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_fourth_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d1 * d3 * d5 - d1 * d4 ^ 2 - d2 ^ 2 * d5 +
          2 * d2 * d3 * d4 - d3 ^ 3) =
      -6 * (d1 * d4 ^ 2 - 3 * d2 * d3 * d4 + 2 * d3 ^ 3) +
      (2 * d0 * d4 * d5 + 2 * d1 * d3 * d5 + 3 * d1 * d4 ^ 2 -
        9 * d2 ^ 2 * d5 - 4 * d2 * d3 * d4 + 6 * d3 ^ 3) -
      2 * (d0 * d4 * d5 - 2 * d1 * d3 * d5 + 3 * d1 * d4 ^ 2 -
        3 * d2 ^ 2 * d5 + d2 * d3 * d4) +
      3 * (d1 * d4 ^ 2 - d2 ^ 2 * d5) := by
  ring

end CoherentFanoIdentities

section TwoCoordinateModularKernel

variable {R Syndrome Lower : Type*}
  [CommRing R]
  [AddCommGroup Syndrome] [Module R Syndrome]
  [AddCommGroup Lower] [Module R Lower]

/-- For a contraction family linear in two marker coordinates, containment of the whole family
in a lower nucleus is equivalent to containment of the two coordinate contractions.  This is the
linear coherent-lift calculation behind consecutive-support modular pullbacks. -/
theorem mem_modularContractionKernel_prod_iff
    (contractionFamily : Syndrome →ₗ[R] (R × R) →ₗ[R] Lower)
    (nucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈
        PRSPolarInduction.modularContractionKernel contractionFamily nucleus ↔
      contractionFamily syndrome (1, 0) ∈ nucleus ∧
        contractionFamily syndrome (0, 1) ∈ nucleus := by
  constructor
  · intro h
    exact ⟨h (1, 0), h (0, 1)⟩
  · rintro ⟨hfirst, hsecond⟩ ⟨x, y⟩
    have hdecomposition :
        (x, y) = x • (1, 0) + y • (0, 1) := by
      ext <;> simp
    rw [hdecomposition, map_add, map_smul, map_smul]
    exact nucleus.add_mem
      (nucleus.smul_mem x hfirst)
      (nucleus.smul_mem y hsecond)

end TwoCoordinateModularKernel

section CyclicPlaneTermination

variable {Coefficient : Type*} [Zero Coefficient]

/-- If the first coefficient block `a₀,…,a_m` and the shifted last block
`a₄,…,a_{m+4}` vanish with `m ≥ 3`, then every coefficient through `a_{m+4}` vanishes. -/
theorem cyclicPlaneCatalecticant_blocks_cover
    {m : ℕ} (hm : 3 ≤ m) (a : ℕ → Coefficient)
    (hfirst : ∀ i, i ≤ m → a i = 0)
    (hlast : ∀ i, i ≤ m → a (i + 4) = 0) :
    ∀ i, i ≤ m + 4 → a i = 0 := by
  intro i hi
  by_cases him : i ≤ m
  · exact hfirst i him
  · have hfour : 4 ≤ i := by omega
    let k := i - 4
    have hk : k ≤ m := by
      dsimp [k]
      omega
    have hik : k + 4 = i := by
      dsimp [k]
      omega
    rw [← hik]
    exact hlast k hk

/-- Under the two cyclic-plane block equations and `m ≥ 3`, there is no nonzero coefficient in
the projective range represented by the consecutive catalecticant. -/
theorem cyclicPlaneCatalecticant_no_nonzero_coefficient
    {m : ℕ} (hm : 3 ≤ m) (a : ℕ → Coefficient)
    (hfirst : ∀ i, i ≤ m → a i = 0)
    (hlast : ∀ i, i ≤ m → a (i + 4) = 0) :
    ¬ ∃ i, i ≤ m + 4 ∧ a i ≠ 0 := by
  rintro ⟨i, hi, hne⟩
  exact hne (cyclicPlaneCatalecticant_blocks_cover hm a hfirst hlast i hi)

end CyclicPlaneTermination

end RelativeConicArcs.PRSStableComponents
