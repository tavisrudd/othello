# C498 — PRS(q−5) redundancy-six census and corrected entry geometry

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · **Status:** complete — all-field split-member
theorem, persistent-stratum \(PGL_2/P\Gamma L_2\) orbit law, and intrinsic semilinear normal forms
for every small exceptional table.

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

The census statement itself is bounded, but the polar-line argument below upgrades it to an
all-field theorem.  Exceptional nets do recur: the characteristic-two Frobenius-trinomial orbit
below gives \(q+1\) deep
directions over every \(\mathbf F_{2^m}\) with \(m\) odd, beginning again at \(q=32\).  Thus there
can be no absolute field-size threshold eliminating all trivial-gcd exceptions.  The correct
asymptotic statement must first remove explicitly classified exceptional families.

The final small exceptional normal-form theorem
(`notes/2026-07-23-c498-small-exceptional-normal-forms.md`)
compresses the residual \(18/11/4/2/1\) projective tables into
\(18/5/2/2/1\) semilinear classes.  Put \(I_f(r)\) for the number of irreducible cubic members in
the marked quotient pencil.  The complete intrinsic fingerprint is only the shared-root collision
energy \(\sum_r\binom{I_f(r)}2\) plus, in odd characteristic, the quintic root-divisor type.  Equal
fingerprints are exactly Frobenius cycles.  The identity
\(\sum_r I_f(r)=N_{1+3}(W_f)\) shows that the first moment was already the net histogram; the energy
is the genuinely new coherent statistic.  Equivalently it counts pairs of type-`1+3` net members
whose gcd has a rational linear factor, giving a polar-free definition internal to the net.
Across the all-field trivial-gcd deep set, zero energy is equivalent to the recurring
characteristic-two \(3\)-nucleus orbit; the q=11 trinomial echo instead has energy 60.

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

The variation in orbit count inside the persistent stratum is governed by the exact fifth-power
law proved below, rather than by an extra square/trace sporadic.

### All-\(q\) orbit law for the persistent stratum

The quadratic-gcd locus is a bundle over the two \(PGL_2(q)\)-orbits of binary quadratics.
Over a rational square its fibre has \(q\) points; over an irreducible quadratic it has \(q+1\).
This gives
\[
 q(q+1)+\frac{q(q-1)}2(q+1)=\frac{q(q+1)^2}{2}.
\]
The stabilizer action on these fibres gives the full orbit refinement.

For the rational-square, or tangent, fibre the Borel stabilizer is transitive unless
\(\operatorname{char}\mathbf F_q=5\).  Hence, if \(p\ne5\), there is one orbit
\[
 (|O|,|\operatorname{Stab}|)=(q(q+1),q-1).
\]
In characteristic five the degree-five binomial coefficient vanishes.  In the normal tangent
fibre \([e_4+x e_5]\), \(x=0\) is fixed and \(\mathbf F_q^\times\) is transitive, giving two orbits
\[
 (q+1,q(q-1)),\qquad(q^2-1,q).
\]
This explains the \(26+624\) split at \(q=25\).

For an irreducible quadratic, identify the \(q+1\)-point fibre with the norm-one torus \(T\).
Its nonsplit-torus stabilizer acts through
\[
 T\longrightarrow T,\qquad z\longmapsto z^5,
\]
and the stabilizer's involution sends \(z\) to \(z^{-1}\).  If \(5\nmid q+1\), this produces one
orbit
\[
 (|O|,|\operatorname{Stab}|)=\left(\frac{q(q^2-1)}2,2\right).
\]
If \(5\mid q+1\), the quotient \(T/T^5\cong C_5\) modulo inversion has the three classes
\[
 \{0\},\qquad\{\pm1\},\qquad\{\pm2\}.
\]
The corresponding orbit size/stabilizer pairs are
\[
 \left(\frac{q(q^2-1)}{10},10\right),\qquad
 \left(\frac{q(q^2-1)}5,5\right),\qquad
 \left(\frac{q(q^2-1)}5,5\right).
\]
Thus the \(q=9\) fibre sizes \(2,4,4\) and the \(q=19\) fibre sizes \(4,8,8\) are the first two
instances of one uniform rule.

