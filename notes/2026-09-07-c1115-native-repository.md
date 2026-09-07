# C1115 — Native filesystem repository companion

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core `248b678`; documentation routing `8848e3f`.

User-approved companion to C1114: native filesystem persistence with shared portable
repository semantics. Allowed paths: core `crates/repository-native/`, workspace
`Cargo.toml`/`Cargo.lock`, `docs/run-repository.md`. Browser implementation and solver
kernels remain outside this slice. Native support is initially local Unix filesystems;
no Windows/network-filesystem or power-loss claim.

The adapter uses C1114's bounded replay image under a fresh per-operation advisory lock,
then synchronizes a temporary candidate, atomically replaces the image, and synchronizes
the directory before acknowledging. Open never recreates missing state. Exact retries
re-synchronize the image, including after an uncertain post-rename outcome. Validate
cross-process ownership and actual killed-process recovery at each publication step.

## Result

Separate `ergodis-repository-native` Unix host crate, with no dependency from portable
runtime/WASM back to it. Fresh per-operation advisory file descriptions exclude concurrent
processes and handles. Every action loads current portable state under the lock. The shared
journal owns all command admission, exact receipts, fences, budgets and metadata semantics.

Publication writes a same-directory temporary image, syncs it, atomically replaces committed
state and syncs the directory. Creation also syncs the parent directory. Only completed
publication returns RestartPersistent. Errors after replacement report an uncertain outcome;
exact request retries re-sync before acknowledging. Coherent read snapshots sync visible state,
including after a predecessor dies between rename and directory sync. Missing/corrupt images,
unsafe final paths/permissions, symlinks, hard links and oversized state reject. Orphan candidate
files are never selected as authority; the adapter never overwrites an existing repository
on create or silently reinitializes missing state.

## Validation

Five substantive native tests plus the subprocess entry test pass:
- Differential native/portable transaction trace, reopening after each action, exact receipts,
  stale writer rejection, interrupted attempts, retained reservations and bundle export.
- Two independent OS processes contend on activation: exactly one wins.
- Actual child SIGKILL at candidate creation, write completion, file synchronization,
  atomic replacement and directory synchronization. Reopening sees the complete old/new
  state as appropriate; exact retries neither duplicate receipts nor advance twice.
- Injected ENOSPC at the same stages: before-publication errors versus uncertain outcomes;
  same-ID retry resolves the outcome.
- Missing/corrupt/oversized images and unsafe final directory/file paths reject without reset.

The process tests run under `~/.cache/ergodis/repository-tests` on **ZFS**, not tmpfs.
Native full fmt, all-target/all-feature clippy and all-feature tests pass. Python parity
passes all eight exact cost/witness/work cases. Release WASM compilation passes after the
workspace addition; the browser package does not depend on the new host crate. Browser
API/UI/process-restart tests passed under C1114 and its implementation is unchanged here.

Replay from core, using run-quiet around noisy commands:
`nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt nixpkgs#python3 --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && RAYON_NUM_THREADS=12 cargo test --all-features && python3 wasm/scripts/check-python-parity.py && cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release'`.

Run-quiet captures: scoped native `20260907-144434-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsrustfmt-nixpkgsclippy-command-bash-c-c`;
full final `20260907-144515-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsrustfmt-nixpkgsclippy-nixpkgspython3-c`.
Cache audit `20260907-144547-cache-gc.sh` passed in dry-run mode; nothing deleted.
An initial test-only ambiguous Error import was qualified before retrying compilation.

## Limits and closeout

Local Unix filesystem support only. Caller-trusted parent, private directory and cooperating
clients are required; modifying lock/state paths directly or moving the live directory is
outside the protocol. No Windows/network-filesystem, multi-user authentication, hardware
power-loss, device-failure or physical disk-full claim. ENOSPC injection checks error handling.
The common 16 MiB/1024-event replay image is rewritten per mutation; no large-history or hot-path
performance claim. Runtime kernels/layouts are unchanged. No executable recovery or analytics
bridge is claimed. No incidental mathematical discovery or genuine research mystery.

C1114 and C1115 satisfy the approved initial browser/native persistence scope. Next gate:
choose and allocate the analytical projection bridge using coherent repository snapshots
(C1033 is the existing downstream reader), or an execution-recovery slice with separate gates.
No unallocated successor ID is invented. No export or push.
