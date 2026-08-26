# C949 focused snapshot — the bounded transverse Redei core

**Date:** 2026-08-26

**Scope:** balanced triangular `(4,-3)`, `eta=1` branch only.

This note starts from `(SR24a-low-pencils)` and
`(SR24a-Redei-cubic)` in
`notes/2026-08-26-c949-structural-proof-snapshot.md`.  It proves the exact
split-product restriction and compresses both canonical Redei quotients to a
bounded pair of nine-coefficient cubics.  It does not prove that the pair is
inconsistent.

## Setup

Let `D` be the balanced minimal blocking `(2q+4,4)`-arc and choose a generic
point `T in D`, so `d_3(T)=0`.  Take a tangent at `T` as the affine line at
infinity and use `T` as the omitted direction.  Put

```text
D_aff=D\{T},
R(X,M)=product_((a,b) in D_aff)(X-b+Ma),
F=X^q-X,  G=M^q-M.
```

Canonical division gives

```text
R=FQ+GH,  deg_X H<q,  deg Q,deg H<=q+3.            (TR1)
```

Let `V_i=(a_i,b_i)` be the three external zero-triangle vertices,

```text
t_i(M)=b_i-Ma_i,
L_i=X-t_i(M),
B_0=product_(i=1)^3 L_i.
```

The exact low-pencil theorem and global interpolation give

```text
Q=B_0 C_0(X^3,M)+G E,
deg_X E<3,  deg E<=3.                              (TR2)
```

There are three connector slopes `sigma_12,sigma_13,sigma_23`.  In the
flag-adapted normal form

```text
V_1=(0,0), V_2=(1,0), V_3=(s,1),  s notin {0,1},
```

they are `0,1/s,1/(s-1)`.

## Exact split-product restriction

The line `V_iT` is a bisecant because `T` is generic.  After removing `T`,
its other `D` point contributes a nonzero constant to
`R(t_i(M),M)`.  Among the `q` finite directions through `V_i`, exactly
`q-2` are bisecants and the two connector directions are trisecants.
Therefore, for some `lambda_i in F_q^*`, exactly

```text
R(t_i(M),M)
 =lambda_i G(M)^2
  (M-sigma_ij)(M-sigma_ik).                        (TR3)
```

Since `t_i^q-t_i=-a_iG`, evaluating `(TR1)` on `L_i=0` and using `(TR2)`
gives

```text
H(t_i(M),M)
 =G(M)[a_i E(t_i(M),M)
       +lambda_i(M-sigma_ij)(M-sigma_ik)].          (TR4)
```

This is the desired pre-specialization split-product identity.  By itself it
does not kill a coefficient of `E`: it prescribes `H` on three moving lines,
while `H` still has field-size degree.

## The companion 18-coefficient remainder

Divide `H` by the monic cubic `B_0`:

```text
H=B_0D+S,  deg_X S<3,  deg S<=q+3.                 (TR5)
```

For every nonconnector field slope, the three roots of `B_0(X,m)` are
distinct and `(TR4)` makes `H` vanish at all three.  Hence `S(X,m)=0`.
Define

```text
K(M)=product_(sigma in {sigma_12,sigma_13,sigma_23})(M-sigma),
P_good(M)=G(M)/K(M).
```

Coefficientwise divisibility by the `q-3` nonconnector roots gives

```text
S=P_good T_6,
deg_X T_6<3,  deg T_6<=6.                           (TR6)
```

The bivariate space in `(TR6)` has `7+6+5=18` coefficients.

At a connector `m=sigma_ij`, write

```text
B_0(X,m)=(X-c)^2(X-d),  c!=d.
```

Differentiate `(TR4)` along the two moving roots `t_i,t_j`.  Since
`G'(m)=-1`, subtraction gives

```text
H_X(c,m)=E(c,m),  H_M(c,m)=0.                      (TR7)
```

Because `B_0(c,m)=B_(0,X)(c,m)=0`, the remainder has
`S(c,m)=S(d,m)=0` and `S_X(c,m)=E(c,m)`.  Thus its connector fiber is exactly

```text
T_6(X,m)
 =E(c,m)/[P_good(m)(c-d)] (X-c)(X-d).              (TR8)
```

## Canonical nine-plus-nine core

For each coefficient of `X^i`, interpolate the three connector values in
`(TR8)` by the unique polynomial of `M`-degree less than three.  Let the
resulting quadratic-in-`X` polynomial be `I_E(X,M)`.  It depends linearly
only on the three connector evaluations of `E` and satisfies

```text
deg_X I_E<3,  deg_M [X^i]I_E<3,  deg I_E<=4.
```

Now `T_6-I_E` vanishes at all three connector slopes, so `K` divides it.
Set

```text
U=(T_6-I_E)/K.
```

The coefficient of `X^i` in `T_6` has `M`-degree at most `6-i`; division by
the cubic `K` therefore gives

```text
deg_X U<3,  deg U<=3.                              (TR9)
```

Combining `(TR2)`, `(TR5)`, and `(TR6)--(TR9)` yields the exact paired form

```text
Q=B_0 C_0(X^3,M)+G E,
H=B_0 D+P_good I_E+G U,                            (TR10)
deg_X E,deg_X U<3,
deg E,deg U<=3.
```

Thus the two canonical Redei quotients have a genuine bounded symbolic core
of **nine plus nine coefficients**.  Unlike the earlier false count using
`E` and its reciprocal transform, `E` and `U` arise from the two different
canonical quotient remainders.

## Scope and red-team boundary

`(TR10)` is compression, not closeout.  The high-degree quotients `C_0,D`
remain.  Every finite field slope kills both `G E` and `G U`, so the integer
line spectrum alone constrains neither cubic.  A contradiction requires a
global relation between them, most plausibly:

