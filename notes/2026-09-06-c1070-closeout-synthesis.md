# C1070 closeout synthesis: exact compositional leakage analysis as an Ergodis product

**Lane**: `ergodis`
**Task**: C1070, open-ended product exploration from Astra's two brainstorms of 2026-09-06.
**Brief**: `2026-09-06-c1070-ergodis-compositional-leakage-brief.md`.
**Status of this file**: synthesis and recommendation. Every verdict below is owned by the dated
probe report it names; this file adds no new claim.

## 1. What was asked and what was found

Astra proposed reading the labelled prescribed-coset recovery theory of the *Exact Compositional
Transfer of Bounded Linear Recovery* manuscript as a privacy interface: compile a hierarchical
linear encoding into the minimum-cost coalitions that recover a *named* secret functional, or leak
at least `t` symbols, with coefficient witnesses; then extend that to transcripts of repair,
refresh, and masking operations. Twelve probes ran in one session (probes 4, 7, and 10 added on Tavis's call), each with a dated report, a
committed generator, a certificate, and an independent cross-check; the coordinator reviewed every
proof and every reported number against the report and the code before accepting it.

| Probe | Question | Verdict | Report |
|---|---|---|---|
| 1 | Do the labelled costs compose when each level carries a mask space? | Yes. Masks are label pinning: the masked cost is the mask-free cost on the enlarged message space with the target pinned to zero on mask coordinates. Composition holds under per-block mask freshness; shared masks must be promoted to a message coordinate at their lowest common level; the fresh formula can only overstate privacy, never understate it. | `2026-09-06-c1070-probe1-mask-quotiented-associativity.md` |
| 5 | Interface on the mask-free tower case. | Built: per-class minima with witnesses, direct `t`-profile, JSON and summary, brute-force cross-check. | `2026-09-06-c1070-probe5-privacy-interface-tower-case.md` |
| 3 | Per-level budgets as vector costs. | Pareto antichains per class and per `t`, cross-checked; the core already has the partially ordered monoid and front types but its transfer stack is scalar. | `2026-09-06-c1070-probe3-vector-costs.md` |
| 2 | Can the `t`-profile avoid subspace enumeration, via the quotient? | Yes, and without the quotient: the profile is a coalition-side quantity, one best-first sweep gives every `t`. Greedy subspace extension fails only under heterogeneous costs. The compositional quotient pays for itself only on towers too large to flatten. | `2026-09-06-c1070-probe2-leakage-profile-from-quotient.md` |
| 0 | What exists, what to cite, what to absorb. | Every adjacent literature is amount-only or unlabelled in composition; freshness is assumed everywhere and verified nowhere; the IronMask and maskVerif gadget corpora are a ready benchmark. No novelty verdict, by design. | `2026-09-06-c1070-probe0-prior-art-survey.md` |
| 6 | Transcript state along a protocol. | The state is the observed row space; nothing coarser is exact against an unrestricted next observation. Retired randomness contracts the state exactly, and proactive refresh is that contraction. Mask reuse is a one-sided rank-drop alarm. | `2026-09-06-c1070-probe6-transcript-state.md` |
| 8 | One library surface. | `ergodis_private::leakage::{LeakageProblem, analyze}` and the `leakage` subcommand; masks pinned in the compiler, profile by the sweep, every committed artifact regenerates byte-identically. | `2026-09-06-c1070-probe8-leakage-module-unification.md` |
| 9 | Benchmark against published verdicts. | 75 linear gadgets ingested from IronMask and maskVerif, 54 settled exactly, all agreeing with the published probing order, zero disagreements, 21 budget-limited partials. | `2026-09-06-c1070-probe9-gadget-corpus-benchmark.md` |
| 7 | Legitimate versus illegitimate recoverability. | Same labelled cost function on two target and unit models; Astra's constrained form is the epsilon-constraint form of a two-objective Pareto problem, complete for every front point, and coincides with the front exactly when the adversarial values on the legitimate minimizers form an antichain. `leakage-design-report` returns the front with both sides' witnesses; a locality-versus-parity family shows a genuine trade-off, full-reconstruction requirements collapse the front to a point. | `2026-09-06-c1070-probe7-constrained-recoverability.md` |
| 10 | Do uniform unit costs force an optimal leaked-subspace chain? | No, in both the coalition and subspace versions, already in the pure probing model: with single-coordinate unit-cost units the profile is the generalized Hamming weight hierarchy and the conjecture is Wei's chain condition. Probe 2's measurement was a parameter artefact (its families were not unit-cost and stopped at ambient 3). Two proved sufficient conditions survive as run-time checks; otherwise probe 2's `t`-factor bound. | `2026-09-06-c1070-probe10-uniform-cost-chain.md` |
| 4 | Labelled Wei duality through the tower. | No: two binary four-leaf towers with identical labelled profiles have duals whose labelled profiles differ; the missing invariant is leaf-class multiplicity, and ambiguity is the norm. Projective towers are a proved sufficient condition. Amount profiles dualize by Wei; labels never do. | `2026-09-06-c1070-probe4-labelled-duality.md` |

## 2. The product claim, stated once

The engine answers, for an explicit linear protocol over a finite field with a stated observation
model, *which* secret linear combination a coalition can reconstruct, at what minimum cost, with the
coefficients that do it, and it does so compositionally through encoding towers and along
transcripts. Three properties distinguish it from the surveyed tools:

1. **Labelled composition.** The composed answer is exact, not a sufficient condition, and it names
   the functional. The masking-verification tools decide the same rank condition per gadget and
   compose through unlabelled non-interference notions; the secret-sharing and secure-storage
   literatures compute amounts.
2. **Freshness verified, not assumed.** Every surveyed tool takes fresh randomness as a model axiom.
   Here freshness is a checked hypothesis, shared randomness is promoted and costed, and the
   direction of the error when it is missed is a theorem: an unverified freshness assumption always
   overstates privacy.
3. **Both sides of the audit.** The same cost function evaluates legitimate repair and adversarial
   leakage, so a design family can be searched for its Pareto front with witnesses on both sides.
4. **A transcript state with a contract.** The row space with named coordinates is the only exact
   state; any compression is a published statement about the future (retired randomness or a unit
   menu), and the mask-reuse alarm is sound.

Scope, to be stated wherever the claim is: the linear-uniform model over a finite field. No
non-uniform priors, no noisy or adaptive observation, no nonlinear operations, no implementation
side channels, no computational privacy.

## 3. Recommendation

Ship it as an Ergodis capability, in this order:

1. **The unified `leakage` surface as it stands** (probe 8), with probe 9's corpus as its regression
   suite and probe 5's direct method as the test oracle.
2. **Freshness verification and reuse detection as the headline feature**, because it is the one
   thing no surveyed tool does and its failure direction is proved.
3. **The transcript analyzer** (probe 6) for distributed-storage repair and refresh audits, with the
   retired-randomness contraction as the stale-state metric.
4. **Defer** the compositional quotient route until a customer tower is too large to flatten; probe
   2 showed it loses on every tower in hand.

Whether a paper is carved out of this is a separate decision. Probe 0 recorded read depths and no
novelty verdict; a paper claim would need the two unopened tight-composition papers read and
MathSciNet covered.

## 4. Open items and successors

Allocated work needs a C-ID; none is allocated here.

- **Certified incremental mode** (probe 10): the two proved sufficient conditions for an optimal
  chain (all profile gaps one; `Γ_{t−1} = t−1`) are cheap run-time checks that could gate an
  incremental profile mode, falling back to the sweep.
- **Design families beyond exhaustive enumeration** (probe 7): the front search is exhaustive over
  the candidate family; larger parameterized families need pruning by the labelled bounds.
- **Schema migration**: delete the five per-probe subcommands once each certificate is regenerated
  under the unified schema, as one task with report updates (probe 8, section 7).
- **Vector search on the core monoid**: needs the capped monoid to expose an unsaturated total or a
  wider witness; both blockers are stated at the point of use in `leakage.rs` (probe 8).
- **Scale**: exact search closes at roughly 80 wires; the quadratic-wire add and copy gadgets from
  eight shares up stall (probe 9). Wire count, not share count, controls.
- **Two-level masked instance** cross-checked against the masked min-sum tables (probe 8).
- **Menu-quotient mode** for probe 6's finite-future case.
- **Discovery-track leads**: the greedy-structure lead (graduated into probe 2) and probe 6's
  coupled-but-additive fraction, both in `ergodis-discovery-track.md`.

## 5. Consolidated mystery ledger

Each probe carries its own ledger; this lists what remains open across them.

| Observation | Status |
|---|---|
| Uniform unit costs never produced a greedy-chain failure in 1.4 million instances. | **Settled by probe 10**: the measurement was a parameter artefact; the conjecture is Wei's chain condition and fails from ambient dimension 5 (blocks) or 6 (single wires). |
| Share of shared-mask queries that disagree with the fresh formula grows with `q` (about 8, 18, 35 per cent at `q` = 2, 3, 5). | Open, low value; no downstream claim rests on it (probe 1). |
| Coupled-but-additive fraction sits near 0.52 in larger ambients and higher in the two smallest binary ones. | Open subspace-counting lead, discovery track (probe 6). |
| The manuscript's finiteness bound for the contextual quotient is written for a chain; under vector costs it needs an antichain argument. | Reasoning only, not a proof (probe 3, Part C); moot while the quotient route is deferred. |

| Under labelled duality, 84 of 92 labelled-profile classes at `q = 2, k = 3, n = 7` are ambiguous for the dual. | Settled as the norm, not an anomaly (probe 4): leaf-class multiplicity is the missing invariant. |

Everything else raised during the probes was settled inside the probe that raised it.

## 6. Provenance

Two brainstorms from Astra on 2026-09-06. Structural claims: all held. Landscape claims: the
relative-weight secret-sharing connection is established, as Astra said; the claim that the
manuscript already acknowledges it was false, the manuscript contains no privacy reading at all.
Code: `~/src/ergodis-private`, modules `hierarchical_leakage`, `masked_leakage`,
`leakage_structure`, `vector_leakage`, `transcript_leakage`, `leakage`, `gadget_corpus`,
`leakage_design`, and the chain-search and dual-tower report tools; public core
`~/src/ergodis` untouched throughout. Evidence bundles under `notes/data/2026-09-06-c1070-probe*/`
with `SHA256SUMS`.
