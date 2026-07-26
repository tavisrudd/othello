# C649 — Full-Weyl rigidity for general stabilizer AME states

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Updated:** 2026-07-26

**Status:** theorem, proof repairs, and literature positioning adopted in
the manuscript; the arbitrary-additive support, marginal, covariance,
axis-recovery, and LU-to-LC chain is kernel checked above one explicit
stabilizer-projector realization field; aggregate replay is queued

## Result

The MDS/CSS hypothesis is not needed for the LU-to-LC rigidity mechanism.
The correct general statement is:

> Let \(q=p^e\), let \(m\geq2\), and let
> \(\lvert\psi\rangle,\lvert\phi\rangle\) be stabilizer
> \(\operatorname{AME}(2m,q)\) states for the same \(q\)-dimensional
> Pauli/Weyl error basis.  If, after a party permutation,
> \[
>   (U_1\otimes\cdots\otimes U_{2m})\lvert\psi\rangle
>      =e^{i\theta}\lvert\phi\rangle ,
> \]
> then every \(U_i\) normalizes the local projective Pauli/Weyl group.
> Hence every such LU equivalence is LC.

This includes arbitrary additive prime-power stabilizers.  The stabilizer
label space need not be \(\mathbb F_q\)-linear, the stabilizer phases need
not be equal, and the state need not arise from a CSS or classical MDS
construction.

The boundary \(m\geq2\) is sharp for this proof and conclusion about every
intertwiner factor.  At \(m=1\), a Bell pair has continuous non-Clifford
product-unitary automorphisms \(U\otimes\overline U\), and a two-factor
diagonal tensor does not intrinsically determine its axes.

## The support theorem

Let \(\mathcal S_\psi\) be the stabilizer group of a pure
\(\operatorname{AME}(2m,q)\) stabilizer state, and pass to its projective
Pauli-label group \(L\).  Then
\[
  |L|=q^{2m}.
\]
For a party set \(A\) of size \(m+1\), let
\[
  L(A)=\{\ell\in L:\operatorname{supp}(\ell)\subseteq A\}.
\]
Then:

1. \(|L(A)|=q^2\);
2. every nonidentity element of \(L(A)\) has support exactly \(A\); and
3. for every \(i\in A\), coordinate projection
   \[
      \operatorname{pr}_i:L(A)\longrightarrow P_i
   \]
   is a bijection onto the \(q^2\)-element local projective Pauli-label
   group \(P_i\).

### Proof by cardinality squeeze

Project \(L\) to the Pauli labels on the omitted \(m-1\) parties.  The
image has at most \(q^{2(m-1)}\) elements, so its kernel \(L(A)\) has
at least
\[
  q^{2m}/q^{2(m-1)}=q^2
\]
elements.

Fix \(i\in A\).  The kernel of
\(\operatorname{pr}_i:L(A)\to P_i\) consists of stabilizer labels
supported on \(A\setminus\{i\}\), a set of \(m\) parties.  The AME
condition makes every \(m\)-party reduction maximally mixed.  Orthogonality
of the Pauli basis therefore forbids any nonidentity stabilizer on at most
\(m\) parties.  Thus \(\operatorname{pr}_i\) is injective.  Since
\(|P_i|=q^2\), this gives \(|L(A)|\leq q^2\), proving equality and
bijectivity.

Equivalently, over the prime field the label Lagrangian has dimension
\(2me\).  Restriction to the omitted parties has a kernel of dimension at
least \(2e\), while injection to one retained \(2e\)-dimensional local
label space gives the reverse inequality.  This is the dimension squeeze
formalized in `StabilizerAMESupport.lean`.

## Full-Weyl marginal

The stabilizer projector expansion and partial trace give
\[
 \rho_A
   =q^{-|A|}
      \sum_{\ell\in L(A)}\widetilde W_\ell ,
\]
where \(\widetilde W_\ell\) is the chosen stabilizer lift of the projective
Weyl label \(\ell\).  Relative to a fixed Weyl convention it is a nonzero
scalar multiple of the corresponding product Weyl operator.  Stabilizer
phases therefore change only the nonzero diagonal coefficients.

