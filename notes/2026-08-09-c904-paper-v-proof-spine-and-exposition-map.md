# C904 — Paper V proof spine and exposition map, early-review freeze

**Date:** 2026-08-09
**Lane:** `clebsch`
**Status:** pre-draft review packet; no manuscript claim yet
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

## Objects and equivalences to freeze

The common target should be a small marked groupoid, not an equality of three
unrelated coordinate polynomials.  An object is

\[
 (X,[C],Z,\epsilon),
\]

where (X) is a six-element projective frame, ([C]) is a switching class of
symmetric zero-diagonal sign operators on (X), (C^2=5I), (Z) is the
triangle-holonomy cubic with its chosen generator, and (epsilon) records the
outer orientation.  Morphisms are coordinated relabellings and switchings.
Orientation reversal sends ((C,Z,epsilon)) to
((-C,-Z,-epsilon)); forgetting (epsilon) retains the embedded quadratic
algebra (mathbf Q[C]=mathbf Q[-C]).

This definition still needs a referee-level check that (C\mapsto-C) is best
treated as an involution of objects rather than a morphism in the oriented
groupoid.

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
   six-axis triangle-holonomy package.  It must construct the six axes from
   the recovered (A_5)-stabilizer, identify the two outer characters, and
   prove that sheet exchange maps to cubic orientation reversal.  An abstract
   bijection of two-element torsors after choosing basepoints is insufficient.
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

Starting from a common target cubic (Z):

1. its six ordinary singular points recover the projective six-axis frame;
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
both of its composites, are the earliest open proof obligations.

## Proof spine under review

1. Define the common marked groupoid and all three involutions.
2. Give the Paper-I transport as the model case, including its inverse.
3. Construct and prove the Paper-II matching-sheet transport.
4. State the Paper-III relative transport and its noncanonical inputs.
5. Prove the three transports agree on one normalized representative and
   descend equivariantly to the groupoid.
6. Recover the six-axis frame from the nodal cubic.
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
| 1--2 | Introduction and principal theorem | state the lossless common-output theorem, markings, honest Paper-IV boundary, and one causal paragraph |
| 2--3 | The six-axis model case | display one conference matrix, triangle cubic, orientation involution, and the groupoid conventions |
| 3--6 | Three marked transports | Paper I in miniature; expand the new Paper-II commuting diagram; state Paper III relative to its bridge datum |
| 6--10 | Reconstruction | nodes recover axes; triangle holonomy recovers switching; balance and shadow recognition recover (C^2=5I); spectral algebra follows |
| 10--12 | The commuting round trips | print each returned output and prove both composites; separate marking inputs from reconstructed data |
| 12--14 | Norm, conductor, and boundaries | determinant-line norm and conductor-two corollaries; no integral lattice identification without a map |
| 14--16 | Related work, verification, conclusion | claim-specific precedence; concise evidence map; end with the common shadow being lossless |

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
