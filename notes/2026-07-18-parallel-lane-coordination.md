# Parallel lane coordination: crowns, relconic, and release interfaces

**Date:** 2026-07-18

**Status:** cross-lane execution map for parallel agents. This note allocates no task, changes no
lane peg, and does not supersede the live queue or an owning lane's handoff. The live queue is
single-writer state maintained by the designated queue coordinator.

## Coordination rule

Parallelize task-owned theorem work; serialize shared state.

- A task worker owns only its report, checker, certificate, and task-specific paper/Lean paths.
- A lane integrator is the sole writer for that lane's shared handoff while parallel workers are
  active.
- The queue coordinator is the sole writer for the live queue and queue archive. Workers and lane
  integrators send it the committed task bundle and completion verdict; they do not race it.
- A consumer reads a producer's committed artifact by path and commit. It never edits the producer's
  report, checker, handoff, or paper to make the dependency convenient.
- Paper registries, release-policy documents, and aggregate build state likewise have one named
  writer at a time.
- New manuscript candidates are named by a working alias and working title, never by an ordinal
  placeholder. The current C210/C298 sequel alias is `layered-arcs`.

When a worker finishes a coherent theorem/evidence bundle, it commits the task-owned files first.
The lane integrator and queue coordinator then serialize the handoff and queue/archive completion
transition under the repository's hard completion invariant. Until that administrative transition
lands, the task remains live even if its theorem bundle is committed.

## Ready work and dependency matrix

| Work | Owner | May run now? | Produces | Consumers / gate |
|---|---|:---:|---|---|
| C294 bronze repair | `crowns` | yes | corrected atomic theorem/checker/JSON/checksum bundle for all four proved residue classes | must land atomically before downstream work cites the stronger family |
| C294 frontier and exact-value gates | `crowns` | after an explicit worker/path split | bounded boundary-state data; exact nimbers and strategy excursions for all mixed `PGL2(5)` types | distinct durable reports and owners; only the crowns integrator merges conclusions |
| C295 bounded q=11 reconstruction pilot | `crowns` | after the queue coordinator records the split | intrinsic matching/port decompositions of the uncoloured icosahedron, modulo automorphism, with geometrizability tests | independent of C272; supplies a bounded composition falsifier, not the general theorem |
| C295 general intrinsic reconstruction | `crowns` | no | recovery of uncoloured matching/port decomposition, centres, incidence, code | waits for committed C272 N1 package; C296 consumes only a substantive theorem |
| C296 reconstruction-to-value | `crowns` | no | value derived through reconstructed algebraic data | requires substantive C294/C295 results on one object class and a value proof that consumes the recovered data; separate successes do not clear it |
| C297 normal form/moduli | `relconic` | complete (`3955bf94`) | proper codimension-three scope; exact conic-stabilizer and semilinear quotients; omitted moduli | committed `layered-arcs` scope input; unlocks C301/C304 |
| C302 carrierwise secant-defect stability | `relconic` | yes | equality/stability coupling capacity, repeated hits, and coverage | unlocks C303; possible later input to cap/crowns only after a consumer states a deterministic lemma |
| C300 `PG(2,64)` classification, literature phase | `relconic` | yes | priority boundary, projective/code equivalence plan | classification phase follows its literature gate |
| C305 `q=512` feasibility phase | `relconic` | yes | lossless-chart proof and measured shard bound | full sweep only if the recorded resource gate passes |
| C303 partial-domain two-hypergraph | `relconic` | no | collision-free deletion versus retained relative coverage, including the C298 terminal stars | C298 is complete; waits only for C302 |
| C301 exceptional-incidence dichotomy | `relconic` | yes | first broad bounded-degree full-layer theorem | consumes C297's exact quotient and C298's projection theorem |
| C304 alternative towers/functions | `relconic` | yes | theorem-led alternative architecture pilot | starts from C297's omitted constant-p moduli; no undirected coefficient mining |
| C299 invariant/residue exposition | `relconic` | drafting only | conceptual compression used by `layered-arcs` | starts only with `layered-arcs` drafting; not a C301 gate |

The C84 arithmetic sieve, seeded even-characteristic continuation pilot, and general congruence
ledger are not silently allocated by the zoom-out notes. Assign an owning lane and task under the
normal queue process before an agent begins theorem or implementation work. The public artifact
spine is already split between C270 and C287 below.

## Cross-lane contracts

### `relconic` -> `crowns` / `cap`

C210/C298 proves a legality obstruction and robust collision/transversal dichotomy, not a game
value theorem. C302 may eventually supply a carrierwise dead-set/redundancy identity, but point
counting begins only after `crowns` or `cap` states a deterministic value-preserving consumer. No
agent may cite collision abundance as P-position abundance.

### `continuation` -> `crowns`

