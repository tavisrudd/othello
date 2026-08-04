# C834 — kernel closure of the weight-eight and reconstruction finite leaves

**Date:** 2026-08-03

## What changed

`RelativeConicArcs.PassantCodeQ13.WeightEight` had thirteen native-evaluation leaves and
`RelativeConicArcs.PassantCodeQ13.Reconstruction` one. Twelve of those fourteen are now decided by
kernel reduction, and the axiom closure of the Paper IV gate
`RelativeConicArcs.Gates.PassantCodeQ13` contains exactly two native-evaluation axioms.

Kernel-checked in this pass:

- membership of the normalized base point in the internal coordinates;
- internality of the 42 cyclic vertex triples, their pairwise distinctness, and their distinctness
  from the base point;
- the seven passant lines through the base point, and uniqueness of the passant line joining the
  base point to a second internal point;
- the identification of the cyclic vertices with the passant-join neighbors of the base point,
  including bijectivity;
- the four-clique enumeration and its length, the unique common neighbor of each four-clique, the
  collapse to fourteen five-cliques, their maximality, and the common-neighbor cardinality of each
  four-clique set;
- the seven internal points on each passant line.

## Method

Three mechanisms carry the work.

The base-point pencil facts are instances of the general pencil results of
`RelativeConicArcs.PassantCodeQ13.PencilJoins`, so they need no computation at all. To make them
available, the ambient dual-line evaluation, the normalized secant coordinates, and the secant-line
subtype moved from the weight-eight module into
`RelativeConicArcs.PassantCodeQ13.Geometry`, where they belong: they describe the conic model
rather than the tangent graph. The weight-eight module now imports the pencil results instead of
being imported by them.

The neighbor identification is decided on coordinate triples rather than on the subtype of internal
points. Deciding `PassantJoin` directly would re-derive the universe of the passant-line subtype
once per vertex, which is what exhausts memory; instead each vertex triple is checked against the
displayed passant pencil of the base point, and the passing statement is transported through the
pencil-join equivalence.

The row cardinality is the dual of the pencil cardinality and uses the same construction: a row
table over the 78 passant lines, kernel-reduced once, and a bijection between the filtered `Finset`
of internal points on a line and the `toFinset` of the displayed row.

The clique enumeration is decided directly on the list of four-element sublists of the 42 vertices,
which the kernel handles; the elaboration of the whole weight-eight module takes about four
minutes.

## The two native checks that remain

`fourCliqueSets_complete` compares the enumerated four-clique sets with the four-element clique
subsets of the ambient powerset. Deciding it by kernel reduction is not viable: the powerset of the
42 vertices materializes 111,930 `Finset` values and the elaboration is killed by the memory guard
after eighty seconds. The replacement is a proof rather than a computation, resting on a general
lemma: a finite set of size `n` contained in a duplicate-free list is the member set of one of that
list's sublists of length `n`, obtained from the subperm characterization of multiset order. The
clique condition transfers between the list and set forms by a direct equivalence. That proof
elaborates against the built weight-eight module; its in-place elaboration inside the module, the
gate replay, and the axiom audit are not yet run, so the change is uncommitted.

`adjacent_iff_tangentCompatibleAtBase` identifies the six cyclic difference sets with the
tangent-holonomy compatibility relation over the 1,764 ordered vertex pairs. Each pair evaluates
six tangent products, and each tangent product as defined is a product over the secant-line
subtype, so a direct decision would re-derive that universe more than ten thousand times. The
route is the same table discipline used for the pencils: rewrite the tangent product as an
evaluation product over the displayed secant pencil of the point, which has seven members, and
index the check by position in precomputed lists of the base point's and the 42 vertex triples'
pencils, so that each pencil reduces once. That replacement is written but not yet elaborated, so
it is uncommitted.

## The separate native surface of the certificate package

The audit above covers the shared semantic library. The paper's own Lean package under
`papers/q13-passant-code/lean-certificates` has an independent gate and axiom audit, and its
sources still contain sixty-four native decisions across forty-five modules: twenty-two in the
minimum-word orbit enumeration, sixteen in the weight-ten profile certificates, nine in the
structural upgrade, eight in the association transport, six in the automorphism anchors, and three
in the association algebra. Closing those is the larger part of the remaining native debt for the
release theorem.
