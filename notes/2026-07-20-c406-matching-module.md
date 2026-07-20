# C406 Gates 2--3 — harmonic factorization module and cubic sheet memory

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `GREEN EXACT THEOREM; SHARP CUBIC ORIENTATION CHARACTER AND DEPTH--FOURIER SHEET BRIDGE;
UNIQUENESS AND FIRST HESSIAN SPLITTING FAIL; LIKELY-NEW COMPOSITION IN BOUNDED AUDIT,
UNRESTRICTED PRIORITY OPEN`

## The theorem

Use C406 Gate 1's frozen conic coordinates, target perfect-matching orbits, and base matchings.
For `T=A3,B3,H3`, write

```text
q = 5,7,11,        e = 2,3,5,        d=e-1=1,2,4,
H = S4,S4,A5,      |Omega|=5,14,22.
```

On the standard conic `Q=XZ-Y^2`, let `P_M` be the canonically scaled product of the secants in
the matching `M`.  C403 gives `P_M|_Q=P_N|_Q` for all perfect matchings, so after choosing any
base matching `M_0` the factorization-difference map is

```text
Phi_(M_0)(M) = (P_M-P_(M_0))/Q in R_d.
```

Let

```text
Delta_Q = 4 partial_X partial_Z - partial_Y^2,
H_d = ker(Delta_Q:R_d -> R_(d-2)).
```

Then the distinguished Coxeter matching orbit has the uniform image

```text
span {Phi_(M_0)(M):M in Omega}
   = H_d                                      for d odd,
   = H_d + F_q Q^(d/2)                        for d even.
```

Thus the exact ranks are `3,6,10`.  The first two images fill `R_1,R_2`; the H3 image is the
proper ten-space

```text
H_4 + F_11 Q^2 < R_4,             dim R_4=15.
```

The fixed-matching characters and semisimple decompositions over the actual fields are:

| type | parent-class fixed counts | permutation module | augmentation | kernel | image |
|:---|:---|:---|:---|:---|:---|
| A3 | `5,3,1,2,1` on `1,2,22,3,4` | `2*1+3` | `1+3` | `1` | `3` |
| B3 | `14,6,6,2,2` on `1,2,22,3,4` | `4*1+2*2+2*3` | `3*1+2*2+2*3` | `2*1+2+3` | `1+2+3` |
| H3 | `22,6,4,2,2` on `1,2,3,5A,5B` | `4*1+2*4+2*5` | `3*1+2*4+2*5` | `2*1+4+5` | `1+4+5` |

Here the S4 symbols are its ordinary irreducibles of dimensions `1,1,2,3,3`; only the displayed
constituents occur.  For A5 the two three-dimensional constituents do not occur.  Since
`5,7,11` do not divide `24,24,60`, Maschke semisimplicity applies; `F_11` is already splitting
for A5 because `sqrt(5)=+-4`.

The linear sheet sign does **not** survive.  For B3 and H3 let `Omega=F_+ disjoint_union F_-`
be the two `PSL_2(q)` one-factorizations and put `epsilon=+1` on `F_+`, `-1` on `F_-`.  Then

```text
sum_M epsilon(M) Phi_(M_0)(M) = 0.
```

Equivalently, the sums of the `q` plane secant products in the two sheets are exactly equal as
degree-`(q+1)/2` ternary forms, before restriction to the conic.  The same cancellation persists
in the signed quadratic moment.  The first surviving memory is cubic:

```text
mu_k = sum_M epsilon(M) Phi_(M_0)(M)^(symmetric k),
mu_1=mu_2=0,             mu_3 != 0.
```

Because each sheet has `q=0` elements in `F_q` and all lower signed moments vanish, `mu_3` is
independent of `M_0`.  It is fixed by `PSL_2(q)` and negated by the outer coset under the induced
polynomial action.  More strongly, C430 now proves symbolically that every field-valued signed
trade orthogonal through degree two is a scalar sheet sign.  Thus the two complementary
one-factorization sheets are the only balanced halves, and the second-moment radical itself gives
a direct two-level recovery algorithm.  Hence the factorization-difference configuration
intrinsically recovers the **unordered** B3/H3 sheet pair, and the nonzero cubic tensor carries its
outer sign.  See `notes/2026-07-20-c430-conceptual-balanced-half-rigidity.md`.

