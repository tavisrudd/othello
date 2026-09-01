# ADR: Correctness assurance architecture for Ergodis

**Date:** 2026-08-31
**Status:** proposed — decision memo only; adoption requires the Ergodis-owning lane's agreement
**Scope:** how Ergodis-produced paper-facing claims are proved or certified correct. No code is
changed by this document. Every recommendation that touches the Ergodis core is a request to its
owning lane, with its cost stated, not a work order.

## Context

Ergodis is now the evidence base under paper-facing claims. In the past week it produced exact
quantum-code minimum distances that replace published upper bounds, an exhaustive multi-cell
parameter sweep supporting a conjecture, censuses over billions of projective points, and certified
negative statements of the form "no object of this kind exists in this domain".

The exposure is asymmetric. A positive result ships a witness — a codeword, a support, a
configuration — that an independent checker validates in seconds. An exhaustion claim ships
nothing: it rests entirely on the searcher having actually enumerated its stated domain, with its
symmetry reductions sound, its pruning rules admissible, and its shard accounting complete. A
silent bug in a canonical-form routine or a pruning bound does not produce a wrong answer that
looks wrong; it produces a confident negative that is unfalsifiable from outside. Every "exact
minimum distance" claim contains such a negative as its lower-bound half: the witness certifies
"distance at most d", and only the exhaustion certifies "no lighter logical operator exists".

The repository already has a trust discipline this memo must extend, not duplicate:

- `notes/research-reproducibility-conventions.md` — atomic evidence bundles (report + generator +
  certificate + hashes), replay commands, stated trusted boundary of every checker, independent
  replay or an explicit reason none exists, negatives stated with exact domain and stop condition.
- `notes/formal-annotation-conventions.md` — the `\evidence` annotation layer pinning manuscript
  statements to registered evidence bundles, gated by a checker with digest pinning.
- `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md` — the Lean-side trust spine:
  declared gates, exact per-terminal axiom sets, generated-data provenance, portfolio axiom
  inventory.
- `lean/CLAUDE.md` — Lean work runs only through the guarded entry points
  (`lean/scripts/guarded-lean`, `lean/scripts/lean-build-queue.py`); certificate regeneration only
  in an owned build window; every computationally discharged Lean claim must state whether it is
  kernel reduction, a proved checker, native evaluation, an imported certificate, or an axiom.

What the existing discipline does **not** cover is the gap this memo prices: the conventions
guarantee that an Ergodis run is *reproducible* — same binary, same inputs, same output — and that
its claim is *recorded* with hashes and replay commands. Reproducibility is not correctness. A
deterministic searcher with an unsound pruning rule reproduces its wrong negative perfectly, and an
independent replay of the same binary replays the same bug.

## The question

Not "should we verify Ergodis" in the abstract, but: **which assurance architecture buys the most
credibility per unit of effort, given what our claims actually rest on?** The options are laid out
below with what each covers, what it provably does not, its realistic cost, and which existing
claims it would strengthen.

**Proposed decision, in one paragraph.** Do not verify Ergodis; certify its claims, check its
premises, and test its prunes. Concretely: make a negative-claim checklist (planted witnesses in
random orbit positions, with/without-reduction reconciliation, shard coverage ledger,
candidate-count fingerprints, independent re-derivation from the statement) a mandatory extension
of the existing reproducibility conventions; emit and independently check small *premise
certificates* for the symmetry layer, starting with the anchor-soundness condition under the
`[[756,16,d]]` claims; and for flagship negatives, re-derive the claim through an independent
proof-logging pipeline (SAT/pseudo-Boolean with a formally verified checker, or SCIP exact with
VIPR where the claim is ILP-shaped) rather than instrumenting the optimized search — the
Lam's-problem playbook, which requires no Ergodis changes at all. Lean's role is a small verified
checker of record for our compact certificates now, and a formalized encoding plus imported proof
only for a result that displaces a published bound. Full functional verification of the kernels
is rejected; proof logging inside Ergodis itself is deferred until the certified-distance product
needs per-run certificates.

## Decision drivers

1. **Negative and exactness claims are the exposure.** Positives are already cheap to check; the
   architecture must be judged by what it does for exhaustion claims.
2. **Trust concentrates in four places**: symmetry reduction and canonical forms; pruning and
   bounding rules; the arithmetic layer (finite fields, bit-parallel kernels, overflow); and the
   sharding/resume logic that decides whether a search covered its stated domain. (Detailed in the
   risk-surface section below.)
3. **Effort is the scarce resource.** This is a small research codebase under active performance
   work; an assurance mechanism the owning lane will not maintain is worth nothing.
4. **Lean is the in-house prover** with an established guarded build discipline, generated-
   certificate experience, and the C326 trust spine to hang new checkers on. Any Lean-side work is
   bound by `lean/CLAUDE.md`.
5. **Paper claims and product claims need different protection.** A paper claim needs to convince a
   referee once, with a frozen artifact; a product claim (the certified-distance pitch: every run
   emits something a customer verifies far more cheaply than the run cost) needs per-run
   certificates with a checker whose trusted base is small and stable.

## Risk surface of the artifact

