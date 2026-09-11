# C1133: independent hostile referee report on A–D

**Date:** 2026-09-10. **Lane:** `cubic-threefolds`.
**Referee remit:** hidden assumptions in the quantum comparison, surface
vanishing, Hodge conservation and the C/D deductions. This is a fresh
journal-style assessment of the proof sources, not an adoption of an earlier
acceptance decision.

**External full-text reads in this report: one** — Iritani's ten-page Hodge
note. Every other external source below, including the follow-up's Behrend
source, was read only at the explicitly recorded primary passages.

## Summary and contribution

The proposed argument selects whole primary factors of quantum multiplication
using their full even rank, a canonical rank-two residue, and the odd
representation of the universal Hodge group. The selected factors vanish for
complex surface centers. Blowup comparisons consequently turn their additive
counts and representation classes into birational invariants in dimensions
three and four. The proposed applications are the one-stabilization
classification of Picard-rank-one Fano threefolds (A), rational third-Hodge
conservation for the nine detected families (B), very-general cancellation for
cubic and quartic threefolds (C), and bounded-degree arithmetic finiteness for
partners of a fixed cubic (D).

I found **no demonstrated fatal or major mathematical error in the audited
comparison-to-conservation argument**. In particular, the cited comparisons
really provide the independent coordinates and regular inverses that the
argument uses. The fixed-base faithfulness proof is a substantive additional
argument; it is not merely an assertion that restriction preserves injection.
The written proof of that argument survives the tests described below.

This conclusion has a specific boundary. I read the entire upgrade packet,
the two supplementary proof notes, and the complete current comparison section.
I did not independently rederive all seventeen enumerative inputs, their
identification with every smooth deformation family, or the positive rationality
classification. Accordingly, this report supports A relative to those geometric
inputs, B at the stated detected endpoints, and the C/D implications from B.
It is not a replacement for the separate input audit or a claim to have read
every external source in the literature register.

## Significance and scope

The proposed all-member, one-stabilization result and Hodge conservation would
be substantial. The selection rule does useful work: ordinary cohomology alone
does not exclude contributions from surface centers in a fourfold factorization.
The resonant rank-two cases also require more information than exponent classes
modulo integers. Thus the retained lattice is mathematically consequential.

The underlying quantum decomposition and equivariant Hodge-atom theory are
external inputs, not discoveries of this packet. C and D are applications of
established Torelli and isogeny results after B has been proved. The packet
generally respects these distinctions. I make no comprehensive novelty or
priority determination, and did not review the optional pencil consequences as
part of A–D.

## Correctness: principal findings

### 1. The reduced coefficient map is faithful on the stated domain

The relevant source statements are Iritani v3 Remark 2.3, Remark 5.6, and
equations (5.47)–(5.48), read at their actual locations. Remark 2.3 reduces the
connection to combined Novikov/divisor variables, with the unit coordinate
polynomial. Remark 5.6 takes the image of that reduced ring under the center
Novikov map. Section 5.8.2 supplies independent coordinates on the external
direct sum. These are the ingredients used by the manuscript's
`lem:faithful-center-base-change`, rather than an invented replacement for
Iritani's coefficient construction.

The proof's two finiteness assertions are justified under its conventions.
The restriction of an ambient ample divisor is ample on the center, so bounded
numerical effective-degree slices contain finitely many lattice points. At a
fixed curve class, the coefficient is polynomial in the remaining nondivisor
coordinates: its homogeneous degrees form a finite set, the unit degree is
bounded, and every remaining even nondivisor variable has strictly negative
degree. The exclusion of separate source divisor variables is essential here.

Take the least nonzero ambient ample degree. The initial shifts have degree
zero for this filtration, while positive-degree corrections cannot alter this
least piece. Translation of the finite polynomial coefficients is injective.
After grouping colliding untagged monomials, the remaining finite exponentials
have distinct numerical divisor characters. The Vandermonde argument applies
over the fraction field in the other variables, because its coefficients do
not contain these divisor coordinates. Thus the nonzero least piece survives.

