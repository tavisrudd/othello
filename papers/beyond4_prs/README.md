# Deep holes beyond redundancy four

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

## Read the paper

[**Open the paper (PDF) →**](prs-beyond-redundancy-four.pdf)

[**Open the TIT submission version (PDF) →**](prs-beyond-redundancy-four-tit-submission.pdf)

This directory contains the manuscript
*Deep holes of projective Reed--Solomon codes beyond redundancy four:
recursive carriers and exact classifications through redundancy ten* and its public
verification bundle.

The first previously open case, redundancy five, and redundancy six are
classified for every prime power \(q\geq7\).  Redundancy seven has a complete
split-free classification for every \(q\geq7\), promoted to a deep-hole
classification for \(q\geq11\); redundancies eight, nine, and ten have exact
deep-hole classifications for \(q\geq43,53,59\), respectively.

The governing mechanism is coherent polar contraction.  For every
\(r\geq6\), the reduced recursively contained locus is unconditionally the
union of the catalecticant rank-two scheme and one maximal adjacent-zero
Lucas carrier.  Dense squarefree markers select one terminal component, while
Pascal nesting merges all modular descendants into that carrier.  Under the
stated intermediate-package hypothesis this yields the uniform
arbitrary-redundancy classification; at redundancy ten a final-pair
Artin--Schreier argument proves that the entire degree-nine Lucas carrier is
shallow over every \(\mathbb F_{2^m}\), \(m\geq4\).  The supplement states
exactly where bounded certificates, mathematical arguments, and conditional
Lean interfaces enter.

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
