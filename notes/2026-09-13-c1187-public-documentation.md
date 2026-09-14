# C1187 — Public documentation cleanup

**Lane:** `ergodis`
**Status:** in progress.

## Scope and acceptance

Review the public documentation in the Ergodis core for a first-time public
reader. Describe supplied functionality only; remove internal process and
unreleased proposals. Retain useful contributor naming, component ownership
and reusable-core guidance in public `docs/dev/`, with no private-package
references. Preserve mathematical contracts, result distinctions and security
limits. Introduce concepts before using their names and follow the paper style
guide's sentence and paragraph discipline.

Reconcile stale glossary entries against implemented repository/runtime APIs;
replace migration narratives with present-tense usage. Separate the Python API
from reference tooling and resolve its Python-version mismatch with the flake.
Do not change algorithms, benchmark results or release/export state.

Validation: documentation/link and scope checks, refreshed source manifest,
the standard native validation gate and Python fixture agreement. Record exact
changes, validation results and any exclusions below. Publication remains
outside this task; benchmark-section curation remains with C1149.

## Execution

Sol owns DESIGN, glossary and public contributor guidance. Root owns the other
public pages, integration, setup and validation. No incidental research lead
has been identified.
