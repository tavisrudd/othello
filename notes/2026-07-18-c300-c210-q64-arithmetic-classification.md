# C300: arithmetic classification of the C210 `PG(2,64)` arcs

**Lane**: `relconic`

Date: 2026-07-18.

## Result

The twelve nonlinear C210 repairs give three projectively inequivalent `24`-arcs in
`PG(2,64)`, not merely three classes relative to the frozen seed.  Equivalently, their
`[24,3,22]_{64}` MDS codes form three monomial-equivalence classes.  Each projective stabilizer
has order four.  The three classes are, however, one arithmetic class: field Frobenius maps each
class to each other class, so they give one semilinear-code/`PΓL(3,64)` orbit.  Each semilinear
stabilizer also has order four.

The object is adjacent to, but is not an instance of, the standard conic-pencil,
translation-arc, hyperfocused-arc, or affinely regular-polygon constructions.  Its exact conic
signature is instead unexpectedly rich: every representative has exactly two conics meeting it
in ten points, 47 meeting it in eight, 16 meeting it in seven, 1,632 meeting it in six, and 29,240
meeting it in five.  The two ten-point conics are disjoint on the arc and give an intrinsic
`10+10+4` decomposition.  This decomposition is what makes the full projective classification
finite and certifiable; the original visible `8+8+8` layer decomposition is not intrinsic.

The affine coverage residues also have an exact small translation structure.  The cross-layer
classes `AB,AR,BR` leave a 56-set with translation stabilizer of order four.  Adding `AA` or `BB`
leaves a 14-set with a common translation stabilizer of order two.  The two terminal 14-sets are
disjoint translates (with exactly two translating vectors), and the 56-set partitions as

    28 covered by both AA and BB
    14 covered only by AA
    14 covered only by BB.

Thus the numerical `56 -> 14 -> 0` is not an accidental count: the 56-set is fourteen cosets of
its order-four translation stabilizer, while each terminal 14-set is seven cosets of their common
order-two stabilizer.  In the chosen binary coordinate model the 56-set spans all of
`GF(2)^12`; each 14-set has affine-span dimension seven.  These statements classify the bounded
residue geometry needed here; they do not assert a scalar-extension formula.

## Literature-first comparison

### Conic unions and pencils

Write the affine model as `P(y,h)=[1:y:y^2+h]`.  The two seed layers lie on

    XZ + Y^2 + alpha*X^2 = 0,
    XZ + Y^2 + beta *X^2 = 0,

while a nonlinear repair `h=a*r^2+b*r+c`, `r=y+eta`, lies on

    XZ + (1+a)*Y^2 + b*X*Y + k*X^2 = 0

for the forced constant `k`.  The seed conics lie in one pencil, but `b!=0` puts the repair conic
outside that pencil.  All three are tangent to `X=0` at `[0:0:1]`; the arc selects only eight
affine points from each.  Denniston/Mathon closed sets of conics instead produce maximal
`(k,d)`-arcs whose lines meet them in `0` or `d` points.  They are therefore a different incidence
category, not a prior construction of this 2-arc.

The closest union-of-conics construction is Giulietti--Montanucci, Example 3.5: a translation
`2*sqrt(q)`-arc formed from two conic pieces.  The C210 object has size `3*sqrt(q)=24`, and a
translation orbit has prime-power cardinality, already excluding equality.  The exact direction
count below gives a second independent exclusion.

### Hyperfocused, translation, and affine-complete arcs

Giulietti--Montanucci define a hyperfocused `k`-arc by exactly `k-1` secant directions and prove
that every translation arc is hyperfocused.  A C210 24-arc determines 46 directions and misses 19,
whereas hyperfocus would require 23.  Hence it is neither hyperfocused nor a translation arc.
Its affine completeness is the same off-line completeness notion used in that literature, but
completeness alone does not imply focus.

Korchmaros--Szonyi's survey also shows that an affinely regular polygon lies on a single
irreducible conic.  The exact maximum conic intersection here is ten, so no representative is an
affinely regular 24-gon.  These comparisons use the full texts of:

