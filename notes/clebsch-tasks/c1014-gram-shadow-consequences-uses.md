# C1014 — Gram-shadow consequences and uses

**Lane:** clebsch
**Status:** open, math-only exploration alongside C1013; no manuscript or
Ergodis source edits at this stage.
**Scope:** shake the downstream tree opened by \(G_{d,r}=\Delta\,\Phi_{d,r}\)
(see `c1013-gram-discriminant-invariant-hierarchy.md` and the classicality
boundary in `c1013-gram-discriminant-classicality-audit.md`).

## Threads

1. **Finite-field double covers and Frobenius biases.** The covers
   \(C_m:\ y^2=\Phi_{2m,4}(\lambda)\); genus growth, exact biases against Weil
   bounds, exceptional collapses (including the \(q=11,13\) harmonic-design
   collapse flagged in the audit).
2. **Fermat/Lucas splitting of the branch locus.** Session finding
   (2026-08-30): with \(s_m=\lambda^m+(1-\lambda)^m\),
   \(d_m=\lambda^m-(1-\lambda)^m\), the recorded identity
   \(G_{2m,4}=(1-(a+b)^2)(1-(a-b)^2)\) reads
   \(G_{2m,4}=(1-s_m^2)(1-d_m^2)\), and the collision factor
   \(\lambda^2(1-\lambda)^2\) distributes so that
   \[
    \Phi_{2m,4}=\varepsilon\,(1+s_m)\cdot\frac{s_m-1}{\lambda(1-\lambda)}
    \cdot\frac{1+d_m}{\lambda}\cdot\frac{1-d_m}{1-\lambda}.
   \]
   All four pieces are Lucas-type polynomials in \(u=\lambda(1-\lambda)\)
   (or times \(d_1\)), so square-class biases should decompose into
   Jacobi-sum-type character sums on Fermat-locus factors rather than opaque
   Frobenius traces. Verification and constants: see the dated arithmetic
   report listed below.
3. **Real/local signature and Hasse refinements.** Sign of \(\Phi_{d,r}\) as
   restricted-signature stratifier over \(\mathbf R\); Hasse/spinor
   invariants as the next arithmetic shadows past the square class.
4. **Automorphism groups of the induced colorings** and excess-automorphism
   marking-loss obstructions, family-level (Paper V's mechanism for all
   \(m\)).
5. **Exceptional harmonic/equianharmonic collapses** — structural location of
   \(\Phi_{2m,4}=0\) against \(I=0\), \(J=0\).
6. **Exact marking fibres and query complexity** of the
   \(\Phi\)-coloring shadow.
7. **Applications routing:** Papers IV–V versus a standalone sparse-shadow
   arithmetic/reconstruction theorem; every novelty claim stays behind the
   literature-audit conventions (audit's coverage gaps apply).

## State after 2026-08-30 session

- Thread 1: genus of \(C_m\) is \(2m-4\), dropping to \(2m-5\) exactly when
  \(m\equiv1\bmod3\) (proved via \(\operatorname{ord}_I\Phi=2/1/0\) for
  \(m\equiv1/2/0\bmod3\)); Jacobian splits under \(\lambda\mapsto1-\lambda\).
  Three proved exceptional strata, periodic in \(2m\bmod(p-1)\); the
  \(q=11,13\) harmonic collapse is exactly these. Bias is always odd — hence
  nonzero — away from divisors of \(4^{m-1}-1\), from
  \(\Phi_{2m,4}(1/2)=16(1-4^{1-m})\).
- Thread 2: verified with global sign \(-1\); the pieces are Dickson
  polynomials (\(s_m=D_m(1,u)\)), not Chebyshev/cyclotomic except
  \(I=\Phi_6(\lambda)\). Jacobi-sum decomposition **refuted**: at \(m=3\) the
  descent quotients are non-CM elliptic curves with
  \(\operatorname{Jac}(C_3)\sim E_1^2\).
- Open anomalies: sporadic collapse at \((m,p)=(6,23)\); the \(m=3\) curve
  \(E_1\) shows 13 supersingular primes below 500 all \(\equiv11\bmod12\)
  despite non-integral \(j=71^3/2160\) — needs an independent recheck (CM
  signature vs a bug in the supersingular test).

## Session reports

- `../2026-08-30-c1013-c1014-phi-family-arithmetic.md` — factorization
  verification, \(u\)-descent, genus/bias tables, Jacobi-sum decomposition.
- `../2026-08-30-c1013-modular-transvectant-foundations.md` — modular
  radicals, integrality/content laws, parity/Pfaffian residuals,
  transvectant identification (C1013-side, feeds threads 1–2 boundaries).

## Compute routing

Per user directive (2026-08-30) and the queue row: try Ergodis first for
compute/solve legs (exact small-field rank kernels, compiled finite-field/
orbit search; read-only use, no Ergodis or ergodis-private source edits).
Where its existing CLI/library cannot express a leg, fall back to scripts and
record the missing typed operation as an interface-improvement note (C1013
card §7 discipline).

## Boundaries

- No priority/classicality sentence leaves this card without an audit per
  `notes/literature-audit-conventions.md`; the C1013 audit's "no-predecessor-
  located" list is the current boundary.
- Promotion to any paper is a separate explicit decision, not part of this
  task.
