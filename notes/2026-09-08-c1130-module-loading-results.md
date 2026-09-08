# C1130 — Module loading spike results

**PRIVATE — do not ship or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: bounded loading/execution experiment complete; ABI remains experimental.
C1130 full WASM completeness remains IN PROGRESS. No production migration accepted.

## Decision and next gate

Public core hosts load and execute separately compiled private LRC and QEC providers
on native and ordinary WASM without private source or rebuilding core privately.
The native recipient also accepts a compatible revised, stripped provider under
unchanged host bytes. Prefer ordinary WASM with presized coarse batch calls for the
next integration experiment. The measured component adapter costs substantially
more on small batches.

Do not freeze the ABI yet. Its native Provider is exclusive `&mut self` and is not
Send/Sync. Workspaces retain Arc plans within an instance, but parallel workers
instantiate separate providers and duplicate compiled plans. Next test a provider
factory → shareable immutable compiled plan → independently owned/bound executor
workspace, preserving library lifetime and safe release. Avoid shared solve-loop
locks and keep existing direct native call paths. This is a proposed refinement,
not an adopted production design.

Then admit labelled composition (primes/GF4, rectangular shapes) as the third family,
make CampaignSession orchestration consume the shared execution surface, wire real
recovery/QEC into the console, and perform the private glossary pass. The new module
Worker runs alongside CampaignSession; it is not runtime or console integration.
Full capability inventory and native/WASM parity remain open.

## Implementation and conformance

Core `0af66d9` adds the experimental ergodis-modules ABI/native loader and generic
browser host/Worker. Core `5542688` adds manifest negative tests and physical-Worker
generation checks. Initial private implementation: `3aafb81`; final private
source/evidence commits: `29a2fd8` and whitespace-normalization `2e90fa4`.
Contributor `9e49744`
extends retained-binary tooling to integration executables.

Core has no private family types or source dependency. Private library packages
compile original source modules through a thin shared adapter. Production kernel
bodies remain unchanged; the existing test-only allocation helper was extracted
verbatim for reuse. No new executable target or private rebuild of the canonical
core WASM engine was introduced.

The native recipient was built offline in bubblewrap with public core source,
standard dependencies and shared target cache only, then run without either source
checkout mounted. It passes 23 LRC and 20 QEC transcript operations. Actual Chromium
Worker execution passes the same transcripts plus 23 component LRC calls; the test
fetches the canonical core engine once. Gates cover repeated readouts, failed
preparation preserving the old plan, capacities, unsupported readouts, wrong-kind/
stale/cross-instance handles, busy release, reload, package ABI/schema/target/import/
digest rejection and foreign Worker generation rejection.

The full Stim d5/r5 rotated memory-Z surface-code model has 120 detectors and 502
edges, noise 0.001 at four circuit noise sites, seed 2026 and 256 shots. The last
shot is replaced by an all-detectors syndrome as a negative control. This is the
full model, not the console's six-detector projection. LRC uses HostileInstances,
seed 2026, and 256 admitted budget queries with count, threshold and mode/load
witnesses. Expected opaque answers come from existing native APIs. Transport parity
is not independent mathematical verification: QEC overflow/class availability,
LRC admission and proof authority remain distinct.

## Native costs and allocations

Retained adapter/static-C-ABI/loaded-C-ABI experiments rotate three arms over five
rounds, batches 1/16/256/4096, and one/four workers on distinct physical cores. The
initial experiment has 240 samples, longer QEC follow-up 120, and stripped
distribution experiment 240. Counters include cycles, instructions, branches,
branch misses and cache misses; GNU time records peak RSS.

Selected **loaded / typed adapter** ratios for the stripped distribution:

| Family | Batch | Workers | Instructions | Warm elapsed | Peak RSS KiB |
|---|---:|---:|---:|---:|---:|
| LRC | 1 | 1 | 1.323 | 1.278 | 2972 |
| LRC | 1 | 4 | 1.323 | 1.333 | 3824 |
| LRC | 256 | 1 | 1.007 | 0.972 | 3020 |
| LRC | 256 | 4 | 1.007 | 0.966 | 3876 |
| QEC | 1 | 1 | 1.218 | 1.209 | 4212 |
| QEC | 1 | 4 | 1.218 | 1.350 | 6244 |
| QEC | 256 | 1 | 1.003 | 0.941 | 4224 |
| QEC | 256 | 4 | 1.003 | 0.978 | 6800 |

The baseline is the typed adapter, **not an unwrapped native solver**. Batch-one
QEC repeats the first sampled syndrome, which has zero defects. Native performance
cycles the first 255 shots, excluding the dense negative control. Counters include
process setup; warm measurements use the per-worker maximum. Workers have no
all-ready barrier, so one worker's preparation can overlap another's timed loop.
These measurements diagnose boundary cost, not full native performance acceptance.
Ratios below one do not establish faster unchanged kernels. Batching amortizes
boundary overhead; one-query dynamic calls are materially more expensive.

Eight retained before/after loaded-path profiles cover both families and worker
counts. Interpret only leaf samples: optimized frame-pointer callchains were
unreliable. Representative initial QEC leaves spend about 44.7% in subset dynamic
programming, 18.5% reading the pair matrix, 15.8% cluster solving and 10.5% decode;
the invoke wrapper is about 0.3%. LRC's inlined adapter/readout dominates its profile.
No full legacy native before/after benchmark claim is made. Old and current
operator-tool binaries were retained, but this experiment measures the new boundary.

