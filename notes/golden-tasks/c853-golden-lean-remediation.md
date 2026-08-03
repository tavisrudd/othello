# C853 Golden quantum-statistics Lean remediation

**Lane:** golden

**Status:** queued after C845 and before C840

## Goal

Replace the current scalar-only Golden quantum-statistics Lean artifact with a
standards-compliant theorem-level companion.  The formal API must define the
paper's mathematical objects, prove the semantic bridges now present only in
docstrings, and expose exact terminals for the paper's principal mathematical
claims.  Every remaining claim must have an explicit human, cited,
certificate, computational, or experimental trust route.

This task owns formal remediation.  C845 owns the guarded canonical exporter
prerequisite.  C840 subsequently owns independent claim-by-claim
reconciliation, canonical-candidate validation, and the final honest coverage
ledger.  C841 owns public declaration and paper-repository promotion only
after both tasks pass.

## Audit baseline

The present project-local closure consists of:

- lean/RelativeConicArcs/GoldenBalancedCut.lean;
- lean/RelativeConicArcs/Gates/GoldenQuantumStatistics.lean; and
- the corresponding relconic trust declaration and generated fact.

It exposes four commutative-ring terminals.  No terminal defines a conference
matrix, balanced cut, cross block, exchange spectrum, Schur sector, holonomy,
control cube, switching class, or stability distance.  None of the paper's
eight labeled theorems or propositions is formalized at theorem-interface
level.

The two current expressions named crossGramDet and traceContraction are
manually written polynomials.  Lean does not presently prove that they equal a
matrix determinant or trace.  The fourth-word terminal is only arithmetic
substitution after the trace-contraction value.  The current manuscript does
not visibly use the trace-contraction 12 or fourth-word -42 terminals.

The generated Golden trust fact observes exactly propext for all four
terminals, with no project axiom or opaque declaration.  The scoped unit has
no trust-spine finding, but the monolithic relconic audit has 165 unrelated
baseline errors and is not a usable exit gate.

The suffixed finitegeom-golden-quantum-statistics repository is superseded
read-only evidence.  It is divergent from canonical finitegeom/main, lacks
the current import-only gate, carries a stale paper title and loose axiom
expectations, and must not be edited or used as an authority.

## Coverage ledger to close

| Manuscript result | Baseline Lean coverage | C853 target |
|---|---|---|
| orbit classification and orientation carrier | none | exact theorem terminals |
| general balanced-spectrum rigidity | one scalar order-six identity | structural theorem or explicit residual boundary |
| Golden balanced exchange benchmark | two scalar calculations | complete theorem terminal |
| continuous-control optimum | none | complete bounds and equality set |
| Hermitian exchange landscape | none | complete moments, sectors, and Pareto frontier |
| squared-spectrum rigidity and stability | none | exact rigidity and metric bounds |
| balance obstruction | none | exact proposition terminal |

Experimental feasibility, source availability, tomography protocols, optical
compilation, and hardware design-limit claims remain outside Lean unless the
task isolates a precise mathematical proposition.  Their exclusion must be
stated explicitly and must not be counted as missing formal proof.

## Phase 1: formal vocabulary

- [ ] Define real symmetric conference matrices of order n.
- [ ] Define order-six Hermitian conference matrices.
- [ ] Encode zero diagonal, signed or unit-modulus off-diagonal entries,
      symmetry or Hermitian symmetry, and the conference square identity.
- [ ] Define balanced subsets and balanced triples.
- [ ] Define the principal block A and complementary cross block R.
- [ ] Define the normalized exchange matrix H = RR*/5.
- [ ] Define real triangle holonomy.
- [ ] Define the power sums and symmetric functions p1, p2, e2, e3, h3, and
      s(2,1) with the manuscript's normalizations.
- [ ] Define real controls, Boolean controls, balance, switching equivalence,
      permutation equivalence, and Frobenius orbit distance where used.
- [ ] Give every scholarly-public definition a self-contained docstring.
- [ ] Use stable mathematical names; reserve Golden paper terminology for a
      documented correspondence or import-only gate.

Acceptance: the formal statements can be understood without the paper,
internal notes, or workflow history.

## Phase 2: semantic bridge

- [ ] Define the signed three-by-three triangle matrix.
- [ ] Prove the matrix identity A² = 2I + tau A.
- [ ] Derive its characteristic polynomial and the spectrum of A².
- [ ] Prove from C² = 5I that RR^T = 5I - A² in the real case.
- [ ] Prove the Hermitian identity RR* = 5I - A².
- [ ] Replace crossGramDet with an actual determinant or prove equality with
      the actual matrix determinant.
- [ ] Replace traceContraction with an actual trace or prove equality with the
      relevant matrix trace.
- [ ] Prove the normalization from det(RR*) = 16 to e3(H) = 16/125.
- [ ] Move every claimed determinant, trace, spectrum, or block
      interpretation from prose into theorem types.
