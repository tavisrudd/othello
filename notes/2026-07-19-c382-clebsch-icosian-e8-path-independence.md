# C382 — gated Clebsch-to-icosian `E8` path-independence theorem

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** ready; C381 green gate cleared by the marked integral root embedding and root-only
inversion theorem

**Parent:** `notes/2026-07-19-c381-clebsch-e8-extension-obstruction.md`

## Entry gate

The live queue and crowns handoff must name all of the following before `go C382` is valid:

1. C381's exact marked `E8` object on the weak-degree-one side;
2. its acting group and equivalence category;
3. its behavior under `A5`, `PSL_2(11)`, and the golden outer map `J` where defined; and
4. the concrete invariant to be compared with the icosian construction.

If any item is absent, stop without computation and report that C382 remains gated.  The abstract
identity `K^perp ~= E8` is not an entry ticket.

## Cleared frozen input

C381 supplies the presentation-independent marked object

```text
(R(S) < K^perp ~= E8, {alpha_u,alpha_v})
```

up to canonical-class-preserving `W(E8)` equivalence.  Its exact types are `(D8,A2)` on the 132
matched pairs, `(3A1,2A1)` on 660 weak MDS pairs, and `(4A1,2A1)` on 660 weak non-MDS pairs.  The
acting group is `PGL_2(11)`; `PSL_2(11)` preserves the two eleven-parent sheets and the golden `J`
exchanges them without changing type.  The invariant recovers the C379 matching, the parent, and
MDS status.

For the matched row, `D8` has rank eight, discriminant four, and index two in unimodular `E8`, so

```text
E8/D8 ~= C2.
```

This is the first comparison target, but not a pre-certified chirality bit: `Aut(C2)` is trivial,
and C381 proves that `J` exchanges sheets while preserving the unmarked root type.  Any positive
comparison must therefore retain the marked `D8` embedding, its glue vector/coset in the ambient
lattice, and the relevant centralizer action.  The matched blow-up is worse than weak; if C382 uses
it as the full-rank bridge, it must say “Picard-root degeneration” rather than “weak del Pezzo
contraction.”

The cheapest fixed-parent character calculation is also already closed.  In class-order order
`1,2,3,5`, the pair-permutation characters are `(6,2,0,1)` on `A5/D10` and `(30,2,0,0)` on each
of the two `A5/C2` orbits.  Hence ordinary permutation character distinguishes the matched orbit
but not the weak MDS and weak non-MDS size-30 orbits.  C382 must lift to the integral Picard action
and marked root orbits.

## Target diagram

C382 asks whether two independently constructed marked lattices agree naturally:

```text
Clebsch parent + two child points
          |
          | blow up / take K-perp and C381's marked root datum
          v
   weak-degree-one marked E8 object
          |
          | canonical integral isometry, to be proved
          v
golden A5 -> binary icosahedral group -> icosian E8 lattice.
```

The theorem target is a commuting, `A5`-equivariant comparison that also identifies the action of
golden conjugation or `J`.  “Both endpoints are `E8`” is a red result.

## Cheap representation gate

Before constructing an isometry:

1. compute the `W(E8)` orbit and centralizer of the marked index-two `D8` embedding, including the
   unique nonzero glue coset, and test whether any retained marking survives beyond the trivial
   quotient action;
2. define the `A5` action on C381's single lattice, family, or local system without silently
   identifying different blow-ups;
3. consume the already certified pair characters `(6,2,0,1)` and `(30,2,0,0)`, then compute the
   integral/rational **Picard-lattice** character and marked root-orbit decomposition; the two
   size-30 pair actions are character-indistinguishable and must not be recomputed as a gate;
4. construct the corresponding marked `D8`/glue and character data for the icosian `E8` model;
5. classify or distinguish the two `A5` embeddings up to `W(E8)` conjugacy; and
6. compute the centralizer/normalizer ambiguity relevant to canonicity.

**Stop immediately** if the actions are not defined in the same category, their characters or root
orbits differ, the glue comparison reduces to the unique abstract `C2` coset, or the set of
comparison isometries has no intrinsic quotient.

## Full theorem gate

Proceed beyond the character test only to establish:

1. an explicit integral lattice isometry between the two `E8` models;
2. equivariance for the named `A5` action;
3. transport of C381's distinguished effective-root subsystem, orbit, or flag to a natural
   icosian/600-cell object;
4. compatibility of the golden involution with the outer passage already certified in
   C376--C379; and
5. one new consequence—such as an orbit/design classification, uniqueness theorem, or arithmetic
   obstruction—not visible at either endpoint alone.

Canonicity may mean uniqueness up to a proved centralizer.  It may not mean choosing one convenient
matrix from a nontrivial torsor and suppressing the choice.

## Verdicts

- **Green:** the full diagram commutes in a named category and transports a new invariant or
  theorem.  This may compete as a sequel-level `E8` crown.
- **Yellow:** the two `A5` embeddings are conjugate and an explicit isometry exists, but the result
  is classical or noncanonical.  Use it as exposition only.
- **Red:** the actions mismatch, no natural comparison exists, or the connection is solely the
  familiar icosahedron/icosian and eight-blow-up dictionaries.  Close the route.

## Literature and evidence requirements

Read primary sources in full for the icosian construction of `E8`, `A5`/binary-icosahedral
subgroups of `W(E8)`, degree-one del Pezzo `E8` markings, and conjugacy of relevant embeddings.
Run MathSciNet, zbMATH, Google Scholar, and forward-citation closure on the exact marked comparison.
Baez's exposition is a map to the literature, not a priority source.

Any finite character, root-orbit, or isometry calculation requires a task-owned deterministic
certificate, independent replay, hashes, and an explicit trusted boundary.  Do not formalize an
`E8` lattice library in Lean unless the paper theorem first passes the full gate and a separate
bounded formal API is approved.

## Hard exclusions

- No generic icosian or 600-cell exposition as a deliverable.
- No “magic square,” octonion, moonshine, Mathieu, or holographic expansion.
- No inference from matching cardinalities, root counts, or abstract group names.
- No replacement of C381's weak surface by a nonexistent smooth degree-one surface.
- No all-prime claim without a separately allocated arithmetic task.

## Hand-back

On green, update the C373 gateway program with the proved commuting diagram and decide whether the
result belongs in the present Clebsch paper or a sequel.  On yellow or red, archive the exact
comparison and return to the certified C376--C381 spine without opening adjacent famous-object
doors.
