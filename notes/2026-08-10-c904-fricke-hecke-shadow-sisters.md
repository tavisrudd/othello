# C904 Paper V: Fricke--Hecke correspondence and shadow sisters

Date: 2026-08-10

Status: research, exact certificates, literature audit, and framing only.  No
paper source was edited and no Lean command was run.

## Executive verdict

Upgrade 4 survives a hard push and is substantially stronger than the first
formulation.  It is not just the parameter involution

```text
T -> 729/T,                 s=t^2 -> 1/(9s).
```

The exact package now contains:

1. a universal degree-three Velu isogeny over the cubic-moduli coordinate;
2. the full level-three Hecke pullback, with irreducible bidegrees
   `(1,1),(3,3),(3,3),(9,9)`;
3. an explicit quadratic twist relating the published Prym curve to the
   universal `X_0(3)` Tate model;
4. an arithmetic Fricke trace law over finite fields;
5. a hypergeometric Picard--Fuchs equation whose quadratic twist explains the
   otherwise missing chordal singularity;
6. an exact distinction between Winger's `Gamma_1(3)` lift and the cubic's
   `Gamma_0(3)` lift;
7. an explicit identification of the cubic and Winger bases, making them
   genuine modular shadow sisters; and
8. a characteristic-eleven collision theorem that explains the exceptional
   `F_11` trace collapse.

The best new conceptual statement is:

> The projective rank-two period system of the nonstandard `A5` cubic pencil is
> the universal `X_0(3)` system, while its actual Prym system is the quadratic
> twist whose branch divisor records the noncuspidal cubic boundary.  The twist
> adds scalar `-I` monodromy at the chordal cubic, upgrading the integral
> monodromy from `Gamma_1(3)` to `Gamma_0(3)` without changing the coarse
> modular curve.

This is the precise sense in which the classical PEL and `E^5` descriptions
forgot structure.

## 1. Exact universal isogeny

Put

```text
A=T+27,       B=A^2.
```

The Tate normal form

```text
E_T: y^2 + Axy + By = x^3
```

has the point `P=(0,0)` of order three and

```text
Delta(E_T)=T(T+27)^8,
j(E_T)=(T+27)(T+3)^3/T.
```

The quotient by `<P>` is

```text
E'_T:
y^2+Axy+By=x^3-5ABx-B(A^3+7B),
```

with

```text
j(E'_T)=(T+27)(T+243)^3/T^3=J(729/T).
```

An exact Velu map is

```text
x' = x + AB/x + B^2/x^2,

y' = y
     - AB(y+Ax)/x^2
     - B^2(2y+2Ax+B)/x^3.
```

The certificate reduces the target equation modulo the source equation and
gets zero identically.  Thus the degree-three isogeny is proved, not inferred
from equality in the modular polynomial.

The Fricke involution is

```text
w_3(T)=729/T.
```

It is a regular involution of the completed coarse cubic-moduli line, but only
a correspondence on the common smooth family.

## 2. Fricke is not a hidden cubic automorphism

The four cubic boundary values in the `T` coordinate are

| `T` | cubic geometry |
|---:|---|
| `infinity` | six singular points |
| `0` | ten singular points |
| `-27` | five `A_2` singularities |
| `729/5` | chordal cubic |

Fricke acts by

```text
0 <-> infinity,
-27 -> -27,
729/5 <-> 5.
```

The member at `T=5` is smooth.  Therefore no projective automorphism of the
total cubic pencil can realize Fricke fibrewise: it would have to preserve
smoothness.  The exact domain on which both cubic fibres are smooth is

```text
P^1 minus {0,infinity,-27,729/5,5}.
```

This is a useful impossibility theorem, not a defect.  Fricke is an isogeny
correspondence on the elliptic/Hodge shadow, and its failure to preserve the
discriminant is itself structured.

Generically `T` and `729/T` are distinct.  Hence Torelli rules out a generic
isomorphism of the principally polarized intermediate Jacobians, even though
their elliptic multiplicity factors are degree-three isogenous after the
explicit twist below.  The remaining hard problem is to construct and measure
the induced isogeny on the integral `A5`-stable lattice.

