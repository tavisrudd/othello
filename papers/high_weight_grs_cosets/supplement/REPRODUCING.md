# Reproducing the computational supplement

The complete local evidence bundle is under this `supplement/` directory.
`EVIDENCE-MANIFEST.json` records every stable path, SHA-256 value, byte count,
and replay class; `EVIDENCE-ROWS.md` is its human-readable rendering.  Verify
the bundle without access to the development monorepo by running, from the
paper directory:

```text
python3 supplement/verify.py
```

The quick check also verifies that the local PDF and the seven
supplement-artifact rows printed in `RELEASE-MANIFEST.md` match the
current files.  It deliberately does not fill or validate the external
repository, archive, DOI, or immutable-release fields.

Run every paper-local Python replay with:

```text
python3 supplement/verify.py --replay
```

## Pinned environment

The exact Lean, Lake, Nix, and Rust dependency locks used by the development
tree are copied into `supplement/toolchain/` and hashed in the evidence
manifest:

- `lean-toolchain`;
- `lake-manifest.json`;
- `export-flake.lock` and `export-flake.nix`;
- `Cargo.lock`.

The Python replays use only the standard library.  The Rust generators
require a Rust compiler compatible with the copied lock; the GF(27) sweep
generator carries its own `Cargo.toml` and `Cargo.lock` and has no
dependencies.  External repository,
tag, archive, and DOI fields belong to the immutable publication step and are
listed separately in `RELEASE-MANIFEST.md`.

The paper-export root also contains `flake.nix`, `flake.lock`, and
`lean-toolchain`.  Enter the pinned environment before building or replaying:

```text
nix develop
```

Build the manuscript with `make check`.  The canonical output is
`high-weight-grs-cosets.pdf`;
`main.pdf` is not part of the export.

The paper repository includes the self-contained Projective Reed--Solomon
Toolkit under `software/projective-reed-solomon/`. Run its fast gate with:

```text
make software-check
```

The gate checks formatting, warning-free Clippy, and the locked test suite.
`make software-slow-check` runs the four ignored exhaustive release regressions
over GF(8), GF(9), and GF(32). The separately named
`make software-gf16-check` runs the full GF(16)/R11 semilinear census; the full
`make release-check` requires both slow gates.
The `projective-reed-solomon` executable exposes `canonicalize`, `distance`,
`decode`, `classify`, and `verify`; its README provides runnable examples, and
`software/projective-reed-solomon/docs/cli.md` records the JSON workflow, exit
behavior, and certificate boundary.
`supplement/SOFTWARE-MANIFEST.json` hashes every shipped file in the software
subtree, excluding only build and Git directories.

This paper repository contains the frozen statement map and toolchain locks,
but it does not bundle a `lean/` checkout. The paper-facing formal closure is
maintained in a separate Lean repository. Its eventual immutable public commit in
`https://github.com/tavisrudd/finitegeom` is release metadata in
`RELEASE-MANIFEST.md`.  The version-independent archival locator for that
repository is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
Every certificate consumed by the adopted theorem set
is already paper-local; no separate certificate-package input belongs in the
release workspace. Until the public Lean repository and revision are published,
the local bundle checks the paper-local evidence and Lean interface described
in the manuscript but does not claim an externally fetchable formal replay.

## Replay semantics

The release manifest assigns every replay one of the schema labels
**rederive**, **reconstruct**, or **compare** from
`CERTIFICATE-SCHEMA.md`.  A successful comparison-only replay is never
described as an independent derivation.

## Replay map

