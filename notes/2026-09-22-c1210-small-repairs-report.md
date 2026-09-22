# C1210 — Datalog/Rel small repairs

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: IN PROGRESS. Cleanup and stage sequencing accepted; record-format gates remain open.

## Scope and coordination

Tavis requested cleanup first, with the main agent coordinating and reviewing Terra/Sol
subagents. Three commit boundaries: documentation/byte-preserving cleanup (core/private
separately), stage-sequencing repair, and record updates. The task does not implement the
later builder, schema/provenance, domain or ABI work.

Initial core revision: `c73ed85`; initial private revision: `bfd79c9`. Scoped source trees
were clean on entry. A fresh private tools control was retained before any source edit:
`ergodis-tools-bfd79c9`, measured SHA-256
`c0fe7a8fb22a9327da683d0f85481409691befe1436fba6ac2509e948e0e24d2`.
Recipe: the dev `retain-bin.sh` on private `tasks/tools`, binary `ergodis-tools`, default
release profile under the core pinned Nix shell. Core dependency revision was `c73ed85`.
The previous C1209 control predates C1205 a and is not assumed matched to today's tree.

Core documentation and private cleanup have separate owners. The sequencing analysis is
read-only until cleanup lands. Builds share one scheduled slot; all use the pinned toolchain,
shared target directories, at most twelve workers, and the required OOM preference.
The main agent reviews diffs, gates and receipt interpretation before commits are accepted.

## Acceptance ledger

| Milestone | Status | Required evidence |
|---|---|---|
| Core checker/fact-count documentation | Committed `61116a3` | Main reviewed all four documentation diffs; fmt, Clippy and 85/85 test groups passed; manifest regenerated |
| Private documentation and byte-preserving cleanup | Accepted `8192836`; evidence `1bd7d79` | fmt/Clippy and 100 affected tests pass; native/WASM canonical digest unchanged; primary A/B/null, fitted cache, calls and RSS reviewed |
| Stage sequencing | Accepted `69426b9`; evidence `c1b398f` | 100 focused tests, unchanged native/WASM parity, measured entry cost and unchanged loop call targets |
| Parity v2 and additive bench policy | Candidate `67b782a`; performance pending | Native/WASM v2 agrees and byte-growth forecast reconciles; both bench policy spellings pass |

## Decisions and limits

The cleanup Fermi is zero change in retired instructions/work/bytes: the literal retains
the same 32-byte stride and two u32 positions, each initializer assigns the same values,
and the canonical writer emits the former word zero for aggregates. The named chain
buffer remains 64 entries. ThinLTO can nevertheless change generated code; profiles and
matched A/B, including a separate cache-event run, are required before accepting that claim.

Main-agent review caught and corrected two proposed-documentation issues before acceptance:
`count` accepts arbitrary values, unlike the integer-only `min`/`max`/`sum`; and
construction record checking is replay through shared builder machinery, not an independent
implementation. The adjacent reference helper's stale "drop the group" description was also
corrected to whole-program refusal. No behavior was changed for these corrections.

- A generation check establishes workspace-stage freshness, not the identity of arbitrary
  source bytes supplied by a caller. The remaining source-byte precondition must stay explicit.
- Review selected a smaller implementation than the originally proposed counter: a private
  Empty/Parsed/Admitted state. Scanning invalidates before any error; successful compact parse
  and admission advance state; lowering requires Admitted. There is no numeric wrap. Diagnostic
  recovery stays outside the documented compact-parse admission boundary. Failed lowering
  preserves admission for retry. Implemented and correctness-tested in `69426b9`;
  performance acceptance is recorded below.
- Source implementation hashes may move even on documentation edits. No historical receipt
  is re-pinned as if its measurement had been repeated.
- No cache deletion, publication, unrelated comment sweep or Lean operation is authorized here.

