# C1015 — global obstruction beyond the six-local matching test

**Lane:** `relconic`

**Status:** Queued; normalized-coordinate human proof landed in the C1003
closeout, invariant/global extension open. No manuscript, summary, mirror,
formal, release, or Ergodis source edits are authorized.

## Starting point

C1003 classified the four simple `MATCH(9,4,1)` designs over arbitrary
fields. Exactly one odd-characteristic representative passes the C1002/C1008
test on every six-set. Seven concurrence equations admit the human reduction

\[
-\frac{2(r-1)^2}{r^2}=0,
\]

where the frame arc inequalities give `r!=0,1`; this also explains the
characteristic-two degeneration. Exact elimination independently yields
`x_8^2(x_8-1)^2`. The replay is
`notes/c1003_match9_rank_three.py`; the publication and literature context is
`notes/2026-08-30-c1003-matching-design-publication-routing.md`.

## Objective

Make the ratio defect projectively intrinsic and determine the strongest
reusable theorem it supports. The preferred outcome is a global compatibility
or holonomy invariant forced by rank-three chord concurrency and strictly
refining all six-local tests.

## Literature correction and priority ceiling

Nagy, _Embeddings of Ree unitals in a projective plane over a field_, proves
that the Ree unital `R(3)` embeds in `PG(2,K)` if and only if `F_8` is a
subfield of `K`, and then the embedding is unique and contained in an
order-eight subplane. In the regular-hyperoval model its 63 dual points are
exactly the 63 perfect-matching centers. Its 28 dual lines are exactly the 28
one-factorizations of `K_10`, each collecting nine matching centers.

The C1003 replay now verifies this intrinsically: the regular matching design
has exactly 28 one-factorizations, each block occurs in four, and each pair of
factorizations shares exactly one block, giving a `2-(28,4,1)` design. The
nonhyperoval class has only one one-factorization. The identification of the
regular incidence design with `R(3)` uses Nagy's external-point/external-line
model; the count and intersection parameters are exact internal computation.

Our realization hypothesis does not assume those nine-point sets collinear;
it assumes only that each perfect matching is realized by concurrent secants.
Thus the first priority question is now the **Ree bridge**:

> Does every rank-three realization of the regular `MATCH(10,5,1)` design, or
> either of its nine-point deletions, force the nine centers in each canonical
> one-factorization to be collinear?

If yes, Nagy's theorem replaces the entire regular-class coordinate
classification and adds uniqueness, admissibility, and subplane containment.
The publishable contribution would be the automatic completion from secant
concurrences to the Ree-unital line structure, not the already classical `F_8`
boundary. Nagy's odd-characteristic factor `2` and characteristic-two cubic
`v^3+v^2+1` closely parallel the C1003 calculation; checking whether the seven
blocks are a literal super O'Nan shadow is mandatory before a novelty claim.

## Work programme

1. Recast the landed normalized substitution chain as a frame-free cross-
   ratio, bracket syzygy, Menelaus/Ceva configuration, or projective monodromy
   contradiction.
2. Construct the 28 canonical one-factorizations of the regular ten-point
   design and test, symbolically and synthetically, whether their nine center
   points are forced collinear. Identify the smallest concurrence subset that
   forces one such line, then use automorphisms to propagate it.
3. Determine the actual carrier of the obstruction: seven displayed blocks,
   their vertex/block incidence shadow, or a smaller invariant subdiagram.
4. Test relabellings and deletions to decide whether the certificate is a
   nine-point phenomenon or the first instance of a uniform seven-/eight-/
   nine-local compatibility law.
5. Formulate a characteristic-sensitive invariant whose odd-characteristic
   specialization forces the contradiction and whose characteristic-two
   degeneration explains the `F_8` survivor.
6. Audit primary literature on representations/embeddings of abstract ovals,
   abstract hyperovals, hyperfactorizations, and `pg(5,7,3)` for such global
   compatibility laws, following `notes/literature-audit-conventions.md`.
7. Use Ergodis only through its control interface, if useful, to rank or
   compress candidate identities. Record control/provenance improvements but
   do not edit Ergodis source.

## Success gates

- **Base — landed:** a human derivation of `-2(r-1)^2/r^2=0` from the seven
  displayed concurrences, with every division and characteristic exception
  explicit.
- **Strong:** an invariant statement independent of the chosen projective
  frame, plus a replayable bounded-shadow recognizer; preferably the Ree bridge
  giving all 28 one-factorization lines from matching concurrences.
- **Priority-judo:** a general global compatibility theorem for rank-three
  matching-design realizations from which the nine-point exclusion and a
  classical abstract-oval fact both follow, or which answers a representation
  question absent from the subsequent literature.

## Publication decision after proof

Prefer the arcs equality appendix if the result remains a nine-point boundary
lemma. Reassess a standalone representation note only if the invariant is
uniform in size, excludes an infinite family, or yields a structural
classification beyond the four order-eight pointed classes.