1. an `X/M` reciprocal transition for the full quotient pair `(Q,H)`;
2. a Witt lift that computes the transverse derivatives in `(TR7)`;
3. the split norm/coherence identities for the balanced carrier;
4. a bounded q=27 rejection core rewritten in the coordinates `(E,U)`.

The 18-dimensional space in `(TR6)` and the pair `(E,U)` are not yet
identified with C962's carrier coordinates.  C962 uses two univariate
degree-`r-1` polynomials, of dimension `2r`; that dimension equals 18 only at
`q=27`.  An explicit carrier-to-Redei map is still required.

## Exact two-tangent transpose

The natural reciprocal comparison uses two tangent charts, not the formal
substitution `M -> M^(-1)` inside one chart.  Choose projective coordinates
so that

```text
C=0 is tangent at T_infty=[1:0:0],
A=0 is tangent at T_0=[0:0:1],
tau[A:B:C]=[C:B:A].
```

Put `D^circ=D\{T_infty,T_0}`.  Every point of `D^circ` has `A,C` nonzero.
For the native affine products of `D` and `tau D`, direct comparison of the
linear factors gives

```text
X R_D(M,X)=lambda M R_(tau D)(X,M),
lambda=product_(P in D^circ) A(P)/C(P).             (TR11)
```

The factors `X,M` are essential: they are the two tangent endpoints omitted
in the respective affine products.  A bare equality of the two `R` products
is false.

Write the two canonical divisions as

```text
R_D=FQ_D+GH_D,
R_(tau D)=FQ_tau+GH_tau.
```

Substitution in `(TR11)` and coprimality of `F(X)` and `G(M)` give a unique
polynomial `L` with `deg L<=4` such that

```text
X Q_D(M,X)-lambda M H_tau(X,M)= F(X)L(X,M),
X H_D(M,X)-lambda M Q_tau(X,M)=-G(M)L(X,M).         (TR12)
```

This is the exact bounded Koszul transition for the full quotient pair.  The
quartic degree, rather than cubic degree, is forced by the two endpoint
factors.

The low-pencil cubics transform compatibly, but `(TR12)` does not close on
`(E,U)`.  After inserting `(TR10)`, the high quotients `C_0,D` remain and the
field factors absorb the bounded cores into `L`; reduction modulo `F` or `G`
erases the corresponding terms.  Moreover `tau` is a coordinate change, not
an automorphism of `D`.  Therefore no invariance equation or vanishing of the
three homogeneous reciprocal coefficients follows from transpose covariance
alone.  A successful reciprocal argument must independently control `L` or
the high quotients using the balanced norm/Witt data.

## Explicit carrier-to-Chow bridge

The balanced shear does supply an exact map from the carrier to the full
point product.  Use the simultaneous Frobenius coordinates of `(SR24t)` in
the structural snapshot:

```text
u=a^r,  t=b^r,  y=t+wu,
y^2-A(u^3)y+C(u^3)=0.
```

Let `U_0=A_0^r` be the three marked row values and `E_0=B_0^r` the three
other affine-axis values.  The zero-completed first carrier and affine core
are exactly

```text
S=Frob(H) union (U_0 times {0}),
B_aff^Frob=S union ({0} times E_0).                 (TR13)
```

For line-intercept variable `Zeta` and slope `m`, put

```text
Z_u=Zeta+(m+w)u.
```

If `y_1,y_2` are the two carrier roots over `u`, then the corresponding
points have `t_j=y_j-wu`, and hence

```text
product_(j=1)^2 (Zeta-t_j+m u)
 =(Z_u-y_1)(Z_u-y_2)
 =Z_u^2-A(u^3)Z_u+C(u^3).
```

Multiplying over all nonzero rows gives the exact zero-completed product

```text
P_car(Zeta,m)
 =product_(u in F_q^*)
   [Z_u^2-A(u^3)Z_u+C(u^3)].                       (TR14)
```

No transversal completion is assumed.  By `(TR13)`, the affine-core product
is simply

```text
R_(B_aff^Frob)(Zeta,m)
 =P_car(Zeta,m) product_(e in E_0)(Zeta-e).         (TR15)
```

If the three restored infinity points are `[u:t:0]`, the following is the
`W=1` affine dehomogenization of the Chow product of `D^Frob`, up to a
nonzero scalar:

```text
widehat R_(D^Frob)(Zeta,m)
 =P_car(Zeta,m)
  product_(e in E_0)(Zeta-e)
  product_([u:t:0] in R_infty)(m u-t).             (TR16)
```

The degree check is exact: `2q-2+3+3=2q+4=|D|`.  The rigorous homogeneous
form uses line coordinates `(Z,M,W)`.  Put

```text
L_u=Z+Mu+wuW.
```

Then

```text
Chow_D(Z,M,W)
 =product_(u!=0)[L_u^2-A(u^3)W L_u+C(u^3)W^2]
  product_(e in E_0)(Z-eW)
  product_([u:t:0] in R_infty)(Mu-tW).              (TR16h)
```

Any rational tangent chart is obtained by a contragredient linear projective
substitution in `(TR16h)`, dehomogenization, and division by the selected
tangent-point factor.  Canonical division by `X^q-X` and `M^q-M` then
computes `Q,H`, hence the bounded cores `E,U` and the two-tangent quartic
`L`.  Thus the carrier-to-Chow/Redei map is explicit and valid in both the
extendable and nonextendable branches.

