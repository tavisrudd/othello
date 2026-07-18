# C326 plan — generated trust spine and proof-dependency graph

**Lane**: `build-sys`
**Status**: design accepted for implementation; start with RelativeConicArcs

## Objective

Build one toolchain with three explicit products:

1. a read-only check that fails when the declared trust boundary and the Lean tree diverge;
2. generated regions in `lean/TRUST.md` and per-area trust manifests; and
3. canonical dependency-graph data from which compact Mermaid/DOT views can be rendered.

The tool must distinguish declarations made by reviewers from facts extracted from Lean. It must
not turn a hand-written inventory into self-confirming generated prose.

## Non-goals

- Do not infer mathematical roles such as “checker” or “classical input” from names or imports.
- Do not treat an import graph as a theorem-dependency graph.
- Do not make ordinary gate builds rewrite tracked files.
- Do not require independently compiled gates to coexist in one Lean environment.
- Do not claim that an artifact regenerates merely because its tracked bytes have a hash.
- Do not use generated documentation or rendered diagrams as ground truth.

## Threat model

C326 must detect all of the following:

- a project-local axiom in a module outside every gate, such as the current Dye axioms;
- a terminal acquiring an unexpected axiom, including one otherwise permitted in its area;
- a declared terminal missing from every declared gate;
- a gate omitting a terminal or audited module that its manifest claims to cover;
- an unclassified project-local module, including a new top-level area such as `Queens/`;
- a generated data tree, `*Rows/` tree, or generated leaf missing from the spine;
- a data tree losing every path to a declared terminal;
- a stale or false generator path, payload hash, or generated-file header;
- a generated Markdown region that is stale, duplicated, malformed, or hand-edited; and
- graph drift hidden by a lossy data-tree collapse.

## Architecture

### 1. Portfolio registry

Add one portfolio registry under `lean/trust/`. It defines the project source roots, areas,
manifests, gates, shared-module policy, and explicit exclusions. Every project-local `.lean` module
must be classified as one or more of:

- owned by an area;
- shared by named areas;
- intentionally outside all paper-facing gates, with a reason; or
- generated data belonging to a declared data tree.

The global classification is independent of gate reachability. This is what catches an orphan
`Q11DyeAxioms`-style declaration and an otherwise omitted `Queens/` subtree.

Build products and dependency caches are excluded structurally, not through ad hoc ignore lists.

### 2. Per-area declarative spine

Use one versioned TOML file beside each area manifest. TOML is the author-edited source because its
diffs remain readable; generated facts use JSON. The schema must support:

```text
area
  manifests[]
  gates[]
    module
    terminals[]
    expected project-local modules[] or an explicit coverage rule
  terminals[]
    declaration
    gate memberships[]
    exact expected axioms[]
  permitted custom axioms[]
  named external inputs[]
    entry mode
    entry declarations[]
    citation/manifest anchor
  data trees[]
    path and member rule
    explicit handwritten exclusions
    generator and generator digest
    load-bearing inputs and their digests
    payload-hash convention and expected root hash
    expected terminal reachability[]
    provenance status
```

An area may have several gates. A terminal may occur in more than one compatible gate. Completeness
is defined over the declared union of gates, so the three independently compiled alternate-orbit
gates are representable without importing them together.

Named external inputs remain declarations by the reviewer. The checker verifies that their stated
entry declarations exist and that an input marked `axiom` agrees with Lean's facts; it cannot infer
citations or mathematical meaning.

### 3. Lean-derived fact exporter

Implement a small Lean environment exporter. Do not parse `#print axioms` text or use a regex over
source declarations as the authoritative audit.

Run the exporter separately for each gate. It emits canonical JSON containing:

- resolved transitive module closure;
- every project-local declaration in that closure;
- every project-local declaration represented as an axiom in Lean's environment;
- the exact collected axiom set of every named terminal;
- direct constant dependencies from each declaration's type and value/proof body; and
- the defining module of every declaration.

Also run a portfolio inventory over all classified project modules, not merely gate closures. That
inventory emits every project-local axiom declaration and every module not reachable from a gate.
This second pass is required even when all gate checks are green.

The exporter records schema version, Lean version, Mathlib revision or lock identity, and the
digest of the exporter itself. Output objects and arrays are canonically ordered and contain no
timestamps or host paths.

The implementation must document whether dependencies hidden behind opaque declarations are
available to the metaprogram. If Lean does not expose a proof body, the graph records the boundary
as opaque instead of silently claiming a complete theorem graph.

### 4. Source and data-tree inventory

A deterministic source scanner provides filenames, import declarations, generated-tree membership,
header facts, byte counts, and hashes. It may parse Lean import syntax for the module graph, but the
resolved closure from the Lean exporter remains authoritative for trust checks.

