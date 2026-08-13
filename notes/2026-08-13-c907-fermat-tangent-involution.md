# C907 — Fermat tangent-cover involution

Date: 2026-08-13

Status: exact birational formula and exact obstruction audit. This does not
prove or disprove stable rationality of the Fermat cubic.

## The rational cover and its involution

Write the Fermat cubic in coordinates

\[
 a=x_0+x_1,\quad b=x_0-x_1,\quad
 c=x_2+x_3,\quad d=x_2-x_3,\quad e=x_4:
\]

\[
 4F=a^3+3ab^2+c^3+3cd^2+4e^3.
\]

On the line \(\ell\), put

\[
 p(r)=[r:-r:1:-1:0].
\]

On the affine tangent-direction chart used below, a direction modulo the
line is

\[
 v(r,y,z)=(a,b,c,d,e)=(y,z,-r^2y,0,1).
\]

The exact polar identity is

\[
 4F(p(r)+t v)=t^2\left(12ryz+tD\right),
 \qquad
 D=4+(1-r^6)y^3+3yz^2.
\]

Thus the residual-point map from the rational threefold
\(\mathbf P(T_X|_\ell)\) uses

\[
 \lambda=-\frac{12ryz}{D}.
\]

Its deck involution is

\[
 \boxed{
 (r,y,z)\longmapsto
 \left(-r,y,-\frac{4+(1-r^6)y^3}{3yz}\right).}
 \tag{1}
\]

The replay verifies both that (1) squares to the identity and that all five
coordinates of the residual point are unchanged.

## Fixed field

Put \(\rho=r^2\), \(A=4+(1-r^6)y^3\), and

\[
 u=z-\frac{A}{3yz},
 \qquad
 v=r\left(z+\frac{A}{3yz}\right).
\]

Then

\[
 \mathbf C(r,y,z)^{\langle\iota\rangle}
 =\operatorname{Frac}
 \frac{\mathbf C[y,\rho,u,v]}
 {\left(v^2-\rho\left[u^2+
 \frac{4(4+(1-\rho^3)y^3)}{3y}\right]\right)}.
 \tag{2}
\]

Adjoining a two-dimensional permutation representation adds two free
invariants to (2), by the no-name lemma. It does not simplify or split the
displayed conic. Consequently stable linearization of this cover is not a
shortcut: it is a sufficient positive construction for stable rationality,
but no longer an easier invariant-field problem.

The nonsplitting assertion has an exact Brauer residue.  Over
\(K=\mathbf C(\rho,y)\), put

\[
 A_\rho=4+(1-\rho^3)y^3.
\]

The conic (2) has class

\[
 \beta=\left(\rho,\frac{4\rho A_\rho}{3y}\right)
       =\left(\rho,\frac{A_\rho}{y}\right)
       \in\operatorname{Br}K[2].
 \tag{2a}
\]

Here \((\rho,\rho)=(\rho,-1)=0\) over \(\mathbf C\), and constants are
squares.  The divisor \(A_\rho=0\) is integral: over \(\mathbf C(y)\), the
element \(1+4/y^3\) is not a cube, so its cubic equation for \(\rho\) is
irreducible.  The residue of (2a) at this divisor is the class of \(\rho\).
It is nonsquare in the divisor function field, since \(\rho\) has a simple
zero at each smooth point

\[
 \rho=0,\qquad y^3=-4.
\]

Thus \(\beta\ne0\), and (2) has no \(K\)-point.  The injection
\(\operatorname{Br}K\hookrightarrow\operatorname{Br}K(t_1,t_2)\) shows that
adjoining two independent variables still does not give a rational section.
This is a base-relative obstruction only: \(\beta\) dies in the conic's own
function field, so it does not by itself prove that the total quotient
threefold is nonrational or stably irrational.

## Two elliptic residues

The involution on the parameter line is \(r\mapsto-r\), with fixed base
points \(0\) and \(\infty\). At \(r=0\), the fixed curve is

\[
 E_0:\quad y^3+3yz^2+4w^3=0.
 \tag{3}
\]

The change

\[
 (X_0,X_1,X_2)=(y+z,y-z,2w)
\]

takes twice (3) to
\(X_0^3+X_1^3+X_2^3=0\). Hence \(E_0\) is the Fermat elliptic curve and
has \(j=0\). Exchanging the two coordinate pairs of the Fermat threefold
sends \(r\) to \(1/r\), so the second fixed base point carries an isomorphic
curve \(E_\infty\).

At either curve the two normal eigencharacters are both the sign character
\(\chi\). This explains why the most obvious equivariant Burnside obstruction
does not fire:

\[
 (C_2,k(E),(\chi,\chi))=0
\]

by relation B1, since \(\chi+\chi=0\) in \(C_2^\vee\). The genus-one case is
also outside the genus-at-least-two hypothesis of the available
intermediate-Jacobian/Burnside count. The elliptic curves therefore expose
structure but do not prove non-linearizability or stable irrationality.

## The clean graph-resolution Picard obstruction also vanishes

There is a second exact regression against stable non-linearizability.  Let
`S` be a smooth rational surface with an involution `sigma` acting trivially
on `Pic(S)`, and consider the fibre inversion on a trivial `P^1`-bundle

