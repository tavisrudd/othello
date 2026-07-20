# C399 — Coxeter-number conic phase and the `B3` root-length defect

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; LITERATURE-REFRAMED UNIFORM COXETER-NUMBER COMPLEMENT-CODE PHASE`

## The theorem

Let `T` be one of the irreducible rank-three Coxeter types `A3`, `B3`, or `H3`, with Coxeter
number `h=4,6,10`, respectively, and put

```text
e = h/2,                 N = 3h/2.
```

Thus the Coxeter exponents are `(1,e,h-1)` and the projectivized reflection arrangement has `N`
mirrors.  Reduce the standard integral arrangement over a finite field `k=F_q` at a lattice-good
odd prime: every odd characteristic for `A3/B3`, and every odd prime ideal of `Z[tau]` for the
fixed `H3` model.  Let `B_T(q)` be the complement of the mirrors in `PG(2,q)`, and let `D_T(q)`
be the dimension-three projective evaluation code whose generator columns are `B_T(q)`.

Then:

1. **Uniform complement and code parameters.** Whenever the complement is nonempty,

   ```text
   |B_T(q)| = (q-e)(q-h+1),
   D_T(q) = [(q-e)(q-h+1), 3, (q-e-1)(q-h+1)]_q.
   ```

   Equivalently, the largest intersection of a line with `B_T(q)` is exactly `q-h+1`.

2. **Coxeter-number conic phase.** At

   ```text
   q = h+1,
   ```

   the complement is exactly the `q+1` rational points of the invariant nonsingular conic

   ```text
   Q: X^2+Y^2+Z^2=0
   ```

   in the displayed coordinates.  Hence

   ```text
   D_T(h+1) = [h+2,3,h]_(h+1) = [q+1,3,q-1]_q
   ```

   is the full projective/extended GRS code.  The three instances are

   | type | `h` | conic field | child code |
   |:---|---:|---:|:---|
   | `A3` | 4 | `F_5` | `[6,3,4]_5` |
   | `B3` | 6 | `F_7` | `[8,3,6]_7` |
   | `H3` | 10 | `F_11` | `[12,3,10]_11` |

3. **Empty phases.** The two roots of the complement polynomial are `q=e` and `q=h-1`.
   Subject to field existence and good reduction, these give the empty phases: `A3` at q=3
   (q=2 is bad), `B3` at q=3,5, and `H3` at q=5,9.

4. **Stable intrinsic recovery.** If

   ```text
   q > N-1 = 3h/2-1,
   ```

   then every nonmirror line meets `B_T(q)`, while every mirror is disjoint from it.  Thus the
   unmarked projective system of `D_T(q)` intrinsically recovers the reflection arrangement.
   Its singular multiplicities then recover the distinguished orbit data: the four triple flats
   for `A3`, the four triple flats together with the three fourfold flats for `B3`, and the six
   fivefold flats for `H3`.

5. **Exact deep-hole boundary.** For `A3`, the four triple flats form a projective frame whose
   six secants are exactly the mirrors, so `B_A3(q)` is its complete projective weight-three
   syndrome locus.  The same statement holds for the six `H3` fivefold points and their fifteen
   secants.  It cannot hold for the full `B3` arrangement: nine is not `binom(n,2)` for any `n`,
   whereas an `n`-arc has exactly `binom(n,2)` distinct secants.

   The failure is nevertheless canonical rather than erratic.  The four `B3` triple flats form a
   frame whose six secants are precisely the long-root `D3=A3` subarrangement; its complete
   deep-hole locus is `B_A3(q)`.  The three short-root coordinate mirrors cut out three disjoint
   `(q-3)`-point sections of that locus, giving

   ```text
   B_B3(q) = B_A3(q) minus the short-root polar triangle,
   |B_A3(q) \ B_B3(q)| = 3(q-3).
   ```

   Thus `B3` is the unique root-length-defect member of the theorem.  It explains exactly why the
   stronger complete-deep-hole functor fails without breaking the Coxeter-number conic phase.

This is the common theorem C399 was seeking: the field `q=h+1`, the GRS child, the length and
distance, and the recovery threshold are all controlled by the Coxeter number.  The result is not a
concatenation of three modular determinant tables.  The subsequent full literature audit sharpens
the ownership boundary: the complement length and the three individual small-field conic
configurations are classical.  The principal literature-surviving claim is the exact uniform
nonmirror-line maximum `q-h+1`, hence the minimum-distance law and its common Coxeter-number phase.

## Proof

### Complement size

Good reduction preserves the intersection lattice.  The three Coxeter arrangements have exponents

```text
A3: (1,2,3),       B3: (1,3,5),       H3: (1,5,9),
```

so the finite-field method gives `(q-1)(q-e)(q-h+1)` affine complement vectors.  Dividing by the
`q-1` nonzero scalars gives the projective formula.  The exact rank-two ledgers provide a direct
rank-three proof independent of the general exponent theorem:

```text
A3: 3 double + 4 triple flats,                    6 mirrors;
B3: 6 double + 4 triple + 3 fourfold flats,       9 mirrors;
H3: 15 double + 10 triple + 6 fivefold flats,    15 mirrors.
```

For example, inclusion along the singular flats gives `6(q+1)-(3+2*4)=6q-5` covered projective
points for `A3` and `9(q+1)-(6+2*4+3*3)=9q-14` for `B3`, yielding the asserted factorizations.
C339 supplies the identical calculation for `H3`.

### Why `q=h+1` is a conic

At the Coxeter-number prime the invariant form is nonsingular and every reflection mirror is
external to `Q`.  If a mirror has pole/root `r`, externality is the quadratic-character condition
that `-Q(r)` be nonsquare.  In the fixed integral models the root-norm classes reduce as follows:

| type | field | root-norm classes | negatives |
|:---|:---|:---|:---|
| `A3` | `F_5` | `{2}` | `{3}` nonsquare |
| `B3` | `F_7` | `{1,2}` | `{6,5}` nonsquare |
| `H3` | `F_11` | `{1,4}` | `{10,7}` nonsquare |

Therefore all `q+1` conic points lie in the arrangement complement.  At `q=h+1` the complement
formula becomes

```text
(h+1-h/2)(h+1-h+1) = (h/2+1)*2 = h+2 = q+1,
```

so containment is equality.  The standard conic--projective-GRS dictionary gives the child code.
The A3/B3 equality is independently replayed by direct point enumeration; C368 supplies two
independent q=11 H3 fibres and the manuscript-coordinate projectivity.

### Distance and recovery

For a nonmirror line `L`, put

```text
delta(L) = sum_(P in L singular) (m(P)-1).
```

Distinct mirror intersections on `L` collide precisely at singular points, hence

```text
|L cap B_T(q)| = q+1-N+delta(L).
```

The exact singular-line ledgers give `max delta=e` in all three types.  For A3 the nonmirror
`delta` counts are

```text
delta 0: (q-3)^2,     delta 1: 3(q-3),     delta 2: 4q-5;
```

for B3 they are

```text
delta 0: (q-5)(q-7),  delta 1: 6(q-5),
delta 2: 4(q-5),      delta 3: 3q+7;
```

and C339 gives the six H3 classes through `delta=5`.  Since `N=3h/2` and `e=h/2`, the maximum
intersection is

```text
q+1-3h/2+h/2 = q-h+1.
```

Subtracting it from the length proves the distance.  Independently, if `q>N-1`, even the crude
bound `q+1-N>0` makes every nonmirror line visible, proving intrinsic recovery without consuming
the detailed spectrum.

## Free upgrades and questions answered

### Classical parent fibres and the Coxeter/code identification

At `q=h+1`, the automorphism group of the full conic child jumps from the projective Coxeter group
to the full conic stabilizer `PGL_2(q)`.  Exact permutation closure and normalizer computation give

| type | projective Coxeter group | full child group | normalizer | conjugate decorations |
|:---|---:|---:|---:|---:|
| `A3` over `F_5` | `S4`, order 24 | `PGL_2(5)`, order 120 | 24 | 5 |
| `B3` over `F_7` | `S4`, order 24 | `PGL_2(7)`, order 336 | 24 | 14 |
| `H3` over `F_11` | `A5`, order 60 | `PGL_2(11)`, order 1320 | 60 | 22 |

Each Coxeter group is transitive on the `q+1` conic points and self-normalizing in the full child
group.  Thus the bare GRS child admits exactly `5,14,22` conjugate Coxeter decorations and cannot
recover which one produced it.  Equality of two mirror decorations would recover the same
reflection subgroup, so the coset counts are decoration counts, not merely subgroup bookkeeping.

These counts, their geometric-marker interpretation, full-conic-group transitivity, and much of
their pairwise geometry are classical: Edge gives the five canonical triangles, fourteen
octahedral structures, and twenty-two Clebsch hexagons on the respective conics, while Dye sharpens
the q=11 transitivity and incidence geometry.  C399 claims neither the counts nor parent ambiguity
as new.  Its contribution here is to identify the classical markers uniformly as the Coxeter
mirror decorations produced by the complement-code phase.  The H3 member is C379's 22-parent
Clebsch locus.

This gives a uniform answer to the most immediate inverse question:

```text
stable phase: the complement code recovers its Coxeter arrangement;
conic phase:  symmetry expands to PGL_2(q) and the unmarked child forgets among 5,14,22 parents.
```

C403 extends this forgetting through the factorized Veronese tower in the exact safe sense.  On
the full conic, the support of a line product is only the union of its rational endpoint sets, and
the projective restriction of a secant/tangent product is determined only by its total endpoint
divisor; the secant pairing and Coxeter decoration disappear.  The unrestricted degree-`r` conic
evaluation code is therefore parent-free, with rank `min(2r+1,q+1)`.  External factors require the
stated caution: their conjugate divisors can retain which lines were excluded as mirrors, so the
whole nonmirror value-sector is not claimed parent-free.

### Why it does not extend one rank higher

The rank-three count is forced by exponent duality: the nontrivial exponents are `h/2` and `h-1`,
so at `q=h+1` their two complement factors multiply to `q+1`, exactly the size of a conic.  The
first higher-rank gate already fails for every irreducible rank-four type.  At the candidate field
`q=h+1`, the projective complement counts versus the two possible nonsingular quadric-surface
counts are

| type | candidate `q` | complement | quadric surface sizes | result |
|:---|---:|---:|:---|:---|
| `A4` | 6 | no field | — | closed |
| `B4` | 9 | 48 | 82 or 100 | unequal |
| `D4` | 7 | 32 | 50 or 64 | unequal |
| `F4` | 13 | 96 | 170 or 196 | unequal |
| `H4` | 31 | 480 | 962 or 1024 | unequal |

So the obvious rank-four continuation is closed before any incidence computation.  This makes the
rank-three scope structurally natural rather than an arbitrary truncation.  A theorem excluding
isolated coincidences in every higher rank is not needed here and remains explicitly unclaimed.

### Other immediate boundaries

- The conic child itself is classical GRS in all three cases.  The theorem's content is the exact
  arithmetic/code transition and its identification with the classical parent ambiguity, not a
  new GRS, AME, or parent-fibre geometry.
- Edge's octahedral involution geometry already contains the underlying `3+6` split behind the B3
  long/short-root decomposition.  The new-looking content is the exact arrangement-complement and
  deepest-syndrome consequence, not the deletion configuration itself.  No repair, PIR, or quantum
  advantage follows for free.
- A decorated inverse theorem at the conic phase is possible only after supplying a Coxeter marking;
  the bare child cannot choose among the exact coset counts.  H3's matching decoration is genuinely
  extra structure, while no equally rich A3/B3 marking has yet passed a novelty gate.
- Reducible rank-three systems have no single irreducible Coxeter number and do not belong to this
  theorem.  Adding them would produce product/pencil cases rather than strengthen the flagship.

The bounded successor portfolio is allocated as C403--C405.  C403 now owns the reusable weighted
adjoint/enumerator abstraction of the distance law.  C404 closed at its literature gate because
Edge and Dye already contain the intended fibre counts, marker meaning, and much of the relation
skeleton.  C405 remains the first rigorously field-bounded twisted-cubic deepest-syndrome pilot.
See
`notes/2026-07-20-c403-c405-c399-successor-portfolio.md`.

C406 is the later bounded manuscript-compatibility gate exposed by C403's matching kernel and
stabilizer theorem.  It does not reopen C404's marker census: it tests whether the classical
`5/14/22` parent markers are intrinsically the symmetry-selected factorizations of the canonical
Frobenius zero section, whether their factorization differences carry a nontrivial conic-ideal
module, and whether the H3 sheet sign has a genuine Fourier/reconstruction consequence.  C399
remains the protected portable theorem unless that gate passes and a separate replacement decision
is made; see
`notes/2026-07-20-c406-clebsch-flagship-red-team-and-factorization-memory-plan.md`.

## Evidence and replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c399-coxeter-number-conic-phase.py --check
sha256sum -c notes/2026-07-20-c399-coxeter-number-conic-phase.sha256
```