## 3. The arithmetic datum missed by the `j`-map

Substitute the exact `A5` specialization

```text
a(u)=-32(u-3)^4/[9(u+1)^3(u+3)^2],
b(u)=-8(u-3)^2(u-1)/[(u+1)(u+3)^2],
u^2=5t^2,       T=81t^2=81u^2/5
```

into the Weierstrass model printed by van Geemen--Yamauchi.  Comparison of
`c4` and `c6` with those of `E_T` gives the exact multiplier

```text
m(u)=1600(u-3)^5 /
     [2187(u+1)^4(u+3)^3(3u^2+5)].
```

Modulo squares in `Q(u)^*/Q(u)^{*2}`, this is

```text
D(T)=(T+27)(T-729/5).
```

Indeed

```text
m(u)/D(T)
 = [200(u-3)^2 /
    {2187(u+1)^2(u+3)^2(3u^2+5)}]^2.
```

Thus the explicit Prym elliptic curve is the `D(T)`-quadratic twist of the
universal Tate model, up to a rational coordinate change.  This fixes a serious
arithmetic ambiguity: `j` alone cannot determine Frobenius traces.

The two zeros of `D(T)` are exactly the two noncuspidal cubic boundary values:

```text
T=-27          five A_2 points,
T=729/5        chordal cubic.
```

Together, the universal Tate degeneration at the two cusps and this twist
divisor recover the full cubic boundary support.  The displayed `u`-chart has
coordinate poles at `u=-1,-3`; these are not additional geometric boundary
values and must be removed by changing Weierstrass chart.

This suggests the correct integral object is not merely `(E,C)` but the modular
rank-two system with its boundary quadratic character.

The twist also descends the Prym isomorphism class from `Q(u)` to `Q(T)`.
After a global minimalization, one convenient short Weierstrass model is

```text
y^2=x^3+A_4(T)x+A_6(T),

A_4(T)=-675(T+3)(T+27)(5T-729)^2,

A_6(T)=6750(T+27)(5T-729)^3(T^2+18T-27).
```

Its discriminant is

```text
34012224000000 T(T+27)^2(5T-729)^6,
```

with the remaining order three at infinity.  Tate's algorithm in
characteristic zero gives the exact fibre configuration

```text
T=0          I_1,
T=-27        II,
T=729/5      I_0^*,
T=infinity   I_3.
```

The Euler numbers `1+2+6+3=12` show that this is a rational elliptic surface.
The configuration itself belongs to the classical classification of rational
elliptic surfaces; the new lead is that it is the descended multiplicity
surface of this `A5` cubic pencil.  In particular, the Kodaira symbols prove
the monodromy claims below without relying only on a formal differential
equation: `II` has order-six monodromy and `I_0^*` has scalar `-I` monodromy.

There is also a rigid Mordell--Weil consequence.  The reducible-fibre root
lattice is

```text
D_4 + A_2,
```

of rank six.  Since a rational elliptic surface has Picard rank ten,
Shioda--Tate gives geometric Mordell--Weil rank

```text
10-2-(4+2)=2.
```

Oguiso--Shioda's classification (case 32) sharpens this to

```text
MW_geom = A_1^* + <1/6>,       torsion=0.
```

The determinant `1/12` is exactly reciprocal to the determinant `12` of
`D_4+A_2`, as unimodularity predicts.  Thus the twist does more than insert
the missing boundary: relative to the extremal three-torsion Tate surface, it
trades part of the reducible-fibre lattice for two genuine geometric section
directions and removes rational torsion.  Their exact field of definition and
explicit formulas over the cubic parameter have not been determined here.
Those two low-height directions are a concrete place to search for additional
cubic correspondences; they must not yet be advertised as `Q(T)`-rational
sections.

## 4. Arithmetic Fricke law

The standard Tate models satisfy

```text
E_{729/T} = quadratic twist by -3 of E'_T,
```

after the coordinate scaling `9/T`.  The sign is exact: the `c6` ratio is
`(-3)^3(9/T)^6`; it is also independently detected by point counts.

