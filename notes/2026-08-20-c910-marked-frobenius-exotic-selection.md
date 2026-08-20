# C910 — marked-Frobenius selection of the exotic two-primary packet member

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-20

The previous pass (`2026-08-20-c910-six-label-action-and-kernel-stability.md`)
proved diagonal stability of both transported primary kernels from equivariance
of the comparison matrix, and closed with the observation that equivariance
cannot go further: the two-primary packet is exactly the set of diagonally
stable maximal-isotropic subspaces, so all five members satisfy the same group
hypothesis.  This pass formalizes the input that does select a member.

## What this pass did

Two new modules under
`papers/cubic-stabilization-epilogue/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/GraphLattices/`,
plus one extension of an existing module.

`SixPointStableHalfFrobenius.lean` transports Frobenius of the four-element
labelling field to the five-member packet of diagonally stable halves of the
characteristic-two coefficient heart, through the affine-chart equivalence
already formalized.  The transported map is an involution.  Its fixed members
are exactly the three defined over the prime field — the vertical copy and the
graphs of the slopes `0` and `1` — and it exchanges the two remaining members,
the graphs of `W` and `W+1`; those two are the exotic pair.  On a graph member
the involution squares the slope: the labelled commutant matrix of the Frobenius
conjugate of a scalar is the square of the labelled matrix of that scalar, which
is checked on the four labels using `W² = W+1` and `(W+1)² = W`.

Marking a subspace means asserting that this involution moves it.  For a packet
member that is equivalent to lying in the exotic pair, and either exotic member
is the graph of a slope annihilated by `t²+t+1` whose minimal polynomial over
the field with two elements is that irreducible quadratic.  So the marking is
stated without reference to the labelling field, and it delivers exactly the
coefficient-side slope datum that `lem:six-axis-local-chart` states at the prime
two — the slope with minimal polynomial `t²+t+1`, generating a quadratic
finite-etale extension — for the kernel itself rather than for a display model.

`SixAxisTwoPrimaryExoticSelection.lean` runs that against the two-primary
kernel.  For a comparison matrix pulling a unimodular alternating form back to
the six-axis source polarization and equivariant for the two displayed
generators of the six-label action, the transported two-primary kernel is a
packet member; marking it makes it exotic, with that slope datum.  Marking and
exotic membership are recorded as equivalent, so nothing weaker than the marking
is being smuggled in.

`ConnectedPacketPersistence.lean` gains the corresponding persistence
statement: a continuous classifier from a connected base into the packet whose
value at one base point is moved by the involution is constant, and every fibre
is exotic.  Marking is therefore an input at one fibre, not at every fibre.

`Applications/RelativeSixAxis.lean` carries the selection per fibre.  The
geometric input structure gains one field, `twoPrimaryKernelFrobeniusMarked`,
stating the marking of the transported two-primary kernel on every fibre, and
the packaged conclusion gains `twoPrimaryKernelExoticSelection`.  Three reviewer
terminals were added — `principalGluing_stableHalfPacket_frobeniusMarking`,
`principalGluingPacket_stableHalf_marked_persists_as_exotic`, and
`relativeSixAxis_twoPrimaryKernelExoticSelection` — the first two registered on
`prop:principal-gluing-packet` and the third on `lem:relative-six-axis`.  All
three report `propext, Classical.choice, Quot.sound`.

## What the hypothesis is, and what it is not

Marking is a condition on explicit subspaces of two copies of the coefficient
heart: the packet class of the kernel is moved by the transported involution.
Lean proves that this condition selects the exotic pair, that no hypothesis of
stability under the packet-preserving group can make that selection, and that
one marked fibre suffices over a connected base.  It does not identify the
transported involution with a geometric Galois action, an arithmetic Frobenius
of a family, or the manuscript's odd normalizer element, and it does not prove
that the geometric kernel of the nonstandard component is marked.  The
manuscript's assertion that the intermediate Jacobian of that component uses the
exotic pair therefore remains outside the package, now as a single named bit
rather than as an unrepresented notion.

## Validation

From `papers/cubic-stabilization-epilogue/`:

```text
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-epilogue/lean --cores 20-23
make lint formal-static
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Both the source-only and the axiom-log check pass over 156 sources and 307
reviewer terminals, with 62 claims, 48 machinery rows, and unchanged coverage
counts (5 absent, 27 fragmentary, 29 conditional, 1 complete).  The claim-map
rows for `prop:principal-gluing-packet` and `lem:relative-six-axis` were
reviewed across objects, hypotheses, conclusion, and cautions before their
digests were refreshed.  The manuscript PDF was not rebuilt: the only manuscript
change is the `\lean` lists of those two statements, whose macros are
typographically empty.

## Mystery ledger

- **Settled: what separates the exotic pair from the rest of the packet.**  One
  bit, and it is not group-theoretic.  The packet is exactly the set of
  diagonally stable maximal-isotropic subspaces, so every member is stable; the
  separating condition is being moved by the Frobenius involution.
- **Settled: the marking has a labelling-free form.**  A packet member is exotic
  exactly when its graph slope has irreducible minimal polynomial `t²+t+1`; the
  prime-field members have slopes satisfying `M² = M`.  Nothing in the criterion
  mentions the four-element labelling field.
- **Settled: how many fibres must be marked.**  One.  Connectedness and
  discreteness of the finite packet propagate exotic membership to every fibre,
  which is the same argument already used for the projective-line packet.
- **Open, and now the sharpest next gate: is the packet involution the heart
  action of an odd six-label permutation?**  A permutation acts on a graph
  member by conjugating its slope, and the two displayed generators are even and
  commute with `W`, so they act trivially on the packet.  If some odd
  permutation's heart matrix conjugates `W` to `W+1`, then the transported
  involution is that permutation's action, marking becomes "not stable under the
  full six-label group", and the already formalized exclusion of a faithful
  action of the symmetric group on six letters on the classified automorphism
  orders becomes a route to supplying the marking instead of assuming it.  The
  package has the general-permutation chart action and the descent to heart
  coordinates, so the missing pieces are an explicit heart matrix for one
  transposition and the conjugation identity, which is a finite check.
- **Open, unchanged: the geometric side.**  No relative isogeny, torsion group
  scheme, Weil pairing, geometric Galois action, or identification of the six
  labels with the manuscript's dihedral axes is constructed, so the marking of
  the actual kernel remains supplied.
- **Open, unchanged: the orders `2⁴` and `3⁴` of the primary parts of the
  kernel.**  Still unstated; the route through complementation in the kernel
  subgroup is unchanged by this pass.