Frobenius acts on \(T/T^5\) by multiplication by \(p\).  Consequently the three nonsplit
\(PGL_2\)-orbits remain three \(P\Gamma L_2\)-orbits when \(p\equiv\pm1\pmod5\), whereas the last
two fuse when \(p\equiv\pm2\pmod5\).  The tangent orbits never fuse.  The independent replay now
asserts all of these size, stabilizer, and Frobenius-cycle formulas against every frozen field.

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

## Third-order close: the characteristic-at-least-five theorem

The polar-line re-foundation gives a complete large-field theorem in characteristic at least five.
Form the \(3\times4\) quintic catalecticant
\[
 C_f=
 \begin{pmatrix}
 a_0&a_1&a_2&a_3\\
 a_1&a_2&a_3&a_4\\
 a_2&a_3&a_4&a_5
 \end{pmatrix}.
\]
The \(3\times3\) catalecticant of the quotient quartic syndrome \(b(r)\) is
\[
 C_f
 \begin{pmatrix}
 -r&0&0\\
 1&-r&0\\
 0&1&-r\\
 0&0&1
 \end{pmatrix}.
\]
By Cauchy--Binet its determinant is
\[
 D_f(r)=-\Delta_{012}r^3+\Delta_{013}r^2-\Delta_{023}r+\Delta_{123}, \tag{3}
\]
where the \(\Delta_I\) are the four maximal minors of \(C_f\).  Hence the entire polar line lies
in C491's quartic secant cubic exactly when \(\operatorname{rank}C_f\le2\).  Hankel apolarity
identifies this with C498's quadratic-gcd stratum.  For a trivial-gcd net,
\(\operatorname{rank}C_f=3\), so at most three rational \(r\)'s land on the secant cubic.  The
independent replay now checks the rank \(2/3\) dichotomy on every frozen deep representative.

Assume \(p\ge5\).  The remaining geometric cyclic locus from C491 is the projected Veronese surface
\[
 \mathcal V=\{[q(s,t)^2]:q\text{ a binary quadratic}\}\subset\mathbf P^4.
\]
Because \(2\ne0\), this is an embedded degree-four surface and contains no projective line.
Therefore \(\ell_f\) meets it in length at most four.  Finally, the pointed gcd-one failure
``the quotient pencil has common root \(r\)'' says exactly that every member of \(W\) vanishing at
\(r\) vanishes twice there.  These are the ramification points of the basepoint-free
\(g^2_4\) defined by \(W\); its Wronskian has degree
\[
 (2+1)(4+2(0-1))=6.
\]
Thus at most six \(r\)'s are pointed ramification collisions.

For every other \(r\), C491's gcd-one graph argument or \(S_3\) fiber-square argument gives a split
cubic avoiding \(r\).  In the \(S_3\) case the punctured estimate is the one above:
\(q-2\sqrt q>18\), valid for \(q\ge29\).  The total exceptional budget on the polar line is
\[
 3+4+6=13<q+1.
\]
Therefore:

> **Split-member theorem, \(p\ge5\).**
> If \(q\ge29\) has characteristic at least five, every trivial-gcd Hankel net of binary quartics
> contains a totally split squarefree member.

Together with the exhaustive census below 29, this closes the large-field orbit inventory in
characteristic at least five.  Trivial-gcd exceptional orbits occur only as
\[
 18,\ 2,\ 1
\quad\text{orbits at}\quad q=7,11,13,
\]
and never for \(q\ge17\).  Consequently, for every characteristic-at-least-five prime power
\(q\ge17\), the deep set is exactly the persistent quadratic-gcd stratum and has
\[
 \frac{q(q+1)^2}{2}
\]
points.  The remaining work at \(q=7,13\) is intrinsic normal-form interpretation, not
large-field existence.

## Fourth-order close: characteristic three and characteristic two

The same polar-line count closes the modular characteristics after identifying C491's cyclic
closures.

### Characteristic three