Sequencing Fermi, before integration: four source-level stage stores (scan Empty, parse
Parsed, admission Parsed then Admitted) and two entry checks per successful pipeline.
The compiler may eliminate stores; prediction is single-digit/tens of instructions per
source invocation, not per token, node or IR-loop iteration. Failed scan/parse resets only;
diagnostic recovery grants no admission. Acceptance uses the clean accepted cleanup
binary against the next candidate, with parse/admit/lower stages on ASCII, Datalog and
early/late malformed cohorts, a parse A/A null, separate cache events, scoped profile/call
inspection and RSS. The benchmark's automatic parity comparison omits nested lowering
records, so exact lowering outcomes/counts/IR fingerprints must also be checked explicitly.

## Closeout

The final record-update gates and task-lifecycle closure remain open. Incidental discoveries,
retained artifacts and unresolved evidence gaps will be accounted for at closure.

## Isolated preparation and validation scheduling

While private cleanup gates run, later source changes are prepared separately and do not
alter the measured primary checkout or start another build:

- `~/.cache/ergodis/worktrees/c1210-sequencing`, based on private `bfd79c9`: uncommitted
  `src/rel_frontend/mod.rs`, `src/rel_frontend/diagnostic.rs`, `tests/rel_lowering.rs`.
  Source reviewed, then integrated and validated as primary `69426b9` after cleanup acceptance.
  This isolated copy itself was never built.
- `~/.cache/ergodis/worktrees/c1210-records`, same base: uncommitted
  `tests/rel_frontend_portability.rs`, `analysis/rel-frontend/portability.py`,
  `analysis/rel-frontend/README.md`, `tasks/tools/src/rel_frontend_bench.rs`.
  Source reviewed; artifact generation, smoke/parity/performance gates remain pending.
  It cannot land before the sequencing repair is accepted.

These source-only worktrees intentionally have no build targets or dependency-symlink trees.
Reviewed patches will be integrated into the primary checkout and validated in sequence.
They remain uncommitted draft copies; the primary commits and evidence are authoritative,
not these isolated preparations. No cache/worktree deletion was performed.

Private fmt and Clippy passed. The first broad test invocation used Cargo jobs=12 but omitted
the test-harness cap, so the agent interrupted it without claiming acceptance and restarted
with `RUST_TEST_THREADS=12`. Subsequent test commands must carry both caps. The constrained
run also spent several minutes in unrelated library-domain tests; the previous run's bounded
tail named tiger_blossom_sparse, q29_psd_scope_proof and order6_margin_evolve. The main agent
stopped this task-owned broad run and selected affected frontend/lowering/stratified/reference
test targets instead. Private AGENTS does not require the unrelated full library suite;
the required task gates remain intact. Neither interrupted run establishes a full-private-suite
pass, and neither reported a failure before interruption.

The record-update owner later mistakenly selected a broad
`cargo test -p ergodis-private -p ergodis-tools --all-features` invocation despite the
scoped plan. Main directed that task-owned run be stopped and replaced by the named
`rel_frontend_portability` integration target and relevant driver checks. The source
fmt/Clippy gates had passed; this incomplete broad run is not a test-pass claim.
The owner confirmed the runner/cargo PIDs stopped and no test executable had launched;
the retained log directory had only invocation context, not a partial test result.

## Core documentation validation

Core `61116a3` changes comments only in contract derivation, verify derivation/ranked and
rules demand, plus regenerated SHA256SUMS. Public check methods retain the source identity
requirement and explicitly name shared trust. The prepared fact count now names
`Admitted::facts.len()`; wire count includes duplicate and absent source entries.

