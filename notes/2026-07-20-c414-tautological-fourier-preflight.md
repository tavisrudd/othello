# C414--C417 — factorization-sector twisted-Fourier synthesis and attack

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `STAGES T0/T1 THEOREMS; B3 SEAM SPLIT CERTIFIED; SECTION/DEPTH/MODULAR SYNTHESIS OPEN`

**Literature depth:** zero sources were read at full text for this synthesis.  Three sources were
read partially and five at abstract/metadata depth, as itemized below.  This is a background
comparison, not a novelty or priority audit, and it licenses no absence claim.

## Executive picture

The current evidence does not support a canonical identification of C406's cubic/Tate plane with
C411's depth plane.  It supports a more structured statement: the quartic quotient and sextic
product live in complementary character sectors of a twisted Fourier transform on the ternary
quadratic space

```text
V = Sym^2(F_q^2),                    Q = XZ-Y^2.
```

The two factorization objects have complementary scalar degrees.  With

```text
h=(q-1)/2,
Phi_M=(P_M-P_0)/Q,                  deg(Phi_M)=h-1,
P_M=product of the matching secants, deg(P_M)=h+1,
```

one has `(h-1)+(h+1)=q-1`.  Additive Fourier transform sends scalar-character
weight `r` to weight `-r`; it therefore has exactly the covariance needed to exchange the
quotient and product sectors directly.  Adding the quadratic exponent `h` formally regrades the
two scalar weights to

```text
(h-1)+h = q-2 = -1 mod (q-1),
(h+1)+h = q   =  1 mod (q-1).
```

Stage T0 proved that the ambient kernels on those regraded sectors are inverse up to `q^2`.
Stage T1 then supplied the decisive falsifier: this scalar regrading is **not** the sheet
orientation and is not the primary exceptional object.  Over `F_11`, the regraded `-1/+1`
`A4`-invariant sectors have only a two-dimensional `J`-odd part.  The actual four-dimensional
exceptional block is

```text
((H_4)^A4)^(J=-1)  <--finite Fourier-->  ((H_6)^A4)^(J=-1).
```

Scalar homogeneity and sheet parity must therefore remain separate gradings.  The ordinary rank-16
Fourier block, zero-depth profiles, cubic/Tate quotient, and characteristic-11 projective cover
should be obtained only after exceptional restriction, nonlinear zero-divisor compression, or
modular reduction.

The target theorem is deliberately sharper than “the four constructions are related”:

> **Factorization-sector Fourier conjecture.**  For the B3/H3 conic-factorization configurations,
> the quotient and secant product define canonical sections in the complementary scalar sectors
> `H_(h-1),H_(h+1)`.  After restriction to the common parent subgroup and then to external
> sheet-odd parity, their finite Fourier functional equation has the observed four-coordinate odd
> block and signed depth profile as explicit shadows.  An integral lattice degenerates in defining
> characteristic to the nonsplit projective-cover/Tate picture, so the depth and cubic planes are
> related boundary quotients rather than canonically equal planes.

Nothing below promotes the full conjecture to a theorem.  The ambient transform, the q=11
exceptional restriction, and both q=7 representation-theoretic seam branches are theorems.  The
matching identity, oriented depth construction, seam selection, geometric shadow, and modular
comparison remain gated.

## Stage T0 result

The first Tao-style gate passes exactly.  For each `q=5,7,11`, choose a generator `chi` of the
multiplicative character group and one representative of every projective line in `F_q^3`.  After
factoring out the one-dimensional Gauss sum, Fourier on scalar-weight `r` sections has projective
kernel

```text
K_r([y],[x]) = 0                         if <x,y>=0,
                chi(<x,y>)^(-r)          otherwise.
```

Exact cyclotomic-integer calculation gives both ordered compositions

```text
K_1 K_-1 = q^2 I,                 K_-1 K_1 = q^2 I.
```

The checked dimensions and row supports are:

| type | q | projective lines | orthogonal zeros/row | nonzero entries/row | composition scalar |
|:---:|---:|---:|---:|---:|---:|
| A3 | 5 | 31 | 6 | 25 | 25 |
| B3 | 7 | 57 | 8 | 49 | 49 |
| H3 | 11 | 133 | 12 | 121 | 121 |

