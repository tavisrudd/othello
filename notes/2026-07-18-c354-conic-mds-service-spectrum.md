# C354: exact conic-MDS service spectrum

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **SHARP OBSTRUCTION; POINT TYPE DOES NOT CLASSIFY THE SRR**

## Result

Fix the conic

\[
\mathcal O=\{(t^2:t:1):t\in\mathbb F_q\}\cup\{(1:0:0)\}\subset PG(2,q)
\]

and a column matrix `F` for its `q+1` points.  A raw-object basis is a projective frame
`B=(b_1,b_2,b_3)`; the corresponding generator matrix is `G_B=B^{-1}F`.  Scaling a `b_i` only
rescales one raw object, and reordering the frame only permutes the three service coordinates.  C354
therefore counts unordered projective frames and identifies SRRs up to coordinate permutation.

The exact census gives:

| `q` | unordered projective frames | `PGL(2,q)` frame orbits | distinct SRRs |
|---:|---:|---:|---:|
| 5 | 3,875 | 50 | 43 |
| 7 | 26,068 | 109 | 78 |
| 9 | 110,565 | 203 | 93 |
| 11 | 354,046 | 339 | 217 |

The frame count is independently forced by

\[
\frac{(q^2+q+1)(q^2+q)q^2}{6},
\]

the number of unordered noncollinear triples in `PG(2,q)`.  The machine certificate records every
orbit representative, stabilizer order, orbit size, point-type word, exact rational vertex/facet
description, and its multiplicity among all frames.

The hoped-for classification by the internal/external/on-conic word fails at the first required
field and fails sharply.  The numbers of distinct SRRs within each type are:

| type | `q=5` | `q=7` | `q=9` | `q=11` |
|:--|--:|--:|--:|--:|
| `III` | 1 | 1 | 1 | 1 |
| `IIE` | 7 | 12 | 19 | 46 |
| `IEE` | 10 | 27 | 28 | 92 |
| `EEE` | 7 | 15 | 19 | 45 |
| `IIO` | 2 | 2 | 2 | 2 |
| `IEO` | 7 | 9 | 11 | 16 |
| `EEO` | 4 | 7 | 8 | 10 |
| `IOO` | 1 | 1 | 1 | 1 |
| `EOO` | 3 | 3 | 3 | 3 |
| `OOO` | 1 | 1 | 1 | 1 |

Here `O` means on the conic; the table sorts the letters, so the report's `IIE`, for example, is
serialized as `EII` in the JSON.  All-internal frames give the oval simplex, as in the 2026 paper.
Every other high-variation off-conic type requires substantially finer frame data.

## Smallest same-type separation

Over `F_5`, both frames

\[
A=\{(0:1:0),(1:0:1),(1:0:4)\},\qquad
B=\{(0:1:0),(0:1:1),(1:4:0)\}
\]

have type `EEE`, and every coordinate axis has intercept `5/2`.  Nevertheless their SRRs differ.
The region for `A` contains `(0,1,2)`.  The region for `B` has the certified facet

\[
\lambda_1+2\lambda_2+2\lambda_3\le 5,
\]

up to coordinate permutation, so `(0,1,2)` is excluded.  The JSON supplies a rational allocation
for the first statement and a rational fractional-cover dual certificate for the second.  Thus axes,
the `EEE` word, and equality of the three one-object capacities do not determine the SRR.

This is the sharp obstruction required by C354's exit gate.  The bounded data do not support an
all-odd-`q` closed spectrum: already at `q=11`, 45 of the 48 `EEE` frame orbits and 92 of the 99
`EEI` frame orbits have different regions.  An all-field classification would effectively need a
full frame-orbit invariant plus a parametric fractional-matching projection, not a refinement by a
small fixed list of point types.  C354 stops rather than promoting that uncontrolled same-type
variation into another census.

## Recovery and equivalence conventions

For a target `b_i`, a minimal recovery set has size at most three:

- if `b_i` is on the conic, its column is a singleton recovery;
- otherwise the size-two recoveries are exactly the secant pairs through `b_i`;
- a conic triple is minimal exactly when it contains neither a singleton nor a recovering secant
  pair for that target.

The service region is the image of the resulting labelled fractional-matching polytope under the
map summing edge weights by target.  Point type is computed from the quadratic character of
`y^2-xz`: zero is `O`, square is `E`, and nonsquare is `I`.  The conic stabilizer is the symmetric-
square copy of `PGL(2,q)`; its order is checked as `q(q^2-1)`.  The q=9 computation uses
`F_3[x]/(x^2+1)` and the same projective normalization as the prime fields.

## Exact certificate and replay

