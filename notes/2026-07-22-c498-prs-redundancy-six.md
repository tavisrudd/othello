# C498 — PRS(q−5) redundancy-six census and corrected entry geometry

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · **Status:** computational calibration complete;
the characteristic-two nucleus family and both q=11 orbits are classified; the generic split-member
theorem and the remaining exceptional-net strata remain open.

## Result

For the quintic normal rational curve
\[
 C=\{(1,t,t^2,t^3,t^4,t^5):t\in\mathbf F_q\}\cup\{(0,0,0,0,0,1)\}
 \subset\mathbf P^5(\mathbf F_q),
\]
an exhaustive census was run for every prime power
\[
q\in\{7,8,9,11,13,16,17,19,23,25,27\}.
\]
In every field, the points outside all spans of four distinct points of \(C\) are exactly the
points whose Hankel-kernel net contains no totally split squarefree binary quartic.  Every such
point lies in a span of five distinct points of \(C\).  Thus the covering radius is exactly
\(\rho=5\) throughout the searched domain, including \(q=7,8\), below the \(q\ge9\)
Seroussi--Roth sufficient range.

The deep set has two strata:

1. A persistent degree-two-gcd stratum of exactly
   \[
   \frac{q(q+1)^2}{2}
   \]
   points in every searched field.  Its common quadratic is either a rational square (the
   tangent family) or irreducible (the sigma-secant family).  This is the redundancy-four
   tangent/secant problem embedded through the full binary-quadratic cofactor system.
2. A trivial-gcd exceptional stratum.  Its PGL2-orbit counts are
   \[
   18,11,4,2,1,0,0,0,0,0,0
   \]
   at \(q=7,8,9,11,13,16,17,19,23,25,27\), respectively.  In particular, the C491 pattern
   does **not** recur at \(q=17,19\): no exceptional net occurs anywhere in the searched band
   \(16\le q\le27\).

This is a bounded theorem.  It neither proves that exceptional nets never recur above 27 nor
supplies the asymptotic split-member bound.

They do in fact recur: the characteristic-two Frobenius-trinomial orbit below gives \(q+1\) deep
directions over every \(\mathbf F_{2^m}\) with \(m\) odd, beginning again at \(q=32\).  Thus there
can be no absolute field-size threshold eliminating all trivial-gcd exceptions.  The correct
asymptotic statement must first remove explicitly classified exceptional families.

## Exact census

| \(q\) | PG(5,q) points | deep points | PGL2 orbits | PGammaL2 orbits | gcd-2 points | trivial-gcd points |
|---:|---:|---:|---:|---:|---:|---:|
| 7 | 19,608 | 5,376 | 20 | 20 | 224 | 5,152 |
| 8 | 37,449 | 5,037 | 13 | 7 | 324 | 4,713 |
| 9 | 66,430 | 2,250 | 8 | 5 | 450 | 1,800 |
| 11 | 177,156 | 1,584 | 4 | 4 | 792 | 792 |
| 13 | 402,234 | 1,820 | 3 | 3 | 1,274 | 546 |
| 16 | 1,118,481 | 2,312 | 2 | 2 | 2,312 | 0 |
| 17 | 1,508,598 | 2,754 | 2 | 2 | 2,754 | 0 |
| 19 | 2,613,660 | 3,800 | 4 | 4 | 3,800 | 0 |
| 23 | 6,728,904 | 6,624 | 2 | 2 | 6,624 | 0 |
| 25 | 10,172,526 | 8,450 | 3 | 3 | 8,450 | 0 |
| 27 | 14,900,788 | 10,584 | 2 | 2 | 10,584 | 0 |

The variation in PGL2 orbit count inside the persistent stratum over non-prime fields is recorded
exactly in the JSON certificate; the tangent/sigma description is geometric and does not assert
that each is always one PGL2 orbit.

## Method and internal checks

The Rust generator constructs each finite field in a fixed polynomial basis and performs two
complete, independent scans of \(\mathbf P^5(\mathbf F_q)\):

- **Definition scan:** mark the union of the spans of every four-element subset of \(C\).
- **Hankel scan:** for \(f=(a_0,\ldots,a_5)\), form
  \[
  H_f=\begin{pmatrix}
  a_0&a_1&a_2&a_3&a_4\\
  a_1&a_2&a_3&a_4&a_5
  \end{pmatrix}
  \]
  and test every projective member of its kernel for four distinct roots in
  \(\mathbf P^1(\mathbf F_q)\).

