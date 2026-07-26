# C622: diagonal-isodual fixed-party transversal dichotomy

**Lane:** `ame-lu`

**Status:** complete

## Result

Let \(q\) be an odd prime, \(m\geq2\), and let
\(C\leq\mathbb F_q^{2m}\) be a linear \([2m,m,m+1]_q\) MDS code.  The
fixed-party projective transversal logical group of the associated
\([[2m-1,1,m]]_q\) quantum MDS encoder is
\[
 \begin{cases}
 \mathbb F_q^2\rtimes\operatorname{SL}_2(q),
   & SC=C^\perp\text{ for a nonsingular diagonal }S,\\
 \mathbb F_q^2\rtimes T,
   & \text{no such }S\text{ exists},
 \end{cases}
\]
where \(T=\{\operatorname{diag}(a,a^{-1}):a\in\mathbb F_q^\times\}\).
Thus the proposed dichotomy is true.  The GRS evaluation formula is not
needed: it supplies one class of diagonal-duality witnesses, but diagonal
isoduality is the intrinsic phase condition.

The result concerns fixed party labels.  A coordinate permutation used in
the broader coding-theory definition of isoduality belongs to the separate
party-moving extension and can enlarge \(T\) to its normalizer.  The theorem
therefore uses *diagonally isodual* for the fixed-coordinate condition.

## Arbitrary-length proof

Write a product-Clifford label action as
\[
 F_i=\begin{pmatrix}\alpha_i&\beta_i\\
                     \gamma_i&\delta_i\end{pmatrix}
\]
and use \(D_\alpha,D_\beta,D_\gamma,D_\delta\) for the corresponding
diagonal coordinate matrices.  Preservation of
\(L_C=C_X\oplus C_Z^\perp\) is equivalent to
\[
\begin{array}{ll}
D_\alpha C\subseteq C,&D_\gamma C\subseteq C^\perp,\\
D_\beta C^\perp\subseteq C,&D_\delta C^\perp\subseteq C^\perp.
\end{array}
\]

The six-party multiplier lemma extends without loss.  If \(E,F\) are
\([2m,m,m+1]_q\) MDS codes and a diagonal \(D\) satisfies
\(DE\subseteq F\), then either \(D=0\), or \(D\) is nonsingular and
\(DE=F\).  A nonzero \(D\) supported on at most \(m\) coordinates would
send a word nonzero at one supported coordinate to a nonzero word of
weight at most \(m\) in \(F\).  Hence its support has at least \(m+1\)
coordinates.  Its kernel on \(E\) is supported on at most \(m-1\)
coordinates and is therefore zero.  Equal dimensions give \(DE=F\), and
surjectivity excludes a zero diagonal entry.

If the chosen input block is nondiagonal, \(D_\beta\) or \(D_\gamma\) is
nonzero.  The lemma gives
\[
 D_\gamma C=C^\perp\quad\text{or}\quad D_\beta C^\perp=C.
\]
The second equality can be inverted, so a nondiagonal input block forces a
nonsingular diagonal \(S\) with \(SC=C^\perp\).  Without such an \(S\),
every input block is diagonal and determinant one.  The common blocks
\(\operatorname{diag}(a,a^{-1})\) always preserve \(L_C\), proving that
the exact linear factor is \(T\).

Conversely, a witness \(S=\operatorname{diag}(s_i)\) propagates
\[
 \begin{pmatrix}1&0\\ \lambda s_i&1\end{pmatrix},
 \qquad
 \begin{pmatrix}1&\mu s_i^{-1}\\0&1\end{pmatrix}.
\]
At any input coordinate \(j\), varying \(\lambda,\mu\) realizes every
lower and upper elementary unipotent because \(s_j\ne0\).  These generate
\(\operatorname{SL}_2(q)\).  More generally, propagation from \(j\) to
\(i\) is conjugation by
\(\operatorname{diag}(1,s_i/s_j)\), so all group relations hold
coordinatewise.  Logical Pauli operators have physical Pauli
representatives, giving the complete translation fiber
\(\mathbb F_q^2\) over either linear factor.  The LU-rigidity theorem
excludes any non-Clifford enlargement.

