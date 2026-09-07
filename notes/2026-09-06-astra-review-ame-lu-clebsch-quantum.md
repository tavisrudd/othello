# Review of three Astra (ChatGPT) suggestions: AME marginals/SLOCC, MDS--CSS errata, Clebsch cubic-phase codes

**Lane:** `ame-lu` (review requested by the user; items 3 and 4 concern other lanes and were
not acted on there).  Date: 2026-09-06.  Follow-ups allocated: C1089 (`ame-lu`), C1090 (`clebsch`).

## 1. MDS--CSS errata (Paper II) — already applied

Both reported items refer to `papers/mds_css_transversal_groups`.  Commit `6034287a6`
(2026-09-06, "apply Astra recheck errata across four manuscripts") already replaced the
inverse-transpose label rule in the diagonal-isoduality proof by conjugation `K A K`,
`K = diag(1,-1)`, and rewrote the fixed-copy takeaway in the LU-invariants section to say it is a
statement about the geometric generic locus, that polynomial invariants separate any finite family,
and that only uniformity in `q` or family size is open.  The paper repository
`~/src/math-papers/mds-css-transversal-groups` carries the same fix at `6bd7cb8`.  The review was
of a stale copy.  Nothing to repair.

## 2. AME marginal certification (Paper I) — correct; sharp count and Hamiltonian threshold unclaimed

Inputs already in Paper I: the stabilizer-AME support theorem `|L(A)| = q^2` and the half-set
decomposition `L = ⊕_{j∉B} L(B∪{j})` (with the "fewer than m minimum-support subgroups cannot span"
clause).  Checked by hand: `Π_j = q^{m-1} ρ_{A_j} ⊗ I` is the projector onto the common +1 space of
`L(A_j)`; the product over `j` is `|ψ><ψ|`; any state with the `m` prescribed marginals has unit
expectation on each `Π_j`, hence equals `ψ` (UDA); `≤ m`-party marginals are maximally mixed
(optimal locality); for `k < m` chosen `(m+1)`-sets the normalized projector of the generated
subgroup is mixed and reproduces those marginals (optimal count, mixed-state sense);
`H = Σ_j (I - Π_j)` is a commuting-projector parent Hamiltonian with unique ground state and unit
gap; `1 - F ≤ Tr(Hσ) ≤ Σ_j δ_j`; no nontrivial `m`-local Hamiltonian has `ψ` as a ground state.

Caveats for the manuscript: the half-set decomposition is the systematic form of an MDS code
relative to an information set; `n/2 + 1` locality is the generic Jones--Linden threshold, so only
the exact count `m` and the lower bounds are AME-specific; the Hamiltonian and witness are the
standard stabilizer constructions.

Literature (report: `2026-09-06-c1089-literature-ame-marginals-slocc.md`): the only competitor
is Wu et al., PRA 92, 012305 (2015), Theorem 2 (stabilizer states determined by `n` generator-support
marginals, qubit-only, uncontrolled supports); the `m`-marginal, `(m+1)`-party version with the
"fewer than `m` fail" bound is a strict sharpening.  No parent-Hamiltonian or locality-threshold
statement for AME/perfect tensors is in print (2025 AME review arXiv:2508.04777, HaPPY, Error
Correction Zoo checked).  Fidelity certificate: cite Tóth--Gühne PRA 72, 022340 (2005).

## 3. AME SLOCC (Paper I) — SLOCC = LU pre-empted; branchwise scalar-unitary corollary is new

SLOCC = LU for critical (hence all `k`-uniform) states is Burchardt--Raissi, PRA 102, 022413 (2020),
Corollary 1, restated with the 0-or-1 exact-conversion dichotomy in arXiv:2508.04777; both via
Kempf--Ness and Gour--Wallach NJP 13, 073013 (2011).  Paper I's bibliography already holds
`BryanLeutheusserReichsteinVanRaamsdonk2019` and `GourKrausWallach2017`, uncited in the body.

The stronger statement — every product Kraus branch `(⊗A_i)ψ ∝ φ` between 2-uniform states with
maximally mixed one-party marginals has each `A_i` scalar-unitary — is correct by the variance
argument (`f(t) = log‖e^{tH}ψ‖²`, `f'(0) = f'(1) = 0`, `f'' = 4 Var ≥ 0`, and 2-uniformity gives
`Var_ψ(H) = q^{-1} Σ tr H_i²`).  Kempf--Ness alone does not give it (GHZ is 1-uniform with a
continuous SL stabilizer); for qubit stabilizer states it follows from Englbrecht--Kraus PRA 101,
062302 (2020); nothing covers general `q` or non-stabilizer 2-uniform states.  Combined with
LU = LC this makes SLOCC equivalence of stabilizer AME states decidable by the paper's finite
symplectic recognition.

