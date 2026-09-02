# C985 bounded feature-promotion pipeline design

**Lane:** `complete-ports`

**Status:** design only; implementation paused by user direction

**Date:** 2026-09-02

## Decision

Compose the already-landed feature mechanisms through one cold, bounded,
diagnostic pipeline:

```text
source FeatureDag + canonical source candidates
    -> universal simplification + total old-to-new map
    -> exact training-value quotient
    -> exact training-plus-holdout value quotient
    -> reachable-value support and transitive input scope
    -> downstream-aware Pareto frontier
    -> source-bound diagnostic promotion artifact
```

The pipeline has no theorem or pruning authority. It reduces duplicate
candidate work, retains explicit counterevidence when a training equivalence
splits on holdout, and emits the exact provenance needed by a later admission
checker. Complete-domain sealing remains a separate future operation.

## Typed boundary

The cold request supplies:

- one canonical `FeatureDag` and its presentation binding;
- a strictly increasing list of source candidate IDs;
- a training corpus and optional reachable-row bitmap;
- an optional disjoint holdout corpus and reachable-row bitmap;
- one downstream-compatibility score per source candidate; and
- explicit caps for simplified nodes, selected rows, evaluated cells, support
  values, scope words, candidates, and Pareto points.

The result owns:

- the simplified DAG;
- the total map for every source node, not merely requested candidates;
- the exact training and validated quotient representatives;
- one provenance record for every source candidate;
- exact selected-row counts and value supports;
- the final Pareto points, including the source candidate that supplied each
  retained downstream-compatibility score; and
- fingerprints for the source DAG, source candidate sequence, training view,
  holdout view, bounds, and pipeline schema.

Candidate provenance distinguishes four identities:

```text
source candidate
    -> universally simplified node
    -> training representative
    -> training-plus-holdout representative
```

It also records whether the validated representative is retained on the
frontier and, if so, its frontier ordinal. An explicit integer sentinel is
used for “not retained”; no invalid `FeatureId` is constructed.

## Exact semantics

Universal simplification runs first and may merge nodes only through checked
identities valid on every integer input. Its total old-to-new map is the sole
way source candidates enter later stages.

The training quotient is observational and is retained for diagnostics. The
validated quotient is computed over the union of selected training and
selected holdout rows from the complete set of simplified candidates. It is
not computed by quotienting only the training representatives: doing that
would irreversibly discard two candidates that agree in training but separate
on holdout. Consequently every validated class refines a training class.
Failure of that refinement invariant is an internal error.

When several source candidates simplify to or observationally represent the
same validated feature, evaluation cost and scope come from that feature.
Downstream compatibility is the maximum available score among its source
members, and the lowest source ID attaining that maximum is retained as its
replayable origin. This aggregation is valid only because compatibility is a
declared monotone benefit coordinate; it grants no semantic authority.

The support projector and scope compiler run on validated representatives.
Pareto dominance remains exactly:

```text
smaller support, evaluation cost, and scope; larger compatibility
```

with at least one strict coordinate. No scalar weighting or local-cost
threshold may discard a non-dominated point.

## Bounds and memory

All allocation is cold and preceded by checked shape/product bounds. Selected
training and holdout rows may be copied once into one flat validated-corpus
buffer; there is no row-per-object allocation. Candidate maps, quotient
members, supports, scopes, and frontier records are contiguous boxed slices or
flat vectors before final boxing. Digests are bucketing aids only; exact value
comparison decides every merge.

The first implementation should reuse the existing simplifier,
`FeatureValueQuotient`, `ObservedFeatureSupportBank`, and `FeatureScopeBank`
rather than duplicate their matrices. A later fused evaluator is admissible
only after the baseline exposes material duplicate evaluation or peak-memory
cost. This pipeline never enters a solver worker, so it adds no solve-loop
allocation, branches, communication, or contention.

## Failure and authority rules

Fail closed on malformed reachability tails, empty selected views,
noncanonical candidates, candidate IDs outside the source DAG, score-length
mismatch, checked-size overflow, cap exhaustion, evaluation overflow,
presentation drift, quotient non-refinement, or inconsistent provenance.

The output is always marked diagnostic with `proof_authority = false`.
Training perfection, holdout perfection, a singleton support, or Pareto
retention cannot promote a predicate to a necessary condition. Authority
requires a separate complete reachable-domain proof or an independently
replayed structural implication tied to the same presentation.

## Acceptance controls

The implementation tranche is accepted only when all of the following pass:

1. A redundant source DAG simplifies to fewer nodes while every source-node
   value replays through the total map.
2. Two candidates merge on training, split on a disjoint holdout, and remain
   distinct in the validated quotient.
3. Universally identical candidates remain merged on both views.
4. Every source candidate has a complete four-stage provenance record.
5. Duplicate simplified candidates with different compatibility scores retain
   the maximum score and deterministic lowest attaining source ID.
6. A constructed four-point tradeoff keeps every non-dominated point and
   rejects every dominated point without scalarization.
7. Forged reachability tails, candidate ordering, bounds, fingerprints, and
   provenance fail closed.
8. Snapshot/replay reproduces byte-identical canonical records after restart.

Property controls should compare the pipeline against a small direct evaluator
over generated bounded DAGs and row sets. The independent oracle recomputes
full columns and pairwise equivalence without using pipeline digests or
representatives.

## Performance gate

The first retained comparison is simplify-first versus the same pipeline with
universal simplification disabled on a reusable redundant-expression family.
Both arms use identical source candidates, rows, holdout, caps, compatibility,
and final semantic output. Record:

- source/simplified nodes and candidate counts;
- evaluated cells and exact integer operations;
- peak RSS and retained artifact bytes;
- cycles, instructions, branches, branch misses, and wall time; and
- paired-log t-scores over rotated interleaved rounds.

The control is identified by a Git commit or tracked patch, never a cached
binary. Retain simplification as a pipeline default only when the exact work,
memory, or hardware advantage resolves without worsening the small-DAG gate;
otherwise retain the universal pass as an explicit optional diagnostic stage
and record the negative.

## Deferred successors

After this tranche, choose from measured evidence:

1. seal a supplied reachable domain and admit exact observational reductions;
2. add a complete structural implication/certificate adapter;
3. fuse repeated column evaluation if it dominates cold compile cost; or
4. measure expression-graph width and import exact treewidth extraction only
   when its parameterized bound beats flat enumeration.

No successor changes the diagnostic authority of this initial pipeline.
