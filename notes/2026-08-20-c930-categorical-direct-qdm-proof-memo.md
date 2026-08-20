# C930 categorical direct-QDM proof memo

**Lane:** `cubic-threefolds`

**Phase:** 1 -- proof and narrative design only; no manuscript edits

**Target:** the sole manuscript authority is
`papers/cubic-stabilization-epilogue/`.  The complete 60-page paper has now
been read.  The theorem inventory, page count, table of contents, migration
ledger, and implementation plan below refer only to that paper.  The separate
Gamma-row manuscript is outside C930 and must not be edited.

**Scope:** strictly \(m=1\).  Higher-stabilization material is classified only
for preservation outside this paper; C930 does not investigate, repair, or
extend any \(m=2\) or all-\(m\) provider.

## Verdict

There is a short paper spine.  Choose an additive marker of the local blocks of
a quantum \(D\)-module.  A blowup adds the marker values of its center blocks.
If the marker vanishes on every center that can occur in weak factorization,
the blowup formula telescopes and the marker is birationally invariant.

Both cubic proofs follow this argument.  They differ only in what their marker
remembers and in the comparison results used to prove the blowup formula:

1. an unconditional **atomic direct-QDM marker** which proves
   \(X\times\mathbf P^1\) irrational for every smooth cubic threefold; and
2. the finer **framed primitive-sixth marker** \(\nu _6\), which recovers the
   conditional framed proof with Hypotheses 5.7R and 5.7T as explicit provider
   fields.

The first proof uses Beauville's small quantum algebra, an internal derivation
of the rank-two connection and residue, the Iritani and Iritani--Koto
comparison theorems, weak factorization, and surface classification.  The same
cubic calculation supplies the exponents for the second proof.  The
chemical-formula construction is only a candidate neighboring specialization
until it receives a theorem-level source map; it is not on the paper's proof
path.

This architecture should shorten the quantum half substantially without
displacing the paper's independent cycle-theoretic crown.  The checked
epilogue has 5,305 TeX lines and 60 pages: five pages of introduction, eighteen
pages of six-axis and minimal-class mathematics, fourteen pages of atomic
proof, twenty pages of framed proof, and three pages of synthesis.  The
realistic categorical target is 46--50 pages, with 52 an author-review ceiling
and 44 a stretch target.  The saving comes from replacing the duplicated
fourteen- and twenty-page proof organizations by one compiler, one common
cubic calculation, and two specialization records.  Sections 2--3 are not
page-budget collateral.

## 1. The common theorem

The model case is one blowup \(\operatorname{Bl}_Z Y\to Y\).  Its block
decomposition is the block decomposition of \(Y\), together with finitely many
specialized copies of the center theory.  Once a marker kills those copies, it
has the same value on the two ends of the arrow.  The theorem below says only
that this local equality may be repeated along weak factorization; all of the
work lies in constructing the decomposition and proving center nullity.

Let \(\mathsf{SPVar}_n\) denote smooth projective complex varieties of
dimension at most \(n\), with the geometric operations needed below.  A
**marked block theory with occurrence-indexed comparison providers** consists
of the following data.

1. For every \(Y\), a finite split object
   \[
     \mathcal B(Y)\in\operatorname{Sym}^{\sqcup}(\Pi),
   \]
   where \(\Pi\) is a groupoid, thin groupoid, or indexed groupoid of local
   blocks and \(\operatorname{Sym}^{\sqcup}(\Pi)\) denotes its free symmetric
   monoidal groupoid.
   Put
   \[
     \mathcal L_{\mathcal T}
       =\pi_0\operatorname{Sym}^{\sqcup}(\Pi_{\mathcal T}),
   \]
   the commutative monoid of isomorphism classes of finite split objects, and
   write \(\mathcal B(Y)\) also for its class in \(\mathcal L_{\mathcal T}\).
2. Lawful base change and coordinate reindexing.  If blocks depend on a probe,
   small point, original loop coordinate, or center specialization, those data
   remain indices; they are not erased in prose.
3. A commutative monoid \((A,+,0)\) and a lawful marker fold
   \[
     w:\mathcal L_{\mathcal T}\longrightarrow A,
     \qquad I_w(Y)=w(\mathcal B(Y)).
     \tag{C930.0}
   \]
4. When a specialization needs it, a projective-bundle marker certificate
   \[
     I_w(\mathbf P_Y(V))=rI_w(Y),
     \qquad r=\operatorname{rank}V.
     \tag{C930.1}
   \]
5. For every actual blowup arrow
   \(\beta:\operatorname{Bl}_Z Y\to Y\), where \(Z\) is smooth of
   codimension \(c\ge2\), retain its occurrence family
   \(\omega_j=(\beta,Z,j,\varsigma_j,\chi_j)\).  Here \(\varsigma_j\) is the
   center bulk parameter and \(\chi_j\) is the numerical Novikov
   specialization.  Supply a certified
   **marker-level** comparison
   \[
     I_w(\operatorname{Bl}_Z Y)
       =I_w(Y)+\sum_{j=0}^{c-2}c_w(\omega_j),
     \qquad c_w(\omega_j)=w(\mathcal B(Z;\omega_j)).
     \tag{C930.2}
   \]
   The certificate need not lift to equality in
   \(\operatorname{Sym}^{\sqcup}(\Pi)\).  A stronger block-level comparison may produce
   it after applying \(w\), but marker-level equality is the common interface.

