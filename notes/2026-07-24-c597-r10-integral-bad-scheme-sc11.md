# C597 — R10 integral bad scheme and \(\mathrm{SC}(11)\)

**Lane:** `reed-solomon`
**Date:** 2026-07-24
**Status:** complete after the catalecticant-rowspace transport repair;
\(\mathrm{SC}(j)\) holds for every \(j\geq6\)

## Result

The integral ordered-root incidence and its bottom-syndrome elimination are
correct.  On the rank-two open, the noncollision Plücker ideal \(J\) and
C595's cyclic syndrome ideal \(V\) satisfy
\[
 J\subset V,\qquad 3DV\subset J,\qquad DV\not\subset J.
\]
Hence
\[
 (J:D^\infty)=(V:D^\infty)\quad\text{over }\mathbf Z[1/3],
\]
and the literal equality with \(V\) holds over \(\mathbf Z[1/6]\).
The integer \(3\) is minimal for this elimination presentation.  It is not
claimed to be an intrinsic invariant: another model could conceivably be
denominator-free.

The original report made an invalid transport step.  Substituting the
elementary symmetric functions of retained markers into these identities
preserves them on syndrome--marker space, but does not eliminate the marker
variables and therefore says nothing by itself about the upper syndrome
\(f\).  The same substitution at redundancies six and seven cannot recover
the known components \(N_3\) and \([e_3]\), which is a decisive regression
failure of that argument.  Section 6 supplies the missing elimination:
the closure of all bottom contractions is the projectivized row space of
the consecutive catalecticant.  Its containment in the bottom bad union
forces containment in one irreducible component, and each such component
is handled explicitly.  This proves \(\mathrm{SC}(j)\) for every
\(j\geq6\), including \(\mathrm{SC}(11)\).

## 1. Integral ordered-root incidence

Let \(E\) be a rank-two bundle and let
\[
 \mathbf G=\operatorname{Gr}(2,\Gamma^3E)
\]
over \(\operatorname{Spec}\mathbf Z\).  Write
\[
(z_0,z_1,z_2,z_3,z_4,z_5)
=(p_{01},p_{02},p_{03},p_{12},p_{13},p_{23})
\]
for Plücker coordinates, with relation
\[
                  z_0z_5-z_1z_4+z_2z_3=0.                  \tag{3}
\]
For a cubic pencil \(\langle p_0,p_1\rangle\), the alternating evaluation
determinant
\[
 p_0(t)p_1(s)-p_1(t)p_0(s)
\]
is divisible over \(\mathbf Z\) by the diagonal bracket \(s-t\).
The quotient is the symmetric bidegree-\((2,2)\) form
\[
\begin{aligned}
G_z(t,s)={}&z_0+z_1(t+s)+z_2(t^2+ts+s^2)+z_3ts\\
            &+z_4ts(t+s)+z_5t^2s^2.                        \tag{4}
\end{aligned}
\]
Homogenizing (4) on
\(\mathbf P(E^\vee)\times\mathbf P(E^\vee)\) gives a global section.
Thus (4), its diagonal, and the incidence of the pencil line with the
twisted cubic form one finite-type integral model.  No choice of pencil
basis, affine root chart, or marker order enters the zero scheme.

The collision subscheme is retained as
\[
\mathbf P(W)\times_{\mathbf P(\Gamma^3E)}C_3.               \tag{5}
\]
C535 proves that (4)--(5) commute with arbitrary base change, while
removing (5) commutes only with flat or Cartier-preserving base change.
Accordingly, C597 does not assert a false globally base-change-compatible
colon ideal.  It uses the integral incidence first, then residualizes on
\(\mathbf Z[1/6]\) and treats the two exceptional fibres separately.

## 2. Exhaustive factorization lemma

Work over an algebraically closed field.  If the residual moving part of
\(G_z\) is reducible, its factors have either bidegrees
\((1,1)+(1,1)\) or a vertical/horizontal bidegree.  The latter is a
fixed-root or collision component and belongs to (5).

Let \(\tau(t,s)=(s,t)\).  Unique factorization and
\(\tau(G_z)=G_z\) give the symmetric and exchanged cases below, together
with one anti-invariant diagonal case.