Ground truth from a source-level survey (2026-08-31) of
`papers/complete-repair-ports/ergodis/src/`, `ergodis-private/src/`, and this week's campaign
reports. The headline pattern: **positive-direction verification is uniformly excellent, and
negative-direction assurance is nearly absent — and the assurance investment is inversely
correlated with claim exposure.** Every witness in the campaign set is re-verified from its
definition (`checked_incumbent_result` recomputes syndrome and logical observation from the
support; the weight-36 witness was re-checked by a third code path; BP-OSD outputs are re-verified
over GF(2)). Nothing comparable exists on the negative side. Meanwhile `css_distance.rs` — the
kernel behind every published distance claim — is the least-tested large kernel in the tree (a
handful of unit tests on toy fixtures, no property tests, no debug assertions in HEAD, no Python
parity coverage), while `scheduler.rs`, `orbit.rs`, and `observational.rs`, which back no
published claim, carry property-test suites and dense assertions.

### Where trust concentrates

**1. Symmetry premises are declared, not verified.** The 378-fold anchor reduction behind the
`[[756,16,d]]` claims comes from `anchors: [0, 378]` — a hardcoded literal in
`papers/complete-repair-ports/ergodis/python/generate_bb_native.py`; nothing computes or checks
it. The search core's own docstring (`css_distance.rs`, `search_bounded`) states the required
condition precisely: the anchors must cover the coordinate orbits of a verified symmetry action
preserving *both* the physical kernel *and* the logical-zero subspace. The C1018 verification
checked only the first half (the two `Z_21 × Z_18` generators preserve the GF(2) row space of the
checks); the logical-subspace half is unverified. `semantic_symmetry.rs` says the same in its
module doc: it certifies coordinate orbits only; the domain adapter is responsible for proving
invariance of the feasible family and objective. A wrong anchor set never invents a codeword — it
silently loses them. Blast radius: negatives only, including the lower-bound half of every exact
distance.

**2. Pruning rules, hand-replicated.** Four pruning rules in `css_distance.rs`, copied across
five near-identical inner loops (serial, Rayon branch-partition, prefix expander, two compact
backends), with one documented divergence between the serial and parallel copies already present.
In order of danger: (i) the even-parity skip — if the all-ones vector lies in the physical row
space, odd radii are skipped, and this supplies the `+2` in `d >= 28`; the functional returned by
`binary_all_ones_functional` (hand-rolled elimination with label bookkeeping) is never validated,
though the validation is a two-line check (`dot(functional, column.syndrome) == 1` for every
coordinate); (ii) greedy conflict packing (`syndrome_packing_exceeds`) — which at survey time
carries an uncommitted, untested working-tree edit adding a second reverse-order pass, contrary to
`PERFORMANCE.md`'s own A/B rule; (iii) Bloom completion filters — one-sided by construction
(no false negatives) *provided* insert and query compute the same key and the saturation/fallback
paths always produce all-ones rather than partially filled filters; (iv) the degree lower bound
(safe; its inputs are true maxima). All four corrupt negatives only: over-pruning loses codewords,
under-pruning costs time. The concurrency layer, by contrast, is the best-assured part of the
tree: the controller fan-out ADR states a one-sided contract (stale or lost bounds only add work),
witnesses are re-verified before publication, and parallel runs preserve exact candidate counts.

**3. The arithmetic layer is thinner than the claims assume.** Neither crate sets
`overflow-checks` for release builds, so campaign binaries wrap integer arithmetic silently; bare
`+=` on narrow accumulators exists in census code (`hadamard_2092.rs`). The C1017 review found
four arithmetically unsound input ranges in a rejected overlay (unchecked narrowing casts, a
non-terminating multiplicative-order loop, `prime * prime` overflow in an Euler-phi routine) — by
review, not by any test. The core supplies only prime fields and GF(4), no general GF(p^h) and no
null-space API, so campaign drivers reimplement field towers, Gaussian elimination, projective
indexing, and group actions locally — dozens of private binaries each potentially carrying an
uncovered arithmetic layer. The one SIMD kernel (`semantic_sets.rs`, runtime-dispatched
ternary-partition kernels) has a genuine differential test against a direct profiler, but on a
single hardcoded family; divergence outside it would be host-dependent and silent. Blast radius:
both directions — a wrapped counter corrupts a census in either direction; a wrong inverse can
fake or hide a witness.

**4. Sharding has no coverage ledger.** `CssSearchShard` partitions a deterministic frontier by
`branch_index % count`, and its docstring is the entire guarantee. The frontier itself depends on
`count`, so shards run with mismatched `count` partition nothing. Nothing records which shards
ran, checks that all completed, or refuses a global conclusion from a partial set — the union is
assembled by hand outside the tool. Shard output is at least labelled distinctly
(`bounded-search-shard`) and barred from the incumbent-certification path. There is no resume for
search progress, and compiled artifacts do not survive core revisions. The sharding path is also
essentially unexercised: the flagship exhaustion ran unsharded hours before the flags landed.
Blast radius: negatives only, and in the worst way — a lost shard is byte-identical to an
exhaustion that found nothing.

