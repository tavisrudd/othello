# C925 referee source-substitution table

Date: 2026-08-21

## Result-level trust statement

The no-Stokes all-stabilizations consumer is kernel-checked, but the geometric
proof is not yet source-instantiated.  Iritani supplies the completed
comparison and exact augmentation-row square.  Its Euler residual square,
together with the C924/KKPYY spectral-extension theorem, supplies the formal
stable-projector square.  Those two squares currently live in opposite
\(z\)-completions and have not been placed on one faithful even coefficient
object.  Moreover the cubic calculation proves raw \(z=0\) row visibility,
not visibility of \(\epsilon M\) on the full stable projector.  Lean verifies
the conditional linear-algebraic consequences and the finite rational
cubic-block arithmetic; it does not construct this common QDM object or the
missing cubic full-row witness.  Several decisive inputs are preprints rather
than journal publications.

The active consumer is
`Comparison.RowedProjectorDecomposition.UnitScaledData.detects_iff`.  It needs
only an invertible ambient-plus-correction comparison, a unit-scaled row
square, and a block-natural idempotent-projector square.  The correction
projector may be nonzero.

The direct all-center edge instantiation uses Iritani's completed blowup
comparison and its derived augmentation row together with the KKPYY marked
spectral union.  Gu--Yu--Yu gives a simple-wall corroborating instantiation.
The other formal interfaces are alternatives: a polynomial projector may replace
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
| `FaithfulScalarEdge` | Separate occurrence equivalences and adjacent carrier identification | Construction of the native endpoint data, completed direct-sum map, or its two squares |
| Two-base faithful edge | One global native coefficient ring | Faithful maps to the edge ring or semantic endpoint identifications |
| Polynomial scalar-edge constructor | Direct projector-square check | Geometric polynomial presentation, operator square, or row square |
| Coprime-factor certificate | A preconstructed polynomial projector | Geometric marked/unmarked factor split and product annihilation |
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
| Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3 | The Gu--Yu--Yu bibliography records it as “to appear in Kyoto J. Math.”; the checked text is still the arXiv version | Proposition 5.1 fundamental-solution square; Theorem 5.2 completed Fourier isomorphism and ordinary basis; Proposition 5.4 ambient extension; Theorems 5.9/5.18 general smooth-center direct sum; vertex inclusions (5.38), (5.39); invertible generic bulk Jacobian in Theorem 5.18(7) | Applying degree-zero augmentation to the two Fourier maps proves the rank-row square on the exact Iritani comparison. `CoprimeFactorProjector` checks only the `z=0` CRT projector; KKPYY/C924 spectral-splitting canonicity transports its unique full connection-stable extension. `TwoBaseRowedProjectorEdge` proves reflection after a common faithful scalar object is supplied. | The general smooth-center QDM decomposition theorem and its ring/completion hypotheses; no cited statement puts the negative-`z` row and positive-`z` stable projector on one faithful even coefficient object |
| Iritani--Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4 | Author CV and bibliographic records list it as a preprint; no journal version located | Projective-bundle QDM decomposition and the faithful common coefficient spine | `detects_baseChange_iff`, `detects_on_common_extensions_iff`, and `detects_tensorIdentity` prove faithful descent and endpoint witness transport | The projective-bundle comparison; it corroborates the product endpoint but is not needed for the rank-row tensor identity |
| Behrend, *The product formula for Gromov--Witten invariants*, J. Algebraic Geom. 8 (1999), 529--541; arXiv:alg-geom/9710014v1 | Refereed journal theorem | Theorem 9: the Gromov--Witten transformation of a product is the tensor product/cup product of the two factor transformations | Its three-point genus-zero specialization gives the small quantum tensor algebra and degree-zero tensor row used by `CubicBlockCertificate.rankRow_tensor_detects` | The virtual-class product formula itself; it transports a full cubic row witness but does not derive that witness from the raw `z=0` row |
| Programme cubic-block calculation | Local, not refereed | Rank-two zero block, nonzero nilpotent, modified-residue discriminant `4/9`, and degree-zero row `(0,-7r^2)` | `CubicBlockCertificate` kernel-checks the normalized rational nilpotent, trace `-1`, determinant `5/36`, discriminant `4/9`, and row detection. The earlier exact SymPy certificate independently checks the full conjugation at symbolic nonzero `r`. | Identification of the finite matrices with the cubic QDM block and the normalization from the geometric quantum product |
| Abramovich--Karu--Matsuki--Wlodarczyk, *Torification and factorization of birational maps*, JAMS 15 (2002) | Refereed journal theorem | Projective weak factorization with smooth centers | No supplemental proof is needed; Lean only consumes a finite sequence of lawful edge comparisons | The algebraic-geometric weak factorization theorem |
| Projective-space endpoint | Classical small quantum presentation, independently corroborated by Iritani--Koto Theorem 5.1 with base a point | `QH(P^(m+3))=K[H]/(H^(m+4)-q)`; at `q != 0` its geometric spectral factors are rank one | `ProjectiveSpaceQuantumPolynomial.relationPolynomial_separable`, `not_detects_zero`, and `projectiveProductBranchCount_pos`; Haskell separately checks `m=1,3,4,13` and `0..64` | The standard geometric small-quantum presentation |

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
| Marked-projector naturality | KKPYY Theorem 4.1 and Remark 4.2: canonical full F-bundle spectral summands, applied to Iritani's connection isomorphism | C924's recursive Sylvester splitting gives the same unique full stable extension from the `z=0` CRT projector | These are two formulations of the same formal uniqueness mechanism. `CoprimeFactorProjector` checks the fibre projector only: a `z`-dependent connection gauge need not commute with that constant polynomial away from `z=0`. | Use full spectral-extension uniqueness; retain the CRT theorem as the exact leading-fibre certificate. |
| Cubic marked block | Beauville's cubic quantum product plus the C924 exact conjugation/residue calculation | KKPYY Example 6.21 identifies an indecomposable cubic zero atom from the quantum differential equation | Only partial independence. Example 6.21 corroborates the zero atom but does not compute the C924 modified-residue discriminant `4/9`; it is not a second proof of the exact marker. | Exact geometric normalization remains one-source plus two computational replays. |
| Product source `X x P^m` | Iritani--Koto Theorem 5.1 | Standard product/CohFT formula on a small product slice, followed by the tensor-projector and tensor-row lemma | Genuinely independent once the product QDM formula is cited/proved. `CubicBlockCertificate.rankRow_tensor_detects` kernel-checks transport of an already supplied cubic full-row witness. | The cubic full-row witness on the stable block remains open; the product theorem does not create it. |
| Projective-space target | Explicit `QH(P^n)=K[H]/(H^(n+1)-q)` at `q != 0` | Iritani--Koto with base a point | Genuinely independent but elementary; both yield rank-one factors. `ProjectiveSpaceQuantumPolynomial.relationPolynomial_separable` kernel-checks squarefreeness for every `m`. | Only the standard geometric small-quantum presentation remains imported. |
| Repeated-vertex occurrence | Iritani's injective vertex maps (5.38), (5.39), and the invertible formal generic coordinate germ in Theorem 5.18(7); (5.40) remains edge-local | `TwoBaseRowedProjectorEdge.Data.detects_iff` compares distinct native endpoint objects after faithful extension to one edge object | The intrinsic-predicate route needs neither a common path ring nor an adjacent carrier map once one native rowed object exists. | **Open at source level:** full big QDM has odd nilpotents, and on the even slice the row and stable projector use opposite `z`-completions. `Data.toIntrinsicEdge` closes only the downstream telescope after a faithful common object is supplied. |

