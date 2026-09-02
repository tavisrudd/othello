# ergodis Python reference layer

The production solver and public CLI are the Rust crate one directory above.
This directory contains transparent reference algorithms, differential-oracle
fixtures, benchmark controls, and evidence generators used to audit ergodis.
It is intentionally secondary to the Rust interface.

The `ergodis` package is the typed Python 3.14+ API for exact Rust primitives.
It owns one persistent `ergodis-rpc` worker, while domain objects hide the
transport:

```python
from ergodis import CharacterSumQuery, Client, Polynomial

with Client() as client:
    chi = client.GF(5).quadratic_character
    batch = chi.sum_many([
        CharacterSumQuery("S", Polynomial([36, -108, 213, -246, 213, -108, 36])),
        CharacterSumQuery("S2", Polynomial([36, -108, 105, -36]), twist=(1, -4)),
    ])
    assert (batch["S"].value, batch["S2"].value) == (2, 3)
```

`Polynomial.from_sympy()` accepts a SymPy polynomial without making SymPy a
runtime dependency. `Client.call()` is the generic typed escape hatch for a
newly registered RPC method; framing, process lifetime, large-integer encoding,
errors, and locking stay shared.

`ergodis_client.py` is the exception: it is the dependency-free reference
binding for the optional, versioned local control protocol.  It sends bounded
framed requests and streams run-relative evidence without buffering complete
files.  See `../CONTROL_PROTOCOL.md`.

Its Python 3.14+ proposer API uses frozen slotted dataclasses, `StrEnum` roles
and failure classes, keyword-only resource envelopes, and native `asyncio` Unix
socket I/O:

```python
from ergodis_client import ProposalRole, ProposalSessionOffer, Session

campaign = Session.from_run_dir("run")
proposer = await campaign.open_proposal_session_async(
    ProposalSessionOffer(roles=frozenset({ProposalRole.HEURISTIC}))
)
ticket = await proposer.submit_async(
    request_id=1,
    payload_blake3=payload_digest,
    payload=payload_stream,
    proposer_id=3,
    role=ProposalRole.HEURISTIC,
    cost_units=20,
    maximum_return_bytes=4096,
)
state = await ticket.status_async()
```

Equivalent synchronous methods omit the `_async` suffix. Ticket objects expose
status, claim, typed failure reporting, streamed completion, cancellation, and
retained result artifacts; exact retries continue to use the original
server-side resource envelope. `ticket.complete(attempt, binary_stream)` writes
fixed-size chunks to the daemon-issued create-only upload path before sending
the compact completion control message. The async form moves only that file I/O
to a helper thread; it never materializes the result in a socket frame or one
in-memory byte string.

`ergodis_provider.ProviderRunner` is the provider-neutral async execution
boundary. A backend implements one `async` attempt returning a binary stream;
the runner claims the ticket, enforces its absolute execution deadline,
reports typed failures and provider `Retry-After`, sleeps exactly until a
daemon-recorded retry time, and streams successful output through the ticket.
It never polls and does not implement a second retry policy. Provider SDK
adapters remain small translations into this callback and are responsible for
reaping any SDK work that ignores cancellation.

`ergodis_command_provider.CommandProvider` is the first concrete translation.
It executes an argv vector without a shell, streams one bounded private request
file to stdin, pumps stdout to a disk-backed anonymous file under a private
run-owned work directory, caps stderr, and maps configured temporary exit codes
to typed transient failures. Timeout cancellation kills and reaps the entire
child process group. This supports local LLMs, hosted-provider CLI wrappers,
SAT/MIP tools, and research scripts without adding any provider dependency to
Ergodis.

Submission input uses the same bounded artifact boundary as output. The session
returns a private run-relative request-upload directory and a nonempty tuple of
frozen `ProposalRequestSchema` descriptors. If exactly one schema is offered it
is selected automatically; otherwise `submit(..., request_schema=schema)` is
required. A descriptor's content-derived identity binds its logical name,
version, encoding, byte cap, role mask, and optional sorted provider allowlist.
The Python client rejects an unoffered or incompatible schema before creating a
file. `ProviderInvocation.request_schema` gives adapters the exact descriptor
validated by the daemon; SDK adapters should dispatch on its identity or
encoding rather than guessing from bytes.

The session
`submit(..., payload=binary_stream, payload_blake3=...)` streams there in fixed
chunks and sends only the declared digest and measured byte count. The daemon
re-hashes and publishes a read-only request artifact, binds both fields into the
durable ticket together with the schema identity, and returns its verified path
and descriptor on claim. `ProviderRunner` passes that confined path to the
backend invocation, so `CommandProvider` needs no out-of-band request filename.

The `recovery_algorithms` package implements direct finite-field and
combinatorial formulations. Its simple representations make it useful for
independent checking on bounded instances; they are not the high-performance
execution path.

## Run the reference tests

From the ergodis root:

```text
nix shell nixpkgs#python3 --command python3 python/test_algorithms.py
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
```

`generate_fixtures.py` compares the reference algorithms with the canonical
Rust fixture in `tests/fixtures/python_span_cases.json`. The corpus includes
small-field exhaustive checks, labelled composition, exact confinement, GF(4)
transfer witnesses, orbit search, and capacitated scheduling.

## Evidence and controls

- `generate_evidence.py` regenerates or checks the exact mathematical evidence
  bundle and `SHA256SUMS`.
- `run_benchmarks.py` runs the interleaved Rust/control protocols documented in
  `../BENCHMARKS.md`.
- `benchmark_python.py` contains the CP-SAT, HiGHS, CryptoMiniSat,
  Graphillion, max-flow, and direct-reference controls.
- `verify_baseline_encodings.py` checks that the formulation-specific controls
  encode the same bounded application examples.
- `gf27_defect_cpsat.py` is the conditioned GF(27) comparison model.
- `generate_bb_native.py` constructs published bivariate-bicycle codes directly
  from their two torus polynomials, checks commutation and ranks, derives a
  quotient-observation basis, and emits a sparse native input without a matrix
  download. `export_bb_native.py` also exposes the BB360 and BB756 controls to
  the independent `bposd` construction.

For normal use, installation, commands, JSON examples, and output semantics,
start with `../README.md`.