Combining this with `D(T)` gives the Prym trace multiplier

```text
R(T)=(T-5)(5T-729)        modulo squares.
```

More precisely, over a finite field of odd characteristic away from the bad
values, whenever both explicit Prym models and the indicated parameters are
defined,

```text
a_q(Prym_{729/T})
  = chi_q((T-5)(5T-729)) a_q(Prym_T).
```

The certificate checks the symbolic `c4,c6` identity and directly counts
points for dozens of instances over `F_11,F_19,F_29,F_31`.

The zeros of `R(T)` are exactly the two points where one side is chordal and the
other side smooth.  Thus the arithmetic trace law itself detects the maximal
domain of the smooth Fricke correspondence.

### Conditional lift to cubic point counts

Once the `A5`-equivariant l-adic/motivic descent is proved, put

```text
B_q=1+q+q^2+q^3,
epsilon_q(T)=chi_q((T-5)(5T-729)).
```

Then the expected fifth-power factorization gives

```text
#X_T(F_q)=B_q-5q a_q(Prym_T),

#X_{729/T}(F_q)-B_q
  = epsilon_q(T) (#X_T(F_q)-B_q).
```

So Fricke partners either have equal point counts or are symmetric about
`B_q`.  This statement is not yet promoted to a cubic theorem: the explicit
elliptic trace law is proved, while the descent of the entire cubic motive is a
separate gate.

## 5. Why characteristic eleven collapses

The chordal value and its smooth Fricke partner coincide modulo a good odd
prime precisely when

```text
729/5 = 5,
729-25=704=2^6*11.
```

Hence `11` is the unique good odd characteristic with this collision.

Moreover, modulo eleven,

```text
R(T)=(T-5)(5T-729)=5(T-5)^2,
```

and `5` is a square.  Therefore every common smooth Fricke pair has the same
Prym trace over `F_11`.

For the Paper-V coordinate `r`, with

```text
t=2(r-3)/r,
```

the formal rational lift of Fricke is

```text
r' = 36(r-3)/(11r-36),
```

and its reduction is the exceptionally simple involution

```text
r' = 3-r                  over F_11.
```

It pairs the eight smooth parameters as

```text
1<->2, 4<->10, 5<->9, 6<->8,
```

and fixes the two chordal values `7,infinity`.  Their `T`-values are only
`{1,3,4,9}`, their `j`-values are only `{4,10}`, and direct evaluation of every
valid van Geemen--Yamauchi chart gives trace `-3` for all eight members.

This upgrades the old observation “all eight cubics have 1629 points” to an
arithmetic mechanism.  The final cubic-level proof still needs the l-adic
factorization, but the elliptic calculation is exact and complete.

## 6. Picard--Fuchs and monodromy

Let

```text
z=T/(T+27).
```

The universal projective period system is the triangle hypergeometric system

```text
2F1(1/3,2/3;1;z).
```

In the `T` coordinate its scalar equation is

```text
f'' + (1/T)f' - 6/[T(T+27)^2] f = 0.
```

If a Prym period is written as `g=D(T)^(-1/2)f`, direct gauge transformation
gives

```text
g'' + P(T)g' + Q(T)g = 0,

P(T)=3(5T^2-396T-6561)/[T(T+27)(5T-729)],

Q(T)=(25T^3-4605T^2-64881T+2657205)/
     [T(T+27)^2(5T-729)^2].
```

The local picture is then transparent:

| `T` | projective behavior | actual Prym behavior |
|---:|---|---|
| `0` | cusp of width 1 | unipotent |
| `infinity` | cusp of width 3 | unipotent |
| `-27` | orbifold order 3 | order 6 after the twist |
| `729/5` | ordinary interior point | scalar `-I` |

At the chordal point the two local exponents are shifted to `-1/2,1/2`, so
both local eigenvalues are `-1`; there is no logarithm because the untwisted
system is regular there.  This agrees with the known finite-monodromy behavior
of the chordal degeneration.