### Theorem A -- occurrence-indexed marker-ledger compiler

Assume the marker-level certificates (C930.2) and
\[
  c_w(\omega)=0
  \quad\text{for every actual center occurrence \(\omega\) with}
  \quad \dim Z_\omega\le n-2.
  \tag{C930.4}
\]
Then \(I_w\) is a birational invariant of smooth projective \(n\)-folds.  If
\(I_w(Y)\ne I_w(\mathbf P^n)\), then \(Y\) is irrational.

A projective weak factorization has nontrivial smooth centers of dimension at
most \(n-2\).  For each arrow and each indexed center occurrence, (C930.4)
kills the correction in (C930.2).  The value is unchanged in either
orientation and therefore telescopes along the factorization.  ∎

The quotient below records the same proof categorically.  It is useful because
both cubic markers and the chemical formula factor through it.

For a marked theory \((\mathcal T,w)\), let \(K_w\) be the congruence on
\(\mathcal L_{\mathcal T}\) generated, for each provider certificate
(C930.2), by the pair
\[
 \mathcal B(\operatorname{Bl}_Z Y)
 \sim
 \mathcal B(Y)+\sum_{j=0}^{c-2}\mathcal B(Z;\omega_j).
 \tag{C930.2a}
\]
The certificate says exactly that \(w\) takes the same value on the two sides,
so \(w\) descends through \(K_w\); equality before quotienting is not assumed.
For dimension \(n\), let \(J_{w,n}\) be generated by
\[
 x+\mathcal B(Z;\omega)\sim x,
 \qquad x\in\mathcal L_{\mathcal T},
 \quad
 \text{for every actual occurrence \(\omega\) with \(\dim Z\le n-2\)}.
 \tag{C930.3}
\]
Set
\[
 \mathcal Q_{\mathcal T,w,n}
 =\mathcal L_{\mathcal T}/(K_w\vee J_{w,n}).
 \tag{C930.3a}
\]
The full occurrence \(\omega\), including \(\varsigma_\omega\) and
\(\chi_\omega\), is part of the relation.  No intrinsic unindexed center
class is substituted for it.

The notation used in both specializations is summarized here.  The last column
records the nearest source convention when there is one.

| symbol | role | convention or translation |
|---|---|---|
| \(\Pi_{\mathcal T}\) | groupoid of local blocks retained by the theory | custom; \(\operatorname{Sym}^{\sqcup}\) is explicitly the free symmetric monoidal groupoid, not a symmetric algebra |
| \(\mathcal L_{\mathcal T}\) | commutative monoid of isomorphism classes of finite split block objects | \(\pi_0\) prevents a category/monoid ambiguity |
| \(\mathcal B(Y)\) | block ledger of \(Y\), viewed in \(\mathcal L_{\mathcal T}\) | custom notation, introduced only after the one-blowup model |
| \(\omega_j=(\beta,Z,j,\varsigma_j,\chi_j)\) | one actual center occurrence in one blowup formula | the arrow and all source indices are retained, as weak-factorization readers expect |
| \(\varsigma_j\) | center bulk parameter | Iritani's \(\varsigma_j(\widetilde\tau)\) |
| \(\chi_j\) | numerical Novikov specialization of the \(j\)-th center summand | distinct from both \(\varsigma_j(\widetilde\tau)\) and the auxiliary divisor-character variables |
| \(w\), \(I_w\) | marker fold and its value on a variety | custom; \(w\) is a monoid map, not a weight grading |
| \(\mathcal Q_{\mathcal T,w,n}\) | ledger quotient imposing comparison and center-null relations | an effective monoid quotient, not a Grothendieck group |

### 1.1 Conventions at the three interfaces

The geometric notation follows birational geometry except where it would
collide with the cubic.  Iritani writes
\(\widetilde X=\operatorname{Bl}_Z X\) for a center of codimension \(r\).
Here \(X\) is reserved for the cubic threefold, so a generic blowup is
\(\operatorname{Bl}_Z Y\to Y\); its codimension is \(c\), while \(r\) remains
available for the rank of a projective bundle.  This translation should be
stated once where the blowup theorem is imported.

For quantum-cohomology readers, retain Iritani's
\(\operatorname{QDM}(Y)\), the connection variable \(z\), the bulk parameter
\(\tau\), and the center maps \(\varsigma_j(\widetilde\tau)\) in the statement
of the comparison theorem.  After 5.7R removes the reconstruction tail at
marker level, the ledger correction is indexed by the separate numerical
specialization \(\chi_j\).  Divisor-character tagging is a faithful-extension
adapter used to prove center nullity; it is not part of \(\chi_j\).  The
occurrence symbol \(\omega_j\) abbreviates the full provider input only after
these data have been defined.

Three Novikov variables otherwise compete for the letter \(q\).  Write
\(q_{\mathrm{exc}}\) for Iritani's exceptional-line variable,
\(q_{\mathrm{fib}}\) for Iritani--Koto's vertical fibre-line variable, and
reserve \(q\) for the cubic small quantum relation.  At the blowup interface,
retain \(Q,\widetilde Q,Q_Z\) for the ambient, blowup, and center Novikov
variables.  Iritani--Koto's convention
\(\mathbf P(V)\) for lines, with
\(p=c_1(\mathcal O_{\mathbf P(V)}(1))\), should be stated when their theorem is
used.