### Anti-invariant diagonal factor

If \(\tau L=-L\), then \(L\) is proportional to the homogenized diagonal
bracket \(s-t\).  The product of the two anti-invariant factors has
\[
 (z_0,\ldots,z_5)=(0,0,-\mu,3\mu,0,0),
\]
whose Plücker value is \(-3\mu^2\).  It therefore survives only in
characteristic three, where it is part of the diagonal collision scheme
retained in (5).  It contributes no new noncollision branch.

### Symmetric factors

Both factors are individually fixed by \(\tau\):
\[
L=a+b(t+s)+cts,\qquad M=A+B(t+s)+Cts.
\]
Their product has
\[
\begin{aligned}
(z_0,\ldots,z_5)=(&aA,\ aB+bA,\ bB,\ aC+cA+bB,\\
                  &bC+cB,\ cC).
\end{aligned}
\]
Substitution into (3) gives the integral identity
\[
 z_0z_5-z_1z_4+z_2z_3
       =(ac-b^2)(AC-B^2).                                  \tag{6}
\]
Hence at least one symmetric factor has rank one.  Over the algebraic
closure it is \(\ell(t)\ell(s)\), so it is a vertical/horizontal
collision factor.  This branch contributes no new contained component.

### Exchanged factors

The factors are exchanged by \(\tau\):
\[
L=a+bt+cs+dts,\qquad \tau L=a+ct+bs+dts.
\]
Now
\[
\begin{aligned}
(z_0,\ldots,z_5)=(&a^2,\ a(b+c),\ bc,\ b^2+c^2+2ad-bc,\\
                  &d(b+c),\ d^2),
\end{aligned}
\]
and (3) becomes
\[
 z_0z_5-z_1z_4+z_2z_3
 =(ad-bc)(ad-b^2+bc-c^2).                                  \tag{7}
\]
The first factor in (7) makes \(L\) rank one and again gives a
vertical/horizontal collision.  The second factor is the cyclic branch.
Equations (6)--(7) are exhaustive by unique factorization; no third
non-cyclic factorization type exists.

The same argument includes repeated factors.  An irreducible singular
moving curve remains geometrically integral and is handled by the existing
finite singular deletion scheme; singularity alone is not promoted to a
contained component.

## 3. Integral bridge to the syndrome cyclic ideal

For a bottom syndrome \(c=(c_0,\ldots,c_4)\), let
\[
H_c=\begin{pmatrix}
c_0&c_1&c_2&c_3\\
c_1&c_2&c_3&c_4
\end{pmatrix}.
\]
On its rank-two open, the kernel line has Plücker coordinates
\[
\begin{aligned}
z_0&=c_2c_4-c_3^2,&
z_1&=-(c_1c_4-c_2c_3),&
z_2&=c_1c_3-c_2^2,\\
z_3&=c_0c_4-c_1c_3,&
z_4&=-(c_0c_3-c_1c_2),&
z_5&=c_0c_2-c_1^2.                                         \tag{8}
\end{aligned}
\]

Eliminating \(a,b,c,d\) from the noncollision factor of (7) gives the
six integral Plücker equations
\[
\begin{aligned}
K_1&=3z_4^2-9z_2z_5-z_3z_5,&
K_2&=z_3z_4-3z_1z_5,\\
K_3&=z_3^2-9z_0z_5,&
K_4&=z_2z_3-z_1z_4+z_0z_5,\\
K_5&=z_1z_3-3z_0z_4,&
K_6&=3z_1^2-9z_0z_2-z_0z_3.                               \tag{9}
\end{aligned}
\]
Let
\[
                         J=(K_1(z(c)),\ldots,K_6(z(c)))
\]
be their pullback under (8).  C595's primitive syndrome cyclic ideal
\(V=(V_1,\ldots,V_7)\) is
\[
\begin{aligned}
V_1={}&2c_3^3-3c_2c_3c_4+c_1c_4^2,\\
V_2={}&6c_2c_3^2-9c_2^2c_4+2c_1c_3c_4+c_0c_4^2,\\
V_3={}&2c_1c_3^2-3c_1c_2c_4+c_0c_3c_4,\\
V_4={}&c_0c_3^2-c_1^2c_4,\\
V_5={}&2c_1^2c_3-3c_0c_2c_3+c_0c_1c_4,\\
V_6={}&6c_1^2c_2-9c_0c_2^2+2c_0c_1c_3+c_0^2c_4,\\
V_7={}&2c_1^3-3c_0c_1c_2+c_0^2c_3.
\end{aligned}                                               \tag{9a}
\]
For any homogeneous carrier ideal \(I\), its **coherent-Fano ideal**
is obtained by substituting the universal consecutive polar line into
every generator of \(I\), expanding in the two line parameters, and
setting every coefficient to zero.  It represents upper syndromes whose
entire consecutive polar line lies in the carrier, including the
integrability constraint on the two line generators.

