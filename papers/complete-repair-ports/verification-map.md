# Verification map

This map separates mathematical proof, formal checking, classical imports, and
finite computation.  The manuscript proof remains responsible for explaining
the mechanism even when Lean checks the statement.

| Claim group | Human proof route | Lean route | Finite artifact | Permitted role of computation |
|---|---|---|---|---|
| Port object and MDS reconstruction | Restriction dimension gives every prescribed relation; a common-core star gives a basis; double duality recovers the code | `RepairPorts.Gates.CompletePorts` and its ten audited terminals | Existing coefficient replay | Corroborate examples only |
| Exact confinement and transfer | Block-functional decomposition, independent fiber minima, exact three-stratum split, and both inclusions of port equality | `RepairPorts.Gates.CompletePorts`, led by `RepairPorts.exactFunctionalStrata` and `RepairPorts.exactPointedConfinementAndTransfer` | None | No role |
| Positive-density realization | Trace pairing, exact eventual zero-sector reduction, zero-extension of support/coefficient ports, scaled concatenated parameters, and target count | `RepairPorts.Gates.CompletePorts`, led by `eventually_pointedConfinement_iff_zeroCost`, `eventually_prescribedPorts`, `concatenatedRestrictedCode_parameters`, and `eventually_mdsMinimumCoefficientFingerprints` | None | No role |
| Reliability and bounded EXIT | Finite subset sums, deletion--contraction partition, derivative counting, minimum-blocker coefficient, and radius filtration | `RepairPorts.Reliability`; imported and axiom-audited by `RepairPorts.Gates.CompletePorts` | C219 and C226 bundles | Exact finite profiles and Poisson refinements only |
| Pointed Tutte and filtration boundary | Direct rank-polynomial specialization, pointed duality, sparse-paving rank count, and two-event inclusion--exclusion | `RepairPorts.PointedTutte`; imported and axiom-audited by `RepairPorts.Gates.CompletePorts` | C676 exact \(\mathbb F_7\) replay; C227 \(q=9\) bundle | The \(\mathbb F_7\) replay independently checks the displayed minors and profiles; the \(q=9\) rows are illustration only |
| Cubic geometry | Coordinate algebra, exhaustive small-circuit classification, zero-sum decomposition on the axis, and shifted-inverse matching/transversal proof on the cubic | `FiniteGeom.axisTwistedCubic_code_parameters` and the audited `RepairCodes.AxisTwistedCubic`/`AxisTwistedCubicInvariants` chain | Existing \(q=9\) tables | Appendix tables or examples only |
| Harmonic geometry | Quartic/nucleus determinant algebra, projective completion, arbitrary-order circuit classification, uniform small-column exclusion, pointed circuit-to-repair transport, and nucleus-gate closure | `RepairPorts.HarmonicQuartic`; imported and axiom-audited by `RepairPorts.Gates.CompletePorts`. The exact parameter terminal exposes the manuscript's sharp five-point section lemma | C218, C243, C244 bundles | Appendix finite rows, witnesses, and error tables only |

## Current paper-local finite bundles

The retained private sources are C218, C219, C226, C227, C243, and C244.
C325 will replace scattered replay descriptions with one versioned appendix
manifest and an independent replay route after C678 freezes the retained data.
No current private C-task path is a public archive identity.

## Release boundary

C679 checks the private draft and trust map.  Public export remains separately
gated on C287 shared-Lean extraction, a public checker/archive identity, stable
repository metadata, and author authorization.
