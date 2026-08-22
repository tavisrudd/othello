# Cold referee report: *Frobenius-equivariant pair extension and robust repair of eight-arcs*

Date: 2026-08-21

## Material and scope

I cold-read the manuscript source at commit
`a16667ce13262a5bb6dc04e3c32e405927362ce4`.  The PDF extracted from that
commit has SHA-256
`a4f2de94a1969efc30218b158b1e76f29c27fb976238a33ae0c070a639b0e98d`,
matching the frozen PDF specified for review.  I did not consult earlier
reports, dossiers, task notes, handoffs, or builds.  I inspected selected
source declarations from the pinned Q25 certificate commit read-only.  I did
not run Lean, Lake, Nix verification, regeneration, or a manuscript build.

## Verdict

**Grade A (ready) on manuscript-local mathematical and expository grounds.**

I find no manuscript-local mandatory correction.  Proposition 5.3, including
the step from the normalized finite census back to semantic projective arcs,
is now stated and proved with enough precision to close the previously
plausible normalization/equivalence gap.  The remaining mandatory actions are
external release and retrievability gates, not corrections to the manuscript's
mathematics or wording.

## Proposition 5.3

### Residual group and action

After the ordered fixed points are sent to

\[
 A=[0:0:1],\qquad B=[0:1:0],
\]

their pointwise stabilizer in \(\operatorname{PGL}(3,5)\) consists, after
normalizing the first diagonal entry, of the 400 triangular matrices

\[
 [X:Y:Z]\longmapsto
 [X:\alpha X+\lambda Y:\beta X+\mu Z],
 \quad \alpha,\beta\in\mathbb F_5,
 \quad \lambda,\mu\in\mathbb F_5^*.
\]

The displayed maps \(g_{y,z}\), with
\(y=a+b\omega\), \(z=c+d\omega\), realize this full stabilizer via
\((\alpha,\lambda)=(-ab^{-1},b^{-1})\) and independently in the third
coordinate.  Thus the claimed group has exactly \(20^2=400\) elements, is
isomorphic to
\(\operatorname{AGL}(1,5)\times\operatorname{AGL}(1,5)\), fixes \(A,B\)
individually, and commutes with Frobenius.  The pinned source's
`residualApply` is the same action in canonical affine and infinite charts,
and its group layer proves the corresponding composition law and action.

### Ordered normalization and finite rows

The first normalization is legitimate: two distinct fixed projective points
have independent representatives and a base-field projectivity sends the
ordered pair to \((A,B)\).  Every other selected point is then off \(AB\), so
it has the unique form \([1:y:z]\).  Noncollinearity with
\((A,P,\phi P)\) and \((B,P,\phi P)\) is exactly the condition that the
imaginary coefficients of \(y,z\) are nonzero.  The displayed
\(g_{y,z}\) consequently sends a chosen nonfixed orbit to the standard orbit
through \([1:\omega:\omega]\).

The certificate source confirms all details needed for the row
correspondence:

- its canonical projective charts are exactly \([1:y:z]\), \([0:1:z]\),
  and \([0:0:1]\);
- its `OrbitCode` bijectively enumerates the 310 nonfixed Frobenius pairs;
- code 5 is the standard pair through \([1:\omega:\omega]\);
- compatibility with \(A,B\) excludes codes 0 through 4; and
- after fixing code 5, ordering the two remaining distinct codes produces
  precisely \(6\le b'<c'\le309\), hence \(\binom{304}{2}=46{,}056\)
  dispatched rows.

There is therefore no missing normalized branch and no illicit quotient by
the choice of selected orbit or conjugate point.

### Five representatives and exact equivalence

The five printed code pairs

\[
 (58,169),\ (61,81),\ (63,141),\ (97,109),\ (113,194)
\]

agree with the five representatives in the pinned certificate source.  The
source derives their residual-orbit sizes \(200,400,400,200,400\) from
stabilizers of orders \(2,1,1,2,1\), proves pairwise disjointness, and gives
union cardinality 1600.  Its exhaustion terminal puts every normalized row
with legal-pair cardinality 32 in this union and gives at least 33 outside it.

