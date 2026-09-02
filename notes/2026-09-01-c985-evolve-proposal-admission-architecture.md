# C985 Evolve proposal/admission architecture

**Lane:** `complete-ports`

**Status:** design accepted; common envelope and further adapters remain implementation work

**Date:** 2026-09-01

## Decision

Use the optional CSS automorphism-discovery adapter as the reference systems
pattern for Ergodis Evolve:

```text
untrusted proposer
    -> bounded typed proposal
    -> canonical normalization
    -> exact replay of the claimed obligations
    -> role-specific admission
    -> source-bound persistent artifact
    -> compiled allocation-free consumer
```

The proposer is replaceable and has no proof authority. It may be nauty,
AlphaEvolve, an LLM, a stochastic search, a SAT/MIP solver, a domain script, or
another Ergodis campaign. Ergodis owns the semantic checks. A proposal can be
valuable after rejection because its counterexample or measured cost feeds the
next generation, but it cannot prune, merge states, reduce anchors, or support
a certificate until the corresponding admission contract passes.

This generalizes two already-landed boundaries:

- `css_automorphism_adapter` accepts backend-neutral permutation proposals,
  binds them to the exact CSS source fingerprint, and independently admits
  only actions preserving both the physical row space and the observable row
  space while strictly reducing the orbit partition;
- `RankedEvolutionDriver` separates candidate evaluation and parent selection
  from admission, so an inadmissible candidate may remain useful evolutionary
  material without becoming a theorem.

The reusable abstraction is not “run Evolve and trust its answer.” It is a
typed translation-validation boundary around every candidate kind.

## Common protocol

Every proposal family should expose the following logical fields, regardless
of whether its transport is the typed plan language, a compact binary schema,
Python bindings, or a control socket:

1. **Identity.** Schema version, proposer identity/version, source fingerprint,
   canonical payload digest, and deterministic proposal ID.
2. **Resource envelope.** Maximum payload bytes, records, term nodes, degree,
   generators, verifier work, and output work. Bounds are checked before bulk
   allocation or execution.
3. **Intended role.** Diagnostic feature, ordering hint, witness candidate,
   exact reduction, contextual quotient, or structural theorem candidate. A
   weaker role must never be silently promoted.
4. **Typed payload.** A permutation, feature DAG, predicate, decomposition,
   bound, rewrite, witness, or proof composition—not an untyped bag of JSON
   fields.
5. **Claimed obligations.** The exact invariance, equivalence, implication,
   feasibility, dominance, or coverage statements the admission checker must
   replay.
6. **Canonical normalization.** Range checks, stable ordering, deduplication,
   and canonical encodings happen before semantic evaluation. Normalization
   must not erase information needed to verify the original claim.
7. **Admission result.** Accepted role, independently recomputed metrics,
   compact counterexample on failure, verifier version, and fingerprints of
   every dependency.
8. **Persistence.** Create-only/source-bound artifacts with strict trailing-
   byte and version checks. Human-readable syntax may be a view, but one typed
   IR must underlie file, Python, daemon, and CLI paths.

Admission is family-specific. There should not be one generic `verified=true`
bit. A verified witness, verified symmetry, verified necessary predicate, and
verified exact quotient grant different capabilities.

## Context available at each step

Context is deliberately asymmetric. Discovery benefits from broad summaries;
authority requires the complete exact source; the hot consumer should receive
almost none of the campaign context.