The universal elliptic local system has monodromy `Gamma_1(3)`.  The chordal
loop supplies `-I`, and a residue-class calculation gives

```text
<Gamma_1(3),-I> = +/-Gamma_1(3) = Gamma_0(3).
```

This closes the coarse `X_0(3)` versus integral `X_1(3)` distinction at the
rank-two local-system level.  It does not by itself classify the principal
polarization on the fivefold intermediate Jacobian.

## 7. The full pulled-back Hecke correspondence

Substitution of

```text
X=J(T),       Y=J(U)
```

into the classical modular polynomial `Phi_3(X,Y)` factors over `Q` into four
irreducible components of bidegrees

```text
(1,1), (3,3), (3,3), (9,9).
```

The `(1,1)` component is

```text
TU-729=0,
```

the Fricke graph.  One `(3,3)` component is

```text
T^3 - T^2U^3 - 36T^2U^2 - 270T^2U
    - 729TU^2 - 26244TU - 531441U = 0;
```

the other is its transpose.  The remaining component is irreducible of
bidegree `(9,9)` and is printed implicitly by the certificate rather than in
this note.

The degrees have a direct subgroup interpretation.  Starting from `(E,C)`:

1. quotient by `C` and mark the dual subgroup: one Fricke choice;
2. quotient by `C` and mark one of the other subgroups: three choices;
3. quotient by one of the other three subgroups and mark the image of `C`:
   three choices;
4. make both choices independently away from `C`: nine choices.

Thus the cubic-moduli line inherits the full level-three isogeny graph, not
only one involution.  Fricke is the unique rational branch; the two cubic
branches and the degree-nine branch become available over controlled low-degree
extensions.

## 8. CM and the split primes above three

The equality of the two Fricke `j`-values factors as

```text
J(T)-J(729/T)
 = (T-27)(T+27)
   (T^2-10T+729)(T^2+46T+729)/T^3.
```

It produces the four CM types

| parameter condition | `j` | CM discriminant |
|---|---:|---:|
| `T=-27` | `0` | `-3` (singular cubic) |
| `T=27` | `54000` | `-12` |
| `T^2+46T+729=0` | `8000` | `-8` |
| `T^2-10T+729=0` | `-32768` | `-11` |

The last factor has an exact interpretation that links back to the earlier
finite orientation work.  Put

```text
alpha=(-1+sqrt(-11))/2,       alpha^2+alpha+3=0.
```

Then `Norm(alpha)=3` and

```text
alpha^6=-3-16alpha=5-8sqrt(-11),
alpha_bar^6=13+16alpha=5+8sqrt(-11).
```

These are precisely the two roots of `T^2-10T+729`, and

```text
729/alpha^6=alpha_bar^6.
```

So Fricke exchanges the sixth powers of the two generators of the split primes
above three in `Q(sqrt(-11))`.  C473 independently found exactly those two
primes and their outer/Galois exchange as the arithmetic orientation torsor.

This does **not** yet prove that the two parameters are the two `A5` markings
of the Klein cubic.  It makes that identification an unusually rigid target:
Roulleau's Klein factor has `j=-32768`, the Klein group has the relevant pair of
icosahedral parents, and the modular points are exactly the two norm-three
kernels.  What remains is to put the Klein equation in the canonical pencil or
track its two `A5` subgroups through the integral period lattice.

For discriminant `-8`, if `beta=1+sqrt(-2)` with norm three, the other quadratic
factor consists of `-beta^6,-beta_bar^6`.  The rational pair

```text
T=-3 <-> -243,       j=0 <-> -12288000
```

is the conductor step inside the `Q(sqrt(-3))` isogeny class and is a natural
finite target when locating the Fermat and `Y_6` cubics.  No assignment of
those names is made without an equation-level calculation.

## 9. The Winger shadow sister

Looijenga--Zi prove that the `V_4` multiplicity elliptic curve in the Winger
genus-ten pencil has a distinguished point of order three, monodromy exactly
`Gamma_1(3)`, and period map an isomorphism from the completed pencil base to
the completed modular curve.  Their Winger parameter `w` has

