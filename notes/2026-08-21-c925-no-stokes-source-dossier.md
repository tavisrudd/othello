# C925 no-Stokes source dossier

Date: 2026-08-21

## Purpose and status convention

This dossier records the external inputs relevant to the live no-Stokes
proof and the repeatedly proposed fallback bridges.  Each entry separates:

- **SOURCE:** the statement actually present in the cited paper;
- **DERIVED:** a calculation made from that statement;
- **NOT PROVIDED:** a map or compatibility which the source does not state;
- **OPEN/DISPOSITION:** the exact remaining use, or the reason the source is
  not part of the active C925 proof.

The conditional one-edge consumer is
`Comparison.RowedProjectorDecomposition.UnitScaledData.detects_iff`; the
exact-row `Data.detects_iff` is its scale-one specialization.  For one blowup
it needs an intrinsic marked idempotent on each direct-sum factor, block
naturality of those idempotents, and one algebraic row square through ambient
projection.  The row may have a separate coefficient-module codomain.  It
does not consume a loop, an eigenvalue, primary coverage, correction
vanishing, a Gamma lattice, or Stokes data.  The older one-sided
`MarkedWitnessObstruction` architecture is retained only as a fallback.

The finite conditional telescope is
`Comparison.RowedProjectorPath.Path.detectsAt_iff`.  It deliberately requires
one native carrier, row, and projector at every vertex.  Constructing that
family, or proving that all edge occurrences are faithful pullbacks of it, is
the live geometric gate.  Edgewise comparison data alone do not identify two
occurrences of an intermediate variety.

The looser telescope is `RowedProjectorPath.IntrinsicPath.property_iff`.
It needs no shared carrier: each edge may instead prove an equivalence for one
intrinsic vertex-indexed detection predicate.  This replaces global
occurrence descent by a smaller per-edge reflection theorem.  Lean now derives
that reflection in
`RowedProjectorOccurrence.FaithfulScalarEdge.detectsAt_iff`: fix native
endpoint data over (R), extend both along one faithfully flat
(R\to K), and supply a direct-sum comparison satisfying the unit-scaled row
square and block-projector square.  The local rows and endpoint projectors are
definitionally the scalar extensions, so they cannot be replaced by unrelated
edge data.  `FaithfulScalarEdge.ofBasisSquares` reduces the two squares to a
basis check, and `FaithfulScalarEdge.toIntrinsicEdge` supplies the path edge.
`TwoBaseRowedProjectorEdge` removes the common-(R) restriction: the two native
data may use different coefficient rings, each extends faithfully to one edge
ring, and explicit identifications with the semantic endpoint predicates
supply the intrinsic path edge.

There are only two source architectures for that conditional consumer:

1. one general marked source specialized downstream; or
2. a typed chain of local marked maps whose downstream composite is the one
   map consumed by Lean.

The publication-status and exact source-substitution audit is
`2026-08-21-c925-referee-source-substitution-table.md`.  The decisive KKPYY
input, together with Iritani's blowup and Iritani--Koto's projective-bundle
decompositions, is currently cited from preprints or an accepted arXiv
version.  Gu--Yu--Yu supplies a simple-wall corroboration, not a simultaneous
hypothesis of the direct all-center route.  Lean checks their algebraic
consequences after the geometric maps are supplied; it does not reprove the
QDM decomposition theorems.

## Red--fix--green ledger

| Component | Hostile result | Disposition |
|---|---|---|
| one-edge row/projector consumer | no algebraic countermodel under its stated hypotheses | **Green:** Lean theorem and exhaustive finite models |
| reverse traversal in weak factorization | the original path type encoded only blowup-to-base edges | **Fixed/green:** oriented `Step.forward` and `Step.reverse`; Lean aggregate and Haskell forward-then-reverse regression pass |
| repeated-vertex occurrence | equal variety names can carry unrelated rows/projectors over different completions | **Lean-green/source-open:** `TwoBaseRowedProjectorEdge` permits different native endpoint rings and derives the intrinsic edge after faithful extension to one edge ring; geometry must provide the semantic endpoint identifications |
| source-map fusion | the earlier route took Iritani's comparison and Gu--Yu--Yu's row equation from different maps | **Fixed/green for the row:** Proposition 5.1, Theorem 5.2, Proposition 5.4, and the definition of Theorem 5.18's comparison derive the rank-row square on Iritani's own completed map; the marked-projector square remains separate |
| endpoints | rational branch/matrix certificates do not identify the actual product and projective-space QDM marked factors | **Mixed:** both endpoint algebras are Lean-green; the standard geometric QDM presentations remain external |
| all-\(m\) edge scope | low-dimensional C924 centers and a simple-wall theorem do not cover every higher-dimensional AKMW center | **Fixed for comparison and row:** Iritani treats an arbitrary smooth center of codimension at least two; the uniform marked-projector/native-presentation theorem remains open |

Every red item is fail-closed in the routing and test interfaces.  A source
token records an obligation; it is not computational evidence that the
obligation holds.

`Comparison.RowedProjectorOccurrence` now removes two further algebraic
steps.  `OccurrenceEquivalence.detects_iff` derives occurrence-independent
detection from one unit-scaled row/projector equivalence.
`CommonSourceEdgePresentation.toEdge` derives the exact typed edge from two
presentations of one source; both compatibility equations therefore use the
same comparison.  `FaithfulScalarEdge` removes the separate occurrence
equivalence altogether for the intrinsic route: its endpoint rows and
projectors are scalar extensions by construction, and faithful base change
plus the one-edge theorem derives the native predicate equivalence.  Basis
extensionality closes both compatibility squares once their values are known
on a basis.  The open source task is precisely to construct this record from
the QDM maps, not to prove another linear-algebra lemma after it is supplied.

The resulting per-edge source ledger is short and fail-closed, but the
pole-bounded no-Stokes instantiation is ruled out in D10:

1. restrict to an even bulk slice and construct native rowed marked modules
   at the two endpoints on which the row and projector genuinely compose;
2. give faithful algebra maps from both native coefficient objects to one
   edge coefficient object (K), with its topology/graded support stated;
3. construct the completed ambient-plus-correction linear equivalence over
   (K);
4. prove on that same equivalence the unit-scaled row square and the
   block-projector square.

The block-projector square in item 4 is itself a Lean consequence when both
projectors are presented by one polynomial in operators intertwined by the
completed map; `FaithfulScalarEdge.ofBasisRowAndPolynomialProjector` encodes
that route.  Thus the irreducible source checks may be reduced to the completed
map, its basis row equation, its operator square, and the geometric polynomial
presentation.  Faithful scalar extension, intrinsic edge reflection, either
traversal orientation, and finite telescoping are Lean consequences.

`CoprimeFactorProjector.Data` makes the polynomial presentation explicit.
Marked and unmarked factors, Bezout coefficients, and annihilation by their
product construct the idempotent; it is the identity on the marked-factor
kernel, zero on the unmarked-factor kernel, and natural for every operator
intertwiner.  The source must still prove that the C924 predicate selects
those factors.

## D1. Iritani--Koto: projective-bundle Fourier branches