The standard-library generator constructs the integral A3/B3 mirrors, all singular flats, every
special nonmirror line, both natural B3 orbit systems, and all their secants.  Its independent path
enumerates every point and line of `PG(2,p)` at `p=3,5,7,11`, checks the complement, complete line
spectrum, code parameters, and the exact conic equalities at q=5 and q=7.  The H3 entries are
hash-pinned to the independently replayed C339, C346, and C368 certificates.

The trusted boundary is exact Python integer/modular arithmetic, those three tracked H3 bundles,
the standard Coxeter-exponent finite-field method, and the standard arc--MDS and conic--GRS
dictionaries.  The artifact does not classify reducible rank-three Coxeter systems, bad
characteristic two, arbitrary complex reflection groups, or non-projective codes.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 25,983 | `f90f8bf9ef85667ffeb937c4b3f07c54407edcfc965fb4cf9b45f7f854097275` |
| certificate `.json` | 16,824 | `993b9f7c9da5b79e474aa0f2a38919352de135844cdbe35a3c89a8430da4f65e` |

## Focused source audit and claim boundary

The completed audit is
`notes/2026-07-20-c399-literature-audit.md`.  It combines three independent slices, eight distinct
full-text reads, targeted partial readings, exact-query screens, and pinned forward-citation checks
in OpenAlex, Crossref, and Semantic Scholar.