**5. The private "proof" layer is a re-run trigger, not a certificate.** The `*_proof.rs`
verifiers (`reduction_proof.rs`, `quotient_paf_proof.rs`, `g53_sparse_q4_proof.rs`, and siblings
under `ergodis-private/src/`) re-run the searcher and the oracle from the same crate and compare
both against constants baked into the same module. What they genuinely establish: the Horn-rule
transcript replays against a sealed rule registry, extractor provenance is not forged (a real
defence against the exact unsoundness the C1017 review caught — a producer labelling arbitrary
data to obtain pruning authority), and searcher and oracle agree. What they do not provide: an
artifact an outsider can check without re-running the producer's own code.

### What already exists and is worth keeping

Genuine independent checkers: `group_action::verify_permutation_orbits` (two-sided orbit
certificate: spanning-forest reachability down-rank plus closure of every generator image) and
`verify_binary_gl_rref` (idempotence, invariance, and an independently derived closed-form count);
`hall.rs`'s matching and deficient-set verifiers; the g53 q4 brute-force oracle
(`g53_sparse_q4_oracle.rs`), a deliberately different second implementation asserted equal to the
theorem-driven compiler; and the plane-order-12 Python helper, which re-derives every claim from
the mathematical statement *without* the driver's normalizations and adds positive controls
(prime-power orders must be nonempty; known-empty orders must be empty) — the best assurance
pattern in the campaign set and the template to generalize. Budget caps fail closed everywhere
checked (explicit errors, never truncation). Planted-witness ground-truth generation exists for
exactly one driver (`bin/certiis.rs`) and for no exhaustive search kernel.

### The negative-claim ledger

What currently stands between a silent bug and a wrong published claim, per claim:

| Claim                                                                | Current protection                                                                                     | Residual exposure                                                                                        |
|----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `[[756,16,d]]`, `d >= 28` (5.6e11 candidates, radius-26 exhaustion)  | Input regenerates byte-for-byte to the same hash; radius-22 conclusion reproduced on a newer core      | Everything else: hardcoded anchors, unvalidated parity functional, Bloom filters, packing bound; one impl |
| g53 order-2092 shard empty at q0–q4                                  | Two genuinely different implementations agree on all misses and probe counts                            | Shared mathematical premise (mod-7 roots, row targets, orbit multiplicities feed both); one dropped equation justified by an untested identity |
| g91 shard impossible at q0 (Diophantine endpoint)                    | Nine-case endpoint, independent double loop, hand-checkable in a minute                                 | Effectively none — the model claim itself                                                                 |
| g41 reduction to 768 necessary roots                                 | Flat oracles enumerate all raw assignments; scope deliberately limited to exclusion authority           | Shared model premise                                                                                      |
| g133: 11.0M of 26.8M mod-four roots excluded at q0                   | Retained roots carry reconstructed witnesses                                                            | Excluded roots rest on the compiler's own arithmetic alone; no second implementation                      |
| No planar (157,13,1) difference set; no order-7 collineation, order 6 | Independent Python re-derivation without driver normalizations; per-rejection Hall certificates; positive controls | Small                                                                                                     |
| Brouwer exceptional census, q in {5..31}                              | Two implementations agree on every count                                                                | Both are the same session's reading of the definitions; per-q exhaustiveness rests on a driver-level transitivity argument |

Also in the ledger as near-misses: the rejected C1016 overlay that granted pruning authority on a
field name (caught by review; public Ergodis now advertises `proof_authority: false`), and an
accepted-without-bisect candidate-count drift at radius 22 between core revisions — the drift was
written off as "candidates is not a stable replay fingerprint", which discards the only cheap
end-to-end detector of a pruning regression, since an over-pruning bug and a legitimate pruning
improvement are indistinguishable under that reading.

## The options

### Option A — full functional verification of the search kernels

Prove, in Lean or another prover, that the optimized Rust kernels implement their specifications:
that canonicalization computes a true canonical form, that every pruning rule is admissible, that
the parallel search visits every node of the reduced tree.

**Verdict: not remotely proportionate, and it would not even be the strongest option.** The cost
is person-years (Flyspeck was about twenty person-years, and it did *not* verify its search code —
it checked certificates). Verifying the actual optimized artifact means proving bit-sliced
finite-field kernels, SIMD paths, lock-free work sharing, and every pruning heuristic sound, then
either extracting a slow verified executable or maintaining a refinement proof against a codebase
under active performance work — the ADRs of the last two days alone reworked the parallel bound
fan-out. Every subsequent optimization reopens the proof. And the payoff is capped: a verified
searcher still leaves the encoding gap (does the formal specification match the mathematical
claim?) and the hardware-error exposure of CPU-year runs, both of which certificate checking on
independent hardware handles better. Nobody in the surveyed landscape verifies the producer; the
field's entire architecture is built on not needing to. Rejected.

### Option B — certificate checking with a verified checker

Leave the search unverified. Have it emit, per claim, a certificate sufficient for an independent,
small, ideally formally verified checker to validate the claim without trusting the search. For
positives this is the witness we already ship. For negatives it requires Option C's machinery,
which is why B and C are one architecture with two halves.

