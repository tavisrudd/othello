# C925 referee source-substitution table

Date: 2026-08-21

## Result-level trust statement

The no-Stokes all-stabilizations consumer is kernel-checked after the
following geometric inputs are supplied.  Its path-level geometric
instantiation is not yet closed: every occurrence of an intermediate variety
must descend from one native rowed marked module.  Several decisive inputs are
currently preprints rather than journal publications.  Lean verifies their
linear-algebraic consequences and the finite rational cubic-block arithmetic;
it does not independently construct quantum cohomology modules or Fourier
comparison maps.

The active consumer is
`Comparison.RowedProjectorDecomposition.UnitScaledData.detects_iff`.  It needs
only an invertible ambient-plus-correction comparison, a unit-scaled row
square, and a block-natural idempotent-projector square.  The correction
projector may be nonzero.

The direct edge instantiation uses the Gu--Yu--Yu basis, row, comparison, and
connection statements together with the KKPYY marked spectral union.  The
other formal interfaces are alternatives: a polynomial projector may replace
a directly supplied projector square; a faithful common base is needed only
when two scalar extensions are compared; unit scaling is needed only when the
row normalization is not exact; and the tensor lemma is an endpoint
constructor.  They are not cumulative hypotheses.

| Provider choice | Replaces | Does not replace |
|---|---|---|
| Direct projector square | Polynomial presentation plus operator square | Geometric identification of the marked union |
| Polynomial functional calculus | Direct projector-square verification | Proof that the polynomial is the geometric marker |
| Direct endpoint comparison | Two common-source presentations | QDM existence and invertibility |
| Common-source composition | A separately cited composite comparison | Existence of both source presentations |
| Same coefficient ring | Faithful common-base descent | Row/projector compatibility |
| Faithfully flat common base | A map between incompatible completions | Proof that both complete marked modules descend |
| Exact row square | Unit normalization | Projector naturality |
| Unit-scaled row square | Exact normalization | Proof that the scale is a unit |
| Tensor endpoint constructor | A separate product-witness calculation | Projective-bundle QDM comparison |

These are alternate implementations of one row-visible-projector proof.  The
one-sided marked-witness construction is a genuinely different consumer, but
its required source-to-projective-space map has not been constructed.

## Publication and substitution ledger

| Input | Status checked on 2026-08-21 | Exact imported statement | Lean or computational substitute | Irreducible external content |
|---|---|---|---|---|
| Gu--Yu--Yu, *Quantum cohomology of variations of GIT quotients and flips*, arXiv:2508.15770v1 | Author CV and arXiv list it as a preprint; no journal version located | Proposition 5.2 finite-free ordinary basis; Proposition 4.21 fundamental-solution square; Theorem 5.5 simple-wall completed isomorphism | `Data.ofBasisSquares`, `UnitScaledData.ofBasisSquares`, and `CommonSourcePresentation.ofBasisSquares` prove that the basis equations extend and compose. The Haskell checker rejects a bad row square, singular comparison, and missing source token. | Existence and invertibility of the completed QDM maps, their exact coefficient rings, and the basis formulas |
| Katzarkov--Kontsevich--Pantev--Yu, *Birational Invariants from Hodge Structures and Quantum Multiplication*, arXiv:2508.05105v2 | Institutional and arXiv records list a preprint; no journal version located | Theorems 4.1, 4.5, and 4.11: formal spectral decomposition and blowup/projective-bundle F-bundle decompositions | `polynomialProjector_naturality` proves projector transport from one operator square whenever the marked projector is presented by one polynomial. `CommonSourcePresentation.toUnitScaledData` checks downstream fusion with the row theorem. | Existence and canonicity of the geometric spectral splitting, and the claim that the C925 marker selects the corresponding union of blocks |
| Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3 | The Gu--Yu--Yu bibliography records it as “to appear in Kyoto J. Math.”; the checked text is still the arXiv version | Formal blowup QDM decomposition used by KKPYY and the simple-wall model; vertex inclusions (5.38), (5.39); center homomorphism (5.40); invertible combined coordinates in Theorem 5.18(7) | The same row/projector certificate interfaces test any explicit finite-free presentation. A field-first native datum can use faithful field extensions, but localization of an integral module at its fraction field is not faithful. | The QDM decomposition theorem, its ring/completion hypotheses, and the proof that every path occurrence is the faithful pullback of one native rowed marked module while retaining the regular z-lattice |
| Iritani--Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4 | Author CV and bibliographic records list it as a preprint; no journal version located | Projective-bundle QDM decomposition and the faithful common coefficient spine | `detects_baseChange_iff`, `detects_on_common_extensions_iff`, and `detects_tensorIdentity` prove faithful descent and endpoint witness transport | The projective-bundle comparison and the proof that the actual marked modules descend to the named common ring |
| Programme cubic-block calculation | Local, not refereed | Rank-two zero block, nonzero nilpotent, modified-residue discriminant `4/9`, and degree-zero row `(0,-7r^2)` | `CubicBlockCertificate` kernel-checks the normalized rational nilpotent, trace `-1`, determinant `5/36`, discriminant `4/9`, and row detection. The earlier exact SymPy certificate independently checks the full conjugation at symbolic nonzero `r`. | Identification of the finite matrices with the cubic QDM block and the normalization from the geometric quantum product |
| Abramovich--Karu--Matsuki--Wlodarczyk, *Torification and factorization of birational maps*, JAMS 15 (2002) | Refereed journal theorem | Projective weak factorization with smooth centers | No supplemental proof is needed; Lean only consumes a finite sequence of lawful edge comparisons | The algebraic-geometric weak factorization theorem |
| Projective-space endpoint | Classical computation, with the quantum-product input traced through the endpoint packet | Generic rank-one spectral blocks and therefore zero marked projector | `not_detects_zero` and `projectiveProductBranchCount_pos` prove the consumer and the unbounded `m+1` arithmetic; Haskell separately checks `m=1,3,4,13` and `0..64` | Identification of the actual projective-space QDM spectral factors with the rank-one model |

