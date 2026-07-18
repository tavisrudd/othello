# C304: alternative towers and a planar-function pilot

**Lane**: `relconic`

Date: 2026-07-18.

## Result

C297's omitted constant-p family has a clean basis-free extension to every finite
characteristic-two base field, but the original C210 scalar tower does not.  These are different
statements.

1. Let `F=GF(2^n)` and `E=GF(2^(2n))`.  A root `omega` of

       X^2+X+1

   lies in `E\F` exactly when `n` is odd.  When `n` is even, `GF(4)` is already contained in `F`,
   so `omega in F`; every displayed coset `e*omega+F` is then just `F`.  Thus the even relative
   scalar steps of the fixed C210 model collapse its marked repair layers.  They are not an
   unproved continuation of the same quadratic-extension construction.
2. For arbitrary `n`, choose `nu in F` with `Tr_F/GF(2)(nu)=1` and let

       rho^2+rho=nu,             E=F+F*rho.

   Replacing `omega` by `rho` makes C297's full constant-p cross-repair construction work
   verbatim.  The proof below gives the exact coefficients and both oriented trace calculations.
   This removes the artificial odd-degree restriction from the *internal and cross-repair* gate,
   but it does not transfer C210's seed--cross-repair collision obstruction: the identities
   `N=a^2+a+1` and `H=delta*N*G1` belong to the old common-direction slice and can degenerate when
   `GF(4) subset F`.
3. The theorem-led odd-characteristic planar pilot stops at an exact identification.  The basic
   planar function `f(x)=x^2` produces precisely the two parallel subfield parabolas already used
   as the C210 seed.  Its relative-difference-set property proves a fixed-displacement chord
   bijection, but supplies neither the separate no-three-collinear condition for a general planar
   graph nor relative completeness.  A third graph on the same subfield domain is immediately
   illegal by the vertical triples.  Hence this pilot gives no new repair architecture and does
   not justify a broader planar-function coefficient search.

The surviving theorem-led frontier is therefore C297's generalized constant-p family at the
seed--cross-repair gate.  C304 does not claim that this larger family is collision-forcing, and it
does not claim a construction.

## Why the original even scalar tower collapses

The roots of `X^2+X+1` are the two nontrivial elements of `GF(4)`.  Finite-field intersections give

    GF(2^n) intersect GF(4) = GF(2^gcd(n,2)).

Since `GF(4) subset GF(2^(2n))`, either root lies in `E`.  It lies outside `F` exactly when `n` is
odd.  For the C210 notation `F=GF(8^m)=GF(2^(3m))`, this is exactly the condition that `m` be odd.

There is an equivalent scalar-extension formulation.  Start with a quadratic Artin--Schreier
extension `E_0/F_0` and extend constants from `F_0` to `F_r=GF(|F_0|^r)`.  The quadratic subfield
`E_0` is contained in `F_r` exactly when `r` is even.  Hence fixed repair cosets defined using an
element of `E_0\F_0` remain nontrivial on odd scalar degrees and collapse on even scalar degrees.
This is a field-intersection fact, not a failure of the collision proof.

To study a base field whose absolute degree is even, one must choose the fresh quadratic extension
`GF(q^2)/GF(q)`, rather than reuse the old `GF(4)` direction.  The next theorem does exactly that.

## Basis-free constant-p theorem

Let `F=GF(2^n)` with `|F|>4`, let `E/F` be quadratic, and choose `rho in E` with

    rho^2+rho=nu,        Tr_F/GF(2)(nu)=1.

Such a `nu` exists, its Artin--Schreier polynomial is irreducible, and its two roots are `rho` and
`rho+1`.  Fix distinct nonzero `e_1,e_2 in F` and put `d=e_1+e_2`.  In the notation

    R_i={P(e_i*rho+r,G_i(r)):r in F},
    G_i(r)=A_i*r^2+B_i*r+C_i,
    K_i=1+A_i,

