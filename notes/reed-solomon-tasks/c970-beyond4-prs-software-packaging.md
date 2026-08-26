# C970: Beyond Four PRS software packaging and paper upgrade

**Lane**: `reed-solomon`

**Status:** active; self-contained paper subtree and fast paper/software gates green

## Checkpoint: 2026-08-25

The implementation now lives under
`papers/beyond4_prs/software/projective-reed-solomon/` with the public name
**Projective Reed--Solomon Toolkit**. The crate, library, and executable use the
unambiguous `projective-reed-solomon` identity. Its Clap interface provides
`canonicalize`, `distance`, `decode`, `classify`, and `verify`, with a global
candidate limit, compact JSON output, stdin/file input, and descriptive help.

Both runtime registries are subtree-local. Public schemas and provenance no
longer expose internal task identifiers or development-note paths. The subtree
now owns its Rust pin, lock, MIT license, citation metadata, changelog, theorem
boundary, certificate documentation, complexity summary, benchmark protocol,
and terminal-selector summary.

The paper Makefile has fast and slow software targets. The supplement generates
and verifies a complete 21-file software manifest, registers it in the 74-entry
evidence bundle, and includes the whole software subtree in deterministic export
ownership. The canonical and TIT manuscripts state the broader computational
domain without broadening the deep-hole theorem domain. Formatting, warning-free
Clippy, 31 focused library tests, seven compiled-CLI integration tests, five
fixed-seed property tests (1,280 generated cases), both manuscript builds, and
the quick 74-artifact supplement gate pass.

The deterministic exporter then produced standalone paper commit
`38d68b863582e2aed3ee87c9a9e09028d1dd4153` from source commit
`fe49e690fe86b9c2d314812850c4f3821be1cca9`; its software and quick supplement
gates pass without the monorepo, and `cargo package --locked` verifies the
23-file crate archive. Filtering
`software/projective-reed-solomon/` to the repository root with
`git filter-repo` produced disposable software commit
`36ad2607603b1898eae17c3c09006b20f8bbf840`, whose formatting, warning-free
Clippy, fast test, and package gates pass without path repair. A CLI smoke
test classifies the documented GF(7)/R5 tangent request as `DEEP` and emits a
task-ID-free `projective-reed-solomon-deep-certificate-v1` certificate.

The TIT rebuild exposed a stale 50-page committed artifact whose source produced
51 pages. The review driver now omits only the two tables of raw GF(7)
redundancy-nine coefficient arrays, retaining them in the canonical paper and
electronic supplement and pointing there from the unchanged proof. With standard
IEEE theorem and bibliography typography restored, the TIT PDF is 49 pages. Its
Make gate now enforces the strict target `< 50` instead of printing and masking a
failed comparison.

Four ignored release regressions---the GF(8)/R7 distance audit, complete GF(8)
and GF(9) R5 chart exhaustions, and the GF(32)/R17 characteristic-power
boundary---pass together on the expanded test build in 129.91 seconds. The
GF(16)/R11 semilinear census is
isolated as `make software-gf16-check`; `make release-check` still requires it,
but it was not run without the separately required approval.

## Closeout and mystery ledger

- **Settled:** the public name is Projective Reed--Solomon Toolkit, with the
  unambiguous `projective-reed-solomon` crate, library, and executable identity.
- **Settled:** every shipped schema, path, registry locator, benchmark, and help
  surface is free of internal task identifiers.
- **Settled:** the fresh paper export and later software-only history filter both
  work without path repair and pass their fast gates.
- **Settled:** the stale TIT artifact is replaced by a warning-free 49-page
  build whose strict page gate leaves one page of headroom; only raw coefficient
  tables move to the canonical/supplement copy.
- **Open:** the sole unrun evidence gate is the exact GF(16)/R11 semilinear
  census. Its owning command is `make software-gf16-check`; no mathematical or
  packaging inference is drawn from an unrun result.

## Goal

Publish the C969 structural PRS classifier as a first-class companion artifact
inside the Beyond Four PRS paper repository while making its eventual extraction
into a standalone repository a history-preserving subtree operation rather than a
rewrite.  Upgrade the manuscript, supplement, release exporter, and verification
gates so that the software's computational scope and theorem boundary are explicit,
replayable, and release-pinned.

## Repository boundary

The initial authoritative location is:

```text
papers/beyond4_prs/software/projective-reed-solomon/
```

That directory must be independently buildable and must behave as a prospective
repository root.  It owns its `Cargo.toml`, `Cargo.lock`, pinned Rust toolchain,
MIT license, README, changelog, citation metadata, source, tests, documentation,
and machine-readable data.  It must contain no filesystem references, embedded
data paths, documentation links, or build dependencies that escape the subtree.
The paper remains CC BY 4.0, with the software subtree's MIT exception stated
unambiguously.

