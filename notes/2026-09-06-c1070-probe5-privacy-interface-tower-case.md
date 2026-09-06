# C1070 probe 5 — privacy interface, mask-free tower case

**Lane**: `ergodis`
**Task**: C1070 probe 5 (the engineering probe of the compositional-leakage brief
`notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`).
**Code**: `~/src/ergodis-private` — tier-1 module `src/hierarchical_leakage.rs` and the tier-2
subcommand `tasks/tools/src/leakage_profile.rs`. `~/src/ergodis` core is unmodified; nothing in it
needed to be exported for this probe.
**Evidence**: `notes/data/2026-09-06-c1070-probe5/` (inputs, machine-readable reports,
human-readable summaries, `SHA256SUMS`).

## 1. What the interface does

Given

- a hierarchical linear encoding — a tower of concatenated represented linear codes, with no fresh
  randomness at any level,
- a secret subspace given as a set of message functionals (`row A`), and
- an observation model — coalitions of coordinates at any level, whole-block or partial, each unit
  carrying its own cost,

the interface produces

1. for each projective class of secret functional in `row A`, the minimum-cost coalition that
   recovers it, with the coefficient witness that reconstructs it from the observed coordinates
   (or the statement that the functional is private against every coalition in the model);
2. the `t`-symbol leakage profile for `t = 1..dim row A`, computed by the **direct** method — the
   minimum over `t`-dimensional subspaces `T ⊆ row A` of the labelled cost of recovering `T`; and
3. a machine-readable JSON report and a human-readable summary.

The underlying identity is the brief's section 2: for a uniform message the leakage of `A z` to a
coalition `H` observing `B_H z` is `dim(row A ∩ row B_H)` field symbols, so privacy of a named
functional `s` against `H` is `s ∉ row B_H`, and "`H` learns at least `t` symbols" is "some
`t`-dimensional `T ⊆ row A` lies inside `row B_H`". Every question the interface answers is that
membership test plus a minimization over coalitions.

The direct method is deliberate. Probe 2 asks whether the `t`-symbol profile can be read off the
finite contextual quotient without enumerating subspaces; this probe supplies the ground truth that
such a compiled profile must reproduce.

**Scope.** The linear-uniform model only. Masks are absent by construction: the tower is
deterministic concatenation, inner message equals outer symbol. Non-uniform priors, noisy
observations, adaptive observers, and computational (as opposed to information-theoretic) privacy
are out of scope and are not modelled anywhere in the code.

## 2. Input schema

Schema identifier `ergodis.hierarchical-leakage.v1`, JSON, one object.

| field | meaning |
|---|---|
| `schema`             | optional; rejected unless it equals `ergodis.hierarchical-leakage.v1` |
| `name`               | optional label carried into the report |
| `field`              | `{characteristic, degree, modulus?}`; the modulus is low-to-high coefficients of a monic irreducible polynomial, defaulting to the lexicographically first one, the same convention as the engine's `SmallField::new` |
| `message_dimension`  | `k`, the dimension of the message space |
| `levels`             | ordered list of levels; each is `{name?, blocks}` |
| `levels[].blocks[]`  | `{name?, generator}` where `generator` is a `rows × cols` matrix taking that block's input symbols to its output symbols |
| `secret`             | matrix `A`; rows are message functionals, `cols` must equal `message_dimension` |
| `observation`        | `{generate?, units?}`, the union of both |
| `options`            | `{max_cost?, brute_force_check, max_profile_dimension?, search_node_budget}` |

A matrix is `{rows, cols, data}` with `data` row-major.

**Level composition.** Level 0's block input dimensions must sum to `message_dimension`; level `ℓ`'s
must sum to level `ℓ-1`'s total output width. Each level is assembled into a block-diagonal matrix
and the levels are multiplied in order, giving the end-to-end encoding `E` of shape
`message_dimension × leaf_count`. A message row vector `z` encodes to `y = z E`, so leaf coordinate
`i` reveals the functional `E[:, i]`.

**Observation model.** Two forms, freely mixed:

- `observation.generate` is a list of bulk generators: `{"kind": "leaf-coordinates", "cost": c}`
  gives one unit per leaf coordinate; `{"kind": "level-blocks", "level": ℓ, "cost": c}` gives one
  unit per block of level `ℓ` covering that block's whole leaf span.
