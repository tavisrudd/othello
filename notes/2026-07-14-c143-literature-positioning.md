# C143 literature positioning — equivariant repair and orbit replacement

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-14
**Status:** targeted primary-source search complete; historical-first claims remain withheld pending
database and citation-network review

## Scope and conclusion

The search covered three claims:

1. the main arbitrary-deletion theorem for Frobenius-invariant ten-arcs;
2. the profile-minimized multiplicity bound recorded as D-AOR1; and
3. the orbit-replacement reconfiguration graph recorded as D-AOR2.

No exact predecessor was located for an orbit-valued extension count or an arbitrary selected-orbit
deletion-and-different-replacement theorem for plane arcs invariant under the quadratic field
Frobenius.  The strongest defensible publication language is:

> To our knowledge, previous work does not give an orbit-valued extension count, nor an
> arbitrary-orbit deletion-and-replacement theorem, for arcs invariant under the quadratic field
> Frobenius.

This was a broad targeted web search of primary papers, not a complete MathSciNet/zbMATH and
citation-tree audit.  Do not make a historical-first claim from it.

## Main theorem: closest predecessors

The closest geometric predecessor is Baker and Wantz, [*An arc partition of the Hughes plane using
a field-theoretic model*](https://doi.org/10.2140/iig.2005.2.83), *Innovations in Incidence
Geometry* 2 (2005), 83–92 ([primary PDF](https://msp.org/iig/2005/2-1/iig-v2-n1-p04-s.pdf)).
Lemma 3.1 (p. 89) transfers incidence for Frobenius-invariant point sets; the proof of Proposition
3.3 (pp. 90–91) enlarges an invariant arc by a point together with its Frobenius mate.  This is
genuine precedence for the paired-extension maneuver, but it supplies no legal-orbit count,
arbitrary deletion quantifier, different-replacement condition, or multiplicity theorem.

Dye, [*Hexagons, conics, A₅ and PSL₂(K)*](https://doi.org/10.1112/jlms/s2-44.2.270),
*Journal of the London Mathematical Society* 44 (1991), 270–286, is the nearest special-family
completion predecessor. Theorem 8 (pp. 283–284) parametrizes the exact completion locus for Clebsch
hexagons through a fixed vertex. Proposition 1 and Theorem 7 (pp. 282–283) define a five-valent graph
on Clebsch hexagons by shared associated triangles. Neither result uses quadratic field-Frobenius
orbit replacement, but both rule out broader claims of first exact symmetric-arc completion
geometry or first graph on finite-projective configuration objects.

Other nearby strands are:

- Martin, [*On arcs in a finite projective plane*](https://doi.org/10.4153/CJM-1967-030-2),
  *Canadian Journal of Mathematics* 19 (1967), 376–393
  ([primary PDF](https://www.cambridge.org/core/services/aop-cambridge-core/content/view/095C79C6CB4DAF41815B7330805ACA6A/S0008414X00054389a.pdf/on-arcs-in-a-finite-projective-plane.pdf)):
  classical secant/tangent incidence counts, especially Section 2, but no Frobenius-orbit quotient.
- Lisoněk, Marcugini, and Pambianco,
  [*Constructions of small complete arcs with prescribed symmetry*](https://doi.org/10.11575/CDM.V3I1.61979),
  *Contributions to Discrete Mathematics* 3(1) (2008), 14–19
  ([primary PDF](https://cdm.ucalgary.ca/article/download/61979/46677/176938)):
  extension of symmetric seeds by whole stabilizer-group orbits, but no quadratic Frobenius
  constraint or universal repair theorem.
- Marcugini, Milani, and Pambianco,
  [*Complete arcs in PG(2,25)*](https://doi.org/10.1016/j.disc.2005.11.094), *Discrete
  Mathematics* 307 (2007), 739–747: the smallest ordinary complete arc in `PG(2,25)` has size 12.
  Thus ordinary eight-arc extendability is unsurprising; the new content is simultaneous
  conjugate-pair legality, multiplicity, and exclusion of the erased pair.
- Alderson, [*Extending MDS codes*](https://doi.org/10.1007/s00026-005-0245-7), *Annals of
  Combinatorics* 9 (2005), 125–135
  ([author PDF](https://www.unb.ca/faculty-staff/directory/_resources/pdf/sase/alderson/mds-codes.pdf)):
  one-coordinate extension and uniqueness in a near-maximal regime, without paired semilinear
  constraints.

The safe coding translation is **equivariant puncture-and-re-extend** or **equivariant coordinate
replacement**.  Unqualified “erasure repair” risks confusion with reconstructing the same lost
symbol in a fixed distributed-storage code.

Ueberberg's 1997 “Frobenius collineation” terminology is not direct precedence: it denotes an
order-three collineation induced from `GF(q^3)/GF(q)`, not the quadratic field-conjugation
involution.  Use **quadratic field-Frobenius involution** when ambiguity matters.

## D-AOR1: profile-minimized multiplicity

No source located the `E(N-M)` Baer-carrier count, its five-profile minimization, or a deletion-
robust count for arbitrary Frobenius-stable plane arcs.  The closest conventional background is:

- Ball and Lavrauw, [*Arcs in finite projective spaces*](https://arxiv.org/pdf/1908.10772):
  arc–linear-MDS correspondence (Theorem 17, p. 7), large-arc unique completion (Theorem 40,
  pp. 18–19), and ordinary secant-coverage arguments (pp. 24–25).
- Alabdullah and Hirschfeld,
  [*A new lower bound for the smallest complete `(k,n)`-arc in `PG(2,q)`*](https://doi.org/10.1007/s10623-018-00592-8),
  *Designs, Codes and Cryptography* 87 (2019): secant-incidence identities (Lemma 1.6) and a
  coverage-count lower bound (Theorem 2.1).
- Wu, Ding, and Chen,
  [*When Does the Extended Code of an MDS Code Remain MDS?*](https://arxiv.org/pdf/2312.05534),
  *IEEE Transactions on Information Theory* 71 (2025): the one-coordinate extension/deep-hole
  criterion (Theorem 6, p. 7), without candidate counts or paired extensions.
- Pavese and Santonastaso,
  [*On pseudo-arcs from normal rational curve and additive MDS codes*](https://arxiv.org/pdf/2602.23130)
  (2026): Frobenius-orbit representatives and invariant/pseudo-arc extensions (Proposition 3.1,
  pp. 9–10; Theorem 3.4 and Remark 3.5, p. 13; Theorem 3.11, p. 15), but no legal-extension count
  for arbitrary invariant plane arcs.
- Dye's Theorem 8 (pp. 283–284) is an exact completion-locus theorem for the Clebsch-hexagon family,
  but it supplies neither the `E(N-M)` count nor the arbitrary-deletion quantifier.

The ingredients are elementary incidence and orbit counting, so the counting mechanism alone
should not be advertised as deep novelty.  The apparently distinctive synthesis is the combination
of conjugate-pair legality, explicit profile minimization, multiplicity, and the quantifier over
every erased selected orbit.

The number `318` is **not** a proved sharp actual minimum.  It is the profile-minimized first-order
carrier lower bound at `s=7`; `(f,e)=(4,2)` minimizes the five certified lower bounds, without an
attainment claim.

## D-AOR2: orbit-replacement graph

No exact predecessor was located for a graph whose edges delete and insert one nonfixed Frobenius
orbit while preserving the exact fixed subset. Dye's graph is, however, a direct finite-projective
configuration-graph predecessor, so the broader claim that no arc/configuration graph was located
is not tenable. Closest predecessors and abstractions are:

- Dye, Proposition 1 and Theorem 7 (pp. 282–283): a five-valent graph on Clebsch hexagons with
  shared-associated-triangle adjacency, rather than deletion/insertion of a Frobenius orbit.
- Blokhuis, Seress, and Wilbrink,
  [*Characterization of complete exterior sets of conics*](https://doi.org/10.1007/BF01204717)
  (1992): a Paley graph is a proof device on p. 145, and a `q=31` Petersen secant-incidence
  configuration appears on p. 146. Neither is a reconfiguration graph on arcs.

- Ito et al., [*On the Complexity of Reconfiguration Problems*](https://doi.org/10.1016/j.tcs.2010.12.005),
  *Theoretical Computer Science* 412 (2011), 1054–1065
  ([author PDF](https://dspace.jaist.ac.jp/dspace/bitstream/10119/9858/1/16537-1.pdf)):
  feasible-solution reconfiguration graphs (pp. 1–2) and token jumping versus sliding (pp. 5–6).
  After fixing the exact Frobenius-fixed subset, the present graph is token-jumping-like on orbit
  tokens in a quotient collinearity hypergraph, not ordinary graph independent-set reconfiguration.
- Cardinali, Giuzzi, and Kwiatkowski,
  [*On the Grassmann Graph of Linear Codes*](https://doi.org/10.1016/j.ffa.2021.101895), *Finite
  Fields and Their Applications* 75 (2021), 101895
  ([arXiv](https://arxiv.org/abs/2005.04402)): `Δ_k(n,k)` is a graph on linear MDS codes
  (Corollary 2.8), but adjacency is codimension-one code intersection, not replacement of two
  conjugate projective columns.
- Maurer, [*Matroid Basis Graphs I*](https://doi.org/10.1016/0095-8956(73)90005-1), *Journal of
  Combinatorial Theory B* 14 (1973), 216–240: the classical single-element-exchange analogy.
  Ten-arcs are not matroid bases; “basis-graph-like” is safe, “basis graph” is not.
- Östergård, [*Switching Codes and Designs*](https://doi.org/10.1016/j.disc.2011.05.016),
  *Discrete Mathematics* 312 (2012), 621–632, and Potapov,
  [*Embedding in MDS Codes and Latin Cubes*](https://arxiv.org/abs/2109.14962), §2 Proposition 4:
  related local transformations, but they replace codeword subsets rather than projective columns.

The graph is fibered by the exact fixed-point subset, so no global connectivity claim is possible
across fibers.  The degree is for embedded point sets; quotienting by projective or semilinear
equivalence can identify neighbors.  High local branching implies neither connectivity nor
expansion.

At `s=7`, the total legal-pair bounds `(477,351,319,345,441)` for
`f=(0,2,4,6,8)` give per-deletion alternative counts `(476,350,318,344,440)`.  With
`e=(10-f)/2`, the profilewise degree candidates are therefore
`(2380,1400,954,688,440)`.  The simpler `318e` bound is valid but lossy.  Cross-deletion neighbor
injectivity remains to be formalized before these graph-degree values are promoted to the paper.

The exact Q25 minimum and five residual equality classes pursued in C151 are unaffected. If their
eventual geometric description uses conic incidence, the pair/cross-ratio model in
Blokhuis–Seress–Wilbrink (p. 144) is useful vocabulary and possibly a proof heuristic, but its
classification theorem concerns size-13 complete exterior sets rather than invariant eight-arcs.

## Publication recommendation

- Lead with quantitative equivariant extension; present arbitrary-deletion replacement as its most
  vivid robustness consequence.
- For the main theorem, use “to our knowledge” and distinguish Baker–Wantz's paired-extension
  maneuver explicitly.
- For D-AOR1, say “profile-minimized first-order carrier bound,” never “sharp minimum.”
- For D-AOR2, say “quadratic-Frobenius orbit-replacement graph” and “local degree bound”; distinguish
  its deletion/insertion adjacency from Dye's shared-triangle graph. Make no connectivity,
  expansion, rapid-mixing, or historical-first claim.
- Before priority language, run MathSciNet/zbMATH and backward/forward citation searches from
  Baker–Wantz, the Ball–Lavrauw survey, and the MDS Grassmann-graph paper.
