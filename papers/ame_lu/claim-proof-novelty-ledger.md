# Claim, proof, and novelty ledger

The first draft uses only the qualified novelty posture authorized by C562.
Every computational result below is present in the C563 paper-local package.

| Claim family | Mathematical proof status | Paper-local evidence | Literature status | Manuscript action |
|---|---|---|---|---|
| Six-arc/MDS/CSS/AME dictionary | proved in Section 2; full statement covered by `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary` | C374 imported; aggregate Lean import and standard-axiom gates passed | standard AME--MDS source cited | `thm:dictionary` drafted; unconditional formal coverage adopted |
| Projective/monomial classification by `z`; LC classification over prime fields | proved in Section 4; C571 supplies the necessary prime-field correction and explicit extension-field counterexample | C396 plus C395 input imported | no independent priority claim | `thm:lc-pencil` revised |
| Logical-Clifford phase over odd prime fields | proved in Section 5 | C397 imported | Grassl--Geiselmann--Beth, Aharonov--Ben-Or, and Gottesman credited for the GRS/fault-tolerant gate constructions; the claimed contribution is the fixed-party self-association iff classification across six-arcs | `thm:logical-phase` revised; extension-field full Clifford kernel excluded |
| Uniform H3/GRS LU separation | proved in Section 6 | C402 imported | bounded source audit retained | `thm:lu-h3-grs` drafted |
| `q=13` arbitrary-LU separator | proved in Section 6 | C397 imported | no priority claim | `thm:q13-lu` drafted |
| Pentad and signed-sheet forgetfulness | stated with Fourier/isodual mechanism in Section 6 | C546 imported | classical pentad core not claimed as new | boundary paragraph drafted |
| Four-copy divisor and transport operator | proved in Appendix A; Lean covers the polynomial and characteristic-seven core conditionally on determinant, rank-bridge, and orbit inputs | C548/C550 imported | no independent priority claim | `thm:transport-divisor` drafted; formal coverage described as conditional |
| Generic constancy of fixed-copy contractions | proved componentwise on irreducible regular generator charts in Section 6 | no new computation | no priority claim | `thm:fixed-copy-boundary` revised to exclude reducible-family and finite-rational-point overclaims |
| Uniform MDS/CSS LU-intertwiner rigidity, transversal Clifford no-go, and prime-field pencil `LU iff LC iff z` | rigidity proved in Section 3 for every prime power, every \(m\geq2\), and every existing linear `[2m,m,m+1]` MDS code; the `[[2m-1,1,m]]` no-go follows by the Choi correspondence; scalar pencil corollary remains only over odd prime fields in Section 4 | no computation required for rigidity or the transversal corollary; C396 supports the corrected prime-field pencil corollary | C562 supplies the Rains--Van den Nest ancestry; the supplied broader audit is advisory pending repository-compliant source caching and read-depth reconciliation, so the manuscript makes no absence or “first” claim for the broader scope | `thm:lu-lc-rigidity` and `cor:transversal-clifford` promoted as the version-1 headline package; `cor:lu-lc-pencil` remains the six-party specialization |

## Promotion rule

A row entered theorem prose only after:

1. its exact hypotheses match the source report;
2. every computational dependency is present in the paper-local manifest;
3. the proof/evidence boundary is written in `verification-map.md`; and
4. any novelty-dependent wording has a recorded claim-specific audit.