**Source.** Hiroshi Iritani and Yuki Koto, *Quantum cohomology of projective
bundles*, arXiv:2307.03696v4.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2307.03696.txt`, SHA-256
`ef1855c431cd7a91a17666a4125523d60060b7c8a519ddb0d169d1043044b262`.

For the trivial-bundle endpoint we also use Kai Behrend, *The product formula
for Gromov--Witten invariants*, Journal of Algebraic Geometry 8 (1999),
529--541, arXiv:alg-geom/9710014v1.  Its main theorem identifies the complete
system of Gromov--Witten classes of a product with the tensor product of the
two systems.  Its specialization to three-point genus-zero invariants gives
the tensor-product small quantum algebra used below.

### SOURCE

- Theorem 5.1 gives, for a rank-\(r\) projective bundle, a connection- and
  pairing-compatible isomorphism

  \[
    \Phi=\bigoplus_{j=0}^{r-1}\Phi_j:
    \operatorname{QDM}(\mathbf P(V))_{\mathrm{loc}}
    \xrightarrow{\sim}
    \bigoplus_{j=0}^{r-1}\varsigma_j^*\operatorname{QDM}(B)_{\mathrm{ext,loc}}
  \]

  over the formal Laurent base
  \(\mathbf C[z]((q^{-1/r'}))[[Q,\widehat\tau]]\), with
  \(\lambda_j=e^{2\pi i j/r}q^{1/r}\).
- Theorem 5.1(6) gives the leading branch matrix

  \[
   \Phi_j(\phi_i p^k)|_{Q=\widehat\tau=0}
    ={1\over\sqrt r}\lambda_j^{k-(r-1)/2}
      \bigl(\phi_i+O(q^{-1/r})\bigr).
  \]
- The monodromy paragraph immediately before Proposition 5.5 states that a
  rotation of the \(q\)-plane sends \(\lambda_0\) to \(\lambda_j\) and the
  stationary branch \(F_0\) to \(F_j\).
- Proposition 5.8 constructs the branch projection \(\Pi_j\) and proves its
  connection and shift-operator intertwining properties.  It is a formal
  Fourier projection; no sectorial \(z=0\) summation is used.
- Formula (5.10) gives the leading inverse branch column.

### DERIVED

For \(r=3\), apply the ordinary cohomological rank row to the inverse of the
\(k\)-th branch unit in (5.10).  The coefficient of \(p^0\) is

\[
   a_k={1\over\sqrt3}\lambda_k+O(q^{-1/3}).
\]

Consequently the three branch coefficients have a nonzero primitive Fourier
component: the leading vector is proportional to
\((1,\zeta_3,\zeta_3^2)\).  On the geometric branch-label permutation module,
the rank row therefore detects a primitive deck character generically.  This
is a Stokes-free G1 calculation.

This deduction concerns the geometric label permutation after splitting.  It
does not identify that action with naive scalar Galois action on every
coefficient module.

The analogous endpoint test closes the unmarked deck proposal.  For
\(\mathbf P^5=\mathbf P(\mathbf C^6)\), Theorem 5.1 uses \(r=6\) and the
half-Tate root field with \(r'=12\).  Formula (5.10) gives degree-zero
coefficient

\[
  a_k={1\over\sqrt6}\lambda_k^{5/2}.
\]

The subgroup generated by four turns of the \(q\)-plane has order three on
the twelve-fold cover and sends the branch label \(k\) to \(k+4\).  It
multiplies \(a_k\) by

\[
  \exp\!\left(2\pi i\,{4\over6}{5\over2}\right)=\zeta_3^2.
\]

Thus the native six-branch projective-bundle carrier of \(\mathbf P^5\)
itself has primitive \(C_3\)-visible rank.  The proposed G4 statement is
false for this natural endpoint action, not merely unproved.  This does not
exclude a different action independently proved trivial on the target; it
does exclude using the unmarked projective deck permutation as that action.

The distinction is load-bearing.  Let \(L=K(u)\), \(u^3=q\), with deck
generator \(g(u)=\zeta_3u\), and let a rational endpoint have one-dimensional
carrier \(E=K\).  Restriction of scalars of \(L\otimes_K E\cong L\) contains the
primitive eigenlines \(Ku\) and \(Ku^2\).  A coefficient-extraction row can
detect them.  Thus naive scalar extension makes G4 false even though the
geometric endpoint object descends.  The trace row kills those scalar
characters, but replacing the source sheet row by trace can also kill the
primitive source witness.  The same row construction must be used on both
sides.

### NOT PROVIDED

- A \(K\)-valued descended marked row which separates the geometric deck
  action from the semilinear action on \(K(q^{1/3})\).
- A map from this projective-bundle packet to the QDM of a birationally
  equivalent projective space.
- Any multiwall or weak-factorization comparison.
- Endpoint non-detection for the geometric deck action.
- Compatibility with Gu--Yu--Yu's wall variable or a global Novikov charge.

### DISPOSITION

The unmarked native deck carrier is closed by the \(r=6\) endpoint
calculation.  Do not resume it by appealing only to descent or by replacing
the geometric action with scalar Galois action.  Any surviving no-Stokes
route must retain the cubic marked atom, not only a projective branch label.

## D2. Gu--Yu--Yu: simple VGIT Fourier maps

**Source.** Zhaoxing Gu, Song Yu, and Tony Yue Yu, *Quantum cohomology of
variations of GIT quotients and flips*, arXiv:2508.15770v1.  Local extracted
text: `/tmp/persistent/tavis/lit-search/text/arXiv_2508.15770.txt`, SHA-256
`8374add284f70c42011d3ffc01fdcd725766d9d37b7156c7cc9d15e11ea6c54b`.

### SOURCE

- Definition 4.13 defines the discrete Fourier transform from the equivariant
  Givental source to a quotient, subject to definedness.
- Proposition 4.14(1) proves commutation with powers of the extended shift
  operator \(S\).  Proposition 4.14(2)--(5) gives the differential and grading
  compatibilities.
- Theorem 4.15 proves the required definedness/cone statement only for a
  highest or lowest GIT quotient.  The corresponding statement for a general
  quotient is Conjecture 1.11.
- Proposition 4.21 constructs the QDM map for a highest/lowest quotient and
  proves connection compatibility, homogeneity, and its fundamental-solution
  diagram.
- Proposition 5.2 proves that the completed wall source is finite free over
  its completed chamber ring.  Homogeneous equivariant classes whose Kirwan
  images form a cohomology basis give a basis of the completed module, and
  those basis vectors lie in the original nonlocalized source.
- Theorem 5.5, under the paper's three-component simple-wall assumptions and
  \(c_{F_0}<0\), extends the maps to one wall-specific completed base and gives
  the ambient-plus-fixed-component isomorphism.  It preserves the Poincare
  pairing.
- Remark 6.7 explicitly warns that in the balanced case the two chamber cones
  need not fit in one common completion and the Fourier map to the opposite
  chamber need not extend to the chosen completion.

### DERIVED

On the nonlocalized equivariant QDM source, the definition of the discrete
Fourier transform, Proposition 4.21's fundamental-solution diagram,
commutation of \(M_W\) with shifts, and the degree-zero Kirwan identity give
the generatorwise adjoint rank-row formula used in C925.  More explicitly,
for an ordinary equivariant class \(s\),

\[
 \epsilon_XM_X\operatorname{FT}_X(s)
 =\sum_k S^{-k}\epsilon_X\kappa_X(\mathbb S^kM_Ws)
 =\sum_k S^{-k}\epsilon_W(\mathbb S^kM_Ws).
\]

Propositions 2.4 and 2.8 make the last augmentation legal: one may rewrite
\(\mathbb S^kM_Ws=M_W\mathbb S^ks\), and \(\mathbb S^ks\) remains in a
Novikov multiple of the nonlocalized equivariant QDM lattice.  The last
expression is independent of the chosen highest/lowest quotient.

This identity extends to Theorem 5.5's Laurent wall module without a new
continuity theorem.  Proposition 5.2 supplies an \(R\)-basis \(\{s_i\}\) of
that module inside the ordinary source.  Base-change the algebraic rows to
their Givental coefficient modules and check equality on the \(s_i\); finite
\(R\)-linearity proves equality everywhere.  This is the basis-square
principle formalized by
`RowedProjectorDecomposition.Data.ofBasisSquares`.

This is a derivation from the displayed maps, not a separately stated
Gamma-row theorem in the paper.

### NOT PROVIDED

- Identification of \(S\) with the external \(q^{1/3}\) Kummer deck action of
  the projective-bundle source.  \(S\) is an extended shift operator and is not
  a finite-order deck generator by declaration.
- A geometric finite-etale packet or a separation of scalar and geometric
  deck actions.
- A Fourier/QDM map for every chamber of an arbitrary AKMW cobordism.
- One global source whose endpoint maps cover a whole weak-factorization
  chain.
- Composability of different wall-specific formal completions.
- A fixed-phase, formal-HLT, or Stokes realization of the algebraic rank row.
- A theorem identifying the adjoint row with a Gamma row on a \(z=0\)
  solution object.  Neither is consumed by the marked-projector proof.

### DISPOSITION

For the active marked-projector proof, the adjoint row square is closed by the
preceding basis argument.  Gu--Yu--Yu's extended map is not being asserted to
preserve the omitted fundamental-solution diagram on arbitrary completed
series by continuity; only the diagram on an ordinary \(R\)-basis is used.

The older deck-marked/global-source alternatives remain unsupplied for the
reasons below, but they are no longer closure gates.

Shift naturality cannot substitute for deck naturality.  Even in finite
linear algebra, if \(S=1\) on \(K^3\), every linear map commutes with \(S\),
while a generic map does not commute with the cyclic permutation of three
coordinates.  Proposition 4.14(1) therefore supplies G2 only after an
independent theorem identifies the chosen finite deck action with an action
functorially constructed from the shift data.

## D3. Iritani: blowup decomposition

**Source.** Hiroshi Iritani, *Quantum cohomology of blowups*,
arXiv:2307.13555v3.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt`, SHA-256
`f447f3a7324c28871b0a6965bd94f71fd48ffce17062fac4d9c01aef3eed3523`.

