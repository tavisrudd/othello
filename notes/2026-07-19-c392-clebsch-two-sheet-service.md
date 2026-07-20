# C392: Clebsch two-sheet service compatibility

**Lane:** `crowns`

**Verdict:** `SHARP OBSTRUCTION; THE UNCOLOURED q=11 GRAPH FORGETS WHICH SHEET DEFINES PROJECTION TARGETS`

## Result

C295's q=11 continuation graph is the icosahedron and intrinsically recovers an unordered pair of
admissible six-block matching/port decompositions.  In the fixed twelve-point conic embedding,
these two sheets have sharply different projective behavior:

| intrinsic sheet | concurrent five-secant blocks | C357 target interpretation |
|---|---:|---|
| geometric Clebsch sheet | `6` | six external projection targets |
| graph-automorphic mate | `0` | none; no block is a projection pencil |

Thus the two sheets do **not** induce the same service/PIR data on the fixed conic.  Only the
geometric sheet defines requested projective objects.  The uncoloured graph cannot select it,
because its full automorphism group exchanges the two sheets.  C357's operational invariant
therefore depends on exactly the projective/conic sheet marking forgotten at C295's q=11 boundary.

For each of the six geometric blocks, the five matching edges are the nonfixed secant orbits of an
external target and the omitted antipodal pair consists of its two tangent contacts.  With the full
conic as the twelve stored columns, C357 gives

\[
 r=5,\qquad \kappa=5,\qquad \tau=2,
\]

so these targets have nonmaximal service and nonmaximal disjoint PIR availability.  C334's exact
full-oval calculation further gives fractional service capacity `q/2=11/2`.  There is no
corresponding tuple for the mate sheet in the fixed projective model: assigning one would mistake
abstract matching blocks for concurrent secants.

## Meaning of the obstruction

This is stronger than saying that an automorphism group is unexpectedly large.  The exact
`6 versus 0` concurrency split identifies what the extra graph automorphism destroys.  A single
choice of the geometric sheet—or equivalently the compatible projective conic embedding—is enough
to recover all six targets and their service data.  Without that choice, the service construction
does not descend to the abstract graph.

The result gives a clean exceptional-field contrast with C369:

- for stable four-frames at `q>=13`, full-faithful plane reconstruction makes the service
  extremizer predicate graph-intrinsic;
- for C295's q=11 Clebsch pilot, the graph recovers only an unordered two-sheet object, and the
  projective operational interpretation lives on one sheet.

This closes the proposed positive q=11 transfer.  It is useful as an exact reconstruction boundary
and as protection against a false graph-intrinsic service claim, but it is supporting material for
the C295/C369 package rather than an independent flagship theorem.

## Evidence and replay

Run from `/home/tavis/src/othello`:

```text
python3 notes/2026-07-19-c392-clebsch-two-sheet-service.py --check
python3 notes/2026-07-19-c392-clebsch-two-sheet-service-replay.py
sha256sum -c notes/2026-07-19-c392-clebsch-two-sheet-service.sha256
```

The main checker reuses C295's exact q=11 construction, enumerates its `636` decompositions and
full graph automorphism group, isolates the geometric orbit of size two, and records concurrency
for every block of its two sheets.  The canonical JSON certificate contains both decompositions,
their port pairs, normalized concurrence points where present, the operational tuple, and the
SHA-256 of the unordered two-sheet fixture.

The independent replay hard-codes only the twelve conic points and two certified decompositions.
It checks that both are six matchings partitioning the same thirty graph edges, recomputes the
concurrency counts `6` and `0` by modular cross products, verifies all twelve geometric ports are
tangent contacts, and checks the common fixture hash.  Its implementation does not import the C295
checker.

The trusted boundary is integer arithmetic modulo `11`, the fixed C295 conic labelling, Python's
standard library, and C295's already-certified identification of the unique size-two orbit.  The
certificate does not prove a general small-field theorem or classify other nongeometric orbits.

The bundle sizes are `4,655` bytes for the generator, `3,228` bytes for the replay, and `6,593`
bytes for the canonical JSON.  Their hashes are recorded in the adjacent checksum manifest.

## Scope and novelty

No novelty is claimed for the icosahedron, complete quadrangles, conic projection involutions, or
external-point service formulas.  The new program-facing conclusion is the exact incompatibility
of C295's intrinsic two-sheet output with C357's projective target predicate.  This does not clear
C296, select a sheet intrinsically, or authorize a new q=11 reconstruction census.