The theorem-domain registry currently consumed from
`notes/reed-solomon-tasks/c969-theorem-domain-v1.json` moves under the software
subtree and becomes the canonical machine-readable runtime boundary.  The frozen
orbit registry moves with it.  Paper-local verification hashes and semantically
checks those registries rather than maintaining a second authoritative copy.

## Deliverables

1. Relocate `rust/prs_classifier` with history-preserving moves into
`papers/beyond4_prs/software/projective-reed-solomon` and make it self-contained.
2. Give the crate a small stable public interface for `canonicalize`, `distance`,
   `decode`, `classify`, and `verify_certificate`, with versioned request and
   certificate schemas.  Separate theorem-domain lookup from computational
   algorithms; modularize the current monolithic library only where this can be
   done without changing behavior.
3. Add subtree-local documentation for the theorem boundary, certificate schemas,
   complexity claims, reproducible benchmarks, license, citation, and release
   history.  Replace every monorepo-relative README reference.
4. Add a manuscript subsection presenting the certified structural classifier as
   a companion result.  It must distinguish:
   - dimension-independent structural canonicalization;
   - exact budgeted distance and decoding for `r >= 5`, `q >= r`;
   - theorem-gated R5--R10 classification;
   - complete GF(8)/R7 extraction;
   - the prior-art-backed even-`q`, `r=q-1` diagonal tangent family; and
   - fail-closed unsupported or unresolved higher-dimensional classifications.
5. Add a compact operation/domain/proof-input/certificate table so computational
   coverage beyond R10 is not presented as a generic higher-dimensional deep-hole
   theorem.  Keep new mathematics, imported radius promotion, algorithms,
   certificate records, and implementation reach visibly separate.
6. Integrate the software subtree into the paper Makefile, reproduction guide,
   evidence manifest, release manifest, and deterministic release exporter.
   Distinguish the classifier's lock from the existing supplement toolchain lock.
7. Refresh the canonical and TIT packaging metadata, PDF hashes, source hashes,
   page counts, software version/commit pin, and availability statement after all
   manuscript and verification changes are final.

## Required gates

The paper repository exposes these conceptual gates, with final target names kept
stable once implemented:

- `software-check`: `cargo fmt --check`, warning-denying clippy, and
  `cargo test --locked`;
- `software-slow-check`: release-mode ignored exhaustive orbit and semilinear
  regressions;
- `supplement-check`: existing evidence checks plus hashes and semantic validation
  of the complete software boundary and theorem registries;
- `release-check`: both manuscript builds, fast and slow software checks, required
  supplement replays, and current PDF/software/source manifests.

`supplement/prepare_release_export.py` must treat the complete software subtree as
release-owned input, reject dirty owned paths, include it in the fresh-history
paper export, and produce a standalone candidate that passes the same checks
without the development monorepo.

## Implementation order

1. Move the crate without behavioral edits.
2. Internalize registries and remove all paths escaping the subtree.
3. Add toolchain, licensing, citation, documentation, and repository-ready metadata.
4. Modularize interfaces while preserving command and certificate compatibility.
5. Add software verification and release-export integration.
6. Upgrade manuscript scope/exposition and provenance ledgers.
7. Run the full paper/software release gate and refresh immutable-candidate metadata.

Keep coherent software-only changes confined to the software subtree whenever
possible so a later filtered history remains intelligible.

## Later extraction gate

From a fresh clone of the published paper repository, this operation must produce
a usable standalone repository without manual source or path repair:

```bash
git filter-repo \
  --path software/projective-reed-solomon/ \
  --path-rename software/projective-reed-solomon/:
```

The extracted root must build and test with its committed lock and toolchain, retain
license/citation/reproduction documentation, contain every runtime registry, and
have no references to the former paper or monorepo layout.  Hosted CI, a standalone
archive DOI, and crates.io publication are later publication operations, not
prerequisites for completing C970.

## Non-goals

- Do not broaden the theorem-domain registry merely because generic computation is
  available.
- Do not claim novelty for imported covering-radius results.
- Do not publish, push, rewrite public history, mint a DOI, or extract the standalone
  repository as part of this task without separate authorization.
- Do not make the Lean repository depend on the Rust package.

## Acceptance

C970 is complete when the classifier is self-contained under the paper tree; the
paper states its exact mathematical and computational boundary; all paper-local
software, supplement, manuscript, and deterministic-export gates pass; the release
manifests pin the reviewed artifacts; and a dry-run extraction in a disposable
fresh clone passes the crate's fast checks without path repair.