This is the route around the failed linear test.  The classical one-factorizations are not being
renamed as new: the new mechanism is that C403's conic-ideal quotient turns them into a common
harmonic image, recovers their unordered two-sheet partition by the balanced degree-two condition,
and has its first nonzero signed orientation carrier at cubic order.

## Reopened cubic-classification addendum

The signed moment has a sharp group-theoretic interpretation.  For `G=PGL_2(q)` and
`G^+=PSL_2(q)`, in both B3 and H3,

```text
Stab_G(mu_3)=G^+,                 Stab_G(F_q mu_3)=G.
```

Indeed `mu_3` is nonzero, every element of `G^+` fixes it, and every element of the outer coset
negates it.  Thus the tensor realizes the determinant-square character and its projective line is
an unoriented orientation form.  These stabilizers are inside the conic stabilizer `G`; no claim
is made about the full linear stabilizer in `GL(W)`.

The cubic degree is also minimal in the precise moment sense.  If `epsilon` is the sheet sign and
`Phi_M=(P_M-P_0)/Q`, then

```text
sum epsilon(M) Phi_M                         = 0,
sum epsilon(M) Phi_M^(symmetric 2)           = 0,
sum epsilon(M) Phi_M^(symmetric 3)           = mu_3 != 0.
```

Consequently no signed power-sum statistic of degree one or two or any linear functional thereof
orients the sheets, while degree three does.  This is not a claim about every conceivable
nonlinear statistic.  The low moments nevertheless recover the **unordered** pair: C430's
radical--Hadamard theorem says that the entire degree-two trade kernel is the sheet-sign line, so
the two sheets are the only complementary halves with equal first and second moments.  The cubic
supplies the sign exchanged when those two halves are swapped.

These moment equalities give explicit plane syzygies before conic restriction.  Since each sheet
has `q=0` members in `F_q`, expansion of `P_M=P_0+Q Phi_M` gives

```text
sum_(M in F_+) P_M = sum_(M in F_-) P_M,
sum_(M in F_+) P_M^(symmetric 2) = sum_(M in F_-) P_M^(symmetric 2),
sum_M epsilon(M) P_M^(symmetric 3) = Q^(symmetric 3) mu_3 != 0.
```

The first identity is an equality between `q+q` secant-product factorizations as ternary forms;
the second lies in the symmetric square of that form space (and hence also yields equality after
ordinary polynomial multiplication).  The third records the first surviving tensor syzygy.

The A3 exception has one uniform index-two explanation.  Restriction of a transitive `G/H` action
to `G^+` splits into two orbits exactly when `H` lies in `G^+`.  The B3 `S4` and H3 `A5` parents
do lie in `PSL_2(7)` and `PSL_2(11)`, producing `7+7` and `11+11`.  The A3 `S4` parent cannot lie
in `PSL_2(5) ~= A5` (already its order 24 does not divide 60), so its five markers remain one
`PSL_2(5)` orbit.

Two attractive stronger claims fail exactly:

1. The space of `PSL_2(q)`-fixed, outer-odd tensors in `Sym^3(W)` has dimension **three** in both
   B3 and H3 (`Sym^3(W)` has dimensions 56 and 220).  Hence `mu_3` is not the unique relative
   invariant.  Even requiring contraction along the unique parent-fixed covector to be proportional
   to the canonical second moment leaves a two-dimensional solution space.
2. That contraction does not recover the parent-module summands.  The second-moment form and the
   contracted cubic have the same one-dimensional radical and ranks `5/5` in B3 and `9/9` in H3;
   in the frozen normalization the contraction is respectively `3` and `8` times the second
   moment.  It therefore does not split H3's `4+5` quotient.  The cubic's first flattening still
   has full rank `6/10`, so this is a failure of the proposed eigensplitting, not degeneracy of the
   cubic itself.

