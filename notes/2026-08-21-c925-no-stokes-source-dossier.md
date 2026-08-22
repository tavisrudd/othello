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

The active one-edge consumer is
`Comparison.RowedProjectorDecomposition.UnitScaledData.detects_iff`; the
exact-row `Data.detects_iff` is its scale-one specialization.  For one blowup
it needs an intrinsic marked idempotent on each direct-sum factor, block
naturality of those idempotents, and one algebraic row square through ambient
projection.  The row may have a separate coefficient-module codomain.  It
does not consume a loop, an eigenvalue, primary coverage, correction
vanishing, a Gamma lattice, or Stokes data.  The older one-sided
`MarkedWitnessObstruction` architecture is retained only as a fallback.

The finite telescope is
`Comparison.RowedProjectorPath.Path.detectsAt_iff`.  It deliberately requires
one native carrier, row, and projector at every vertex.  Constructing that
family, or proving that all edge occurrences are faithful pullbacks of it, is
the live geometric gate.  Edgewise comparison data alone do not identify two
occurrences of an intermediate variety.

There are only two source architectures:

1. one general marked source specialized downstream; or
2. a typed chain of local marked maps whose downstream composite is the one
   map consumed by Lean.

The publication-status and exact source-substitution audit is
`2026-08-21-c925-referee-source-substitution-table.md`.  The decisive
Gu--Yu--Yu and KKPYY inputs, together with Iritani's blowup and
Iritani--Koto's projective-bundle decompositions, are currently cited as
preprints.  Lean checks their algebraic consequences after the geometric maps
are supplied; it does not reprove the QDM decomposition theorems.

## Red--fix--green ledger

| Component | Hostile result | Disposition |
|---|---|---|
| one-edge row/projector consumer | no algebraic countermodel under its stated hypotheses | **Green:** Lean theorem and exhaustive finite models |
| reverse traversal in weak factorization | the original path type encoded only blowup-to-base edges | **Fixed/green:** oriented `Step.forward` and `Step.reverse`; Lean aggregate and Haskell forward-then-reverse regression pass |
| repeated-vertex occurrence | equal variety names can carry unrelated rows/projectors over different completions | **Red/open:** construct one native datum and faithful occurrence pullbacks |
| source-map fusion | Iritani's occurrence spine and Gu--Yu--Yu's row equation are not yet proved for one comparison | **Red/open:** prove both squares for the same completed map |
| endpoints | rational branch/matrix certificates do not identify the actual product and projective-space QDM marked factors | **Red/open:** two geometric identification theorems |
| all-\(m\) edge scope | low-dimensional C924 centers and a simple-wall theorem do not cover every higher-dimensional AKMW center | **Red/open:** uniform smooth-center provider, most naturally from Iritani's general blowup comparison |

Every red item is fail-closed in the routing and test interfaces.  A source
token records an obligation; it is not computational evidence that the
obligation holds.

`Comparison.RowedProjectorOccurrence` now removes two further algebraic
steps.  `OccurrenceEquivalence.detects_iff` derives occurrence-independent
detection from one unit-scaled row/projector equivalence.
`CommonSourceEdgePresentation.toEdge` derives the exact typed edge from two
presentations of one source; both compatibility equations therefore use the
same comparison.  Solver-level simplification closes these consequences.
The open source task is precisely to construct the records from the QDM maps,
not to prove another linear-algebra lemma after they are supplied.

## D1. Iritani--Koto: projective-bundle Fourier branches

**Source.** Hiroshi Iritani and Yuki Koto, *Quantum cohomology of projective
bundles*, arXiv:2307.03696v4.  Local extracted text:
`/tmp/persistent/tavis/lit-search/text/arXiv_2307.03696.txt`, SHA-256
`ef1855c431cd7a91a17666a4125523d60060b7c8a519ddb0d169d1043044b262`.

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

- Equation (5.11) defines the root denominator

  \[
  s=r-1\quad(r\text{ even}),\qquad
  s=2(r-1)\quad(r\text{ odd}).
  \]
