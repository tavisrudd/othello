# Verification map

This file will become the claim-level trust map for the paper.  The initial
state records dependencies without treating the source reports as a public
artifact.

| Result label | Conceptual proof | Exact computation | Independent replay | Paper-local artifact status |
|---|---|---|---|---|
| `thm:dictionary` | C374 | code and stabilizer checks | source report records replay | not imported |
| `thm:lc-pencil` | C396 | projective quotient and holonomy recovery | source report records replay | not imported |
| `thm:lu-h3-grs` | C402 | concurrency formula and permutation lemma | source report records replay | not imported |
| `thm:logical-phase` | C397 | fixed-party kernel theorem | finite group checks at `q=11` | not imported |
| `thm:q13-lu` | C397 | contraction invariance | complete two-/three-/four-copy evaluation | not imported |
| `thm:transport-divisor` | C548/C550 | transport-sheaf and cycle-cover derivation | divisor and orbit certificates | not imported |
| `thm:lu-lc-pencil` | open | proposed invariant-field computation | none | forbidden |

## Required import record

For each paper-facing computation record:

- the exact claim and searched domain;
- generator/script path and version;
- compact certificate path and schema;
- deterministic replay command and expected output;
- independent implementation or the reason none exists; and
- SHA-256 hashes in `supplement/EVIDENCE-MANIFEST.json`.
