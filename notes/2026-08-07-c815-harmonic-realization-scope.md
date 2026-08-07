# Scope for the harmonic rows of gap class B

**Lane:** `clebsch`
**Date:** 2026-08-07
**Task:** C815, rows HARM-1 and HARM-2 of
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`

## What the two rows still exclude

Row HARM-1 excludes the face-axis geometry, the spherical addition theorem, and
the abstract `A5` comparison.  Row HARM-2 excludes the invariant-line input for
the geometric spherical cubic and the raw spherical moment.  Both rows carry
manuscript Theorem `thm:harmonic-main` in
`papers/clebsch-passages/sections/05-harmonic-realization.tex`: the ten labelled
icosahedral face axes give an injective copy of the Clebsch four-space in the
real degree-six spherical harmonics, and the spherical cubic on that copy is
`-784000/1247103` times `sigma_3`.

What Lean has today is the algebra downstream of those exclusions.
`RelativeConicArcs.PetersenHarmonicKernel` starts from the *displayed* operator
`(196 I + 47 J - 112 A)/243`, divides by thirteen by fiat, and derives the
pair-sum eigenvalue `140/1053`; `RelativeConicArcs.ClebschInvariantCubic` starts
from the *hypothesis* that the cubic lies on the `sigma_3` line and from the
*given* value `-15680000/1247103` at the marked vector.  Neither the geometry
that produces the two orbit values, nor the analysis that produces the factor
one thirteenth, nor the value itself, is proved.

## Route

The chosen route removes the analysis rather than formalizing spherical harmonic
theory.  Its pivot is that the normalized spherical average of a polynomial in
three variables can be introduced as an explicitly defined linear functional and
then characterized algebraically, after which every remaining step of the
manuscript's proof is polynomial identity.

**The moment functionals.**  Let `N` be the standard Gaussian moment functional
on `R[x1,x2,x3]`, given on monomials by `N(x^a y^b z^c) = (a-1)!!(b-1)!!(c-1)!!`
when every exponent is even and by zero otherwise, and for a form of degree `d`
let `M(p) = N(p)/(d+1)!!`.  Three facts carry everything:

1. `N(1) = 1` and `N(x_i p) = N(d_i p)`, and these two properties determine `N`
   uniquely by induction on degree.
2. Consequently `N` is invariant under every orthogonal substitution: the
   functional `p |-> N(p o R)` satisfies the same two properties, because
   `R R^T = 1` collapses the chain rule, so it is `N`.  Hence `M` is invariant
   too, and `M(1) = 1` with `M((x.x) p) = M(p)` by Euler's relation, so `M` is a
   normalized invariant functional on functions on the sphere.
3. If `p` is harmonic and homogeneous of degree `d` and `q` is homogeneous of
   degree `d`, then `N(p q) = p(d) q`, the apolar pairing.  The induction is
   Euler's relation `d p = sum x_i d_i p`, one application of property 1, and the
   vanishing of `Delta p`.

**The addition theorem becomes apolarity.**  For a unit axis `u` write
`Z_u(x) = (231 (u.x)^6 - 315 (u.x)^4 (x.x) + 105 (u.x)^2 (x.x)^2 - 5 (x.x)^3)/16`,
the homogenization of `P_6(u.omega)`.  It is harmonic, by one polynomial identity
modulo `u.u = 1`.  Since `Z_v` is harmonic, only the top term of `Z_u(d)`
survives, and the Leibniz computation
`(u.d)^6 (v.x)^6 = 720 (u.v)^6`,
`(u.d)^6 ((v.x)^4 (x.x)) = 720 (u.v)^4 (u.u)`,
`(u.d)^6 ((v.x)^2 (x.x)^2) = 720 (u.v)^2 (u.u)^2`,
`(u.d)^6 (x.x)^3 = 720 (u.u)^3`, in which the unit hypothesis on `u` is used
exactly where the factors `(u.u)` appear, gives `Z_u(d) Z_v = 10395 P_6(u.v)`.  Dividing by `13!! = 135135` turns fact 3
into the manuscript's Gram identity `G = K/13` with no integral anywhere.  The
three Gram eigenvalues then follow from the Petersen eigenvalues exactly as the
manuscript says, and their positivity gives injectivity.

**The face-axis labelling is ring-general.**  Over any commutative ring carrying
an element `phi` with `phi^2 = phi + 1`, the ten displayed vectors have squared
norm `3`, and the square of the inner product of two distinct axes is `5` when
the label pairs are disjoint and `1` when they meet.  That is the whole content
of "the labeling is geometric": it identifies the incidence graph as `KG(5,2)`
and supplies the two squared angles `5/9` and `1/9` that the Legendre polynomial
converts into `-65/243` and `47/243`.

**The alternating group acts by rotations.**  Three explicit matrices over the
same ring permute the ten axes up to sign and induce `(2 5)(3 4)`, `(3 5 4)` and
`(1 2)(3 5)` on the five labels; the certificate checks that the subgroup they
generate has order sixty and consists of even permutations, hence is the
alternating group.  With the invariance of `M` this makes `y |-> M(F_y^3)` an
`A5`-invariant cubic form on the sum-zero four-space, which is the
invariant-line input of HARM-2.  The Lean development does not depend on that
generation statement: because the certificate establishes the cubic identity for
arbitrary sum-zero `y`, the module proving it will prove the identity directly
rather than through invariance, and the rotations serve only to record that the
configuration carries the icosahedral action.

**The abstract comparison.**  The action of `A5` on five letters is
two-transitive, so its commutant on the five-coordinate module is spanned by the
identity and the all-ones matrix; the restriction to the sum-zero four-space is
therefore scalar, and preserving `sigma_3` forces the scalar to be a cube root of
one, hence one.  This is linear algebra over the rationals and needs nothing
above.

**Two conventions the later modules must pin down.**  The certificate takes
`sigma_3(y)` to be `(1/3) sum y_i^3`, while the manuscript's `sigma_3` is the
third elementary symmetric function; the two agree on the sum-zero module, and
the module proving the cubic identity must fix one definition and record the
equivalence.  And because the identification of `M` with the surface integral is
the declared trust boundary, each module stating a theorem about `M` must say so
in its header, so that no theorem about the functional is read as a theorem about
the integral.

**The cubic value.**  The marked field `F_y` for `y = (4,-1,-1,-1,-1)` is
`35/24` times a cubic form in `x1^2, x2^2, x3^2` with ten coefficients in
`Z[sqrt 5]`, so its cube has at most fifty-five monomials and `M` evaluates it
directly.  The exact checks below confirm more: the identity
`M(F_y^3) = -784000/1247103 sigma_3(y)` holds for symbolic `y` modulo the
sum-zero relation, so the invariant-line argument can be used to shorten the
proof but is not needed to state the theorem.

## What stays outside

One classical statement is not closed by the route above, and the scope of that
sentence is the manuscript's Theorem `thm:harmonic-main` rather than the whole
section: that the explicitly defined functional `M` is the normalized surface
integral over the two-sphere.  Every theorem stated in terms of `M` remains
correct as stated without it, and the manuscript displays exactly the same
monomial formula as its own computational input.  Closing it means deriving the
monomial formula from the polar decomposition of Lebesgue measure on three-space
together with the one-dimensional Gaussian moments, which Mathlib supports
through `MeasureTheory.Measure.measurePreserving_homeomorphUnitSphereProd` and
`integral_gaussian`, and it belongs in a module of its own so that the algebraic
development does not depend on measure theory.

Three further assertions of the section lie outside the main theorem and outside
this route, and none of them is owned by any existing row of the gap inventory.
They are recorded here so that the row is not closed while they are unattended:

1. the covariant-obstruction paragraph, that no rotation-equivariant polynomial
   covariant induces the linear bridge, whose content is the vanishing of
   `Hom_{SO(3)}(H_R, H_6)` between non-isomorphic irreducible rotation modules
   together with the homogeneous-parts reduction;
2. the non-arithmetic content of the Gaunt factorization: that the first factor
   is the square of the Wigner symbol `(6 6 6; 0 0 0)`, that `46189` is
   therefore the universal degree-six denominator, and that multiplicity one is
   what reduces the cubic to the marked fixed line;
3. the Condon--Shortley remark, whose two displayed constants follow from the
   stated conversion factor but whose conversion factor itself is a
   special-function input.

Their pure arithmetic is verified — `46189 = 11 * 13 * 17 * 19`,
`46189 * 27 = 1247103`, `400 * 1960 = 784000`, `13 * 1247103 = 4563 * 3553` —
so what these three need is an owner for their representation-theoretic and
special-function inputs, not a computation.

## Module plan

| module | content | closes |
|---|---|---|
| `RelativeConicArcs.IcosahedralFaceAxes` | the ten labelled axes over a ring with a golden element; squared norms and squared inner products; the Kneser incidence; the three rotation generators and their label permutations | face-axis geometry of HARM-1 |
| `RelativeConicArcs.SphericalMomentFunctional` | `N` and `M`, the integration-by-parts recursion, uniqueness, orthogonal invariance, the sphere relation, and `N(p q) = p(d) q` for harmonic `p` | the analytic input of both rows, modulo the identification above |
| `RelativeConicArcs.ZonalHarmonicDegreeSix` | the degree-six zonal harmonic, its harmonicity, and `Z_u(d) Z_v = 10395 P_6(u.v)` | spherical addition theorem of HARM-1 |
| `RelativeConicArcs.FaceAxisHarmonicGram` | the ten zonal harmonics, `G = K/13`, the three eigenvalues, injectivity | the Gram half of HARM-1 |
| `RelativeConicArcs.AlternatingComparisonLine` | the commutant computation, the identification of an equivariant comparison with a multiple of the pair-sum map, the construction of the coordinate representative that identification needs, and the `sigma_3`-normalized uniqueness | abstract `A5` comparison of HARM-1 |
| `RelativeConicArcs.SphericalCubicRestriction` | `M(F_y^2) = (140/351) sum y_i^2` and `M(F_y^3) = -784000/1247103 sigma_3(y)` on the sum-zero module, with the marked values `2800/351` and `-15680000/1247103` | HARM-2, and the manuscript's quadratic identity |
| `RelativeConicArcs.SphereIntegralMoments` | the identification of `M` with the normalized surface integral; the only module importing measure theory | the trust boundary named above |

`RelativeConicArcs.PetersenHarmonicKernel` and
`RelativeConicArcs.ClebschInvariantCubic` are not replaced: their present
statements become consequences whose displayed hypotheses are discharged.

## Exact checks

`notes/2026-08-07-c815-harmonic-realization-checks.py` computes every quantity
above in exact arithmetic over `Q(sqrt 5)` and writes
`notes/2026-08-07-c815-harmonic-realization-checks.json`.  Replay from the
repository root:

```sh
uv run --with sympy python3 notes/2026-08-07-c815-harmonic-realization-checks.py \
  --check notes/2026-08-07-c815-harmonic-realization-checks.json
