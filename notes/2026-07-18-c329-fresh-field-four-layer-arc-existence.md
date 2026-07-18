# C329: fresh-field four-layer arc existence

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** complete.  The allowed repair-conic coincidence locus already contains fresh
collision-free four-layer arcs over every odd-tower field `GF(Q)` with `Q>=2^45`; the generic
degree-six fallback is unnecessary.  Relative coverage remains a separate gate.

## Theorem

Let `F=GF(Q)`, where `Q=2^n`, `n` is odd, and `Q>=2^45`.  C315's `E4` survivor contains a marked
configuration on

    Delta_R=0,       P0=d=1+rho,       theta=w^2+w+1=1,

for which both C316 seed--seed--repair pentics have factor type `(5)` or `(3,2)` and both C316
repair--repair--seed quadratics are irreducible over `F`.  After choosing the collision-invisible
common height away from C316's at most four deleted values, all four collision fibers have no
`F`-point.  By C317, the four full layers therefore form an arc.

The construction is fresh in each field.  It is not a fixed-coefficient scalar-extension family,
and it does not assert relative coverage of the prescribed conic or `C`-completeness.

More precisely, on a skeleton satisfying the open conditions below, the number of common seed
translations `h` that pass all four collision gates and the two seed-zero deletions is at least

    (121/57600)*(Q+1-3676202*sqrt(Q)) - 257/64 - 2.     (1)

This is positive for `Q>=2^45` on the odd tower.

## Coincidence quadratics and their trace classes

Use C315's coordinates `(X_gamma,Y_gamma)` for `gamma in {alpha,beta}`.  On `P0=d` and
`theta=1`,

    Gamma_gamma=(d^2*Y_gamma+1)+(d*X_gamma+1)*omega,

where `omega^2+omega+1=0`.  Write C316's repair--repair--seed variables as

    q=d*omega+u,       z=omega+a.

The coincidence map is `Psi_0=z^2+q*z=Gamma_gamma`.  Its omega coordinate gives

    u=d*(X_gamma+1+a),

and its base coordinate is exactly

    rho*a^2+d*(X_gamma+1)*a+d+d^2*Y_gamma=0.            (2)

For `X_gamma!=1`, equation (2) has no `F`-root exactly when

    Tr(kappa_gamma)=1,
    kappa_gamma=rho*(1+d*Y_gamma)/(d*(X_gamma+1)^2).    (3)

The excluded row `X_gamma=1` is already absent from C315's survivor; there (2) is a purely
inseparable linearized equation and always has one `F`-root.

Fix C327's common translation line

    (X_alpha,Y_alpha)=(x,y_0+h),
    (X_beta,Y_beta)=(x',y'_0+h).

On the generic C315 chart, the four legality equations and the two equations encoding (3) as
trace one are

    U_gamma^2+U_gamma=Y_gamma/X_gamma^2+1,
    V_gamma^2+V_gamma=rho^2*(Y_gamma+1)/(X_gamma+d)^2+1,
    W_gamma^2+W_gamma=kappa_gamma+1.                    (4)

