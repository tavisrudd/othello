import RelativeConicArcs.SphericalMomentFunctional

/-!
# The degree-six zonal harmonic and its addition theorem

For a coefficient vector `u : Fin 3 → ℝ` the *zonal form of degree six* is the
real ternary form

```
zonalHarmonic u = (231 * ℓ ^ 6 - 315 * ℓ ^ 4 * r + 105 * ℓ ^ 2 * r ^ 2 - 5 * r ^ 3) / 16,
```

where `ℓ = ∑ i, u i * X i` is the linear form with coefficient vector `u` and
`r = X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2`.  It is the homogenization of the degree-six
Legendre polynomial `legendreSix s = (231 s ^ 6 - 315 s ^ 4 + 105 s ^ 2 - 5)/16`
in the sense of `eval_zonalHarmonic` below: on a coefficient vector `v` with
`∑ i, v i ^ 2 = 1` its value is `legendreSix (∑ i, u i * v i)`.

The module proves that the form is homogeneous of degree six, that its Laplacian
vanishes when `∑ i, u i ^ 2 = 1`, and the addition theorem

```
gaussianMoment (zonalHarmonic u * zonalHarmonic v) = 10395 * legendreSix (∑ i, u i * v i)
```

for coefficient vectors `u` and `v` with `∑ i, u i ^ 2 = ∑ i, v i ^ 2 = 1`,
together with its normalized form
`normalizedMean 12 (zonalHarmonic u * zonalHarmonic v)
  = legendreSix (∑ i, u i * v i) / 13`.

## Scope and trust boundary

`gaussianMoment` and `normalizedMean` are the explicitly defined functionals of
`RelativeConicArcs.SphericalMomentFunctional`, given by a formula on monomials.
The classical identification of `normalizedMean` with the normalized surface
integral over the unit two-sphere is not formalized in either module and is not
used here, so the addition theorem above is a polynomial identity and not a
statement about spherical integrals.  Nothing in the module imports measure
theory, and the proof uses no analysis: the three terms of the second factor
carrying `r` are removed by the sphere relation followed by the lower-degree
vanishing of `gaussianMoment` against a form of vanishing Laplacian, and the
surviving term is evaluated by apolarity against a power of a linear form.
-/

namespace RelativeConicArcs.ZonalHarmonicDegreeSix

open MvPolynomial RelativeConicArcs.SphericalMomentFunctional

/-- The Legendre polynomial of degree six as a function of one real argument,
normalized so that its value at `1` is `1`. -/
noncomputable def legendreSix (s : ℝ) : ℝ := (231 * s ^ 6 - 315 * s ^ 4 + 105 * s ^ 2 - 5) / 16

/-- The value at `1` is `1`. -/
@[simp] lemma legendreSix_one : legendreSix 1 = 1 := by rw [legendreSix]; norm_num

/-- The degree-six Legendre polynomial sees its argument only through the square.
An axis of the configuration is a line rather than a chosen vector, and a
zonal value is therefore determined by the squared inner product of two axes; the
sign of a chosen representative does not enter. -/
lemma legendreSix_of_sq {s t : ℝ} (h : s ^ 2 = t) :
    legendreSix s = (231 * t ^ 3 - 315 * t ^ 2 + 105 * t - 5) / 16 := by
  subst h
  rw [legendreSix]
  ring

/-- The zonal form of degree six with axis `u`: the homogenization of
`legendreSix` along the axis `u`, obtained by replacing each even power `s ^ (2k)`
of the argument by `(∑ i, u i * X i) ^ (2k)` times the matching power of
`X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2`.  For a unit axis it is a harmonic form of degree
six; see `laplacian_zonalHarmonic`. -/
noncomputable def zonalHarmonic (u : Fin 3 → ℝ) : MvPolynomial (Fin 3) ℝ :=
  C (1 / 16) * (231 * linearForm u ^ 6 - 315 * (linearForm u ^ 4 * quadric)
    + 105 * (linearForm u ^ 2 * quadric ^ 2) - 5 * quadric ^ 3)

