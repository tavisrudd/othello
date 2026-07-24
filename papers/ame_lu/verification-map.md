# Verification map

This file will become the claim-level trust map for the paper.  The initial
state records dependencies without treating the source reports as a public
artifact.

| Result label | Conceptual proof | Exact computation | Independent replay | Paper-local artifact status |
|---|---|---|---|---|
| `thm:dictionary` | Section 2 plus `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary` | C374 code and stabilizer checks | direct-Lagrangian replay, complete GRS enumeration, and kernel-checked import/axiom gates | C374 bundle imported; symbolic Lean coverage complete pending aggregate adoption |
| `thm:lc-pencil` | C396 | projective quotient and holonomy recovery | symbolic identities plus twelve-field direct replay | imported; C396 bundle and C395 input |
| `thm:lu-h3-grs` | C402 | concurrency formula and permutation lemma | direct q=19 Lagrangian-rank replay | imported; C402 bundle |
| `thm:logical-phase` | C397 | fixed-party kernel theorem | full-row-space, group-closure, and Gale replays | imported; C397 bundle |
| `thm:q13-lu` | C397 | contraction invariance | complete two-/three-/four-copy evaluation and orbit sum | imported; C397 bundle |
| `thm:transport-divisor` | C548/C550 | transport-sheaf and cycle-cover derivation | quotient/finite-field and section/transport replays | imported; C548/C550 bundles |
| `thm:fixed-copy-boundary` | C559 | contraction-rank formula and generic-minor argument | no computation required | conceptual proof available |
| `thm:lu-lc-rigidity` and `cor:lu-lc-pencil` | C560 plus C396 | MDS shortening and diagonal Weyl-tensor axis rigidity; C396 supplies `z` classification | no new computation for rigidity; C396 replay for `z` | conceptual rigidity proof available; C396 evidence imported |

## Required import record

For each paper-facing computation record:

- the exact claim and searched domain;
- generator/script path and version;
- compact certificate path and schema;
- deterministic replay command and expected output;
- independent implementation or the reason none exists; and
- SHA-256 hashes in `supplement/EVIDENCE-MANIFEST.json`.
