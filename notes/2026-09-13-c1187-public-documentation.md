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

## Implemented changes

- Replaced speculative component/glossary descriptions with supplied APIs;
  corrected repository publication, attempts, sidecars and service terminology.
- Added `docs/dev/contributor-boundaries.md` for public contribution placement,
  dependency and naming guidance. No private packages or unreleased designs.
- Added a task-based documentation index and linked it from the root README.
- Removed roadmap and migration narratives from the admission, language,
  runtime, run-record, bundle, protocol and verification references. Retained
  actual scope, replay, correctness and security limits.
- Reframed the benchmark classifier as a performance heuristic for its stated
  kernel/corpus, not a universal API-acceptance classifier. Preserved its
  predictions, measurements, predeclaration hash and calibration disclosures;
  no benchmark curation or numerical claims changed.
- Reordered browser instructions around reader actions and added purpose-first
  openings to technical references. Clarified the module ABI's separate scope.
- Split Python use from reference tooling; changed the flake development tools
  to Python 3.14.7 and added `nix run .#python`, which builds the RPC binary and
  configures its location and the Python package for scripts or an interactive
  session. The lock and Rust pin are unchanged.

## Validation record

Initial local-link audit: 37 public documents/assets, 128 relative links,
no missing targets. Public-document lint passed. Sol integration review found
and root corrected the module-ABI scope sentence and two glossary definition
issues. No incidental research lead arose.

The first native check passed formatting and fixture/hash checks but failed
Clippy with duplicate `ergodis_verify` type identities from the shared build
cache (absolute and relative source paths). No Rust source was changed and no
shared artifacts were deleted. Retry uses `CARGO_INCREMENTAL=0` in the same
required target directory. Final validation results and commit follow below.

Command hygiene: an initial combined instruction read exceeded the outer tool
output budget. It was replaced by separate bounded reads; no task action relied
on a truncated instruction.