For category-theory readers, the construction stops at the object level:
\(\Pi_{\mathcal T}\) is a groupoid,
\(\operatorname{Sym}^{\sqcup}(\Pi_{\mathcal T})\) is its free symmetric
monoidal groupoid, and \(\mathcal L_{\mathcal T}\) is its monoid of connected
components.  The birational quotient below is a quotient of an object set; no
localization category, universal property, or functor on birational arrows is
claimed.  These conventions make the diagram legible to all three audiences
without enlarging the theorem.

Let
\[
 \operatorname{BirOb}_n^{\mathcal E}
 =\operatorname{Ob}(\mathsf{SPVar}_n^{\mathcal E})/\!\sim_{\mathrm{bir}}
\]
be the object set modulo birational equivalence; no localization category is
asserted.  When the center-null certificates (C930.4) hold, \(w\) also
descends through \(J_{w,n}\).  The descent diagram is then
\[
\begin{CD}
\operatorname{Ob}(\mathsf{SPVar}_n^{\mathcal E})
@>{\mathcal B_{\mathcal T}}>>
\mathcal L_{\mathcal T}
@>{q_{w,n}}>>
\mathcal Q_{\mathcal T,w,n}
@>{\overline w}>> A\\
@V{\mathrm{quot}}VV
@V{q_{w,n}}VV
@| @|\\
\operatorname{BirOb}_n^{\mathcal E}
@>{\overline{\mathcal B}_{\mathcal T,w}}>>
\mathcal Q_{\mathcal T,w,n}
@=\mathcal Q_{\mathcal T,w,n}
@>{\overline w}>> A.
\end{CD}
\tag{C930.I}
\]
Here \(\mathcal E\) is the proof-carrying environment of actual comparison
occurrences.  In the atomic instance its certificates come from stronger
block comparisons.  In the framed instance they are supplied directly after
applying \(\nu_6\).  Diagram (C930.I) is the categorical form of the telescope
in Theorem A.

This is the severe skeleton.  Symmetric-monoidal categories, indexed probes,
Beck--Chevalley, and the universal center quotient justify the three displayed
operations, but the paper should introduce only the amount needed to make
Theorem A type-correct.  Reader/indexed-State/Writer language, optics,
holonomy, universal sufficient shadows, ExactTop, charge filtrations, and
resonant saturation are not used by either \(m=1\) proof and do not belong on
the main route.

Theorem A is elementary once its provider record exists.  The exposition must
not sell the one-paragraph telescope as the difficult theorem.  The content is
the exact categorical interface, the QDM comparison adapters which inhabit it,
the common cubic calculation, and the fact that two differently framed proofs
are literal instances rather than analogous arguments.

## 2. Unconditional atomic direct-QDM specialization

### 2.1 Carrier and marker

Take \(\Pi\) to be the groupoid of generic even QDM spectral blocks and
regular isomorphisms, after lawful algebraic generic base change and invertible
formal coordinate change.  For a rank-two block with centered leading
operator \(N\ne0\), the intrinsic line \(L=\operatorname{im}N\) defines the
elementary modification.  Its regular residue \(R\) has discriminant
\[
  \delta^\sharp=(\operatorname{tr}R)^2-4\det R.
  \tag{C930.5}
\]
Set \(A=\mathbf N\).  The additive fold \(w_{\mathrm{at}}\) assigns one to a
block exactly when
\[
  (\operatorname{rank},[N\ne0],[\delta^\sharp\ne0])=(2,1,1),
  \tag{C930.6}
\]
and assigns zero otherwise; on a split object it sums these block values.  It
retains neither odd rank nor the value of the nonzero discriminant.

This is called the atomic specialization because it follows one indecomposable
rank-two cubic packet through the block ledger.  It is defined and proved
inside the direct-QDM theory.  It must not be identified silently with a
KKPYY Hodge atom.

### 2.2 Comparison providers

Iritani--Koto's projective-bundle comparison gives (C930.1).  Its common
faithful coefficient spine is
\(\mathbf C[q_{\mathrm{fib}}][[Q,\widehat\tau]]\); the proof does not map one
opposite outer completion into the other.  Iritani's blowup comparison gives
(C930.2), with \(q_{\mathrm{exc}}\) and the source variables
\(Q,\widetilde Q,Q_Z\) kept distinct.  Four adapters must remain visible:

1. restrict the invertible bulk Jacobian to the even slice and retain the
   independent unit coordinates which separate summand spectra;
2. use only gauges regular and invertible at \(z=0\), so the modified residue
   changes by conjugacy; and
3. retain \(\varsigma_j(\widetilde\tau)\) until the reconstruction-tail
   comparison has been applied; and
4. repair the noninjective raw center Novikov map by numerical reduction and
   divisor-character tagging.

After faithful scalar extension and the prescribed formal reparametrization,
the atomic center copies determine the same class in the localized indexed
groupoid.  No canonical equality with an unextended intrinsic block is
asserted.

No comparison from one blowup arrow is recursively composed with the
completion of the next.  Every ledger identity is intrinsic; every new center
starts from its own numerical reduced QDM and coefficient spine.

### 2.3 Cubic and rational endpoints

