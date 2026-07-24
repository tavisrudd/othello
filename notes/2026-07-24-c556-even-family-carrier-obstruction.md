# C556: orthogonal-resolution and conic-residue obstruction

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete negative.  The zero-defect matching design is exactly in
the maximal-arc partial-geometry parameter family, but rank-three realization
does not presently force the missing family of dual orthogonal resolutions.
The apparent \(4006\)-hole versus \(4005\)-resolution bridge fails at its
first geometric gate.  The prescribed conic instead supplies a sharp binary
nucleus residue; the ten-point falsifier shows that this one-bit datum occurs
in both the realizable and Mathon classes and therefore does not supply the
missing theorem.

## Exact partial-geometry bridge

Let \(k=2m\), and suppose a \(k\)-arc has zero defect.  Its maximum centres
form a \(\operatorname{MATCH}(k,m,1)\) design \(D\): the points of \(D\) are
the \(\binom{k}{2}\) secants, and its lines are the perfect matchings attached
to maximum centres.  In the common \(pg(s,t,\alpha)\) convention,
\[
 D=\operatorname{pg}(m-1,k-4,m-2),\qquad
 D^*=\operatorname{pg}(k-4,m-1,m-2).
\]
Put \(d=2\) and \(d'=m-1\).  Then \(D^*\) has the Gezek--Tonchev maximal-arc
parameters
\[
 \operatorname{pg}\bigl(d(d'-1),d'(d-1),(d-1)(d'-1)\bigr).
\]

The \(k\) arc vertices give \(k\) pairwise orthogonal parallel classes in
\(D^*\): for a vertex \(a\), the \(k-1\) secants through \(a\) are disjoint
as lines of \(D^*\) and cover every maximum centre once.  This meets the
Gezek--Tonchev bound
\[
 d(dd'-d'+1)=k.
\]
Their Theorems 2.3--2.4 say that the geometry arises from a degree-two
maximal arc in a projective plane of order \(k-2\) precisely when the other
side also meets its bound.  Thus \(D\) must have
\[
 R=(m-1)(2m-3)
\]
pairwise orthogonal parallel classes.  A parallel class of \(D\) is exactly
a resolution of \(K_k\) by \(k-1\) maximum-centre matchings.

This identifies the missing input without proving it: zero defect gives the
first maximal family abstractly, while neither the matching axioms nor the
known rank-three equations give the second.

## Why the literal hole map fails

At the sole square-root equality parameter
\[
 (q,k,m)=(4096,92,46),
\]
let \(N\) be the nucleus of the prescribed conic \(\mathcal C\), and let
\[
 E=\{y\in\mathcal C:r(y)=46\},\qquad
 H=\{y\in\mathcal C:r(y)=0\}.
\]
The equality calculation gives
\[
 |E|=91,\qquad |H|=4006,
\]
whereas the missing Gezek--Tonchev family has
\[
 R=45\cdot89=4005
\]
classes.

The numerical offset does not define a map.  All conic tangents pass through
\(N\).  If \(N\in A\), its \(91\) incident \(A\)-secants would all be conic
tangents.  But if \(a,b,c\) count external, tangent, and chord \(A\)-secants
relative to \(\mathcal C\), then
\[
 a+b+c=\binom{92}{2},\qquad b+2c=46|E|=\binom{92}{2},
\]
so \(a=c\) and \(b\) is even, a contradiction.  Hence \(N\notin A\).
Relative completeness gives \(r(N)>0\); zero defect and parity then force
\[
 r(N)=b=46.
\]

For \(y\in H\), its conic tangent is \(A\)-external and contains \(N\).
If it contains \(v_y\) maximum centres and \(u_y\) index-one centres, the
linewise secant count gives
\[
 u_y+46v_y=46\cdot91.
\]
It produces a resolution only when \(v_y=91\).  The conic-tangent pencil
partitions all maximum centres except its common point \(N\), and there are
only
\[
 (k-1)(k-3)-1=8098
\]
such remaining centres.  Therefore at most
\[
 \left\lfloor\frac{8098}{90}\right\rfloor=89
\]
members of the entire tangent pencil can support resolutions.  In
particular, the \(4006\) holes cannot inject into the required \(4005\)
resolution family through their canonical tangent lines.

## The actual one-bit residue

The set \(E\) gives a different, exact structure.  Its \(91\) maximum-centre
matchings cover

- each of the \(46\) tangent edges once;
- each of the \(2070\) chord edges twice; and
- each of the \(2070\) external edges zero times.

The tangent edges are exactly the nucleus matching \(M_N\).  Consequently,
in the binary edge space of \(K_{92}\),
\[
 \boxed{\quad \sum_{y\in E} M_y=M_N.\quad}
\]
Moreover every arc vertex has one tangent mate, chord degree \(45\), and
external degree \(45\): across the \(91\) matchings in \(E\), its incident
edge is counted once on the tangent edge and twice on each chord edge.

This is the genuine connection to the Clebsch hexad/one-bit program.  A
large matching configuration leaves one canonical binary residue.  The
connection stops there.  C501--C502's hexad bit is a local readout of the
already existing outer torsor
\[
 \operatorname{PGL}_2(11)/\operatorname{PSL}_2(11)\cong C_2;
\]
it does not create the carrier swap.  At the ten-point characteristic-two
benchmark,
\(\operatorname{PGL}_2(8)=\operatorname{PSL}_2(8)\), so that outer quotient
has no analogue.  At \(k=92\) no canonical degree-\(91\) group action is
available from the hypotheses.

## Exact ten-point falsifier

The certificate consumes C574's two canonical
\(\operatorname{MATCH}(10,5,1)\) designs and performs three exhaustive
checks.

1. It enumerates resolutions.  The classical class has exactly \(28\), every
   pair orthogonal, while Mathon's class has exactly one.  These counts
   independently reproduce Gezek--Tonchev's Section 3 computation.
2. It enumerates nine-block subsets whose edge multiplicities lie in
   \(\{0,1,2\}\) and whose odd residue is a matching.  The classical class
   has \(64\,260\) witnesses, \(1\,020\) over every target matching.
   Mathon's class also has \(1\,080\): \(16\) over each of \(54\) targets and
   \(24\) over each of nine targets.
3. It performs the nucleus-in-arc analogue, where the odd residue is a
   vertex star.  The classical class has \(13\,020\) witnesses, \(1\,302\)
   over each vertex.  Mathon's class still has \(114\), split as six over
   nine vertices and sixty over one vertex.

The explicit conic-compatible regular hyperoval from C574 has edge
multiplicity histogram
\[
 18\cdot0,\qquad 9\cdot1,\qquad18\cdot2,
\]
and its odd residue is exactly the star at the prescribed conic's nucleus,
which belongs to the arc.  Its nine conic matchings meet every one of the
\(28\) resolutions evenly: ten resolutions are disjoint from them and
eighteen meet them in two blocks.  Reaching a resolution requires replacing
at least seven of the nine conic blocks.

Thus existence of the binary residue does not distinguish rank-three
realizability or maximal-arc origin.  Even the stronger
\(\{0,1,2\}\)-multiplicity condition survives abundantly in Mathon's
field-uniformly non-realizable class.

The binary code of the \(28\) classical resolution vectors has rank \(19\).
Every star-residue witness is orthogonal to all \(28\) vectors, while every
matching-residue witness has odd intersection with exactly four.  This is a
clean finite signature, but it presupposes the full resolution family and
does not construct it.

## Evidence and replay

The atomic evidence bundle is

- `notes/2026-07-24-c556-even-family-carrier-obstruction.py`;
- `notes/2026-07-24-c556-even-family-carrier-obstruction.json`;
- `notes/2026-07-24-c556-even-family-carrier-obstruction.sha256`.

Replay from `rust/`:

```bash
python3 ../notes/2026-07-24-c556-even-family-carrier-obstruction.py --check
sha256sum -c ../notes/2026-07-24-c556-even-family-carrier-obstruction.sha256
```

The load-bearing input is C574's JSON certificate, whose SHA-256 is pinned
inside the C556 JSON.  The generator uses exact integer, set, and
\(\mathbf F_8\) arithmetic.  Resolution enumeration is an exact-cover
recursion.  Matching residues use a \(5+4\) meet-in-the-middle decomposition;
star residues use a \(4+5\) decomposition.  Every returned witness is then
checked directly against all \(45\) edge multiplicities.

Gezek--Tonchev's published Section 3 gives an independent check of the
load-bearing \(28/1\) resolution counts.  The direct \(\mathbf F_8\)
reconstruction independently checks the classical design, conic
disjointness, nucleus, and residue histogram.  The larger auxiliary residue
counts are reconnaissance rather than a theorem input; they have canonical
regeneration and direct witness validation but no second exhaustive
implementation.

Artifact data:

| file | bytes | SHA-256 |
|---|---:|---|
| generator | 15,833 | `8609a1381bef160f66aa1d56a6679337d3c55e209b2ca712ef644dce728a518a` |
| JSON certificate | 4,243 | `995d27e5d1b697e9878f70bbf3f24047cd0fef75106033c03682d7beb5a3a735` |

The literature input is Mustafa Gezek and Vladimir D. Tonchev, *On partial
geometries arising from maximal arcs*, Journal of Algebraic Combinatorics 55
(2022), 117--139, DOI `10.1007/s10801-020-00995-8`.  The cached arXiv
version `arXiv:2008.13246`, SHA-256
`66f4d59fd19b3aa4307482b5dc479f22b8287e186f2c451881a9d02e8f9f3189`,
was read at partial depth: Construction 2.1, Theorems 2.3--2.4 and their
proofs, and the complete order-eight comparison in Section 3.  No novelty or
absence claim is made.

## `ej` + `tt` closeout

The cheap upgrades are the exact nucleus theorem, the regular
chord/external split, the binary residue identity, and the tangent-pencil
\(89\)-line ceiling.  They sharpen the exceptional parameter without
eliminating it.

The Tao-style stress test asks whether the one-bit residue creates the
resolution carrier.  It does not: the Mathon design has both matching and
star residues despite having only one resolution, and the regular conic
configuration is seven block replacements from every resolution.  The
Clebsch comparison explains the failure conceptually: a local bit can read
an outer torsor only after the two-sheet carrier exists.

**NO-GO:** C556 exposes a precise maximal-arc reconstruction target but no
theorem forcing the missing dual family from rank-three realization.  It
therefore supplies no infinite characteristic-two carrier obstruction and
does not improve the manuscript's asymptotic lower bound.

## Mystery ledger

- **Settled:** the zero-defect partial geometry lies exactly in the
  Gezek--Tonchev maximal-arc parameter family, and the arc stars attain one
  of the two required orthogonal-class bounds.
- **Settled negatively:** the \(4006\) conic holes do not canonically supply
  the missing \(4005\) classes through their tangent lines; the whole tangent
  pencil can support at most \(89\) resolution lines.
- **Settled:** the exceptional conic data instead gives a \(45\)-regular
  chord graph, a \(45\)-regular external graph, the nucleus matching, and the
  displayed binary residue.
- **Settled negatively:** that residue and its \(\{0,1,2\}\) integral lift
  do not distinguish the regular and Mathon ten-point designs.
- **Settled negatively:** the Clebsch hexad outer bit is not the missing
  carrier.  It is a readout of a pre-existing \(C_2\)-torsor, and the
  characteristic-two benchmark has no corresponding
  \(\operatorname{PGL}/\operatorname{PSL}\) quotient.
- **Open:** whether some nonlinear many-base rank-three invariant forces a
  maximal orthogonal family remains unknown.  The next clean unallocated
  gate is the square-restriction degeneracy locus
  \(F_A|_{x^*}\in K[x_0,x_1]^2\), not another resolution or parity census.