Commands under the pinned core Nix shell, with `choom -n 1000` and twelve build jobs:
`cargo fmt --check`; `cargo clippy --all-targets --all-features -- -D warnings`;
`cargo test --all-features`; `python3 python/generate_evidence.py --write`.
All reported exit zero; 85 test-result groups, 1,037 tests passed, zero failed, three ignored.
The core Python-parity tests compare committed Python-origin fixtures; no live Python
process was claimed. Private Rel reference/differential coverage is reported separately below.
Counts were summed from the saved post-revision log without another suite rerun.
During coordination, a redundant whole-handoff read exceeded the command-output cap;
it was not used for review and was replaced with a bounded C1210 section lookup.
One redundant suite rerun occurred in the implementation subagent; it contributes no
additional acceptance evidence. No core hot-loop/performance change is claimed.

Read-only recomputation uses the package's complete identity preimage: domain and declared
source bytes, plus the verifier's rule ID and little-endian rule version prefix. Main
review caught an initial calculation that omitted that prefix; the corrected values below
use `ergodis/necessary-coordinate` and version 1 as a little-endian u32. Source identities/canonical program
bytes are separate from these implementation identities:

| Package | Before `61116a3` | After `61116a3` |
|---|---|---|
| contract | `b383135c5563a039650a3d911306ebf0ed8a29876e72ccb3fe1895e2b01163e4` | `dae904ed8764ec9a61d36a226677b2bcd33011f0503ed6fe894c88a12e6d7d49` |
| verify | `381ac03f7575081a05fcb02dfa80dec9282052101f4b1b7394365e5c613cc839` | `efa1074500b1bb7436245d04e921fda1ddb16f72b265336d2a154b76f905924a` |

The main agent independently reproduced all four corrected values with shell concatenation
of the identity preimages through `git show` and `sha256sum`, separately checking the rule
constants at both revisions. No compiled probe or rebuild was needed.

## Private cleanup correctness

Candidate `8192836` contains only the five reviewed source files and
`analysis/rel-frontend/portability-c1210-m1.json`. The core dependency is `61116a3`;
the retained baseline used `c73ed85`, whose difference is the core documentation above.

Pinned fmt and all-target/all-feature Clippy pass. Affected private test targets:
rel_frontend 28, rel_frontend_portability 1, rel_lowering 52, rel_reference_eval 19;
100 passed, zero failed. These include the allocation and reference/differential checks.
The full private library suite is explicitly not claimed.

The main agent inspected the parity receipt: 243 cases, 529,122 canonical bytes,
native/WASM byte equality, unchanged SHA-256
`5f9600ef35db554dc0360624f87e2b69653193842c959c2f6d0c27daacba0cc4`.
The standalone portability compiler and pinned shell both report rustc 1.95.0
(`59807616e`, 2026-04-14). The source commit was followed by separate candidate retention
and matched performance acceptance; the evidence and limits follow.

Main independently reviewed the seven-round Datalog companion receipt
`analysis/rel-frontend/performance-v1-c1210-m1-datalog-stages.json`: lower-stage byte
instruction ratio 0.9999998396, interval [0.9999991512, 1.0000005281]; scalar
1.0000000974, [0.9999994529, 1.0000007418]. Parse A/A null is 0.9999998274,
[0.9999922173, 1.0000074377]. Every recorded event was enabled 100% of its run.
Subtracting admission from lowering means gives byte 1,326,411.19 control versus
1,326,409.59 candidate instructions; scalar 1,326,411.24 versus 1,326,415.97.
These subtracted means have no paired-difference interval and are corroborative, not
an improvement claim. The initial lower-only receipt lacked an A/A null, hence the
companion with parse/admit/lower/stratify. The five default cohorts also show no
instruction interval wholly outside [0.9999, 1.0001]. Main separately reproduced
exact cross-arm equality of nested lowering and stratification records, fingerprints,
failures, token/node counts and admission for all three primary receipts. Cache,
profile/call and memory acceptance is recorded below.

Main recomputed the retained candidate's measured SHA-256 as
`ce60240668c6edce779e68ecb85bed053be2ea8233f6ef18a014aa5454a8df67`, and
reconfirmed the baseline hash above. The companion's byte-path peak RSS is control→candidate:
parse 6,056→6,064 KiB; admission 6,084→6,092; lowering 6,180→6,188; stratification
25,032→25,040. Workspace retained bytes remain 11,045,388 throughout. The uniform
8 KiB process increase is recorded, not hidden behind a memory-neutrality claim; its
binary/startup-page origin is an inference, not an established attribution.

