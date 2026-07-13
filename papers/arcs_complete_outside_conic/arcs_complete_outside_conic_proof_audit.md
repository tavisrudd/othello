# Proof and claim audit

## Analytic claims proved in the paper

1. The first and second secant-index equations are proved by direct double counting and identified as classical.
2. The prescribed-hole defect formula is an exact identity, not an estimate:
   \[
   m\Delta_H(A)=
   \sum_{x\in X_H(A)}(r(x)-1)(m-r(x))+
   \sum_{y\in H}r(y)(m-r(y)).
   \]
3. Coverage, uncovered-locus, equality, and quantitative stability statements are immediate corollaries of the exact identity.
4. For a nonsingular conic, the lower bound uses only \(|C|=q+1\) and the preceding identity.
5. The asymptotic lower bound is obtained from the parity-free necessary inequality
   \[
   q^2-k\le \frac{k-1}{2}\bigl(k(q-1)-(k-2)(k-3)\bigr),
   \]
   giving \(k\ge\sqrt{2q}+3/2-O(q^{-1/2})\).
6. The upper-bound transfer is an averaging argument over \(\operatorname{PGL}(3,q)\).
7. The even-characteristic statements use only the standard nucleus/tangent facts for a nonsingular conic.

## Computer-assisted claims

The supplementary verifier checks explicit upper-bound witnesses for
\(q=8,9,11,16\). It enumerates the whole projective plane, checks the conic,
arc condition, relative coverage, and both classical moment equations.

The lower bounds for these orders are analytic. No exhaustive nonexistence
search is used in the paper.

For the (q=11) witness, the verified value (I_C=0) implies that all 15
secants are exterior to the conic. Completeness, the maximum index three, and
the two moment equations then force the required-point index counts
((N_1,N_2,N_3)=(90,15,10)).

The auxiliary q=11 residual-game remark is separately machine checked in
`RelativeConicArcs/Q11Residual.lean`: kernel reduction verifies that all twelve conic parameters
are initially live and that their determinant-defined conflict graph is the 30-edge, degree-five
icosahedral graph. The P-value conclusion uses the generic proved antipodal conflict-graph mirror
theorem, not an exhaustive game-tree evaluator. This result is not used by the paper's bounds.

Verifier SHA-256:

`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

## Lean formalization

The standalone `lean/RelativeConicArcs/` package formalizes the elementary theorem chain and the
four finite certificates. Its generic Boolean checker verifies conic disjointness, the arc
condition, and coverage on the (q^2+q+1) canonical projective representatives; `check_sound`
proves that acceptance implies semantic relative completeness. The accepted coordinate list need
not be normalized or duplicate-free.

The aggregate builds without warnings. The source contains no `sorry`, `admit`, custom axiom, or
`native_decide`. The load-bearing certificate, arithmetic, and final numerical theorems report
exactly `[propext, Classical.choice, Quot.sound]`; see `lean/RelativeConicArcs/TRUST.md` for the
theorem map, provenance, and trust boundary. The Kim--Vu input remains an explicit named theorem
hypothesis and is not used by the finite results.

## Claims intentionally omitted

- No claim that the classical first two index equations are new.
- No claimed association-scheme or spectral theorem.
- No claim that a lower bound on the conic-incidence term can settle
  \(\rho_C(16)=8\) versus \(9\); the paper proves that this route is too weak.
- No exact values for orders whose witnesses were not independently included
  and checked in the supplementary verifier.
- The remaining `rho_C(16) in {8,9}` dichotomy is assigned to C101; closing it requires either a
  checked eight-point construction or a checked exhaustive eight-point nonexistence certificate.
- No unconditional novelty certification for the parameter itself.