The manuscript now states the equivalence relation exactly: subsets are acted
on pointwise by the full stabilizer of the **ordered** pair \((A,B)\), while
the swap is excluded.  This is the right relation.  Any two first
normalizations with the same ordering differ by this stabilizer.  The second
normalization is itself an element of the same group, so choosing a different
old nonfixed orbit or its conjugate only moves the normalized configuration
within its existing \(G\)-orbit.  The text also correctly limits the result to
classification up to ordered normalization; it does not claim a count of
unnormalized arcs or quotient by the fixed-point swap.

### Semantic transport

The certificate's `RawCap` is the nonzero-determinant condition for every
triple of distinct canonical points.  Its `LegalPair` predicate requires both
new points to be fresh and checks the determinant conditions after adjoining
the first and then the conjugate point.  Together with the bijection on the
310 nonfixed orbits, this is exactly the manuscript's semantic definition of
a fresh legal conjugate pair.  Base-field projectivities commute with
Frobenius and biject candidate pairs while preserving freshness and
collinearity.  Thus both the cardinality \(L\) and equality transport in both
directions.  I find this bridge complete.

## Rest of the mathematics

The carrier argument is correct.  Empty fixed lines are counted exactly;
nonfixed old secants occur in \(M=fe+e(e-1)\) Frobenius orbits; and each such
orbit forbids at most one candidate on a fixed empty carrier.  The linewise
invisible-center and collision identities are exact support/multiplicity
identities, and their aggregate form is used consistently.

The four nonexceptional Q25 profiles also check out.  In particular, the
cross-pair center estimate counts at most \(f+(e-2)\) occupied fixed lines
through the center.  In the \((0,4)\) profile, the second secant-index moment
is partitioned correctly among fixed external points, nonfixed points on the
four occupied mate lines, and candidates on empty carriers; the inequalities
give \(B\ge48\), \(R\ge11\), and hence \(L\ge5\).

The saturation, five-profile envelope, and parameterized exchange arguments
are arithmetically and logically consistent.  The empty-carrier step in the
parameterized theorem follows from the phase inequality and the completed-
square occupation identity; the erased orbit is then correctly removed from
the total legal-pair count.  The main theorem and its repair multiplicities
follow with no hidden profile case.

## Coding interpretation and exposition

The coding translation is accurate at the level claimed: projective columns
of a \(k\)-arc give a dimension-three \([k,3,k-2]\) MDS code, and adjoining a
conjugate projective pair is a Frobenius-compatible two-column lengthening.
The manuscript appropriately warns that “repair” changes the generator-column
configuration and is not erasure decoding in a fixed code.  Column scalings
and projective equivalence are implicit standard conventions and do not
create a mathematical ambiguity in the stated results.

The exposition is unusually effective for a computer-assisted classification:
the conceptual carrier mechanism precedes the census, the exact correction is
separated from the first-order bound, and the trust boundary is repeated only
where it matters.  Proposition 5.3 is long, but the length is warranted by the
normalization and transport obligations.  I found no local wording change
that rises to a required correction.

## Artifact reproducibility

The frozen paper pin is internally precise.  In the locally available Git
object database, certificate commit
`d4e910cf01819a8678fd84422bb18fe23f4d6695` exists, and its `MANIFEST.json`
hash is exactly
`4f3d252a453c7217a8a8aaf7b27374794396e2d0b4101c7c8b85683deaa52292`.
The package records a locked Lean/mathlib toolchain, a single aggregate build
target, canonical-input digest, source-regeneration checks, and a final
manifest seal.  The manuscript candidly identifies the 9,511-module scale
and distinguishes a lightweight identity check from a full kernel build.
That is an adequate reproducibility specification.  This review does not
claim that the large command was executed.

## External publication and retrievability blockers

These do not change the manuscript-local grade, but they are mandatory before
public release:

1. As viewed without authentication on 2026-08-21, the cited public
   `finitegeom-q25-certificates` GitHub repository reports that it is empty,
   and the pinned commit URL does not expose the commit.  The local object is
   therefore not presently an independently retrievable public artifact.
2. The cited structural-source URL at Othello commit
   `9977af02cfed699c1c14802242a6f500896164bc` returns 404 publicly.
3. The paper itself is described as a staged release and has no archival
   identifier in the frozen metadata.  Deposit the frozen paper source/PDF
   and both evidence trees, or otherwise make the exact pinned commits
   publicly retrievable, before claiming a reproducible public release.

Once those external objects are published at the printed identities, I see no
remaining mandatory obstacle to submission.
