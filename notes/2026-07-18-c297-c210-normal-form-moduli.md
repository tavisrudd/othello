# C297: the C210 quadratic family is a proper normal-form slice

**Lane**: `relconic`

Date: 2026-07-18.

## Result

The C210 trace-one two-repair-coset family is **not** universal among natural full quadratic
two-repair-coset extensions of the two-parabola seed, even after genuine projective equivalence,
seed and repair interchange, and field automorphisms.

There are two separate conclusions.

1. The genuine projective quotient is small and explicit.  Once the prescribed conic and the
   parallel-layer presentation are retained, every projectivity between two such configurations
   is induced by

       (x,h) -> (lambda*x+mu, lambda^2*h),
       lambda in F^*, mu in F.                              (1)

   It leaves each quadratic coefficient invariant, scales each linear coefficient by `lambda`,
   and changes only the constant coefficient under translation.  Field automorphisms enlarge
   this to a semilinear quotient; they are not extra elements of `PGL(3,E)`.
2. On the exact constant-pair-sum Artin--Schreier locus, the natural trace-compatible family has
   three genuine `F`-degrees of freedom omitted by C210: a relative scale `c` between the two
   quadratic curvatures, the unrestricted `E/F` direction of the first curvature, and the
   unrestricted `E/F` direction of the first linear coefficient.  C210 is the slice

       c=1,        A_1=a*omega,        B_1=b*omega.          (2)

   None of these three normalizations is supplied by the conic stabilizer.  In particular, the
   first condition is projectively visible through the unordered pair `{A_1,A_2}`.

Thus the completed C210 obstruction remains exactly correct in its committed scope, but it is not
a classification theorem for all full quadratic trace-compatible two-coset architectures.  Paper
II must define the C210 family as the common-curvature, common-linear-direction slice (2), rather
than as *the* general quadratic two-coset normal form.  The omitted moduli are genuine input for
C304, while the quotient below clears the C297 gate for C301.

This report proves a normal-form and moduli statement.  It neither constructs an arc after the
seed--repair gates nor weakens any collision theorem already proved inside C210.

## Natural marked family

Let `E/F` be quadratic of characteristic two, with `|F|>4`, and fix

    omega^2+omega+1=0,       E=F+F*omega.

On the odd C210 tower this is canonical up to `omega <-> omega+1`: `F` has odd degree over
`GF(2)`, so it does not contain `GF(4)`, while `E` does.  Write

    P(x,h)=[1:x:x^2+h]

relative to the prescribed conic `C : XZ=Y^2`.  A natural marked configuration consists of two
seed layers

    S_alpha={P(t,alpha):t in F},
    S_beta ={P(t,beta ):t in F},                            (3)

and two full quadratic repair layers

    R_i={P(e_i*omega+r, G_i(r)):r in F},
    G_i(r)=A_i*r^2+B_i*r+C_i,                              (4)

where `e_i in F^*`, `e_1!=e_2`, and `A_i,B_i,C_i in E`.  The usual open conditions are

    alpha*beta!=0,       alpha+beta notin F,
    A_i!=1,

together with pointwise conic avoidance when it is required.  The first line makes (3) the
standard two-parabola seed arc.  The condition `A_i!=1` is exactly the internal arc condition for
one full repair layer, because the three-point determinant is

    (r+s)*(r+u)*(s+u)*(1+A_i).

Choosing the representative `e_i*omega` of its additive coset is parameterization gauge: replacing
it by `e_i*omega+d_i` and replacing `r` by `r+d_i` describes the same point set.  After the
displayed representatives are fixed, the coefficients in (4) are unique.

C210 restricts (4) to

    A_1=A_2=a*omega,       B_1=B_2=b*omega,                (5)

with arbitrary constants `C_i=c_i0+c_i1*omega`, followed by its constant-pair-sum trace-one
condition.  The restriction (5) was a selected coefficient slice motivated by the `PG(2,64)`
survivors.  It is not a consequence of writing an arbitrary `E`-valued quadratic graph in the
basis `(1,omega)`.

## Exact cross-repair trace reduction

The omitted family can be seen without a coefficient census.  Orient a possible cross-repair
triple with two points of `R_1`, at parameters `r,u`, and one point of `R_2`, at parameter `s`.
Put

    d=e_1+e_2,       Y=s+d*omega,
    K_i=1+A_i,
    T=G_2(s)+C_1+B_1*Y+Y^2.

