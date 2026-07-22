# C484 — coherent semilinear descent

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete.

## Result

Let `k=F_q`, let `sigma:x |-> x^p` generate `Gal(k/F_p)`, and let a coherent family of labelled
projected sextics be given on the C482 reconstruction open.  Frobenius acts coefficientwise on
every normalized view, compatibility row, camera gauge, parent coordinate, and Gale coordinate.
All reconstruction maps commute with this action.  In particular, for

```text
x=(a,b,c,d,bc,ad),                x#=Gale(x),
```

one has

```text
sigma(x#)=Gale(sigma(x)),
sigma(L0(x))=L0(sigma(x)),
sigma(L1(x))=L1(sigma(x)).                              (1)
```

The pure four-view fibre is therefore a Frobenius-stable Gale pair off the conic divisor and a
single ramified sheet on it.  On the unramified labelled locus, choosing one geometric sheet `x`
defines the exact descent cocycle

```text
epsilon_x(gamma) in C2,       gamma(x)=Gale^epsilon_x(gamma)(x).      (2)
```

Because Gale association is defined over the prime field and commutes with every field
automorphism, `epsilon_x` is a `C2` cocycle; changing sheets changes no class.  A sheet is defined
over `F_q` exactly when the restriction of (2) to the absolute `q`-Frobenius is trivial.  If it is
nontrivial, the two sheets are exchanged and first become individually rational over `F_(q^2)`.
On the conic/GRS ramification divisor the sheets coincide and there is no sheet obstruction.

The local tests from C483 globalize without choosing a global sheet coordinate:

- in odd characteristic, `delta_i=tau_i^2` has a chart-independent square class because
  `tau_i/tau_j` is an invariant unit; a sheet is rational exactly when `delta_i` is a square;
- in characteristic two, `kappa_i=eta_i^2+eta_i` has chart-independent absolute trace because
  `kappa_j-kappa_i=a_ij^2+a_ij`; a sheet is rational exactly when
  `Tr_(F_q/F_2)(kappa_i)=0`.

Thus the geometric double cover has the usual Kummer realization in odd characteristic and the
Artin--Schreier realization in characteristic two.  This is the only possible two-sheet field
obstruction.  The multiplicative, additive, quotient-line, and projective camera gauges contribute
no further class over a finite field: Hilbert 90 and Lang descent kill those connected-gauge
cocycles, while C475's explicit edge-torus transporter already gives the same conclusion without
an abstract existence argument.

For a diagonally unlabelled target, let `H` be its common diagonal `S6` stabilizer and let

```text
chi:H -> C2
```

be its action on the Gale pair.  If `pi` is a Frobenius label transporter, so that
`sigma(c)=pi.c`, define `epsilon_(pi,x)` by comparing `pi^-1 sigma(x)` with `x`.  Replacing `pi`
by another allowed transporter changes `epsilon_(pi,x)` by an element of `chi(H)`.  Hence the exact
unlabelled effectivity criterion is

```text
epsilon_(pi,x) in chi(H).                               (3)
```

When the two unlabelled sheets remain distinct, `chi(H)=0` and (3) reduces to the ordinary
Kummer/Artin--Schreier test.  If `chi(H)=C2`, the stabilizer itself identifies the sheets; descent
is then effective in the quotient, but reconstruction is not sheet-unique.  This is precisely the
finite-stabilizer exception isolated abstractly in C483.

Finally, the frozen q=8 control has no Hilbert--90 obstruction.  Exact extraction from the C478
certificate gives the colour-only Frobenius generator on the six coherent signatures as

```text
(0 4 1)(2 5 3).                                        (4)
```

The equivariant object has six singleton signatures.  Applying the colour-orbit coequalizer while
holding the four literal syndrome points fixed turns (4) into two fibres of size three.  This is a
free `C3` information-loss action on colours, not the `C2` Gale sheet cocycle, not descent from
`F_8` to itself, and not a failure of multiplicative or additive Hilbert 90.

## 1. Frobenius on the C482 gauges

Use C482's normalization

```text
h1=(1,0,0), h2=(0,1,0), h3=(0,0,1), h4=(1,1,1),
h5=(1,a,b), h6=(1,c,d).
```

For view `s`, its normalized projected sextic is `(A_s,B_s,C_s)`, its residual quotient gauge is
`beta_s`, and