The cheapest singular-locus recovery also fails: in the frozen affine gauge none of the nonzero
`14/22` quotient vectors is singular for the cubic; the sole zero vector is the chosen base and is
not a projective point.  More fundamentally, changing the base translates all quotient vectors
while leaving `mu_3` unchanged because the lower signed moments vanish, so an intrinsic
point-recovery claim needs a translation-invariant singular scheme, not this naive comparison.

No **linear cubic-to-C378 intertwiner** follows from the shared dimension four.  C378's odd sector
is a four-dimensional subspace of the scalar-`A4` common-refinement relation algebra, whereas the
H3 summand is a geometric nontrivial `A5` module.  There is also a central-character obstruction:
quartic evaluation has scalar weight four, while the ordinary scalar-line relation algebra has
trivial scalar weight, so every scalar-equivariant linear map between these objects is zero.
Explicitly, if `lambda` generates `F_11^*`, then dilation acts on a homogeneous degree-`d` form by
the nontrivial character `lambda^d` for `d=4` (and on a secant product by `lambda^6`), but fixes
each scalar-line relation indicator.  Equivariance would force

```text
T(f)=T(lambda.f)=lambda^d T(f),
```

and `lambda^d != 1`, hence `T(f)=0`.  This rules out only linear maps to the ordinary relation
algebra; character-twisted targets and nonlinear projective zero statistics remain available.

The portfolio nevertheless supplies a different, exact bridge.  Let `R_0,...,R_15` be C378's
projective scalar-`A4` common-refinement relations, with oriented `J`-pairs

```text
(R_1,R_10), (R_3,R_13), (R_6,R_14), (R_9,R_11).
```

For the original degree-six secant product `P_M`, not the base-dependent quartic quotient, define

```text
D(M)_i = # {projective x in R_left(i) : P_M(x)=0}
         - # {projective x in R_right(i) : P_M(x)=0}.
```

Zero evaluation is projectively well-defined and removes the scalar-weight obstruction.  Exact
calculation gives six profiles:

```text
sheet +:  (-6,0,12,-12) [1],  (-3,3,0,3) [4],  (3,-2,-2,0) [6],
sheet -:   (6,0,-12,12) [1],   (3,-3,0,-3) [4], (-3,2,2,0) [6].
```

The bracketed numbers are fibre sizes.  These six fibres are exactly the scalar-`A4` orbits on the
22 matchings, hence give an explicit realization of the six double cosets

```text
A4 \\ PGL_2(11) / A5.
```

The three positive profiles span a plane over `F_11`, not a three-space, and obey the exact weighted
relation

```text
1*(-6,0,12,-12) + 4*(-3,3,0,3) + 6*(3,-2,-2,0) = 0.
```

Writing odd-sector coordinates as `(a,b,c,d)`, the plane is cut out exactly by

```text
2a+2b+c=0,                 9a+8b+d=0                  in F_11.
```

Pushing the signed 22-point configuration through `D` therefore preserves the cubic-first trade:
its signed symmetric moments vanish in degrees one and two and are nonzero in degree three.  This
is an explicit compressed realization of C406's orientation memory inside C378's odd sector.

The two size-one fibres are the base matching and its `J`-mate.  Thus the oriented common
refinement plus a sheet choice recovers one individual singleton matching and C379 then recovers
its Clebsch parent; without a sheet choice it recovers the unordered golden matching/parent pair.
The size-four and size-six profiles do not recover their individual matchings.  In all cases

```text
D(JM) = -D(M)
```

for every matching.  Since these four coordinates are C378's oriented odd-relation coordinates,
its certified matrix `M_odd` gives the commutative outer-sign consequence

```text
M_odd D(JM) = -M_odd D(M).
```

This is a genuine explicit factorization-depth map into the Fourier-stable odd sector.  It is not
an isomorphism from the cubic tensor, and `M_odd` does not permute the six raw profile vectors.  The
rank drop from the three-dimensional outer-odd cubic space to the two-dimensional profile plane is
an exact constraint, not evidence for a dimension-matching identification.