/-- The zonal form of degree six is homogeneous of degree six. -/
theorem isHomogeneous_zonalHarmonic (u : Fin 3 → ℝ) : (zonalHarmonic u).IsHomogeneous 6 := by
  have hl : (linearForm u).IsHomogeneous 1 := isHomogeneous_linearForm u
  have hq : quadric.IsHomogeneous 2 := isHomogeneous_quadric
  have h6 : (linearForm u ^ 6).IsHomogeneous 6 := by simpa using hl.pow 6
  have h4 : (linearForm u ^ 4 * quadric).IsHomogeneous 6 := by simpa using (hl.pow 4).mul hq
  have h2 : (linearForm u ^ 2 * quadric ^ 2).IsHomogeneous 6 := by
    simpa using (hl.pow 2).mul (hq.pow 2)
  have h0 : ((quadric : MvPolynomial (Fin 3) ℝ) ^ 3).IsHomogeneous 6 := by simpa using hq.pow 3
  have hnum : ∀ (n : ℕ) [n.AtLeastTwo] {p : MvPolynomial (Fin 3) ℝ}, p.IsHomogeneous 6 →
      ((OfNat.ofNat n : MvPolynomial (Fin 3) ℝ) * p).IsHomogeneous 6 := by
    intro n _ p hp
    rw [← map_ofNat (C : ℝ →+* MvPolynomial (Fin 3) ℝ) n]
    exact hp.C_mul _
  exact ((((hnum 231 h6).sub (hnum 315 h4)).add (hnum 105 h2)).sub (hnum 5 h0)).C_mul _

/-- The value of the zonal form at a coefficient vector of unit length is the
degree-six Legendre polynomial of the inner product of the two vectors. -/
theorem eval_zonalHarmonic (u v : Fin 3 → ℝ) (hv : ∑ i, v i ^ 2 = 1) :
    eval v (zonalHarmonic u) = legendreSix (∑ i, u i * v i) := by
  have hl : eval v (linearForm u) = ∑ i, u i * v i := by
    rw [linearForm, map_sum]
    exact Finset.sum_congr rfl fun i _ => by simp
  have hq : eval v quadric = 1 := by
    rw [quadric, map_sum, ← hv]
    exact Finset.sum_congr rfl fun i _ => by simp
  rw [zonalHarmonic, legendreSix]
  simp only [map_mul, map_sub, map_add, map_pow, map_ofNat, eval_C, hl, hq]
  ring

section Harmonicity

/-- A derivation kills a numeral. -/
@[simp] private lemma pderiv_ofNat (i : Fin 3) (n : ℕ) [n.AtLeastTwo] :
    pderiv i (ofNat(n) : MvPolynomial (Fin 3) ℝ) = 0 := by
  rw [← Nat.cast_ofNat (R := MvPolynomial (Fin 3) ℝ) (n := n), Derivation.map_natCast]

/-- The second derivative along one variable of the sixteenfold zonal form,
grouped by the way each term depends on the index: through the square of the
`i`-th coefficient, through the product of that coefficient with `X i`, through
`X i ^ 2`, or not at all. -/
private lemma pderiv_pderiv_zonal (u : Fin 3 → ℝ) (i : Fin 3) :
    pderiv i (pderiv i (231 * linearForm u ^ 6 - 315 * (linearForm u ^ 4 * quadric)
        + 105 * (linearForm u ^ 2 * quadric ^ 2) - 5 * quadric ^ 3))
      = (6930 * linearForm u ^ 4 - 3780 * linearForm u ^ 2 * quadric + 210 * quadric ^ 2)
          * C (u i) ^ 2
        + (-5040 * linearForm u ^ 3 + 1680 * linearForm u * quadric) * (C (u i) * X i)
        + (840 * linearForm u ^ 2 - 120 * quadric) * X i ^ 2
        + (-630 * linearForm u ^ 4 + 420 * linearForm u ^ 2 * quadric
            - 30 * quadric ^ 2) := by
  simp only [map_sub, map_add, pderiv_mul, pderiv_pow, pderiv_linearForm, pderiv_quadric,
    pderiv_C, pderiv_ofNat, pderiv_X_self, Nat.cast_ofNat, zero_mul, mul_zero, zero_add,
    add_zero, mul_one]
  ring

