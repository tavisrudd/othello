# Cap-game flagship manuscript skeleton

**Status:** architecture and theorem slots; not submission prose.

## Headline variants

### Crown lands

**Theorem A.** State the uniform outcome families:

1. every positive-dimensional finite affine space is P;
2. every binary projective space of positive projective dimension is P;
3. every odd-dimensional projective space over an odd finite field is P;
4. every projective plane over an even finite field is P;
5. every projective plane over an odd finite field is P.

The proof of item 5 must cite a new terminal theorem whose dependency chain
passes through the frame/grid/conic/residual interfaces.  Fixed-q data remain
illustrations, not hypotheses.

### Crown remains open

**Theorem A.** State items 1--4 only.

**Theorem B.** State the general whole-board and invariant-subboard mirror
interfaces, followed by the hyperbolic and coordinate-exact elliptic quadric
corollaries.

**Theorem C.** State the odd-plane equivalence to residual escape, the exact
size-three extension count, the rank-three residual-hypergraph theorem, and
the pair-only Node--Kayles specialization.

The introduction says that Theorem C identifies the exact obstruction left
outside Theorems A and B.  It does not present computation as a substitute for
the missing odd-plane implication.

## Dependency spine

```text
FiniteBuildGame semantics
├─ mirror invariant + pair-extension contract
│  ├─ affine translation / blocked-centre reflection ── AG(n,q) P
│  ├─ elliptic projective involution ───────────────── PG(2m−1,q) P
│  └─ invariant subboard
│     ├─ hyperbolic quadrics
│     └─ coordinate-exact elliptic quadrics
├─ binary sum-free equivalence ────────────────────── PG(n,2) P
└─ rank-three projective transport
   ├─ characteristic-two residual mirror ──────────── PG(2,q), q even, P
   └─ frame ⇔ grid ⇔ escape
      ├─ size-three extension count
      ├─ conic localization + full-PGL value transport
      └─ rank-three residual hypergraph
         ├─ pair constraints
         ├─ triple constraints
         └─ no active triples ⇒ Node--Kayles
            └─ uniform routing theorem [OPEN or CROWN]
```

## Three-interface proof organization

Use three boxed contracts throughout the paper:

| Interface | Input | Output | Principal uses |
|---|---|---|---|
| symmetry | involution, incidence preservation, pair-extension validity | P-position | affine, odd-dimensional projective, even-plane residual, invariant subboards |
| transport | equivalence preserving valid positions and moves | equal P/N value | binary representatives, frame normalization, coordinate/projective-linear changes |
| residual rank | fixed old state and cap legality | minimal new obstructions have size two or three | odd-plane conflict graph plus active triples |

The named geometric families are corollaries below these boxes.  Do not give
each family a new proof vocabulary when it merely discharges an existing
contract.

## Section map

### 1. The game and the result

Phenomenon: building a cap has exact second-player outcomes on several
infinite finite-geometric families.

Interface theorem: give the finite-build recurrence, cap legality, P/N
convention, and Theorem A.

Why hypotheses hold: one paragraph previewing translation, blocked-centre
reflection, binary sum-free transport, and elliptic projective involutions.

Consequence: a unified family theorem, not a board catalogue.

Outside: even-dimensional projective spaces over odd fields; odd planes are
treated by an exact reduction later.

Milner audit: one semantic definition, no solver representation.

Serre audit: lead with Theorem A and one smallest successful mirror.

### 2. The mirror contract

Phenomenon: a symmetry yields copycat only when a legal move and its mate may
be added together.

Interface theorem: the generic invariant mirror theorem, followed by
`initialPStatement_of_fixedPointFree_collinearity_preserving_involution` and
`initialSubCapP_of_fpf_collinearity_preserving`.

Why hypotheses hold: incidence preservation transports cap validity;
fixed-point-freeness prevents a self-reply; pair extension handles mirror
chords.

Consequence: reusable whole-board and subboard engines.

Outside: a single mirror-chord example demonstrates why fixed points being
illegal is insufficient.  No failed-route taxonomy.

Milner audit: display the move-correspondence square.

Serre audit: one counterexample, then the corrected theorem.

### 3. Uniform affine and projective families

Phenomenon: the same interface supports distinct geometric realizations.

Interface theorems, in order:

1. `CapGame.Affine.initialP_fin`;
2. `ProjectiveCap.Projective.initialPStatement_binary_of_projectiveDim_ge_one`;
3. `ProjectiveCap.Projective.initialPStatement_of_odd_card_finrank_eq_two_mul`;
4. `ProjectiveCap.initialPStatement_of_even_card_finrank`.

Why hypotheses hold: one construction paragraph per row.

Consequence: Theorem A.

Outside: do not imply a theorem for `PG(2m,q)` over odd fields.

Milner audit: each construction discharges the same explicit contract.

Serre audit: formulas only for the elliptic block map and the two affine
branches.

### 4. Invariant classical subboards

Phenomenon: the projective mirror acts on more than the full point set.

Interface theorem: invariant-subboard mirror.

Why hypotheses hold: the block form scales by the nonsquare scalar.  Then use
`ProjectiveCap.Projective.isP_subCap_mapLinearEquiv` to transport the
coordinate theorem to any presentation supplied with the corresponding
projective linear equivalence.

