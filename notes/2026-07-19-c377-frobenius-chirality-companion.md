# C377 companion — intrinsic Frobenius chirality after trivial linear descent

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** unallocated successor design; does not reopen C377

**Parent:** `notes/2026-07-19-c377-clebsch-golden-descent.md`

## Decision boundary

C377 closed correctly at its bounded-negative gate.  Benson already proves the characteristic-zero
representation-theoretic mechanism: the two golden three-dimensional `A5` representations are
related by Galois conjugation and an outer automorphism, and the relative-Brauer obstruction
`lambda(rho)` is trivial.  C377's integral matrix, split/inert/ramified specialization, and exact
Clebsch realization therefore do not constitute a new descent mechanism.

The surviving question is not how to find another intertwiner.  It is:

> What intrinsic arithmetic information remains visible in the unmarked Clebsch code, syndrome
> graph, and double-six after ordinary linear descent has become unobstructed?

This companion scopes one creative answer.  It allocates no task, asserts no novelty, and does not
alter the C378--C380 execution order.  Promotion requires a fresh global C-ID and a claim-specific
literature audit.

## Questions exposed by C377 and Benson

1. **Linear descent versus arithmetic orientation.**  Benson's `lambda(rho)=1` says that the
   representation can be put in an outer-compatible descended form.  Why does C373's intrinsic
   unordered `10+10` chirality torsor nevertheless retain a nontrivial exchange character?
2. **Intrinsic recovery.**  Can split versus inert behavior be recovered from the unmarked code or
   syndrome graph, without supplied `tau`, projective columns, `A5` generators, or names for the two
   chirality sheets?
3. **Frobenius law.**  Does arithmetic Frobenius act on the recovered two-set by the quadratic
   character

   ```text
   chi_5(p) = (5/p)?
   ```

4. **Ramification.**  Is the characteristic-five enhancement
   `A5 < S5 = PGL_2(5)` the ramified fiber of the same intrinsic two-cover, rather than a separate
   stabilizer coincidence?
5. **Obstruction comparison.**  How are Benson's linear relative-Brauer invariant, the outer
   chirality `H^1` class, and the Brauer class attached to a Galois-invariant double-six related?
   A priori they live in different categories and need not agree.
6. **Productivity.**  Does the recovered arithmetic class determine an equivalence field, a
   Frobenius-fixed structure, a code invariant, or another conclusion unavailable from either the
   representation or surface alone?

## Flagship candidate

### Intrinsic Frobenius--chirality theorem

The intended theorem should have a coordinate-free statement of the following form.

Let `C_P` be a good odd-prime reduction of the Clebsch six-column code, considered only up to the
correct unmarked monomial equivalence.  Form its canonical quotient/syndrome graph.  Recover from
that graph:

1. its characteristic translation subgroup;
2. the six scalar-direction blocks as intrinsic maximal cliques;
3. the induced projective `A5` action on those six blocks; and
4. the unordered pair `T_P` of its two ten-element orbits on three-subsets.

The target assertions are:

1. `T_P` is independent of every supplied coordinate, golden-root, and sheet choice;
2. the family `T` is the arithmetic two-cover attached to `Q(sqrt(5))/Q` away from the bad fibers;
3. for an unramified rational prime `p`, Frobenius acts on `T_P` by

   ```text
   identity       if p = +/-1 mod 5,
   sheet exchange if p = +/-2 mod 5;
   ```

4. at `p=5` the cover ramifies, the golden fibers coalesce on the invariant conic, and the outer
   sheet exchange becomes an internal linear element of the order-120 stabilizer; and
5. at `p=11`, the recovered exchange is exactly the C376/C377 outer character, not merely an
   abstract isomorphic `C2` action.

The theorem must be stated over the largest base on which the recovered object is actually
canonical.  Writing an etale cover over `Z[1/10]`, a finite flat cover across characteristic five,
or only a prime-by-prime theorem are different claims.  Do not choose among them before the
stabilizer and bad-fiber computation fixes the correct category.

## Required new consequence

Recovering `sigma(tau)=1-tau` after restoring the golden coordinates is tautological and does not
pass.  At least one of the following must be proved intrinsically:

- the unmarked finite-field code determines whether its golden `A5` form is linearly defined over
  the prime field or only semilinearly over its quadratic extension;
