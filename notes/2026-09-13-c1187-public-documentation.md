# C1187 — Public documentation cleanup

**Lane:** `ergodis`
**Status:** complete. Core commit `5f537e6` (28 files); no export or push.

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
  session. The lock and Rust pin are unchanged. Added `uv` to the development
  environment and replaced remaining ad hoc Nix shell commands in the public
  benchmark and reference guides with pinned flake development commands.

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

## Final validation and ownership

Passed `nix flake check`, `CARGO_INCREMENTAL=0 nix run .#check` (fixture and
manifest agreement, fmt, all-target/all-feature Clippy and all-feature tests),
`CARGO_INCREMENTAL=0 nix run .#wasm-test` (including eight exact Python parity
cases), and the Python first-query smoke through the new entry point. The full
two-query Python README example also passed. ARM64 Linux shell output evaluated;
execution was on x86-64 Linux. No benchmark rerun or numerical claim was needed.

Final gate log:
`/tmp/claude-run-quiet/20260913-200920-nix-develop-c-python3-generate_evidence.py-write-nix-flake-check-CARGO_INCREMENTA/`.
The full Python README example log is
`/tmp/claude-run-quiet/20260913-200647-CARGO_INCREMENTAL0-nix-run-.python-c-from-ergodis-import-Client-Polynomial-Charac/`.
Final documentation audit covered 37 Markdown/HTML/SVG files and 128 local
links, with no missing targets. Public-document lint and staged pre-commit lint
passed; `git diff --check` passed.

The second native run passed compilation/Clippy but stopped at the manifest
test because another writer changed `scripts/public-lint.sh` and
`tests/publication-guards.sh`. The final gate passed against the refreshed
working-tree manifest. Before committing, restored only those two manifest
entries to their committed content identities, leaving both foreign edits
untouched. Verified the exact task-only commit manifest against all 614 Git
blobs before committing, then independently verified every entry against HEAD
after commit. Consequently the task commit is self-consistent; the dirty
publication-tool work needs its own hash refresh when its owner commits it.
The other writer's concurrent benchmark-curation commit was preserved too.

No algorithm, Rust source or mathematical certificate was changed by C1187.
No incidental discovery warrants a discovery-track entry. All task-owned core
paths are committed and clean. Public snapshot refresh remains with the
release-readiness work and requires its own authorization and gates.

## Follow-up — concise public losses summary

At Tavis's request, added a 101-word “Where it loses” section near the start of
`BENCHMARKS.md`. It retains the public-interest negative controls rather than
removing them during curation: L2's 193 s scheduling solve versus CP-SAT's
14.1 ms, both with optimum 10; and L3's configured width refusal versus a
CP-SAT feasible answer in 53.6 ms. The paragraph distinguishes refusal from
infeasibility, gives the paired-round measurement scope and links to the exact
evidence rows and the detailed comparison. No measurements were changed or
new benchmarks run. Each rounded number and status was checked directly against
`evidence/negative-control-tier.json`; publication lint and link checks passed.

Follow-up committed as core `bbcb225`. The full native gate passed with
`CARGO_INCREMENTAL=0 CARGO_PROFILE_DEV_DEBUG=1 nix run .#check`, after the shared
cache again produced duplicate verifier-crate type identities under the default
debug fingerprint. Log:
`/tmp/claude-run-quiet/20260913-203003-CARGO_INCREMENTAL0-CARGO_PROFILE_DEV_DEBUG1-nix-run-.check/`.
No shared artifacts were cleared. As above, the concurrent publication-tool edits
were left untouched and excluded from the committed manifest; all 614 entries
were verified against the exact task-only commit content. No export or push.