Their six slopes in `h` are

    a_1=1/x^2,                  a_2=rho^2/(x+d)^2,
    a_3=1/(x')^2,               a_4=rho^2/(x'+d)^2,
    a_5=rho/(x+1)^2,            a_6=rho/(x'+1)^2.       (5)

This gives the promised complete dependence-divisor classification.  On the standing open, for
every nonempty `I subset {1,...,6}`, the `I`-character degenerates exactly on

    D_I: sum(i in I) a_i=0.                             (6)

There are no other dependence loci.  The six singleton loci are empty on the standing open; the
subsets of `{1,2,3,4}` specialize to C327's exact seven residual divisors after its standing
factors are removed; and (6) gives every remaining mixed or quadratic-gate divisor without a
choice of square roots.

For an exact polynomial open, put

    L=(x*(x+d)*(x+1)*x'*(x'+d)*(x'+1))^2,
    N_I=L*sum(i in I) a_i,
    P_dep=product(empty!=I subset {1,...,6}) N_I.        (7)

Each `N_I` has total degree at most twelve, so `deg(P_dep)<=756`.  The product is nonzero: over an
algebraic closure the six rational functions in (5) have respectively unique poles on

    x=0, x=d, x=1, x'=0, x'=d, x'=1,

and no nonempty sum can vanish identically.  This pole proof also proves the completeness of (6).

Off `P_dep=0`, every nontrivial character of (4) is an Artin--Schreier equation
`T^2+T=a*h+c` with `a!=0`.  Hence the composite cover `C -> P1_h` is geometrically connected,
Galois of degree `64` with group `(C2)^6`, has constant field `F`, and has genus zero.  It is etale
over `A1_h`; its unique point above infinity is `F`-rational, with full inertia and different
exponent `63*2=126`.  Riemann--Hurwitz gives

    2*g(C)-2=64*(-2)+126=-2.

Thus `C` has exactly `Q` affine `F`-points, and exactly `Q/64` values of `h` satisfy all four
legality traces and both quadratic no-root traces.

## The two pentics remain jointly `S5 times S5`

Retain C327's notation

    s=x+x',       delta_0=d^2*(y_0+y'_0),       delta_1=d*s,
    A_1=d*x,      A_2=d*(x+d),       e_1=1,      e_2=rho.             (8)

The standing open has `d*s!=0`.  C327's individual-monodromy proof remains dominant after (8):
for the first orientation `(delta_0,delta_1,A_1)` are independent generic parameters, while for
the second `(e_2,delta_0,delta_1,A_2)` are independent generic parameters.  Consequently each
specialized pentic has generic geometric group `S5`, with two distinct transposition branch
values off the inherited exact factors `W_i*c_i`.

It remains to replace C327's free-`theta` separation argument.  Let `b,c` be the two critical
parameters and `R_i` its rational functions.  Direct symmetric reduction of C327 (8), using

    (b+c)^2=delta_1,       (b*c)^2=Nm(Delta_S),

gives the critical-value sum

    R_i(b)+R_i(c)=e_i^2+A_i*(A_i+delta_1)/delta_1.       (9)

Substitution of (8) yields

    (R_1(b)+R_1(c))+(R_2(b)+R_2(c))=d^3/s!=0.           (10)

Thus the two irreducible generic degree-two branch divisors are distinct even though
`theta=1` and their target coordinates coincide.  They are therefore coprime; equivalently the
inherited cross-resultant `S` is nonzero on this restricted skeleton.  Deleting `S=0` makes all
four finite critical values pairwise distinct.

As in C327, distinct transposition divisors make the two sign fields distinct, hence the two
splitting fields are disjoint and have joint group `S5 times S5`.  The cover (4) is etale at those
finite divisors.  Any common quotient with the pentic compositum would lie in the biquadratic
compositum of the sign fields and would ramify there, so base change to `C` preserves
`S5 times S5`.

The complete skeleton open is the product of:

1. C327's standing factors after `P0=d,theta=1`;
2. `P_dep` from (7); and
3. the inherited `W_1*W_2*c_1*c_2*S` factors.

It is nonzero by the pole audit, the two dominant individual-monodromy maps, and (10).  C327's
degree estimates give degree at most `704` for item 3 and at most `10` for item 1.  Hence this
restricted open has total degree at most

    10+756+704=1470.                                    (11)

Schwartz--Zippel supplies an `F`-rational skeleton on it whenever `Q>1470`.

## Effective simultaneous count

Over the rational curve `C`, the four finite pentic branch values have `4*64=256` geometric
preimages.  Each has transposition inertia and different exponent two.  At infinity the pentic
inertia audit is unchanged from C327: the two possible joint wild groups give infinity
contribution `16800` or `18600`.  The local `(C2)^6` extension has no common quotient with either
infinity group, whose abelianization is `C3`.

Galois Riemann--Hurwitz for the `S5 times S5` compositum over `C` therefore gives

    g=1837201       or       g=1838101,
    so g<=1838101.                                        (12)

Indeed the finite contribution is `256*14400`, the base term is `-2*14400`, and the larger
infinity contribution is `18600`.

Let `D` be the `44` derangements of types `(5)` and `(3,2)` in `S5`.  Applying Kosters,
Corollary 1.3, elementwise to `D times D`, exactly as in C327, and deleting the `256` finite
ramified points and infinity gives

    N_C >= (121/900)*(Q+1-3676202*sqrt(Q))-257.          (13)

Every acceptable `h` has `64` rational lifts to `C`, all with the same two factor types.  Dividing
(13) by `64` and deleting the two seed-zero translations proves (1).  The right side of (1) is
positive at `Q=2^45`; as a function of `sqrt(Q)` it is increasing from there onward.  This proves
the stated odd-tower threshold.  The common height is independent of all six trace equations and
both pentics, so one finally chooses it away from C316's at most four prescribed-conic and
zero-height values.

The effective source is the one already pinned and cached by C327: Michiel Kosters, *A short proof
of a Chebotarev density theorem for function fields*, Corollary 1.3, arXiv:1404.6345, cached
SHA-256 `a7576fd77dd933e73532f37ac8799de925c58733ddf49f9f11a049c0286a51e1`.

## Evidence and trusted boundary

This is a proof-only result.  Equations (2), (3), (9), and (10) are direct identities in the C315
and C316 coordinates.  The dependence classification uses the exact rational functions (5), and
the threshold uses C327's source-pinned effective Chebotarev bound with the explicitly recomputed
degree, branch count, and genus.  No coefficient census, random sample, or untracked computation
supports the theorem.

C317 is the trusted interface from simultaneous absence of rational points in the four exact
finite fibers to collision-freeness of the four layers.  It does not turn collision-freeness into
relative coverage.  The surviving construction must next prove that every required point of the
prescribed conic still lies on a secant of the four-layer arc.

## Vibe check

Excellent construction progress: the ostensibly degenerate coincidence stratum is exactly the
place where the remaining sextics become two compatible trace gates, and the pentic correlation
stays generic for the explicit reason (10).  The arc-existence mechanism is now complete on an
odd-tower tail; relative coverage is the sole construction-facing risk left before a genuinely
`C`-complete family can be claimed.
