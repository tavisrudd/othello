# Cross-paper agenda — rigid local incidence patterns and global transport

**Date:** 2026-07-15
**Scope:** `arcs`, `clebsch`, `repaircodes`, and `baer`

## Unifying question

When an algebraic code invariant records a complete incidence pattern rather than only its
cardinality, what hypotheses force that pattern to be rigid locally and transportable globally?

The four current papers supply complementary test cases: prescribed-hole coverage, the Clebsch
deep-hole locus, complete repair hypergraphs, and Frobenius-pair extension/repair structures. The
point of the agenda is not to merge their manuscripts, but to identify reusable theorems that can
move between them.

## Structural questions

1. Is there a common defect identity of the form “ambient capacity minus legal locus equals visible
   collisions plus invisible obstructions” encompassing prescribed-hole coverage, deep-hole loci,
   repair hypergraphs, and Frobenius-pair extensions?
2. Can extension loci and repair ports be treated uniformly as circuit-avoidance hypergraphs of
   representable matroids?
3. When does containment of all legal or all obstructed extensions in a low-degree algebraic locus
   force a large automorphism group? The Clebsch degree-at-most-three rigidity theorem is the first
   exact test case.
4. Can equality and near-equality in the defect identities be classified by coherent
   configurations, replacing case censuses by invariant structure?
5. Which computer-assisted classifications admit invariant-theoretic replacements? The Clebsch
   `A_5` orbit proof is a model: retain the finite certificate while moving the explanatory burden
   to character and subgroup data.

## Transfer and construction questions

6. Can a finite exceptional configuration serve as an inner seed whose entire extension or repair
   complex—not merely its cardinality or minimum distance—survives concatenation?
7. Is there a transfer theorem for orbit-valued extension structures analogous to the complete
   repair-hypergraph theorem?
8. Can the Clebsch extension complex, the prescribed-conic syndrome locus, or the Frobenius
   alternate-repair complex be copied blockwise into an asymptotically good family?
9. More broadly, which exact finite incidence structures persist unchanged inside unbounded code
   families, and which invariants certify that persistence?

## Reusable formal spine

A useful shared formal layer would expose projective-system circuits, circuit-avoidance extension
hypergraphs, orbit carriers, defect decompositions, and bounded-support transfer. Individual paper
developments should import this layer only after the mathematical interfaces stabilize; the agenda
does not license a cross-lane refactor by itself.

## Highest-value next theorem

The most concrete bridge is an orbit-valued transfer statement: give sufficient hypotheses under
which a bounded inner code's complete legal-extension or repair hypergraph, together with its
automorphism-orbit labels, embeds faithfully in every block of a concatenated family. This would
connect the local rigidity results of `arcs`/`clebsch` to the global persistence mechanism of
`repaircodes`, with the Frobenius alternate-repair complex as a second nontrivial seed.