The publication-status search found preprint records for Gu--Yu--Yu, KKPYY,
and Iritani--Koto.  Gu--Yu--Yu's bibliography records Iritani's blowup paper
as accepted/forthcoming in *Kyoto Journal of Mathematics*.  This records what
was found; it does not substitute a forthcoming version for the audited arXiv
text or assert that no later bibliographic record can exist.

## Independent-derivation matrix

“Second derivation” below means a genuinely different proof of the imported
identification.  A restatement built from the same Fourier operators is
classified as a lineage cross-check, not as independent evidence.

| Geometric identification | Primary derivation | Alternate derivation | Independence verdict | Live use |
|---|---|---|---|---|
| Blowup QDM direct sum | Iritani Theorem 5.18 | Gu--Yu--Yu Theorem 5.5 in the three-component wall model; KKPYY Theorem 4.5 analytifies Iritani | GYY has a distinct leading-basis/Vandermonde invertibility proof but imports Iritani's shift/Fourier machinery. KKPYY explicitly extracts its theorem from Iritani, so it is not independent. | Prefer Iritani for ordinary blowups; retain GYY as a theorem-level cross-check. |
| Ambient rank-row square | Apply degree-zero augmentation to Iritani's common-source Fourier maps and the definition of `Psi` | Gu--Yu--Yu Definition 4.13, Propositions 2.8 and 4.21, Proposition 5.2 | Same Fourier/augmentation mechanism in two papers, so this is a derivational cross-check, not an independent geometric proof. The elementary augmentation step should be proved in the packet. | Source-local proof can avoid attributing a separate row theorem to either paper. |
| Marked-projector naturality | Canonical spectral decomposition in HYZZ/KKPYY plus connection naturality | Direct formal CRT/Hensel splitting and isomorphism invariance of rank, nilpotent part, and modified residue; polynomial functional calculus when a collision-free polynomial exists | The formal-algebra proof is independent of KKPYY canonicity. The polynomial shortcut is only conditional: it fails if marked and unmarked blocks cannot be separated by one polynomial in the chosen operator. | Promote the direct formal lemma as the source-minimal route; keep KKPYY as corroboration. |
| Cubic marked block | Beauville's cubic quantum product plus the C924 exact conjugation/residue calculation | KKPYY Example 6.21 identifies an indecomposable cubic zero atom from the quantum differential equation | Only partial independence. Example 6.21 corroborates the zero atom but does not compute the C924 modified-residue discriminant `4/9`; it is not a second proof of the exact marker. | Exact geometric normalization remains one-source plus two computational replays. |
| Product source `X x P^m` | Iritani--Koto Theorem 5.1 | Standard product/CohFT formula on a small product slice, followed by the tensor-projector and tensor-row lemma | Genuinely independent once the product QDM formula is cited/proved. It avoids the opposite Laurent projective-bundle completion. | Highest-value endpoint redundancy to write explicitly. |
| Projective-space target | Explicit `QH(P^n)=K[H]/(H^(n+1)-q)` at `q != 0` | Iritani--Koto with base a point | Genuinely independent but elementary; both yield rank-one factors. | Add a finite polynomial/separability certificate if desired. |
| Repeated-vertex occurrence | Field-first native rowed projectors, Iritani's vertex inclusions (5.38), (5.39), and compatible field extensions; (5.40) is excluded | Analytic continuation of the horizontal rowed projector on one connected native maximal F-bundle | Two conceptual bridges, neither complete. The algebraic route must keep the regular z-lattice and prove same-map carrier/row/projector descent; coordinate invertibility is insufficient. | **Open gate.** Do not telescope until one bridge is completely written. |