### SOURCE

- Section 4.1 defines the discrete Fourier map for either quotient

  \[
    F_Y(f)=\sum_{k\in\mathbf Z}S^k\kappa_Y(S^{-k}f).
  \]

- Proposition 5.1 constructs the QDM map
  \(\operatorname{FT}_Y\), proves the fundamental-solution square
  \(M_Y\operatorname{FT}_Y=F_YM_W\), and proves shift, connection, and
  homogeneity compatibility.
- Theorem 5.2 extends the blowup-side map to an isomorphism on the completed
  equivariant source.  If ordinary equivariant classes have Kirwan images
  forming a cohomology basis, those same classes form a basis of the completed
  source.
- Proposition 5.4 extends the ambient map to that same completed source and
  retains the Proposition 5.1 compatibilities.
- Theorem 5.9 defines the completed direct-sum comparison by

  \[
    \Psi=\bigl(\operatorname{FT}_X\oplus
      \textstyle\bigoplus_j\operatorname{FT}_{Z,j}\bigr)
      \operatorname{FT}_{\widetilde X}^{-1}.
  \]

- Equation (5.11) defines the root denominator

  \[
  s=r-1\quad(r\text{ even}),\qquad
  s=2(r-1)\quad(r\text{ odd}).
  \]
- Theorem 5.18 restricts that construction to a connection- and
  pairing-compatible formal Laurent decomposition of the blowup QDM into one
  ambient factor and \(r-1\) center factors over
  \(\mathbf C[z]((q^{-1/s}))[[Q,\widetilde\tau]]\).
- For codimension \(r=2\), this specializes to \(s=1\) and one outer center
  factor.

### DERIVED

Let \(\epsilon_Y\) be projection to cohomological degree zero and put
\(\rho_Y=\epsilon_YM_Y\).  On the ordinary equivariant source the Kirwan map
is graded and unital, hence \(\epsilon_Y\kappa_Y=\epsilon_W\).  Therefore,
whenever the discrete Fourier sum is defined,

\[
 \rho_Y\operatorname{FT}_Y(s)
 =\epsilon_YF_YM_W(s)
 =\sum_{k\in\mathbf Z}S^k\epsilon_W(S^{-k}M_W(s)),
\]

which is independent of whether \(Y=X\) or \(Y=\widetilde X\).  Theorem
5.2 supplies an ordinary equivariant basis of the completed source, and
Proposition 5.4 puts the ambient map on that same source.  Equality on this
basis extends by linearity after the common Laurent base change; no
coefficientwise continuity assertion on an arbitrary rational Fourier input
is used.  Substituting the definition of \(\Psi\) gives the exact row square

\[
  \rho_{\widetilde X}=\rho_X\operatorname{pr}_X\Psi.
\]

Thus the general smooth-center blowup comparison and its rank-row equation
come from one map in one source.  Gu--Yu--Yu's analogous simple-wall
calculation is a lineage cross-check, not a required splice.

The marked-projector square is a separate consequence of spectral-extension
uniqueness for this same map.  At the generic
point of a native numerical Novikov/bulk domain, let \(\kappa_Y\) denote the
Euler residual endomorphism.  Over an algebraic closure, partition its
generalized eigenspaces by the C924 predicate

\[
  \operatorname{rank}=2,\qquad N\ne0,\qquad
  \delta^\sharp\ne0.
\]

The predicate is invariant under regular block isomorphism and under field
automorphisms: rank is preserved, and nonvanishing of \(N\) and
\(\delta^\sharp\) is preserved.  Hence the union of marked geometric factors
is Galois-stable and descends to the native generic field.  Equivalently,
factor the characteristic polynomial into the product \(f_{\rm mark}\) of
the marked primary factors and the complementary product
\(f_{\rm unmark}\).  They are coprime; Bezout and Cayley--Hamilton give the
idempotent polynomial

\[
 P_{\rm mark}=b(\kappa_Y)f_{\rm unmark}(\kappa_Y),
 \qquad
 af_{\rm mark}+bf_{\rm unmark}=1.
\]

`CoprimeFactorProjector.Data.projector` constructs exactly this idempotent on
the \(z=0\) Euler fibre.  This is not yet the full QDM projector: a regular
\(z\)-dependent connection gauge need not commute with the constant
polynomial \(P_{\rm mark}(\kappa)\) away from \(z=0\).

The full projector is the unique connection-stable spectral extension of
that fibre projector.  Existence and uniqueness are the spectral-splitting
theorem used in C924: recursively, every off-diagonal coefficient is solved
by a Sylvester operator whose leading spectra are disjoint.  Equivalently,
this is Katzarkov--Kontsevich--Pantev--Yu Theorem 4.1 and Remark 4.2, which
extend the generalized Euler eigenspaces to canonical maximal F-bundle
summands.

Iritani's \(\Psi\) commutes with the full quantum connection and is regular
at \(z=0\), so its constant term intertwines the Euler residual
endomorphisms, with the stated power/exponential shifts on the center
factors.  The C924 predicate is invariant under these elementary shifts.
Theorem 5.18(6) gives distinct leading Laurent orders for the
ambient cluster and the \(r-1\) center clusters; after shrinking the generic
Laurent domain their spectra are pairwise disjoint.  Thus no marked and
unmarked factor is merged by a cross-cluster collision.  This is also the
precise content of the maximal-F-bundle
interpretation: Katzarkov--Kontsevich--Pantev--Yu Theorem 4.5 extracts its
canonical blowup isomorphism from Iritani's formal comparison, while their
Theorem 4.1 and Remark 4.2 identify the summands with the canonical
generalized-eigenbundles.  Conjugating the source stable projector by
\(\Psi\) gives a stable target projector with the same \(z=0\) spectral
fibre; canonicity identifies it with the target projector.  Thus it is not a
second comparison map.  On the same \(\Psi\) used for the row equation,

\[
  \Psi P_{\widetilde Y}
   =(P_Y\oplus\textstyle\bigoplus_j P_{Z,j})\Psi.
\]

Iritani's (5.38) and (5.39) are literal injective native-ring maps into the
edge Laurent ring, and Theorem 5.18(7) gives an invertible combined
bulk-coordinate Jacobian.  These facts do not yet instantiate the scalar
edge.  Full big QDM has odd bulk variables, hence a supercommutative
coefficient ring rather than a domain with a fraction field.  Even after
restricting to the even bulk slice, the two pieces of the proposed Boolean
live in opposite \(z\)-completions: the canonical stable projector is
\(z\)-adic, whereas \(\rho=\epsilon M\) is a negative-\(z\) fundamental-
solution row.  A fraction-field slogan does not define their composite.
One must exhibit an even common graded/topological coefficient object on
which both act, prove that its native and edge maps are faithful, and prove
that the infinite coefficient convolutions are defined.  Alternatively, one
may replace the Boolean by a genuinely fibrewise row/projector pair and prove
its row square directly.  `TwoBaseRowedProjectorEdge.Data.toIntrinsicEdge`
then closes the occurrence problem, but it does not construct this missing
common object.

### NOT PROVIDED

- Triviality of the external projective-bundle Kummer action on the center's
  inner spectral/idempotent packet.
- A common external Novikov charge along a weak-factorization path.
- A global map to the final rational endpoint.

### BOUNDARY

The comparison, its algebraic augmentation-row square, and the formal stable
projector square are separately source-derived for a general smooth-center
blowup.  Their joint row-visible Boolean is not defined on the two native
opposite-\(z\) completions.  D10 proves that an algebraic or pole-bounded
common realization cannot supply the cubic witness.  A replacement
fibrewise \(z=0\) row square would be a different source theorem, not a
completion of the present construction.

## D4. AKMW: weak factorization and birational cobordisms