/-- The sixteenfold zonal form of a unit axis is harmonic.  Summing the grouped
second derivatives over the three variables replaces the square of the
coefficient by `∑ i, u i ^ 2 = 1`, the coefficient times `X i` by the linear
form, and `X i ^ 2` by the quadric, after which the three surviving coefficient
identities `231 * 30 = 315 * 22`, `315 * 12 = 105 * 36` and `105 * 2 = 5 * 42`
cancel every term. -/
private lemma laplacian_zonal_unscaled (u : Fin 3 → ℝ) (hu : ∑ i, u i ^ 2 = 1) :
    laplacian (231 * linearForm u ^ 6 - 315 * (linearForm u ^ 4 * quadric)
      + 105 * (linearForm u ^ 2 * quadric ^ 2) - 5 * quadric ^ 3) = 0 := by
  have hcoeff : ∑ i, C (u i) ^ 2 = (1 : MvPolynomial (Fin 3) ℝ) := by
    rw [← map_one (C : ℝ →+* MvPolynomial (Fin 3) ℝ), ← hu, map_sum]
    exact Finset.sum_congr rfl fun i _ => by rw [map_pow]
  have hlin : ∑ i, C (u i) * X i = linearForm u := rfl
  have hquad : ∑ i, (X i : MvPolynomial (Fin 3) ℝ) ^ 2 = quadric := rfl
  rw [laplacian_apply, Finset.sum_congr rfl fun i _ => pderiv_pderiv_zonal u i,
    Finset.sum_add_distrib, Finset.sum_add_distrib, Finset.sum_add_distrib,
    ← Finset.mul_sum, ← Finset.mul_sum, ← Finset.mul_sum, Finset.sum_const, hcoeff, hlin, hquad]
  simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, Nat.cast_ofNat]
  ring