Index \(L(A)\) by the local labels at one retained party.  The projection
bijections above turn the marginal into
\[
 \rho_A
   =\sum_{v\in P_i}\lambda_v
       W_v\otimes W_{f_2(v)}\otimes\cdots\otimes W_{f_{m+1}(v)},
 \qquad \lambda_v\ne0,
\]
where every \(f_j:P_i\to P_j\) is a bijection fixing the identity.
The maps \(f_j\) need not be \(\mathbb F_q\)-linear.  Axis recovery uses
only that they are bijections between full local Weyl bases.

Because \(m+1\geq3\), the rank-one contraction locus of this tensor is
exactly the union of its displayed coordinate axes.  A product-unitary
equivalence of two such marginals must therefore permute every local Weyl
axis.  Conjugation fixes the identity axis, so every local factor
normalizes the projective Weyl group and is Clifford.

Every party lies in an \((m+1)\)-set, completing the global LU-to-LC
argument.

## What the test removed

None of the following hypotheses is needed for rigidity:

- equal computational-basis phases;
- CSS form \(C\times C^\perp\);
- a linear classical code;
- the MDS shortening theorem;
- \(\mathbb F_q\)-linearity of the stabilizer label group; or
- odd characteristic.

Their role in the current paper is instead to supply explicit
classification coordinates, diagonal-isoduality, and exact logical
groups.  The general stabilizer-AME theorem broadens the LU-to-LC
headline, not the later code-geometric group dichotomy.

## Lean support

`RelativeConicArcs.AMELU.StabilizerAMESupport` now proves the explicit
finite-coordinate support bridge, including:

- `stabilizerAME_kernelToLocal_bijective`;
- `stabilizerAME_finrank_ker_eq_local`.
- `stabilizerCoordinateRestriction_eq_zero_iff`;
- `stabilizerKernelLocalProjection_injective_of_supportAtMost`;
- `stabilizerAME_halfParty_kernelToLocal_bijective_of_finrank`; and
- `stabilizerKernelLocalProjection_existsUnique`.

`AMESupportedSubspaceProfile.erase_sup_erase_eq`,
`space_eq_minimumSupportSpan`, and
`minimumSupportSpan_univ_eq_top` prove the minimum-support decomposition
and generation consequences from the exact support profile.
`RelativeConicArcs.AMELU.HolonomyCentralizer` proves the abstract
evaluation-at-a-base equivalence between compatible transition gauges and
the holonomy centralizer, including restriction to a normal subgroup.

The existing generic diagonal-tensor files already prove the independent
axis-recovery step for arbitrary finite index sets and nonzero
coefficients.  `RelativeConicArcs.AMELU.StabilizerAMERigidity` now composes
the actual supported kernels, exact profile, complete local-label
projections, phased marginal, covariance, and axis terminal.  Its
`additiveStabilizer_all_isClifford_of_localAction` and party-relabeled
variant are the end-to-end rigidity terminals.  The sole physics-facing
field is `AdditiveStabilizerState.marginalWeylExpansion`, the standard
partial-trace stabilizer-projector formula; the party-relabeled terminal
also takes an explicit realization of the permuted source state.

## Literature audit

The claim-specific audit is complete in
`2026-07-25-c649-stabilizer-ame-literature-audit.md`.  It discusses
fourteen sources individually, including three at full-text depth, and
records every search family, cache key, hash, read depth, and database gap.

The qubit theorem is already a consequence of Rains and the Van den
Nest--Dehaene--De Moor minimal-support criterion.  Tan's 2026 computation
contains the canonical \(q=3,m=2\) automorphism subcase.  Huber--Grassl
already give the full quantum-MDS weight enumerator, and perfect-tensor
operator pushing is standard from Pastawski et al.  No exact predecessor
was located for the uniform all-prime-power, all-\(m\), arbitrary-additive
intertwiner theorem or its factorwise stabilizer-QMDS conversion corollary.
The manuscript makes no absolute firstness claim.

## Manuscript consequence

