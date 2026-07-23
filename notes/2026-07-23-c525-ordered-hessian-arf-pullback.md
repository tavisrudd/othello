# C525 — characteristic-two ordered-Hessian root-line theorem

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

Let \(k\) be a field of characteristic two and let
\(\ell=\mathbf P\langle U,V\rangle\subset\mathbf P(\Gamma^3E)\) be a line of divided-power
binary cubics.  Writing
\[
c_{u,v}=uU+vV
\]
and
\[
\operatorname{Hess}^{\mathrm{div}}(c_{u,v})
=N_u(u,v)X^2+N_s(u,v)XY+D(u,v)Y^2,
\]
the ordered-Hessian incidence
\[
\mathcal C_\ell:
N_u(u,v)X^2+N_s(u,v)XY+D(u,v)Y^2=0
\subset\mathbf P^1_{u:v}\times\mathbf P^1_{X:Y}              \tag{1}
\]
has bidegree `(2,2)` and arithmetic genus one.

After removing forced vertical factors caused by \(\ell\) meeting the twisted cubic, its complete
geometric degeneracy locus is:

1. the **persistent Veronese surface**
   \[
   \Sigma=\{\mathbf P(qE):[q]\in\mathbf P(\operatorname{Sym}^2E)\}
   \subset G(1,\Gamma^3E),
   \]
   on which (1) is separably reducible; and
2. the two Fano rulings of the characteristic-two tangent quadric
   \(Q:N_s=AD+BC=0\), on which (1) is inseparable.

One ruling is the tangent-conic boundary of \(\Sigma\).  The complementary ruling is a separate
conic \(\mathcal N\), but it has no rank-two contained root-compatible Hankel pullback: if every
root-line lies in \(\mathcal N\), the consecutive contraction linear forms are proportional and
the line has rank at most one.  The only nontrivial contained pullback is therefore \(\Sigma\).
By C512's iterated contained-flag theorem, its syndrome pullback is exactly the persistent
catalecticant rank-two and Lucas-nucleus carrier union.

Consequently, for every syndrome degree \(n\ge5\), every characteristic-two syndrome outside that
carrier has a root-compatible geometrically integral reduced ordered-Hessian slice once
\[
q\ge T_n^{(2)}
:=\min\left\{\frac{(n-4)(n+3)}2+1,\ 5(n-4)\right\}.          \tag{2}
\]
The exact deletion budget improves to
\[
\delta_n^{(2)}\le3n-4.                                      \tag{3}
\]
If additionally
\[
q+1-2\sqrt q>3n-4,                                          \tag{4}
\]
the slice has a rational point outside every deletion divisor, giving a completely split
squarefree Hankel-kernel member.  Thus under (2)--(4), every split-free PRS syndrome lies in the
persistent/Lucas carrier union.  No ambient syndrome census and no fixed-redundancy extrapolation
enter the theorem.

This is a containment theorem, not an assertion that every carrier point is deep.  Arithmetic
deepness on Lucas carriers retains its level-specific Frobenius law.

## 1. The universal `(2,2)` equation

For
\[
U=(A,B,C,D_3),\qquad V=(a,b,c,d),
\]
the three divided-Hessian coefficients are binary quadratics:
\[
\begin{aligned}
N_u(u,v)&=(AC+B^2)u^2+(Ac+aC)uv+(ac+b^2)v^2,\\
N_s(u,v)&=(AD_3+BC)u^2
 +(Ad+aD_3+Bc+bC)uv+(ad+bc)v^2,\\
D(u,v)&=(BD_3+C^2)u^2+(Bd+bD_3)uv+(bd+c^2)v^2.
\end{aligned}                                                \tag{5}
\]
Equation (1) follows.  It commutes with the `GL(E)` action on cubic/root coordinates and with
change of basis on \(\ell\).  A rational point of (1) is exactly a line parameter together with
one ordered residual root.  Off \(N_s=0\), its characteristic-two descent class is the Arf class
\[
\frac{D N_u}{N_s^2}\in k(u/v)/\{h^2+h\}.                     \tag{6}
\]

## 2. Forced vertical and horizontal factors

A vertical factor \(l(u,v)\) divides all three coefficients in (5) exactly when
\(\operatorname{Hess}^{\mathrm{div}}(c_{u,v})=0\) at its zero.  The base locus of the divided
Hessian is the twisted cubic, so:

> Vertical factors of (1) are exactly the scheme-theoretic intersections
> \(\ell\cap C_3\).

They are collision components, not exceptional carriers.  Remove them before asking geometric
integrality.

