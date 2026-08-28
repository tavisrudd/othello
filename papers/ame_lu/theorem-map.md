# Theorem adoption map

This map covers Paper I after the two-paper split. Results owned by
`mds_css_transversal_groups` are absent; their frozen labels remain assigned in
`cross-paper-theorem-ownership.md`.

## Body hierarchy

| Source | Manuscript result | Exact boundary | Evidence type |
|---|---|---|---|
| C649 | every product-unitary intertwiner between additive stabilizer `AME(2m,q)` states is Clifford factor by factor | every prime power `q=p^e`, every `m≥2`, standard additive Weyl system; Bell pairs excluded sharply | AME support counting, complete Weyl-basis marginal, intrinsic tensor axes; manuscript proof with kernel-checked cores |
| C649 | minimum-support transition maps classify LU equivalence up to local trace-symplectic frames; exact sequence for the fixed-party projective symmetry group | same state class; holonomy-centralizer description stated over prime fields | minimum-support generation, transition equations, product-Pauli character correction |
| C649 | every transversal conversion between associated `[[2m-1,1,m]]_q` encoders is Clifford on every physical and logical factor | every prime power and `m≥2`; one logical qudit | AME Choi correspondence and transpose/inverse Clifford closure |
| C833 | cleaning-based global rounding at explicit radius `R_clean`, with local `8ε` Clifford rounding and residual `D≤π√q ε` | every stabilizer `AME(2m,q)`, `m≥2`; asymptotics conditional on AME existence | leakage-aware three-region commutator, Weyl--Fourier concentration, stabilizer overlap gap, AME second moment; no computation |
| C787 | relative two-state rounding over an exact base intertwiner, with the same local `8ε` and collective `π√q ε` constants | two stabilizer `AME(2m,q)` states on one exact product-unitary orbit; radius remains `R_clean` | exact-base line transport, defect identity, product-intertwiner torsor, and lossless conditional decomposition are kernel checked; the cleaning radius and coefficient remain manuscript inputs |
| C836 | uniform scale `Theta(min{p^-1,q^-1/2,n^-1/2})`; Reed--Solomon scale `Theta(q^-1)` over prime fields and `Theta(q^-1/2)` at extension degree at least two | explicit existing families only; no fixed-`q` existence claim | closed-form comparison of the four terms in `R_clean` |
| C837 | after exact branch selection, local frame errors satisfy the collective squared estimate `≤π²ε²` | conclusion of cleaning theorem | chord bound applied to the collective residual norm |
| C838 | cleaning-rounded symplectic maps satisfy every minimum-support transition at a dimension-only radius; localized commutators cannot control the stabilizer character | every stabilizer AME state; exact product-Pauli correction may be nonlocal in the rounding metric | two intersecting minimum supports and commutator-phase separation; manuscript proof only |
| C889 | the induced action on any chosen encoder is within \\(8\\varepsilon\\) of an exactly transversally realizable logical Clifford at the transition-compatibility radius | every stabilizer AME state; controls the logical image, not local distance of the full physical correction | robust transition compatibility, surjectivity onto the input Weyl plane, and stabilizer cancellation |

## Appendix hierarchy

| Source | Appendix result | Disposition |
|---|---|---|
| C774--C777 | 2-uniform discreteness, local quadratic stability, and 2-unitary gauge corollary | retained in Appendix A as mechanism comparisons |
| C786/C795 | stabilizer overlap gap and balanced-cut residual stability; `k`-uniform generator-coordinate radius, ceiling, and single-marginal explicit threshold | the two load-bearing estimates are proved in Section 5; the alternative routes remain in Appendix A |
| C796 | stability under per-site spectral control from a balanced cut | canonical statement and proof are Proposition 5.4; Appendix A cites it directly |
| C581/C795 | quantitative one-marginal axis recovery and two-state Clifford rounding | retained as the exponentially diluted comparison route |
| C830 | aggregate minimum-support rounding at `Theta_q(m^-3/4(2/q)^m)` | retained as the orthogonal-support-sector comparison; superseded globally by cleaning |

## Stable body labels

- `thm:lu-lc-rigidity`: arbitrary-additive stabilizer-AME LU rigidity.
- `prop:stabilizer-ame-support`: exact `q²` supported-label group and
  bijective local projections on every half-plus-one marginal.
- `prop:full-weyl-marginal`, `cor:full-weyl-cover`, and
  `prop:marginal-axes`: reusable complete Weyl-basis axis recovery.
- `thm:atlas-classification`: exact minimum-support transition-map classification and
  symmetry-group extension.
- `lem:pauli-phase-correction`: product-Pauli correction after the label
  Lagrangian is matched.
- `cor:transversal-clifford`: factorwise transversal rigidity for encoder
  conversions.
- `thm:quantitative-rounding`: introduction-level quantitative theorem.
- `lem:quantitative-cleaning-commutator` and `lem:nested-weyl-rounding`:
  leakage-aware cleaning and finite Weyl--Fourier concentration.
- `thm:cleaning-global-rounding`: explicit proof and constants for the
  quantitative theorem.
- `cor:relative-intertwiner-rounding`: lossless transfer of global rounding
  to two states over an exact base intertwiner.
- `prop:robust-linear-atlas`: exact symplectic compatibility of the transition
  maps and the stabilizer-character boundary.
- `cor:logical-clifford-rounding`: dimension-only rounding of the induced
  encoder action despite the uncontrolled global Pauli correction.
- `lem:stabilizer-overlap-gap`: exact branch separation used by every
  defect-only route.
- `prop:main-residual-stability`: balanced-cut control of the collective
  residual generators in the headline quantitative theorem.

## Deliberate exclusions

- No global LU--LC conjecture and no result for arbitrary stabilizer states.
- No classification of nonstabilizer or arbitrary minimal-support AME states.
- No party-count-independent defect-ball radius.
- No optimality or self-testing claim for `R_clean`.
- No semilinear, split-torus, code-reconstruction, diagonal-isoduality,
  six-point-pencil, finite-census, transport, or party-extension theorem;
  those exact-group and geometric results belong to Paper II.
- No claim that the cleaning theorem, its constants, robust transition
  compatibility, or the character obstruction is kernel checked or
  certificate checked.