C491's wild family is the union of the lines joining its fixed nucleus \(n=e_2\) to the quartic
normal rational curve in \(\mathbf P^4\).  Its geometric closure is therefore the degree-four cone
\[
 \mathcal W_3=\operatorname{Join}(n,C_4).
\]
The only lines on this cone are its rulings.  No ruling is a first-polar line: by equivariance it
suffices to test \(\mathbf P\langle e_2,e_4\rangle\), but requiring both consecutive Hankel rows
\((a_0,\ldots,a_4)\) and \((a_1,\ldots,a_5)\) to lie in that span forces all \(a_i=0\).
Hence a genuine polar line meets \(\mathcal W_3\) in length at most four.

The secant and pointed-ramification budgets remain \(3\) and \(6\).  The latter does not require a
classical Wronskian: a nonzero \(2\times2\) first-derivative minor has degree at most six.  It cannot
vanish identically here, since a three-dimensional quartic Hankel net cannot consist entirely of
polynomials in \(t^3\).  Thus the same \(3+4+6\) argument proves that no characteristic-three
trivial-gcd exception exists for \(q\ge29\).  The census at \(q=27\) closes the only gap before the
next characteristic-three field \(q=81\): the four q=9 orbits are the complete exceptional table.

### Characteristic two

The tame cyclic surface degenerates in a useful, completely explicit way.  Acting on the C491
point \(e_2\) by
\(g=\left(\begin{smallmatrix}\alpha&\beta\\\gamma&\delta\end{smallmatrix}\right)\) gives, up to a
nonzero scalar,
\[
 g\cdot e_2=
 [\,0:\delta\gamma:\alpha\delta+\beta\gamma:\alpha\beta:0\,].
\]
Its closure is the invariant plane
\[
 \Pi_{\rm cyc}=\mathbf P\langle e_1,e_2,e_3\rangle.
\]
A polar line lies in this plane exactly when both consecutive Hankel rows do.  The overlap equations
then force
\[
 f\in\mathbf P\langle e_2,e_3\rangle=\mathcal N_3.
\]
Thus the \(3\)-nucleus line already found is the **only** polar-line component contained in the
characteristic-two cyclic locus.  Every other polar line meets that plane in at most one point.

The pointed-ramification budget is again at most six.  An identically zero differential would force
\(W=\langle1,t^2,t^4\rangle\), but no nonzero quintic has consecutive Hankel rows whose common
kernel is that space; the overlap equations force all six coefficients to vanish.  Therefore, off
\(\mathcal N_3\), the total potentially bad budget is only
\[
 3+1+6=10.
\]
For \(q\ge32\), the punctured C491 bound supplies a split member unless the net is on
\(\mathcal N_3\).  The arithmetic calculation above says that this line is deep exactly for
\(q=2^m\) with \(m\) odd.

### All-field inventory

Combining the theorem with the frozen census gives the complete trivial-gcd orbit inventory for
every prime power \(q\ge7\):
\[
\begin{array}{c|ccccc}
q&7&8&9&11&13\\ \hline
\#PGL_2\text{-orbits}&18&11&4&2&1,
\end{array}
\]
plus one \(q+1\)-point nucleus orbit for every \(q=2^m\) with odd \(m\ge5\), and no other
trivial-gcd orbit.  In particular:

- characteristic at least five has no exception for \(q\ge17\);
- characteristic three has no exception for \(q\ge27\);
- characteristic two has no exception for even \(m\), and exactly the nucleus orbit for odd
  \(m\ge5\).

The all-field **existence and orbit-count theorem is closed**.  The dated normal-form companion now
also closes the small certified tables at q=7,8,9,13 and their final \(P\Gamma L_2\) packaging.

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

## Transfer to other Deep Hole strata

The most reusable object is not the quartic K3 by itself but the **polar recursion**.  For
redundancy \(r\), write a syndrome as a binary \((r-1)\)-ic
\(f=(a_0,\ldots,a_{r-1})\).  Choosing a prospective factor \(t-r_0\) contracts it to
\[
 b(r_0)=(a_1-r_0a_0,\ldots,a_{r-1}-r_0a_{r-2}),
\]
a redundancy-\((r-1)\) syndrome.  As \(r_0\) varies these contractions form the first-polar line
\[
 \ell_f=\mathbf P\langle(a_0,\ldots,a_{r-2}),
                         (a_1,\ldots,a_{r-1})\rangle.
\]
A split kernel member downstairs lifts to one upstairs unless it contains the chosen factor.
Thus each redundancy is a pointed line-incidence problem in the preceding redundancy's syndrome
space.  Iterated contractions give the corresponding catalecticant polar flag.

