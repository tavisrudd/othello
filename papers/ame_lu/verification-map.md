# Verification map

Paper I has no paper-facing computation, certificate, or replay dependency.
The inherited 17-artifact package is owned and independently replayed by
Paper II.

| Result labels | Conceptual proof | Formal/core evidence | Exact boundary |
|---|---|---|---|
| `prop:stabilizer-ame-support`, `prop:full-weyl-marginal`, `cor:full-weyl-cover`, `thm:lu-lc-rigidity` | complete in Sections 2--3 | coordinate restriction, support counting, unique local labels, and abstract complete-basis axis criterion are kernel checked | concrete additive stabilizer state, phased marginal expansion, and end-to-end composition remain manuscript proofs |
| `thm:atlas-classification`, `lem:pauli-phase-correction` | complete in Section 4 | minimum-support generation, abstract holonomy centralizer, and symplectic character algebra are kernel checked | state-ray phase correction and complete concrete atlas composition remain manuscript proofs |
| `cor:transversal-clifford` | complete in Section 4 | Choi orientation and Clifford transpose/inverse closure are kernel checked | complete arbitrary-additive encoder theorem is assembled in the manuscript |
| `lem:quantitative-cleaning-commutator`, `lem:nested-weyl-rounding`, `thm:cleaning-global-rounding`, `cor:relative-intertwiner-rounding` | complete in Section 5 | `RelativeIntertwinerDecomposition` checks exact-base line transport, defect invariance, product-intertwiner composition, and lossless transfer of a hypothesis-explicit one-state decomposition | leakage constant, Fourier concentration, exact-branch selection, residual norm, radius, and numerical `8ε`/`π√q ε` inputs remain manuscript only |
| `prop:robust-linear-atlas`, `cor:logical-clifford-rounding` | complete in Section 5 | input-plane surjectivity and inverse-transpose orientation have kernel-checked cores | robust compatibility, stabilizer cancellation, and the quantitative logical corollary are manuscript compositions |
| `lem:local-generator-isometry`, `lem:product-lie`, `thm:two-uniform-discrete`, and related Appendix A stability results | complete in Appendix A | generator splitting, single-exponential identity, polarized second moment, and absence of nonscalar continuous symmetry are kernel checked | all quantitative constants, topological finiteness step, and inverse estimates are manuscript only |
| `lem:stabilizer-overlap-gap`, `prop:main-residual-stability` | complete in Section 5 | none | load-bearing closed-form manuscript proofs for branch selection and collective residual control |
| `lem:quantitative-axes`, `prop:quantitative-intertwiner`, `lem:collective-support-energy`, `thm:aggregate-global-rounding`, `thm:explicit-threshold` | complete in Appendix A | none | alternative closed-form manuscript proofs; no numerical table or replay is cited |

## Pending formal boundary

The checked declarations currently exit through the pre-split AME--LU
aggregate. The paper-specific semantic gate and recursive formal-root contract
are not part of this phase. Until they exist, no release surface may present
the combined aggregate as Paper I's exact formal closure.
