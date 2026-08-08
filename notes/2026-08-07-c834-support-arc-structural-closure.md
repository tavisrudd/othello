# C834 — the minimum-word supports are arcs, and what that buys the fixed-point exhaustion

**Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure) · **Date:** 2026-08-07

## Result

Every support of the decoded minimum-word family of the passant code of PG(2,13) is a twelve-point
arc of the plane: no three of its points are collinear. The Lean proof is structural in the four
orbits and finite only on the four displayed representatives, and it replaces the blockwise kernel
enumeration of the 364 supports against the 78 passant rows.

The new module is `PassantCodeQ13.MinimumWords.SupportArc`. Its terminal statements are

- `coordinateDeterminant_symmetricSquareImage` — substitution by a two-by-two matrix multiplies the
  coordinate determinant of three triples by the cube of the matrix determinant, because the
  symmetric square of a two-by-two matrix has that cube as its own determinant;
- `coordinateDeterminant_act_ne_zero` — the model's action of an invertible matrix carries three
  independent nondegenerate coordinate triples to three independent ones, the normalization of each
  image contributing one further nonzero factor;
- `representativeS4_noCollinearTriple` and the three dihedral analogues — each representative is an
  arc, decided by kernel reduction over its twelve coordinates in each of three positions, which is
  1728 comparisons and one three-by-three determinant over the residue field per surviving triple;
- `coordinateDeterminant_ne_zero_of_mem_minimumSupportCodes` — no support of the family contains
  three collinear internal points;
- `tripleConcurrenceIn_minimumSupportCodes_eq_zero_of_collinear` — triple concurrence in the family
  vanishes on every collinear triple of distinct internal points.

`PassantCodeQ13.MinimumWords.RowUniqueness.geometric_rows_have_zero_triple_concurrence` is now proved
from that, through the new
`PassantCodeQ13.MinimumWords.RowUniqueness.coordinateDeterminant_eq_zero_of_incident`: two distinct
internal points of a line determine it, so the line is the normalized join of the first two, and
incidence of a third point with that join is exactly the vanishing of the determinant of the three
coordinate triples.

Retired with it: the three modules `PassantCodeQ13.MinimumWords.Concurrence.RowBlockOne`,
`RowBlockTwo` and `RowBlockThree`; the theorem
`PassantCodeQ13.MinimumWords.geometric_rows_have_zero_triple_signatures`; and the module
`PassantCodeQ13.MinimumWords.RowUniqueness.PassantRowMasks`, whose only purpose was the bit-set
presentation those blocks consumed. Two shared algebraic facts moved from
`RowUniqueness.Transport` to `RowUniqueness.PolarGram`, where the coordinate determinant is defined,
so that both consumers reach them: `coordinateDeterminant_scaleTriple` and
`eq_zero_of_mul_eq_zero_field`.

The passant-row definitions of `PassantCodeQ13.MinimumWords.ConcurrenceBase` went with them:
`passantRowCodesOn`, `passantRowCodes`, `rowTripleCheckOn`, `passantRowTripleCheck`,
`tabulatedPassantRowCodesOn`, and the two lemmas bridging the tabulated and coordinate row encodings.
Nothing in the package refers to a passant-row bit set any more; the geometric rows enter only through
the semantic incidence relation.

## The three dihedral families are conics

An exact recomputation records a structural fact that no row of the formal package states. For each
of the three representatives with dihedral stabilizer the twelve points impose only rank five on the
six-dimensional space of conics, so a unique further conic passes through all twelve; that conic is
nondegenerate with fourteen points, of which the twelve are exactly its points internal to the base
conic and the remaining two lie on the base conic itself. The representative with symmetric
stabilizer imposes full rank six and lies on no conic.

So three of the four families are, member by member, a conic meeting the base conic in exactly two
points with its twelve remaining points removed. That reading explains two numbers the package
currently only checks: each orbit has 91 members because the two shared points form one of the 91
unordered pairs of base-conic points, and the stabilizer has order 24 because that is the order of the
stabilizer of such a pair. It also makes the arc property of those 273 supports a one-line
consequence, since a line meets a nondegenerate conic in at most two points; only the 91 supports of
the symmetric family need the finite check at all.