The odd-field Weil representation still gives coherent unitary lifts of
the linear \(\operatorname{SL}_2(q)\) factor on every diagonally isodual
code.  The full affine scalar extension remains nonsplit by the Weyl
commutator.  Neither statement decides the independent party-permutation
extension.

## Non-GRS boundary

Diagonal isoduality is not a disguised GRS condition.  Zhu and Liao
construct self-dual non-GRS MDS families; self-duality is the special case
\(S=I\).  Zhu and Zhao construct isometry-dual elliptic MDS codes, using
fixed-coordinate diagonal equivalence in their AG-code presentation.
These sources establish that the intrinsic condition occurs outside the
evaluation-line framework, although the manuscript does not depend on a
specific non-GRS parameter example.

No new computation was adopted.  The proof is symbolic, and the
non-GRS boundary is literature-supported rather than inferred from a local
finite search.

## Literature audit

No source was read at full text.  Four primary preprints were read
partially, and two current publisher records were available only at
abstract/metadata depth.  This audit supports terminology, neighboring
constructions, and scope.  It does not license a novelty or priority
claim, and the manuscript makes none.

- Yunlong Zhu and Chang-An Zhao, *On Iso-Dual MDS Codes From Elliptic
  Curves*, arXiv preprint version `arXiv:2502.02033`, corresponding to the
  2026 published article.  **Read depth:** `partial`, introduction,
  Theorem 3.1, Construction 2, Theorem 5.1, and conclusion.  Access:
  shared cache key `arXiv:2502.02033`, SHA-256
  `e8af7e0dd247530d95a11c7df06dba3c5a38fb101895e6f1cc142351710408bf`.
  The source defines isometry duality, explicitly fixes the coordinate
  order for its AG codes, and constructs odd-characteristic
  isometry-dual MDS elliptic codes.
- Theerapat Tansuwannont, Yugo Takada, and Keisuke Fujii, *Clifford Gates
  with Logical Transversality for Self-Dual CSS Codes*,
  `arXiv:2503.19790`.  **Read depth:** `partial`, introduction, definitions
  of compatible symplectic bases, Theorem 1, and Corollary 1.  Access:
  shared cache key `arXiv:2503.19790`, SHA-256
  `1734a9034eabbf75450c00e41352fa2b049747384d06528053f834cacab3e82e`.
  It treats binary self-dual CSS codes and simultaneous transversal
  Hadamard/phase operations in a compatible logical basis, not the exact
  odd-prime fixed-party group of a one-logical-qudit MDS encoder.
- Daitao Huang, Qin Yue, Yongfeng Niu, and Xia Li, *MDS or NMDS
  Self-Dual Codes from Twisted Generalized Reed--Solomon Codes*,
  `arXiv:2009.06298`.  **Read depth:** `partial`, definitions, Theorem 2.5,
  Section 3 statements, and construction corollaries.  Access: shared
  cache key `arXiv:2009.06298`, SHA-256
  `b15a6adf3d0169f9055d71675a5b186f22fef3012574c1c9b542d0acca121810`.
  It supplies odd-prime self-dual MDS TGRS constructions but does not by
  itself establish the non-GRS status needed for the manuscript sentence.
- Hao Chen, *Many Non-Reed-Solomon Type MDS Codes From Arbitrary Genus
  Algebraic Curves*, arXiv preprint `arXiv:2208.05732`, corresponding to
  the 2024 IEEE article.  **Read depth:** `partial`, Sections 2.2--3,
  Theorem 2.4, and Corollary 3.2.  Access: shared cache key
  `arXiv:2208.05732`, SHA-256
  `ad56f6ce5fdbdc99dad52de3663004d202fe692be50071b3d8b55da08c7e02e2`.
  Its Schur-square argument distinguishes elliptic MDS codes from GRS
  codes, but the paper does not identify those examples with Zhu--Zhao's
  isometry-dual construction.
- Canze Zhu and Qunying Liao, *A Class of Double-Twisted Generalized
  Reed--Solomon Codes*, 2024, DOI
  `10.1016/j.ffa.2024.102395`.  **Read depth:**
  `abstract/metadata only`, publisher title, abstract, introduction
  preview, and section headings.  The accessible record states that the
  authors prove non-GRS status by Schur squares and construct several
  self-dual non-GRS MDS or NMDS classes.  The full text was not reachable,
  so no theorem number or parameter-level claim is imported.
