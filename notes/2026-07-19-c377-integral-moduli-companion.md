# C377 companion — integral moduli orientation cover

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** unallocated successor design, recalibrated after C378/C379; does not reopen C377

**Parent:** `notes/2026-07-19-c377-clebsch-golden-descent.md`

**Sibling:** `notes/2026-07-19-c377-frobenius-chirality-companion.md`

## Decision

The most creative global successor to C377 is not another descent matrix and not a prime-by-prime
restatement of quadratic splitting.  It is to construct the moduli object whose fibers produce the
golden conjugate arcs, intrinsic code chirality, and characteristic-five coalescence.

The provisional flagship is:

> Construct the integral orientation cover of the `A5`-equivariant Clebsch six-arc locus, determine
> its normalization and discriminant, recover the cover intrinsically from the unmarked code or
> syndrome graph, and compute what survives under the forgetful maps to the cubic surface and
> Benson's descended representation.

This companion designs that project and ranks the genuinely different alternatives behind it.  It
allocates no task, asserts no theorem or novelty, and does not displace the live C380 foundation
gate.

## Why moduli is the right next level

C377 proves an exact integral conjugate-fiber identity, but Benson already owns the general linear
descent mechanism and its trivial relative-Brauer obstruction.  The arithmetic content that remains
is distributed among several kinds of marking:

```text
golden root tau
    |
ordered six-arc
    |
A5-marked projective configuration
    |
oriented 10+10 chirality sheet
    |
unoriented code / syndrome graph
    |
unmarked Clebsch cubic surface.
```

A moduli construction can say exactly where the quadratic choice enters, where it becomes a
two-cover, where it ramifies, and at which forgetful map it ceases to be an obstruction while
remaining intrinsically recoverable.  A list of finite-field specializations cannot by itself make
those distinctions canonical.

## C378/C379 calibration: two covers are not one fibre

C378 makes the orientation-cover idea more productive: the two golden rank-eight syndrome
fissions have a certified Fourier-self-dual rank-16 common refinement and a nonzero `J`-odd
sector.  A moduli orientation can therefore parameterize genuinely different algebraic structure,
not just the two roots of `tau^2-tau-1`.

C379 imposes a necessary correction.  Over the fixed q=11 deep-hole conic, the marked parent fibre
has 22 elements, not the two golden parents.  An individual parent is recovered by decorating the
conic with its canonical obstruction matching.  C379's independently replayed pre-freeze extension
proves that the 22 matchings split into two eleven-element `PSL_2(11)` orbits, each a
one-factorization of `K_12`, and that `J` exchanges the two systems.  See
`notes/2026-07-19-c379-one-factorization-biplane-companion.md`.

Thus the proposed global golden orientation cover may still be degree two, but its q=11 image in
the deep-hole construction would select one of two **eleven-parent systems**, not one of two
individual parents.  Recovering a parent requires the additional matching choice.  This finite
distinction is now certified; its focused source audit and a productive framed moduli map must
still precede any stack, normalization, or field-of-moduli build-up.

## Flagship theorem candidate

Let `A5_6 < S6` denote the exceptional degree-six action fixed by the Clebsch labeling.  Define a
moduli problem whose objects over a base scheme `B` are six sections

```text
(P_0,...,P_5) in P2_B
```

in the required arc/general-position locus, together with an `A5_6` action realized projectively on
the configuration.  Morphisms must state explicitly whether they preserve labels, preserve only
the `A5` marking, or may use the full normalizer.

The desired theorem has five layers.

### M1 — geometric fixed locus

The `A5_6`-equivariant six-arc locus modulo `PGL_3` is finite over its arithmetic base, with no
unrecorded positive-dimensional or embedded components.  Its generic geometric points are exactly
the two golden realizations.

### M2 — normalization and orientation

The normalization of the oriented locus is the correct integral golden order, conjecturally a
localization of

```text
Z[tau]/(tau^2-tau-1).
```

The normalizer quotient

```text
N_S6(A5)/A5 = C2
```

forgets orientation and produces the unoriented moduli object.  The induced degree-two map is the
same torsor recovered by C373's `10+10` triple orbits.

### M3 — discriminant and bad fibers

