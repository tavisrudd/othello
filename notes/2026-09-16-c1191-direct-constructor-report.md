# C1191 — the direct constructor from the relational IR into the demand evaluator's prepared form

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none.

Task card: `2026-09-16-c1191-direct-constructor.md`. Decision record: private
`docs/adr/0004-rel-lowering-ir.md`, whose "direct constructor into the demand evaluator's prepared
form" is what this task builds. Predecessors: `2026-09-15-c1190-milestone-c.md` (the design note
"Designing for the direct constructor"), `2026-09-15-c1190-per-column-domains.md` (the 96 per cent
encoding finding and the boundary experiment), `2026-09-15-c1190-milestone-b.md` (layer programs and
complement records). Repositories: `~/src/ergodis` (core) and `~/src/ergodis-private` (driver).

## Arms

Filled in as each is retained. Every hash is recorded **as measured**, never cited: the thing to run
is the retain recipe at the named revision.

| Arm | Repository | Revision | Dirty | Retained name | rustc | Measured sha256 |
| --- | ---------- | -------- | ----- | ------------- | ----- | --------------- |
| control, harness A/B | `ergodis-private` | `b7c624d` | no | `ergodis-tools-b7c624d` | 1.95.0 (59807616e 2026-04-14) | `15f7c83aba28c3732b53854226e97809e80da2737073439c1b92bf7ff5bf7e2c` |
| harness, and control of the constructor A/B | `ergodis-private` | `3778763` | no | `ergodis-tools-3778763` | 1.95.0 (59807616e 2026-04-14) | `c3bc2ba80ba7851a4b66b520540f07d83ca9ca4fcf0029989cddb98ec30f6dad` |
| candidate | `ergodis-private` | `8191ab7` | no | `ergodis-tools-8191ab7` | 1.95.0 (59807616e 2026-04-14) | `efbb5987e56edfe95c439ed5d3bc12e1a86a9f9a7a76d83193848b213b7a7ca1` |

Every arm is `ergodis-tools`, `release`, no features, built through the retain recipe below, which
re-executes itself inside `nix develop` of the core checkout so the toolchain is the
`rust-toolchain.toml` pin. Every tree was clean. `ergodis-private` depends on `~/src/ergodis` by
path, so the candidate arm also carries core revision `2517852`; the two control arms carry core
`3c3e7f8`, the revision before this task's core commit.

Retain recipe for every arm, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

which re-executes itself inside `nix develop` of the core checkout, so the toolchain is the
`rust-toolchain.toml` pin.

## Commits

| Repository | Commit | What |
| ---------- | ------ | ---- |
| `othello` | `715fff0` | this report's skeleton and the Fermi predictions, written before any code |
| `ergodis-private` | `3778763` | the `stratify` bench stage; `bench.py` records the load average and the counter enabled fraction |
| `ergodis-private` | `30cebc2` | the harness A/B receipt against the `b7c624d` control |
| `ergodis` | `2517852` | `Demand::from_prepared`, `datalog::admit_prepared`, the flat fact pool in `Admitted`, both checkers' admitted-form entry points, the prepared-constructor test suite and the constructor allocation regression |
| `ergodis-private` | `1c7e42c` | every layer built through the prepared constructor; `Budget::LayerTuples` for `Budget::ProgramBytes`; `LayerReport::layer_values` for `program_bytes` |
| `ergodis-private` | `8191ab7` | `Error::LayerCapacity` names the evaluator's row capacity; `rel-lower --values` lets a boundary probe raise the lowering workspace |

## Fermi predictions, written before any code

These are written from the per-column report's byte decomposition (about 44 bytes fixed plus about
1 byte per value in a materialized fact's canonical JSON, of which the tuple is about 4 per cent),
from milestone (c)'s boundary measurements (153, 302, 84 and 213 dictionary entries on four cohorts,
all at about 22,000 materialized facts in one layer), and from reading the core's bound constants.

### 1. Which bound binds after the serialization is gone, and where the boundary lands

Today a layer is refused by `Budget::ProgramBytes`: the canonical JSON of one layer's `Program`
against the core's `MAX_BYTES` of 1,048,576. Nothing in the prepared path serializes, so that
refusal has nothing to check and is replaced by whichever declared bound binds first. The candidates,
with the dictionary size `d` each admits on a cohort whose negated relation has arity two and both
columns over the whole dictionary:

| Bound | Value | Checked against | Largest `d` at arity two |
| ----- | ----: | --------------- | -----------------------: |
| `MAX_COMPLEMENT` (this route's own) | 2^22 = 4,194,304 | `∏ᵢ \|Dᵢ\|` per negated literal | **2,048** |
| `MAX_INDEX_KEYS` (core) | 2^24 = 16,777,216 | `domain^arity` of an indexed relation | 4,096 |
| `MAX_UNIVERSE` (core) | 2^30 | `domain^arity` of any relation | 32,768 |
| `MAX_DOMAIN` (core) | 65,536 | the declared domain | 65,536 |

**I predict `MAX_COMPLEMENT` is the bound that binds on `stratified`, at a dictionary of about
2,048**, against today's 153 — a factor of about **13.4**, which is the order of magnitude the
per-column closeout priced this lever at (it predicted "roughly 10×, to a dictionary of about 1,000
at arity two with whole-dictionary columns", so I predict it was right in order and about twice
conservative). On `columns`, whose two columns are disjoint halves, the same bound is
`(d/2)² ≤ 2^22`, so I predict about **4,096** against today's 302. On `columns3`, arity three, the
close pass checks `d³` against `MAX_INDEX_KEYS` for an indexed relation before the complement bound
can fire, so I predict **`MAX_INDEX_KEYS` at about 256** against today's 84 — a different bound on a
different cohort, and the first time on this route that the *core's addressing* rather than this
route's own materialization budget decides the reach. For the `aggregate` cohort's comparison filter,
`MAX_FILTER` is also 2^22 and the filter is `N(N−1)/2` over `|D₀|·|D₁| = N²` candidates, so I predict
the refusal at a key set of about **2,048** against today's 213.

The general statement I predict the measurement supports: **removing the serialization moves the
route's ceiling from about 22,000 materialized facts in one layer to about 4,000,000**, and what
binds after that is a declared materialization budget rather than an encoding.

### 2. What one materialized fact costs to hand the core, before and after

Today, per fact: a `Fact` with an owned relation `String` (one allocation plus a copy of about 20
bytes) and an owned `Vec<u32>` tuple (a second allocation); `encode_source` serializing about 45
bytes of JSON; SHA-256 over those 45 bytes; then `datalog::admit` re-resolving the relation name
through a `BTreeMap<&str, u32>` (a handful of string comparisons), re-checking every value, and
cloning the tuple into a third allocation inside `AdmittedFact`; then `Demand::new` copying the
tuple a fourth time into the per-relation `initial` vector and a fifth into the boxed slice. SHA-256
costs on the order of 17 instructions per byte here, so the hash alone is about **760 instructions
per fact**; I estimate the whole per-fact boundary cost at **600 to 1,200 instructions**.

In the prepared path, per fact: one store of `arity` words into a presized flat pool, a sort key, and
SHA-256 over `4·arity` bytes — about **140 instructions of hashing at arity two** and perhaps 40 of
everything else. I predict the per-fact boundary cost falls to **150 to 250 instructions**, a factor
of **4 to 6**, and that the hash is the dominant surviving term in both.

### 3. What the measured stage shows

The existing `rel-frontend-bench` stages stop at `lower`, the frontend's lowering into the relational
IR; no stage runs the stratified backend at all, which is why milestone (c) could measure a cohort at
512 definitions that the backend refuses at 214. **The candidate is therefore invisible to the
existing stage set**, and the first thing this task must build is a `stratify` stage that runs the
layer chain. That stage is harness work, so it is committed and a control retained at that revision
*before* the constructor is written, and the harness commit itself gets a parity A/B against
`ergodis-tools-b7c624d` showing `scan`, `parse`, `admit` and `lower` did not move.

I predict, on the `stratify` stage: `datalog` (purely positive, 513 input facts, no complement) down
**10 to 25 per cent**, because its boundary cost is the input facts only and its evaluation dominates;
`stratified` (three complements over a dictionary of 512 at the bench's 512 definitions) down **40 to
70 per cent**; `aggregate` down by a similar fraction; and the three cohorts that never reach the
backend at **1.000 within the nulls**. I predict `scan`, `parse` and `admit` at unity to within about
ten parts per million, and `lower` likewise, with the standing caveat this lane has now recorded five
times: the workspace builds with thin LTO and one codegen unit, and a swing of a few tenths of a per
cent on a cohort that cannot execute the change is code layout, which I will not read as a win or a
loss.

### 4. Memory

I predict the prepared path **reduces** peak resident set at the boundary, because the layer no
longer holds a serialized copy of itself: today a layer at the boundary materializes about 22,000
facts as `Fact` records (roughly 60 bytes of `String` and `Vec` headers plus two heap blocks each,
call it 120 bytes per fact, about 2.6 MB) and then a 1 MiB `Vec<u8>` of JSON. The prepared path holds
`4·arity` bytes per fact in one flat pool, about 176 KB at the same fact count. I predict peak RSS at
a fixed dictionary size falls by **1 to 4 MB** on the negation cohorts and is unchanged on the
cohorts that do not reach the backend. At the *new* boundary the absolute figures will of course be
far larger, and I predict I report them rather than only the ratio, which is the per-column audit's
one substantive finding about reporting.

### 5. Where the risk is

Not in the arithmetic: a prepared `Demand` either builds the same `RelationPlan`, `Step` and `Index`
structures as `Demand::new` or it does not, and the differential decides that. The two places I
expect to be wrong first are (a) **what a prepared `Demand` answers for `source()`**, because both
independent checkers take a `&Program` and a prepared `Demand` has none, so either the checkers grow
an admitted-form entry point or the prepared path loses its checkers — and losing the checkers would
lose the whole evidence chain this route rests on; and (b) **the fact identity**, because
`Demand::new` keeps facts in program order with duplicates recorded by index while a prepared source
has no program order at all, so the prepared source identity has to be defined over a canonical
*set* if it is to be stable under a re-ordering of supplied tuples. I predict at least one
instructive negative in each.

### 6. Expected differential disagreements

Zero, and for a reason that is weaker than milestone (b)'s: the prepared path is a second
construction of the *same* `RelationPlan`/`Step`/`Index` structures from the same information, not a
different reading of a construct, so the only way it can disagree is by building them wrongly. That
makes a deliberate mutation the load-bearing evidence rather than the corpus, and I predict I will
have to say so.

## Status

Built and gated; measured. A layer of the stratified backend is now handed to the demand-driven
evaluator as a **prepared source** — relations by index, atom arguments as resolved slots, and each
relation's tuples as a flat slice the driver already owns — instead of as a serialized
`rule_contract::Program` with one owned `Fact` per tuple. Nothing per tuple is allocated, no relation
name is resolved, nothing is serialized, and the one-mebibyte encoding budget that decided this
route's reach is gone. The core rule contract, `Demand::new`, `encode_source`, `identity_of` and
every existing certificate are unchanged.

## Design, and the shapes not built

### The core: one admitted form, two ways in

`ergodis_verify::datalog` gains `admit_prepared`, which takes a `PreparedSource`:

```rust
pub struct PreparedSource<'a> {
    pub domain: u32,
    pub relations: &'a [PreparedRelation<'a>],  // name, arity, input
    pub rules: &'a [PreparedRule<'a>],          // head and body atoms of resolved Slots, variables
    pub facts: &'a [&'a [u32]],                 // one flat slice per relation, stride its arity
}
```

`ergodis_rules::Demand::from_prepared` admits it and runs the **same preparation body**
`Demand::new` runs — `RelationPlan`, the semi-naive `Step`s and the `Index`es are built once, in one
function, from an `Admitted` however it was admitted. Every budget is enforced through the same
`Error` values over the same constants (`MAX_DOMAIN`, `MAX_RELATIONS`, `MAX_RULES`, `MAX_ARITY`,
`MAX_BODY`, `MAX_VARIABLES`, `MAX_UNIVERSE`, values below the domain, identifier spelling, duplicate
names, a head over an input relation, a head variable no body atom binds). `MAX_BYTES` has no
prepared counterpart, because nothing is serialized.

Three decisions inside that are worth stating because each could have gone the other way.

**Variable numbering is canonical and checked, not accepted.** A prepared rule's variables must be
numbered from zero by first occurrence in body order, then head order — the numbering `admit`
derives from a wire program. A rule that numbers them any other way is `Error::Source`. The
alternative was to accept the producer's numbering, which would have made one rule have several
prepared forms and therefore several identities. The cost is a renumbering pass in the driver, which
is a linear scan of at most eight entries per literal.

**The identity is hashed over the tuple *set*, not the supplied order.** Admission sorts and
deduplicates each relation's tuples before hashing, so a producer that emits the same tuples in
another order, or emits one twice, prepares the same source. The encoding is streamed into SHA-256
through a fixed 512-byte stack window rather than a serialized buffer; the tag
`finite-boolean-prepared-rules.v1` domain-separates it from `identity_of`, whose tag is the wire
schema. **The two identities differ and are meant to**: a certificate of a prepared source binds to
the prepared source.

**`Admitted` now holds its facts' tuples in one flat pool** with a 12-byte record per fact, instead
of an owned `Vec<u32>` per fact. That is what lets a prepared source of a million tuples cost one
allocation rather than a million, and it removes the same per-tuple allocation from the wire path,
where it was never necessary either.

### The core: what a prepared `Demand` answers for `source()`

`Demand::source()` returns `Option<&Program>` and a prepared plan answers `None`. The three
candidates the card names were an `Option`, a reconstructed `Program` on demand, and a documented
refusal; the `Option` is the one taken, because reconstructing a program would invent a wire form
whose identity is not the one the certificates bind to, and a refusal would lose a caller that has a
wire program and wants it back. No caller of `Demand::source()` existed, in either repository, so
the signature change costs nothing today.

The consequence that mattered and nearly went wrong is the **checkers**. Both of the core's
independent checkers take a `&Program`, and losing them for a prepared source would have thrown away
the evidence chain this whole route rests on. `derivation` and `ranked` therefore each gain a
`check_admitted` entry point that reads the admitted source directly; the `&Program` entry points are
unchanged and still admit the source themselves. `Demand::verify` and `Demand::verify_ranked` hand a
wire program to the `&Program` checker exactly as before and take the admitted door only when there
is no wire program, so **the wire path re-admits its source twice and the prepared path admits it
once**. That asymmetry is recorded under deviations rather than glossed.

### The driver: what the layer loop does now

`src/rel_stratified.rs` assembles each layer as parallel `names`/`arities`/`inputs` vectors, a
`rows_from` vector saying where each declared relation's tuples come from — a certified closure the
driver already holds, or the *k*th vector one of the layer's own constructions produced — and a slot
pool for the rules. Nothing is copied: `complement_over`, `filter_over` and `aggregate_over` already
returned flat `Vec<u32>` of tuples (milestone (c) made sure of it), and those vectors become the
prepared source's fact slices directly. The `Fact` records, the per-tuple `String`, the per-tuple
`Vec`, the `atom_named` indirection through relation *names*, and the `encode_source` byte check are
all gone; relations are addressed by index throughout, and each record carries the index of the
relation the layer declared for it (`declared`).

`Budget::ProgramBytes` is replaced by `Budget::LayerTuples` against `MAX_LAYER_TUPLES`, and
`LayerReport::program_bytes` by `LayerReport::layer_values`. The two are not the same quantity in
different units: the old figure was JSON bytes, of which the per-column audit measured about 96 per
cent to be the relation name repeated and the `relation`, `tuple` and `cost` keys; the new one counts
tuple values and nothing else.

### Shapes considered and not built

1. **A `MAX_LAYER_TUPLES` set high enough never to bind, or no layer bound at all.** Rejected: a
   layer may declare up to `MAX_RELATIONS` relations and each complement may be `MAX_COMPLEMENT`
   tuples, so an unbounded layer is an out-of-memory failure where a refusal belongs. The bound is
   set to `MAX_COMPLEMENT`'s own value — a layer may materialize as many tuples as one negation may —
   and is checked against the *projected* total before each construct is enumerated, so the refusal
   carries its numbers and nothing large is built first.
2. **Keeping `Demand::source()` returning `&Program` by reconstructing one.** Rejected above.
3. **Routing the prepared path through `Demand::new` by building a `Program` and skipping only the
   serialization.** Rejected: the `Fact` per tuple, the name resolution and the per-tuple clone
   inside admission are most of the cost, and `MAX_BYTES` would still have to be dealt with
   separately.
4. **Making the prepared identity equal the wire identity of the same program.** Rejected: it would
   force the prepared path to serialize, which is the whole thing being removed. The two identities
   differ, the report says so, and the differential compares closures rather than identities.
5. **Deleting the serialized projection.** Not done. `rel_lowering::project` — the single-program,
   whole-`Program` projection of milestone (a) — is untouched and still available to any consumer
   that genuinely needs a wire program: an export, an external checker, or a reader that wants to
   decode the program back. Nothing in the stratified driver uses it any more, and one lowering
   fixture still exercises it.

## Method

### The measured stage had to be built first

Every existing `rel-frontend-bench` stage stops at `lower`, the frontend's lowering into the
relational IR. **No stage ran the stratified backend at all**, which is why milestone (c) could
measure the `aggregate` cohort at 512 definitions while the backend refused it at 214: the two were
measuring different things. The candidate is entirely in the backend, so it was invisible to the
stage set.

The first commit of this task therefore adds a `stratify` stage — parse, admit, lower, then
`rel_stratified::evaluate` over every layer, with each layer's evaluation, derivation certificate
and both of the core's independent checkers — and its record carries a SHA-256 over every relation's
certified rows, so the receipt itself is evidence that two arms building a layer by different routes
establish the same closure. The stage difference `stratify` minus `lower` is the backend boundary.

That commit is harness work, so it was made and a control retained at its revision **before** the
constructor was written, and the harness commit got its own parity A/B against
`ergodis-tools-b7c624d` on the stages that already existed. The playbook requires that: the
workspace builds with thin LTO and one codegen unit, and this lane has recorded five swings of a
few tenths of a per cent from adding code a cohort cannot execute.

### The two repairs the receipts had been missing

`bench.py` now records the load average over the rounds and, per event, the fraction of each
`perf stat` measurement the counter was actually scheduled in. The per-column audit asked for both,
the milestone (c) report restated both as omissions, and neither had been done. The harness A/B is
the first receipt in this lane to carry them: **100.00 per cent enabled on every event over 1,337
measurements**, so "the set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` fits this PMU" is now a
recorded observation rather than an inference from the A/A nulls.

### Arms, cohorts and protocol

Five interleaved rounds, both scanner variants, pinned to CPU 5, the non-multiplexing six-event set,
two-point differencing between `N` and `N/2` iterations, `--stages scan,parse,admit,lower,stratify`.
The five default cohorts and `datalog` run at 512 definitions; `stratified`, `columns` and
`aggregate` run at **128**, because at 512 the control is refused by the byte bound and the
candidate is not, and two arms doing different work have no ratio. Instruction ratios decide; cycle
ratios are reported with their intervals.

## Results

### The boundary: where the route runs out now

This is the headline. Each row is the largest `--definitions` that completes the whole chain and the
first that is refused, by bisection over the committed `rel-lower` tool on committed cohorts. The
cohorts' `--definitions` is the *per-column* domain, which is the dictionary on `stratified`, half of
it on `columns`, a third on `columns3`, and the key set on `aggregate`; the dictionary is given as
well, because that is the axis the earlier reports measured.

**Before**, at milestone (c)'s close, every one of the four was refused by `Budget::ProgramBytes` —
the canonical JSON of one layer's program against the core's `MAX_BYTES` of 1,048,576 — at about
22,000 materialized facts in a layer:

| Cohort | Arity | Largest dictionary | Materialized facts there |
| ------------ | ----: | -----------------: | -----------------------: |
| `stratified` | 2 | 153 | 23,182 complement |
| `columns` | 2 | 302 | 22,577 complement |
| `columns3` | 3 | 84 | 21,938 complement |
| `aggregate` | 2 | 213 (key set) | 22,578 filter |

**After**, with the tool's committed defaults (`--max-rows 1048576`, `--values 4096`):

| Cohort | Largest dictionary | Factor | Materialized facts there | First refused, and the bound |
| ------------ | -----------------: | -----: | -----------------------: | ---------------------------- |
| `stratified` | **1,024** | ×6.7 | 1,047,043 complement | 1,025: the demand evaluator's **row capacity**, 2^20, at layer 1 |
| `columns` | **1,820** | ×6.0 | 826,738 complement | dictionary 1,822: the lowering workspace's **fact pool**, 4,097 against 4,096 |
| `columns3` | **255** | ×3.04 | 614,082 complement | 258: the core's **`MAX_INDEX_KEYS`**, 17,173,512 against 16,777,216 |
| `aggregate` | **3,959** (key set 1,365) | ×6.4 on the key set | 930,930 filter | key set 1,366: the lowering workspace's **fact pool**, 4,097 against 4,096 |

**And with the workspace raised** (`--max-rows 16777216 --values 262144`, both flags of the committed
tool, so these replay from this revision too), which is what shows which bound belongs to the *route*
rather than to the workspace the operator asked for:

| Cohort | Largest dictionary | Factor over before | Materialized facts there | Peak RSS | First refused, and the bound |
| ------------ | -----------------: | -----------------: | -----------------------: | -------: | ---------------------------- |
| `stratified` | **2,047** | ×13.4 | 4,187,141 complement | 1.39 GB | 2,048: **`Budget::LayerTuples`**, 4,197,376 against 4,194,304 |
| `columns` | **4,092** | ×13.5 | 4,183,050 complement | 2.73 GB | 4,094: **`Budget::LayerTuples`**, 4,195,326 against 4,194,304 |
| `columns3` | **255** | ×3.04 | 614,082 complement | 564 MB | 258: **`MAX_INDEX_KEYS`**, unchanged by the workspace |
| `aggregate` | **4,096** (key set 1,412) | ×6.6 on the key set | 996,166 filter | 1.86 GB | key set 1,413: **`MAX_INDEX_KEYS`**, 16,793,604 against 16,777,216 |

**The number that transfers is the fact ceiling, and it moved by about two orders of magnitude.**
Every product-shaped construct on this route used to stop at about 22,000 materialized facts in one
layer, because that is a mebibyte of JSON divided by the roughly 45 bytes a fact serialized to. It
now stops at **4,194,304** — `MAX_LAYER_TUPLES`, this route's own declared materialization budget,
which is a number chosen for what a layer may hold in memory rather than for what an encoding can
carry. That is **×190 on the ceiling**, against the per-column closeout's Fermi of "roughly 10× on
the dictionary", which in dictionary terms is ×13.4 and ×13.5 at arity two. The closeout predicted
"a dictionary of about 1,000 at arity two with whole-dictionary columns"; the measurement is 2,047,
so it was right in order and about twice conservative.

**Three of the four cohorts are now stopped by something other than this route's own bound**, which
is the more useful half of the result:

- `columns3`, at arity three, is stopped by the **core's `MAX_INDEX_KEYS`** — `domain^arity` of a
  relation read as one of two body atoms, against 2^24. Fermi prediction 1 named this bound and this
  cohort and predicted about 256; the measurement is 255.
- `aggregate` is stopped by **`MAX_INDEX_KEYS` too**, at a post-extension dictionary of exactly
  4,096 — `4096² = 2^24`. Milestone (c)'s Fermi prediction 3 predicted precisely this ("`MAX_INDEX_KEYS`
  is the bound that binds for aggregation, at a post-extension domain of 4,096 at arity two") and was
  recorded as **wrong**, because the lowering workspace's fact pool fired first. It was right about
  the bound and wrong only about what stood in front of it, and with that removed it is the bound.
  My own Fermi predicted `MAX_FILTER` at a key set of about 2,048 for this cohort and was wrong for
  the same reason it was wrong then: the aggregate extends the dictionary by about 2.9 entries per
  key, so the addressing bound arrives before the filter's `N(N−1)/2` reaches 2^22.
- Under the tool's defaults, `stratified` is stopped by the **demand evaluator's row capacity** and
  `columns` and `aggregate` by the **lowering workspace's fact pool**. Both are capacities the
  operator asks for rather than bounds of the route, and neither had ever been reachable before,
  because the encoding stopped the route an order of magnitude earlier. The row capacity was passed
  through as an unnumbered `Core(Budget)`; it is now `Error::LayerCapacity` with its layer and its
  number.

**So the shape of the answer has changed.** Before, one bound decided this route's reach on every
construct and it was an encoding. Now four different bounds decide it on four cohorts, three of them
about *addressing and capacity* — how large an index the evaluator direct-addresses, how many rows a
workspace was asked for, how many facts a lowering pool holds — and only one about materialization.
That is a route whose limits are where the evaluation actually is.

### The A/B: the five cohorts that never reach the backend

Candidate `8191ab7` over control `3778763`, instructions, five interleaved rounds, CPU 5, 512
definitions. **A/A instruction nulls** 1.0000013, 1.0000002, 0.9999989, 1.0000008 and 1.0000018 —
all within two parts per million of unity. **Counter enabled fraction 100.00 per cent on every
event**, recorded rather than inferred. **Load 2.02 to 2.36** over the rounds. Receipt
`analysis/rel-frontend/performance-v6-prepared-8191ab7.json`.

| Cohort | `scan` | `parse` | `admit` | `lower` | `stratify` − `lower`, candidate | control |
| ----------------- | -------: | -------: | -------: | -------: | ------: | ------: |
| `ascii`           | 0.999997 | 0.999999 | 0.999998 | 1.000000 | 1 | −1 |
| `unicode`         | 1.000000 | 0.999999 | 1.000001 | 1.000001 | −1 | 1 |
| `comment-string`  | 1.000022 | 1.000014 | 1.000006 | 1.000003 | 1 | −2 |
| `malformed-early` | 1.000000 | 0.999997 | 0.999998 | 0.999991 | 2 | −4 |
| `malformed-late`  | 0.999994 | 0.999999 | 1.000000 | 1.000000 | −3 | −3 |

**Scan, parse, admission and the lowering stage are unity to within twenty-two parts per million**,
which is the level of the nulls, so the front end did not move. All five cohorts are refused before
the backend — three by the lowering and two by the parse — so their `stratify` stage is a null by
construction, and it measures ±4 instructions on both arms, which is what a stage that runs nothing
should measure. That is also the check that the new stage is a real stage rather than a stub: on a
cohort that reaches the backend it is millions of instructions, and on a cohort that does not it is
three.

### The A/B: the backend stage on the cohorts that reach it

The composed figure is `stratify` minus `lower`: the backend boundary, the evaluation of every layer,
its derivation certificate and both of the core's independent checkers. `datalog` runs at 512
definitions and the rest at 128, which is where both arms complete.

| Cohort | Stage instructions, candidate | control | instruction ratio | cycles | wall p50, candidate over control | peak RSS |
| ------------ | ------------: | ------------: | ----------: | ------: | ------------------------------: | --------------------: |
| `datalog`    | 1,680,329,956 | 1,690,474,760 |     0.99400 | 0.96864 | 120.4 / 100.2 ms = **1.20** | 127,240 / 127,592 KiB |
| `stratified` |   168,175,532 |   323,491,619 | **0.51988** | 0.47000 |  10.29 / 19.88 ms = **0.518** | 11,420 / 15,960 KiB (**−28 %**) |
| `columns`    |   168,662,964 |   326,736,068 | **0.51621** | 0.46909 |  11.83 / 20.22 ms = **0.585** | 16,652 / 23,348 KiB (**−29 %**) |
| `aggregate`  |    59,064,703 |   136,776,315 | **0.43183** | 0.44332 |   7.89 / 12.09 ms = **0.653** | 21,080 / 23,656 KiB (**−11 %**) |

**`scan`, `parse`, `admit` and `lower` are unity on every cohort** — the largest departure is
forty-two parts per million on the `aggregate` scanner — so the front end did not move. The A/A
instruction nulls are 1.0000118, 1.0000013, 1.0000011 and 0.9999855. Counter enabled fraction
**100.00 per cent on every event of every run**; load 2.08 to 2.61.

**The closure SHA-256 is identical across arms on every cohort**, over every relation's certified
rows: `5c455ad4…ab8101a`, `dffdcd35…e896c6fb`, `3f5c4cdd…13c39e4f` and `ec562d2c…54e314e1e`. That is
the exactness evidence the receipts carry themselves, beside the differential.

**On the negation cohort the backend is halved**, in instructions, in cycles and in wall time, and
its peak resident set falls by 28 per cent. That is far more than the per-fact Fermi predicted, and
the reason is a mechanism the Fermi did not have: **the old route encoded each layer's program four
times.** The driver serialized it for the byte check; `Demand::new`'s admission serialized it again
and hashed it for the source identity; and each of the two independent checkers admitted the program
for itself, serializing and hashing it a third and a fourth time. The prepared route encodes once,
into a binary canonical form over tuples rather than JSON over names, and both checkers read the
admitted source. On `stratified` the control's three layers serialize to 748,012 bytes and the
candidate's tuple payload is 33,281 values.

**`datalog` is the instructive one, and it is a loss in wall time while being a win in
instructions.** Its layer holds 512 facts and its evaluation derives 135,926 tuples, so the boundary
is a small part of the stage and the instruction saving is 10.1 million on 1.68 billion, −0.6 per
cent. But its wall time is up 20 per cent, and the counter that explains it is the fault count:
**30,162 minor faults per iteration on the candidate against 4,971 on the control**, which at a few
hundred nanoseconds each is the whole of the 20 milliseconds. `perf_event_paranoid` is 2 on this
host, so perf counts user-mode events only and that cost is invisible in the instruction ratio — the
playbook's rule that a stage whose cost is kernel time is read from its faults and its wall time,
caught in the act. Peak resident set is the same on both arms, 127 MB, so nothing is using more
memory; pages are being returned to the kernel between iterations and faulted back in. The mechanism
and what it means for a real invocation are in the disposition below.

### Exactness

| Gate | Outcome |
| ---- | ------- |
| Native/WASM parity replay | **243 cases, 530,505 canonical bytes, byte-equal, SHA-256 `f0e2b581…b448b40` — unchanged.** The corpus compares the canonical bytes of the lowered relational IR, which this change does not touch; the layer programs are downstream of it and carry no canonical form of their own. So the parity hash did not move, and the reason it could not is structural rather than lucky. |
| `rel_lowering` | 52 passed, 0 failed (51 before, plus the new layer-payload fixture) |
| `rel_frontend` | 28 passed, 0 failed |
| `rel_frontend_portability` | 1 passed, 0 failed |
| `rel_reference_eval` (the C1189 differential) | 19 passed, 0 failed; **zero disagreements** over the committed fixtures, the milestone (a) audit's further programs, the recorded rejection surface, the 35 Addendum A equations, the surface-construct table, and the seeded in-fragment, negation, aggregation, comparison, near-miss and name-resolution corpora, all at their unchanged seeds |
| Core `cargo test --all-features` | every test binary passed, including the new prepared-constructor suite and the constructor allocation regression |
| Clippy, both repositories | no diagnostics |
| `cargo fmt --check`, both repositories | clean |

### The three deliberate mutations

Each is a one-line change, run with the gates and then reverted. None is committed. They are the
load-bearing evidence that the agreement discriminates, because the corpora cannot: the prepared path
is a second construction of the same structures from the same information, so a corpus that exercises
the construction only sees the two agreeing.

1. **The prepared identity taken over the tuples as supplied rather than over the sorted set** — one
   line restoring the supplied order after the deduplication. It fails **exactly one test in either
   repository**: the core's `the_prepared_identity_is_a_function_of_the_fact_set`. Every lowering
   fixture and every corpus of the differential passes, because the closure is unaffected. That is
   the sharpest thing the mutations say: **an identity defect is invisible to every corpus this lane
   has**, and it is caught only by a unit test written to catch it.
2. **A negative literal read over its own relation instead of over the complement the layer built** —
   the `atom_over` lookup forced to the relational-IR relation. Twenty of the fifty-two lowering
   fixtures fail and six of the nineteen differential tests, including the negation, comparison and
   aggregation corpora, the committed fixtures, the Figure 3/4 table and the independent Python
   oracle. Some fail as a refusal (a comparison literal names no relation, so the rule is
   `REL0504`) and some as a wrong closure, which is the pair of failure modes the construction has.
3. **The driver's canonical variable renumbering dropped**, passing the rule-local variable index
   straight through. Ten lowering fixtures and ten differential tests fail, every one of them with
   `Core(Source)` — the core refusing the rule because its body does not number its first variable
   zero. That is the check described under "Variable numbering is canonical and checked" doing its
   job: a producer that ignores the canonical order is refused rather than given a second identity
   for one rule.

Fermi prediction 6 said zero differential disagreements, for a weaker reason than milestone (b)'s:
the prepared path is a second construction of the same structures from the same information, so it
can only be wrong by building them differently, and a corpus that exercises the construction cannot
distinguish two constructions that agree. It came out zero **on the first run of every corpus**,
which is worth stating plainly as the weak evidence it is — the load-bearing evidence that the
agreement discriminates is the deliberate mutations below, not the corpora.

## Profile

Kernel-scoped: `perf record -e instructions:u -F 4000` on
`rel-frontend-bench --cohort stratified --stage stratify --definitions 128 --repeat 300`, pinned to
CPU 5, on each retained binary. That harness mode runs parse, admit and lower once per iteration
against a backend stage of 168 to 323 million instructions, so better than 99 per cent of the profile
is the stage under test. `perf.data` under `~/.cache/ergodis/perf-c1191/`.

The figures below are **share times the measured stage instructions**, which is an estimate and not a
measurement: the playbook is explicit that a symbol's profile share is not its cost, and this project
has been misled by shares twice. They are used here to say *where the saving went*, which is what a
profile is for, and the total they account for is checked against the measured saving at the end.

| Symbol | control, M instructions | candidate, M |
| ------------------------------------------------------ | ------: | -----: |
| `serde_json::ser::format_escaped_str`                   |   28.40 |   — |
| `serde_core` map/vec entry serialization, `itoa`        |   22.07 |   — |
| `ergodis_verify::datalog::admit`                        |   22.26 |   — |
| `hashbrown` rehash, `DefaultHasher::write`, `hash_one`  |   22.61 |   — |
| `alloc::vec::Vec::push_mut`                             |   12.94 |   — |
| `malloc_consolidate`, `cfree`, `_int_free_chunk`        |   12.07 |   — |
| `__memmove_avx512_unaligned_erms`                       |   19.47 | 12.36 |
| `__memcmp_evex_movbe`                                   |    4.27 |  2.61 |
| `sha2::sha256::x86::digest_blocks`                      |    6.34 |  0.92 |
| `ergodis_rules::demand::Demand::prepare`                |       — |  2.61 |
| `core::slice::sort::unstable::ipnsort`                  |       — |  2.54 |
| `ergodis_verify::datalog::Streaming::word`              |       — |  1.35 |
| `ergodis_verify::datalog::admit_prepared`               |       — |  1.31 |
| `derivation::closed_world`                              |   18.63 | 17.09 |
| `Demand::evaluate_into`                                 |   13.33 | 13.45 |
| `datalog_store::JoinIndexes::probe`                     |   10.68 | 14.58 |
| `datalog_store::RelationStore::insert`                  |   13.36 | 11.76 |

**Where the saving went.** Every serde symbol is gone; `datalog::admit` is gone; the hash table that
deduplicated facts inside it is gone, replaced by a sort of packed keys (`ipnsort`, 2.54 M); the
allocator's consolidation and free work is gone with the per-fact allocations; and SHA-256 falls from
6.34 M to 0.92 M, because the control hashes 748,012 bytes of JSON three times and the candidate
hashes a 133 KB tuple payload once. **The whole prepared boundary — `Demand::prepare`,
`admit_prepared`, the streaming encoder and the tuple sort — is about 7.8 M instructions**, against
about 110 M for the four serializations, three admissions and their allocator traffic. At 16,897
materialized facts over three layers that is a recorded per-unit budget of about **460 instructions
per materialized fact** for the prepared boundary, against about 6,500 for the wire one.

The symbols that are *not* the boundary barely move: `closed_world`, `evaluate_into`,
`RelationStore::insert` and `JoinIndexes::build` are within about 10 per cent either way, and
`JoinIndexes::probe` is up 3.9 M, which is thin-LTO layout on a function neither arm changed. Two
renames are not savings and are excluded from the table for that reason: `derivation::check_bounded`
becomes `check_admitted_bounded` (13.75 M against 14.87 M) and `ranked::check_bounded` becomes
`ranked::check_admitted_bounded` (7.86 M against 8.21 M).

The identified terms sum to about 134 M against a measured saving of 155.3 M, so the attribution
closes to about 86 per cent; the remainder is in symbols below the profile's 0.15 per cent cut and in
`Map::fold`, which is down 2.5 M.

**Out-of-line calls in the candidate's loops, listed as the playbook requires.** Two libc symbols
appear: `__memmove_avx512_unaligned_erms` at 12.36 M and `__memcmp_evex_movbe` at 2.61 M. Neither is
new — the control carries both, at 19.47 M and 4.27 M — and both are **lower** on the candidate, so
each is justified by measurement rather than removed. `memmove` is the runtime-length
`extend_from_slice` that fills each relation's row store in `Demand::prepare` and the tuple pool in
`admit_prepared`, plus the workspace reset in `evaluate_into`; `memcmp` is the slice comparison in the
driver's tuple sort and the one-per-synthetic-relation name comparison in `synthetic_name`. None is
in the evaluator's per-derivation inner loop, whose zero-allocation regression is unchanged and still
passes.

## Disposition

**Kept**, by the forward commits in the table above; nothing is reverted. The instruction ratio on
the backend stage is 0.520 on `stratified`, 0.516 on `columns` and 0.994 on `datalog`, the closure
digests are identical across arms on every cohort, and the boundary the task exists to move went
from about 22,000 materialized facts in a layer to 4,194,304.

**The one measured loss, and what it is.** On `datalog` the repeated-loop wall time is up 20 per cent
while instructions are down 0.6 per cent, and the counter that explains it is 30,162 minor faults per
iteration against 4,971. Diagnosis, in the order the playbook prescribes — count the events, then
find the mechanism, then check it:

- With glibc's trim and mmap thresholds pinned above the pool sizes
  (`MALLOC_TRIM_THRESHOLD_` and `MALLOC_MMAP_THRESHOLD_` at 2^30), the candidate's faults go to
  **0 to 2 per iteration** and the control's to 279, and the two arms' wall times become equal:
  medians of about 65.2 ms over three alternating pairs each.
- A single `rel-lower` invocation on the same cohort — which is what a consumer actually runs — is
  **102.8 ms on the candidate against 106.9 ms on the control**, with peak resident set 126,992 KiB
  against 127,568 KiB.

So the mechanism is the allocator returning pages to the kernel between iterations: the wire route
left 512 owned relation names and 512 owned tuples alive above the freed workspace, which pinned the
heap; the prepared route frees everything, glibc trims, and the next iteration faults the pages back
in. It is a property of running the whole chain repeatedly in one process, which is what the bench
probe does and what nothing else does. It is recorded rather than dismissed, because a
harness-shaped cost is still a cost if a consumer ever loops, and because the diagnosis is the
evidence that the instruction ratio was not hiding a real regression.

**What the saving actually is, which the Fermi did not have.** The old route encoded each layer's
program **four** times: the driver serialized it for the `MAX_BYTES` check; `Demand::new`'s admission
serialized and hashed it for the source identity; and each of the two independent checkers admitted
the program for itself, serializing and hashing it again. Three of those four also re-resolved every
relation name and cloned every tuple. The prepared route encodes once, in a binary canonical form
over tuples rather than JSON over names, and both checkers read the admitted source. On `stratified`
that is 748,012 bytes of JSON per pass replaced by a 33,281-value tuple payload hashed once. The
per-fact Fermi predicted a factor of four to six on the *per-fact* boundary cost and had no term for
the repeated whole-program encodings, which is why it predicted 40 to 70 per cent off the stage and
the measurement is 48 per cent — right by accident, from a cost model that was missing its largest
term. The model is corrected here rather than left to look prescient.

**Two components of that saving, separated.** Removing the serialization is the change the card asked
for. Removing the two checkers' re-admissions is a consequence of `check_admitted`, which the
prepared path needs because it has no wire program to hand them. The wire path still re-admits, by
design, so the comparison is between the two routes as they now stand and not between two spellings
of one route. *Evidence gap*: the split between the two components is not measured, and measuring it
would need a third arm with `check_admitted` on the wire path, which is a shape this task chose not
to build.

## Recorded deviations

Each of these is a departure from the card's design, or a change the card did not ask for, and each
is here rather than buried in a commit message.

1. **`Admitted`'s fact representation changed, which the card did not ask for.** The card asks for a
   constructor with no `Fact` per tuple; `Admitted` held an owned `Vec<u32>` per fact, so a prepared
   source would have traded one allocation per tuple for another. `AdmittedFact` is now a 12-byte
   record and the tuples live in one flat pool. This is a change to a public type of the core, it
   removes the same per-tuple allocation from the wire path, and it is why the constructor's
   allocation count is a constant.
2. **Both checkers gained an admitted-form entry point, and the two paths now re-admit differently.**
   The card says to decide how a prepared `Demand` answers `source()`; it does not say what the
   checkers do, and both take a `&Program`. `derivation::check_admitted` and `ranked::check_admitted`
   read the admitted source directly. `Demand::verify` and `verify_ranked` hand a wire program to the
   `&Program` door when there is one, so **the wire path admits its source twice and the prepared
   path admits it once**. The re-admission was never the independence that matters — the checkers
   are independent *implementations of the evaluation*, replaying a certificate against the source —
   but the asymmetry is real and is recorded rather than smoothed over.
3. **The prepared source identity is not the wire identity**, which the card permits and this report
   states as a consequence: a certificate of a prepared source binds to the prepared source, and the
   two encodings are domain-separated by their own tags. Nothing compares the two identities; the
   differential compares closures.
4. **The identity is streamed through a fixed 512-byte stack window, not value by value.** The card
   says "with no intermediate buffer". A per-value `update` call into SHA-256 would add about a
   third again to the hashing cost for nothing; the window is one compression block's worth of stack
   and never holds anything the size of the encoding. This is the reading of "no intermediate
   buffer" taken, and it is stated rather than assumed.
5. **A prepared rule's variable numbering is checked, not accepted.** The card describes the rules as
   "already-resolved slots (relation index + `Slot::Constant | Slot::Variable`, variable count)". The
   constructor additionally requires the canonical numbering and refuses anything else, so that a
   rule has one prepared form and therefore one identity. The driver pays a renumbering pass for it.
6. **`Budget::ProgramBytes` is replaced by a bound of the same kind rather than deleted.** The card
   says to replace it with "the bound that now binds first". Measurement says three different bounds
   bind first on four cohorts and two of them are workspace capacities, so simply deleting the check
   would have left a layer able to materialize up to `MAX_RELATIONS` complements of `MAX_COMPLEMENT`
   tuples each — an out-of-memory failure where a refusal belongs. `MAX_LAYER_TUPLES` is this route's
   own declared bound at `MAX_COMPLEMENT`'s value, checked against the projected total before each
   construct is enumerated.
7. **`rel-lower` gained a `--values` flag**, which the card did not ask for. Without it the deeper
   half of the boundary table would have had to come from an uncommitted source, which is exactly the
   defect the milestone (c) audit recorded against the aggregate-only probe. With it every figure in
   the boundary table replays from a committed revision.
8. **The JSON path is kept, and here is where.** `rel_lowering::project`, the single-program
   whole-`Program` projection of milestone (a), is untouched and still exercised by one lowering
   fixture. Nothing in the stratified driver uses it. A consumer that genuinely needs a wire program
   — an export, an external checker, a reader that wants to decode the program back — uses it and
   gets the unchanged wire identity.

## Remaining gaps

1. **`MAX_INDEX_KEYS` is now the bound to attack**, on two of the four cohorts. It is a core bound on
   the demand evaluator's direct-addressed join index, `domain^arity` against 2^24, and what would
   move it is a non-direct index for a sparse relation with an exact crossover policy — a core
   change with its own measurement, not a driver one.
2. **The lowering workspace's fact pool is sized from `Limits::values`**, so a source with many facts
   needs a dictionary limit it does not otherwise need. That coupling is now visible because it
   binds; sizing the fact pool separately is a small change nobody has made.
3. **`rel-lower`'s `--max-rows` default of 2^20 is what stops `stratified` at a dictionary of 1,024**,
   against the core's `MAX_ROWS` of 2^24. It is an operator default, it is now reported with its
   number, and whether it should be raised is a decision about how much memory a default invocation
   may take rather than a defect.
4. **Peak resident set at the new boundary is gigabytes**: 1.39 GB on `stratified` at 2,047 and
   2.73 GB on `columns` at 2,046. The encoding bound was also a memory bound, and removing it removed
   that too. Nothing sizes a layer against available memory; `MAX_LAYER_TUPLES` is a tuple count, and
   a tuple's cost in the evaluator's workspace is seven `u32` per derived row rather than the four
   bytes per value the bound counts.
5. **Milestone (c)'s and the per-column report's gaps are unchanged**: min-plus is deferred, an
   aggregate's body is one positive application, arithmetic in a term position is refused, the
   same-layer fallback takes the whole dictionary, `bind` records no site for a variable an aggregate
   binds, and `exists(x in D: F)` and `not` over a non-application are still unwritten.

## Mystery ledger

1. **Settled: what the encoding was costing this route, and it was two orders of magnitude on the
   ceiling rather than the one the Fermi predicted.** Every product-shaped construct used to stop at
   about 22,000 materialized facts in one layer; the measured ceiling is now 4,194,304, and the
   largest dictionary at arity two goes from 153 to 2,047 on `stratified` and from 302 to 4,092 on
   `columns`. The per-column closeout priced this lever at "roughly 10× on the dictionary, to about
   1,000 at arity two"; it is ×13.4 and ×13.5, so the estimate was right in order and about twice
   conservative. Every figure replays from a committed revision by the replay block below, on
   committed cohorts, with no generated source anywhere — which is the defect the milestone (c) audit
   recorded against that milestone's own deepest probe. *Nothing about this item is open.*

2. **Settled, and it is the more useful half: four cohorts are now stopped by three different bounds,
   and only one of them is about materialization.** `columns3` and `aggregate` stop at the core's
   `MAX_INDEX_KEYS`, the demand evaluator's direct-addressed join index at `domain^arity` against
   2^24. `stratified` and `columns` stop at `MAX_LAYER_TUPLES`, this route's own declared budget.
   Under the tool's defaults, two cohorts stop earlier still at capacities the operator asked for —
   the evaluator's row bound and the lowering workspace's fact pool. Before this task one bound
   decided the reach of every construct on every cohort and it was an encoding. **The route's limits
   are now where the evaluation is**, which is what one wants from a limit.

3. **Settled, and it settles somebody else's open question: milestone (c)'s Fermi prediction 3 was
   right.** That prediction said `MAX_INDEX_KEYS` would be the bound that binds for aggregation, at a
   post-extension domain of 4,096 at arity two, and it was scored wrong because the lowering
   workspace's fact pool fired 47 keys earlier. With the fact pool raised the `aggregate` cohort runs
   to a post-extension dictionary of **exactly 4,096** and is refused at 4,097 on `MAX_INDEX_KEYS`,
   16,793,604 against 16,777,216. The prediction was right about the bound and wrong only about what
   stood in front of it. My own Fermi for that cohort predicted `MAX_FILTER` at a key set of about
   2,048 and was wrong for the same reason it was wrong then: the aggregate extends the dictionary by
   about 2.9 entries per key, so the addressing bound arrives first.

4. **Open: nothing bounds a layer's memory, and at the new boundary that is gigabytes.** Peak
   resident set is 1.39 GB on `stratified` at a dictionary of 2,047 and 2.73 GB on `columns` at
   4,092. The encoding bound was incidentally a memory bound — a mebibyte of JSON cannot describe
   many tuples — and removing it removed that too. `MAX_LAYER_TUPLES` counts tuples, but a tuple's
   real cost is the evaluator's workspace row plus its five witness columns plus both checkers'
   stores, which is far more than the four bytes per value the bound counts. *Evidence gap*: a
   measured bytes-per-materialized-tuple figure across the four cohorts at two dictionary sizes, and
   a decision about whether the layer bound should be expressed in bytes. Neither is done here.

5. **Open, inherited, and one step less mysterious: the `comment-string` cohort's +0.23 per cent from
   milestone (c).** That cohort is refused by the relation budget and executes none of the changed
   code, and this task's harness commit — which adds a whole stage to the same binary — moves its
   lowering stage by **eight instructions on 1.89 million, a ratio of 1.00000 to five places**. So
   the thin-LTO layout swing is not something every commit to this binary produces; it was one build
   pair. *Evidence gap*: unchanged, the kernel-scoped `perf record -e instructions:u` profile of
   `lower::run` bucketed by address range in the two milestone (c) binaries, which is now overdue on
   three reports.

6. **Open: this route has no independent audit of the constructor's correctness beyond its own
   corpora.** The differential found zero disagreements on the first run of every corpus, which for
   this change is weak evidence by construction: the prepared path builds the same structures from
   the same information, so a corpus that exercises the construction cannot distinguish two
   constructions that agree. The deliberate mutations below are what shows the gates discriminate.
   *Evidence gap*: the independent read-only audit the task card asks for, which is not in this
   report and which the next step names.

## Replay commands

Run from `~/src/ergodis-private`. Every gate and every measurement was run under
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build.

```sh
# Gates, private.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_lowering --test rel_frontend --test rel_frontend_portability \
    --test rel_reference_eval -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check

# Gates, core.
cd ~/src/ergodis
nix develop . --command cargo test --all-features -j 8
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
cd ~/src/ergodis-private

# The committed independent Python oracle, and the native/WASM parity replay.
python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output analysis/rel-frontend/portability-v1.json

# The corpus census the differential prints rather than asserts in full.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_reference_eval -j 8 -- --nocapture --test-threads 1

# The boundary table, with the tool's committed defaults. Each pair is the
# largest --definitions that runs and the first that is refused; the tool prints
# the budget, the number found and the limit for every refusal.
for n in 1024 1025; do choom -n 1000 -- nix develop ~/src/ergodis --command \
    cargo run --release -p ergodis-tools -- \
    rel-lower --cohort stratified --definitions $n --max-tuples 0; done
for n in 910 911;   do … --cohort columns   --definitions $n --max-tuples 0; done
for n in 85 86;     do … --cohort columns3  --definitions $n --max-tuples 0; done
for n in 1365 1366; do … --cohort aggregate --definitions $n --max-tuples 0; done

# The same four with the lowering workspace and the evaluator's row store raised,
# which is what shows which bound belongs to the route rather than to the
# workspace the operator asked for. Both flags are the committed tool's.
R="--max-rows 16777216 --values 262144"
for n in 2047 2048; do … --cohort stratified --definitions $n --max-tuples 0 $R; done
for n in 2046 2047; do … --cohort columns    --definitions $n --max-tuples 0 $R; done
for n in 85 86;     do … --cohort columns3   --definitions $n --max-tuples 0 $R; done
for n in 1412 1413; do … --cohort aggregate  --definitions $n --max-tuples 0 $R; done

# The A/B. Each arm is retained once, from a checkout at its own revision: the
# script retains whatever the tree carries and names the binary for it, so one
# invocation cannot produce both.
git checkout 3778763 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout 8191ab7 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
CONTROL=~/.cache/ergodis/bin/ergodis-tools-3778763
CANDIDATE=~/.cache/ergodis/bin/ergodis-tools-8191ab7
B=analysis/rel-frontend
# The five default cohorts and datalog at 512 definitions.
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v6-prepared-8191ab7.json
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v6-prepared-datalog-8191ab7.json
# The three backend cohorts at 128 definitions, which is where both arms
# complete: at 512 the control is refused by the byte bound and the candidate is
# not, and two arms doing different work have no ratio.
for c in stratified columns aggregate; do
  nix develop ~/src/ergodis --command python3 $B/bench.py \
      --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 --cohorts $c \
      --definitions 128 --stages scan,parse,admit,lower,stratify --events $E \
      --out $B/performance-v6-prepared-$c-8191ab7.json
done
# The harness commit's own parity A/B, on the stages that already existed.
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-3778763 \
    --control ~/.cache/ergodis/bin/ergodis-tools-b7c624d --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower --events $E \
    --out $B/performance-v5-harness-3778763.json
```

## What this task left under `~/.cache/ergodis/`

`bin/ergodis-tools-3778763` and `bin/ergodis-tools-8191ab7`, each with its `.sha256` sidecar and its
`MANIFEST.tsv` row: the harness arm, which is this task's control, and the candidate, which is
**the control the next backend A/B should use**. Beside them, `ergodis-tools-b7c624d`, which milestone
(c) left and which the harness A/B measured against, and `ergodis-tools-b1ce519` and
`ergodis-tools-606136e` from the two milestones before that. Under `c1191/`: the three A/B driver
logs and the parity replay's receipt, none of which anything cites — the parity figure in this report
is reproduced by the committed `analysis/rel-frontend/portability-v1.json` and by the replay command,
and the A/B figures by the committed receipts. Under `perf-c1191/`: the kernel-scoped profiles.
`target/ergodis-private` and `target/ergodis` are the two shared build trees, which are not this
task's to remove. Deletion is the user's call.

## `ej`/`tt` closeout

Run after the acceptance gate passed, as the lane requires.

**Cheap upgrades taken during the task.** Three, none of which the card asked for and each of which
cost a handful of lines. The flat fact pool in `Admitted` removes a per-tuple allocation from the
*wire* path as well, which nobody had noticed was there. `bench.py` now records the load average and
the counter enabled fraction — two of the four small repairs the per-column audit asked for, queued
by two reports and done here because this task's own receipts needed them; the enabled fraction came
back 100.00 per cent on every event over 1,337 measurements, which turns a claim this lane has been
making from the A/A nulls into a recorded observation. And `rel-lower --values` is what makes the
deep half of the boundary table replay from a committed revision instead of from a probe nobody
committed, which is the reproducibility defect the milestone (c) audit recorded against that
milestone's own deepest figure.

**What the `tt` pass found, and it is a change of question.** Milestone (c)'s closeout ended with a
rule of thumb: on this route, ask whether a construct is a *product* or a *reduction*, because a
product is capped at about 22,000 facts and a reduction is free. That rule is now obsolete in its
second half and misleading in its first. The cap on a product is 4,194,304 facts, which is not a cap
any Rel program a person writes will reach; and what actually stops three of the four cohorts is
`domain^arity` against the demand evaluator's direct-addressed index, which is a property of the
**arity and the dictionary**, not of the construct. The new question is:

> Does this construct raise the *arity* of a relation the evaluator must index, or the *size of the
> dictionary*? Because `domain^arity` against 2^24 is what decides the reach now.

That reframes the two things ADR 0004 records as alternatives. The `Negative` atom kind in the core
`Rule` was the route to take "as soon as a program needs a dictionary in the thousands or a negated
relation of arity four"; a dictionary in the thousands now works, and arity four is `domain^4`
against 2^24, which is a dictionary of 64 — so the case for that alternative is now entirely about
*arity*, and not at all about dictionary size. And per-column domains, which bought a factor of two
or three on the number of facts, buy nothing at all against an addressing bound computed from the
declared domain: the close pass checks `dictionary^arity`, not `∏ᵢ |Dᵢ|`. **Narrowing the addressing
bound to the per-column domains a relation actually ranges over is the obvious next lever and it is
a core change**, because the index is the core's.

**Doors this opens.**

1. **A layer may now hold millions of tuples, so incremental evaluation across layers is worth
   asking about.** Every layer currently reads its predecessors' closures forward as input facts, and
   at a dictionary of 2,047 that is 8.4 million tuple values copied into the evaluator's row stores
   per layer. The prepared source hands them over by reference; the evaluator still copies them into
   its workspace. A workspace that could borrow an immutable input relation instead of copying it is
   a core change with a measurable prize that did not exist when a layer held 22,000 facts.
2. **The prepared constructor is the entry point any other producer would want.** It is domain
   neutral, it names nothing private, and it is what a second front end — or an external compiler —
   would use. Nothing about it is Rel-specific.
3. **The bound to attack is now `MAX_INDEX_KEYS`, and the shape of the fix is known**: a sparse index
   for a relation whose tuple count is far below `domain^arity`, with an exact crossover policy and a
   replay test, which the playbook already prescribes for every compressed representation.

**Candidates to queue** (no IDs allocated):

- The independent read-only audit of this task, which the card asks for and this report does not
  contain.
- Per-column domains in the *addressing* bound: check `∏ᵢ |Dᵢ|` rather than `dictionary^arity` for a
  relation whose columns are narrow, which is where the two milestones' work would finally compound.
- A sparse join index in the core for a relation far below `domain^arity`, which is what
  `MAX_INDEX_KEYS` is a bound on.
- A memory model for a layer, and a decision about whether `MAX_LAYER_TUPLES` should be expressed in
  bytes; mystery ledger item 4.
- Sizing the lowering workspace's fact pool separately from `Limits::values`, which is the coupling
  that stops two cohorts under the tool's defaults.
- The kernel-scoped profile of `lower::run` bucketed by address range, still overdue on three
  reports.
- The two repairs of the per-column audit's four that remain: a record shape naming the rule a
  complement came from, and sizing the `BindSite` pool to the terms that occur in bodies.

## Next steps

(to be filled)