This has four immediate uses elsewhere in the Deep Hole problem.

1. **Persistent strata become stabilizer quotients.**  At redundancy \(r\), the nonsplit torus
   acts on the relevant fibre by the \((r-1)\)-st power, so its orbit invariant is
   \[
   T/T^{\,r-1}\quad\text{modulo inversion and Frobenius}.
   \]
   Modular tangent splitting occurs when \(p\mid r-1\).  The fifth-power and characteristic-five
   laws above are the \(r=6\) instance.
2. **Large-field existence becomes a low-degree intersection budget.**  Pulling the preceding
   redundancy's secant, cyclic, wild, and nucleus strata back to \(\ell_f\) gives bounded-degree
   equations.  Unless the whole polar line is contained, only finitely many factors are bad.
   Contained lines are detected by catalecticant rank and consecutive-row overlap.
3. **Infinite modular families separate from small-field accidents.**  A polar line contained in
   a lower exceptional component produces a genuine family, often predicted by Lucas vanishing
   of binomial coefficients.  Without containment, exceptional behaviour can only occur when the
   finitely many bad divisors cover all \(q+1\) rational points, as at \(q=11\).
4. **Semilinear packaging is systematic.**  Once the stabilizer quotient is cyclic, Frobenius is
   multiplication by \(p\); no new extension-field square/trace guess is needed.

### Which redundancy is cheapest next?

Among genuinely new cases, **redundancy seven is now the clear next target**.  A sextic syndrome
has
\[
 \ell_f=\mathbf P\langle(a_0,\ldots,a_5),(a_1,\ldots,a_6)\rangle
 \subset\mathbf P^5,
\]
so choosing one factor reduces its quintic-kernel problem directly to C498's classified
quartic-net problem.  The high-\(q\) work is finite:

- classify polar lines contained in the C498 quadratic-gcd variety or, in characteristic two,
  its \(3\)-nucleus line;
- bound all other intersections by catalecticant degrees; and
- control the pointed-collision divisor excluding a lifted quartic that already contains the
  chosen root.

This is cheaper than C498's original K3 discovery because the downstairs exceptional set and its
all-field arithmetic are known.  It is not free: C498 classifies whether a split quartic exists,
not how many avoid a prescribed root, so the pointed refinement is the real new lemma.  Exhaustive
small-field search in \(\mathbf P^6\) is also substantially more expensive and should follow orbit
reduction.

Redundancy four is cheaper only because its tangent/secant classification is already the
persistent base used here; redundancy five is C491 and closed.  Redundancy eight and above should
wait for the redundancy-seven exceptional locus.  The economical programme is
\[
 \boxed{\text{finish C498 small normal forms}\ \longrightarrow\
        \text{pointed C498 lemma}\ \longrightarrow\ \text{redundancy seven}.}
\]
This recursion concerns one-column PRS deep holes.  It does not by itself recover the
simultaneous-extension data needed for higher-order MDS or list-decoding claims.

### Significance calibration

On the current literature audit this is a substantial specialist advance: the scalar covering
radius in the usual large-\(q\) range is not new, but the all-field deep-syndrome strata, their
\(PGL_2/P\Gamma L_2\) orbit law, and the exceptional-net theorem are not pre-empted by any located
source.  The characteristic-two nucleus recurrence and the fifth-power stabilizer quotient are
conceptual additions rather than census output.