```text
alpha_s=A_s(beta_s+1)-1,
K_s = [ 0       beta_s  1 ]
      [ alpha_s 0       1 ],
u_s=(beta_s,alpha_s,-alpha_s beta_s).                  (5)
```

If Frobenius sends the view index `s` to `sigma s`, equivariance means

```text
(A_(sigma s),B_(sigma s),C_(sigma s))
  =(sigma A_s,sigma B_s,sigma C_s).                    (6)
```

Applying `sigma` to (5) gives the same formulas for the transported view:

```text
beta_(sigma s)=sigma(beta_s),
alpha_(sigma s)=sigma(alpha_s),
K_(sigma s)=sigma(K_s),
u_(sigma s)=sigma(u_s).                                (7)
```

The recovery formula

```text
beta_s=(A_s-1+(1-B_s)b)/(B_s a-A_s)                   (8)
```

also commutes with Frobenius, including its denominator/non-denominator trichotomy.  Thus a unique
camera remains unique after transport, no camera remains no camera, and a free camera parameter
remains a transported affine parameter.

The compatibility row is

```text
m_s=(-B_s(A_s-1), -A_s(1-B_s), C_s(A_s-1), A_s(1-C_s),
     C_s(1-B_s), -B_s(1-C_s)).                         (9)
```

Every coefficient in (9) lies in the prime-field polynomial algebra on `A_s,B_s,C_s`.  Therefore

```text
m_(sigma s)=sigma(m_s),       M_(sigma T)=sigma(M_T),
ker M_(sigma T)=sigma(ker M_T).                        (10)
```

The product cubic

```text
F=x_X x_a x_d-x_Y x_b x_c                            (11)
```

is defined over the prime field.  Frobenius consequently transports every residual cubic section
`P(ker M_r) intersect V(F)`, preserving its dimension, rank-drop stratum, collision point, and
separability.  This proves equivariance not only on the generic double cover but on the complete
C483 exceptional-fibre table.

## 2. Equivariance of the Gale cover and discriminant

For a `3 x 6` parent matrix `H`, Gale association takes the projectivized columns of any matrix
whose row space is `ker(H)`.  Since

```text
ker(sigma H)=sigma(ker H),                              (12)
```

this definition immediately proves the first identity in (1), independently of the normalized
chart.  Column rescaling, `GL_3` row bases, parent `PGL_3`, and diagonal `S6` relabelling all commute
with (12).

On the normalized chart,

```text
L0=bc+a+d-ad-b-c,
L1=abc+bcd+ad-abd-acd-bc.                              (13)
```

The kernel cubic and residual quadratic are

```text
Q(se+tx)=st(L0 s+L1 t),
q(s,t)=s(L0 s+L1 t),
Disc(q)=L1^2.                                          (14)
```

Equations (13)--(14) have integral coefficients.  Frobenius therefore preserves the universal
collision factor, the two residual roots, and the reduced ramification equation `L1=0`.  The
intrinsic identities

```text
L0=-det(h4,h5,h6),
L1=det(v2(h1),...,v2(h6))                              (15)
```

show that this is independent of the frame: the boundary divisor and conic divisor are both
Frobenius-stable.  In characteristic two separability is still `L1 != 0`; no discriminant formula
requiring division by two has entered.

The complete-child cut is equally equivariant.  Applying Frobenius to

```text
g(ell_s)=u'_s,                   g(L)=U(A')             (16)
```

gives the same equations for the transported child, centres, and parent.  Every determinant
nonvanishing equation and every complementary secant-covering product in C483 is defined over the
prime field.  Thus the restriction map `Sigma_T` is a map of Frobenius sets.  Its injectivity, when
assumed or certified, descends with it.

## 3. The sheet cocycle and its global local tests

Let `y` be a rational point of the pure reconstruction target on the rank-four, unique-camera,
unramified open, and let

```text
P_y={x,iota x},             iota=Gale.                  (17)
```

Equation (12) makes `P_y` a two-point Frobenius set and makes `iota` commute with Frobenius.  For a
chosen sheet, (2) obeys

```text
epsilon_x(gamma delta)=epsilon_x(gamma)+epsilon_x(delta) in C2.       (18)
```

For the absolute Galois group of a finite field, (18) is determined by the arithmetic Frobenius.
The fixed-point criterion proves the asserted effectivity statement.  If the value is nonzero,
Frobenius swaps two points and its square fixes both, so the exact first field of sheet definition
is quadratic.