The two deep sets must agree element-for-element.  The generator then:

- closes every deep point under three PGL2 generators and requires the orbits to partition the
  deep set;
- checks orbit-size divisibility in \(|\mathrm{PGL}_2(q)|=q^3-q\);
- computes Frobenius fusion, representative factor labels, net gcd degree, and the complete
  quartic-member histogram;
- requires zero totally split squarefree members in every recorded deep representative net; and
- checks **every** deep point, not merely each representative, for membership in a five-point
  NRC span.

All assertions pass in all eleven fields.

## Independent replay and trusted boundary

The Python replay shares no finite-field or linear-algebra code with the Rust generator.  For
\(q\le16\) it directly rebuilds the union of all four-point spans from the definition, recovering
the exact deep count.  It also independently reconstructs every recorded PGL2 orbit, Hankel net,
Frobenius link, stabilizer order, net gcd degree, and a five-span witness for every orbit
representative.

For the extra-juice extension \(q\in\{17,19,23,25,27\}\), the same Python replay checks all those
structural and representative-level claims and that the recorded orbit union has the stated size,
but skips its slower independent four-secant marking.  Exhaustiveness there rests on the Rust
generator's elementwise definition/Hankel agreement.  This boundary is deliberate and is not
described as a second exhaustive implementation.

From the repository root:

```sh
rustc -O notes/2026-07-22-c498-prs-deep-hole-census.rs -o /tmp/c498-census
C498_JSON_OUT=/tmp/c498-census.json /tmp/c498-census
cmp /tmp/c498-census.json notes/2026-07-22-c498-prs-deep-hole-census.json
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py \
  --fields 17,19,23,25,27 --skip-direct
(cd notes && sha256sum -c 2026-07-22-c498-prs-redundancy-six.sha256)
```

The computation is deterministic, uses no randomness, and depends only on `rustc` and the Python
standard library.  Field moduli and all enumeration conventions are embedded in both programs.

## Ledger correction: the persistent gcd is always quadratic

C491 §9 called the uniform tangent/secant stratum the “degree \(r-3\) gcd” stratum.  That is true
at \(r=5\) only because \(r-3=2\).  If the Hankel kernel has vector dimension \(r-3\) and a common
factor of degree \(d\), its cofactor space has dimension at most \(r-1-d\).  Therefore
\[
r-3\le r-1-d,\qquad d\le2.
\]
Equality \(d=2\) gives the full binary-quadratic cofactor system.  Thus the tangent/sigma-secant
stratum persists at every redundancy through a **quadratic** common factor, not a degree-\(r-3\)
factor.

## Corrected theoretical entry gate

The original C498 card proposed a direct replacement of C491's fiber-square curve by a
fiber-square surface.  That is insufficient: for a quartic, two rational roots can leave an
irreducible quadratic.

For a trivial-gcd net \(W\subset H^0(\mathbf P^1,\mathcal O(4))\), the correct intrinsic object is
the basepoint-free morphism
\[
\phi_W:\mathbf P^1\longrightarrow\mathbf P(W^\vee)\cong\mathbf P^2.
\]
A net member is the pullback of a line.  On the open locus of three distinct points with
nondegenerate images, the surface
\[
T_W=\{(t_1,t_2,t_3)\in(\mathbf P^1)^3:
\det(\phi_W(t_1),\phi_W(t_2),\phi_W(t_3))=0\}
\]
parametrizes a rational line containing three rational points of the pulled-back divisor; its
fourth residual point is automatically rational.  Hence an \(\mathbf F_q\)-point of \(T_W\)
off the diagonals, ramification locus, and image-degeneracy locus gives a totally split squarefree
member.  Equivalently, one may use the discriminant double cover of the ordered-pair surface.

The determinant is alternating.  After division by the three pairwise brackets
\([t_1t_2][t_1t_3][t_2t_3]\), its residual equation has multidegree \((2,2,2)\) on
\((\mathbf P^1)^3\).  Thus a smooth residual trisecant surface is a K3 surface.  Because the
residual equation is symmetric, it descends through
\(\operatorname{Sym}^3(\mathbf P^1)\cong\mathbf P^3\) to a quadric; rational points upstairs,
rather than arbitrary rational degree-three divisors downstairs, encode three rational roots.
On the smooth stratum, the K3 cohomological estimate has the concrete shape
\[
\left|\#T_W(\mathbf F_q)-(q^2+1)\right|\le 22q,
\]
before subtracting the explicitly bounded bad curves.  Singular or reducible \((2,2,2)\)
surfaces are therefore the natural home of the exceptional-net classification.

