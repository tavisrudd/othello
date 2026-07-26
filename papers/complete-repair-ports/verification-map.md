# Verification map

This map separates mathematical proof, formal checking, classical imports, and
finite computation.  The manuscript proof remains responsible for explaining
the mechanism even when Lean checks the statement.

| Claim group | Human proof route | Lean route | Finite artifact | Permitted role of computation |
|---|---|---|---|---|
| Port object and MDS reconstruction | Restriction dimension gives every prescribed relation; a common-core star gives a basis; double duality recovers the code | `RepairPorts.Gates.CompletePorts` and its ten audited terminals | Existing coefficient replay | Corroborate examples only |
| Exact confinement and transfer | Block-functional decomposition, independent fiber minima, exact three-stratum split, and both inclusions of port equality | `RepairPorts.Gates.CompletePorts`, led by `RepairPorts.exactFunctionalStrata` and `RepairPorts.exactPointedConfinementAndTransfer` | None | No role |
| Positive-density realization | Trace pairing, outer-family hypothesis, concatenated parameters, and density count | C674 conditional family terminal | None | No role |
| Reliability and bounded EXIT | Finite subset sums, deletion--contraction partition, derivative counting, radius filtration | C675 terminals | C219 and C226 bundles | Appendix profiles only |
| Pointed Tutte | Direct rank-polynomial specialization and pointed duality | C676 terminals | C227 bundle | Appendix comparison only |
| Cubic geometry | Coordinate algebra, circuit classification, and combinatorial matching/transversal proof | Existing cubic chain; C678 aggregate terminal | Existing \(q=9\) tables | Appendix tables or examples |
| Harmonic geometry | Normal-rational-curve/nucleus algebra and harmonic design counting | C677 terminals | C218, C243, C244 bundles | Appendix finite rows, witnesses, and error tables |

## Current paper-local finite bundles

The retained private sources are C218, C219, C226, C227, C243, and C244.
C325 will replace scattered replay descriptions with one versioned appendix
manifest and an independent replay route after C678 freezes the retained data.
No current private C-task path is a public archive identity.

## Release boundary

C679 checks the private draft and trust map.  Public export remains separately
gated on C287 shared-Lean extraction, a public checker/archive identity, stable
repository metadata, and author authorization.