- D. Mokhtari, K. Guenda, T. A. Gulliver, N. Aydin, and P. Liu,
  *MDS Matrices and Their Application to MDS and LCD Code Construction*,
  2026, DOI `10.1007/s40314-026-03768-4`.  **Read depth:**
  `abstract/metadata only`, Springer publisher record.  Its abstract
  advertises isodual MDS constructions and \(\lambda\)-orthogonal MDS
  matrices.  The full text is subscription-only and was not used for a
  mathematical implication.

Load-bearing search strings were:

```text
"isodual MDS codes"
"diagonally isodual" code
"MDS code" "equivalent to its dual" monomial
site:arxiv.org transversal Clifford MDS CSS code automorphism symplectic
"self-dual" "non-GRS MDS" code
"A class of double-twisted generalized Reed-Solomon codes" pdf
```

The screened fields were titles, abstracts, publisher metadata, and the
searchable full text of the promoted arXiv records.  MathSciNet and Google
Scholar were not covered; the current Springer and Elsevier full texts were
not accessible.  These are access gaps, not negative results.  No
forward-citation closure or absence claim was attempted.

## Manuscript and formal consequence

Corollary `cor:diagonal-isodual-transversal-group` now states the intrinsic
all-length dichotomy.  Section 3 proves the arbitrary-length multiplier
lemma, converse, duality-shear propagation, complete translation fiber,
GRS specialization, and scalar-lift boundary.  Section 5 identifies
diagonal isoduality with the conic condition for six-arcs.  The introduction,
verification boundary, theorem map, claim/proof/novelty ledger,
verification map, formalization ledger, and statement-adequacy table use the
same scope.  The stale verification sentence denying the already-constructed
nonabelian party-permutation factor set was also corrected.

`RelativeConicArcs.AMELU.EncoderTransversal` now defines
`IsDiagonallyIsodual`, packages the five exact obligations in
`DiagonalIsodualityTransversalInputs`, and proves
`diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy`.  The terminal
has no GRS evaluation hypothesis.  Its conditional fields expose
special-linearity, torus propagation, diagonal-isodual propagation, the
off-diagonal converse, and the complete affine translation fiber.  The
declaration is included in `AMELUAggregateAxioms`.

## Validation

- `lean/scripts/guarded-lean
  RelativeConicArcs/AMELU/EncoderTransversal.lean`: passed in 45 seconds.
- The guarded aggregate rebuild and trace-only
  `AMELUAggregate`/`AMELUAggregateAxioms` exit gate passed.  The new
  terminal reports only `propext`, `Classical.choice`, and `Quot.sound`.
- `make -C papers/ame_lu check`: warning-free, 21 pages, 195,344 bytes.
- PDF SHA-256:
  `67a9dc518045d0edb723349753a7ed6eca26780e08e878b2e583322a36d0283f`.
- Manuscript pages 2, 7, 8, and 21 were rendered and visually inspected;
  the new statement, proof, extension factor set, and bibliography are
  legible with no bad break.
- The refreshed release manifest verifies 35 public artifacts and 76 formal
  companion artifacts in the current integrated graph; their tree hashes are
  `1fadf1e57b7c94f735eed1411b68c8c0e20dafec6188ce1890f2f7ff4bbc89cb`
  and
  `96800b6a569cdd6e68e01c3884405f8b2d05af0e9ef410b9d5f2e3454b14a11a`.
- No computational evidence bundle was required or adopted.

## `ej` and Tao closeout

The cheap strengthening was to move the entire GRS scalar-lift calculation
to the diagonal-isodual branch.  The coordinate propagation formula already
depends only on \(S\), so the genuine Weil lift of the linear factor holds
for every code on that branch, not merely for evaluation codes.

The adversarial question was whether a diagonal automorphism of \(C\) could
enlarge the non-isodual input group beyond \(T\).  It cannot: such
automorphisms may change the other coordinate blocks, but the image on the
chosen two-dimensional Pauli plane is still a determinant-one diagonal
matrix, hence an element of \(T\).  The common torus supplies every such
input block.

