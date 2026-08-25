# C958 generic split parametrization

**Lane:** `cubic-threefolds`

## Result

The first constructive stage of C958 is complete over the generic split Cox
field `Q(a,b)`.  The certificate gives:

- the three tangent hyperplanes through the first C956 orbit-test witness;
- the four signed maximal minors defining the orbit correction;
- the normalized projective `T_3`-weight of every Cox coordinate; and
- the integral Laurent exponent of its correction factor.

Write `r_i=kappa_i/kappa_0` in the block order

```text
(110): E1,E2,E5;       (101): L14,L24,L45;
(011): L13,L23,L35;    (111): L12,L15,L25.
```

Up to the common projective factor, the orbit correction is

```text
E1,E2,E5                 1
L14,L24,L45              r1
L13,L23,L35              r2
L12,L15,L25              r3
E3                       r2^(-1) r3
E4                       r1^(-1) r3
L34                      r1 r2 r3^(-1)
Q                        r1 r2
```

The script checks the twenty Cox quadrics at the tangent and orbit-test
points, containment of the boundary subspace, vanishing of the three slice
forms at the orbit-test point, the cofactor kernel identity, unimodularity,
and integrality of every Laurent exponent.

The expanded formulas are already nontrivial: the three hyperplane rows use
1039, 1099, and 1158 serialized characters; the four signed minors use 3373,
4480, 3908, and 4506.  This strongly favors a compact machine-readable
artifact rather than printing the eventual composite maps in the main paper.

## Descent boundary

This is a split-field certificate, not yet a parametrization of either cubic
product over `Q`.  The `a,b` here are the moduli of five marked blow-up points
in the split Cox model.  They are not the base coordinate called `a` in
Tschinkel--Zhang Propositions 5.1 and 5.2.

For the type-`I_1` series, the generic cubic surface is over
`K=Q(a,b_1,...,b_r)` and has conic-bundle splitting group `C2 x S3`.  For the
type-`I_3` series, the splitting group has order 24.  Tschinkel--Zhang identify
these Galois types from the five degenerate fibres but do not provide the
Galois-equivariant change from their intersection-of-two-quadrics model to the
marked split Cox coordinates.  C956 proves that a ground-field tangent section
exists by density and uniqueness; that argument does not itself output its
coordinates.

The next load-bearing step is therefore explicit descent, starting with type
`I_1`: construct a `K`-basis of the descended projective Cox representation
from the five conic-bundle fibres, express the orbit-test point and tangent
section in that basis, and verify that the signed-minor map is fixed by
`C2 x S3`.  Only then should inverse tangent elimination begin.

The consulted Tschinkel--Zhang source is cached as `arXiv:2608.20029`, SHA-256
`be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`;
the relevant inputs are Propositions 5.1 and 5.2 and their displayed generic
fibres and splitting fields.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-24-c958-generic-split-parametrization.py \
  --check notes/2026-08-24-c958-generic-split-parametrization.json
sha256sum -c notes/2026-08-24-c958-generic-split-parametrization.sha256
```

The generator imports the function definitions, but not the command-line
execution, of C956's checked `derive_slice_cover.py`; its SHA-256 is embedded
in the JSON.  The present checks are direct exact symbolic identities within
one SymPy implementation.  There is not yet an independent implementation of
this new expansion.  The certificate explicitly does not claim inverse
tangent elimination, Galois descent, or maps for `X_j x P2`.

Files:

- generator: 8721 bytes, SHA-256
  `8b2ca67cdcbe22ada1bdc8711e8e55aab7b9c4e372eae58455f751906b35c1ac`;
- certificate: 23054 bytes, SHA-256
  `06f4ad8e57fcbfec0ddb5cd16b9ad683bfd499bf13fa8f7adc8c79d07f627e21`.

**Vibe:** the constructive quotient is explicit and manageable as an
artifact; ground-field descent, not elimination, is now the genuine gate.

## EJ + TT closeout

The large hyperplane coefficients conceal a small invariant core: all sixteen
orbit-correction factors are Laurent monomials in only three signed-minor
ratios, with exponents in `{-1,0,1}`.  Descent should therefore act first on
the four block evaluations and their Plücker coordinates, not on the expanded
hyperplane coefficients.

For type `I_1`, the five singular conic fibres give an intrinsic route.  Model
their components in the cubic étale algebra `K[t]/(t^3-3a^2t-beta)` together
with its quadratic factor, and use trace coordinates to descend the permuted
Cox blocks.  This avoids choosing radicals or first identifying the split
blow-up parameters.  Only after the signed-minor ratios and quotient
coordinates are expressed in that descended basis should the inverse graph be
eliminated.

The first witness was chosen to cover the generic Cox moduli, not to minimize
formula size.  A bounded small-height witness search may shorten the ancillary
formulas, but it is lower value than closing descent and should not delay it.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why are the expanded formulas large while the correction exponents are tiny? | settled | hyperplanes depend on the arbitrary tangent frame; the orbit correction depends only on the unimodular four-block weight simplex |
| Can the type-`I_1` section be written over `K` without radicals? | open, next | construct the conic-fibre component module over the cubic and quadratic étale algebras and descend by traces |
| Can a smaller witness materially reduce formula size? | open, optional | bounded height search after descent; current formulas already fit a compact artifact |
| Will inverse tangent elimination remain tractable after descent? | open | no elimination has been run; first obtain descended quotient coordinates and choose an affine chart |
| Does this stage give maps for either cubic product? | no, explicitly delimited | C958 acceptance still requires descent, both composites, exceptional loci, and function-field composition |