- `observation.units` is a list of explicit units, each `{name?, cost, coordinates}` for a partial
  observation or `{name?, cost, level, block}` for a whole block.

Blocks partition each level's symbol vector contiguously, so a block's leaf span is a contiguous
coordinate range whenever the deeper levels refine its symbol range. When they do not — a deeper
block mixes symbols from two shallower blocks — that block has no whole-block coordinate set and the
interface fails closed with `UnrefinedBlock` rather than silently over-approximating. Partial
observations remain available in that case.

At most 63 units are addressable, because a coalition is a `u64` mask.

## 3. Output schema

The report carries `schema`, the resolved field (characteristic, degree, order, modulus), the
message dimension, the per-level widths, the leaf count, the end-to-end encoding matrix, the reduced
secret basis and its dimension, the resolved unit list, and then:

- `functional_classes[]` — one entry per projective class of `row A`: the class representative in
  secret-basis coordinates, the message functional itself, `private` (true when no coalition in the
  model recovers it), and when it is recoverable a `recovery` object holding `cost`, `unit_indices`,
  `unit_names`, `coordinates`, and `coefficients` — a one-row matrix over the observed coordinates
  whose combination equals the functional.
- `leakage_profile[]` — one entry per `t`: `subspaces_examined`, `minimum_cost`, the minimizing
  subspace in both secret-basis coordinates and message functionals, and the `recovery` for it, whose
  `coefficients` matrix has one row per basis functional of the subspace.
- `brute_force_checked`, `brute_force_agrees`, and per-entry `brute_force` verdicts recording the
  reported cost, the cost the independent enumeration found, and how many coalitions it examined.
- `spans_reduced` and `nodes_popped`, the auditable work counters.

Numbers are exact integers throughout; there is no floating point anywhere in the analysis.

## 4. Algorithms

**Minimum-cost coalition.** Best-first enumeration of coalitions in nondecreasing total cost. Each
subset is generated exactly once, by adding units of strictly increasing index; unit costs are
nonnegative, so the heap pops subsets in nondecreasing cost and the first recovering subset is a
minimum. Reduced coalition spans are cached by mask across the whole analysis, so the thirteen
per-functional searches and the profile searches share their work.

**Recovery test and witness in one pass.** For a coalition the observed coordinate functionals are
row-reduced together with an identity block recording, for each basis row, the combination of
observed coordinates that produced it. A target functional is then reduced against the pivots; if
the residual vanishes the accumulated combination is exactly the coefficient witness, and if it does
not the coalition does not recover the target. Recovery and witness therefore cost one reduction,
not two.

**`t`-symbol profile.** All `t`-dimensional subspaces of the secret space are enumerated as reduced
row echelon coordinate matrices — every choice of pivot columns crossed with every assignment to the
free positions — and each is pushed through the same minimum-cost search. The enumeration counts are
the Gaussian binomials, asserted in the tests.

**Independent cross-check.** Every reported minimum is replayed by a separate brute force that
enumerates all coalitions of cost at most the reported cost and takes the minimum recovering one.
Its recovery test is a different implementation on purpose: it routes through `ergodis::Matrix`
row-space rank arithmetic (`canonical_row_basis_with`, comparing the rank of the observed rows with
the rank of the observed rows stacked with the target) rather than this module's elimination. A
disagreement fails the subcommand with a nonzero exit status.

## 5. Validation

All results below are the committed reports in `notes/data/2026-09-06-c1070-probe5/`.

### 5.1 The labelled separation, over `F_3` and `F_5`

The brief's witness example: shares `(x, y, x+y)` versus `(x, y, x+2y)`, secret `S = x + y`, every
single share observable at cost 1.

| encoding | field | minimum cost for `S` | coalition | witness |
|---|---|---|---|---|
| `(x, y, x+y)`  | `F_3` | 1 | `leaf2`         | `[1]`    |
| `(x, y, x+2y)` | `F_3` | 2 | `leaf0, leaf1`  | `[1, 1]` |
| `(x, y, x+y)`  | `F_5` | 1 | `leaf2`         | `[1]`    |
| `(x, y, x+2y)` | `F_5` | 2 | `leaf0, leaf1`  | `[1, 1]` |