**Source.** Dan Abramovich, Kalle Karu, Kenji Matsuki, and Jaroslaw
Wlodarczyk, *Torification and factorization of birational maps*, JAMS 15
(2002), arXiv:math/9904135v4.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_math_9904135.txt`, SHA-256
`902e525156b0595e2fc452dd7c4f7d7dd1bb02eb0382836bf4a5339c2e952e78`.

### SOURCE

- Theorem 0.1.1 factors a birational map between complete nonsingular
  characteristic-zero varieties into blowups and blowdowns with smooth
  centers, preserving the chosen common open set.  Projective endpoints admit
  projective intermediate varieties.
- Definition 2.1.1 identifies the two endpoints of a birational cobordism as
  the geometric quotients \(B_-/\mathbf G_m\cong X_1\) and
  \(B_+/\mathbf G_m\cong X_2\).
- For a **projective birational morphism** \(X_1\to X_2\), Theorem 2.3.1
  constructs a complete nonsingular variety \(\bar B\) with an effective
  \(\mathbf G_m\)-action, closed invariant copies of both endpoints, and a
  closed equivariant embedding
  \(\bar B\hookrightarrow\mathbf P_{X_2}(\mathcal E)\).  Thus, when \(X_2\)
  is projective, this particular compactified cobordism is projective.
- The proof uses birational cobordisms and torification.  Theorem 0.3.1 gives
  the stated functoriality with respect to absolute isomorphisms.

### NOT PROVIDED

- A smooth projective master space satisfying Gu--Yu--Yu's three-component
  simple-wall hypotheses for the entire factorization.
- A theorem that the two endpoint embeddings in Theorem 2.3.1 are the
  highest/lowest stable-equals-semistable GIT quotients required by
  Gu--Yu--Yu Theorems 4.15 and 5.5.  The compactified cobordism may have many
  fixed components, and a general birational map first passes through weak
  factorization rather than one projective birational morphism in a fixed
  orientation.
- Quantum D-modules, Fourier maps, coefficient completions, rank rows, deck
  actions, or Gamma structures.
- A single quantum source mapping to all factorization vertices.

### OPEN

AKMW supplies the geometric index category for the composed-source route and
a plausible projective \(\mathbf G_m\)-carrier for one projective birational
morphism.  It does not prove that this carrier lies in the quantum/GIT scope
needed to instantiate the global-source architecture, and it does not supply
either marked source architecture by itself.

The global-source possibility is therefore **reopened**, not proved.  Its
first source lemma is that the chosen compactified cobordism's endpoint
quotients are precisely highest/lowest GIT quotients satisfying
stable-equals-semistable, freeness/smoothness, and the weight assumptions used
in Gu--Yu--Yu Section 4.3.  Definition 2.1.1 gives the geometric quotients;
it does not state this complete quantum-GIT compatibility.

## D5. Cai: formal solution ring and formal monodromy

**Source.** Jiaji Cai, *The cubic threefold is symplectically irrational*,
arXiv:2608.01577v1.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2608.01577.txt`, current SHA-256
`10374c7ad8a7909ecbfcf0bbcc33ad715e3ce785fe74ab25aead66bd52d4b815`.

### SOURCE

- The formal solution construction starts from
  \(\mathbf C((z))[[q,t]]\), passes to an algebraic closure of the relevant
  fraction field, and adjoins the formal Turrittin symbols \(z^\rho\),
  \(e^Q\), and \(\log z\) with their multiplicative relations.
- Formal monodromy is defined on that formal solution object.

### NOT PROVIDED

- An embedding of Gu--Yu--Yu's completed large-radius fundamental solution or
  adjoint Fourier row into this exact formal solution ring.
- Equality of the large-radius rank row with a marked formal \(z=0\) covector.
- A deck-marked, Stokes-free endpoint comparison.

### OPEN

This is a bounded fallback ring-embedding test only.  Even a successful ring
map does not remove the row-formalization theorem, so it is not the primary
no-Stokes route.

## D6. Spenko--Van den Bergh: window transitions and GKZ comparison

**Source.** Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
arXiv:2007.04924v3.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2007.04924.txt`, current SHA-256
`20e682fc63b81b35801788aea4ec5d62b9c81d2b7cc4cf839480e7d7343d7d33`.

### SOURCE

- Proposition 12.6 gives the explicit signed window transition, including
  its coefficient-torus factors and character shifts.
- Theorem 6.4 and Proposition 13.4 identify the oriented window/groupoid
  transition with GKZ analytic continuation only under their stated
  nonresonance and negative-cone hypotheses.
- The first paragraph of the proof of Corollary 13.2 gives the one-sided
  no-boundary-quotient consequence from the window-sum identity and its
  survival under specialization.  This is a useful source-side provider for
  can-surjectivity after a separate transverse-quiver identification.

### NOT PROVIDED

- A resonant QDM/Gamma receiver, the actual can/variation packet, or the
  target square used in the older crossed-edge route.
- A geometric external \(C_3\)-deck action on a common marked carrier.
- The G2 selected-action comparison or the G3 rank-row square of the current
  one-sided consumer.

### DISPOSITION

The finite window formula remains useful for pilots and for checking any
proposed algebraic carrier.  The GKZ theorem does not itself specialize to
the resonant marked endpoint and does not close any current G0--G4 gate.

## D7. Yu--Zhang: topological Laplace and block functoriality

**Source.** Tony Yue Yu and Shaowu Zhang, *Topological Laplace Transform and
Decomposition of nc-Hodge Structures*, arXiv:2405.19549v1.  Local extracted
text: `/tmp/persistent/tavis/lit-search/text/arXiv_2405.19549.txt`, current
SHA-256
`fa1feffda5f0a30d7739c569452fc7f0d80cec8828b9ddc7409797717851a493`.

### SOURCE

- Proposition 2.6(4) says that an **already existing** morphism of co-Stokes
  structures is graded on every good interval.
- Theorem 8.13 identifies, in a non-anti-Stokes direction, the asymptotic
  lift of the formal spectral decomposition of an algebraic
  exponential-type connection with the straight-Gabrielov-path
  vanishing-cycle decomposition.

### NOT PROVIDED

- Extension of a block covector to a global morphism, or construction of a
  Gamma/rank morphism.
- Identification of the theorem's quotient vanishing-cycle block with the
  canonical image \(\operatorname{im}(1-T)\) used by the old Malgrange
  consumer.
- A Stokes-free algebraic deck carrier or any current G0--G4 map.

### DISPOSITION

This is a lawful block reader after the actual exponential-type occurrence
and its morphism are supplied.  It cannot create that morphism, and the
current route deliberately avoids using it as a bridge from a large-radius
row to a fixed-phase row.

## D8. Shen--Shoemaker: extremal Gamma asymptotics

**Source.** Yefeng Shen and Mark Shoemaker, *Quantum spectrum and Gamma
structure for standard flips*, arXiv:2502.08762v2.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2502.08762v2.txt`, current
SHA-256
`047096a64d7a5d6d23c5f8458abcdb676071fc1bf910709437c62aa8ae6a2de1`.

### SOURCE

- Theorems 9.9 and 9.14 give oriented asymptotic Gamma classes on a
  one-wall extremal slice with the non-extremal Novikov variables set to
  zero and the extremal variable fixed nonzero.
- With the paper-local discrepancy-one repair, the codimension-two blowup
  case has the required \(\nu=1\) sector calculation.

### NOT PROVIDED

- A common two-edge or pathwise receiver, a full-variable comparison, or an
  inverse/coherence theorem for independently chosen reverse sectors.
- Identification of the extremal Gamma row with the algebraic
  projective-bundle deck row used in G0--G4.
- Faithful transport of the cubic marker through the all-ambient-Novikov-zero
  specialization.

### DISPOSITION

These results remain valid one-wall source data.  They do not enter the
primary no-Stokes architecture because using them to identify opposite or
adjacent sectorial rows reintroduces the missing Stokes/overlap connector.

## D9. Sabbah: explicit Malgrange blocks

**Source.** Claude Sabbah, *A short proof of a theorem of Cotti, Dubrovin and
Guzzetti*, Corollary 1.5 and Proposition 2.2.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/10.4171_PM_2077.txt`, current SHA-256
`96b3cc30a87ae65a165f7a102cd5e7483263cafc4e402ef89e4e26082f52c5ca`.

### SOURCE

- Corollary 1.5 gives the explicit pairwise Malgrange/Stokes blocks in terms
  of the can/variation maps.
- Proposition 2.2 derives full two-sided block vanishing from constancy of
  complete vanishing-cycle local systems in the coalescence setting.

### NOT PROVIDED

- The actual QDM inverse-Laplace receiver, its rank row, or its
  identification with those nearby/vanishing-cycle maps.
- The weaker projected-row vanishing for the C925 occurrence without the
  same missing reader.
- Any algebraic external deck carrier for G0--G4.

### DISPOSITION

Sabbah sharply identifies what the old Stokes consumer would have needed,
but supplies no instance of the current one-sided marked map.  It is retained
as a falsifier and typing guide, not as an active source route.

## D10. Katzarkov--Kontsevich--Pantev--Yu: algebraic QDM atoms

**Source.** Ludmil Katzarkov, Maxim Kontsevich, Tony Pantev, and Tony Yue Yu,
*Birational invariants from Hodge structures and quantum multiplication*,
arXiv:2508.05105v2.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2508.05105.txt`, SHA-256
`d654da17d1468dc7a53168e0fd06b242deeb6ecf71ebcddf93b96d29f60f3ad9`.

