# Verification map

This file will become the claim-level trust map for the paper.  The initial
state records dependencies without treating the source reports as a public
artifact.

| Result label | Conceptual proof | Exact computation | Independent replay | Paper-local artifact status |
|---|---|---|---|---|
| `thm:dictionary` | Section 2 plus `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary` | C374 code and stabilizer checks | direct-Lagrangian replay, complete GRS enumeration, and kernel-checked import/axiom gates | C374 bundle imported; unconditional statement coverage passes the aggregate Lean gate |
| `thm:lc-pencil` | C396 plus `pencilZ_eq_iff_samePencilYOrbit` and the conditional `admitted_nonGRS_pencil_classified_by_z`; C571 restricts the quantum clause to prime fields | projective quotient over odd fields and prime-field holonomy recovery | symbolic identities plus twelve-field direct replay; extension-field runs are checks of the field-linear interface, not the full Clifford group | imported; C396 bundle and C395 input; Lean classification hypotheses remain explicit |
| `thm:lu-h3-grs` | C402 plus the finite graph core and conditional separator in `RelativeConicArcs.AMELU.MarginalMoment` | concurrency formula and permutation lemma | direct q=19 Lagrangian-rank replay | imported; C402 bundle; native graph counts are separated from geometric and LU hypotheses |
| `thm:logical-phase` | C397 plus conditional `fixedPartyKernel_eq_specialLinear_or_splitTorus` | odd-prime-field fixed-party kernel theorem | full-row-space, group-closure, and Gale replays | imported; C397 bundle; extension-field full Clifford kernels and the party-moving normalizer are outside formal coverage |
| `thm:q13-lu` | C397 plus conditional `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` | contraction invariance | complete two-/three-/four-copy evaluation and orbit sum | imported; C397 bundle; contraction/rank, LU covariance, and rank evaluations remain explicit inputs |
| `thm:transport-divisor` | C548/C550 plus the unconditional polynomial core and conditional transport interfaces in `RelativeConicArcs.AMELU.TransportDivisor` | transport-sheaf and cycle-cover derivation | quotient/finite-field and section/transport replays | imported; C548/C550 bundles; determinant, rank-bridge, and orbit-geometry inputs remain explicit |
| `thm:fixed-copy-boundary` | C559 | contraction-rank formula and generic-minor argument | no computation required | conceptual proof available |
| `thm:lu-lc-rigidity`, `cor:transversal-clifford`, and `cor:lu-lc-pencil` | C560/C609 plus corrected C396 scope; the generic foundation and terminal are checked by `RelativeConicArcs.AMELU.GenericDefinitions`, `GenericMDS`, `GenericMarginal`, `GenericMarginalCovariance`, `GenericTensorRigidity`, and `GenericLURigidity`; `EncoderTransversal` checks the inverse-transpose Choi action, Clifford closure, and factorwise conversion terminal; the six-party specialization is checked by `LURigidity` and `LUPencilClassification` | complete generic marginal, covariance, axis-recovery, retained-cover, and LU-to-LC chain; exact `((Lᵀ)⁻¹⊗U_phys)` orientation; adjoint, entrywise-conjugate, and transpose closure; C396 supplies the prime-field `z` classification inputs | no new computation for rigidity or the transversal corollary; kernel-checked aggregate and axiom audit; C396 replay for `z`; C571 records an exact `q=25` Frobenius counterexample outside the pencil corollary | the all-\(m\) LU-to-LC theorem and the factorwise no-go are unconditional from the displayed normalized Choi conversion data; the pencil composition remains conditional only on existing classification inputs |
| `cor:discrete-lu-symmetry` and `cor:grs-transversal-group` | `AutomorphismExactSequence` checks the exact topological sequences; `NonabelianExtensionInvariant` checks the realized extension's section-free outer action, normalized factor set, ordered nonabelian change law, and splitting obstruction; `EncoderTransversal` supplies the conditional exact-GRS-group interface | closed scalar-torus fibers, finite discrete quotients, exact fixed-party kernel, descent of conjugation modulo inner automorphisms, factor-set associativity, change of normalized lifts, trivializability iff splitting, CSS shears, affine-special-linear carrier equality, and order-16464 arithmetic | no computation required; the aggregate and declaration-level axiom audit are kernel checked | `cor:discrete-lu-symmetry` is unconditional in Lean; `GRSTransversalInputs` retains the GRS construction, phase-corrected lifts, Pauli representatives, generation, and converse, and does not provide a normalized cochain trivializing the party-permutation factor set |

## Required import record

For each paper-facing computation record:

- the exact claim and searched domain;
- generator/script path and version;
- compact certificate path and schema;
- deterministic replay command and expected output;
- independent implementation or the reason none exists; and
- SHA-256 hashes in `supplement/EVIDENCE-MANIFEST.json`.
