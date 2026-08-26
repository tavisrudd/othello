# Electronic supplement

## Description

This supplement contains the canonical classification records, generators,
certificates, deterministic replays, checksum manifests, toolchain locks, the
declaration-level trust map, and Projective Reed--Solomon Toolkit for “Deep
Holes of Projective Reed--Solomon Codes Beyond Redundancy Four: Recursive
Carriers and Exact Classifications Through Redundancy Ten.”

## Size

The review package is verified in its source-tree form by
`supplement/EVIDENCE-MANIFEST.json`. The final compressed archive name, byte
count, and SHA-256 are submission-time metadata and are not claimed by this
local candidate.

## Platform and environment

The supported platform is x86-64 Linux.  The pinned Nix environment supplies
Python, Rust, Lean, TeX, `jq`, Git, and the system libraries required by the
paper-local checks.  See `supplement/REPRODUCING.md` and
`supplement/toolchain/`.

## Major components

- `CLASSIFICATION-RECORDS.json` and its guide give the public R5--R7 orbit
  records.
- `EVIDENCE-MANIFEST.json` and `EVIDENCE-ROWS.md` enumerate every bundled
  artifact with SHA-256 and byte count.
- `evidence/` contains the finite-field generators, certificates, and
  replays.
- `LEAN-STATEMENTS.md` identifies the exact formal declarations and every
  nonformal hypothesis.
- `software/projective-reed-solomon/` contains the self-contained Rust toolkit,
  examples, registries, tests, and its own software manifest.

## Setup and execution

From the manuscript source directory, enter the pinned environment with
`nix develop`.  Run:

```text
python3 supplement/verify.py
python3 supplement/verify.py --replay
```

The first command checks the bundle, public classification records, hashes,
and local release-manifest rows.  The second additionally reruns every
paper-local replay, including the compiled characteristic-seven comparison.
Expected success messages and per-certificate semantics are detailed in
`supplement/REPRODUCING.md`.

## Contact

Tavis Rudd. Private contact and account metadata are supplied through the
journal submission system rather than stored in this public artifact.