Beauville's relations give the small even multiplication matrix
\[
M_P=
\begin{pmatrix}
0&6q&0&36q^2\\
1&0&15q&0\\
0&1&0&6q\\
0&0&1&0
\end{pmatrix},
\qquad
\chi_{2M_P}(T)=T^2(T^2-108q).
\tag{C930.7}
\]
After adjoining \(\kappa=(3q)^{1/2}\), the even spectral ranks are \(1,1,2\), and
the zero block has nonzero nilpotent leading term.  The internal normalized
gauge calculation gives
\[
  \delta^\sharp=\frac49\ne0.
  \tag{C930.8}
\]
The two scalar blocks emit zero, so
\[
 I_{\mathrm{at}}(X)=1,
 \qquad
 I_{\mathrm{at}}(X\times\mathbf P^1)=2.
 \tag{C930.9}
\]
The second equality is the rank-two trivial projective-bundle case of
(C930.1).

For \(\mathbf P^4\), multiplication by \(5H\) has five distinct eigenvalues
at nonzero Novikov parameter, so every generic block has rank one and
\[
  I_{\mathrm{at}}(\mathbf P^4)=0.
  \tag{C930.10}
\]

### 2.4 Center nullity

The complete dimension-two audit is short.

- A point has one rank-one block.
- \(\mathbf P^1\) has two generic rank-one blocks.  For a curve of genus one,
  \(N=0\); for genus greater than one, the modified residue discriminant is
  zero.
- If a surface has nef canonical class, its centered Euler operator strictly
  raises ordinary degree, hence has one even block of rank at least three.
- The remaining minimal surfaces are \(\mathbf P^2\) and geometrically ruled
  surfaces.  The former has simple generic Euler spectrum; the latter reduces
  by (C930.1) to a curve.
- Point blowups do not change the value, by (C930.2).

Thus (C930.4) holds for \(n=4\).  Theorem A and (C930.9)--(C930.10) prove:

### Theorem B -- unconditional one-step irrationality

For every smooth complex cubic threefold \(X\),
\(X\times\mathbf P^1\) is irrational.

This is the new paper's headline application.

## 3. Finer conditional framed specialization

### 3.1 Different carrier, same compiler

Take the indexed block theory of small even QDMs equipped with their numerical
Novikov spine, designated small point, and original unramified \(z\)-disc.
The blocks are formal orbit factors.  Set \(A=\mathbf N\).  On each block the
fold \(w_{\mathrm{fr}}\) adds the algebraic multiplicities of the two
primitive-sixth eigenvalues, and on a split object it sums the block values:
\[
 \nu_6(Y;\chi)=
 \operatorname{mult}_{\zeta_6}+
 \operatorname{mult}_{\zeta_6^{-1}}.
 \tag{C930.11}
\]
This carrier is not obtained from the atomic carrier by a global forgetful
map.  On the isolated cubic rank-two packet, a richer exponent-framed object
maps to both the qualitative discriminant marker and the framed-sixth marker.
That common refinement is local to the packet; it is not a claim that either
marker determines the other on every QDM.

Let \(\mathsf{CubExpFrame}(X)\) denote the **normalized cubic rank-two
exponent frame** obtained from the Beauville block by the integral regular
gauge used below.  Only for this normalized local object do we use the fork
\[
\begin{CD}
\mathsf{CubExpFrame}(X) @= \mathsf{CubExpFrame}(X)\\
@V{(\rho_+-\rho_-)^2=\delta^\sharp}VV
@VV{\rho\mapsto e^{2\pi i\rho}}V\\
\mathsf{AtomicCubic}_{\delta^\sharp}
@. \mathsf{FramedCubic}_{\nu_6}.
\end{CD}
\tag{C930.II}
\]
The left arrow is the normalized regular-singular comparison lemma; the right
arrow retains the original-disc exponent classes.  Diagram (C930.II) makes no
statement about arbitrary rank-two exponent frames.

### 3.2 Conditional provider record

The two hypotheses are fields of the framed comparison provider, not axioms of
Theorem A.

- **5.7R:** for the residual \(O(u)+s_j\) reconstruction tails which actually
  occur, the intrinsic and reconstructed framed-sixth values agree.  It is not
  arbitrary-bulk invariance.
- **5.7T:** only for comparison-generated specializations of surface centers
  which are neither minimal nor geometrically ruled, intrinsic zero passes to
  the tagged specialized value.

Write \(\nu_6(Z;\omega)\) for the framed marker evaluated on the center theory
at both source indices carried by \(\omega\).  The center-null assertion is
indexed:
\[
 \nu_6(Z;\omega)=0
 \quad(\dim Z\le2,\ \omega\text{ generated by the actual blowup arrow}).
 \tag{C930.12}
\]
Discarding \(\chi_\omega\) would make the proof invalid because a noninjective
center map can merge Novikov classes; discarding \(\varsigma_\omega\) would
erase the reconstruction point at which 5.7R is applied.

With 5.7R, the blowup comparison has the form (C930.2).  Direct specialized
computations handle points, curves, \(\mathbf P^2\), nef-canonical surfaces,
and Hirzebruch surfaces.  Only ruled surfaces over positive-genus curves use
5.7R.  The remaining surface specializations which are neither minimal nor
geometrically ruled consume 5.7T.  This proves (C930.12), so Theorem A makes \(\nu_6\) conditionally
birationally invariant through dimension four.

### 3.3 Endpoint from the internal cubic calculation