Put
\[
 D=\det\begin{pmatrix}
c_0&c_1&c_2\\c_1&c_2&c_3\\c_2&c_3&c_4
\end{pmatrix}.                                              \tag{10}
\]

The first half of the bridge is integral:
\[
\begin{aligned}
K_1&=3c_0V_4+4c_1V_5-c_2V_6,\\
K_2&=c_1V_4+c_2V_5-c_4V_7,\\
K_3&=-4c_1V_3+9c_2V_4+c_4V_6,\\
K_4&=0,\\
K_5&=c_2V_3-3c_3V_4-c_4V_5,\\
K_6&=4c_1V_1-c_2V_2+c_4V_4.                                \tag{11}
\end{aligned}
\]
Thus \(J\subset V\) over \(\mathbf Z\).

For the converse, the certificate contains a \(6\times7\) polynomial
matrix \(B\) giving the compact explicit identity
\[
                     3D(V_1,\ldots,V_7)
                    =(K_1,\ldots,K_6)B.                    \tag{12}
\]
Explicitly,
\[
\scriptsize
\begin{pmatrix}
0&c_4^2&0&0&c_1c_4&3c_2^2&c_1c_2\\
c_4^2&0&c_2c_4&c_2c_3-c_1c_4&
 -3c_2^2+5c_1c_3+c_0c_4&6c_1c_2&2c_1^2+c_0c_2\\
c_3c_4&-2c_3^2&c_1c_4&0&c_0c_3&0&c_0c_1\\
0&0&0&0&0&0&0\\
2c_3^2+c_2c_4&-8c_1c_4&2c_1c_3+c_0c_4&
 -c_1c_2+c_0c_3&c_1^2&-6c_0c_1&c_0^2\\
c_2c_3&3c_2^2-2c_1c_3-4c_0c_4&c_1c_2&0&0&-3c_0^2&0
\end{pmatrix}.
\]
An independent integer-coefficient standard-basis calculation confirms
\[
                         3DV\subset J,\qquad DV\not\subset J. \tag{12a}
\]
The factor \(3\) is necessary even set-theoretically: over \(\mathbf F_3\),
the point
\[
                         (c_0,\ldots,c_4)=(1,0,0,1,0)
\]
annihilates \(J\), has \(D=2\), and does not annihilate \(V\).  Thus \(3\)
is the minimal cleared-denominator integer for this elimination:
\(\{n\in\mathbf Z:nDV\subset J\}\) is an ideal containing \(3\) but not
\(1\), hence equals \(3\mathbf Z\).  This is not asserted to be intrinsic
to the geometric functor; a different presentation might avoid
denominators.  The projected
schemes defined by \(J\) and \(V\) are therefore equal on the
\(D\)-open over \(\mathbf Z[1/3]\), or equivalently
\[
                (J:D^\infty)=(V:D^\infty)
                \quad\text{over }\mathbf Z[1/3].
\]
The characteristic-two specialization of \(V\) itself retains the
\(D\)-supported component \(Q_2\) displayed below, so
\((V:D^\infty)\ne V\) in that fibre.  This is exactly why \(2\) must be
inverted before replacing the right-hand side by \(V\).  Over
\(\mathbf Z[1/6]\), diagonal rescaling identifies (9a) with the
homogeneous kernel of the projected-Veronese parametrization
\[
 [u:v:w]\longmapsto[u^2:2uv:v^2+2uw:2vw:w^2].
\]
That kernel is prime.  Moreover the image point
\((1,0,2,0,1)\) has \(D=-6\), a unit on this base, so
\(D\notin V\) and \(V:D^\infty=V\).  Consequently
\[
                  (J:D^\infty)=V
                  \quad\text{over }\mathbf Z[1/6].          \tag{13}
\]
This is the missing saturation equivalence.  Scheme decomposition over
\(\mathbf Q\) independently returns exactly two minimal components:
\(V\), and a second component on which \(D=0\).

