# Electronic supplement

## Description

This supplement contains the canonical classification records, generators,
certificates, deterministic replays, checksum manifests, toolchain locks, and
the declaration-level trust map for “Projective Reed--Solomon Syndromes Beyond
Redundancy Four: Deep Holes, Coherent Polar Flags, and Modular Carriers.”

## Size

[[AUTHOR INPUT: exact compressed archive filename, byte count, and SHA-256]]

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

[[AUTHOR INPUT: corresponding-author name and email]]