Cleanup accepted after the fitted separate cache receipt
`performance-v1-c1210-m1-datalog-cache-fit.json`: instructions, cycles, cache references
and cache misses all enabled 100%; parse A/A instruction null 0.9999968313,
[0.9999843627, 1.0000093000]. The prior six-hardware-event cache invocation multiplexed
(minimum 66%, means about 82–84%) and is rejected as acceptance evidence. No cache
improvement is claimed. The scoped profile/disassembly comparison found no new loop calls:
both arms have 175 static call sites in `lower::run` and the same symbolic target list
apart from a monomorph hash. Existing sampled workspace transfer/clear calls remain;
the change does not establish that all existing lowering code is call-free. The ordinary
cohorts do not execute aggregate reader paths; aggregate/forall fixtures provide correctness,
not a separate performance claim. Cleanup is retained for clarity and accurate contracts,
not as an optimization. Detailed replay and call attribution live in private
`analysis/rel-frontend/c1210-m1-evidence.md` (`1bd7d79`), reviewed by the main agent.

The main agent applied the reviewed stage patch to the three primary-checkout files;
`git diff --check` passed. Only after all cleanup measurements ended was the build slot
transferred to the sequencing owner. The isolated preparation remains uncommitted as
listed above; primary source correctness and performance gates now follow in sequence.

The sequencing owner reports pinned formatting, scoped Clippy, frontend/lowering/reference
tests (28+53+19 = 100, all passed) and the native/WASM replay passing. The parity corpus
remains 243 cases, 529,122 bytes with the same digest. Source is committed as `69426b9`;
main compared all three committed files against the reviewed isolated patch with whitespace
removed and found no other changes. Main also recomputed the clean retained candidate's
measured SHA-256 as `891bca69263a0cbf8678f98208b0bd4ffe0960ae9b830bd555cf06983e504613`.
Matched control is `8192836`, both with core `61116a3`. Stage A/B acceptance is recorded below.

One sequencing cache invocation was refused before measurement because the main agent's
three-event recipe omitted `cycles`, which `bench.py` requires alongside `instructions`.
The corrected separate set is `instructions,cycles,cache-references,cache-misses`, already
confirmed at 100% enabled in cleanup. No source change or primary rerun was needed.

Record-update Fermi before integration: `body_policy` mapping/JSON emission is outside the
timed loop, so expected kernel/work/fingerprint delta is zero; ThinLTO layout still requires
a matched driver A/B. Forty-two lowered records gain three u32 counters each: predicted
wire growth 504 bytes, from 529,122 to 529,626, with 243 cases and 14,238 inner canonical
RIR bytes unchanged. These are predictions, not generated-v2 results. The intended bounded
gate uses ASCII plus Datalog (successful lowering), scan/parse/admit/lower, both scanners,
parse A/A nulls, fitted separate cache events, profiles/calls and RSS. Both policy spellings
must be checked in standalone bench receipts; schema remains v1 there, v2 only for parity.

## Sequencing measurement review

