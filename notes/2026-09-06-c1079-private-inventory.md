# C1079 private/C1016 evolve inventory

**Lane:** `ergodis`
**Scope:** read-only inventory of `~/src/ergodis-private`, primarily its
C1016 mechanisms, as input to the C1079 synthesis.  No claim below upgrades a
candidate or a measured result to a theorem.

## Evidence revision and boundaries

The private checkout was at `74b7ca9243b1` when inspected (2026-09-06); its
working tree had no reported changes under the inspected source paths.  This is
the Tier-1 private library plus Tier-2 `tasks/hadamard-2092` adapter, not a
core implementation or release surface.  `AGENTS.md` assigns reusable private
proof synthesis, evolve adapters, feature DAG/quotient/PAF machinery, and
campaign RPC/controller adapters to Tier 1, while keeping task-specific
campaigns in Tier 2 (lines 27-39).

The authoritative C1016 task card says that proven structural results and
exact enumerations grant negative coverage, while observed/evolved/heuristic
predicates never do (`notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`,
lines 57-60).  Its live unrestricted arm is a full-neighbourhood tabu search
over exact q29 margin shells and q174/carrier repair, and it records the
margin-fibre control gate rather than claiming an unproved exclusion (lines
100-152, 186-205).  This is an important existing separation: a search result
can direct the campaign without being a reduction.

## Reusable private capabilities

| Capability | Evidence at `74b7ca9243b1` | Status and reuse value |
|---|---|---|
| Bounded candidate relation discovery | `src/proof_synthesis.rs:16-70` exhaustively enumerates bounded homogeneous relations; `:80-83` requires an exact full-row replay after the modular nullspace fast path. | Implemented candidate generator with a local replay check. It is not a general theorem discovery system or a domain-validity proof. |
| Registered-extractor proof replay | `src/proof_synthesis.rs:220-262, 291-321, 386-393, 423-480`; `src/q29_even_moment_proof.rs:1-14, 51-52`. | Strong retention candidate: sealed extractor identity/version/parameter/source commitments, bounded Horn closure, and replay against a registered rule registry. The q29 adapter explicitly distinguishes a proved moment predicate from an observed/evolved retained root. |
| C1016 theorem-shape corpora | `src/banked_rule_evolve.rs:1-9, 78-187` has ten registered proof-rule ablation systems; `src/banked_semantic_evolve.rs:1-39, 78-241` has fourteen residual-coordinate corpora. | Implemented discovery/backfill training fixtures. Labels are recomputed from sealed mechanisms; they are not independent discovery evidence. Retain as regression/admission inputs, not as a fixed theorem catalogue. |
| Counterexample-driven admission spike | `tasks/hadamard-2092/src/evolve/theorem_gap.rs:1-12, 42-50, 604-639`. | Useful CEGAR-shaped experiment: blind evolve proposals and an exhaustive declared conjunction domain are replayed against a direct model; rejects retain counterexamples and uncompilable mutations are never silently admitted. Explicitly one planted family, not evidence of cross-domain admission soundness. |
| Unix-socket campaign control | **Documented behavior, not source-verified in this inventory:** `docs/CAMPAIGNS.md:1-6, 47-57, 127-131, 264-295`. The private adapter does import the core control API in `tasks/hadamard-2092/src/evolve/blind_holdout.rs:8-9`; the protocol implementation/schema itself belongs to the core and was not inspected here. | Documented experimental-v0 control surface with per-run endpoint/manifest, epoch-conditional mutations, bounded ledger/briefs, and watcher-mediated safe-point activation. Socket isolation and boundedness are reuse candidates; neither proves autonomous operation nor grants theorem authority. |
| Candidate language and proposers | `docs/CAMPAIGNS.md:133-166, 198-246`. | Typed bounded expression/bytecode plans, deterministic mutate/evolve, behavioural deduplication, scoped genomes, and a bounded tree synthesizer. All current outputs are diagnostic theorem shapes; independent proof is mandatory before sound solver use. |
| Exact live ordering experiment | `docs/CAMPAIGNS.md:277-352`. | One C880 alignment adapter applies only score ordering while every branch remains in exact DFS. It protects the hot loop and has matched-control/probation gates, but the document records a remaining 1.81x slowdown and lacks online dispatch. Reuse the safe-point/control discipline, not this performance result as a general policy. |

## C1016-specific implementation and results

The private adapter has a real `evolve` command family (`tasks/hadamard-2092/src/evolve/`) and proof/
quotient modules.  The C1016 card records fourteen independently replayed exact
reductions and the closure of the multiplier-assumed programme, but leaves the
unrestricted bordered search open (`notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`,
lines 70-99).  The standing move order is wider margin-fibre moves, per-shell
replication, then the plain `Z/523` shard (lines 186-205).  Thus the reusable
lesson is a ladder of explicitly scoped quotients with control experiments,
not a universal quotient selection algorithm.