| Step | Context available | Context deliberately unavailable |
|---|---|---|
| Campaign controller | problem identity, budgets, prior proposal ledger, compact progress/root histograms, exceptional-state samples, accepted/rejected summaries, literature/user hints | mutable search-worker state, unbounded traces, implicit proof authority |
| Proposer | typed problem schema, permitted grammar, resource limits, selected training/holdout views, compact counterexamples, cost/pruning feedback, optional domain metadata explicitly granted by the adapter | verifier internals as an oracle unless the campaign explicitly studies them; private fields not declared in its schema; live hot memory |
| Candidate scorer | canonical candidate, bounded corpus or probe roots, exact work/cost counters, coverage bitmaps and target labels appropriate to the candidate role | authority to prune; hidden evaluation set when a genuine holdout is required |
| Normalizer | candidate payload, schema/version, source fingerprint, declared bounds and role | campaign history, scores, solver state; normalization is deterministic and context-free beyond its declared inputs |
| Semantic verifier | complete authoritative source/model, normalized proposal, claimed obligations, independent replay/oracle inputs, hard resource limits | proposer confidence, fitness, names, or narrative as evidence |
| Admission policy | normalized proposal, verifier report, capability/role lattice, measured cost and exact coverage, existing admitted artifacts for dominance/conflict checks | raw backend status or unverifiable prose; no role promotion beyond the verified obligations |
| Persistence layer | admitted payload/report, exact dependency fingerprints, schema and verifier versions, hashes, byte limits | live pointers, caches, unbounded logs, or disposable executable paths |
| Cold compiler | admitted typed artifact plus validated source model and pre-sized workspace hints | proposer process, socket protocol, evolutionary archive; it produces the fixed consumer representation once |
| Search worker | immutable compiled representation, worker-owned preallocated state, and at most a guarded validated-plan inbox | proposal syntax, serialization, verifier, archive, strings, allocation, I/O, global mutable counters, or proposer dispatch |
| Feedback reducer | worker-local counters after join, admission failures, smallest counterexamples, compile/verify/search costs, bounded exceptional-state samples | full event streams by default; verbose local traces require an explicit bounded diagnostic request |
| Human/agent view | compact delta brief, top candidates, reasons for rejection, smallest falsifiers, uncertainty and next suggested probes; drill-down by proposal/root ID | automatic transcript dumps or per-node telemetry that swamp attention/token budgets |

Standalone mode uses the same stages with a deterministic built-in proposer and
file-backed ledger. Interactive mode may add literature-derived shapes or steer
the proposer through the control plane, but it does not change admission. A
campaign can therefore run unattended without needing continual model calls,
while an agent can add intelligence at proposal boundaries rather than sitting
inside the search loop.

Training context and verification context must be separately fingerprinted.
For theorem discovery, the proposer may see a selected corpus, while admission
replays against the complete declared corpus and any direct-model holdout. For
symmetry and semantic-equivalence candidates, sampling is useful only for
ranking: exact admission always sees the full defining relations.

## LLM proposer sessions and bounded queries

An LLM proposer should receive a short-lived research session, not direct
access to a solver process. The controller creates a `ProposalSession` bound to
one run, source fingerprint, immutable observation snapshot, permitted proposal
roles, typed grammar version, expiry, and hard query/byte/work budgets. The
session may ask a limited number of pull-based questions before proposing.

The logical protocol is request/response with explicit IDs:

```text
OpenSession
  -> SessionOpened(session_id, snapshot_id, offer, limits)

SubmitQuery(session_id, request_id, query)
  -> QueryAccepted(ticket_id) | Rejected(reason)

QueryCompleted(ticket_id, snapshot_id, compact_result_digest)
FetchResult(ticket_id)
  -> CompactResult | Pending | Expired

SubmitProposal(session_id, proposal_id, role, typed_payload,
               claimed_obligations, query_dependencies)
  -> ProposalAcceptedForReplay(admission_ticket)

AdmissionCompleted(admission_ticket)
  -> Admitted(report) | Rejected(report, smallest_counterexample)
```

`QueryCompleted` is an optional notification. Polling is allowed at a bounded
rate, but the preferred implementation is event-driven notification on the
controller connection followed by one explicit fetch. Search workers never
service requests or wait for results.

The first query vocabulary should remain small and typed:

- `GetProblemSummary`: dimensions, sorts, operators, exact invariants, current
  bounds, and compact work histograms;
- `GetGrammar`: permitted term/predicate/decomposition constructors and their
  static costs;
- `GetProposalLedger`: top admitted/rejected shapes and compact rejection
  reasons, filtered by candidate family;
- `ProbeCandidate`: compile a candidate into a disposable cold evaluator and
  score it on declared probe roots/corpus partitions without admission;
- `CompareCandidates`: same-snapshot paired work/cost/coverage delta;
- `GetCounterexample`: retrieve the smallest retained falsifier for one exact
  candidate or failure-core class;
- `TraceExceptional`: request a bounded trace around a selected exceptional
  state/root/property;
- `SampleStates`: stratified fixed-count state summaries, never raw unbounded
  state dumps;
- `ExplainFeature`: return the typed derivation, dependencies, cost, and
  observed coverage of one persisted feature ID;