**Verdict: this is the right architecture, and it is the standard answer everywhere the survey
looked — with one correction to how it is usually pitched for us.** The correction: for our
flagship negatives, the certificate does not have to come *from Ergodis*. Instrumenting the
optimized search to emit proofs is Option C's cost; but a claim can instead be *re-derived* through
an independent pipeline that natively emits verified-checkable proofs — exactly how Lam's problem
was certified (the 1989 custom search was never instrumented; the claim was re-established via
SAT+CAS with DRAT certificates, more cheaply than the original run). "Certify the claim, not the
tool" decouples the assurance architecture from the Ergodis core entirely, which also dissolves
the lane-ownership constraint for this layer. Where the claim is ILP-shaped, SCIP 10.0's exact
rational mode already emits VIPR certificates off the shelf at a 3–10x slowdown, with zero proof
engineering — and the quantum-codes lane's own queued next step (rerunning the gross-code
formulations with orbital branching in SCIP/Gurobi) is one flag away from this. What Option B
cannot cover: the encoding gap (does the CNF/PB/ILP model the mathematical claim — closed by a
written adequacy argument, or in the limit by formalizing the encoding), and claims too large for
any independent pipeline (see the ceiling section).

### Option C — proof logging for exhaustive search

The searcher emits, alongside its answer, a machine-checkable proof of the exhaustion itself:
every branching step, every pruning step, every symmetry-breaking step justified in a formal proof
system, checked by an independent (ideally verified) proof checker. This is how the satisfiability
world made unverified solvers trustworthy (DRAT/LRAT logs, verified checkers), and pseudo-Boolean
proof logging (VeriPB with dominance-based strengthening, checked by CakePB or lifted into Lean by
PBLean) extends it to exactly our shape: symmetry-broken exhaustive search with certified
nonexistence answers, deployed in production in the Glasgow Subgraph Solver.

**Verdict: the correct long-term shape for a *product*, premature as a retrofit.** Three facts
gate it. First, every pruning inference must be expressible as a cutting-planes derivation: the
parity skip and the degree bound translate naturally (parity and cardinality reasoning are
established in VeriPB), greedy packing is a sum of bounds, but the Bloom completion filters are
themselves compiled from an auxiliary enumeration — logging them means logging that enumeration
too — and the algebraic reductions in the private campaign layer (character-energy censuses,
quotient transfers) have no automatic rendering. Second, retrofitting proof emission onto bespoke
research search outside the CP/SAT community is essentially unprecedented; this is months of work
by someone fluent in cutting-planes proof systems, inside a hot loop whose owning lane guards
every instruction (the fan-out ADR accepted a half-percent cycle cost only after interleaved
A/Bs — proof logging costs a constant factor on that loop). Third, checking historically runs
10–100x solve time, which matters at our scales. Adopt the *format discipline* now (design any
new certificate schema so a VeriPB/kernel-format emission remains possible), revisit actual
emission when the certified-distance product needs per-run certificates rather than per-claim
ones, and use Option B's independent-pipeline route for paper claims in the meantime.

### Option D — certifying algorithms (per-run witnesses of self-correctness)

In the McConnell–Mehlhorn–Näher–Schweitzer sense: restructure each algorithm so every run emits a
witness that the *run* was correct, checkable by a simple checker. Distinct from C in granularity:
not a proof of the full exhaustion, but strong per-component witnesses.

**Verdict: adopt selectively, for the premises rather than the search.** The structural limit is
exactly our problem: a negative answer needs a co-witness backed by a duality theorem, and generic
nonexistence has none — pushed to completeness, this option degenerates into "the certificate is
the search transcript", i.e. Option C. But the *premises* of our searches are certifiable in this
sense, and that is where the ledger shows the trust actually pooling. The anchor reduction's
soundness condition is a finite linear-algebra statement per instance (each group generator
preserves the stabilizer row space *and* fixes the logical-zero subspace setwise): a run can emit
that as a small certificate, checkable in seconds by an independent script — converting the
hardcoded `[0, 378]` from a trusted literal into a checked premise. The parity functional is a
one-line-per-coordinate witness of its own defining property. `group_action.rs` and `hall.rs`
already do this for orbits and matchings; the pattern generalizes. Two dualities from the survey
are worth a cheap probe: the Delsarte/LP (or SDP) dual bound on minimum distance — when it happens
to be tight, the lower-bound half of a distance claim gets a rational, seconds-checkable
co-witness and the exhaustion becomes merely confirmatory — and Farkas certificates for any
LP-derived bound. Cost per premise certificate: hours to days each, and the checker can live
outside the core.

### Option E — assurance that is not proof

Differential testing against independent implementations (GAP/Magma/SageMath, or a second in-house
implementation in a different style), metamorphic testing (the answer must be invariant under
relabelings, field automorphisms, input shuffles), property-based testing of the algebraic
kernels, planted-witness positive controls (inject an object the search must find; a miss is a
caught pruning bug), mutation testing of pruning predicates, redundant recomputation under a
different algorithm or shard decomposition, and the independent-replay discipline already
practiced.

