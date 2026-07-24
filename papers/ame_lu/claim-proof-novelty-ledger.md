# Claim, proof, and novelty ledger

The first draft uses only the qualified novelty posture authorized by C562.
Every computational result below is present in the C563 paper-local package.

| Claim family | Mathematical proof status | Paper-local evidence | Literature status | Manuscript action |
|---|---|---|---|---|
| Six-arc/MDS/CSS/AME dictionary | proved in Section 2; full statement covered by `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary` | C374 imported; Lean import and standard-axiom gates passed | standard AME--MDS source cited | `thm:dictionary` drafted; aggregate formal adoption assigned to C570 |
| LC classification by `z` | proved in Section 4 | C396 plus C395 input imported | no independent priority claim | `thm:lc-pencil` drafted |
| Logical-Clifford phase | proved in Section 5 | C397 imported | no independent priority claim | `thm:logical-phase` drafted |
| Uniform H3/GRS LU separation | proved in Section 6 | C402 imported | bounded source audit retained | `thm:lu-h3-grs` drafted |
| `q=13` arbitrary-LU separator | proved in Section 6 | C397 imported | no priority claim | `thm:q13-lu` drafted |
| Pentad and signed-sheet forgetfulness | stated with Fourier/isodual mechanism in Section 6 | C546 imported | classical pentad core not claimed as new | boundary paragraph drafted |
| Four-copy divisor and transport operator | proved in Section 7 | C548/C550 imported | no independent priority claim | `thm:transport-divisor` drafted |
| Generic constancy of fixed-copy contractions | proved in Section 6 | no new computation | no priority claim | `thm:fixed-copy-boundary` drafted |
| All-MDS/CSS LU-intertwiner rigidity and pencil `LU iff LC iff z` | proved in Sections 3--4 | no computation required; C396 supports the corollary | C562 complete; Rains--Van den Nest ancestry and qualified exact-scope wording retained | `thm:lu-lc-rigidity` and `cor:lu-lc-pencil` drafted |

## Promotion rule

A row entered theorem prose only after:

1. its exact hypotheses match the source report;
2. every computational dependency is present in the paper-local manifest;
3. the proof/evidence boundary is written in `verification-map.md`; and
4. any novelty-dependent wording has a recorded claim-specific audit.