The resulting information lattice is therefore exact but decorated, with one new intermediate
common-refinement level:

```text
22 matchings  ->  6 scalar-A4 depth profiles  ->  2 PSL_2 sheets  ->  1 undecorated conic.
```

The balanced first/second moments recover the sheet level from the full factorization-point
configuration; C430 identifies the recovery map with the unique second-moment radical and the
trade line with the outer-odd projective-cover socle.  The cubic line is its orientation form.
C378's common refinement recovers the six
double-coset classes and its singleton class supplies the golden matching pair; adding either
oriented singleton matching invokes C379 and recovers the individual H3 parent.  None of this makes
the cubic an invariant of the bare GRS child.

## Proof and exact finite obligations

The secant normalization

```text
L_ij=t_i t_j X-(s_i t_j+t_i s_j)Y+s_i s_j Z
```

gives `nu^*L_ij=(t_i s-s_i t)(t_j s-s_j t)`.  C403's four-endpoint identity therefore makes
every difference `P_M-P_N` uniquely divisible by `Q`.  Gate 2 constructs those quotients in the
monomial basis of `R_d`, computes their exact ranks over `F_q`, and compares their span with the
kernel of `Delta_Q`.  In even degree it adjoins the radial vector `Q^(d/2)` and checks equality of
subspaces, not only equality of dimensions.

For each parent conjugacy class the permutation character is the exact number of fixed target
matchings.  Central idempotents over `F_q` then split the full permutation module, augmentation
module, relation kernel, and quotient image.  The displayed kernel/image characters subtract
exactly and their dimensions recover every matrix rank.

For B3/H3, determinant square class constructs the two sheets.  Exact tensor sums give zero in
degrees one and two and a nonzero cubic.  A meet-in-the-middle exhaustion of all equal halves
uses the concatenated degree-one and degree-two coordinates; it finds exactly two solutions in
each type and checks that they are the frozen `PSL_2(q)` sheets.  This exhaustive uniqueness is
the reconstruction clause.

The reopened checker derives the affine linear action on the rank-`6/10` image directly from the
permuted quotient-point configuration.  Three certified generators generate each full `PSL_2(q)`;
adjoining one outer element gives the fixed/anti-fixed equations on the 56- and 220-dimensional
symmetric cubes.  Exact row reduction gives relative-invariant dimension three and verifies that
the signed cubic lies in it.  The parent-fixed covector, second-moment matrix, cubic contraction,
flattening, proportional-contraction space, and gradients at every quotient vector are then
computed exactly.  The independent replay reconstructs these matrices without importing the
primary implementation.

For the depth--Fourier bridge, the primary checker fits and verifies the exact projectivity from
the standard secant-product conic to C378's reduced H3 coordinates, reconstructs the sixteen
scalar-`A4` relations, evaluates all 22 plane products on their projective lines, and compares the
six depth-profile fibres with the independently computed `A4` matching orbits.  It verifies `J`
negation before and after the frozen odd Fourier matrix.  The replay rebuilds the H3 conic,
projectivity, two `A5` groups, common `A4`, relation pairs, all depth profiles, and all matching
orbits from the independent C378 root/reflection implementation.

The full frozen matching-orbit rank census supplies a falsifier.  A3's other orbit also has rank
three.  In B3 the four orbit ranks are `6,5,5,6`.  In H3 the 31 frozen orbits have ranks among
`9,10,14,15`; the target A5 orbit has rank ten.  Thus rank alone is not promoted as an intrinsic
marker.  The theorem uses the exact harmonic image together with the unique balanced-moment
partition.

## Literature disposition

The audit read **two sources at full text in this pass**, reused two earlier full-text readings with
their load-bearing passages reread, and read two further sources partially.

