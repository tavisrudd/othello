# Deep holes beyond redundancy four

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

This directory contains the manuscript
*Deep holes of projective Reed--Solomon codes beyond redundancy four:
recursive carriers and exact classifications through redundancy ten* and its public
verification bundle.

The paper proves complete classifications at redundancies five and six over
every prime power \(q\geq7\), the complete split-free redundancy-seven
classification, and exact high-field classifications at redundancies eight
through ten.  Its recursive theorem identifies the reduced contained carrier
at arbitrary redundancy as the persistent catalecticant scheme plus one
maximal Lucas carrier.  In characteristic greater than \(r-1\), this gives an
exact classification above the displayed uniform threshold.  At redundancy
ten the first fresh higher Lucas carrier is shallow in every admissible binary
field.

## Build

From this directory:

```text
make check
make tit-check
```

`make check` builds the canonical preprint
`prs-beyond-redundancy-four.pdf`.  `make tit-check` builds the
IEEEtran single-column review manuscript
`prs-beyond-redundancy-four-tit-submission.pdf`.

The canonical and IEEEtran drivers consume the same abstract, index terms,
active sections, appendix, acknowledgment, and bibliography.  Their layout
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

Lean checks coordinate algebra, finite-record arithmetic, uniform budget
arithmetic, density, component selection, and conditional synthesis.  The geometric classifications, cited
point and covering-radius theorems, group actions, and certificate semantics
retain the explicit trust routes recorded in
`supplement/LEAN-STATEMENTS.md`.

## Scope

The arbitrary-redundancy statement is a reduced carrier containment theorem,
not a complete small-characteristic classification on every later Lucas
carrier.  It makes no assertion about nilpotent structure in a chosen
integral model and does not settle the general Reed--Solomon deep-hole
conjecture.  Version 1 and its public identifiers remain immutable.

Public release remains blocked on the immutable paper and Lean exports,
independent specialist signoffs, public identifiers, and author/account
confirmation.  No upload or external publication is performed by the local
verification commands.
