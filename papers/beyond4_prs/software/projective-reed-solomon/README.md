# Projective Reed--Solomon Toolkit

This is the companion implementation for *Projective Reed--Solomon deep holes
beyond redundancy four*. Its current executable slice provides:

- exact polynomial-basis arithmetic over explicitly represented finite fields;
- projective syndrome normalization;
- both affine and infinity locator charts;
- increasing-degree Hankel-kernel search over projective locator space;
- the proved 12-point terminal-hyperplane selector for R5--R7, with streaming
  `O(q)`, `O(q^2)`, and `O(q^3)` prefix enumeration;
- intrinsic uniform R5 adapters for the tame rational/conjugate osculating
  families and the characteristic-three nucleus/wild families;
- the uniform R6 odd-binary third-nucleus adapter, including its exact
  extension-degree toggle;
- the uniform R7 odd-binary central-nucleus adapter, with complete q=8 exact
  distance extraction and the q=7,9 radius gap kept separate;
- exact tangent-family canonicalization in `m*q*(q-1)` transports and
  sigma canonicalization in `m*(q^2-1)` on the rootless-form stratum and
  `O(m*r*q)` on the simple-root stratum; these exhaust persistent sigma, while
  the same charts cover general forms in `O(m*r*q^2)` even at the
  characteristic-two degenerate successor;
- exact maximal-Hasse-root canonicalization in `O(m*r*q)` transports off the
  simultaneous Lucas degeneration and `O(m*r*q^2)` on it, including pure
  powers, with the full `m*(q^3-q)` path retained as a defensive fallback;
- an intrinsic persistent-sigma `T/T^(r-1)` modulo inversion/Frobenius
  extractor in `F_q[X]/Q`, using no discrete logarithm or torus enumeration;
- distinct rational-root recovery, Vandermonde magnitude recovery, and an
  independently replayed locator certificate;
- positive deep certificates whose independent verifier replays the frozen
  theorem-domain row, transporter, family route, and radius promotion;
- explicit `PGL(2,q) x Gal(F_q/F_p)` canonicalization with the exact
  `m(q^3-q)` cost exposed; and
- a single `projective-reed-solomon` command with focused subcommands.

## Command-line interface

Build the release executable and inspect its commands:

```text
cargo build --locked --release --bin projective-reed-solomon
target/release/projective-reed-solomon --help
```

The interface is organized by the mathematical question:

```text
projective-reed-solomon canonicalize request.json
projective-reed-solomon distance request.json
projective-reed-solomon decode request.json
projective-reed-solomon classify request.json
projective-reed-solomon verify certificate.json
```

All commands read JSON from standard input when the file is omitted and emit
machine-readable JSON. `--compact` selects one-line output, and the global
`--candidate-limit N` bounds locator or transporter enumeration. `classify`
uses the fail-closed theorem registry; `canonicalize` does not attach a coding
verdict.

A prime-field request has this shape:

```json
{
  "schema": "projective-reed-solomon-request-v1",
  "field": {
    "p": 7,
    "degree": 1,
    "modulus": [0, 1],
    "encoding": "polynomial-basis-base-p-integer-v1"
  },
  "redundancy": 5,
  "evaluation": "full-projective-nrc-v1",
  "syndrome": [0, 0, 0, 1, 0]
}
```

Structural `canonicalize` is dimension-independent: it accepts every
redundancy `r>=5` with `q>=r`. The exact tangent and binary-form lex-coset
proofs apply unchanged. Exact coding operations (`distance` and `decode`) now
accept the same range: exhaustive locator search through degree `r-1`, followed
by an arbitrary `r`-column NRC basis, is dimension-independent and returns a
replayable nearest-word certificate. General `classify` remains restricted to
R5--R10, but one prior-art-backed diagonal family is enabled in every even
field: when `r=q-1`, the exact orbit of the tangent normal form `e_(r-2)` has
distance and covering radius `r`. Its version-2 positive certificate replays
the terminal locator coefficient and two-element-complement obstruction. No
other higher-dimensional canonical form or exact distance `r-1` is promoted
without an independent covering-radius theorem-domain row. R11 tangent and
sigma fixtures and R12--R13 multiple-root fixtures over
`F_13` are checked against all 2,184 explicit PGL transports. A slow ignored
regression checks GF(16)/R11 against all 16,320 semilinear transports, and a
GF(16)/R16 fixture exercises the full-length `r=q` structural boundary. Slow
release-mode coverage also checks all 4,681 projective GF(8)/R5 and all 7,381
projective GF(9)/R5 forms against full semilinear enumeration.
An R17/GF(32) fixture also freezes the dimension-independent Lucas consequence
that degree `p^a` divided-power forms have no rootless stratum in
characteristic `p`; canonicalization detects that pattern and skips the
impossible rootless scan.