Each data tree distinguishes:

- generated leaves, which must have a versioned parseable provenance header;
- handwritten schema/checker/bridge modules; and
- generated aggregate modules, if any.

The provenance header records at least the generator path, generator digest, input/root digest,
payload digest, and schema version. A directory root hash is computed from a specified canonical
list of relative member paths and member payload digests. The spine defines whether the payload is
the complete file or a delimited generated region; there is no implicit convention.

Only tracked files participate in a passing release check. An untracked matching leaf is a failure,
not silently included evidence. Generator paths and load-bearing inputs must be tracked and their
digests must match the spine.

Legacy trees without reproducible provenance are recorded as `legacy-unverified`; generated docs
must say that plainly. Strict provenance cannot be enabled for such a tree until C324 demonstrates
regeneration and supplies the required headers and digests.

## Canonical graph product

The primary graph artifact is canonical JSON, not Mermaid or DOT. It contains typed nodes and
edges sufficient to derive several views.

Node types:

- module;
- declaration (including theorem, definition, checker, and axiom roles declared in the spine);
- gate and area;
- generated data tree and generated leaf;
- named external input; and
- opaque dependency boundary.

Edge types:

- module `imports` module;
- module `declares` declaration;
- declaration `uses` declaration, extracted directly from Lean expressions;
- terminal `depends_on_axiom` axiom;
- gate `contains` module and `exports` terminal;
- generated leaf `imports` module;
- module `imports` generated leaf or aggregate;
- data tree `has_member` leaf; and
- external input `enters_at` declaration, declared by the reviewer.

The raw graph preserves all nodes and edges. Data-tree collapse is a named projection that records
its member set and retains every boundary edge in both directions. It must never relabel a
syntactic dependency as “consumed by.” Human-facing tables use `imports`, `imported by`, and
`reaches terminal`; a semantic `consumer` field appears only when explicitly declared in the
spine.

Required views:

1. **Gate closure:** module imports, axioms, and terminals for one gate.
2. **Proof spine:** terminal-to-declaration dependency paths, with generated trees collapsed.
3. **Data provenance:** generator/input/data-tree/checker/terminal reachability.
4. **Portfolio axiom map:** all project-local axioms, including modules outside every gate.

The renderer consumes only canonical graph JSON and can emit Mermaid and DOT. Rendered files are
optional derived artifacts; the JSON plus schema is the durable interface for other visualization
tools. Large graphs must support area, gate, terminal, node-kind, and depth filters rather than
producing an unreadable portfolio diagram.

“Dangling” is split into explicit predicates:

- no imports cross a data tree's boundary;
- no path exists from a data tree to any declared terminal;
- a declared terminal is absent from all declared gates; or
- a classified module is unreachable and lacks an explicit exclusion reason.

## Evidence-extension boundary

C326 freezes stable node identifiers and a generic evidence-overlay interface so later metadata
does not require rewriting the dependency graph. The canonical schema permits immutable assessment
nodes plus typed `supports`, `assesses`, `supersedes`, `generated_by`, and `replayed_by` edges.
Assessments are separate records joined to graph nodes by stable ID; they never alter Lean-derived
topology.

Within C326, use the overlay only for provenance required by the trust contract and one
RelativeConicArcs exemplar proving that references, supersession, deterministic latest-record
selection, and generic renderer badges work. C326 does not conduct portfolio novelty searches or
attach an unbounded `novel = true` property to theorem nodes.

C328 owns the substantive novelty layer after these identifiers and interfaces stabilize:

- bounded novelty-status vocabulary rather than a Boolean novelty claim;
- immutable assessments with exact claim, search scope, method, date, evidence, known related work,
  limitations, and optional supersession;
- literature-search record validation and freshness policy;
- query/filter support and novelty-specific visualization badges;
- a populated RelativeConicArcs pilot; and
- a protocol by which area-owning lanes supply theorem judgments without `build-sys` annexing their
  research conclusions.

Portfolio-wide assessment population is not a C328 completion condition unless separately
allocated to the owning lanes.

## Commands and mutation contract

Provide one entry point under `lean/scripts/` with these modes:

```text
trust-spine audit [--area AREA]       # read-only; compare declarations with extracted facts
trust-spine generate [--area AREA]    # explicitly rewrite generated JSON/doc regions
trust-spine graph [--area AREA]       # emit canonical graph JSON
trust-spine render --format mermaid|dot [filters]
trust-spine check [--area AREA]       # full read-only regeneration in temporary storage + byte diff
```

`audit`, `graph`, and `check` never modify the worktree. `generate` is the only mutating command.
`check` regenerates facts, graph data, and Markdown into temporary storage, checks schema and
semantic invariants, then compares canonical bytes with tracked outputs. It fails on a dirty
generated region rather than repairing it.