- [ ] Retain the current scalar lemmas only as downstream algebraic helpers.

Acceptance: the existing numbers 16, 12, and -42 are connected to actual
formal matrices, or the unused legacy values are removed from the advertised
boundary.

## Phase 3: first end-to-end manuscript theorem

Formalize the Golden balanced exchange benchmark before expanding to the
harder crowns.

- [ ] Formalize its balanced-control hypotheses.
- [ ] Prove spec(H) = {1/5, 4/5, 4/5}.
- [ ] Derive the stated power sums and elementary symmetric functions.
- [ ] Prove h3 = 313/125, e3 = 16/125, and s(2,1) = 8/5.
- [ ] Prove the Schur-Weyl checksum.
- [ ] State orientation-blindness only after proving the required orthogonal
      invariance.
- [ ] Expose one paper-facing terminal whose type matches the manuscript
      theorem at the claimed scope.

Acceptance: at least one labeled manuscript theorem has a direct formal
counterpart rather than a collection of supporting calculations.

## Phase 4: principal Hermitian headline

- [ ] Prove the Hermitian triangle characteristic polynomial.
- [ ] Prove p1 = 9/5, p2 = 33/25, and e2 = 24/25.
- [ ] Prove the holonomy formulas for e3, h3, and s(2,1).
- [ ] Formalize the admissible Hermitian phase and control domain.
- [ ] Prove the exact componentwise-maximal Pareto segment.
- [ ] Prove both endpoint maximization statements.
- [ ] Prove that constancy of each individual degree-three sector over
      balanced cuts characterizes the real switching/permutation class.
- [ ] Define the averaged squared-holonomy defect.
- [ ] Prove the global lower Frobenius-distance bound.
- [ ] Prove the local upper bound with its exact radius and constants.
- [ ] Separate imported existence or classification facts from the
      classification-free argument.

Acceptance: exact terminals cover the paper's leading landscape, rigidity,
and stability claims.

## Phase 5: general balanced-spectrum rigidity

- [ ] Formalize symmetric conference matrices of order 2d.
- [ ] Prove the normalized cross-Gram spectral correspondence.
- [ ] Define aligned four-sets and their cut counts.
- [ ] Prove the purity formula.
- [ ] Formalize or precisely import the inclusion-matrix injectivity theorem.
- [ ] Formalize or precisely import R(3,3) = 6.
- [ ] Prove cut independence exactly for d at most 3.
- [ ] Handle the nonexistent order-four symmetric conference case.
- [ ] State unique nontrivial order only on the proved domain.
- [ ] Give stable public citations for every imported external theorem.

Acceptance: the all-order theorem's hypotheses, both directions, exceptional
cases, and literature inputs are explicit in the formal interface.

## Phase 6: continuous control and balance obstruction

- [ ] Define the real control cube and transfer K_C(x).
- [ ] Prove each sector bound.
- [ ] Formalize the separate-convexity and rank-one-minor reductions.
- [ ] Prove the Boolean reduction.
- [ ] Characterize every equality case.
- [ ] Prove that exactly twenty balanced Boolean controls jointly maximize
      all three degree-three sectors.
- [ ] Formalize the balance-obstruction proposition on its exact domain.
- [ ] Prove both its inequality and equality characterization.

Acceptance: continuous maxima and equality sets are kernel-checked, not
imported from an external enumeration without a formal completeness bridge.

## Phase 7: orbit and orientation layer

- [ ] Formalize the left-right orthogonal action on a real transfer.
- [ ] Prove classification by singular values.
- [ ] Define oriented port spaces and their special-orthogonal actions.
- [ ] Prove the determinant-sign orbit splitting in the invertible case.
- [ ] Prove collapse of that distinction on the singular locus.
- [ ] Formalize the determinant character.
- [ ] Prove minimal-degree uniqueness on an explicit polynomial domain and
      comparison relation.
- [ ] Keep the permanent outside the invariant quotient unless its
      frame-dependent statement is formalized exactly.

Acceptance: strength-bearing orientation and uniqueness language is witnessed
by theorem types.

## Phase 8: exhaustive claim classification

- [ ] Inventory every theorem, proposition, corollary, displayed numerical
      claim, and verification-dependent assertion in the current manuscript.
- [ ] Assign exactly one primary trust route to each claim: Lean, cited
      theorem, certificate checker, trusted execution, human proof, or
      experimental evidence.
- [ ] Record partial Lean mechanisms separately from theorem coverage.
- [ ] State the finite domain, completeness argument, exact arithmetic, and
      acceptance criterion for every certificate-backed computation.
- [ ] Keep tomography, circuit, source-fidelity, and hardware feasibility
      clauses out of the Lean count unless an exact formal proposition exists.
- [ ] Ensure no claim is omitted and no claim is counted twice.