This is not yet in Lean. Adding it costs three kernel evaluations of a quadratic form at twelve
coordinates each plus a nondegeneracy check, and is the cheapest available upgrade to the module.

## What the arc property buys the fixed-point exhaustion

The remaining native decisions of the minimum layer are the two in
`PassantCodeQ13.MinimumWords.Exhaustion`. `fixedPoint_weightTwelve_exhaustion` searches four
multiplicity profiles of the eleven further points of a weight-twelve codeword through a fixed
internal point, split among the seven passant lines through it and its secant neighbours:
`(5,1,1,1,1,1,1;0)`, `(3,3,1,1,1,1,1;0)`, `(3,1,1,1,1,1,1;2)` and `(1,1,1,1,1,1,1;4)`. A fibre has
odd size because the passant carrying it must meet the codeword evenly.

The arc property, if available for an arbitrary weight-twelve codeword rather than only for the
displayed family, forces every fibre to have size one and so deletes the first three profiles
outright. Two measurements size what is left, both from the tracked script below:

- with the arc restriction, choosing one further point on each of the seven passants and rejecting any
  choice that puts three chosen points on a line leaves 10296 eight-point partial supports out of the
  6^7 = 279936 unrestricted choices, and the whole search tree has 22951 nodes;
- without it, an exhaustive increasing-index search over all weight-twelve subsets through the fixed
  point, pruned only by the parity-deficit bound that each further point flips exactly seven passant
  parities, visits 1344675925 nodes and returns 56 codewords.

The 56 agree with the count the Lean statement asserts, which is an independent confirmation of that
half of the theorem. The five-order-of-magnitude gap is the whole argument for making the arc property
a prerequisite of the exhaustion rather than a corollary of it: the pruned tree is within reach of
kernel reduction and the unpruned one is not, and no table substitution closes that gap.

The arc property for the displayed family cannot be used here, since the exhaustion is what
establishes that a weight-twelve codeword belongs to that family. What is needed is a proof that a
weight-twelve codeword meets every passant in zero or two points, using only the established minimum
distance twelve. Counting does not supply it. Writing `a_i` for the number of passants meeting the
support in `i` points, the incidence count gives `a_2 + 2 a_4 + 3 a_6 = 42` and the pair count over
all 183 lines gives `a_2 + 6 a_4 + 15 a_6 + s = 66`, where `s` counts the pairs of support points
joined by a secant; together these give only `a_4 + 3 a_6 <= 6`, so at most six passants may carry
four support points and at most two may carry six. The secant side is exactly complementary — each
support point has at least seven passant partners and so at most four secant partners, which bounds
`s` above by 24 rather than below — so no contradiction arises from the two identities alone.

One unexploited constraint is recorded here for the successor. Internal points are the elliptic
involutions of `PGL(2,13)`, two of them lie on a common passant exactly when they commute, and the
involution polar to a passant acts on the plane as a harmonic homology whose fixed internal points are
that passant's seven points together with its pole. For an element `g` outside the order-24 stabilizer
of a minimum word `S`, the codeword `S + gS` is nonzero and so has weight at least twelve, which
forces `|S ∩ gS| <= 6`. Applied to the involution polar to a passant carrying four points of `S`, this
says that at most two further points of `S` are matched in pairs by that involution. That is the
sharpest handle found and it does not yet close the case.

## Reproducibility

Script: `notes/2026-08-07-c834-minimum-word-arc-structure.py`. Certificate:
`notes/2026-08-07-c834-minimum-word-arc-structure.json`.

Replay, the second form taking several minutes:

```sh
python3 notes/2026-08-07-c834-minimum-word-arc-structure.py
python3 notes/2026-08-07-c834-minimum-word-arc-structure.py --full-search
```

The script builds the plane of binary quadratic forms over the residues modulo thirteen from scratch
in integer arithmetic, classifies its points and lines against the base conic, transcribes the four
representatives from the Lean definitions of `PassantCodeQ13.MinimumWords.Base`, and recomputes every
number quoted above. It shares no code with the formal development and carries no logical weight: the
arc property itself is the kernel-checked Lean statement named above, and the script is an independent
check of it together with the source of the two search measurements and of the conic identification,
which have no formal counterpart yet.

