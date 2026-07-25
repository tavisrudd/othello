# Verification map

The stable paper-facing names are `Certificate R5`, `Certificate R6`,
`Certificate R6-NF`, `Certificate R7`, and `Certificate SC`. Their schemas are
defined in `supplement/CERTIFICATE-SCHEMA.md`. Internal development identifiers
below record provenance only.

Artifact paths below are relative to `notes/`. Commands run from the repository
root. The manuscript proves its mathematical claims; these artifacts certify
only the finite or symbolic domains stated here.

| Claim group | Generator | Certificate | Independent replay | Checksum |
|---|---|---|---|---|
| C491 redundancy-five census | `2026-07-22-c491-prs-deep-hole-census.py` | `2026-07-22-c491-prs-deep-hole-census.json` | `2026-07-22-c491-prs-deep-hole-replay.py` | `2026-07-22-c491-prs-redundancy-five.sha256` |
| C498 redundancy-six census | `2026-07-22-c498-prs-deep-hole-census.rs` | `2026-07-22-c498-prs-deep-hole-census.json` | `2026-07-22-c498-prs-deep-hole-replay.py` | `2026-07-22-c498-prs-redundancy-six.sha256` |
| C498 small semilinear normal forms | `2026-07-23-c498-small-exceptional-normal-forms.py` | `2026-07-23-c498-small-exceptional-normal-forms.json` | the generator is also the deterministic checker; no second implementation is claimed | `2026-07-23-c498-small-exceptional-normal-forms.sha256` |
| C509 redundancy-seven calibration | `2026-07-23-c509-prs-deep-hole-calibration.py` | `2026-07-23-c509-prs-deep-hole-calibration.json` | `2026-07-23-c509-prs-deep-hole-calibration-replay.py` | `2026-07-23-c509-prs-redundancy-seven.sha256` |
| C595/C597 stable components | `2026-07-24-c595-stable-component-fano-elimination.py`; `2026-07-24-c597-r10-integral-bad-scheme-sc11.py`; `RelativeConicArcs.PRSStableComponents` | corresponding JSON records | both generators are dependency-free identity/factorization checkers; corresponding Singular scripts check saturation and vertical primary decompositions; Lean independently checks the Plücker factorizations, coherent-Fano identities, modular-kernel criterion, and binary block-coverage termination | corresponding SHA-256 manifests and `RelativeConicArcs.Gates.PRSStableComponentsAxiomAudit` |

## Trusted boundaries

- C491 uses two independent exhaustive algorithms on
  `q={7,8,9,11,13,16,17,19,23,25,27,29,31,32,37,41,43,47,49}` and stops
  after every point of each `PG(4,q)` has been classified. The theorem, not the
  census, supplies the continuation above `49`.
- C498 searches exactly
  `q={7,8,9,11,13,16,17,19,23,25,27}`. The Rust stop condition is
  elementwise equality of the definition and Hankel scans over all of
  `PG(5,q)`. Its independent replay reconstructs the definition scan through
  `q=16`; the higher listed fields retain the explicitly documented
  implementation boundary. The normal-form checker is limited to
  `q={7,8,9,11,13}`.
- C509 calibrates exactly
  `q={7,8,9,11,13,16,17,19,23,25,27,29,31,32}` and stops after every
  pointed-bad affine orbit and all of its extensions have been tested. Its
  replay uses five-point spans rather than the pointed-contraction criterion.
  At `q=7,8,9` this certifies split-freeness, not covering radius.
- Certificate SC checks the stated integral identities, eliminations,
  saturations, and finite bottom-component ledger. It does not turn the
  manuscript's density and projective-transport arguments into executable
  claims.

## Exact replay commands

From the repository root:

```text
python3 notes/2026-07-22-c491-prs-deep-hole-census.py
python3 notes/2026-07-22-c491-prs-deep-hole-replay.py
rustc -O notes/2026-07-22-c498-prs-deep-hole-census.rs -o /tmp/c498-census
C498_JSON_OUT=/tmp/c498-census.json /tmp/c498-census
cmp /tmp/c498-census.json notes/2026-07-22-c498-prs-deep-hole-census.json
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py
python3 notes/2026-07-23-c498-small-exceptional-normal-forms.py --summary
python3 notes/2026-07-23-c509-prs-deep-hole-calibration.py --jobs 3 \
  --output notes/2026-07-23-c509-prs-deep-hole-calibration.json --check
python3 notes/2026-07-23-c509-prs-deep-hole-calibration-replay.py
python3 notes/2026-07-24-c595-stable-component-fano-elimination.py --check
python3 notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.py --check
```

The C491 and C498 manifests contain disclosed stale hashes only for living
development reports; the load-bearing generator, data, and replay entries are
unchanged. The paper-local evidence bundle is the public route and is checked
by `supplement/verify.py`.

## Lean boundary

- aggregate import closure:
  `RelativeConicArcs.Gates.PRSBeyondRedundancyFour`;
- aggregate tracked audit:
  `RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`;
- declaration-level manuscript reconciliation:
  `supplement/LEAN-STATEMENTS.md`.

The aggregate imports exactly the shared foundation, redundancy-five,
polar-induction and redundancy-six/seven, and stable-component gates. Its audit
covers the adopted algebraic, contraction, arithmetic, finite-table, and
conditional synthesis terminals. It reports no project-specific axiom or
opaque computational oracle; only `propext`, `Classical.choice`, and
`Quot.sound` occur. The R5--R7 transcription modules name
`supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`.