- **Edge, 1956, `10.4153/CJM-1956-041-6`: full text reused from the C399 audit; published
  21-page PDF, cache SHA-256
  `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`; Sections 19--21 and
  30--32 reread here.** Edge owns the A3 synthematic total, the two H3 eleven-hexagon systems,
  their outer exchange, and explicit classical triangle-product identities.  The audited passages
  do not form the C403 secant-product quotient or its signed moment tensors.
- **Dye, 1991, `10.1112/jlms/s2-44.2.270`: full text reused from the C399 audit; published scan,
  pp.270--286, OCR reconstruction SHA-256
  `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`; load-bearing pp.272,
  279, 280, 282 were previously image-verified and the factorization terminology was re-screened
  here.** Dye owns the conic marker orbits, stabilizers, and relation geometry, not the displayed
  conic-ideal harmonic/moment construction.
- **Filmus--Lindzey, 2022, *Harmonic Polynomials on Perfect Matchings*: full text, SLC 86B.59,
  all 12 pages, cache key `SLC:86B.59`, SHA-256
  `babc314c816261a989fac593967f94ac3716ea23dfc0134f0157a60c4743b47d`.** This is the closest
  terminology collision.  It gives canonical harmonic presentations of functions on the full
  matching space using edge variables and vertex-sum differential operators.  It does not use
  ternary secant products, division by a conic equation, Coxeter suborbits, finite-field signed
  moments, or the B3/H3 sheets.
- **Chien--Kang, 2025, arXiv:2508.12580v1: full text, all 14 pages, cache SHA-256
  `cfb6ce0fbc86f6192aee57cf63c70557eccc331a82d2615f99d52ed7d0f97800`.** It classifies real
  spherical two-design group orbits through first/second moments and isotypic components.  It does
  not cover characteristic-`p` signed halves or a first nonzero cubic separator.
- **Srinivasan, 2018, arXiv:1807.00481v1: partial, Introduction and Sections 2 through Theorem
  2.3, cache SHA-256
  `d6cc59c76758dc33a4bbaed145fa27e20df39e94727632b431ea7eb7ef9acb8b`.** It records the
  multiplicity-free complex perfect-matching permutation module and association scheme.  C406's
  restricted modular parent characters and conic-ideal map are outside that scope.
- **Mohammadpour--Waldron, 2019, arXiv:1912.07151v1: partial, Introduction, Theorem 4.1 and its
  surrounding two-orbit discussion, selected reflection-group examples, and Conclusion, cache
  SHA-256 `5f29d99ec3e1d953d10e1f55c86abf578b7b19b0507ce78ef457622ecff8e776`.** It combines
  real/complex spherical group orbits with weights to raise design strength; it does not give the
  finite-field signed cancellation/reconstruction used here.