The same reasoning works directly on the Hodge-fixed base. Integral divisor
classes separating numerical curve classes are fixed in the periodized
category. The fixed nondivisor directions remain polynomial coefficient
variables. No inference of injection from quotienting a larger injective map
is needed. For a disconnected center, this argument is componentwise.

This conclusion does **not** apply to unrestricted formal series in arbitrary
source coordinates, finite truncations of the exponential tags, or an arbitrary
noninjective specialization. Replacing the displayed ring by any of these would
remove an actual proof hypothesis.

### 2. Independent occurrences and Hodge-fixed restriction are supplied

Iritani Theorem 5.18(7) and Section 5.8.2 explicitly supply an invertible joint
coordinate change. Iritani–Koto v4 Theorem 5.1(5) and Section 5.8 explicitly
do the same for projective bundles; the latter section explicitly treats the
base-copy coordinates as independent variables.

Iritani's Hodge note Proposition 8 is equivariance of the formal maps and the
full comparison. It is stronger than merely preserving invariant vectors in
Corollary 11. Lemma 10 fixes the initial shifts. Equivariance of a map and its
inverse restricts them to inverse maps of fixed loci, so the direct-sum fixed
coordinates remain independent. No equality of the generic full-even and
fixed-base primary decompositions is used for arbitrary varieties.

The projective-bundle adaptation in the transport note is also valid. In
Iritani–Koto (5.11)–(5.12), initial shifts and comparison maps are constructed
using characteristic classes, scalar operations and coefficient extraction.
They commute with the Hodge action. The block-diagonal fundamental solution
has simultaneous base/fiber equivariance by the descendant-correlator argument
in Iritani's Hodge proof. The uniquely normalized Birkhoff factors inherit
equivariance, as does the inverse coordinate map extracted from the unit.
This supplies the missing bridge without assuming that blowup equivariance
alone proves projective-bundle equivariance.

The source's global-generation assumption is handled by twisting the vector
bundle as in Remark 1.2. Remark 5.2 explains the intrinsic vertical-anticanonical
splitting. Neither step imposes a positivity hypothesis on an arbitrary
weak-factorization center.

Finally, each independent unit coordinate adds a scalar to its own Euler
operator. The resultant of two translated characteristic polynomials is monic
up to the harmless resultant sign in their shift difference. It is not
identically zero. Distinct occurrences therefore have disjoint generic
spectra, even if their intrinsic spectra coincide before translation.

### 3. Original and canonical lattices are preserved

The actual Theorem 5.18 is an isomorphism over the displayed graded
z-polynomial completed ring, not only an isomorphism after inverting z.
Iritani–Koto Theorem 5.1 has the corresponding property; Remark 5.3 explains
the homogeneous coefficientwise embedding in nonnegative z-powers, and
Section 5.8 explicitly places the positive factor and its inverse in these
rings. Passage to a z-free fraction field therefore gives regular maps with
regular inverses on the original lattices.

The homogeneity degrees of these maps do not authorize separate z-shifts of
eigenlines. Iritani's Hodge note Remark 2 and Section 2(a,d) also explicitly
separate parity from the numerical degree of a ramified Novikov scalar.
Consequently the maps can preserve parity even when their displayed numerical
degree is odd.

On an eligible even rank-two block, leading-term intertwining carries N and
its image line to their counterparts. The preimage definition of the modified
lattice then makes its preservation automatic. Conjugation of residues uses
the reduction of the map in modified frames; it need not be the original
constant coefficient. The packet correctly retains the possible contribution
of the original linear z-coefficient. Resonance causes no exception to this
argument. In particular, the labels equal to one are not invalid merely
because their exponent classes agree modulo integers.

### 4. Persistence includes the mixed bulk directions actually used