This does not yet yield a bounded fourth-Witt equation.  Expanding `(TR14)`,
changing to a tangent flag, and performing the degree-`q` divisions mixes
all `q-1` carrier fibers and the marked boundary coordinates.  The existing
fourth-Witt gate controls selected top coefficients of `A`, but no proved
coefficient extraction carries it through `(TR14)--(TR16)` to a linear
functional of `E,U`, or `L`.  That extraction is now the precise algebraic
frontier; the absence of a carrier-to-Redei map is no longer the obstruction.

## Exact leading-layer extraction and its blind spot

There is nevertheless a sharp top-layer formula.  Put `N=2q+3`, the degree
of a tangent-chart point product, and let `R_N` be the total-homogeneous
degree-`N` part of

```text
R=(X^q-X)Q+(M^q-M)H,       deg_X H<q.
```

The two leading quotient layers are obtained by disjoint `X`-degree cuts:

```text
Q_(q+3)=X^(-q) [R_N]_(deg_X>=q),
H_(q+3)=M^(-q) [R_N]_(deg_X<q).                       (TR17)
```

Taking the top layer in `(TR12)` therefore gives the explicit homogeneous
quartic

```text
L_4=X^(-q)(X Q_(D,q+3)(M,X)-lambda M H_(tau D,q+3)(X,M)).   (TR18)
```

Likewise let `B_(0,3)=product_i(X+a_iM)` be the homogeneous cubic part of
`B_0`, and write

```text
E_3=e_03 M^3+e_12 XM^2+e_21 X^2M.
```

The degree-`q+3` part of `Q=B_0C_0+(M^q-M)E` yields

```text
M^q E_3=rem_X(Q_(q+3),B_(0,3)).                       (TR19)
```

Thus the reciprocal obstruction coefficients and `L_4` are computable
from the leading tangent-direction Chow form.  This is an exact bounded
extraction, but it does not yet connect them to fourth Witt.

Indeed, in the original balanced-shear affine chart, the top homogeneous
part of the zero-completed carrier product is universally

```text
(Zeta^(q-1)-m^(q-1))^2,
```

and the three affine-axis factors make the top affine-core layer

```text
Zeta^3 (Zeta^(q-1)-m^(q-1))^2.                        (TR20)
```

It is independent of `A,C,w`, whereas the fourth-Witt scalar uses the top
four carrier coefficients.  Therefore the original leading layer cannot by
itself transport the fourth-Witt gate.  This is a method boundary, not an
absolute independence theorem: the contragredient change to an actual
tangent flag can mix lower Chow layers into the new directional leading
form, and the flag depends on `D`.  Any successful bridge must compute that
reflagging from lower/full Chow data.

The first lower layer is already completely explicit.  Write

```text
A(X)=sum_(h=0)^(r-1) a_h X^h,
G=Z^(q-1)-M^(q-1).
```

For the homogeneous carrier bulk in `(TR16h)`, one has

```text
P_car(Z,M,W)=G^2+W P_1+O(W^2),

P_1=G[ a_0 Z^(q-2)
       +sum_(h=1)^(r-1)(-1)^h a_h Z^(3h-1)M^(q-1-3h)
       -w M^(q-2)].                                  (TR21)
```

To prove `(TR21)`, take the `W` coefficient in each quadratic factor and
use

```text
G sum_(u!=0) 1/(Z+Mu)=-Z^(q-2),
G sum_(u!=0) u^k/(Z+Mu)
 =(-1)^(k-1)Z^(k-1)M^(q-1-k),  1<=k<=q-2.
```

Thus every coefficient of `A` is linearly readable from the first normal
Chow layer.  In particular, for `k=1,2,3,4`, the coefficient `a_(r-k)` is,
up to the displayed sign, the coefficient of

```text
Z^(q-3k-1) M^(3k-1)
```

in `P_1/G`.  Hence the complete fourth-Witt input
`a_(r-4),...,a_(r-1)` and `Delta_A` is already present one layer below
`(TR20)`; `C` first enters at order `W^2`.

For the full product the boundary correction is also explicit.  If
`product_(e in E_0)(Z-eW)=Z^3-e_1(E_0)Z^2W+...` and
`Phi=product_(R_infty)(Mu-tW)=Phi_0+W Phi_1+...`, its `W` coefficient is

```text
Phi_0[Z^3P_1-e_1(E_0)Z^2G^2]+Phi_1Z^3G^2.           (TR22)
```

One must not divide by `Phi_0` when it vanishes.  Equations `(TR21)--(TR22)`
do not yet transport fourth Witt to `E_3` or `L_4`: a general tangent
reflag restricts `(TR16h)` to a new infinity plane and can mix all original
`W` layers.  They sharpen the live frontier to computing that restriction,
not discovering where the carrier coefficients enter.

There is a useful cube-root compression of `(TR21)`.  Define the binary form

```text
B_A(Z,M)=sum_(h=1)^(r-1)(-1)^h a_h^r
                         Z^(h-1)M^(r-h-1).
```

Since `x -> x^r` is the inverse of cubing on `F_q`, one has exactly

```text
P_1/G=a_0Z^(q-2)-wM^(q-2)+Z^2M^2 B_A(Z,M)^3.        (TR23)
```

If the leading tail of `B_A` is

```text
b_0Z^(r-2)+b_1Z^(r-3)M+b_2Z^(r-4)M^2+b_3Z^(r-5)M^3,
```

then

```text
(b_0,b_1,b_2,b_3)
 =(a_(r-1)^r,-a_(r-2)^r,a_(r-3)^r,-a_(r-4)^r),
Delta_A=b_0b_2-b_1^2.                               (TR24)
```

Thus fourth Witt is a marked tail jet/catalecticant expression of one binary
cube root.  The marking matters: this individual tail minor is not a
`PGL_2` covariant, and a general change of flag mixes it with all coefficients.