Exact web queries screened title/abstract results for `"one-factorization" "moment" polynomial`,
`"perfect matchings" "harmonic polynomials"`, `"secant" "one-factorization" conic polynomial`,
and `"signed moment" finite field design orbit`.  The first screen exposed Filmus--Lindzey and the
two-orbit design literature; no result exposed the C406 composition.  This is a bounded screen, not
a complete database closure.  The exact-title OpenAlex query did not resolve Filmus--Lindzey,
Crossref returned unrelated title matches, and Semantic Scholar rate-limited the query, so a new
three-graph forward-citation closure was not obtained.  MathSciNet and Google Scholar were not
covered; zbMATH was not closed.  Consequently the report makes no `first`, priority, or unrestricted
absence claim.  The later claim-by-claim priority audit records six full-text and six partial or
metadata-depth sources and sharpens this boundary: Edge and Dye own the exceptional conic-marker
geometry, Cameron--Korchmaros own the relevant highly symmetric one-factorizations,
Bamberg--Klawuhn place one-factorizations in the perfect-matching association scheme as Delsarte
designs, and Pan--Wu--Yin own the `PGL_2(11)/A5` Hadamard orbital action together with its coarse
`A4/D10` cross-sheet stabilizers.  None of those classical layers is claimed as new.  Within the
recorded coverage, no predecessor was located for the composition of the conic-ideal quotient,
balanced-half reconstruction, cubic orientation tensor and plane syzygies, and the exact
depth--Fourier map.  See `notes/2026-07-20-c406-priority-audit.md` for source depth, queries,
forward-citation counts, access gaps, and manuscript-safe wording.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c406-matching-module.py --check
python3 notes/2026-07-20-c406-matching-module-replay.py
sha256sum -c notes/2026-07-20-c406-matching-module.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c406-matching-module.py --write
```

The primary checker consumes but does not regenerate Gate 1's frozen JSON.  It reconstructs each
target orbit from the frozen base matching, computes every quotient polynomial, fixed character,
central-idempotent decomposition, harmonic/radial equality, complete frozen-orbit rank census,
sheet moment, equal-half reconstruction, relative-invariant space, polarization tests, and the
depth--Fourier bridge.  The
independent replay imports neither the primary
checker nor C399/C379 code.  From the frozen endpoints and base matchings it independently rebuilds
`PGL_2/PSL_2`, the matching stabilizer, quotient ranks, conic Laplacian, moment vanishing/nonvanishing,
the exact two-solution reconstruction, the induced symmetric-cube action, the polarization
matrices, and the independent C378 scalar-`A4` relation model.

The trusted boundary is exact Python prime-field arithmetic, the frozen Gate-1 conventions, and
standard unique factorization, Maschke, character-idempotent, and harmonic decomposition facts.  The
bundle proves the three finite module statements, B3/H3 cubic orientation character, bounded
uniqueness/polarization/singular-point negatives, and the H3 depth--Fourier sheet bridge.  It does
not classify the full cubic singular scheme, prove an all-field theorem, identify the cubic tensor
linearly with C378's four-dimensional Fourier sector, or establish literature priority.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 48,589 | `a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51` |
| independent replay | 28,938 | `3d7a2288822531837b429c7151be69f1537ba060566fde35248a624df41c556d` |
| canonical JSON | 21,996 | `e39bf131f3d818dfbcbeb1f2d4dfa9a6ba7645c41cdd6fe9600957c0fe1dc4b2` |

## Gate and manuscript disposition

Gate 2 passes with a uniform nontrivial harmonic image.  Gate 3's proposed linear sign fails, but
the mandated way-around search produces a stronger nonlinear result: the exact two-sheet partition
is the unique balanced second-moment partition and its first signed separator is cubic.  This is a
green mathematical mechanism and a likely-new composition within the bounded recorded coverage;
unrestricted priority remains open because MathSciNet, Google Scholar, zbMATH, and part of the
forward-citation graph were not closed.

The paper-facing replacement is one concise section, not another anthology clause:

```text
canonical Frobenius secant products
  -> conic-ideal harmonic quotient
  -> balanced quadratic recovery of the unordered sheets
  -> cubic orientation character of the B3/H3 sheets
  -> H3 scalar-A4 depth profiles in C378's odd Fourier sector
  -> H3 matching-decorated recovery of the Clebsch parent.
```

The last arrow consumes C379 and is specific to H3: the recovered sheet is an eleven-parent system,
while an individual parent still requires its matching.  No manuscript file is edited here.  A Lean
exit should formalize the generic quotient, Laplacian decomposition, lower-moment base-point
independence, and cubic-sign implication, with the finite ranks and uniqueness counts exposed as
checked certificate leaves.  The explicit H3 depth map is available, but a linear identification
of the cubic tensor with C378's Fourier sector remains obstructed and must not be inferred from the
outer sign alone.

C411 subsequently replaces the 22-term depth-profile table by an exact conceptual derivation:
`A4` subgroup marks give the orbit sizes `1,4,6 / 1,4,6`, one secant-incidence representative per
double coset gives the six profiles, and the weighted barycentre plus antipodality proves the
cubic-first pushforward.  The coordinates form a rank-two mixed `A4`--`A5` bi-Hecke map that
separates the six labels as a set but is not a faithful linear quotient or a zonal spherical
function.  See `notes/2026-07-20-c411-double-coset-hecke.md`.