The orientation map is etale away from its exact discriminant and has a separately described
finite-flat or stacky fiber at characteristic five.  The characteristic-five fiber must explain,
scheme-theoretically rather than numerically, why:

- the two golden roots coalesce;
- the six points lie on the invariant conic;
- the stabilizer enlarges from `A5` to order 120; and
- the outer sheet exchange becomes an internal linear symmetry.

Characteristic two must be treated independently because the `H3` coordinate arrangement already
loses its fifteen-line lattice there.  Do not assume in advance that inverting only `2`, only `10`,
or neither gives the correct integral moduli problem.

### M4 — intrinsic recovery

The orientation cover descends through the correct forgetful map to an object recoverable from the
unmarked monomial code or its canonical quotient/syndrome graph.  No supplied projective columns,
golden root, `A5` generators, or names for the two sheets may enter the definition.

### M5 — arithmetic specialization

For every prime in the proved good locus, arithmetic Frobenius on the recovered fiber agrees with
the splitting character of the global orientation cover.  The split/inert/ramified law of the
Frobenius companion should then be a corollary of the moduli theorem, not an additional coordinate
calculation.

## Three possible base objects

The first task is to decide which moduli category is mathematically correct.  These alternatives
are not interchangeable.

1. **A coarse GIT quotient.**  Start from the open six-arc locus in `(P2)^6` and quotient by
   `PGL_3`.  This is computationally accessible but may forget stabilizers needed to define the
   orientation cover.
2. **A quotient stack.**  Retain projective automorphisms and define the `A5_6` fixed substack.
   This is likely the honest home for the normalizer action and ramified/enhanced-stabilizer fiber.
3. **An explicit invariant ring.**  Fix a projective frame, solve the `A5` compatibility equations,
   and construct a finite algebra with residual gauge action.  This may be the cheapest exact
   certificate but must be proved equivalent to the intended moduli problem.

The project passes canonicity only when one of these models is chosen by proof, not convenience.

## Fixed elimination falsifier

Before a broad proof or literature audit, perform one exact symbolic elimination.

1. Fix four points as a projective frame and retain the two remaining points as variables.
2. Choose generators for the exceptional `A5_6 < S6` action.
3. Introduce projective matrices and column scalars realizing those generators.
4. Impose the group relations, six-point action, arc determinants, and general-position conditions.
5. Saturate by frame, determinant, and collision denominators.
6. Eliminate the projective matrices and gauge scalars.
7. Compute the reduced components, normalization, discriminant, and residual normalizer action of
   the resulting finite algebra.

The hoped-for cheap output is a quadratic algebra with the golden polynomial and one normalizer
involution.  That output is only a gate.  It is not yet a theorem that the algebra represents the
coordinate-free moduli problem.

### Automatic negative outcomes

- A positive-dimensional component means the proposed object was underspecified or the golden
  locus is not isolated; stop and classify the missing marking before continuing.
- Extra zero-dimensional components require geometric identification; do not discard them because
  they are not the expected golden pair.
- A quadratic polynomial obtained only after a coordinate choice is not an intrinsic orientation
  cover.
- If the normalization/discriminant computation is already a direct classical invariant-theory
  formula with no new code or chirality consequence, take the exposition off-ramp.

## Required productivity

At least one result must become provable only after the moduli cover is constructed.

Preferred consequences are:

1. the unmarked code determines the minimal field over which its oriented `A5` form exists;
2. the code or syndrome graph reconstructs the discriminant-five arithmetic cover;
3. every good finite-field specialization is classified as linear split or semilinear inert from
   the unmarked object alone;
4. the characteristic-five stabilizer jump is proved to be the ramified fiber of the same cover;
5. the exact field of moduli versus field of definition is computed at every marking level; or
6. a valid cohomological comparison computes the image of the orientation class in the cubic
   surface's double-six obstruction theory; or
7. the orientation cover maps functorially to the unordered pair of q=11 one-factorizations, while
   the matching-decorated fibre records the strictly finer 22-parent choice.

The statement “the moduli coordinate is `tau`” does not pass.  Neither does rephrasing the
discriminant of `x^2-x-1` as a moduli discriminant without proving representability and intrinsic
recovery.

## Secondary theorem — forgetful descent spectrum

If M1--M4 pass, compute the exact descent data along the tower

