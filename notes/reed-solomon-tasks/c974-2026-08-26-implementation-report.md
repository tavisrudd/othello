# C974 implementation report — simultaneous and pointed locators

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** implementation
and bounded research probe PASS

## Result

The Projective Reed--Solomon Toolkit now has an arbitrary-redundancy
simultaneous-marker locator.  At redundancy `r>=6` it enumerates distinct
degree-`r-5` marker supports, contracts directly to a redundancy-five cubic
pencil, enumerates that complete projective pencil, and lifts any split cubic
avoiding the markers to a split squarefree degree-`r-2` locator.

Every returned locator is converted to the existing
`projective-reed-solomon-locator-certificate-v1` schema and replayed by the
pre-existing verifier.  The pointed API and CLI flags require the locator to
avoid any prescribed finite projective roots and/or infinity.

## Software integration

- New library entry points:
  `search_simultaneous_marker_locator` and
  `search_pointed_simultaneous_marker_locator`.
- New CLI command: `simultaneous-locator`, with repeatable `--forbid-root` and
  `--forbid-infinity` options.
- `distance` and `decode` search all lower degrees first, then use the new
  degree-`r-2` route before the full-support fallback.  Minimality therefore
  remains a property of increasing-degree execution.
- `classify` accepts every structural input with `r>=5`, `q>=r`.  It may emit
  a verified `NOT_DEEP` result beyond R10, or recognize a family and return
  `UNSUPPORTED`.  It cannot emit a new higher-redundancy `DEEP` result because
  the positive theorem registry remains unchanged.
- Candidate-limit exhaustion and absence of a pointed witness are errors, not
  positive certificates.

Commits `deb136305`, `0c11aa5cf`, and `f26d751b8` contain the implementation,
typed pointed-result envelope, tests, and public documentation.

## Complexity boundary

The implemented exact route examines at most

\[
       \binom{q+1}{r-5}(q+1)
\]

generic marker/pencil candidates, subject to the global fail-closed limit.
This removes three support variables relative to direct degree-`r-2` support
enumeration and is effective at fixed redundancy.  It is not C973's symbolic
`O((r-5)q)` selector extraction and no polynomial-in-`r` claim is made.

## Validation

From `papers/beyond4_prs/software/projective-reed-solomon/`:

```text
cargo fmt --check
cargo test --locked
cargo clippy --locked --all-targets -- -D warnings
cargo build --release --locked
```

The full suite passes with 36 focused library tests, eight compiled-CLI tests,
five fixed-seed property tests, and doc tests; five ignored exhaustive gates
were not run.  Focused tests cover R11 locator replay, higher-redundancy
fail-closed classification, pointed infinity avoidance, CLI replay, and the
old R5--R10 behavior.

## Bounded pointed R11 probe

The deterministic probe tests two dense representatives in each exact maximal
R11 Lucas carrier and every possible forbidden projective root:

| Field | Carrier coordinates | Probes | Witnesses | Maximum candidates |
|---|---|---:|---:|---:|
| `GF(16)` | `e_3,...,e_7` | 34 | 34 | 462 |
| `GF(27)` | `e_2,...,e_8` | 56 | 56 | 61 |
| `GF(49)` | `e_4,e_5,e_6` | 100 | 100 | 11,665 |

Every one of the 190 returned certificates was replayed through the public
`verify` command.  The typed CLI result returns its `Vec<Root>` forbidden set
beside the certificate, and the probe compares those server-serialized roots
directly against the returned support.  The candidate limit was 100,000.

From the repository root, after the release build:

```text
python3 notes/reed-solomon-tasks/c974-pointed-r11-probe.py \
  --representatives 2 --candidate-limit 100000 --check
(cd notes/reed-solomon-tasks && sha256sum -c c974-pointed-r11-probe.sha256)
```

Inputs are fixed polynomial-basis models:

- `GF(16)=F_2[x]/(x^4+x+1)`;
- `GF(27)=F_3[x]/(x^3+2x+1)`;
- `GF(49)=F_7[x]/(x^2+1)`.

The generator is 6,801 bytes with SHA-256
`5834bb622b548466fb5f4ae907649c7741003dda5e34ca2a955bf706e6f7e061`.
The canonical 155,920-byte JSON is SHA-256
`c129685797e52e7175f4468f94fab611e92f0b606afc7e7700f3fe06cfb93f27`.

## Trust and theorem boundary

The JSON is a bounded falsification/calibration artifact.  It proves only the
190 displayed existence statements.  It does not prove pointed abundance for
every carrier syndrome, close any whole field, or justify interpolation from
three fields.  The independent replay checks the locator/support/magnitude
identity without trusting the search, but it is the verifier from the same
software package rather than a second field-arithmetic implementation.

The strikingly small candidate counts suggest that the next proof should
study the first-marker terminal pencils and their support patterns, rather
than increase the finite sample.  C973 owns that theorem extraction.

## Extra-juice and Tao closeout

The cheap extra value is an exact decision boundary absent from the original
design note: if the unpointed marker/pencil enumeration finishes, its
`NoLocator(r-2)` conclusion is exhaustive, because every squarefree
degree-`r-2` support has an `(r-5)+3` partition.  The pointed version has the
same exact conclusion inside the open of supports avoiding the prescribed
roots.  Candidate-limit exhaustion remains logically separate.

The Tao question is why the dense representatives succeed so early despite
the conservative C973 thresholds.  The records show this is not merely one
lucky forbidden root: the same syndrome admits witnesses avoiding every point
of `P^1(F_q)`.  The next high-EV invariant is therefore the minimum number of
distinct split locators, or at least the union of their supports, on one
coherent carrier construction.  A support-union equal to all of `P^1` is
weaker than pointed abundance; the correct condition is that the intersection
of all witness supports is empty.  C973 should prove this structurally rather
than extrapolate the finite table.

## Mystery ledger

| Feature | Status | Exact next gate |
|---|---|---|
| Arbitrary-`r` negative witness path | implemented and certified | Symbolic selector optimization only if benchmarks justify its added representation cost. |
| Higher-`r` positive classification | deliberately disabled | Independent C973 seam acceptance plus a parameterized theorem-registry/verifier version. |
| All 190 pointed R11 probes succeed | bounded evidence only | Extract a uniform first-marker or orbit-invariant argument in C973. |
| GF(49) costs exceed GF(16)/GF(27) | unexplained but bounded | Inspect marker-prefix and terminal-pencil distributions by characteristic. |
| Whole GF(16) carrier census | not run | Requires an explicit exhaustive-evidence decision; the two dense representatives are not a substitute. |

No incidental result lies outside the requested C973/software bridge, so no
discovery-track entry is added.
