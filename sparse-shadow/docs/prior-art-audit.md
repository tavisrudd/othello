# Prior-art audit: canonicalization and reconstruction tools

Audit date: 2026-08-25. This was a bounded positioning search, not a novelty or
priority audit. Three papers were read in relevant sections from cached full
texts; five official software/documentation surfaces were read in relevant
sections. No absence-of-prior-work claim is made.

## Result

The canonicalization part of `sparse-shadow` has substantial prior art. The
individualization/refinement architecture is standard; canonical transporters,
automorphism groups, stabilizers, arbitrary permutation actions, incidence
structures, linear codes, and semilinear projective actions all have mature
implementations or published algorithms. The project-specific contribution is
therefore the typed Clebsch adapters, reconstruction maps, explicit residual
fibres/torsors, frozen round trips, and a uniform artifact surface—not generic
canonization itself.

The trust target also has a direct predecessor. Bankovic--Drecun--Maric's
`isocert`/`morphi` exports canonical-labeling proofs and checks them with a
simpler independent checker whose abstract specification and soundness are
formalized in Isabelle/HOL. C968 should treat that proof system as its baseline,
not describe same-implementation recomputation as independent certification.

## Closest systems

| source | overlap | boundary relative to C968 | read depth |
|---|---|---|---|
| McKay--Piperno, *Practical graph isomorphism, II* | refinement/individualization, canonical labels, automorphism pruning, nauty/Traces | graph/digraph canonization rather than paper-specific reconstruction and ambiguity | partial: arXiv v1 abstract and introduction pp. 1--3; cache `arXiv:1301.1493`, SHA-256 `2173fcd10d99c269eec4d28d2089887452eb972456c52a1b961a2bf186194029` |
| Bankovic--Drecun--Maric, *A proof system for graph (non)-isomorphism verification* | proof-producing McKay--Piperno canonization and independent checking | strongest trust-surface comparator; graph-specific proof language | partial: arXiv version, introduction, section 4 opening, conclusion; cache `arXiv:2112.14303`, SHA-256 `c6a1ae32427931b54535733646d8c9f9cc4760e9b2f377d9ea5784b90ccd6853` |
| Feulner, *Canonical Forms and Automorphisms in the Projective Space* | canonical form, transporter, and stabilizer for sequences of subspace multisets under general semilinear action | closest action-level precedent for projective/code adapters; no Clebsch reconstruction semantics | partial: arXiv v1 abstract and introduction through the canonicalization contract; cache `arXiv:1305.1193`, SHA-256 `8c1ac455ca62fb038706b7aa1ef440f203e0a446282decc6167ff42471433f0e` |
| nauty/Traces official site | production graph/digraph canonical labels and automorphism groups; benchmark generators | opaque external engine is a baseline only under C968's explicit-core rule | partial: current home and individualization/refinement introduction, version 2.9.3, accessed 2026-08-25, <https://pallini.di.uniroma1.it/> |
| bliss official documentation | colored directed/undirected canonical forms, canonical labeling witnesses, automorphism generators | canonical forms can vary with version/options; no proof certificate or reconstruction layer | partial: overview and definitions pages, accessed 2026-08-25, <https://users.aalto.fi/~tjunttil/bliss/> |
| GAP Vole official manual | canonical images and stabilizers under arbitrary permutation groups; graph backtracking in Rust | closest general action engine; lower-level interfaces are documented as evolving | partial: chapter 1 sections 1.1--1.3, accessed 2026-08-25, <https://peal.github.io/vole/doc/chap1.html> |
| SageMath official incidence/code documentation | incidence canonical labels and automorphism groups; semilinear code canonical forms, transporters, and stabilizer generators | likely independent baseline for Paper I/IV fixtures; not a certificate checker | partial: `IncidenceStructure` API and coding manual chapter 14.1, release 10.8 docs accessed 2026-08-25, <https://doc.sagemath.org/html/en/reference/graphs/sage/combinat/designs/incidence_structures.html> |
| GAP FinInG official repository/manual | finite projective/incidence geometries, collineation groups, morphisms and intertwiners | reconstruction substrate and cross-check source, not a general canonical-certificate engine | partial: official overview and geometry-morphism documentation, accessed 2026-08-25, <https://gap-packages.github.io/FinInG/> |

## Design consequences

1. Keep C968's canonicalizer explicit, but name McKay--Piperno, nauty/Traces,
   bliss, and Vole as algorithmic/baseline comparators.
2. Model a transporter and stabilizer as first-class outputs. Feulner shows that
   this is the natural projective-action contract, not an optional diagnostic.
3. Add semilinear/projective actions only with exact field/action metadata;
   Sage `codecan` and Feulner are the reference checks for those adapters.
4. Keep the first-gate reference search structurally separate from the producer,
   and evolve its exhaustive recomputation into a compact proof-rule checker
   before calling the final certificates proof-carrying. The `isocert`
   rule/checker split is the minimum comparator.
5. Benchmark whole canonicalization workloads against a named version/options
   tuple. bliss explicitly warns that its canonical form depends on both.

## Implemented mapping

| prior-art consequence | C968 implementation state | evidence boundary |
|---|---|---|
| explicit individualization/refinement rather than opaque FFI | implemented for Papers I and IV | Paper IV exhausts 3,901 nodes and 2,184 least leaves; its independent checker rederives the same leaf, trace, full group, and counters |
| transporter and stabilizer as first-class outputs | implemented for Papers I and IV | canonical wrapper v2 emits the input transporter, full-group generators/orbits, and point stabilizers; wrapper replay recomputes them from the certified group |
| exact projective/semilinear action metadata | executable for Paper IV; schema-gated for II, III, V | Paper IV matches its canonical weighted scheme to an exact symmetric-square GF(13) model and reconstructs the plane, conic, polarity, and marking torsor |
| proof producer/checker separation comparable to `isocert` | implemented for Papers I and IV | the two Paper-IV searches use fixed-cell and ordered-boundary representations and reject result, trace, automorphism, counter, wrapper, equivalence, and reconstruction corruption |
| named external canonical-labeling baseline | implemented for Papers I and IV with nauty; bliss reserved | nauty 2.9.3 matches raw/native-canonical digests and orders 120/6/2184; no cross-engine timing claim is made |

This mapping records engineering influence, not novelty. In particular, the
new point-stabilizer surface follows the Feulner/Vole action contract, while the
full-artifact verifier and corruption suite follow the trust separation exposed
most directly by `isocert`.

## Search record and limits

Queries covered combinations of “canonical labeling,” “automorphism group,”
“stabilizer,” “arbitrary permutation action,” “incidence structure,” “linear
code,” “projective space,” and “independent certificate/checker.” Sources were
restricted to papers, author/project sites, and official package manuals.
MathSciNet, zbMATH, citation-graph closure, and general theorem-prover search
were not covered because the deliverable does not make a novelty or priority
negative. The bounded result cannot support “first,” “unique,” or “no prior
tool” language.
