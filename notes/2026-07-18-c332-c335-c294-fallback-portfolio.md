# C294 fallback theorem portfolio: all-field structure and applied interfaces

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** C332--C335 allocated; exploration only until each task passes its stated theorem or
application gate

## Purpose

If C294 silver does not yield a uniform value theorem, preserve the strongest nearby discoveries
as independent results. The portfolio deliberately separates field descent, abundance, coding and
repair, and applied Cayley/Schreier graph structure. A larger finite nimber table, an unproved
application analogy, or a spectral computation without an operational consequence does not close
any item.

## C332: all-extension subfield descent

**Goal.** Extend C294's odd-extension decomposition to every extension degree
`q=q0^n`. Classify the `PGL2(q0)` and `PSL2(q0)` orbits on `P1(q)` into the base
subline, the quadratic orbit when `2 | n`, and regular orbits; track the deleted fixed points and
derive the exact Sprague--Grundy xor formula.

**First target.** Prove or correct the candidate even-degree decomposition

```text
base residual + one quadratic-orbit residual + regular Cayley components,
```

including the parity of the regular-component multiplicity for both determinant sheets.

**Exit gate.** A uniform theorem for all `n`, explicit formulas and exceptional cases, plus an
independent finite-field replay on representative even and odd extensions. The theorem must say
exactly what remains unevaluated in the quadratic and regular scars.

**Application test.** State the result as a base-change/restriction theorem usable by the
continuation and repair-port constructions, not only as a Node--Kayles identity.

**Novelty boundary.** The orbit lengths themselves are classical: the subfield subgroup has the
base-subline orbit, at most one orbit of size `q0(q0-1)`, and otherwise regular orbits. C332 must
cite that input and claim only the new fixed-point-deleted coloured decomposition, parity-sensitive
Sprague--Grundy formula, and its continuation/repair base-change consequences. Reproving orbit
lengths is not a contribution.

**Owned report stem.** `notes/2026-07-18-c332-all-extension-subfield-descent.*`

## C333: all-odd-field mirror-locus abundance

**Goal.** Replace the frozen one-parameter `S_b` construction by the moduli space of legal
four-centre sets formed from two orbits of a fixed-point-free projective involution. Separate
legality, mirror nonadjacency, full-`PGL2` generation, and subfield exclusion, then count the
surviving configurations over odd finite fields.

**First target.** Determine the dimension and irreducible pieces of the normalized mirror locus
and test whether the existing congruence restrictions are artifacts of the chosen involution and
constants.

**Exit gate.** Either a positive-dimensional full-`PGL2(q)` P-family for every sufficiently large
odd `q`, with an asymptotic or exact count, or a sharp arithmetic obstruction theorem explaining
which fields fail and why. Full-group generation must be proved rather than inferred from samples.

**Applied interface.** Export explicit parametrizations and exceptional-locus tests suitable for
constructing symmetric codes or repair networks without a group enumeration.

**Novelty boundary.** Fregier's correspondence between off-conic points and projective
involutions is classical, and recent work already studies triples of such involutions and proves
full-`PGL2(q)` generation for suitable triangles. C333 must be about the four-centre
`tau`-stable mirror locus, its quadratic-character nonadjacency conditions, its count, and the
resulting uniform P-strategy. Neither the point--involution dictionary nor existence of generating
triples is new.

**Owned report stem.** `notes/2026-07-18-c333-all-odd-q-mirror-locus.*`

## C334: MDS and multi-target repair applications

**Goal.** Translate the current `S_b` geometry, and later C333's larger locus, into precise coding
and distributed-repair statements. Treat the associated `[6,3,4]_q` MDS-code equivalence classes,
the exact GRS/non-GRS boundary, and automorphism groups as structural preliminaries. The applied
object is the growing `q+1`-helper conic carrier equipped with several superposed projection
matchings, interpreted as simultaneous radius-two repair ports.

**Mandatory metrics.** At least one theorem must quantify an applied property such as disjoint
repair availability, helper load, erasure tolerance, simultaneous repair capacity, repair-conflict
reliability, or an explicit scheduling guarantee. A relabelling of the P-position theorem in code
language is not sufficient.