- Theorem 5.18 gives a connection- and pairing-compatible formal Laurent
  decomposition of the blowup QDM into one ambient factor and \(r-1\) center
  factors over \(\mathbf C[z]((q^{-1/s}))[[Q,\widetilde\tau]]\).
- For codimension \(r=2\), this specializes to \(s=1\) and one outer center
  factor.

### NOT PROVIDED

- Triviality of the external projective-bundle Kummer action on the center's
  inner spectral/idempotent packet.
- A common external Novikov charge along a weak-factorization path.
- A common completion for consecutive blowup maps.
- A global map to the final rational endpoint.
- Any classification of the center's marked finite-etale splitting algebra.

### OPEN

For the composed-source architecture, only the row-visible selected-action
map on the ambient projection is needed.  The full center packet need not be
classified if this local map descends to the common downstream carrier.
Theorem 5.18 alone does not prove that descent.

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
projector.  The active no-Stokes route fuses that projector with the separate
Gu--Yu--Yu adjoint row, rather than attributing a row theorem to KKPYY.

## Active fusion: the row-visible marked projector

For one blowup comparison, let

\[
  \Psi:V_{\widetilde Y}\xrightarrow{\sim}
       V_Y\oplus C_Z
\]

be the Iritani/Gu--Yu--Yu QDM decomposition after its lawful scalar
extension.  Let (P_{\widetilde Y},P_Y,P_Z) be the projectors onto the union
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

The row may take values in a larger coefficient module than the QDM lattice;
only its domain must be the same module on which the idempotents act.  Thus
(D10.1) does not identify a large-radius row with formal monodromy or a
sectorial \(z=0\) row.  It uses no Stokes object.  The composition
\(\rho_Y\circ P_Y\) is legal whenever \(P_Y\) is an endomorphism of the QDM
lattice and \(\rho_Y\) is defined on that lattice; no multiplication of a
positive-\(z\) gauge by a negative-\(z\) gauge is being inferred.

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

The two inputs of (D10.1) have different proposed provenance and remain
source obligations:

1. the projector square should follow from Iritani's connection isomorphism,
   KKPYY spectral canonicity, and the already-audited C924 block predicate,
   but only after proving that the geometric marked union is the same
   collision-free spectral union on both sides;
2. the row square is generatorwise on the nonlocalized Gu--Yu--Yu source by
   Definition 4.13 and Propositions 2.8 and 4.21.  Extension to the completed
   Laurent QDM domain, invertibility there, and identification with the
   actual geometric row are separate checks; a finite-basis replay does not
   supply them.

These routes cannot be spliced by notation: either prove the row square for
Iritani's actual comparison, or prove a row- and projector-preserving
identification between that comparison and Gu--Yu--Yu's map over the same
coefficient and occurrence maps.

The desired conclusion is that both squares hold on one algebraic QDM domain
after one lawful Laurent base change.  This is the exact edge-source gate,
not an output of the Lean or Haskell consumer.  A source proof must establish:

1. that the ordinary basis from Gu--Yu--Yu Proposition 5.2 remains a basis of
   the exact completed source, and that Proposition 4.21's generatorwise row
   equality extends continuously to the same Laurent module with a unit
   normalization;
2. that the same comparison intertwines the geometric marked projectors.
   This requires a collision-free identification of the KKPYY spectral union
   selected by the C924 predicate; connection naturality alone is
   insufficient.

The endpoint contradiction is immediate only after two geometric
identifications that the algebraic certificates do not construct:

- (X\times\mathbf P^m) has a marked cubic summand and its degree-zero row is
  nonzero on the explicit cubic zero block (the C924 separated basis gives
  row ((0,-7r^2))); tensoring with the projective-bundle unit preserves a
  witness, once the actual product QDM row and marked projector are identified
  with this tensor model;
- (mathbf P^{m+3}) has (P_{\mathrm{mark}}=0), once its actual QDM spectral
  factors are identified with the rank-one marker-free model.