The primary checker reduces every entry of both matrix products modulo
`Phi_4,Phi_6,Phi_10`, respectively.  The independent replay chooses a different projective gauge
and constructs each root-of-unity power recursively in the cyclotomic basis.  It also rebuilds the
primary gauge to cross-check the stored kernel hashes.  No floating-point or fitted cyclotomic
embedding is used.

This proves the ambient complementary-weight transform and its normalization.  Its `+-1`
interpretation is only a quadratic scalar regrading.  It does not authorize identifying that
regrading with the external `J`-orientation, and it does not by itself locate the factorization
sections in an exceptional block.

## Stage T1 result: q=11 exceptional restriction

The q=11 scalar-cocycle gate passes, but it corrects the original conjecture.  The normalized
projective `A4` section picks up `-I` in 48 products.  Adjoining those signs produces a group of
order 24 with order distribution

```text
1^1 2^7 3^8 6^8,
```

so it is `A4 x C2`, not the binary tetrahedral group.  In odd dimension, determinant one selects
the unique rotational `A4` splitting, with order distribution `1^1 2^3 3^8`.  This removes the
odd-weight lift ambiguity canonically.

On the 133 projective lines, exact cyclotomic calculation then gives:

| scalar weights | invariant dimension | `J`-even | `J`-odd | killed projective `A4` orbits |
|---|---:|---:|---:|---|
| `-1,+1` | 9 each | 7 | 2 | `3,6,6,6,6,6` |
| `4,6` | 15 each | 11 | 4 | none |

Both weight pairs are exchanged by exact Fourier blocks whose reverse compositions are `121 I`.
Only the original polynomial weights `4/6` have the required four-dimensional odd block.  Thus
the T0 `-1/+1` transform remains a valid ambient identity but fails as an explanation of C378's
four odd coordinates.  The corrected primary object is the `A4`-invariant, `J`-odd part of the
actual factorization sectors.

## Stage T1B result: q=7 has two seams, and both Fourier cores pass

A fixed B3 `S4 < PSL_2(7)` parent has seven opposite determinant-sheet mates, not one.  Its action
on those mates has two orbits:

| common seam | number of mates | matching overlap | endpoint orbits |
|---|---:|---:|---|
| `S3` | 4 | one common edge | `2+6` |
| `D8` | 3 | no common edge | `8` |

Hence the phrase “the two outer-conjugate `S4` parents” did not specify a unique common
refinement.  The matching overlap gives an intrinsic seam predicate, but no current geometry
chooses between its two values.

This ambiguity does **not** kill the Fourier mechanism.  Using the unique determinant-one
orthogonal lift `PGL_2(7) -> SO_3(7)`, every parent pair has four involutive pair exchanges.  For
all seven pairs and all four choices, the true factorization weights `2/4` have a four-dimensional
`J`-odd sector.  The exact restricted kernels compose to `49 I_4` on it.  The ambient `-1/+1`
regrading again has the wrong odd dimension:

| seam | weights | invariant dimension | `J`-even | `J`-odd |
|---|---|---:|---:|---:|
| `S3` | `-1,+1` | 6 | 1 | 5 |
| `S3` | `2,4` | 14 | 10 | 4 |
| `D8` | `-1,+1` | 3 | 0 | 3 |
| `D8` | `2,4` | 13 | 9 | 4 |

The representation-theoretic B3/H3 portability gate therefore passes in a sharply qualified form:
the four-dimensional odd factorization block is uniform, while the ambient invariant sector and
the seam geometry are not.  The next gate must construct the actual quotient/product sections and
depth profile on both seam types or give a geometric reason to select one.

There is also a clean negative conclusion about the proposed uniqueness shortcut.  After taking
common-subgroup invariants, that subgroup acts trivially, and `J` acts as `-I` on each odd
four-space.  Consequently the local equivariant Hom space between source and target has dimension
`4*4=16`, not one, in both B3 and H3.  Fourier is canonical because it descends from the ambient
pairing, but subgroup symmetry alone cannot identify a proposed section from one evaluation.  Any
one-point proof must first retain the full moving-parent equivariance, or add a multiplication,
incidence, or Hecke constraint that cuts the 16-dimensional local Hom space to a line.