- M. Giulietti and E. Montanucci, *On Hyperfocused Arcs in PG(2,q)*,
  [arXiv:math/0601488](https://arxiv.org/abs/math/0601488), cached PDF SHA-256
  `feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`;
- G. Korchmaros and T. Szonyi, *Affinely regular polygons in an affine plane*,
  [doi:10.55016/ojs/cdm.v3i1.62767](https://doi.org/10.55016/ojs/cdm.v3i1.62767), cached PDF
  SHA-256 `4fa486544fef606ccd249a1c2ce06eeb6ae9a9e1a423fba1d1dd81dde285ec47`;
- F. De Clerck, S. De Winter, and T. Maes, *A geometric approach to Mathon maximal arcs*,
  [arXiv:1003.2080](https://arxiv.org/abs/1003.2080), cached PDF SHA-256
  `001c5f8174f4a6069bfa0167825cd943e2b4a35e7c6f48315b395542e50c6185`, for the
  closed-conic/maximal-arc boundary.

### Bounded Kloosterman lookup

For the first frozen orbit the previously proved reciprocal-trace count is

    N_00 = (s-3+K_s)/4,

with `K_8=-5`, hence `N_00=0`; the Weil bound forces `N_00>0` for `s>=16`.  The standard binary
Kloosterman correspondence realizes `K_s` as the Frobenius trace of the ordinary elliptic curve
`Y^2+XY=X^3+X` (up to the displayed sign convention).  This supplies a familiar arithmetic label
for the exceptional `GF(8)` count and nothing more.  C300 opens no isogeny, moduli, or elliptic
classification program.  The bounded lookup used M. Moisio,
[*Kloosterman sums, elliptic curves, and irreducible polynomials with prescribed trace and norm*](https://arxiv.org/abs/0706.2112),
cached PDF SHA-256 `133c0701f8f011a505b5b5b2769a2f24ca353f1fe8b9cdb65d61fcbe3b38c590`.

## Projective and code equivalence

For a projective arc, any ordered four points form a projective frame.  The checker first
enumerates all `C(24,5)=42,504` five-subsets of each representative to recover every conic meeting
it in at least five points.  The unique pair of ten-point conics forces every projectivity to
preserve or swap the two ten-point parts and to preserve the four-point remainder.  Relative to
one fixed source frame, this leaves exactly

    2 * (10*9) * 10 * 4 = 7,200

target frames per source/target/Frobenius triple.  All `3*3*6*7,200=388,800` candidates are checked
as actual maps of point sets.  The resulting map-count matrices are

    PGL(3,64):       diag(4,4,4),
    PΓL(3,64):       every entry 4.

Representing the 24 projective points as columns of a rank-three generator matrix gives an
`[24,3,22]_{64}` MDS code.  Column scaling and permutation are exactly projective point-set
equivalence, so the first matrix gives three monomial-code classes.  Allowing field automorphisms
gives the single semilinear class in the second matrix.  This statement does not identify the
codes with a named generalized Reed--Solomon presentation.

## Evidence and replay

The exact evidence bundle is:

- `papers/arcs_complete_outside_conic/analyze_c300_q64_arithmetic_classification.py`;
- `papers/arcs_complete_outside_conic/analyze_c300_q64_arithmetic_classification_output.json`;
- `papers/arcs_complete_outside_conic/analyze_c300_q64_arithmetic_classification_SHA256SUMS`.

The checksum manifest covers the 14,154-byte classifier, 1,579-byte output, and all four
load-bearing imported/input artifacts: `analyze_c210_q64_affine_coverage.py` (4,348 bytes),
`analyze_c210_q64_quadratic_orbits.py` (7,791 bytes),
`probe_c210_two_layer_parabolas.py` (10,231 bytes), and
`probe_c210_quadratic_coset_repairs_output.txt` (2,656 bytes).

Replay from `papers/arcs_complete_outside_conic/` with:

```bash
python3 analyze_c300_q64_arithmetic_classification.py \
  > /tmp/analyze_c300_q64_arithmetic_classification_output.json
diff -u analyze_c300_q64_arithmetic_classification_output.json \
  /tmp/analyze_c300_q64_arithmetic_classification_output.json
python3 analyze_c300_q64_arithmetic_classification.py --check
sha256sum -c analyze_c300_q64_arithmetic_classification_SHA256SUMS
```

The checker uses deterministic integer arithmetic in the fixed polynomial-basis model
`GF(64)=GF(2)[x]/(x^6+x+1)`.  Its trusted boundary is the field implementation, projective-frame
reconstruction, the theorem that five arc points determine their conic, and exhaustive finite
enumeration.  The independent checks are the earlier direct line-incidence arc/coverage checker,
the earlier exhaustive conic-stabilizer calculation, and the agreement between the new full-PGL
stabilizer order four and the previously found four-element translation action.  Computation proves
only the stated `PG(2,64)` classification.

## Discovery-track retrospective

The clean relconic companion contains one entry since 2026-07-17: the checked failure of Singular
`minAssGTZ` over `GF(2)` and its resulting tooling caution.  Reviewing C297--C304 and this C300
closure against “was I looking for this?” found no omitted incidental lead.  The codimension-three
moduli, exceptional-component types, deletion constraints, bounded terminal coincidences,
alternative-tower collapse, the intrinsic `10+10+4` conic signature, and the residue translation
structure were all direct deliverables of their allocated tasks.  They therefore remain in their
reports rather than being duplicated into the discovery log.  The live handoff's missing companion
link was restored.

## Vibe check

This is a strong finite classification result.  The 24-arcs are genuinely new relative to the
obvious classical buckets, their three geometric classes have a clean single arithmetic orbit,
and the formerly opaque coverage counts now have a compact translation-coset explanation.  The
result remains deliberately bounded to `PG(2,64)` and does not revive the obstructed scalar family.