```text
w=0       triple conic / order-three orbifold,
w=infinity six lines / width-three cusp,
w=27/5    ten-node curve / width-one cusp,
w=-1      six-node curve with Bring normalization / interior point.
```

Matching the orbifold point and the two labelled cusps gives the unique affine
coordinate bridge

```text
T=5w-27.
```

Consequently

```text
j_W(w)=5w(5w-24)^3/(5w-27)
```

and Fricke becomes

```text
w -> 27w/(5w-27).
```

The boundary comparison is striking:

| common `T` | cubic fibre | Winger fibre |
|---:|---|---|
| `infinity` | six singular points | six lines |
| `0` | ten singular points | ten nodes |
| `-27` | five `A_2` points | triple conic |
| `-32` | smooth | six-node Bring fibre |
| `729/5` | chordal | smooth, `w=864/25` |

Thus three geometric degenerations are the same three modular markers, while
each pencil has one extra geometry-specific boundary over a modular interior
point.  Winger's Bring boundary is invisible to its `V_4` elliptic monodromy;
the cubic chordal boundary is visible only as the central scalar `-I`.

On the common base the expected rational-VHS statement is

```text
M_cubic = M_Winger tensor chi_D,
```

where `M_cubic=Hom_A5(W_5,H^3)(1)`,
`M_Winger=Hom_A5(V_4,H^1)`, and `chi_D` is the quadratic character of
`D(T)`.  The explicit Prym calculation proves the elliptic side; a polished
family-level statement should still spell out the rational local systems and
their integral lattices.

After adjoining `sqrt(D(T))`, the two rank-two systems become the same modular
system.  At the level of complex isogeny classes this predicts

```text
J(cubic_T)^4  ~  A_V(Winger_w)^5,
T=5w-27,
```

because the two sides are respectively powers `E^20`.  This is a useful
shadow-sister bridge, not yet an algebraic correspondence between the total
spaces.

The other Winger multiplicity factor is Hilbert modular, as analyzed by Zi.
It must not be collapsed into this elliptic component.  Likewise the
Wiman--Edge pencil has genuinely Hilbert-modular monodromy.  These examples
show that `A5` symmetry alone does not force `X_0(3)`.

## 10. Algorithms and bounds unlocked by the package

### Fast point counting

Given a good finite-field parameter, compute `T`, form `E_T`, multiply its
trace by the character of `D(T)`, and use Schoof/SEA.  Equivalently, count the
global short Weierstrass model above directly; this version needs neither
`sqrt(5)` nor a choice of the `u`-chart.  Once the cubic motive is proved to be
five copies of this rank-two factor, this replaces enumeration in `P^4(F_q)`
by an elliptic point-count computation polynomial in `log q`.

The direct `F_11` census already verifies the predicted trace on every smooth
member.

### All extension fields from order two

If `a=a_q(Prym_T)`, then the predicted middle factor is

```text
P_3(X_T,z)=(1-q a z+q^3 z^2)^5.
```

All extension counts follow from the second-order recurrence

```text
u_0=2,       u_1=a,       u_n=a u_{n-1}-q u_{n-2},
Tr(Frob_{q^n}|H^3)=5q^n u_n.
```

This collapses an order-ten cohomological computation to order two.

### Discrete point-count spectrum

For marked members over `F_q`, the same factorization would imply

```text
#X(F_q) == 1+q+q^2+q^3       (mod 5q)
```

and at most

```text
4 floor(sqrt(q))+1
```

possible point counts as the parameter varies, rather than a priori `O(q)`
unrelated values.  The numerical Weil interval is not improved—the generic
`b_3=10` bound is already `10q^(3/2)`—but the divisibility and discrete spectrum
are new restrictions.

### Fricke propagation

One elliptic point count determines its Fricke partner up to the explicit
quadratic character `R(T)`.  When the character is `+1`, the two zeta functions
agree if the full motive descends; when it is `-1`, odd extension traces change
sign and even extension traces agree.  Over `F_11` every smooth pair is in the
first case.

### Isogeny-graph algorithms