I checked the flatness and trace proof of Proposition 12.1 directly. A cyclic
vector gives the full polynomial commutant over the formal local ring before
nilpotence away from the initial point is known. Centering gives trace C=0.
Tracing the displayed flatness identity against powers of N gives (12.2);
Newton identities put every higher trace in the ideal generated by the first
r traces. The least-total-degree derivative argument then forces that ideal
to vanish. Cyclicity remains because its determinant is a unit.

This proof quantifies over every formal even bulk derivative. It therefore
does not silently restrict to the divisor locus or to unmixed product
parameters. Its hypotheses still matter: the cluster must be separated from
its complement at the initial point, its centered leading term must be
cyclic there, and the centered base equations must have at most a simple
z-pole. The QDM and its regular spectral separation supply the pole bound.
The finite input still has to supply the cyclic initial cluster.

The rank-two modification then has at most the one possible lower-left bulk
pole. The diagonal part of T+[R,T]=0 forces that pole to vanish, giving a
regular bulk connection and a Lax equation for R. This checks residue
persistence without nonresonance and without a claim about arbitrary
specialization. It does not establish an arbitrary-rank lattice theorem.

### 5. Surface vanishing and full-Hodge cancellation withstand the tests

The minimal-nef-surface degree inequality is valid also with arbitrary even
nonunit bulk insertions and odd fiber inputs: the output degree strictly
increases because c1(S) has nonpositive degree on every effective curve.
Removing the unit shift is necessary. The sole primary factor consequently
has full even rank b2+2, not the dimension of its invariant subspace.

When that rank is three, b2=1. The class of i alpha wedge conjugate(alpha)
from a nonzero holomorphic one-form would be nonzero with square zero, which
is impossible in the one-dimensional real second cohomology generated by
an ample class. Thus the odd part is zero in the only dangerous rank-three
case. Curves contribute either simple factors, a zero leading operator, or
a rank-two residue of discriminant zero. Ruled surfaces follow from the
projective-bundle comparison; rational surfaces can be compared to P2 using
only point centers. This ordering is not circular.

The full-super Frobenius lemma correctly excludes odd cohomology from an
even-rank-one factor. It uses associativity, supercommutativity and the
nondegenerate Frobenius pairing. It is stronger than an assertion about the
even counting matrix alone. At a detected Picard-rank-one Fano endpoint,
the even cohomology is Tate and the odd cohomology is H3; the stated primary
configuration therefore places all of H3 in the selected factor.

Use one common reductive quotient for all varieties in the finite
factorization. Equivariant idempotents have constant multiplicities on its
isotypical summands. The safe sum is invariant under permutation of algebraic
splitting branches, so B does not need rational descent of each labelled
branch separately. Equality 2[H3(X)]=2[H3(Y)] cancels in the torsion-free
Grothendieck group of the semisimple representation category. Pure weight
three excludes nonzero Tate shifts between endpoint constituents. Finally,
the determinant polynomial on the rational equivariant-Hom space proves
descent of an isomorphism from an extension field to Q. These steps establish
a rational Hodge isomorphism; they establish no integral or principal
polarization identification.

### 6. C and D have the stated quantifiers

Voisin v3 states rational generic Torelli with a very general source and an
arbitrary smooth target of the same hypersurface type. Her Remarks 0.1 and
0.3 address the unpolarized and rational formulations. The pairs (d,n)=(3,4)
and (4,4) avoid the exceptions of Theorem 0.2. Thus C follows from B without
an unmentioned integral-polarization hypothesis. Neither all-member
cancellation nor cancellation on a prescribed special pencil follows.