The tangent-reflag obstruction is exact.  Fixing a tangent as infinity and
changing only the affine origin applies a `GL_2` change to the restriction
of `Chow_D` to that line-variable plane; it cannot introduce the normal
polar `(TR21)`.  If a different tangent has equation

```text
W=-(alpha Z+beta M)/gamma
```

in the carrier flag, then its restriction is

```text
sum_j (-(alpha Z+beta M)/gamma)^j P_j(Z,M),          (TR25)
```

where `P_j=[W^j]Chow_D`.  The carrier infinity line is a trisecant, so no
actual tangent has `alpha=beta=0`; every tangent restriction mixes all
normal layers.  Consequently neither an origin gauge nor an unweighted
average of the differently parameterized tangent `E_3` forms transports
`(TR24)` to `L_4`.  A valid bridge must supply a common marked-flag
normalization or a polynomial norm/Witt identity controlling the full sum
`(TR25)`.

There is a separate selector obstruction relevant to minimum-size
constructions.  `Chow_D`, `(E,U)`, and `(TR21)--(TR25)` are unweighted data
of the tight-line set.  A downward four-switch requires a **blocker-labeled**
fourfold point, four **arc-labeled** degree-one donors, and non-tight blocker
slack.  None of these labels or slacks is recorded by the unweighted Chow
form.  In the balanced `eta=1` branch the exact selector ledger has

```text
(b_1,b_2,b_3,b_4)=(2q(q-4)/3,2q,0,0),               (TR26)
```

so the required blocker-labeled fourfold point is absent identically even
though the unweighted arrangement has many fourfold points.  At `eta=2`,
`b_4` is at most one and is not forced.  Therefore no functional of the
current unweighted `E,U` or first polar can certify a downward construction
without a new marked-selector carrier or norm identity.

The exact marked rational Chow object is still available, but it is
q-scale.  With `O=B union U` the `3q-3` open side points and

```text
Theta_u=ell_T^3 product_(b in B)ell_b^2 product_(v in V)ell_v
        / product_(x in U)ell_x,
P_sel=ell_T product_(b in B)ell_b,
```

one has the exact Frobenius compression

```text
Theta_u product_(o in O)ell_o / product_(v in V)ell_v = P_sel^3.
                                                            (TR26-marked)
```

The cube map is bijective over `F_q`, so after the fixed three-side factor
this determines the marked tangent-plus-matching selector exactly.  It does
not make the selector bounded: `deg P_sel=q-2`.  Locally on a tight line its
divisor order is just `(SR16)`'s regularity balance, and in characteristic
three `dlog(P_sel^3)=0`.  Thus ordinary differential or unweighted Chow
operations erase the marker; a new mixed-incidence/norm identity is needed
to transport `(TR26-marked)` to `(E,U,L)`.

At `eta=1` the marked low selector nevertheless has an exact graph normal
form.  Join two vertices of `D` when their line is a bisecant.  The nine
exceptional vertices have degree one and the `2q-5` generic vertices degree
three.  The unique selected tangent is incident with a generic vertex
`v_0`; the selected `A_2` edges form a perfect matching on the remaining
`2q-6` generic vertices.  No selected edge meets `v_0` or an exceptional
vertex, and the complementary blocker-edge graph has degree sequence
`1^9,2^(2q-6),3^1`.  This is the selector compression `(v_0,tau,matching)`
from `(SR16)--(SR17b)`, not a new identification with C962's 714 mapping
tasks.  Tutte feasibility and all high-incidence/mapping gates remain.

More precisely, each of the three side colours restricts to a matching on
the generic vertices with three missing generic incidences.  No single
colour can supply the selector matching after deleting `v_0`.  For a fixed
generic `v_0`, feasibility is exactly

```text
odd(H[G\{v_0}] - X) <= |X|   for every X subset G\{v_0}.
```

The secant ledger fixes the almost-cubic coloured degree sequence but no
such odd cuts.  A new projective expansion theorem would have to turn an
odd cut into too many completed tri/four-secant pairs.  Computationally,
this is still a useful exact first gate: test all generic `v_0` and their
perfect matchings before invoking the q=27 carrier/mapping machinery.

The side colours nevertheless give an absolute matching-defect bound.  Let
`D_c` be the three generic vertices which colour `c` pairs to exceptional
vertices.  Its remaining edges form a perfect matching of `G\D_c`.  Hence
deleting an arbitrary marked vertex leaves matching deficiency at most four,
while choosing `v_0 in D_c` leaves exactly the other two vertices of `D_c`
unmatched and gives

```text
def_Tutte(H[G\{v_0}]) <= 2.                         (TR27)
```

Every generic vertex has tangent choices, so this marking is admissible.
The full selector exists iff an alternating path in the other two colours
joins the two exposed monomers (or an equivalent augmentation exists).
Abstract three-coloured degree data cannot force this: one may attach three
generic vertices to exceptions in all three colours and put three disjoint
perfect matchings on the rest, leaving three isolated generic vertices.
That countermodel is not asserted projectively realizable; it proves that
the next lemma must use the tri/four-secant completion geometry.

There is a second bounded reduction for direct two-colour augmentation.
For colours `i,j`, the union `M_i union M_j` consists of alternating cycles,
alternating paths with endpoints in `D_i triangle D_j`, and isolated common
defects `D_i intersect D_j`.  If a path joins two vertices of
`D_i\D_j`, flipping it matches those two monomers; marking the third vertex
of `D_i` completes the selector.  Otherwise every path pairs opposite
colours and induces a bijection

```text
phi_ij:D_i\D_j -> D_j\D_i.                         (TR28)
```

