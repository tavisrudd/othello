# C312: universal seed--repair determinant and trace reduction

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; exports the exact eight-packet constant-`p` legality system to C315 without
solving its moduli.

## Result

Let `E/F` be a quadratic extension of finite fields of characteristic two, let a bar denote the
nontrivial relative automorphism, and write

    P(x,h)=[1:x:x^2+h].

For an affine repair coset `v+F`, with `v notin F`, put

    delta_v=v+bar(v) in F^*,
    lambda_v(z)=(z+bar(z))/delta_v in F,
    mu_v(z)=z+lambda_v(z)*v in F.                         (1)

Thus `z=mu_v(z)+lambda_v(z)*v`.  Formula (1), rather than a chosen equation for a basis element,
is the basis-independent coordinate projection used below.

For a quadratic repair graph

    R(v;A,B,C)={P(v+r,A*r^2+B*r+C):r in F},
    K=1+A,

and a seed layer `S_gamma={P(t,gamma):t in F}`, both possible seed--repair orientations reduce to
one universal packet.  For `U=(U_2,U_1,U_0) in E^3`, define

    a_j=lambda_v(U_j),       b_j=mu_v(U_j),
    p_U(X)=a_2*X^2+a_1*X+a_0,
    q_U(X)=a_2*X^3+(b_2+a_1)*X^2+(b_1+a_0)*X+b_0.        (2)

The two packets are

    U^SR(v,A,B,C;gamma)=(K,B,C+gamma+v^2),               (3)

    U^RS(v,A,B,C;gamma)
      =(K^-1,B*K^-1,(C+gamma+v^2+B*v)*K^-1),             (4)

where (4) is used only on the internal-arc open `K!=0`.  Here `SR` means two seed points and one
repair point; `RS` means two repair points and one seed point.

For either packet, at remaining-layer parameter `z in F` there is a collinear triple with two
distinct same-layer points if and only if

    p_U(z)!=0
    and Tr_F/GF(2)(q_U(z)/p_U(z)^2)=0.                   (5)

In particular, there is no denominator convention hidden in (5): `p_U(z)=0` is exactly the
repeated-root case and supplies no two distinct points.  Equations (1)--(5) are the promised
basis-independent necessary-and-sufficient determinant/trace test.

For C297's constant-p family, simultaneous legality of all four seed/repair pairs and both
orientations is exactly the eight conditions

    Safe(v_i,U^SR_i,gamma),  Safe(v_i,U^RS_i,gamma)
    for i in {1,2}, gamma in {alpha,beta},                (6)

where `Safe` is the explicit coefficient system in (15) below and the specialized packets are
displayed in (18)--(19).  This is a finite equation system over `F`, not a census.  C315 owns its
solution on C314's invariant atlas.

## The determinant lemma

For arbitrary `x_1,x_2,x_3 in E` and `h_1,h_2,h_3 in E`, direct expansion gives

    det(P(x_1,h_1),P(x_2,h_2),P(x_3,h_3))
      =(x_1+x_2)*(x_2+x_3)*(x_3+x_1)
       +(x_2+x_3)*h_1+(x_3+x_1)*h_2+(x_1+x_2)*h_3.       (7)

This identity is alternating in the characteristic-two sense and requires no normalization of
`E/F`.

Take two distinct seed parameters `t,u`, a repair parameter `r`, and put `x=v+r`, `p=t+u`,
`q=t*u`.  Dividing (7) by `t+u` shows that the three points are collinear exactly when

    K*r^2+B*r+C+gamma+v^2 = p*(v+r)+q.                  (8)

The left side is the polynomial belonging to (3).  Applying the two projections (1) to (8)
forces precisely `p=p_U(r)` and `q=q_U(r)`; expansion gives (2).

For the reverse orientation take repair parameters `r,u`, a seed parameter `t`, and set
`p=r+u`, `q=r*u`, `y=v+t`.  The divided determinant, independently simplified rather than inferred
from (8), is

    gamma+y^2+B*y+C = K*(p*y+q).                         (9)

Indeed, the chord interpolation expression is

    A*r^2+B*r+C+(y+r)*(y+u)+(y+r)*(A*p+B),

and its `r`-dependent terms collapse to `A*q`.  Dividing (9) by `K` gives packet (4), and (1)--(2)
again force its pair sum and product.

In characteristic two, `T^2+p*T+q` has two distinct roots in `F` exactly when

    p!=0 and Tr_F/GF(2)(q/p^2)=0.                        (10)

For `p!=0`, this is the usual Artin--Schreier substitution `T=p*Z`.  For `p=0`, Frobenius is a
bijection on `F`, so `T^2+q` has one root with multiplicity two.  Combining (8)--(10) proves (5)
in both orientations.

