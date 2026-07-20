# C382 — gated Clebsch-to-icosian `E8` path-independence theorem

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** allocated but gated; start only after C381 records its green invariant

**Parent:** `notes/2026-07-19-c381-clebsch-e8-extension-obstruction.md`

## Entry gate

The live queue and crowns handoff must name all of the following before `go C382` is valid:

1. C381's exact marked `E8` object on the weak-degree-one side;
2. its acting group and equivalence category;
3. its behavior under `A5`, `PSL_2(11)`, and the golden outer map `J` where defined; and
4. the concrete invariant to be compared with the icosian construction.

If any item is absent, stop without computation and report that C382 remains gated.  The abstract
identity `K^perp ~= E8` is not an entry ticket.

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

1. define the `A5` action on C381's single lattice, family, or local system without silently
   identifying different blow-ups;
2. compute its integral/rational character and root-orbit decomposition;
3. construct the corresponding data for the icosian `E8` model;
4. classify or distinguish the two `A5` embeddings up to `W(E8)` conjugacy; and
5. compute the centralizer/normalizer ambiguity relevant to canonicity.

**Stop immediately** if the actions are not defined in the same category, their characters or root
orbits differ, or the set of comparison isometries has no intrinsic quotient.

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