Thus failure of every direct two-colour proof is encoded by at most nine
defect vertices, their overlaps, and three cross-colour bijections.  This
does **not** compress the full selector to nine symbols: the third colour
has chords through the interiors of `Theta(q)` alternating paths/cycles and
may change augmentation and the off-core cap.  The bounded object is the
defect wiring; the path/cycle geometry remains q-scale.

## Explicit inverse duplex and a fivefold obstruction

Let `n=q-1`, choose primitive `g`, and put

```text
E_(x,epsilon)=(g^x,g^(epsilon-x)),   epsilon in {0,1}.
```

Delete `E_(0,0),E_(1,0),E_(3,1)`.  For `n>=8` the singleton exponent sets
in `a,b,a/b` are

```text
{0,1,3},  {0,-1,-2},  {0,2,5}.                    (TR29)
```

Thus all three projections have profile `1^3 2^(q-4)` and satisfy the
product gate.  The `a`- and `b`-matchings form a `2n`-cycle; deletion leaves
two even paths and the isolated vertex `v_0=E_(1,1)=(g,1)`, hence a raw
perfect matching of `H\{v_0}`.  That matching uses `q-4` edges of one
colour and violates `(SR19b)` for `q>=27`; no balanced selector is claimed.

Irrespective of the selector, the standard nine-boundary completion violates
the fourfold cap.  A forced boundary point `[0:beta:1]` and the primal point
`P_t=[beta^2 t:1:-beta]` give branch equations

```text
beta^2 t a^2-beta a+c=0,       c in {1,g}.
```

Their discriminants are `beta^2(1-t)` and `beta^2(1-gt)`.  For quadratic
character `chi`, the number of `t` making both nonzero squares is

```text
N=(q-1-chi(1-g)-chi(1-g^(-1)))/4 >= (q-3)/4.       (TR30)
```

For `q>=27`, exclude `t=0` and at most one value for each deleted line; at
least two choices remain.  Each gives four distinct retained generic lines
through `P_t`, and the boundary line is a fifth.  Hence the inverse duplex
fails the cap for every ternary `q>=27`.  This strengthens `(SR21)`'s
`q>=81` blocking obstruction, but only for this inverse two-conic family and
its standard boundary realization.

## SR23 collision saturation

The near-surjective ordinary projections are globally almost extremal.  For
an ordinary direction `m`, let `z_m<=6` be the number of empty intercepts,
let `h_(i,m)` count fibers of size `i`, and put

```text
E_m=q-5+z_m,
C_m=sum_i binom(i,2)h_(i,m)
   =E_m+h_(3,m)+3h_(4,m).
```

The three special directions contribute `q-4` pairs each, while every pair
of points of `H` has one direction.  Therefore, with `Z=sum_m z_m`,

```text
sum_ord (h_(3,m)+3h_(4,m))=q^2-7q+17-Z.            (TR31)
```

At fixed `E_m`, cap four gives the universal upper bound
`2E_m-epsilon_m`, where `epsilon_m=0` iff `z_m=2 mod 3` and is one
otherwise.  Its exact deficit is

```text
D_m=h_(2,m)+h_(3,m)-epsilon_m >= 0,
sum_ord D_m=2Z-sum_ord epsilon_m-7=O(q).            (TR32)
```

Thus the `Theta(q^2)` collision mass differs from the packing by ones and
fours optimum by only `O(q)` total units.

There is an equivalent directional Redei compression.  Reduce the intercept
product `P_m(T)` modulo `T^q-T`.  If `z_m=0` the remainder is zero; otherwise
it vanishes on the `q-z_m` occupied intercepts and hence equals their root
product times a residual of degree at most `z_m-1<=5`.  The remaining
theorem is cross-directional: synchronize these varying degree-five
residuals into a common carrier or contradiction.  Scalar saturation alone
does not even force one defect-free direction.

The six affine boundary points label those residuals more rigidly.  If
`B_6(T,m)` is their intercept product and `A_m(T)` the squarefree polynomial
of H-missing intercepts, then

```text
A_m(T) divides B_6(T,m).                              (TR33)
```

Away from the at most `binom(6,2)=15` directions where boundary intercepts
collide, `A_m` is indexed by one of only 64 labelled boundary subsets.  For
a boundary point `c_i`, membership is detected by the fixed product

```text
F_i(M)=product_(h in H)((y_i-y_h)-M(x_i-x_h));
```

the label is missing at slope `m` iff `F_i(m)!=0`.  In the intended balanced
geometry each label occurs in at least `r-4` ordinary missing patterns, so
`Z>=2q-24`.  These degree-`2q-5` functions are still below their
interpolation threshold.  The next missing input is a pairwise-intersection
or cap-four theorem for the six labelled tangent-direction sets, not a
64-pattern pigeonhole argument.

## A two-scalar global-division defect

Choose one boundary direction as infinity and divide the full affine product
monically:

```text
S(X,M)=(X^q-X)Q(X,M)+J(X,M),       deg_X J<q.
```

The `q-4` regular slopes have `Q=(X-d_m)G_m^3`, while either vertex slope
has `Q=(X^q-X)(X-t_v)`.  Put
`P_reg(M)=product_(m regular)(M-m)`.  Since `deg Q<=q+1`, regular-fiber
divisibility and characteristic-three differentiation give

```text
partial_X Q=A(X^3,M)+P_reg(M)(X p(M)+cX^4),
deg p<=3.                                             (TR34)
```

At a vertex, `partial_X Q=X^q+X+t_v`; hence `c=0` and

```text
p(v_i)=P_reg(v_i)^(-1),       i=1,2.                 (TR35)
```

Thus `p` has at most two remaining scalar parameters.  Equivalently,