- `EstimateVerification`: a conservative resource estimate for replaying a
  proposed obligation.

No query grants shell access, arbitrary file reads, arbitrary code execution,
mutable solver references, or raw memory inspection. The protocol accepts
only validated IDs and typed expressions from the offered grammar.

### Async execution

Probe and trace work runs asynchronously in low-priority controller-owned jobs.
It consumes immutable compiled state, frozen corpus views, or copied bounded
snapshots. Long probes may use separate worker pools with CHOOM/resource caps;
they do not occupy search-worker mailboxes or share mutable counters. A session
may have several outstanding tickets, but deterministic concurrency and work
caps are enforced per run. Cancellation discards a cold job and leaves the
search untouched.

Live traces require a stricter boundary. The controller posts a prevalidated
trace request; at the existing guarded safe point, an eligible worker may copy
one fixed-size record into its worker-owned publication slot. The controller
collects and serializes it off-thread. If no eligible state appears before the
request deadline, the result is `NoMatch`, not permission to add hot polling.

Every result names the `snapshot_id` and exact probe domain. A proposal records
the query IDs it used. Results from different epochs may inform a proposal, but
they are never silently combined into one exact score. Admission always reruns
against the current authoritative source fingerprint; a stale source produces
an explicit rejection or rebase request.

### Default budgets

Budgets are campaign policy rather than protocol constants, but a conservative
initial LLM offer is:

- at most 16 queries and four outstanding tickets;
- at most four candidate probes and two exceptional traces;
- at most 64 KiB of total returned structured data;
- at most 256 trace events or 128 sampled states per query;
- one explicit wall/work allowance per probe and one session expiry;
- at most eight submitted proposal revisions, each with a distinct canonical
  payload digest.

The controller reports remaining budgets after every response. It returns
compact deltas, histograms, feature IDs, and smallest counterexamples rather
than logs. A verbose trace is opt-in, localized, capped, persisted outside the
conversation, and fetched by range or record ID. This makes an LLM session
more token-efficient than repeatedly asking for global status.

### Transport and API

The Rust daemon should expose typed request/response enums over a length-
prefixed local transport. A compact binary encoding is appropriate for the
daemon; the Python 3.14+ client presents frozen typed dataclasses, enums,
`async` methods, async iterators for completion notices, and structural pattern
matching. An LLM tool adapter may project those methods to JSON Schema because
tool-calling systems understand it, but JSON is transport glue only: theorem
and plan payloads remain canonical typed source or typed binary IR.

Unix socket paths include the run ID and an unguessable session nonce. Peer
credentials, source/run binding, expiry, and per-session ledgers isolate
concurrent campaigns. Reconnecting resumes persisted tickets and budgets; it
does not reopen expired authority or expose another run.

### Proposal timing

The LLM need not wait for every ticket. It may submit an early proposal, amend
it with a new digest after later results, or leave unused probes pending until
session expiry. Admission tickets are also asynchronous. The controller may
continue autonomous built-in evolution while the LLM thinks; when an admitted
artifact arrives, normal plan activation policy decides whether and where to
install it. This makes the LLM one opportunistic proposer among several rather
than a synchronous dependency of the solve.

## Proposer selection and operational policy

A cold portfolio controller chooses which proposer receives budget. Correctness
does not depend on this choice: a bad selection wastes bounded cold work but
cannot bypass admission. Eligibility is deterministic—candidate family,
problem schema, required context, authority role, and resource limits must
match—then the scheduler ranks eligible proposers by a cost-aware contextual
value estimate:

```text
P(admission | problem, history, current obstruction)
  * P(operational success before deadline | provider health)
  * expected exact work removed or reach gained
  * expected cross-instance reuse
  / (proposal + probe + verification + integration cost)
  + bounded exploration bonus
```

Inputs are static problem descriptors, the current measured bottleneck,
compact progress and rejection histograms, smallest failure cores, proposer
history on structurally similar problems, interactions with admitted artifacts,
and remaining campaign budgets. Cheap deterministic proposers run before an
LLM unless the observed obstruction specifically calls for a new structural
shape. A cost-aware contextual bandit or successive-halving portfolio may
learn the estimates, while a fixed exploration reserve prevents permanent
lock-in. User/agent overrides are explicit ledgered decisions, not hidden
changes to the policy.

