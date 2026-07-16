# Clebsch A+ upgrade and follow-up research roadmap

**Date:** 2026-07-16

**Source lane:** `clebsch`

**Follow-up lane:** `clebsch-next`

## Executive verdict

The current paper already has a coherent rigidity/classification spine. The best plausible A+
upgrade is not another census or a second historical narrative, but a short reflection-arrangement
synthesis that explains several existing results at once:

> The fifteen secants of the Clebsch hexagon should be identified with the projectivized
> icosahedral reflection arrangement of type `H3`, while the six secants of the `PG(2,5)`
> four-frame form the projectivized braid arrangement of type `A3`.

This is unusually well connected to the manuscript and appears tractable. It should replace and
compress parts of the existing exposition rather than create a new independent spine. Broader
decoder-tomography, cubic-surface, stability, chirality, and all-field questions belong in the new
`clebsch-next` lane.

**C211 completed 2026-07-16.** The manuscript now gives an exact `F_11` projectivity from the
standard `H3` mirrors to the displayed Clebsch secants, derives the complement and decoder strata
from the intersection lattice, identifies the frame joins with `A3`, and factors the two conic-size
equations. The rendered draft grows from 17 to 19 pages. The novelty audit materially narrows the
claim: Edge/Calvo own the icosahedral geometry in substance, and Jurrius--Pellikaan own the general
derived-arrangement decoder formalism. What survives is the exact finite-field application and the
paired `A3/H3` conic-filling synthesis. See
[`2026-07-16-c211-clebsch-reflection-arrangements.md`](2026-07-16-c211-clebsch-reflection-arrangements.md).

## The `H3` identification

The Clebsch chord arrangement recorded in the paper has fifteen lines and the singularity ledger

```text
6 quintuple points + 10 triple points + 15 double points.
```