Orr v4 Theorem 5.1 permits a finitely generated characteristic-zero field K,
a target defined over a finite extension L, and geometric isogeny. Its bound
has exactly the dependence used in D. Achter Theorem B provides the
arithmetic intermediate Jacobian. B gives geometric isogeny; invariance of
Hom under algebraically closed extension puts that isogeny over the
algebraic closure of K. Bounded isogeny degree gives finitely many kernels in
a fixed torsion group and hence finitely many unpolarized targets.
Narasimhan–Nori Theorem 1.1 explicitly gives the required finite principal
polarization orbits. Classical cubic Torelli finishes the geometric count.
There is no uniform bound asserted independent of X,K,D, and twists are
not being counted. I found no hidden field-of-definition or polarization
assumption in this deduction.

## Exposition and organization

The working packet has a useful separation of A, B, C and D, and keeps the
optional rank-three modification away from the proof of A. The main obstacle
to journal reading is that the exact proof currently has to be assembled
from a manuscript section and two dated notes, while the packet still has
placeholder proof instructions. A reviewer should receive a single statement
of the comparison proposition with its two bases, its full module, its source
ring and its preserved lattice, followed by one proof. The lengthy ledger
material should remain an audit companion.

The primary intended readers are birational geometers with quantum-cohomology
experts as a second audience. They need the reduced-domain injection proof
and the original-lattice argument in the main mathematical text. These are
not routine formalism that can safely be replaced by citations to the raw
decomposition theorem. A compact dependency table should separate the
seventeen-family enumerative/deformation imports from the local algebra.

## Major comments

1. **Comparison contract: tested and satisfied on the stated rings.** Preserve
   the entire argument above in a consolidated proof. An unrestricted center
   Novikov map, a quotient-restriction slogan, or an isomorphism only on the
   punctured z-disc would be insufficient. I found no such substitution in
   the supplied combined proof sources.
2. **Geometric input boundary: outside this referee's independent reread.**
   An all-member Theorem A still requires the enumerative identifications,
   fixed-basis normalizations, connected smooth-deformation coverage and the
   rationality of the eight positive families. I did not treat the packet's
   table, checker assertions, source register, or earlier reviews as an
   independent verification of those inputs. This is a limit of this report,
   not a discovered failure of the separate input audit.
3. **Hodge target: the current qualified statement is necessary.** Maintain
   full even ranks, the fixed bulk base with full fiber, one common group,
   and rational unpolarized cancellation. The evidence checked here does
   not permit stronger integral or all-member Torelli conclusions.

## Minor comments

1. The opening byte-identity assertion in the fixed-base note is stale.
   It gives `ef2bd45d...` for the comparison section; the section actually
   read here has hash `c7d397df...` recorded below. This is a provenance
   defect, not evidence by itself of a changed proof. Refresh the assertion
   or pin it explicitly to its historical snapshot.
2. For literal precision, a resultant in the difference of two scalar shifts
   has leading coefficient one up to the chosen resultant sign convention.
   Only nonvanishing is needed.
3. The packet still points [NN] at a secondary recollection. The original
   Theorem 1.1 and its principal-polarization consequence are directly
   readable on printed page 125 and should be cited there in the final paper.
4. State the finite-total-grading and polynomial-unit conventions adjacent to
   the coefficient ring, and retain the distinction between algebraic closure
   in coefficient variables and forbidden ramification in z.

## Editorial recommendation

**Favorable on correctness within the assigned scope; revise and consolidate
before submission.** I would not reject the A–D route on any of the tested
hidden-assumption grounds. A journal acceptance recommendation for the full
upgrade should be conditional on the separate seventeen-family input audit
and inspection of the consolidated manuscript. The current distributed
proof packet warrants revision rather than unconditional paper acceptance.
This recommendation reflects the reviewable-artifact and read-scope boundaries,
not a concealed claim to have found a fatal defect.

## Explicit hostile tests and EJ+TT closeout

I tested the implications against the elementary failures they must avoid:

- The untagged map x,y to q kills x-y. The retained divisor characters remove
  this kernel on the actual reduced source.
- An injection into a larger coordinate ring can become noninjective after
  quotienting the target. The fixed-base proof instead constructs and tests
  its reduced map directly.
