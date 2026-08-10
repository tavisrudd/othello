# C904 — Paper V proof spine and exposition map, early-review freeze

**Date:** 2026-08-09
**Lane:** `clebsch`
**Status:** revised after three sealed early reviews; Paper-II kill gate open
**Working title:** *The Golden Reconstruction Theorem*
**Working root:** `papers/clebsch-round-trip/`

## One-sentence theorem target

Relative to explicit paper-specific markings, the golden output packages of
Papers I--III determine one oriented balanced six-axis cubic; that cubic
recovers the six-axis frame, the golden conference switching class, and its
quadratic spectral algebra, and rebuilding the cubic returns the original
marked output package up to the declared switching, relabelling, and
orientation involutions.

“Output package” is deliberate.  The theorem does not claim to reconstruct
the full q11 code, the full matching quotient, or the global arithmetic cover.
Paper IV remains the logically independent lower branch of the series map.

## Concrete data types to freeze

Do not place the input and the reconstructed output in one omnibus groupoid.
Use two concrete presentations and prove their equivalence.

1. An **admissible oriented cubic shadow** is a five-dimensional rational
   vector space with an actual cubic generator (Z), not a pre-supplied frame
   or conference operator.  Admissibility says that its singular scheme is
   exactly six reduced ordinary nodes in projective-frame position and that,
   after the intrinsic normalization lemma, its nonzero triangle
   coefficients admit an edge lift whose triangle and Pfaffian shadows are
   proportional.  The six-set (X(Z)) and the conference operator are outputs.
   Relabelling acts through the recovered frame; orientation reversal negates
   the generator.
2. An **oriented golden conference package** is a symmetric zero-diagonal
   sign matrix (C) on six labelled axes with (C^2=5I), modulo diagonal
   switching, together with the choice between ([C]) and ([-C]).  Relabelling
   and switching are equivalences; orientation reversal is the separate
   involution (C\mapsto-C).

The forward map sends (C) to its triangle products.  The inverse recovers the
node frame, normalizes the coefficient presentation, and reconstructs the
switching class from those products.  C809's translation-invariance theorem
then turns the triangle/Pfaffian comparison into (C^2=\lambda I); the sign
locus fixes (\lambda=5).  Thus the conference identity is a conclusion rather
than part of cubic admissibility.  A separate normalization lemma is
load-bearing because the nodes alone do not choose affine coordinates or
scale.

For the spectral output, distinguish the unpointed algebra
(\mathbf Q[C]=\mathbf Q[-C]) from the pointed embedding
(t\mapsto(I+C)/2), which changes under orientation reversal.

## Proposed principal theorem

### A. Marked transport

Each of the first three papers supplies a functor into the common groupoid.

1. **Paper I.**  Its stable theorem `thm:orientation-two-graph` gives
   (c_{ijk}=B_{ij}B_{jk}B_{ki}), the inverse gauge reconstruction, pair
   balance, and (B^2=5I).  Its stable corollary
   `cor:orientation-cubic-geometry` recovers the unlabelled six-axis frame
   from the six ordinary nodes.
2. **Paper II.**  Its stable theorem `thm:balanced-cubic` recovers the
   (H_3) sheet pair and its first nonzero signed tensor (mu_3), with the
   outer coset negating (mu_3).  The missing theorem is a commuting
   transport from the oriented (H_3) matching-sheet package to the
   six-axis triangle-holonomy package.  For a marked base matching, its six
   pairs form the natural degree-six (A_5)-set.  Their augmentation is the
   unique five-dimensional constituent of the restricted Paper-II output.
   The bridge must construct the equivariant intertwiner and compare the
   pulled-back cubic coefficient by coefficient.  This comparison is
   essential: invariant cubics on the five-dimensional (A_5)-module form a
   two-dimensional space.  It must also prove that sheet exchange maps to
   cubic orientation reversal.  An abstract bijection of two-element torsors
   after choosing basepoints is insufficient.
3. **Paper III.**  Its stable proposition `thm:orientation-source` supplies
   ([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}) relative to a marked bridge
   datum.  The normalized chart lift and the cross-identification of the
   five-labelled systems remain hypotheses.  The selected component does not
   recover them.

After these transports, the three target objects must be isomorphic by an
explicit coordinated relabelling, with the orientation involutions commuting.
The proof may normalize one common representative, but it must then prove
independence from switchings and equivariance under relabelling.

### B. Reconstruction from the cubic

Starting from an oriented six-axis cubic (Z):

1. its six ordinary singular points recover the projective six-axis frame,
   and the normalization lemma recovers the coefficient presentation;
2. the four-point two-graph identities recover the switching class of (C)
   from the triangle coefficients;
3. the pair-balance identities give (C^2=5I), while the independent
   triangle/Pfaffian criterion explains why the same cubic recognizes the
   conference class intrinsically on the sign locus;
4. (E=\mathbf Q[t]/(t^2-t-1)\to\mathbf Q[C]),
   (t\mapsto(I+C)/2), recovers the quadratic spectral algebra and its
   involution;
