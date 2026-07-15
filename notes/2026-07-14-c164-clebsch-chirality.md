# C164 — Clebsch support chirality

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Coefficient-aware checker, manuscript citation, Git tracking, PDF build,
and independent post-edit review all passed.

## Correct claim boundary

Let the projective/support `A5` act in its exotic degree-six representation on the 20
three-element coordinate supports. The exact intrinsic structure is:

- the 20 supports form two `A5`-orbits `O+` and `O-`, each of size ten;
- complementation interchanges the two orbits;
- the names `+` and `-` are not intrinsic: the code canonically determines only the unordered
  bipartition, equivalently an unbased `Z/2`-torsor;
- choosing the member of one orbit consistently from each complementary pair makes the
  intersection-two graph on the ten pairs the Petersen graph; choosing the other orbit gives the
  same graph, so Petersen does not orient the torsor.

For every one of the 120 maximum-distance affine syndromes `s` and every three-support `S`, the
three parity-check columns in `S` form a basis and determine a unique coefficient vector with
syndrome `s`. Every coefficient is nonzero, since otherwise `[s]` would lie on a secant. Hence:

- every deep-hole coset has exactly 20 weight-three leaders, one on each support;
- each coset has `10+10` leaders on `O+` and `O-`;
- over all 120 deep-hole cosets, the 2400 minimum-weight leaders split `1200+1200`.

Every monomial automorphism induces a support permutation in `A5`, so it preserves each support
class and carries the unique leader for `(s,S)` to the unique leader for the transformed
syndrome/support pair. This is the coefficient-aware equivariance that the old support-only argument
lacked.

The normalizer of the exotic `A5` in `S6` is an `S5` of order 120. Its outside coset has 60 elements
and exchanges `O+` with `O-`, but these permutations are outside the monomial support image and are
not code automorphisms. The old appeal to `Hom(A5,Z/2)=0` did not prove the coefficient statement and
is deleted.

## Durable artifact contract

`papers/clebsch-hexagon-code/check_chirality.py` must certify all support orbits, complementation,
Petersen adjacency, the full normalizer/outside swap, every per-syndrome coefficient solution, the
`10+10` and `1200+1200` counts, and monomial coefficient equivariance. It must print
`orientation_preferred=False` and finish with `all assertions passed`.

C173 subsequently gives the explicit geometry: a pair of self-polar triangles forms an alternating
six-cycle whose bipartition is one complementary support pair. This identifies the Petersen graph
with `KG(5,2)` but supplies no orientation external to the code, so the manuscript correctly retains
only the unordered chirality bipartition.

## Validation

Command:

`cd papers/clebsch-hexagon-code && python3 check_chirality.py`

Output:

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
orientation_preferred=False
all assertions passed
```

- `git ls-files --error-unmatch papers/clebsch-hexagon-code/check_chirality.py`: passed; the new
  checker is explicitly staged for tracking.
- `git diff --check`: passed for the checker, manuscript, report, discovery log, queue, and handoff.
- `nix shell nixpkgs#tectonic -c tectonic clebsch_hexagon_code.tex --outdir
  /tmp/clebsch-build --keep-logs`: succeeded after its internal reruns, with no warnings.
- Independent post-edit review found the Petersen certificate, full normalizer, `10+10` per coset,
  `1200+1200` global split, all 1,440,000 equivariance cases, and unoriented-torsor language mutually
  consistent.