```text
ordered six-arc
  -> A5-marked arc
  -> chirality-oriented code
  -> unoriented monomial code
  -> syndrome graph
  -> unmarked cubic surface.
```

For every level record:

- automorphism group in the correct equivalence category;
- field of moduli;
- minimal field of definition;
- `H^1` marking torsor;
- `H^2` or Brauer obstruction, where defined;
- fiber of the forgetful map; and
- exact information recoverable from the next level.

The strongest likely phenomenon is:

> Linear and unmarked projective descent are defined over the base field, while orientation lives
> over the golden quadratic cover; forgetting orientation kills the obstruction but does not erase
> the ability of the unmarked combinatorial object to reconstruct the unordered torsor.

That statement is conjectural until every equivalence and recovery map is written explicitly.

## Secondary theorem — obstruction separation

The moduli object offers a natural place to test the three-level ladder

```text
Benson relative-Brauer lambda
        |
        v
orientation/chirality H1 class
        |
        v
Galois-invariant double-six Brauer class.
```

The goal is not to force the arrows to exist.  It is to construct them from functorial automorphism
group sequences or prove that no such comparison is natural.

Valuable outcomes include:

- `lambda=0` while the orientation class is nonzero, with a precise explanation of the forgotten
  marking;
- the double-six class is the transgression of the orientation class;
- the double-six class vanishes independently, separating surface descent from code orientation;
  or
- a no-map theorem showing that the three classes answer categorically different questions.

C377's row-preserving projectivity and C376's row-exchanging Cremona passage must remain distinct
throughout.  Equality of their quotient characters is input, not equality of cocycles.

## Alternative route — two-axis reduction phase diagram

If the moduli cover exists but does not yield a strong intrinsic consequence, the next bounded
question is the interaction of two independent arithmetic axes:

```text
golden splitting: split / inert / ramified,
modular behavior: p divides or does not divide |A5|=60.
```

The exceptional cells are potentially informative:

- `p=2`: arrangement and mirror-lattice collapse;
- `p=3`: lattice-good but modular/nonsemisimple representation theory;
- `p=5`: golden ramification, conic/GRS phase, and `A5 -> S5` enhancement;
- `p` prime to 60, split: two linear fibers; and
- `p` prime to 60, inert: one quadratic semilinear fiber.

A theorem would classify, in every cell, survival of the arc, marked double-six, Picard action,
code equivalence, intrinsic torsor, and stabilizer.  This is lower priority because integral `H3`
lattices and modular Coxeter reductions have substantial prior art.

## Alternative route — arithmetic shadow on the 27 lines

One may compute Frobenius on the Clebsch Picard lattice and ask for an intrinsic formula

```text
N_p(orientation 0) - N_p(orientation 1) = c * chi_5(p)
```

using rational lines, tritangent planes, double-sixes, or a graph/code count.  This passes only if
`N_p` is defined without a supplied orientation and yields a consequence not already immediate
from the permutation representation.

This route is crowded: Galois actions on 27 lines, rational-line counts, discriminants, and
symmetric cubic-surface monodromy are established research areas.  A zeta or Artin-factor
repackaging of a known line action is not a crown.

## Alternative route — integral refinement of Benson

Benson's invariant is defined over fields.  A possible integral refinement would classify
outer-compatible lattices in the golden three-dimensional representation and the local obstruction
to choosing a descent datum preserving an integral arc/code lattice.

Clebsch-specific questions are:

- Is C377's integral `J` unique up to the integral `A5` normalizer and scalar units?
- How many compatible lattice genera exist?
- Which local primes distinguish them?
- Does every rational Hilbert-90 normalization preserve an integral six-arc or code?
- Can the bad primes be predicted from a discriminant or locally free class?

This is mathematically legitimate but lower expected value unless it produces a sharp uniqueness or
bad-prime theorem beyond C346.

## Ranked research order

1. finish the focused source audit of the now-certified q=11 `11+11`
   one-factorization/biplane theorem;
2. run one framed fixed-locus elimination for the integral orientation cover;
3. continue to normalization or a moduli object only if steps 1--2 give a functorial productivity
   map rather than only the golden polynomial;