The evidence bundle is:

- `notes/2026-07-18-c354-conic-mds-service-spectrum.py` — deterministic generator/checker;
- `notes/2026-07-18-c354-conic-mds-service-spectrum.json` — canonical orbit, spectrum, facet,
  vertex, primal-allocation, and dual-cover certificate;
- `notes/2026-07-18-c354-conic-mds-service-spectrum.sha256` — SHA-256 and byte counts for the
  report, script, and JSON.

From `/home/tavis/src/othello/rust`, regenerate with:

```bash
nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \
  'PYTHONPYCACHEPREFIX=/tmp/persistent/tavis/c354-pycache python3 \
  ../notes/2026-07-18-c354-conic-mds-service-spectrum.py \
  --output ../notes/2026-07-18-c354-conic-mds-service-spectrum.json'
```

Check the tracked artifact without modifying the worktree with:

```bash
nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \
  'PYTHONPYCACHEPREFIX=/tmp/persistent/tavis/c354-pycache python3 \
  ../notes/2026-07-18-c354-conic-mds-service-spectrum.py --check'
```

For every reported vertex, the checker verifies an exact rational primal allocation against every
server-capacity constraint.  For every non-coordinate facet, it verifies an exact rational dual
fractional cover whose weight equals the facet bound.  Hence the certified vertices lie inside the
true projected polytope and the true polytope lies inside the certified facets; exact rational hull
enumeration then proves equality.  Floating-point `scipy.optimize.linprog` is used only to discover
candidates, not to trust a facet or vertex.

As an independent replay, a second subset-by-subset implementation reconstructs every minimal
recovery set directly from linear dependence and compares it with the secant/triple construction.
Orbit sizes sum to the closed projective-frame count above, and every orbit stabilizer satisfies
orbit--stabilizer.  The trusted boundary is the short finite-field arithmetic, exact rational
certificate checks, and Python integer/fraction arithmetic.  The computation does not prove a
formula for untested fields, an integral scheduling statement, a failure-robust region, or a queueing-
delay law.

## Literature boundary

- Ball--Lavrauw, [*Arcs in finite projective spaces*](https://arxiv.org/abs/1908.10772), Theorem 17,
  gives the arc--MDS equivalence: generator columns of an MDS code are an arc and conversely.
- Kurz, [*Designing codes for storage allocation*](https://doi.org/10.15495/EPub_UBT_00005191),
  explicitly treats the generator matrix/projective multiset as the service object, but restricts
  its detailed three-file analysis to the binary field and does not classify conic frames.
- Alfarano--Kilic--Ravagnani--Soljanin,
  [*The Service Rate Region Polytope*](https://arxiv.org/abs/2303.04021), establishes the projected
  polytope/rational-allocation framework and handles systematic MDS matrices.
- Ly--Soljanin,
  [*Service Rate Regions of MDS Codes and Fractional Matchings in Quasi-uniform Hypergraphs*](https://arxiv.org/abs/2504.17244),
  classifies a family indexed by the number of systematic columns; it does not cover the conic
  matrices with size-two recovery sets studied here.
- Di Giusto--Ravagnani--Soljanin,
  [*The Oval Strikes Back*](https://arxiv.org/abs/2601.16628), proves the exact simplex for a basis
  of three internal points and asks for other MDS matrices/geometric incidence structures.  It does
  not enumerate mixed or external frames.
- Hollmann--Xiang,
  [*Association schemes from the action of `PGL(2,q)` fixing a nonsingular conic*](https://arxiv.org/abs/math/0503573),
  classifies pair orbitals of non-tangent lines using cross-ratio, not full frame orbits or SRRs.
- Tranchida,
  [*Triples of involutions in `PGL(2,q)` and their incidence geometries*](https://arxiv.org/abs/2411.10299),
  studies off-conic triangles through generated subgroups, self-polarity, and hypertopes, but gives
  no service-polytope classification or count.

A targeted title/identifier, primary-reference, and forward search through 2026-07-19 found no
follow-up that classifies generator-matrix SRRs over a fixed conic code or enumerates these exact
frame spectra.  This is a focused search boundary, not a MathSciNet/zbMATH absence claim.

The load-bearing cached full texts and SHA-256 values are `arXiv:1908.10772`
`00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`,
`10.15495/EPub_UBT_00005191`
`bb93a894b699a2143acbd9cf9ef5078bb34944cc9634e373a52056643916f9d1`,
`arXiv:2303.04021` `ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4`,
`arXiv:2504.17244` `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`,
`arXiv:2601.16628` `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`,
`arXiv:math/0503573` `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`,
and `arXiv:2411.10299` `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.