Both encodings are `[3, 2, 2]` codes with the same uniform matroid, so every unlabelled summary of
them agrees. The labelled cost separates them: in the first the third share *is* the secret, in the
second no single share is correlated with it. This is the manuscript's opening example in privacy
clothing, and it is now a machine check rather than a paragraph. The `t = 1` profile entry carries
the same separation, 1 against 2, because the secret space is one-dimensional here.

### 5.2 Two-level tower over `F_3`

Level 0 is the `[4, 3]` single-parity-check code over `F_3`; level 1 has two `[3, 2]` blocks, the
first `(u, v) ↦ (u, v, u+v)` and the second `(u, v) ↦ (u, v, u+2v)`. Six leaf coordinates. The
observation model has all six leaf coordinates at cost 1 plus both level-1 whole blocks at cost 2,
eight units in total. The secret is the whole three-dimensional message space, giving thirteen
projective classes.

The compiled leaf functionals are `m0`, `m1`, `m0+m1`, `m2`, `m0+m1+m2`, `2m0+2m1`. The reported
per-class minima are 1 for the four classes that a single leaf carries — `m0`, `m1`, `m0+m1`
(equivalently `2m0+2m1`), `m2`, `m0+m1+m2` — and 2 for the rest, each with an explicit two-coordinate
witness. The profile is cost 1 at `t = 1`, cost 2 at `t = 2`, cost 3 at `t = 3`, examining 13, 13
and 1 subspaces respectively. Work: 26 coalition spans reduced, 513 best-first nodes popped.

### 5.3 Two-level tower over `GF(4)`

Same shape over the engine's own example field, `GF(2)[a]/(a^2+a+1)` with modulus `[1, 1, 1]` — the
field `examples/data/transfer-subspace.json` and `examples/data/transfer-tower.json` use. Outer
`[4, 2]` code, two `[3, 2]` inner blocks, six leaves, secret the whole two-dimensional message space,
five projective classes. Four of the five classes cost 1 and the class `m0 + (a+1)m1` costs 2, with
witness `[1, a+1]` over the first two leaves. Profile: cost 1 at `t = 1`, cost 2 at `t = 2`.

This exercises the extension-field path end to end. It is a tower in this probe's schema, not a
re-ingestion of the engine's `transfer-tower` input, which is parameterized differently — see the
open items.

### 5.4 Brute force

Every minimum in every one of the six inputs was confirmed by the independent enumeration; no
reported minimum was contradicted, and no cheaper coalition was found. The two-level inputs have
eight units, so the enumeration sweeps the full 256-coalition lattice for each check, filtered to
coalitions within the reported cost. The unit tests additionally assert monotonicity of the profile
in `t` and the Gaussian-binomial enumeration counts.

### 5.5 Tests

Six tests in `src/hierarchical_leakage.rs`, all passing:

- the labelled cost separates the two three-share schemes over both `F_3` and `F_5`;
- the reported witness coefficients, applied to the encoding columns, rebuild the secret functional;
- the two-level tower's every per-class minimum and every profile entry is confirmed by brute force,
  and the profile is nondecreasing in `t`;
- whole-block units cover exactly their leaf span;
- the projective and subspace enumerations have the Gaussian counts; and
- a functional outside every observation is reported private, with no profile entry at `t = 1`.

## 6. Replay

Working directory `/home/tavis/src/othello/notes/data/2026-09-06-c1070-probe5`. Build once from
`/home/tavis/src/ergodis-private`:

```text
cargo build -p ergodis-tools --release
```

The executable lands in the shared out-of-tree target directory declared by that workspace's
`.cargo/config.toml`. Then, for each of the six stems
`single-level-f3-plain`, `single-level-f3-twisted`, `single-level-f5-plain`,
`single-level-f5-twisted`, `tower-two-level-f3`, `tower-two-level-gf4`:

```text
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools leakage-profile \
  --input <stem>.json --json-out <stem>.report.json --summary-out <stem>.summary.txt
```

The subcommand exits nonzero if the brute-force cross-check disagrees with any reported minimum.
Check the artifacts with `sha256sum -c SHA256SUMS` in that directory. The tests replay with