| Public label | Domain/stop condition | Replay boundary |
|---|---|---|
| Certificate R5 | nineteen recorded fields; pointwise and orbitwise exhaustion | independent Python replay |
| Certificate R6 | direct scan through \(q=16\); structural bridge thereafter | independent replay plus radius gate |
| Certificate R6-NF | recorded small exceptional normal forms | same-file deterministic checker |
| Certificate R7 | \(q=7,8,9,11\) census and the finite coherent-polar bridge below 37 | primary quotient enumeration, representative/orbit replay, independent-arithmetic reconstruction, and an independent direct-locus enumeration of the complete split-free sets and orbit partitions |
| Certificate R7 direct locus | fourteen-field candidate-domain exhaustion | direct-locus reconstruction with declared shared engine/R5/R6 inputs; checker is not a second field implementation |
| Certificate SC | integral factorization and bridge identities in every characteristic; saturation over \(\mathbf Z[1/6]\); fibres \(2,3\) | dependency-free identity/factorization replay plus Singular primary decomposition |
| Certificate R8 | threshold, modular supports, and witness data | generator plus separately written replay |
| Certificate R9 | residual-quadratic and characteristic-seven bridge data | generator, independent residual replay, and exact q=49 Rust record |
| Certificate R10 | threshold and persistent orbit arithmetic | generator plus independent cyclic-orbit replay |
| Certificate Lucas M9 | full carrier at q=16,32; invariant-block rank-two twists at q=64 | exact quotient certificates plus independent action/Hankel replay; the q=64 complement and all larger fields are mathematical |
| Certificate R11 binary quotients | complete degree-ten divided-power upper-Borel quotients of the carrier at q=16,32 | two toolkit-free replays that rebuild the field, the action, every orbit, and every Hankel equation, each behind a fail-closed 1,000-pair equivariance gate |
| Certificate R11 GF(27) sweep | all 402,321,277 projective classes of PG(6,27); zero fallback invocations, zero unsaturated classes | frozen sweep outputs plus an independent Python replay of the seeded 200-class witness sample; the 26-minute Rust sweep is a separate rederive |
| Certificate R11 characteristic seven | seven pointed orbit representatives over q=49 | generator plus an independently written replay that shares no code with the toolkit or the generator |

## Exact replay commands

Run these from the paper directory.  Each subshell changes only to the
paper-local directory containing the named certificate.  The top-level
`--replay` option runs the complete Python replay list; the two Singular commands are
separate checks in the same evidence bundle.

```text
(cd supplement/evidence/r5 && python3 2026-07-22-redundancy-five-deep-hole-replay.py --json 2026-07-22-prs-deep-hole-census.json)
(cd supplement/evidence/r6 && python3 2026-07-22-redundancy-six-deep-hole-replay.py --json 2026-07-22-prs-deep-hole-census.json)
(cd supplement/evidence/r6-normal-forms && python3 2026-07-23-small-exceptional-normal-forms.py --summary)
(cd supplement/evidence/r7 && python3 2026-07-23-prs-deep-hole-calibration-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-r7-independent-arithmetic-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-r7-direct-locus-replay.py --check 2026-07-26-r7-direct-locus-replay.json)
(cd supplement/evidence/r7-direct-locus-v2 && python3 2026-08-02-r7-direct-locus-generator.py --check)
(cd supplement/evidence/r7-direct-locus-v2 && python3 2026-08-02-r7-direct-locus-checker.py 2026-08-02-r7-direct-locus-certificate.json --compare-public ../../CLASSIFICATION-RECORDS.json --output-comparison 2026-08-02-r7-direct-locus-public-comparison.json --check-comparison)
(cd supplement/evidence/r8 && python3 2026-07-23-prs-redundancy-eight.py --check)
(cd supplement/evidence/r8 && python3 2026-07-23-prs-redundancy-eight-replay.py)
(cd supplement/evidence/r9 && python3 2026-07-23-prs-redundancy-nine.py --check)
(cd supplement/evidence/r9 && python3 2026-07-23-prs-redundancy-nine-replay.py)
(cd supplement/evidence/r9 && rustc -O 2026-07-23-prs-redundancy-nine-q49.rs -o /tmp/prs-r9-q49 && /tmp/prs-r9-q49 | cmp - 2026-07-23-prs-redundancy-nine-q49.txt)
(cd supplement/evidence/r10 && python3 2026-07-23-prs-redundancy-ten-synthesis.py --check)
(cd supplement/evidence/r10 && python3 2026-07-23-prs-redundancy-ten-synthesis-replay.py)
(cd supplement/evidence/lucas-m9 && python3 2026-07-24-degree-nine-rank-two-artin-schreier-avoidance.py --check)
(cd supplement/evidence/lucas-m9 && python3 2026-07-24-degree-nine-rank-two-artin-schreier-avoidance-replay.py)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers.py 16 --check 2026-08-02-higher-lucas-modular-carriers-q16.json)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers.py 32 --check 2026-08-02-higher-lucas-modular-carriers-q32.json)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers-replay.py)
(cd supplement/evidence/stable-components && python3 2026-07-24-r10-integral-bad-scheme-sc11.py --check)
(cd supplement/evidence/stable-components && python3 2026-07-24-stable-component-fano-elimination.py --check)
(cd supplement/evidence/stable-components && Singular -q 2026-07-24-r10-integral-bad-scheme-sc11.sing)
(cd supplement/evidence/r11-binary-quotients && python3 2026-08-28-r11-gf16-pointed-quotient-replay.py)
(cd supplement/evidence/r11-binary-quotients && python3 2026-08-28-r11-gf32-pointed-quotient-replay.py)
(cd supplement/evidence/r11-gf27-switch-sweep && python3 2026-08-28-r11-gf27-witness-replay.py)
(cd supplement/evidence/r11-char7-pointed-orbits && python3 2026-08-28-r11-char7-pointed-orbits-replay.py)
```