The terminology check also exposed an important boundary.  Coding papers
often allow a coordinate permutation in “isodual,” while fixed-party
transversality does not.  The manuscript now says “diagonally isodual” and
keeps permutation-assisted dualities in the party-moving extension.

## Post-closeout extra juice

The multiplier lemma gives a sharper intrinsic test than the dichotomy needs.
For a generator matrix \(G\) of \(C\), set
\[
 \mathcal D_C=\{s\in\mathbb F_q^{2m}:G\operatorname{diag}(s)G^{\mathsf T}=0\}.
\]
This is a linear space, and \(s\in\mathcal D_C\) precisely when
\(\operatorname{diag}(s)C\subseteq C^\perp\).  Every nonzero member is
nonsingular and gives equality by the multiplier lemma.  Moreover,
\(\dim\mathcal D_C\leq1\): if independent \(s,t\) existed, both would have
full support, while
\(s-(s_i/t_i)t\) would be a nonzero member with a zero \(i\)-th coordinate.
Thus diagonal isoduality is exactly the nullity-one case, failure is the
nullity-zero case, and the witness \(S\) is unique up to scalar.  The ratios
\(s_i/s_j\) in the propagation formula are consequently canonical invariants
of the labeled code.

This also makes the logical phase an all-or-nothing one-gate test.  The
existence of one fixed-party transversal Clifford with a nondiagonal block at
one input forces \(\mathcal D_C\neq0\), and the resulting upper and lower
shears generate the whole \(\operatorname{SL}_2(q)\) factor at every input.
The two projective groups have orders
\[
 q^3(q^2-1)\quad\text{and}\quad q^2(q-1),
\]
so crossing the phase boundary multiplies the group order by \(q(q+1)\).

Finally, a witness \(S\) makes \(C\) a maximal totally isotropic subspace for
the diagonal symmetric form
\((x,y)\mapsto xS y^{\mathsf T}\).  The form is therefore hyperbolic.  In odd
characteristic this gives the immediate necessary check
\[
 \det S=\prod_i s_i\in(-1)^m(\mathbb F_q^\times)^2.
\]
This determinant-square-class obstruction is weaker than the nullity test but
can reject a proposed witness without manipulating the code.

## Mystery ledger

| Feature | Closeout status | Evidence gap or owner |
|---|---|---|
| Does the six-party diagonal-multiplier lemma propagate to arbitrary \(m\)? | **Settled:** the support and kernel bounds become \(m\) and \(m-1\) verbatim. | none |
| Can a nondiagonal input block occur without diagonal isoduality? | **Settled negatively:** either off-diagonal coordinate matrix is a nonsingular code--dual equivalence. | none |
| Is the translation fiber complete over both branches? | **Settled:** physical Pauli representatives give every logical Pauli independently of the linear block. | none |
| Does the theorem require GRS evaluation structure? | **Settled negatively:** only a diagonal duality witness is used. | none |
| Are there non-GRS codes on the isodual branch? | **Settled at family level:** published self-dual non-GRS MDS constructions exist. | the accessible Zhu--Liao record did not support a parameter-level example, so none is claimed |
| Is the exact arbitrary-length converse unconditional in Lean? | **Settled boundary:** the terminal names its five hypotheses and proves the exact carrier dichotomy from them. | formalizing the MDS diagonal-multiplier lemma and its block-action bridge would remove the remaining conditional fields |
| How many diagonal-duality witnesses can a fixed labeled MDS code have? | **Settled:** their linear space has dimension zero or one, so a witness is projectively unique. | none |
| Does one nondiagonal transversal gate imply only a partial enlargement? | **Settled negatively:** it forces the full \(\operatorname{SL}_2(q)\) branch and an order jump by \(q(q+1)\). | none |
| Does the witness carry a quick arithmetic obstruction? | **Settled:** its diagonal form is hyperbolic, so \(\det S\) has square class \((-1)^m\). | none |

No unresolved mathematical feature remains in the exact fixed-party
dichotomy.  The only open item is the depth of its formal proof, not the
paper theorem.

**Vibe check:** this is the high-value clean outcome: the GRS/non-GRS
presentation boundary disappears and the logical phase becomes an intrinsic
code property at every length, with a short converse and no new finite
computation.