### SOURCE

- Theorem 4.1 gives the spectral decomposition of a maximal F-bundle from a
  decomposition of the Euler endomorphism into parts with disjoint spectra.
  Remark 4.2 calls the resulting generalized-eigenbundle decomposition
  canonical in the formal setting.
- Theorem 4.5 gives the canonical blowup isomorphism of maximal F-bundles on
  nonempty connected analytic domains.  Its proof imports Iritani's formal
  blowup decomposition.
- Theorem 4.11 gives the canonical projective-bundle isomorphism with the
  disjoint union of (r) copies of the base F-bundle.
- Definition 5.16 and Proposition 5.17 form atoms by quotienting local
  spectral atoms by the blowup and projective-bundle elementary
  equivalences.  The resulting chemical formula is an ordinary multiset.
- Remark 3.53 explicitly warns that algebraic-closure base change loses
  information.
- Example 6.21 identifies the cubic-threefold zero atom and records that it
  does not split further near the hyperplane point.
- Section 6.4 explains pairing, Serre, and integral enhancements.  It says
  that compatibility of the blowup decomposition with the
  Gamma-corrected integral structure requires additional work and is deferred
  to forthcoming work.

### DERIVED

The qualitative C924 predicate

\[
  \mathsf{marked}(A):\quad
  \operatorname{rank}A=2,\qquad N_A\ne0,\qquad
  \delta_A^\sharp\ne0
\]

is invariant under the regular block isomorphisms used to define the atom
ledger.  On any chosen split F-bundle, the direct sum of all marked summands
therefore has an idempotent projector (P_{\mathrm{mark}}).  Theorem 4.5 and
Theorem 4.11 carry the union of marked summands to the corresponding union on
the ambient and correction factors.  No choice between isomorphic marked
occurrences is needed: the projector marks all of them.

This supplies an algebraic selected operator without a loop or a root.  One
may use the projector directly, or the involution
(T_{\mathrm{tag}}=1-2P_{\mathrm{mark}}).  Projective space has zero marked
projector because its generic quantum cohomology is semisimple with rank-one
spectral factors.  The cubic zero block is marked by the C924 calculation.

### NOT PROVIDED

- A scalar row on the atom decomposition which kills every blowup correction.
- Compatibility of the canonical blowup atom correspondence with a rank or
  Gamma row.
- A categorical or integral enhancement that would imply such compatibility.
- Natural morphisms between atoms; the introduction explicitly says that
  atoms do not form a category with natural morphisms.

### DISPOSITION

The undecorated chemical formula alone does not solve stabilization: a center
may contain the same marked atom.  Its useful contribution is the intrinsic
projector.  The active no-Stokes route combines that projector with the
adjoint row derived directly on Iritani's blowup comparison; it does not
attribute a row theorem to KKPYY.

## Active fusion: the row-visible marked projector

For one blowup comparison, let

\[
  \Psi:V_{\widetilde Y}\xrightarrow{\sim}
       V_Y\oplus C_Z
\]

be Iritani's QDM decomposition after its lawful scalar extension.  Let
(P_{\widetilde Y},P_Y,P_Z) be the projectors onto the union
of C924-marked atoms, and let

\[
  \rho_Y=\epsilon_YM_Y
\]

be the algebraic adjoint Fourier row, valued in the Givental coefficient
completion.  The exact provider is the pair of squares

\[
 \Psi P_{\widetilde Y}=(P_Y\oplus P_Z)\Psi,
 \qquad
 \rho_{\widetilde Y}=\rho_Y\operatorname{pr}_Y\Psi.          \tag{D10.1}
\]

The consumer also accepts
`rho_blowup = u rho_Y pr_Y Psi` for a unit `u`; this isolates Fourier signs,
Tate factors, and localized monomials from the Boolean argument.  A zero or
nonunit factor is not silently accepted.

The row may take values in a larger coefficient module than the QDM lattice,
but its domain must be the same module on which the idempotents act.  This is
the current typing obstruction.  C924 and KKPYY construct the stable
projector on a \(z\)-adic F-bundle, while Iritani's
\(M\in\operatorname{End}(H)[[z^{-1}]][[Q,\tau]]\) defines the row in the
opposite completion.  In general \(\rho P\) is not defined: the coefficient
of one power of \(z\) can be an infinite untopologized sum.  Therefore
(D10.1) is presently a conditional common-object interface, not yet a
source-instantiated no-Stokes object.

From (D10.1), purely linear algebra gives

\[
  \exists x\;(P_{\widetilde Y}x=x\ \&\
                   \rho_{\widetilde Y}(x)\ne0)
  \quad\Longleftrightarrow\quad
  \exists y\;(P_Yy=y\ \&\ \rho_Y(y)\ne0).                  \tag{D10.2}
\]

The correction may contain arbitrarily many marked atoms: the row square
kills its entire contribution.  This is exactly why (D10.2), unlike the
ordinary chemical formula, is potentially stable for every (m).

The row square in (D10.1) is now derived on Iritani's actual comparison in D3.
Theorem 5.2 supplies the completed ordinary basis, Proposition 5.4 extends
the ambient map to the same source, and Theorem 5.9 defines the comparison
from those maps.  No Gu--Yu--Yu/Iritani identification and no continuity
argument on arbitrary rational Fourier inputs remains.

The \(z=0\) projector is derived in D3 from the Galois-stable coprime
factorization, Cayley--Hamilton, and Bezout.  Bare connection compatibility
does not transport that constant polynomial projector through a
\(z\)-dependent gauge.  The full projector square instead follows by
conjugating the source stable projector and using uniqueness of the
connection-stable spectral extension with the prescribed \(z=0\) fibre.
KKPYY Theorem 4.1 and Remark 4.2 supply this canonicity; their Theorem 4.5
identifies the resulting blowup decomposition with the one extracted from
Iritani's formal comparison.

Only the projective-space endpoint is presently source-derived.  The cubic
product endpoint still needs the full-row theorem

\[
  (\epsilon_XM_X)|_{\operatorname{im}P_X}\ne0,
  \tag{D10.3}
\]

where \(P_X\) is the full connection-stable cubic projector.  C924 proves
that the raw degree-zero row is \((0,-7r^2)\) on the marked \(z=0\) Euler
block.  This does not imply (D10.3).  Normalization
\(M=1+O(z^{-1})\) can cancel the raw constant term against positive powers in
the stable projector.  For example, over a Laurent field take

\[
 \epsilon=(1,0),\quad
 P(z)=\begin{pmatrix}1&0\\z&0\end{pmatrix},\quad
 M=I-z^{-1}\begin{pmatrix}0&1\\0&0\end{pmatrix}.
\]

Then \(P^2=P\), \(P(0)=\operatorname{diag}(1,0)\), and
\(M=I+O(z^{-1})\), but \(\epsilon MP=0\).  Behrend's product formula and
`CubicBlockCertificate.rankRow_tensor_detects` transport a genuine cubic
full-row witness to \(X\times\mathbf P^m\); they do not create that witness.
The exact hypergeometric point-period calculation gives a candidate direct
proof of (D10.3), but its identification with this algebraic row/projector
pair and its coefficient object must be stated explicitly before it counts
as the no-Stokes endpoint provider.

For the target, the standard small quantum presentation is

\[
 QH(\mathbf P^{m+3})
   =K[H]/(H^{m+4}-q).
\]

At \(q\ne0\) in characteristic zero, \(H^{m+4}-q\) is separable.  After a
splitting-field extension every Euler spectral factor therefore has rank
one.  The C924 predicate requires a rank-two block with nonzero nilpotent
part, so the marked projector is zero at this point and hence on the generic
F-bundle.  `ProjectiveSpaceQuantumPolynomial.relationPolynomial_separable`
checks the separability statement for every \(m\).