Theorem 1.1 is now the arbitrary-additive stabilizer
\(\operatorname{AME}(2m,q)\) theorem.  The title, abstract, Sections 1--4,
verification prose, and scholarly ledgers use the new hierarchy.  MDS
shortening remains as an explicit CSS realization; diagonal isoduality and
the pencil retain their previous scopes.  The transition-atlas paragraph
now identifies Section 4's 450 holonomies as concrete conjugacy data of the
general full-Weyl marginal atlas.

## Extra-juice consequences and exposition hierarchy

Two consequences are free once the support theorem is stated.

First, the minimum-weight coefficient of the projective stabilizer weight
enumerator is forced:
\[
 A_{m+1}
   =\binom{2m}{m+1}(q^2-1).
\]
Indeed, each \((m+1)\)-set supports exactly \(q^2-1\) nonidentity labels,
all with full support, and a label of weight \(m+1\) determines its support
set uniquely.  This is best presented as a short corollary or consistency
check, not as a separate headline; a literature comparison with quantum-MDS
weight-enumerator formulas is required before attaching novelty language.

More generally, AME and purity give the complete supported-label profile
\[
 \bigl|\{\ell\in L:\operatorname{supp}(\ell)\subseteq A\}\bigr|
   =q^{2\max(|A|-m,0)}.
\]
For \(|A|\leq m\) this is the no-small-support condition.  For
\(|A|\geq m\), compare the Weyl-orthogonality formula for
\(\operatorname{tr}(\rho_A^2)\) with
\(\operatorname{tr}(\rho_{A^c}^2)=q^{-|A^c|}\).
Möbius inversion then determines the entire projective stabilizer weight
enumerator.  If \(w>m\), the number of labels with any one prescribed
support of size \(w\) is
\[
 \sum_{j=m+1}^{w}(-1)^{w-j}\binom{w}{j}
       \bigl(q^{2(j-m)}-1\bigr),
\]
and multiplying by \(\binom{2m}{w}\) gives the weight-\(w\) coefficient.
This broader formula is likely standard quantum-MDS enumerator territory
and should serve as a literature connection rather than a new paper branch.

Second, choose any party of a stabilizer \(\operatorname{AME}(2m,q)\) state
as a Choi input.  The remaining parties define a one-logical-qudit
stabilizer quantum-MDS encoder with parameters
\([[2m-1,1,m]]_q\).  The LU-to-LC theorem then makes every tensor-product
conversion between any two such encoders Clifford on every physical factor
and on the logical factor.  Thus the present transversal no-go also loses
its CSS, equal-phase, and classical-MDS hypotheses.  This belongs immediately
after the general rigidity theorem.

The clean paper hierarchy is therefore:

1. general stabilizer-AME support theorem;
2. general stabilizer-AME LU-to-LC theorem and projective discreteness;
3. general stabilizer quantum-MDS encoder no-go;
4. MDS--CSS specialization, where classical geometry computes exact
   logical groups rather than proving rigidity;
5. the six-party pencil and invariant-theoretic applications.

The title and abstract should reflect the split in roles: stabilizer AME is
the scope of rigidity, while MDS--CSS geometry is the scope of the exact
transversal-group calculation.  A suitable working title is

> *Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford
> Groups of MDS--CSS Codes*.

The opening proof picture should be the cardinality squeeze, not MDS
shortening.  On every half-plus-one marginal, AME forces the supported
stabilizer subgroup to contain exactly one representative of every local
Pauli label at each retained party.  The existing axis lemma then recovers
the local Pauli frame.  MDS shortening should reappear afterward as the
explicit CSS realization of this intrinsic support theorem.

Equivalently, the supported subgroup is the graph of stabilizer
operator-pushing maps.  Fix \(i\in A\).  Every Pauli label at \(i\) has a
unique stabilizer completion on the other \(m\) parties of \(A\), so on the
state every one-party Pauli pushes to a product Pauli on any chosen other
\(m\) parties.  The half-plus-one marginal records the graph of this
discrete pushing map.  Axis recovery says that its product structure
reconstructs the Pauli frame.  This gives the theorem a direct perfect-
tensor, holographic-code, and quantum-secret-sharing interpretation without
adding another proof branch; the closest primary operator-pushing source
should be cited rather than claiming this language as new.