Structural quality and operational health are separate estimates. A provider
throttle, transient transport failure, or temporary latency spike must not
teach the portfolio that the proposer generates bad mathematics. Immediate
selection excludes a provider still under `Retry-After`, a saturated provider,
and a call whose estimated completion lies beyond the absolute deadline. Among
eligible choices, recent operational success discounts expected value while
the admission estimate continues to describe proposal quality. This lets the
controller fail over during backoff and recover the original ranking once the
provider is healthy.

Typical routing is: automorphism/decomposition for excessive roots;
aggregate-bound or contextual-quotient proposals for excessive states;
equivalent presentations for compilation/traversal cost; BP+OSD/ISD for weak
incumbents; conflict-driven feature generation after repeated falsifiers;
certificate-structure proposals for oversized evidence; and LLM/AlphaEvolve
shape generation after cheaper grammars plateau.

### Rate limits and quotas

Limits are hierarchical and all must admit a request:

- campaign-wide concurrent-job, CPU-work, returned-byte, and wall-time budgets;
- per-proposer and per-provider token buckets, preventing one backend from
  monopolizing the controller;
- per-session query, trace, proposal-revision, outstanding-ticket, context-
  byte, and returned-byte limits;
- per-query-family weighted costs, so a trace or exact probe consumes more
  units than a summary lookup;
- per-root and per-snapshot sampling caps, preventing repeated extraction of
  the same live region; and
- separate admission/verifier capacity, reserved so a flood of speculative
  probes cannot starve already-submitted exact checks.

Every response reports the relevant remaining units and reset/expiry time.
Provider `Retry-After` bounds are honored. Limits use monotone controller time
and persist across daemon restart; reconnecting or changing a socket cannot
mint a fresh campaign budget.

Fairness is weighted across active campaigns, with a small reserved lane for
interactive requests and a separate lane for exact admission. Priority may
move queue order but never expand a request's declared resource envelope.

### Timeouts and cancellation

Each operation carries one absolute deadline propagated through queueing,
execution, result storage, and delivery. Distinguish:

- session expiry;
- queue deadline, after which work that never started is dropped cheaply;
- execution work and wall limits enforced by the cold worker;
- result-retention expiry for an unfetched compact result; and
- admission deadline, which may outlive the interactive LLM session but not
  the owning campaign unless explicitly persisted.

Timeouts are selected from recorded cost quantiles plus a safety margin, then
clamped by hard campaign caps. A timeout result records exact completed work
and scope; it is never reported as a completed negative. Cancellation is by
ticket and idempotent. Cold jobs check cancellation at bounded coarse work
boundaries. Search workers do not receive cancellation probes beyond their
already-admitted safe-point mechanism.

Orphaned provider calls and child processes are controller-owned, have process
and memory caps, and are reaped after the deadline. A client disconnect does
not automatically cancel useful work; the session policy says whether tickets
persist for reconnect or are abandoned.

### Error classes, retries, and backoff

Errors are typed before retry policy is chosen:

| Error class | Automatic action |
|---|---|
| Malformed, out-of-range, forbidden role, or failed semantic admission | no retry; return compact diagnostic/counterexample |
| Stale source or snapshot | offer one explicit rebase against the new fingerprint; never silently replay as current |
| Budget/resource limit | no identical retry; proposer may submit a smaller query or request a separately authorized budget change |
| Deterministic backend failure | no retry for that payload/backend version; retain failure signature |
| Transient transport/provider failure | bounded exponential backoff with full jitter and idempotent request ID |
| Provider rate limit | honor `Retry-After`, debit no duplicate logical query, and allow another proposer to use the slot |
| Queue or execution timeout | at most one policy-approved retry with a reduced scope or larger already-authorized deadline; never blindly repeat expensive work |
| Backend crash or repeated protocol fault | open the backend circuit breaker and fail over when another eligible proposer exists |

Backoff state is keyed narrowly by provider/proposer and error class, not by
the whole campaign. A typical transient schedule is 250 ms, 500 ms, 1 s, 2 s,
then capped at 30 s with full jitter and a small total retry count. Server-
supplied lower bounds override it. Retry budgets are separate from query
budgets but bounded, so failures cannot multiply spend indefinitely.

