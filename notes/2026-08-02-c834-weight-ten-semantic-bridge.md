# C834 — the weight-ten semantic bridge: base pencil and syndrome bits

**Date:** 2026-08-02

## What is now proved

The weight-ten certificates address internal points and passant lines by their position in the
normalized coordinate lists of `RelativeConicArcs.PassantCodeQ13.Geometry`, and store the passant
rows through a point as the set bits of a natural number.  The pencil-profile theorem
`RelativeConicArcs.PassantCodeQ13.WeightTen.arbitrary_weightTen_word_has_pencil_profile` instead
quantifies over the subtypes `InternalPoint` and `PassantLine`.  Two new modules state the
dictionary between the two presentations.

`PassantCodeQ13.WeightTen.PencilTransport` covers the base point `(1,0,2)` of coordinate index
zero:

- `internalPointAt_val` and `passantLineAt_val` identify the subtype element at a displayed index
  with the indexed coordinate triple used by the certificates;
- `incidentAt_iff` identifies the executable incidence test with the incidence relation;
- `mem_linesThroughBase` identifies the indexed base pencil with the passant lines through the base
  point;
- `mem_fibreOf` and `mem_fibres_flatten` identify the fibre of a pencil line with the internal
  points on that line other than the base point, and the union of the fibres with the points
  sharing a passant with the base point;
- `mem_secantNeighbors` identifies the secant-neighbour list with the internal points other than
  the base point lying on no common passant with it.

`PassantCodeQ13.WeightTen.SyndromeBits` covers the bitwise obstruction readings:

- `testBit_syndromeBelow` characterizes every bit of the accumulated incidence syndrome by
  induction on the row bound;
- `testBit_columnSyndrome` and `testBit_columnSyndrome_of_ge` specialize that to the stored
  `78`-row syndrome;
- `and_columnSyndrome_eq_zero_iff` proves that vanishing bitwise conjunction of two syndromes is
  exactly absence of a common passant, which is the certificates' secant-join test;
- `and_columnSyndrome_ne_zero_iff` proves that nonvanishing conjunction of three syndromes is
  exactly a passant through all three points, which is the certificates' three-on-a-passant test.

No step is a finite search.  The executable incidence test and the incidence relation are the same
field equation applied to the same normalized triples, and the syndrome characterization is an
induction on the accumulation bound.  Both modules elaborate warning-free in a few seconds under
the serial profile.

## Verification

```sh
lean/scripts/guarded-lean --root <repository>/papers/q13-passant-code/lean-certificates \
  PassantCodeQ13/WeightTen/PencilTransport.lean
lean/scripts/guarded-lean --root <repository>/papers/q13-passant-code/lean-certificates \
  PassantCodeQ13/WeightTen/SyndromeBits.lean
```

Both require `RelativeConicArcs.PassantCodeQ13.WeightTen` to be built first through the queue with
`--profile single --threads 1`.

## What remains on the weight-ten endpoint

Two gaps remain before the pencil-profile dichotomy can be joined to the two finite certificates in
one Lean theorem.

The first is assembly.  In the cyclic branch the support of a weight-ten codeword at the base point
is the base point, one point in each of the seven passant fibres, and an unordered pair of secant
neighbours.  Turning the semantic statement of that shape into a `CycleExclusion.Selection
markedFibres` derivation together with a member of `secantNeighbors.sublistsLen 2` requires
choosing the fibre representatives in the order of the fibre list and the secant pair in the order
of the neighbour list, then reading the certificate's obstruction conclusion back as a passant
carrying three support points or a support point of secant degree three.  Both readings are now
available bitwise from `SyndromeBits`; what is missing is the list-versus-finset accounting that
converts the fibre sizes and the secant-neighbour count of the profile theorem into the list shape
the certificates consume.  The corresponding assembly for the isolated branch replaces the fibre
choice by a three-element subset of the distinguished fibre.

The second is transport.  Both certificates are anchored at the base point, while the profile
theorem supplies its dichotomy at an arbitrary support point.  The normalized projective matrices
of `PassantCodeQ13.MinimumWords` act on the indexed internal points and are already proved to be
permutations preserving the polar relation; carrying an arbitrary internal point to index zero and
carrying codewords along that action is the remaining input.

Separately, the semantic module `RelativeConicArcs.PassantCodeQ13.WeightTen` still discharges its
pencil cardinality, joining-line uniqueness, and secant/passant complementarity by native
evaluation.  Those three leaves are release-facing and must be replaced by kernel reduction before
the weight-ten half of the distance argument meets the release standard.
