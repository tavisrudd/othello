# Portfolio leverage for ergodis: floor, reach, and spin-offs

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: private analysis; no task allocated by this note; companion to
`2026-08-29-ergodis-commercialization-analysis-memo.md` (arcs and Clebsch
imports, native backend, market and patent verdicts) and
`2026-08-29-portfolio-computational-asset-inventory.md` (facts about the code
assets outside the crate). This note is the synthesis: what in the rest of the
portfolio raises ergodis' floor, extends its reach, or stands alone.

Sources: the asset inventory; portfolio snapshot sections for the Queens and
cap lanes, Reed--Solomon high-weight cosets, AME local-unitary rigidity,
Frobenius eight-arc repair, continuation-graph rigidity, cubic threefolds, the
golden operator programme, Hadamard 668, and the E8 code ladder; and the
2026-08-29 C985 native-backend notes.

## A. Raising the floor (core engine and trust)

1. **Incremental orbit-canonical pruning inside the native CSS search.** The
   Queens solver carries an incremental dihedral canonical key down the
   depth-first search and rejects non-canonical children in place
   (`rust/src/queens/`). The native connected-support search (`css_distance.rs`)
   uses symmetry only at the root through orbit anchors. Bivariate-bicycle
   codes carry translation groups of order 72 and up; the lifted-product codes
   carry non-abelian groups. Carrying the anchor stabilizer's canonical key
   down the constraint-driven tree is the Queens mechanism applied to the
   Dumer--Kovalev--Pryadko tree, and it is the one remaining multiplier that
   `dist_m4ri` does not have. Expected effect: a reduction bounded by the
   stabilizer order on the hundred-billion-candidate enumerations (BB360,
   BB784), which are exactly the runs whose replay cost the patent addendum
   flagged as unverifiable. Highest-value floor item.

2. **Automorphism discovery for arbitrary inputs.** Customers will hand over a
   parity-check matrix, not a group. The Queens Weisfeiler--Leman plus
   individualisation-refinement canonical keys (`queens/graph.rs`) are the seed
   of a Tanner-graph canonicalizer; with it the symmetry tier computes the
   automorphism group from the input instead of assuming it. Without it the
   whole symmetry product depends on the user knowing their code's group. A
   binding to nauty or bliss is the pragmatic route; the in-house keys are the
   fallback and the certificate's independent control.

3. **Exact static filters instead of Bloom filters.** The from-scratch BuRR
   ribbon-retrieval store (`rust/src/burr.rs`, about 1.05--1.1 r bits per key,
   fingerprint membership) can replace the completion Bloom filters in the
   compact and wide backends with an exact static set at similar space. Fewer
   false candidates reach the full-syndrome check, and the persisted
   compiled-filter artifact (the C985 scaling plan) becomes a static
   retrieval structure with a checksummed, versioned layout that already
   exists.

4. **A Lean-verified certificate checker.** The Lean infrastructure (trust
   extraction, certificate firewall, claim-map checker) can host a verified
   checker for the parts of an ergodis certificate that are checkable in
   polynomial time: the weight-`d` witness (in `ker H_X`, outside the
   `H_Z` row space), the isomorphism transport between CSS directions, the
   provenance forward scan, and separator paths. The exhaustion itself is not
   checkable, which is precisely why the checkable parts must be verified to
   the highest standard. This is what makes the certificate credible to an
   IBM-class buyer or a lab, in the way verified DRAT checkers made SAT proofs
   credible; the Lean surface is small.

5. **Fail-closed theorem gating as certificate policy.** The projective
   Reed--Solomon toolkit's classifier refuses to answer when a theorem's
   hypotheses are not met. Adopt the same policy in every ergodis adapter: a
   result is either certified under stated hypotheses or declined, never
   returned with silent assumptions. Cheap, and it is the discipline the
   domain-adapter invariance obligation needs.