This audit finds multiple proofs for the formal projector and projective-space
endpoint, but not a source proof of the common rowed coefficient object or of
the cubic full-row endpoint.  The active conditional proof is source-minimal:
Iritani for blowups, formal spectral-extension uniqueness, the standard
product formula, Beauville's cubic calculation, the explicit projective-space
ring, and AKMW.  GYY/KKPYY remain corroborating routes rather than
simultaneous hypotheses.  Unconditional all-\(m\) closure requires either a
direct even rowed F-bundle theorem or both missing local statements above.

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

For a factorization path, choose one native detection datum
`(V_Y,row_Y,P_Y)` at each vertex.  The loosest route does not identify the two
edge occurrences of (Y).  Instead, each edge supplies one faithful scalar
extension of its two native endpoint data and the completed direct-sum map
with its two squares.  `FaithfulScalarEdge.detectsAt_iff` proves the native
endpoint predicates equivalent; `toIntrinsicEdge` and
`IntrinsicPath.property_iff` telescope those propositions.  Define the native
data only after exhibiting an even graded/topological coefficient object on
which the row and projector compose, and use faithful extensions of that full
object.  A nominally repeated variety name or a fraction field of the
`z=0` lattice is not a substitute for these identifications.

The marked projector may be checked by any of three exact routes:

1. supply the block-natural projector square directly; or
2. exhibit one operator `E`, one polynomial `p`, prove
   `P_mark=p(E)` on both sides, and prove the operator square.
3. split the annihilating polynomial into marked and unmarked coprime factors,
   provide Bezout coefficients, and prove product annihilation.

`polynomialProjector_naturality` proves the second route.  Numerical
agreement of eigenvalues without a collision-free polynomial presentation is
not accepted.  `FaithfulScalarEdge.ofBasisRowAndPolynomialProjector` fuses
that derivation with faithful scalar reflection: after a basis row equation,
the operator square and two polynomial identities supply the intrinsic path
edge.
`CoprimeFactorProjector.Data` proves the third route constructs an idempotent
which selects exactly the marked-factor kernel and is natural under the
operator square.

The row may be enlarged into a Givental coefficient module through an
explicit injective linear map; `detects_comp_injective_iff` handles this
separately from scalar extension.  Two unrelated completions may be compared
through `detects_on_common_extensions_iff` only after the full marked modules
and rows are proved to descend to one faithfully flat common base.

## Certificate intake

An exact finite-free common-source certificate can be consumed if it records:

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

The smaller intrinsic-edge certificate records the native source and target
rows and projectors, one faithfully flat coefficient extension, one invertible
ambient-plus-correction matrix, its correction projector and unit row scale,
and the row and projector equations on a basis.  The endpoint rows and
projectors are not repeated certificate fields: `FaithfulScalarEdge` fixes
them as scalar extensions.  Lean derives the full equations by basis
extensionality and then derives the intrinsic edge proposition.

## Referee attack points

The proof fails if any one of the following occurs:

- the Iritani degree-zero augmentation identity fails on an ordinary
  completed-source basis or does not define the advertised coefficient-valued
  row after the common Laurent base change;
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
check.  The former three geometric gates are discharged respectively by the
Iritani/CRT native projector argument, Behrend's product formula plus the
C924 block, and the projective-space small quantum presentation.  The
rank-row equation is source-derived on Iritani's exact map; its displayed
augmentation calculation remains a referee check, not a separate imported
theorem.  The principal residual referee risk is therefore source correctness
and normalization of these geometric identifications, not an unfilled logical
interface in the telescope.