## 4. Vertical fibres

### Characteristic two

The pullback of (9) has exactly two minimal components:
\[
\begin{aligned}
\Pi_2&=(c_0,c_4),\\
Q_2&=(c_2c_3+c_1c_4,\ c_2^2+c_0c_4,\
      c_1c_2+c_0c_3,\ c_0c_3^2+c_1^2c_4).
\end{aligned}                                               \tag{14}
\]
The determinant \(D\) vanishes on \(Q_2\), so it is persistent.  The plane
\(\Pi_2\) is the true binary cyclic plane.  C595 proves that its coherent
Fano pullback is the declared nucleus plus a persistent vertical
component.

The Plücker specialization alone does not represent every inseparable
binary degeneration.  The **ordered-Hessian chart** attaches to an ordered
basis \(p_0,p_1\) of the cubic pencil the bidegree-\((2,2)\) equation
\[
 u^2\operatorname{Hess}^{\rm div}(p_0)
 +uv\,\operatorname{PolHess}^{\rm div}(p_0,p_1)
 +v^2\operatorname{Hess}^{\rm div}(p_1)=0
\]
on pencil-parameter space times Hessian-root space.  It retains the
parameter order before quotienting by a basis change and therefore sees
inseparable degenerations lost by the primitive Plücker specialization.
Its tangent quadric has two conic families of generator lines.  In
Plücker coordinates these **tangent-quadric rulings** are
\[
\begin{aligned}
z_1=z_4=0,\quad z_2=z_3,\quad z_0z_5=z_2^2,\\
z_0=z_5=0,\quad z_2=z_3,\quad z_1z_4=z_2^2.
\end{aligned}
\]
C525 proves that the first ruling is the square-quadratic boundary of the
persistent Veronese, while the second is complementary.  Under the
consecutive-Hankel constraint the Veronese pulls back exactly to the
persistent/Lucas union; the complementary ruling identities force all
five contraction forms to be proportional and hence rank at most one;
the remaining vertical factors are the collision Chow resultant (5).
Thus no binary component remains.

### Characteristic three

Primitive specialization of (9) is nonflat and is not used as the wild
model.  The actual wild closure is the cone
\(\operatorname{Join}(e_2,C_4)\).  A line not through its vertex would
project to a line in \(C_4\), impossible because the quartic normal
rational curve contains no line; hence every contained line is a ruling
\(\langle e_2,\nu_4(t)\rangle\).

The ruling calculation is explicit.  By \(\operatorname{PGL}_2\)
equivariance move it to \(\langle e_2,e_4\rangle\).  If the two
consecutive Hankel rows lie on this ruling, then
\[
(a_0,\ldots,a_4),(a_1,\ldots,a_5)\in\langle e_2,e_4\rangle.
\]
The first membership gives \(a_0=a_1=a_3=0\), and the second gives
\(a_1=a_2=a_4=0\); the overlap leaves only \(a_5\).  Thus
\(f=\mu e_5\).  Undoing the frame gives
\(f=\mu\nu_5(t)\), including the endpoint at infinity, which is the
rank-one/fixed-factor boundary.  Applying the same two-row computation
to every adjacent pair gives the identical conclusion at every upper
level.  No ternary component remains.

