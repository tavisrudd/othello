# C460 — golden–Frégier cloud bridge

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — THE POINT-VALUED GUESS REPAIRS TO AN ORBIT-VALUED CLOUD THEOREM; THE H3 OVERLAP GRAPH RECOVERS THE UNORDERED SHEETS; THE GOLDEN COMMON TRIANGLE IS EXACTLY THE REDUCED PERPENDICULARITY GERM`

## Theorem

Let a nonsingular conic over an odd finite field be identified with `P¹(F_q)`. A perfect matching
of its `q+1` rational points is concurrent if and only if it is the orbit pairing of a fixed-point-
free projective involution. Equivalently, it is the secant pencil through an interior point. These
matchings form the single orbit

```text
PGL₂(q) / D_{2(q+1)},                 size q(q-1)/2.
```

Consequently a matching fixed by C406's `S4` parent at `q=5,7`, or by its `A5` parent at `q=11`,
cannot be concurrent: the parent would have to embed in a pencil stabilizer of order
`2(q+1) = 12,16,24`, contradicting the parent orders `24,24,60`. This conceptually explains C446's
sharp negative without repeating its matching census.

The correct geometric replacement is the **Frégier cloud** of a target matching `M`: the set of
interior points obtained by intersecting each pair of distinct secants of `M`. Equivalently, it is
the set of concurrent pencil matchings sharing exactly two edges with `M`.

| type | target clouds | points per cloud | interior points | parent double-coset orbit sizes |
|:---|---:|---:|---:|:---|
| B3 | 14 | 6 | 21 | `3, 6, 12` |
| H3 | 22 | 15 | 55 | `10, 15, 30` |

In each row the cloud is the middle parent orbit. Its point-stabilizer intersection has order four;
the other intersection orders are `8,2` for B3 and `6,2` for H3. Every B3 cloud has setwise
stabilizer exactly its `S4` parent (order 24), and every H3 cloud has setwise stabilizer exactly its
`A5` parent (order 60). Thus the clouds are faithful orbit-valued replacements for the failed
point-valued selectors.

## Coordinate proof of the uniform statement

Use the conic `v(t)=[t²:t:1]` (with its point at infinity) and let `P=[A:B:C]` be off the conic.
The chord through `v(x),v(y)` has equation

```text
X - (x+y)Y + xy Z = 0.
```

Requiring it to pass through `P` gives

```text
y = (Bx-A)/(Cx-B),
```

represented by the trace-zero matrix `[[B,-A],[C,-B]]`. Its square is
`(B²-AC)I`, so it is a projective involution; its fixed-point discriminant is
`4(B²-AC)`. It has no rational fixed point exactly when `P` is interior, and then its two-cycles
are precisely the secants through `P`. Conversely, concurrency supplies this formula and hence the
involution. The nonsplit involutions form one conjugacy class; their centralizer/normalizer is the
nonsplit dihedral group of order `2(q+1)`, proving the orbit formula.

The primary certificate recomputes the specializations `10/21/55` at `q=5,7,11` from the frozen
endpoint labels, rather than treating the formula as recalled data.

## H3 intrinsically recovers the unordered sheets

For the 22 H3 clouds, two clouds in the same frozen `PSL₂(11)` sheet always meet in three points.
Cross-sheet intersections have sizes three or five:

| relation | intersection size | unordered pairs |
|:---|---:|---:|
| same sheet | 3 | 110 |
| cross sheet | 3 | 55 |
| cross sheet | 5 | 66 |

Join two clouds exactly when their intersection has size five. The resulting graph is connected,
6-regular, and bipartite, with 22 vertices and 66 edges. Its unique unordered bipartition has sizes
`11+11` and equals the two frozen `PSL₂(11)` sheets. Thus the cloud geometry recovers the unordered
sheets without naming either one.

The B3 control behaves analogously but is not used as an H3 template: same-sheet intersections are
always one; cross-sheet intersections have sizes zero or three, with multiplicities `21/28`.

## The golden triangle and rational octahedral skeleton

C458's base and J-mate clouds meet in exactly

```text
{ [1:0:0], [0:1:0], [0:0:1] }.
```

The setwise stabilizer of this triangle in `PGL₂(11)` has order 24 and element-order histogram
`1¹ 2⁹ 3⁸ 4⁶`, hence is the rational octahedral `S4`. Its orbit on the two golden matchings has
size two. The intersection of their individual stabilizers has order 12 and histogram
`1¹ 2³ 3⁸`, hence is their common `A4` and fixes both matchings individually.

Among all 10,395 perfect matchings of the twelve conic points, this `S4` fixes exactly one:

```text
{0,∞}{1,10}{2,3}{4,6}{5,7}{8,9}.
```

It is the rational q=11 B3/cube matching. Its six secant lines have rank three, so it is
nonconcurrent, exactly as the parent-order obstruction predicts.

The M5 comparison is **positive, not merely cardinal**. Over `Q(phi)`, each of the six golden axes
is perpendicular to a unique conjugate axis and the pairing is stable under golden conjugation.
Reducing both axes at `phi→8`, their six pairwise intersections collapse two-by-two onto precisely
the three coordinate points above. Therefore the golden clouds' common triangle is exactly C442's
prime-independent perpendicularity-pairing germ. This supplies a concrete finite shadow for M5;
it does not replace M5's quaternion/two-frame mechanism or prove the gluing statement by itself.

## Incidence rank and T3 control

The canonical cloud-incidence matrices have the following exact profiles.

| type | shape | row sum | column sum | rank over Q | left kernel over Q |
|:---|:---:|---:|---:|---:|:---|
| B3 | `14×21` | 6 | 4 | 13 | sheet-sign line |
| H3 | `22×55` | 15 | 6 | 21 | sheet-sign line |

For H3 the ranks over `F_2,F_3,F_5,F_7,F_11,F_13` are respectively
`11,20,21,21,21,21`; the left nullities are `11,2,1,1,1,1`. Thus the sheet-sign line is the full
left kernel over `Q` and in characteristics `5,7,11,13`, but not in characteristics two or three.
For B3 the corresponding ranks are `12,13,13,13,13,13`: only characteristic two has an additional
left-kernel dimension.

This matrix and its canonical row/column orders are exported only as a secondary T3 control. The
rank drops are not identified here with Weil, Hamming, or Golay constituents.

## Classical-source boundary

No novelty or priority claim is made. Bamberg and Penttila's *Analytic Projective Geometry*,
§5.2, explicitly treats Frégier involutions; its official Cambridge frontmatter locates the section
at pages 86–90. Bamberg–Harris–Penttila, “On abstract ovals with Pascalian secant lines,”
*Journal of Group Theory* 21 (2018), DOI `10.1515/jgth-2018-0028`, §2, defines the involution
`X↦X^P` from an off-conic point and identifies the conic involutions with `PGL₂`. The latter was
consulted through the publisher's full HTML after the shared cache reported the DOI absent. C460's
uniform statement is also proved directly above, so the citation is historical/terminological,
not a trusted computational input.

The immediately relevant `PGL/A5/S4` orbitals are derived from the frozen groups in the certificate;
no broad matching census, literature absence claim, or manuscript claim is made.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c460-golden-fregier-cloud-bridge.py --check
python3 notes/2026-07-21-c460-golden-fregier-cloud-bridge-replay.py
sha256sum -c notes/2026-07-21-c460-golden-fregier-cloud-bridge.sha256
```