## Constraints already proved

### 1. Orientation is necessarily external to the bare scheme

C413 proves that the rank-16 scheme's algebraic automorphism group is exactly the global `C2`
generated by `J`.  This involution exchanges the two golden rank-eight fusions, matching sheets,
singleton parents, and all four oriented odd relation pairs.  Therefore no construction functorial
in the bare abstract scheme can select one parent.  It can recover only the unordered pair or an
object invariant under `J`.

The required extra datum can be expressed equivalently as a sheet choice, a sign of the nonzero
cubic tensor `mu_3`, an orientation of the four `J`-pairs, or a member of the golden parent pair.
These are realizations of the determinant-square orientation character

```text
epsilon : PGL_2(q)/PSL_2(q) -> {+1,-1}.
```

Stage T1 shows that this is a grading of the parent/sheet action, not a scalar-dilation weight on
`V`.  It must be imposed as `J`-parity after scalar-weight restriction rather than added to the
polynomial degree.

### 2. Ordinary scalar-line Fourier is the wrong source category

C406 proves a central-character obstruction.  Quartic evaluation has scalar weight four and the
sextic product has weight six, while C378's ordinary scalar-line relation indicators have weight
zero.  Hence any scalar-equivariant linear map from those polynomial sectors to the ordinary
relation algebra is zero.  Projective zero statistics avoid the obstruction by discarding nonzero
values, but that nonlinear passage is necessarily lossy.

For a multiplicative character `chi` and

```text
H_r={f:V\{0}->C : f(lambda*x)=chi(lambda)^r f(x)},
```

the unnormalized additive Fourier transform satisfies the elementary change-of-variables law

```text
F:H_r -> H_-r.
```

The matching degrees are complementary in all three frozen cases:

| type | q | quotient degree `h-1` | product degree `h+1` |
|:---:|---:|---:|---:|
| A3 | 5 | 1 | 3 |
| B3 | 7 | 2 | 4 |
| H3 | 11 | 4 | 6 |

This is the first uniform mechanism that simultaneously predicts C416's `4/6` twist, supplies
C414's B3 comparison, and leaves A3 available as the nonsplitting control.

### 3. The twisted kernel is essentially forced

Choose one representative on every projective line.  If `f` has nontrivial scalar weight `r`, its
Fourier transform at a representative `y` is, after summing over nonzero scalars on each source
line,

```text
G(chi^r) * sum_[x] f(x) chi(<x,y>)^(-r),
```

where orthogonal lines contribute zero and `G(chi^r)` is the one-dimensional Gauss sum.  Thus the
projectivized kernel is fixed by polarity and the multiplicative character; there is no room for
coordinate fitting.  The reverse-weight kernel must compose with it to `q^2 I` after removing the
two Gauss factors, equivalently full Fourier squares to `q^3` times reflection on `V`.

C378's formula `q*(number of orthogonal lines)-(orbit size)` is exactly the weight-zero radial
version of the same scalar summation.  The desired twisted block is therefore a character-valued
analogue of the already certified `qz-ell` rule.

### 4. Fourier, depth, trade, and modular data share parity, not a proved plane

The common exact sign line appears in four ways:

| construction | exact outer-odd feature |
|---|---|
| factorization trade | `mu_3` is nonzero, `PSL_2`-fixed, and outer-negated |
| depth | `D(JM)=-D(M)` |
| ordinary Fourier | `M_odd` preserves the four-dimensional `J`-odd block |
| modular cover | the paired projective-cover socle has a one-dimensional outer-odd line |

This proves a common orientation character.  It does not prove that the two-dimensional shadows
are the same.  In the frozen bases their primitive relations are

```text
depth:       [2,8,1],
cubic/Tate:  [2,9,1].
```

C412 rejects the natural ordinary-orbital, contraction, correlation, rank-flag, divided-transfer,
and Bockstein identifications.  Any final theorem must explain the discrepancy rather than choose
one of the ten remaining projective identifications.