Both linked contract tests perform 1,000 repeated executions without allocation;
the original Tiger allocation test passes. Separately instrumenting actual loaded
providers records zero execution allocations across 600 LRC calls (all three
readouts) and 400 QEC calls (both readouts), including rejected execution checks.
Setup positive controls count 4 and 17,015 allocations respectively. Host allocator
counts are not evidence about loaded-library heaps. Audit instrumentation is absent
from distribution/timing builds.

## WASM phases and component comparison

The same LRC source compiles as a WIT component using wit-bindgen 0.46.0 and jco
1.32.1. Its 23-operation parity passes in Node and Chromium. This list/capacity
adapter allocates canonical buffers outside its solver. Five rotated warm rounds
give component/plain elapsed ratios 14.936, 4.550, 2.247 and 1.047 at batches
1,16,256,4096. Initial ordinary payload: 28,409 bytes; generated component JS plus
WASM: 116,348 bytes, unminified. This evaluates that adapter/toolchain, not every
possible Component Model design.

An ordinary-WASM phase probe measures 2,000 batches of 256 over five rounds.
Median total milliseconds:

| Family | Upload | Invoke | Download | Full host call | Provider-local repeat |
|---|---:|---:|---:|---:|---:|
| LRC | 0.144 | 1.938 | 0.844 | 4.256 | 1.798 |
| QEC | 0.134 | 63.249 | 2.366 | 63.454 | 60.992 |

These are separate diagnostic arms, not additive cost components. This QEC corpus
includes the dense negative control, unlike native performance. Provider linear
memory remains unchanged after preparation/runs: LRC 3,407,872 bytes and QEC
4,194,304 bytes, excluding canonical core and JS/Worker overhead. Digest, compile,
instantiate and prepare phases are recorded as single cold samples; their order
dependence prevents a comparative startup verdict.

## Distribution and compatibility

Frozen source-isolated native recipient SHA-256:
`6a2478afc63395386dbfa3ff4b67da1baced6f8b1d8bf724185320d5ab63a8f8`.
It accepted initial providers and version 0.0.1 providers with revision-2 metadata
and unchanged schemas/ABI. This tests a compatible metadata/packaging revision,
not arbitrary future algorithm/schema upgrades. package.py --keep-host checks the
unchanged recipient bytes before repackaging.

Default-feature distribution payloads are stripped with source paths remapped to
unique opaque names. Sizes: LRC native 356,872 / WASM 22,586 bytes; QEC native
619,032 / WASM 238,533 bytes. All four have zero matches for the four audited markers
/home/tavis, ergodis-private, tiger_blossom and parametric_lrc. Exact hashes are in
the committed distribution-audit.json. This is a bounded source-identifier scan,
not a secrecy guarantee against reverse engineering. Native loading executes
trusted code; manifest hashes establish integrity against a selected manifest,
not publisher authentication. Manifest inspection does not activate code.

## Validation and replay

Core fmt, all-target/all-feature Clippy, all-feature tests (650 unit tests plus
integration/docs), 79 Python algorithm tests and 8 exact cost/witness/work WASM
parity cases passed. Provider/component scoped all-target/all-feature Clippy,
adapter ownership/semantic tests, two existing QEC semantic tests and original
Tiger allocation test pass. Final scoped gates include actual Chromium after the
Worker generation guard. Whole operator-tools Clippy retains the unrelated existing
needless_range_loop in tasks/tools/src/leakage_dual_tower.rs:116; no waiver or
foreign fix applied. Final scoped log:
/tmp/claude-run-quiet/20260908-140735-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsrustfmt-nixpkgsclippy-nixpkgsnodejs-ni/.

Private analysis/module-loading/README.md specifies replay order. Its evidence/
manifest.json seals input/transcript bytes, all 600 raw samples, summaries, leaf
reports and artifact hashes. Bulk executables/perf data stay in the named
~/.cache/ergodis/module-loading/ and ~/.cache/ergodis/bin/ locations. Exact allocation
diagnostic payload hashes are recorded, but those binaries were overwritten by
later builds and not separately retained. Do not package shared-target outputs
after diagnostic builds without rebuilding/auditing default-feature distribution.

The original native baseline is ergodis-tools-6ab0681, SHA-256
663fd90d4cf6e7309960c2cb156d536f8a36211b7f0229a11153e61e9dd82b46.
Measurement executables lrc-module-boundary-3aafb81 and qec-module-boundary-3aafb81
are retained with exact hashes. Run-time HEADs in artifacts.json predate final
commits and include then-pending spike edits; they are not clean-tree identities.

An independent arithmetic recomputation matched the initial 32 paired summaries
to 1e-10. The committed summary script reconstructs all three experiments from raw
samples. Oracle answers reuse native APIs; independent mathematical verification
and independent-agent review were outside this bounded spike.

Operational corrections: navigation completion is awaited; isolated compilation
needs the Nix C linker; unique remapped paths avoid Rust source-map collisions;
summary grouping now supports a single-family follow-up. After compaction, an
overlarge combined document read exceeded the output rule and was replaced by a
narrow header/status read. A staged whitespace check also emitted excessive perf
report padding diagnostics; the evidence exporter now trims trailing report
whitespace, rehashes the records, and the saved bounded recheck passes. This was
fixed with a forward commit; numerical evidence and raw perf data are unchanged.

Experimental limits remain: 64 live objects per instance, 65,536 queries/workspace,
QEC 4,096 nodes / 65,536 edges / one observable, and bounded buffers. These are
spike limits to remove/generalize, not intended WASM restrictions. Update/checkpoint/
continuation support and production ABI negotiation remain unimplemented. C1130
stays open through shared ownership, three-family integration, full inventory and
parity, console integration, native performance acceptance and private glossary.