6. **Bit-identical vectorization.** The Othello engine's AVX2/AVX-512
   Kogge--Stone kernels are bit-identical to their scalar versions and tested
   as such. The same discipline applied to the packed syndrome words and
   filter probes of the wide backend is a measurable speed item with a
   built-in correctness control.

7. **Value-preserving engine ladders as controls.** The Othello ladder
   (minimax, alpha-beta, ordered, strong) returns identical values with
   different node counts; the QDistSAT BB360 note already used a second direct
   record as an independent implementation control. Make the ladder explicit
   for the CSS backends (compact, wide, large, Gurobi, Kissat) so every
   external claim carries a cross-backend agreement record.

## B. Extending reach (new uses inside existing markets)

1. **Certified transversal-gate discovery for qLDPC codes.** The AME paper
   computes exact projective transversal groups (GRS-based codes attain
   `F_q^2 x| SL_2(q)`; `AME(8,7)` has order 16464) from code automorphisms and
   stabilizer structure. Which logical gates are transversal is the second
   question every qLDPC roadmap asks after distance, because it sets
   magic-state cost. Ergodis' orbit and group-action machinery plus these
   theorems give a certified answer with an explicit Clifford witness. Same
   buyers as distance; Infleqtion's `qLDPC` package is the only tool with
   automorphism machinery aimed at this, and it certifies nothing.

2. **Robust stabilizer-state certification.** Local-unitary rigidity makes
   LU-equivalence of stabilizer AME states a finite local-Clifford question,
   and the quantitative rounding bound (`2 sqrt 2 q^2 epsilon`) turns noisy
   lab data into a certified statement "this state is the intended AME state
   up to local Clifford, within this error". That is a state-certification
   product for quantum networking and photonic resource-state groups, a
   market adjacent to but distinct from code distance.

3. **Repair-multiplicity certificates for storage.** The eight-arc paper's
   counting identity separates invisible candidate mass from collision
   redundancy and proves "after deleting any orbit, at least 318 alternate
   repairs remain". Reliability engineers want exactly that number for
   erasure layouts (mean time to data loss depends on how many repair sets
   survive a failure), and it is a counting certificate rather than a repair
   method, which keeps it clear of the helper-selection patent surface. Add
   it as a storage-tier query beside minimum-helper cost.

4. **Leakage certificates.** Already recorded in the security analysis:
   relative generalized Hamming weights are the leakage profile of coset
   coding and linear secret sharing; the complete-ports theorems compute them
   exactly under composition. Same storage adapters, a different buyer.

5. **Certified strategy synthesis.** The cap lane replaced a Grundy-value
   oracle by explicit strategy certificates (copycat and pairing strategies,
   the `c80` checker), and its live proof object is a rank-descending reply
   with a well-founded absorption coordinate. That is a ranking-function
   certificate, the standard currency of termination and game solving in
   verification (parity and Buechi games behind reactive synthesis). The
   observational compiler already treats interface games as an exemplar; a
   strategy-certificate output is the bridge from finite geometry games to
   controller synthesis. Long shot commercially, but it is the one lane whose
   objects map directly onto the EDA-formal acquirer's vocabulary.

6. **Field-size sieves as finiteness certificates.** The arcs `q < C(k,2)`
   sieve, the cap-game `q <= C(s,2)` secant barrier, and Faber's tame-subgroup
   finiteness all bound the instances a search must visit. A library of such
   sieves, each a theorem with a one-line check, is what lets the "finite
   exact compilation" hypothesis be discharged per instance rather than
   assumed.

## C. Separate algorithms and products

1. **Projective Reed--Solomon toolkit as a standalone crate.** It is already
   packaged (own lockfile, citation file, benchmark harness, complexity
   bounds, fail-closed classifier, replayable certificates). Two markets it
   does not yet name: worst-case test vectors for Reed--Solomon and BCH
   decoder intellectual-property verification (deep holes are the hardest
   received words, and decoder vendors have no certified source of them), and
   soundness arguments for erasure-coded data-availability schemes. Release
   it first; it is the lowest-risk public artifact in the portfolio and a
   natural sibling of the ergodis kernel.