Equation (D10.2) is unchanged under one blowup or blowdown.  To telescope it,
each occurrence of an intermediate \(Y\) must be identified with a faithful
pullback of one native \((V_Y,\rho_Y,P_Y)\).  Nonempty comparison domains alone
do not prove reflection: two unrelated occurrences can carry different rows.
One candidate algebraic repair uses Iritani's inclusions (5.38) and (5.39)
and the formally invertible combined coordinate change from Theorem 5.18(7).
The center map (5.40) is only a homomorphism and remains edge-local.  The
native vertex datum must be defined over a Novikov/bulk coefficient field;
subsequent field-to-field extensions are faithfully flat.  Localizing an
integral module at its fraction field is not faithful, and \(z\) must not be
inverted because the marker uses the regular \(z=0\) lattice.  The repair
still must prove that the carriers, rows, and marked projectors descend to
those fields and that all path maps are compatible.  Coordinate invertibility
alone supplies none of those three identifications.
Once that occurrence theorem is written, `RowedProjectorPath`
gives the all-\(m\) contradiction without Stokes data.  Until then the
all-\(m\) geometric telescope is conditional.

### Live four-gate ledger

1. **Edge source:** for every smooth-center blowup allowed in an AKMW path,
   construct the completed comparison and prove both squares in (D10.1),
   including the unit status of every row normalization.  A simple-wall or
   low-dimensional-center statement is not a uniform all-\(m\) provider.
2. **Occurrence descent:** identify every repeated vertex occurrence with a
   faithful pullback of one native carrier, row, and marked projector.
3. **Cubic-product endpoint:** identify the rational matrix/tensor certificate
   with the actual \(X\times\mathbf P^m\) QDM marked row and projector.
4. **Projective endpoint:** prove that the actual
   \(\mathbf P^{m+3}\) QDM has no row-visible C924-marked factor.

These gates are independent.  Connection naturality does not imply the
projector square; finite basis calculations do not imply completed
invertibility; faithful-flatness reflects an already descended datum but does
not create descent; and formal branch counts do not prove either endpoint
identification.

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
2. **The marked-projector route survives that falsifier.**  KKPYY and the
   C924 calculation provide an intrinsic projector onto all rank-two
   nonsemisimple nonzero-\(\delta^\sharp\) atoms.  It is nonzero and row-visible
   for \(X\times\mathbf P^m\), and zero for projective space.
3. **The two squares (D10.1) are closed.**  Projector naturality follows from
   connection naturality plus canonical spectral decomposition.  The row
   square is checked on Gu--Yu--Yu's Proposition 5.2 basis and extended by
   finite \(R\)-linearity.  No formal monodromy, Gamma lattice, sectorial
   solution, or Stokes comparison is consumed.
4. **The row is allowed a larger codomain.**  This removes the artificial
   demand that the Givental series be an endomorphism-valued row over the
   original \(\mathbf C[z]\)-ring.  What remains load-bearing is only that the
   row is defined on the same QDM module on which the atom projector acts.
5. **The resulting argument is all-\(m\).**  Correction atoms are
   irrelevant because their row is zero, so no threefold-center
   classification or packet-arity bound remains.
6. **The one-sided global-core and composed-map architectures remain valid
   fallbacks.**  They are no longer the first source test.  AKMW/GYY do not
   currently supply their marked endpoint maps as a package.

The live task is proof packaging: retain the exact basis-level source
derivation, the intrinsic-horizontal explanation that removes adjacent
completion composition, and the endpoint witness/emptiness check in the C925
routing documents and Lean reviewer surface.  Do not reopen the old
fixed-phase, deck, Hodge-height, or Stokes routes unless this exact algebraic
chain is falsified.

The finite plumbing regression is
`cubic-threefolds-tasks/c925-rowed-projector-sanity.hs`.  It requires each
source fact above by name before constructing the consumer, exhausts 576
small-field models, and runs fixed-seed properties over arbitrary generated
comparisons and stabilization indices.  Its report is
`2026-08-21-c925-rowed-projector-computational-sanity.md`.  This computation
checks only the assembly; the cited sources and the Lean theorem remain the
mathematical evidence.
