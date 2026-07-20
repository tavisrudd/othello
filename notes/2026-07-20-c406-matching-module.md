# C406 Gates 2--3 — harmonic factorization module and cubic sheet memory

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `GREEN EXACT THEOREM; LINEAR MEMORY DIES, CUBIC MOMENT RECOVERS THE B3/H3 SHEETS; PRIORITY OPEN`

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
polynomial action.  More strongly, among all `q`-subsets of the `2q` quotient points there are
exactly two whose signed first and second moments vanish; they are the two complementary
one-factorization sheets.  Hence the factorization-difference configuration intrinsically recovers
the **unordered** B3/H3 sheet pair, and the nonzero cubic tensor carries its outer sign.

This is the route around the failed linear test.  The classical one-factorizations are not being
renamed as new: the new mechanism is that C403's conic-ideal quotient turns them into a common
harmonic image, loses their sign through degree two, and recovers their exact two-sheet partition
at cubic order.

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
absence claim.  Within the recorded coverage, the combined harmonic/cubic-memory theorem survives;
broader priority remains open.

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
sheet moment, and equal-half reconstruction.  The independent replay imports neither the primary
checker nor C399/C379 code.  From the frozen endpoints and base matchings it independently rebuilds
`PGL_2/PSL_2`, the matching stabilizer, quotient ranks, conic Laplacian, moment vanishing/nonvanishing,
and the exact two-solution reconstruction.

The trusted boundary is exact Python prime-field arithmetic, the frozen Gate-1 conventions, and
standard unique factorization, Maschke, character-idempotent, and harmonic decomposition facts.  The
bundle proves the three finite module statements and the B3/H3 cubic reconstruction.  It does not
prove an all-field theorem, identify the cubic tensor with C378's four-dimensional Fourier sector,
or establish literature priority.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 26,514 | `4337c7b29c9916903d52c74e5036369f03f64d3d4cdc8ab1e4588fe76fc8c365` |
| independent replay | 10,312 | `d0198315709dfd0a64afd99ec1a4e7076f459a2c24caa145e1a83f2fba6798ba` |
| canonical JSON | 15,208 | `ea834aba8f4b7a42108a25ec9d1731e63972b16558a2d7431c0404a9f18be545` |

## Gate and manuscript disposition

Gate 2 passes with a uniform nontrivial harmonic image.  Gate 3's proposed linear sign fails, but
the mandated way-around search produces a stronger nonlinear result: the exact two-sheet partition
is the unique balanced second-moment partition and its first signed separator is cubic.  This is a
green mathematical mechanism, qualified yellow only on priority because forward-citation closure is
incomplete.

The paper-facing replacement is one concise section, not another anthology clause:

```text
canonical Frobenius secant products
  -> conic-ideal harmonic quotient
  -> linear/quadratic sheet forgetting
  -> cubic recovery of the B3/H3 one-factorization sheets
  -> H3 matching-decorated recovery of the Clebsch parent.
```

The last arrow consumes C379 and is specific to H3: the recovered sheet is an eleven-parent system,
while an individual parent still requires its matching.  No manuscript file is edited here.  A Lean
exit should formalize the generic quotient, Laplacian decomposition, lower-moment base-point
independence, and cubic-sign implication, with the finite ranks and uniqueness counts exposed as
checked certificate leaves.  A direct C378 Fourier identification remains unproved and must not be
inferred from the outer sign alone.