**Verdict: mandatory floor, highest credibility per hour, and it is what referees at the venues
that publish this kind of result actually check for.** The McKay standard — independent
implementations with different algorithms, mass-formula/orbit-counting reconciliation, exact
reproduction of every published smaller case — is the de facto acceptance bar for computational
classification; formal certificates are a differentiator, not a gate, at those venues today. The
survey and the risk map agree precisely on the highest-yield items for us: (i) planted witnesses
*in random orbit positions* for every exhaustive kernel, so the symmetry reduction must carry the
plant back to a canonical representative — the single most dangerous untested direction, and today
no exhaustive kernel has one; (ii) mutation testing (`cargo-mutants`) aimed at the pruning
predicates specifically — a pruning rule no test can distinguish from a stronger one is untested;
(iii) metamorphic group-action invariance (`canon(g·x) == canon(x)`, identical answers and counts
under random group elements), plus with/without-reduction agreement at small parameters; (iv)
reduced-parameter distance cross-checks against Magma's `MinimumWeight` (a genuinely independent
exact algorithm with a provable running lower bound) and QDistRnd for the upper-bound half; (v) a
coverage ledger for sharded runs — completion tokens carrying the input-spec hash, shard
parameters, binary hash, and node counts, with a checker that refuses to assemble a global
negative from a partial or mismatched set, plus a rerun under a *different* shard decomposition,
the one check that catches boundary bugs no fixed decomposition can see; (vi) treating exact
candidate counts as replay fingerprints again — a drift between core revisions gets bisected and
attributed, not waived. Limits, stated plainly: none of this is proof; a shared wrong premise
passes every differential test built on it (the g53 pair of implementations shares its
mathematical model, and the Brouwer census's two implementations share one session's reading of
the definitions), and hardware error at CPU-year scale is untouched by any single-machine
discipline.

## Comparison

Coverage of the actual failure modes, per option. "Core buy-in" marks whether the Ergodis-owning
lane must change code.

| Failure mode                                   | A: verify kernels | B: certify claims | C: proof logging | D: premise certificates | E: testing floor |
|------------------------------------------------|-------------------|-------------------|------------------|-------------------------|------------------|
| Unsound anchor / symmetry premise              | yes, at huge cost | yes (indep. pipeline) | yes           | **yes, cheaply**        | partially (plants, metamorphic) |
| Over-pruning bug in an inner loop              | yes               | yes               | yes              | no                      | **mostly** (plants, mutation, count fingerprints) |
| Arithmetic wrap / driver-local field bug       | yes               | yes               | partially        | no                      | **mostly** (proptest, differential) |
| Missing shard / coverage gap                   | yes               | yes (leaf-coverage obligations) | yes | via ledger invariants   | **mostly** (ledger + second decomposition) |
| Encoding gap (model does not match the claim)  | no                | no                | no               | no                      | partially (indep. re-derivation from the statement) |
| Hardware error at CPU-year scale               | no                | **yes** (check elsewhere) | yes       | partially               | partially (sampled reruns) |
| Cost (realistic)                               | person-years, reopened by every optimization | days–weeks per flagship claim | months, hot-loop tax | hours–days per premise | days–weeks total |
| Core buy-in needed                             | total             | **none**          | total            | small, or none (external checker) | small (test-side) |

Two readings of the table drive the decision. First, no single option covers the encoding gap —
only an independent re-derivation *from the mathematical statement* (the plane-order-12 Python
helper pattern) or, at the top of the range, a formalized encoding does; that check must exist at
every tier. Second, the two options with the best coverage-to-cost ratio (B and D) are exactly
the two that need no core buy-in, which is what makes a recommendation adoptable this week rather
than after a lane negotiation.

## What the community accepts (external practice, surveyed 2026-08-31)

The survey below is what the recommendation calibrates against. Full citations are in the closing
source list.

**Satisfiability.** The community-normative architecture is: untrusted solver emits a proof log
(DRAT, elaborated to LRAT with propagation hints), a small formally verified checker replays it —
`cake_lpr` is verified down to machine code including parsing and file I/O. Scale is no longer the
constraint: Boolean Pythagorean triples (200 TB proof), Schur number five (about 2 PB), Keller
dimension 7, packing chromatic number 15, empty hexagon number 30 — all checked with verified
checkers. What the proof covers is only that the CNF is unsatisfiable; the *encoding gap* — does
the CNF model the mathematics — is the acknowledged dominant residual risk, closed either by a
written adequacy argument or by formalizing the encoding (the empty-hexagon work formalized the
encoding in Lean, so the final theorem is about points in the plane, not a CNF).

**Pseudo-Boolean proof logging — the closest published shape to Ergodis.** VeriPB (Gocht,
Nordström and coauthors) logs cutting-planes proofs over 0/1 constraints, and — this is its
distinguishing contribution — its redundance and dominance rules let *symmetry-breaking and
dominance pruning* be justified inside the proof, with the witness maps carried in the log rather
than trusted (Bogaerts–Gocht–McCreesh–Nordström, AAAI 2022 / JAIR 2023). The Glasgow Subgraph
Solver emits VeriPB proofs in production for its nonexistence answers: an exhaustive,
symmetry-pruned search whose negatives are certified. A CakeML-verified kernel checker (CakePB)
closes the chain, and PBLean (2026) checks VeriPB kernel proofs inside Lean 4, producing Lean
theorems. Costs: logging is a small factor on solve time; checking historically 10–100x solve
time, improving; and — the load-bearing caveat — every pruning inference must be *expressible* as
a cutting-planes derivation. Algebraic pruning (orbit computations, invariant-theoretic bounds)
has no automatic rendering, and retrofitting emission onto bespoke research search is essentially
unprecedented outside the CP/SAT community.

