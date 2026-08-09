# C897 Paper III focused regrade — Hamza Si Kaddour

**Date:** 2026-08-09

**Verdict:** `PASS`

## Sealed scope and artifact

I read the assigned dossier extracts and then audited PDF pages 17--20 before
opening the permitted supplement.  The standalone mirror was clean at commit
`9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`, and the audited PDF had SHA-256
`a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`, matching
the manifest.  After freezing the PDF verdict, I inspected only
`sections/05-golden-operator.tex`.  The source inspection did not change the
verdict.

## Strongest theorem package on this surface

For a two-graph \(\tau\) on a labelled set of at least seven vertices, the
family \(\mathcal A(\tau)\) of four-sets whose four triple values agree
determines \(\tau\) up to complement, and six vertices do not suffice.  For a
Seidel conference signing, the determinant-\((-3)\) fourth-order fibre is
exactly this aligned family, so it determines the signing up to diagonal
switching and global negation.  Fourth-order indicator queries alone admit a
fixed quadratic reconstruction family and an adaptive
\(\binom n2+O(n)\)-query decoder; neither claim is presented as an improvement
over algorithms whose oracle returns full principal-minor values.

In the vocabulary of the reconstruction literature, the input is equality of
the labelled four-local up-to-complement observable within the two-graph
parity class, and the output is equality of the labelled two-graphs up to one
global complement.  It is not reconstruction of an arbitrary 3-uniform
hypergraph from its induced hypergraphs, nor reconstruction of an ordinary
graph from local graph-isomorphism types.

## Causal proof audit

1. Rooting a two-graph produces a graph representative, and the two-graph
   equation identifies an aligned four-set through the root with a clique or
   independent triple.  The Ramsey equality \(R(3,3)=6\) therefore supplies an
   aligned anchor on every seven-set.

2. Relative to an aligned four-set, the four three-anchor tests determine each
   normalized outside cut except for three balanced cuts.  Formula (5.2) and
   the two displayed finite tables resolve all remaining cases except the
   apparent interchange of two distinct balanced cuts.  With three outside
   vertices, the pairwise constraints rule out any such interchange.  This
   proves seven-point faithfulness.  As an independent finite check, exhaustive
   enumeration of rooted graph representatives confirmed that every
   seven-point aligned-family fibre is exactly one complement pair; the
   displayed six-point pair has the same aligned family and is not a
   complement pair.

3. The complement convention propagates from one seven-set to every adjacent
   seven-set: their six-vertex intersection contains triples, and two
   restrictions agreeing there cannot use opposite complement conventions.
   This is the earliest convention-propagation step, and it is justified.

4. After fixing one seven-point reconstruction, a new point is first attached
   to six points with known restriction.  Of the thirty-five four-sets on the
   resulting seven-set, fifteen avoid the new point and are already known;
   the twenty containing it are the new tests and determine its five rooted
   values.  Thus the stated six-known-point count is correct.

5. For each further old vertex, the two hypothetical rooted values give two
   valid seven-point restrictions.  They agree on the five anchor vertices,
   so they are not complements; seven-point faithfulness forces their aligned
   families to differ.  Since changing that rooted value affects only tests
   containing both the new and old vertices, one test through those two
   vertices and two anchors distinguishes them.  The claimed one-test step is
   therefore valid, including its adaptivity.

## Focused findings

- **Holtz--Sturmfels scope:** Correct.  The paper confines the comparison to
  principal-minor ambiguity under the cited strict nondegeneracy hypothesis.
  It does not use that theorem as a premise for aligned-design faithfulness or
  claim that its query model is the same.

- **Unconditional Seidel step:** Correct.  For a Seidel matrix, an order-three
  principal minor is twice its triangle sign.  All triangle signs determine
  the switching class directly, with no Holtz--Sturmfels nondegeneracy
  assumption.  This elementary step is the one actually relevant to the
  comparison.

- **Seven-point distinguishing query:** Correct.  The two candidates are
  distinct and not complementary on the chosen seven-set, so the theorem
  supplies a distinguishing alignment bit; all possible differing tests must
  contain the two vertices in question.  Evaluating the candidates before
  choosing the test makes the adaptive selection legitimate.

- **Six-known-point count:** Correct.  The source and PDF consistently use six
  known points, twenty new four-set tests containing the attached point, and
  fifteen already-known tests avoiding it.

- **Reconstruction boundary:** Correct and explicit.  Fourth-order data are
  invariant under global negation, so the theorem stops at complement for
  two-graphs and at switching plus global negation for Seidel signings.  A
  calibrated triangle product is expressly additional data that selects an
  orientation; it is not claimed to be recovered from the fourth-order
  indicator.

The six-point witness establishes sharpness for this aligned-family
observable.  The comparison paragraph also correctly separates it from the
ordinary-graph four-local theorem and from the eventual five-local result for
arbitrary 3-uniform hypergraphs; it does not import a six-point failure from
either source.

## Contribution and publication bar

Relative to the packet, the contribution is a sharp four-local
reconstruction-up-to-complement theorem for the constrained two-graph parity
class, together with an explicit fixed decoder and a near-counting-order
adaptive decoder for the weaker one-bit fourth-order oracle.

Assuming the rest of the article's proofs are sound, this section meets the
stated *Advances in Mathematics* significance and cross-field readability bar:
the observable, equivalence relation, comparison oracle, exceptional order,
and reconstruction limit are all stated locally and distinguished from the
neighboring literature.

## Unresolved findings

None on the assigned surface.