The `continuation` lane owns C271--C273, its N1 manuscript, and its Lean library. General C295
consumes the committed C272 N1 theorem package read-only. The bounded q=11 pilot lies below N1's
stable range and may proceed independently after the queue coordinator records that split. Both
routes must recover the projection matching colours and centres intrinsically from an uncoloured
continuation object; automorphism equality or Clebsch vertex count alone is not that theorem. Any
proposed manuscript import returns to the continuation owner for integration.

### `clebsch` / `arcs` / `nofil` -> `crowns`

The bounded Clebsch recognition corollary crosses three publication allocations: `arcs` owns the
q=11 graph/extension identification, `clebsch` owns rigidity and code geometry, and `nofil` owns the
P-reading. `crowns` may state the synthesis in a C295/C296 report but edits none of those papers.
The ten-arc and Pasch foils are useful only if the recovery theorem's domain makes their failure
nontrivial; prefer inequivalent configurations with the same uncoloured graph or the same coarse
intrinsic invariants.

### `cap` <-> `crowns`

C84 owns fourth-centre density and the separate exchange/small-bad-set arrow to `(ON)`. C294 owns
the mixed subfield Cayley scar. They share a failed certificate language, not a proved reduction.
A future C84 arithmetic sieve is cap-owned and must preregister its invariant/formula class before
reading labels; a null rejects only that class.

### `dihedral` -> `crowns`

The `dihedral` lane owns the proper-small-subgroup catalogue and manuscript. Crown I consumes
committed value laws read-only. A congruence-law assembly first needs a coverage ledger and a task;
it is not a license for crowns agents to edit the dihedral paper.

### Release and Lean builds

A public artifact spine is a shared prerequisite, not the sole release gate. The adopted policy is
paper-specific mixed verification: every claim names its route, and every claim labelled
Lean-formalized meets `lean/TRUST.md`. Each paper owner retains its citation,
adequacy/provenance, immutable-release, and rebuild gates.

C287 (`build-sys`) owns the incrementally tagged shared Lean repository's reviewed manifests,
extraction, exact builds, axiom audits, clean-checkout validation, and artifact portability. C270
(`nofil`) owns public identity, metadata, DOI/OEIS and paper-release coordination. C287 does not
create remotes, publish, or push; C270 does not copy sources or run builds. Paper repositories pin
an exact validated shared commit and contain no copied Lean sources.

The `arcs` release preparation currently has no separate lane alias: until one is allocated, the
release coordinator may maintain its release map, while mathematics and manuscript edits remain
with the existing paper owner. `clebsch` is allocated after `arcs` for publication provenance. The
`equivariant-robust-completion` manuscript remains frozen to release-coordinator edits while
`alt-orbit-repair` owns the active C151 theorem boundary; C152 affects release only if its graph
claims are adopted. The `build-sys` lane owns aggregate build orchestration. No parallel agent
launches a heavyweight Lean build outside the unattended queue or edits a shared generated
certificate closure while another build owner is active.

## Recommended parallel batches

### Batch A: independent programs

1. `crowns`: one owner lands the atomic C294 bronze repair. Frontier and exact-value work starts in
   parallel only after the queue coordinator records distinct durable report paths and owners.
2. `relconic`: C302 carrierwise stability.
3. `relconic`: C300's literature phase or C305's measured feasibility phase.
4. release coordinator: apply the mixed-verification policy and prepare C270 metadata alongside
   C287's manifest work, without public action or edits to paper-owned mathematics.

C301 and C304 are now safe additional starts on distinct task artifacts because C297 landed in
`3955bf94`. C300, C301, C302, C304, and C305 must not edit the shared relconic handoff; the lane
integrator merges their milestones serially.

### Batch B: consumers after gates

- Start C303 after C302 lands; treat both C298 terminal stars explicitly.
- C301 and C304 are in the ready pool; consume C297 by committed path rather than re-deriving its
  quotient.
- Start the bounded q=11 C295 pilot once the queue coordinator records its independence from C272;
  start general C295 only after C272 lands.
- Keep C296 gated until substantive C294 and C295 theorems meet on one object class and the value
  proof actually consumes the reconstructed data.

### Release waves

- **Foundation:** C270 fixes identity and metadata while C287 validates the first exact
  `FiniteGeom` + mirror closure; neither performs a public action without explicit authority.
- **First manuscripts:** `nofil` closes C265--C269; `dihedral` has one C264 manuscript writer;
  `arcs` receives its adequacy/provenance and immutable-archive release pass.
- **Dependent allocation:** `clebsch` receives its final release pass after `arcs` is public;
  `complete-ports` waits for specialist citation review; `equivariant-robust-completion` waits for
  the active C151 theorem boundary to freeze, with C152 a gate only if adopted.

## Handoff message format

Each worker reports to its lane integrator with exactly:

```text
task / lane:
commit:
owned paths:
theorem or bounded negative:
replay / validation:
trusted boundary:
consumer-ready interface:
remaining gate:
```

This is a coordination message, not a session transcript. Durable proofs, finite counts, and
negative boundaries belong in the task report; the live handoff retains only the resulting state
map.
