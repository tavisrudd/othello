# C1170 — owned Rel-rich frontend prototype

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS. Two-hour continuation began 2026-09-13 05:24:50 UTC;
target stop 07:24:50 UTC.

Establish a versioned syntax/admission coverage contract with at least the
expressive richness of Rel, then implement a bounded owned lexer/parser and
diagnostic prototype to test the representation and performance approach.
Authority and source study: `2026-09-12-c1169-datalog-frontends.md` and the
binding user directions in `ergodis-architecture-context.md`.

## Scope

- Pin the Rel documentation and official editor grammar/test references;
  create original feature fixtures with explicit expected structure, precedence,
  binding, error categories and spans. Label prototype omissions; a small
  fragment is not the final language target.
- Reuse applicable owned scanner/interning machinery after inspecting the
  existing core. Prefer a small runtime dependency surface. All backend,
  semantic admission/lowering, rule handling and joins remain Ergodis-owned.
- Prototype compact span/ID pools and an explicit bounded parsing stack, with
  capacity planning before scanning and no hidden allocation/growth in the
  repeated scan. Include setup and materialization in measured totals.
- Implement the normal/diagnostic split: compact successful parse, structured
  failure, optional richer error-only reparse and separate rendering. Require
  Rust/iidy-hs-quality context, primary/secondary spans, IDs and useful fixes;
  preserve rejection and keep semantic provenance for non-syntax failures.
- Exercise representative complexity immediately: Rel operator precedence,
  Unicode, qualified/partial application, binders/varargs, nested modules and
  interpolation/raw strings. Expand coverage using an explicit manifest.

## Acceptance

Correctness precedes speed: positive/negative fixture agreement, full input
consumption, deterministic errors, capacity/nesting controls and native/WASM
parity. Parser prototype success does not establish production execution or
Lean proof coverage for the parsed forms.

Retain release baselines and input hashes; use interleaved equal-work A/B with
allocation counts, peak memory, time distributions and hardware counters for
scanning-loop changes. Separate parse, diagnostic reparse, admission/lowering
and end-to-end boundaries. Include malformed inputs and error rendering quality;
do not optimize the successful path by making diagnostics inadequate.

The deliverable is the coverage contract, a validated bounded prototype and
measured disposition of candidate representations. It is not a claim that all
Rel semantics are implemented. Allocate the remaining frontend/production
lowering work from the resulting coverage manifest.

Tree-sitter/editor integration and an executable semantics reference (PLT
Redex or similar) are deferred, not prerequisites. No foreign evaluator or
join runtime is an allowed shortcut. No new runtime dependency, performance
claim or backend policy change is made by this queue entry.

## Validated checkpoint — 2026-09-13 05:49 UTC

Private commit `cfae073` contains the original owned scanner, iterative Pratt
parser, preallocated span/ID pools, compact failures, error-only escaped source
excerpts, versioned ten-family coverage manifest and 11 integration tests.
Targeted tests and strict Clippy pass. Thread-local allocation instrumentation
observed zero allocations across 100 repeated success, syntax-failure and
invalid-UTF-8 cycles after workspace preparation. No parser speedup is claimed.

The manifest and implementation README live under
`ergodis-private/analysis/rel-frontend/`. Unsupported interpolation and complex
escapes reject explicitly. Semantic admission and execution remain absent.
Rich recovery trees, complete rich-error quality, retained interleaved
measurements/hardware counters and native/WASM parity remain acceptance work.
C1170 remains open at this validated checkpoint.

The user clarified that the two-hour continuation is for any of today's
queued Ergodis work, not frontend-only. After this checkpoint the active
work switches to C1154's offline FeatureDag interval/acyclicity slice; the
original 07:24:50 UTC stop target remains unchanged.


## Native/WASM and review checkpoint — 2026-09-13

Private commit `a644dad` contains this checkpoint. The finite portability gate now executes the exact frontend source as native
and WASM test libraries: 142 cases produce 325,403 identical canonical bytes,
including syntax records, failure fields and rendered diagnostics. Both scanner
variants also agree. The corpus includes 512 definitions, every byte prefix of
a Unicode module, deterministic malformed bytes, and 1,024 nested parentheses
which explicitly reach DepthCapacity. Exact replay and source hashes and toolchain versions:
`ergodis-private/analysis/rel-frontend/portability-v1.json` and its adjacent
Python/Node runners. This is finite platform parity, not an independent grammar
oracle, production browser ABI, or speed measurement.

