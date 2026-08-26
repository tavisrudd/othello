# Command-line and JSON workflow

The executable accepts one versioned JSON object and emits one versioned JSON
result. Pass a file as the final argument or omit it to read standard input.
Pretty JSON is the default; `--compact` or `-c` selects one-line output.

Global options may appear before or after the subcommand:

```text
projective-reed-solomon [OPTIONS] <COMMAND> [FILE]
```

- `--candidate-limit N`, also visible as `--limit N`, bounds locator or
  transporter candidates examined by a search;
- `--compact`, or `-c`, selects compact JSON;
- `--help` and `<COMMAND> --help` describe the available mathematical scope.

## Commands

### `canonicalize`

Returns the normalized syndrome, lexicographically least semilinear orbit
representative, and an exact transporter. It accepts every `r >= 5`, `q >= r`.
The result is structural data, not a deep-hole verdict.

```text
projective-reed-solomon canonicalize request.json
```

### `distance` and `decode`

Both commands run the same increasing-degree exact locator search and emit a
`projective-reed-solomon-locator-certificate-v1` object. Its `distance`,
`support`, and `magnitudes` fields give the decoded nearest error pattern.
`distance` emphasizes the metric answer; `decode` emphasizes the witness.

```text
projective-reed-solomon distance examples/shallow-r5-f7.json \
  > locator-certificate.json
projective-reed-solomon verify locator-certificate.json
```

### `classify`

Returns one of four statuses:

| Status | Meaning |
|---|---|
| `DEEP` | Both a split-free route and an applicable covering-radius route replay; a positive certificate is included |
| `NOT_DEEP` | A locator certificate exhibits a closer word |
| `UNRESOLVED` | The structural classification is known, but the frozen radius premise is absent |
| `UNSUPPORTED` | No enabled theorem-domain route justifies a coding verdict |

The general classification input boundary is R5--R10. The separately certified
even-field diagonal family at `r=q-1` is recognized before that general gate.
Other requests beyond R10 are rejected as outside the classification input
domain; use `canonicalize`, `distance`, or `decode` for their structural or
metric data.

The positive certificate is nested under `deep_certificate`. With `jq`, a full
classification-to-verification pipeline is:

```text
projective-reed-solomon classify examples/tangent-r5-f7.json \
  > classification.json
jq '.deep_certificate' classification.json \
  | projective-reed-solomon verify
```

### `verify`

Accepts either public certificate schema. It recomputes field arithmetic,
normalization, locator support and magnitudes or the semilinear transporter,
family evidence, and theorem-domain lookup. Success emits:

```json
{"status":"VALID"}
```

Corrupted, inapplicable, or unknown-schema certificates fail with no valid
result on standard output.

## Exit behavior

- exit status `0`: the requested computation completed; this includes
  `UNRESOLVED` and `UNSUPPORTED`, which are explicit JSON results rather than
  failures;
- exit status `2`: malformed JSON, invalid field or code parameters, an
  exhausted candidate budget, a rejected certificate, or invalid CLI syntax.

Errors are written to standard error in a human-readable form. The program does
not emit a partial JSON result after an error.

## Reproducible invocation

For archival runs, use the committed toolchain and lock, record the command and
candidate limit, and preserve both the request and output:

```text
cargo run --locked --release --bin projective-reed-solomon -- \
  --candidate-limit 10000000 classify request.json > result.json
```

The schema strings are part of the public contract. A future incompatible
request or certificate format will use a new schema identifier.
