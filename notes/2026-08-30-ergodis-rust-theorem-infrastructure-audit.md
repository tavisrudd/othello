# Ergodis Rust theorem-infrastructure audit

**Date:** 2026-08-30
**Decision:** no dependency added; design borrowing and private spikes only

## Ranked leverage

| upstream | best use | decision | license seen upstream | main caution |
|---|---|---|---|---|
| Metamath Zero / `mm0-rs` | untrusted elaborator to compact proof IR to tiny independent checker; binary proof stream; server workflow | borrow architecture now; no code import | CC0-1.0 repository | component/transitive audit still required; CC0 has different patent treatment from Apache-2.0 |
| `egglog` | exact-term canonicalization, equality saturation, rewrite discovery, Datalog joins | private optional spike after recipe IR stabilizes | MIT | equality explanations are not Ergodis proof authority; replay every extracted equality in Lean or an independent checker |
| Ascent | forward theorem-DAG saturation, case joins, proof-status/debt lattices | private optional spike on one frozen theorem graph | permissive MIT text | generated data structures may not meet hot-loop/memory constraints; no automatic trust in derived facts |
| Salsa | incremental invalidation of theorem fragments, environment hashes, certificates, and composed goals | borrow query-key/durability design first | MIT OR Apache-2.0 | upstream describes itself as work in progress; avoid making persistent artifact format depend on it |
| RustSAT + solver adapters | finite implication refutations and PB/VeriPB proof logging | sidecar spike only if current native backend lacks a gate | MIT | current advertised MSRV 1.87 exceeds this crate's 1.82; solver-wrapper licenses and proof formats need separate audit |
| Differential/Timely Dataflow | incremental forward closure over very large changing theorem graphs | defer until scale demands it | MIT | heavy architecture and allocation model for today's graph; do not pay distributed-dataflow cost prematurely |
| Verus | machine-check stable Rust kernels such as mask census, matching, and certificate parsers | selective verification experiment, no runtime dependency | MIT | supports a Rust subset and remains under active development; separate toolchain/replay burden |
| PyO3 / maturin | optional in-process Python transport after the socket protocol stabilizes | audit and spike later; no dependency now | MIT OR Apache-2.0 | CPython/toolchain/build closure; binding must remain a replaceable transport |
| `petgraph` | ordinary graph algorithms and visualization | probably unnecessary initially | MIT OR Apache-2.0 reported upstream | theorem DAG is a typed hypergraph with proof status; a small CSR/index layer may be simpler and faster |

## What to copy conceptually

### MM0

The most valuable pattern is a hard trust split:

```text
rich untrusted theorem miner/composer
  -> compact deterministic proof stream
  -> tiny independent verifier
```

MM0 explicitly separates specification from implementation-defined proof
syntax, and its proof-producing MM1 compiler need not be trusted.  Ergodis
should do the same, with Lean as final authority and a compact internal proof
DAG for fast replay.  Use the architecture, not MM0 source or format, unless a
later interoperability case justifies the dependency.

### egglog / EqSat

Use equality saturation only inside `canonicalize`: normalize formulas,
discover equivalent lemma interfaces, and select a low-cost representative.
Attach provenance to every rewrite.  The extracted equality is a candidate
until replayed by the theorem composer and Lean.  Keep exact finite-field and
quantifier side conditions outside untyped rewrites.

### Ascent / Datalog

The theorem hypergraph is naturally relational:

```text
proved(fragment)
requires(edge, fragment)
produces(edge, fragment)
compatible(substitution, domains, quantifiers)
```

Ascent's lattice relations are attractive for “best known proof status” or
minimum proof debt.  A spike should compare it with a hand-written indexed
worklist on one C80/C896/PRS graph, measuring allocations, RSS, update latency,
and explainability.

### Salsa / differential dataflow

Salsa's useful idea is keyed, memoized, dependency-tracked queries.  The keys
for Ergodis are environment hash, theorem-fragment hash, action contract,
certificate hash, and target obligation.  Differential dataflow becomes
relevant only when thousands of live campaigns continuously add and retract
facts; it is not the first implementation.

### RustSAT

RustSAT provides a useful common encoding layer and advertises proof logging,
including VeriPB support through `pigeons`, plus interfaces to CaDiCaL, Kissat,
Glucose, and MiniSat.  It could validate candidate implication edges.  Because
of the MSRV mismatch and per-solver licensing surface, isolate any experiment
as a tool/sidecar rather than changing Ergodis' core toolchain.

## Licensing and supply-chain gate

No upstream code, generated code, vendored source, or dependency enters public
Ergodis without a checked intake record containing:

```text
exact crate/version and source commit
SPDX expression from the distributed artifact, not a search snippet
selected features and complete transitive dependency closure
license texts, NOTICE/attribution, and Apache patent terms where applicable
MSRV and build-script/native-code inventory
source/repository allowlist and checksum/lockfile pin
security/advisory result and maintenance status
public/private/optional linkage decision
```

Policy for this incubation:

- permissive is not automatic approval; MIT/BSD/ISC/Zlib, Apache-2.0, and CC0
  still receive attribution, patent, source, and transitive audits;
- GPL/AGPL/LGPL/MPL, source-available licenses, custom terms, unknown files, or
  mixed-license components require explicit review before even a private
  integration;
- copying an algorithm from prose is reimplementation with citation; copying
  source, tests, tables, generated code, or distinctive comments is code reuse
  and requires the corresponding license path;
- optional features must not silently pull disallowed native solver or build
  dependencies into the public default closure;
- run an automated license/source/advisory gate on every lockfile change, but
  retain a human-reviewed allowlist because scanners cannot resolve scope,
  exceptions, patent posture, or generated artifacts.

## Primary upstream records consulted

- Lean environment/kernel API: <https://lean-lang.org/doc/api/Lean/Environment.html>
- MM0 repository and proof architecture: <https://github.com/digama0/mm0>
- egglog repository and MIT license: <https://github.com/egraphs-good/egglog>
- Salsa repository and dual license files: <https://github.com/salsa-rs/salsa>
- Ascent repository: <https://github.com/s-arash/ascent>
- RustSAT repository: <https://github.com/chrjabs/rustsat>
- Differential Dataflow repository/license: <https://github.com/TimelyDataflow/differential-dataflow>
- Verus repository: <https://github.com/verus-lang/verus>
- PyO3 and maturin: <https://github.com/PyO3/pyo3>, <https://github.com/PyO3/maturin>

## Next decision gate

Implement the first theorem composer with owned Rust indices.  Once one PRS,
one C80, and one C896 theorem DAG are replaying, benchmark:

1. hand-written worklist;
2. Ascent;
3. egglog only for canonicalization.

Adopt a crate only if it materially reduces implementation/proof debt without
violating memory, hot-loop, trust, MSRV, or licensing constraints.

Vibe: Rust has excellent components to borrow from, but the winning stack is a
small Ergodis-owned proof IR plus narrowly scoped optional engines—not a deep
dependency on someone else's theorem runtime.