### 5. The modular shadow must be nonsplit

On one eleven-point sheet the characteristic-11 permutation module is the projective cover

```text
P(1) with Loewy layers 1|9|1,
```

and the depth plane is `P(1)^A4/soc(P(1))`.  Integrally, the relevant divided-transfer operator
satisfies `B^2=11B`; modulo 11 it becomes square-zero.  This is the expected degeneration of a
semisimple Fourier/Radon projector into a radical--socle boundary map.  It strongly suggests that
the depth and Tate planes are distinct subquotients of one integral transform.

The numbers `8` and `9` also match the highest weight and dimension of the heart
`L(8)=Sym^8(F_11^2)`, but no theorem currently identifies the coefficient shift with an Euler,
derivative, or connecting morphism.  This remains a precise C417 question.

### 6. Tomography solves label loss without orienting the torsor

C413 proves that three conjugate `A4` Hecke views sharply separate all 22 parents and that the
maximally symmetric minimal instruments form the canonical 220-member orbit with `S3` channel
stabilizer.  No pair suffices.  This removes C437's within-fibre label obstruction after adding
views, but it neither selects one golden sheet nor canonically selects one triple inside the
220-orbit.

### 7. C438 forbids an over-broad decorated-transform theorem

C438 proves that the tempting q=9/q=11 commuting square is categorically false.  At q=11 the
matching decoration, the outer `11+11` split, and the parent all live on
`PGL_2(11)/A5`.  At q=9 a parent is an octad-point mark in an eight-element fibre, while the
Frobenius `7+7 -> 14` fusion lives on the separate 36-element determinantal/even-theta fibre.

Consequently the present Fourier/local-system conjecture is a B3/H3 conic-factorization statement,
not a generic decorated-obstruction transform encompassing the q=9 Cayley-octad construction.
Any future theta/Richelot bridge must first change category and provide its own marking functor.

## What the picture resembles

The ingredients belong to three established frameworks.

1. `V=Sym^2(F_q^2)` with relative invariant `Q` is the binary-quadratic prehomogeneous vector
   space.  Kazhdan--Polishchuk study finite-field functional equations for regular
   prehomogeneous spaces with character/local-system twists.  Their framework is the closest
   known home for the complementary `H_(h-1) <-> H_(h+1)` equation.
2. Additive Fourier on a finite quadratic space is the Weyl element in the oscillator/Weil
   representation.  Multiplication by `Q`, the `Q`-Laplacian, and harmonic decomposition are the
   raising/lowering package that should organize C406's identity `P_M-P_0=Q Phi_M`.
3. The depth statistic is a signed restricted projective Radon transform: pull back to an
   incidence correspondence and sum over fibres.  Finite projective X-ray theory supplies the
   right inversion/admissibility language for C413's multiple-view separation.
4. Relative Fourier--Mukai transforms provide a useful proof architecture, although not the same
   transform.  Lo's functors are exact quasi-inverses in the derived category, while recovery in
   the ordinary sheaf heart is only up to a codimension-two correction.  After a `B`-field twist,
   the cohomological transform becomes essentially a signed row swap plus explicit base terms;
   torsion-pair filtrations isolate the lower-dimensional defect before stability is compared.

These comparisons identify a category and standard machinery.  They do not establish that the
specific `A5/A4` matching sections satisfy the proposed functional equation or that the modular
extension is its reduction.

### Fourier--Mukai-inspired free upgrade

Lo's mechanism suggests replacing a literal equality of the depth and cubic/Tate planes by an
exact transform **upstairs** and an isomorphism only after quotienting a controlled defect
downstairs.  The finite candidate is

```text
factorization sections / defect  <--Fourier-->  depth sections / defect,
```

where the first defect candidates are the zero-divisor/depth-compression kernel and the modular
socle.  This is an attack template, not an identification: neither defect quotient has yet been
constructed on the certified odd four-space.