The six quintuple points are the arc vertices, the ten triple points are the Brianchon points, and
the fifteen double points are the other intersections of disjoint chords. This is exactly the
intersection ledger of the projectivized fifteen mirror planes of the icosahedral reflection
arrangement. The classical arrangement itself is not new; for a modern account see Sebastian
Calvo, *The icosahedral line configuration and Waldschmidt constants*, JPAA 228 (2024), 107563,
[arXiv:2209.01499](https://arxiv.org/abs/2209.01499).

The ledger gives the characteristic polynomial directly. The codimension-two coefficient is

```text
6(5-1) + 10(3-1) + 15(2-1) = 59,
```

and centrality gives a root at one, hence

```text
chi_H3(t) = t^3 - 15t^2 + 59t - 45
          = (t-1)(t-5)(t-9).
```

Consequently the projective finite-field complement has size

```text
chi_H3(q)/(q-1) = (q-5)(q-9) = q^2 - 14q + 45,
```

which is exactly the manuscript's Clebsch-family uncovered-locus formula. The general
characteristic-polynomial/finite-field-complement method is classical; see Christos Athanasiadis,
*Characteristic Polynomials of Subspace Arrangements and Finite Fields*, Advances in Mathematics
122 (1996), 193--233. For the paper, the existing incidence count can also prove the formula
directly, avoiding any delicate good-reduction dependency.

The coding interpretation is stronger than the point count. The projective weight-at-most-two
syndromes form the line arrangement, and the weight-three syndromes form its complement. Its
intersection lattice reproduces the decoder strata:

- six fivefold intersections are the weight-one column directions;
- ten threefold intersections are the Brianchon directions with three nearest weight-two errors;
- fifteen twofold intersections have two nearest weight-two errors;
- ninety ordinary line points have one nearest weight-two error;
- the twelve complement points at `q=11` are the weight-three directions.

Thus the ambiguity enumerator and the Brianchon reconstruction are manifestations of the `H3`
intersection lattice rather than separate coincidences.

## The `A3` companion and the two exceptional fields

The six joins of a projective four-frame form the projectivized reflection arrangement of type
`A3`: four triple points and three double points. Its characteristic polynomial is

```text
chi_A3(t) = (t-1)(t-2)(t-3),
```

so its projective complement has `(q-2)(q-3)` points, exactly the four-arc formula already proved
in the manuscript. The two conic-filling cases for `4 <= k <= 7` can therefore be presented as

| arc | secant arrangement | projective complement | conic-sized field |
|---|---|---:|---:|
| four-frame | `A3` | `(q-2)(q-3)` | `q=5` |
| Clebsch hexagon | `H3` | `(q-5)(q-9)` | `q=11` |

This does not replace the universal chord-moment proof or the arbitrary-arc rigidity theorem. It
explains why the two surviving configurations have their particular factorizations and Platonic
symmetries.

## Current-paper upgrade gate

The upgrade belongs in the current paper only if C211 closes all of the following:

1. Give a coordinate-free or short exact-coordinate proof that the fifteen Clebsch chords are the
   projectivized `H3` mirrors over the relevant base ring/fields.
2. State the characteristic and good-reduction boundary honestly; retain the direct incidence
   proof wherever it is cleaner.
3. Show explicitly how the intersection lattice recovers the syndrome and ambiguity strata.
4. Identify the four-frame joins with `A3` and use this to synthesize, not duplicate, the small-arc
   theorem.
5. Audit priority: the icosahedral arrangement is classical, while the MDS syndrome-complement,
   decoder-stratification, and `A3/H3` conic-filling synthesis are the candidate new contributions.
6. Keep the net manuscript growth small, ideally about two pages after removing redundant counts.

A clean result is a plausible solid-A+ upgrade because it makes the manuscript shorter, more
conceptual, and better connected to reflection groups and arrangement theory. A mere observation
that the incidence numbers coincide is not enough.

## Follow-up research program

### Coxeter-arrangement codes and decoder tomography

The strongest stand-alone direction is to ask when a projective code has its low-weight syndrome
locus equal to a reflection or free arrangement. The desired theory relates:

```text
distinguished projective axes  <-> parity-check columns
reflection hyperplanes         <-> weight-at-most-two syndromes
arrangement complement         <-> maximum spanning-weight syndromes
intersection lattice           <-> decoder ambiguity poset.
```

Jurrius and Pellikaan already construct the parity-check derived arrangement and recover extended
coset-leader and list-weight enumerators from its geometric lattice and multiplicity function,
including the planar MDS secant case. C212 must therefore improve on that baseline with a genuine
reconstruction or classification theorem; the displayed dictionary alone is prior art.

An A+ follow-up needs a general reconstruction or classification theorem, not only the `A3` and
`H3` examples. Natural invariants include the characteristic polynomial, Orlik--Solomon algebra,
freeness exponents, and the support-incidence structure of coset leaders. This program is C212.

### Clebsch cubic and `E6`

The highest-ceiling speculative connection is the numerical and group-theoretic match

```text
12 + 15 = 27,     10 Brianchon points,     five triangles,     S5.
```

The corresponding Clebsch cubic surface has 27 lines, ten Eckardt points, a Sylvester pentahedron,
and `S5` symmetry. The first task is a cheap falsification gate: compare the incidence induced by
the paper's `12+15` point orbits with the Schlaefli graph, and test whether the ten Brianchon
objects match the ten Eckardt objects equivariantly. The already-failed direct 27-point cap
template must not be revived. An exact incidence dictionary would support a stand-alone A+
paper; a cardinality-only match should be reported negative and stopped. This gate is C213.

### Stability, chirality, and arithmetic orbits

The pre-existing C206--C208 questions move to `clebsch-next`:

- C206 seeks a parameterized stability mechanism behind the sharp nearest-conic gap. The `H3`
  viewpoint suggests studying deformations of five mirrors under a one-vertex replacement and
  testing addition--deletion or intersection-lattice defects.
- C207 seeks a code-intrinsic chirality torsor and a precise obstruction to the outside exotic
  `S5` coset. The real `H3` reflection group and the exotic `S5` normalizer are different
  index-two extensions of `A5`; explaining that distinction may be more informative than forcing
  an identification.
- C208 seeks the all-field `A5`-orbit decomposition of the `H3` complement, including the verified
  `q=19` split `20+120`, with a representation-theoretic or Frobenius explanation.

## Disposition

- **Current paper (`clebsch`):** C182 remains the submission-critical archive task; C211 is the
  bounded `A3/H3` manuscript upgrade.
- **New lane (`clebsch-next`):** C206--C208 are re-pegged here; C212 and C213 are new follow-up
  tasks.
- **Not queued:** the companion quartic/quintic/sextic atlas remains a promising moduli project,
  but it lacks a unifying theorem and is lower priority than the arrangement and cubic-surface
  gates.