Acceptance: a referee can identify the trust route and exact artifact for
every substantive paper claim.

## Phase 9: referee-facing source review

Audit the full project-owned transitive verification closure.

- [ ] Self-contained module headers and public docstrings.
- [ ] Exact domains, quantifiers, normalizations, and degeneracy conventions.
- [ ] No task IDs, lanes, agents, sessions, internal reports, local paths,
      private URLs, or reverse workflow references.
- [ ] No TODO, pending, temporary, next-step, fallback, or similar status
      prose.
- [ ] No novelty or priority claims.
- [ ] No strength-bearing name without a theorem proving that strength.
- [ ] No unexplained project abbreviation or paper-only nickname.
- [ ] No prose stronger than an elaborated theorem type.
- [ ] No mutable phrase such as as in the manuscript.
- [ ] Generated sources name their generator, schema, semantic data, and
      checking method.
- [ ] Computational claims disclose kernel reduction, checker, native
      evaluation, imported certificate, or axiom exactly.
- [ ] External citations give authors, title, year, stable identifier, and
      pinpoint result.
- [ ] The public correspondence names the current paper title, author, DOI,
      and exact covered theorem or equation.
- [ ] Golden is explained by C² = 5I, the paired three-dimensional
      eigenspaces with eigenvalues ±sqrt(5), and the golden ratio.

Acceptance: the artifact is intelligible as a permanent scholarly record
without repository workflow context.

## Phase 10: trust and build validation

- [ ] Use only lean/scripts/guarded-lean or the guarded build queue.
- [ ] Acquire a genuine quiet build window before shared-tree builds or
      generation.
- [ ] Build bounded leaves before aggregators.
- [ ] Build an import-only Golden quantum-statistics gate importing every
      advertised paper-facing terminal.
- [ ] Run the exact-target no-build confirmation.
- [ ] Generate facts from the clean authoritative source checkpoint.
- [ ] Confirm the exact terminal list and full project-local closure.
- [ ] Confirm exact axioms, opaque declarations, and project axioms.
- [ ] Provide a scoped Golden audit independent of the 165 unrelated
      relconic baseline errors.
- [ ] Run the external-view regeneration check.
- [ ] Validate a clean canonical exported candidate after C845 supplies the
      guarded materializer.
- [ ] Require deterministic repeat materialization and byte identity.
- [ ] Record toolchain, Mathlib revision, source hashes, target hashes, and
      measured build profile.
- [ ] Commit sources, generated facts, manifests, and gate changes atomically.
- [ ] Never use stale oleans, raw lake commands, manual destination copies, or
      the superseded suffixed clone as evidence.

Acceptance: clean authoritative source, clean candidate, exact trace-current
gate, exact axiom audit, and deterministic manifests agree.

## Phase 11: handoff to C840 and C841

- [ ] Give C840 the complete theorem-to-terminal ledger and explicit residual
      exclusions.
- [ ] Require C840 to validate the exporter-produced candidate against
      canonical finitegeom/main independently.
- [ ] Do not let C840 infer coverage from names or internal reports.
- [ ] Begin C841 only after C840's exact gate passes.
- [ ] Publish the validated canonical finitegeom commit before adding a paper
      declaration.
- [ ] Pin the exact public commit, gate, manifests, toolchain, and concept DOI.
- [ ] Add FORMAL_COMPANION.json, README boundary prose, Zenodo relationship,
      and a paper-local declaration verifier only then.
- [ ] Synchronize the standalone paper through the deterministic exporter.
- [ ] Do not say fully formalized unless the final ledger proves that scope.
- [ ] Do not tag, push, or mutate remotes without explicit user authorization.

## Ownership and exclusions

C853 may edit the authoritative Golden quantum-statistics Lean modules, new
mathematically named modules needed by their closure, the Golden import-only
gate, the exact Golden entries in the trust registry, generated Golden facts
inside an owned build window, this task record, the Golden handoff, and the
Golden discovery track when the discriminator applies.

C853 must not edit the paper manuscript, either finitegeom destination, the
superseded suffixed clone, unrelated relconic trust units, global generated
views outside an owned regeneration gate, or the standalone paper repository.
It must not weaken validation to evade the relconic baseline.

## Ordered milestones

1. Close C845's guarded canonical-export prerequisite.
2. Build the formal vocabulary and semantic bridge.
3. Formalize the Golden balanced exchange benchmark end to end.
4. Formalize the Hermitian landscape, rigidity, and stability crown.
5. Formalize general rigidity, continuous maxima, balance obstruction, and
   orientation results.
6. Complete the exhaustive claim and prose audits.
7. Pass the guarded source, axiom, manifest, and deterministic-export gates.
8. Hand the validated surface to C840, then C841.

The first implementation checkpoint is not another scalar lemma.  It is the
matrix-level semantic bridge through RR* = 5I - A² and one complete
paper-theorem interface.
