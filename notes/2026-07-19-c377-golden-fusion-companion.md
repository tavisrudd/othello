# C377 companion — golden fusion and the chirality-forgetting quotient

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** unallocated theorem design and bounded pilot observation; no paper-facing computational
claim yet

**Parent:** `notes/2026-07-19-c377-clebsch-golden-descent.md`

**Siblings:** `notes/2026-07-19-c377-frobenius-chirality-companion.md` and
`notes/2026-07-19-c377-integral-moduli-companion.md`

## Executive thesis

C377's descent mechanism is prior art, but its exact integral map can still be productive when
transported into structures not studied by that prior art.  The best candidate is the relation
between the primitive rank-eight Clebsch syndrome scheme and its rank-four affine orthogonal
fusion.

The proposed central theorem is:

> The golden passage exchanging the two Clebsch presentations completes the projective `A5`
> syndrome action to the full conic stabilizer `PGL_2(11)`.  Its affine orbit scheme is exactly the
> rank-four orthogonal fusion of the rank-eight Clebsch scheme.  Thus golden chirality is fission
> data: adjoining or descending the golden orientation forgets that data and restores the full
> conic symmetry.

A stronger companion theorem would identify the q=11 deep-hole transform on marked Clebsch parents
as the quotient that forgets precisely this chirality:

```text
                         golden outer passage
         C_plus  -------------------------------->  C_minus
            \                                             /
             \                                           /
              \ D                                     D /
               \                                       /
                    common GRS deep-hole conic Q
                              |
                              v
                 rank-four PGL_2(11) orthogonal scheme.
```

This is a new use of C377 rather than a claim that its representation-theoretic descent is new.

## Reaction to the integral-moduli companion

The integral orientation-cover proposal is the correct global language for distinguishing an
ordered arc, an `A5` marking, a chirality orientation, an unmarked code, and an unmarked cubic
surface.  Its strongest features are:

- it forces the base category, stabilizers, and forgetful maps to be stated rather than inferred;
- it treats characteristic five as a ramified or stacky fiber rather than a numerical exception;
- it distinguishes field of moduli from field of definition; and
- it separates Benson's `H^2` obstruction, the chirality `H^1` torsor, and any double-six Brauer
  class.

Its principal risk is productivity.  A costly elimination may return only
`tau^2-tau-1`, its discriminant five, and the normalizer involution.  All are expected before the
moduli computation.  The cover becomes a flagship only if forgetting its orientation changes or
controls a concrete recoverable object.

The fusion proposal supplies such an object.  The oriented points of the moduli cover should map
to rank-eight `A5` fissions of a common rank-four orthogonal scheme.  Quotienting by the orientation
involution should map to the common orthogonal fusion.  In this form the moduli cover does not
merely remember a quadratic coordinate: it parameterizes extra association-algebra structure that
is present before descent and absent afterward.

Accordingly the fixed elimination falsifier should be followed, not preceded, by the q=11 fusion
gate below.  If no fission or deep-hole information descends functorially from the moduli cover,
the global stack project should take its yellow off-ramp.

## Bounded q=11 pilot observation

A scratch calculation using C341's exact q=11 `A5` matrices and C377's displayed matrix

```text
J = [ 1  0  0 ]
    [ 0  0 -1 ]
    [ 0 -1  0 ]
```

found the following.

```text
|<A5,J>| = 1320                         projectively;
projective orbit sizes = 12, 55, 66;
affine nonzero orbit sizes = 120, 550, 660.
```

The affine orbits are exactly the C372 rank-four fusion blocks:

```text
relation 3        size 120,
relations 2,4,7   size 550,
relations 1,5,6   size 660.
```

The group preserves the invariant conic.  Its order equals the order of the full projective conic
stabilizer, so the intended identification is

```text
<A5,J> = Stab_PGL3(Q) ~= PGL_2(11).
```

This is only a bounded scratch observation.  It is not yet backed by a task-owned generator,
canonical certificate, independent replay, or source audit and therefore is not released as a
paper-facing theorem.  C378 is the natural owner of its exact certification because C378 already
tests how C377's map interacts with the `H3` pairing and C372 Fourier duality.

The pilot also kills one tempting route.  C372's unexplained rank-six fusion has projective block
sizes `10,18,45,30,30`, which suggested an `A6` or Valentiner action.  The actual golden closure is
the order-1320 conic group and gives the rank-four fusion instead.  Since every cross-fiber map is
`J` times a same-fiber `A5` map, choosing another one of the sixty outer projectivities produces
the same generated group.  The golden passage should not be used to explain the rank-six fusion.

## Theorem A — golden symmetry completion

Let `G` be the projective `A5` preserving the q=11 `tau=8` Clebsch hexagon, let `Q` be the invariant
deep-hole conic, and let `j` be the reduction of C377's integral map.

The theorem target is:

1. `j` preserves `Q` and carries the `tau=8` marked parent to the `tau=4` parent with the outer
   label character;
2. the projective group generated by `G` and `j` is the full conic stabilizer
   `PGL_2(11)` of order 1320;
3. its three projective orbits are the conic and the two anisotropic norm types, of sizes
   `12,55,66`; and
