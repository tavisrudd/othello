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
`TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition.Data.detects_iff`.
The basis extension used by the source pipeline is
`Data.ofBasisSquares`.  Lean proves both over an arbitrary commutative ring and
with an arbitrary row codomain; the computation is a finite regression, not
their proof.

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

Four malformed bundles independently break the row square, the projector
square, projector idempotence, or comparison invertibility.  The smart
constructor rejects each.  The first two malformed bundles also reverse the
detection Boolean, so both squares are load-bearing rather than decorative.

The source inventory has six separately named inputs.  Removing any one makes
certification fail:

1. Gu--Yu--Yu Proposition 5.2: an ordinary equivariant basis;
2. Gu--Yu--Yu Propositions 2.4 and 2.8: shift legality on that source;
3. Gu--Yu--Yu Proposition 4.21: the adjoint row square on basis vectors;
4. Gu--Yu--Yu Theorem 5.5: the completed comparison isomorphism;
5. connection naturality of that comparison; and
6. the KKPYY canonical marked spectral union.

These labels are obligations, not implementations of the cited theorems.

## Property checks and stabilization indices

QuickCheck 2.15.0.1 runs six properties with seed 925 and 1,000 cases per
property.  It samples lawful comparisons, basis extension, detection
equivalence, correction-marker independence, arbitrary nonnegative
stabilization indices, and arbitrary finite path lengths.  The executable also
checks the endpoint formula directly for `m=0,...,64`.

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

Both commands pass.  The canonical output records 38 named checks, 576
exhaustive lawful bundles, and 6,000 fixed-seed QuickCheck cases.

## Hashes

| artifact | bytes | SHA-256 |
|---|---:|---|
| `c925-rowed-projector-sanity.hs` | 16772 | `1830fabcf200115965bc0b445067251704a4349585c1df71e1f58980a216164b` |
| `c925-rowed-projector-sanity-output.txt` | 1874 | `f888258f18416053a48427071a5f537a290b2d34606f9f871d3b3d6d9ed36cc1` |

## Boundary

The suite does not compute Gromov--Witten invariants, construct a QDM
comparison, identify a marked spectral block, or verify any cited source.  It
tests the plumbing after those source facts are supplied and makes omission of
one of the six facts fail closed.  Lean is the independent general check of
the consumer algebra.  The mathematical source dossier remains
`2026-08-21-c925-no-stokes-source-dossier.md`.

## EJ + TT closeout and mystery ledger

- **Settled:** a correction projector may be nonzero.  All 288 such finite
  models satisfy the same detection equivalence, matching the symbolic Lean
  proof.
- **Settled:** the row square and projector square are independently
  load-bearing.  Each has a finite countermodel that reverses detection.
- **Settled:** idempotence and invertibility are separate legality gates.  The
  suite isolates each failure while leaving the comparison squares valid.
- **Settled:** the bounded stabilization sweep is not mathematical evidence
  for all `m`.  Lean proves the symbolic positive branch count; the Haskell
  values at `1,3,4,13` and the range through `64` are regressions.
- **Evidence boundary:** the executable names but cannot establish the six
  external source facts.  Their theorem-level audit is kept in the source
  dossier and is not inferred from successful execution.

No genuine mystery remains in the algebraic or computational consumer.  A
future failure would have to falsify one of the recorded external-source
instantiations, not uncover another missing consumer hypothesis.
