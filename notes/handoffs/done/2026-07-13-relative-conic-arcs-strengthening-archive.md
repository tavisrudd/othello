# Relative-conic arcs strengthening — companion archive

Append-only companion to
[`../2026-07-13-relative-conic-arcs-strengthening.md`](../2026-07-13-relative-conic-arcs-strengthening.md).
The live handoff holds the current goal, theorem targets, gates, task statuses, and next action.
Session notes, raw validation output, source-search trails, changed conclusions, and closed-negative
routes belong here.

## 2026-07-13 — lane created and C106–C110 allocated

The completed C89–C96 lane exposed a second, downstream strengthening program rather than a gap in
the original formalization. The new lane separates three mathematical layers:

- an exact evaluation-avoidance theorem based on the fact that fewer than `q` proper hyperplanes do
  not cover a finite vector space over `F_q`;
- the standard but useful projective dictionary between plane arcs, codimension-three MDS codes,
  syndrome distance, deep holes, and one-column extensions; and
- a configuration-specific `q=11` package whose preliminary computations indicate an icosahedral
  `A5` action and unusually exact code/extension invariants.

The q11 evidence recorded before allocation is provisional until C106 reproduces it independently:

- conic-projectivity stabilizer size 60 with element-order distribution
  `1^1 2^15 3^20 5^24`;
- point-orbit sizes `6,12,10,15,30,30,30`;
- off-arc secant-index counts `(N1,N2,N3)=(90,15,10)`;
- six perfect matchings partitioning the 30 icosahedron edges;
- quadratic evaluation rank six, excluding containment in a conic;
- projective deep-hole syndrome set equal to the standard 12-point conic;
- affine syndrome/coset distances `(1,60,1150,120)`; and
- distance-two leader multiplicities `(900,150,100)`.

These observations motivated the task split but are not yet paper claims or Lean theorems. C106 is
explicitly authorized to refute or narrow them before proof engineering.

Initial literature seeds for the structured audit are Kaipa on projective syndromes/deep holes and
MDS extensions; Zhang–Wan–Kaipa on deep holes; recent non-GRS MDS construction work; finite-geometry
classifications of conic exterior sets and small arcs; the `A5 < PSL(2,11)`/Witt-design literature;
and finite-vector-space hyperplane covering theorems. The audit must search the exact conjunction,
not infer novelty from failure of one phrase search.

The final discovery review is a required C110 deliverable. It must separately classify proved
corollaries, cheap generalizations, surprising equivalences, applications to the projective-cap
program, and speculative directions; none may be silently promoted to novelty.

## 2026-07-13 — R0 statement correction: the chord classes are not perfect matchings

The allocated T3 wording called the six witness-coloured chord classes “perfect matchings.” This is
arithmetically impossible: a perfect matching on 12 vertices has six edges, whereas the six classes
partition the icosahedron's 30 edges and therefore have five edges each. The correct target is six
five-edge near-perfect matchings. For each exterior witness point, its five conic secants pair ten
conic vertices; the two omitted vertices are its tangent contacts. The live handoff has been
rewritten with the corrected statement. C106 must still check distinctness, edge partition, and the
tangent-contact interpretation directly from the frozen coordinates.

## 2026-07-13 — R6 strengthens the evaluation threshold from `< q` to `≤ q`

The initial T1 target assumed `|A|<q`, following the plain union bound
`|⋃H_a|≤|A||K|/q`. All bad hyperplanes contain zero, giving the strictly better elementary bound
`|⋃H_a|≤1+|A|(|K|/q−1)`. Consequently at most `q` proper hyperplanes cannot cover `K`, so the exact
avoidance dichotomy holds uniformly under `|A|≤q`. The threshold is sharp: in dimension two, the
`q+1` one-dimensional subspaces are precisely the proper hyperplanes and cover the entire space.
The live target and C107 queue row now use the strengthened hypothesis. The small-field checker
`papers/arcs_complete_outside_conic/check_evaluation_dichotomy.py` exhausts every projective
hyperplane family of size at most `q` for `q=2,3,5` and dimensions one through three, and checks the
`q+1` cover in dimension two.

## 2026-07-13 — C106 independent replay, provenance, and exact-object novelty gate

Commands (all scratch outputs are disk-backed under `/home/tavis`, not `/tmp`):

```text
python3 papers/arcs_complete_outside_conic/check_q11_structure.py \
  > /home/tavis/q11-structure-python.json
c++ -std=c++20 -O2 -Wall -Wextra -pedantic \
  papers/arcs_complete_outside_conic/check_q11_structure.cpp \
  -o /home/tavis/q11-structure-cpp
/home/tavis/q11-structure-cpp > /home/tavis/q11-structure-cpp.txt
python3 papers/arcs_complete_outside_conic/check_evaluation_dichotomy.py \
  > /home/tavis/evaluation-dichotomy.json
```

Toolchain: Python 3.13.12; GCC 14.3.0. SHA-256:

```text
0abe909c9aadce0db4c75f296c8de25e929dd1065c906996da8dec017e534d69  check_q11_structure.py
1753674172d48f1d056d350e30baa9eb67de0810c84a96da0440947768ae041c  check_q11_structure.cpp
6ed309bd2461ce9998cbd3bcaa5396379e6973b7503ce2dcdfb32c9806386566  check_evaluation_dichotomy.py
b096305a809b062c274129c157d51a57d65e9aec0e44662370ec53c8c773110f  q11-structure-python.json
380cab47923cbfb3a9bfcc54ee89cf0eb79aa551d936d2e91cbb4949ae56477d  q11-structure-cpp.txt
88be03eb8a81bb906083457a4b4201cfd1ef6bcaa9de01928175840f61ac55ff  evaluation-dichotomy.json
```

Both q11 implementations prove by exhaustive assertions:

- 133 projective points, 12 conic points, and a six-arc disjoint from the conic;
- quadratic evaluation rank six;
- required-point secant indices `1:90, 2:15, 3:10`, and conic index `0:12`;
- affine syndrome distances `0:1, 1:60, 2:1150, 3:120`;
- distance-two minimum-leader histogram `1:900, 2:150, 3:100`;
- exactly 12 single extension columns, precisely the conic;
- a 30-edge, degree-five conflict graph split into six distinct five-edge matchings, each covering
  ten vertices and missing exactly the two tangent contacts of its witness;
