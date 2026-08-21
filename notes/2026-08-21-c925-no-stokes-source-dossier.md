# C925 no-Stokes source dossier

Date: 2026-08-21

## Purpose and status convention

This dossier records the external inputs relevant to the live deck-marked
proof and the repeatedly proposed fallback bridges.  Each entry separates:

- **SOURCE:** the statement actually present in the cited paper;
- **DERIVED:** a calculation made from that statement;
- **NOT PROVIDED:** a map or compatibility which the source does not state;
- **OPEN/DISPOSITION:** the exact remaining use, or the reason the source is
  not part of the active C925 proof.

The consumer is
`Comparison.MarkedWitnessObstruction.Data.endpoint_detects_of_source_detects`.
For one selected action it needs a detected marked source, one same-ring map
to the projective endpoint, selected-action naturality, one scalar row square,
and endpoint row non-detection.  It does not consume surjectivity, primary
coverage, correction control, inverse maps, or Stokes data.

There are only two source architectures:

1. one general marked source specialized downstream; or
2. a typed chain of local marked maps whose downstream composite is the one
   map consumed by Lean.

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

### OPEN

Construct the finite geometric carrier on which the branch permutation and
the row above coexist over one invariant coefficient field, without importing
the scalar regular representation into the rational endpoint.

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
- Theorem 5.5, under the paper's three-component simple-wall assumptions and
  \(c_{F_0}<0\), extends the maps to one wall-specific completed base and gives
  the ambient-plus-fixed-component isomorphism.  It preserves the Poincare
  pairing.
- Remark 6.7 explicitly warns that in the balanced case the two chamber cones
  need not fit in one common completion and the Fourier map to the opposite
  chamber need not extend to the chosen completion.

### DERIVED

On the nonlocalized completed equivariant QDM source, the definition of the
discrete Fourier transform, Proposition 4.21's fundamental-solution diagram,
commutation of \(M_W\) with shifts, and the degree-zero Kirwan identity give
the generatorwise adjoint rank-row formula used in C925.  This is a derivation
from the displayed maps, not a separately stated Gamma-row theorem in the
paper.

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
  solution object.

### OPEN

Either construct a single global deck-marked source map using a theorem beyond
the scope of Gu--Yu--Yu, or descend the finite row-visible part of every local
map to one common downstream ring so the maps can be composed by
`MarkedWitnessObstruction.Data.comp`.

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

1. **G1 has a credible source-level algebraic calculation:** Iritani--Koto's
   inverse branch asymptotics make the rank row visibly nontrivial in a
   primitive geometric deck character for \(r=3\).
2. **G4 is not yet sourced for that same action:** target descent alone is
   insufficient because scalar extension creates spurious deck characters.
3. **The algebraic row square is the least open part of G3:** once both
   highest/lowest maps exist on the stated nonlocalized source, the adjoint
   calculation derives the same source rank row generatorwise.  Extension to
   the chosen rational marked core is still a source check.
4. **G2 is not supplied for the selected geometric action:** Gu--Yu--Yu
   provide shift naturality, while AKMW provides no quantum action.  Neither
   paper constructs the deck-marked endpoint map or a legally composable
   same-action chain.
5. **The AKMW global-source variant is live but conditional:** it removes
   intermediate-wall composition if the four sublemmas above hold.  The
   existing global shift is not the missing geometric action.
6. **No Stokes theorem is needed if these algebraic gaps are solved.**
   No existing cited source solves them as a package.

The next source test is therefore finite and falsifiable: construct the
geometric rank-row carrier for the \(r=3\) branch packet and the rational
endpoint over one invariant core with faithfully flat branch fields, then ask
whether the Gu--Yu--Yu map
descends to it and intertwines the geometric deck generator.  If it does not,
the no-Stokes deck route stops there; do not replace the geometric action by
the scalar Galois regular representation.