In odd characteristic, C483 supplies local anti-invariant coordinates

```text
tau_i#=-tau_i,             tau_i/tau_j=r_ij,
r_ij#=r_ij,                r_ij r_jk=r_ik.             (19)
```

The target coordinate is `delta_i=tau_i^2`.  On overlaps,
`delta_i=r_ij^2 delta_j`, so all charts give one class in `F_q^*/F_q^{*2}`.  This class is trivial
exactly when a rational `tau_i`, hence a rational sheet, exists.  At `delta=0` the cover is
ramified and the single sheet is already rational.

In characteristic two, the local coordinates satisfy

```text
eta_i#=eta_i+1,
kappa_i=eta_i^2+eta_i,
eta_i+eta_j=a_ij,
kappa_j-kappa_i=a_ij^2+a_ij.                            (20)
```

Absolute trace kills the last overlap term, so `Tr(kappa_i)` is chart-independent.  The standard
finite-field identity

```text
image(t |-> t^2+t)=ker(Tr_(F_q/F_2))                   (21)
```

then gives the exact sheet criterion.  If the trace is one, the two roots are exchanged by
Frobenius and lie over the quadratic extension.  The pole of this affine chart at the conic fixed
divisor is harmless because that divisor is handled directly as the ramified singleton.

Equations (19)--(21) are the promised globalization: no global `tau` or `eta` is asserted.  Their
transition data make the square class or trace the intrinsic obstruction.

## 4. Gauge descent and the finite diagonal stabilizer

There are three logically separate descent layers.

1. **Connected gauges.**  Column scales, determinant scales, quotient-line bases, and camera
   projectivities are connected linear/projective gauge groups.  Over a finite field their
   Frobenius cocycles are effective by multiplicative/additive Hilbert 90 and Lang's theorem.
   C475 additionally constructs the required edge-torus transporter explicitly.  These gauges
   never change the bit (2).
2. **The Gale sheet.**  The residual degree-two finite etale cover has the `C2` class (2).  It is
   not a connected-gauge cocycle and can be nontrivial.  Equations (19)--(21) test it exactly.
3. **Finite label stabilizers.**  Passing from a labelled coherent tuple `c` to its diagonal
   `S6` orbit retains a finite stabilizer `H`.  This is not covered by Hilbert 90 and must be kept
   in the transporter criterion (3).

To prove (3), choose `pi` with `sigma(c)=pi.c`.  Equivariance gives
`pi^-1 sigma(x)` in the same two-point fibre as `x`, hence defines `epsilon_(pi,x)`.  Every other
valid transporter is `pi h` for some `h in H`.  Acting by `h` changes the sheet comparison by
`chi(h)`, and these are all possible changes.  Therefore some transporter fixes the chosen
unlabelled sheet exactly when `epsilon_(pi,x)` lies in `chi(H)`.

This formulation also covers the orbifold locus without pretending that a nontrivial stabilizer
is harmless.  If `chi(H)=0`, the two quotient sheets are distinct and the field test is unchanged.
If `chi(H)=C2`, a stabilizer element carries one labelled parent to its Gale associate.  The
unlabelled target then has one quotient sheet, but it has lost the distinction the reconstruction
theorem would otherwise make.  This is effectivity with non-uniqueness, not a repaired rational
inverse.

## 5. Exact q=8 specialization

The q=8 C478 control consists of six parents above one literal four-point complete child.  For
each parent, retain the coherent family of four atlas colours modulo one diagonal `S6`, but do not
quotient the field colours.  These six signatures are pairwise distinct.

The C484 extractor applies `x |-> x^2` simultaneously to all 120 atlas colour coordinates while
holding the ordered literal syndrome domain fixed, then re-canonicalizes only by diagonal `S6`.
In the canonical parent order recorded in the certificate, the three powers act by

```text
1:          [0,1,2,3,4,5],
sigma:      [4,0,5,2,1,3],
sigma^2:    [1,4,3,5,0,2].                             (22)
```

Thus `sigma` has the exact cycle decomposition (4); its square is the second line composed with
itself, and its cube is the identity.  There are no fixed signatures and no shorter orbit.

This computation distinguishes two functors:

```text
equivariant family:      sigma acts on domain and colours together;
colour-orbit quotient:   domain held fixed, colours coequalized by <sigma>.              (23)
```