## Redundancy-eleven companion bundles

The three redundancy-eleven bundles are companion records; the manuscript
claims nothing at redundancy eleven and no adopted statement depends on them.
Their four Python replays are in the list above and in `verify.py --replay`.
They need no compiler, no toolkit, and no network.

Their generators are separate.  Each rederives its certificate but needs the
compiled Projective Reed--Solomon Toolkit or a Rust compiler, so none of them
belongs to the quick Python replay:

```text
(cd supplement/evidence/r11-binary-quotients && python3 2026-08-28-r11-gf16-pointed-quotient.py --check --binary ../../../software/projective-reed-solomon/target/release/projective-reed-solomon --output 2026-08-28-r11-gf16-pointed-quotient.json)
(cd supplement/evidence/r11-binary-quotients && python3 2026-08-28-r11-gf32-pointed-quotient.py --check)
(cd supplement/evidence/r11-char7-pointed-orbits && python3 2026-08-28-r11-char7-pointed-orbits.py --check)
(cd supplement/evidence/r11-gf27-switch-sweep && cargo build --release --locked --manifest-path 2026-08-28-r11-gf27-switch-sweep/Cargo.toml && PROBE_THREADS=8 2026-08-28-r11-gf27-switch-sweep/target/release/probe certify)
(cd supplement/evidence/r11-gf27-switch-sweep && python3 2026-08-28-r11-gf27-witness-replay.py 2026-08-28-r11-gf27-switch-sweep/out/certify-witness-sample.tsv)
```

The two binary-field generators reproduce their certificates only against the
pinned toolkit build recorded in each certificate's `binary_sha256`; the GF(32)
certificate additionally pins the GF(16) generator source in
`base_source_sha256`, so that generator is bundled byte-for-byte and is invoked
with explicit `--binary` and `--output` rather than through patched defaults.
The GF(16) quotient generator takes about 17 seconds and the GF(32) one about
95 seconds.  The characteristic-seven generator takes about 34 seconds.

The GF(27) sweep is the one long rerun: about 26 minutes on eight threads.  It
writes into `2026-08-28-r11-gf27-switch-sweep/out/`, beside the crate and never
over the frozen dated copies in the bundle root, so a rerun is compared against
them rather than replacing them.  `PROBE_QLIMIT=<n>` truncates the sweep to the
first `n` quotient points for a smoke test.  What that sweep certifies is a
closure of the redundancy-eleven carrier `PG(6,27)`, not of the ambient
`PG(10,27)`; the certificate-free switch lemma remains open.

The public R5--R7 orbit tables are a deterministic projection of the
hash-pinned frozen certificates.  From the paper directory run:

```text
python3 supplement/build_classification_records.py --check
```

This verifies the embedded source hashes, every projected record, and every
orbit-size completeness sum.  It does not rerun the classifications.

## Public classification-record extraction

From the paper directory:

```text
python3 supplement/build_classification_records.py --check
jq -e 'all(.records[].fields[]; .exhaustion_identity == true)' \
  supplement/CLASSIFICATION-RECORDS.json
```

The builder reads only the bundled R5, R6, R6-NF, and R7 certificates.  It
stops after serializing all 19 R5 fields, 11 R6 fields, and 14 R7 fields, and
proves byte-for-byte agreement with the committed public record.  The `jq`
command independently checks every recorded orbit-size exhaustion identity.
This extraction does not rerun the underlying finite classifications.
