# Projective Reed--Solomon Toolkit

Exact, proof-carrying tools for full-length projective Reed--Solomon syndromes.

The toolkit turns a syndrome over an explicitly represented finite field into
one of three kinds of output: a semilinear canonical form, an exact nearest-error
certificate, or a theorem-gated deep-hole verdict. These outputs deliberately
have different mathematical scopes. Canonicalization and decoding work beyond
the paper's classification range; a positive deep-hole verdict requires a
matching theorem-domain entry and carries a certificate that can be replayed
independently.

The software accompanies *Projective Reed--Solomon deep holes beyond redundancy
four*. It is self-contained here so this directory can later be extracted as a
standalone repository without repairing paths or recovering data files.

## Choose the operation

Write `q` for the field order and `r` for the redundancy.

| Command | What it answers | Implemented domain |
|---|---|---|
| `canonicalize` | Which semilinear orbit contains this syndrome? | Every `r >= 5`, `q >= r` |
| `distance` | What is its exact distance from the code? | Every `r >= 5`, `q >= r`, within the candidate budget |
| `decode` | What nearest error pattern realizes that distance? | Same exact search as `distance` |
| `classify` | Does the frozen theorem package prove it deep or not deep? | Registry-gated R5--R10, plus the certified even-field diagonal family at `r=q-1` |
| `verify` | Does this locator or positive deep certificate replay? | Every emitted certificate schema |

`canonicalize` never attaches a coding verdict. `classify` is fail-closed: it
does not turn computational reach into a covering-radius theorem.

## Quick start

The committed Rust toolchain and dependency lock are sufficient to build the
release executable:

```text
cargo build --locked --release --bin projective-reed-solomon
target/release/projective-reed-solomon --help
```

Classify the included tangent syndrome over `F_7`:

```text
target/release/projective-reed-solomon classify examples/tangent-r5-f7.json
```

The result is `DEEP` and includes a
`projective-reed-solomon-deep-certificate-v1` object. Save that nested object
and replay it with:

```text
target/release/projective-reed-solomon verify certificate.json
```

For a shallow example, compute and replay the nearest-error certificate:

```text
target/release/projective-reed-solomon distance examples/shallow-r5-f7.json \
  > locator-certificate.json
target/release/projective-reed-solomon verify locator-certificate.json
```

Every command reads JSON from standard input when `FILE` is omitted:

```text
cat request.json | target/release/projective-reed-solomon -c canonicalize
```

Use `--candidate-limit N` (or `--limit N`) to bound locator or transporter
enumeration and `--compact` (or `-c`) for one-line JSON. Budget exhaustion is an
error, never a partial mathematical verdict. See [the CLI guide](docs/cli.md)
for outputs, exit behavior, and certificate pipelines.

## Request format

A prime-field request is versioned JSON:

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

Extension fields use the same base-`p` polynomial-basis encoding and provide an
explicit monic irreducible modulus. The executable validates the characteristic,
modulus, field elements, code parameters, and projective syndrome before any
search begins.

## What the certificates establish

A locator certificate records a completely split projective locator, its
distinct support, and nonzero magnitudes. The verifier reconstructs the syndrome
from that error pattern. It is an independently checkable witness of the stated
distance upper bound; increasing-degree search supplies minimality.

A positive deep certificate records the normalized syndrome, semilinear
transporter, recognized structural family or frozen orbit, theorem-domain row,
and covering-radius source. The verifier recomputes each link. No positive
certificate is emitted for `UNRESOLVED` or `UNSUPPORTED`.

This separation is the central design rule:

```text
request -> exact arithmetic -> canonical form or nearest error
                                  |
                                  v
                         frozen theorem lookup
                                  |
                                  v
                    replayable positive certificate
```

## Mathematical and algorithmic scope

The implementation includes:

- exact polynomial-basis arithmetic over prime and extension fields;
- projective normalization, affine and infinity locator charts, distinct-root
  recovery, and Vandermonde magnitude recovery;
- increasing-degree Hankel-kernel search with streamed locator candidates;
- exact semilinear canonicalization under `PGL(2,q) x Gal(F_q/F_p)`;
- reduced tangent, rootless, simple-root, multiple-root, and pure-power charts,
  with full group enumeration retained as a reference oracle;
- the proved R5--R7 terminal-hyperplane selector and defensive exact fallback;
- intrinsic persistent and fixed-family adapters plus frozen R5--R7 exceptional
  orbit data; and
- independent replay of both nearest-error and positive deep certificates.

The reduced canonicalization charts retain at most `O(m*r*q^2)` transports for
`q=p^m`; one transport costs `O(r^2 + r log q)` field operations. The explicit
`m(q^3-q)` action remains an independent oracle. Locator candidates are streamed,
so `--candidate-limit` bounds search work rather than a stored candidate list.
The exact accounting is in [docs/complexity.md](docs/complexity.md), and the
R5--R7 selector is described in
[docs/terminal-hyperplane-solver.md](docs/terminal-hyperplane-solver.md).

## Trust boundary

Two versioned data files ship with the executable:

- `data/theorem-domain-v1.json` is the fail-closed registry consulted before a
  positive deep verdict;
- `data/frozen-orbits-v1.json` records the audited finite exceptional orbits.

Changing either mathematical domain is a release-level theorem change, not a
routine implementation edit. Generic canonicalization or exact decoding beyond
R10 does not imply a generic higher-redundancy deep-hole classification. The
[theorem-boundary table](docs/theorem-boundary.md) states the exact distinction.

## Reproduce and inspect

The fast development gate is:

```text
cargo fmt --all -- --check
cargo clippy --locked --all-targets -- -D warnings
cargo test --locked
```

The unit, compiled-CLI, property, and exhaustive layers are described in
[docs/testing.md](docs/testing.md). Reproducible timing and operation-count
records are covered by [docs/benchmarks.md](docs/benchmarks.md).

Further reference:

- [CLI and JSON workflow](docs/cli.md)
- [certificate schemas](docs/certificate-schemas.md)
- [theorem boundary](docs/theorem-boundary.md)
- [canonicalization complexity](docs/complexity.md)
- [benchmark protocol](docs/benchmarks.md)
- [testing layers](docs/testing.md)

## Citation and license

Citation metadata is in `CITATION.cff`. The software is licensed under the MIT
License. The surrounding paper and its non-software material are licensed
separately under CC BY 4.0.