Intentional regeneration is the primary command with `--write`. It verifies the C446 and C458 JSON
hashes against their committed manifests, reconstructs `PGL₂(q)` from normalized matrices, derives
every cloud from pairwise secant intersections, computes all stabilizers, graphs, and ranks, and
recomputes the characteristic-zero perpendicularity comparison from C458's frozen golden axes.

The independent replay imports no primary C460 code. It reconstructs the conic points from the
frozen secant ledger, enumerates all projective-plane points, recognizes interior points by their
secant pencils, rebuilds clouds by the shared-two-edge predicate, and independently rechecks the
overlaps, graph, ranks, triangle, stabilizers, and perpendicularity shadow.

Trusted boundary: exact integer/rational arithmetic, exact arithmetic in `Q(phi)` and the prime
fields, finite projective normalization, exhaustive enumeration of the two required finite planes,
and the hash-pinned C446/C458 conventions. The bundle proves the stated B3/H3 cloud results and the
uniform coordinate proposition. It does not prove M5, identify a Weil constituent, edit the
manuscript, or change any cap-lane artifact.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary generator/checker `.py` | 24,727 | `5a02fcb54cc0b1b18766781b3091b3f704d378b107e6b30187d5f1d0fc4e0dfd` |
| independent replay `.py` | 9,511 | `1ed04ff684bed72004e3a49b0945ff3774512ff7a7612a846a701b2ca3eda293` |
| canonical certificate `.json` | 79,313 | `91b14e042c7655290a72e799b4d1c5fe853a1eec47cc0061dd9ba4e69b076031` |

The table records load-bearing byte counts and hashes; the adjacent manifest also covers the report.
