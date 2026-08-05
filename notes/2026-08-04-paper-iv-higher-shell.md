# Paper IV higher-shell incidence codes

**Date:** 2026-08-04  
**Lane:** `clebsch`  
**Status:** Exact reproducible research bundle; no manuscript, Lean, or release file changed

## Result

The (2184) weight-(38) words of the binary frame metacode split into two
(G=operatorname{PGL}(2,13))-orbits of size (1092), distinguished by
left/right weights ((17,21)) and ((21,17)).  For either orbit, form the
(1092)-by-(182) binary support-incidence matrix.  Its row and column ranks
are both (37), and its column span has exact parameters

\[
\boxed{[1092,37,204]_2}.
\]

The (182) coordinate columns are distinct.  Ninety-one have weight (204)
and ninety-one have weight (252), with the two classes exchanged between the
two orientations.  The complete minimum shell consists exactly of the
ninety-one weight-(204) coordinate columns.  Those minimum words already
span the full (37)-dimensional code.

The all-ones word belongs to the column span.  Complementing all (182)
columns gives a (36)-dimensional subspace; adjoining the all-ones word
recovers the full code.  Thus parity complementation does not produce a new
(38)-dimensional code.  The minimum distance of that complemented
(36)-space was not computed here.

## Exact distance certificate

For each orientation the checker greedily extracts twenty-five pairwise
disjoint information sets, each of size (37).  If a codeword has weight at
most (204), one information-set restriction has weight at most

\[
\left\lfloor\frac{204}{25}\right\rfloor=8.
\]

The checker changes basis separately at each information set and enumerates
all

\[
\sum_{i=0}^{8}\binom{37}{i}=51{,}738{,}692
\]

restriction patterns.  Hence it tests (1{,}293{,}467{,}300) patterns per
orientation.  Deduplication in the common (37)-bit message coordinates
finds minimum (204) and exactly ninety-one minimum messages.  Direct
comparison identifies them with the ninety-one light coordinate columns.
The tracked JSON records all fifty information sets and both lists of minimum
messages.

## The (C\mapsto C+J) two-cycle

Let (C) be the (91)-square cubic octahedral--toric correspondence matrix
and let (J) be the all-ones matrix.  Over (mathbf F_2), translation by
(J) is literally period two:

\[
(C+J)+J=C,
\]

and the row degrees alternate between (3) and (88).  Exact elimination
gives

\[
\operatorname{rank}C=77,
\qquad
\operatorname{rank}(C+J)=76.
\]

For

\[
H_D=\begin{pmatrix}I&D\\D^{\mathsf T}&I\end{pmatrix},
\qquad D=C+J,
\]

the rank is (146), so the block kernel has dimension (36).  The seventy-
eight paired physical-coordinate columns are annihilated by (H_D), span
dimension (36), and include weight-(28) words.  Since this is a subcode of
the already certified ([182,37,28]_2) metacode, it is exactly

\[
\boxed{[182,36,28]_2}.
\]

More precisely, the original block kernel is the direct sum of this
constituent and the all-ones line.  Thus the matrix iteration alternates the
full and expurgated block codes rather than reaching an idempotent fixed
point.  The same checker exhaustively enumerates the two fifteen-dimensional
one-sided kernels:

\[
\ker(C+J)=[91,15,28]_2
\]

with (78) minimum words, and

\[
\ker(C^{\mathsf T}+J)=[91,15,26]_2
\]

with (28) minimum words.

## Evidence and replay

The load-bearing checker is
`notes/2026-08-04-paper-iv-higher-shell.cpp`.  It reads only the two tracked
inputs named in the generated JSON, reconstructs both weight-(38) incidence
matrices, performs all binary eliminations and exhaustive searches, and emits
canonical JSON.  It uses no randomness.  The compiler and OpenMP runtime are
trusted execution boundaries; the input metacode's prior exhaustive
weight-shell classification remains a trusted input rather than being
regenerated here.

From the repository root:

```sh
g++ -std=c++20 -O3 -march=native -fopenmp \
  notes/2026-08-04-paper-iv-higher-shell.cpp \
  -o /tmp/paper-iv-higher-shell
OMP_NUM_THREADS=24 /tmp/paper-iv-higher-shell --check \
  notes/2026-08-04-c682-paper-iv-frame-metacode.json \
  notes/2026-08-04-c682-paper-iv-orbit-correspondence.json \
  notes/2026-08-04-paper-iv-higher-shell.json
sha256sum -c notes/2026-08-04-paper-iv-higher-shell.sha256
```

The checker internally cross-checks row rank against column rank, reconstructs
minimum messages independently from every information-set basis, compares the
deduplicated minimum shell with coordinate columns, and verifies the block
kernel both by elimination and by the independently supplied physical-column
span.  A second independent exhaustive implementation was not run: the exact
search covers (2{,}586{,}934{,}600) bounded information-set patterns, and
duplicating that cost would add little beyond the multiple bases and
rank-versus-span checks already included.

The checksum manifest records SHA-256 and byte counts for the checker, report,
generated certificate, and both load-bearing inputs.  The computation proves
only these two tracked weight-(38) orbit incidence codes and the stated
(C+J) transforms; it does not claim a uniform higher-shell theorem.