If `p=r+u` and `q=r*u`, the chord-height identity reduces exactly to

    T=K_1*(p*Y+q).                                      (6)

Write

    T/K_1=U_2*s^2+U_1*s+U_0,
    U_j=x_j+y_j*omega,       x_j,y_j in F.

Equation (6) has the unique forced pair sum and product

    p(s)=(y_2*s^2+y_1*s+y_0)/d,
    q(s)=x_2*s^2+x_1*s+x_0+s*p(s).                       (7)

There are two distinct left-repair points precisely when

    p(s)!=0 and Tr_F/GF(2)(q(s)/p(s)^2)=0.               (8)

This recovers the C210 formula, but it also displays its missing hypotheses.  In particular,
`p(s)` is constant exactly when

    K_2/K_1=c in F^*,
    (B_2+B_1)/K_1=ell in F.                              (9)

C210 sets `c=1` and `ell=0`; (9) does not force either equality.

### Complete constant-p trace-compatible family

Fix

    c in F^*,       P in F^*,       ell=P*(1+sqrt(c)),
    x_0 in F with Tr(x_0/P^2)=1.                           (10)

Choose arbitrary `K in E^*` and `B_1,C_1 in E`, and impose

    K_1=K,                    K_2=c*K,
    B_2+B_1=ell*K,
    C_2+C_1+B_1*d*omega+d^2*omega^2
      =K*(x_0+d*P*omega).                                 (11)

Then (7) in the first orientation is

    p=P,
    q=c*s^2+(ell+P)*s+x_0.

Since `ell+P=P*sqrt(c)` and `Tr(z^2)=Tr(z)`, its trace is identically

    Tr(q/P^2)=Tr(x_0/P^2)=1.                              (12)

In the reverse orientation the corresponding data are

    p'=P/sqrt(c),
    q'=s^2/c+(P/c)*s+x_0/c,

and division by `(p')^2=P^2/c` gives the same trace cancellation and the same constant in (12).
Thus the two repair layers have no `2+1` cross-repair triple in either orientation.  Because
`K_1,K_2` are nonzero, they are also internally arc-legal.

The trace-one constant can be parameterized in the C210 manner by

    x_0/P^2=w^2+w+1.

This makes (10)--(11) a full algebraic trace-compatible family over every odd scalar extension.
It is not a finite-field accident.

C210 is obtained from (10)--(11) only after the three extra restrictions

    c=1,        K=1+a*omega,        B_1=b*omega.           (13)

Then `ell=0`, so `A_2=A_1` and `B_2=B_1`, and (11) is precisely the common trace-one constant-sum
relation used by C210.

### Explicit inequivalent subfamily

Take `K=1`, `B_1=0`, and any `c in F^*\{1}`.  Then

    A_1=0,             A_2=c+1,
    B_2=1+sqrt(c),

with the constants determined by (11).  Both repair layers are internally legal and the two
cross-repair orientations have trace one.  The unordered repair-curvature pair is

    {A_1,A_2}={0,c+1}.                                  (14)

Every C210 member has pair `{a*omega,a*omega}`.  The projective action derived below preserves
each `A_i`, and field automorphisms preserve equality versus inequality.  Therefore (14) is not
projectively or semilinearly equivalent to a C210 member.

If pointwise conic avoidance is desired, it does not remove this counterfamily.  For fixed
nonconstant coefficients, at most `q` choices of `C_1` make a point of `R_1` have height zero and
at most `q` choices make a point of `R_2` have height zero.  Since `q^2>2q`, some `C_1 in E`
avoids both sets.  The statement is still only about the internally trace-compatible repair
architecture; seed--repair legality remains a separate gate.

### A second omitted stratum

There is also a possible linear-pair-sum stratum, absent from C210.  After a projective subfield
translation places its pole at `s=0`, write

    U_2=c,
    U_1=d*L*(z+omega),
    U_0=d^2*z^2,

with `c,L in F^*`.  The two orientations are trace-compatible exactly when

    1+L*(z^2+z+1)+c=0,
    Tr((c+L)/L^2)=1,
    Tr(c*(1+L)/L^2)=1.                                  (15)

