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

- Thread 1: genus of \(C_m\) is \(2m-4\), dropping to \(2m-6\) exactly when
  \(m\equiv1\bmod3\) (**corrected 2026-08-30 evening**: the repeated factor
  is \(I^2\) and must be divided out whole; the first report's \(2m-5\) and
  its \(\chi(\Phi)=\chi(\mathrm{radical})\) preamble carry the same
  off-by-one — current statements live in the modular-structure report
  below). Jacobian splits under \(\lambda\mapsto1-\lambda\) into quotients
  \(D_1,D_2\) with \(g_1+g_2=g(C_m)\). Exceptional strata: the earlier three
  proved families, plus a fourth proved stratum
  \(r=2m\equiv(p-1)/2+1\bmod(p-1)\) (sign uniformity, not an extremum) —
  this resolves the \((6,23)\) sporadic, with \((5,19)\) the same stratum;
  complete constant-character classification for \(p\le300\) fits one
  \(\mu_n\) family except one point. Bias is always odd — hence nonzero —
  away from divisors of \(4^{m-1}-1\), from
  \(\Phi_{2m,4}(1/2)=16(1-4^{1-m})\).
- Modular identifications: \(m=3\) → conductor 90 (below); \(m=4\) → both
  quotients elliptic of **conductor 14** (the unique level-14 newform;
  torsion \(\mathbf Z/6\)). Uniform supersingular-congruence law: \(L=\)
  lcm of rational torsion over the isogeny class divides \(p+1\), giving
  \(p\equiv11\bmod12\) at \(m=3\) (\(L=12\)) and \(p\equiv5\bmod6\) at
  \(m=4\) (\(L=6\)); exhaustive to \(p<2000\). Higher-genus quotients
  (\(m=5,6\)) all split, though \(\operatorname{Aut}(D)=1\): the split comes
  from the anharmonic \(S_3\) acting on the square-class model of
  \(\Phi_{2m,4}\) (Theorem H, exact over \(\mathbf Q\));
  \(H^0(\Omega)=a\cdot\mathrm{triv}+b\cdot\mathrm{sgn}+c\cdot\mathrm{std}\)
  with measured \((a,b,c)=(0,0,1),(0,0,1),(1,1,2),(1,1,3)\) at
  \(m=3,4,5,6\). Elliptic factors located: level 150 (\(m=5\), \(D_1\)),
  level 1584 (\(m=6\), \(D_1\)).
- Exact bad-prime law (no exceptions, \(m=2..12\)):
  \(\{2\}\cup H(m)\cup M(m)\cup E(m)\) — harmonic point
  (\(p\mid4^{m-1}-1\), minus \(p=3\) when \(m\equiv1\bmod3\)), collision
  locus (odd \(p\mid m\)), true double branch point
  (\(p\mid\operatorname{Res}\) after removing the common factor; first at
  \((8,29)\), closing that open item). Levels stay supported on the bad
  primes, but \(\{2,3,5\}\) does not persist: 7 enters at \(m=4\), 17 at
  \(m=5\), 11 and 31 at \(m=6\).
- Thread 2: verified with global sign \(-1\); the pieces are Dickson
  polynomials (\(s_m=D_m(1,u)\)), not Chebyshev/cyclotomic except
  \(I=\Phi_6(\lambda)\). Jacobi-sum decomposition **refuted**: at \(m=3\) the
  descent quotients are non-CM elliptic curves with
  \(\operatorname{Jac}(C_3)\sim E_1^2\).
- Open items after the modular-structure pass: derive the \((a,b,c)\)
  multiplicities (Riemann–Hurwitz for \(C_m\to C_m/S_3\), which would also
  give the \(D_2\) conductors); the \(m=3\) bias \(\equiv1\bmod4\) rigidity;
  and the newly isolated unexplained stratum \((p,r)=(47,30)\), which
  replaces \((6,23)\) as the open sporadic point.
- The
  \(m=3\) supersingular anomaly is **resolved** (2026-08-30, independent
  PARI recheck): the data are correct and extend (22 zeros of \(a_p\) below
  3000, all \(\equiv11\bmod12\)), but the mechanism is classical, not CM.
  \(E_1\) has conductor \(90\), rational torsion \(\mathbf Z/4\), and lies
  in the eight-curve conductor-90 isogeny class with cyclic 12-isogenies.
  A rational 4-torsion point forces \(4\mid p+1\) at any supersingular
  prime, and the rational 3-isogeny forces \(p\equiv2\bmod3\); together
  every supersingular prime is \(\equiv11\bmod12\). The abundance is an
  enhanced Lang–Trotter constant from the same congruence concentration —
  no conflict with Elkies (which gives infinitude, and here infinitely many
  zero-\(a_p\) primes all \(\equiv11\bmod12\)). **Upgrade:** \(E_1\) is
  modular of level 90, so \(\operatorname{Jac}(C_3)\sim E_1^2\) identifies
  the entire \(m=3\) shadow census with the coefficient sequence of the
  level-90 weight-2 newform of its isogeny class — an exact modular law for
  the \(m=3\) bias (bias hits its minimal value exactly at these
  supersingular primes), replacing Weil-bound estimates. Exact
  Cremona/LMFDB label still to be pinned (needs elldata; class is
  determined by conductor 90 + cyclic 12-isogeny structure).

## Session reports

- `../2026-08-30-c1013-c1014-phi-family-arithmetic.md` — factorization
  verification, \(u\)-descent, genus/bias tables, Jacobi-sum decomposition.
- `../2026-08-30-c1014-modular-structure-covers.md` — quotient curves and
  modular identification for \(m=3..6\), genus-law correction, Theorem H
  (anharmonic \(S_3\)), bad-prime law, fourth exceptional stratum resolving
  \((6,23)\), constant-character classification \(p\le300\). Scripts:
  `c1014_modular_structure.py` + generated `c1014_*.gp`.
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