If one common rowed object existed, the algebraic consumer would make
(D10.2) unchanged under one blowup or blowdown.  The center map (5.40) could
remain edge-local because the consumer never identifies correction carriers
at adjacent steps.  `TwoBaseRowedProjectorEdge` and
`RowedProjectorPath.IntrinsicPath.property_iff` kernel-check that conditional
telescope.  They do not supply the common object, and the pole-bounded
proposal for it is excluded below.

The Lean telescope would give the all-\(m\) contradiction if the following
local/source data existed.  The pole-bounded no-Stokes realization of the
middle two items is ruled out below, so this is now a retired provider ledger.

### Retired four-gate ledger

1. **Edge formal projector — source-derived:** the Galois-stable coprime
   factorization and Iritani/KKPYY spectral-extension uniqueness give the
   projector square on the formal F-bundles.  The CRT certificate itself is
   only the \(z=0\) fibre.
2. **Joint occurrence object — unavailable in the pole-bounded no-Stokes
   regime:** a nonzero marked algebraic vector would define a proper
   subconnection of the irreducible cubic hypergeometric module.  The opposite
   \(z\)-tails also have an infinite homogeneous diagonal on the unrestricted
   formal modules.
3. **Cubic-product endpoint — impossible for the proposed pole-free
   replacement:** the same irreducibility obstruction persists after the
   product extension.  A sectorial realization can contain the local formal
   block, but that is the Stokes connector excluded by this route.
4. **Projective endpoint — closed:** the standard small-quantum presentation
   and separability of \(H^{m+4}-q\) give only rank-one generic spectral
   factors, hence zero marked projector.

The first two gates could only be replaced by a direct fibrewise projector and
row square for a different \(z=0\) functional.  Raw degree-zero augmentation
does not satisfy that square at general Novikov parameters.  Existence of
another intrinsic functional is an open design question, not a theorem
asserted by this dossier.

### Rejected normalized-\(z=0\) Jacobian repair

Iritani's equation (5.32) does permit one exact normalization.  Put

\[
 h_Y=\operatorname{FT}_Y(1)|_{z=0}.
\]

After proving that \(h_Y\) is a quantum unit in the relevant adic
completion, left multiplication by \(h_Y^{-1}\) turns the \(z=0\) Fourier
map into the mirror-map differential:

\[
 L_{h_Y}^{-1}\operatorname{FT}_Y|_{z=0}=D\tau_Y.
\]

Because \(L_{h_Y}\) commutes with Euler multiplication, this normalization
is compatible with the already selected CRT factors.  It does **not** prove
the needed row square.  The exact remaining identity, in the bulk/fibre
directions consumed by (5.32), is

\[
 \epsilon_{\widetilde X}D_{\vartheta}\widetilde\tau
 =\epsilon_XD_{\vartheta}\tau.                    \tag{D10.4}
\]

The actual detection consumer needs only the projector-restricted identity

\[
 \epsilon_{\widetilde X}P_{\widetilde X}
 =\epsilon_XD\tau\,P_{\widetilde X},               \tag{D10.5}
\]

up to a unit normalization, together with the projector square.  The Lean
theorem
`ProjectedRowProjectorDecomposition.Data.detects_iff` proves that (D10.5) is
enough and imposes no row condition on unmarked corrections.  Theorem 5.18
gives the initial asymptotics and invertibility of the combined Jacobian, but
not (D10.4) or (D10.5) with the native Novikov and bulk variables retained.
The string equation fixes the identity-coordinate derivative and still
permits a shear
\(\tau^0=\widetilde\tau^0+f(Q,\widetilde\tau^{\ne0})\).

This is a real missing theorem, not a formal consequence of the comparison.
For example, over \(k[[t]]\), take \(D\widetilde\tau=I_2\) and the combined
ambient--centre Jacobian

\[
 J=(D\tau,D\varsigma)=
 \begin{pmatrix}1&t\\1&1\end{pmatrix}.
\]

It is invertible, has the correct initial row, sends the unit to the prescribed
unit after the harmless choice of coordinates, and can be made a unital
algebra isomorphism by transporting the product.  Nevertheless the source
degree-zero row \((1,0)\) differs from the ambient pullback row \((1,t)\).
Thus invertibility, unit preservation, projector naturality, and initial-slice
agreement do not imply (D10.4).  If the chosen projector contains the leaking
direction, the same model also violates (D10.5); the cited source supplies no
geometric theorem excluding that case.

The failure already occurs for the geometric blowup
\(\operatorname{Bl}_{p}\mathbb P^2=F_1\).  Reichelt, Schulze, Sevenheck, and
Walther, *Algebraic aspects of hypergeometric differential equations* (2021),
DOI 10.1007/s13366-020-00560-1, Example 5.1, give multiplication by the first
divisor in the ordered basis \((1,T_1,T_2,[\mathrm{pt}])\):

\[
 (a,b,c,d)\longmapsto(q_1q_2d,\ a-q_1b,\ q_1b,\ c).
\]

If \(q_1q_2\ne0\), a nonzero eigenvector cannot have \(a=0\): the four
coordinate equations then force successively \(d=c=b=0\).
The Lean theorem
`HirzebruchSurfaceAugmentation.no_nonzero_eigenvector_in_degreeZeroKernel`
checks this implication over every field.

For Iritani's blowup variables one has, up to the displayed generator
convention, \(q_1=q_{\mathrm{edge}}\) and
\(q_2=Qq_{\mathrm{edge}}^{-1}\).  After passage to the generic fraction field,
both are nonzero.  Iritani's normalized \(z=0\) direct-sum map identifies the
rank-one point correction with a one-dimensional algebra ideal in
\(QH(F_1)\).  Every nonzero vector in that ideal is an eigenvector for
multiplication by \(T_1\), so its degree-zero coordinate is nonzero.  A full
ambient-only row square would instead annihilate that correction ideal.
Equation (5.32) writes the unnormalized \(z=0\) map as the normalized
Jacobian map composed with multiplication by quantum units; these
multiplications preserve the correction ideal.  Thus both the normalized and
unnormalized **full** row squares are false for this elementary blowup.

The point correction by itself has rank one and is not selected by the
rank-two C924 projector.  Tensoring it with the cubic marked block turns this
into a decisive marked-centre test.  Let \(B\) be the cubic threefold and
consider the smooth codimension-two blowup

\[
 \operatorname{Bl}_{B\times\{p\}}(B\times\mathbb P^2)
 \cong B\times F_1.
\]

Over a generic splitting field, let \(U_B\) be the marked cubic block and
let \(L\) be the rank-one \(F_1\) correction ideal.  The product projector
already used at the source endpoint is \(P_B\otimes\mathrm{id}\), so it fixes
\(U_B\otimes L\).  Equivalently, the scalar outer Euler eigenvalue only shifts
the semisimple part of the cubic block; its rank, nonzero nilpotent part, and
shift-invariant modified-residue discriminant remain marked.  Choose
\(b\in U_B\) with \(\epsilon_B(b)\ne0\) and \(0\ne\ell\in L\).  The \(F_1\)
calculation gives \(\epsilon_{F_1}(\ell)\ne0\), hence

\[
 \epsilon_{B\times F_1}(b\otimes\ell)
 =\epsilon_B(b)\epsilon_{F_1}(\ell)\ne0.
\]

The normalized blowup comparison carries this vector entirely in the centre
factor, so its ambient component is zero.  This contradicts (D10.5).  Lean
checks the two load-bearing linear implications in
`HirzebruchSurfaceAugmentation.tensor_degreeZeroRow_ne_zero_of_eigenvector`
and
`ProjectedRowProjectorDecomposition.Data.false_of_visible_marked_vector_with_zeroAmbientComponent`.
The imported geometric inputs are the product quantum-cohomology formula,
Iritani's identification of the \(F_1\) correction ideal, and the same tensor
marker identification already used for \(B\times\mathbb P^m\).

Consequently (D10.5) is false as a universal smooth-blowup provider.  Denying
that the product marker fixes \(U_B\otimes L\) would also withdraw the tensor
projector used at the cubic-product endpoint; it is not a repair internal to
this route.  The abstract projector-restricted Lean consumer remains correct,
but it has no universal raw-augmentation instantiation.

The same \(F_1\) table gives a positive finite check for the independent
row-free charge route.  Lean proves that multiplication by \(T_1\) satisfies