```text
cargo test -p ergodis-private --lib hierarchical_leakage
```

### Hashes

Generator sources, at `ergodis-private` commit `222dd23d96fe9750f4068aa23aab526b1d3bd98d`:

| file | SHA-256 |
|---|---|
| `src/hierarchical_leakage.rs`        | `03642e334820945cd3c61d424190488729f6a06612b9e4b545324101c3868a61` |
| `tasks/tools/src/leakage_profile.rs` | `07ff867230ce4e49122569605c6fce400db8239d2b9a4ed78be8b8e2ec179e35` |

Inputs and outputs: `notes/data/2026-09-06-c1070-probe5/SHA256SUMS`, committed alongside them.

### What the evidence does and does not certify

The reports certify exact minimum coalition costs and coefficient witnesses **for the stated
observation model** — the units listed in the report, no others. A "private" verdict means no
coalition of those units recovers the functional; it is not a claim about an adversary with a
different or larger observation vocabulary. The brute-force verdict certifies that no coalition
within the reported cost is cheaper; it does not independently re-derive the encoding matrix, which
both paths share. Nothing here bears on masks, non-uniform priors, or noisy observations.

## 7. What the engine already had, and what this probe added

Already in the public core and reused unchanged:

- `SmallField` runtime finite-field arithmetic, including the extension-field tables, which is what
  lets one code path serve `F_3`, `F_5`, and `GF(4)` from the same input schema;
- `Matrix` with `canonical_row_basis_with`, used to reduce the secret matrix to an independent basis
  and as the independent recovery test in the brute-force replay.

Already in the core but *not* usable for this probe as it stands:

- `transfer-subspace` and `transfer-tower` decide labelled recovery for arbitrary-rank targets and
  compose costs through a tower with replayable coefficient witnesses — the machinery this probe's
  successor will call. Both front ends are pinned to base prime 2 and `GF(4)` with modulus
  `[1, 1, 1]`, and both take the represented-encoder parameterization (`columns`,
  `target_coordinates`, `target_normalization`, `outer_functional_dual_basis`) rather than a tower of
  block generators. The brief's own validation example is over `F_3` and `F_5`, so neither front end
  could serve it. That is a front-end restriction, not a limitation of the underlying kernels.

Added here, in `ergodis-private`:

- the tower schema and its compilation to an end-to-end encoding matrix with per-block leaf spans and
  a fail-closed refinement check;
- the observation model — costed units over coordinates at any level, whole-block or partial;
- the reduction that returns the recovery decision and the coefficient witness in one pass;
- the best-first minimum-cost coalition search with a shared span cache;
- the projective-class and `t`-dimensional-subspace enumerations, and the direct `t`-symbol profile;
- the independent brute-force replay routed through the core's row-space arithmetic; and
- the JSON report, the human-readable summary, and the `leakage-profile` subcommand.

No core change was needed. The one function a witness-carrying path would naturally want from the
core — solve `c B = s` for `c`, rather than only decide `s ∈ row B` — does not exist there;
`Matrix::row_space_contains_field` returns a boolean. Rather than export a new core function on the
strength of one probe, the reduction is written locally, and its results are cross-checked against
the core's containment arithmetic. If probes 1 to 3 keep needing it, promoting a
`solve_left`-with-witness to the core matrix module is the obvious extraction.

## 8. Open items for probes 1 to 3

**Probe 1, masks.** The schema has no mask notion, and adding one is not cosmetic. A level carrying
fresh randomness has message space `L × R_inner`, and the question becomes recovery of `s` *modulo*
the mask functionals: the observed row space lives in `(message, mask)` coordinates and the leaked
secret space is `{ uᵀA : uᵀB = 0 }`. In this interface that is a second matrix per level and a
quotient applied before the membership test. The direct method extends to it immediately — enlarge
the coordinate space, project the target — so probe 1 can reuse the coalition search and the brute
force verbatim as its ground truth while it settles whether the associative min–sum survives the
quotient. A concurrent session is building `masked_leakage` in the same repository for exactly that
question; the two modules should be reconciled once both land, and the mask-free path here is the
degenerate case its results must reproduce.