Every characteristic other than three lies on the bridge's
\(\mathbf Z[1/3]\) locus.  Characteristic two is nevertheless retained as
a separate fibre because the ordered-Hessian chart and C595's
coherent-Fano certificate introduce their own inseparable and
denominator-two phenomena.  Hence the combined formal coefficient
identities still use \(6\), although the Grassmannian bridge itself needs
only \(3\).

## 5. R10 chart and saturation ledger

For an R10 syndrome, contract by five ordered markers to obtain the bottom
syndrome \(c\).  The complete model uses the following pieces.

| Piece | Integral equation or functor | Saturation meaning |
|---|---|---|
| contraction rank | minors of the consecutive contraction matrix | noninjective/rank-one boundary |
| lower persistence | \(D=0\) and its iterated Hankel pullbacks | persistent catalecticant branch |
| cubic pencil | kernel bundle of \(H_c\) on its rank-two open | defines (8) without a basis |
| ordered roots | the homogeneous form (4) | identity-Frobenius splitting cover |
| collision | fibre product (5) | remove only after retaining the closed incidence |
| noncollision factorization | (6)--(9) | after \(D\)-saturation, exactly \(V\) |
| binary vertical fibre | (14) plus C525's ordered Hessian | persistent/Lucas or rank one |
| ternary vertical fibre | wild join/ruling incidence | rank/fixed-factor |
| fixed old marker | evaluation-row minors | exact common-factor boundary |
| repeated markers | pairwise diagonal brackets | forbidden pointed divisors |

All marker contractions are homogeneous, commute, and are symmetric after
passing to the elementary coefficients of their product.  Therefore the
affine marker charts glue to the ordered projective marker space used by
C512, including infinity.  Equations (4)--(5) are global there.  The only
operation that does not commute with the two nonflat vertical base changes
is residual collision removal; the table treats those fibres before that
operation, exactly as C535 requires.

Fixed-factor minors cannot vanish on a whole new component outside the
declared gcd/rank branch.  If they vanished identically along the moving
marker, every geometric member of the lower system would vanish at the
fixed marker, so that marker would divide the entire system.  The
collision divisor is nonzero outside the two inseparable cases
\((j,p)=(5,3),(6,2)\), already routed to the vertical models above.

This proves that the ledger is complete: every failure of the lower
geometrically integral moving cover is rank/persistent, modular,
fixed-factor/collision, or cyclic/wild.

## 6. Catalecticant-rowspace transport

Let \(m=j-5\) markers be retained and write
\[
 \operatorname{Cat}_{m,4}(f)=
 \begin{pmatrix}
 a_0&a_1&a_2&a_3&a_4\\
 a_1&a_2&a_3&a_4&a_5\\
 \vdots&\vdots&\vdots&\vdots&\vdots\\
 a_m&a_{m+1}&a_{m+2}&a_{m+3}&a_{m+4}
 \end{pmatrix}.                                             \tag{15}
\]
If the marker product has coefficient vector
\(h=(h_0,\ldots,h_m)\), its bottom syndrome is
\[
                         c(h)=h\,\operatorname{Cat}_{m,4}(f). \tag{16}
\]
Over an algebraic closure, squarefree products of \(m\) linear forms are
a dense open subset of \(\mathbf P(\operatorname{Sym}^mE^\vee)\).
The contraction map in (16) is linear and homogeneous; after deleting
its projective kernel, the scheme-theoretic closure of its image is
therefore
\[
 \overline{\{c(h):h\text{ is a product of distinct markers}\}}
 =\mathbf P\!\left(
    \operatorname{rowspace}\operatorname{Cat}_{m,4}(f)\right). \tag{17}
\]
This argument is homogeneous, so markers at infinity are included.
Marker diagonals were removed only to select the dense open and reappear
in its closure; no affine boundary is lost.

Suppose the recursively pointed bottom object is contained in the
level-five bad union.  The projective space in (17) is irreducible, while
that bad union has the finite component ledger of Sections 2--5.  Hence
\[
\mathbf P(\operatorname{rowspace}\operatorname{Cat}_{m,4}(f))
   \subset C                                                   \tag{18}
\]
for one irreducible component \(C\).  We now check every possibility.