The normalized rank-two connection used for (C930.8) has indicial polynomial
\[
  \rho^2+\rho+\frac5{36}=0,
  \qquad \rho=-\frac16,-\frac56.
  \tag{C930.13}
\]
The gauge and its inverse use integral powers of the original \(z\), so the
two exponent classes give \(\zeta_6^{-1}\) and \(\zeta_6\), each once.  The
two scalar blocks are unramified with regular monodromy one.  Therefore
\[
  \nu_6(X)=2,
  \qquad
  \nu_6(X\times\mathbf P^1)=4,
  \qquad
  \nu_6(\mathbf P^4)=0.
  \tag{C930.14}
\]
The product equality uses the unconditional external product formula, not the
conditional projective-bundle formula.  Equations (C930.7)--(C930.8) and the
displayed indicial recursion prove the needed cubic packet internally.

Theorem A now gives:

### Theorem C -- conditional framed specialization

Assume 5.7R and 5.7T only on their stated comparison-generated domains.  Then
the framed marker proves \(X\times\mathbf P^1\) irrational.  This theorem has
the same compiler proof as Theorem B but retains more data and consumes two
additional provider fields.

## 4. The chemical-formula specialization

The chemical-formula carrier first enters the generalized probe-indexed
pipeline
\[
\mathsf{Geometry}
\longrightarrow
\int_{p\in P(-)}\operatorname{Sym}^{\sqcup}(\mathsf{MarkedBlock}_p)
\longrightarrow
\operatorname{Sym}^{\sqcup}(\mathsf{Atom}).
\tag{C930.15}
\]
Its proposed local blocks, generated elementary atom equivalence, chemical
formula, and dimension filtration have the types required by that pipeline.
The atom equivalence is
represented by its presented thin groupoid; no natural morphisms between the
underlying atoms are invented.  A sibling specialization would follow once
its comparison and filtration theorems are mapped at theorem level to
(C930.2)--(C930.3); this memo does not claim that source audit has been made.

Thus the chemical formula is a candidate sibling of the **generalized** marked
compiler, not an instance obtained by substituting directly into the unindexed
QDM block theory.  The compiler organizes certified transport and retention
laws; it does not construct the probe carrier or prove its carrier theorems.
Until the theorem-level source map is supplied, omit this claim from the main
theorem path or state it only as a conditional remark.

## 5. Adversarial proof audit

| arrow or claim | attempted break | verdict / required wording |
|---|---|---|
| Arbitrary markers pass through direct sums | choose a nonadditive predicate | Work in the free block monoid first; require only a monoid fold. Boolean `or` remains lawful. |
| Every provider gives a block-level comparison | choose distinct framed multisets with the same \(\nu_6\)-value | False. The common compiler consumes a certified marker-level ledger; block equality is a stronger optional provider. |
| Summand blocks stay separate | force equal eigenvalues after comparison | Independent unit coordinates make the generic resultant nonzero. Retain those coordinates until after splitting. |
| Coordinates may be renamed harmlessly | observe an uncentered eigenvalue function | Require formal-coordinate pseudonaturality; equality at unrelated coordinate names is false. |
| Intrinsic and asymptotic completions compare directly | send a general \(q\)-adic series to the \(q^{-1}\)-Laurent completion | False. Use the common faithful coefficient spine and compare only algebraic generic data. |
| Even restriction preserves the comparison | allow parity mixing | Require the source comparison to be parity preserving and the even-even Jacobian block invertible. |
| The modified residue is gauge invariant | permit a gauge with negative \(z\)-powers | False. Require a gauge regular and invertible at \(z=0\); then the residue is conjugate. |
| The rank-two line is canonical | let the regular coefficient move \(\operatorname{im}N\) | Pairing horizontality forces preservation of the line. This lemma is load-bearing. |
| The repeated cubic eigenvalue can split on the big base | perturb the determinant transversely | Flatness puts every derivative of \(\det N\) in its own principal ideal; formal uniqueness forces \(\det N=0\), while a unit entry keeps \(N\ne0\). |
| Raw center base change is faithful | collapse two center curve classes | False. Numerical reduction plus independent divisor characters and a finite-fibre Vandermonde argument are required. |
| Comparison maps may be recursively composed | pass through incompatible Laurent arms | Do not compose them. Recompute each intrinsic ledger equality from the new center's coefficient spine. |
| Low-dimensional nullity is automatic from rank | test positive-genus curves and nef-canonical surfaces | Rank alone fails. Curves require the modified residue test; nef-canonical surfaces require degree-raising. Keep the case split. |
| Surface classification is complete | omit nonminimal ruled or rational cases | Minimal classification plus projective bundles and point blowups closes exactly all cases. |
| \(\mathbf P^4\) has no retained block | infer semisimplicity without checking the Euler operator | Check the five distinct eigenvalues of multiplication by \(5H\) at a nonzero small point. |
| Weak factorization kills all corrections | allow a divisor center or disconnected center | Divisor blowup is an isomorphism; disconnected centers are handled componentwise. Nontrivial fourfold centers have dimension at most two. |
| The atomic marker is a KKPYY atom | identify the carriers by terminology | False globally. Call it the atomic direct-QDM marker and state KKPYY as a separate thin-groupoid specialization. |
| The framed theory is a generic-bulk marker | move the designated small point | False. Small point and original \(z\)-disc belong to the object's type. |
| 5.7R proves arbitrary reconstruction invariance | quantify over every tail | False. Restrict it to generated residual tails. |
| 5.7T is needed for every surface | apply it to minimal and ruled centers | False. Direct computations and 5.7R remove those cases; retain 5.7T only for the residual class. |
| Intrinsic center zero implies specialized zero | forget \(\varsigma\) or \(\chi\) | False: \(\varsigma\) records the reconstruction point, while a noninjective Novikov map can merge classes unless \(\chi\) is retained. State center nullity for every actual occurrence. |
| The framed proof needs the conditional projective-bundle formula | use it for \(X\times\mathbf P^1\) | Avoid it. The external product formula is unconditional. |
| A categorical diagram proves its analytic providers | hide comparison existence in a functor arrow | False. Label every provider as imported, proved, or conditional at the arrow where used. |
| Group completion is harmless | send Boolean `or` to a group | False: its group completion is trivial. Keep the effective commutative monoid; Bittner is optional. |
| The \(m=1\) compiler proves \(m=2\) or all \(m\) | retain only constituent multiplicities | False. Extension leakage and rank-row transport remain open. State no higher-stabilization consequence. |
| The current atomic and framed proofs can remain intact beneath a new compiler section | add the compiler but retain both full proof organizations | This defeats the refounding.  The compiler must replace their duplicated comparison, transport, and weak-factorization layers, while each specialization retains only its genuinely distinct carrier calculations and hypotheses. |

