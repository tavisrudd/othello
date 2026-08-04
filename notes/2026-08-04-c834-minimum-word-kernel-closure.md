# C834 — the minimum-word layer of the Paper IV package is kernel checked

**Date:** 2026-08-04

## What changed

The nine native decisions of the minimum-word orbit and concurrence leaves in
`papers/q13-passant-code/lean-certificates` are replaced by kernel reduction.  The paper package
now carries 55 native decisions across 39 modules, down from 64 across 45.

Three obstructions had to be removed before the kernel could run these checks at all.

**Indexing the plane.**  `internalIndex` locates a point by scanning the 78-element internal
coordinate list, so expanding a twelve-point support under all 2184 normalized projective matrices
costs about two million comparisons of coordinate triples, which exhausts the memory guard.
`PassantCodeQ13.MinimumWords.NormalizedIndexTable` packs the internal index of every normalized
representative into seven-bit fields of one natural number, keyed by the representative's position
in `projectiveTripleList`, so a lookup is one shift and one mask.  Agreement with the scanning index
is checked by kernel reduction over all 183 representatives, and `normalizeTriple` is proved to land
among them, so the table may be substituted wherever a point arises as an image of the action.  With
that substitution the orbit expansion itself is not the difficulty: the 26,208 group actions alone
reduce in about twenty seconds of kernel time.

**Incidence.**  `incidentAt` reads a passant coordinate and an internal coordinate out of their
lists before evaluating the bilinear form.  `PassantCodeQ13.IndexedIncidenceTable` packs the whole
relation into one natural number, one bit per index pair, and checks agreement by kernel reduction
over all 6084 pairs.

**Recomputation and size.**  Every orbit is now identified with a displayed list of supports in its
own module, and the union of the four orbits with a displayed list of 364 supports, so the
downstream kernel, rank, disjointness, concurrence, and row checks reduce on literals instead of
re-expanding the orbits.  The displayed lists are emitted by the tracked generator
`generate_minimum_word_orbits.py` and carry no trust: Lean checks each of them against the
projective action.  The two exhaustive concurrence checks remain too large for one module even so —
the pair comparison visits 6084 index pairs and counts each against 364 supports — so the indices
below 78 are partitioned into three blocks of 26, each block is discharged in its own module, and
the blockwise results are assembled by list concatenation.

## Evidence

All builds ran through the guarded unattended queue on the `single` profile with one thread on cores
20–23, with `--lean-root papers/q13-passant-code/lean-certificates`.

```sh
lean/scripts/lean-build-queue.py run \
  PassantCodeQ13.MinimumWords.OrbitS4 PassantCodeQ13.MinimumWords.OrbitDihedralA \
  PassantCodeQ13.MinimumWords.OrbitDihedralB PassantCodeQ13.MinimumWords.OrbitDihedralC \
  PassantCodeQ13.MinimumWords.OrbitDihedral \
  --lean-root <package> --profile single --threads 1 --cores 20-23
lean/scripts/lean-build-queue.py run \
  PassantCodeQ13.MinimumWords.Concurrence.PairBlockOne \
  PassantCodeQ13.MinimumWords.Concurrence.PairBlockTwo \
  PassantCodeQ13.MinimumWords.Concurrence.PairBlockThree \
  PassantCodeQ13.MinimumWords.Concurrence.RowBlockOne \
  PassantCodeQ13.MinimumWords.Concurrence.RowBlockTwo \
  PassantCodeQ13.MinimumWords.Concurrence.RowBlockThree \
  PassantCodeQ13.MinimumWords.Reconstruction \
  --lean-root <package> --profile single --threads 1 --cores 20-23
```

Each of the four orbit identifications takes between one and three minutes at a measured peak near
9.9 GB, which is why every orbit keeps its own module on the strictly serial profile.  The dihedral
disjointness aggregate then takes five seconds at 2.1 GB.  The generator is replayed with
`python3 generate_minimum_word_orbits.py --check`, which fails if the tracked module differs from
the generated text.

## Statements

The theorem names and statements consumed by the package gate and its axiom audit are unchanged:
`orbitS4_size_and_kernel`, `orbitS4_rank`, `orbitDihedralA_certificate` and its two siblings,
`dihedral_orbits_pairwise_disjoint`, `minimumSupportCodes_length`,
`pair_concurrence_recovers_passant_join`, and `geometric_rows_have_zero_triple_signatures`.  What
changed is only how they are proved and where the definitions they mention live: the hypergraph and
its concurrence definitions moved into `PassantCodeQ13.MinimumWords.ConcurrenceBase` so that the
block modules and the assembling module can share them.

## What remains for the release theorem

The 55 remaining native decisions are 16 in the weight-ten profile certificates, 11 in the
minimum-word row-uniqueness transport, 9 in the structural upgrade, 8 in the association transport,
6 in the automorphism anchors, 3 in the association algebra, and 2 in the fixed-point exhaustion.

The association-transport leaves multiply 78-by-78 and 91-by-78 Boolean matrices given as functions
on `Fin` types, with each entry a parity fold whose terms index a support list positionally; the
same tabulation that closed the minimum-word layer applies, replacing the positional list reads by
packed-table reads, followed by a blockwise split over rows.

The fixed-point exhaustion is the one leaf whose search is not a candidate for direct kernel
reduction: it meets partial supports in the middle through a hash map keyed by incidence syndrome,
over domains far larger than anything reduced here.  It needs a proved checker in the style of the
weight-ten reachability kernel rather than a table substitution.