Indeed the first orientation has `p=L*s`; after the double pole is reduced modulo `g^2+g`, its
constant class is `(c+L)/L^2`.  The displayed quadratic equation is exactly the reverse-orientation
simple-pole cancellation, and its constant class is `c*(1+L)/L^2`.  C210's restriction `c=1`
makes the first constant `L^-2+L^-1`, of trace zero, which is why its earlier linear-p branch could
not survive.  Equation (15) records another genuine omitted locus whenever its elementary field
conditions have a solution; no claim about its seed--repair gate is made here.

## The genuine conic-stabilizer action

The stabilizer of the standard conic is the symmetric-square image of `PGL(2,E)`.  A matrix

    [[a,b],[c,d]]

acts in characteristic two by

    [X:Y:Z] ->
    [a^2*X+b^2*Z,
     a*c*X+(a*d+b*c)*Y+b*d*Z,
     c^2*X+d^2*Z].                                      (16)

Every layer in (3)--(4) is the `q`-point affine part of a conic through
`P_infinity=[0:0:1]`, tangent there to `X=0`.  A projectivity taking one marked parallel-layer
family to another fixes `P_infinity`; hence `b=0` in (16).  Mapping an `F`-coset of horizontal
coordinates to another `F`-coset then forces `lambda=d/a in F^*`, and the repeated seed domain
forces `mu=c/a in F`.  After projective rescaling, (16) is exactly (1), represented by

    [X:Y:Z] -> [X, lambda*Y+mu*X, lambda^2*Z+mu^2*X].    (17)

For an unmarked configuration this conclusion is automatic once the four layer conics are
intrinsic.  For `q>16`, any different conic contains at most four points from each of the four
layer conics, hence at most sixteen configuration points.  It cannot supply a competing
`q`-point layer.  Thus (17) is also the full unmarked conic-stabilizer action throughout the
asymptotic C210 range.  The exceptional `q=8` full-projective classification belongs to C300.

With the canonical representatives `e_i*omega`, (17) acts by

    alpha -> lambda^2*alpha,       beta -> lambda^2*beta,
    e_i   -> lambda*e_i,
    A_i   -> A_i,
    B_i   -> lambda*B_i,
    C_i   -> lambda^2*C_i+A_i*mu^2+lambda*B_i*mu.        (18)

This proves directly that `A_i` is a genuine projective invariant.  In particular, neither a
weighted rescaling nor a subfield translation can turn `A_1!=A_2` into the C210 equality.

## Exact projective and semilinear quotients

First label the seed pair and the repair pair.  Normalize `e_1=1` using `lambda=e_1^-1` and put

    rho=e_2/e_1,
    alpha_hat=alpha/e_1^2,       beta_hat=beta/e_1^2,
    B_i_hat=B_i/e_1,             C_i_hat=C_i/e_1^2.      (19)

The ordered projective moduli are exactly the tuples

    (rho,alpha_hat,beta_hat,A_1,A_2,
     B_1_hat,B_2_hat,C_1_hat,C_2_hat)                    (20)

modulo the one remaining additive action

    C_i_hat -> C_i_hat+A_i*mu^2+B_i_hat*mu,
    mu in F.                                             (21)

Equations (19)--(21), with the stated open conditions, are the genuine quotient.  The natural
family has eighteen `F`-parameters before projective equivalence and sixteen generically after
the two-dimensional affine stabilizer.  Finite interchange and Galois quotients do not change
that dimension.

Seed interchange swaps `alpha_hat,beta_hat`.  Repair interchange sends

    rho -> rho^-1,
    (alpha_hat,beta_hat) -> (alpha_hat/rho^2,beta_hat/rho^2),
    (A_1,A_2) -> (A_2,A_1),
    (B_1_hat,B_2_hat) -> (B_2_hat/rho,B_1_hat/rho),
    (C_1_hat,C_2_hat) -> (C_2_hat/rho^2,C_1_hat/rho^2),  (22)

followed by the translation quotient (21).

For a field automorphism `sigma` of `E` preserving `F`, put

    epsilon_sigma=sigma(omega)+omega in {0,1}.