The failed implications have concrete hostile witnesses, not merely missing
proofs.

- The framed multisets \([\zeta_6]+[1]\) and
  \([\zeta_6]+[-1]\) are unequal but have the same \(\nu_6\)-value.  A
  marker-level provider cannot be promoted to block equality.
- An uncentered Euler-eigenvalue observer changes under an independent unit
  translation, so two-law marker invariance without coordinate
  pseudonaturality is false.
- A general power series in the intrinsic \(q\)-adic completion has no image
  in the opposite \(q^{-1}\)-Laurent completion, so the naive coefficient map
  does not exist.
- Two numerical center classes can have the same ambient pushforward; raw
  center base change is therefore nonfaithful before divisor tagging.
- The incomplete-Gamma rank-two connection has the same formal monodromy,
  pairing, and integral doubling while a Stokes shear changes the rank-visible
  row.  Those structures cannot replace a sectorial provider.
- A delta module at the common Fourier origin disappears after either partial
  localization but transforms back to a constant full-support module.  Raw
  localized support points in the wrong direction for the proposed row law.
- Boolean `or` has trivial group completion, so a Grothendieck-group backend
  can erase the exact obstruction being compiled.
No attack above breaks Theorems A or B after the stated repairs.  Theorem C
remains conditional exactly at 5.7R and the residual part of 5.7T.  The all-
\(m\) Gamma point-row programme is outside C930 and is not a corollary of this
memo.

## 6. Independent proof-order audit

A reader can reconstruct the unconditional proof in the following order.

1. Define generic even QDM blocks and lawful marker folds.
2. Prove the rank-two modification and regular-gauge invariance.
3. Import the two QDM decomposition theorems and prove the coefficient,
   separation, parity, and center-tagging adapters.
4. Deduce the projective-bundle and blowup ledgers.
5. Prove Theorem A from weak factorization.
6. Derive the cubic matrix from Beauville, persist the rank-two block, and
   compute \(\delta^\sharp\ne0\).
7. Prove center nullity in dimensions zero, one, and two.
8. Compute the product and \(\mathbf P^4\) endpoints and apply Theorem A.

There is no circularity: ruled and nonminimal surfaces use the local ledger
theorems, not birational invariance; birational invariance is invoked only
after the center audit is complete.

The framed proof reuses steps 1, 3--5 and replaces steps 2, 6--8 by the
framed-small carrier, its two provider fields, the indexed center audit, and
the internal indicial calculation.  This is a specialization record, not a
second proof spine.

## 7. Narrative-order audit and proposed table of contents

The opening must preserve the actual paper's synthesis.  It should state the
one-step irrationality theorem and the separation theorem on the
\(A_5\)-pencil before either technical language, then explain the two
independent mechanisms: integral divisor products prove universal
\(CH_0\)-triviality, while a center-null QDM marker proves irrationality after
one stabilization.  The categorical theorem is the organizing principle of
the quantum half, not the organizing principle of the six-axis half.

Proposed structure:

1. **Introduction and results** (3--4 pages): one-step irrationality,
   separation on the \(A_5\)-pencil, the marker theorem, and the conditional
   framed refinement; one paragraph showing how the cycle and quantum halves
   meet.
2. **The six-axis polarization and exotic packet** (7--8 pages): retain the
   present Section 2 proof hierarchy.
3. **Integral divisor products and the primitive minimal class** (9--10
   pages): retain the graph-saturation theorem, six-axis application, and
   exact separation from the neighboring loci.
4. **The categorical QDM ledger** (4--5 pages): the one-blowup model, compact
   notation table, Theorem A, its quotient square, coefficient spines, and
   comparison adapters.
5. **The cubic marker** (6--8 pages): the common small-even block calculation,
   elementary modification, residue discriminant, direct low-dimensional
   nullity, and unconditional one-step irrationality.
6. **The framed-sixth specialization** (10--12 pages): original-disc carrier,
   exact low-degree shifts, 5.7R/5.7T, specialized center audit including the
   Hirzebruch quartic, the normalized cubic fork, and the conditional theorem.
