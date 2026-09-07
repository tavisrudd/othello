# C1079 — Ergodis WASM capability audit

**Lane:** `ergodis`
**Date:** 2026-09-06
**Scope:** read-only recovery and static audit of the historical browser prototype,
the current core, and the current private workspace. This is a current-capability
memo for the C1079 synthesis, not an implementation or migration proposal.

## Provenance and inspected boundary

The prototype is recoverable, but was not carried into either post-split
checkout. Its authoritative retained source is the read-only worktree
`/home/tavis/src/othello-worktrees/c1032-ergodis-wasm`, branch
`codex/c1032-ergodis-wasm`, revision
`d5a39e5f43e29ca8965dd45dc174b92265fccb65`. Its implementation commits are
`83699c6bc` and `08d372b78`; source is under
`papers/complete-repair-ports/ergodis/wasm/`. `ergodis-split-base`
(`aa49d68c38cc1fdafd3bbd727fec97a92fca0b6e`) deletes all twelve tracked
prototype files. Thus current `~/src/ergodis` and `~/src/ergodis-private` do
not contain a buildable WASM adapter, even though the C1033 notebook comment
still refers to its request/response discipline.

Current-core evidence is `~/src/ergodis` at
`6cc96680c0c3251d094afb9b7b09bf6d1cfc8ce4`; private evidence is
`~/src/ergodis-private` at `74b7ca9243b143edeb5af58f69f1a55cc7f4a710`.
Inspected sources were deliberately bounded to the historical prototype's
`Cargo.toml`, `README.md`, `src/lib.rs`, `www/main.js`, `www/worker.js`, smoke
and Python-parity scripts and fixture; current core `Cargo.toml`, `src/lib.rs`,
`src/bin/ergodis.rs`, `src/control/{mod.rs,vm.rs,evolution.rs}`, the
parallel call sites in `composition.rs`, `scheduler.rs`, `balanced.rs`, and
`root_execution.rs`; and private `Cargo.toml`, `src/`, `tasks/`, `docs/`, and
`python/ergodis_notebook/solve.py` only for WASM/extension references.
No current-core, private, or filtered-public source hit a WASM binding,
WebAssembly dependency, dynamic-loader dependency, shared-library ABI, or
runtime-loadable industry-module registration mechanism. This is a bounded negative result, not a
claim about uninspected repositories, artifacts, or external deployment code.

## Current capability matrix

| Area | Compiled/exposed/tested evidence | What the evidence does **not** establish |
|---|---|---|
| Browser host | **Historical implementation and test.** `wasm/Cargo.toml:11-20` is a `cdylib`/`rlib` with `wasm-bindgen`; `wasm/src/lib.rs:90-94` exports one function, `solveCompositionJson`. `www/worker.js:1-14` initializes it in a dedicated module Web Worker. The report at `notes/2026-08-31-c1032-ergodis-browser-wasm-prototype.md` in `d5a39e5f4`, lines 42-54, records a successful `wasm32-unknown-unknown` check, `wasm-pack --target web --release`, eight-case Python parity, and headless Chromium smoke. | No current checkout packages this adapter; this audit did not rebuild the historical worktree. Firefox, Safari, and any standalone WASM runtime were not tested by C1032. |
| Solver / exact result | **Historical implementation and test, narrow.** `wasm/src/lib.rs:29-79` compiles and queries `CompositionTable` from `CostTable`, accepts only GF(2), and returns reachability, exact cost, local labels, and transitions. Inputs are bounded at 4,096 matrix entries, 4,096 inner entries, 256 blocks, and 1 MiB JSON (`:7-10`, `:31-58`). The bundled fixture has eight cost/witness/work cases; the historical report records independent Python replay and Rust adapter tests. | It exposes no general current-core API, no arbitrary field, no solver command schema, and no current-revision parity evidence. It is evidence that a sequential library slice ran in a browser, not evidence that all current core APIs do. |
| Default-core reachability | **Static evidence, current and historical.** Both the historical root and current `Cargo.toml:15-19` declare `default = []`; the historical adapter depended on the default core. C1032 therefore demonstrated that this selected sequential composition slice can avoid optional native control and Rayon dependencies. | It does not prove that every module now reachable through the current default crate compiles for `wasm32`, nor that the removed wrapper still matches changed APIs. A new target check is required for either assertion. |
| Parallelism / threads | **Deliberately absent from the historical adapter.** `parallel = ["dep:libc", "dep:rayon"]` (`Cargo.toml:17`) gates Rayon call sites, e.g. `composition.rs:8,1033` and `root_execution.rs:68-71`. C1032 explicitly says the slice is single-threaded and makes no Rayon claim. | Browser threads, SharedArrayBuffer/cross-origin isolation, worker-pool lifecycle, memory sharing, and parallel performance are unsupported by inspected implementation—not merely untested. The static core layout does not show a browser-thread path. |
| Unix control / evolve / socket steering | **Current native implementation only.** `src/lib.rs:31` gates `control` behind `control-plane`; the feature enables `libc` (`Cargo.toml:19`). `src/control/mod.rs:8-18,388-419` imports Unix filesystem and `Unix{Datagram,Listener,Stream}`, creates/permissions a socket, uses threads and persistent files. `evolution.rs:2018-2020` calls Linux `setpriority`. | None is linked by the historical adapter, and no browser or standalone-WASM host binding, transport substitution, persistence layer, or browser test was found. It cannot be called WASM-supported from this evidence. |
| Typed source / VM / IR | **Current native, feature-gated machinery.** `src/control/vm.rs:341-500` lowers a typed expression document to bounded `PlanSpec` bytecode; `:941+` provides `CompiledPlan` evaluation. This is a candidate source-to-plan compiler, not merely a proposal. | The VM reads JSONL through `std::fs::File` (`:1-10,55-65`), belongs to the control feature, is neither exported through `wasm-bindgen` nor exercised by the old adapter. No WASM source-to-IR compilation, IR package loader, target/compiler identity binding, or parity test exists in inspected code. |
| Theorem/parameter / quotient autonomy | **Not exposed in WASM.** Current core has the general modules, but the browser function calls only labelled composition. The existing C1079 inventories establish that evolve is non-proof-authoritative and disconnected from theorem admission. | No browser theorem candidate, parameter lineage, quotient construction, validation, solver admission, archive, or control observation path was located. No conclusion is drawn about uninspected research code. |
| Native specialized kernels / industry modules | **No implementation located.** Current manifests have no `libloading`, `cdylib`, `staticlib`, or plugin dependency; bounded source searches found no `dlopen`, plugin, extension registration, or module ABI. | Neither `.so` loading nor a WASM-compatible kernel/module artifact exists in inspected sources. Native extension loading and IR-to-native-kernel calls are proposed C1079 work, not prototype capability. |
| Private QEC / industry knowledge | **Core QEC-facing algorithms and private QEC adapters are distinct.** The current core exports QEC-facing algorithms such as `QcLdpcCode` (`src/lib.rs:93-103`); the private checkout contains task/domain adapters. The bounded private source search found no WASM adapter or industry-package boundary. | There is no inspected QEC WASM payload, QEC extension contract, package identity/provenance binding, or carve-out-ready build/test/deployment boundary. Repository placement is not an ownership conclusion. |
| Packaging and black-box demos | **Historical developer demo only.** `wasm/README.md:7-31` specifies local `wasm-pack`, HTTP serving, Python oracle, and Chromium smoke; generated `www/pkg` is ignored. | No recipient distributable, opaque native module, opaque IR payload, compatibility manifest, hosted service, disclosure review, socket redaction, cache/log policy, or black-box demo was found. A compiled WASM payload and JavaScript glue are recipient-inspectable; C1032 makes no obfuscation claim. |

