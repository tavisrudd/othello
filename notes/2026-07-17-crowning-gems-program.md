# Crowning-gems program: reconstruction and full conic continuation

**Date:** 2026-07-17  
**Lane:** `crowns`  
**Status:** theorem targets registered; source programs remain owned by their existing lanes.

## Purpose

This note records the theorem-scale results that could crown the wider finite-geometry, game,
coding, and formalization program. It is not a claim that those theorems are currently proved, nor
permission to duplicate work owned by `cap`, `continuation`, `dihedral`, or `clebsch`. The `crowns`
lane exists to keep the grand targets precise, expose their dependency structure, and recognize
when source-lane results have become strong enough to assemble them.

The current jewel is the Clebsch hexagon phenomenon: a non-GRS MDS code whose deep-hole directions
are exactly a conic, organized by `A5/H3` rigidity and isolated by small-field classification. The
targets below ask for a theorem of still greater reach: one that explains why the game structure is
tractable, why it remembers its geometry, or both.

## Crown I: full conic-continuation classification

### Aspirational theorem

Let `q` be an odd prime power and let `S` be a legal capacity-two off-conic configuration. Write
`T={sigma_x : x in S}` for its projection involutions, `G=<T> <= PGL2(q)`, and `R_S` for the
fixed-point-deleted Schreier graph governing conic-only continuation. Then the information relevant
to the Sprague-Grundy value of `R_S` is determined by explicit subgroup, orbit, and arithmetic data;
in particular, its exact value—or at minimum its P/N outcome—is computable by a uniform theorem
covering the classified proper groups and the growing full/subfield linear-group cases.

The strongest version would cover every legal `S`, including wild characteristic. A credible first
crown may restrict to tame configurations of a fixed selected-set size, but it must cross the
present `PSL2/PGL2` escape boundary rather than merely extend the finite small-subgroup table.

### Why this would be a crown

- It closes the motivating conic-continuation problem rather than stopping at a subgroup boundary.
- It converts a generally hard graph game into a uniform algebraic classification on a natural
  infinite family.
- It would explain the orbit-template theorem as the visible edge of a deeper compression
  principle, not just a convenient decomposition for small groups.
- It unifies finite geometry, permutation groups, Schreier graphs, arithmetic, and combinatorial
  game theory in a single statement.
- A kernel-checked or independently certified version would be unusually definitive.

### Candidate mechanisms

No mechanism is assumed. The live possibilities to test are:

1. a pairing or involutory response strategy surviving the deleted fixed-point set;
2. compression by a coherent configuration or association scheme of the full group action;
3. a representation-theoretic quotient preserving P/N or full nimber data;
4. a bounded exceptional core with bulk cancellation under the mod-two Burnside principle;
5. a local-to-global strategy extracted from orbit abundance or subfield descent; or
6. a structural recognition theorem identifying the residual with known graph families.

The discriminator is value preservation. Orbit counts, spectra, or graph isomorphism types are
useful only if they produce a proved P/N or Grundy-compatible quotient.

### Success tiers

- **Bronze:** a uniform P/N theorem for one genuine full-group family occurring after the generic
  fourth move, with a proved strategy and infinitely many fields.
- **Silver:** a tame classification of the P/N outcome for all legal configurations of a fixed
  size, including full and subfield `PSL2/PGL2` cases.
- **Gold:** an exact Sprague-Grundy classification for every tame legal configuration.
- **Crown:** the gold theorem extended through wild characteristic, with explicit exceptions and a
  checked proof boundary.

### Dependencies and ownership

- C84 `[cap]` owns the abundance-first conic-involution residual-graph program.
- C199/C200 `[cap]` own direct-strategy extraction and structural graph recognition.
- C284–C293 `[dihedral]` own the proper-small-subgroup polyhedral boundary and its upgrades.
- The `crowns` lane may synthesize their conclusions but must not silently re-peg or duplicate them.

## Crown II: continuation structure reconstructs the geometry

### Aspirational theorem

For a specified class of finite projective configurations, the continuation graph or continuation
complex determines the ambient projective plane, the selected arc/cap, its secant structure, and
the associated code up to semilinear equivalence. Equivalently, every combinatorial automorphism of
the continuation object is induced by the expected ambient semilinear stabilizer, and isomorphism
of continuation objects forces equivalence of the underlying geometric/code data.

The cleanest first theorem is the frame-based N1 statement already targeted by the `continuation`
lane. The crown version goes beyond an automorphism-group equality: it supplies a reconstruction
functor or explicit recovery algorithm and states exactly which small fields or degenerate
configurations are exceptional.

### Why this would be a crown

- It reverses the usual construction: the game is not merely produced by the geometry; it remembers
  the geometry.
- It connects continuation games to reconstruction, permutation-group rigidity, and code
  equivalence.
