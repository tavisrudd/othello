# C756 — exceptional missing-set kernel curves

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: three selected
prime-field extremal witnesses, research only

## Verdict

The first unexpected kernels at (q=13,29,31) are genuine curves, but they
do not share a factor or a common chord/conic component.  They are smooth,
absolutely irreducible plane curves of degrees (4,7,6), respectively.  Their
exact conic-preserving stabilizers are the stabilizers of the selected arc:
(S_3,D_{10},A_5).  In every case the missing set is a union of regular
stabilizer orbits; at (q=31) it is one regular (A_5)-orbit.

This identifies the early Hilbert defects as exceptional-symmetry shadows of
the three selected maximum-coverage witnesses, not as evidence for a uniform
split-support factorization.  The bounded split-support follow-up is therefore
closed as a general nonsaturated proof route.  The (q=31) row retains a clean
finite-geometric gem: its sextic belongs to a two-dimensional (A_5)-stable
character space containing (Q^3=(y^2-xz)^3), hence is a distinguished member
of an exact (A_5)-invariant pencil.

Evidence:
`notes/2026-08-01-c756-kernel-curves.py` and
`notes/2026-08-01-c756-kernel-curves.json`.

## Exact classification

| (q) | degree | genus | missing points | curve (mathbf F_q)-points | curve/conic intersection | stabilizer | missing-set orbits |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 13 | 4 | 3 | 24 | 29 | 2 | (S_3), order 6 | (6+6+6+6) |
| 29 | 7 | 15 | 50 | 75 | 0 | (D_{10}), order 10 | (10+10+10+10+10) |
| 31 | 6 | 10 | 60 | 102 | 12 | (A_5), order 60 | (60) |

All three degree-(d) evaluation kernels are one-dimensional.  The
normalization is that the coefficient of (x^d) is (1).  For a compact
exact display, row (a) below lists the coefficients of

\[
  x^a y^b z^{d-a-b},\qquad b=0,1,\ldots,d-a.
\]

The coefficient triangles are:

```text
q=13, d=4:
[[1,-5,-3,1,0], [1,1,-4,2], [-5,3,3], [-4,-2], [1]]

q=29, d=7:
[[1,-10,-11,-7,-6,11,8,1], [12,14,-3,-3,-13,0,9],
 [-14,-7,-3,6,3,9], [1,8,8,-10,7], [-11,-2,9,6],
 [6,11,-7], [-12,2], [1]]

q=31, d=6:
[[4,7,-2,-6,-7,12,12], [6,-10,-7,-1,-8,-9],
 [-14,-8,12,-7,12], [7,6,12,12], [-7,-11,-7],
 [-10,15], [1]]
```

Coefficients are centered integer representatives modulo (q).  The JSON
stores the same polynomials as explicit exponent/coefficient records.

## Geometry and arrangement comparison

Exact factorization over each base field returns one multiplicity-one factor.
Independently, the Jacobian ideal is the unit ideal on each of the three
standard affine charts.  These chart certificates prove geometric smoothness;
a smooth positive-degree projective plane curve is absolutely irreducible.
Thus none of the curves is assembled from chord lines, the conic, or smaller
components over an extension field.

No selected arc vertex lies on its kernel curve.  The rational-point
decompositions are:

| (q) | missing | on conic | covered off-conic nonvertices |
|---:|---:|---:|---:|
| 13 | 24 | 2 | 3 |
| 29 | 50 | 0 | 25 |
| 31 | 60 | 12 | 30 |

The chord intersections also disagree sharply.  At (q=13), six selected
chords have no rational curve point and nine have one.  At (q=29), the
45 chords split as (15,15,10,5) with respectively (0,1,2,3) rational
curve points.  At (q=31), thirty chords have none and fifteen have two.
There is therefore no recurring Bezout or component pattern behind the three
defects.

## Stabilizer explanation and canonicity

The full conic-preserving (operatorname{PGL}(2,q)) stabilizer of each curve
equals the stabilizer of the selected witness.  The element-order profiles are

\[
  1^1 2^3 3^2,\qquad
  1^1 2^5 5^4,\qquad
  1^1 2^{15}3^{20}5^{24},
\]

