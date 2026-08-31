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
   \(m\)). **Largely closed 2026-08-30** (marking-reconstruction report
   below): the 4-set coloring is honestly \(PGL_2\)-invariant for every
   \((d,q)\) (bracket weights are even — no twisted case), and there is a
   clean dichotomy with no exceptional set beyond arithmetic: a constant
   coloring has \(\mathrm{Aut}=\mathrm{Sym}(q+1)\), every nonconstant one
   has exactly \(\mathrm{Aut}=P\Gamma L_2(q)\) (proof via 3-transitivity +
   an odd \((q+1)\)-cycle and the 3-transitive classification; census of
   881 \((m,q)\) pairs, \(q\le121\), zero partial collapses). Marking
   fibre is uniformly \(\mathrm{Gal}(\mathbf F_q/\mathbf F_p)\) —
   trivial over prime fields. Paper V's \(q=11\) harmonic design is
   reproduced exactly and its \(9!\)-candidate check becomes a corollary.
   Two new proved strata: \(r=2p^i\) (Frobenius-twist total collapse over
   non-prime fields) and \(r=p+1\) over \(\mathbf F_{p^2}\) — the
   **Baer-subline coloring = Miquelian inversive plane of order \(p\)**,
   with the \(-1\) color absent; it is the unique refinement failure and
   the unique query-complexity jump. \((47,30)\) is not
   reconstruction-exceptional. Query bounds: \(\Theta(q\log q)\)
   information-theoretic, an explicit \(O(q^2)\) adaptive strategy
   sufficing except on Baer strata.
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
  \(H^0(\Omega)=a\cdot\mathrm{triv}+b\cdot\mathrm{sgn}+c\cdot\mathrm{std}\).
  **Proved (2026-08-30 evening, two independent proofs — explicit character
  computation on the basis \(\lambda^i d\lambda/y\), symbolic for
  \(m\le40\), and equivariant Riemann–Hurwitz):**
  \[a=b=\lfloor(m-2)/3\rfloor,\qquad c=(g-2a)/2,\qquad
    g=2m-4-2[m\equiv1\bmod3].\]
  Two structural corrections/upgrades from the proof: the honest \(S_3\) on
  \(C_m\) is \(\langle\sigma,\iota\tau\rangle\) — \(\langle\sigma,\tau\rangle\)
  is dihedral of order 12 with \((\sigma\tau)^3=\iota\) (Theorem H's
  containment stands, its generator does not); and the exact product law
  \(u^2\Phi_{2m,4}=\prod_{\varepsilon,\eta}(1+\varepsilon\lambda^m+
  \eta(1-\lambda)^m)\) holds for all \(m\), giving
  \(\lambda^{4m-6}\Phi(1/\lambda)=\Phi(\lambda)\) with constant 1. The
  genus law is now a theorem (\(I\) is the only repeated root of \(\Phi\),
  multiplicity exactly 2, exactly when \(m\equiv1\bmod3\)). Isotypic
  growth: \(\dim A_{\mathrm{triv}}=\dim A_{\mathrm{sgn}}=a\to g/6\),
  \(2\dim A_{\mathrm{std}}\to2g/3\); \(a\) jumps at \(m\equiv2\bmod3\).
  Explicit \(S_3\)-quotient models via the syzygy \(V^2=4I^3-27W^2\),
  \(J=I^3/W^2\): \(C_m/S_3:Y^2=R_m(J)\) and
  \(C_m/S_3':Z^2=(4J-27)R_m(J)\), with conductors 150/2550 (\(m=5\)),
  1584/2046 (\(m=6\)), 637/6370 (\(m=7\)), all \(a_p\)-matched to the
  measured traces — the sign-side conductors sit above the earlier
  level-1600 search bound, which is why that search found nothing.
  Elliptic factors: level 150 (\(m=5\), \(D_1\)), level 1584 (\(m=6\),
  \(D_1\)).
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
- Open items after the Chevalley–Weil pass ((a,b,c) derivation is closed):
  the \(m=3\) bias \(\equiv1\bmod4\) rigidity; the sporadic stratum
  \((p,r)=(47,30)\); the
  \(m=8\) abelian-surface isotypic factors are unidentified; the sign-side
  quotient conductor uses all of \(\mathrm{Bad}(C_m)\) while the trivial
  side drops primes in an unexplained pattern (measured \(m=5,6,7\) only;
  \(m=7\) breaks the "largest harmonic prime" reading); and \(m=6\) is the
  only row where the 2- and 3-adic conductor exponents differ between the
  isotypic sides. Settled by inspection (tt pass): genus \(\equiv4\bmod6\)
  never occurring is immediate from the proved genus law — all three
  residues of \(m\bmod3\) give \(g\equiv0\) or \(2\bmod6\); not a mystery.
- tt second pass (2026-08-30, banked): Hasse–Witt invariant census of the
  Gram quadratic space (second coloring, thread 3 — is it also
  Dickson-structured?); compute the tower's motive once from the
  Dickson-pullback datum instead of curve-by-curve newform hunting (would
  make conductors a priori); Sato–Tate moment statistics as a cheap
  decision between split \(\mathrm{GL}_2\)-type and simple
  \(\mathrm{USp}(4)\) for the \(m=8\) surfaces; extremal/maximal-curve
  criterion over \(\mathbf F_{p^2}\) (bridge back to codes); the
  reconstruction/marking threads carry the audit's actual novelty and have
  no work yet — spine of any paper; possible \(\mathbf Z[\zeta_6]\)-linear
  reformulation unifying \(I=\Phi_6\), the period-6 trace, mod-6 genus
  classes, and the anharmonic \(S_3\); for odd \(d\) study the Pfaffian
  residual \(\pi\) itself (value and zero locus), not just \(\Phi=\pi^2\).
- tt-pass frontier (2026-08-30): the tower \(\{C_m\}\) is the pullback of
  one fixed curve along the Dickson map, which should *derive* the
  \(2m\bmod(p-1)\) stratification and likely absorbs \((47,30)\); the
  bias \(\bmod4\) rigidity should follow in one line from \(E_1\)'s
  \(\mathbf Z/4\)-torsion; the excluded set \(p\mid4^{m-1}-1\) in the
  odd-bias theorem is uncharacterized; the \(r=5\) power-sum/Jacobi–Trudi
  analogue on \(x+y+z+w=0\) is the structural generalization feeding C1013
  gate 3; candidate uniform conjecture: every isotypic factor of
  \(\operatorname{Jac}(C_m)\) is of \(\mathrm{GL}_2\)-type with level
  supported on the bad-prime law (first test: the \(m=8\) surfaces).
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

- `../2026-08-30-c1014-marking-reconstruction.md` — invariance, Aut
  dichotomy, uniform Galois fibre, Baer/Miquelian stratum, query bounds,
  novelty boundary ("to our knowledge", audit gaps apply). Script:
  `c1014_marking_reconstruction.py`.
- `../2026-08-30-c1014-chevalley-weil-multiplicities.md` — proved
  \((a,b,c)\) closed form, dihedral-lift correction, product law for
  \(u^2\Phi\), genus-law theorem, explicit \(S_3\)-quotient models and
  conductors. Scripts: `c1014_chevalley_weil.py`, `c1014_cw_quotients.gp`.
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