/-- The zonal form of a unit axis has vanishing Laplacian. -/
theorem laplacian_zonalHarmonic (u : Fin 3 → ℝ) (hu : ∑ i, u i ^ 2 = 1) :
    laplacian (zonalHarmonic u) = 0 := by
  rw [zonalHarmonic, MvPolynomial.C_mul', map_smul, laplacian_zonal_unscaled u hu, smul_zero]

end Harmonicity

section AdditionTheorem

/-- Expanding the second factor of a product with a zonal form. -/
private lemma mul_zonalHarmonic_expand (p : MvPolynomial (Fin 3) ℝ) (v : Fin 3 → ℝ) :
    p * zonalHarmonic v
      = C (1 / 16) * (231 * (p * linearForm v ^ 6)
        - 315 * (quadric * (p * linearForm v ^ 4))
        + 105 * (quadric * (quadric * (p * linearForm v ^ 2)))
        - 5 * (quadric * (quadric * (quadric * p)))) := by
  rw [zonalHarmonic]
  ring

/-- A numeral factor passes through the Gaussian moment functional. -/
private lemma gaussianMoment_ofNat_mul (n : ℕ) [n.AtLeastTwo] (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment ((OfNat.ofNat n : MvPolynomial (Fin 3) ℝ) * p)
      = (OfNat.ofNat n : ℝ) * gaussianMoment p := by
  rw [← map_ofNat (C : ℝ →+* MvPolynomial (Fin 3) ℝ) n, gaussianMoment_C_mul]

/-- Multiplying by the sum of the squares of the variables preserves the
vanishing of the Gaussian moment of a homogeneous form. -/
private lemma gaussianMoment_quadric_mul_eq_zero {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) (h : gaussianMoment p = 0) :
    gaussianMoment (quadric * p) = 0 := by
  rw [gaussianMoment_quadric_mul hp, h, mul_zero]

/-- The addition theorem for the degree-six zonal forms.  For two unit axes `u`
and `v` the Gaussian moment of the product of the two zonal forms is `10395`
times the degree-six Legendre polynomial of the inner product of the axes.  The
proof expands the second factor: the three terms carrying `X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2`
are removed because that factor rescales the moment while the remaining product
pairs the harmonic form `zonalHarmonic u` with a form of degree below six, and
the surviving term is `231 / 16` times the apolar evaluation of `zonalHarmonic u`
against the sixth power of the linear form of `v`, whose value is
`6 ! * legendreSix (∑ i, u i * v i)`. -/
theorem gaussianMoment_zonalHarmonic_mul (u v : Fin 3 → ℝ)
    (hu : ∑ i, u i ^ 2 = 1) (hv : ∑ i, v i ^ 2 = 1) :
    gaussianMoment (zonalHarmonic u * zonalHarmonic v)
      = 10395 * legendreSix (∑ i, u i * v i) := by
  have hZ6 : (zonalHarmonic u).IsHomogeneous 6 := isHomogeneous_zonalHarmonic u
  have hZh : laplacian (zonalHarmonic u) = 0 := laplacian_zonalHarmonic u hu
  have hq : quadric.IsHomogeneous 2 := isHomogeneous_quadric
  have hL : (linearForm v).IsHomogeneous 1 := isHomogeneous_linearForm v
  have hvan : ∀ (e : ℕ), e < 6 → ∀ q : MvPolynomial (Fin 3) ℝ, q.IsHomogeneous e →
      gaussianMoment (zonalHarmonic u * q) = 0 :=
    gaussianMoment_mul_eq_zero_of_laplacian_eq_zero 6 _ hZ6 hZh
  -- the term carrying the sixth power of the linear form
  have key6 : gaussianMoment (zonalHarmonic u * linearForm v ^ 6)
      = 720 * legendreSix (∑ i, u i * v i) := by
    rw [gaussianMoment_mul_linearForm_pow 6 _ hZ6 hZh v, eval_zonalHarmonic u v hv]
    norm_num [Nat.factorial]
  -- the term carrying one copy of the quadric
  have key4 : gaussianMoment (quadric * (zonalHarmonic u * linearForm v ^ 4)) = 0 := by
    refine gaussianMoment_quadric_mul_eq_zero (d := 10) ?_ ?_
    · simpa using hZ6.mul (by simpa using hL.pow 4)
    · exact hvan 4 (by norm_num) _ (by simpa using hL.pow 4)
  -- the term carrying two copies of the quadric
  have key2 : gaussianMoment (quadric * (quadric * (zonalHarmonic u * linearForm v ^ 2))) = 0 := by
    have hin : (zonalHarmonic u * linearForm v ^ 2).IsHomogeneous 8 := by
      simpa using hZ6.mul (by simpa using hL.pow 2)
    have h1 : gaussianMoment (quadric * (zonalHarmonic u * linearForm v ^ 2)) = 0 :=
      gaussianMoment_quadric_mul_eq_zero hin
        (hvan 2 (by norm_num) _ (by simpa using hL.pow 2))
    exact gaussianMoment_quadric_mul_eq_zero (d := 10) (by simpa using hq.mul hin) h1
  -- the term carrying three copies of the quadric
  have key0 : gaussianMoment (quadric * (quadric * (quadric * zonalHarmonic u))) = 0 := by
    have hz : gaussianMoment (zonalHarmonic u) = 0 := by
      simpa using hvan 0 (by norm_num) 1 (isHomogeneous_one (Fin 3) ℝ)
    have h1 : gaussianMoment (quadric * zonalHarmonic u) = 0 :=
      gaussianMoment_quadric_mul_eq_zero hZ6 hz
    have h8 : (quadric * zonalHarmonic u).IsHomogeneous 8 := by simpa using hq.mul hZ6
    have h2 : gaussianMoment (quadric * (quadric * zonalHarmonic u)) = 0 :=
      gaussianMoment_quadric_mul_eq_zero h8 h1
    exact gaussianMoment_quadric_mul_eq_zero (d := 10) (by simpa using hq.mul h8) h2
  rw [mul_zonalHarmonic_expand, gaussianMoment_C_mul, map_sub, map_add, map_sub,
    gaussianMoment_ofNat_mul, gaussianMoment_ofNat_mul, gaussianMoment_ofNat_mul,
    gaussianMoment_ofNat_mul, key6, key4, key2, key0]
  ring

/-- The addition theorem in normalized form: the normalized mean of the product
of the two degree-twelve zonal forms of unit axes `u` and `v` is one thirteenth
of the degree-six Legendre polynomial of the inner product of the axes. -/
theorem normalizedMean_zonalHarmonic_mul (u v : Fin 3 → ℝ)
    (hu : ∑ i, u i ^ 2 = 1) (hv : ∑ i, v i ^ 2 = 1) :
    normalizedMean 12 (zonalHarmonic u * zonalHarmonic v)
      = legendreSix (∑ i, u i * v i) / 13 := by
  have hfac : momentFactor (12 + 2) = 135135 := by norm_num [momentFactor]
  rw [normalizedMean, gaussianMoment_zonalHarmonic_mul u v hu hv, hfac]
  ring

end AdditionTheorem

end RelativeConicArcs.ZonalHarmonicDegreeSix
