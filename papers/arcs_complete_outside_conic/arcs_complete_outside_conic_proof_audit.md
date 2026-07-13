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

Verifier SHA-256:

`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

## Claims intentionally omitted

- No claim that the classical first two index equations are new.
- No claimed association-scheme or spectral theorem.
- No claim that a lower bound on the conic-incidence term can settle
  \(\rho_C(16)=8\) versus \(9\); the paper proves that this route is too weak.
- No exact values for orders whose witnesses were not independently included
  and checked in the supplementary verifier.
- No unconditional novelty certification for the parameter itself.