4. intrinsic Frobenius--chirality theorem from the sibling companion;
5. forgetful descent spectrum;
6. exact obstruction-separation theorem;
7. two-axis modular reduction phase diagram;
8. arithmetic 27-line observable; and
9. integral-lattice refinement of Benson.

The middle arithmetic and descent questions may be different faces of one successful project.  The
last three are fallback routes, not reasons to broaden the first computation.

## Evidence bundle if promoted

A promoted task should produce an atomic bundle containing:

1. a dated theorem or bounded-negative report;
2. exact defining equations for the framed moduli problem;
3. a deterministic elimination/normalization generator;
4. a compact canonical certificate containing components, dimensions, normalization, discriminant,
   normalizer action, and bad fibers;
5. an independent replay from a second frame or invariant-ring presentation;
6. explicit maps from the certificate to the coordinate-free moduli statement;
7. hashes and byte counts for every load-bearing artifact; and
8. a source-level and forward-citation audit of the exact moduli/chirality edge.

The trusted boundary must identify the computer algebra system, version, monomial order,
saturations, and every denominator inverted.  A black-box primary decomposition is not by itself a
proof that the intended stack or quotient was computed.

## Source boundary

Every source characterization records its present read depth.

- **David J. Benson, “Matrices for finite group representations that respect Galois
  automorphisms,” DOI `10.1007/s00013-023-01963-x`.  Read depth: full text.**  C377 read the cached
  arXiv v1 in full.  Benson owns the field-level cyclic descent criterion, relative-Brauer
  invariant, Hilbert-90 normalization, and golden three-dimensional `A5` example with trivial
  invariant.
- **Yuri Prokhorov, “Icosahedron in birational geometry,” arXiv `2411.15334v2`.  Read depth:
  partial.**  Sections 3.1, 3.1.3, and 3.2 were read.  They own the outer relation between the two
  representations and the classical exchange of the two `A5`-equivariant Clebsch contractions.
- **Andreas-Stephan Elsenhans and Jorg Jahnel, “Cubic surfaces with a Galois invariant
  double-six,” DOI `10.2478/s11533-010-0036-1`.  Read depth: abstract/metadata only.**  The
  consulted publisher and EUDML records state that the paper constructs smooth cubic surfaces over
  `Q` with Galois-invariant double-sixes and develops explicit descent from hexahedral form.  Its
  body is mandatory before an obstruction-comparison claim.
- **Andreas-Stephan Elsenhans and Jorg Jahnel, “On the Brauer--Manin obstruction for cubic
  surfaces,” arXiv `1011.1430`.  Read depth: abstract/metadata only.**  The abstract states that a
  Brauer class is attached to each Galois-invariant double-six and that every order-two class is
  obtained this way.
- **Eric Pichon-Pharabod and Simon Telen, “Galois Groups of Symmetric Cubic Surfaces,” arXiv
  `2509.06785`.  Read depth: abstract/metadata only.**  The arXiv abstract describes certified
  monodromy computations for `S5`-subgroup-invariant cubic-surface families and their discriminants.
  It is a mandatory recent source before claiming a new symmetric-family moduli or monodromy
  computation.
- **Stephen McKean, “Rational lines on smooth cubic surfaces,” arXiv `2101.08217`.  Read depth:
  abstract/metadata only.**  The abstract gives arithmetic criteria and large-finite-field
  sufficiency for possible rational-line counts.  It bounds any proposed novelty based only on line
  counts.

No absence or priority verdict follows from this source list.  A promoted theorem requires the
repository's full literature-audit protocol, including full-text reads of every directly
load-bearing moduli and double-six source and forward-citation closure.

## Promotion and hand-back

The smaller C379 one-factorization certificate is complete; finish its focused audit.  Then run
only the fixed elimination falsifier before deciding whether this design deserves allocation.  If
both expose a functorial orientation-to-structure map and the intrinsic-recovery consequence remains plausible,
allocate a new `crowns` C-ID for the integral moduli orientation cover.  Never reuse C377 or
silently expand C378, C379, or C380.

If the elimination gives only the classical golden polynomial with no moduli-level consequence,
retain this file as an unpromoted companion.  If the global moduli construction fails but the
unmarked graph still recovers Frobenius chirality, the sibling companion remains independently
viable at its narrower scope.