Circuit breakers open after a small rolling threshold of attributable failures
or timeouts. The open interval grows to a cap; one half-open health/probe call
tests recovery. Successful exact traffic closes the breaker. A
semantic rejection, provider throttle, or controller queue delay is not a
backend-health failure and must not trip the breaker.

Every mutating request has an idempotency key derived from session, request ID,
canonical request-schema identity, and canonical payload digest. The controller
deduplicates accepted work and
returns the original ticket/result on retry. Proposal revisions require new
payload digests. Artifacts use create-only writes and atomic publication, so a
timeout or crash cannot leave a partially authoritative object.

The implemented `ProposalIdempotencyKey` is a stable 32-byte BLAKE3 identity
over a versioned domain separator, bounded session ID, nonzero request ID,
schema identity, and canonical payload digest. The daemon ticket ledger
enforces create-once lookup and returns the original typed result.

### Overload behavior

On overload, reject or defer cold speculative work first, then reduce proposer
concurrency and trace/sample sizes. Never slow the solve hot loop, increase its
safe-point frequency, allocate larger worker mailboxes, or turn on busy polling.
The controller can keep autonomous cheap proposers running while an external
LLM/provider is backed off. Operational telemetry is aggregated by proposer,
query family, error class, latency bucket, and consumed budget; it is serialized
off-thread and exposed as compact deltas rather than request logs.

### Typed request registry

Large provider inputs remain streamed artifacts, but they are no longer
semantically opaque. A bounded controller registry advertises content-derived
schema descriptors at session open. Each identity commits the logical name,
version, encoding, byte cap, role mask, and optional canonical provider
allowlist. Submit, durable ticket state, idempotency, claim, and the Python
invocation all carry that identity. The daemon validates the envelope before
charging and revalidates the durable ticket at every runnable claim. There is
no unknown-schema fallback.

The registry is the extension seam for hosted SDKs and new proposer languages:
add a descriptor and an adapter-side decoder, not a new transport operation.
The standard descriptor is a versioned byte stream so command and local-
process providers remain usable; embedding controllers may install typed-plan
and canonical structured descriptors.

The reusable hosted-SDK wrapper now supplies the common execution half of that
seam. A vendor translation accepts one typed invocation and one already-open
request stream, performs one attempt, and returns a closeable async byte stream.
The wrapper schema-gates the call, caps chunks and aggregate bytes, writes an
anonymous disk-backed result, and bounds closure on cancellation. Vendor code
only normalizes its error taxonomy and response events; it cannot own retry,
deadline, rate, or circuit policy. No vendor SDK is a core dependency.

### Implemented cold policy boundary

The first reusable policy slice now lives in the feature-gated control module.
It supplies persisted-remainder token buckets driven by caller monotone time;
typed retry actions with full jitter, provider lower bounds, and absolute
deadlines; a single-probe half-open circuit breaker; and a deterministic
portfolio selector. The selector gates context, authority role, tokens,
concurrency, bytes, cost, circuit state, and deadline before comparing checked
expected admitted work/reuse per cost plus a bounded exploration bonus.
Operational success is priced separately from mathematical admission quality;
active retry deferrals and estimates that cannot complete before the deadline
are ineligible.
Duplicate proposer IDs, invalid probability scales, and score/comparison
overflow fail closed. Stable logical-request idempotency keys bind session,
request number, schema identity, and canonical payload digest. Selection is advisory. The
implemented all-or-none hierarchy first previews each campaign/provider/session
bucket at one monotone timestamp and debits only after every weighted cost is
admitted; the controller reselects if that charge fails. A hostile pass repaired clock reversal being mistaken
for ordinary rate limiting and unchecked rational-score cross products.

This is policy, not a new daemon operation. Persisted controller state,
idempotent ticket-ledger lookup, provider adapters, and asynchronous result delivery
remain the integration boundary. Search workers and existing socket operations
are unchanged.

The next quota layer is also implemented as a bounded, snapshot-replayable
`ProposalSession`. It retains every logical query identity after completion or
cancellation, so neither reconnect nor retry refunds the declared work/return
reservation. The ledger enforces permitted authority roles, absolute session
expiry, total queries, concurrent outstanding queries, total work, total
returned-byte reservations, and distinct proposal revisions. Reusing the same
identity or proposal digest is idempotent only when its role and declared
resource envelope are identical. Restore reconstructs query counts, outstanding
count, and charged totals instead of trusting serialized summaries.

