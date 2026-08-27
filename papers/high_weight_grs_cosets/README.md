# High-Weight Cosets of Generalized and Extended Reed--Solomon Codes

[![Version 1 concept DOI](https://img.shields.io/badge/Version_1_concept_DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

## Read the paper

[**Open the paper (PDF) →**](high-weight-grs-cosets.pdf)

[**Open the TIT submission version (PDF) →**](high-weight-grs-cosets-tit.pdf)

This directory contains the manuscript and its public verification bundle.
For every redundancy \(r\geq6\), it classifies all cosets of weight at least
\(r-1\) for sufficiently long generalized and extended Reed--Solomon codes
whose support is obtained from the projective line by deleting any prescribed
finite set.  The classification gives exact deep-hole shells, all MDS and NMDS
one-column extensions, family-wise minimum-support counts, and aggregate weight
enumerators.

The proof spine is coherent polar contraction.  An exact terminal
decomposition, recursive carrier theorem, simultaneous finite-field selector,
and genus-one terminal count leave only the catalecticant rank-two locus and a
characteristic-dependent Lucas carrier.  In the tame range the latter is
empty, producing the complete coding-theoretic classification.  Detailed
redundancy-five through redundancy-seven results supply sharp refinements;
the former R8--R10 calculations remain companion records rather than claims of
the submission.  The supplement states exactly where computation, imported
theorems, and formal interfaces enter.

## Build

From this directory:

```text
make check
make tit-check
make software-check
make supplement-check
```

`make check` builds the canonical manuscript
`high-weight-grs-cosets.pdf`.  `make tit-check` builds the
IEEEtran single-column review manuscript
`high-weight-grs-cosets-tit.pdf`.

## Companion software

Projective Reed--Solomon Toolkit is under
`software/projective-reed-solomon/`. Its `projective-reed-solomon` executable
provides `canonicalize`, `distance`, `decode`, `classify`, and `verify`
subcommands. The toolkit starts from versioned syndrome JSON and returns exact
canonical forms, nearest-error results with replayable locator witnesses, or
theorem-gated verdicts whose positive certificates replay independently. Its
README gives a runnable two-example quick start, and `docs/cli.md` records command outputs and exit
behavior.
The crate carries its own lock, pinned Rust toolchain, MIT license, theorem
registry, frozen orbit data, and extraction-ready documentation. Run the fast
format, lint, and test gate with `make software-check`; exhaustive release-mode
regressions are isolated under `make software-slow-check`, with the explicit
GF(16)/R11 semilinear census under `make software-gf16-check`.

Generic canonicalization and exact budgeted decoding extend beyond the paper's
fixed R5--R10 classification range. They do not create a higher-dimensional
deep-hole theorem: `classify` fails closed outside its frozen mathematical
registry.

The canonical and IEEEtran drivers consume the same abstract, index terms,
active sections, appendix, acknowledgment, and bibliography.  Their layout
is recorded in `sections/README.md`.

## Verification

The electronic supplement contains public classification records, generators,
independent replays, checksums, toolchain locks, and the declaration-level map
of the conditional Lean formalization.

The fixed-level results reach redundancies five through ten at the field ranges
stated above; the arbitrary-redundancy theorem remains conditional on its
explicit intermediate package hypotheses.

Run

```text
python3 supplement/verify.py
```

for the local bundle, companion-software manifest, classification-record,
manuscript-label, and formal-scope checks. Add `--replay` to execute every
paper-local Python replay.
`--release` is reserved for an immutable public release whose repository,
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

No upload or external publication is performed by the local verification
commands. The public release surface records the paper and Lean revisions,
archive metadata, and independent-reader fields separately from this local
bundle.