The proof gate is therefore:

1. factor the determinant by the three pairwise diagonal factors and determine the residual
   \((2,2,2)\) trisecant surface;
2. prove its geometric irreducibility, or classify every reducible/non-geometrically-irreducible
   case, using the alternatives in
   \(4=\deg(\phi_W)\deg(\phi_W(\mathbf P^1))\), especially double covers of conics;
3. bound the rational points lost to diagonals, ramification, and non-squarefree line sections;
4. apply an explicit Lang--Weil/Chebotarev bound to the surviving surface.

This correction is load-bearing.  The census calibrates the exceptional locus but does not
substitute for those four steps.

## Tao re-foundation: C498 is a line problem inside C491

There is a sharper route than treating the \((2,2,2)\) surface as an undifferentiated K3.  Fix a
rational linear factor \(\ell_r=t-r\).  Cubics \(g\) for which \(\ell_rg\in W\) form a pencil.
Substituting the product into the two Hankel equations shows that its C491 syndrome is
\[
 b(r)=(a_1-ra_0,\ a_2-ra_1,\ldots,a_5-ra_4)\in\mathbf P^4.       \tag{2}
\]
At \(r=\infty\), take \(b(\infty)=(a_0,\ldots,a_4)\).  Thus \(r\mapsto b(r)\) identifies
\(\mathbf P^1\) with the projective line
\[
 \ell_f=\mathbf P\langle(a_0,\ldots,a_4),(a_1,\ldots,a_5)\rangle
 \subset\mathbf P^4,
\]
provided the two Hankel rows are independent.

This imports C491 pointwise.  A totally split squarefree quartic is exactly a rational \(r\) for
which the C491 pencil at \(b(r)\) has a totally split squarefree cubic **not containing \(r\)**.
Consequently:

- the residual trisecant K3 is the family, over \(r\in\mathbf P^1\), of C491's \((2,2)\)
  fiber-square curves \(Y_{b(r)}\);
- tangent/sigma, tame cyclic, characteristic-three nucleus/wild, and \(S_3\) fibres are already
  classified by C491;
- C498's new datum is the pointed exclusion \(r\notin\operatorname{roots}(g)\), plus the
  synchronization constraint that all \(q+1\) points of one line \(\ell_f\) must remain
  exceptional.

