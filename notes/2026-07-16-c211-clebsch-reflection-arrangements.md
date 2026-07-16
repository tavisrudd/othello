# C211 — `A3/H3` synthesis for the Clebsch hexagon code

**Lane:** `clebsch`

**Date:** 2026-07-16

**Verdict:** completed and integrated into the manuscript. The exact paired `A3/H3`
conic-filling presentation survived the novelty audit as a paper-specific synthesis. Its two main
ingredients do not survive as novelty claims: the Clebsch--icosahedral geometry is classical in
substance, and the general arrangement-to-decoder mechanism is already due to
Jurrius--Pellikaan.

## Exact identification

Let `tau^2=tau+1`. A standard projective set of the fifteen positive-root directions of `H3` is

```text
(1,0,0), (0,1,0), (0,0,1),
cyclic permutations of (1, +/-tau, +/-(tau-1)).
```

The corresponding mirror lines have six fivefold points

```text
(0,1,1-tau), (0,1,tau-1),
(1,1-tau,0), (1,tau-1,0),
(1,0,-tau), (1,0,tau).
```

Their fifteen joins recover the fifteen mirrors. Every three-by-three determinant on the six
points is twice a unit of `Z[tau]`; hence the six points remain an arc in every characteristic
other than two. The other singularities are ten triple points and fifteen double points.

At `q=11`, choose `tau=8`. The matrix

```text
T = [[2,3,8],
     [10,6,9],
     [2,2,5]]
```

has determinant `3` and maps the six fivefold points onto the six parity-check columns displayed
in the manuscript. The dual action by `T^-1` maps the fifteen mirrors onto the fifteen secants.
This is an equality of arrangements, not only an equality of incidence ledgers.

The exact standard-library replay is
[`check_reflection_arrangements.py`](../papers/clebsch-hexagon-code/check_reflection_arrangements.py).

## Intersection lattices and the two cases

For `H3`, the codimension-two Möbius sum is

```text
6(5-1) + 10(3-1) + 15(2-1) = 59,
```

so centrality gives

```text
chi_H3(t) = t^3 - 15t^2 + 59t - 45
          = (t-1)(t-5)(t-9).
```

The projective complement therefore has `(q-5)(q-9)` points in a lattice-faithful reduction.
At q=11, the projective multiplicity spectrum is

```text
index 0: 12; index 1: 90; index 2: 15; index 3: 10; index 5: 6.
```

Marking the six fivefold points as parity-check columns turns these strata into the established
nearest-codeword ambiguity counts `960,150,100,120` for multiplicities `1,2,3,20`.

For a standard four-frame, the six joins have equations

```text
X, Y, Z, X-Y, X-Z, Y-Z = 0,
```

the essential braid arrangement `A3`. Its four triple and three double points give

```text
chi_A3(t) = (t-1)(t-2)(t-3),
projective complement = (q-2)(q-3).
```

Thus the conic-sized equations factor as

```text
(q-2)(q-3) - (q+1) = (q-1)(q-5),
(q-5)(q-9) - (q+1) = (q-4)(q-11).
```

The first leaves q=5. The H3 model is bad in characteristic two, so the apparent q=4 root of the
second equation is outside its faithful-reduction range; q=11 remains. Characteristic five is
lattice-faithful for H3 even though the modular reflection representation is nonsemisimple. The
A3 graphic arrangement has good reduction in every characteristic.

## Priority and novelty audit

Three parallel targeted searches checked the classical geometry, coding/arrangement theory, and
the paired conic-filling synthesis.

- Edge already derives real Clebsch hexagons from the six opposite-vertex axes of a regular
  icosahedron, and his q=11 construction has the six vertices, fifteen joins, ten Brianchon
  concurrences, fixed conic, and icosahedral `A5` symmetry. Dye calls the regular pentagon plus its
  center the simplest Clebsch hexagon and gives the golden-ratio coordinates. The underlying
  icosahedral identification is therefore classical, even though the literal `H3` cross-reference
  was not found. See [Edge 1956](https://doi.org/10.4153/CJM-1956-041-6) and
  [Dye 1991](https://doi.org/10.1112/jlms/s2-44.2.270).
- Calvo explicitly treats the fifteen projectivized icosahedral mirrors and their
  `6_5,10_3,15_2` singularity ledger. This is the modern reflection-arrangement source:
  [Calvo 2024](https://doi.org/10.1016/j.jpaa.2023.107563).
- Athanasiadis's finite-field characteristic-polynomial method is classical and, by itself, only
  applies at sufficiently good reductions. The direct coordinate calculation above supplies the
  small-field boundary needed here:
  [Athanasiadis 1996](https://doi.org/10.1006/aima.1996.0059).
- Jurrius--Pellikaan is an exact collision with the proposed general decoder interpretation.
  Proposition 3.11 identifies syndrome weight with minimal column-span membership; Theorems 5.3
  and 5.7 derive coset-leader and list-weight enumerators from the derived arrangement and its
  multiplicity function; Example 5.10 explicitly treats redundancy-three MDS secant arrangements.
  The manuscript now cites this priority:
  [Jurrius--Pellikaan 2015](https://doi.org/10.1090/conm/632/12631).
- No searched source gave the combined statement pairing the `A3` q=5 frame and `H3` q=11
  Clebsch code through their characteristic-polynomial complement formulas and the conic-filling
  classification. This is safe as a concise synthesis/application, not as a new arrangement
  theorem, a new icosahedral discovery, or a new arrangement-decoder principle.

The two full texts newly cached for the audit are:

```text
arXiv:2209.01499
sha256 3ef91a2818d27bbd0a09b1095d1095a1f8ae2d162f7a7d3da729e0e7b4ffa252

10.1090/conm/632/12631
sha256 99a2c5d1625af85d4c5560276b45728acaba347dd13f88d789d49b792f714b95
```

## Manuscript disposition

The manuscript now:

- gives the explicit `H3` roots, six fivefold points, and F11 projectivity;
- states the characteristic-two boundary and characteristic-five nuance;
- derives the complement and decoder strata from the intersection lattice;
- identifies the frame joins with `A3` and factors both conic-size equations;
- cites Edge, Calvo, Athanasiadis, and Jurrius--Pellikaan with conservative priority language;
- adds the new exact checker to the verification architecture.

The rendered paper grows from 17 to 19 pages, meeting the roadmap's approximate two-page growth
gate. The arrangement account synthesizes existing counts rather than adding a second theorem
spine.

## Cold read and organizational revision

A fresh referee-style read found no blocking mathematical defect but judged the first integration
too early and partly duplicative: H3 announced the ambiguity census before the code was introduced,
while A3 appeared roughly twelve pages later. The full report is
[`2026-07-16-c211-clebsch-cold-read.md`](2026-07-16-c211-clebsch-cold-read.md).

The manuscript was revised accordingly. Both arrangements now form one late capstone subsection,
“The two reflection-arrangement exceptions,” after the q=11/all-field boundary and immediately
before the small-k theorem. The revision also:

- replaces “explains conic filling” by the precise distinction between complement size and the
  separate geometry proving that the complement is a conic;
- calls q=4 an extraneous polynomial root in the bad characteristic-two regime;
- keeps the H3 field-of-definition boundary visible;
- states the row/column convention for the dual projective action;
- defines ordinary mirror points and distinguishes the central arrangement from its
  projectivization;
- sharpens the three paper-specific contributions in the priority paragraph.

The reorganized paper remains 19 pages and removes the duplicated affine ambiguity derivation from
the arrangement subsection.