**Certified nonexistence in combinatorics.** Lam's problem (no projective plane of order 10,
1989) is the canonical statement of our exposure: a landmark negative resting on custom code with
no certificate. Its re-verification (Bright–Cheung–Stevens–Kotsireas–Ganesh, AAAI 2021) used
SAT+CAS with isomorph-free generation and produced about a terabyte of DRAT nonexistence
certificates covering every stage — cheaper than the original search and third-party checkable.
Countervailing data: R(4,5)=25, the 17-clue Sudoku minimum, and most design-theory nonexistence
results were accepted on *independent reimplementation*, not certificates; and the Erdős
discrepancy SAT proof was superseded by Tao's short human proof, a caution about the market value
of a large certificate per se.

**Optimization.** Exact rational MIP with certificates is now shipped software: SCIP 10.0's
`exact` mode emits VIPR certificates (LP-duality Farkas multipliers per derived constraint, plus a
machine-enforced obligation that branch-and-bound leaves *cover* the branching disjunctions) at
roughly 3–10x slowdown over floating-point defaults. `viprchk` is small and unverified but
independently reimplementable. For an exact-optimality claim that can be posed as a
tractable-size integer program, this is the cheapest certified route in the landscape: zero proof
engineering.

**Computer-assisted proof landmarks.** The four-colour theorem and Kepler settle a structural
question: when a computation has certificate structure, verified *checking* of certificates is
accepted at the top of the field (Flyspeck discharged its enormous linear-programming component by
checking Farkas dual certificates inside HOL Light, not by re-running the LPs); full functional
verification was needed only where no compact witness exists at all (the four-colour discharging
argument). Interval arithmetic without any formalization (Helfgott, Tucker) is likewise accepted
for numerics. The refereeing question has become: *what is your trusted base, and can I re-check
the result myself in a day on my own hardware?*

**Certifying algorithms (McConnell–Mehlhorn–Näher–Schweitzer).** Each run emits a witness whose
validity implies the answer; LEDA shipped this (planarity: embedding or Kuratowski subgraph; max
flow: flow plus min cut). The structural limit is exactly our problem: a *negative* answer needs a
co-witness backed by a duality theorem, and generic "no object exists in this domain" has none —
in that case the certifying-algorithm idea degenerates into "the certificate is the search
transcript", which is precisely what DRAT and VeriPB formalize. One duality is worth naming for
codes: a Delsarte LP (or SDP) lower bound on distance with a rational dual certificate is a short,
seconds-checkable co-witness — when it happens to be tight, the exhaustive search becomes merely
confirmatory.

**Census/classification practice (the McKay standard).** The de facto referee standard at the
venues that publish computational classifications (JCTA, JCD, Math. Comp., Designs Codes and
Cryptography) is: precise algorithm description; mass-formula / orbit-counting double counts
(`Σ |G|/|Aut(X_i)|` reconciled against an independently computed total — the discipline's real
workhorse for *completeness* of a classification, no certificate involved); agreement with all
known smaller cases; ideally two independently written programs with different algorithms; and
published code and data. Formal certificates are a differentiator, not a gate, at every such venue
today.

