# C512 — effective coherent polar induction for split-free Hankel systems

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete conditional general theorem;
the lower-cover monodromy hypotheses remain level-specific inputs

## Result

For every fixed redundancy, split-free Hankel systems satisfy an effective dichotomy.  A coherently
parameterized catalecticant polar flag is either contained in an explicitly computable persistent
rank-two or modular-nucleus component, or the field size is bounded by a closed expression in:

- the degree with which the polar line meets the lower bad carrier;
- the ramification/collision degree of the pointed linear series; and
- the genus and deletion degree of the identity-Frobenius twist of the lower splitting cover.

The statement is conditional only on a geometric lower-cover package: separability, geometric
integrality of the identity twist, and explicit genus/deletion bounds.  These are intrinsic and
checkable from normalization, monodromy on ordered roots, and the different.  They are verified by the
C491 cover in the C498 step and by C498's pointed upgrade in the C509 step.  No field census enters the
general theorem.

The threshold is explicit.  Put
\[
 \mathcal H(g,\delta)=
 \left\lfloor\left(g+\sqrt{g^2+\delta}\right)^2\right\rfloor+1.
\]
If `b` is the transverse lower-bad intersection degree and `c` the marked-collision degree, then
\[
 Q=\max\{\mathcal H(g,\delta),\,b+c\}                         \tag{1}
\]
works.  More generally, take the maximum of (1) over the finitely many lower-cover strata.  Thus, after
removing the contained persistent/modular flags, a split-free system over \(\mathbf F_q\) has
\(q<Q\).

For C498 this recovers the exact logical bound \(q\ge29\), with lower-cover deletion \(18\) and
transverse budget \(3+4+6=13\).  For C509 it recovers \(q\ge37\), with lower-cover deletion \(24\)
and transverse budget \(3+1+8=12\).  The q=19 pointed orbit
\(\langle1,t^3,t^4\rangle\) proves why the parameterized flag is indispensable: it is a bad
individual contraction, but no consecutive-row polar line is contained in its orbit.

## 1. Characteristic-free pointed polar functor

Let \(S\) be a scheme, let \(E\) be a rank-two locally free \(\mathcal O_S\)-module, and use divided
powers for syndromes:
\[
 D_n=\mathbf P(\Gamma^n E).
\]
The perfect divided-power/symmetric-power pairing is valid in every characteristic.  For
\(f\in\Gamma^nE\), define its Hankel kernel intrinsically by
\[
 W_f=\{g\in\operatorname{Sym}^{n-1}E^\vee:
       \langle f,\lambda g\rangle=0\text{ for every }\lambda\in E^\vee\}.       \tag{2}
\]
When the two Hankel rows are independent, \(W_f\) has vector dimension \(n-2\).

For a linear factor \([\lambda]\in\mathbf P(E^\vee)\), contraction is characterized by
\[
 \langle\iota_\lambda f,g\rangle=\langle f,\lambda g\rangle.                   \tag{3}
\]
Equations (2)--(3) give the exact lifting identity
\[
 g\in W_{\iota_\lambda f}\quad\Longleftrightarrow\quad \lambda g\in W_f.       \tag{4}
\]
Thus a completely split squarefree lower member lifts unless \(\lambda\mid g\).  The forbidden
condition is the universal incidence divisor
\[
 \Delta=\{([\lambda],[g]):\lambda\mid g\}
 \subset\mathbf P(E^\vee)\times\mathbf P(\operatorname{Sym}^{n-2}E^\vee).
\]
It is not an after-the-fact exclusion: it belongs to the pointed moduli problem.

The first-polar morphism is
\[
 \Phi_f:\mathbf P(E^\vee)\longrightarrow D_{n-1},\qquad
 [\lambda]\longmapsto[\iota_\lambda f].                                      \tag{5}
\]
Its image is the projectivization of the contraction map
\(E^\vee\to\Gamma^{n-1}E\), hence a point or a line.  In a frame,
\[
 \Phi_f(r)=(a_1-ra_0,\ldots,a_n-ra_{n-1}),\qquad
 \Phi_f(\infty)=(a_0,\ldots,a_{n-1}),
\]
so infinity is part of (5), not a separate chart convention.  Equations (2)--(5) commute with arbitrary
base change and with \(PGL(E)\).

