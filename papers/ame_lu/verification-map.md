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
| `thm:lu-lc-rigidity`, `cor:transversal-clifford`, and `cor:lu-lc-pencil` | C560/C609 plus corrected C396 scope; the generic foundation and terminal are checked by `RelativeConicArcs.AMELU.GenericDefinitions`, `GenericMDS`, `GenericMarginal`, `GenericMarginalCovariance`, `GenericTensorRigidity`, and `GenericLURigidity`; the six-party specialization is checked by `LURigidity` and `LUPencilClassification` | manuscript proof: dual MDS shortening and diagonal Weyl-tensor axis rigidity for every prime power and \(m\geq2\), plus the Choi/transposition bridge; Lean proof: the complete generic marginal, covariance, axis-recovery, retained-cover, and LU-to-LC chain; C396 supplies the prime-field `z` classification inputs | no new computation for rigidity or the transversal corollary; kernel-checked aggregate and axiom audit for the generic theorem and six-party result; C396 replay for `z`; C571 records an exact `q=25` Frobenius counterexample outside the pencil corollary | the all-\(m\) LU-to-LC theorem is unconditional in Lean, and the pencil composition is conditional only on existing classification inputs; the Choi/transposition corollary remains prose-only |
| `cor:discrete-lu-symmetry` and `cor:grs-transversal-group` | C614; the discrete-symmetry formalization is checked by `RelativeConicArcs.AMELU.ProjectiveClifford`, `ProductUnitarySymmetry`, and `ProductUnitarySymmetryTopology` | determinant-root finiteness of exact Weyl conjugates, faithful scalar quotient, finite product quotient, and connected phase-torus fiber; the exact GRS group additionally uses the standard diagonal duality `SC=Cᗮ`, explicit upper/lower product unipotents, generation of `SL_2(q)`, physical Pauli representatives, and the no-go converse | no computation required; the general corollary is kernel checked; `7^2·|SL_2(7)|=16464` is direct arithmetic | `cor:discrete-lu-symmetry` is unconditional in Lean, including party permutations; C613 owns the encoder and exact-GRS-group formalization |

## Required import record

For each paper-facing computation record:

- the exact claim and searched domain;
- generator/script path and version;
- compact certificate path and schema;
- deterministic replay command and expected output;
- independent implementation or the reason none exists; and
- SHA-256 hashes in `supplement/EVIDENCE-MANIFEST.json`.