A horizontal factor \(m(X,Y)\) says that every cubic of \(\ell\) has a fixed Hessian root.
For fixed \([m]\), those cubics form the rank-three quadric cone swept by secants through the
corresponding point of \(C_3\).  Every line on that cone is a generator through its vertex.
Hence a horizontal factor forces a chord/tangent line and belongs to the persistent surface or
its collision boundary.

## 3. Separable external factorization

Assume that (1) is separable and reducible after vertical/horizontal factors are removed.  Its two
factors must both have bidegree `(1,1)`.  Each factor gives a degree-one root map
\(\mathbf P^1_\ell\to\mathbf P^1\).  Use independent projective changes on the parameter and root
lines to make the first map the identity.  The second becomes a projectivity \(g\in PGL_2\), up
to conjugacy.

### Semisimple normal form

Put \(g(t)=ct\).  At the two fixed parameters, normalize the two tangent cubics to
\[
U=(a,1,0,0),\qquad V=(0,0,\gamma,d).
\]
Matching (5) to
\[
(uX+vY)(uX+cvY)
=u^2X^2+(1+c)uvXY+cv^2Y^2
\]
forces
\[
d=0,\qquad a=0,\qquad \gamma=1+c,\qquad \gamma^2=c.
\]
Therefore
\[
c^2+c+1=0.                                                   \tag{7}
\]
The line is
\[
\mathbf P\langle X^2Y,XY^2\rangle=XY\cdot\mathbf P(E).
\]
After undoing the projective normalization it is exactly
\(\mathbf P(qE)\) for a squarefree binary quadratic \(q\).

### Unipotent normal form

Put \(g(t)=t+1\).  The factorization is
\[
(uX+vY)((u+v)X+vY).
\]
The same endpoint normalization and coefficient comparison force simultaneously
\[
d=\gamma=0,\qquad a\gamma=1,
\]
a contradiction.  Hence no unipotent external component exists.

This proves that \(\Sigma\) is the complete separable external reducibility locus.

The arithmetic visible in (7) is the familiar order-three obstruction.  On the normalized line,
\[
B^2X^2+BCXY+C^2Y^2
=(BX+\omega CY)(BX+\omega^2CY),
\]
where \(\omega^2+\omega+1=0\).  The two geometric factors are rational over
\(\mathbf F_{2^m}\) exactly when \(m\) is even.  This recovers the deck-transformation mechanism
behind the frozen characteristic-two nucleus examples without identifying every carrier point as
deep.

## 4. Pluecker ideals

Use Pluecker coordinates
\[
(z_0,z_1,z_2,z_3,z_4,z_5)
=(p_{01},p_{02},p_{03},p_{12},p_{13},p_{23}).
\]
For \(q=aX^2+bXY+cY^2\), the line \(qE\) has
\[
[z_0:\cdots:z_5]
=[a^2:ab:ac:b^2+ac:bc:c^2].                                 \tag{8}
\]
Therefore \(\Sigma\) is the Veronese surface cut out by the `2 x 2` minors of
\[
\begin{pmatrix}
z_0&z_1&z_2\\
z_1&z_3+z_2&z_4\\
z_2&z_4&z_5
\end{pmatrix}.                                               \tag{9}
\]
The tangent ruling of \(Q\) is the conic
\[
z_1=z_4=0,\qquad z_2=z_3,\qquad z_0z_5=z_2^2,
\]
which is the square-quadratic boundary of (8).

The complementary ruling is
\[
\mathcal N:\quad
z_0=z_5=0,\qquad z_2=z_3,\qquad z_1z_4=z_2^2.                \tag{10}
\]
Equations (9)--(10), together with the Chow resultant for lines meeting \(C_3\), are the complete
universal degeneracy package.

## 5. Constrained Hankel pullback

Fix \(R\in\operatorname{Sym}^{n-4}E^\vee\).  Multiplication by the two linear factors gives the
root-compatible line
\[
\ell_{f,R}=L_f(\mathbf P(RE^\vee)).
\]
Its Pluecker coordinates are quadratic in the coefficients of \(R\), so substituting into
(9)--(10) gives equations of degree at most four in those coefficients.

The complementary conic cannot contain a rank-two family of such root-lines.  In a frame, its
first and last linear equations give consecutive identities
\[
h_{-1}(R)^2=h_{-2}(R)h_0(R),\qquad
h_1(R)^2=h_0(R)h_2(R).                                      \tag{11}
\]
If (11) holds on every split \(R\), it holds identically: split forms are Zariski dense over the
algebraic closure.  Unique factorization of linear forms (including the cases where one form
vanishes) then makes each nonzero consecutive triple proportional.  Propagating across the two
overlapping identities makes all five contraction forms proportional, so
\(\operatorname{rank}\ell_{f,R}\le1\).  Thus \(\mathcal N\) contributes no nontrivial contained
carrier.

