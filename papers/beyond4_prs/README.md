# Deep Holes of Projective Reed--Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten

[![Version 1 concept DOI](https://img.shields.io/badge/Version_1_concept_DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

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
make software-check
make supplement-check
```

`make check` builds the canonical preprint
`prs-beyond-redundancy-four.pdf`.  `make tit-check` builds the
IEEEtran single-column review manuscript
`prs-beyond-redundancy-four-tit-submission.pdf`.

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

The tree carries the unrefereed Version 2 candidate. Its fixed-level results
reach redundancies five through ten at the field ranges stated above; the
arbitrary-redundancy theorem remains conditional on its explicit intermediate
package hypotheses. Version 1 and its DOI remain immutable, while a public
Version 2 revision is an author decision.

Run

```text
python3 supplement/verify.py
```

for the local bundle, companion-software manifest, classification-record,
manuscript-label, and formal-scope checks. Add `--replay` to execute every
paper-local Python replay.
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

No upload or external publication is performed by the local verification
commands. The public release surface records the paper and Lean revisions,
archive metadata, and independent-reader fields separately from this local
candidate.
