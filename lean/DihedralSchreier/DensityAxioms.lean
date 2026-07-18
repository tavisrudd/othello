import Mathlib

/-!
# Quarantined analytic input for Theorem 12.1 (prime equidistribution)

This file contains **exactly one** imported mathematical assertion: the prime number theorem
for arithmetic progressions (equivalently, the equal-Dirichlet-density statement it implies).
It is the single classical analytic input that mathlib does not yet provide and that the
manuscript's Theorem 12.1 depends on.  Everything downstream in
`DihedralSchreier/DensityConditional.lean` is derived from this axiom together with the
already-formalized finite classification in `DihedralSchreier/Density.lean`.

The counting primitives `primeCount` and `primeCountMod` used to state the axiom are defined
here so that the axiom's statement is self-contained and its `#print axioms` audit exposes the
precise external input, mirroring `RepairCodes/Imported.lean` and
`RelativeConicArcs/Q11DyeAxioms.lean`.
-/

namespace DihedralSchreier
namespace DensityAxioms

open Filter

open Classical in
/-- `π(x)` — the number of primes below `x`. -/
noncomputable def primeCount (x : ℕ) : ℕ :=
  ((Finset.range x).filter Nat.Prime).card

open Classical in
/-- `π(x; m, a)` — the number of primes `p < x` with `p ≡ a (mod m)` (residue read in
`ZMod m`). -/
noncomputable def primeCountMod (m : ℕ) (a : ZMod m) (x : ℕ) : ℕ :=
  ((Finset.range x).filter (fun p : ℕ => p.Prime ∧ ((p : ZMod m) = a))).card

/-- **Imported: Prime Number Theorem for Arithmetic Progressions.**

H. Davenport, *Multiplicative Number Theory*, 3rd ed. (GTM 74), Springer 2000, Chapters 20–22
(the prime number theorem for arithmetic progressions; see also §22 for the Siegel–Walfisz
form).  Classical statement: for `gcd(a, m) = 1`,
`π(x; m, a) ∼ (1/φ(m)) · π(x)` as `x → ∞`,
i.e. the primes are equidistributed among the `φ(m)` reduced residue classes modulo `m`, each
class carrying natural density `1/φ(m)` among the primes.

Below, the reduced-residue-class hypothesis `gcd(a, m) = 1` is expressed as `IsUnit a` in
`ZMod m` (equivalent by `ZMod.isUnit_iff_coprime`), and the asymptotic ratio `π(x;m,a)/π(x)`
is stated as convergence to `(φ m)⁻¹`.  This is **exactly** the classical theorem — no
effective error term, no uniformity in `m`, and no statement beyond a single fixed reduced
class — and it is the strongest analytic input Theorem 12.1 consumes.

This is a **quarantined classical input pending mathlib**: mathlib currently proves only the
qualitative Dirichlet theorem (infinitude of primes in each reduced residue class, e.g.
`Nat.forall_exists_prime_gt_and_zmodEq`), not this quantitative equidistribution statement.
When mathlib gains PNT-in-AP, this axiom should be replaced by that theorem. -/
axiom primes_equidistribute
    (m : ℕ) (hm : 1 ≤ m) (a : ZMod m) (ha : IsUnit a) :
    Tendsto (fun x => (primeCountMod m a x : ℝ) / (primeCount x : ℝ))
      atTop (nhds ((Nat.totient m : ℝ)⁻¹))

#print axioms primes_equidistribute

end DensityAxioms
end DihedralSchreier
