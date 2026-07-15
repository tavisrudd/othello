# Cheap upgrades and reader questions — Clebsch and hexad lanes

**Date**: 2026-07-14
**Scope**: answer to the user-directed pre-implementation question: which free or cheapish upgrades
and natural reader questions have a realistic proof/computation path? This is a diagnostic report,
not a certification artifact. Every finite result below must be reproduced by the Git-tracked
checker owned by its C item before a manuscript cites it.

## Executive recommendation

Six follow-ups clear the value/cost bar. Four strengthen or clarify the Clebsch paper without adding
a new spine; two belong to the separate gem-mining lane. The natural higher-`k`, exceptional-group,
moonshine, dual-code, ten-arc, and Klein expansions do not clear the bar for the current papers.

| ID | Lane | Upgrade/question | Value | Cost/status |
|---|---|---|---|---|
| C170 | `clebsch` | close unconditional uniqueness over every prime power `q≤14` | very high | diagnostic sweep complete; tracked checker/proof needed |
| C171 | `clebsch` | replace the false global gap gloss by a PGL-invariant conic-distance spectrum; explain local multiplicities by `A₅` orbits | high | local orbit table computed; global distance open but finite |
| C172 | `clebsch` | state the monomial code classification and transitivity on actual deep holes; expose the full leader profile | high | mostly formal consequences of existing Lean facts; exact group extension to pin |
| C173 | `clebsch` | relate Dye's five triangles to the Petersen/chirality ten-set | medium-high | standard `A₅` action suggests an equivariant proof; explicit map/check needed |
| C174 | `gem-mining` | promote `t+|U|=82` to the general six-subset identity | high | one-paragraph proof; diagnostics at q=7,11,13 pass |
| C175 | `gem-mining` | determine which finite fields admit a concurrency-free conic six-set | medium | separate census/theorem question; do not expand C155 without a result |

## C170 — unconditional `q=11` uniqueness is within reach

The manuscript currently proves only: a six-arc with deep-hole locus exactly a conic has `q≤14`,
and under an icosahedral-stabilizer hypothesis it has `q=11`. A reader will immediately ask whether
the non-`A₅` cases inside the finite range actually occur.

The prime powers at most fourteen are `2,3,4,5,7,8,9,11,13`. There is no six-arc at `q=2,3`; at
`q=4,5`, a six-arc is maximal and complete, so its uncovered locus is empty. An independent
four-frame sweep of every six-arc representative in the remaining fields produced:

```text
q 7  reps 70   |U| histogram {0:40, 2:30}
     candidates with |U|=q+1 and U contained in a conic: 0
q 8  reps 195  |U| histogram {0:45, 4:150}
     candidates with |U|=q+1 and U contained in a conic: 0
q 9  reps 441  |U| histogram {0:6, 4:15, 6:120, 7:120, 8:180}
     candidates with |U|=q+1 and U contained in a conic: 0
q 13 reps 4015 |U| histogram {36:85, 38:210, 39:480, 40:1080, 41:1800, 42:360}
     candidates with |U|=q+1 and U contained in a conic: 0
```

The enumeration uses the same exhaustive normalization as the q=11 rigidity proof: any six-arc has
four points forming a projective frame, so normalizing them and sweeping the remaining unordered
pair meets every projective class. Prime fields use direct modular arithmetic; q=8 and q=9 use the
same field encodings/tables as `RelativeConicArcs.FiniteFields` and the tracked q=9 checker.

**Candidate strengthened theorem.** Among all prime powers, `q=11` is the unique field admitting a
six-arc in `PG(2,q)` whose projective distance-three syndrome locus is exactly the rational point set
of a nonsingular conic.

This is not certified until C170 ships and replays a standalone tracked checker, including the
exhaustiveness statement and exact field implementations. If it survives, C166's conditional
icosahedral theorem becomes a conceptual proof for the symmetric subfamily, while C170 closes the
unconditional finite residue.

## C171 — a true global gap and a structural local spectrum

