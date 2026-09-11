# Theorem adoption map

This map covers Paper I after the two-paper split. Results owned by
`mds_css_transversal_groups` are absent; their frozen labels remain assigned in
`cross-paper-theorem-ownership.md`.

## Body hierarchy

| Source | Manuscript result | Exact boundary | Evidence type |
|---|---|---|---|
| C649 | every product-unitary intertwiner between additive stabilizer `AME(2m,q)` states is Clifford factor by factor | every prime power `q=p^e`, every `m≥2`, standard additive Weyl system; Bell pairs excluded sharply | AME support counting, complete Weyl-basis marginal, intrinsic tensor axes; manuscript proof with kernel-checked cores |
| C649 | minimum-support transition maps classify LU equivalence up to local trace-symplectic frames; exact sequence for the fixed-party projective symmetry group | same state class | minimum-support generation, transition equations, product-Pauli character correction |
| current revision | every half-set gives a systematic graph `[K_B^T|I]`; AME is equivalent to invertibility of one block from every complementary pair of party-aligned square submatrices; `m` minimum-support subgroups form an optimal spanning direct sum | arbitrary additive label spaces over `F_p`; optimal only among spanning families of minimum-support subgroups | half-set projection, isotropy, symplectic complementarity, and block-kernel argument; manuscript only |
| current revision | fixed-label LU recognition is the block orbit equation `F_B K_psi = K_phi F_C`, with an explicit field-operation bound; over prime fields it reduces to `(m-1)^2` four-cycle intertwining equations and `det A=1` | promised stabilizer-AME check matrices and `m≥2`; compact symplectic witnesses, upgraded with phase/tableau data; polynomial in `m` for fixed `q`; unknown party relabelling adds at most `(2m)!`; no bit-complexity claim | systematic reduction, tree propagation, and fundamental-cycle proof; manuscript only |
| C1089 | the `m` reductions to `B∪{j}` determine the state among all density operators, with a family of `(m+1)`-party reductions sufficient iff its supported subgroups span `L`; reductions to `≤m` parties and fewer than `m` such reductions do not suffice; `H=Σ(I−Π_j)` is an `(m+1)`-local commuting-projector parent Hamiltonian with unit gap and the marginal fidelity certificate `1−F ≤ Tr(Hσ) ≤ Σ δ_j`; no nonscalar `m`-local Hamiltonian has the state as a ground state | every stabilizer `AME(2m,q)`, `m≥2`; mixed-state (UDA) determination; no claim about non-stabilizer AME states | half-set direct sum, support theorem, and `(2.2)`--`(2.3)`; manuscript only |
| C1089 | every product operator `⊗A_i` carrying one stabilizer `AME(2m,q)` state to a nonzero multiple of another is Clifford up to scalars factor by factor; SLOCC, LU, and LC equivalence coincide and exact single-copy conversion has success probability one or zero, decided by the finite recognition bound | `m≥2`; the scalar-unitary step holds for every two-uniform state, the Clifford step is the rigidity theorem | polar decomposition and the convexity of `log‖e^{tH}ψ‖²` with two-uniform second moments; manuscript only |
| C989 | the algebra of block-diagonal one-party label-space endomorphisms preserving `L` is intrinsically the common holonomy centralizer; in prime dimension its determinant-one units are the fixed-party linear symmetry group and have five possible algebra types | algebra/centralizer identification over the underlying `F_p` spaces for every prime power; determinant-one and five-type conclusions only for `q=p` | graph propagation and elementary subalgebras of `M_2(F_q)`; manuscript only |
| C989 | for prime-dimensional stabilizer `AME(4,q)` and `AME(6,q)` states the local endomorphism algebra has dimension at least two; its algebra type determines CSS form after local symplectic coordinate changes, weighted Hermitian form, dual-number module, or multiplicity-code structure | `q=p`; noncentral-group corollary only for `q>=5`; no MDS-over-rings terminology or genericity claim | weighted block anti-isometry and standard finite-dimensional module theory; manuscript only |
| C649 | every transversal conversion between associated `[[2m-1,1,m]]_q` encoders is Clifford on every physical and logical factor; check matrices return symplectic witnesses, while full tableaux construct compact Clifford--Pauli data whose phase repair can be confined to any chosen `m` physical outputs | every prime power and `m≥2`; one logical qudit; no dense-matrix output bound | AME Choi correspondence, transpose/inverse Clifford closure, finite recognition, and half-supported character correction |
| C833 | cleaning-based global rounding at explicit radius `R_clean`, with local `8ε` Clifford rounding and residual `D≤π√q ε` | every stabilizer `AME(2m,q)`, `m≥2`; asymptotics conditional on AME existence | leakage-aware three-region commutator, Weyl--Fourier concentration, stabilizer overlap gap, AME second moment; no computation |
| C787 | relative two-state rounding over an exact base intertwiner, with the same local `8ε` and collective `π√q ε` constants | two stabilizer `AME(2m,q)` states on one exact product-unitary orbit; radius remains `R_clean` | exact-base line transport, defect identity, product-intertwiner torsor, and lossless conditional decomposition are kernel checked; the cleaning radius and coefficient remain manuscript inputs |
| C836 / C1134 | uniform scale `Theta(min{q^-1/2,n^-1/2})`; Reed--Solomon scale `Theta(q^-1/2)` over prime and extension fields | explicit existing families only; no fixed-`q` existence claim | character averaging and closed-form comparison of the two terms in `R_clean` |
| C837 | after exact branch selection, local frame errors satisfy the collective squared estimate `≤π²ε²` | conclusion of cleaning theorem | chord bound applied to the collective residual norm |
| C838 / C1134 | cleaning-rounded symplectic maps satisfy every minimum-support transition at a universal radius `sqrt(2)/68`; localized commutators cannot control the stabilizer character | every stabilizer AME state with `m>=2`; exact product-Pauli correction may be nonlocal in the rounding metric | two intersecting minimum supports, normalized two-site Hilbert--Schmidt control, and character averaging; manuscript proof only |
| C889 | the induced action on any chosen encoder is within \\(8\\varepsilon\\) of an exactly transversally realizable logical Clifford at the transition-compatibility radius | every stabilizer AME state; controls the logical image, not local distance of the full physical correction | robust transition compatibility, surjectivity onto the input Weyl plane, and stabilizer cancellation |