SHA-256:

| file | digest |
|---|---|
| `notes/2026-08-07-c834-minimum-word-arc-structure.py` | `9506a7835baa8f59fa23c0480ebbeb7cc7ed5cee69cadfe56359f088ba5eb134` |
| `notes/2026-08-07-c834-minimum-word-arc-structure.json` | `bcbf99d1d755897b35218de8b9a21154c7baf8b50be6ce4004fc8df378186d76` |
| `papers/q13-passant-code/lean-certificates/PassantCodeQ13/MinimumWords/SupportArc.lean` | `c50de27b524cb6db80dfd165431e6a4930c5a0d0199deb6dc215cb9434a5615d` |

## Validation

`Both package gates build and the aggregate gate passes:
`PassantCodeQ13.Gates.Main` at a peak of 5.76 GB and `PassantCodeQ13.Gates.AxiomAudit` at 1.82 GB, on
the pinned toolchain through the guarded build queue. The axiom audit now reports 88 terminals, of
which 77 are clean — depending only on `propext`, `Classical.choice` and `Quot.sound` — and 11 carry a
declaration-local native-evaluation axiom. Those 11 are exactly the ones carried before this round: the
two weight-ten profile aggregates, the two fixed-point exhaustion leaves, the three automorphism
anchors, and their four re-exports in the aggregate gate. Every terminal added here is clean, and the
retired blockwise row check was clean too, so the change is a reduction in enumerated work rather than
in trusted base. The paper's evidence verifier passes; its one pinned digest for the audit module was
refreshed for the five added and one removed audit line.

One adjacent repair was required to build at all. The three pair-concurrence blocks
`PassantCodeQ13.MinimumWords.Concurrence.PairBlockOne`, `PairBlockTwo` and `PairBlockThree` each
reduced their whole 26-index block in one declaration, and each was killed by the memory guard on a
host with about 7 GB available, the last measurement before the kill reading 6.58 GB. Each now checks
its block in the two halves of thirteen indices, joined by the existing `pairRecoveryCheckOn_append`,
because the kernel releases one declaration's memory before starting the next. The split form
completed in every attempt, at peaks between 5.6 and 6.8 GB, and the single-declaration form was
killed in every attempt; the two forms were each built twice to establish that. Peak size alone
therefore does not predict the outcome, and the split is retained on the completion evidence. The
mathematical content and the theorem names `pairRecovery_blockOne`, `pairRecovery_blockTwo` and
`pairRecovery_blockThree` are unchanged.`

## Mystery ledger

1. **Both intersection profiles are the same for all four families, and are not coincidences.**
   Every representative meets 42 passants in two points and 36 in none, and 24 secants in two points,
   36 in one and 31 in none. The `ej`+`tt` pass settles this: for a twelve-point arc that is a
   codeword the passant profile is forced by the two counting identities above, and the secant profile
   is then forced as the unique solution of `b_0 + b_1 + b_2 = 91`, `b_1 + 2 b_2 = 84`, `b_2 = 24`.
   Both profiles are therefore theorems about any such support and carry no information distinguishing
   the four families. Nothing remains open.
2. **Three families lie on conics and the fourth does not.** Settled as a computation, unexplained as
   a mechanism: no argument here says why the symmetric family admits no conic, and the family has no
   intrinsic description to match the "conic through two points of the base conic" description of the
   other three. Evidence gap: the symmetric family's twelve points as an orbit of its order-24
   stabilizer are not identified with any named configuration. Owner: a successor task; it is not
   needed for any current formal statement.
3. **Whether every weight-twelve codeword is an arc.** Open, and it is the gate on the fixed-point
   exhaustion. The exact evidence gap is stated in the section above: counting is exhausted, the group
   constraint `|S ∩ gS| <= 6` is available and not yet decisive. Owner: the successor that closes
   stage 5 item 13 of the task card.
