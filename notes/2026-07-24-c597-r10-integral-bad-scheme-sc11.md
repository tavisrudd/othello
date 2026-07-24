# C597 — R10 integral bad scheme and \(\mathrm{SC}(11)\)

**Lane:** `reed-solomon`
**Date:** 2026-07-24
**Status:** complete; \(\mathrm{SC}(j)\) holds for every \(j\geq6\)

## Result

The complete recursively pointed bad scheme has an integral
Grassmannian model.  After separating the collision subscheme before
residualization, its geometric nonintegrality locus has only the branches
already classified in C512, C525, C536, and C595:

1. persistent catalecticant rank at most two;
2. Lucas-nucleus pullbacks;
3. fixed-factor or marker-collision boundary;
4. the cyclic/wild branch.

C595 eliminates the fourth branch.  The first three are exactly the
declared persistent, modular, and collision alternatives.  Consequently
\[
                         \mathrm{SC}(j)
       \quad\text{holds for every }j\geq6.                  \tag{1}
\]
In particular, \(\mathrm{SC}(11)\) is proved.

The integral saturation certificate again needs only
\[
                              N_j=6.                         \tag{2}
\]
Its vertical characteristics are closed: characteristic two is the
ordered-Hessian persistent/Lucas theorem of C525, and characteristic three
is the wild-ruling rank/fixed-factor theorem used by C595.  No exceptional
characteristic remains.

Combining (1) with the already printed uniform transverse theorem removes
its last geometric hypothesis:

> **Unconditional uniform split-free syndrome theorem.**
> Fix \(r\geq6\).  If
> \[
> q\geq6r-15+\left\lfloor2\sqrt{6r-17}\right\rfloor,
> \]
> every split-free redundancy-\(r\) syndrome belongs to the persistent or
> modular list.  If \(\operatorname{char}\mathbf F_q>r-1\), the modular list
> is empty.

This is a syndrome theorem.  Calling its directions code deep holes still
requires the appropriate covering-radius premise.

The C545 manuscript remains frozen.  The new theorem needs an independent
specialist proof review and a claim-specific literature audit before the
user could consider reopening that submission scope.

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
\(\mathbf Z[1/6]\) and treats the two vertical fibres separately.

## 2. Exhaustive factorization lemma

Work over an algebraically closed field.  If the residual moving part of
\(G_z\) is reducible, its factors have either bidegrees
\((1,1)+(1,1)\) or a vertical/horizontal bidegree.  The latter is a
fixed-root or collision component and belongs to (5).

Let \(\tau(t,s)=(s,t)\).  Unique factorization and
\(\tau(G_z)=G_z\) give exactly two possibilities for two \((1,1)\)
factors.

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
Let \(J\) be their pullback under (8), let \(V=(V_1,\ldots,V_7)\)
be C595's primitive syndrome cyclic ideal, and put
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
matrix \(B\) satisfying
\[
                     6D(V_1,\ldots,V_7)
                    =(K_1,\ldots,K_6)B.                    \tag{12}
\]
Its nonzero rows are
\[
\scriptsize
\begin{pmatrix}
0&0&0&-c_2c_4&-3c_1c_4&6c_2^2&2c_1c_2\\
2c_4^2&0&3c_2c_4&-2c_1c_4&-6c_2^2-3c_0c_4&12c_1c_2&
 4c_1^2+2c_0c_2\\
2c_3c_4&0&3c_1c_4&0&-3c_0c_3&0&2c_0c_1\\
0&0&0&0&0&0&0\\
4c_3^2+2c_2c_4&12(c_2c_3-c_1c_4)&-6c_2^2+12c_1c_3+3c_0c_4&
2c_0c_3&12c_1^2-15c_0c_2&-12c_0c_1&2c_0^2\\
2c_2c_3&6(c_2^2-c_0c_4)&3c_0c_3&c_0c_2&0&-6c_0^2&0
\end{pmatrix}.
\]
The projected Veronese \(V\) is prime over \(\mathbf Z[1/6]\), and
\(D\notin V\).  Equations (11)--(12) therefore prove
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

All other characteristics lie on \(\mathbf Z[1/6]\) and are covered by
(13).  Hence (2) confines every possible vertical failure and the two
fibres both close.

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

## 6. Proof of the stable-component assertion