1. If \(C\) is the rank-two Hankel component, apply C536 inductively on
   \(m\).  For every first contraction \(b=\iota_\lambda f\), the
   \((m-1)\)-marker row space of \(b\) is contained in the same component.
   The induction hypothesis puts every \(b\) in the upper rank-two scheme,
   and C536's integral one-step identity
   \(\operatorname{CFano}_n(\Sigma_{2,n-1})=\Sigma_{2,n}\)
   then puts \(f\) in the persistent scheme.  The identical induction
   with C536's consecutive-support formula gives precisely the Lucas
   modular pullbacks and no third component.

2. Away from characteristics two and three, \(C=V\) is the projected
   Veronese surface and contains no projective line.  Thus (18) forces
   the row space of (15) to have dimension one.  All \(2\times2\) minors
   of the consecutive catalecticant vanish, so \(f\) is on the rank-one
   normal rational curve and is already in the rank boundary.

3. In characteristic three, \(C=\operatorname{Join}(e_2,C_4)\).
   Any positive-dimensional linear subspace of this cone is one of its
   rulings.  Move the ruling to \(\langle e_2,e_4\rangle\).  Applying the
   two-row calculation of Section 4 to every adjacent pair of rows in
   (15) successively kills \(a_0,\ldots,a_{m+3}\), leaving only
   \(a_{m+4}\).  Undoing the frame gives
   \(f=\mu\nu_{m+4}(t)\), again the rank-one/fixed-factor boundary.

4. In characteristic two, containment in
   \(\Pi_{\rm cyc}=(c_0,c_4)\) says that the first and last columns of
   (15) vanish:
   \[
    a_0=\cdots=a_m=0,\qquad a_4=\cdots=a_{m+4}=0.             \tag{19}
   \]
   For \(m=1\) and \(m=2\), these are exactly the known \(N_3\) and
   \([e_3]\) pullbacks.  For \(m\geq3\), the two blocks cover every
   coefficient, so no projective point remains.  Consequently the
   cyclic-plane descendant
   \[
          \mathcal M_r^{\rm cyc,2}=\varnothing
          \quad\text{for every }r\geq8.                     \tag{20}
   \]
   The exact \(\mathbf F_4\) affine counts \(15,3,0,0\) at
   \(j=6,7,8,9\) independently replay (19).  This does not erase fresh
   higher Lucas carriers; in particular the degree-nine carrier
   \(\mathbf P\langle e_2,\ldots,e_7\rangle\) remains nonempty.

5. The ordered-Hessian components add nothing: C525's two consecutive
   quadratic identities make the complementary ruling rank one, while
   its Veronese ruling is exactly the persistent/Lucas pullback already
   handled in item 1.  Vertical and horizontal factors are respectively
   collision and fixed-factor components, already handled in Section 5.

Thus every contained component is persistent, modular, collision, or rank
boundary.  This proves \(\mathrm{SC}(j)\) for every \(j\geq6\).  Combining
it with the printed transverse theorem makes the bound
\[
 q\geq6r-15+\left\lfloor2\sqrt{6r-17}\right\rfloor
\]
unconditional for split-free syndromes; the separate covering-radius
premise is still required before calling them code deep holes.

## 7. Evidence and replay

The C597 evidence bundle is:

- `notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.py`;
- `notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.sing`;
- `notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.json`;
- `notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.sha256`.

Replay from the repository root:

```sh
python3 notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.py --check
nix-shell -p singular --run \
  "Singular -q notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.sing"
python3 notes/2026-07-24-c595-stable-component-fano-elimination.py --check
python3 notes/2026-07-23-c525-ordered-hessian-arf-pullback-replay.py
```

The dependency-free Python checker reconstructs (4), verifies the symmetric,
exchanged, and anti-invariant diagonal cases and the Plücker identities
(6)--(7), checks every entry of
(11)--(12), and independently exhausts rational \((1,1)\)-factorizations
over \(\mathbf F_2,\mathbf F_3,\mathbf F_5\).  In each field their images
equal the union of the symmetric-collision, exchanged-collision, cyclic,
and characteristic-three diagonal branches.  These checks concern the
bottom component model; the marker elimination is the geometric
rowspace argument (15)--(18), not a finite-field computation.
The checker also derives the binary \(15,3,0,0\) regression directly from
the two forced index blocks.