The actionable T2 gate is to build canonical source and target filtrations from multiplication by
`Q`, zero-divisor compression, the rank-two depth image, and the Tate/socle boundary.  Compute the
dimension of the Hom space preserving those filtrations, the Fourier pairing, and the relevant
Hecke action.  Continue to singleton normalization only if these conditions cut the local
16-dimensional Hom space to a line.  Otherwise the residual filtered Hom space is the next exact
obstruction.

For T3, Lo's deformation-to-limit method suggests a DVR/Rees formulation: choose an integral
cyclotomic lattice, use the prime above 11 as the filtration parameter, and seek corrected
coordinates in which the generic transform is a signed complementary-block exchange while the
special fibre records the square-zero transfer and radical--socle map.  The `8/9` shift should then
appear either as a supported boundary correction or as proof that no common filtered lattice
exists.

This analogy also sharpens C438 rather than bypassing it.  A relative Fourier--Mukai transform
requires a common base and a universal kernel on a fibre product.  The q=9 parent mark and its
36-class determinantal fusion currently have no such common object.  A future theta/Richelot bridge
must construct the base and kernel explicitly before Fourier--Mukai language becomes structural.

## Resolved gates and unanswered questions

The following list is the durable boundary for C414--C417.

1. **Exceptional block existence — resolved.**  The q=11 weight-`4/6` `A4`-invariant `J`-odd
   blocks and both q=7 weight-`2/4` seam blocks have dimension four and exact inverse Fourier maps.
   The quadratically regraded `-1/+1` blocks have the wrong odd dimensions and are excluded as the
   exceptional explanation.
2. **Local intertwiner uniqueness — resolved negatively.**  Fixing scalar weight, common-subgroup
   invariance, and odd `J` parity leaves four copies of the same sign representation, so the local
   Hom space has dimension 16.  The replacement question is whether the full moving-parent bundle
   or the canonical `Q`/compression/socle filtrations plus Hecke compatibility isolate the Fourier
   line globally.
3. **Matching-section identity.**  Does the twisted Fourier transform of the `J`-odd quotient
   section equal the `J`-odd secant-product section up to the forced Gauss scalar?  A single
   singleton evaluation determines the scalar only after the relevant line is isolated.
4. **B3 seam selection.**  Does the intended geometry choose the four-member `S3` class, the
   three-member `D8` class, or require compatible depth theorems for both?  Matching overlap
   distinguishes them but does not privilege either.
5. **Pair-exchange independence.**  Each q=7 pair has four involutive exchanges.  The odd dimension
   is independent of that choice; is the actual section/profile independent up to the common seam
   group, or does it require another orientation datum?
6. **Odd Fourier geometry.**  Which exact dual incidence statistic is the shadow of the twisted
   section, and how does it yield all four coordinates of `M_odd D(M)` without numerical fitting?
7. **Depth compression.**  Is zero-divisor projection followed by common-subgroup radialization
   exactly the passage from the twisted section to the six depth profiles?  Is its kernel the
   finite analogue of a lower-dimensional Fourier--Mukai defect category?
8. **The `8/9` extension.**  Are `[2,8,1]` and `[2,9,1]` associated-graded boundary maps of one
   filtered integral Fourier/Radon lattice, with their difference supported on the modular socle,
   or does the filtered-lattice comparison give a sharp obstruction?
9. **Geometric portability.**  The q=7 representation block now passes for both seams.  Does either
   seam reproduce the H3 cubic-first trade and signed depth law, and does q=5 explain nonsplitting
   rather than merely supply another table?
10. **Orientation versus parent choice.**  A sheet choice or nonzero vector in the orientation line
   selects a parent, but is there a natural external geometric source of that choice in any intended
   application?
11. **Minimal tomography choice.**  The 220-element `S3`-symmetric orbit is canonical; no intrinsic
   member is known.  Does the twisted line bundle canonically decorate a triple, or does `J/G`
   symmetry prove that impossible too?
12. **Separability boundary.**  C413 recovers every structure needed here but does not prove general
   separability of the rank-16 scheme.
13. **Cross-category boundary.**  Can C438's theta/Richelot postmortem construct a new functor
    between the q=9 and q=11 marking categories, or is the different-fibre obstruction permanent?
