# Deep holes beyond redundancy four

This directory contains the manuscript
*Deep holes of projective Reed--Solomon codes beyond redundancy four:
exact classifications at redundancies five through seven* and its public
verification bundle.

The paper proves complete deep-hole classifications at redundancies five and
six over every prime power \(q\geq7\).  At redundancy seven it proves the
complete split-free classification over the same range and promotes it to a
deep-hole classification whenever the covering radius is six, in particular
for \(q\geq11\).  Its finite-depth coherent-polar escape theorem treats the
uniform lifting step at arbitrary depth; the paper proves the required
contained-carrier hypotheses only at depths one and two and therefore makes no
arbitrary-redundancy classification claim.

## Build

From this directory:

```text
make check
make tit-check
```

`make check` builds the 30-page canonical preprint
`prs-beyond-redundancy-four.pdf`.  `make tit-check` builds the 23-page
IEEEtran single-column review manuscript
`prs-beyond-redundancy-four-tit-submission.pdf`.

The canonical and IEEEtran drivers consume the same abstract, index terms,
eight active section files, acknowledgment, and bibliography.  Their layout
is recorded in `sections/README.md`.

## Verification

The electronic supplement contains public classification records, generators,
independent replays, checksums, toolchain locks, and the declaration-level map
of the conditional Lean formalization.

Run

```text
python3 supplement/verify.py
```

for the local bundle, classification-record, manuscript-label, and formal-scope
checks.  Add `--replay` to execute every paper-local Python replay.
`--release` is reserved for an immutable public candidate whose repository,
revision, archive, DOI, PDF, and independent-reader fields are complete.

Lean checks coordinate algebra, finite-record arithmetic, degree-specific
budgets, and conditional synthesis.  The geometric classifications, cited
point and covering-radius theorems, group actions, and certificate semantics
retain the explicit trust routes recorded in
`supplement/LEAN-STATEMENTS.md`.

## Scope

Redundancies eight and nine, ordered-Hessian geometry, arbitrary-level
contained-carrier classification, and higher Lucas-carrier arithmetic are
companion work.  They are neither manuscript classification theorems nor
inputs to the R5--R7 results.  The finite-depth escape theorem deliberately
exposes these missing carrier hypotheses instead of assuming them.

Public release remains blocked on the immutable paper and Lean exports,
independent specialist signoffs, public identifiers, and author/account
confirmation.  No upload or external publication is performed by the local
verification commands.
