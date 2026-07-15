# C185 — Complete decoding corollaries for the Clebsch code

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **CHECKER AND LEAN SYNTHESIS REPORTED; MANUSCRIPT DECISION OPEN.**

## Exact result

For the displayed `[6,3,4]_{11}` code with parity-check columns `A`, exhaustive independent
enumeration of all coefficient-bearing errors of weights one, two, and three proves the complete
syndrome-distance oracle

```text
s = 0                                      -> distance 0
[s] is one of the six columns of A         -> distance 1
s != 0 and s0*s2 - s1^2 = 0               -> distance 3
otherwise                                  -> distance 2.
```

The `1330` nonzero cosets split by distance as

```text
distance 1:   60
distance 2: 1150
distance 3:  120.
```

Their complete nearest-codeword multiplicity distribution is

```text
one nearest word:      960 cosets
two nearest words:     150 cosets
three nearest words:   100 cosets
twenty nearest words:  120 cosets.
```

For a distance-two syndrome, the number of nearest words is exactly the secant index of its
projective direction. The projective census is `n0=12, n1=90, n2=15, n3=10`; scalar multiplication
by the ten nonzero field elements therefore gives the distance-two multiplicities
`900·1 + 150·2 + 100·3`. Every distance-three syndrome has one leader on each of the twenty
three-subsets of the six coordinates.

The ten secant-index-three directions are exactly the ten Brianchon directions. At each such
direction the three weight-two leader supports are pairwise disjoint and form a perfect matching
of the six coordinates. These ten matchings are exactly the complement of the invariant
five-matching synthematic total among all fifteen perfect matchings.

## Precise equivariant-decoder statement

Let `G = MAut(C)` be the `600`-element monomial automorphism group, acting on error words and on
their affine syndrome vectors. For a deep-hole syndrome `s`, let `L(s)` be its set of twenty
minimum-weight leaders. An equivariant set-valued decoder is a function `D` on the `120` nonzero
deep-hole syndromes such that

```text
empty != D(s) subset L(s),     D(g*s) = g*D(s)  for all g in G.
```

The stabilizer in `G` of one **affine syndrome vector** has order five and has four orbits of size
five on `L(s)`. Consequently every nonempty equivariant returned list has size at least five.
This is attained: each stabilizer orbit transports consistently to all `120` deep-hole syndromes,
giving four distinct full-monomial-equivariant decoders of constant list size five.

The projective `A5` support action has two ten-element orbits on the twenty triples, interchanged
by complementation. Their coefficient-bearing lifts give two full-monomial-equivariant list-size-ten
decoders; each is the union of two of the size-five decoders. The two chirality classes are an
unordered pair: no preferred orientation is asserted. In particular, chirality is a natural
`20 -> 10` halving but is not the coarsest equivariant selection.

The distinction between projective and affine actions is load-bearing. A projective direction
stabilizer alone does not prove a claim about a fixed affine syndrome. The checker separately verifies
the `60` projective support permutations, the `600` coefficient-bearing monomial automorphisms, and
the order-five affine-syndrome stabilizer.

## Durable checker

The hardened checker is

```text
papers/clebsch-hexagon-code/check_decoding.py
```

Its geometry, secant-index census, distance table, and coefficient-bearing leader enumeration are
independent direct replays. For symmetry it imports the exact projective-lift construction from
`check_code_automorphisms.py` and the word-action primitives from `check_chirality.py`. It does not
broaden the latter's claims: it rechecks the same `1,440,000` coefficient-equivariance cases and then
checks `288,000` cases for the four transported size-five decoders. The script is standard-library
only apart from those two sibling checker modules, and every printed headline follows a fail-closed
assertion.

Validation command:

```text
cd papers/clebsch-hexagon-code
/usr/bin/time -f 'elapsed=%e max_rss_kib=%M' python3 check_decoding.py
```

It exited zero with

```text
field=F_11
projective_points=133
secants=15
secant_index_spectrum=[n0:12,n1:90,n2:15,n3:10]
uncovered_directions=standard_conic_12
brianchon_directions=10
nonzero_coset_distance_distribution=[d1:60,d2:1150,d3:120]
syndrome_distance_oracle=[zero:0,arc_ray:1,conic_ray:3,otherwise:2]
nearest_word_ambiguity_distribution=[1:960,2:150,3:100,20:120]
distance_two_leader_count=secant_index
deep_hole_supports=all_20_triples
triple_ambiguity_matchings=10
triple_ambiguity_matchings=complement_of_one_synthematic_total
projective_support_group_order=60
projective_support_group=A5
projective_A5_triple_orbits=[10,10]
complement_swaps_projective_triple_orbits=True
monomial_automorphism_group_order=600
monomial_support_image=projective_A5
coefficient_equivariance_checks=1440000
chirality_decoder_list_sizes=[10,10]
chirality_decoders_full_monomial_equivariant=True
chirality_orientation_preferred=False
affine_deep_hole_syndrome_stabilizer_order=5
affine_stabilizer_leader_orbit_sizes=[5,5,5,5]
affine_stabilizer_orbits_per_chirality=[2,2]
minimum_nonempty_equivariant_list_size_at_deep_hole=5
size_five_full_monomial_equivariant_decoders=4
minimal_decoder_equivariance_checks=288000
all assertions passed
elapsed=7.82 max_rss_kib=17400
```