Lean extraction runs only through the repository's guarded build/queue discipline. The tool may
reuse a trace-current gate environment, but it must never start an uncoordinated Lake build.

## Generated documentation

Generated regions use unique, versioned markers carrying area and section identifiers. The checker
requires exactly one begin/end pair per declared region and rejects nesting, duplication, missing
regions, wrong area identifiers, or generated content outside its markers.

Generate these tables where applicable:

- area → gates → terminals;
- terminal → exact axiom set;
- all project-local custom axioms, including excluded/orphan modules;
- named external inputs and entry modes;
- data trees, provenance status, generators, root hashes, and terminal reachability; and
- classified but currently unaudited/unreachable modules.

The tables display both declared intent and observed Lean facts when that distinction matters.
Handwritten prose remains outside markers and must not make stronger claims than the generated
status fields.

## Validation and adversarial tests

Unit tests use small canonical fixtures. A guarded integration fixture uses a tiny Lean project or
dedicated test modules during a confirmed build window. At minimum, independently demonstrate that
`check` fails for:

1. an axiom in a module outside every gate;
2. a terminal acquiring an already area-permitted but terminal-unexpected axiom;
3. a terminal absent from all its declared gates;
4. a newly unclassified project module;
5. a removed data-tree boundary edge and a removed path to a terminal;
6. a missing generated leaf, an untracked matching leaf, and an unexpected extra leaf;
7. a missing or changed generator, input digest, payload digest, or provenance header;
8. malformed, duplicated, missing, or hand-edited Markdown markers;
9. stale canonical graph JSON while the docs happen to match; and
10. a renderer bug that changes presentation but not canonical graph data.

Also require:

- two consecutive `generate` runs are byte-identical;
- `check` leaves `git status` unchanged;
- raw graph boundary edges survive collapse and expansion exactly;
- direct declaration dependencies replay to the terminal axiom sets reported by Lean, with any
  opaque boundary explicitly accounted for; and
- the Baer manifest's audited terminals are either covered by `Gates.Baer` or reported as missing.

## Delivery sequence

### Phase A — schema and non-circular inventory

1. Freeze the registry, TOML, facts JSON, and graph JSON schemas.
2. Implement global source classification and per-gate Lean extraction.
3. Land read-only audit output before generating prose.
4. Prove the orphan-axiom, terminal-axiom, multi-gate, and unclassified-module tests.

The global portfolio inventory is active from the first RelativeConicArcs pilot; rollout by area
must not recreate a temporary blind spot for Dye or Queens.

### Phase B — RelativeConicArcs pilot

1. Declare all five gates and their terminal membership.
2. Classify every RelativeConicArcs module, including Dye modules outside gates.
3. Inventory every `*Data/` and `*Rows/` tree and its handwritten exceptions.
4. Verify the Baer coverage claim.
5. Emit canonical facts and graph JSON, then generate the affected trust tables.
6. Render at least the gate-closure, proof-spine, data-provenance, and portfolio-axiom views.

### Phase C — C324 regeneration bridge

Use the Phase B inventory to run C324's pinned-toolchain regeneration. Trees that replay exactly
receive strict provenance headers and digests. Failures remain visibly `legacy-unverified`; neither
C324 nor C326 may convert identity hashes into regeneration claims.

### Phase D — strict checks and portfolio rollout

1. Enable strict provenance checks for successfully regenerated trees.
2. Add the generated regions to the portfolio and per-area manifests.
3. Roll the schema across remaining areas without weakening the global unclassified-module and
   project-axiom checks.
4. Add the read-only area checks to each documented gate window only after runtime and ownership
   behavior are measured.

## Completion criteria

C326 is complete only when:

- all adversarial tests above pass;
- RelativeConicArcs has a green full `check` over all five gates plus the global orphan inventory;
- the two Dye axioms appear in the portfolio axiom data despite being outside gate closures;
- Queens and every other project module are classified or explicitly excluded;
- terminal-level exact axiom sets and gate-wide custom-axiom inventories are both enforced;
- the Baer coverage question is resolved mechanically;
- canonical proof/module/data dependency graph JSON is tracked with schema, hashes, and replay
  command;
- at least one Mermaid and one DOT rendering are reproducible from that JSON;
- generated Markdown matches a read-only temporary regeneration;
- C324 provenance results are represented honestly; and
- the report states the trusted boundary of the exporter, source scanner, schema, and renderer.

## Implementation-time decision gates

Stop for review before changing any of these:

- whether declaration proof bodies are unavailable and therefore make the theorem graph partial;
- the exact portfolio source-root/module-classification boundary;
- schema changes after the first tracked facts artifact;
- adding trust checks to a validation gate or CI-equivalent path; or
- requiring regeneration or header rewrites in another lane's generated tree.
