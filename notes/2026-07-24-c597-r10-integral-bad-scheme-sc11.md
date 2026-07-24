# C597 — R10 integral bad scheme and \(\mathrm{SC}(11)\)

**Lane:** `reed-solomon`
**Date:** 2026-07-24
**Status:** complete after the catalecticant-rowspace transport repair;
\(\mathrm{SC}(j)\) holds for every \(j\geq6\)

## Result

The integral ordered-root incidence and its bottom-syndrome elimination are
correct.  On the rank-two open, the noncollision Pluecker ideal \(J\) and
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
for Pluecker coordinates, with relation
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
whose Pluecker value is \(-3\mu^2\).  It therefore survives only in
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
On its rank-two open, the kernel line has Pluecker coordinates
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
six integral Pluecker equations
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

The Pluecker specialization alone does not represent every inseparable
binary degeneration.  C525's ordered-Hessian model is the required second
chart.  Its complete degeneracy package is the persistent Veronese
surface, the two tangent-quadric rulings, and the collision Chow
resultant.  Under the consecutive-Hankel constraint, the Veronese pulls
back exactly to the persistent/Lucas union; the complementary ruling
forces rank at most one; and the Chow factor is (5).  Thus no binary
component remains.

### Characteristic three

Primitive specialization of (9) is nonflat and is not used as the wild
model.  The actual wild closure is the join of the cubic nucleus with the
quartic normal rational curve.  Its lines are rulings, and the
consecutive-Hankel equations force the rank/fixed-factor boundary.  This
is the characteristic-three fibre checked in C595.  No ternary component
remains.

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

## 6. Missing transport step and repair gate

Let \(m=j-5\) markers be retained.  The bottom coordinates are
affine-linear in the elementary symmetric functions of those markers.
The required transport statement is the scheme-theoretic identification
\[
 \overline{\{\text{attainable bottom syndromes}\}}
   =\mathbf P\!\left(\operatorname{rowspace}\operatorname{Cat}_{j-4,5}(f)\right).
\]
Only after proving this equality, including the projective boundary and
marker diagonals, can recursively pointed containment be replaced by
\[
\mathbf P(\operatorname{rowspace}\operatorname{Cat}_{j-4,5}(f))
   \subset C
\]
for one irreducible component \(C\) of the level-five bad scheme.
The original substitution argument proves neither the closure equality nor
this elimination of marker variables.

This reformulation makes the intended uniform cases plausible and
falsifiable.  The persistent component should give catalecticant rank at
most two by Proposition 5.14.  The tame Veronese contains no line, hence
should force rank at most one.  The characteristic-three wild cone has
only its ruling lines, so its rowspace containment should again force rank
at most two.  These implications must be proved for the rowspace functor,
not inferred from identities on marker space.

The binary cyclic plane gives the sharp regression.  Containment in
\(\Pi_{\rm cyc}\) forces
\[
 a_0=\cdots=a_m=0,\qquad a_4=\cdots=a_{m+4}=0.
\]
For \(m\geq3\) the two index blocks cover every coefficient, so this
component terminates after redundancy seven.  The exact
\(\mathbf F_4\) affine count, agreeing with the reviewer's brute-force
regression, is \(15,3,0,0\) nonzero solutions at
\(j=6,7,8,9\), respectively: projectively these are exactly \(N_3\),
\([e_3]\), and then the empty set.  This is the mechanism a repaired
transport proof must reproduce.  If completed, it would imply
\(\mathcal M_r=\varnothing\) in characteristic two for \(r\geq8\).
That consequence is not yet promoted to the manuscript.

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
exchanged, and anti-invariant diagonal cases and the Pluecker identities
(6)--(7), checks every entry of
(11)--(12), and independently exhausts rational \((1,1)\)-factorizations
over \(\mathbf F_2,\mathbf F_3,\mathbf F_5\).  In each field their images
equal the union of the symmetric-collision, exchanged-collision, cyclic,
and characteristic-three diagonal branches.  These checks concern the
bottom component model; they do not eliminate retained markers.
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

Do not change the C545 manuscript: its \(\mathrm{SC}(j)\) hypothesis is
correctly retained.  The Grassmannian bridge is
a valid ingredient for a companion paper, but it is a restatement of the
level-five component classification until the rowspace/marker-elimination
step in Section 6 is proved.  Any future companion should print the
anti-invariant characteristic-three diagonal case and describe \(3\) only
as the minimal denominator of this elimination presentation.

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Whether the bottom non-cyclic component survives | settled negatively | The corrected UFD trichotomy gives symmetric collision, exchanged cyclic/collision, and the characteristic-three anti-invariant diagonal; (13) identifies the noncollision branch with C595's carrier. |
| Whether the missing integral model exists | settled | The unreduced ordered-root incidence (4) and collision fibre product (5) are integral and commute with arbitrary base change. |
| Whether one global residual colon ideal commutes with every fibre | settled negatively, without blocking the theorem | C535's nonflat-base-change obstruction is real.  C597 gets equality on the \(D\)-open over \(\mathbf Z[1/3]\), but the literal saturated equality with \(V\) holds over \(\mathbf Z[1/6]\); fibres \(2,3\) remain separate. |
| Where the factors \(2\) and \(3\) originate | settled sharply | The Pluecker-to-syndrome bridge has minimal integer \(3\), witnessed in characteristic three.  The factor \(2\) enters only through C525/C595's inseparable/coherent-Fano step, so the composition still uses \(6\). |
| Whether characteristic two has a hidden inseparable component | settled | C525's complete ordered-Hessian degeneracy package pulls back only to persistent/Lucas or rank one. |
| Whether characteristic three has a hidden wild component | settled | The true wild rulings force rank/fixed factor; the nonflat primitive Pluecker specialization is not used. |
| Whether bottom identities transport to the upper syndrome | open, load-bearing | Marker substitution preserves identities on syndrome--marker space but does not eliminate marker variables.  Prove the catalecticant-rowspace closure statement in Section 6. |
| Whether \(\mathrm{SC}(11)\) holds | open | The original proof is withdrawn; only \(\mathrm{SC}(6)\) and \(\mathrm{SC}(7)\) remain established by Proposition 6.7 and Corollary 6.14. |
| Whether the uniform syndrome theorem is unconditional | no | It remains conditional on \(\mathrm{SC}(j)\), exactly as printed in C545. |
| Whether binary modular components persist for \(r\geq8\) | strong candidate: no | The two forced coefficient blocks cover all indices for \(m\geq3\); the \(\mathbf F_4\) regression gives \(15,3,0,0\) affine solutions at \(j=6,7,8,9\).  Promotion requires the rowspace transport proof. |
| Whether C545 should be reopened | settled negatively for C597 | The manuscript already states the correct conditional theorem and should remain unchanged. |

## Closeout assessment

The specialist review preserves the integral
\(\operatorname{Gr}(2,4)\) bridge but rejects its promotion to an
all-level theorem.  The missing operation is elimination of retained
markers, not another bottom-component calculation.  The highest-EV repair
is the catalecticant-rowspace closure theorem followed by uniform line
containment in each level-five component.  The binary coefficient blocks
give the sharp regression target and predict that the modular components
terminate after redundancy seven.