choose

    K in E^*,       c in F^*,       P in F^*,
    ell=P*(1+sqrt(c)),
    x_0 in F with Tr_F/GF(2)(x_0/P^2)=1,

and arbitrary `B_1,C_1 in E`.  Define the second layer by

    K_1=K,                         K_2=c*K,
    B_2+B_1=ell*K,
    C_2+C_1+B_1*d*rho+d^2*rho^2=K*(x_0+d*P*rho).       (1)

Then both layers are internally legal (`K_i!=0`), and neither orientation has a cross-repair
triple with two points on one layer and one point on the other.

### Proof

Orient two points on `R_1` and one point on `R_2`, use the right-layer parameter `s`, and set

    Y=s+d*rho,
    T=G_2(s)+C_1+B_1*Y+Y^2.

The universal chord equation is

    T=K_1*(p*Y+q),                                      (2)

where `p` and `q` are the pair sum and product of the two left-layer parameters.  Equation (1)
reduces its left side to

    T/K_1=c*s^2+ell*s+x_0+d*P*rho.

Splitting (2) in the basis `(1,rho)` therefore gives

    p=P,
    q=c*s^2+(ell+P)*s+x_0
      =c*s^2+P*sqrt(c)*s+x_0.                           (3)

Put `z=sqrt(c)*s/P`.  The distinct-splitting criterion in characteristic two says that the two
left parameters exist exactly when `p!=0` and `Tr(q/p^2)=0`, whereas (3) gives

    Tr(q/P^2)=Tr(z^2+z+x_0/P^2)=1.                      (4)

In the reverse orientation the forced data are

    p'=P/sqrt(c),
    q'=s^2/c+(P/c)*s+x_0/c.

After division by `(p')^2=P^2/c`, the same calculation gives

    Tr(q'/(p')^2)=Tr((s/P)^2+s/P+x_0/P^2)=1.            (5)

Thus neither orientation splits distinctly.  Notice that only the existence of an
Artin--Schreier basis and the absolute-trace identity `Tr(z^2+z)=0` were used; the special equation
`rho^2+rho+1=0` was not.  This proves the claimed extension of C297's constant-p gate.

The theorem deliberately stops before seed--repair legality, pointwise avoidance of the prescribed
conic, and relative coverage.  Those conditions involve `alpha,beta,C_1` and the full collision
correspondence and are not consequences of (4)--(5).

## Exact boundary for other characteristic-two towers

The preceding theorem separates three cases that should no longer be conflated.

- **Odd scalar degrees of one fixed quadratic model.**  The original `omega` direction remains
  external, and C210's committed obstruction applies on its exact common-curvature,
  common-linear-direction slice.
- **Even scalar degrees of that fixed model.**  The quadratic direction enters the scalar field,
  the additive repair cosets collapse, and there is no same-model C210 configuration to audit.
- **Fresh quadratic extensions over even-degree fields.**  A new trace-one `nu` and root `rho`
  restore the layer geometry.  The constant-p theorem above proves internal and cross-repair
  legality, but C210's reconstruction denominator and factorization classification do not transfer.

In particular, the vanishing of `a^2+a+1` over fields containing `GF(4)` explains why one cannot
merely replace “odd” by “even” in the old proof.  It is not an obstruction to the generalized
`K`-family: that family uses `K_1,K_2!=0` directly and never divides by `a^2+a+1`.

Modified planar functions in characteristic two also live in a different arithmetic model.  The
standard even-characteristic definition replaces the odd-characteristic derivative by

    x -> f(x+a)+f(x)+a*x,

and the associated relative difference set naturally lives in a group of exponent four, rather
than the elementary-abelian group used in odd characteristic.  Thus it does not drop unchanged
into the C210 chord-height equations.  A future characteristic-two function pilot must first
derive its actual projective layer and seed--repair formulas.