- the syndrome graph recovers `chi_5(p)` from its own automorphism/incidence structure;
- a canonical Frobenius-fixed count or graph/code invariant distinguishes split and inert primes;
- the minimal field of monomial equivalence between the two golden fibers is reconstructed from
  the unmarked code; or
- a comparison map places the chirality class nontrivially in the cubic-surface obstruction
  sequence and computes its image.

An `L`-function sentence is not by itself productive: the zeta function of a manually supplied
quadratic two-set simply repackages the Dirichlet character.  Such a consequence counts only if the
two-set and Frobenius action have first been recovered from the unmarked object.

## Obstruction ladder

The most conceptually ambitious version compares three distinct levels.

```text
representation level
  Benson lambda(rho) in H^2(Gal(L/K), L^*)             = trivial
                  |
                  | forget / transport, to be constructed
                  v
intrinsic marking level
  chirality torsor epsilon in H^1(Gal, S5/A5)          = potentially nontrivial
                  |
                  | connecting/transgression map, if it exists
                  v
cubic-surface level
  double-six class beta in Br(S)/Br(K) or a Picard H^1 = to be computed
```

This is a research diagram, not a claimed exact sequence.  The first obligation is to name the
automorphism groups and functorial maps that could induce its arrows.  In particular:

- a `GL_3` or `PGL_3` descent datum is not a marked-six-arc descent datum;
- C377's `J` preserves the `E` and `Q` rows separately, whereas C376's quintic contraction exchanges
  the two blowdowns;
- equality of their quotient characters does not identify their cocycles; and
- a Brauer class attached to a Galois-invariant double-six is not automatically Benson's relative
  Brauer invariant.

A strong positive theorem would explain how `lambda(rho)` can vanish while `epsilon` remains
nontrivial, and would compute whether `beta` is its image, zero for an independent reason, or an
obstruction of a genuinely different kind.  A proved incompatibility or zero-map theorem would
also be valuable if it sharply separates the three notions.

## Cheap falsifier

Before any general proof or new literature sweep, run the fixed prime set

```text
p = 3, 7, 11, 13, 19, with p=5 treated separately.
```

The predicted unramified behavior is:

| `p` | class mod 5 | expected phase | expected action on recovered torsor |
|---:|---:|:---|:---|
| 3 | -2 | inert | exchange |
| 7 | 2 | inert | exchange |
| 11 | 1 | split | fix |
| 13 | -2 | inert | exchange |
| 19 | -1 | split | fix |
| 5 | 0 | ramified | coalescence / internal outer element |

For each prime, starting from the unmarked object only:

1. build the quotient graph and compute its full color-preserving automorphism group;
2. test whether the characteristic translation subgroup is intrinsic;
3. recover the six direction blocks and the `10+10` torsor;
4. compute Frobenius on that torsor;
5. compare with `chi_5(p)`; and
6. record every enhanced-stabilizer or small-field exception that destroys canonicity.

This is a falsifier, not evidence for an all-prime theorem.  Its canonical output should include
the exact recovered objects, automorphism orders, Frobenius permutation, exception reason, and an
independent replay from the code rather than the original coordinates.

## Stage gates

### F0 — intrinsic-object gate

**Pass:** the unmarked code or graph canonically recovers the six direction blocks and an unordered
`10+10` torsor at every pilot outside an explicitly classified exceptional set.

**Stop:** the torsor appears only after supplying projective columns, an `A5` subgroup, or a golden
root; or enhanced automorphisms merge the two sheets without an intrinsic refinement.

### F1 — arithmetic-character gate

**Pass:** recovered Frobenius agrees with `chi_5` on every pilot, including a separately explained
ramified characteristic-five fiber, and a symbolic argument identifies the all-prime mechanism.

**Stop:** the agreement is merely the coordinate identity `tau^p=1-tau`, or exceptions have no
uniform invariant formulation.

### F2 — obstruction-ladder gate

**Pass:** explicit automorphism-group morphisms produce a valid cohomological comparison and at
least one class/image is computed nontrivially.

**Yellow off-ramp:** the torsor theorem is intrinsic and productive, but the surface comparison is
only a classical dictionary.  Publish or use only the exact torsor scope.

**Stop:** the proposed arrows compare unrelated cohomology sets, depend on hidden markings, or
reduce to equality of two abstract groups of order two.

### F3 — consequence gate

