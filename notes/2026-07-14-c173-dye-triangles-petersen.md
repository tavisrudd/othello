# C173 — Dye triangles and the Petersen support graph

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. The geometric bijection exists, is explicit and equivariant, is checked
for the displayed coordinates and conic, and is now in the manuscript.

## Result

Write `Ω={0,1,2,3,4,5}` for the six coordinate supports. The exotic degree-six `A5` stabilizes a
unique synthematic total, namely the following five perfect matchings:

```text
01|23|45    02|14|35    03|15|24    04|13|25    05|12|34.
```

These are the five classical self-polar triangles: for each row, take the three chord lines through
the indicated pairs of displayed Clebsch vertices. Exact `F_11` arithmetic verifies that the polar
of each triangle vertex for `C: XZ=Y²` is its opposite chord line.

For two matchings `M_i,M_j` in the total, their union is an alternating six-cycle. Its two colour
classes form an unordered `3+3` bipartition `β_ij={S,Ω\S}`. The map

```text
{M_i,M_j}  ↦  β_ij
```

is an explicit `A5`-equivariant bijection from the ten pairs of self-polar triangles to the ten
complementary pairs of three-supports. It is equivariant under the full normalizer `S5`, not only
under `A5`.

Under this bijection, two support-pair vertices are adjacent in the manuscript's Petersen graph
exactly when their two triangle pairs are disjoint. Thus the graph is the standard Kneser graph
`KG(5,2)`. Pairs sharing one triangle give the six-regular complementary graph instead.

The construction does **not** orient the two chirality classes. Each class chooses one member of
every complementary `3+3` pair coherently, but simultaneous complementation gives the other class
and preserves Petersen adjacency. This answers the five-triangle question without reviving the
refuted claim that the ten objects split into five invariant pairs.

## Conceptual proof of bijectivity

Two distinct perfect matchings in a synthematic total are edge-disjoint. Their union is therefore a
two-regular graph on six vertices with no two-cycle, hence an alternating six-cycle and a `3+3`
bipartition.

The bipartition recovers the original pair of matchings. Each selected matching uses three of the
nine edges crossing its `3|3` cut, so together they use six. Every perfect matching crosses a
`3|3` cut an odd number of times. Only three crossing edges remain for the other three matchings in
the total, so each of those uses exactly one; the selected two are precisely the total-members that
lie wholly across the cut. The map is injective, and both sides have size ten. Equivariance is
immediate because permutations preserve cycles and their bipartitions.

## Durable certificate

`papers/clebsch-hexagon-code/check_chirality.py` now additionally asserts:

- all 15 perfect matchings and all six synthematic totals on `Ω`;
- uniqueness of the `A5`- and normalizer-invariant total;
- the five exact self-polarities for the displayed columns and `XZ=Y²`;
- bijectivity of all ten triangle pairs onto all ten complementary support pairs;
- all `120·10=1200` full-normalizer equivariance cases;
- equality of disjoint-triangle-pair adjacency with the previously certified Petersen graph.

Final source identifiers:

- Git blob: `3a4e667b24d262cabde20a0517264bad21551bc5`;
- SHA-256: `6f4c2b47dbe7d7c90e66d76e2dfb8bdfd20fe099eaced247aaebcd20d47eaef5`.

Validation command:

```text
cd papers/clebsch-hexagon-code
/usr/bin/time -f 'elapsed=%e max_rss_kib=%M' python3 check_chirality.py
```

It exited zero in 7.03 seconds with peak RSS 42,844 KiB. New sentinels were:

```text
perfect_matchings=15
synthematic_totals=6
A5_invariant_synthematic_totals=1
invariant_synthematic_total_size=5
invariant_synthematic_total_self_polar_for_XZ_eq_Y2=True
triangle_pairs=10
triangle_pair_support_bijection=True
triangle_pair_equivariance_checks=1200
petersen_adjacency=disjoint_triangle_pairs
normalizer_triangle_action=S5
all assertions passed
```

The full pre-existing chirality, coefficient-equivariance, leader-orbit, and received-word tests
also passed in the same run. An independent agent derived the same alternating-cycle map and
identified the only trust-boundary caveat: an abstract invariant total was not by itself the
displayed geometric one. The added polar-line assertions close that caveat directly.

The manuscript rebuilt with Tectonic; after the C146 prior-art rebase the checked-in PDF is 146,424
bytes. Its log contains no package/LaTeX,
undefined-reference, overfull, or underfull warning.
