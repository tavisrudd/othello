# C172 — Clebsch monomial equivalence and deep-hole orbits

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Code-level corollaries, exact orbit checker, tracking gate, and
warning-free manuscript build passed; independent post-edit review is recorded below.

## Code-level rigidity

The projective rigidity theorem has the following intrinsic coding form:

> Up to monomial equivalence, the Clebsch code is the unique linear `[6,3,4]_11` code of covering
> radius three whose projective deep-hole syndrome locus lies on a conic.

Indeed, the parity-check columns form a six-arc and the covering-radius-three hypothesis identifies
the projective deep-hole syndrome locus with `U(A)`. Projective equivalence of unordered
parity-check column rays is exactly row equivalence together with a coordinate permutation and
nonzero coordinate scalings, hence monomial code equivalence.

The exact automorphism dictionary remains the one settled in C163:

- projective/support stabilizer `A5`, order 60;
- central scalar kernel `F_11*`, order 10;
- `MAut(C) ~= C10 x A5`, order 600;
- trivial pure-permutation subgroup for the displayed column representatives.

## Four different orbit levels

The computation distinguishes sets that the original draft was liable to conflate.

| Set and acting group | Exact orbit statement |
|---|---|
| 120 deep-hole syndrome cosets under `MAut(C)` | one orbit; stabilizer order 5 |
| 20 leaders over one fixed syndrome under its stabilizer | four orbits of size 5, two per chirality |
| all 2400 minimum-weight leaders under `MAut(C)` | four free orbits of size 600, two per chirality |
| 159720 received-word deep holes under `Gamma = C rtimes MAut(C)` | one orbit; stabilizer order 5 |

Thus the chirality classes of size `1200+1200` are invariant unions, not the monomial-orbit
decomposition. Each contains two 600-element orbits.

For the last row, codeword translations are essential. If deep holes `v,w` have syndromes `s,t`,
choose a monomial automorphism `m` carrying `s` to `t`; then `w-mv` has zero syndrome and is a
codeword, so translation by it sends `mv` to `w`. The group has order

`|Gamma| = 1331*600 = 798600`,

and orbit-stabilizer gives stabilizer order `798600/159720=5`, necessarily cyclic.

## Durable evidence

The extended checker is
`papers/clebsch-hexagon-code/check_chirality.py` (SHA-256
`16e5f97693387de9b072ceed9789232c01df7b4e760d00088cfe065326eee9c5`). It constructs
`C=ker(H)` directly from three free coordinates—never replacing it by `row(H)`—and verifies all
`600*1331=798600` monomial images of codewords before building one 159720-word affine orbit.

Relevant exact output:

```text
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
```

Validation:

- `python3 check_code_automorphisms.py`: passed.
- `python3 check_chirality.py`: passed with the exact orbit tail above.
- `git ls-files --error-unmatch papers/clebsch-hexagon-code/check_chirality.py`: passed after
  restaging the extended source.
- Tectonic manuscript build: warning-free.
- `git diff --check`: passed.
- Independent post-edit review: group-action conventions, kernel construction, orbit orders,
  monomial-equivalence proof, and the four-orbit/chirality distinction passed. Its one requested
  compression fix—the explicit normalization identity
  `m t_c m^-1 = t_{m(c)}` establishing the semidirect product—landed before report.

The order-five stabilizer is the coding shadow of a five-fold subgroup in the icosahedral action.
Making that identification canonical for individual received words is an optional geometric
follow-on, not needed for the orbit theorem.