Main reviewed `analysis/rel-frontend/c1210-stage-primary.json`: seven rounds, four cohorts,
parse/admit/lower, both scanners, six events all enabled 100%. Every nested output/work
record compared exactly across arms. Byte Datalog parse/admit/lower add approximately
9.70/32.17/35.46 retired instructions per source; ASCII adds 3.05/30.17/31.30.
These are small genuine entry costs, consistent with the prewritten tens-of-instructions
Fermi, not a zero-cost claim. Datalog lower ratio is 1.0000062456,
interval [1.0000046553, 1.0000078360], with parse A/A null 0.9999995220,
[0.9999962305, 1.0000028135]. Valid execution and malformed parse outcomes are unchanged;
the new behavior is tested on stale/unadmitted calls, not exercised as a successful benchmark.
Byte Datalog lowering RSS is 6,012→6,056 KiB; retained 11,045,388 and occupied 274,832
bytes are unchanged. Cycle ratios are noisy and do not decide this correctness repair.
Fitted cache and call/profile review passed: main verified all four cache-run events at
100% enabled; cache-reference null drift and negative differenced misses preclude a cache
effect claim. Ordered demangled call targets match exactly for `admit::run` (42) and
`lower::run` (175), with unchanged symbol sizes. Existing clear/copy calls remain; a
sampling display threshold is not proof of absence. Main reviewed the complete private
`analysis/rel-frontend/c1210-stage-evidence.md`; source/evidence commits are `69426b9` /
`c1b398f`. The source guard and measured entry cost are accepted as a correctness repair.

Cycle ratios increased on ASCII/Datalog byte lower: 1.0592 [1.0480, 1.0705] and
1.0646 [1.0264, 1.1041]. Their cause is not established; shared-host load is a possible
factor, not a demonstrated attribution. Instruction counts decide under the existing lane
protocol. No timing-neutrality claim follows from accepting the repair. This unresolved
timing observation remains in the evidence, without a new optimization task or scope expansion.

After the sequencing owner released the build slot, main applied the reviewed four-file
record patch and checked the diff. Core was still `61116a3`; the record owner reuses
the clean `69426b9` control. C1213 parallel work was approved only for design and isolated
paired core/private source preparation, with no live-checkout changes or competing builds
until C1210 completes.

## Record-update correctness

Main reviewed the final three code diffs, README and v2 receipt. Scoped formatting and
Clippy pass; the named `rel_frontend_portability` integration test passes (one test).
The native/WASM replay agrees exactly: schema `ergodis.rel_frontend_portability.v2`,
243 cases, 529,626 bytes, four decoder negative controls and 14,238 inner canonical
RIR bytes. Its digest is
`f4542625f8a358dfa1cd5155f74d787b5c5b6a6a402b7511a86c1f8202129028`.
The independent forecast reconciles exactly: 42 lowered cases × 3 new u32 counters
= 504 added bytes. The reader now consumes nineteen counters plus two fingerprint
words. Historical v1 receipts are untouched and the README labels their counts historical.
Bounded Datalog/lower smokes for both policies retain bench schema v1 and emit canonical
`body_policy` values `binarize` and `nary`. Source and v2 artifact are committed as `67b782a`;
matched driver performance acceptance follows. Main additionally checked every recorded
v2 source SHA against the current files, and verified that the complete record summary is
identical to M2's v1 summary, cases agree, and growth equals old lowered_cases × 12 exactly.
Correctness approval alone is not final acceptance.

Main independently rehashed the clean retained record candidate `67b782a`:
`f21d8bea608a0b76e35e775a9ecf2d33296bc1c4029b6a814c65bbcf70fad951`.
Control is `69426b9`, both with core `61116a3` and explicit `--body-policy nary`.
The seven-round `c1210-records-primary.json` has all six counters enabled 100%; main
confirmed every compared nested semantic/work record matches, and every candidate
record carries `body_policy=nary`. Byte Datalog lower instruction ratio is 1.0000001139,
[0.9999990109, 1.0000012170]; RSS is 5,992→5,996 KiB and retained bytes agree.
One small nonzero row must not be hidden: scalar Datalog scan adds 13.17 instructions
per source, ratio 1.0000125867 [1.0000062038, 1.0000189697]. A separately recorded
same-binary primary null has an overlapping interval [0.9999967306, 1.0000084977].
The built-in parse null already existed, so this extra standalone run is retained as
corroboration, not a reason to repeat another standalone cache-null campaign. No speed
improvement or universal zero-delta claim is made. Cache and call/profile gates follow.