## Why the feature split matters

`default = []` is the material reason the historical thin wrapper could reach
the sequential core without compiling the two native-oriented optional surfaces:
`parallel` pulls in both Rayon and libc, while `control-plane` pulls in libc.
That is positive reachability evidence for the particular default dependency
closure used by C1032, not a blanket statement that Ergodis is or is not WASM
portable. The core also contains target-guarded fallbacks—e.g.
`src/bp_osd.rs:17-44` uses scalar `min`/`max` off x86_64 and
`css_distance_native.rs:421-434` selects portable kernels where its x86 probes
do not apply. Those are useful portability signals, but they are not a current
WASM build result.

Conversely, browser incompatibility for the inspected control plane is
source-established: it directly requires Unix sockets, Unix permission APIs,
host filesystem paths, threads, and Linux priority control. The old adapter
does not avoid this by emulation; it never enables or imports that module.
Whether a standalone WASI/Wasmtime host could supply a distinct subset is **not
inspected**, hence not classified as unsupported.

## Validation performed and limits

Static recovery verified the historical branch/worktree identity, source tree,
implementation commits, split deletion, current revisions, feature graph,
binding/export shape, and bounded reference searches. The historical C1032
report is the source for its recorded successful builds and tests; no build,
benchmark, browser run, package generation, or external documentation lookup
was performed in this audit. Consequently, “tested” in the matrix always means
the recorded C1032 validation at `d5a39e5f4` (report lines 42-54), while
“current” means inspected
source at the revisions above. No external toolchain/version claim is made.

## Prioritized integration questions for C1079

1. **Restore versus replace the adapter:** choose and validate a maintained
   current-core target wrapper before treating the prototype as an extension
   host. Its sole old function is insufficient to carry the requested logical
   industry package contract.
2. **Set host capability profiles:** separately decide the browser, any
   standalone WASM host, and native profiles for filesystem, persistence,
   transport, worker/thread, memory, and resource-budget semantics. Do not
   represent Unix-socket evolve as browser support.
3. **Specify portable package identity before loaders:** bind package/source or
   IR digest, core/compiler/IR version, target artifact, native-kernel version,
   validation scope, and disclosure policy; no current format binds these.
4. **Choose the browser-safe source/IR path:** reuse the bounded `PlanDocument`
   lowering only after separating it from filesystem campaign input and after
   establishing source/IR validation and replay. Successful lowering must not
   authorize a theorem or a solver reduction.
5. **Define the native/WASM kernel seam and parity gate:** no inspected browser
   adapter or current package loader loads a native `.so`; decide the required
   WASM variant or host binding, and test semantic parity, error/resource
   behavior, and provenance across representative
   industry capabilities, beginning with QEC.
6. **Package disclosure deliberately:** the present browser demo ships readable
   JavaScript and a reverse-engineerable WASM binary and has no demo manifest or
   redaction boundary. A shippable black-box demo needs explicit inspection,
   diagnostics, logs, cache, proof/replay, and socket-observation policies;
   hosted access needs an independently specified execution and data boundary.