For \(q=p^e\), “Clifford” in the general theorem means the normalizer of the
chosen \(q\)-dimensional additive Weyl system, whose label action lies in
\(\operatorname{Sp}_{2e}(p)\).  The later
\(\operatorname{SL}_2(q)\)-versus-\(T\) calculation remains an odd-prime
MDS--CSS specialization.  Keeping these statements separate prevents the
larger extension-field local Clifford group from leaking into the exact
logical-group claim.

### Proposed front matter

Working abstract:

> Let \(q=p^e\).  For \(m\geq2\), every product-unitary equivalence
> between stabilizer \(\operatorname{AME}(2m,q)\) states is Clifford
> factor by factor.  On any \(m+1\) parties, the supported stabilizer
> labels form a \(q^2\)-element group and project bijectively onto the
> complete local Weyl basis at every retained party.  The reduced
> operator therefore determines its local Weyl axes intrinsically.
> This applies to arbitrary additive prime-power stabilizers and is
> sharp at \(m=1\).  As a Choi consequence, tensor-product conversions
> between the associated \([[2m-1,1,m]]_q\) stabilizer quantum-MDS
> encoders are Clifford on every physical factor and on the logical
> factor.
>
> For equal-phase states from linear MDS--CSS codes, the code geometry
> further determines the exact transversal group.  Over odd prime
> fields it is
> \(\mathbb F_q^2\rtimes\operatorname{SL}_2(q)\) exactly on the
> diagonally isodual branch and
> \(\mathbb F_q^2\rtimes T\) otherwise.  For six-party states, a
> degree-eight quotient classifies the admitted non-GRS pencil, while
> fixed-copy scalar contractions are generically blind to its parameter.

The introduction should then use five paragraphs before the first
specialized corollary:

1. define stabilizer AME states and ask whether their local Pauli frame
   survives arbitrary product changes of basis;
2. state the general rigidity theorem;
3. explain the supported-subgroup squeeze and axis recovery;
4. state the stabilizer quantum-MDS Choi corollary and the sharp Bell-pair
   boundary;
5. position the qubit minimal-support ancestry and the audited scope of
   the prime-power/additive extension.

Only then introduce linear MDS--CSS states and state diagonal isoduality.
This prevents the exact group calculation and the pencil from obscuring
the theorem that now carries the widest scope.

## Second-order extra juice: generation, holonomy, and stability

The complete support profile implies that the minimum supported subgroups
generate the whole stabilizer label space.  If \(A\) has size
\(s\geq m+2\) and \(i\ne j\) lie in \(A\), then
\[
 L(A\setminus\{i\})\cap L(A\setminus\{j\})
   =L(A\setminus\{i,j\}).
\]
The support-dimension formula gives
\[
\begin{split}
 \dim_{\mathbb F_p}\bigl(
   L(A\setminus\{i\})+L(A\setminus\{j\})\bigr)
 &=2e(s-1-m)+2e(s-1-m)-2e(s-2-m)\\
 &=2e(s-m)\\
 &=\dim_{\mathbb F_p}L(A),
\end{split}
\]
with the same calculation at \(s=m+2\) using
\(\dim L(A\setminus\{i,j\})=0\).  Hence
\[
 L(A)=L(A\setminus\{i\})+L(A\setminus\{j\}).
\]
Descending induction from the full party set shows that the
\(L(B)\), \(|B|=m+1\), span \(L\).

This turns the family of half-plus-one marginals into a finite
Pauli-pushing atlas.  Projection bijections on one support give transition
maps between local Pauli spaces; overlaps impose compatibility, and loop
compositions give holonomy up to local symplectic conjugacy.  The 450
shortened-plane holonomies already used for the six-party pencil are
exactly the \(m=3\), prime-field instance of this construction.  The
minimum-support generation theorem also replaces the MDS-specific sentence
in the logical-phase proof that shortened minimum-weight words span
\(C\oplus C^\perp\).