14. **Priority boundary.**  Which parts of the exceptional `A5/A4`, `S4/S3`, and `S4/D8`
    restrictions and modular
    degeneration survive a claim-specific full-text/forward-citation audit?  No answer is claimed
    by this synthesis.

## Tao-style attack plan

“Tao-style” here names a proof-design discipline, not an attribution of views: expose the invariant
with a one-line identity, change to the category where covariance is exact, use symmetry to force
the map, normalize on one configuration, and let computation falsify only small structural gates.

### Stage T0 — exact complementary-weight transform

Construct the projective kernels `K_r` for `r=+-1` over q=5,7,11, using exact cyclotomic exponent
counts rather than floating roots of unity.  Verify

```text
K_-r K_r = q^2 I
```

and the complementary-degree/quadratic-regrading identities above.  **Complete.**  This proves the
ambient transform and fixes all normalizations before exceptional-subgroup restriction; it does
not merge scalar degree with sheet parity.

### Stage T1 — exceptional restriction and uniqueness

Restrict at q=11 to the scalar-`A4` common-refinement action, retaining its projective scalar
cocycle.  **Complete with a correction:** determinant one splits the cocycle, weights `4/6` have
the four-dimensional odd block, and `-1/+1` do not.  Repeat the structural test at q=7.

The q=7 test is also **complete at representation level**.  There are `S3` and `D8` common seams,
and both true weight-`2/4` sectors have exact four-dimensional odd Fourier blocks.  The remaining
T1 question is geometric: select a seam or prove compatible factorization/depth statements on
both, then determine whether the relevant section line is forced inside the four-space.

### Stage T2 — global section module and one-point normalization

Represent the actual-degree `Phi_M` and `P_M` as sections and keep the full family as the parent
pair moves.  Determine the global induced/Hecke module and the extra operator that reduces the
local 16-dimensional Hom space.  In parallel, build the `Q`/zero-divisor/depth/socle filtrations
and measure the filtered, pairing-preserving Hecke Hom space.  Only if that space is one-dimensional
should one singleton and its mate determine the Gauss scalar.  Then prove the all-matching identity
by equivariance, not by 22 independent fits; at q=7, run the test on both seam classes until a
geometric selector is proved.

### Stage T3 — shadows and modular reduction

Factor the known depth map through zero-divisor incidence and radialization.  Choose an integral
cyclotomic lattice for the twisted transform and package its prime-above-11 filtration as a Rees
module.  Seek a corrected basis in which the generic transform is complementary-block exchange;
then compare the special-fibre radical/socle and Tate boundary maps.  The success criterion is an
exact defect-supported derivation of the `8/9` shift; nonexistence of a compatible filtered lattice
is also a valid sharp obstruction.

## Ownership by queued task

- **C414:** the certified two-seam q=7 control, then the B3/H3 section/depth statement and A3
  nonsplitting boundary.
- **C415:** T2/T3's geometric incidence shadow of all four transformed odd coordinates.
- **C416:** T0/T1's multiplicative-character Fourier sectors, Gauss kernels, and the remaining
  section-level intertwiner/uniqueness question.
- **C417:** T3's affine base-choice cocycle, integral lattice, and modular extension class.

The scientific dependency exposed here is `T0 -> T1 -> T2 -> T3`.  It does not administratively
close or re-peg any queued task.  C414 remains the active entry because the q=7 representation gate
has passed but the two-seam geometric portability gate remains open.  The exact results narrow
C416 to the section identity and keep a broad untwisted C415 search behind that gate.

## Literature boundary

This section characterizes sources only to locate standard machinery.  No novelty conclusion or
forward-citation negative is drawn.

- David Kazhdan and Alexander Polishchuk, *Generalized Character Sums Associated to Regular
  Prehomogeneous Vector Spaces*, arXiv:math/9906173v3: **partial**, arXiv PDF rendered through the
  web interface; abstract and opening formulation read.  It treats finite-field analogues of Sato
  functional equations with local systems from stabilizer component-group representations.  No
  cache blob was created in this pass.
