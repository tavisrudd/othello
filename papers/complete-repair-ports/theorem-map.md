# Theorem adoption map

This map controls which results may appear in the main proof spine of
*Complete Bounded Repair Ports*.  Adoption records the intended paper theorem;
body admission additionally requires a complete human proof, a matching Lean
declaration, statement adequacy, an axiom audit, and no computational dependency.

## Status vocabulary

- `ADOPTED`: the result and its exact scope belong in the paper.
- `RECONCILE`: human and Lean proofs exist, but the paper-facing terminal and
  field-by-field adequacy check remain to be closed.
- `TO FORMALIZE`: the mathematical result is retained but may not carry the
  main spine until its Lean and adequacy gates pass.
- `APPENDIX COMPUTATION`: finite data may illustrate a theorem but may not prove
  a body result.
- `CUT/DERIVE`: omit the standalone claim or state it only as a consequence of
  an admitted theorem.

## Adopted theorem hierarchy

| Paper slot | Stable label | Adopted result and exact boundary | Present evidence | Admission status | Owning task |
|---|---|---|---|---|---|
| Complete ports | `def:complete-port` | The complete radius-\(r\) pointed port has support, target-normalized coefficient, and survival-probability layers; matching and transversal depend only on its minimal support clutter. | Human definitions and `FiniteGeom.repairHypergraph`, `minimalRepairHypergraph`, matching/transversal terminals. | `ADOPTED / RECONCILE` | C671, then C678 |
| Reconstruction radius | `def:reconstruction-radius` | The least radius at which the coefficient port determines the pointed code is intrinsic under pointed monomial equivalence. | The normalized coefficient API exists; the intrinsic reconstruction theorem does not. | `ADOPTED / TO FORMALIZE` | C672 |
| MDS reconstruction | `thm:mds-reconstruction` | For an MDS code, the minimum coefficient port at one target reconstructs the pointed code, while its support-only port is the generic complete uniform clutter determined by the MDS parameters. | Manuscript argument only in the Clebsch specialization. | `ADOPTED / TO FORMALIZE` | C672 |
| Exact confinement and transfer | `thm:transfer` | The pointed nonembedded threshold is the exact minimum of the zero-functional and nonzero functional-tuple costs; below it, complete bounded ports transfer exactly.  The numeric two-term form retains its stated surjectivity and nontriviality hypotheses. | Complete manuscript proof and a large kernel-checked chain in `RepairCodes.WeightedTransfer*`. | `ADOPTED / RECONCILE` | C673 |
| Strict transfer example | `cor:strict-transfer` | The completed \(q=9\) seed and Singer-shifted generalized-SPC outer code realize strict weighted radius-four transfer. | Kernel-checked deductions conditional on cited Singer regularity. | `ADOPTED / RECONCILE`; secondary | C673 |
| Positive-density realization | `thm:prescribed` | Every represented radius-\(r\) coefficient port satisfying \(r+1<z_x(I)\) occurs with density \(1/m\) in an asymptotically good fixed-alphabet family, with the exact named random-GV or AG/TVZ input boundary. | Finite cost and transfer core are kernel checked; trace/random/AG assembly is manuscript-only. | `ADOPTED / TO FORMALIZE` | C674 |
| MDS fingerprints | `cor:mds-fingerprints` | The MDS reconstruction theorem and prescribed realization give positive-density coefficient fingerprints; support-only data remains generic. | Depends on C672 and C674. | `ADOPTED / TO FORMALIZE` | C674 |
| Clebsch consequence | `cor:clebsch-port` | The Clebsch \([6,3,4]_{11}\) coefficient port reconstructs the pointed code, has \(z_x=8\), and occurs with density \(1/6\); its minimum support clutter is generic MDS data. | Manuscript-derived from MDS parameters and the current prescribed theorem. | `CUT/DERIVE` until C672+C674, then a compact corollary | C674 |
| Reliability calculus | `thm:reliability` | Finite port reliability satisfies deletion--contraction, pivotal influence, Russo--Margulis, and the blocker-controlled high-survival expansion. | Human proof plus finite scripts; no Lean theorem. | `ADOPTED / TO FORMALIZE` | C675 |
| Bounded EXIT | `prop:bounded-exit` | Radius-truncated extrinsic failure obeys the erasure-sign recurrence, and successive curves encode the cheapest available repair radius; no finite-radius MAP or capacity claim is made. | Human proof plus finite scripts; no Lean theorem. | `ADOPTED / TO FORMALIZE` | C675 |
| Pointed Tutte | `thm:tutte` | Full repair reliability is the stated specialization of the Las Vergnas perspective of \(M\backslash x\to M/x\); pointed duality exchanges repair and failure. | Cited classical structure and manuscript specialization; finite \(q=9\) check only. | `ADOPTED / TO FORMALIZE` | C676 |
| Filtration boundary | `prop:filtration-boundary` | The unfiltered pointed invariant does not determine the bounded-radius filtration. | Present evidence is a certified \(q=9\) coefficient difference. | `ADOPTED / TO FORMALIZE`; seek a symbolic Lean example | C676 |
| Cubic application | `thm:cubic` | The characteristic-three cubic--axis family has the retained code parameters, exact bounded port types, and strict matching/transversal contrast in the stated field range. | Human proof and kernel-checked theorem chain. | `ADOPTED / RECONCILE` | C678 |
| Harmonic application | `thm:harmonic` | The quartic normal-rational curve plus nucleus has the stated code parameters and harmonic \(S(3,4,q+1)\) radius-four coefficient/support port, with theorem-derived nucleus/curve contrast. | Human/classical argument plus finite \(q=9,q=27\) certificates; no Lean terminal. | `ADOPTED / TO FORMALIZE` | C677 |

## Appendix-only finite claims

The following may not carry a body proof: exact \(q=9\) Bernstein
coefficients, EXIT deficits and total-area ledger, finite harmonic closure
witnesses, exact \(q=9/q=27\) circuit replays, finite Poisson error tables, and
any generated profile table.  C325 owns their consolidated manifest and replay
after C678 freezes the appendix contents.

## Deliberate exclusions

Sequential composition, general service regions, coefficient optimization,
log-concavity, product architecture, generic tract/foundation exposition,
propagation-completeness, harmonic cascade thresholds, and C220's optional
cubic blocker strengthening remain outside the paper.