2. **BuRR ribbon retrieval as an open-source crate.** A from-scratch Rust
   implementation of bumped ribbon retrieval with a log-structured store is
   useful far outside this repository (k-mer indexes, network tables, feature
   hashing). Small, reputational, and it recruits the users a symmetry
   compiler never will.

3. **A Tanner-graph canonicalizer and automorphism-group tool with
   certificates.** Item A.2 generalized: compute and certify the automorphism
   group of a code from its check matrix, with orbit representatives and a
   coverage certificate. Useful on its own to every group in the quantum
   survey table, and it is the entry point through which they meet the
   distance product.

4. **The research operating system.** Guarded build orchestration, the
   certificate firewall, the claim-map checker, the evidence-bundle replay
   convention, the literature cache with read-depth recording, and the task
   allocator, extracted from the monorepo as a domain-neutral harness. The
   lab-facing asset discussed earlier; unchanged by this pass except that the
   inventory confirms every piece exists and has been exercised across all
   lanes.

## D. Showcases (prestige and demonstration, not revenue)

1. **Hadamard order 668.** The residual-multiplier census reduced the
   Legendre-pair route to five subgroup cases by congruence and orbit-lock
   proofs. A theorem-guided parallel search over the surviving cases, with
   per-shard coverage certificates, is a recognisable open problem with a
   natural sharding theorem and an audience that understands certificates.
   High visibility, uncertain outcome; appropriate as the cluster
   demonstration for the parallelism story only if a bounded first shard
   shows the search is within reach.

2. **The QDistSAT suite and `LP_1768_224`.** Still the most legible result
   in the quantum vertical, and the first place item A.1 should be measured.

## E. What does not transfer

The cubic-threefold, Sarkisov, flips, golden-operator, and E8-ladder results
are lattice, Groebner, and representation-theoretic certificates about
specific varieties; their exact-arithmetic Smith-form and saturation
certificates are good practice but not a product, and the E8 code ladder is
pre-empted. The Othello engine contributes discipline (A.6, A.7), not
algorithms. Nothing in the continuation-graph or Sarkisov sections changes
ergodis beyond the symmetry-transfer pattern already recorded.

## F. Ranking and what to queue

| item | kind | effort | value | first consumer |
|--------------------------------------------------|---------------|-------------|------------------------------------------|---------------------------|
| A.1 incremental orbit pruning in native search | floor | weeks | largest remaining multiplier on exhaustive runs | BB360/BB784 replay, QDistSAT sweep |
| A.2 / C.3 automorphism discovery + canonicalizer | floor + product | weeks | prerequisite for any customer input | qec adapter |
| A.4 Lean-verified checker | floor (trust) | weeks | credibility with buyers and labs | every certificate |
| B.1 transversal-gate discovery | reach | weeks to months | second qec feature, same buyers | qec adapter |
| C.1 Reed--Solomon toolkit release | product | days | lowest-risk public artifact | crypto and decoder-verification niches |
| A.3 BuRR exact filters; C.2 BuRR crate | floor + product | days to weeks | modest speed; open-source reach | wide backend |
| B.3 repair-multiplicity certificates | reach | days | reliability buyers; patent-light | storage adapter |
| B.2 robust state certification | reach | months | new adjacent market | quantum networking |
| B.5 strategy certificates | reach | months | EDA vocabulary; long shot | observational compiler |
| D.1 Hadamard 668 | showcase | unknown | prestige | parallelism story |

Recommended allocation: one `complete-ports` task for A.1 with the QDistSAT
sweep as its measurement gate (the sweep is needed anyway); one for A.2/C.3;
C.1 as a release task when the disclosure sequence reaches the paper step;
A.4 as a `build-sys`-adjacent Lean task once the certificate formats freeze.
B.1 waits for the qec adapter to exist as a crate. Everything else is a
discovery-track entry, not a task.