\[
 \lambda^4+q_1\lambda^3-q_1^2q_2=0.
\]

At \(q_2=0\) this is \(\lambda^3(\lambda+q_1)\), and the derivative at the
exceptional root \(-q_1\) is \(-q_1^3\ne0\).  The geometric descent for this
edge follows directly from Iritani (1.1).  For
\(Z=B\times\{p\}\subset B\times\mathbb P^2\), one has \(r=2\), the normal
bundle is trivial, and therefore \(\rho_Z=c_1(N_{Z/X})=0\).  A center monomial
maps as

\[
 Q_Z^d\longmapsto Q^{\iota_*d}
\]

with no exceptional-root factor and no \(\mathbb P^2\) Novikov degree.  The
single correction QDM is therefore defined before adjoining the named
product cube root.  Complete in the product parameter on the unramified
generic spectral locus.  The correction splitting closure is then a
constant, hence unramified, extension of that trait, while the cube-root
extension is totally ramified.  Standard unramified--totally-ramified
disjointness makes the external deck subgroup fix every correction geometric
idempotent.  The simple-root theorem is an independent finite check of the
same separation in the \(F_1\) multiplication table.  This closes the model
edge, not the common-charge, splitting-closure, and coherent-ledger theorem
along an arbitrary factorization.

### Rejected associated-graded edge repair

Replacing exact row equality by a congruence in
\(u=q_{\mathrm{edge}}^{-1/s}\) does not follow from Theorem 5.18.  Its
comparison ring is the graded Laurent ring
\(\mathbb C((q_{\mathrm{edge}}^{-1/s}))[[Q,\widetilde\tau]]\), where \(u\) is a
unit, so reduction modulo \(u\) is not defined.  The displayed \(O(u)\)
asymptotics occur only after \(Q=\widetilde\tau=0\); the vertex substitutions
can have unbounded negative \(u\)-order as native curve degree grows.

Even after imposing an external DVR lattice, congruence modulo \(u\) only
propagates a primitive row witness.  The sharp one-witness condition is
equality of the first nonzero associated-graded value:

\[
 \nu(r_sx)=a<\infty,
 \qquad
 \nu\bigl(r_sx-c\,r_t\operatorname{pr}F(x)\bigr)>a.
\]

A path would then have to carry the witness, valuation, lattice, and an
integral occurrence map preserving that leading class.  Iritani supplies no
such occurrence lattice.  Finite Novikov--Artin truncation gives only
order-dependent denominator bounds, not a compatible inverse-limit lattice;
generic CRT projectors can also disappear under the truncation.  This is a
useful finite pilot, not an unconditional provider.

Iritani's later note *Notes on the decomposition theorem for blowups*
(arXiv:2604.10028v2, Proposition 3, Proposition 8, and Corollary 11) adds
rational/cyclotomic and Hodge-equivariant descent of the decomposition.  It
does not add (D10.3), a Gamma/rank row, or the integral occurrence lattices
needed by the associated-graded repair.

### Rejected Hodge-equivariant carrier replacement

Proposition 8 and Corollary 11 do not turn Hodge equivariance into a
correction-exclusion theorem.  They say that the mirror maps and decomposition
are equivariant for the universal Hodge group, with the Novikov/root variables
fixed.  Centre summands remain present in that equivariant category.

In particular, Hodge type, Tate grading, and the outer root packet are
insufficient.  Let \(A=H^3(X,\mathbb Q)\), choose a smooth complete-intersection
curve \(C\subset J(X)\), and use
\(A(1)\subset H^1(C,\mathbb Q)\).  For \(D=m+3\), the blowup of
\(C\times\mathbb P^{m+2}\) along \(C\times\{p\}\) has correction

\[
 \bigoplus_{j=1}^{m+1}H^*(C)(-j).
\]

Its \(A\)-part contains
\(A,A(-1),\ldots,A(-m)\), with the same outer \((m+1)\)-branch root
packet as the projective-bundle source.  Thus these coarse equivariant data do
not distinguish the source packet from a legal correction.

This example does **not** show that the curve carries the full inner C924
formal atom \(N\ne0,\delta^\sharp=4/9\).  If that atom is retained, the
remaining theorem is instead the original higher-centre exclusion: no relevant
smooth centre carries the joint Hodge-labelled C924 packet.  For \(m=2\), the
codimension-two outer correction has length one, so a common product
\(\mu_3\)-charge would separate it only after proving that every centre packet
descends individually and is unramified for that same charge.  Proposition 3
describes each edge's own cyclotomic branch monodromy, while Proposition 8
fixes root variables under Hod; neither supplies this cross-occurrence
common-charge theorem or its coherent ledger lift.

### Rejected pole-free-intersection repair

A proposed way to avoid the opposite-\(z\) completions was to replace
(D10.2) by

\[
 D_L(Y):\quad \exists x\in L_Y\cap\operatorname{im}P_Y
             \text{ with }\rho_Y(x)\ne0,
\]

where \(L_Y\) is the effective-Novikov, nonnegative-\(z\) lattice.  This
proposal separates two real questions, but it does not close either one.

First, restriction to \(L_Y\) can make
\(\rho_Y(x)=\epsilon_YM_Yx\) coefficientwise meaningful under an explicit
local-finiteness/homogeneity hypothesis.  It does **not** follow that
Iritani's comparison preserves these native lattices.  The comparison is an
isomorphism only after Laurent extension in the exceptional variable.
Reflection of \(D_L\) therefore needs a new elementwise denominator-clearing
or strict-intersection theorem; an infinite Laurent tail need not be cleared
by one native monomial.  Flat base change preserving a finite kernel does not
by itself identify the two different chamber lattices or their completed
intersections.

Second, the suggested cubic provider is false for the actual cubic QDM.  Its
normalized scalar operator is

\[
 \theta^4-x(\theta+1/3)(\theta+2/3).
\]

The hypergeometric irreducibility criterion applies because the four left
parameters are \(0\) and the right parameters are \(1/3,2/3\), with no
integral cross-difference.  Thus the global rank-four hypergeometric
differential module is irreducible.  The rank-two eigenvalue-zero block is a
local formal/Stokes-graded block at the irregular end, not a rank-one or
rank-two algebraic subconnection.  On the Picard-rank-one Fano homogeneous
lattice, a nonzero homogeneous pole-free vector fixed by the stable projector
would generate a proper algebraic differential submodule, contradicting this
irreducibility.  The C907 Sage certificate already checks the parameter
differences and records
`global_hypergeometric_module_irreducible = true` and
`rank_two_formal_block_can_be_proper_global_subobject = false`.
The tracked artifacts are
`2026-08-10-c907-quantum-monodromy-stabilization.sage.py`
(SHA-256 `72098d03f35c81307510f07fb26df59c6de985690a2d96a5685cd84755c401ea`),
the independent Python replay
`2026-08-10-c907-quantum-monodromy-stabilization-independent.py`
(SHA-256 `3ae5b4f9532f6be0fd2378396c92878c508d5e68d1c3e279944f96b70aa8ec63`),
and their JSON certificate
`2026-08-10-c907-quantum-monodromy-stabilization.json`
(SHA-256 `b419ce52ee9118584ca81c65ca894a3a300cef32a33056b7872fe1b2ee3cf0ee`).

The imported criterion is Nicholas Katz, *Exponential Sums and Differential
Equations*, Annals of Mathematics Studies 124 (1990), Proposition 3.2:
nonresonance \(\alpha_i-\beta_j\notin\mathbf Z\) implies irreducibility of
the hypergeometric connection.  Yichen Qin and Daxin Xu, *Irregular Hodge
filtration of hypergeometric differential equations*, Algebra & Number Theory
19 (2025), Section 2.1.1, restate that proposition in the confluent notation
used here.  The finite certificate checks only the two parameter differences;
it does not replace Katz's theorem.

The apparent Golyshev `D3` factor is a regularized-period/right-determinant
statement (and in several tracked notes concerns other del Pezzo
threefolds).  Regularization is not an inclusion of a first-order
subconnection into the cubic's unregularized rank-four QDM.  It therefore
cannot supply \(D_L(X)\).  A finite polynomial ansatz can be retained as a
negative regression, but it cannot overturn the irreducibility theorem.