Singular 4.4.1 checks (13), the two generic minimal components, the binary
decomposition (14), containment of \(Q_2\) in \(D=0\), and a
characteristic-five generic control.  Its minimal-prime and saturation
algorithms are the trusted scheme-computation boundary.  The polynomial
identities and finite-field factor enumeration are independent of
Singular.

The manifest records SHA-256 hashes and byte counts for the generator,
Singular checker, and canonical JSON output.  The JSON records the exact
C595 input hash.  C525's primary generator, independent replay, and
checksum manifest were also replayed; the first attempted primary command
omitted its required `--output` argument and made no claim, after which the
documented command passed.

## 8. Paper recommendation

The rowspace repair clears the mathematical gate for printing
\(\mathrm{SC}(j)\) as a theorem.  The manuscript version must include,
rather than merely cite, (15)--(18), the anti-invariant
characteristic-three diagonal case, the seven generators (9a), the
characteristic-three ruling computation, and the distinction between
\(\mathbf Z[1/3]\) equality on the \(D\)-open and literal saturation over
\(\mathbf Z[1/6]\).  The integer \(3\) must be described only as minimal
for this elimination presentation.

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Whether the bottom non-cyclic component survives | settled negatively | The corrected UFD trichotomy gives symmetric collision, exchanged cyclic/collision, and the characteristic-three anti-invariant diagonal; (13) identifies the noncollision branch with C595's carrier. |
| Whether the missing integral model exists | settled | The unreduced ordered-root incidence (4) and collision fibre product (5) are integral and commute with arbitrary base change. |
| Whether one global residual colon ideal commutes with every fibre | settled negatively, without blocking the theorem | C535's nonflat-base-change obstruction is real.  C597 gets equality on the \(D\)-open over \(\mathbf Z[1/3]\), but the literal saturated equality with \(V\) holds over \(\mathbf Z[1/6]\); fibres \(2,3\) remain separate. |
| Where the factors \(2\) and \(3\) originate | settled sharply | The Plücker-to-syndrome bridge has presentation-minimal integer \(3\), witnessed in characteristic three.  The factor \(2\) is required because the characteristic-two specialization of \(V\) has a \(D\)-supported component; the composition still uses \(6\). |
| Whether characteristic two has a hidden inseparable component | settled | C525's complete ordered-Hessian degeneracy package pulls back only to persistent/Lucas or rank one. |
| Whether characteristic three has a hidden wild component | settled | The true wild rulings force rank/fixed factor; the nonflat primitive Plücker specialization is not used. |
| Whether bottom identities transport to the upper syndrome | settled | Products of distinct markers are dense in the binary-form parameter space, so attainable bottom contractions close to the projectivized catalecticant row space (17); irreducibility then reduces containment to one bottom component. |
| Whether \(\mathrm{SC}(11)\) holds | settled | The componentwise rowspace calculation proves the stronger \(\mathrm{SC}(j)\) for every \(j\geq6\). |
| Whether the uniform syndrome theorem is unconditional | settled | Substituting the proved stable-component theorem into the printed transverse argument removes its geometric hypothesis; the radius premise remains separate. |
| Whether the binary cyclic-plane descendant persists for \(r\geq8\) | settled negatively | The two forced coefficient blocks (19) cover all indices for \(m\geq3\); the \(\mathbf F_4\) regression is \(15,3,0,0\).  Fresh higher Lucas carriers, including the degree-nine carrier, are not removed. |
| Whether the manuscript theorem is printable | yes, after the listed repairs | The proof must retain the explicit rowspace lemma, component checks, definitions, generators, vertical calculations, and denominator qualification. |

## Closeout assessment

The specialist review correctly rejected substitution as marker
elimination.  The repair is (17): the dense marker-product locus closes to
the full catalecticant row space.  Irreducibility and the explicit
component checks then prove the all-level theorem.  The binary coefficient
blocks additionally show that the modular component terminates after
redundancy seven.
