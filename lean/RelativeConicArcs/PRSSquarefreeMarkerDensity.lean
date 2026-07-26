import Mathlib.Algebra.MvPolynomial.Funext
import Mathlib.RingTheory.MvPolynomial.Symmetric.FundamentalTheorem

/-!
# Polynomial density of distinct-root coefficient tuples

For an infinite field, a multivariate polynomial that vanishes on every tuple of pairwise
distinct field elements is zero.  Combining this with algebraic independence of the elementary
symmetric polynomials proves that coefficient tuples of monic split squarefree polynomials are
polynomially dense in the full monic coefficient space.

This is the algebraic density statement used for products of distinct retained markers.  It does
not identify a particular catalecticant row-space map or a lower bad-component ideal.
-/

namespace RelativeConicArcs.PRSSquarefreeMarkerDensity

open Function

variable {K : Type*} [Field K] [Infinite K]

omit [Field K] [Infinite K] in
private theorem finCases_injective
    {n : ℕ} {r : K} {x : Fin n → K}
    (hx : Injective x) (hr : r ∉ Set.range x) :
    Injective (Fin.cases r x) :=
  Fin.cons_injective_of_injective hr hx

/-- A polynomial in finitely many variables over an infinite field is determined by its values on
tuples with pairwise distinct coordinates. -/
theorem eq_zero_of_eval_eq_zero_on_injective :
    ∀ {n : ℕ} {p : MvPolynomial (Fin n) K},
      (∀ x : Fin n → K, Injective x → MvPolynomial.eval x p = 0) → p = 0 := by
  intro n
  induction n with
  | zero =>
      intro p h
      apply MvPolynomial.funext
      intro x
      simpa using h x (fun i => Fin.elim0 i)
  | succ n ih =>
      intro p h
      apply (MvPolynomial.finSuccEquiv K n).injective
      rw [map_zero]
      apply Polynomial.ext
      intro degree
      apply ih
      intro x hx
      let polynomial :=
        (MvPolynomial.finSuccEquiv K n p).map (MvPolynomial.eval x)
      have hpolynomial : polynomial = 0 := by
        apply Polynomial.eq_zero_of_infinite_isRoot
        have hinfinite :
            ({r : K | r ∉ Set.range x} : Set K).Infinite :=
          Set.finite_range x |>.infinite_compl
        apply hinfinite.mono
        intro r hr
        change r ∉ Set.range x at hr
        change Polynomial.eval r polynomial = 0
        have heval := h (Fin.cases r x)
          (finCases_injective (x := x) (r := r) hx hr)
        calc
          Polynomial.eval r polynomial =
              MvPolynomial.eval x
                (Polynomial.eval (MvPolynomial.C r)
                  (MvPolynomial.finSuccEquiv K n p)) := by
            dsimp only [polynomial]
            rw [Polynomial.eval_map]
            symm
            simpa using
              Polynomial.hom_eval₂
                (p := MvPolynomial.finSuccEquiv K n p)
                (RingHom.id _) (MvPolynomial.eval x) (MvPolynomial.C r)
          _ = MvPolynomial.eval (Fin.cases r x) p := by
            simpa using
              MvPolynomial.eval_polynomial_eval_finSuccEquiv
                p (MvPolynomial.C r)
          _ = 0 := heval
      have hcoeff := congrArg (fun q : Polynomial K => q.coeff degree) hpolynomial
      simpa [polynomial] using hcoeff

/-- Pullback from monic coefficient coordinates to ordered root coordinates.  Coefficient
variable `i` is sent to the elementary symmetric polynomial of degree `i+1` in the roots. -/
noncomputable def splitCoefficientPullback {n : ℕ}
    (p : MvPolynomial (Fin n) K) : MvPolynomial (Fin n) K :=
  (MvPolynomial.esymmAlgHom (Fin n) K n p).val

/-- Elementary symmetric coefficient coordinates are algebraically independent. -/
theorem splitCoefficientPullback_injective
    {K : Type*} [Field K] {n : ℕ} :
    Injective (splitCoefficientPullback (K := K) (n := n)) := by
  intro p q hpq
  exact MvPolynomial.esymmAlgHom_fin_injective K (n := n) (m := n) le_rfl
    (Subtype.ext hpq)

/-- The coefficient tuples of monic split squarefree degree-`n` polynomials are polynomially
dense: a polynomial relation whose elementary-symmetric pullback vanishes on every injective
ordered root tuple is the zero relation. -/
theorem eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective
    {n : ℕ} {p : MvPolynomial (Fin n) K}
    (h : ∀ roots : Fin n → K, Injective roots →
      MvPolynomial.eval roots (splitCoefficientPullback p) = 0) :
    p = 0 := by
  apply splitCoefficientPullback_injective (K := K)
  have hpullback :
      splitCoefficientPullback p = 0 :=
    eq_zero_of_eval_eq_zero_on_injective h
  simpa [splitCoefficientPullback] using hpullback

end RelativeConicArcs.PRSSquarefreeMarkerDensity
