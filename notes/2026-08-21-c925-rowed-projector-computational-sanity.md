# C925 rowed-projector computational sanity suite

## Claim checked

The executable
`cubic-threefolds-tasks/c925-rowed-projector-sanity.hs` mirrors the final
algebraic source-to-consumer interface.  A source module carries an idempotent
marked projector, an invertible comparison with an ambient-plus-correction
sum, block naturality of the projector, and factorization of the marked row
through the ambient projection.  The consumer asks whether the row is nonzero
on the marked image.

The computation checks that the source and ambient detection Booleans agree.
It permits a nonzero marked projector on the correction term.  This is the
feature that makes the final argument independent of classifications or
vanishing theorems for weak-factorization centers.

The independent symbolic result is
`TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition.UnitScaledData.detects_iff`;
the exact-row theorem is its scale-one case.  The basis extensions used by the
source pipeline are `Data.ofBasisSquares` and
`CommonSourcePresentation.ofBasisSquares`.  The occurrence/path counterparts
are `RowedProjectorOccurrence.OccurrenceEquivalence.ofBasisSquares`,
`OccurrenceEquivalence.detects_iff`,
`CommonSourceEdgePresentation.toEdge`, and
`RowedProjectorPath.Path.detectsAt_iff`.  The smaller intrinsic route is
expanded by `FaithfulScalarEdge.ofBasisSquares` and
`FaithfulScalarEdge.detectsAt_iff`: the local endpoint rows and projectors are
scalar extensions by type, and faithful base change derives the native edge
predicate.  `FaithfulScalarEdge.ofBasisRowAndPolynomialProjector` additionally
derives the projector square from polynomial functional calculus and one
operator square.  Lean proves these results over an arbitrary commutative ring
and with an arbitrary row codomain; the computation is a finite regression,
not their proof.

## Exhaustive domain

The exhaustive model uses the field `F3`.  It enumerates all 48 matrices in
`GL(2,F3)`, both idempotent scalar projectors on the one-dimensional ambient
and correction factors, and all three scalar ambient rows.  Thus it checks 576
lawful raw bundles.  For every bundle it enumerates all nine source vectors
and all three ambient vectors.  It verifies:

- both comparison squares on the standard source basis and on every vector;
- idempotence and comparison invertibility;
- equality of source and ambient detection;
- the 288 cases with nonzero correction projector; and
- support for a row codomain larger than the coefficient field.

The expanded suite also checks:

- all 1,152 unit-scaled bundles for the two units of `F3`;
- faithful detection reflection along `F3 -> F9`;
- 104,976 polynomial-projector transport cases;
- 55,296 certificates formed from two independently chosen common-source
  presentations; and
- tensor endpoint detection for all 576 raw bundles.

Four malformed bundles independently break the row square, the projector
square, projector idempotence, or comparison invertibility.  The smart
constructor rejects each.  The first two malformed bundles also reverse the
detection Boolean, so both squares are load-bearing rather than decorative.

The edge source has seven separately named inputs:

1. Gu--Yu--Yu Proposition 5.2: an ordinary equivariant basis;
2. Gu--Yu--Yu Propositions 2.4 and 2.8: shift legality on that source;
3. Gu--Yu--Yu Proposition 4.21: the adjoint row square on basis vectors;
4. Gu--Yu--Yu Theorem 5.5: the completed comparison isomorphism;
5. connection naturality of that comparison;
6. the KKPYY canonical marked spectral union;
7. uniform coverage of every smooth-center blowup allowed in the all-\(m\)
   factorization.

Two alternative eighth inputs close the path, and the suite checks that they
are not accumulated:

- **typed-occurrence route:** every repeated vertex is the faithful pullback
  of one carrier, marked row, and marked projector;
- **intrinsic-predicate route:** every edge comparison has a faithful scalar
  presentation of the two native endpoint data and satisfies the row and
  projector squares.  Lean derives reflection of the native vertex-indexed
  detection proposition.

These tokens are path-level rather than edge-level.  A positive regression
traverses one certified direct-sum edge forward and then backward.  The hostile
`hostileNominalPath` test gives two edgewise-lawful occurrences with the same
vertex name but opposite detection values.  A name-only telescope accepts
them; the typed telescope rejects them.  Thus the Haskell token records a
genuine geometric obligation, not a convenience of the implementation.  Lean
expands that token into the faithful extension, completed direct-sum
equivalence, and two exact squares; it does not leave intrinsic reflection as
an axiom.