identifying (S_3,D_{10},A_5).  The corresponding witness-orbit decompositions
are (3+3,5+5,10).  The degree-(d) spaces transforming by the same scalar
character as the curve have dimensions (4,6,2).  In the two even-degree
cases they contain (Q^{d/2}); the (q=31) dimension-two result is the exact
(A_5) pencil statement.

The stabilizer alone leaves four invariant conic-external arcs of the selected
size at both (q=13) and (q=29), but only one at (q=31).  At (q=29), two
of the four have 50 missing points and two have 70; all four (q=13) candidates
have 24.  Nevertheless, in each field the selected kernel curve contains the
missing set of exactly one such invariant arc.  Hence the curve is canonical
for the selected witness and distinguishes it inside this bounded invariant
catalogue, while the symmetry group by itself does not do so at (q=13,29).

## EJ + TT closeout and mystery ledger

**EJ.**  The free upgrade was to compute the complete conic-preserving
stabilizers and orbit decompositions, rather than stop after coefficient
extraction.  This turns three unexplained rank defects into an exact
(S_3/D_{10}/A_5) symmetry trichotomy and exposes the (q=31) two-dimensional
(A_5) sextic pencil.

**TT.**  The decisive comparison is not whether each individual curve looks
structured—it does—but whether the structures transport across fields.  They
do not: degree, genus, conic intersection, chord intersection, stabilizer, and
character-space dimension all change.  The correct conclusion is therefore to
retain the finite (A_5) object while killing the proposed uniform
split-support carrier.

Open mysteries:

- **Selected-witness bias remains open.**  The input contains one selected
  maximum-coverage witness per field.  It is not known whether every projective
  orbit of maximum witnesses at (q=13,29,31) has an early kernel.  Closing
  this requires an all-maximum-witness orbit census, not another calculation on
  these three examples.  It is not needed for the negative uniform verdict.
- **The (A_5) pencil parameter is not intrinsically named.**  The checker
  proves the exact two-space and the (Q^3) member, but does not identify the
  second generator with a preferred classical normalization.  Such a naming
  would be exposition, not a new obstruction, and has no allocated successor.
- **Why these audit representatives maximize coverage remains separate.**  The
  kernel curves recover their symmetry, but do not prove extremality or the
  masked direction gap (h\ge1).  Those remain owned by the global
  Rédei/split-chord target and the prefix-container diagnostic.

## Replay, trust boundary, and limits

Run from `rust/` in a disposable environment:

```text
python3 -m venv /tmp/c756-kernel-curves-venv
/tmp/c756-kernel-curves-venv/bin/pip install \
  'python-flint==0.9.0' 'sympy==1.14.0'
/tmp/c756-kernel-curves-venv/bin/python3 \
  ../notes/2026-08-01-c756-kernel-curves.py --check
sha256sum ../notes/2026-08-01-c756-kernel-curves.{py,json} \
  ../notes/2026-08-01-c756-masked-rs-collision-audit.json
```

The generator independently recomputes missing sets, evaluation kernels,
curve points, chord incidences, all conic-preserving stabilizers, element
orders, orbit catalogues, and invariant external-arc catalogues.  FLINT checks
base-field factorization; SymPy checks the three chart Jacobian ideals.  Direct
evaluation checks every kernel equation and every stabilizer scalar identity.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-kernel-curves.py` | 18,389 | `404e1ea824fdbac182a2aedcf43d43cd87423faa94af58eef5a1c07f1614829b` |
| `notes/2026-08-01-c756-kernel-curves.json` | 18,282 | `3cf5a14fb0655cd080f119e5a26c9597ce06512f4c0122f83627e718b2af88e9` |
| input `notes/2026-08-01-c756-masked-rs-collision-audit.json` | 9,581 | `dbefb995e5ff64195f9ca3f0b07f147399fd45e50131242aed409b301d9f81a4` |

The result certifies only the three selected prime-field witnesses and their
first unexpected kernel degrees.  It does not classify every maximum witness,
prove a statement in other fields, or advance the uniform (h\ge1) theorem.