The `(1,1),(3,3),(3,3),(9,9)` factorization gives exact low-degree equations for
walking the full three-isogeny graph directly in cubic parameters.  This can be
used to:

- enumerate cubic parameters in one elliptic isogeny class;
- propagate Frobenius traces and CM labels;
- locate rational or low-degree special members; and
- test whether a proposed geometric correspondence realizes a particular
  Hecke component.

### Bad-reduction detector

The Tate discriminant and `D(T)` isolate the modular cusps and the two
noncuspidal cubic boundaries.  After the local minimal models and primes
`2,3,5` are audited, this should give a sharp parameter-level bad-reduction and
conductor test.

### Low-height section search

The Mordell--Weil lattice makes a previously invisible finite search
available.  Every section is generated by low-height sections, and the two
geometric generators have norms `1/2` and `1/6`.  Solving for polynomial
sections

```text
x=c_2T^2+c_1T+c_0,       y=d_3T^3+d_2T^2+d_1T+d_0
```

therefore gives an equation-level route to the two generators and their
Galois fields.  If either generator descends over a small number field, its
translations and the rational three-isogeny can generate explicit low-degree
maps among special cubic parameters.  The coefficient ideal is
zero-dimensional, but a complete radical decomposition was not included in
this audit; this is a bounded computational follow-up, not a theorem claimed
here.

## 11. A general theorem template

The Winger and cubic examples suggest the following bounded generalization.

Let a finite group `G` act on a one-parameter geometric family and suppose a
rational irreducible representation `V` occurs in the relevant polarized
cohomology with multiplicity two.  Put

```text
M=Hom_G(V,H).
```

Then `M` is rank two.  If its integral isogeny lattice has a canonical cyclic
index-`N` defect, it determines an elliptic curve with level-`N` data.  If the
period map has degree one and the boundary passport matches, the family base
is the corresponding modular curve.  A geometry-specific quadratic character
can change the integral/stack lift without changing the projective period map.

For Winger, Looijenga--Zi prove this with `V=V_4` and `N=3`.  The cubic
calculation supplies the `V=W_5`, `N=3`, quadratic-twist instance at the
rational elliptic level.  The integral `A5`-symplectic lattice and principal
polarization remain the theorem-level gate.

The Wiman--Edge and the second Winger constituent show the boundary of this
template: multiplicity spaces over `Q(sqrt(5))` lead to Hilbert modular rather
than elliptic modular geometry.  Rank two over `Q` and the cyclic index defect
are essential hypotheses, not cosmetic ones.

## 12. Red-team ledger

| claim | status | exact remaining gate |
|---|---|---|
| `J(T)` is the standard `X_0(3)` map | **proved algebraically** | humanize the Fourier/Prym substitution |
| explicit degree-three isogeny | **proved algebraically** | none beyond excluded characteristics |
| Fricke on cubic moduli | **proved on coarse parameter** | stack wording and smooth-domain statement |
| Prym twist `D(T)` | **proved from printed Weierstrass model** | present coordinate changes cleanly |
| arithmetic Prym trace law | **proved** | state field/chart hypotheses |
| rational elliptic surface and geometric MW rank two | **proved** | cite Shioda--Tate and Oguiso--Shioda case 32 |
| explicit low-height MW generators | **open bounded computation** | radical decomposition and Galois descent of the section ideal |
| `F_11` Prym trace collapse | **proved** | connect to cubic `H^3` without relying on point census |
| hypergeometric/projective system | **standard plus exact pullback** | cite the universal `X_1(3)` period equation |
| cubic monodromy `Gamma_0(3)` | **very strong; short human proof needed** | identify the integral multiplicity lattice with the explicit Prym lattice |
| full cubic zeta fifth power | **conditional** | l-adic/motivic descent of `W_5 tensor H^1(E)(-1)` |
| canonical degree `3^5` IJ isogeny | **target** | integral lattice and polarization kernel |
| Winger/cubic VHS bridge | **proved projectively; rational family statement to write** | align integral local systems and twists |
| algebraic cubic--Winger correspondence | **open** | construct a cycle or geometric functor |
| Klein points are `alpha^6,alpha_bar^6` | **rigid candidate** | equation-level or subgroup/period-lattice match |
| Fermat and `Y_6` are `-3,-243` | **candidate only** | equation-level match |

