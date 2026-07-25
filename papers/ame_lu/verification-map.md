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
| `thm:lu-lc-rigidity`, `cor:transversal-clifford`, and `cor:lu-lc-pencil` | C560/C609 plus corrected C396 scope | dual MDS shortening and diagonal Weyl-tensor axis rigidity for every prime power, every \(m\geq2\), and every existing `[2m,m,m+1]` code; Choi/transposition bridge for the `[[2m-1,1,m]]` no-go; C396 supplies the prime-field `z` classification | no new computation for rigidity or the transversal corollary; C396 replay for `z`; C571 records an exact `q=25` Frobenius counterexample outside the pencil corollary | conceptual rigidity and Choi proofs available; prime-field pencil corollary only |

## Required import record

For each paper-facing computation record:

- the exact claim and searched domain;
- generator/script path and version;
- compact certificate path and schema;
- deterministic replay command and expected output;
- independent implementation or the reason none exists; and
- SHA-256 hashes in `supplement/EVIDENCE-MANIFEST.json`.