**Pass:** transport determines a field of equivalence, recoverable arithmetic character, exact
fixed-point law, or other invariant not visible at either endpoint alone.

**Stop:** the conclusion is only that the same quadratic character can be written in several
languages.

### F4 — literature gate

Only after F0--F3 produce an exact candidate theorem, run full-text and forward-citation closure on
that edge.  The audit must cover intrinsic code/graph recovery, outer-compatible representation
descent, arithmetic two-covers, and Galois-invariant double-six Brauer classes.  No priority wording
precedes this gate.

## Automatic scope stops

- Do not search for another golden intertwiner; C377 already has the clean integral one and Benson
  owns the general mechanism.
- Do not claim novelty for quadratic splitting, Hilbert 90, the Legendre symbol, or an `A5` outer
  automorphism.
- Do not call a supplied two-sheet set intrinsic.
- Do not identify C376's row-exchanging Cremona map with C377's row-preserving projectivity.
- Do not call a code equivalence a physical or quantum equivalence.
- Do not generalize to other finite groups before the Clebsch pilot produces a new consequence.
- Do not let a failed obstruction-ladder comparison weaken the already certified C376 theorem.

## Adjacent fallback

If intrinsic Frobenius chirality fails only because the unmarked graph has enhanced automorphisms,
the bounded fallback is an **integral refinement of Benson's invariant**:

> classify outer-compatible `A5` lattices in the golden three-dimensional representation, their
> local equivalence classes, and the exact primes where reduction changes the normalizer or loses
> the marked six-arc/double-six structure.

This is lower expected value.  Integral `H3` lattices and modular Coxeter reduction have substantial
prior art, so it should proceed only after a cheap source audit and only if the classification
produces a Clebsch-specific invariant beyond C346's good-reduction theorem.

## Source boundary

Every characterization below carries the read depth inherited from or added to C377.

- **David J. Benson, “Matrices for finite group representations that respect Galois
  automorphisms,” DOI `10.1007/s00013-023-01963-x`.  Read depth: full text.**  C377 read the cached
  arXiv v1 in full.  Benson owns the cyclic Galois/outer-automorphism criterion, the relative-Brauer
  invariant, Hilbert-90 normalization, and the explicit golden three-dimensional `A5` example with
  trivial invariant.
- **Yuri Prokhorov, “Icosahedron in birational geometry,” arXiv `2411.15334v2`.  Read depth:
  partial.**  C377/C376 read Sections 3.1, 3.1.3, and 3.2.  These sections own the outer relation
  between the two three-dimensional representations and the classical exchange of the two
  `A5`-equivariant Clebsch contractions by `S5-A5`.
- **Andreas-Stephan Elsenhans and Jorg Jahnel, “Cubic surfaces with a Galois invariant
  double-six,” DOI `10.2478/s11533-010-0036-1`.  Read depth: abstract/metadata only.**  The
  publisher and EUDML records state that the paper constructs smooth cubic surfaces over `Q` with
  Galois-invariant double-sixes and develops explicit descent from hexahedral form.  No theorem or
  formula from its body is relied upon here.
- **Andreas-Stephan Elsenhans and Jorg Jahnel, “On the Brauer--Manin obstruction for cubic
  surfaces,” arXiv `1011.1430`.  Read depth: abstract/metadata only.**  The arXiv abstract states
  that a Brauer class is associated to every Galois-invariant double-six and that all order-two
  classes arise this way.  The exact comparison with the Clebsch descent datum remains unread and
  is a mandatory F4 source.

The creative gap is therefore the intersection, not any endpoint in isolation: intrinsic recovery
of the arithmetic chirality character from the unmarked code/graph, followed by a valid comparison
with the already distinct linear and cubic-surface obstruction theories.

## Allocation and hand-back

If the fixed-prime F0/F1 pilot passes and supplies a genuinely intrinsic consequence, allocate a
new `crowns` C-ID for the Frobenius--chirality theorem.  Do not reuse C377 or silently fold it into
C378, C379, or C380.  If the pilot fails, record the bounded negative under the newly allocated task
only if allocation preceded substantive work; otherwise retain this companion as an unpromoted
research design.

C380 may eventually formalize the distinction among the three obstruction levels, but only after
the mathematical maps stabilize.  Lean should not be used to manufacture a relationship between
cohomology classes whose functorial comparison has not first been proved on paper.