Before the normalization (19), the exact semilinear action obtained by applying `sigma` and then
(17) is

    e_i' =lambda*sigma(e_i),
    kappa_i=lambda*epsilon_sigma*sigma(e_i)+mu,
    A_i' =sigma(A_i),
    B_i' =lambda*sigma(B_i),
    C_i' =lambda^2*sigma(C_i)
            +sigma(A_i)*kappa_i^2
            +lambda*sigma(B_i)*kappa_i,                 (23)

with `alpha'=lambda^2*sigma(alpha)` and similarly for `beta`.  Quotienting (20) by (23), together
with the two interchanges, is the genuine semilinear moduli quotient.  Treating Frobenius as an
ordinary projectivity would merge inequivalent `PGL(3,E)` orbits.

On the constant-p trace-compatible locus (10)--(11), the normalized parameter count is thirteen
after (21).  The C210 restrictions (13) cut out a codimension-three subfamily, of dimension ten,
before discrete quotients.  These counts include the moving seed pair; fixing it removes the same
four `F`-parameters from both sides.

## Gauge, relabeling, and geometry

The quotient audit separates operations that had previously appeared together in collision
calculations.

- **Genuine projectivities:** (17), including weighted scaling and subfield translation, provided
  they act on the entire configuration.  The weights
  `x,e,d,b,p,r` of one and `h,C` of two are exactly the geometric weights in (18).
- **Not a stabilizer of a fixed seed:** scaling changes `(alpha,beta)` to
  `(lambda^2*alpha,lambda^2*beta)`.  Thus the `p=1` chart is a genuine equivalence in the moving-seed
  moduli problem, but it is only a lossless one-seed collision chart when the original two-seed
  configuration is held fixed.  Generically a fixed seed pair has no nontrivial scaling.
- **Equation/parameterization gauge:** changing a coset representative by an element of `F`,
  changing the repair parameter accordingly, multiplying a resultant by a nonzero scalar, and
  replacing `w` by `w+1` in `w^2+w+1`.  These do not supply new projective transformations of the
  point set.
- **Relabeling:** seed interchange and repair interchange.  They are quotients of the unlabeled
  construction even when no projectivity realizes the swap.
- **Semilinear equivalence:** Frobenius and the relative conjugation `omega<->omega+1`, governed by
  (23).  This is appropriate for arithmetic classification, but is strictly coarser than genuine
  projective equivalence.
- **Enumeration symmetry only:** an action on `(R,H,J)` is not a geometric quotient unless it
  lifts to (18) on every selected point.  In particular, forgetting `e,C_1,C_2` or using only the
  invariance of the collision resultant is not a moduli reduction.

This also sharpens the C305 scaling boundary: its weighted `p=1` action is the restriction of a
real conic-stabilizer projectivity, but C305 correctly did not claim that it fixes the chosen
two-seed configuration.

## Consequences and evidence boundary

The C210 theorem should be cited invariantly as an obstruction to the family of two full
quadratic repair sections whose curvatures and linear terms lie in the chosen `omega*F` direction
and agree across the two repair cosets, subject to the common trace-one relation.  It should not
be cited as an obstruction to all quadratic repair sections.

C301 may now use (20)--(23) as the exact parameter space and symmetry boundary for the first
exceptional-incidence theorem.  C304 should begin with the codimension-three constant-p extension
(10)--(11), and only then decide whether the linear-p stratum (15), even scalar extensions, or
other function architectures deserve separate pilots.  A larger coefficient census is not the
next step.

The proof is direct algebra from the universal height-interpolation identity and the
characteristic-two symmetric-square action.  It introduces no computational claim or generated
artifact.  Its C210 inputs are the selected family in
[`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md),
especially gates 35--39, and the completed bounded obstruction in
[`2026-07-17-c210-bounded-two-repair-coset-obstruction.md`](2026-07-17-c210-bounded-two-repair-coset-obstruction.md).
The lossless one-seed scaling distinction is independently recorded in
[`2026-07-18-c305-c210-q512-generic-closure.md`](2026-07-18-c305-c210-q512-generic-closure.md).

## Vibe check

This is a useful negative scope result, not a setback.  C210 remains a strong obstruction on a
natural low-dimensional slice, while C297 prevents Paper II from overstating that slice as a
classification theorem and exposes a small, theorem-led set of omitted moduli for the next attack.