- Integral shifts of regular-singular eigenlines can alter residue
  discriminants while preserving exponent classes. The actual comparison has
  a regular inverse on the original lattice, which excludes that operation.
- Restriction to the divisor or unmixed product locus would leave generic
  mixed bulk uncontrolled. The cyclic flatness argument uses every formal
  bulk derivative. It must not be applied to a noncyclic initial factor.
- Odd Betti number alone gives no surface exclusion. The proof instead uses
  the whole even rank and the b2=1 argument.
- A polarized integral Torelli theorem alone would not consume B. The actual
  Voisin statement is rational and unpolarized with the required quantifiers.

These are falsifications of weakened replacement arguments, not counterexamples
to A–D. I found no task-owned mathematical repair to add for free. The useful
closeout improvement is to make the faithful-domain and lattice hypotheses
first-class in the final comparison proposition, with the exact source loci
recorded below. No alternative P1-only replacement is assessed by this report.

### Mystery ledger

- **Settled in this read:** the source of independent occurrence coordinates;
  faithfulness after direct fixed-base reduction; full-fiber equivariance;
  regular inverse and resonant lattice transport; mixed-bulk cyclic
  persistence; the dangerous rank-three surface case; rational cancellation;
  and the C/D quantifier checks.
- **No genuine mathematical mystery was established in those interfaces.**
  The remaining independent-read gap is the all-seventeen geometric input
  package, owned by C1133's separate input review. Optional appendices and
  pencil claims receive no acceptance from this audit.

## Read-depth and reproducibility record

Read-depth below records this referee's own reading, independently of the
register's earlier entries. Cached bytes were not counted as read. The four
internal proof sources were read in full, including all appendices and the
embedded checker in the packet; the checker was read, not executed. No Lean,
manuscript build, external communication, manuscript edit or acceptance-map
edit was performed. The lane handoff was read for routing, not as evidence
for any prior verdict. Its first whole-file display exceeded the repository's
output limit; it was replaced by bounded contiguous reads. This procedural
failure did not become a source-reading claim.

| External source | This read's depth | Exact locus and role |
|---|---|---|
| Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3 | Partial primary text | Extraction 700–865, 4180–4300, 5590–5915: QDM conventions, Remark 2.3, (5.15)–(5.16), Remark 5.6, actual z-connections, Theorem 5.18, initial shifts, independent coordinates and (5.47)–(5.48). |
| Iritani–Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4 | Partial primary text | Extraction 1–107, 2330–2480, 3219–3330: twisting hypothesis, Theorem 5.1, Remarks 5.2–5.4, Fourier construction opening, complete reconstruction section and inverse positive factor. |
| Iritani, *Notes on the decomposition theorem for blowups*, arXiv:2604.10028v2 | Full primary text | All ten pages, extraction 1 through end, including references; parity conventions, universal Hodge category, Lemma 7, Proposition 8, Lemma 10 and Corollary 11. |
| Katzarkov–Kontsevich–Pantev–Yu, arXiv:2508.05105v2 | Partial primary text | Extraction 3880–3985 and 4366–4430: fixed locus, local G-atoms, projective-bundle equivalence and beginning of the nonrationality criterion. Not a full read of their analytic construction. |
| Voisin, *Schiffer variations and the generic Torelli theorem for hypersurfaces*, arXiv:2004.09310v3 | Partial primary text | Extraction 1–115: rational very-general-source/arbitrary-target formulation, Theorem 0.2, Remarks 0.1–0.4; matched official HTML. No independent proof of generic Torelli claimed. |
| Orr, *Families of abelian varieties with many isogenous fibres*, arXiv:1209.3653v4 | Partial primary text | Extraction 1100–1190: Theorem 5.1 and its complete proof. The version is the corrected v4; the earlier correction's separate proof was not reread. |
| Achter, *Arithmetic Torelli maps for cubic surfaces and threefolds*, arXiv:1005.2131v4 | Partial primary text | Extraction 35–105: Theorem B and its arithmetic interpretation. Construction proof not reread. |
| Narasimhan–Nori, *Polarisations on an abelian variety*, DOI 10.1007/BF02837283 | Partial primary scan | Printed pages 125–126 visually read: Theorem 1.1, its principal-polarization consequence, and the degree convention. Pages 127–128 not read in this audit. The web screenshot timed out; existing local page images were inspected. |
| Abramovich–Karu–Matsuki–Włodarczyk, arXiv:math/9904135v4 | Partial primary text | Extraction 1–165: Theorems 0.1.1 and 0.3.1, in particular projectivity of all intermediate varieties for projective endpoints. Factorization proof not reread. |

