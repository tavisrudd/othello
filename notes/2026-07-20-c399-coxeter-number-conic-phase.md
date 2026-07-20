# C399 — Coxeter-number conic phase and the `B3` root-length defect

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; UNIFORM COXETER-NUMBER CONIC/GRS PHASE WITH ONE B3 ROOT-LENGTH DEFECT`

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
concatenation of three modular determinant tables.

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

### The conic child forgets its Coxeter parent

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
The H3 value is exactly C379's 22-parent Clebsch locus; C399 shows that it is the last member of a
rank-three `5,14,22` symmetry-completion sequence.

This gives a uniform answer to the most immediate inverse question:

```text
stable phase: the complement code recovers its Coxeter arrangement;
conic phase:  symmetry expands to PGL_2(q) and the unmarked child forgets among 5,14,22 parents.
```

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
  arithmetic transition and parent-forgetting geometry, not a new GRS or AME class.
- The B3 deletion formula opens a nested-code/short-root filtration, but its unweighted code
  parameters are already exhausted above.  No repair, PIR, or quantum advantage follows for free.
- A decorated inverse theorem at the conic phase is possible only after supplying a Coxeter marking;
  the bare child cannot choose among the exact coset counts.  H3's matching decoration is genuinely
  extra structure, while no equally rich A3/B3 marking has yet passed a novelty gate.
- Reducible rank-three systems have no single irreducible Coxeter number and do not belong to this
  theorem.  Adding them would produce product/pencil cases rather than strengthen the flagship.

The bounded successor portfolio is now allocated as C403--C405.  C403 asks whether flag-coboundary
data gives the distance law from one arrangement-code theorem; C404 tests a uniform intrinsic
decoration and recovery geometry behind the `5,14,22` fibres; and C405 is the first rigorously
field-bounded twisted-cubic deepest-syndrome pilot.  Their stop rules explicitly reject larger
tables, bare coset reformulations, and unbounded rational-normal-curve escalation.  See
`notes/2026-07-20-c403-c405-c399-successor-portfolio.md`.

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

This report newly read **one external source in full** and **four external sources partially**.  The
theorem is proved positively and does not depend on an absence claim.  The audit bounds attribution
and asks whether a standard source already packages the Coxeter-number conic/code phase.

| source | read depth and access | boundary |
|:---|:---|:---|
| Denef--Loeser, *Character sums associated to finite Coxeter groups*, DOI `10.1090/S0002-9947-98-02025-X` | **partial**, published version, Introduction and Sections 1.1--1.5; shared-cache SHA-256 `9cd64541ae4052a871ac0b089957b88e1b4c11fc11009cb8e5b7d837e2fd2b6b` | Owns the finite-field Coxeter-arrangement triple `(V,G,Q)`, liftable good reduction, invariant quadratic form, and preserved degrees when the characteristic avoids the group order.  It studies character sums on the affine complement, not the projective complement code, the `q=h+1` conic equality, or the B3 deep-hole defect. |
| Ehrenborg--Klivans--Reading, *Coxeter arrangements in three dimensions*, arXiv:1501.05991v1 | **full text**, shared-cache SHA-256 `8ebb11afdd402af15d2b340d05e0ae2010b1b602b728e3e47716911273562bb1` | Characterizes real three-dimensional Coxeter arrangements by congruent spherical regions and a rank-two reflection criterion.  It supplies no finite-field complement, conic, or code theorem. |
| Monson--Schulte, *Modular Reduction in Abstract Polytopes*, arXiv:0805.1479 | **partial**, Sections 2--3.2; shared-cache SHA-256 `149eeb36d30adc3cba20813bc7dad33d7a42cc0f39de0f3f3b9e6ab501c019ee` | Owns modular reductions of crystallographic Coxeter groups and regular polytopes.  Its B-type cube family is compatible with the short/long-root split but does not supply the complement-code phase. |
| Palezzato--Torielli, *Combinatorially equivalent hyperplane arrangements*, arXiv:1906.05463 | **partial**, Sections 4, 6, and 7; shared-cache SHA-256 `01973a6ff9a6a09303473f787afad0b15e153d6d24b6ce6b761d0d2fac9c0003` | Owns the good/lucky-prime and Smith-period machinery for preserving intersection lattices.  C399 credits that boundary and uses exact rank-three ledgers for its code theorem. |
| Ball--Lavrauw, *Arcs in finite projective spaces*, arXiv:1908.10772v2 | **partial**, Sections 1--3; shared-cache SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4` | Supplies the standard arc/frame, conic/normal-rational-curve, and MDS dictionaries.  None is claimed as new. |

The exact searches

```text
site:arxiv.org "Coxeter number" conic complement reflection arrangement finite field
site:arxiv.org "reflection arrangement" conic finite field A3 B3 H3
site:arxiv.org "Coxeter arrangement" evaluation code complement
"reflection arrangement" "q+1" conic finite field Coxeter
"Coxeter arrangement" finite field complement conic
"A3" "B3" "H3" conic finite field reflection
```

were screened over returned titles/snippets on 2026-07-20.  They located general Coxeter-arrangement,
finite-field, topology, and invariant-theory sources, including Denef--Loeser, but no record naming
the displayed phase theorem.  This is bounded discovery coverage, not a priority proof.  MathSciNet,
zbMATH forward coverage, Google Scholar, and citation graphs are **NOT COVERED**.  The defensible
paper language is “a uniform Coxeter-number conic phase for these three integral rank-three models,”
not “the first such theorem” or “to our knowledge.”

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
- This is a portable flagship candidate and therefore consumes the C398--C402 paper-promotion slot
  only after the required Lean exit and manuscript-owner review.  It does not authorize accumulating
  C400--C402 as additional unrelated generalizations.