7. **The separation theorem** (2--3 pages): combine the unchanged cycle
   theorem with the new unconditional marker proof and state the exact framed
   boundary.

This gives a 41--50 page component estimate before rendered-float effects.
Editing should target 46--50 pages, treat 52 as the review ceiling, and regard
44 as a stretch target rather than a gate.

## 8. Migration and deletion ledger

The epilogue remains one paper.  The cycle side is already a coherent proof;
the quantum side is the refounding surface.

| current component | action in categorical paper | reason |
|---|---|---|
| Main file and abstract | rewrite | Preserve all three crowns: one-step irrationality, six-axis universal \(CH_0\)-triviality, and their separation.  Present the categorical marker as the mechanism of the quantum crown. |
| `01-introduction.tex` (5 pages) | rewrite to 3--4 pages | State the separation synthesis first; replace the Hodge-atom roadmap by the direct marker mechanism; keep the framed result visibly conditional and subordinate. |
| `02-envelope.tex` (8 pages) | retain, light Milnor pass only | The polarization, principal gluing packet, and no-elliptic-product theorem are an independent load-bearing crown. |
| `03-minimal-class.tex` (10 pages) | retain proof; compress local orientation where free | Graph saturation, the six-axis minimal class, and the exact Eckardt/separation analysis prove the cycle half.  None is replaced by the QDM compiler. |
| `04-atomic-one-step.tex` (14 pages) | refound as the direct atomic specialization | Keep the common cubic block, elementary modification, pairing/flatness rigidity, residue calculation, and low-dimensional exclusion.  Replace the Hodge-fixed base, global atom construction, chemical-formula globalization, and atom non-rationality criterion by Theorem A and direct QDM center nullity. |
| `05-framed-monodromy.tex` (20 pages) | refound as the finer specialization of the same compiler | Keep the framed carrier, exact string/divisor shifts, formal-germ theorem, 5.7R/5.7T, specialized center audit, Hirzebruch quartic, product formula, and cubic exponents.  Remove repeated compiler, weak-factorization, and cubic setup already established in Sections 4--5. |
| `06-synthesis.tex` (3 pages) | rewrite locally | Replace the atom language by the direct marker while keeping the cycle/quantum independence and the exact higher-stabilization boundary. |
| Formal annotations and registries | migrate statement by statement after prose stabilizes | Stable labels and source/evidence edges must follow the new theorem graph; no bulk relabeling before the statements settle. |
| Bibliography | prune only after the new source map is complete | Retain every source used by the cycle side and direct QDM adapters; remove a citation only when no surviving claim imports it. |
| C925 Modules 0--13 | compress into the compiler and atomic sections | These contain the load-bearing direct proof and adapters. |
| C925 Module 22 | compress into the framed section | It types the exact conditional specialization already present in Section 5. |
| C925 higher-stabilization modules | omit | They are not prerequisites and C930 is strictly \(m=1\). |

The pre-edit authority is frozen by source commit and the tracked 60-page PDF
in `notes/2026-08-20-c930-epilogue-baseline.md`.  No file in the separate
Gamma-row manuscript is part of this migration.

## 9. Mathematical inputs and conditional boundary

### Load-bearing imported mathematics

- Beauville's complete-intersection quantum product formulas, main theorem
  and (2.1)--(2.3);
- Iritani's blowup QDM comparison, Theorem 5.18 together with Remarks 2.3 and
  5.6 and equations (5.15), (5.27)--(5.30), and (5.38)--(5.43), in the exact
  regular coefficient scope used;
- Iritani--Koto's projective-bundle QDM comparison, Theorem 5.1 together with
  Remark 1.2, equations (1.1), (5.2), and (5.11)--(5.12), Remarks 5.2--5.3,
  and Proposition 5.6, in the corrected common coefficient spine;
- Behrend's product formula for genus-zero Gromov--Witten invariants;
- projective weak factorization; and
- the standard classification of minimal smooth projective surfaces with
  non-nef canonical class.

### Proved in the packet and to be proved in the paper

- lawful marker and compiler algebra;
- regular-gauge invariance of the modified residue;
- coefficient-spine, parity, separation, and center-tagging adapters;
- Beauville-to-cubic matrix reconstruction, persistence, normalized residue,
  and indicial roots;
- low-dimensional center nullity; and
- both specialization maps into Theorem A.

### Conditional only

- 5.7R on generated residual reconstruction tails; and
- 5.7T on comparison-generated specializations of surfaces which are neither
  minimal nor geometrically ruled.

## 10. Validation of the memo

Three independent exact replays and one source compilation passed against the
current C925/C924 artifacts on 2026-08-20:

1. the ninety-six-check categorical law model matched
   `c925-categorical-law-check.json` exactly;
2. the typed Haskell path/effect model matched
   `c925-sparse-shadow-path-toy-output.txt` exactly; and
3. the rational SymPy cubic calculation matched
   `c924-finite-cubic-check.json` exactly under SymPy 1.14.0.
4. the occurrence-indexed descent square and normalized cubic fork compiled
   together under `amscd` with `pdflatex` from TeX Live 2025.

