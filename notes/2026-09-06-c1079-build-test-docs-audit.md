# C1079 build, test, documentation, and export audit

**Lane:** `ergodis`
**Date:** 2026-09-06
**Scope:** read-only audit of `ergodis` core, `ergodis-private`, and `ergodis-contrib`; no build,
export, source edit, or artifact/log sweep. This is consolidation input, not a claim that current
controls have failed.

## Observed controls

| Area | Actual evidence | Assessment |
|---|---|---|
| Core/package boundary | Core is `publish = false`, feature-gates `parallel` and `control-plane`, and has explicit binaries (`ergodis/Cargo.toml:1-84`). Its guide requires domain-neutral core only and one-way private dependency (`ergodis/AGENTS.md:8-31`). Private root is a workspace with library root and three task crates, `publish = false`, and a path dependency on core with control/parallel features (`ergodis-private/Cargo.toml:1-25`). | Boundary is explicit and mechanically reflected in manifests. Private default dependency enabling core control/parallel features means private test/build compatibility is a meaningful integration check. |
| Private organization | `ergodis-private/AGENTS.md:14-42` defines Tier 1 library versus Tier 2 task binaries and forbids `src/bin`; `README.md:1-15` states adapters/fixtures/evidence remain private. | Clear policy. The workspace member list is a compact mechanical inventory, though there is no observed CI check that every member still obeys the tier/binary rule. |
| Export split | `.publicignore:1-42` drops process docs, private tooling, evidence, regressions and target config; `scripts/export-public.sh:1-155` materializes a filtered snapshot, rewrites prose paths/evidence URLs, lints, advances public branch/tag, and records only the private mapping. `scripts/public-lint.sh:1-220` rejects task IDs, private paths, process docs, oversize files; `tests/publication-guards.sh:1-220` exercises clean/refusal/export fixtures. | Strong export guard with an actual fixture suite. It is an allow/deny filter, not a semantic proof that exported docs’ commands or numerical evidence replay. |
| Public CI/release | Public workflow runs only task-ID/process-document lint on GitHub (`.github/workflows/public-lint.yml:1-48`). The private release checklist requires staging `cargo build --release` and `cargo test --all-features`, public lint, evidence-tag resolution, replay commands and finished docs (`docs-private/RELEASE-CHECKLIST.md:1-52`). | CI independently rechecks confidentiality hygiene. Build/test/docs/evidence obligations are presently checklist/staging gates, not observed public CI jobs. That is consistent with filtered release control but weakens routine drift detection before a release. |
| Core correctness tests | Core has integration tests for CLI/RPC, contextual allocation, observational compiler, feature theorem evolution, arithmetic/Python parity, and publication guards (bounded listing under `ergodis/tests`). `feature_theorem_evolution.rs:1-150` exercises generated feature evolution and held-out symbolic parameters. `python_parity.rs:1-150` defines broad fixture-driven core parity. | Good mixed unit/integration/differential shape. Test names and source show coverage intent; this audit did not execute or establish fixture/oracle freshness. |
| Private exact/performance tests | Private has dedicated allocation/replay tests; e.g. `tests/proof_synthesis_allocations.rs:1-150` measures derivation and replay allocations with a counting allocator. `performance/kernel-registry-v1.json:1-180` records per-kernel allocation/layout/correctness/counter/contention status and evidence paths across core/private. `performance/check_kernel_registry.py:1-86` validates the schema, source/evidence paths, `na` reasons, and fails on open required gates; `performance/README.md:1-19` documents its strict invocation. AGENTS and PERFORMANCE require zero allocation, replay, single/parallel controls for hot changes. | The registry and checker are a useful cross-repository performance gate. I found no invocation beyond its documented manual command, so routine wiring remains an enforcement opportunity, not a need for a duplicate validator. |
| Contributor tooling | `ergodis-contrib/AGENTS.md:1-25` isolates performance contract and retained-baseline/cache tools from ship artifacts. `PERFORMANCE.md` requires out-of-tree targets, allocation/parity/perf gates; cache scripts are the designated retention/GC mechanism. | Correct separation: contributor process does not leak into public tree. Enforcement is largely procedural plus kernel registry, which avoids burdening ordinary source-only changes but needs a focused machine check for registered-kernel changes. |
| Documentation authority | `DESIGN.md:1-115` makes API/tests current-behavior authority and itself the component/topology authority; README/OPTIMIZATION/BENCHMARKS/CONTROL_PROTOCOL are mapped at `DESIGN.md:104-115`. `CONTROL_PROTOCOL.md:1-145` carries wire/trust boundary. | Useful authority map. No observed docs link/replay checker, generated API-doc gate, or explicit docs-to-feature/target support matrix, including WASM. |