The result should not yet be advertised as resolving the general Reed--Solomon Deep Hole problem.
It handles one next fixed redundancy, and its small exceptional tables still need intrinsic
compression.  As a standalone paper it is plausibly a strong finite-geometry/coding-theory result.
Its broader significance depends on portability: a redundancy-seven theorem obtained by the same
polar recursion would turn C491/C498 from two fixed-case classifications into evidence for a
general inductive method.  That is the point at which the work would matter well beyond the
immediate PRS\((q-5)\) classification.

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
The third-order pass computes that trapping budget exactly in characteristic at least five:
the secant cubic contributes at most three points, the tame cyclic projected Veronese at most four,
and pointed ramification at most six.  This proves the \(q\ge29\) split-member theorem and, with
the census, closes all characteristic-at-least-five fields.
The fourth-order pass closes characteristics three and two.  The wild characteristic-three locus
is a degree-four nucleus cone with no polar ruling; the characteristic-two cyclic locus is a plane
whose unique polar-line component is exactly \(\mathcal N_3\).  This yields the complete all-field
orbit inventory above.
The all-high-\(q\) pass then removes the last persistent-stratum ambiguity.  Tangent fibres are
transitive except for the fixed/nonzero split in characteristic five; sigma fibres are norm-one
tori modulo fifth powers, inversion, and Frobenius.  This proves the exact \(PGL_2/P\Gamma L_2\)
orbit law in every field and exposes its redundancy-\(r\) replacement \(T/T^{r-1}\).  The same
polar-line mechanism makes redundancy seven the cheapest genuinely new case, with a pointed C498
lifting lemma as its precise entry gate.

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
- **Does the generic theorem close in ordinary characteristic?** Yes.  For \(p\ge5\), the exact
  exceptional budget is \(3+4+6=13\), while the punctured \(S_3\) bound applies at \(q\ge29\).
  Together with the census, no trivial-gcd exception exists at any \(q\ge17\).
- **What happens in characteristic three?** The wild locus is a degree-four nucleus cone, but none
  of its rulings is a polar line.  The q=9 table is complete and no exception survives from q=27.
- **What happens in characteristic two?** The cyclic locus is the plane
  \(\mathbf P\langle e_1,e_2,e_3\rangle\); its unique polar-line component is the \(3\)-nucleus
  \(\mathbf P\langle e_2,e_3\rangle\), deep exactly in odd extension degree.
- **What is the quotient quadric?** It is exactly the Hankel determinant
  \(L_0L_2-L_1^2\), a rank-three cone on every frozen trivial-gcd representative.
- **Why does the persistent stratum split at q=9,19,25?**  The q=9 and q=19 sigma fibres are
  \(T/T^5\) modulo inversion, giving fibre sizes \(1:2:2\); q=25 is instead the
  characteristic-five tangent fixed/nonzero split.  Frobenius acts on \(T/T^5\) by multiplication
  by \(p\), which also gives the exact semilinear fusion.
- **Which new redundancy is cheapest?** Redundancy seven: its first-polar line lives in C498
  syndrome space.  The new gate is the pointed C498 lemma ensuring that a downstairs split
  quartic can be chosen not to contain the selected lifting root.

Final close:

- **Intrinsic classification of the remaining exceptional orbit sets.** Settled by the pointed
  polar-profile fingerprint in the dated normal-form companion.  It separates all prime-field
  projective classes and its only extension-field collisions are exactly Frobenius cycles, giving
  \(18/5/2/2/1\) semilinear normal forms at q=7/8/9/11/13.
- **Generic existence threshold after exceptional removal.** Settled with the stated modular
  exception: there is no uniform vanishing threshold because the characteristic-two \(3\)-nucleus
  line recurs, and off that classified line the all-field existence theorem is complete.
- **Remaining mystery.** None.  A smaller classical-invariant presentation would be optional
  repackaging, not an unclassified geometric or arithmetic stratum.

## Artifacts

- `2026-07-22-c498-prs-redundancy-six.md` — this report.
- `2026-07-22-c498-prs-deep-hole-census.rs` — primary exhaustive generator (37,556 bytes).
- `2026-07-22-c498-prs-deep-hole-census.json` — canonical orbit certificate (27,077 bytes).
- `2026-07-22-c498-prs-deep-hole-replay.py` — independent Python replay (16,760 bytes).
- `2026-07-22-c498-prs-redundancy-six.sha256` — SHA-256 manifest.
- `2026-07-23-c498-small-exceptional-normal-forms.md` — intrinsic semilinear classification.
- `2026-07-23-c498-small-exceptional-normal-forms.py` — deterministic generator/checker.
- `2026-07-23-c498-small-exceptional-normal-forms.json` — canonical normal-form certificate.
- `2026-07-23-c498-small-exceptional-normal-forms.sha256` — SHA-256 manifest.