5. rebuilding triangle holonomy from ([C]) returns (Z), with the chosen
   outer orientation determining its sign.

The determinant-line norm identity

\[
 \det[D_x,C]=-8000N_{E/\mathbf Q}(\det B_x),\qquad
 \operatorname{Pf}[D_x,C]=4Z(x)
\]

is a mechanism corollary, not an additional recognition hypothesis.  Its sign
and normalization must be reconciled against the current Paper-III convention
before it appears in the theorem.

### C. Round-trip statement

For each paper (r\in\{\mathrm I,\mathrm{II},\mathrm{III}\}), write
(F_r) for marked transport to the common target and (R_r) for the inverse
that rebuilds exactly the paper-specific golden output retained in the
theorem.  The claim is

\[
 R_rF_r\simeq\operatorname{id},\qquad
 F_rR_r\simeq\operatorname{id}
\]

in the stated groupoids.  The proof must print what (R_r) returns.  It is not
enough to recover only the labels that were supplied as marking inputs.

The current corpus proves the Paper-I reconstruction and the common
six-axis inverse.  Paper III returns its marked conference source but not the
chart lift or global cover.  Paper II's (F_{\mathrm{II}}), and therefore
both of its composites, are the earliest open proof obligations.  Its retained
output must be named explicitly: either the full signed tensor package, if an
inverse is proved, or only the marked five-dimensional golden residue.

## Proof spine under review

1. Define the two concrete data types, their equivalences, and orientation
   involutions.
2. Give the Paper-I transport as the model case, including its inverse.
3. Construct and prove the Paper-II matching-sheet transport.
4. State the Paper-III relative transport and its noncanonical inputs.
5. Prove the three transports agree on one normalized representative and
   are equivariant under switching, relabelling, and every stabilizer.
6. Recover the six-axis frame and coefficient normalization from the nodal
   cubic.
7. Recover ([C]), prove (C^2=5I), and identify (mathbf Q[C]).
8. Verify every forward/inverse composite at the exact output level.
9. State the norm/Pfaffian and conductor-two consequences with their integral
   boundary.

The earliest unsupported implication is Step 3.  Drafting the main theorem is
blocked until that step is either proved or the theorem is narrowed to Papers
I and III.  A two-paper theorem may still be publishable, but it would no
longer justify “three reconstructions” or the present Paper-V role.

## Exposition map under review

Target length: 12--18 pages, with the theorem on page 2.

| pages | section | job |
|---:|---|---|
| 1--2 | Introduction, object table, theorem | define every retained output and marking; state the exact theorem and honest Paper-IV boundary |
| 2--3 | Common model and scope | display one conference matrix and cubic; separate input/output data types and involutions |
| 3--7 | Marked transports | import Papers I and III briefly; give Paper II and its exact intertwiner most of the space |
| 7--10 | One common inverse | nodes recover normalized axes; holonomy recovers switching; conference and spectral recognition follow |
| 10--13 | Exact round trips | print a source/output table and prove both composites at the retained-output level |
| 13--14 | Corollaries and boundaries | norm/Pfaffian mechanism; rational versus integral boundary; Paper IV remains separate |
| 14--16 | Precedence, verification, conclusion | claim-specific audit; concise evidence map; qualify “lossless” by its exact object |

The series diagram belongs after the principal theorem, not on the title page.
A second proof-spine diagram may be justified only if it shows the two
directions of the round trip more clearly than the series map.  The two figures
must not duplicate one another.

## Early-review questions

1. Is the common groupoid defined at the correct categorical level, or does it
   silently identify orientation reversal with switching or relabelling?
2. Does any proposed inverse return only marking data already supplied?
3. Can the Paper-II transport be a substantive equivariant theorem, or is it
   necessarily a basepoint-dependent identification of two abstract signs?
4. Is the singular-frame step used causally, or merely repeated from Paper I?
5. Is C809's Pfaffian recognition genuinely needed in the round trip, and if
   not, what conceptual job earns its inclusion?
6. Does the exposition map keep the new theorem dominant over inherited
   facts, citations, and verification detail?
7. Which page or section first risks making Paper IV appear part of the cubic
   equivalence?
8. What is the strongest headline justified if the Paper-II commuting diagram
   fails?

## Literature flags before prose

The publication audit must cover, at minimum:

- classical switching/two-graph reconstruction from triangle products;
- principal-minor and nodal-cubic reconstruction of the six-axis frame;
- symmetric conference matrices of order six and their switching class;
- Macaulay inverse systems and self-associated configurations around the
  Paper-II cubic;
- classical Clebsch/Joubert/Segre identifications that may already supply a
  Rosetta map; and
- reconstruction/equivalence language for invariants, to avoid claiming a
  categorical inverse stronger than the maps prove.

No novelty sentence is licensed by this packet.  The owning claim--proof--
novelty ledger will be created before manuscript positioning.