## Exact trace-class and pole classification

This section is an interface, not a solution of the eight simultaneous conditions.  Fix a packet
`U`, abbreviate `p=p_U`, `q=q_U`, and consider

    f_U(X)=q(X)/p(X)^2.                                  (11)

Only values with `p(z)!=0` enter (5).

1. If `p=0` identically, the orientation is identically safe: every forced same-layer quadratic
   is repeated-root.  In coefficients this is exactly `a_2=a_1=a_0=0`.
2. If `p=p_0 in F^*` is constant, then

       Tr(f_U(z))
        =Tr(L*z+b_0/p_0^2),
       L=(p_0*sqrt(b_2)+b_1+p_0)/p_0^2.                 (12)

   Thus `L=0` gives a constant trace class: trace one is identically safe and trace zero is
   identically obstructed.  If `L!=0`, the affine trace functional is balanced on `F`, so both
   legal and obstructing remaining-layer parameters occur.
3. If `deg(p)>0`, the class has the following explicit reduced pole divisor modulo `g^2+g`.
   These formulas are over an algebraic closure and are Galois-stable, hence define an `F`-divisor.

   - If `p` is squarefree and `a` is a root, put

         s_a=q'(a)/p'(a)^2 + sqrt(q(a)/p'(a)^2).         (13)

     The reduced class has a simple pole at `a` exactly when `s_a!=0`, and no pole there
     otherwise.  This follows by adding
     `(c/(X-a))^2+c/(X-a)` with `c=sqrt(q(a)/p'(a)^2)`.
   - If `p=a_1*(X-a)` is linear and its expansion is
     `q(a+Y)=d_0+d_1*Y+d_2*Y^2`, the reduced simple-pole coefficient is
     `d_1/a_1^2+sqrt(d_0/a_1^2)`.  If it vanishes, the reduced class is the constant
     `d_2/a_1^2`.
   - If `p=a_2*(X-a)^2` is inseparable quadratic and
     `q(a+Y)=d_0+d_1*Y+d_2*Y^2+d_3*Y^3`, first put

         c_2=sqrt(d_0/a_2^2),
         c_1=sqrt(d_2/a_2^2+c_2).                       (14)

     The reduced class has an order-three pole when `d_1!=0`; if `d_1=0`, it has a simple pole
     exactly when `d_3/a_2^2+c_1!=0`.  If both coefficients vanish, its reduced class is zero.

There is no omitted pole at infinity.  For quadratic `p`, `deg(q)<=3<2*deg(p)`; for linear `p`,
the possible finite constant at infinity is exactly the constant recorded above.  Consequently
the remaining nonconstant cases are Artin--Schreier functions with explicit odd reduced poles:
simple poles on the squarefree strata and a possible order-three pole on the inseparable-quadratic
stratum.  If `D` is the displayed reduced pole divisor, the normalization of
`Y^2+Y=f_U(X)` has geometric genus

    -1 + (1/2)*sum_{P in supp(D)}(ord_P(D)+1),

provided the class is nonconstant; its constant field and the deletion of the `p=0` fibers must
be checked before a point-supply argument.  C315 may use these divisor formulas, but a
nonconstant class is not declared globally safe or obstructed here.

## A finite equation system over the base field

Let `Q=|F|>4` and let

    T_F(Z)=sum_{j=0}^{[F:GF(2)]-1} Z^(2^j)

be the absolute-trace polynomial.  For a packet `U`, define

    Phi_U(X)=p_U(X)^(Q-1)
      *(1+T_F(q_U(X)*p_U(X)^(Q-3))).

Then

    Safe(v,U)  iff  rem_{X^Q-X}(Phi_U)=0.                (15)

This is an equality of polynomials of degree below `Q`, hence is exactly a finite list of
coefficient equations in `F`.  At an `F`-point with `p!=0`, Fermat changes the trace argument to
`q/p^2`, so vanishing says its trace is one.  At `p=0`, the leading factor makes `Phi_U` vanish,
exactly implementing the repeated-root deletion.  Therefore (15) is necessary and sufficient,
including small fields; it does not replace the structural classification (12)--(14) with an
enumeration.

The separate open/deleted conditions for a marked configuration are

    v_i notin F,                 v_1+F != v_2+F,
    K_i!=0,
    alpha!=0, beta!=0,          alpha+beta notin F,      (16)

and, when pointwise avoidance of the prescribed conic is part of the configuration,

    gcd(A_i*X^2+B_i*X+C_i, X^Q-X)=1.                    (17)

The last condition is exactly `G_i(r)!=0` for every `r in F`; it is not a seed--repair trace
condition.  Conditions (16) also show that no seed point can coincide with a repair point and no
point of one repair coset can coincide with a point of the other.  Within a displayed layer,
distinct parameters have distinct affine `x`-coordinates.  Thus (15)--(17) account separately for
every repeated-root, conic, and point-coincidence deletion.

## Specialization to C297's constant-p family

Choose an Artin--Schreier generator `rho` of `E/F`, distinct nonzero `e_1,e_2 in F`, and put
`d=e_1+e_2`, `v_i=e_i*rho`.  C297's full constant-p trace-compatible repair family is

    K_1=K,                       K_2=c*K,
    B_2=B_1+ell*K,               ell=P0*(1+sqrt(c)),
    C_2=C_1+B_1*d*rho+d^2*rho^2+K*(x_0+d*P0*rho),       (18)

with `c,P0 in F^*`, `K in E^*`, and
`Tr_F/GF(2)(x_0/P0^2)=1`.  For `i in {1,2}` and
`gamma in {alpha,beta}`, define the eight explicit packets

    U_i,gamma^SR=(K_i,B_i,C_i+gamma+v_i^2),

    U_i,gamma^RS=(K_i^-1,B_i*K_i^-1,
                  (C_i+gamma+v_i^2+B_i*v_i)*K_i^-1).    (19)

Substitute (18) into (19), apply (1)--(2), and impose the eight remainder identities (15).  Along
with the inequations (16), and (17) when conic avoidance is required, this is the complete exact
equation/inequation system equivalent to simultaneous seed legality.  It uses only the independent
C297 parameters

    (e_1,e_2,alpha,beta,c,P0,K,B_1,C_1,x_0)

subject to (18) and the displayed trace-one condition.  No `A_i,B_2,C_2` are independent, and no
extra orientation or denominator saturation is to be added.  Equations (12)--(14) give C315 the
smaller structural strata to solve before it ever expands the exact finite-field remainder (15).

## Equivariance and quotient boundary

The classification is preserved by every action proved in C297:

- A conic-stabilizer projectivity sends the three columns in (7) through one invertible linear
  map, so determinant zero, point distinctness, and conic membership are preserved.  Its weighted
  scaling and subfield translation merely make an affine change of the packet parameter and
  multiply a same-layer quadratic by a nonzero scalar.
- Changing the representative of `v+F` translates the repair parameter.  This is
  parameterization gauge, not an additional projective quotient, but it bijects the solutions of
  (5) and leaves (15) unchanged after reduction modulo `X^Q-X`.
- Seed interchange permutes `gamma=alpha,beta`; repair interchange permutes `i=1,2` and applies
  C297's normalization rescaling.  Thus both relabelings permute the eight conditions in (6).
- A semilinear automorphism commutes with relative conjugation up to the conjugate choice of
  Artin--Schreier generator, preserves zero/nonzero, and preserves absolute trace.  Applying it to
  (1)--(5) therefore applies the same automorphism to the coefficient system.

These are four different statements: projective equivalence, parameterization gauge, finite
relabeling, and semilinear equivalence have not been conflated.  In particular, (15) does not
promote a symmetry of a resultant or trace polynomial to a projectivity.

## Completeness audit and C315 interface

The determinant has only the two support orientations treated in (8) and (9).  Each orientation
has one remaining-layer parameter, and (2) is the unique decomposition of its quadratic `E`-value
as `p(v+z)+q` with `p,q in F`.  Criterion (10) exhausts the split, nonsplit, and repeated-root
cases.  Thus there is no missing orientation, root case, or denominator divisor.

C315 should consume exactly:

1. the constant-p relations and opens (18), (16), and optionally (17);
2. the eight packets (19), expanded by the projections (1) and coefficient formulas (2);
3. the exact safety equations (15);
4. the constant/affine strata (12) and reduced-pole strata (13)--(14); and
5. C297's projective action, the two relabelings, and its semilinear action as distinct quotients.

The report proves neither that the simultaneous system is empty nor that it has a survivor.  It
makes no collision, coverage, or `C`-completeness claim.  Component and dimension analysis of this
exact system belongs to C315 after C314 supplies its invariant charts.

## Evidence boundary

This is a proof-only result.  Identities (7)--(9) are direct determinant and polynomial
expansions; (10) is the finite-field Artin--Schreier splitting criterion; (12)--(14) are explicit
reductions modulo `g^2+g`; and (15) is polynomial-function interpolation on `F`.  No CAS output,
coefficient sample, or field census is evidence for the theorem.

## Vibe check

Good: the omitted constant-`p` moduli now have a compact, basis-independent seed gate with all
eight orientations and all repeated-root divisors visible.  The hard work is correctly localized
in C315: solving these exact strata on C314's atlas, not rediscovering determinant algebra.