The four rational-root strata—rootless, simple, multiple, and pure power—give
an exhaustive worst-case bound of `O(m*r*q^2)` exact transports for structural
canonicalization, where `m` is the field extension degree. This is strictly
below full `m*(q^3-q)` enumeration when `r` is treated as the fixed redundancy;
the implementation retains that enumeration as its independent reference. The
symmetric-power action uses adjacent exact-linear-factor rows in `O(r^2)` field
operations per transport; see the [full accounting](docs/complexity.md).

`classify` returns witness-backed `NOT_DEEP`, persistent-family `DEEP`, and
frozen R5--R7 finite-exception `DEEP`/`UNRESOLVED` results. At GF(8)/R7 it is
complete: the nine-direction diagonal tangent orbit and the fixed central
nucleus are deep, while every other split-free orbit has distance six.
`canonicalize` uses
proved lex-coset charts on every binary form; the explicit group action remains
as a defensive reference path. It additionally returns prior-art-backed
`DEEP` for the even `r=q-1` diagonal tangent orbit, including GF(16)/R15.
Further R8--R10 nonpersistent formula adapters
remain open. `distance` and `decode` are exact for every `r>=5`, `q>=r`, within their explicit
candidate budget: after degrees through `r-1` they use an arbitrary NRC basis
at degree `r`, whose coefficients are forced nonzero by the failed lower
search. Locator candidates are streamed, so peak search storage is one locator
plus the Hankel-kernel basis rather than the candidate budget. Unsupported
classification paths fail closed.

The locator enumeration has projective kernel dimension
`2t+1-r` at degree `t`.  At terminal split-free testing `t=r-2`, this gives
the field-scale exponents `q`, `q^2`, and `q^3` for
redundancies five, six, and seven, before the `O(q)` exhaustive-root factor
check used by this reference implementation.  A later factoring backend must
separate locator selection cost from root-factorization cost.

The generic exact terminal fallback still enumerates the degree-`r-1` locator
hyperplane.  For R5--R7 it is now reached only as the bounded-small-field and
defensive correctness branch after the 12-point selector. The proof and
degree count are summarized in
[`docs/terminal-hyperplane-solver.md`](docs/terminal-hyperplane-solver.md).

`verify-certificate` accepts both
`projective-reed-solomon-locator-certificate-v1` negative witnesses and
`projective-reed-solomon-deep-certificate-v1` positive certificates. A deep
certificate is emitted only for `DEEP`, never for `UNRESOLVED` or
`UNSUPPORTED`.

The reproducible benchmark harness is built and run with:

```text
cargo run --release --manifest-path software/projective-reed-solomon/Cargo.toml \
  --bin projective-reed-solomon-benchmark -- --iterations 10 --extension-fields
```

When run from this directory, omit `--manifest-path`. Its selector,
projective-oracle, canonicalization, classification, and replay rows are
documented in [`docs/benchmarks.md`](docs/benchmarks.md).

## Repository boundary

This directory is deliberately self-contained. `data/theorem-domain-v1.json`
is the fail-closed theorem registry used by positive deep certificates, while
`data/frozen-orbits-v1.json` records the frozen finite exceptional orbits.
Neither file silently promotes generic computation into a covering-radius
theorem. See [`docs/theorem-boundary.md`](docs/theorem-boundary.md) and
[`docs/certificate-schemas.md`](docs/certificate-schemas.md).
The deterministic unit, property, CLI, and exhaustive layers are described in
[`docs/testing.md`](docs/testing.md).

The software is licensed under the MIT License. The surrounding paper and its
non-software material are licensed separately under CC BY 4.0.