The notation audit used Iritani's *Quantum cohomology of blowups*,
arXiv:2307.13555v3 (cached SHA-256
`c16f56b2...a934b`), and Iritani--Koto's *Quantum cohomology of projective
bundles*, arXiv:2307.03696v4 (cached SHA-256 `5139f8e0...57624`).  It also
checked the notation already used by the epilogue.  The audit separates
Iritani's center bulk parameter \(\varsigma_j\) from the epilogue's numerical
Novikov specialization \(\chi_j\), reserves \(X\) for the cubic, and makes the
free symmetric-monoidal and object-quotient conventions explicit.

The completed claim-level source ledger is
`notes/2026-08-20-c930-qdm-literature-audit.md`.  It records the exact latest
source versions, cached PDF hashes, theorem/equation locators, point-of-use
citation requirements, and the distinction between imported results and
author-proved adapters.  Its QDM verdict is PASS for the current \(m=1\)
theorem graph.

These replays certify the finite algebra advertised by their artifacts.  They
do not certify the imported QDM comparison theorems or the conditional 5.7R
and 5.7T providers.  The proof-order audit above separately traces those
trust boundaries.

The complete epilogue source was read without manuscript modification: the
main file, all six included sections, the formal-annotation macros, and the
bibliography.  The main file and sections contain 5,305 lines.  The checked
job-name log records 60 pages, with section starts at pages 1, 6, 14, 24, 38,
and 58.  The tracked PDF hash and source commit are recorded in
`notes/2026-08-20-c930-epilogue-baseline.md`.

## 11. Phase-2 implementation plan

Phase 2 is authorized for the epilogue authority only.

1. The 60-page PDF and source identity are frozen.
2. Rewrite the abstract, theorem statements, and section openings first; cold-
   read that skeleton while Sections 2--3 remain connected.
3. Introduce Theorem A and the descent square before the technical QDM
   adapters, then make the atomic and framed theorem statements explicit
   specialization records.
4. Refound Sections 4--5 from the bounded C925 modules and retained epilogue
   proofs.  Preserve every load-bearing calculation named in the migration
   ledger.
5. Rewrite the synthesis and introduction against the new theorem graph.
6. After prose stabilizes, read and follow the formal-annotation conventions,
   then migrate stable labels, claims, imports, and evidence rows.
7. Replay the finite cubic calculation and categorical law checks; build from
   the paper's guarded Makefile; inspect pages, references, warnings, tables,
   and diagrams.
8. Run separate mathematical, source-verification, cycle/QDM coherence, and
   adjacent-reader cold reads.
9. Synchronize a standalone mirror only after the export conventions have
   been loaded and all authority gates pass.

## 12. `ej` + `tt` closeout and mystery ledger

The post-implementation closeout confirms five cheap upgrades.

1. The atomic direct-QDM and framed-sixth arguments share not only the final
   weak-factorization paragraph but also the coefficient, comparison, and
   center-localization interfaces.  This is enough common material to shorten
   the paper rather than merely unify its notation.
2. The internal indicial calculation is the exact bridge between the two
   markers on the cubic packet: its squared exponent difference is
   \(\delta^\sharp=4/9\), while its individual exponent classes give
   \(\zeta_6^{\pm1}\).  One calculation feeds both specializations.
3. The cycle half needs no categorical rewrite.  Keeping its eighteen-page
   proof intact makes the paper shorter by concentrating every structural edit
   on the thirty-four-page quantum pair.
4. Theorem A can be stated and proved immediately after the provider record;
   the categorical quotient then explains the proof instead of delaying it.
5. The notation audit separates the reconstruction parameter \(\varsigma_j\),
   the numerical specialization \(\chi_j\), and the auxiliary character
   variables.  It also gives distinct names to the three Novikov variables
   otherwise called \(q\).  These distinctions remove genuine typing traps.

### Mystery ledger

| feature | status | exact gap or owner |
|---|---|---|
| Does the one cubic calculation feed both markers? | Settled | Beauville's matrix plus the normalized-gauge and indicial recursion gives both \(\delta^\sharp\) and \(\zeta_6^{\pm1}\). |
| Will the categorical layer look decorative? | Settled in the manuscript | The paper keeps only the indexed block groupoid, free symmetric monoid, provider record, and center quotient.  Each is used by both quantum specializations, and the cycle half does not pretend to depend on it. |
| Can source notation be compressed into one center index? | Settled negatively | The occurrence retains both \(\varsigma_j\) and \(\chi_j\); auxiliary divisor-character variables remain a proof adapter rather than a ledger index. |
| Does the common spine remove 5.7R or 5.7T? | No | The compiler locates them but does not prove them. They remain the exact provider fields of Theorem C. |
| Does C930 take on higher stabilization? | No | Its mathematical and manuscript scope ends at \(m=1\); higher-stabilization material is only preserved outside the proposed paper. |
| Can the two crowns read as one paper rather than juxtaposed papers? | Settled for the referee gate | The rewritten introduction and synthesis make the separation theorem the causal meeting point, and the hostile manuscript pass found no coherence defect. |
| Can the final paper reach 46--50 pages without hiding a provider or trimming the cycle proof? | Settled | The integrated warning-free manuscript is 50 pages, down from the frozen 60-page baseline, with the cycle core retained. |
| Should the direct-QDM section move ahead of the cycle core? | Author decision, not a proof gap | The categorical proof currently begins on page 23.  Moving it after the introduction could foreground the headline mechanism but would change the paper's narrative architecture. |

No further mathematical mystery blocks the implemented (m=1) proof spine.
The remaining open items are either explicitly conditional mathematics owned
by C925/C907 or the author's narrative and submission decisions.