This audit therefore finds multiple proofs for the endpoint and formal
projector identifications, but not two independent proofs of the exact cubic
marker or rank-row geometry.  The active proof may be made source-minimal by
using Iritani for blowups, the direct formal spectral lemma, the standard
product formula, Beauville's cubic calculation, the explicit projective-space
ring, and AKMW.  GYY/KKPYY then become high-value corroborating routes rather
than simultaneous hypotheses.

## Exact source-to-consumer substitution

For one wall, let `S` be the completed common source, with presentations

\[
 F_{\rm src}:S\xrightarrow{\sim}V_{\widetilde Y},\qquad
 F_{\rm tgt}:S\xrightarrow{\sim}V_Y\oplus C_Z.
\]

The endpoint comparison is not an extra source theorem:

\[
 \Psi=F_{\rm tgt}F_{\rm src}^{-1}.
\]

`CommonSourcePresentation.toUnitScaledData` proves this composition and its
two squares from one common projector, the two presentation naturality
squares, and the common-source row equation.  Its basis constructor reduces
all three equations to a finite basis.  The proof still requires the two
presentations as actual linear equivalences; a finite truncation cannot prove
invertibility in a completed infinite series ring.

For a factorization path this construction must be preceded by an occurrence
descent.  For each vertex `Y`, choose one native `(V_Y,row_Y,P_Y)`.  Each
incident edge must identify its occurrence with a faithful scalar extension
of that datum.  Define the native data over coefficient fields first, without
inverting \(z\); a finite diagram of field embeddings may then be passed to
one common overfield.  `RowedProjectorPath` gives the telescope with a
definitionally shared intermediate value.  A nominally repeated variety name
is not a substitute for these maps.

The marked projector may be checked by either of two exact routes:

1. supply the block-natural projector square directly; or
2. exhibit one operator `E`, one polynomial `p`, prove
   `P_mark=p(E)` on both sides, and prove the operator square.

`polynomialProjector_naturality` proves the second route.  Numerical
agreement of eigenvalues without a collision-free polynomial presentation is
not accepted.

The row may be enlarged into a Givental coefficient module through an
explicit injective linear map; `detects_comp_injective_iff` handles this
separately from scalar extension.  Two unrelated completions may be compared
through `detects_on_common_extensions_iff` only after the full marked modules
and rows are proved to descend to one faithfully flat common base.

## Certificate intake

An exact finite-free source certificate can be consumed if it records:

1. the coefficient ring and ordered bases;
2. both common-source presentation matrices and inverse matrices;
3. the common, source, ambient, and correction projector matrices;
4. idempotence and the two projector squares on the common basis;
5. the source and ambient row matrices, the unit scale, and the row square on
   the common basis;
6. any coefficient-module injection used for the row;
7. any common-base algebra maps and a proof of faithful flatness; and
8. for polynomial transport, the operator matrices and the common polynomial.

Lean then constructs the comparison data and proves detection preservation.
The Haskell suite exhaustively tests the same schema over `F3`, including two
independent common-source presentations.  A certificate containing truncated
power series proves only the corresponding truncation.  Exact existence of
the completed QDM map requires exact symbolic coefficients, a finite
presentation theorem, or the cited geometric source theorem.

## Referee attack points

The proof fails if any one of the following occurs:

- the Gu--Yu--Yu row equation is valid only before the Theorem 5.5 base
  change and the ordinary basis does not remain a basis afterward;
- the comparison intertwines the connection but the marked projector is not
  functorial under that same map;
- the projectors exist only after a nonfaithful specialization or a turning
  collision;
- the occurrence comparison inverts \(z\) and therefore forgets the regular
  \(z=0\) lattice on which the marker is defined;
- the row normalization is zero or a nonunit;
- two incident edges use unrelated occurrences of the same intermediate
  variety;
- the cited edge theorem does not cover a higher-dimensional AKMW center;
- the cubic rational block is not the actual geometric block; or
- the projective-space endpoint has a marked rank-two factor.

Each consumer-side algebraic weakening has a Lean theorem and a finite hostile
check.  Four independent referee-facing gates remain: the exact source
row/projector equations for every allowed edge, occurrence descent, the
cubic-product endpoint identification, and projective-space marked emptiness.