## Odd-characteristic planar-function pilot

Let `F=GF(q)` have odd characteristic.  The function

    f(x)=x^2

is planar because, for every `a!=0`,

    f(x+a)-f(x)=2*a*x+a^2

is a permutation of `F`.  Equivalently, its graph

    D={(x,x^2):x in F}

is a `(q,q,q,1)` relative difference set in the additive group `F^2` relative to the vertical
subgroup: every difference `(a,b)` with `a!=0` has a unique ordered representation as a difference
of two graph points.

Embed this graph in the C210 conic coordinates by vertical translation:

    S_alpha={P(t,alpha)=[1:t:t^2+alpha]:t in F}.

For `alpha,beta in E^*` with `delta=beta-alpha notin F`, the union

    S_alpha union S_beta

is the same two-parabola `2q`-arc used as the C210 seed.  Indeed, a mixed three-point determinant
is, up to a nonzero sign,

    (u-t)*((v-t)*(v-u)+delta).

The product term lies in `F` and cannot equal `delta`; repeated horizontal parameters reduce to a
nonzero multiple of `delta`.  Same-layer triples lie on a nonsingular conic and are also excluded.

This is a useful sanity check but not a new architecture.  The strongest classical planar example
has recovered the already-known seed exactly.  Moreover, adding a third translated graph over the
same domain is impossible: for each `t in F`, its point and the two seed points share the vertical
line `Y=tX`.  This obstruction is independent of the chosen planar function.

For a general planar function, the derivative-permutation theorem controls pairs with one fixed
horizontal displacement.  The projective arc gate instead requires every affine line to meet the
graph in at most two points, equivalently

    |{x in F : f(x)-m*x=b}| <= 2                         (6)

for all `m,b in F`.  Relative completeness asks for still different secant-intercept image sets
after embedding in `PG(2,E)`.  Neither (6) nor that coverage assertion follows from the planar
definition.  Any further planar or relative-difference-set candidate must therefore arrive with
separate proofs of:

1. internal graph arc legality;
2. cross-layer and seed--repair legality; and
3. coverage of the required off-conic points.

Planar terminology alone clears none of these three gates.  This is the stop condition for the
C304 pilot.

## Literature boundary

The planar/relative-difference-set equivalence and the distinction between odd and even
characteristic are summarized in Pott--Schmidt--Zhou,
[*Semifields, relative difference sets, and bent functions*](https://arxiv.org/abs/1401.3294).
The modified even-characteristic derivative and its projective-plane motivation are from
Schmidt--Zhou,
[*Planar functions over fields of characteristic two*](https://arxiv.org/abs/1301.6999).
For the classical finite-field planar-function boundary, see Ronyai--Szonyi,
[*Planar functions over finite fields*](https://doi.org/10.1007/BF02125898).

These sources support the function-theory definitions and relative-difference-set interpretation.
The tower-collapse lemma, basis-free constant-p theorem, and projective pilot above are direct
finite-field and incidence calculations in this report.

## Evidence and claim boundary

This report is proof-only.  It introduces no generated artifact or computational claim.  Its
inputs are C297's equations (10)--(11) and the universal chord identity already proved in the C210
bundle.  The calculation (2)--(5) is the independent basis audit that shows exactly which part of
C297 survives.

The report does **not** prove:

- seed--cross-repair legality or collision-forcing for the generalized constant-p family;
- relative completeness for any new family;
- an obstruction to arbitrary planar, modified-planar, linearized, or o-polynomial layers; or
- a C210 theorem on even scalar extensions, where the original model has collapsed.

## Vibe check

This is a clean scope win rather than a construction breakthrough.  It removes a misleading
“even-tower gap,” exports C297's most promising omitted family to every characteristic-two base
field, and prevents planar-function language from reopening an unstructured search.  The real
mathematical risk is now concentrated where it belongs: the generalized family's seed--cross-repair
collision correspondence.