```text
Q=X A_0(X^3,M)-X^2 P_reg(M)p(M)+B_0(X^3,M).
```

This is an exact pre-specialization bounded defect, not yet a carrier
theorem: `A_0,B_0` and `J` remain q-scale, and no proved reflag identifies
`p` with tangent-chart `(E,U)` or C962's carrier.

The two parameters localize exactly at the two finite boundary slopes.  For
such a slope `b`, write its profile as

```text
F=A_b(X)(X-s_b)C_b(X),  deg A_b=r-1, deg C_b=2r,
S_b=(X-s_b)C_b(X)^3,
```

where `A_b` is the **missing-root** polynomial.  If
`C_b^2=A_b Q_b+R_b`, `deg R_b<r-1`, then

```text
S_b=FQ_b+(X-s_b)C_bR_b,       deg((X-s_b)C_bR_b)<q.
```

Thus the global quotient specializes literally to `Q(X,b)=Q_b`, and

```text
p(b)=-[X^2]quo(C_b^2,A_b)/P_reg(b).                (TR36)
```

The vertical boundary direction supplies the missing condition directly.
Under the homogeneous substitution `M=1/N`, `X=-Y/N`, the transformed
remainder still has `Y`-degree below `q`.  At `N=0`, the vertical product is
`(Y-s)C(Y)^3`, which has no `Y^(q+2)` coefficient because its exponents are
only zero or one modulo three.  That coefficient is the leading coefficient
of `p`; hence

```text
deg p<=2.                                             (TR37)
```

The two vertex and two finite-boundary values therefore obey one exact
compatibility.  If `m_1,...,m_4` are those slopes and `y_i=p(m_i)` is given
by `(TR35)--(TR36)`, then

```text
sum_i y_i / product_(j!=i)(m_i-m_j) = 0.             (TR38)
```

This is the first overdetermining field-uniform quotient gate.  It is not
yet identified with fourth Witt or the reciprocal norm; those formulas use
different carrier coordinates and still require an explicit bridge.

Equivalently, let `L(M)` be the linear interpolant through the two vertex
values.  Then

```text
p(M)=L(M)+lambda(M-v_1)(M-v_2),
```

and the two finite-boundary quotients must give the same scalar

```text
(p(b_1)-L(b_1))/((b_1-v_1)(b_1-v_2))
 =(p(b_2)-L(b_2))/((b_2-v_1)(b_2-v_2)).             (TR39)
```

There is also a cheap top-coefficient form.  Since `deg p<=2`,
`[X^2 M^(q-1)]Q=0`; taking the corresponding coefficient of
`S=(X^q-X)Q+J` yields

```text
e_(q-1)({a(P):P in B_aff})=0.                       (TR40)
```

In the normalized q=27 flag this is the constant-time filter `e_26(a)=0`.
It is coordinate-gauge dependent and cannot be applied to C962's 714 tasks
until the carrier-to-this-Redei-flag map is made explicit.

This dependence is substantive.  In the original balanced-shear carrier
flag, `(TR20)` has

```text
[Zeta^(q+2)m^(q-1)] Zeta^3(Zeta^(q-1)-m^(q-1))^2=1,
```

not zero.  There is no contradiction: the boundary reflag and completion
factors mix the full Chow layers into the new coefficient.  Any proposed
carrier compiler must reproduce the `1 -> 0` cancellation from the complete
reflagged product; evaluating `(TR40)` on raw carrier variables is invalid.

The construction has three bad boundary directions, and the entire argument
repeats with each one chosen vertical.  Intrinsically, for affine coordinates
`(u,t)` define the binary form

```text
Psi(alpha,beta)
 =e_(q-1)({alpha u(P)+beta t(P):P in B_aff}).
```

It has degree `q-1` and vanishes at the three covectors whose kernels are the
bad boundary directions.  If a direction is represented by `[u_i:t_i]`, its
root is `[alpha:beta]=[t_i:-u_i]`.  Hence the squarefree **dual** boundary
cubic divides it:

```text
B_R^vee(alpha,beta)
 :=product_i(u_i alpha+t_i beta)
 divides Psi(alpha,beta).                            (TR41)
```

This packages three chartwise `(TR40)` gates; it does not prove that they are
independent.  At q=27, after reconstructing all 55 affine-core points and
the three boundary directions, test all three `e_26` values before the
carrier/mapping gates.  Raw carrier rows do not yet carry the required flag.

The full carrier-to-Chow map makes this an exact post-terminal compiler
contract.  In one affine normalization put

```text
C_B(U,V,W)=product_(P=(u_P,t_P) in B_aff)
            (Uu_P+Vt_P+W).
```

Since `deg C_B=2q+1`, coefficient extraction gives

```text
Psi(U,V)=[W^(q+2)]C_B(U,V,W),
B_R^vee(U,V) divides [W^(q+2)]C_B(U,V,W).            (TR42)
```

At `q=27`, `C_B` has degree 55 and `Psi=[W^29]C_B` has binary degree 26.
The product in `(TR14)--(TR16)` constructs this `C_B` after completion and
boundary embedding.  If one starts from the degree-`2q+4` Chow form of `D`,
the three known infinity-point factors must first be omitted or divided out;
extracting the coefficient directly from `Chow_D` is wrong.  A completed
carrier terminal plus its resolved mapping and the fixed homogeneous
boundary convention therefore suffice for this cheap necessary filter.  A
raw carrier or unresolved mapping task does not.

Coordinate conversion is essential.  In `(TR16h)` an affine point factor is
`Z+Mu-tW`, so relative to the abstract convention above

```text
(U,V,W_aff)=(M,-W,Z).
```

