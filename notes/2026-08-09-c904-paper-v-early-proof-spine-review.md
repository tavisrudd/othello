# C904 — Paper V early proof-spine review

**Date:** 2026-08-09  
**Lane:** `clebsch`  
**Surface reviewed:** `notes/2026-08-09-c904-paper-v-proof-spine-and-exposition-map.md`  
**Mode:** three sealed reads; no reviewer saw another review

## Verdict

**MAJOR at the packet level; productive kill gate found before drafting.**

All three readers independently located the same first unsupported arrow:
Paper II's outer-odd matching-sheet tensor has not yet been transported to
the six-axis triangle cubic.  Agreement of stabilizers, characters, or
two-element orientation torsors is not enough.  Paper V may make a
three-source claim only after it constructs the actual equivariant map and
checks the cubic under that map.

No finding challenges the already proved Paper-I cubic reconstruction or the
relative Paper-III conference source.  The failure is in the proposed
assembly, not in a released theorem.

## Correctness findings

1. The proposed common object stored both a switching class `[C]` and a
   representative-level equation `C^2=5I`, while allowing switching among its
   morphisms.  Those levels must be separated.
2. The proposed target already contained `C` and `Z`, making parts of the
   advertised reconstruction circular.  The paper needs distinct source and
   target data types and an explicitly named inverse between them.
3. Recovering coefficients from six singular nodes requires a normalization
   theorem.  The node frame alone recovers coordinates only projectively.
4. Agreement on one normalized representative does not descend until
   switching and relabelling equivariance, including stabilizers, is proved.
5. `Q[C]` as an unpointed quadratic algebra must be distinguished from the
   oriented embedding sending a chosen golden generator to `(I+C)/2`.
6. The determinant-line norm convention must be reconciled with the current
   Paper-III normalization before it can enter the theorem.

## Paper-II kill gate

For a marked `H_3` matching, its stabilizer `A_5` acts on the six matched
pairs.  Their augmentation is a five-dimensional irreducible module.  The
Paper-II affine quotient restricts to `1 + 4 + 5`, so it has a unique
five-dimensional constituent.  This makes a bridge plausible but does not
prove it.

The required lemma is:

> construct a marking-natural `A_5`-equivariant identification between the
> six-pair augmentation and the five-dimensional constituent of the
> Paper-II output, then prove that pulling back the recovered signed tensor
> `mu_3` gives the reduction of the oriented triangle-holonomy cubic with the
> declared scalar and outer sign.

Multiplicity one of the module does not settle the cubic: the
five-dimensional `A_5` representation has a two-dimensional space of
invariant cubics.  An exact coefficient comparison is load-bearing.  The
round trip must then specify whether it returns the full Paper-II tensor or
only its marked five-dimensional golden residue.

If this lemma fails, the honest fallback is a two-source theorem for Papers I
and III, with Paper II retained only as a character/orientation comparison.
That would not justify a headline claiming three reconstructions.

## Exposition findings

- Put a compact object table before the theorem.  Define markings, retained
  outputs, forgotten parent data, and involutions there.
- Give Paper II most of the transport section; the inherited Paper-I and
  Paper-III inputs should be short stable-locator imports.
- Prove one common inverse and tabulate what each source recovers, rather than
  repeating three nominally different inverse proofs.
- Use “lossless” only for the explicitly retained golden residue.
- Keep Paper IV in the series-scope paragraph and diagram, outside the literal
  cubic round trip.
- C809's shadow criterion earns a causal role only if it derives the
  conference identity from the cubic.  Otherwise state it as a corollary and
  do not make it look load-bearing.

## Revised publication gate

The proof spine may advance to manuscript drafting only when all of the
following are explicit:

1. concrete data types for the oriented cubic and oriented conference
   package, with their separate equivalence relations;
2. a normalized inverse from the cubic's intrinsic node frame to its
   triangle coefficients;
3. the Paper-II six-pair intertwiner and exact cubic comparison;
4. the exact Paper-II retained output returned by the inverse;
5. switching, relabelling, stabilizer, and orientation equivariance;
6. the unpointed/pointed quadratic-algebra distinction; and
7. a page map in which the new transport dominates the inherited material.

Until Gate 3 is settled, the manuscript title and abstract remain working
language only.