Its positive pre-emption is decisive.  Edge (1956) already gives the separate q=5,7,11 conic
markers, the exact `5,14,22` counts, their stabilizers and substantial relation geometry, while
Dye (1991) sharpens the q=11 transitivity and incidence theory.  Edge also contains the projective
`3+6` octahedral split underlying the B3 short/long-root geometry.  Raja (2026) pre-empts the generic
idea of evaluation codes on complements of arrangements, and Berg--Wakefield supplies an adjacent
union-of-arrangements construction.  Coxeter exponent factorization, finite-field complement
counts, modular reduction, and the conic--GRS dictionary remain classical infrastructure.

No screened source states the exact uniform nonmirror-line maximum `q-h+1`, the resulting distance
formula across `A3/B3/H3`, or the common Coxeter-number complement-code phase.  That negative is
qualified: Raja's full text, Korchmaros's primary paper, Monson--Schulte Part I, MathSciNet, and
Google Scholar remain access gaps.  The defensible language is therefore “the classical
configurations admit a common Coxeter-number arrangement-complement code formulation,” followed by
an exact statement of the line-defect/distance theorem.  Do not use “first,” claim the `5,14,22`
geometry, or call the family “Coxeter codes,” which is occupied terminology.

## Lean exit

The paper-facing arithmetic spine and certificate interface are formalized in
`lean/RelativeConicArcs/ClebschGatewayCoxeterPhase.lean`.  The kernel checks the two uniform
`h=2e` identities, all three length/distance specializations, the `PGL_2(q)` order and decoration
index identities, the exact `5,14,22` list, and the bounded rank-four negative gate.  The external
certificate remains explicitly responsible for incidence, conic-set equality, and group closure.

The dedicated import-only gate
`RelativeConicArcs.Gates.ClebschGatewayCoxeterPhase` and the umbrella gate
`RelativeConicArcs.Gates.ClebschGateway` both passed the guarded serialized build.  The final
umbrella run ended with a green trace-only exact-target gate.  The printed audit has no `sorryAx`
or project-local axioms; the two general integer polynomial identities use only Mathlib's `propext`,
while the finite profile and gate theorems are axiom-free.

## Hand-back

- C339, C346, and C368 retain the H3 spectrum, good-reduction, and q=11 transform theorems.
- C399 supplies the common `A3/B3/H3` theorem and records the exact B3 root-length defect rather
  than hiding it behind a false complete-deep-hole claim.
- C403--C405 own the arrangement-code abstraction, intrinsic parent-fibre geometry, and bounded
  twisted-cubic pilot, in that order; none is silently claimed by this report.
- This is the selected portable paper-heading theorem and consumes the C398--C402 promotion slot
  under the classical/new boundary fixed by the completed audit.  It does not authorize
  accumulating C400--C402 as additional unrelated generalizations.
