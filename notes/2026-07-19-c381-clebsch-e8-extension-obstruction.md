# C381 — Clebsch eight-point extensions and the weak-`E8` obstruction

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** queued bounded exact gate; may run independently of C379's literature closure

**Parent:** `notes/2026-07-19-c373-clebsch-gateway-program.md`

**Inputs:** C379's fixed q=11 conic, complete 22-parent matching-decorated locus, two
one-factorizations, and independently replayed certificate

## Routing contract

Enter with:

```text
go C381
```

C381 owns the finite eight-point/weak-degree-one question.  It does not own the icosian lattice
comparison.  On completion:

- if the green gate below is recorded in the report and crowns handoff, promote C382 from gated to
  ready and hand back `go C382`;
- otherwise leave C382 gated, archive C381's exact theorem or bounded negative, and route through
  the next live `crowns` priority.

No worker may infer C382 readiness merely from the occurrence of an abstract `E8` Picard lattice.

## Exact starting correction

The smooth del Pezzo route proposed in the original C373 atlas is already obstructed by C379.
For every parent `X` in the complete 22-parent locus and every `p` on the child conic, the
seven-point set `X union {p}` contains a six-point conic.  Hence every eight-point extension

```text
X union {p,q}
```

contains that same forbidden six-point subset.  It cannot be in the general position required for
a smooth degree-one del Pezzo surface.  C381 must state this inheritance as a short conventional
proof before any enumeration.  A search for a smooth member is not authorized.

The surviving question is sharper:

> What weak degree-one surface and effective-root subsystem arise from each two-point extension,
> and does C379's matching/factorization structure canonically control that `E8` data?

## Frozen finite domain

Use the exact q=11 conventions and all 22 parents from C379.  For each parent `X` and each of the
66 unordered pairs `{p,q}` in `Q(F_11)`:

1. form the eight-point configuration `S=X union {p,q}`;
2. test whether `S` is an eight-arc and, when it is, certify the `[8,5,4]_11` parity-check kernel
   and `[8,3,6]_11` row dual;
3. classify the pair relative to the parent matching `M_X`, the two one-factorization sheets, and
   the exact `A5`, `PSL_2(11)`, and `PGL_2(11)` actions; and
4. compute the complete effective `(-2)`-root subsystem in `K^perp` for the blow-up at `S`.

The raw domain has only `22*66=1452` marked configurations.  Use group orbits for the proof and
the full domain for a bounded certificate; do not expand to arbitrary q=11 six-arcs.

## Full degree-one geometry test

For eight distinct planar points, “no three collinear” and “no six on a conic” are not the entire
degree-one general-position test.  C381 must also test the cubic root classes corresponding to a
cubic through all eight points with a double point at one of them.  In the standard blow-up basis,
enumerate all 240 roots of the abstract `E8` lattice, including the line, conic, and singular-cubic
types, and decide effectivity in fixed conventions.

With blow-up basis `H,E_1,...,E_8`, use the complete standard list

```text
E_i-E_j                                             (56 roots),
+/-(H-E_i-E_j-E_k)                                (112 roots),
+/-(2H-E_i1-E_i2-E_i3-E_i4-E_i5-E_i6)             (56 roots),
+/-(3H-2E_i-sum_(j != i) E_j)                      (16 roots).
```

For distinct points the first type records no infinitely-near effectivity.  The other positive
types are tested respectively by collinear triples, six-point conics, and cubics through all eight
with a double point at the distinguished point.  Verify the list and sign convention against the
chosen primary surface source before making it a trusted mathematical boundary.

Do not label a surface weak del Pezzo merely from a root count.  State and source the exact nef/big
criterion being used, test every required incidence, and record the resulting Dynkin type of the
effective-root subsystem.  Distinguish:

- the abstract Picard lattice `K^perp ~= E8` present for any eight blow-ups;
- effective `(-2)` roots caused by the special point configuration;
- the root subsystem contracted by the anticanonical model; and
- smooth, weak, and worse-than-weak degree-one behavior.

## Matching and orbit questions

The first predicted split is between the six edges of `M_X` and the other sixty pairs of conic
points.  Do not assume that this is the complete classification.  Compute the stabilizer orbits and
ask:

1. Does a matched pair, whose two points lie with five parent points on one conic, create a
   different effective-root type from an unmatched pair?
2. Do the two eleven-matching one-factorization sheets select different marked root systems, or are
   they exchanged without changing the unmarked type?
3. Is the root subsystem recoverable from `(Q,M_X,{p,q})` without the original six columns?
4. Does `J` exchange two root markings by the same quotient character as the cubic, code, scheme,
   and factorization sheets?
5. Is there a canonical root, root orbit, parabolic subsystem, or lattice flag that survives the
   relevant equivalence quotient?

Counts, equal Dynkin types, or the mere presence of 240 abstract roots do not answer these
questions.

## Promotion gates

### Green — unlock C382

All of the following are required:

1. a complete exact orbit/root classification with a conceptual proof;
2. a presentation-independent construction from C379's matching-decorated child;
3. a nontrivial marked `E8` invariant—root subsystem, orbit, flag, or embedding class—transported
   by the golden outer passage;
4. a consequence not implied solely by the standard blow-up/Picard dictionary; and
5. source closure showing exactly which compatibility, rather than which ingredients, remains.

### Yellow — close C381; keep C382 gated

The smooth obstruction and weak-surface/root census are exact and useful, but the matching sheets
select no canonical marked `E8` datum.  Retain the result as a sharp endpoint of the extension
ladder and do not invoke icosians.

### Red — close C381; keep C382 gated

No eight-arcs exist in the frozen domain, the configurations fall outside the weak-del-Pezzo
criterion without a clean classification, or every apparent `E8` connection is only the universal
Picard lattice of eight blow-ups.

## Evidence bundle

If computation is used, commit atomically under the C381 stem:

- this report with the final theorem or bounded negative;
- a deterministic primary generator/checker;
- a compact canonical JSON containing orbit representatives, incidence tests, code parameters,
  effective roots, Dynkin types, and stabilizers;
- an independent replay that reconstructs the parents and roots without importing the primary;
  and
- a checksum manifest with byte counts and exact commands.

The primary may consume C379 only through its pinned public certificate/checker boundary.  The
replay should reconstruct the finite geometry from formulas.  Canonically sort parent, pair, root,
and orbit labels; regeneration must be byte-identical.

## Literature gate

Before novelty language, follow the repository audit protocol for:

- eight-point general position and weak degree-one del Pezzo classifications;
- effective `E8` root subsystems and singular anticanonical models;
- finite-field eight-arcs and `[8,3,6]` MDS extensions over `F_11`;
- `A5` actions on degree-one del Pezzo surfaces and `E8`; and
- constructions relating matchings, one-factorizations, or biplanes to marked `E8` root systems.

C373's Baez and Manivel entries were read only at abstract/metadata depth.  They cannot support a
classification, novelty verdict, or icosian comparison.

## Hard exclusions

- No search for smooth degree-one examples after the inherited six-conic obstruction is proved.
- No all-prime or arbitrary-arc census.
- No claim that `[8,3,6]` alone supplies a canonical eight-party quantum extension.
- No 600-cell, icosian, Kleinian, Mathieu, or Witt escalation inside C381.
- No C382 hand-back without the exact green invariant and named comparison category.
