# C1190 — Rel lowering architecture, current design

**Lane:** `ergodis`
**Adopted:** 2026-09-15
**Updated:** 2026-09-24 for C1205
**Decision record:** private `docs/adr/0004-rel-lowering-ir.md`

## Boundaries

```text
Rel source bytes
  → parse and semantic admission (owned compact node pool)
  → lower and normalize (standard-library-only, fixed-capacity RIR)
  → stratified prepared-layer assembly
  → core Datalog admission and Demand evaluation
  → derivation certificate + ranked certificate and two core checks
  → checked typed closure
```

Lowering flattens module names, distributes disjunction, projects existentials,
checks range restriction, records binding columns, stratifies dependencies,
binarizes when selected, and closes a typed value dictionary. The RIR records
relations, source facts, rules, positive and nonpositive literals, join order,
column types, strata, and weighted cost definitions. It is a compact shared
shape for Boolean and weighted routes. The source file compiles independently
in the native/WASM parity harness, so it has no Cargo dependencies and its
passes use the capacities declared by `Workspace::new`.

The Boolean backend in `rel_stratified` groups strata that can share a positive
least fixed point. It splits layers where negation or an aggregate must read a
completed prior closure. A layer builds a core `PreparedSource`; the Demand
plan consumes it directly. The backend materializes negation complements,
comparison filters, and aggregate results as ordinary positive input relations.
It records each materialization's source, domain provenance, tuple count,
digest, and literal use sites. The producer checks the construction records
before returning the ordinary result. Cost-defining expressions use the
separate `rel_weighted` route and its ranked trace certificate.

The old `rel_lowering::project` constructed a second wire program directly
from RIR. It has been retired. `rel_lowering` now provides the typed readout
map and shared diagnostic helper. `rel_wire_export` converts the captured
prepared bytes of an executed layer into the core Datalog wire format. Core
Datalog admission is the fragment gate on each representation. The exporter
compares admitted relation, rule, and fact meaning. It does not equate their
identities: prepared and wire encodings are different. Source fact order,
duplicates, and alpha-renaming of rule variables may change the wire source ID
while leaving admitted meaning equal.

## Nonpositive evidence

Every layer has source-bound derivation and ranked certificates checked by
separate core algorithms. An opt-in evidence call carries original source
bytes, a source digest, frontend policy and limits, external seed descriptors,
canonical prepared bytes and identity per layer, declared relation and input
digests, literal-to-materialization mapping, both encoded certificates, and the
checked readout and final closure. The ordinary result does not carry this
transfer envelope. The offline verifier re-lowers the source, re-admits each
prepared layer, checks both core certificates, reconstructs input provenance,
and rebuilds complements, comparisons, and aggregates with separate set-based
code. It does not call Demand or producer construction routines.

A complement for `not R(t_1, ..., t_k)` is `D_1 × ... × D_k − R`, where each
`D_i` is a singleton for a constant or the union of values from positive body
columns that bind the variable at position `i`. A same-layer derived binding
relation cannot yet supply a complete closure, so that column uses the full
value dictionary. Range restriction ensures all variables are bound. Thus
every tuple a derivation can query lies in the product; excluding all other
tuples is exact. If a column domain is empty, that rule has no binding and
cannot derive a tuple. The construction verifier checks the recorded domain
sources and the complement against checked prior closures.

## Identity and ownership

| Boundary | Owner | Identity or check |
|----------|-------|-------------------|
| Source | Rel caller / evidence envelope | Exact bytes and tagged SHA-256 |
| RIR | Lowering | Canonical fingerprint, re-derived from source |
| Prepared layer | Core Datalog | Prepared source ID over canonical bytes |
| Wire export | Core Datalog | Distinct wire source ID and admitted-meaning comparison |
| Positive closure | Core verifiers | Derivation and ranked certificates |
| Nonpositive inputs | Offline Rel verifier | Tagged construction digests and set rebuild |
| Final readout | Offline Rel verifier | Relation and tuple comparison to checked closures |

The RIR fingerprint helps detect accidental lowering drift; it is not a
cryptographic commitment. Consumers needing a particular source or external
seed set pin those identities independently of the artifact. The dated C1205
Org report records acceptance, adversarial cases, and performance receipts.

## Portability and cost

The standard-library-only frontend and core prepared format are used by native
and WASM routes. The C1205 evidence encoder and offline tool are cold opt-in
paths; they do not add fields to the ordinary `Stratified` closure or per-row
work to the demand evaluator. The exporter performs cold admission and
allocation. The performance gates measure default evaluation, lowering, and
cold evidence work separately against a retained control.
