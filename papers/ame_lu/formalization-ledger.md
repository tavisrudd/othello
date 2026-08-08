# Formalization ledger

The shared mathematical namespace remains `RelativeConicArcs.AMELU`. This
ledger records Paper I's theorem boundary; it does not create or validate the
future paper-specific semantic gate.

| Manuscript result | Formal status | Unformalized boundary |
|---|---|---|
| `prop:stabilizer-ame-support`; `prop:full-weyl-marginal`; `cor:full-weyl-cover`; `thm:lu-lc-rigidity` | `StabilizerAMESupport` checks coordinate restriction, support-bounded injectivity, the half-party kernel-to-local bijection, and unique local labels. `AMESupportedSubspaceProfile` checks minimum-support generation. The abstract full-Weyl local criterion is kernel checked. | Lean does not construct the concrete support profile from an arbitrary additive stabilizer state and AME reductions, derive the phased Weyl marginal, or compose the complete arbitrary-additive theorem. |
| `thm:atlas-classification`; `lem:pauli-phase-correction` | `HolonomyCentralizer` checks the abstract transition-centralizer mechanism. `StabilizerDictionary` checks the symplectic character algebra behind Pauli correction. | The concrete state atlas, state-ray phase correction, and full theorem composition are manuscript proofs. |
| `cor:transversal-clifford` | `EncoderTransversal` checks the inverse-transpose Choi orientation and Clifford closure operations. | The mixed module also contains Paper II carrier material; a narrow Paper I gate must review its recursive imports. The complete arbitrary-additive encoder theorem is a manuscript composition. |
| `lem:local-generator-isometry`; continuous-symmetry core | `Multipartite` checks generator splitting, the single-exponential identity, the polarized second-moment identity, and the absence of a nonscalar continuous product symmetry. | Topological finiteness, all quantitative growth bounds, inverse estimates, and thresholds remain manuscript only. |
| `lem:quantitative-cleaning-commutator`; `lem:nested-weyl-rounding`; `thm:cleaning-global-rounding`; `cor:relative-intertwiner-rounding` | `RelativeIntertwinerDecomposition.relative_approximate_decomposition` checks that an exact product base transports a supplied one-state threshold and generator-norm coefficient without loss; its supporting defect and torsor lemmas are kernel checked through `AMELUTwoUniformRigidity`. | The cleaning/Fourier theorem, exact branch selection, and numerical `8ε`, `R_clean`, and `π√q ε` inputs remain manuscript proofs. |
| `prop:robust-linear-atlas`; `cor:logical-clifford-rounding` | Input-plane surjectivity follows from `StabilizerAMESupport`; `EncoderTransversal` checks the inverse-transpose Choi orientation. | Robust compatibility, stabilizer cancellation on the chosen input leg, and the quantitative logical corollary are manuscript compositions. |
| Appendix A recognition package | none | Entire partial-Weyl and integer-modulus package is manuscript only. |
| Appendix B alternative quantitative routes | only the multipartite core named above | Quantitative tensor axes, overlap gap, single-marginal threshold, aggregate support energy, budget-free stability, and 2-unitary gauge corollary are not formalized. |

## Current audit boundary

The relevant declarations have been checked under Lean `v4.32.0-rc1`. In the
pre-split aggregate, their audited axiom sets contain only `propext`,
`Classical.choice`, and `Quot.sound`. No Paper I-specific root contract exists
yet, so this statement is a declaration-level record rather than a release
closure claim.

The future semantic roots are planned as
`RelativeConicArcs.Gates.AMEStabilizerRigidity` and
`RelativeConicArcs.Gates.AMEStabilizerRigidityAxioms`. Creating them,
refactoring mixed modules if needed, validating the recursive closure, and
updating the public formal repository belong to the formal-split phase.
