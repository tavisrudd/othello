# Verification map

Paper I has no paper-facing computation, certificate, or replay dependency.
The inherited 17-artifact package is owned and independently replayed by
Paper II.

| Result labels | Conceptual proof | Formal/core evidence | Exact boundary |
|---|---|---|---|
| `prop:stabilizer-ame-support`, `prop:full-weyl-marginal`, `cor:full-weyl-cover`, `thm:lu-lc-rigidity` | complete in Sections 2--3 | coordinate restriction, support squeeze, unique local labels, and abstract full-Weyl axis criterion are kernel checked | concrete additive stabilizer state, phased marginal expansion, and end-to-end composition remain manuscript proofs |
| `thm:atlas-classification`, `lem:pauli-phase-correction` | complete in Section 4 | minimum-support generation, abstract holonomy centralizer, and symplectic character algebra are kernel checked | state-ray phase correction and complete concrete atlas composition remain manuscript proofs |
| `cor:transversal-clifford` | complete in Section 4 | Choi orientation and Clifford transpose/inverse closure are kernel checked | complete arbitrary-additive encoder theorem is assembled in the manuscript |
| `lem:quantitative-cleaning-commutator`, `lem:nested-weyl-rounding`, `thm:cleaning-global-rounding` | complete in Section 5 | none | leakage constant, Fourier concentration, exact-branch selection, residual norm, and radius are manuscript only |
| `prop:robust-linear-atlas` | complete in Section 5 | none | symplectic compatibility and affine-character obstruction are manuscript only |
| `prop:partial-weyl-marginal`, `lem:recognition-group`, `cor:recognition-generation`, `lem:minimal-support-charts`, `cor:css-recognition`, `rem:arbitrary-dimension` | complete in Appendix A | none | manuscript-only sufficient criterion |
| `lem:local-generator-isometry`, `lem:product-lie`, `thm:two-uniform-discrete`, and related Appendix B stability results | complete in Appendix B | generator splitting, single-exponential identity, polarized second moment, and absence of nonscalar continuous symmetry are kernel checked | all quantitative constants, topological finiteness step, and inverse estimates are manuscript only |
| `lem:quantitative-axes`, `prop:quantitative-intertwiner`, `lem:collective-support-energy`, `thm:aggregate-global-rounding`, `lem:stabilizer-overlap-gap`, `cor:uniform-separation`, `thm:explicit-threshold` | complete in Appendix B | none | closed-form manuscript proofs; no numerical table or replay is cited |

## Pending formal boundary

The checked declarations currently exit through the pre-split AME--LU
aggregate. The paper-specific semantic gate and recursive formal-root contract
are not part of this phase. Until they exist, no release surface may present
the combined aggregate as Paper I's exact formal closure.
