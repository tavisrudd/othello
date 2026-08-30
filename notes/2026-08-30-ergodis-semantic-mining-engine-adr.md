# ADR: Ergodis semantic mining engine

**Date:** 2026-08-30
**Status:** accepted for private incubation

## Decision

Move the repeated Python search-to-theorem workflow into an optional private
Ergodis layer driven by declarative **semantic mining recipes**.  Python remains
the fast hypothesis laboratory.  Stable operations migrate to allocation-free,
streaming Rust kernels; every promoted result carries an independent replay
artifact.  Nothing problem-specific enters the public Ergodis core until at
least two domains use the same abstraction.

The engine does not claim to prove discovered lemmas.  It produces a compact
lemma packet:

```text
domain and exact label predicate
semantic feature and symmetry declarations
pure/extremal strata with support counts
minimal orbit or parametric representatives
fitted exact identities
nearest counterexamples and ablations
finite implication/replay certificate
remaining source-language proof obligations
```

## Why

The current manual loop is effective but repetitive:

1. stream a finite certificate table;
2. invent a semantic representation;
3. compute exact features and find a separator;
4. quotient the exceptional rows by symmetry;
5. fit a finite-field formula;
6. recognize a classical action or structural family;
7. restate the finite result as a lemma and identify its proof gap.

The C973 control compressed 2,106 extremal witness pairs to one additive-plane
two-point switch, one divided-power translation orbit, and semilinear
equivariance.  A second pass found that all 6,890 split `e_3` locators are
within four replacements of an affine plane.  The exact ambient census has
4,686,825 nine-sets; precisely 2,106 have maximum affine-plane overlap four,
and all 2,106 are nine-caps.  None satisfies the `e_3` Hankel label.  An
automated engine should surface the candidate lemma

> a split nonic with `g2=g3=0` contains five points in an affine `F3`-plane

without requiring a human to hand-write three successive Python probes.

The next geometric canonicalization pass sharpens this further.  All 2,106
overlap-four sets are nine-caps, and `AGL(3,3)` is transitive on them: its order
is 303,264, the orbit has size 2,106, and the stabilizer has order 144.  This is
**not** yet a one-case Hankel proof.  Arbitrary `F3`-affine maps do not preserve
GF(27) multiplication or the fixed label `g2=g3=0`.  Even the relevant
`AGammaL(1,27)` action moves the `e_3` syndrome under translations.  The fixed
label stabilizer `GammaL(1,27)` has orbit size 78 on a cap, leaving 27 cap
orbits.  A sound canonicalizer must either prove label preservation or carry
the transformed label and quotient `(object,label)` pairs.

## Plan algebra

The plan language has exactly three transform verbs:

```text
match          attach exact semantic matches/features to streamed objects
reduce         aggregate, extremize, ablate, filter, or retain bounded cores
canonicalize   quotient retained objects by actions or exact parameterizations
```

`verify` is a mandatory gate around a plan, not a fourth transform.  Sources
and sinks are execution plumbing.  Domain words such as `affine_plane`,
`carry_state`, or `hall_deficit` name typed match adapters, not engine ops.

The C973 plan can therefore read:

```text
source split_nine_sets
match affine_subspace(rank=2, metric=max_overlap) as plane
reduce histogram(plane.overlap), minima(label=g2_g3_zero)
canonicalize under [translation, scaling, frobenius]
canonicalize fit divided_power_orbit(parameter=z4)
canonicalize near_misses under AGL(3,3)
verify replay_hankel, action_preservation, source_hash
sink lemma_packet, bounded_exceptions
```

The ops compose as a typed dataflow.  `match` may fan out bounded feature
columns but may not serialize.  `reduce` must declare its memory bound and
retention policy.  `canonicalize` runs only on a reducer's bounded retained
set unless explicitly supplied a streamed orbit partition.  This prevents an
innocent plan from materializing the full search corpus.
Every `canonicalize under action` op must declare whether the action preserves
the label, transports it through an exact action adapter, or is diagnostic
only.  The verifier rejects a proof packet built from a diagnostic quotient.

## Recipe model

A recipe has six sections which compile to that three-op algebra:

```text
source      streamed records and fixed-width semantic IDs
label       exact target predicate(s), never a learned surrogate
features    rank, incidence, orbit, support, polynomial, or strategy features
actions     declared generators with exact preservation checks
reducers    histograms, minima, cores, quotients, and parametric fits
gates       replay, negative controls, purity, completeness, and stop rules
```

The first feature vocabulary should be deliberately small:

- finite-set family overlap and hitting profiles;
- prime-field affine-subspace and cap recognition;
- exact rank/block ablation;
- finite group orbit closure and stabilizers;
- finite-field monomial/polynomial interpolation;
- Hall matchings and deficient sets;
- labelled scalar histograms and Pareto fronts.

Candidate generation searches compositions of these typed features to a
bounded depth.  Scoring is lexicographic: exact label purity, domain coverage,
description length, orbit/parameter compression, proof-language relevance,
then computational cost.  Statistical correlation is useful only for ranking;
it cannot pass a theorem gate.

## Execution architecture

1. **Source adapter.** Parse or generate records outside the search loop and
   compile them to fixed-width IDs, bit masks, or sparse sorted arrays.