The full embedded atlas is a complete LC invariant, although a compressed
holonomy multiset need not be.  If local symplectic maps carry every
\(L(B)\), \(|B|=m+1\), to the corresponding supported subgroup of a
second state, generation makes their direct sum carry the full label
Lagrangian \(L\) to \(L'\).  Choose local Clifford lifts.  Any remaining
stabilizer-character mismatch is removed by a Pauli correction, as in the
existing character-correction theorem.  Conversely, an LC equivalence
plainly carries the full atlas.  In a fixed Pauli frame the actual
\((m+1)\)-party reduced operators determine even the stabilizer character,
because their nonzero Weyl coefficients give its values on a spanning
set.  Thus all half-plus-one marginals determine the stabilizer AME state.

This is the best route for making the two halves of the paper cohere:
rigidity reconstructs each local frame, holonomy compares the reconstructed
frames across overlapping marginals, and diagonal isoduality determines
the symmetry group of the resulting atlas.  The exact claim that the
full atlas is a complete LC invariant uses only generation and Pauli phase
correction.  Completeness should not be attributed to the scalar
450-holonomy multiset outside the admitted pencil.

There is also a quantitative successor.  For a stabilizer marginal all
diagonal Weyl coefficients have the same magnitude.  In the contraction
proof, the nonzero singular values are therefore a common scalar times
the absolute values of the contraction coordinates.  The distance from
rank one is exactly controlled by the second-largest coordinate, with no
condition-number loss from unequal coefficients.  This gives the queued
approximate-rigidity problem a uniform starting estimate and suggests an
explicit ``approximately LU implies near LC'' theorem for stabilizer AME
states.  It is a successor, not a free manuscript corollary.

## Tao / third-order extra juice: the transport-commutant theorem

The transition atlas suggests one exact object that may subsume much of the
paper's later propagation machinery.  Make a connected multigraph whose
vertices are the local Pauli-label spaces \(V_i\) and whose edge labeled by
\((A;i,j)\) is
\[
 M_A(i,j)=p_jp_i^{-1}:V_i\longrightarrow V_j,
 \qquad |A|=m+1,\quad i,j\in A.
\]
Fix a base party \(b\).  Products along closed paths generate a holonomy
group \(H_b\leq\operatorname{GL}(V_b)\).

In prime local dimension, evaluation at \(b\) should give an exact
isomorphism
\[
 \{\text{fixed-party linear Clifford symmetries of }L\}
   \;\cong\;
 C_{\operatorname{SL}_2(q)}(H_b).                    \tag{*}
\]
Necessity is immediate: preservation of every supported graph gives
\[
 F_jM_A(i,j)=M_A(i,j)F_i,
\]
so \(F_b\) commutes with every loop transport.  Conversely, an element
centralizing \(H_b\) propagates consistently to every party.  Since
\(\operatorname{SL}_2(q)\) is normal in \(\operatorname{GL}_2(q)\), all
propagated blocks remain symplectic.  They preserve every minimum-support
subgroup, and minimum-support generation then makes them preserve \(L\).

For \(q=p^e\), \(e>1\), conjugation by an arbitrary transition need not
preserve \(\operatorname{Sp}_{2e}(p)\).  Choose path transports
\(P_i:V_b\to V_i\), pull each local alternating form back to \(V_b\), and
write it as
\[
 P_i^*J_i=J_bA_i.
\]
A base block propagates symplectically exactly when it commutes with every
\(A_i\); path independence is exactly commutation with every holonomy.
Thus the natural prime-power replacement for \((*)\) is
\[
 G_b
   \;\cong\;
 \operatorname{Sp}(V_b,J_b)\cap\mathcal A_L',
 \qquad
 \mathcal A_L=\langle H_b,A_1,\ldots,A_{2m}\rangle.    \tag{**}
\]
Changing the base or chosen paths conjugates the presentation without
changing the resulting group.

This is the structural theorem Tao would ask the paper to expose.

- In the prime-field MDS--CSS case, the ever-present split torus forces
  the holonomies into its diagonal commutant.  Diagonal isoduality is the
  scalar-holonomy branch, whose centralizer is all of
  \(\operatorname{SL}_2(q)\); a nonscalar diagonal holonomy leaves exactly
  \(T\).
- The 450 quantities in the six-party pencil are scalar conjugacy data
  extracted from \(H_b\), rather than an isolated census.
- The extension-field shortened-transport commutant dimensions and their
  Frobenius-sector jumps are candidates for concrete manifestations of
  \(\mathcal A_L'\).  Verifying the identification could turn the current
  exceptional census into an exact group theorem.
- Dasu--Burton's transversal-Clifford matrix algebra becomes a genuinely
  close conceptual comparison: both problems reduce a transversal group
  to units in a finite endomorphism-algebra commutant, with different
  locality and block hypotheses.
- Quantitative rigidity can be organized by the smallest nonzero singular
  value of the commutator map
  \(X\mapsto([X,a])_{a\in\mathcal A_L}\).  A near symmetry is then close to
  the exact commutant before the final projection to a Clifford element.

The immediate high-value test is to prove \((*)\) abstractly and check that
the existing prime-field logical-phase proof factors through it.  The
prime-power theorem \((**)\) is the next layer.  A finite census should then
ask which centralizer types actually occur for stabilizer AME tensors:
full symplectic group, split or nonsplit Cartan, unipotent centralizer,
center, or further extension-field commutants.  Unexpected absences would
be structural constraints, not failed searches.

## Mystery ledger

| Mystery | Status | Evidence / next gate |
|---|---|---|
| Does the supported subgroup have exactly \(q^2\) elements? | resolved positively | cardinality squeeze above; Lean dimension core |
| Does every retained local projection cover the full Weyl basis? | resolved positively | AME excludes the projection kernel; equal finite cardinalities |
| Do arbitrary stabilizer phases spoil diagonality? | resolved negatively | they only multiply Weyl-basis coefficients by nonzero phases |
| Is \(\mathbb F_q\)-linearity required? | resolved negatively | prime-field/additive dimension argument and group-cardinality proof |
| Is \(m=1\) included? | resolved negatively and sharply | Bell-pair \(U\otimes\overline U\) automorphisms |
| Is the stabilizer weight distribution determined? | resolved positively | purity fixes every supported-label count; subset Möbius inversion gives all exact weights |
| Do minimum-support stabilizers generate the full label group? | resolved positively in prose | support-dimension inclusion--exclusion and descending induction; Lean bridge requested |
| Do the marginal transition maps explain the pencil holonomies? | resolved conceptually | Section 4 already defines the same projection transitions and loop compositions |
| Is the full pushing atlas a complete LC invariant including phases? | resolved in prose | generation recovers the label Lagrangian; existing Pauli character correction removes lift mismatch |
| Does full-Weyl rigidity admit a uniform quantitative version? | open successor | equal coefficient magnitudes give a condition-number-free rank-one defect; C581 owns the full stability theorem |
| Is the prime-field fixed-party group exactly the holonomy centralizer? | open, proof outlined | prove evaluation-at-base isomorphism using transition intertwining, loop consistency, and minimum-support generation |
| Does the prime-power group equal the symplectic commutant in \((**)\)? | open | add transported-form operators to the holonomy algebra and prove path-choice independence |
| Which holonomy-centralizer types occur for general stabilizer AME states? | open | exact census after \((*)\)/\((**)\); distinguish split, nonsplit, unipotent, central, and extension-field cases |
| Do C623's commutant jumps equal \(\dim\mathcal A_L'\)? | open | reconcile the shortened-transport matrices and transported alternating forms definition by definition |
| Does the transversal no-go remain CSS-specific? | resolved negatively | view any party as the Choi input of the punctured stabilizer quantum-MDS encoder |
| Is the prime-power qudit theorem already in the literature? | open | claim-specific audit required before manuscript novelty wording |
| Is the full stabilizer-to-marginal bridge kernel checked? | open | build an additive stabilizer-state interface; current Lean checks the dimension and axis cores |