Consequently this repair does not move the live frontier.  The Lean theorem
`PoleFreeProjectorObstruction.pullbackFixedSubmodule_invariantUnder` proves
that a horizontal algebraic inclusion and horizontal formal projector make
the pullback fixed vectors connection-stable.  The theorem
`pullbackFixedSubmodule_eq_bot_of_horizontal_irreducible` combines that fact
with irreducibility and properness to prove that the pullback is zero;
`not_detectsOnIncludedModule_of_horizontal_irreducible` gives the row
corollary.  Hypergeometric irreducibility, the algebraic-to-formal
inclusion, and geometric horizontality/properness remain explicit source
inputs.  The guarded aggregate and axiom audit pass.

A different
lattice large enough to meet the local formal block would again require an
edgewise strictness theorem and an independently proved cubic witness; if it
contains sectorial sums, it has reintroduced the Stokes connector under a new
name.  This closes the row-visible-projector route on algebraic and Novikov-
or \(z\)-pole-bounded native domains.  It does not prove that no exotic
nonsectorial analytic domain exists.

The exact certainty split is:

| statement | evidence status |
|---|---|
| a horizontal proper formal summand contains no nonzero included algebraic vector in an irreducible algebraic module | kernel-checked by `pullbackFixedSubmodule_invariantUnder` and `pullbackFixedSubmodule_eq_bot_of_horizontal_irreducible` |
| the cubic operator is irreducible | Katz Proposition 3.2 plus the exact nonresonance certificate above |
| the proposed effective-Novikov or bounded-\(z\)-pole witness would give such an algebraic vector | mathematical homogeneity and horizontal-projector argument recorded above; not separately formalized in the paper-local Lean package |
| every enlargement containing the formal block must be sectorial | not claimed; all standard summation realizations are sectorial, but no exclusion theorem for exotic domains is used |
| no different intrinsic \(z=0\) correction-killing functional exists | not claimed; raw augmentation is only one failed candidate |

### Generic even-bulk persistence

The concern that the cubic rank-two Jordan block might split under a generic
even-bulk perturbation is answered by the formal-germ rigidity theorem
`rankTwoCluster_nilpotent_persists_on_formal_germ`.  In the matrix model of
the compressed QDM connection, it proves that a traceless nilpotent part with
one unit entry and nilpotent closed fibre stays square-zero and nonzero,
provided the compressed multiplication commutes with the leading operator and
the displayed flatness identities hold in every bulk direction.  This is
stronger than checking one entry of one first derivative.  The theorem does
not construct the QDM cluster; the geometric input is that the isolated cubic
cluster supplies those compressed flatness and commutation equations.  Thus
generic splitting is not an additional gate under the C924/m=1 formal-germ
hypotheses.

## The exact one-sided source theorem

The loosest consumer has removed the strongest clauses of the former
Burnside and augmented-direct-sum routes.  It does **not** require fixed
correction idempotents, an equivariant stable-ledger bijection, target
surjectivity, a primary lift, or an inverse comparison.

For a factorization path

\[
  Y_0=X\times\mathbf P^2,\quad Y_1,\ldots,\quad Y_N=\mathbf P^5,
\]

the exact composed-source theorem would provide, over one final coefficient
field containing the selected primitive root,

\[
  (V_i,T_i,r_i),\qquad f_i:V_i\longrightarrow V_{i+1},
\]

with

\[
  f_iT_i=T_{i+1}f_i,
  \qquad
  r_i=c_i\,r_{i+1}f_i
\]

for arbitrary scalars \(c_i\), plus a row-visible selected-primary witness
in \(V_0\) and non-detection by \(r_N\) on the same selected-primary part of
\(V_N\).  `MarkedWitnessObstruction.Data.comp` assembles these arrows.  The
global-source variant replaces the chain by one map from a detected marked
core to \(V_N\).

The theorem is uniform in \(m\): only the endpoint source witness changes.
What remains source-theoretic is not correction classification but the
existence of one **common geometric action** and the rowed maps.  Neither
AKMW nor Gu--Yu--Yu currently supplies the common action, lawful common base,
or the assembled endpoint map.  A family of unrelated edge maps is not a
provider until a common scalar extension and compatible action/root
reindexing make the displayed composition well typed.

### Global-cobordism specialization

The loosest single-source instantiation is now formalized by
`Comparison.GlobalCommonSourceObstruction`.  It asks for one common marked
source \(S\), a primary-covering map

\[
  S\longrightarrow \operatorname{QDM}(X\times\mathbf P^2)
\]

used only to lift the known cubic-side witness, and a one-sided map

\[
  S\longrightarrow \operatorname{QDM}(\mathbf P^5)
\]

used only for selected-action naturality and the scalar row equation.  The
second map is not required to be surjective.  At a Fitting exponent,
surjectivity of the first map is a sufficient implementation of its primary
lift.

AKMW Definition 2.1.1 and Theorem 2.3.1 make this architecture plausible,
and Gu--Yu--Yu Proposition 4.21 constructs maps from one equivariant QDM to
each endpoint **if** the compactified cobordism satisfies their
highest/lowest hypotheses.  Four source sublemmas remain:

1. the AKMW endpoint quotients lie in the exact Gu--Yu--Yu scope;
2. both Fourier maps descend from one rational marked core; their endpoint
   modules may use unrelated faithfully flat branch fields, and the
   cubic-side map is surjective on the selected primary part (ordinary
   surjectivity plus Fitting is enough);
3. one geometric selected action acts on the common source and both endpoint
   modules, and both maps intertwine it;
4. Gu--Yu--Yu's generatorwise adjoint row calculation extends to both maps on
   this carrier with the same common row.

Proposition 4.14(1) does not discharge item 3.  Its extended shift
\(\mathbb S\) is sent by discrete Fourier transform to multiplication by the
coefficient \(S\).  Scalar multiplication by \(S\) on both endpoints cannot
by itself produce G4: after adjoining a primitive root it gives the rational
target the same scalar eigenlabel.  A finite geometric quotient of the shift
data could still work, but its construction and its target action must be
proved separately.

## Current source verdict

1. **The unmarked native-deck route is closed.**  Iritani--Koto's inverse
   branch formula makes the cubic \(r=3\) source visible, but the same formula
   gives primitive \(C_3\)-visible rank on the \(r=6\) projective endpoint.
   This is an endpoint countercalculation, not a missing descent lemma.
2. **The marked-projector consumer survives that falsifier,
   conditionally.**  KKPYY and the C924 calculation provide the formal stable
   projector onto the rank-two nonsemisimple nonzero-\(\delta^\sharp\) union,
   and projective space has zero such projector.  Cubic visibility by the full
   algebraic row on a common legal object remains open.
3. **The two squares (D10.1) are separately source-derived, not jointly
   instantiated.**  Projector naturality follows in the positive-\(z\) formal
   F-bundle from connection naturality plus canonical spectral decomposition.
   The row square follows in the negative-\(z\) completed Fourier source.
   Their common domain and the composite \(\rho P\) are not supplied.
4. **The row is allowed a larger codomain.**  This removes the artificial
   demand that the Givental series be an endomorphism-valued row over the
   original \(\mathbf C[z]\)-ring.  What remains load-bearing is only that the
   row is defined on the same QDM module on which the atom projector acts.
5. **The resulting consumer is uniform in \(m\), but the geometric theorem is
   not landed.**  If the common rowed object and cubic full-row witness are
   supplied, correction atoms are irrelevant and the Lean telescope works
   for every \(m\).  The rejected pole-free-intersection proposal does not
   supply those inputs because the cubic global hypergeometric module is
   irreducible.
6. **The one-sided global-core and composed-map architectures remain valid
   fallbacks.**  They are no longer the first source test.  AKMW/GYY do not
   currently supply their marked endpoint maps as a package.

The live no-Stokes task is no longer construction of a common object for
\(\epsilon M\) and the stable projector.  It is either a different fibrewise
\(z=0\) functional with a source-derived edge square, or an invariant outside
the QDM spectral-marker architecture.  No such functional is presently known;
raw degree-zero augmentation is an exact failed candidate.  Do not resume the
pole-free algebraic-subconnection, fixed-phase, deck, Hodge-height, or Stokes
routes without answering their recorded countermodels.

The finite plumbing regression is
`cubic-threefolds-tasks/c925-rowed-projector-sanity.hs`.  It requires each
source fact above by name before constructing the consumer, exhausts 576
small-field models, and runs fixed-seed properties over arbitrary generated
comparisons and stabilization indices.  Its report is
`2026-08-21-c925-rowed-projector-computational-sanity.md`.  This computation
checks only the assembly; the cited sources and the Lean theorem remain the
mathematical evidence.