For distinct ordered factors \(\boldsymbol\lambda=(\lambda_1,\ldots,\lambda_j)\), define
\[
 \Phi_f^{(j)}(\boldsymbol\lambda)=
 [\iota_{\lambda_j}\cdots\iota_{\lambda_1}f].                 \tag{6}
\]
Contractions commute, but (6) retains the ordered factors as marked forbidden roots.  The domain is the
complement of the pairwise diagonals in \(\mathbf P(E^\vee)^j\), and the final witness must avoid every
\(\lambda_i\).  This is the **catalecticant polar flag**.  Forgetting the parameterization of (5), or the
markers in (6), destroys the lifting criterion (4).

## 2. Intrinsic lower splitting package

Fix a degree \(m\) and a number \(s\) of marked forbidden roots.  Let
\(\mathcal X_{m,s}\) be the moduli space of a degree-\(m\) syndrome together with \(s\) distinct ordered
points of \(\mathbf P(E^\vee)\).  A **lower splitting package**
\[
 (B_{m,s},\{\mathcal C_\alpha\},g_\alpha,\delta_\alpha)
\]
has the following data.

1. \(B_{m,s}\subset\mathcal X_{m,s}\) is a closed, \(PGL(E)\)-stable bad carrier.  It contains the
   inseparable, reducible-monodromy, persistent, modular, and boundary strata on which the generic
   splitting-cover argument is not valid.  Equations for it are supplied, not merely its set of finite-field
   points.
2. On each stratum of \(\mathcal X_{m,s}\setminus B_{m,s}\), the ordered-root splitting incidence has a
   finite cover whose identity-Frobenius twist \(\mathcal C_\alpha\) is a geometrically integral projective
   curve.  Its normalization has genus at most \(g_\alpha\).
3. A divisor of degree at most \(\delta_\alpha\) removes branch points, repeated-root diagonals, and the
   \(s\) forbidden-root incidences.  Every rational point left over gives a completely split squarefree
   Hankel-kernel member avoiding all markers.

This package is intrinsic and finitely checkable at fixed \(m,s\):

- separability is the nonvanishing of the discriminant;
- geometric integrality is equivalent to transitivity of geometric monodromy on the relevant ordered-root
  tuples;
- the genus follows from normalization, or from Riemann--Hurwitz using the cover degree and different;
- \(\delta_\alpha\) is an intersection degree of the diagonal, branch, and marker divisors; and
- the equations and their degrees can be obtained by elimination from the universal apolar incidence.

The arithmetic meaning is standard Frobenius splitting.  Wang's `arXiv:2606.12810v1` supplies this
general Galois/étale dictionary; the claim-specific audit records the exact boundary.  C512 uses the
one-dimensional effective consequence rather than an unspecified asymptotic constant.

### Effective lower witness lemma

If \(q\) is a prime power and
\[
 q+1-2g_\alpha\sqrt q>\delta_\alpha,                          \tag{7}
\]
then \(\mathcal C_\alpha(\mathbf F_q)\) contains a point outside the deletion divisor, hence the
corresponding pointed lower Hankel system has an admissible split member.  The definition of
\(\mathcal H\) makes \(q\ge\mathcal H(g_\alpha,\delta_\alpha)\) sufficient for (7).

This is Hasse--Weil on the normalization; singular models may equivalently use Aubry--Perret.  Constant
field obstructions are not swept into the error term: failure of an identity-Frobenius twist to be
geometrically integral puts the system in \(B_{m,s}\).

## 3. Contained-or-transverse theorem

Let \(f\in D_n(\mathbf F_q)\) carry \(s\) existing markers.  Pull the lower bad carrier back along the
graph of its coherently pointed polar map:
\[
 Z_f=(\Phi_f,\lambda_1,\ldots,\lambda_s,\lambda)^*B_{n-1,s+1}
 \subset\mathbf P(E^\vee).                                   \tag{8}
\]
Let \(R_f\) be the marked self-collision divisor: parameters \(\lambda\) for which every lower witness
vanishing at \(\lambda\) vanishes there twice, or an existing marker is repeated.

Assume the following fixed-degree data have been computed:

- **transverse degree:** if \(Z_f\ne\mathbf P^1\), then
  \(\deg Z_f\le b_{n,s}\);
- **collision degree:** outside the declared inseparable modular locus,
  \(\deg R_f\le c_{n,s}\); and