The first retains six singleton parent signatures.  The second replaces the six-element set by
the two orbits in (4).  Since every parent and every recorded atlas value is already over `F_8`,
this is not failure of rationality over `F_8`.  Since the action has order three, it cannot be the
order-two Gale deck class.  And since (23)'s second functor deliberately omits the domain action,
it is not a Galois descent datum for the coherent family at all.  It is exactly erased relative
colour orientation.

The frozen two-centre restriction gives one further exact partition of the same parent order:

```text
{0,5}, {1,2}, {3,4}.                                   (24)
```

Its fixed-point-free pairing commutes with the colour generator (4).  Together they act regularly
as

```text
C3 x C2 = C6
```

on the six parents.  This proves a product structure for this specific frozen two-centre
restriction, rather than inferring one from `6=2*3`.  The `C2` in (24) is the child-relative
two-centre ambiguity; the extraction does not identify it with the ambient four-view Gale deck
involution, because the fixed-child cut need not preserve Gale pairs.

No new field or parent census was performed.  The extractor consumes the frozen C398 parent and
C478 atlas inputs and adds only the permutation calculation implicit in their existing six versus
`3+3` counts.

## Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c484-coherent-semilinear-descent.md
notes/2026-07-22-c484-coherent-semilinear-descent.py
notes/2026-07-22-c484-coherent-semilinear-descent.json
notes/2026-07-22-c484-coherent-semilinear-descent.sha256
```

Replay from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c484-coherent-semilinear-descent.py --check
sha256sum -c notes/2026-07-22-c484-coherent-semilinear-descent.sha256
```

The checker loads the hash-pinned C398/C474/C478 scripts and JSON certificates, reconstructs only
the frozen q=8 six-parent fibre, verifies that the six diagonal coherent signatures are distinct,
and computes every colour-Frobenius power.  It then verifies the group law, the two exact
three-cycles, agreement with C478's stored singleton and `3+3` fibre sizes, the frozen two-centre
pairing, and the resulting regular `C6` action.  The JSON records all load-bearing input hashes and
byte counts, the canonical parent order, and the explicit permutations.

The checker is `10,665` bytes and the canonical JSON certificate is `6,612` bytes; the checksum
manifest pins both together with this report.

There is no new independent finite-geometry replay: the claim is an exact extraction from the
already independently replayed C478 frozen control, and duplicating its parent enumeration would
be a second census forbidden by the task boundary.  The new check has two internal routes to the
same conclusion: direct permutation of the six equivariant signatures and comparison with C478's
independently frozen orbit-fibre sizes.  The all-field descent theorem is the algebraic proof in
Sections 1--4; the q=8 artifact certifies only the specialization in Section 5.

Trusted boundary: Python exact integer/GF(8) arithmetic in the hash-pinned C398 implementation,
the frozen C474 semilinear child stabilizer, the C478 atlas canonicalization, JSON serialization,
and the algebraic C481--C483 theorems cited above.

## Extra-juice closeout

Three cheap consequences sharpen the result.

First, the sheet obstruction has a single intrinsic value even though neither local coordinate is
global: an odd-characteristic square class or a characteristic-two trace bit.  This is the exact
finite-field invariant C485 can state algorithmically.

Second, diagonal stabilizers do not create a mysterious third obstruction.  Their whole effect is
the image `chi(H)` in (3): either they leave the sheet test unchanged or they identify the two
sheets and destroy uniqueness.  Connected gauges remain unobstructed.

Third, the q=8 factorization is stronger than the numerical equality `6=2*3`: the generator is
free with exact cycle type `3+3`, while the Gale ambiguity is order two.  The two mechanisms are
therefore separated by their actions, not merely by interpretation.

Fourth, the frozen two-centre ambiguity commutes with colour Frobenius and upgrades the six-parent
set to a regular `C6=C3 x C2` object.  This is an honest product theorem for that restriction, with
the important type annotation that its `C2` is child-relative and has not been identified with
Gale association.

## Requested second extra-juice pass

The descent bit has an exact extension-tower law.  If `b=epsilon_x(Frob_q) in C2`, then over
`F_(q^m)` the arithmetic Frobenius is `Frob_q^m`, so

```text
epsilon_x(Frob_(q^m))=m b in C2.                        (25)
```