## Consolidation findings and staged gates

1. **Keep one public-core quality gate and one private-package quality gate.** Do not force
   private fixtures/evidence into core or make core name packages. Add a small core command/CI
   target that runs format, clippy, all-feature tests, the required bounded Python exact
   differential corpus (costs, witnesses, helper loads), selected CLI/RPC/PlanSpec fixtures, and
   publication-guard fixtures. Add a private workspace target that runs its format/clippy/tests
   against the sibling core revision plus allocation/replay tests for affected packages. The
   current gates are documented/manual rather than already named entry points; this is a proposed
   consolidation, not evidence that the current commands are wrong.

2. **Make release staging consume the same named gates, not re-describe them.** The checklist’s
   stranger-build and export obligations are sound, but versioned `core-check` and
   `private-check` scripts/Make targets would make exact invocation, Nix environment,
   Python-oracle availability, and failure ownership visible. The public branch CI should retain
   confidentiality lint and add only tests that can run from the filtered tree; private-package
   and evidence-only checks must remain private.

3. **Wire the existing kernel-registry gate.** Reuse
   `ergodis-private/performance/check_kernel_registry.py`, which already parses
   `kernel-registry-v1.json`, validates schema/dimensions/statuses, confirms source/evidence
   paths, requires `na` reasons, and fails on open gates. Invoke it when registry/performance-
   kernel paths change and at release staging. Avoid rerunning benchmarks merely because
   documentation changes.

4. **Strengthen docs without turning prose into a second specification.** Preserve `DESIGN.md`
   authority mapping; add a concise generated/checked capability matrix linking each feature,
   binary/target, protocol schema, and test fixture/replay command. Release staging should check
   README/OPTIMIZATION/BENCHMARKS command targets exist in the filtered tree and external evidence
   URLs resolve to the matching declared evidence tag. This mechanizes requirements already in
   `RELEASE-CHECKLIST.md:16-27` without requiring all evidence to ship.

5. **Extension and WASM discipline (proposed).** Native packages need a core-only build, package
   manifest compatibility test, ABI/IR replay fixture, and private-package integration test;
   package source/kernel assets never enter public-core checks. WASM needs a separate target
   matrix with semantic PlanSpec/feature-DAG fixtures shared with native, target-specific loader/
   import tests, and an explicit unsupported-capability result. C1032 owns actual WASM audit and
   test mechanics; do not invent its host command here.

6. **Mode/provenance/admission tests (proposed C1079 gate).** Add fixtures asserting that a
   generated/evolved/imported/composed candidate retains origin and parameter lineage; changes in
   source/compiler/module/parameter identity invalidate unsafe cache reuse; heuristic output has
   no negative-coverage claim; and proof-generating admission requires an independently replayed
   scoped artifact. These belong primarily in core contracts, with QEC/C1016 concrete cases in
   private packages.

## Coordination

- **C1017:** owns performance-contract remediation/kernel registry history. Any registry-schema
  validator or changed performance acceptance gate should coordinate there, not silently rewrite
  existing evidence requirements.
- **C1032:** owns WASM audit/prototype mechanics. Its findings should fill the target-specific
  matrix and command, while C1079 owns only the shared core contract/convergence plan.
- **C1033:** its scope is notebook DuckDB/Sage work, not generic CI or gate ownership. Do not
  reassign build/test/portability automation to it without explicit scope approval; C1079 should
  not turn this audit into benchmark reruns.

## Pragmatic order

First introduce named core/private check entry points around the current documented manual gates,
and wire the existing strict kernel-registry checker; then make release staging and filtered public
CI call the appropriate portions. Add native-package
and WASM target gates only alongside the extension contracts, so unsupported mechanisms do not
create permanently failing matrix cells. This gives routine feedback while preserving current
release, privacy, evidence, and performance boundaries.