The most important red-team correction was the sign of the universal Fricke
twist.  It is `-3`, not `+3`.  The sign is invisible in `c4` and the
discriminant but forced by `c6` and finite-field traces.  Any exposition based
only on `j` would miss it.

## 13. Literature and priority audit

### Direct authorities

1. Bert van Geemen and Takuya Yamauchi, *On intermediate Jacobians of cubic
   threefolds admitting an automorphism of order five*, `arXiv:1506.05346`.
   This owns the `D_5` normal form, Prym construction, Weierstrass model, and
   general `j` formula.  It does not specialize the `A5` line to `X_0(3)`,
   identify Fricke, or compute the twist `D(T)`.

2. Moritz Hartlieb, *Special subvarieties in the locus of intermediate
   Jacobians of cubic threefolds*, Math. Z. 310 (2025), article 52,
   DOI `10.1007/s00209-025-03745-3`.  This owns the one-dimensional PEL special
   locus and `J(X)~E^5`.  The published full text does not name the modular
   curve or a three-isogeny.

3. Eduard Looijenga and Yunpeng Zi, *Monodromy and period map of the Winger
   Pencil*, `arXiv:2109.01810`, Theorem 1.1 / Theorem 5.2 and Section 3.  This
   owns the Winger `V_4` elliptic factor, its point of order three,
   `Gamma_1(3)` monodromy, and the modular isomorphism of bases.  It does not
   compare with the cubic threefold pencil.

4. Yunpeng Zi, *On the Monodromy and Period Map of the Winger Pencil*,
   `arXiv:2301.00500`.  This treats the complementary Hilbert-modular Winger
   structure.  It is the reason the shadow-sister claim must be restricted to
   the `V_4` elliptic constituent.

5. Antoine Pinardin and Zhijia Zhang, *A5-equivariant geometry of quadric
   threefolds*, `arXiv:2508.11496`.  This owns explicit five-`A_2` and chordal
   members of the nonstandard `A5` cubic geometry.  It contains no
   intermediate-Jacobian, modular, or Fricke organization.

6. Sebastian Casalaina-Martin, Samuel Grushevsky, Klaus Hulek, and Radu Laza,
   *Complete moduli of cubic threefolds and their intermediate Jacobians*,
   `arXiv:1510.08891`.  This is the authority for the finite-monodromy chordal
   limit and prevents calling the chordal point a modular cusp.

7. Xavier Roulleau, *The Fano surface of the Klein cubic threefold*,
   `arXiv:1001.4853`.  This owns the `Q(sqrt(-11))` CM period lattice and
   `E_{-11}^5` description at the Klein point.

8. Benson Farb--Eduard Looijenga (`arXiv:1911.01210`) and Matthew Stover
   (`arXiv:2012.15708`) treat the Hilbert-modular Wiman--Edge monodromy.  They
   provide the essential negative control: not every `A5` pencil is an
   `X_0(3)` pencil.

9. Antoine Pinardin's 2026 Edinburgh thesis, especially Section 4.6, was
   checked because it is newer than the cited preprint and directly treats the
   nonstandard `A5` cubic.  Its searchable full text has no occurrence of
   `modular curve`, `Fricke`, or `Prym`; its focus is equivariant birational
   geometry and the singular model.

10. Ulf Persson, *Configurations of Kodaira fibers on rational elliptic
    surfaces*, Math. Z. 205 (1990), 1--47,
    DOI `10.1007/BF02571223`, owns the characteristic-zero classification of
    rational elliptic fibre configurations.  The configuration
    `I_0^*,I_3,II,I_1` is therefore classical; its occurrence as the descended
    Prym multiplicity surface is the new candidate.