Session state is now atomically published in a private, run/source-bound store
and composed with the durable ticket store. The transaction order is quota
reservation first and ticket publication second. Each reservation retains the
exact ticket specification and its original controller timestamp, so restart
can reconstruct a missing ticket without inventing provider, role, cost, byte,
or deadline data. A ticket without a matching reservation is impossible under
that order and fails closed. Reconciliation also converts ready, failed,
cancelled, and expired tickets into the corresponding session settlement, while
completion and cancellation deliberately do not refund total budgets. Bounded
crash temporaries are tolerated; malformed snapshots, swapped session/source
bindings, reversed clocks, loose permissions, and ambiguous writes fail closed.
The composed store is now reachable through typed bounded operations on the
existing authenticated campaign socket: session open, submit, status, worker
claim/failure/complete, cancel, ready-result metadata, and revision reservation.
The daemon, not the provider, owns monotone timestamps, idempotency derivation,
deadline construction, retry jitter, and the fixed bounded retry policy.
Session and per-operation hard caps are validated before durable work, and a
socket-level control replays the complete open/submit/claim/complete/fetch
lifecycle. This remains protocol mechanics rather than a provider adapter:
new socket submissions now atomically charge campaign/provider/session request-
rate buckets, and exact duplicates bypass both rate and quota debit. Because
absolute deadlines are server-derived from relative timeouts, duplicate
recognition reconstructs the original durations from the persisted creation
time; the same identity with a changed role, provider, work, bytes, or timeout
envelope fails closed. The buckets are process-local until daemon resume lands.
Claim now returns a deterministic run-relative upload path. The worker streams
the result into that private create-only file; completion carries only the
ticket and attempt. The daemon independently enforces the byte cap, hashes and
copies through a fixed 64 KiB buffer, fsyncs, and publishes a read-only result
artifact. Fetch re-hashes it against durable ticket metadata. Thus neither the
control frame nor the Python binding buffers a complete result, and provider-
supplied size/digest metadata has no authority. Typed `ergodisctl proposal-*`
commands project the full lifecycle; the dependency-free Python 3.14+ binding
mirrors it with frozen slotted session/ticket objects, `StrEnum` roles and
failures, validated keyword-only resource envelopes, native synchronous/
`asyncio` Unix-socket calls, and bounded streamed completion.

The operational policy is deliberately split into three accounting layers.
Logical query/revision/work/return-byte reservations are durable and never
refunded by reconnect, cancellation, or retry. Attempt retries retain their
typed action, exact `not_before` time, and owning deadline in the durable
ticket. Admission-rate token buckets are now published as one private source-
bound campaign/provider/session snapshot after every all-or-none debit. Exact
refill remainders and monotone timestamps survive reopen; duplicate entries,
binding drift, loose permissions, capacity overflow, and reversed clocks fail
closed, while ambiguous replacement poisons dispatch. Attaching restored
proposal sessions to a resumed campaign remains separate from the now-durable
rate store. A real provider-neutral worker adapter must consume the ticket
actions rather than invent a second timeout/backoff policy.

Per-provider circuit state is now integrated into the same durable store and
authoritatively gates claims. Attributable operational failures open bounded
exponential intervals; non-health failures leave the circuit alone. Once the
interval passes, a single persisted half-open lease is bound to the exact
ticket key. Competing tickets receive typed deferral/busy responses. Success
closes the circuit, another attributable failure reopens it, and cancellation
or expiry releases only the matching lease. A hostile pass caught and repaired
the otherwise permanent-lock failure of persisting only an unowned half-open
Boolean; restore now requires lease/Boolean agreement.

That adapter now exists in the Python 3.14 binding. `ProviderRunner` invokes an
arbitrary async backend exactly once per daemon-claimed attempt, enforces the
ticket's absolute execution deadline with structured cancellation, translates
typed backend errors/`Retry-After`, timeouts, transport errors, and crashes into
the existing failure vocabulary, and follows only the resulting durable ticket
state. Retry-wait sleeps once to the recorded `not_before_ms`; busy and terminal
claims return without polling. Successful attempts return a binary stream and
reuse bounded artifact completion. Concrete SDK translation, payload/context
delivery, and reaping SDK operations that ignore cancellation remain explicit
backend responsibilities rather than generic retry policy.