Primary online locations consulted are [Iritani v3](https://arxiv.org/html/2307.13555v3),
[Iritani–Koto v4](https://arxiv.org/html/2307.03696v4),
[Iritani Hodge v2](https://arxiv.org/html/2604.10028v2),
[Voisin v3](https://arxiv.org/html/2004.09310v3),
[Orr v4](https://arxiv.org/html/1209.3653v4), and the
[Narasimhan–Nori original scan](https://repository.ias.ac.in/36463/1/36463.pdf).
The substantive readings used the pinned local extractions and page images.

The eight source PDF hashes below were recomputed and matched the register;
the AKMW hash is its successful cache lookup's recorded digest.

| Cached source key | PDF SHA-256 |
|---|---|
| arXiv:2307.13555 | `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b` |
| arXiv:2307.03696 | `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624` |
| arXiv:2604.10028 | `0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3` |
| arXiv:2508.05105 | `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64` |
| arXiv:2004.09310 | `8e15cfb5439d54aac3563fdd563bc7d96974abe27ef34f4a88bdcd993966ac6a` |
| arXiv:1209.3653 | `ee06d6d046ed402746a95b697d94213f2daaebb5662bc9d8ec57287f2ebd515e` |
| arXiv:1005.2131 | `68d98147d7d06de410a7dfd29c95efb0653554231f9e1b507591751d8e71fe64` |
| 10.1007/BF02837283 | `2710fad133c91c6e57f16b6e842d2db875a76b057e9551ccf9b2de8de303410b` |
| arXiv:math/9904135 | `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5` |

| Internal proof source | SHA-256 of reviewed bytes |
|---|---|
| `notes/cubic-threefolds-tasks/c1133-m1-upgrade-proof-packet.md` | `3d5c0899977f7a57b9c8cd74ac20b8b481453f926581e8506248a30123f8b75b` |
| `notes/2026-09-09-c1133-fixed-base-proof.md` | `fce9945908afffdcfbc3be2956573e1500e584d1ff6e78c9f5488f32e80fbea7` |
| `notes/2026-09-09-c1133-transport-vanishing-audit.md` | `0ec3cf3a03874c5e106206199abaef717bd814366091ca5f112580fb568101a2` |
| `papers/cubic-stabilization-m1/sections/02-qdm-marker.tex` | `c7d397df80241fc2b0c35b22bb796552a0cace08aa4a79bb03b5e1f6e269695c` |

**Vibe check:** the hard comparison interfaces survived; the result should be
presented as one complete proof with its geometric inputs visible.

go C1133 cubic-threefolds consolidate the audited A–D proof and finish input review

## Focused follow-up: removal of IK from the core A–D proof

This follow-up was requested only after the baseline report was completed
and committed as `e8ad70084`. It reviews Section 2 of
`notes/2026-09-10-c1133-transport-input-reduction.md`, plus the stated
finite-input reductions in Section 3. The baseline judgment above was made
without this replacement argument.

**Verdict: the P1 replacement is valid for the core A–D statements, with
their existing quantifiers.** I found no hidden mixed-bulk or lattice gap in
the replacement. The general projective-bundle operation theorem still
requires its own comparison input; this review authorizes no deletion of
IK from that stronger theorem's dependency record.

### Endpoint computation and transverse continuation

Behrend's product formula at (g,n)=(0,3) gives the small quantum tensor
product on the full supermodule. Because the second factor is P1, its
cohomology is even and its second homology contributes an independent
Novikov direction; there is no additional mixed homology class or Koszul
sign to suppress. The Euler and grading endomorphisms of the product are
the sums of those of its factors. Thus the small z-connection, pairing and
original lattice have the asserted tensor identification.

After a splitting coefficient extension, the P1 eigenvalues give two
scalar shifts. An equality between eigenvalues from opposite shifts would
make its independent Novikov parameter algebraic over the X parameter
field. Their resultant is therefore nonzero. Regular formal separation of
the P1 connection produces two rank-one lattices with regular inverses.
Tensoring with either adds scalar connection coefficients to an X block.
Its rank-two image line and modification are unchanged, and the residue
changes only by a scalar matrix. Its discriminant is unchanged.

The endpoint hypothesis needed next is exactly the finite one already used
in the baseline: the repeated even block is cyclic of rank two or three,
with rank-one complements. Each product cluster is therefore eligible for
the arbitrary-even-bulk cyclic persistence theorem. Every mixed class is
included among its formal derivatives. One is extending a separated
cluster over a formal germ of the product's own QDM; one is not asserting
that restriction to the tensor-product locus is a faithful coefficient
map. Rank-two residue rigidity then supplies its numerical value. This
does not invoke the projective-bundle reconstruction theorem.

At the initial product point each repeated cluster carries one copy of
the odd H3 representation, periodized as before. Equivariant continuation
on the fixed base preserves its multiplicities. The safe sum therefore
doubles H3. This proves exactly the endpoint input needed for B and
consequently C/D. Simple initial projective-space clusters remain rank one
and give the required zero endpoint.

### The full even potential on C times P1

I checked the proposed potential geometrically, independently of the
symbolic checker. For genus(C) at least one, a map from every component of
a connected genus-zero nodal tree to C is constant, and the constants
agree at the nodes. Thus the degree-(0,d) stable-map stack is
C times the stable-map stack for P1. The constant C direction has
deformation space T_C and no obstruction, because H1(O_tree)=0. Its
virtual class consequently has the ordinary [C] factor.

For even insertions 1,h,p,hp, a nonzero invariant must have exactly one
total h factor. Two such factors vanish on C. If the sole h occurs in an
h insertion, its P1 component is the unit and the primary string equation
kills the positive-degree invariant. If it occurs in hp, all remaining
nonunit insertions must be p. The P1 degree sum is then n, whereas its
virtual dimension is 2d+n-2, forcing d=1. The degree-one invariant with
three p insertions is one; the divisor equation gives the same value with
any further p insertions and also recovers the one-point hp term.
This proves the positive-degree term c q_f exp(b), with no higher powers
of c. Degree-zero maps give precisely the classical cubic terms. Hence,
up to irrelevant quadratic terms,

    F = v²c/2 + vab + cQ,    Q = q_f exp(b).

The horizontal Novikov parameter should remain an independent spectator
in the intrinsic coefficient field: its positive-degree coefficients vanish,
but it is not being specialized to zero or one. This minor clarification
was sent to the author and has been added to the replacement note.

The third derivatives give

    h²=0,    h*p=hp,    p²=Q(1+ch).

The Euler element after removing its unit scalar is
κh+2p-c hp, with κ=2-2g. With p'=(1-ch/2)p, direct multiplication gives

    (p')²=(1-ch)Q(1+ch)=Q,
    U=κh+2p'.

The projectors (1±p'/sqrt(Q))/2 have even rank two; on each block the
centered operator is κh. In genus one this operator is identically zero
on the entire even base. Thus the elliptic case is genuinely handled
without applying cyclic persistence to a noncyclic zero matrix. There is
no rank-three factor, and the rank-two selector requires nonzero N.

For genus greater than one, κ is nonzero and each block is cyclic of rank
two. At c=0 the tensor connection has the curve's zero residue
discriminant. The already audited rank-two Lax argument continues this
value through all even bulk coordinates. For C=P1, independent small
Novikov variables give four simple eigenvalues, so all four continued
clusters remain rank one. These arguments cover the full even base, which
equals the Hodge-fixed even base for C times P1.

### Ruled centers, dependency pruning, and limits

A projective-line bundle over C is birational to C times P1 by generic
triviality of its vector bundle. Surface factorization uses point centers
only, whose selectors are zero by the blowup formula. This proves ruled
surface vanishing without any projective-bundle QDM theorem and without
using the dimension-four birational invariant being constructed.

The remaining surface cases and weak-factorization argument are unchanged.
Therefore the core proof needs only the blowup comparison, its Hodge
refinement for B, the local persistence/residue lemmas, the product formula
at the small endpoint, and the elementary ruled calculation above. The
general IK comparison and its separate equivariance adaptation can be
removed from **this proof of A–D**. No all-member, same-family,
characteristic-zero or bounded-field-degree quantifier has been weakened.

The stated finite-input pruning is also logically sound. The eight
rational-control matrices do not prove positive rationality and need not
be premises once their geometric rationality is imported. A needs nonzero
H3 only for the four rank-three detections and nonzero discriminant for
the five rank-two detections. B needs the entire H3 representation, not
its numerical dimension. Exact labels and Hodge numbers support the finer
signature corollaries but are unnecessary for A–D. Exhaustion, every-member
quantum identification/deformation, and all-member positive rationality
remain geometric inputs. This is input pruning, not their verification.

### Follow-up read depth, checks and closeout

The complete replacement note and 100-line Python checker were read. The
checker was not rerun by this referee: its finite relations were checked
by the independent hand derivation above. In particular, its input
potential was not treated as an oracle. No new formal or computational
claim is being promoted by the referee report.

[Behrend, *The product formula for Gromov–Witten invariants*](https://arxiv.org/abs/alg-geom/9710014),
arXiv:alg-geom/9710014v1, was read **partially at primary text**: extraction
1–165 and 275–350, including formula (1), its super sign, and Theorem 1's
virtual-class statement. The proof of that theorem was not read in full.
Its PDF hash was recomputed as
`73d708012d4157f176a264940b80490f697f51aefd6a3913fbd7ccbbc1e0ed7d`.
The external full-text count remains **one**.

The checker and certificate bytes read have SHA-256
`d9081b7ac895d04b6c2dcadfb8698fb6ca56df0fca96eb99a12db1e4c82586a8`
and `4c42a309f763f78fd064f178ee703e65dce4c6b8eb73231a7e14133b9e14d196`,
respectively. The replacement note at the substantive Section 2/3 read,
before its spectator clarification and closeout updates, had SHA-256
`0bdd0bdd5f231f2c5a7a01347e1aebb2080541d95ddfac2135eabe1ac9a8b2cd`.
The stale present-tense comparison hash flagged in the baseline has also
been corrected by the author; I read the revised opening. The baseline
hash table records the original reviewed snapshot and is intentionally
retained as provenance.

The EJ+TT pass identifies why the elliptic calculation works: the precise
Euler weight minus one of hp cancels the mixed c-deformation after the
nilpotent change p to p'. This is the necessary mechanism, not an
accidental special-fiber eigenvalue check. The spectator clarification is
the only requested local refinement. **Mystery ledger update:** the
elliptic noncyclic case and all mixed-bulk/lattice gates of this replacement
are settled by the written argument; no genuine new mystery remains.
The independent-read limits on the geometric input package remain as in
the baseline report.

**Vibe check:** the narrower proof works; IK remains needed only for the
stronger general projective-bundle statements if those are retained.

go C1133 cubic-threefolds consolidate the reduced A–D proof with explicit inputs