\[
 (s,[Z:W])\longmapsto
 (\sigma(s),[f(s)W:g(s)Z]),
 \tag{4}
\]

where `f,g` are `sigma`-invariant sections of the same line bundle `L`.
Assume for this calculation that the graph centers

\[
 C_f=\{f=0,Z=0\},\qquad C_g=\{g=0,W=0\}
\]

are smooth and disjoint.  Blowing them up resolves (4).  Write `H` for the
relative hyperplane class and `E_f,E_g` for the exceptional divisors.  The
lifted involution exchanges each exceptional divisor with the strict
transform of the corresponding vertical divisor.  Hence

\[
 E_f\mapsto L-E_f,\qquad E_g\mapsto L-E_g,
 \qquad H\mapsto H+L-E_f-E_g,
 \tag{5}
\]

and it fixes `Pic(S)`.  The last formula also follows because the strict
transforms of the coordinate sections, of classes `H-E_f` and `H-E_g`, are
exchanged.

Put `u=E_f-E_g` and `v=E_f+E_g-L`.  The anti-invariant lattice is generated
by `u,v`, while

\[
 (\iota-1)H=-v,
 \qquad
 (\iota-1)E_f=-(u+v),
 \qquad
 (\iota-1)E_g=u-v.
\]

It follows that

\[
 H^1(C_2,\operatorname{Pic}(\widetilde{S\times\mathbf P^1}))=0.
 \tag{6}
\]

This is the clean local shape of the Fermat formula: `f/g` is
`-[4+(1-r^6)y^3]/(3y)` and `sigma(r,y)=(-r,y)`.  It shows that the core
elementary transformation contributes no `H^1(C_2,Pic)` obstruction.  It is
not yet the Picard computation of a complete smooth projective equivariant
resolution of (1): the compactified zero/pole divisor is reducible and has
boundary multiplicities, so its crossings and the additional equivariant
blowups must be audited.  Equation (6) is a regression and a compression of
that remaining calculation, not the final answer.

## Mechanism and scope correction

For a general line, the point-choosing double cover has a smooth branch
conic and a fixed rational conic-bundle divisor. For the chosen Fermat line,
the branch conic splits and is contained in the quintic discriminant. In the
tangent model the degenerate fixed-divisor information contracts to the two
elliptic residues above. Thus fixed-divisor rationality and elliptic fixed
curves are two birational models of the same descent degeneration; neither is
by itself a stable obstruction.

This corrects the tempting inference that a rational fixed divisor makes
stable linearization likely. It also corrects the opposite inference that a
positive-genus fixed curve automatically prevents stable linearization.

## Reproducibility

Generator and certificate:

- `notes/2026-08-13-c907-fermat-tangent-involution.sage`
- `notes/2026-08-13-c907-fermat-tangent-involution.json`

Hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| generator | 4567 | `91fda1242a035eca6ba5bafc69d79af4ec2b5fea29735ebbc41fbb1ed92025d1` |
| certificate | 996 | `c054495ad315e2b309144b424c0cad7bdcfbc7e3b4e708d0254515e9f082d13f` |

Replay from the repository root:

```text
~/.claude/bin/run-quiet "nix shell nixpkgs#sage --command sage notes/2026-08-13-c907-fermat-tangent-involution.sage --check notes/2026-08-13-c907-fermat-tangent-involution.json"
```

The replay checks the polar factorization, involutivity, equality of the
residual-point coordinates, the fixed-field relation, smoothness of (3), and
its linear Fermat transformation. The second endpoint uses the exact ambient
coordinate-pair symmetry rather than a second symbolic chart. No finite
search is promoted to a nonexistence theorem. The equality of all five image
coordinates is an invariant cross-check independent of merely squaring the
displayed involution; the plane-cubic Jacobian saturation and its explicit
linear Fermat change are likewise separate checks of the fixed-curve claim.

## AA / EJ / TT and mystery ledger

- **AA:** raw line projection, independent-variable Brauer splitting, and
  stable linearization as a supposedly easier quotient problem are closed.
  The surviving opposite attacks must change the fibration or construct a
  genuinely mixed birational map.  The clean graph-resolution
  `H^1(C_2,Pic)` test also vanishes; only the compactification-boundary
  correction to that lattice remains.
- **EJ:** formula (1) is an exact Cremona involution attached to the Fermat
  cubic. Formula (2) compresses its quotient to one conic, while the two
  \(j=0\) fixed curves explain how the split Fermat discriminant is retained
  after contracting the rational fixed divisor.  Formula (2a) gives a
  nonzero residue proof that even two free stabilization variables do not
  produce a section of this fibration.
- **TT:** rational quotient does not imply linearizable action; conversely,
  a fixed elliptic curve in codimension two contributes the zero ordinary
  Burnside symbol when both normals are sign. Neither shortcut settles
  stable rationality.
- **Settled:** exact involution, fixed field, nonsplitting of its generic
  conic after two independent variables, two elliptic residues, their normal
  characters, failure of the elementary Burnside test, and vanishing of the
  clean two-center graph-resolution Picard obstruction.
- **Open:** a finer stabilized equivariant invariant of (1), or a mixed
  two-variable transformation of (2). The standard no-name, fixed-divisor,
  and ordinary Burnside data are exhausted.
