# Ergodis local control protocol

The optional `control-plane` feature exposes a bounded local protocol for long
campaigns.  Rust, Python, and Lean clients use this protocol as their common
semantic boundary.  A binding is only a transport convenience; it cannot
promote a candidate to a proved theorem.

The current experimental schema is `ergodis-control-experimental-v0`.  A
client reads `manifest.json` from a caller-selected private run directory.  It
uses the manifest's exact socket path, run ID, and nonce on every request.
Simultaneous campaigns therefore have separate endpoints and handshakes.
Both reference clients bound manifest ingestion to the 65,536-byte frame
ceiling and reject a mismatched manifest schema before connecting.

## Wire format

Each connection carries one request and one response:

```text
4-byte unsigned little-endian payload length
UTF-8 JSON payload of exactly that length
```

Frames are at most 65,536 bytes.  Unknown request fields are rejected.  The
client must verify the response schema, request ID, and run ID.  The daemon
accepts connections through a blocking Unix-domain listener; it does not poll.
Accepted streams have the read/write deadline reported by `capabilities`, so a
client that abandons a partial frame cannot hold the serial controller forever.

The request object contains `schema`, `request_id`, `run_id`, `nonce`,
`max_bytes`, `op`, and an `args` object.  The response contains `schema`,
`request_id`, `run_id`, `epoch`, `ok`, and a `result` object.  `capabilities`
returns the daemon's framing, frame bound, operation names, large-result
policy, and proof-authority status.

Numbers follow the Rust wire types rather than a binding language's coercion
rules: request IDs and epochs are unsigned 64-bit integers, Boolean values are
not integers, and byte limits are positive bounded integers.  Non-finite
floating-point spellings are not JSON and are rejected.  Reference clients
fail closed if any envelope field has a different type.

Campaign-data headers may bind an offline feature extractor with an optional
`generator` object containing a nonempty `name`, nonempty `version`, and
64-hex-digit `digest`. The daemon copies this provenance into the manifest and
status response. A presentation hash alone does not identify how derived
features were computed.

`tests/fixtures/control_protocol_v0.json` is the language-neutral wire fixture.
New clients should parse and reproduce those compact payloads before speaking
to a live daemon.  In Lean, the stable starting point is a small client that
uses `read` until four bytes and then the declared payload length have arrived,
decodes the prefix explicitly as little-endian, and parses `Lean.Json`.  No
Rust/Lean object crosses the process boundary.

## Large evidence

Responses remain summaries.  Large traces and evidence are written to
create-only, run-relative files and returned as path/hash/byte-count metadata.
A client resolves paths beneath the manifested run directory and streams them
with a caller-selected record bound.  It must not read an entire evidence file
merely to iterate its records.

The daemon likewise does not retain a serialized evidence payload.  It first
streams compact JSON through a hash/count sink to enforce the configured bound
and derive the content address, then serializes directly through a buffered
create-only file writer.  This trades one cheap serialization pass for bounded
memory independent of the trace limit.

`candidate-batch` accepts a bounded list of lowered plans, evaluates them
against the frozen batch, and writes each complete record directly to a
create-only JSONL file under `evidence/`. The response contains only counts and
a caller-bounded top set. The daemon stops before the first record that would
cross `max_evidence_bytes` and reports `truncated: true`; it never silently
writes beyond the configured campaign trace limit.

## Textual plan authoring

Single plans passed to `ergodisctl try` and `ergodisctl apply` may use the
bounded textual syntax instead of hand-authored JSON:

```text
plan "rigid-order" {
  role ordering;
  output score;
  scope root.kind 0x0000000000000005;
  expr select((rigid == 1) && !(debt > 3), max(score * 4, abs(slack)), -7);
}
```

The parser accepts ordinary arithmetic, comparisons, Boolean connectives, and
the bounded `abs`, `min`, `max`, and `select` forms. Quoted names allow field
names outside the identifier grammar. Text and expression-JSON decode to the
same typed AST and use the same lowering and type checker; canonical formatting
has parse/format/parse identity, and equivalent text and JSON lower to identical
serialized bytecode. Input bytes, tokens, expression nodes, and depth are all
bounded before a plan can enter the daemon. JSON and JSONL remain the protocol,
persistence, bulk-batch, and diagnostic encodings; text is the human authoring
surface only.

## Proof authority

The daemon currently advertises `proof_authority: false`. Plans may diagnose
or order work, but no control-plane plan is authorized to prune the exact
search. A fit to a frozen feature batch is evidence about that batch, not a
proof. Any future pruning role must bind its predicate to independently
verified feature semantics rather than trusting field names or presentation
metadata.

The reference Python client is `python/ergodis_client.py`.  It has no external
dependencies, uses monotone request IDs, enforces the frame bound, and provides
bounded line and JSONL iterators.  Capability negotiation also pins the socket
deadline, create-only large-result policy, proof-authority status, and minimum
operation inventory.  A future in-process Python or Lean FFI must remain
byte-for-byte conformant with this socket path.

## Search-path isolation

The component topology and implementation-status matrix are authoritative in
[DESIGN.md](DESIGN.md). In experimental v0, `ergodis-campaign` serves the serial
control protocol, durable ledger, bulk candidate evaluator, and one optional
low-priority evolution worker. `evolve-start`, `evolve-status`, and
`evolve-cancel` manage that worker; `ergodisctl evolve` remains an offline
staging path. The generic `theorem_search` engine also supports caller-owned
streaming sinks.