Fix \(j\geq6\) and suppose a universal polar line is wholly contained in
the recursively pointed bad scheme.  The parameter line is irreducible, so
it lies in one component of the finite ledger in Section 5.

- C536 identifies containment in the lower secant scheme with the upper
  persistent scheme and computes every linear Lucas pullback.
- The uniform collision lemma makes the collision divisor finite outside
  the two already resolved vertical cases.
- The fixed-factor argument places an identically fixed marker in the
  gcd/rank boundary.
- By Section 2, every remaining geometric nonintegrality component is
  collision or cyclic.
- Equations (11)--(13) identify the noncollision component with C595's
  cyclic carrier after persistent saturation.
- C595 eliminates that carrier in every characteristic, while C525 closes
  the additional binary inseparable chart.

Thus the upper syndrome belongs to
\(\mathcal P_j\cup\mathcal M_j\).  This is \(\mathrm{SC}(j)\), proving
(1).  The argument is independent of the number of retained markers:
marker contraction only substitutes integral linear forms for the \(c_i\)
in identities (11)--(12).

For \(j=11\), the five retained marker coefficients give
\[
c_i=a_{i+5}-s_1a_{i+4}+s_2a_{i+3}-s_3a_{i+2}
       +s_4a_{i+1}-s_5a_i.
\]
Substitution into the same identities is the requested R11
coherent-Fano elimination.  The combined cleared denominator from
(12) and C595 remains \(N_{11}=6\).

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

The dependency-free Python checker reconstructs (4), verifies the two
factorizations and the Pluecker identities (6)--(7), checks every entry of
(11)--(12), and independently exhausts rational \((1,1)\)-factorizations
over \(\mathbf F_2,\mathbf F_3,\mathbf F_5\).  In each field their images
equal the union of the symmetric-collision, exchanged-collision, and
cyclic branches.

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

The result merits a companion-paper theorem: it removes the only
arbitrary-level geometric hypothesis from the uniform transverse theorem
and replaces level-specific carrier calculations by one integral
Grassmannian factorization.  The mechanism is short enough to print:
the symmetry dichotomy (6)--(7), the bridge (11)--(13), and the two
vertical fibres.

It is not yet authorized for the frozen C545 submission.  Before any paper
change, run a claim-specific literature audit and obtain an independent
specialist proof review focused on the exhaustiveness of the factorization
ledger and the nonflat characteristic-two residualization boundary.

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Whether a non-cyclic R10 component survives | settled negatively | The UFD symmetry dichotomy gives only collision or exchanged cyclic factors; (13) identifies the latter with C595's carrier. |
| Whether the missing integral model exists | settled | The unreduced ordered-root incidence (4) and collision fibre product (5) are integral and commute with arbitrary base change. |
| Whether one global residual colon ideal commutes with every fibre | settled negatively, without blocking the theorem | C535's nonflat-base-change obstruction is real; C597 residualizes over \(\mathbf Z[1/6]\) and treats fibres \(2,3\) before saturation. |
| Why the same integer \(6\) reappears | settled | Both the Pluecker-to-syndrome bridge (12) and the cyclic coherent-Fano certificate use only denominators \(2,3\); their composition still localizes once at \(6\). |
| Whether characteristic two has a hidden inseparable component | settled | C525's complete ordered-Hessian degeneracy package pulls back only to persistent/Lucas or rank one. |
| Whether characteristic three has a hidden wild component | settled | The true wild rulings force rank/fixed factor; the nonflat primitive Pluecker specialization is not used. |
| Whether \(\mathrm{SC}(11)\) holds | settled | Section 6 proves the stronger \(\mathrm{SC}(j)\) for all \(j\geq6\). |
| Whether the uniform syndrome theorem is now unconditional | settled | Substitute (1) into the printed uniform transverse theorem; covering radius remains a separate coding premise. |
| Whether C545 should be reopened | gated | Requires user authorization after a dedicated literature audit and independent specialist review. |

## Closeout assessment

The `ej`+`tt` pass found the decisive upgrade: the R10 obstruction was not a
large elimination problem but a symmetry problem on
\(\operatorname{Gr}(2,4)\).  Unique factorization reduces every moving
nonintegrality component to collision or one cyclic equation, and the
cleared-denominator bridge identifies that equation with C595's already
closed carrier.  No mathematical mystery remains in the stable-component
assertion; the remaining gates are external review, literature diligence,
and manuscript-scope authorization.