Consequently a nontrivial Gale pair remains nonsplit over every odd-degree extension and splits
over every even-degree extension; its exact minimal splitting field is `F_(q^2)`.  This agrees
chartwise with both local models:

```text
odd characteristic:  a nonsquare in F_q becomes a square in F_(q^m) iff m is even;
characteristic two:  Tr_(F_(q^m)/F_2)(kappa)=m Tr_(F_q/F_2)(kappa).
```

Thus C485 can state one uniform extension algorithm: compute the base square-class/trace bit, and
read every finite extension from parity—no repeated reconstruction or field-specific case split.
With a diagonal stabilizer, the same statement holds after passing from `C2` to the quotient
`C2/chi(H)` prescribed by (3).

## Requested third extra-juice pass

The q=8 control carries an exact information-loss diamond.  On the canonical parent order, the
equivariant restriction partitions are

```text
one centre:    {0,1,2,3,4,5},
two centres:   {0,5} | {1,2} | {3,4},
three centres: {0} | {1} | {2} | {3} | {4} | {5},     (26)
```

while the colour-orbit quotient is

```text
{0,4,1} | {2,5,3}.                                     (27)
```

Equations (26)--(27) realize all four subgroup quotients of the regular `C6=C3 x C2` action:

```text
quotient by C6  -> 1 fibre of 6,
quotient by C3  -> 2 fibres of 3,
quotient by C2  -> 3 fibres of 2,
quotient by 1   -> 6 fibres of 1.                      (28)
```

The `C3` and `C2` partitions are transverse: every intersection contains one parent.  Explicitly,
the `(C3 orbit,C2 orbit)` coordinates of parents `0,...,5` are

```text
(0,0), (0,1), (1,1), (1,2), (0,2), (1,0).             (29)
```

This turns the frozen recovery threshold into a typed quotient theorem.  One centre forgets the
whole regular coordinate, two centres retain the `C3` coordinate, colour orbiting retains the
`C2` coordinate, and three equivariant centres retain both.  Again, the `C2` coordinate here is
the selected fixed-child restriction ambiguity, not an asserted Gale coordinate.

## Mystery ledger

| Feature | Closeout status | Exact remaining gap / owner |
|---|---|---|
| Frobenius action on every C482 variable | settled | Equations (5)--(11) are coefficientwise and prime-field defined. |
| Equivariance of Gale, ramification, rank drops, and child cut | settled | Equations (12)--(16) cover the full C483 table. |
| Global sheet obstruction in odd characteristic | settled | The overlap-invariant square class of `tau_i^2` is exact. |
| Global sheet obstruction in characteristic two | settled | The overlap-invariant trace of `kappa_i` is exact. |
| Connected gauge descent | settled | Hilbert 90/Lang, plus C475's explicit transporter, leave no extra class. |
| Finite diagonal-stabilizer descent | settled | Criterion (3) is necessary and sufficient; a sheet-swapping stabilizer means non-uniqueness. |
| q=8 `3+3` mechanism | settled by the frozen extraction | Colour Frobenius acts as `(0 4 1)(2 5 3)`; the quotient erases a free `C3` orientation. |
| q=8 two-centre residual symmetry | settled by the requested extra-juice pass | Pairing `(0 5)(1 2)(3 4)` commutes with colour Frobenius and gives a regular `C6`; it is not asserted to be Gale. |
| q=8 information-loss lattice | settled by the third extra-juice pass | The `6 / 3x2 / 2x3 / 1x6` partitions are exactly the `C6 / C3 / C2 / 1` subgroup quotients, with transverse product coordinates (29). |
| Whether q=8 is a Hilbert--90 class | settled negatively | It is a colour-only finite coequalizer, distinct from both connected gauges and the Gale `C2` cover. |
| Behaviour over `F_(q^m)` | settled by the second extra-juice pass | The obstruction restricts to `m b`; odd degrees preserve it and even degrees split it. |
| All-field reconstruction synthesis | open | C485 owns assembly and must keep child-relative recovery conditional on injectivity of `Sigma_T` outside the four frozen controls. |

No genuine C484 mystery remains.

## Vibe check

Strong.  Descent introduces no hidden all-field exception: the only geometric bit is the expected
Gale double-cover class, finite label stabilizers have an exact quotient criterion, and q=8's
order-three collapse is now an explicit free colour action rather than an analogy.