2. **Feature kernels.** Run zero-allocation Rust loops over caller-sized
   workspaces.  Dense universes up to 64 points use machine-word masks and
   `popcnt`; larger sparse/dense cases choose compressed sorted sets or bitmaps
   by measured density.
3. **Streaming reducers.** Keep bounded histograms, extrema, sketches, and
   representative IDs.  Large witnesses stream directly to create-only files.
4. **Exceptional-state queue.** Only pure, near-pure, rigid, or surprising
   states enter a bounded side queue for orbit closure and verbose analysis.
5. **Symbolic fitter.** Exact finite-field interpolation and action matching
   run off the hot path.  It must emit all aliases and identifiability defects.
6. **Independent verifier.** Re-read the source and proposed packet without
   sharing the mining reducer.  Reject source drift by hash.

Search threads check only the existing cheap steering flag.  Mining reducers
receive batched snapshots outside the solver hot path.  Serialization, JSON,
formula formatting, and orbit narrative never execute in worker loops.

`semantic_sets.rs` is the first Rust kernel: it profiles maximum overlap with a
precompiled mask family and iteratively enumerates fixed-cardinality subsets.
Both steady-state loops allocate nothing and use no recursion.
`semantic-affine-census` is the first end-to-end `match/reduce/canonicalize`
adapter.  In under one second including the release-build check on the current
host, it streams all 4,686,825 masks through the overlap reducer, recognizes
the minimum stratum as caps, and closes its affine orbit.  The hot census loop
allocates nothing; only precomputation and the pre-sized orbit set allocate.
With the frozen labelled-locator TSV attached, the same run performs the full
three-op plan: `match` profiles all 6,890 weighted labelled locators, `reduce`
finds the 2,106-object ambient minimum, and `canonicalize` proves that minimum
is one cap orbit.  Their intersection is exactly zero.

The first five-run counter baseline is compute-bound and stable: 0.17965 s,
873.3 M cycles, 3.905 G instructions, 153.2 M branches, 0.713 M branch misses,
and only 9.2 K cache misses.  This is about 26.1 million ambient objects/s,
186 cycles and 833 instructions per object, IPC 4.47, and a 0.47% branch-miss
rate.  The next kernel optimization target is therefore instruction work in
the 39-mask overlap reduction (batched SIMD/popcount or a theorem-derived
smaller family), not memory layout or branch prediction.

## Python's continuing role

Python is not removed.  It remains the place to create a new feature in
minutes, inspect ten representative rows, and decide whether the idea deserves
engineering.  Promotion requires:

1. exact agreement on a frozen positive and hostile-negative corpus;
2. a stable typed interface used by two recipes or one demonstrably expensive
   campaign;
3. a Rust kernel with pre-sized storage and no hot-loop allocation;
4. a separate replay path;
5. measured end-to-end value, not merely a faster microbenchmark.

This preserves rapid mathematical iteration while preventing Python scripts
from becoming the permanent execution architecture.

## Near-term implementation order

1. Finish the mask-family profiler with a streamed binary/JSONL recipe adapter
   and exact ambient-versus-labelled histograms.
2. Port affine-subspace enumeration and cap recognition, using fixed arrays for
   small prime-field dimensions.
3. Add orbit closure from declared generators and emit one representative plus
   stabilizer/transporter certificates, with exact label-action typing.
4. Port exact parametric fitting and match fitted coefficient rows against a
   catalogue of classical actions (divided powers, Frobenius, torus, affine).
5. Join feature outputs into a bounded separator search and exceptional-state
   ledger.
6. Apply the same recipe API to C80 Hall-deficit packets and C896 carry-state
   rank cores before considering a public API.

## Rejected alternatives

- **Rewrite every exploratory probe in Rust immediately:** too slow for
  mathematical iteration and likely to fossilize bad abstractions.
- **Keep disconnected Python scripts:** fast locally, but repeats parsing,
  field arithmetic, orbit logic, certificates, and failure modes.
- **Use a generic ML feature learner first:** it obscures exact purity and
  source-language proof obligations.  Learned ranking can be added after the
  exact semantic vocabulary exists.
- **Put the miner in public Ergodis now:** premature; the private adapters still
  contain research-process and domain-specific concepts.

## Acceptance gates

- Reproduce the C973 affine-overlap and semilinear-core artifacts exactly.
- Recover the known divided-power translation identity from the recipe output.
- Find the 2,106 ambient nine-caps as the unique overlap-four stratum and show
  zero intersection with the `e_3` label.
- Reject `AGL(3,3)` as a proof quotient for the fixed Hankel label; accept it
  only as diagnostic geometry until a paired syndrome action is supplied.
- Run one C80 and one C896 recipe without adding either problem's vocabulary to
  the kernel layer.
- Demonstrate zero allocations in measured Rust feature hot loops and bounded
  memory under streamed evidence.

Vibe: the architecture is now clear and grounded in three different
certificate modalities; the risk is overbuilding the recipe language before
two more real campaigns force its minimal shape.

Replay the landed ambient census with:

```bash
cargo run --release --manifest-path ergodis-private/Cargo.toml \
  --bin semantic_affine_census -- \
  --labelled-tsv notes/reed-solomon-tasks/c973-gf27-switch-probe/out/e3-ninesets.tsv \
  --output /path/to/create-new.json
```