11. Keiji Oguiso and Tetsuji Shioda, *The Mordell--Weil lattice of a rational
    elliptic surface*, Comment. Math. Univ. St. Pauli 40 (1991), 83--99,
    DOI `10.14992/00009974`, Table case 32, gives for root lattice
    `D_4+A_2` the torsion-free Mordell--Weil lattice
    `A_1^*+<1/6>`.  This owns the lattice classification; Paper V can use it
    to expose the two section directions in the `A5` Prym surface.

### Search verdict

Bounded searches covered exact combinations of

```text
A5 cubic threefold + X_0(3), X_1(3), 3-isogeny, Fricke,
Klein cubic + 3-isogeny / X_0(3),
Winger pencil + cubic threefold,
the exact D(T), R(T), and CM factor polynomials,
forward citations to Hartlieb and van Geemen--Yamauchi.
```

They returned the authorities above or unrelated material.  No source located
the cubic `X_0(3)` specialization, the Prym twist, the `Gamma_0/Gamma_1`
comparison, the characteristic-eleven collision, the Hecke factorization in
cubic parameters, or the Winger--cubic base bridge.

This is a strong priority lead, not permission for an unqualified global
firstness claim.  Classical invariant-theory sources and forward citations
should be checked again before manuscript language is settled.

## 14. Recommended theorem ladder

### Safe and high-value now

1. `X_0(3)` Hauptmodul and exact Velu isogeny.
2. Fricke on the unmarked cubic parameter and its precise smooth domain.
3. Prym twist `D(T)` and the four-boundary explanation.
4. Picard--Fuchs quadratic twist and `Gamma_0(3)` monodromy.
5. Characteristic-eleven collision and direct Prym trace theorem.
6. Rational elliptic surface, Shioda--Tate rank two, and the
   Oguiso--Shioda lattice identification.
7. Winger base bridge, with priority credited to Looijenga--Zi.

### Major but requiring one hard proof

8. `A5`-equivariant l-adic/motivic factorization and all zeta consequences.
9. Integral symplectic lattice and the canonical Fricke isogeny of
   intermediate Jacobians.
10. Rational-VHS shadow-sister theorem across the cubic and Winger families.

### Highest ceiling

11. An algebraic correspondence realizing the shared elliptic motive.
12. A general multiplicity-two/cyclic-defect modularity theorem that includes
    both Winger and cubic instances and explains why the Wiman--Edge case lies
    outside it.
13. Exact Klein/Fermat/`Y_6` placement and the compatibility with the finite
    orientation torsors.

The present exact package is a strong major upgrade to Paper V.  The motivic
or integral-polarization theorem is what could move it from an excellent
special-family paper toward an Inventiones-level result.  An Annals-level claim
would need the general theorem or a genuinely geometric cross-family
correspondence, not just more formulas for this pencil.

## 15. Reproducibility

Replay:

```text
nix-shell -p 'python3.withPackages (ps: [ ps.sympy ])' --run \
  'python -u notes/2026-08-10-c904-fricke-hecke-certificate.py'
```

Certificate:

```text
notes/2026-08-10-c904-fricke-hecke-certificate.py
notes/2026-08-10-c904-fricke-hecke-certificate.out
```

| path | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-fricke-hecke-certificate.py` | 26,393 | `e7c3249082d26b9335e7961dbdb9e94a75cfe029e8bce6d03831ba4dfd269e7a` |
| `notes/2026-08-10-c904-fricke-hecke-certificate.out` | 3,445 | `ad3b22d14062d44d02eab7a02e929bf14fac2f336a6f371bcabfd90156538a96` |

The script checks every displayed rational identity, the Velu map, the
Picard--Fuchs gauge transform, the full modular-polynomial factorization, the
CM norm-three identities, the Prym twist, the `Gamma_1/Gamma_0` residue-class
identity, direct finite-field trace laws, the Winger coordinate bridge, and the
characteristic-eleven collision.

Vibe: this is now the most surprising Paper-V upgrade.  The strongest feature
is not that the parameter happens to be modular; it is that one quadratic
character simultaneously explains the fourth boundary, the stack lift, the
finite-field trace law, and the exact difference between two `A5` shadow
sisters.
