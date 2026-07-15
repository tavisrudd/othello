# C176 — Brianchon/Petersen dictionary certificate

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Exact checker, manuscript proposition, queue, and handoff integration
are complete.

## Result

Let the five matchings in the unique invariant synthematic total be

```text
T0 = 01|23|45    T1 = 02|14|35    T2 = 03|15|24
T3 = 04|13|25    T4 = 05|12|34.
```

For each unordered pair `{Ti,Tj}`, their union is an alternating six-cycle. Its distance-three
edges form a unique antipodal perfect matching. Exact enumeration proves that the resulting ten
matchings are distinct and are exactly the complement of `{T0,...,T4}` among all fifteen perfect
matchings on the six vertices.

Interpret each antipodal pair `ab` as the chord through displayed Clebsch vertices `a,b`. The
three chords in every antipodal matching concur over `F_11`, giving ten distinct projective points.
With projective coordinates normalized so the first nonzero coordinate is `1`, the complete
triangle-pair → antipodal-matching → complementary-support-pair → concurrence-point dictionary is:

```text
T0T1  05|13|24  034|125  (1,3,3)
T0T2  04|12|35  025|134  (1,7,10)
T0T3  02|15|34  035|124  (1,5,4)
T0T4  03|14|25  024|135  (1,5,7)
T1T2  01|25|34  045|123  (1,3,7)
T1T3  03|12|45  015|234  (1,0,3)
T1T4  04|15|23  013|245  (1,6,6)
T2T3  05|14|23  012|345  (1,0,9)
T2T4  02|13|45  014|235  (1,7,9)
T3T4  01|24|35  023|145  (1,6,4)
```

An independent ledger starts from all fifteen chord lines rather than from the ten claimed
concurrences. There are exactly 45 formal intersections of chord pairs with disjoint endpoint sets.
After projective normalization these give exactly ten geometric points of multiplicity three and
fifteen of multiplicity one. The multiplicity-three set is exactly the ten-point set in the table.
Thus no expected Brianchon point is missing, no extra triple concurrence is hidden, and no accidental
double or higher-multiplicity point is being suppressed.

## Equivariance and support compatibility

The checker keeps the two symmetry claims separate at their correct levels:

- For every one of the `120` elements of the abstract normalizer `N_{S6}(A5) ≅ S5` and all ten
  triangle pairs, it verifies equivariance of both the antipodal matching and alternating-cycle
  support pair: `120·10=1200` exact combinatorial cases.
- For every one of the `60` displayed projective `A5` lifts and all ten triangle pairs, it applies
  the exact `3×3` matrix over `F_11` to the concurrence point and obtains the point indexed by the
  transformed triangle pair: `60·10=600` exact geometric cases.
- The same `600` cases independently commute through the already-certified complementary-support
  map. Consequently the triangle-pair, Brianchon-point, and support-pair/Petersen labellings are one
  compatible `A5`-set dictionary.

The distinction matters: the sixty normalizer elements outside `A5` act on the abstract six-label
combinatorics but are not projective automorphisms of the displayed hexagon, so no geometric
`S5`-equivariance claim is made.

## Durable certificate

The implementation extends `papers/clebsch-hexagon-code/check_chirality.py` and preserves every
pre-existing C164/C173 assertion. Its new fail-closed assertions cover:

- uniqueness of the antipode of every vertex in each of the ten alternating six-cycles;
- equality of the ten antipodal matchings with the complement of the invariant total;
- ten exact three-chord concurrences at ten distinct projective points;
- the complete 45-intersection multiplicity ledger `3^10 1^15`;
- equality of the multiplicity-three set with the constructed Brianchon set;
- all `1200` full-normalizer combinatorial equivariance cases;
- all `600` geometric `A5` equivariance cases; and
- all `600` support-pair/Brianchon compatibility cases.

Validation command:

```text
cd papers/clebsch-hexagon-code
/usr/bin/time -f 'elapsed=%e max_rss_kib=%M' python3 check_chirality.py
```