```

What the certificate records: the ten axes have squared norm `3` and squared
inner products `5` and `1` according to Kneser disjointness; `P_6` takes `1`,
`-65/243` and `47/243` at the three orbit values; the zonal polynomial has
vanishing Laplacian modulo `u.u = 1`; the apolar residual
`Z_u(d) Z_v - 10395 P_6(u.v)` vanishes modulo `u.u = v.v = 1`; the Gaussian
functional satisfies the integration-by-parts recursion on every monomial with
each exponent at most four, and the apolar identity on three harmonic samples; the
spherical Gram matrix of the ten zonal harmonics equals `K/13` with eigenvalues
`110/1053`, `140/1053` and `28/1053` of multiplicities `1, 4, 5`; the pair-sum
vectors are Petersen `(-2)`-eigenvectors; the three displayed matrices are
rotations inducing the stated label permutations, whose generated subgroup has
order sixty and consists of even permutations, hence is the alternating group; and both the quadratic residual
`M(F_y^2) - (140/351) sum y_i^2` and the cubic residual
`M(F_y^3) + (784000/1247103) sigma_3(y)` vanish modulo the sum-zero relation,
with marked values `2800/351`, `-15680000/1247103` and `sigma_3 = 20`.

What it does not certify: that `M` is the surface integral, which is the
classical input named above, and nothing about the Lean development, which is
checked by its own gates.

Hashes and byte counts:

| artifact | bytes | sha256 |
|---|---|---|
| `notes/2026-08-07-c815-harmonic-realization-checks.py` | 15265 | `188c1aaccfdaab4d7849c0241d5bb1dcbc56f40c993aaba7a3fc6143b5bd83c5` |
| `notes/2026-08-07-c815-harmonic-realization-checks.json` | 1492 | `a870063928c5791ab753cec9291dce9dd37cb9fb35955ebb29db9ebf00098d58` |

Cross-check.  The paper's own evidence bundle
`papers/clebsch-passages/verification/evidence/harmonic_clebsch.py` records
`-784000/1247103`, `-15680000/1247103` and `2800/351`.  It is an independent
implementation — hand-written exact arithmetic in `Q(sqrt 5)` and a hand-written
polynomial type, against sympy here — but not an independent method: it applies
the same monomial formula.  The genuinely independent check in this bundle is
internal and structural: the symbolic residual
`M(F_y^3) + (784000/1247103) sigma_3(y)` vanishes for arbitrary `y` modulo the
sum-zero relation, which no single numerical value can produce by accident, and
the apolar identity reproduces the Gram matrix through a route that never
evaluates a monomial average.