- It gives conceptual meaning to the computational continuation graphs used throughout the program.
- It can turn graph certificates into geometric certificates and make later classifications
  canonical rather than coordinate-dependent.

### Required layers

1. **Automorphism rigidity:** prove `Aut(Continuation(A))` is the ambient semilinear stabilizer.
2. **Incidence recovery:** reconstruct points, lines/secants, and selected versus continuation
   vertices from intrinsic graph/complex predicates.
3. **Configuration recovery:** recover the arc/cap and prove uniqueness up to semilinear equivalence.
4. **Code recovery:** transport the recovered projective columns to the associated code up to the
   appropriate monomial/semilinear equivalence.
5. **Exceptional boundary:** classify or sharply delimit the small-`q`, low-rank, and highly
   symmetric failures.

### Success tiers

- **Bronze:** the N1 frame-graph automorphism theorem for the stable field range.
- **Silver:** intrinsic reconstruction of the plane and frame from the continuation graph.
- **Gold:** reconstruction for the intended arc/cap class, including its associated code.
- **Crown:** a general continuation-complex reconstruction theorem with exact exceptions and a
  formal or independently certified recovery map.

### Dependencies and ownership

- C271–C273 `[continuation]` own the literature closure, N1 manuscript, and Lean library.
- The existing N2 claim remains softened until its missing hypotheses and literature boundary are
  resolved.
- The `crowns` lane records the gold/crown synthesis target; it does not upgrade N2 by rhetoric.

## Crown III: reconstruction-to-value synthesis

### Dream theorem

Within a natural class of conic or finite-geometric continuation games, the continuation object
intrinsically reconstructs its ambient geometry and code, and its P/N or Sprague-Grundy value is an
explicit invariant of the reconstructed algebraic data.

In slogan form:

> **The game remembers the geometry, and the geometry solves the game.**

This theorem is gated on genuine progress in both Crown I and Crown II. It must not be pursued as a
vague unification essay while either component remains conjectural.

### Minimal defensible form

A first combined theorem need not cover every configuration. It could identify one infinite,
geometrically natural class for which:

1. the continuation graph determines the configuration up to semilinear equivalence;
2. the reconstructed group/orbit data determine the exact P/N outcome; and
3. both directions are constructive or checked by small trusted kernels.

### Strong form

The strong form would package a functorial chain

```text
continuation object
    -> reconstructed incidence geometry
    -> reconstructed projective code and group action
    -> value-preserving algebraic quotient
    -> exact Sprague-Grundy value.
```

It would state invariance and completeness at every arrow and classify all exceptional fibers.

### What would not count

- juxtaposing independent reconstruction and value theorems without a mathematical bridge;
- using coordinates or exhaustive search to “reconstruct” an object already supplied as input;
- a graph invariant correlated with outcomes but not proved value-preserving;
- a formalization wrapper around an unproved classification; or
- an umbrella title that hides unresolved full-group or wild cases.

## Cross-program role of the Clebsch hexagon

The Clebsch hexagon remains the model jewel and possible test case for Crown III. It already links:

- a projective six-arc;
- an `A5` action and `H3` reflection arrangement;
- a non-GRS MDS code;
- a conic deep-hole locus;
- an exact continuation complex; and
- finite-field rigidity and uniqueness.

A reconstruction-to-value pilot could ask whether the Clebsch continuation object intrinsically
recovers the hexagon/code/conic package and whether the resulting symmetry yields a direct game
classification. That is a bounded test, not a substitute for the full crown.

## Research discipline

Each crown task must maintain three boundaries:

1. **Theorem boundary:** state exactly which fields, configuration sizes, subgroup types, and game
   conventions are covered.
2. **Evidence boundary:** distinguish conceptual proof, classical input, exact computation, and
   kernel-checked consequence.
3. **Ownership boundary:** source lanes prove their own deliverables; `crowns` assembles only after
   explicit dependencies are met.

Negative work should produce a bounded obstruction theorem or counterexample family, not the claim
that a crown is “impossible.” A failed compression mechanism is valuable if its exact failure mode
is recorded and it rules out a natural route.

## Allocated tasks

- **C294 `[crowns]`** — full conic-continuation crown: theorem specification, Dickson/subfield
  boundary audit, and a value-preserving attack on the first genuine full-group family.
- **C295 `[crowns]`** — continuation-reconstruction crown: promote N1 rigidity toward intrinsic
  geometry/code reconstruction with exact exceptional scope.
- **C296 `[crowns]`** — reconstruction-to-value synthesis, gated on substantive C294 and C295
  theorems; begin with a bounded Clebsch or frame-based pilot.

## Evaluation question

At every handoff ask:

> Has the work produced a theorem that changes the conceptual shape of the program, or only a larger
> table inside the existing shape?

The `crowns` lane exists for the former.