- David Kazhdan and Alexander Polishchuk, *Fourier Transform over Finite Field and Identities
  between Gauss Sums*, arXiv:math/0003011v1: **abstract/metadata only**, official arXiv abstract.
  It places elementary finite Fourier identities under monomial Gauss-sum relations.  No cache
  blob was created.
- Shamgar Gurevich and Ronny Hadani, *The Geometric Weil Representation*,
  arXiv:math/0610818v2: **abstract/metadata only**, official arXiv abstract.  It constructs an
  invariant geometric realization of the finite-field Weil representation.  No cache blob was
  created.
- David V. Feldman and Eric L. Grinberg, *Admissible Complexes for the Projective X-Ray Transform
  over a Finite Field*, arXiv:1707.06695v1: **partial**, official arXiv HTML, abstract and
  Introduction through the double-fibration, Bolker inversion, signed-measure, and admissibility
  setup.  It supplies a comparison category, not the exact transform used here.  No cache blob was
  created.
- Shigeo Koshitani and Juergen Mueller, *The Projective Cover of the Trivial Representation for a
  Finite Group of Lie Type in Defining Characteristic*, arXiv:1609.08070: **abstract/metadata
  only**, official arXiv HTML.  Its general theorem explicitly excludes the cyclic-Sylow rank-one
  cases such as `SL_2(p)`; it is background for why the exact C412 module must be treated
  separately, not evidence for C412's `1|9|1` computation.  No cache blob was created.
- Fredrik Strömberg, *Weil Representations Associated to Finite Quadratic Modules*,
  arXiv:1108.0202: **abstract/metadata only**, official arXiv abstract.  It gives explicit matrix
  coefficients for the standard Weil representation of a finite quadratic module.  It is broad
  representation-theoretic background and was not read as a source for the exceptional
  `A4/S3/D8` restrictions here.  No cache blob was created.
- Andrzej K. Brodzik and Richard Tolimieri, *Fourier and Zak Transforms of Multiplicative
  Characters*, arXiv:2104.09295: **abstract/metadata only**, official arXiv abstract.  It treats
  finite Fourier/Zak formulas for multiplicative characters on cyclic rings.  It confirms that
  multiplicative-character Fourier transforms are standard background; it does not state the
  ternary projective exceptional blocks certified here.  No cache blob was created.
- Jason Lo, *Fourier--Mukai Transforms of Slope Stable Torsion-Free Sheaves on Weierstrass
  Elliptic Threefolds*, arXiv:1710.03771; *Journal of Algebra* 604 (2022), 40--86:
  **partial**, latest arXiv source package.  Read the Introduction and main-results discussion,
  the relative transform/WIT definitions, the twisted-Chern-character row-swap formula, the main
  stability theorem and proof outline, and the torsion-quadruple/HN strategy.  It supplies the
  exact-upstairs/modulo-defect and filtered-limit proof architecture above, not a finite-field
  transform, exceptional subgroup restriction, or Hecke-compression predecessor.  No persistent
  cache blob was created.

A post-T1 bounded search also queried binary-quadratic finite-field Fourier transforms,
`Sym^2` Weil restrictions, twisted Gelfand pairs, and `A4/S3/D8` association-scheme blocks.  It
returned the broad sources above and no claim-level match was inspected at full text.  This is a
routing observation only, not an absence result.

MathSciNet, zbMATH, Google Scholar, and forward citations were not searched for this synthesis.
That is acceptable only because no absence, novelty, or priority verdict is made.

## Evidence and stop boundary

The proved inputs are C378's exact radial Fourier matrix, C406's polynomial degrees and scalar
obstruction, C411's double-coset depth map, C412's Tate/projective-cover boundary, C413's intrinsic
recovery and tomography theorem, and C438's different-fibre obstruction.  The complementary-degree
and weight-reversal formulas are formal consequences of those definitions.

Four atomic bundles now certify: the ambient q=5/7/11 complementary kernels; the q=11 projective
lift splitting and exact `4/6` odd block; the q=7 `S3/D8` seam census; and the exact `2/4` odd blocks
on all seven q=7 seams.  Each bundle has a primary checker, canonical JSON, checksum manifest, and
an independent replay using a different construction or projective gauge.