4. after scalar lifting to `F_11^3`, its translation orbit scheme is exactly C372's rank-four
   orthogonal fusion.

The conceptual proof should use the quadratic form and the classical conic stabilizer after one
small exact generation or subgroup-index certificate.  A black-box permutation-group order alone
is not the desired proof.

### Productivity requirement

The group equality and orthogonal orbit sizes are classical once the subgroup is known.  The
paper-facing contribution must be the compatibility statement:

> the same integral passage that exchanges the arithmetic/code chirality is precisely what closes
> the Clebsch syndrome fission to its orthogonal fusion.

If source audit finds this compatibility already stated, retain it only as explanatory glue.

## Theorem B — deep-hole transform as a chirality quotient

C368 already proves that both q=11 golden parents have the same complete projective deepest-
syndrome locus `Q(F_11)`, and C377's `J` preserves `Q`.  This gives equivariance but not yet a
two-to-one quotient theorem.

The stronger target requires a precise moduli category.  Restrict first to `A5`-marked six-arcs
with the fixed invariant form and degree-six action.  Prove that:

1. the two golden Clebsch markings are the complete fiber of the deep-hole transform above the
   marked conic child;
2. the outer character exchanges the two parents and acts trivially on the child;
3. forgetting the `A5` orientation identifies the two parents; and
4. the child's full `PGL_2(11)` symmetry is the symmetry completion in Theorem A.

The phrase “two-to-one” is invalid on unmarked projective or monomial-equivalence classes if the
two parents are already equivalent there.  The theorem must state exactly which marking makes the
fiber a torsor.

### Cheap classification gate

Avoid a census of all six-arcs.  Solve only the `A5_6`-equivariant fiber over `Q`:

1. classify six-point `A5/D5` orbits compatible with the fixed conic form;
2. impose that their fifteen secants have complement exactly `Q(F_11)`;
3. quotient by same-fiber `A5`, not the outer normalizer; and
4. check whether exactly the two golden markings remain.

**Green:** the fiber is exactly one free `C2` torsor and this identification is intrinsic.

**Yellow:** both parents map to the same child but the fiber contains other marked parents or the
two-point statement is only a coordinate artifact.

**Red:** the transform is not well-defined on the proposed marked moduli category.

## Theorem C — conjugate fissions and a signed Fourier algebra

Let `X_plus` and `X_minus` be the two rank-eight orbit partitions after placing the golden-conjugate
parents in one fixed syndrome space.  Compute:

1. their common coarsening;
2. the coherent closure of both partitions together;
3. the invariant and anti-invariant spans under `J`;
4. convolution and entrywise-product rules among those spans; and
5. Fourier action using the invariant `H3` pairing.

The first expected output is that the invariant orbital partition is the rank-four orthogonal
fusion.  The higher-upside output is a `C2`-graded algebra

```text
even * even  contained in even,
even * odd   contained in odd,
odd * odd    contained in even,
```

whose odd part records the lost golden orientation.  A Fourier-stable grading would turn the
arithmetic character into a signed MacWilliams transform or an exact signed syndrome statistic.

### Stop rule

Do not promote a direct sum of two isomorphic Bose--Mesner algebras, a full matrix algebra coherent
closure, or a grading forced formally by adjoining any involution.  The odd component must have a
canonical basis, a nontrivial multiplication law, or a code/decoder observable.

## Theorem D — Cremona, Galois, and code comparison

C376's quintic Cremona passage exchanges the two blowdown rows.  C377's linear Galois projectivity
preserves each row while carrying the golden fiber to its conjugate.  They are different maps with
the same image in `S5/A5`.

There are two exact comparison questions.

1. Do the two routes form a commuting square after the canonical double-six correspondence, or do
   they differ by an `A5` element?
2. If they differ, is the resulting `A5` conjugacy class, cocycle, or holonomy independent of all
   allowed choices?

An arbitrary comparison element is not an invariant because the set of identifications is an
`A5` torsor.  Promote only an identity forced by naturality or a choice-independent conjugacy
class with an incidence, code, or Picard consequence.

The quotient-level triangle is already exact and useful:

```text
birational blowdown exchange
             \
              \ same character in S5/A5
               \
golden Galois passage -------- monomial code-chirality exchange.
```

It should be included in the paper even if no finer holonomy survives, while crediting the
classical ingredients.

## Arithmetic and moduli integration

If Theorems A and B pass, the integral-moduli companion gains a concrete functor:

```text
oriented A5 six-arc moduli
          |
          | construct syndrome orbit algebra
          v
rank-eight Clebsch fission
          |
          | forget golden orientation / adjoin outer passage
          v
rank-four orthogonal scheme.
```

The moduli orientation cover is then productive because its two sheets parameterize fissions of a
common descended algebra.  The characteristic-five fiber should test whether this fission cover
ramifies, coalesces, or becomes internally oriented when the parent itself becomes the conic.

The Frobenius companion should likewise be sharpened.  Recovering `chi_5(p)` from the field
characteristic is tautological.  A genuine arithmetic theorem would show that Frobenius acts on an
intrinsically reconstructed pair of fissions or on a signed adjacency module, and that the
invariant algebra is the descended fusion.

