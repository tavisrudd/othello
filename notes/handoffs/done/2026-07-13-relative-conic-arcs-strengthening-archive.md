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