- **contained classification:** if \(Z_f=\mathbf P^1\), or \(R_f=\mathbf P^1\), then \(f\) belongs to the
  explicitly computed persistent catalecticant locus \(\mathcal P_n\) or modular-nucleus locus
  \(\mathcal M_n\).

These hypotheses are scheme-theoretic and algorithmic.  If \(B_{n-1,s+1}\) is cut out by multihomogeneous
equations, substitute the linear contraction (5); the degrees of the resulting binary forms give
\(b_{n,s}\), and their simultaneous vanishing decides containment.  The collision divisor is the
ramification divisor of the moving series after fixed factors are removed.  In the generic Hankel case
\(W_f\) is a \(g^{\,n-3}_{\,n-1}\), so
\[
 c_{n,0}\le (n-2)((n-1)-(n-3))=2n-4.                         \tag{9}
\]
In small characteristic, a zero differential is detected before (9) and routed to \(\mathcal M_n\);
it is never silently counted as a finite divisor.

> **Theorem (effective coherent polar induction).**
> Let the lower splitting package and the three displayed degree/containment hypotheses hold at
> degrees through \(n\).  Put
> \[
> A_{n-1,s+1}=\max_\alpha\mathcal H(g_\alpha,\delta_\alpha),\qquad
> Q_{n,s}=\max\{A_{n-1,s+1},\,b_{n,s}+c_{n,s}\}.              \tag{10}
> \]
> If \(q\ge Q_{n,s}\), every split-free degree-\(n\) Hankel system over \(\mathbf F_q\) belongs to
> \(\mathcal P_n\cup\mathcal M_n\).  Equivalently, off those contained loci every split-free system has
> \(q<Q_{n,s}\).