Recommendation (C1089): one proposition (sharp marginal certification, parent Hamiltonian with
locality threshold, fidelity bound) and one remark (SLOCC corollary) in Paper I, citing the sources
above.  Not a headline.

## 4. Clebsch II → cubic-phase quantum codes — sound and independently replayed

Astra's memo (4 Sept 2026) derives from the two exceptional matching configurations of *Quadratic
Trade Rigidity and Cubic Orientation in Conic Matching Quotients* (Clebsch Paper II) the CSS codes
`[[14,6,2]]_7` and `[[22,10,2]]_11` (X-stabilizer `<1>`, Z-stabilizer `L^⊥ = DL`) with a signed
transversal cubic phase `⊗ M^{ε_i}` inducing the logical cubic `F(u) = Σ ε_i (x_i·u)^3`.

Confirmed against Clebsch II: base matchings match its (3.1); its Gorenstein section gives
`dim L = p`, `L∘L = ε^⊥` of dimension `2p-1`, `L∘L∘L = V` (Hilbert function `(1,q-1,q-1,1)`),
exactly the inputs the construction uses.  Hand-checked: parameters and distance, moment
cancellation, ε-only rigidity of the cubic direction, no-extra-X-check obstruction, acceptance
formula, leading infidelity coefficients `91/6` and `231/10`, enumerator totals and `(p-1)`
divisibility, the Pauli-spectrum non-equivalence argument, Waring bounds `k+1 ≤ r ≤ 2p-1`.

Structural remark not in the memo: `F_p^{p-1}` is the `SL_2(p)`-representation
`Sym^{p-3} ⊕ triv` (quartics for `p = 7`, octavics for `p = 11`) and `F` is `PSL_2`-invariant, so
the shape `s·(quadratic invariant) + (cubic invariant)` is forced; only the coefficients and the
vanishing of the `s³` term are computational.

Independent replay (`2026-09-06-clebsch-quantum-replay/REPORT.md`, scripts alongside): every
exact claim reproduced — ranks, signed self-orthogonality, Schur-square hyperplane, both raw
cubics, both normal forms, transvectant identities under the memo's binomial normalization,
radical, centroid ranks 35 and 99, both full weight enumerators (p = 11 by subset-rank enumeration
in Rust), distances 6 and 8, witnesses, reconstruction from the base matchings, numerical
acceptance/infidelity to every printed digit.  Two corrections: the `p = 7` rank-one certificate
leaves the line through `v = (0,0,1,2,0,0)` (Hessian rank 4, so the conclusion survives;
exhaustive minimum Hessian rank is 3); the `p = 11` coordinate list is a rank-preserving projection
of the 15 quartic monomials, not the raw coefficient vector.

Prior art to expect: weighted/generalized triorthogonal qudit codes (Campbell--Anwar--Browne 2012;
Haah's generalized divisible codes; Krishna--Tillich 2019; Saha--Prakash 2025).  The mechanism is
known; the two invariant-defined gates, their certificates, and the trade-to-code dictionary are
the candidate novelty.  No priority search has been done.  Queued as C1090 in `clebsch`; the
`clebsch` handoff and discovery track were not edited (foreign lane).

**Overlap with the existing Clebsch quantum spinoff (checked 2026-09-07).**
`papers/conference-cut-spectra` (*Balanced Cuts of Conference Matrices*, DOI
10.5281/zenodo.21766747) is a linear-optics application of Clebsch III's order-six conference
matrices: real orthogonal six-mode transfers indexed by the six synthematic totals, determinant
amplitudes obeying the Segre-cubic nulls `Σ Z_T = 0`, `Σ Z_T³ = 0`, degree-three Schur sectors
of `±1` control vectors, boson/fermion sampling readout, and a photonic design limit.  It has no
finite-field, stabilizer-code, qudit-register, transversal-gate, or magic-state content, and its
cubic identities are real power sums on six amplitudes, not `F_p` moment identities on `2p`
points.  There is no overlap of objects, results, or claims with the cubic-phase codes; C1090
should cite it only as the programme's earlier quantum application, in a coda.