Consequently the compiler extracts `[Z^(q+2)]C_B(Z,M,W)`, viewed as a binary
form in `(M,-W)`, not `[W^(q+2)]` of the displayed `(TR16h)` polynomial.
The latter is a different Chow coefficient and has no proved boundary-cubic
divisibility.  At q=27 the correct specialized coefficient is `[Z^29]`.

There is an exact univariate compiler that avoids root extraction and the
full 55-factor Chow expansion.  For a boundary direction `[u_i:t_i]`, put

```text
(alpha_i,beta_i)=(t_i,-u_i),
d_i=alpha_i-beta_i w.
```

For each `u in F_q^*`, the two carrier roots contribute

```text
h_(i,u)(z)=1+s_(i,u)z+p_(i,u)z^2,
s_(i,u)=2d_i u+beta_i A(u^3),
p_(i,u)=d_i^2u^2+beta_i d_i u A(u^3)+beta_i^2C(u^3).
```

Indeed this is the product of `1+(alpha_i u+beta_i(y-wu))z` over the two
roots of `y^2-A(u^3)y+C(u^3)`.  The three affine-axis completion points add
`product_(e in E_0)(1+beta_i e z)`.  Therefore

```text
Psi(alpha_i,beta_i)
 =[z^(q-1)] product_(u!=0)h_(i,u)(z)
               product_(e in E_0)(1+beta_i e z).    (TR43)
```

At q=27, keep only coefficients through `z^26` while multiplying 26
quadratics and three linears, and require the result to vanish for all three
boundary directions.  This uses only the completed carrier, resolved
mapping, and explicit Frobenius boundary frame.  Raw mapping columns must be
converted to the `E_0` coordinates of `(TR13)` first.  No implication from,
or independence of, the current fourth-Witt and norm gates is yet proved.

The three-value verdict respects the existing semilinear quotient.  Under
joint Frobenius transport of the carrier, mapping, affine core, and boundary
frame, projected point coordinates are cubed and the three boundary
directions are merely permuted.  Since `e_(q-1)` has prime-field
coefficients,

```text
g'_(sigma(i))=g_i^(3^j),
g_i=Psi(t_i,-u_i).                                  (TR44)
```

Projective rescaling only multiplies by a nonzero scalar, so the all-zero
verdict is invariant.  The gate may therefore be evaluated once on each of
the 714 **joint** carrier--mapping orbit representatives.  Transporting only
the mapping while fixing an arbitrary carrier or boundary frame is invalid.

For the current Rust terminal, run this only as a post-terminal C949 audit.
The constructor has `columns=t` and `ratios=t/u`, so conditional on the paper
frame the natural restored directions are `[row:column:0]=[1:ratio:0]` with
normal covectors `(column,-row)`.  The current witness/API does not type or
verify that these code ratio directions are exactly the paper's three
`R_infinity` directions in the `(TR13)` frame.  That coordinate lemma and a
replay fixture are the remaining implementation certificate.  Do not insert
an extra shear into the boundary normal or silently promote this to a general
C962 rejection reason before that check.

There is a stronger exact global form.  In the boundary-vertical chart put

```text
psi(m)=e_(q-1)({b(P)-m a(P):P in B_aff}).
```

Coefficient comparison in `S=(X^q-X)Q+J`, using monicity of `Q` and
`[X^2]Q=-P_reg p`, gives

```text
psi(m)=-1-P_reg(m)p(m),       deg p<=2.             (TR45)
```

Thus `psi=-1` on every regular direction, `psi=1` at both vertex directions,
and `psi=0` at all three boundary directions (including infinity).  If
`hat psi(M,N)=N^(q-1)psi(M/N)`, then

```text
hat psi(M,N)
 =-N^(q-1)-N hat P_reg(M,N)hat p(M,N).
```

This is a stronger compiler target than the three zeros: after the cheap
root test, the full binary form must have the displayed quadratic quotient.
It is also a no-go for using `Psi` to synchronize the 64 labelled residual
patterns from `(TR33)`: every regular direction has the same value `-1`, so
this coefficient contains no missing-label information.  A residual
propagation theorem must use a lower projection/Chow coefficient.

The immediately lower elementary-symmetric coefficient is exact but exits
the bounded state.  With `t_P=b(P)-Ma(P)`, coefficient comparison gives

```text
e_(q-2)({t_P})=-[X^3]Q.                             (TR46)
```

At a regular direction, where `Q=(X-d_m)G_m^3`, this is

```text
e_(q-2)=d_m([X]G_m)^3,
```

while it vanishes at both vertex directions.  Hence its degree-`q-2`
binary form has the two vertex normal covectors as factors.  However
`[X^3]Q` lies in the unrestricted cube-sector `B_0(X^3,M)` of `(TR34)`; the
derivative that produced the bounded quadratic `p` kills it.  The scalar
`d_m([X]G_m)^3` is not determined by the labelled missing-root subset
`A_m|B_6`, and it depends on the fixed intercept frame.
Being a cube gives no additional restriction over `F_(3^h)`, because
Frobenius is bijective; no common cube-root gluing follows.

There are two q-scale checksums but no bounded compression.  Write
`theta(m)=e_(q-2)({b(P)-ma(P)})` and let `theta(infinity)` be its homogeneous
vertical value.  Since its binary form has degree `q-2` and vanishes at the
vertices,

```text
sum_(m regular)d_m([X]G_m)^3
 +theta(b_1)+theta(b_2)=0,

sum_(m regular)m d_m([X]G_m)^3
 +b_1 theta(b_1)+b_2 theta(b_2)+theta(infinity)=0,   (TR46a)
```