The best concrete provenance example is the q29 moment adapter:
`src/q29_even_moment_proof.rs:1-14` names its predicates structural and
canonically recomputed, while `:51-52` encodes the theorem as
`ProvedStructural` and its root as `ObservedEvolved`.  The generic mechanism
enforces that only `ProvedStructural` and `ExactComputational` permit pruning
or negative coverage (`src/proof_synthesis.rs:299-321`).  This directly
supports the C1079 rule that a heuristic/proof-generating *run mode* must not
be inferred from candidate origin.

## Terminology/data-model gap affecting C1079

In the inspected generic proof-synthesis and C1016 campaign surfaces, existing
code has useful pieces but does not represent the C1079-required dimensions
independently:

* `GenericProofStatus` is a validation-like enum, but `ProvenanceClass` mixes
  origin-like labels (`ObservedEvolved`, `HeuristicSearch`) with validation
  outcomes (`ProvedStructural`, `ExactComputational`) at
  `src/proof_synthesis.rs:291-321`.
* `DerivationTranscript` has one extractor, one goal digest, one status and one
  provenance field (`:386-393`).  It has no separate theorem candidate and
  parameter-candidate lineage, no parent/mutation graph, no validity scope or
  side conditions per instantiation, and no search-mode obligation record.
* Extractor commitments are valuable but only bind the extractor/version,
  parameter digest, and source commitment (`:220-262`).  They do not by
  themselves record imported versus generated/evolved/composed origin, run
  inputs/configuration, validation evidence, or justified evidence reuse after
  mutation.

This is a synthesis requirement gap, not a reproduced correctness defect:
C1016's documented policy is sound and individual adapters preserve it, while
the inspected generic artifact cannot express the fuller C1079 lifecycle.
One possible synthesis direction is to retain its admission guard and add
separate candidate-lineage, validation/scope, and run-mode records; this report
does not decide whether that replaces, wraps, or refactors the enum.

## Control-plane fit and limits

The *documented* socket protocol is a plausible substrate for steering an
autonomous system: it exposes status, agent briefs, candidate
testing/application, obstructions, traces, exceptional-state ranking, an
observational ceiling, batch/evolve, and synthesis (`docs/CAMPAIGNS.md:169-246`).
The same documentation says watcher compilation swaps only at safe points
(`:277-295`).  These claims require a core-protocol source/schema inspection
before being treated as implementation-verified retain decisions.

The documentation lists autonomous-persistence/lifecycle limitations: no
restart restoration, disk compaction of equivalent ledger entries, proof
handles, or multi-policy dispatch (`docs/CAMPAIGNS.md:354-360`), and a cold
routing policy that does not change during a job (`:103-125`).  Treat these as
documented C1079 gaps pending source verification.  A possible plan may make
the socket an observation/control API over durable run/candidate/evidence
records; this inventory does not prescribe that architecture.

## Priority-ranked synthesis inputs (requirements gaps, not bug findings)

1. **High — provenance/validation representation gap.** The generic enum and
   transcript cannot express the user-required independent theorem and
   parameter lineage/scope.  Reproduce by serializing any
   `DerivationTranscript`: no fields can distinguish an evolved-but-validated
   theorem from an imported-but-unvalidated one, or record a parameter
   descendant's validation.
2. **High — proof-mode obligation not found in inspected surfaces.** No inspected private transcript or
   campaign schema identifies proof-generating versus heuristic run mode or
   records coverage invalidation when a mode/candidate changes.  Existing
   pruning methods are the correct narrow guard, but are not a run contract.
3. **Medium — autonomous feedback is only partly present in the inspected/design-documented surfaces.** Evolve uses frozen
   labels plus bounded live profiles, and cold policies remain non-adaptive.
   The theorem-gap spike supplies counterexamples, but only on a planted
   family.  Retain its replay/rejection artifact as the seed of a CEGAR loop;
   do not generalize its measured acceptance result.
4. **Medium — no shared quotient objective/evaluator was found in the inspected surfaces.** C1016 has
   measured q29/q174/carrier ladders and controls, while the controller has
   observational ceilings and throughput probation.  There is no common
   object that prices discovery/compilation cost, solve savings, memory, and
   proof scope across candidate quotients.
5. **Low — private documentation still frames this as diagnostic control.**
   That is accurate for the current implementation but stale as the sole
   product framing after C1079's explicit autonomy direction.  Update wording
   only after the proposed architecture/data-model decision; do not relabel
   existing v0 results as autonomous.

## Candidate synthesis options, not an architecture decision

Options supported by the inventory are to retain registered extraction/replay,
exact bounded endpoints, counterexample artifacts, feature-vocabulary ceilings,
immutable create-only evidence, and paired operational controls; to consider
adapting the C1016 quotient ladder into candidate objects evaluated against
separate exactness, cost, and search-savings criteria; and to avoid treating the
fixed C1016 move set, a frozen theorem catalogue, diagnostic-only plan roles,
or one C880 routing policy as product limits.  Socket control/watcher claims in
this paragraph remain documentation-derived pending core source/schema review.