Source identity for that run:

- SHA-256: `24f42397f4e2b7e32109d44fc2caeb6ec1991476c3bffc6143d61f8364305cb6`;
- prospective Git blob: `d021423287d721f55755bca3769522c093439701`.

The blob is recorded as prospective until the root lane stages the new checker explicitly.

## Lean coverage map

`RelativeConicArcs/Q11DecodingSynthesis.lean` now packages items 1--4 below. A narrow direct
elaboration passed on 2026-07-15; every displayed theorem reports only `propext`,
`Classical.choice`, and `Quot.sound`. The substantial projective/monomial action layer in item 5
remains separate and open.

All referenced theorems below live in namespace `RelativeConicArcs.Examples.Q11Coding`, except the
new Brianchon module, whose namespace is
`RelativeConicArcs.Examples.Q11BrianchonPetersen`.

| Checked proposition | Existing Lean theorem(s) | Coverage |
|---|---|---|
| The columns define a `[6,3,4]_{11}` MDS code | `witness_mds_columns`, `witness_code_minimum_distance_four` in `Q11Coding` | Complete |
| The distance-three projective locus is the standard conic | `projective_distanceThreeDirections_eq_standardConic` in `Q11Coding`; `affine_distanceThree_iff_mem_standardConic` in `Q11SemanticSynthesis` | Complete |
| Exact distance of every nonzero canonical/affine-ray syndrome | `canonical_syndromeDistance_exact`, `affineRay_syndromeDistance_exact` in `Q11SemanticSynthesis` | Complete, but the four-branch oracle is not packaged as one theorem |
| Nonzero coset-distance counts `60,1150,120` | `affine_coset_distance_distribution` in `Q11SemanticDistribution` | Complete |
| Distance-two leader count equals secant index | `syndromeLeaderSupports_two_eq_raw`, `canonical_weightTwo_leader_count`, `affineRay_weightTwo_leader_count` in `Q11SemanticLeaders` | Complete |
| Distance-two multiplicity counts `900,150,100` | `distance_two_leader_distribution` in `Q11SemanticLeaders` | Complete |
| Every deep hole has all twenty triple supports | `conicZero_weightThree_leader_count` in `Q11Coding` proves count twenty at one displayed syndrome | Partial: all syndromes and equality of the support set with all triples need a named synthesis lemma |
| Ten Brianchon concurrences and complement of the invariant total | `brianchon_concurrences`, `brianchon_matchings_are_complement`, `disjoint_chord_intersection_ledger` in `Q11BrianchonPetersen` | Complete geometrically/combinatorially |
| Triple-ambiguity leader supports equal the ten Brianchon matchings | Combine `syndromeLeaderSupports_two_eq_raw` with the Brianchon theorems | Missing explicit bridge between the two concrete tables |
| Full ambiguity distribution `960,150,100,120` | Follows from the existing distance distributions, weight-two distribution, and a uniform deep-hole twenty-leader theorem | Missing one synthesis theorem; one prerequisite is still partial |
| Projective `A5` has two triple orbits `10+10` | No Lean projective-support group action | Missing |
| Full `MAut(C)` coefficient equivariance and chirality decoders | No Lean monomial action on words/syndromes | Missing |
| Affine deep-hole stabilizer has four five-element leader orbits; four global size-five decoders attain the lower bound | No Lean stabilizer/orbit infrastructure | Missing |

## Synthesis status, in EV order

1. **Done:** package the already-certified distance facts as one total syndrome oracle, including
   `s=0` and the distance-one column-ray branch.
2. **Done:** prove that every distance-three syndrome has leader-support set exactly
   `(Finset.univ : Finset (Fin 6)).powersetCard 3`; derive the uniform count twenty.
3. **Done:** combine that result with `distance_two_leader_distribution` and the weight-one branch to state
   the complete ambiguity enumerator `1^960 2^150 3^100 20^120`.
4. **Done:** bridge `rawLeaderSupports` at secant index three to the ten concrete
   `brianchonMatching` values.
5. Build the `60` projective lifts and `600` monomial actions in Lean, then certify the two
   chirality orbits, the order-five affine-syndrome stabilizer, its `5+5+5+5` leader orbits, and the
   four transported minimal decoders.

Items 1--4 are finite synthesis over existing certified data. Item 5 is the substantial missing
infrastructure already identified by the chirality lane; it should not be disguised as a final
`decide` after the group action has been assumed.

No Lean process was run for C185, and the manuscript was not edited.