If the generic root-line lies in \(\Sigma\), every iterated contraction pencil has a common
quadratic.  C512's contained-flag theorem applies exactly: its catalecticant clause gives the
persistent rank-two carrier and its contraction-kernel/Lucas clause gives the modular-nucleus
flags.  Conversely both families contract into \(\Sigma\).  Therefore the complete nontrivial
contained pullback is precisely the persistent/Lucas union.

Lines meeting \(C_3\) only add removable vertical factors.  Even if such an intersection persists
through a family of \(R\)'s, the reduced moving component remains the object tested by
(9)--(10); it is not promoted to a carrier merely because one parameter is forbidden.

## 6. Effective base selection

Write \(R=\prod_{i=1}^{n-4}(t-r_i)\).  Each coefficient of \(R\) is at most linear in every
individual \(r_i\).  Hence:

- each Pluecker coordinate of \(\ell_{f,R}\) has degree at most two in each root;
- each quadratic equation in (9)--(10) has degree at most four in each root; and
- the fixed-root Vandermonde has total degree \(\binom{n-4}{2}\).

Outside the contained carrier, at least one pulled-back degeneracy equation is nonzero.  Affine
Schwartz--Zippel therefore leaves a distinct rational root base as soon as
\[
q>4(n-4)+\binom{n-4}{2}
=\frac{(n-4)(n+3)}2,
\]
which gives the first term of (2).

There is a sharper large-\(n\) choice.  Put \(m=n-4\) and partition any \(5m\) available field
elements into pairwise disjoint five-element sets \(S_1,\ldots,S_m\).  A nonzero polynomial of
degree at most four in each variable cannot vanish on
\(S_1\times\cdots\times S_m\): successive univariate interpolation would otherwise make it the
zero polynomial.  Every tuple in this product has distinct coordinates because the blocks are
disjoint.  Thus \(q\ge5(n-4)\) also suffices, proving the second term of (2).  Together these
replace C519's provisional coefficient-discriminant bound \((n-4)(n+43)/2\).

## 7. Deletion and arithmetic

On a good reduced slice, retain:

| divisor | degree |
|---|---:|
| moving/fixed diagonal | \(n-4\) |
| residual determinant \(D=0\) | \(2\) |
| characteristic-two inseparability \(N_s=0\) | \(2\) |
| residual root through a fixed root | \(2(n-4)\) |
| residual root through the moving root | \(4\) |

Their total is at most \(3n-4\), proving (3).  The normalization of a geometrically integral
reduced `(2,2)` curve has genus at most one.  Hasse--Weil and (4) therefore leave a rational point
outside the deletion divisor.  Its parameter gives a split \(P=R\lambda\); one rational residual
root makes the other rational; and the deletions make the complete degree-\((n-1)\) kernel member
squarefree.

## Evidence and replay

The atomic bundle is:

- `notes/2026-07-23-c525-ordered-hessian-arf-pullback.py`;
- `notes/2026-07-23-c525-ordered-hessian-arf-pullback.json`;
- `notes/2026-07-23-c525-ordered-hessian-arf-pullback-replay.py`; and
- `notes/2026-07-23-c525-ordered-hessian-arf-pullback.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c525-ordered-hessian-arf-pullback.py \
  --output notes/2026-07-23-c525-ordered-hessian-arf-pullback.json --check
python3 notes/2026-07-23-c525-ordered-hessian-arf-pullback-replay.py
(cd notes && sha256sum -c 2026-07-23-c525-ordered-hessian-arf-pullback.sha256)
```

The standard-library generator checks the universal formulas and enumerates all `357` lines of
`PG(3,4)` as a bounded algebra regression.  It finds `21` persistent-surface lines, `10`
inseparable lines (the two five-line rulings), `20` separable reducible lines, and exactly `10`
separable reducible lines without an `F4`-rational vertical factor; every one of those ten lies on
\(\Sigma\).  The load-bearing byte counts are `8566` for the generator, `2948` for the JSON
certificate, and `3139` for the replay.  This finite check is not the proof of the algebraically
closed classification.

The independent replay reconstructs the `21`-point Veronese surface and `5`-point complementary
conic, checks their ideals, verifies the order-three factorization over `F4`, and independently
checks the bound table.  The normal-form and constrained-pullback arguments above are hand proofs.

## Extra-juice closeout