where `theta(b)=-[X^3]quo(C_b^2,A_b)` (equivalently
`s_b([X^(r+1)]C_b)^3`).  These are useful only after all fibres are known.  A genuine residual theorem
must bridge the labelled missing polynomial `A_m` to the cube-sector data
`G_m` or control `B_0` globally.

## Mystery ledger (`ej` + `tt`)

- **Settled:** the split point product gives the exact restrictions `(TR3)`
  and `(TR4)`.
- **Settled:** connector mixed derivatives recover the three values
  `E(c,sigma)`.
- **Settled:** both canonical quotients compress to the bounded pair `(E,U)`.
- **Settled/no-go:** the transition is `(TR12)` with a bounded quartic `L`,
  but covariance alone lets `L` absorb the entire core.
- **Open:** constrain `L` from the reciprocal norm or a Witt lift.
- **Open:** decide whether a Witt or norm identity forces any nonzero linear
  functional of `E` or `U`.
- **Settled:** `(TR14)--(TR16)` give an explicit carrier-to-Chow/Redei map.
- **Settled:** `(TR17)--(TR19)` extract `E_3` and `L_4` from the leading
  tangent-direction Chow form.
- **Settled/no-go:** `(TR20)` proves that the original affine leading layer
  is carrier-blind; fourth Witt must enter through lower layers and tangent
  reflagging.
- **Settled:** `(TR21)--(TR22)` locate the entire fourth-Witt carrier input
  linearly in the first lower homogeneous Chow layer.
- **Settled:** `(TR23)--(TR24)` identify fourth Witt as a marked tail
  catalecticant/jet of a binary cube root.
- **Settled/no-go:** tangent-origin gauge changes cannot see that normal
  polar, while changing tangents mixes every normal layer as in `(TR25)`.
- **Settled/no-go:** unweighted Chow/Redei data omit the arc/blocker selector
  and non-tight slack; `(TR26)` shows this is decisive already at `eta=1`.
- **Settled/no-go:** `(TR26-marked)` recovers the exact selector as a q-scale cube,
  but characteristic-three logarithmic differentiation erases it and no
  bounded marked bridge follows.
- **Settled/no-go:** `(TR29)--(TR30)` give a valid inverse-duplex transversal
  but force a fivefold boundary concurrence for every ternary `q>=27`.
- **Settled:** `(TR31)--(TR32)` show the ordinary projections have only
  `O(q)` total defect from cap-four collision saturation; every directional
  Redei remainder has residual degree at most five.
- **Open:** prove a cross-direction propagation theorem for those bounded
  residuals; separate fiber factorization does not supply a common carrier.
- **Settled:** `(TR33)` reduces the generic residual support to 64 labelled
  boundary-subset patterns, with each of the six labels occurring linearly
  often.
- **Open:** control pairwise intersections of those six tangent-direction
  sets; their individual degree/count data remain below interpolation range.
- **Settled:** `(TR34)--(TR35)` compress every noncube term in the global
  affine quotient derivative to a cubic with at most two scalar freedoms.
- **Open:** relate that two-scalar defect to `(E,U)`, fourth Witt, or the two
  boundary fibers; the large cube channels cannot be discarded.
- **Settled:** `(TR36)` identifies the two remaining parameters with low
  Euclidean-quotient coefficients in the two finite boundary fibers.
- **Settled:** the vertical boundary forces `deg p<=2`, and `(TR38)` is the
  resulting overdetermining four-slope compatibility.
- **Settled:** `(TR39)` is its one-scalar boundary form, and `(TR40)` is the
  equivalent normalized elementary-symmetric compiler gate.
- **Open:** identify `(TR38)` with a carrier/Witt/norm functional or use it
  directly against the selector and mapping gates.
- **Settled/no-go:** the old carrier-top coefficient is one while `(TR40)`
  is zero in the boundary flag; this is a reflag compiler test, not a
  contradiction or a raw-carrier gate.
- **Settled:** cyclically, the three boundary projection gates assemble as
  the binary divisibility `(TR41)`.
- **Settled:** `(TR42)` compiles that divisibility exactly from the completed
  affine-core Chow product; the three infinity factors of `Chow_D` must be
  removed first, and direction coordinates are dualized.
- **Settled/no-go:** in the existing `(Z,M,W)` carrier form the affine
  homogenizing variable is `Z`; extracting `[W^(q+2)]` there is a wrong-flag
  coefficient and cannot be used as the gate.
- **Settled:** `(TR43)` evaluates all three roots by a truncated univariate
  recurrence from completed carrier/mapping data, with no root extraction or
  full Chow expansion.
- **Settled:** `(TR44)` makes the all-three-zero verdict invariant under the
  existing joint semilinear quotient, so representative-only evaluation is
  exact.
- **Settled:** `(TR45)` determines the entire directional binary form up to
  one quadratic quotient and proves that its regular-direction values are
  label-blind.
- **Settled/no-go:** `(TR41)--(TR45)` cannot propagate the 64 labelled
  degree-five residual patterns; a lower projection coefficient is required.
- **Settled/no-go:** `(TR46)` is the first richer coefficient, but it lands
  in the unrestricted q-scale cube-sector and is not determined by the
  missing-label subset.  Merely descending one coefficient is not another
  bounded certificate, and cubing itself is bijective.
- **Open:** determine whether this post-terminal filter rejects any surviving
  q=27 carrier states independently of fourth Witt, reciprocal norm, and the
  mapping gate; no symmetry of `D` may be assumed.
- **Open:** certify and fixture the code-ratio to paper-`R_infinity` adapter
  before making `(TR43)` an implementation rejection reason.
- **Open:** obtain a common marked-flag or full norm/Witt transition that
  transports the fourth-Witt gate and the marked selector to `E,U`, or `L`.