**Primary external metric.** Start with H. Ly and E. Soljanin,
[*Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform Hypergraphs*](https://arxiv.org/abs/2504.17244).
Model the superposed projection matchings as the recovery hypergraph and compute the image of its
fractional-matching polytope. The preferred pass condition is an enlarged MDS service-rate region,
or the same target region with fewer systematic columns, on a growing carrier. If the geometry only
changes a repair schedule without changing service feasibility, say so and revert to an explicitly
repair-specific metric; service and repair are not synonyms.

**Exit gate.** A proved infinite family with explicit code/repair parameters and a literature-audited
comparison to existing MDS, LRC, batch-code, or functional-repair constructions; otherwise a
bounded negative identifying why the geometric family offers no new operational tradeoff.

**Novelty boundary.** Arcs and linear MDS codes are classically equivalent; projective-line group
actions already construct optimal LRCs; and partial geometries already provide multiple repair
alternatives. A fixed-length `[6,3,4]_q` family, an arc--MDS translation, locality two, or multiple
repair sets alone is not novel enough. C334 must prove a new multi-target interference, helper-load,
simultaneous-repair, resilience, reliability, or scheduling tradeoff on the growing carrier.

**Ownership boundary.** `complete-ports`, `repairports`, and other source lanes remain read-only.
C334 owns only the crowns-side multi-target interface unless the user explicitly re-pegs work.

**Owned report stem.** `notes/2026-07-18-c334-mirror-mds-multitarget-repair.*`

## C335: applied Cayley/Schreier network structure

**Goal.** Run a go/no-go audit of whether the mixed involution Cayley scars or full-group conic
Schreier residuals form useful sparse network families. Use determinant sheets, pair traces, the
full Fricke/definition-field coordinate, and two-colour voltage/backbone structure to seek exact or
asymptotic theorems on diameter, expansion, routing, resilience, mixing, or canonical distributed
addressing.

**First target.** Build a literature and invariant boundary, then select one operational metric for
which the algebraic coordinates can plausibly give an all-`q` theorem. Trace/GRR classification is
a permitted mechanism, not by itself the applied deliverable.

**Primary external metric and falsifier.** Use A. Patra and A. Barg,
[*Generalized regenerating codes and node repair on graphs*](https://arxiv.org/abs/2405.11714),
whose cost weights helper traffic by network distance. Before generating a family census, solve one
small Cayley and one deleted-Schreier instance analytically and compare with their scalar
specialization. If vertex transitivity makes the distance-weighted optimum depend only on the
distance distribution, record that degeneracy as a sharp negative and stop. Do not compare a
scalar code with vector/subpacketized regenerating-code optima as though the regimes coincided.

**Exit gate.** One proved network-relevant bound with a comparison against a standard baseline and
an explicit infinite family, or a sharp negative showing that these graphs fail the proposed
application metric. Spectra, automorphism orders, or finite tables alone do not pass.

**Novelty boundary.** Recent work already develops the incidence geometry of involution triples in
`PGL2(q)` and constructs full-group rank-three hypertopes; cubic graphical regular
representations of `PSL2(q)` are also known. C335 may consume those results but cannot claim the
triple geometry, full-group generation, or GRR existence as new. Its only acceptable novelty is an
operational network theorem for this specific deleted Schreier/mixed-Cayley family, or a sharp
negative. This makes C335 deliberately high-risk.

**Owned report stem.** `notes/2026-07-18-c335-applied-cayley-schreier-networks.*`

## Order and relation to C294

1. C323 evidence hygiene is closed at commit `e0c9db85`.
2. In the current crowns EV order, C334 precedes C333 and C332 because the 2025 service-rate-region
   model supplies a live, falsifiable applied consumer; C333 remains the highest-upside intrinsic
   family theorem, while C332 is the lowest-risk independent theorem.
3. C334 may begin on the established `S_b` family, consume C298 only through an explicit repair
   metric, and later consume C333; it must prioritize an operational repair/code result.
4. C335 begins with literature and metric selection, not graph generation.

None of C332--C335 closes C294 silver. C294 is paused by user as of 2026-07-18; these tasks may read
its committed inputs but do not resume B3. If C294 is explicitly resumed later, it may consume a
proved result from this portfolio without making the fallback task part of its experiment queue.

## Focused novelty audit, 2026-07-18

This is a first-pass source audit, not a MathSciNet/zbMATH citation-closure claim.

| Item | Verdict | Existing boundary | Defensible new core |
|:--|:--|:--|:--|
| C332 | **promising synthesis; classical orbit input** | Subfield-subgroup orbit sizes on the projective line are known | deleted coloured residual, quadratic scar, xor parity, and base-change theorem |
| C333 | **strongest novelty prospect** | Fregier correspondence and generating involution triples are known | counted `tau`-stable four-centre P-locus over all odd fields |
| C334 | **promising after SRR refocus** | arc--MDS equivalence, `PGL2`-based LRCs, multiple repair alternatives, and general MDS SRR machinery are known | a strictly improved service region or systematic-column tradeoff from the growing carrier |
| C335 | **high-risk / go-no-go with a standard metric** | involution-triple hypertopes, cubic `PSL2` GRRs, and graph-constrained repair bounds are known | an exact distance-weighted repair bound for the deleted Schreier or mixed-Cayley family, or a sharp symmetry degeneracy |

Primary and near-primary boundary sources:

- P. Tranchida, [*Triples of involutions in `PGL(2,q)` and their incidence geometries*](https://arxiv.org/abs/2411.10299), especially the point--involution dictionary, full-group hypertope existence, and subfield boundary.
- P. J. Cameron, G. R. Omidi, and B. Tayfeh-Rezaie, [*3-Designs from `PGL(2,q)`*](https://www2.math.ethz.ch/EMIS/journals/EJC/Volume_13/PDF/v13i1r50.pdf), for classical projective-line subgroup orbit calculations.
- J. Thas, [*M.D.S. codes and arcs in projective spaces: a survey*](https://lematematiche.dmi.unict.it/index.php/lematematiche/article/view/593), for the classical arc--MDS equivalence.
- L. Jin, L. Ma, and C. Xing, [*Construction of optimal locally repairable codes via automorphism groups of rational function fields*](https://arxiv.org/abs/1710.09638), for `PGL2` actions on the projective line in LRC constructions.
- L. Pamies-Juarez, H. D. L. Hollmann, and F. Oggier, [*Locally Repairable Codes with Multiple Repair Alternatives*](https://arxiv.org/abs/1302.5518), for availability from partial geometries.
- H. Ly and E. Soljanin, [*Service Rate Regions of MDS Codes & Fractional Matchings in Quasi-uniform Hypergraphs*](https://arxiv.org/abs/2504.17244), for the growing-carrier multi-object service metric.
- A. Patra and A. Barg, [*Generalized regenerating codes and node repair on graphs*](https://arxiv.org/abs/2405.11714), for distance-weighted graph-constrained repair.
- B. Xia and T. Fang, [*Cubic graphical regular representations of `PSL2(q)`*](https://arxiv.org/abs/1510.02740), for the existing GRR boundary.

A targeted search found Node--Kayles work on many named graph families and structural parameters,
but no direct Cayley- or Schreier-family value theorem. That is positive evidence for C294's game
novelty, not proof of absence; any paper-facing claim still requires database and forward-citation
closure.