*Proof.*  Suppose \(f\notin\mathcal P_n\cup\mathcal M_n\).  The contained-classification hypothesis
makes \(Z_f\cup R_f\) a finite divisor of degree at most \(b_{n,s}+c_{n,s}\).  Since
\(\#\mathbf P^1(\mathbf F_q)=q+1>b_{n,s}+c_{n,s}\), choose a rational \(\lambda\) outside it.  The pointed
lower contraction lies outside \(B_{n-1,s+1}\).  As \(q\ge A_{n-1,s+1}\), the effective lower witness
lemma supplies a completely split squarefree \(g\in W_{\iota_\lambda f}\) avoiding \(\lambda\) and all
earlier markers.  By (4), \(\lambda g\in W_f\), and avoidance makes it squarefree.  This contradicts
split-freeness.  Therefore \(f\in\mathcal P_n\cup\mathcal M_n\).  Every constant in (10) is obtained by
the finite operations listed above, so the bound is effective. \(\square\)

Iteration applies the theorem to (6).  For fixed redundancy only finitely many \(m,s\) occur; taking the
maximum of their \(Q_{m,s}\) is an effective arithmetic bound for every transverse polar flag.

## 4. Classified contained components

### 4.1 Persistent catalecticant flags

Let
\[
 C_f^{(2)}:\operatorname{Sym}^{n-2}E^\vee\longrightarrow\Gamma^2E
\]
be the middle Hankel/catalecticant contraction.  The consecutive-row identity generalizing C498/C509
gives
\[
 \Phi_f(\mathbf P^1)\subset\{\operatorname{rank}C^{(2)}\le2\}
 \quad\Longleftrightarrow\quad
 \operatorname{rank}C_f^{(2)}\le2.                            \tag{11}
\]
One direction is functoriality of contraction.  Conversely, if the rank is larger, its kernel cannot lie
in every factor hyperplane \(\lambda\operatorname{Sym}^{n-2}E^\vee\), whose total intersection is zero.
Thus (11) classifies all polar lines contained in the catalecticant secant closure.

Over an algebraic closure, rank at most two is the secant/tangent closure of the degree-\(n\) NRC.
Over \(\mathbf F_q\), remove rank one and rational split secants as shallow.  The two deep persistent
forms are:

- a rational double root (tangent); and
- a conjugate quadratic pair (sigma-secant).

Equivalently, \(W_f\) has a common quadratic factor that is respectively a square or irreducible.  The
dimension inequality
\[
 \dim W_f=n-2\le n-\deg(\gcd W_f)
\]
forces the persistent common factor to have degree at most two in every redundancy; it does not grow
with \(n\).

The orbit arithmetic is uniform.  Write \(T\) for the norm-one torus.  On a sigma fibre the torus acts
by \(z\mapsto z^n\), so the intrinsic invariant is
\[
 T/T^n\quad\text{modulo inversion and Frobenius}.             \tag{12}
\]
If \(d=\gcd(n,q+1)\), the \(PGL_2(q)\)-orbits are the inversion-orbits of \(C_d\); coefficientwise
Frobenius acts by multiplication by the characteristic \(p\) on \(C_d\).

On a tangent fibre, torus normalization leaves the scalar additive cocycle
\[
 u\star z=z+nu.                                               \tag{13}
\]
If \(p\nmid n\), the unipotent radical is transitive.  If \(p\mid n\), (13) is zero and the torus gives
the fixed/nonzero split.  This proves the predicted modular tangent law rather than inferring it from
field tables.  For redundancy \(r\), \(n=r-1\), so (12) is \(T/T^{r-1}\) and the split occurs exactly
when \(p\mid r-1\).

### 4.2 Modular-nucleus flags

For each \(p,n,j\), let \(\mathcal N_{n,j,p}\) be the \(j\)-nucleus of the degree-\(n\) NRC, defined
intrinsically as the intersection of its \(j\)-osculating spaces after base change to characteristic
\(p\).  Gmainer--Havlicek's binomial-coordinate criterion and Lucas' theorem compute it by finite linear
algebra.

The complete space of degree-\(n\) syndromes whose first-polar line is contained in a lower nucleus
\(\mathcal N\subset\mathbf P(\Gamma^{n-1}E)\) is
\[
 \mathcal M_n(\mathcal N)=
 \mathbf P\ker\!\left(
   \Gamma^nE\longrightarrow
   \operatorname{Hom}(E^\vee,\Gamma^{n-1}E/\widetilde{\mathcal N})
 \right).                                                     \tag{14}
\]
Formula (14) is exactly the consecutive-row overlap test.  Iterating (14) classifies every
modular-nucleus polar flag: at each step take the kernel of the next contraction map modulo the already
computed nucleus.  Hence the modular contained components are explicit linear schemes for fixed
\(n,p\); no ambient projective census or guessed trinomial normal form is required.

Containment is geometric, while deepness on a component can remain arithmetic.  The C498
characteristic-two \(3\)-nucleus line is deep precisely in odd extension degree, and (14) contracts it at
C509 to one central sextic point.  C512 deliberately keeps those arithmetic deck-transformation laws in
the lower splitting package rather than declaring every nucleus point deep.

## 5. Verification on C498 and C509

| Step | lower identity-twist bound | transverse carrier | collision | contained components | resulting theorem |
|---|---:|---:|---:|---|---|
| C498, \(n=5\) | \(q-2\sqrt q>18\), first prime power \(29\) | secant cubic \(3\) plus cyclic/wild closure at most \(4\) | \(2n-4=6\) | quadratic-gcd rank two; in characteristic two the \(3\)-nucleus line | \(q\ge29\): only persistent plus the classified nucleus line |
| C509, \(n=6\) | \(q-2\sqrt q>24\), first prime power \(37\) | secant closure \(3\), plus at most one nucleus intersection | \(2n-4=8\) | quadratic-gcd rank two; characteristic-two nucleus contracts to \(e_3\) | \(q\ge37\): only persistent plus the odd-degree central point |

The lower curves in the first row are C491's absolutely irreducible \(S_3\) fibre-square curves of
arithmetic genus one.  Their diagonal/branch deletions cost twelve, and the first marked root costs six.
The second row adds one further forbidden root, raising the deletion from eighteen to twenty-four.
Geometric cyclic, wild, inseparable, and constant-field-twisted cases are precisely the declared lower
bad carrier, not failures of (7).

The persistent formulas specialize to \(T/T^5\) and tangent coefficient \(5\) for C498, and to
\(T/T^6\) and tangent coefficient \(6\) for C509.  Thus both the geometric trichotomy
`persistent / modular / arithmetically bounded` and the exact orbit laws are instances of the theorem's
intrinsic clauses.

## 6. The q=19 flag-coherence falsifier

At q=19, the C509 certificate contains one pointed-bad affine orbit of size nineteen represented by the
C498 syndrome \(e_2\), with quartic net
\[
 \langle1,t^3,t^4\rangle.
\]
It has exactly six split squarefree members, and every one contains the marked point at infinity.  Thus
the individual contraction is pointed-bad although it is not C498-deep.

No sextic has both consecutive Hankel rows synchronized so that its entire parameterized polar line
lies in this orbit.  Consequently the orbit contributes no C509 deep syndrome.  A theorem about the set
of bad lower fibres would falsely promote this transient orbit to an inductive component.  In (8), it is
only a point of the pullback divisor \(Z_f\); the theorem promotes a family only when the **graph of the
pointed polar map** is contained scheme-theoretically.  This is the promised theorem-level falsifier.

## 7. Exact remaining gaps and scope

The theorem is field-independent and effective, but it does not claim that the required lower splitting
package has already been verified in every degree.  At a new redundancy the genuine inputs are:

1. equations for every lower residual bad carrier;
2. geometric monodromy transitivity, or direct absolute irreducibility, for each identity twist;
3. genus/different and deletion degrees for those twists; and
4. the kernel calculations (11) and (14) for all contained components in the relevant characteristics.

Failure of item 2 is substantive: it can signal a constant-field twist or a new persistent/modular
component.  It may not be replaced by an empirical field threshold.  Once these four finite checks are
made, (10) supplies the arithmetic bound automatically.

This does not classify all linear systems of binary forms, prove all-redundancy Reed--Solomon deep-hole
classification, or provide intrinsic normal forms for C498/C509's remaining small-field exceptional
tables.  It proves the induction theorem requested by C512 and identifies exactly what a later fixed
redundancy must verify.

## Extra-juice closeout

The effective threshold can be sharpened without changing the theorem's shape:

- use the exact Frobenius conjugacy-class twist rather than the whole Galois closure;
- use the geometric genus instead of arithmetic genus after normalization;
- count overlaps among deletion divisors instead of summing their degrees; and
- substitute the actual polar line into lower equations before taking a global degree bound.

These are cheap level-specific improvements and explain why C498/C509 beat a generic Lang--Weil
constant.  They do not justify a redundancy-eight census: the next meaningful work is the lower-cover
monodromy/contained-flag calculation, after which (10) gives the bounded falsifier domain.

## Mystery ledger

Settled:

- **What is the intrinsic inductive object?**  The graph of the pointed contraction map (5), iterated as
  (6), together with its forbidden-root divisors.
- **Can “arithmetically bounded” be made effective?**  Yes: equation (10) is a closed threshold in the
  genus, deletion, transverse-intersection, and collision degrees.
- **Why does the common-factor family persist with degree two?**  The Hankel-kernel dimension inequality
  forces gcd degree at most two in every redundancy.
- **What causes the exact tangent split?**  The scalar cocycle \(u\star z=z+nu\), so precisely
  \(p\mid n=r-1\).
- **How are modular contained flags classified without a census?**  By the contraction-kernel formula
  (14), after Lucas/binomial computation of the lower NRC nuclei.
- **Why is q=19 not an inductive exception?**  Its bad pointed contraction is transient; no coherent
  consecutive-row polar line is contained in its orbit.

Open, with exact owner/gate:

- **Uniform lower-cover monodromy in arbitrary degree.**  Evidence gap: no theorem currently proves the
  required ordered-root transitivity for every residual Hankel splitting cover.  Gate: compute the
  geometric monodromy or absolute irreducibility at each new fixed redundancy.  Owner: a future
  fixed-redundancy application, not C512.
- **All-degree catalogue of arithmetic laws on modular nuclei.**  Formula (14) classifies the contained
  linear schemes, but deepness can depend on constant-field deck transformations.  Gate: determine the
  arithmetic monodromy of each nonempty component.  Owner: the application in that characteristic.
- **Sharpness of the generic threshold.**  Equation (10) is sufficient, not asserted optimal.  Gate:
  normalize the actual identity twist and compute overlap-corrected deletions.

No genuine mystery remains about the abstract induction mechanism itself.

## Literature boundary

The adjacent audit `2026-07-23-c512-general-polar-flag-literature-audit.md` finds no pre-emption,
qualified by its MathSciNet gap.  Wang's June 2026 splitting-family framework is the closest source and
is cited as arithmetic infrastructure, not claimed as C512's contribution.