The three C1171 lexer review defects are repaired: `a^b` uses exponentiation,
unsupported radix literals reject explicitly, and malformed exponents have
nonempty numeric spans. Separators after exponents also reject. Caret-prefixed
entity references remain explicitly unsupported instead of being mistaken for
ordinary names. The coverage manifest names this gap; full entity syntax is
still required by the product target. Thirteen frontend integration tests and
one native probe pass; strict library and targeted-test Clippy passes.

The standalone probe inherits the owning library's explicit flat-API Clippy
allowance; its source includes the module directly to exclude host-only crate
dependencies. Its bounded returned allocation lasts until process exit and
is not a production interface or a change to the zero-allocation parser claim.

C1170 stays open. Next gate: retained interleaved parser measurements with
setup/scan/materialization boundaries, followed by rich recovery and the
remaining versioned syntax/admission gaps. No dependency or backend adoption.

Operational note: a repeated handoff read exceeded the display budget after
context recovery; subsequent reads were narrowed to the relevant section.
The saved portability receipt was inspected instead of blindly rerunning the
previous truncated tool result. The probe's initial Clippy invocation exposed
its missing inherited flat-API allowance; that invocation was corrected before
revalidation. No failed gate is reported as passing.


### Diagnostic and stress refinement

Private `6290979` adds stable malformed-exponent ID `REL0104`, a specific
missing-digit explanation and repair examples. The compact failure layout
remains 16 bytes. All 16,105 expression suffixes of lengths zero through four
over the declared eleven-byte alphabet pass bounded token/failure span checks,
scanner equality, diagnostic rendering and workspace reuse. This is a finite
stress gate, not exhaustive language correctness. The final 142-case native/
WASM canonical output is 325,403 bytes. No performance conclusion follows.

### Mystery ledger / bounded extra-value pass

The review exposed an accidental acceptance boundary: a caret-prefixed name
consumed an infix operator. This is settled for the prototype by making caret
an operator and explicitly deferring entity references in the manifest.
The missing exponent span also exposed a cheap diagnostic improvement: retain
a specific compact error category and build explanatory text only on failure.
Both changes have regression and platform-parity evidence.

No unexplained discrepancy remains in these finite gates. Remaining evidence
gaps are owned by C1170: full reference syntax/Unicode conformance, semantic
admission, rich bounded recovery, and retained performance measurements. The
same-source parity oracle cannot establish correctness against Rel; it only
checks platform and scan-variant agreement.


Private `9cdc124` contains the final allocation and record-census refinement.
The final allocation gate additionally exercises identifier exponentiation,
malformed exponents, radix rejection and the scalar control: still zero
allocations over 100 prepared cycles. The independent canonical-record decoder
checks complete consumption and rejects four corrupt controls. Its census finds
180,240 occupied token/node bytes for the 12,068-byte, 512-definition source
(4,097 tokens, 3,584 nodes). This approximately 14.9× logical representation
ratio is not a traffic/RSS measurement. It sharpens the next cost model:
measure materialization, retained capacity and setup alongside ASCII dispatch.


### Measurement handoff

For the next C1170 run, freeze separate ASCII-heavy, Unicode-heavy, comment/
string-heavy and malformed early/late source cohorts before comparing variants.
Use identical limits, original source bytes, token/node outputs and rejection
codes. Keep corpus generation and full output equality checks outside timing;
prevent dead-code elimination without charging a full fingerprint traversal to
only one arm. Report preparation, repeated UTF-8 validation plus scan/parse,
optional error enrichment and rendering separately, then their actual composed
cost. Admission/lowering is absent and must not be represented by a zero-cost
stub in an end-to-end claim.

Retain release executables in the shared cache, pin equal work to physical
cores, alternate paired runs, and collect cycles/instructions/branches/misses/
cache events under the existing performance playbook. Keep allocation and
instrumented profiling runs separate from throughput. Report distributions,
null drift, source hashes, occupied records and retained capacity. A win confined
to one synthetic cohort does not authorize general frontend promotion.