They do not certify a matching-section Fourier identity, uniqueness of the section line inside the
odd four-space, a q=7 seam selector, an oriented B3 depth profile, the geometric meaning of
`M_odd D(M)`, the `8/9` extension class, existence of an A3 sheet orientation, or novelty.  Thus
“portable B3/H3 theorem” currently means only the representation-theoretic Fourier core, not the
full factorization/depth theorem requested by C414.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13.12:

```bash
python3 notes/2026-07-20-c414-tautological-fourier-preflight.py --check
python3 notes/2026-07-20-c414-tautological-fourier-preflight-replay.py
sha256sum -c notes/2026-07-20-c414-tautological-fourier-preflight.sha256

python3 notes/2026-07-20-c414-exceptional-twisted-fourier.py --check
python3 notes/2026-07-20-c414-exceptional-twisted-fourier-replay.py
sha256sum -c notes/2026-07-20-c414-exceptional-twisted-fourier.sha256

python3 notes/2026-07-20-c414-b3-seam-preflight.py --check
python3 notes/2026-07-20-c414-b3-seam-preflight-replay.py
sha256sum -c notes/2026-07-20-c414-b3-seam-preflight.sha256

python3 notes/2026-07-20-c414-b3-exceptional-twisted-fourier.py --check
python3 notes/2026-07-20-c414-b3-exceptional-twisted-fourier-replay.py
sha256sum -c notes/2026-07-20-c414-b3-exceptional-twisted-fourier.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c414-tautological-fourier-preflight.py --write
python3 notes/2026-07-20-c414-exceptional-twisted-fourier.py --write
python3 notes/2026-07-20-c414-b3-seam-preflight.py --write
python3 notes/2026-07-20-c414-b3-exceptional-twisted-fourier.py --write
```

| bundle/artifact | bytes | SHA-256 |
|---|---:|---|
| T0 primary | 7,554 | `253ba6c69bb965d98adc811d188b71471a7d4ef5ec916fde71a26e01b070b672` |
| T0 replay | 5,178 | `1206cdae50c23367f68cd4fb79e5a4ec9779c0e643d7473e83664702499a999e` |
| T0 JSON | 4,635 | `cbd90ee4ee861122fa9d1af580b581ac8d58eb566f02916d7328c45ab8d8ba04` |
| q=11 primary | 17,901 | `7ef5dfffb7231c56cd2cd32bb29ba206876e12531596d79a2e38dd94824c4fbe` |
| q=11 replay | 11,713 | `b0294be985c9a13eae14b6c9a7490df34e75d987e729397dd97b8bd7fff5d03c` |
| q=11 JSON | 90,668 | `7062aae1e519a7dceaba888aa60f1bfacf286f4adf59953bb25eb6d0ceb304e8` |
| q=7 seam primary | 6,578 | `930b7730574c597f23f98d1839e7037659557db89223eabaaf12601002a42511` |
| q=7 seam replay | 4,716 | `d2de505a5378cf68a17f352a9016a9a23dfbac94f1d0426f1f0a94f46477d24f` |
| q=7 seam JSON | 4,849 | `64cd62069d20a35d320e426f7181c9fa44fef1c6bb201ae930c7d02f8ac63af4` |
| q=7 block primary | 11,936 | `4c8580eaddb53be1aae495a6cbb08a97b5ff3a8631867ca68a218309f3f0e66c` |
| q=7 block replay | 15,623 | `80f70369ced20fa9aeac148c4331c1e968d61c47ed839afdf4c100478f418764` |
| q=7 block JSON | 54,170 | `8d587172551ae0623110d3a44a4325545470579ed256f6b49606fe74c3f21a76` |

The trusted boundary is elementary arithmetic in the three prime fields, the standard dot pairing,
the certified B3/H3 parent actions, the definition of a multiplicative character through a
primitive generator, and exact reduction in the displayed cyclotomic integer bases.  The replays
rebuild q=11 from an independent H3 implementation and q=7 from matching stabilizers rather than
the B3 root generators.  None imports or assumes the desired factorization-section identity; that
geometric realization remains the live T2 obligation.