The current local perturbation calculation compares each one-point neighbour's `U(A')` with the
fixed Clebsch conic. It does not define a PGL-invariant distance to the phenomenon. The natural
global invariant is

```text
δ(A) = min_Q |U(A) △ Q(F_11)|,
```

where `Q` ranges over nonsingular conics. It is PGL-invariant and satisfies `δ(A)=0` exactly on the
Clebsch class by rigidity. Computing its exact next value over the remaining fourteen six-arc
classes would give the paper a genuine global gap theorem and remove the need for the false
“nearest other embedded six-arc” gloss. The calculation is small with conic/point sets represented
as bitsets; it must report both class representatives and witnesses attaining the minimum.

The already-correct 252-neighbour histogram also has a nearly free structural refinement. Acting on
legal moves `(deleted vertex, inserted point)`, the concrete `A₅` stabilizer has eight orbits, and
the symmetric-difference value is constant on each:

```text
|U(A') △ C|, orbit size
(18,30), (19,60), (20,30), (20,30), (20,30),
(22,12), (22,30), (24,30)
aggregate: {18:30, 19:60, 20:90, 22:42, 24:30}
```

C171 should put this orbit table in the C165 checker/report rather than leave unexplained raw
multiplicities.

## C172 — translate the geometry back to codes and actual words

The rigidity theorem is stated for parity-check arcs, but PGL-equivalent parity-check arcs give
monomially equivalent codes. Thus a free coding corollary is available: the conic-locus condition
selects one monomial-equivalence class of `[6,3,4]_11` codes. This is the appropriate coding-level
form of the classification.

The exact automorphism statement should be pinned at the same time. The monomial automorphism group
maps to the order-60 projective arc stabilizer, and its kernel consists of the ten global nonzero
coordinate scalars; C172 must determine and state the exact extension rather than guess a split.
Regardless of the splitting, the scalar kernel is transitive along each nonzero syndrome ray and
`A₅` is transitive on the twelve conic directions. Hence the expected consequence is:

- all 120 deep-hole affine syndromes/cosets form one monomial-automorphism orbit;
- after adjoining translations by codewords, all `120·1331=159720` received-word deep holes form
  one orbit under the natural Hamming-space automorphism group preserving the code.

This is a stronger correct replacement for the draft's dimensional shorthand “the complete set of
deep holes is a conic.”

The complete leader profile is already kernel-checked and can be stated at essentially zero proof
cost if it helps the exposition:

| coset distance | cosets by minimum-leader multiplicity |
|---:|---|
| 0 | 1 coset with 1 leader |
| 1 | 60 cosets with 1 leader |
| 2 | 900 with 1, 150 with 2, 100 with 3 |
| 3 | 120 with 20 |

Sources: `Q11SemanticDistribution.affine_coset_distance_distribution`,
`Q11SemanticLeaders.distance_two_leader_distribution`, and
`Q11Coding.conicZero_weightThree_leader_count`.

## C173 — answer the five-triangles question conceptually

The manuscript asks whether Dye's five self-polar triangles index a natural code decomposition. The
known negative must be respected: the ten objects do not admit an `A₅`-invariant partition into five
pairs. But there is a better candidate statement.

The ten complementary pairs of three-subset supports carry the standard primitive ten-point action
of `A₅`, equivalently its action on the two-subsets of a five-set; the resulting graph is Petersen.
Dye's five triangles carry the natural five-point action. C173 should construct and verify an
explicit equivariant bijection

```text
{complementary support pairs}  ≃  {unordered pairs of Dye triangles}.
```

If it exists, each unordered pair of triangles indexes one complementary support pair, and each
chirality class chooses one orientation from every pair. That explains the Petersen graph and the
`10+10` split without inventing the refuted five-pair decomposition. If no canonical geometric map
exists beyond the abstract `A₅`-set isomorphism, the manuscript should delete the open question
rather than advertise unsupported structure.

## C174 — the `82` identity is a general theorem

Let `H` be any six-subset of a nonsingular conic in `PG(2,q)`, let `U(H)` be the points off `H` and
off all fifteen chords, and let `t(H)` count concurrent triples of chords, including the forced
`6·C(5,3)=60` triples at the six vertices. If `c` counts accidental concurrent perfect matchings,
then no off-conic point lies on more than three chords and

```text
t(H) = 60 + c.
```

Writing `a,b,c` for off-conic points on exactly one, two, three chords gives

```text
a + 2b + 3c = 15(q-1),
b + 3c = C(15,2) - 6 C(5,2) = 45.
```

Thus the covered off-conic point count is `15q-60+c`, the uncovered off-conic count is
`q²-15q+60-c`, and the conic contributes `q-5` further points outside `H`. Therefore

```text
t(H) + |U(H)| = q² - 14q + 115.
```

At q=11 this is `82`. Diagnostic exhaustive checks give:

```text
q=7:  constant 66, pairs {(64,2):28}
q=11: constant 82, pairs {(60,22):264,(62,20):330,(63,19):220,(64,18):110}
q=13: constant 102, pairs {(61,41):2184,(62,40):546,(64,38):182,(66,36):91}
```

The identity is a family-level contribution adjacent to BDMP's printed `w=5` calculation. The
Mathieu statement remains the q=11 specialization: the hexads are exactly the six-sets with `c=0`,
equivalently maximal `|U|=22`.

## C175 — the finite-field no-concurrency question

The general identity leaves a clean reader question: for which prime powers q does a six-subset of
`P¹(F_q)` exist with `c=0`, i.e. none of its fifteen perfect-matchings has concurrent chords? The
first diagnostics are nonmonotone: q=11 has 264 such sets, while q=13 has none; over infinite fields
the condition is generic. C175 should first build a small-q orbit/census map, then look for a finite
field existence argument or obstruction. It is a separate gem-mining item, not a reason to enlarge
C155 before a theorem appears.

## Deliberate non-queues

- The higher-`k` named-variety question has no candidate after C123 killed the natural dual-variety
  proposal; it is not cheap.
- Valentiner/27-line/other exceptional-group probes already failed their first tests and would add a
  second research program, not strengthen this paper.
- The dual code, ten-arc foil, Klein reduction, and moonshine/Hauptmodul suggestions are decorative
  or speculative. C167 should prune them rather than promote them as upgrades.
- A full self-duality or decoding/statistical application is not implied by the current data; the
  unsupported learning aside should still be removed.

## Trust boundary

The diagnostics in this report were run independently from the manuscript scripts and agree with
the already-reported q=11 values. They were inline exploratory computations, not Git-tracked
artifacts. C170, C171, C174, and C175 must each ship a standalone tracked checker before reporting a
finite claim. C172 and C173 must cite their exact Lean/script evidence and may not rely on the
session-only C121/C124 scratch files.
