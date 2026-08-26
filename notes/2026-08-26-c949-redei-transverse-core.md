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

## Mystery ledger (`ej` + `tt`)

- **Settled:** the split point product gives the exact restrictions `(TR3)`
  and `(TR4)`.
- **Settled:** connector mixed derivatives recover the three values
  `E(c,sigma)`.
- **Settled:** both canonical quotients compress to the bounded pair `(E,U)`.
- **Open:** determine the reciprocal transition law of the pair, including
  the high quotients `C_0,D`.
- **Open:** decide whether a Witt or norm identity forces any nonzero linear
  functional of `E` or `U`.
- **Open:** construct an explicit map to the finite carrier `(A,C)`, or prove
  that no such direct map is natural.
