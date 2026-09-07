# C1107 — Portable repository ownership and recovery contract

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core commit `75b646b`.

## Result

Core `crates/runtime/src/repository.rs` defines `RunRepository` and a bounded
volatile `MemoryRepository`; `docs/run-repository.md` is its normative contract.
Immutable bundle upload is separate from selecting a current head. Published
heads require complete declared record/specification/content/parent closure.
Staging can contain orphan content or competing candidates without creating an
authoritative head. All loops and metadata work are cold; no solver/update
kernel or native64 layout changes.

Commands atomically register runs, acquire/fence attempts, reserve work, advance
heads and record work observations, or append versioned metadata/notes. Run-ID
collisions and reused attempt IDs reject. Head updates require both expected
revision/head and a repository/run/attempt/fence-bound lease. Explicit takeover
interrupts the previous attempt; it neither proves the old worker stopped nor
returns any budget. Compatible restart keeps the run/specification and accounting.
Changed semantics needs a fork or an independently admitted migration.

Exact successful requests retain their effects and receipt atomically. Same-ID
retries return the historical receipt without mutation; changed-command retries
reject. A replayed receipt never renews a superseded lease. A failed command
leaves no success receipt or partial mutation. Reservations debit before launch,
retain full logical/physical authorization through interruption or finish, and
are never automatically refunded. Physical observations are monotone, bounded
by authorization and only lower bounds after interruption. Replay/reconstruction
can reserve physical work without a new logical charge; the scheduler remains
responsible for correctly classifying/enforcing those work units.

The reference implementation and all its acknowledgements explicitly identify
their persistence as Volatile. The contract allows RestartPersistent only for
an adapter whose acknowledged state survives process restart; power-loss,
quota/eviction and host-failure guarantees need separate adapter evidence.

## C1033 connection requested during this task

Read the complete dated spike report
`2026-09-01-c1033-ergodis-jupyter-sage-duckdb.md`, then inspected current private
`analysis/ergodis_catalog.sql:182` and `python/ergodis_notebook/campaign.py`.
The SQL macros read the live `ledger.jsonl` and `manifest.json`; the notebook
tracks incremental ledger offsets and uses the legacy epoch-CAS steering path.
The report's old complete-ports stamp is historical; the exact live C1033 queue
row routes it to ergodis. No private C1033 source or task status was changed.

This informed a coherent catalog snapshot at a single committed repository
revision, containing run heads, attempt histories and accounting. System
metadata and user notes are independently opt-in. A detached snapshot stays
stable when later commands commit. This gives a future SQL/notebook adapter a
safe join boundary rather than combining unrelated live reads. Derived catalogs
remain rebuildable readers; no SQL row, notebook output, cached statistic or
flushed ledger line supplies writer authority or a mathematical admission.
The public contract records this general boundary without naming private code.

No DuckDB/Jupyter integration was rerun or migrated here, and no database was
selected as the persistence backend. C1033's earlier measurements and notebook
observations remain its own evidence, not new claims from this task. Its
manifest/ledger read surface should inform the next native/catalog bridge.

## Validation and limits

`crates/runtime/tests/repository_contract.rs` contains ten deterministic tests:
partial staging and retry; duplicate IDs/request conflicts; both orders of
activation/head races; stale writer rejection; interrupted reservations and
physical replay accounting; failed commit atomicity; incompatible restart and
attempt reuse; append-only sidecar CAS and identity independence; foreign
repository fences; coherent catalog snapshots and opt-in disclosure; monotone
physical observations; and explicit volatile acknowledgement checks. Related
properties share test cases. The publication contract is written over the
repository trait for reuse by future adapters.

Initial seven tests passed; the catalog additions passed nine tests plus
targeted all-feature clippy. Full native fmt/clippy/tests and WASM release
compilation passed before the closeout persistence field was added. Final full
native fmt, all-target/all-feature clippy, all-feature tests (including all ten
repository tests) and release WASM compilation pass after that addition.
Python parity passes all eight exact
cost/witness/work cases. No browser API or generated browser package changed.

The pilot admits 4096 accounting slots and 64 MiB content/text bytes, with
existing bundle limits and 4096/128-byte sidecar text/author limits. Fixed
container overhead is also bounded by the slot cap. It supplies bounded owned
reads and no clock, random generator, filesystem, shared-memory or database
dependency. Finite closure checks are iterative. Unknown sidecar schemas are
preserved as opaque data, never treated as solver configuration.

Native and browser adapters must demonstrate transaction atomicity, cross-owner
fencing, acknowledged-state recovery, acknowledgement loss, incomplete writes,
quota/eviction behavior and consistent read snapshots on their actual storage.
The in-memory model cannot establish those platform guarantees. Execution
recovery, terminal campaign completion, persistent event feeds, larger-store
pagination and legacy-client migration remain separate work.

## Closeout and next gate

Replay from `~/src/ergodis`, wrapping noisy commands with `run-quiet`:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && RAYON_NUM_THREADS=12 cargo test --all-features && cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release'
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
```

Final run-quiet capture: `/tmp/claude-run-quiet/20260907-141819-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-nixpkgsrustfmt-command-bash-c-c`.
Targeted runs: prefixes `20260907-141119` and `20260907-141431`; Python `20260907-141727`.
No browser execution gate was rerun: this slice changes no browser API, client or
package; the new runtime module passes release WASM compilation. No export/push.
Cache audit passed in dry-run mode at `20260907-142136`; nothing deleted.

No incidental mathematical discovery or research mystery. The cheap closeout
upgrade makes actual volatility explicit in each acknowledgement/read snapshot.
The next gate is allocation and backend selection for the first persistent
adapter, keeping the C1033 analytical read layer as a downstream consumer. No
concrete successor ID is allocated by this contract task. Native filesystem and
browser IndexedDB adapters and actual execution recovery are not claimed here.

Operational correction: the initial combined C1084 architecture read exceeded
the 10,000-token producer limit. It was replaced with bounded, relevant storage,
lineage, metadata and ownership sections. No broad read was repeated or used as
a task deliverable.