- all 1320 conic projectivities, a 60-element stabilizer inside `PSL(2,11)`, element-order counts
  `1:1, 2:15, 3:20, 5:24`, generators of orders two and three with product order five and closure
  60, and point-orbit sizes `6,10,12,15,30,30,30`;
- transitivity on the six arc points, 12 conic points, and 30 conflict edges; and
- transformed/relabelled invariance plus the witness/generator negative controls.

The evaluation checker exhausts every family of at most `q` projective hyperplanes for
`q=2,3,5` in dimensions one through three (206,866 families total), verifies that none covers, and
checks the sharp `q+1` cover in dimension two.

Early source collisions:

- Brouwer's [*Strongly regular graphs* notes](https://homepages.cwi.nl/~aeb/math/srg/rk3/srgw.pdf)
  call an `A5`-stabilized six-set in `PG(2,q)` an **icosahedral** and list the exceptional orbit
  sizes and congruence conditions, including conic transitivity at `q=11`.
- Dolgachev–Farb–Looijenga's
  [Wiman–Edge paper](https://doi.org/10.1007/s40879-018-0231-3) describes the classical `A5`
  orbit structure in the Klein plane.
- The Bayreuth [M12 design construction](https://mathe2.uni-bayreuth.de/discreta/M12/m12_design.html)
  gives explicit projective-line generators embedding `A5` in `PSL(2,11)`.
- Davydov–Marcugini–Pambianco
  [Theorem 6.3](https://arxiv.org/abs/2101.12722) gives the general plane-arc secant-index/coset
  weight and leader-count dictionary for `[n,n-3,4]_q` MDS codes.
- Kaipa's [deep-hole/MDS-extension paper](https://arxiv.org/abs/1612.05447) gives that dictionary
  in the Reed–Solomon extension setting.
- Finite-vector-space covering by proper subspaces, including the sharp `q+1` threshold, is
  classical; Jamison's
  [covering paper](https://www.sciencedirect.com/science/article/pii/0097316577900012) is a source
  spine rather than a novelty citation for the elementary common-zero proof.

Safe posture: T1's application and T2/T3's certified synthesis may strengthen the paper, but the
hyperplane threshold, generic coding dictionary, `A5` six-set, and orbit structure are not novelty
claims. The exact relative-conic deep-hole locus plus refined q11 counts and extension complex had
no exact match in this bounded search; C110 must continue citation chasing before submission.

## 2026-07-13 — latent-potential review and scope decision

The strongest additional connection is a coding reinterpretation of the paper's central theorem,
not merely a dictionary appended to the q11 example. For the rank-three parity-check matrix of an
arc, `r_A(x)` is exactly the number of weight-two leader supports for projective syndrome direction
`x`. Hence the prescribed-hole first and second moments and defect identity are exact leader-count
and leader-collision identities. `CompleteOutside A C` confines every distance-three projective
syndrome direction to `C`; “deep-hole locus” is reserved for the separately proved covering-radius-
three case. The paper's additive `3/2` lower bound therefore gives the same length obstruction for
projective `[k,k-3,4]_q` MDS codes with conic-confined distance-three syndrome locus. A bounded exact-
phrase and citation search found the general arc/coset dictionary, but no predecessor for this
prescribed-hole defect restatement and consequence. This remains a synthesis candidate, not a
priority claim.

The q11 extension complex has the exact independent-set counts
`(i_0,i_1,i_2,i_3)=(1,12,36,20)` and no independent four-set, hence polynomial
`1+12t+36t²+20t³`. Exactly six independent pairs are maximal—the antipodal pairs—and all twenty
independent triples are maximal. Thus the seed has six ordinary-complete eight-point extensions and
twenty ordinary-complete nine-point extensions within its conic-column extension locus. The two
vertices missed by each witness-coloured near-perfect matching are exactly its tangent contacts and
one antipodal pair; adjoining those missing edges gives a one-factorization of the icosahedron plus
its antipodal matching. These are cheap finite consequences suitable for `by decide` over
`Q11Residual`.

The exact classical object was also located: the six-set is the Clebsch hexagon, and its ten points
on three bisecants are its Brianchon points, forming the classical `A5`-fixed ten-arc. The q11
ten-arc is known complete. This is interpretation and necessary prior-art citation, not novelty;
the primary source trail runs through R. H. Dye, *Hexagons, Conics, A5 and PSL2(K)*, J. London
Math. Soc. 44 (1991), and the later “Primitive arcs in PG(2,q)” treatment.

Finally, the T1 count sharpens quantitatively. For `r≥2`, the complement of `m≤q` distinct
hyperplanes in `F_q^r` has at least `(q-1)q^(r-2)(q+1-m)` vectors, sharp for hyperplanes through a
common codimension-two subspace. The exact number of full-support evaluation forms is more generally
controlled by the evaluation matroid's characteristic/Tutte polynomial, but importing that theory
would be disproportionate. The degree-`d`/Veronese version also suggests a future hierarchy of MDS
codes whose distance-three syndrome locus is confined to a prescribed algebraic variety; this is
parked as a research direction, not added to C107–C109.

Scope decision: C108 will be a thin semantic bridge carrying the defect theorem into coding
language. C109 is collapsed to one `Q11Coding.lean` module and no longer requires a formal abstract
`A5` isomorphism or full orbit library. The main paper gets the compact coding theorem and q11
example if the proofs remain readable; no companion paper is currently planned.

An adversarial pass corrected the initially overgeneral multi-extension wording. For arbitrary
singly legal new columns, pair conflicts with one old column do not detect three collinear new
columns; the exact general object is therefore a conflict hypergraph with two- and three-edges. If
the single-extension locus is confined to an arc, the three-edges disappear. In particular, for a
relative-complete arc outside a disjoint conic, every extension lies on that conic, simultaneous MDS
extensions are exactly graph-independent sets, and ordinary complete superarcs containing the seed
are exactly maximal independent sets. This turns the q11 polynomial into a complete-superarc
classification of the fixed Clebsch seed, rather than merely a count of compatible columns. The
same semantic bridge also gives the cheap exact leader counts: a distance-two syndrome direction of
index `r` has `r` weight-two leaders, while every distance-three affine syndrome has exactly
`binom(k,3)` weight-three leaders.

## 2026-07-13 — Discovery Track register established

At the user's request, the live handoff now maintains the standard Discovery Track taxonomy used
by the earlier formalization lanes. After clarification, its scope is strictly incidental
mathematical observations arising while executing the planned work—not a record of the plan or its
completion. Planned deliverables remain in the work-package/status sections. Dated proof/search
history remains here in the companion archive. Every discovery must be reclassified after C110's
adversarial proof and novelty audits before manuscript promotion.

## 2026-07-13 — C107 finite-field evaluation leaf

`RelativeConicArcs/EvaluationDichotomy.lean` now proves the sharp at-most-`q` common-avoidance
theorem, quantitative common-zero count, dimension-sensitive distinct-hyperplane bound and its
factored form, the explicit `q+1` plane cover and rank-two equality model, the exact evaluation
kernel dichotomy, finite-dimensional kernel/span duality, and arbitrary-feature evaluation closure
(hence every Veronese degree). The focused build is warning-free. `#print axioms` for all public
headline declarations reports exactly `[propext, Classical.choice, Quot.sound]`, and a source scan
finds no `sorry`, `admit`, `native_decide`, or custom axiom. The top-level aggregate successfully
built/imported this leaf, then stopped in unrelated concurrent generated file
`Q25PairRows/R_073.lean`, whose missing import leaves `RowResult` and `fin_cases` unknown; C107's
aggregate gate remains open only for a clean rerun after that lane is repaired.

## 2026-07-13 — C108 syndrome and transparent coding bridge

`SyndromeGeometry.lean` now proves the projective syndrome-distance trichotomy, exact weight-two
leader-support count, one-column extension equivalence, confinement of distance-three directions
under `CompleteOutside`, the exact pair/triple conflict-hypergraph theorem, and its arc-confined
pair-graph/maximal-completion specialization. The first and second secant moments and scaled defect
are restated as exact leader-count, leader-collision, and leader-remainder identities.

`CodingBridge.lean` defines the parity-check map/code and Hamming support transparently. It proves
dimension `n-3`, minimum distance exactly four under the codimension-three MDS column package, and
the indexed projective arc/triple-independence bridge. A distance-three affine syndrome has a
unique leader on each three-column support; mapping leaders to supports is injective and onto the
three-subsets, so the actual leader count is `Nat.choose n 3`, not only a support count. The module
also exposes a small covering-radius certificate: three independent columns represent every
syndrome with weight at most three, and avoidance of all affine two-column spans forces a selected
syndrome to have distance at least three. Focused builds are warning-free.

## 2026-07-13 — C109 q11 code and extension package

`Q11Coding.lean` builds with kernel finite reduction and proves:

- the full projective secant-index spectrum `0:12, 1:90, 2:15, 3:10, 5:6`;
- a transparent `[6,3,4]₁₁` MDS code and exact minimum distance;
- quadratic evaluation determinant nonzero, hence no conic through the six columns and the
  projective non-GRS conclusion;
- projective distance-three directions exactly equal the standard conic;
- a conic syndrome avoids every two-column affine span, while every syndrome has a weight-at-most-
  three representative, proving covering radius exactly three;
- exactly 20 minimum weight-three leaders for the displayed conic syndrome;
- affine distances `(1,60,1150,120)` and distance-two leader split `(900,150,100)`;
- extension polynomial `1+12t+36t²+20t³`, no independent four-set, no maximal zero- or
  one-extension, exactly six maximal two-extensions and twenty maximal three-extensions; and
- six five-edge witness chord matchings, each missing an antipodal pair, disjointly partitioning
  all thirty icosahedron edges.

The exact projective deep-hole locus is proved as an equality, not inferred from relative
completeness: confinement supplies one inclusion and singleton extension validity supplies the
reverse. The radius proof avoids enumerating `11^6` words; its finite kernel check is only the
`6·6·11·11` two-column avoidance table.

## 2026-07-13 — C110 adversarial, novelty, and publication pass

The independent checkers were rerun from disk-backed `/var/tmp`. Source and output hashes match the
C106 freeze exactly. Python and separately written C++ agree on every q11 projective, syndrome,
leader, chord, and group datum. Coordinate/relabel transport passes; replacing one witness point
changes the extension count from 12 to 20 and the stabilizer from 60 to 2; a mutated generator is
rejected. The small-field evaluator exhausts 206,866 hyperplane families and the sharp `q+1`
boundary.

An axiom audit of the public C108/C109 headlines reports exactly
`[propext, Classical.choice, Quot.sound]`; source scans find no `sorry`, `admit`, `native_decide`,
or custom axiom. `CodingBridge` and `Q11Coding` focused builds pass. The shared aggregate is still
intentionally deferred because an unrelated process is sequentially building hundreds of
generated Q25 leaves; starting another aggregate would violate the repository's OOM hygiene.

The primary-source citation pass tightened novelty wording. Khare records the classical sharp
vector-space covering threshold; Kaipa records the deep-hole/MDS-extension equivalence for
Reed–Solomon codes; Davydov–Marcugini–Pambianco treat plane-arc cosets and explicitly state the
`binom(n,3)` farthest-coset leader count in Theorem 4.6; Dye and Storme–Van Maldeghem supply the
Clebsch-hexagon/primitive-arc prior-art spine. No exact predecessor was located for this paper's
prescribed-hole defect as a coding leader-collision identity or for the full q11 conjunction, so
both are described only as checked syntheses, with no priority claim.

The manuscript source, rendered PDF, proof audit, package TRUST manifest, papers-index results
table, task queue, and projective-cap consumer handoff were synchronized. The main paper remains
the natural home: the coding theorem is a compact reinterpretation of its central defect, while
the q11 package is one exceptional example rather than a separate companion-scale narrative.

## 2026-07-13 — affine-leader proof-surface adversarial repair

The final checklist rejected a merely arithmetic restatement of the q11 affine coset counts as an
insufficient proof surface. A direct kernel enumeration of coefficient presentations was then
tested and stopped after even a 121-syndrome slice reached roughly 8.6 GiB; `/tmp` was not involved,
and no aggregate was started. The replacement is structural: `CodingBridge` now proves that for
weights at most three, actual affine leaders map bijectively to the supports that occur. The q11
counts therefore follow from the kernel-checked projective secant spectrum and the ten nonzero
scalars on each direction, exactly as in the manuscript proof. Focused builds of `CodingBridge`
and `Q11Coding` pass warning-free after this strengthening.

## 2026-07-13 — hostile-review repair round (supersedes the preceding affine-count adequacy verdict)

An external hostile review against pre-strengthening base `c3fbe05` correctly found that the
preceding support-bijection repair still did not connect the projective arithmetic to all affine
syndromes: the public q11 distribution theorems merely multiplied projective counts by ten. That
statement-adequacy verdict is overturned here.

The repaired strict-trust chain now proves a coordinate normalization bijection
`AffineRay ≃ {s : Vec (ZMod 11) // s ≠ 0}`, characterizes membership in
`affineSyndromesOfDistance d` by actual `parityCheckMap` distance, and derives the affine counts
structurally from the certified projective spectrum. For distance two, split kernel certificates
prove a nonzero two-column presentation for every determinant-zero pair; the semantic theorem
`syndromeLeaderSupports_two_eq_raw` identifies those pairs with supports of actual weight-two
coefficient words. The generic leader/support bijection and the proved scalar-word bijection then
yield the semantic `(900,150,100)` split. Large finite reductions were split into leaf modules and
built sequentially; two attempted aggregate-style reductions were stopped when they approached
the box's memory limit alongside the unrelated Q25 worker.

The same review round repaired three other statement surfaces. The generic extension theorem now
says exactly "maximal inside `E`"; `completeOutside_empty_of_maximalExtensionIn_full` supplies the
ordinary-completeness upgrade only for the full one-point extension locus, and
`maximal_independent_extension_complete` verifies that hypothesis for every q11 maximal set. The
six antipodal additions are explicit and
`completed_witness_matchings_oneFactorization` checks distinctness, perfect matching coverage,
edge-disjointness, and partition. The no-quadratic Lean theorem is documented only as the formal
no-conic premise; the projectively non-GRS conclusion is defined and sourced through the classical
normal-rational-curve/GRS correspondence in the manuscript.

The final hostile-review repair added the named theorem
`affine_distanceThree_iff_mem_standardConic`: for every nonzero affine syndrome, actual
parity-check distance three is equivalent to membership of its projective quotient in the standard
conic. This closes the remaining gap between the semantic affine-distance computation and the
separately proved incidence-defined deep-hole locus. A source-level recheck also corrected the q16
description: `StepBook.coverage` covers every legal move by a certified transition, while
`StepBooksValid` covers the parent list exactly; neither theorem is now inaccurately described as a
literal equality between raw children and legal extensions.

The repaired modules `Q11SemanticSynthesis`, `Q11SemanticDistribution`,
`Q11SemanticLeaders`, and `Q11Coding` then built sequentially under `choom -n 1000`. The bridge
and the other repaired q11 headline theorems print only Mathlib's accepted
`[propext, Classical.choice, Quot.sound]` foundations. A focused source scan found no `sorry`,
`admit`, `native_decide`, or paper-specific axiom. Tectonic rebuilt the synchronized PDF at SHA-256
`f53a0180dceba632f727d125b32f0c730ec14c4649869889a79c0c2b7987c384`; the only diagnostic was
the pre-existing harmless underfull bibliography line.

A final bounded hostile re-review inspected the three new bridge theorem bodies and compared the
revised q16 language with `Q16StepKernel.lean`. It found no remaining blocker, major, moderate, or
minor defect in the repair set and confirmed that no conclusion is inferred merely from parallel
cardinalities.

The literature/claim pass added Blokhuis--Seress--Wilbrink (1992) for complete exterior sets,
updated Davydov--Marcugini--Pambianco to the final 2023 journal record, and made the classical/new
split explicit. The q16 explanation now names `StepBook.coverage`, `StepBooksValid`,
`classifiedAt_level8_of_frame`, and frame reduction so a referee can see that list closure and
exhaustiveness are kernel-checked rather than trusted to the generator. The independent checker
protocol was replayed with GCC 14.3.0, `-std=c++20 -O2`, and disk-backed `/var/tmp`; all three
frozen output hashes reproduced exactly. Auxiliary group/orbit/mutation diagnostics are now
clearly outside the one-to-one Lean theorem manifest and outside the proof dependency.


## Live-file snapshot before pruning — 2026-07-15

# Handoff: relative-conic arcs — evaluation, coding, and icosahedral strengthening

**Lane**: `relconic` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-13
**Status:** ACTIVE — strengthened lane and hostile-review repairs pass focused publication gates; C110 shared aggregate rerun, C188 q=5 import, and C195–C196 exterior-set framing remain
**Tasks:** C106–C110, C188, C195–C196, C201

## ⚠ The manuscript was edited from outside this lane (2026-07-14, commit `cfd8537`)

A `gem-mining` literature sweep hit this paper. The user authorized the edits; they are recorded here
so the change is not invisible to this lane. Two fixes to `arcs_complete_outside_conic.tex`, both
from the [gem-program vet](../2026-07-14-gem-program-vet.md) §2.2:

- **§1 exterior-set paragraph + §8 prior-art sentence: `Edge1956` added.** W. L. Edge, *Canad. J.
  Math.* **8** (1956) 362–382, §§29–32 describes the q=11 six-external-point configuration and names
  it the Clebsch hexagon, 35 years before BSW — whom this paper already cited correctly. New
  bibliography entry.
- **§4 line ~441: the leader-formula cite was wrong.** It read "DMP Theorem 4.6"; in arXiv v2 that is
  the *symmetry* theorem, and the general farthest-coset formula — which is what the sentence
  describes — is **Theorem 7.7**. Re-pinned, and the `DavydovEtAl2021` bibliography entry now
  discloses arXiv v2 numbering, matching what the `clebsch` paper already does for the same
  reference. Rebuilt: compiles clean, no undefined citations.

**This lane came out of the sweep well.** Its §1 exterior-set paragraph already cited BSW and drew
the right distinction ("a different condition from prescribed-hole completeness") before any of this
— the only lane with no false novelty claims in the
[review tables](../2026-07-14-novelty-status-review-summary-tables.md). Two things for this lane to
carry:

- **The deep-hole "first" is audited and survives** ([sweep](../2026-07-14-gem-lit-deep-holes.md)):
  no prior instance of a complete deep-hole set identified with the full rational-point set of a
  named variety. ZWK's redundancy-4 result is a disjoint union of three combinatorial families, not
  a variety-equality. **Residual: Reed–Muller deep holes marked NOT SEARCHED, not cleared** — this
  paper owns that claim and ships first, so the residual is this lane's. Queued as **C154**; search
  directions in the [C153–C160 queue rationale](../2026-07-14-c153-c160-queue-rationale.md), and the
  current state of every claim is in the
  [novelty status tables](../2026-07-14-novelty-status-review-summary-tables.md) (this lane has no
  false-novelty rows).
- **Prop 8.7** is what `clebsch` cites as its companion reference (it had gone stale as "Prop 4.6");
  re-sync if this paper renumbers again.

## Goal

Strengthen the completed `arcs_complete_outside_conic` paper and Lean development with three
downstream theorem packages:

1. an exact finite-field evaluation-avoidance dichotomy;
2. a projective arc–MDS/deep-hole/extension bridge; and
3. the exceptional `q=11` syndrome and exact MDS-extension structure, with its classical
   Clebsch-hexagon/icosahedral interpretation.

The queued C188 follow-up imports only Clebsch C187's `q=5` four-frame witness to prove and
strict-kernel formalize `rho_C(5)=L_2(5)=4`. The broader `4<=k<=7` conic-filling classification
stays in the `clebsch` lane and is cited rather than migrated; see the
[C188 report](../2026-07-15-c188-rhoc5-frame.md).

Two bounded Dye/BSW follow-ups are queued here. C195 adds the implication diagram separating
complete exteriority (`C subset U`) from completeness outside the prescribed conic (`U subset C`).
C196 instantiates the distinction on BSW's q=7 exterior four-arc, where the four-arc identity gives
`|U|=20>8=|C(F_7)|`. Both are framing upgrades; neither changes theorem ownership.

The work is a continuation of the finished
[C89–C96 formalization](done/2026-07-12-arcs-complete-outside-conic-formalization.md), not a reopening
of it. Session history, experimental output, literature-search trails, and superseded formulations
belong in the
[companion archive](done/2026-07-13-relative-conic-arcs-strengthening-archive.md).

## Scope and isolation

- Extend only the standalone `lean/RelativeConicArcs/` library. Existing `ProjectiveCap`,
  `FiniteGeom`, generated `Q16CertificateData`, and unrelated targets must not import the new
  modules.
- Reuse the existing one-way foundations, especially `EvaluationObstruction.lean`,
  `ProjectiveBridge.lean`, `Q11Residual.lean`, and `Q16QuadraticAvoidance.lean`.
- Put coding terminology over semantic finite linear algebra and projective incidence; do not make
  the result depend on an opaque or paper-specific coding framework.
- Keep external computation outside the trust boundary. Lean must check the finite certificates and
  the semantic bridges from checked data to the published theorems.
- Heavy temporary build artifacts must use disk-backed storage under `/home`; `/tmp` is tmpfs.

## Exact theorem targets

### T1 — evaluation-avoidance dichotomy

For a finite field `F` of cardinality `q`, a finite-dimensional `F`-space `V`, evaluations
`ev x : V →ₗ[F] F`, and finite sets `U` and `A`, let
`K = ker (evaluationMap ev U)`. Under `|A| ≤ q`, prove

```text
∃ f ∈ K, f ≠ 0 ∧ ∀ a ∈ A, ev a f ≠ 0
↔
K ≠ ⊥ ∧ ∀ a ∈ A, K ⊄ ker (ev a).
```

Then prove the finite-dimensional dual reformulation
`K ≤ ker (ev a) ↔ ev a ∈ span (ev '' U)` and the degree-`d` Veronese/evaluation-closure corollary.
The core existence proof is the sharp common-zero count showing that at most `q` proper
hyperplanes cannot cover `K`. Strengthen existence quantitatively: if `dim K=r≥2` and there are
`m≤q` distinct bad hyperplanes, at least
`(q-1)q^(r-2)(q+1-m)` vectors avoid them; equality is attained by hyperplanes through a common
codimension-two subspace. This uniform threshold is sharp because the `q+1` one-dimensional
subspaces cover `F_q²`.

### T2 — projective arc and coding bridge

For a projective `k`-arc represented by the columns of a rank-three matrix `H_A`, define
`C_A = ker H_A` and prove:

- `A` is an arc iff every three columns are independent, equivalently `C_A` has parameters
  `[k,k-3,4]_q` and is MDS;
- projective syndrome distance is one on `A`, two on its secant-covered locus, and three on its
  ordinary uncovered locus;
- a fixed affine syndrome over a direction of secant index `r` has exactly `r` weight-two minimum
  leaders, while every distance-three syndrome has exactly `binom(k,3)` weight-three leaders;
- an uncovered point is exactly a one-column MDS extension of `C_A`;
- completeness outside a conic is exactly confinement of all projective distance-three syndromes
  to the conic; when covering radius three is separately established, these and only these are the
  projective deep-hole directions; and
- simultaneous extensions are independent sets of the full pair/triple conflict hypergraph. If the
  single-extension locus is confined to an arc—in particular, to the prescribed conic here—the
  triple obstruction vanishes, so the extension poset is exactly the independence complex of the
  pair-conflict graph. Maximality is initially relative to the allowed locus; it upgrades to
  ordinary completeness when that locus is proved to be the full one-point extension set.

Also restate the prescribed-hole defect identity in these semantics: `r_A(x)` is the number of
weight-two leader supports for projective syndrome direction `x`, so the first and second index
moments and the exact defect are leader-count and leader-collision identities. Consequently the
paper's lower bound becomes a length obstruction for projective codimension-three MDS codes whose
distance-three syndrome directions are confined to a prescribed conic. Use “deep-hole” only when
covering radius three has separately been proved.

If Mathlib lacks a suitable coding API, state and prove support-size/syndrome semantics first, then
add conventional parameter corollaries. The geometric theorem must not be blocked by library
terminology.

### T3 — the `q=11` certified code and extension package

For the certified six-arc already used by `Q11Residual.lean`, prove in one thin downstream module:

- its secant-index distribution is `(N₁,N₂,N₃)=(90,15,10)`;
- the six exterior arc points give five-edge near-perfect chord matchings, each missing the two
  tangent-contact vertices, and these six matchings partition the 30 edges of the icosahedron;
- `C_A` is a non-GRS `[6,3,4]₁₁` MDS code of covering radius three whose projective deep-hole
  syndrome set is exactly the 12-point conic;
- the affine coset-distance distribution is `(1,60,1150,120)`, and the distance-two cosets split as
  `(900,150,100)` according to whether they have one, two, or three minimum-weight leaders; and
- the simultaneous MDS-extension complex is the independence complex of the icosahedron, with
  independence polynomial `1+12t+36t²+20t³`, exactly six maximal two-extensions and twenty
  maximal three-extensions, and no four-extension.

The formal non-GRS premise is coordinate-free: quadratic evaluation on the six projective columns has
rank six, so no conic contains the arc. The manuscript's projectively non-GRS conclusion must
state its convention and cite the classical normal-rational-curve/GRS correspondence. Identify the seed in the manuscript with the classical
Clebsch hexagon and its ten triple-secant Brianchon points with the known `A5`-fixed ten-arc, but do
not make a new abstract `A5` isomorphism or full orbit formalization a completion dependency.

## Work packages

| Task | Work | Completion gate |
|---|---|---|
| **C106 [REPORTED 2026-07-13]** | Run the cheap refutation suite and freeze independent small certificates for T1–T3. | Python and independent C++ replays agree; coordinate/relabel invariance and mutations pass; R6 sharpens T1 to `|A|≤q`; “perfect matching” was corrected to five-edge near-perfect matching. |
| **C107 [REPORTED 2026-07-13; shared aggregate pending]** | Formalize T1 in `EvaluationDichotomy.lean`, including the dimension-sensitive avoidance count, then dual/Veronese closure. | Warning-free focused build, all mathematical targets, and axiom audit pass. The shared aggregate rerun remains deferred while the unrelated generated Q25 leaf sequence builds. |
| **C108 [REPORTED 2026-07-13]** | Formalize the thin T2 semantic bridge and coding restatement of the prescribed-hole defect theorem in `SyndromeGeometry.lean` and `CodingBridge.lean`. | Arc, syndrome-distance and exact affine leader counts, confined distance-three locus, leader moments/defect, general conflict-hypergraph extensions, and the arc-confined graph/maximal-completion specialization are kernel-checked without importing this spinoff into existing consumers. |
| **C109 [REPORTED 2026-07-13]** | Formalize T3 in downstream `Q11Coding.lean`. | Non-GRS `[6,3,4]₁₁` code, exact covering radius/deep-hole locus, syndrome/leader distributions, tangent-antipode matchings, and complete extension spectrum build under strict trust; no abstract `A5` library is required. |
| **C110 [IN PROGRESS; SHARED AGGREGATE ONLY]** | Complete the rigorous novelty/citation audit, adversarial proof review, consumer review, and publication synchronization. | Claim ledger uses safe wording and primary citations; independent Python/C++ replay and mutations pass; paper/PDF, proof audit, Lean TRUST, `papers-index.md`, and projective-cap consumer note are synchronized; two hostile-review rounds, the post-audit actual-leader and affine-distance/conic bridges, final source checklist, focused rebuild, axiom audit, and PDF rebuild pass. Only the shared aggregate rerun remains. |
| **C188 [QUEUED 2026-07-15]** | Import C187's `q=5` four-frame witness and derive `rho_C(5)=L_2(5)=4`; cite the broader small-`k` classification without migrating it. | Relative-conic semantic theorem and `Results` entry pass strict-kernel checks; manuscript, result table, proof audit, TRUST manifest, and paper index are synchronized. |
| **C201 [QUEUED 2026-07-15]** | Derive the symbolic form of the q=16 quadratic-rank obstruction, test q=64, and classify equality/first-excess orbits in the bounded cells. | Either an infinite even-field theorem route or a precise obstruction failure, with independently replayable orbit/rank evidence. |

## Cheap refutation gates

Run these in C106 before substantial T3 proof engineering.

| Gate | Required check | Failure response |
|---|---|---|
| **R0 — source regeneration** | Recompute the stabilizer, point orbits, secant indices, quadratic rank, syndrome distances, leader multiplicities, extension columns, and extension graph from the certified coordinates. | Block every affected statement until the discrepancy is resolved. |
| **R1 — coordinate invariance** | Repeat after a nontrivial projective transform and independent relabelling of both arc and conic parameters. | Treat any failure as a representation artifact. |
| **R2 — independent implementation** | Reproduce the group and code calculations with a separately written implementation or GAP/Sage, not shared helper code. | Do not freeze a certificate from agreeing variants of one implementation. |
| **R3 — negative controls** | Perturb a witness coordinate and generator/table entry; the exceptional symmetry, orbit, and extension assertions should break. | If they persist, strengthen the characterization or identify the genuinely generic theorem. |
| **R4 — syndrome enumeration** | Enumerate all 133 projective syndrome directions and all 1331 affine syndromes independently; reproduce the claimed projective and affine distributions. | Reframe or reject the coding statement. |
| **R5 — extension exhaustiveness** | Check every projective column: exactly the 12 conic directions extend singly, and pair compatibility is exactly the icosahedral nonedge relation. | Reject the claimed exact extension complex. |
| **R6 — T1 boundary search** | Exhaustively test small finite spaces through `|A|=q`, and verify the sharp `q+1`-hyperplane cover of `F_q²`. | Correct the hypotheses before Lean formalization. |

All certificate-generation scripts must record command, source hash, output hash, and an independent
semantic cross-check in the companion archive. Small finite proof data may be generated, but the
Lean checker must remain visibly simpler than the generator.

## Lean attack order

1. **C106 statement freeze.** Run R0–R6 and record exact representatives, generators, orbit tables,
   and counterexamples at sharp hypothesis boundaries.
2. **C107 reusable algebra.** Prove the kernel-form union bound. Add the annihilator/span theorem
   only after the core statement builds, then specialize to evaluation and Veronese closure.
3. **C108 geometric semantics.** Define support-bounded syndrome representation and prove the
   arc/secant/uncovered trichotomy. Derive MDS parameters and extension language afterward.
4. **C109 finite structure.** Reuse `Q11Residual` to check the code distributions, tangent-antipode
   matching relation, and exact independence/extension spectrum. Keep the computed 60-element
   stabilizer as provenance and classical interpretation, not a formalization dependency.
5. **C110 review and publication.** Perform novelty collision searches and citation chasing in
   parallel with C107–C109, but decide claim wording only after the Lean statements stabilize.

C107 and C108 may proceed independently once their C106 subgates pass. C109 remains gated by the
full q11 refutation suite and the early exact-object literature search.

## Novelty-search strategy

Maintain a claim matrix with columns: exact proposed claim, nearest source, exact overlap,
distinction that remains, proof status, and safe manuscript wording. Search primary literature and
follow both backward references and forward citations.

1. **Coding/deep-hole stream:** non-GRS `[6,3,4]₁₁` MDS codes; projective syndromes and deep holes;
   conic syndrome sets; covering-radius-three MDS codes; one-column and simultaneous MDS
   extensions; extension graphs/complexes; refined coset-leader distributions. Begin with
   Kaipa, Zhang–Wan–Kaipa, and current non-GRS MDS/deep-hole construction literature.
2. **Finite-geometry/group stream:** six-arcs in `PG(2,11)`; `A5 < PSL(2,11)` on the conic;
   icosahedral chord systems; exterior sets; arc stabilizer/orbit classifications; Witt-design and
   `M12` constructions.
3. **Evaluation/Veronese stream:** finite vector spaces covered by hyperplanes; blocking-set duals;
   evaluation matroid closure; Veronese and projective Reed–Muller codes. Expect the hyperplane
   lemma to be classical; audit novelty of the exact avoidance equivalence and this application.
4. **Secondary application stream:** independent domination in collinear-triple hypergraphs,
   line-arrangement/net interpretations of the matching equality case, and higher-moment/coherent-
   configuration refinements. These do not enter the paper without a proved statement and a
   separate collision search.

Novelty verdicts are: **known**, **known components/new synthesis candidate**, or **no exact match
located**. Never convert the third verdict into a priority claim without an external specialist
bibliographic check. If the exact q11 object is already classified, retain only the checked
reconstruction and genuinely additional syndrome/extension invariants.

### Current novelty posture after C106

| Claim family | Verdict | Nearest located source / safe use |
|---|---|---|
| At most `q` proper hyperplanes do not cover an `F_q`-space; `q+1` is sharp | **Known** | Classical finite-vector-space covering result; cite the covering literature (including Jamison) and present only the evaluation/Veronese specialization. |
| Arc ↔ codimension-three MDS code; secant index ↔ coset weight/leader count | **Known** | Davydov–Marcugini–Pambianco treats `[n,n-3,4]_q` cosets from plane arcs and explicitly gives the `binom(n,3)` farthest-coset leader count in Theorem 4.6; Kaipa supplies the deep-hole/MDS-extension formulation for Reed–Solomon codes. |
| Six-point `A5` orbit and the `6,10,12,15,30/60` orbit structure | **Known** | This is the classical **Clebsch hexagon**; its ten points on three bisecants are the Brianchon-point `A5` ten-arc. Brouwer's notes and the classical `A5` literature supply the wider orbit structure. |
| Prescribed-hole defect as an exact leader-collision identity for conic-confined distance-three syndromes | **Known dictionary / synthesis candidate** | Davydov–Marcugini–Pambianco supply the general secant/coset dictionary; no exact coding restatement of this paper's prescribed-hole identity or lower bound was located in the bounded search. |
| This witness has conic distance-three syndrome/extension locus, exact refined coset counts, and extension polynomial `1+12t+36t²+20t³` | **Known components / synthesis candidate** | No exact conjunction located in the bounded search. State only the checked synthesis unless C110's citation chasing finds an exact predecessor. |
| Six witness-coloured five-edge chord matchings | **Classical-looking consequence** | Treat as an incidence description of the icosahedral action, not a novelty claim. |

## Discovery Track register

Append and reclassify only incidental mathematical consequences here as they are noticed while
executing C107–C110, following the earlier arcs-formalization handoff pattern. Planned theorem
deliverables and their completion state belong in the work-package table, not here. Each discovery
records its current proof tier, novelty posture, and intended disposition. “Candidate-new” means
only that no exact collision has yet been located; promotion requires C110's proof audit and
specialist-quality citation chase.

- **Incidental Lean-proved strengthening:** for `m` distinct hyperplanes in rank `r≥2`, anchoring one
  member and using its codimension-two intersection with every other member gives the
  dimension-sensitive subtraction-form lower bound and the factored formula
  `(q-1)q^(r-2)(q+1-m)` for `m≤q`. Selected subfamilies of the explicit `q+1` plane cover attain
  the anchored count exactly, providing the rank-two equality model. This is a reusable finite-
  geometry strengthening; novelty posture remains classical/known.
- **Incidental Lean-proved semantic correction:** general simultaneous column extensions require a
  pair/triple conflict hypergraph. When the confined extension locus is itself an arc, triple
  conflicts vanish and complete superarcs are exactly maximal independent sets of the residual
  pair-conflict graph.
- **Incidental candidate-new paper-level synthesis:** reinterpret the prescribed-hole defect identity as an
  exact weight-two-leader collision identity for projective codimension-three MDS codes, carrying
  the paper's additive lower bound to codes with conic-confined distance-three syndrome locus.
- **Incidental Lean-proved finite strengthening:** the q11 extension complex has polynomial
  `1+12t+36t²+20t³`; the fixed seed has exactly six complete eight-arc and twenty complete nine-arc
  superarcs, and no ten-arc superarc. `Q11Coding.extension_independence_spectrum` and
  `maximal_extension_spectrum` kernel-check the complete classification.
- **Incidental prior-art identification, not novelty:** the q11 seed is the Clebsch hexagon; its ten
  triple-secant points are the classical Brianchon-point `A5` ten-arc, known complete over q11.
- **Incidental Lean-proved structural corollary:** each of the six witness-coloured chord classes is
  a five-edge near-perfect matching, the six classes are disjoint and partition the 30 residual
  edges, and each misses an antipodal pair. Adding the six antipodal edges therefore gives a
  one-factorization of the icosahedron plus its antipodal matching. The finite incidence statement
  is checked; treat its interpretation as classical-looking until searched directly.
- **Incidental reusable radius certificate:** in a rank-three parity-check system, three-column
  independence gives a weight-at-most-three representative of every syndrome, while avoidance of
  every two-column affine span gives a distance-at-least-three witness. Together these two small
  certificates prove covering radius exactly three without enumerating all words. The generic
  implications are Lean-proved in `CodingBridge.every_syndrome_has_weight_le_three` and
  `syndromeDistanceAtLeast_three_of_pair_avoidance`; novelty posture is elementary/known.
- **Incidental prior-art collision found during proof audit:** the exact `binom(k,3)` count for
  every distance-three affine syndrome is stated explicitly for farthest MDS cosets by
  Davydov–Marcugini–Pambianco, Theorem 4.6. Keep the Lean theorem as an independent formal proof,
  but make no novelty claim for the count.
- **Incidental structural observation:** nonzero scalar multiplication preserves affine syndrome
  distance and every minimum-leader multiplicity, and acts freely on each projective syndrome
  direction. Thus every refined nonzero affine-coset count is divisible by `q-1` and is determined
  entirely by the projective index spectrum. For q11 this explains the factor ten in both refined
  distributions; the observation is elementary/known and is used only as a structural bridge.
- **Incidental statement-adequacy repair, now Lean-proved:** the affine ray map is a bijection from
  133 projective directions times ten nonzero scalars onto all 1330 nonzero syndromes;
  `mem_affineSyndromesOfDistance_iff` characterizes the counted sets by actual parity-check
  distance. For distance two, `syndromeLeaderSupports_two_eq_raw` identifies the determinant
  pairs with supports of actual coefficient words and `distance_two_leader_distribution` counts
  the resulting semantic finsets. This closes the hostile-review gap in the original arithmetic
  rescaling proof; it is a rigor upgrade, not a novelty claim.
- **Incidental reusable maximality correction, now Lean-proved:**
  `completeOutside_empty_of_maximalExtensionIn_full` separates maximality inside an allowed set
  from ordinary completeness and supplies the latter exactly when the allowed set is the full
  one-point extension locus. `maximal_independent_extension_complete` verifies that hypothesis for
  every q11 maximal residual set, so all six eight-arcs and twenty nine-arcs are genuinely ordinary
  complete arcs.
- **Incidental prior-art collision:** the q11 condition that all witness secants miss the conic
  places the coordinates in the classical complete-exterior-set literature; cite
  Blokhuis--Seress--Wilbrink (1992) and keep that condition distinct from prescribed-hole
  completeness.
- **Incidental portfolio connection (not a new arcs-paper theorem):** the conic continuation
  conflict graph is read as an independence complex here, as a reconstruction/symmetry object in
  the continuation track, and as a Node--Kayles/pairing-game board in the game tracks. Graph
  isomorphism therefore transports the extension polynomial and normal-play value; ambient
  semilinear reconstruction would further identify these as projective invariants.
- **Incidental portfolio connection (not yet instantiated across papers):** completion distance,
  repair tolerance, and arc-insertion resilience are instances of the same obstruction-family
  transversal invariant `δ=τ`. Audit twisted-cubic claims across the completion and coding
  manuscripts before either uses "transversal spectrum" as a flagship novelty phrase.
- **Incidental polyhedral-game instance:** the q11 icosahedron is the nonregular 12-point
  `A₅` action on `P¹(11)`, providing a certified instance of the dihedral paper's deferred
  polyhedral-action program. Cross-cite it there; do not enlarge this paper's theorem claims.
- **Incidental common-object observation:** an off-conic point simultaneously determines its
  secant index against an arc and the conic involution used by the dihedral/Schreier analysis.
  This is the object-level bridge behind the otherwise technique-separated tracks and is a
  candidate umbrella-survey remark, not a proved strengthening here.
- **Incidental parked research direction:** degree-`d` Veronese features suggest MDS codes whose distance-three
  syndrome locus is confined to a prescribed algebraic variety. Do not enlarge C107–C110 without a
  separate theorem and novelty gate.
- **Incidental statement-adequacy repair:** the affine code computation and the incidence-defined
  conic locus are now joined by `affine_distanceThree_iff_mem_standardConic`, which states directly
  that every nonzero affine syndrome has actual distance three exactly when its projective quotient
  lies on the standard conic. This was the sole material gap found by the second hostile review.

## Trust, adversarial, and publication gate

- No `sorry`, `native_decide`, `admit`, paper-specific axiom, or unproved semantic bridge.
- Print and record axioms for every public theorem. Unconditional targets should use only accepted
  Mathlib foundations.
- Build focused leaves before aggregates, especially around generated finite data; never trigger a
  missing heavy import closure with a raw aggregate build.
- Regenerate finite data and compare hashes, then run at least one mutation round against the Lean
  checker and one independent mathematical review of the theorem hypotheses.
- Keep universal theorems, checked finite facts, computed exploratory evidence, and novelty claims
  in visibly distinct trust tiers.
- Update both manuscript sources and rendered PDF, the proof audit, `lean/RelativeConicArcs/TRUST.md`,
  top-level `lean/TRUST.md` if its manifest changes, and the table of results in
  `papers/papers-index.md`.
- Review T2/T3 against C84 and C100. Record only an actual new consumer theorem or a scoped negative
  relevance verdict in the projective-cap handoff.
- At closure, revisit the discovery ledger and classify every noticed corollary, cheap extension,
  surprise, implication, application, or speculative novel direction. Move a completed live
  handoff to `notes/handoffs/done/`.

## Packaging gate

- T1 and a concise T2 dictionary belong in the main paper if proved.
- Add the coding restatement of the central defect theorem and its length consequence to the main
  paper if C108 remains concise.
- Add the q11 code parameters, exact distributions, extension polynomial, and classical Clebsch
  identification as a compact example; do not create a companion paper unless later results grow
  beyond that scope.

## Next step

Rerun the top-level `RelativeConicArcs` aggregate once the concurrent Q25 leaf builder has
completed. Then archive this live handoff and close C107/C110.

## 2026-07-16 aggregate-tail closure

The guarded queue run
`lean/scripts/lean-build-queue.py run RelativeConicArcs --profile single --threads 1 --cores 20-23`
passed the target in 21.04 seconds at 3,706,712 KiB maximum RSS, then passed the trace-only aggregate
gate. The disk-backed run record is
`/home/tavis/.cache/othello-lean-build/run-20260716-164912-721cc9b2`. This closes the remaining C107
and C110 aggregate tails; both rows were removed from the live queue.