The daemon evolution worker shares only the immutable frozen feature batch,
streams its audit to a bounded create-only file, and publishes progress through
one isolated cache-line record. A distinct solver-side low-priority sampler consumes fixed-size root
snapshots, performs isolated bounded probes, and sends compact scorecards through
the watcher. Search workers do not run evolution, probe workspaces, or protocol
code.

`ergodisctl evolve-start` accepts an optional direct seed JSONL file and up to
eight repeated `--resume-evidence` paths.  A replay archive must match the
problem, ordered feature schema, and exact feature-generator provenance.  When
no generator provenance exists, its complete presentation hash must also
match.  The daemon recomputes every archived plan hash, ranks candidates within
each archive, interleaves archives in request order, removes structural
duplicates, and admits at most 32 direct-plus-replayed seeds.  Replayed plans
are compiled and evaluated again on the current frozen batch; archived scores
are selection evidence, never current results.  Each output header records the
current presentation and producing code commit, while replay roots record a
separate source hash and archive path rather than creating a false parent edge
in the mutation lineage.

Completed predicate evaluations also persist a bounded failure shape: the
false-positive/false-negative class, first mismatching row identity and label,
and at most eight values for fields referenced by the candidate.  The daemon
uses that counterexample to target simple ordered-comparison thresholds before
trying the generic mutation family.  The generated constant is the nearest
integer boundary that gives the requested label on that row; overflow yields
no candidate.  Evidence serialization happens immediately.  Ranked candidates
retain only the mismatch-row index, and feature probes are reconstructed only
for the bounded beam selected for expansion.

Expansion first selects outcome-distinct parents, then divides the remaining
candidate budget across them with shares differing by at most one.  An earlier
parent cannot consume a later parent's share; unused capacity carries forward
when a parent has fewer mutations.  This preserves beam diversity without
building a candidate list per parent or increasing the configured global
candidate bound.

Each evaluated child records its exact change from the selected parent under
the same ordering used by the beam: weighted correctness first, then fewer
false positives, then lower semantic complexity.  The record also carries the
rows evaluated, semantic operation count, and their saturating product as a
deterministic evaluation-cost proxy.  The completion summary aggregates
trials, completed and cascade-rejected evaluations, parent comparisons,
improvements, perfect candidates, rows, and semantic-operation rows by the
finite built-in mutation operator label.  Direct and replay roots therefore do
not dilute an operator's parent-relative improvement rate.  Only the previous
generation's bounded expanded-parent scores are retained for lineage joins.
The archive reserves 8 KiB before admitting candidate records and always ends
with a compact summary footer, including on cancellation or candidate
truncation.  Its recorded byte count includes the footer and equals the status
response.  A limit too small for the identity header plus this reserve fails
before writing a partial header.

When parent-relative scorecards exist, every outcome-distinct parent first
receives one exploration slot.  Remaining slots are assigned by a deterministic
max-heap using, in order, the best observed correctness gain per semantic-op
row, false-positive reduction per semantic-op row, parent-relative improvement
rate, diminishing quota, and the exact candidate rank.  Each gain remains
paired with the cost of the trial that achieved it; unrelated extrema are
never combined.  With no parent-relative evidence, allocation falls back to
the balanced shares above.  The summary separately counts exploration,
scorecard-guided, and no-signal balanced slots.

Before assigning those slots, the daemon forms bounded semantic niches from
the mutation operator, the complete false-positive/false-negative error class,
and the base-two bucket of semantic-operation rows.  It admits the best
outcome-distinct candidate from each niche in global score order, up to the
beam bound, then fills remaining beam positions by the ordinary global order.
Every evidence record carries its niche and the summary counts niche and global
elite positions.  A selected elite with an unconsumed deterministic mutation
suffix carries a bounded ordinal cursor into the next generation.  Resumption
skips the consumed prefix, emits only new offspring, and drops the elite after
the finite stream is exhausted.  Fresh candidates precede retained cursors
within the same niche, so resumption cannot displace a newly reached stepping
stone; the summary counts retained positions.
Durable archives preserve the candidate itself for later campaign replay, where
mutation starts afresh under the new campaign identity.

For selected beam parents, the daemon also performs bounded exact hindsight on
proper postfix subexpressions.  It examines longest fragments first, compiles
at most 16 typed predicate fragments per parent, retains at most four with
positive weighted coverage and zero false positives on the complete frozen
batch, examines at most 256 distinct semantics, and records at most 64 accepted
fragments per campaign.  Each
`hindsight-fragment` record contains its source edge, structural semantic hash,
compiled hash, plan, exact coverage, and rows examined.  Such a fragment is an
empirical theorem candidate, not proof authority: records set `trusted` to
false and carry an explicit compatible-batch replay obligation.  Fragment
records consume the ordinary bounded evidence allowance; lack of room rejects
the fragment without truncating candidate search.

Compatible zero-false-positive fragments may be joined by the exact OR rule.
Composition requires identical role, output type, and scope.  Coverage is kept
in an adaptive sparse-index or dense-bitmap representation.  A bounded bitmap
union first rejects pairs that add no weighted positive coverage; only useful
unions are compiled and replayed on the full batch, where any negative hit or
bitmap/weight mismatch fails closed.  The daemon attempts at most 16 new pairs
per generation and 64 per campaign, accepting at most eight per generation
within the shared 64-fragment ledger.  A `hindsight-composition` record names
both semantic parents and the `or-zero-false-positive` derivation rule.  It
remains untrusted pending its recorded replay obligation.

Socket I/O, JSON, evidence serialization, and plan compilation happen outside
worker hot loops.  Uncontrolled solves compile without the control-plane
feature.  Controlled workers retain only the existing coarse safe-point flag;
adding a language binding does not add another search-path check.