The first concrete backend translation is deliberately provider-independent:
an argv-only command adapter streams a bounded private request file to stdin,
pumps stdout to a disk-backed anonymous file under a private run directory,
caps stderr, maps configured temporary exits into typed transient failures, and
kills/reaps the isolated process group on timeout cancellation. It invokes no
shell and introduces no SDK dependency. Local LLMs, hosted-provider wrappers,
SAT/MIP programs, or domain scripts can therefore share the same runner. The
next transport gate is daemon-owned typed request/context artifacts so the
callback need not obtain its immutable input out of band; a hosted SDK adapter
then becomes a thin optional package rather than core policy.

That request gate is now implemented. A session exposes one private
run-relative upload directory; Python streams a nonempty bounded request to a
deterministic request-ID path. Submission carries only the canonical digest and
measured length. The daemon independently verifies and atomically publishes a
read-only request, persists digest/length in the ticket, and revalidates the
artifact on every runnable claim. The runner confines the returned path to the
authenticated run before constructing `ProviderInvocation`; the command
adapter consumes it directly. No input or output payload is buffered in a JSON
frame or one byte vector. Typed payload schemas above these opaque canonical
bytes and an optional hosted SDK package remain the next layers.

The next generic slice now implements the in-memory/persistable ticket state
machine without adding wire operations. Its fixed ticket identity makes submit
create-or-return-existing and rejects a conflicting normalized spec. Explicit
attempt numbers prevent stale asynchronous callbacks from completing a later
retry, while duplicate completion/failure callbacks return the recorded
outcome. Retry-wait stores the typed action as well as the failure, so replay
does not reroll jitter or reinterpret `Retry-After`. Snapshot restoration is
strict: the configured cap must equal the persisted cap, IDs are unique,
timestamps and retry transitions are revalidated, and overdue queue/execution/
retention states expire at restore time. Admission expiry and result-retention
expiry remain separate, preserving late diagnostic retrieval without permitting
late theorem admission.

The remaining daemon boundary is deliberately narrower: attach the snapshot to
a bounded create-only/atomic campaign artifact, persist-before-dispatch and
persist-before-acknowledgement, reconcile restored running attempts after
orphan reaping, and then expose bounded submit/status/cancel/result operations.
No provider-specific payload belongs in the generic ticket record.

The durable store portion is now implemented without whole-ledger rewrites.
Private create-only metadata pins the store/ticket schema and configured cap;
each ticket has one bounded key-named compact record. Creation uses a fsynced
temporary file and atomic hard link, replacement uses a fsynced temporary file
and atomic rename, and the containing directory is synced. Replay rejects
symlinks, wrong names, oversized/corrupt records, excess capacity, and cap or
schema drift. A bounded number of crash-leftover temporary files is tolerated,
their sequence numbers are not reused, and restore-time deadline transitions
are persisted immediately. Any ambiguous persistence error poisons the live
store: the daemon must stop and recover rather than dispatch against memory-
only state. Campaign attachment, orphan reconciliation, and wire operations
remain open.

## Runtime and performance boundary

Proposal generation, normalization, serialization, counterexample reduction,
and verifier diagnostics are cold work. An admitted proposal is compiled once
into the existing fixed-capacity representation before search. The solve hot
loop remains allocation-free, nonrecursive, and free of I/O or proposer
dispatch.

If a proposal changes search work, admission requires exact verdict/witness
parity and an independent replay boundary. If it changes the hot loop, it also
requires the Ergodis one-/parallel-mode counter A/B and zero-allocation gates.
If it only changes ordering, stale or rejected advice may add work but may not
change correctness. Runtime steering swaps only already-validated, preallocated
plans at guarded safe points.

The proposer receives bounded feedback rather than raw traces: admission
status, exact work reduction, compile/memory cost, smallest counterexample,
coverage bitmap digest, and a compact exceptional-state sample. This keeps the
loop useful to an automated daemon or an interactive agent without producing
token- or I/O-scale transcripts.

## Highest-value proposer inventory

Ranked by expected near-term leverage for Ergodis, not by general novelty:

| Rank | Proposer | Candidate | Exact admission obligation | Expected value |
|---:|---|---|---|---|
| 1 | Equivalent-presentation proposer | row bases, check orders, variable orders, static tie orders | identical accepted solution/witness set under exact row-space or model equivalence | Immediate compile/search reductions on large CSS exhaustion; LP1768 already shows depth-growing gains |
| 2 | Automorphism/action proposer | coordinate, state, factor, or constraint generators | bijection plus preservation of every physical and observable relation | Directly reduces roots/anchors; already joins BB288/BB360 from two orbits to one |
| 3 | Aggregate-bound proposer | packing, residual hitting, moment, residue, parity, character-sum, or cut inequalities | one-sided implication checked against the exact model, with replayable bound witness where applicable | Theorem-driven node removal; residual hitting and parity bounds already dominate local micro-optimization |
| 4 | Decomposition/interface proposer | separators, component cuts, join trees, boundary alphabets, elimination orders | exact composition equivalence and witness lift | Extends Ergodis beyond flat search and can reduce both state count and memory through smaller interfaces |
| 5 | Contextual-quotient proposer | candidate signatures, congruences, state merges, abstract domains | indistinguishability for the admitted continuation class plus congruence under every composition operator | The core cross-domain thesis; potentially orders-of-magnitude state reduction |
| 6 | Feature/theorem proposer | typed term DAGs, predicates, implications, scoped decision lists | full-corpus replay, held-out/direct-model replay, zero false positives for sound roles, and explicit scope | Turns Evolve into theorem discovery rather than parameter tuning; current raw-DAG and archive machinery is ready |
| 7 | Incumbent/witness proposer | BP+OSD, ISD, local search, MIP/SAT solutions, learned policies | independent feasibility and observable replay only | Cheap upper bounds tighten exact search; never grants optimality or negative coverage |
| 8 | Certificate-structure proposer | repeated proof motifs, branch DAGs, structural lemmas, rewrite/composition plans | expansion to the original certificate plus independent replay | Converts large computational evidence into smaller structural results and cheaper verification |
| 9 | Counterexample/attack proposer | adversarial instances, separating contexts, mutation tests, exceptional states | exact reproduction against the claimed rule or verifier | High leverage for hardening theorem candidates and focusing conflict-driven synthesis |
| 10 | Backend/encoding proposer | SAT/MIP/CP encodings, specialized propagators, semiring/tensor contractions | bidirectional solution/witness translation and objective preservation | Broadens application reach while preserving Ergodis as semantic compiler/certifier |

## First implementation sequence

1. Define a small generic cold `ProposalEnvelope`/`AdmissionReport` substrate
   with typed payload traits, strict limits, source fingerprints, and canonical
   digests. Do not make it a universal serialized enum.
2. Adapt automorphism proposals without changing their current artifact bytes;
   this is the compatibility control.
3. Add equivalent-presentation proposals as the second family, because current
   LP1768 presentation autotuning supplies exact performance and replay tests.
4. Route feature-DAG proposals through the same lifecycle while preserving the
   existing `RankedEvolutionDriver`, Pareto/Dalmatian archive, failure cores,
   and separating front.
5. Expose the lifecycle through the typed plan/Python/control surfaces. JSON is
   allowed only as an optional external view, not as the internal theorem
   language.
6. Add proposer feedback records and deterministic replay tests before any
   autonomous daemon loop uses the interface.

The first two adapters are intentionally different: automorphisms prove model
invariance, while presentation candidates prove equivalent semantics but may
change traversal cost. If one common substrate expresses both without merging
their authority roles, it is general enough to admit the remaining proposer
families incrementally.

## Safeguards

- Never admit from score, corpus perfection, proposer confidence, or backend
  status alone.
- Never let a source fingerprint stand in for semantic replay.
- Never let an exact witness imply optimality or a necessary condition imply
  sufficiency.
- Preserve rejected candidates and their compact counterexamples so Evolve
  does not rediscover known failures.
- Measure compile cost, retained bytes, verification cost, exact work removed,
  and hot-loop cost separately; a proposal with fewer states can still lose.
- Keep private campaign semantics and C-task identities outside public Ergodis.

## Acceptance gate

The architecture is realized, rather than merely documented, when one common
cold lifecycle supports at least automorphism, equivalent-presentation, and
feature-DAG proposals; each family rejects a forged source, forged semantic
claim, malformed bounds, and role escalation; accepted artifacts replay after
restart; and their compiled consumers retain the existing hot-loop performance
contracts.