- Forced vertical factors are exactly twisted-cubic intersections and can be removed without
  promoting a collision parameter to a carrier.
- The apparently new external `(1,1)+(1,1)` component is not new: it is precisely the classical
  common-quadratic surface \(qE\).
- Its factorization exposes the same order-three Frobenius law as the known characteristic-two
  nucleus family.
- The complementary inseparable ruling has no nontrivial contained root-line pullback.
- Exact Pluecker equations reduce the base-selection coefficient from `24` per fixed root to `4`,
  changing the initial quadratic bound from `(n-4)(n+43)/2` to the strict threshold
  `(n-4)(n+3)/2`.
- Disjoint five-element interpolation blocks remove the Vandermonde penalty entirely, giving the
  linear sufficient threshold `q >= 5(n-4)` and hence the minimum in (2).
- The reduced branch degree drops from four to two, improving the deletion budget from `3n-2` to
  `3n-4`.

## Tao stress test

The proof survives the following load-bearing attacks.

- **Could a reducible `(2,2)` curve escape the two normal forms?** Once all vertical and
  horizontal factors are removed, every irreducible factor has positive degree in both
  projections.  Bidegree additivity leaves only `(1,1)+(1,1)`.  Over the algebraic closure each
  irreducible `(1,1)` factor is the graph of a projectivity.  Every projectivity is identity,
  semisimple with two fixed points, or unipotent with one fixed point; the identity is included in
  the semisimple coefficient comparison and fails (7).
- **Does “inseparable” silently mean “nonreduced”?** No.  The two rulings classify
  \(N_s\equiv0\), hence purely inseparable root projection.  Individual total-space curves may be
  reduced; the theorem uses inseparability, not a blanket nonreduced assertion.
- **Can the complementary ruling survive only on split root bases without giving a polynomial
  identity?** No.  Split forms are dense over the algebraic closure, so (11) is an identity.
  Zero-form edge cases in the UFD argument only lower contraction rank and cannot create a
  rank-two carrier.
- **Can the interpolation grid select repeated roots?** No.  The sets
  \(S_1,\ldots,S_{n-4}\) are pairwise disjoint.  Every grid tuple is automatically ordered and
  distinct, while degree at most four in each variable and \(|S_i|=5\) make the product grid a
  hitting set for every nonzero pullback equation.
- **Is the `F4` enumeration being used as an algebraic-closure proof?** No.  It is a bounded
  regression for the displayed equations and counts only.  Completeness rests on the
  bidegree/projectivity normal-form argument and the Pluecker ideals.
- **Do removable vertical components invalidate Hasse--Weil?** No.  They are factored before
  normalization.  Their parameter belongs to the forbidden collision boundary; the retained
  moving component has genus at most one, and the deletion table bounds the points that cannot
  encode a squarefree kernel member.

The stress test changes no theorem statement.  It does sharpen the trust boundary: the carrier
result is geometric containment, while arithmetic deepness on the retained carrier remains
outside C525.

## Mystery ledger

Settled:

- **What are all geometrically degenerate ordered-Hessian line sections?** After forced vertical
  factors, exactly \(\Sigma\) and the two rulings of \(Q\).
- **Is there a new separable external component?** No.  The only one is \(qE\), the persistent
  common-quadratic surface.
- **Can the complementary ruling persist under every root contraction?** Not at rank two;
  identities (11) force proportional contraction forms.
- **Does the corrected characteristic-two model yield an effective arbitrary-degree theorem?**
  Yes: equations (2)--(4).
- **Is the quadratic distinct-root penalty intrinsic?** No.  Disjoint interpolation blocks give
  the linear base-selection threshold in (2).

Open:

- **Which Lucas-carrier points are actually deep at arbitrary degree?** C525 gives containment,
  not a uniform arithmetic classification.  Evidence gap: the Frobenius action on each
  level-specific modular ordered-root cover.  Owner: a future carrier-arithmetic task if a fixed
  level or representation-stable family is selected.
- **Sharpness of the field bound.** The theorem uses five-element interpolation blocks and a
  summed deletion budget.  Smaller hitting sets, exact divisor overlap, or a finite covariant
  slice family may lower it.

No genuine mystery remains about the characteristic-two universal root-line component theorem.

## Literature boundary

The adjacent delta
`notes/2026-07-23-c525-ordered-hessian-arf-pullback-literature-audit.md` makes no priority claim for
twisted-cubic line geometry, Hessians, Arf invariants, Veronese surfaces, or normal-rational-curve
nuclei.  The current line-orbit literature located in the fresh search explicitly treats
characteristic different from two and three; C525 uses direct modular algebra rather than importing
those classifications.