## Appendix hierarchy

| Source | Appendix result | Disposition |
|---|---|---|
| C774--C777 | 2-uniform discreteness and local quadratic stability | retained in Appendix B as the stabilizer-independent infinitesimal mechanism |
| C786/C795 | stabilizer overlap gap and balanced-cut residual stability; former `k`-uniform generator-coordinate comparison | the two load-bearing estimates are proved in Section 6; the independent `k`-uniform radius study was retired in C993 |
| C796 | stability under per-site spectral control from a balanced cut | canonical statement and proof are Proposition 6.4 in Section 6 |

## Stable body labels

- `thm:lu-lc-rigidity`: arbitrary-additive stabilizer-AME LU rigidity.
- `prop:stabilizer-ame-support`: exact `q²` supported-label group and
  bijective local projections on every half-plus-one marginal.
- `prop:full-weyl-marginal`, `cor:full-weyl-cover`, and
  `prop:marginal-axes`: reusable complete Weyl-basis axis recovery.
- `thm:atlas-classification`: exact minimum-support transition-map classification and
  symmetry-group extension.
- `prop:half-set-direct-sum`, `cor:finite-recognition`,
  `cor:prime-systematic-recognition`: systematic half-set form, optimal
  linear-size support reduction, explicit recognition bound, and
  prime-field fundamental-cycle reduction.
- `prop:marginal-certification` and `cor:stochastic-conversion`: sharp
  mixed-state determination by `m` half-plus-one reductions, the parent
  Hamiltonian with its locality threshold and fidelity certificate, and
  scalar-Clifford rigidity of stochastic conversions.
- `thm:local-endomorphism-algebra`, `cor:endomorphism-types`, and
  `thm:low-party-endomorphisms`: intrinsic algebra/centralizer identification,
  five prime-field algebra types and unit groups, and the four-/six-party
  dimension bound.
- The last column of Table 1 and Appendix A give the code and module
  structures forced by the four nonscalar prime-field algebra types.
- `lem:pauli-phase-correction`: product-Pauli correction after the label
  Lagrangian is matched, uniquely supported on any prescribed half for an
  AME target; fewer parties cannot support all character repairs.
- `cor:transversal-clifford`: factorwise transversal rigidity for encoder
  conversions.
- `thm:quantitative-rounding`: introduction-level quantitative theorem.
- `lem:quantitative-cleaning-commutator` and `lem:nested-weyl-rounding`:
  Pauli-compatible leakage-aware cleaning and finite Weyl--Fourier concentration for `eta<1/3`, uniformly in characteristic.
- `thm:cleaning-global-rounding`: explicit proof and constants for the
  quantitative theorem.
- `cor:relative-intertwiner-rounding`: lossless transfer of global rounding
  to two states over an exact base intertwiner.
- `prop:robust-linear-atlas`: exact symplectic compatibility of the transition
  maps and the stabilizer-character boundary.
- `cor:logical-clifford-rounding`: dimension-independent rounding of the induced
  encoder action despite the uncontrolled global Pauli correction.
- `lem:stabilizer-overlap-gap`: exact branch separation used by every
  defect-only route.
- `lem:balanced-cut-comparison`, `prop:main-residual-stability`:
  unconditional balanced-cut comparison for arbitrary product unitaries,
  followed by collective residual control in the headline quantitative
  theorem.

## Deliberate exclusions

- No global LU--LC conjecture and no result for arbitrary stabilizer states.
- No classification of nonstabilizer or arbitrary minimal-support AME states.
- No party-count-independent defect-ball radius for a nearby exact product symmetry.
- No optimality or self-testing claim for `R_clean`.
- No semilinear, split-torus, code-reconstruction, diagonal-isoduality,
  six-point-pencil, finite-census, transport, or party-extension theorem;
  those exact-group and geometric results belong to Paper II.
- No paper-facing eight-party witness and no finite-field density statement for
  the center-only symmetry type.
- No claim that the cleaning theorem, its constants, robust transition
  compatibility, or the character obstruction is kernel checked or
  certificate checked.