It exited zero. Exact output was:

```text
field=F_11
support_group_order=60
triple_orbit_sizes=[10, 10]
complement_swaps_triple_orbits=True
complementary_pairs=10
petersen_degree=3
petersen_edges=15
petersen_connected=True
petersen_adjacent_common_neighbors=0
petersen_nonadjacent_common_neighbors=1
petersen_strongly_regular_parameters=[10, 3, 0, 1]
petersen_independent_of_orbit_representatives=True
perfect_matchings=15
synthematic_totals=6
A5_invariant_synthematic_totals=1
invariant_synthematic_total_size=5
invariant_synthematic_total_self_polar_for_XZ_eq_Y2=True
triangle_pairs=10
triangle_pair_support_bijection=True
triangle_pair_equivariance_checks=1200
petersen_adjacency=disjoint_triangle_pairs
triangle_pair_antipodal_matchings=10
antipodal_matchings=complement_of_invariant_total
brianchon_points=10
brianchon_chord_concurrences=10
formal_disjoint_chord_intersections=45
disjoint_chord_intersection_multiplicities=[1x15, 3x10]
multiplicity_three_points_equal_brianchon_points=True
brianchon_combinatorial_equivariance_checks=1200
brianchon_geometric_equivariance_checks=600
support_brianchon_compatibility_checks=600
brianchon_dictionary=[T0T1:05|13|24:034|125:(1,3,3); T0T2:04|12|35:025|134:(1,7,10); T0T3:02|15|34:035|124:(1,5,4); T0T4:03|14|25:024|135:(1,5,7); T1T2:01|25|34:045|123:(1,3,7); T1T3:03|12|45:015|234:(1,0,3); T1T4:04|15|23:013|245:(1,6,6); T2T3:05|14|23:012|345:(1,0,9); T2T4:02|13|45:014|235:(1,7,9); T3T4:01|24|35:023|145:(1,6,4)]
normalizer_triangle_action=S5
normalizer_S6_order=120
normalizer_identification=S5
normalizer_outside=60
normalizer_outside_swapping_orbits=60
outside_in_monomial_support_image=0
deep_hole_affine_syndromes=120
leaders_per_syndrome=20
leader_chirality_per_syndrome=[10, 10]
global_syndrome_leader_pairs=2400
global_distinct_leaders=2400
global_chirality_counts=[1200, 1200]
monomial_automorphisms_checked=600
coefficient_equivariance_checks=1440000
leader_monomial_orbits=4
leader_monomial_orbit_sizes=[600, 600, 600, 600]
leader_monomial_orbit_chirality_counts=[[600, 0], [600, 0], [0, 600], [0, 600]]
leader_monomial_stabilizer_orders=[1, 1, 1, 1]
deep_hole_syndrome_stabilizer_order=5
fixed_syndrome_leader_orbit_sizes=[5, 5, 5, 5]
fixed_syndrome_leader_orbits_per_chirality=[2, 2]
translation_codewords=1331
translation_code_is_parity_check_kernel=True
kernel_preservation_checks=798600
received_word_deep_holes=159720
affine_deep_hole_orbit=159720
affine_deep_hole_transitive=True
orientation_preferred=False
all assertions passed
elapsed=6.98 max_rss_kib=43684
```

The manuscript was then rebuilt successfully with Tectonic after adding
Proposition `prop:brianchon-support`; the build completed in two TeX passes and wrote the PDF
without a warning or error.

Source identities for that run:

- Git blob: `3bdfc04ba52260b89dd6f3dfe4f734421433130b`;
- SHA-256: `200cbd604c7e9aa942d1e3b54c372b97c69b8ebcb42220e710d1141131f9cca5`.

`git ls-files --error-unmatch papers/clebsch-hexagon-code/check_chirality.py` exited zero and printed
the path, so the cited checker is Git-tracked. The C176 extension and this report were staged
explicitly with the manuscript sources; no repository-wide staging command was used.