**Probe 2, the profile without subspace enumeration.** The profile computed here is
`min over T of cost(T)` with `T` ranging over the Gaussian-binomial-many `t`-dimensional subspaces of
`row A` — 13 subspaces at `t = 1` and `t = 2` for a three-dimensional secret over `F_3`, and growing
fast in `q` and in `dim row A`. The six committed reports are the ground truth a quotient-derived
profile must match exactly, cost by cost, and the `subspaces_examined` counters are the baseline any
claimed collapse has to beat. The obvious first check for probe 2 is whether the minimizing subspace
is always spanned by cheapest-class functionals; it is in all six inputs here, but that is six
inputs, not a theorem, and the two-level `F_3` tower is the natural place to look for a counterexample
because its inner blocks are deliberately different.

**Probe 3, vector costs.** Costs here are scalars in a `u32` and the search is a plain
uniform-cost sweep. A per-level budget — at most `a` compromised blocks and `b` coordinates per block
— makes the cost a vector and the search a Pareto frontier, which changes the search, the report
(there is no single "the minimum-cost coalition" any more, but an antichain), and the brute-force
comparison. The unit list is already the right place to attach a vector: each unit would carry a cost
vector instead of a scalar, and the block/coordinate structure it already records is what a per-level
budget indexes. Probe 3 should check `scheduler_dominance.rs` and `frozen_shortest_path.rs` in the
core before writing a new Pareto search, as the brief says.

**Also open, smaller.** The engine's own `transfer-subspace` and `transfer-tower` inputs cannot yet
be ingested by this interface, and the reverse translation — compiling a tower spec into the
represented-encoder parameterization those commands take — is what will let the compositional min–sum
be measured against this direct ground truth on the same object. That translation, not a new schema,
is the concrete next piece of engineering.

## 9. Closeout pass (`ej` + `tt`) and mystery ledger

Free upgrades taken during this probe: the recovery test was made to return the coefficient witness
in the same reduction rather than a second solve; the span cache was made shared across all searches
in one analysis, so the per-class and per-subspace searches amortize; the whole-block leaf span was
made fail-closed on an unrefined block instead of silently over-approximating; and the subcommand was
made to exit nonzero on a brute-force disagreement, so the cross-check is a gate and not a printed
opinion.

What a sharper reading asks that this probe does not answer:

| observation | status |
|---|---|
| In all six inputs the minimizing `t`-dimensional subspace is spanned by functionals that are individually cheapest. If that held in general the profile would collapse to a greedy read of the per-class costs and probe 2 would be nearly free. | **Open.** Six inputs is not evidence for a theorem; it is a hypothesis for probe 2 to attack, and the two-level `F_3` tower with its two different inner blocks is where a counterexample would live. |
| The `t = 3` profile cost in the two-level `F_3` tower is 3, exactly `dim row A`, and the whole-block units at cost 2 never win anywhere. | **Settled, and uninteresting.** With every leaf at cost 1 a whole block of three leaves costs 2, so blocks are underpriced and should win — they do not, because three independent functionals are reachable from three singleton leaves at the same cost 3 and the search breaks ties toward the first-generated coalition. The observation model, not the encoding, is what makes block units inert here; a run with block cost below 2 would exercise them. |
| The profile is nondecreasing in `t` in every input, and is asserted so in the tests. | **Settled and structural.** A `t`-dimensional secret subspace contains a `(t-1)`-dimensional one, so its recovery cost cannot be lower; this is a sanity invariant, not a finding. |
| `2m0 + 2m1` appears as a leaf functional in the two-level `F_3` tower and is the same projective class as `m0 + m1`, so the tower has a redundant leaf from the labelled point of view. | **Settled.** It is the arithmetic of the second inner block over `F_3` (`o2 + 2 o3` with `o3` the parity symbol collapsing the `m2` term), not a modelling error; the classes it serves are already served by leaf 2. Worth remembering when building demo towers: a level can silently produce a projectively duplicate coordinate. |

No genuine mystery remains in the mask-free case. The real unknowns are all downstream and named:
whether the associative min–sum survives the mask quotient (probe 1), whether the `t`-profile is
readable off the contextual quotient (probe 2), and whether the quotient stays finite under vector
costs (probe 3).