**Sharded coverage as its own trust problem.** The only place "did the shards cover the domain"
is machine-checked rather than bookkept is cube-and-conquer: the cube set's disjunction must be a
tautology, itself checked (and cake_lpr's compositional format makes per-shard proofs compose into
one theorem with the checker enforcing coverage). VIPR's leaf-coverage obligation is the same idea
for branch-and-bound. Everywhere else, coverage is engineering discipline: shard indices as
prefix ranges of one canonical enumeration (so coverage is a statement about a function, provable
on paper, not a property of a job queue); completion tokens that make "crashed" distinguishable
from "found nothing"; boundary and total reconciliation; re-running under a *different* shard
decomposition (boundary bugs are invisible to any fixed decomposition); resume-equals-fresh-run
property tests on checkpointing; and sampled reruns on different hardware — fleet-scale studies
(Google's "Cores that Don't Count", Meta's silent-data-corruption measurements) put undetected CPU
miscomputation at rates that matter at CPU-year scale, which is independently the strongest
argument for checking certificates on hardware other than the machine that produced them.

## Recommendation

**Do not verify Ergodis. Certify its claims, check its premises, and test its prunes.** In
priority order, with costs and ownership:

**R1. Adopt a negative-claim checklist as an extension of
`notes/research-reproducibility-conventions.md`** (owned here, no core changes; drafting cost is
an afternoon, per-claim cost is hours). A paper-facing exhaustion or exactness claim must ship,
in its evidence bundle: a planted-witness positive control in a random orbit position at the
claim's own parameters or the nearest reachable ones; a with/without-symmetry-reduction
reconciliation at a reduced parameter; an independent re-derivation *from the mathematical
statement* (plane-order-12 helper pattern — different normalizations, its own positive controls),
or a stated reason none exists; for sharded runs, a coverage manifest (every shard's completion
token: input-spec hash, shard index and count, binary hash, node count) validated by a ledger
checker that refuses a global negative from a partial or mismatched set, plus one rerun under a
different decomposition; and the exact candidate count recorded as a replay fingerprint, with any
cross-revision drift bisected before the claim ships. This is Option E made mandatory, and it is
the tier the survey says referees actually look for.

**R2. Emit and check premise certificates for the symmetry layer** (Option D; checker lives
outside the core, so the near-term version needs no lane agreement). First target: an
independent script that verifies both halves of the anchor-soundness condition for the
`[[756,16,d]]` instances — each symmetry generator preserves the stabilizer row space *and* fixes
the logical-zero subspace setwise, and the anchor set covers the coordinate orbits — replacing
the hardcoded `anchors: [0, 378]` premise with a checked one. Hours of work; it closes the
largest single hole under the largest single claim. Request to the owning lane, at its
convenience: have the driver emit this certificate per run and validate the parity functional
(`dot(functional, column) == 1` for every coordinate — a two-line startup check in a cold path,
no hot-loop cost).

**R3. Certify flagship negatives through independent proof-logging pipelines, not by
instrumenting Ergodis** (Option B; no core changes at all). For a headline nonexistence or
lower-bound claim, re-derive it in a pipeline that natively emits verified-checkable proofs:
encode "a kernel word of weight at most R with nonzero logical observation exists" as CNF or
pseudo-Boolean, let a proof-logging solver refute it (cube-and-conquer for scale), check the
DRAT/LRAT or VeriPB output with cake_lpr or CakePB — the Lam's-problem playbook, which never
touched the original searcher. Where the claim is ILP-shaped, use SCIP exact mode with VIPR
output first: zero proof engineering, and the quantum-codes lane's queued orbital-branching rerun
is the natural pilot. Also run the cheap probe from Option D: compute the Delsarte LP dual at the
claimed parameters; if it is tight, the lower bound gets a rational co-witness for free. Cost:
days to weeks per flagship claim, paid only for claims that headline a paper. The written
encoding-adequacy argument is part of the bundle; it is the one gap no checker closes.

**R4. Raise the testing floor of the load-bearing kernels** (requests to the owning lane, each
small and none touching hot-loop semantics): enable `overflow-checks` in release profiles for
campaign binaries (or a dedicated `campaign` profile) and measure the cost before rejecting it;
`cargo-mutants` over the four pruning predicates with tests that kill the mutants; property tests
for `css_distance.rs` at small parameters (serial vs parallel vs compact backends on random
instances, not just toy fixtures); a differential test for the SIMD ternary-partition kernels on
randomized families rather than one hardcoded one; and reduced-parameter distance agreement with
Magma/QDistRnd wherever ranges overlap. Days of work total; this is where the inverse correlation
between assurance investment and claim exposure gets fixed.

**R5. Lean enters at two points only, both through the guarded discipline of `lean/CLAUDE.md`**
(no direct `lake`; builds via `lean/scripts/lean-build-queue.py`; certificate regeneration only
in an owned build window; C326 provenance for any generated certificate data). (a) Near term: a
small kernel-checked checker for our own compact certificates — the anchor-soundness certificate
of R2 and witness re-verification — is weeks of work and gives the *checker of record* a minimal
trusted base; it fits the existing certificate-package pattern (`.#verify` apps) and the
formal-annotation layer's `\evidence` registry as-is. (b) Prestige tier, only for a claim that
displaces a published bound people rely on: import an R3 proof into Lean (LRAT via reflection, or
VeriPB kernel format via PBLean) and formalize the encoding, so the final theorem is about the
code, not about a CNF — the empty-hexagon template. Months; justified at most once per flagship
result, and explicitly not a default. Full functional verification of the Rust kernels (Option A)
is rejected outright.

**Explicitly not recommended now:** retrofitting VeriPB emission into `css_distance.rs` or the
private campaign layer (Option C) — adopt its format discipline in any new certificate schema and
revisit when the product needs per-run proofs; a full second fast implementation of the search
(a slow, obviously-correct reference at small parameters, which R1's controls effectively
require, buys most of the value at a fraction of the cost).

## The ceiling, stated plainly

Some claims are not checkable by any means cheaper than rerunning them, and the architecture
above does not pretend otherwise. In that category today: the multi-billion-point census claims
and the g133 exclusion mass (the excluded roots have no witnesses by construction, no second
implementation, and no proof log — R1's controls and a differently-decomposed rerun are the best
available, and the paper prose must say the claim rests on a tested but unverified computation);
and the `[[756,16]]` radius-26 exhaustion *unless and until* an R3 re-derivation at that scale
succeeds — the SAT community routinely refutes instances of comparable and larger search volume
under cube-and-conquer, so this is plausible but unproven for our shape, and until it lands the
claim's protection is R1 + R2, not a certificate. The g91 Diophantine endpoint sits at the other
extreme: hand-checkable, effectively at the ceiling of assurance already. Papers should state,
per claim, which of these tiers it sits in — the existing reproducibility convention's "what the
output certifies and what it does not" field is the right slot, and the negative-claim checklist
of R1 makes the tier explicit.

## Paper claims versus product claims

These need different protection, and the certified-distance pitch conflates them. A *paper* claim
is frozen: one artifact, one referee, checked once — R1–R3 protect it, and the per-claim cost of
an independent re-derivation is acceptable because it is paid once. A *product* claim ("every run
emits something the customer verifies far more cheaply than the run cost") needs per-run
certificates from the production searcher itself, which is exactly Option C — the one tier this
memo defers. So the pitch, scrutinized: it survives **fully for the upper-bound half** (a witness
checks in seconds against hours of search — dramatically cheaper, today, with no new work);
it survives **for ILP-shaped claims** via VIPR (checking a branch-and-bound certificate is much
cheaper than solving); it **does not survive today for the exhaustion half** of an exact
distance, where verification currently equals rerun, and even with mature proof logging the
realistic number from the SAT/PB world is that checking costs the same order as solving, sometimes
more — cheaper *per relying party* and on *their* hardware (which is the real value: hardware
error and vendor trust drop out), but not "dramatically cheaper" in CPU terms. If the product
pitch is to include certified lower bounds, Option C's costs come due, and the time to design for
it is when the certificate schema is first frozen — which is a reason R2's premise certificates
should adopt VeriPB-compatible conventions where they naturally fit, and a reason the Delsarte
dual probe matters: parameters where the LP bound is tight get a seconds-checkable lower-bound
certificate with no proof logging at all.

## Foreign issues raised, not acted on

Observed during the survey; all belong to the Ergodis-owning lane and are recorded here only so
they are not lost. (1) The private proof/reduction layer — every `*_proof.rs`, the g41/g53/g91/
g133 modules, `hadamard_2092.rs`, and the private test tree — is untracked in git; the g53 and
g91 nonexistence claims currently rest on code existing in one working tree, which the
reproducibility conventions already forbid as sole evidence. (2) `syndrome_packing_exceeds`
carries an uncommitted, untested edit in the live pruning path, contrary to `PERFORMANCE.md`'s
own A/B rule. (3) The radius-22 candidate-count drift between core revisions was accepted
without a bisect. (4) The committed release binary cannot run the large distance claims (feature
flags absent), so a reviewer following the README reproduces nothing; and the campaign report and
the code disagree about whether shard splitting exists.

## Constraints restated

- The Ergodis core is owned by another lane. This memo recommends; adopting anything here requires
  that lane's agreement. The core-touching items (R2's driver-side emission, all of R4, the
  hygiene items in the foreign-issues list) are requests with their costs stated; R1, R2's
  external checker, R3, and R5(a) proceed without core changes.
- All Lean work respects `lean/CLAUDE.md`: guarded entry points only, no direct `lake`
  invocations, certificate regeneration only inside an owned build window, and the C326 spine's
  provenance rules for any generated certificate data.
- The ceiling section names the claims not checkable by any means cheaper than a rerun; nothing
  above implies uniform coverage.

## Key sources

Verified SAT proof checking: Tan–Heule–Myreen, cake_lpr (TACAS 2021; STTT 2022, including the
compositional format that machine-checks shard coverage); Cruz-Filipe et al., LRAT (CADE 2017);
Heule–Kullmann–Marek, Boolean Pythagorean triples (SAT 2016); Heule, Schur number five (AAAI
2018). Certified symmetry/dominance breaking: Bogaerts–Gocht–McCreesh–Nordström (AAAI 2022; JAIR
77, 2023); Gocht–McCreesh–Nordström, certified subgraph solving (IJCAI 2020); VeriPB/CakePB, SAT
Competition 2025 checker documentation. Certified nonexistence: Bright–Cheung–Stevens–Kotsireas–
Ganesh, a SAT-based resolution of Lam's problem (AAAI 2021); Lam, The search for a finite
projective plane of order 10 (Amer. Math. Monthly 1991). Optimization certificates: Cheung–
Gleixner–Steffy, VIPR (Math. Prog. Computation); SCIP Optimization Suite 10.0 exact mode (2025).
Landmarks: Gonthier, four-colour theorem (Notices AMS 2008); Hales et al., Flyspeck (Forum of
Math. Pi 2017). Certifying algorithms: McConnell–Mehlhorn–Näher–Schweitzer (Computer Science
Review 2011). Lean import paths: LRAT-Catcher (arXiv:2607.00815); PBLean (arXiv:2602.08692);
Subercaseaux et al., formal verification of the empty hexagon number (ITP 2024); Kirchweger–
Manrique–Szeider, formally verified graph generation with SAT modulo symmetries and Lean (2026).
Classification practice: Kaski–Östergård, Classification Algorithms for Codes and Designs
(Springer 2006); McKay–Radziszowski, R(4,5)=25 (J. Graph Theory 1995). Quantum-code distances:
QDistRnd (JOSS 2022). Hardware error rates at scale: Hochschild et al., Cores that Don't Count
(HotOS 2021); Dixit et al., Silent Data Corruptions at Scale (2021).
