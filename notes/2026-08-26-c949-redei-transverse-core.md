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
- **Open:** compute the tangent reflagging well enough to transport the
  fourth-Witt/top-carrier coefficient gate to `E,U`, or `L`.