Two further fail-closed tokens guard the endpoint contradiction: geometric
identification of the cubic-product marked factor and geometric proof of
projective-space marked emptiness.  The arithmetic endpoint model is tested
separately and cannot manufacture either identification.

Four other tokens guard modular adapters and are not simultaneous assumptions
of the direct route: faithful common-base descent, polynomial presentation of
the marker, unit row normalization, and a tensor endpoint unit.  The suite
checks each adapter only when its route is selected.

These labels are obligations, not implementations of the cited theorems.

## Property checks and stabilization indices

QuickCheck 2.15.0.1 runs nine properties with seed 925 and 1,000 cases per
property.  It samples lawful comparisons, basis extension, detection
equivalence, correction-marker independence, unit scaling, polynomial
transport, common-source composition, arbitrary nonnegative stabilization
indices, and arbitrary finite path lengths.  The executable also checks the
endpoint formula directly for `m=0,...,64`.

The finite range is only a regression.  Lean proves
`projectiveProductBranchCount_pos (m)` for every natural number `m`; the
external projective-bundle theorem supplies the mathematical interpretation
of that positive branch count.
The output names `m=1,3,4,13` separately, with branch counts `2,4,5,14`.

## Replay

Working directory: `/home/tavis/src/othello/rust`.

GHC 9.10.3, QuickCheck 2.15.0.1:

```sh
nix shell --impure --expr \
  'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
  --command sh -c \
  'runghc ../notes/cubic-threefolds-tasks/c925-rowed-projector-sanity.hs \
   | diff -u \
       ../notes/cubic-threefolds-tasks/c925-rowed-projector-sanity-output.txt -'
```

Warning-free type check:

```sh
nix shell --impure --expr \
  'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
  --command ghc -Wall -Werror -fno-code \
  ../notes/cubic-threefolds-tasks/c925-rowed-projector-sanity.hs
```

Both commands pass.  The canonical output records 64 named checks, 576
exhaustive lawful bundles, 1,152 unit-scaled bundles, 104,976 polynomial
cases, 55,296 common-source cases, and 9,000 fixed-seed QuickCheck cases.

## Hashes

| artifact | bytes | SHA-256 |
|---|---:|---|
| `c925-rowed-projector-sanity.hs` | 34006 | `8a216e0c409240dc2c90aaa4937b5e61b1efbde8a3f54d0d5f4cd7127faea184` |
| `c925-rowed-projector-sanity-output.txt` | 3467 | `4e015e120272ba8d8f91a42e89f3c42f208f23ff9cf784c6880245accce25451` |

## Boundary

The suite does not compute Gromov--Witten invariants, construct a QDM
comparison, identify a marked spectral block, or verify any cited source.  It
tests the plumbing after the route-specific source facts are supplied.  The
six direct-edge obligations, uniform smooth-center coverage, either selected
path-level presentation obligation, and both endpoint identifications fail
closed independently.  On the intrinsic route that token means a native
faithful scalar presentation; Lean, rather than the token, proves edge
reflection.  Four other facts gate
alternative adapters and are not cumulative assumptions.  Source-fact tokens
are coverage labels, not implementations of the cited results.  Lean is the
independent general check of the consumer algebra.  The exact substitution and
publication-status audit is
`2026-08-21-c925-referee-source-substitution-table.md`.

## EJ + TT closeout and mystery ledger

- **Settled:** a correction projector may be nonzero.  All 288 such finite
  models satisfy the same detection equivalence, matching the symbolic Lean
  proof.
- **Settled:** the row square and projector square are independently
  load-bearing.  Each has a finite countermodel that reverses detection.
- **Settled:** idempotence and invertibility are separate legality gates.  The
  suite isolates each failure while leaving the comparison squares valid.
- **Settled:** two independently supplied common-source presentations compose
  to the same unit-scaled consumer.  All 55,296 finite cases check both
  presentation inverse laws and all three squares.
- **Settled:** faithful scalar extension, polynomial projector transport, unit
  normalization, and tensor endpoint transport are modular adapters rather
  than simultaneous assumptions of the direct edge route.
- **Settled:** the bounded stabilization sweep is not mathematical evidence
  for all `m`.  Lean proves the symbolic positive branch count; the Haskell
  values at `1,3,4,13` and the range through `64` are regressions.
- **Evidence boundary:** the executable names but cannot establish any
  external source theorem.  Their theorem-level audit is kept in the source
  dossier and is not inferred from successful execution.

No genuine mystery remains in the algebraic or computational consumer.  The
existence and geometric identification of the completed QDM maps remain the
source trust boundary; finite truncations cannot establish them.