The numerical gain is immediate.  C491 gives
\(\#Y_{b(r)}(\mathbf F_q)\ge q-2\sqrt q\) on an \(S_3\) fibre.  Its diagonal and branch deletions
cost at most \(12\) points; deleting the unique cubic member through the prescribed \(r\) costs at
most six more ordered pairs.  Hence
\[
 q-2\sqrt q>18
\]
forces a split quartic from any \(S_3\) fibre, and this holds for every prime power \(q\ge29\).
Therefore a C498 deep net at \(q\ge29\) must have every rational point of \(\ell_f\) in the C491
exceptional/pointed-collision locus.  The next generic theorem is a Fano-scheme problem: classify
the lines contained in that locus, and bound the intersection degree for lines not contained in
it.  The characteristic-two \(3\)-nucleus line is already one contained-line component; the
q=11 split-involution orbit is a collision-only small-field line.

The line is not arbitrary.  In divided-power language it is the **first-polar line** of the binary
quintic \(f\), the image of all contractions by linear forms.  Its Pluecker coordinates are the
adjacent Hankel minors
\[
 p_{ij}=a_i a_{j+1}-a_{i+1}a_j\qquad(0\le i<j\le4).
\]
Thus one need not compute the full Fano scheme of the C491 exceptional locus, only its intersection
with the polar-line locus coming from binary quintics.  This is also the natural bridge to the
quintic invariant toolkit recorded in the literature audit: exceptional C498 normal forms should
be contact types of a polar line with C491's tangent/sigma/cyclic strata.

The parameterization must be retained.  The same \(r\) both selects the point \(b(r)\in\ell_f\)
and names the forbidden repeated fourth root.  An unlabelled line forgets that diagonal and cannot
distinguish a genuine C491 split witness from the collision-only q=11 fibre.  The correct Fano
object is therefore a coherently parameterized polar line with its pointed-collision section.

This fibration does not invalidate the K3 argument.  It explains it and supplies a more structured
proof: sum genus-at-most-one fibre bounds, then use C491's exact exceptional strata to classify
the bad fibres.  The surface-wide \(22q\) estimate becomes a fallback rather than the primary
classification engine.

## Exact symmetric-cube equation

The quotient quadric has a particularly simple intrinsic equation.  Write a binary cubic as
\[
 g=d_0s^3+d_1s^2t+d_2st^2+d_3t^3
\]
and put
\[
 L_j(g)=\sum_{i=0}^3 a_{i+j}d_i\qquad(j=0,1,2).
\]
A quartic divisible by \(g\) has the form \(g(us+vt)\).  The two Hankel equations defining
\(W=\ker H_f\) become
\[
 \begin{pmatrix}L_0(g)&L_1(g)\\L_1(g)&L_2(g)\end{pmatrix}
 \binom uv=0.
\]
Consequently the image of the residual trisecant surface in
\(\operatorname{Sym}^3(\mathbf P^1)\cong\mathbf P^3\) is exactly
\[
 Q_f:\quad L_0L_2-L_1^2=0.                                      \tag{1}
\]
For the trivial-gcd deep representatives in the frozen census the three \(L_j\) are independent,
so \(Q_f\) is the rank-three quadric cone.  This was checked directly from every certified
representative over all eleven fields.  Formula (1), rather than a generic unspecified quadric, is
the right starting point for both the splitting cover and its exceptional monodromy.

## First exceptional family: the characteristic-two 3-nucleus line

Let \(f_\mathrm{Fr}=(0,0,0,1,0,0)\).  Its Hankel net is
\[
 W_\mathrm{Fr}=\langle s^4,s^3t,t^4\rangle ,
\]
or \(\langle1,t,t^4\rangle\) on the affine chart.  This net is basepoint-free and has trivial gcd.
Every member is a Frobenius trinomial
\[
 A+Bt+Ct^4.
\]
If \(C\ne0\), differences of two roots lie in the kernel of
\[
 u\longmapsto u^4+\alpha u,\qquad \alpha=B/C.
\]
Four distinct rational roots would force all three roots of \(u^3=\alpha\) to lie in the ground
field.  Conversely, when \(\mu_3\) is rational, \(t^4+\alpha t\) has four distinct rational roots
for any nonzero cube \(\alpha\).  Therefore
\[
 W_\mathrm{Fr}\text{ contains a totally split squarefree member}
 \quad\Longleftrightarrow\quad 3\mid(q-1)
\]
for \(q\) even.  Equivalently, over \(q=2^m\) it is deep exactly when \(m\) is odd.

The geometry makes the same dichotomy transparent.  The associated rational quartic is
\[
 \phi(t)=(1,t,t^4).
\]
In characteristic two, projection from \(\phi(a)\), after writing \(u=t-a\), is the cubic cover
\(u\mapsto u^3\).  Its two nontrivial geometric deck transformations are rational exactly when
\(\mu_3\subset\mathbf F_q\).  For odd \(m\), Frobenius swaps them and no nonzero rational fibre
splits into three rational residual points.

This is one full \(PGL_2(q)\)-orbit.  Indeed the upper-triangular subgroup fixes
\([f_\mathrm{Fr}]\): in the degree-five substitution matrix, the \(t^3\)-coefficient can occur only
in row three because \(\binom43=\binom53=0\) in characteristic two.  Conversely, for a general
matrix \(\left(\begin{smallmatrix}\alpha&\beta\\\gamma&\delta\end{smallmatrix}\right)\), the row-two
coefficient is \(\gamma(\alpha\delta+\beta\gamma)^2\), so an invertible stabilizer must have
\(\gamma=0\).  The stabilizer is therefore exactly the Borel of order \(q(q-1)\), and the orbit has
\(q+1\) points.  The frozen \(q=8\) certificate sees exactly this size-nine orbit, with stabilizer
\(56\).  The same proof gives new deep orbits at \(q=32,128,\ldots\), without an extrapolative
computation.

The orbit is more intrinsic than the chosen trinomial suggests.  A lower-unipotent transform sends
\([f_\mathrm{Fr}]\) through
\[
 [0,0,c,1,0,0]\qquad(c\in\mathbf F_q),
\]
and its missing point is \([0,0,1,0,0,0]\).  Hence the orbit is exactly the invariant projective
line
\[
 \mathcal N_3=\mathbf P\langle e_2,e_3\rangle.
\]
By the binomial-coordinate criterion of Gmainer--Havlicek, this is the \(3\)-nucleus of the
quintic normal rational curve: \(\binom42,\binom52,\binom43,\binom53\) all vanish in
characteristic two.  Thus the whole geometric nucleus line toggles arithmetically:
\[
 \mathcal N_3(\mathbf F_{2^m})\text{ is deep pointwise}
 \quad\Longleftrightarrow\quad m\text{ is odd}.
\]
Coefficientwise Frobenius fixes the representative, so this is also one
\(P\Gamma L_2(q)\)-orbit, with semilinear stabilizer of order \(m q(q-1)\).  At \(q=32\) it supplies
33 exceptional points and therefore the unconditional lower bound
\[
 \#\{\text{deep directions}\}\ge \frac{q(q+1)^2}{2}+(q+1)=17\,457.
\]

This is the first higher-redundancy nucleus family: it is geometric and persistent, but its
deepness is an arithmetic deck-transformation obstruction.  The remaining certified exceptional
orbits are not explained by this family.

## Second-order upgrade: the isolated odd-characteristic echo

The same normal form \(W_\mathrm{Fr}=\langle1,t,t^4\rangle\) explains one further certified orbit.
In odd characteristic, a monic member is totally split and squarefree exactly when there are four
distinct \(r_i\in\mathbf F_q\) with
\[
 e_1(r_1,r_2,r_3,r_4)=e_2(r_1,r_2,r_3,r_4)=0.
\]
Write
\[
\begin{aligned}
r_1&=x+y+z,&r_2&=x-y-z,\\
r_3&=-x+y-z,&r_4&=-x-y+z.
\end{aligned}
\]
The two coefficient equations reduce to the conic
\[
 x^2+y^2+z^2=0,
\]
and distinctness removes the six lines \(x=\pm y\), \(x=\pm z\), \(y=\pm z\).  Each such line
meets the conic rationally precisely when \(-2\) is a square.  Hence:

- if \(-2\) is nonsquare, every rational conic point is good;
- if \(-2\) is square, the bad union has at most twelve points, so a good point exists for
  \(q\ge13\);
- at \(q=7\), \(-2\) is nonsquare;
- at \(q=9\), the frozen field model has the explicit good root set \(\{1,2,3,6\}\); and
- at \(q=11\), \(-2=3^2\), the six line sections are pairwise disjoint on the conic, and their
  twelve points exhaust \(C(\mathbf F_{11})\).

Thus, among odd prime powers \(q\ge7\), this trinomial net is deep **only at \(q=11\)**.  It is
exactly the certified \(q=11\) representative \((0,0,0,1,0,0)\), whose orbit has size \(132\) and
stabilizer \(10\).  Combined with the characteristic-two result, the normal form has the complete
arithmetic law
\[
 W_\mathrm{Fr}\text{ is deep}
 \quad\Longleftrightarrow\quad
 q=11\ \text{ or }\ q=2^m\text{ with }m\text{ odd}
 \qquad(q\ge7).
\]

## The other q=11 orbit: a split-involution collision

The remaining representative is
\[
 f=(0,1,0,2,0,10),
\]
with orbit size \(660\) and stabilizer \(2\).  Its net has the intrinsic involution-normal form
\[
 W=\langle t^2-2,\ t(t^2-2),\ t^4+1\rangle
   =\langle u,\ tu,\ u^2+5\rangle,\qquad u=t^2-2.
\]
The stabilizer is generated by \(t\mapsto-t\).  More generally, the projective plane
\(\mathbf P\langle e_1,e_3,e_5\rangle\) is the split-involution locus, and a point
\((0,1,0,a,0,b)\) gives
\[
 W_{a,c}=\langle u,\ tu,\ u^2+c\rangle,\qquad
 u=t^2-a,\quad c=a^2-b.
\]
If \(a\) is a square, the cubic members \(u(A+Bt)\) already give a split squarefree divisor with
infinity as the fourth root.  Thus a deep interior point requires \(a\) nonsquare.  After scaling
\(t\), its two elementary parameters are
\[
 j=c/a^2,\qquad \chi(a)\in\{\pm1\}.
\]
The q=11 orbit is the class \((j,\chi(a))=(4,-1)\).

There is also a direct factorization certificate, not merely an orbit lookup.  Factor a monic
member as
\[
 (t^2+pt+r)(t^2+qt+s)
\]
and put \(R=r+a\), \(S=s+a\).  Coefficient comparison is exactly
\[
 pS+qR=0,\qquad RS+apq=c.                                    \tag{2}
\]
For \((a,c)=(2,5)\), the independent replay enumerates all solutions of (2) for which both
quadratics have two distinct rational roots.  There are fifteen ordered candidates (eight up to
swapping the factors), and every one lies on the resultant divisor: the two quadratics share a
root.  Hence none yields four distinct roots.  This explains the second q=11 orbit as a
collision-only fibre of the split-involution conic bundle.

The same interior stratum has two calibrated deep scaling classes at q=7,
\((j,\chi(a))=(2,-1),(5,-1)\), represented by
\((0,1,0,3,0,5)\) and \((0,1,0,3,0,6)\).  No interior class survives at any other odd field in the
frozen \(q\le27\) census.  This is evidence for a bounded small-field accident, not yet the uniform
point-bound theorem.

## C502 hexad verdict for redundancy six

C502 supplies no direct theorem input to C498.  Its detector needs a shared Steiner hexad with
\(A_5\) stabilizers and distinguishes the two \(PSL_2(11)\)-classes exchanged by the outer coset.
The C498 q=11 exceptional stabilizers have orders \(10\) and \(2\), not \(60\), and there is no
canonical Steiner hexad in a quartic Hankel net.

More decisively, C498 classifies under the full \(P\Gamma L_2\), so C502's inner-versus-outer bit is
already quotiented out.  On the trinomial orbit the order-ten split torus contains outer elements;
on the orbit above, \(t\mapsto-t\) has nonsquare determinant \(-1\), so its order-two stabilizer is
itself outer.  In both cases \(PSL_2(11)\) is already transitive on the full \(PGL_2(11)\)-orbit.
There is no latent two-sheet \(T_{11}\) refinement to recover.

The only portable residue is methodological: if a future **PSL-level** or coherently paired
classification produces a stabilizer \(H\le PSL_2(q)\), C502's normalizer-class lemma can test
whether the outer coset separates or fuses its two sheets.  It does not prove a split quartic,
control the trisecant surface, or identify the residual quadratic-discriminant \(C_2\); those
\(C_2\)'s have no canonical comparison and must remain separate.

## Extra-juice and Tao closeout

The cheap field extension settled the immediate C491 analogy: redundancy-five sporadics reappear
at 17 and 19, whereas redundancy-six trivial-gcd exceptional nets do not.  The clean vanishing
from 16 through 27 makes a true geometric/point-bound threshold more plausible, but gives no
license to promote 16 to a theorem.

The Tao pass found that plane-quartic line sections are the natural language and that a plain
fiber-square loses the residual quadratic splitting condition.  This turns the next step from a
generic point-count exercise into a precise irreducibility-and-degeneracy classification.  The
Vandermonde quotient further identifies the generic surface as a \((2,2,2)\) K3, giving a concrete
\(22q\) error term rather than an unspecified Lang--Weil constant.

The subsequent symmetric-cube pass exposed equation (1) and the characteristic-two
Frobenius-trinomial family.  In particular, the clean census gap \(16\le q\le27\) was not an
asymptotic disappearance: the first recurrence is forced at \(q=32\).  The generic point bound must
now be stated only after excising this orbit and any further monodromy-exceptional families.
The free upgrade is its intrinsic identification with the full \(3\)-nucleus line, including one
semilinear orbit, exact stabilizer, and a 17,457-point lower bound for the \(q=32\) deep set.
The second-order pass then found the isolated \(q=11\) echo of the same net: a six-line arrangement
exhausts a conic only there.  This replaces a raw sporadic orbit by a complete all-field arithmetic
criterion for the trinomial normal form.
The requested follow-up resolves the other q=11 orbit as the
\((j,\chi(a))=(4,-1)\) split-involution class: all fifteen rational quadratic-factor candidates
collide on the resultant divisor.  C502's hexad bit does not refine either orbit under the full
projective equivalence.
The Tao pass then re-founded the generic problem on C491: the quotient-cubic syndromes form one
line \(\ell_f\subset\mathbf P^4\), and the K3 is its family of C491 fiber-square curves.  One
\(S_3\) fibre already gives a split quartic for \(q\ge29\); only lines trapped in the classified
C491 exceptional/pointed-collision locus can remain deep.

## Mystery ledger

Settled in this chunk:

- **Do exceptional nets reappear at 17 or 19, as C491 sporadics do?** No; the exhaustive Rust
  census finds none at 17 or 19, nor at 23, 25, or 27.
- **Why did the C491 ledger predict gcd degree 3 at redundancy six?** The dimension inequality
  forces \(d\le2\); the old formula accidentally agreed only at redundancy five.
- **Is the fiber-square surface the correct quartic analogue?** No; the trisecant surface (or a
  discriminant double cover of the ordered-pair surface) is required.
- **What surface does the corrected construction produce?** After removing the three diagonal
  factors it is a symmetric \((2,2,2)\) surface, generically K3, with quadric quotient in
  \(\operatorname{Sym}^3(\mathbf P^1)\).
- **Can trivial-gcd exceptions recur above the census?** Yes.  The Frobenius-trinomial orbit has
  \(q+1\) deep directions for every \(q=2^m\) with \(m\) odd, so it recurs first at \(q=32\).
- **Is that orbit coordinate-dependent?** No.  It is exactly the invariant \(3\)-nucleus line
  \(\mathbf P\langle e_2,e_3\rangle\), one orbit under both \(PGL_2(q)\) and
  \(P\Gamma L_2(q)\).
- **Why does the same representative reappear at \(q=11\)?** In odd characteristic its split
  members are points of \(x^2+y^2+z^2=0\) off six collision lines.  At \(q=11\) those twelve bad
  points exhaust the conic; for every other odd prime power \(q\ge7\), a good point exists.
- **What is the other q=11 orbit?** It is the nonsquare split-involution class
  \((j,\chi(a))=(4,-1)\).  Every rational factorization into two split quadratics has a common
  root, so the net has no split squarefree member.
- **Does C502 supply a hidden q=11 bit?** No.  Neither exceptional stabilizer is \(A_5\), both full
  PGL orbits are already PSL-transitive, and C498's equivalence includes the outer coset.
- **What is the generic object after the Tao pass?** The line
  \(\ell_f=\mathbf P\langle(a_0,\ldots,a_4),(a_1,\ldots,a_5)\rangle\) in C491 syndrome space.
  Its pointed C491 fibre at \(r\) records quartics whose chosen fourth factor is \(t-r\).
- **What is the quotient quadric?** It is exactly the Hankel determinant
  \(L_0L_2-L_1^2\), a rank-three cone on every frozen trivial-gcd representative.

Open:

- **Intrinsic classification of the remaining exceptional orbit sets.** The characteristic-two
  3-nucleus orbit and its isolated q=11 trinomial echo are now classified by one all-field
  criterion; the other q=11 orbit and two q=7 orbits lie in the split-involution interior above.
  The JSON records complete representatives and net-member histograms for the other
  \(16/10/4/0/1\) \(PGL_2\)-orbits at \(q=7/8/9/11/13\), but no normal-form theorem yet.  Owner:
  C498, via the splitting cover over the rank-three cone.
- **Generic existence threshold after exceptional removal.** There is no uniform vanishing
  threshold before exceptional removal.  An \(S_3\) quotient fibre now has the explicit sufficient
  threshold \(q\ge29\).  Owner: C498's Fano-scheme classification of lines in the C491 exceptional
  and pointed-collision locus.
- **Persistent-stratum PGL2 splitting over extension fields.** The geometric tangent/sigma
  dichotomy is clear, but the arithmetic splitting into 4 or 3 PGL2 orbits at q=9,19,25 has not
  yet been expressed by an intrinsic square/trace invariant.  Owner: C498 exceptional-net
  classification stage if needed for the final PGammaL theorem.

## Artifacts

- `2026-07-22-c498-prs-redundancy-six.md` — this report.
- `2026-07-22-c498-prs-deep-hole-census.rs` — primary exhaustive generator (37,556 bytes).
- `2026-07-22-c498-prs-deep-hole-census.json` — canonical orbit certificate (27,077 bytes).
- `2026-07-22-c498-prs-deep-hole-replay.py` — independent Python replay (15,137 bytes).
- `2026-07-22-c498-prs-redundancy-six.sha256` — SHA-256 manifest.