Across other primes the number and sizes of `A5` syndrome orbits may change, so no all-prime
rank-eight family is assumed.  The first global task is to define the oriented orbital object whose
specialization is allowed to change rank and to prove that its descent remains functorial.

## A possible representation-theoretic formulation

The exact phenomenon may be cleaner in permutation-module language than in moduli language.  Let
`A5` act through the golden three-dimensional representation on the projective plane, and consider
the permutation module on nonzero syndrome vectors or projective directions.  The two Galois-
conjugate `A5` orbital decompositions refine the three norm orbits of the ambient orthogonal group.

The theorem target is that the orthogonal orbital algebra is the Galois-invariant descent of the
golden `A5` orbital algebra, while an anti-invariant module records the orientation.  This would
explain why Benson's linear representation descends with trivial obstruction even though the
marked orbital decomposition retains a nontrivial `H1` class: the representation descends, but a
chosen fission does not.

This is a concrete answer to the obstruction ladder:

```text
linear representation                descends;
orthogonal orbit algebra             descends;
choice of golden A5 fission          remains a two-sheet torsor.
```

No Brauer comparison is required for this first theorem.  The cubic-surface class becomes a later
test of whether the same oriented fission is visible in Picard geometry.

## Ranked execution plan

1. **Certify the q=11 group closure and fusion equality.**  Produce a task-owned exact bundle and
   independent replay; identify the group conceptually as the full conic stabilizer.
2. **Run a claim-specific source audit.**  Search for this `A5`-to-`PGL_2(11)` completion, the exact
   orbital fission/fusion, and Galois descent of association schemes or coherent configurations.
3. **Classify the marked deep-hole-transform fiber.**  Stop at the `A5_6`-equivariant locus rather
   than enumerating all q=11 six-arcs.
4. **Compute the conjugate-fission coherent closure and signed algebra.**  Continue only with a
   nontrivial canonical odd component.
5. **Attach the integral moduli orientation cover.**  Promote the global stack only if it
   parameterizes the fission or quotient established above.
6. **Run the split/inert pilot.**  Ask whether Frobenius acts on the intrinsic fission data, not
   whether one can recompute the Legendre symbol.
7. **Compare the cubic-surface obstruction classes.**  This remains last because its maps and
   source boundaries are least mature.

The first step fits C378's existing common-duality/Fourier scope.  No additional task should be
allocated before its exact gate and literature disposition.

## Red-team stops

- The rank-four affine orthogonal scheme and its full conic symmetry are classical.  Novelty must
  lie in the exact arithmetic/code/fission compatibility.
- C377's `J` is not C376's row-exchanging Cremona transformation.
- The two golden parents are projectively or monomially equivalent after allowing the outer map;
  a two-point fiber exists only in a correctly marked category.
- The rank-six fusion is not explained by adjoining any C377 outer cross-fiber map.
- A quadratic cover, Legendre symbol, Artin `L`-function, or Hilbert-90 identity is not productive
  without an intrinsically recovered fission or signed statistic.
- Equality of dimensions or orbit counts does not prove equality of association schemes; compare
  the actual relation sets and multiplication tensors.
- A `C2` grading manufactured from a direct sum is not a new algebraic structure.
- The moduli elimination is not promoted merely because it returns the expected golden polynomial.
- Do not use Lean to force a common abstraction before the mathematical comparison maps stabilize.
- Do not enlarge to `A6`, Valentiner geometry, or other famous objects after the exact q=11 closure
  has already selected `PGL_2(11)`.

## Valuable off-ramps

1. **A only:** use golden symmetry completion as the conceptual explanation of C372's rank-four
   fusion and C368's conic child.
2. **A plus B:** promote the deep-hole transform as the marked chirality quotient.
3. **A plus C:** promote arithmetic orientation as a Fourier-stable fission datum.
4. **Moduli only:** retain a precise field-of-moduli/field-of-definition theorem without claiming
   a new scheme.
5. **Everything after A fails:** keep C376 as the gateway theorem and C377 as elegant credited
   arithmetic glue; the certified paper remains intact.

## Lean hand-back

C380 can formalize the stable generic implications after the mathematical gates close:

- adjoining a group element coarsens orbit partitions according to generated-group orbits;
- equality of the certified orbit blocks gives the stated fusion;
- a nontrivial quotient character does not choose a sheet;
- uncovered projective points are exactly one-point arc/MDS extensions; and
- the deep-hole quotient statement, if its marked category is fixed.

The finite group order, orbit blocks, and relation-set equality should enter through bounded
checker leaves with an import-only paper-facing gate.  The full cubic-surface construction,
association-scheme library, and integral moduli stack remain outside the first Lean slice.

## Promotion standard

The decisive paper-facing sentence must be stronger than “golden conjugation acts in several
places.”  The target is:

> Golden orientation is exactly the extra datum that fissions the conic's orthogonal error algebra;
> arithmetic descent and the deep-hole transform forget that datum in two different mathematical
> languages.

If exact work cannot make “exactly” true, the companion remains a source of exposition and bounded
future questions rather than a new crown.