Consequence: one hyperbolic-quadric and one coordinate-exact
elliptic-quadric corollary.

Conceptual compression: state the invariant zero-locus schema first.  An
arbitrary preserved point predicate is already accepted by the formal
subboard theorem; quadrics are examples where form similarity proves
preservation.

Outside: point to a companion for parabolic, Hermitian, and Baer-semilinear
method-boundary classification.

Milner audit: separate preservation of the board predicate from preservation
of cap legality.

Serre audit: no classification table and no coordinate variants in the main
text.

### 5. Odd projective planes: the exact residual problem

Phenomenon: whole-board symmetry fails at the first structurally different
family, but transitivity compresses the game to one residual interface.

Interface theorems:

1. frame reduction;
2. `initialPStatement_iff_oddEscapeStatement_finrank`;
3. `sizeThreeExtensionCount`;
4. on-conic full-PGL value transport.

Why hypotheses hold: the opening pair burns two parallel classes; a residual
size-three state plus the burned directions gives the conic-localized escape
set.

Consequence: a counterexample is exactly a value trap, not a state with no
move.

Outside: the uniform escape theorem remains open in the no-crown variant.

Milner audit: keep projective, grid, and conic representations connected by
named transport maps.

Serre audit: one normalized residual picture; no orbit-mining chronology.

### 6. Capacity degradation and the Node--Kayles boundary

Phenomenon: after a partial cap, saturated lines remove vertices, load-one
lines make pair conflicts, and load-zero lines retain triple constraints.

Interface theorems:

1. `gridCap_iff_allSmallSubsetsCap`;
2. `minimal_bad_extension_card`;
3. `gridCap_union_iff_all_pairs` under `NoActiveResidualTriples`;
4. isolated-gadget Grundy zero and follower-signature bound;
5. pair-budget inequalities.

Why hypotheses hold: projective lines share at most one pair, and cap
invalidity has a minimal collinear triple or row/column pair witness.

Consequence: the pair-only region is a static Node--Kayles game; the remaining
problem is dynamically routing coupled triples into that region.

Outside: no uniform small-Grundy theorem and no claim that gadgets are
disjunctive summands.

Milner audit: distinguish the static validity equivalence from game-tree
persistence.

Serre audit: one pair/triple residual diagram replaces all internal packet
names.

### 7. Finite evidence and verification boundaries

Phenomenon: exact finite cases test and delimit the open theorem.

Interface: reproduce the normalized fixed-q table from the C551 packaging
record, with separate columns for mathematical trust and publication-evidence
readiness.

Why sufficient: explain solver exhaustion, rules-only reply-DAG checking,
formal orbit transport, and Lean certificate consumption as distinct
interfaces.

Consequence: formal q=5,7,11,13; computed/rules-certified q=3,9,17,19,23 at
their exact tiers; q=25 only at the on-conic bucket layer; `PG(4,3)` as
higher-dimensional evidence.

Outside: no row is promoted beyond its certificate chain.

Milner audit: certificates implement a theorem interface; they do not define
the game.

Serre audit: main text gets the trust table and one checker contract;
commands, hashes, schemas, and inventories go to verification material.

### 8. Outlook or crown proof

Crown version: give the uniform residual-routing theorem and complete the
odd-plane implication.

No-crown version: state one exact open problem:

> Bound or classify the corrected rooted follower signatures in the coupled
> rank-three residual strongly enough to force a P-valued route into the
> pair-only Node--Kayles region.

Mention higher even-dimensional odd-field projective spaces separately.
Avoid a list of abandoned mechanisms.

## Figure and table slots

1. Mirror-contract commuting square.
2. Global-symmetry versus residual-capacity-degradation diagram.
3. Frame → grid → conic → rank-three residual diagram.
4. Mechanism-organized theorem table.
5. Fixed-q trust/readiness table.
6. One pair/triple residual-position figure.

## Verification-material split

The formal-core paper consists of the uniform family, mirror/subboard, and
residual-reduction theorems.  It has no logical dependency on the fixed-q
computations.  Treat the evidence section as a detachable annex:

Main paper:

- exact theorem statements and proof ideas;
- one paragraph defining each trust tier;
- normalized fixed-q table;
- statement of what the independent checker validates.

Verification supplement:

- exact replay commands;
- source, certificate, and manifest hashes and byte counts;
- finite domains and stop conditions;
- checker schemas and trusted boundaries;
- generated Lean dependency closures and axiom outputs.

Internal only:

- task chronology, handoffs, solver transcripts, failed build experiments,
  superseded selectors, and performance tuning.

If normalization or generated-source review is incomplete at freeze time,
drop the annex rather than weakening the trust vocabulary.  The headline and
all uniform proofs survive unchanged.

## Freeze gates

The architecture may be frozen when:

1. every cited Lean terminal has a referee-facing dependency-closure audit;
2. every retained computational row is either backed by a current-compliant
   evidence bundle or removed;
3. the conic-localization section cites exact formal terminals for every
   load-bearing bridge;
4. the literature audit licenses each historical claim;
5. the crown/no-crown choice is made from theorem status, not schedule.
