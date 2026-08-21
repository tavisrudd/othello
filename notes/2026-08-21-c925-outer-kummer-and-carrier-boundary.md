# C925 outer Kummer theorem and the carrier boundary

Date: 2026-08-21

## Status

The projective-bundle side of the two-layer packet proposal is now a source
theorem.  For a rank-three projective bundle, Iritani--Koto's Fourier
branches are cyclically permuted by the cubic Kummer monodromy.  For a
codimension-two blowup, Iritani's comparison has one center summand and root
denominator one, so the outer blowup constructor introduces no new
fractional exceptional variable.

This does **not** close the $m=2$ telescope.  A unary center summand retains
the full descent action of its inner spectral packet.  Integral monomial
coefficients and a saturated Novikov lattice do not force its primitive
idempotents to be fixed.  The exact counterexample is

\[
 K=\mathbf C((q)),\qquad
 A=K[t]/(t^3-q),\qquad
 L=K(q^{1/3}).
\]

The algebra $A$ is defined using integral powers over $K$, but
$A\otimes_KL\cong L^3$, and the three primitive idempotents form the regular
$C_3$-orbit.  Thus codimension two removes only a new *outer* root; it does
not make the center's inner packet externally trivial.

The discriminant-resolvent companion proves the desired unramified inner
packet for the actual $A_5$-cubic Prym axis.  It does not prove that every
smooth threefold center carrying a marked $4/9$ quantum block has that
Prym/resolvent realization.  The remaining theorem is therefore a genuine
carrier-recognition or carrier-unramifiedness statement for arbitrary actual
centers, not a comparison-formula calculation.

## 64.1 The source's external cubic orbit

Let $V\to B$ have rank $r$, and let $q$ be the vertical Novikov
variable.  Iritani--Koto construct Fourier branches $F_j$ at

\[
 \lambda_j=e^{2\pi i j/r}q^{1/r},\qquad 0\le j<r.
\]

In the proof preceding Proposition 5.5 they state that a $2\pi j$-rotation
of the $q$-plane sends $\lambda_0$ to $\lambda_j$ and $F_0$ to
$F_j$.  Theorem 5.1 then identifies the localized QDM of
$\mathbf P_B(V)$ with the direct sum of these $r$ base-QDM branches.

For $X\times\mathbf P^2$, $V=\mathcal O_X^{\oplus3}$, so the base-Novikov
embedding has no $c_1(V)/3$ shift.  The subgroup

\[
 C_{3,\mathrm{ext}}\leq
 \operatorname{Gal}\bigl(K(q^{1/6})/K\bigr)
\]

which sends $q^{1/3}\mapsto\zeta_3q^{1/3}$ cycles the three branches.
Rank-two rigidity makes the $4/9$ marking invariant under regular
comparison and scalar extension.  Hence every nonempty marked base packet
produces an external regular three-orbit.

This is stronger than a cardinality computation: the branch permutation is
explicitly the monodromy used to construct the Fourier transforms.

## 64.2 What codimension two proves

For a blowup along a smooth codimension-$r$ center, Iritani uses

\[
 s=
 \begin{cases}
 r-1,&r\text{ even},\\
 2(r-1),&r\text{ odd}
 \end{cases}
\]

and constructs $r-1$ center summands over
$\mathbf C((q_E^{-1/s}))$.  At $r=2$, this gives

\[
 s=1,\qquad r-1=1.
\]

Moreover the center Novikov map becomes

\[
 Q_Z^d\longmapsto Q^{i_*d}q_E^{-\rho_Z\cdot d},
\]

with integral exponent.  Therefore the *outer* exceptional comparison adds
one copy and needs no root of its own exceptional variable.

For a finite weak-factorization path, this local statement globalizes only
after supplying an injective occurrence-lattice diagram in one torsion-free
saturated lattice, a compatible completion cone, and a primitive mod-three
charge representing the source $\mathbf P^2$ variable.  Under those
hypotheses, all transition monomials have integral external charge and the
source root $q^{1/3}$ defines an external action fixing the base algebra and
the independent exceptional variables.

The existence of that common charged completion is not automatic.  An
abstract colimit can acquire torsion or lose primitivity: a relation
$q=3e$, for example, makes the saturation contain $q/3$.  Nor does the
source fibre class canonically define a class on every weak-factorization
vertex.  Thus the path-level charge-preserving reindexing remains part of the
geometric provider.

It does not imply fixedness of the primitive idempotents of the inner center
QDM.

## 64.3 The actual Prym input

The companion paper
`papers/cubic-gluing-resolvent/cubic_gluing_resolvent.tex` proves two facts
which remove an ambiguity in the proposed packet:

1. its Proposition ``Actual-axis comparison'' identifies the Prym elliptic
   factor with the actual primitive dihedral norm axis inside the
   intermediate Jacobian, as a polarized elliptic scheme;
2. its main theorem identifies the five actual principal kernels with the
   two proper transitive resolvents of the $S_3$-torsor of
   \(\mathcal E[2]\).

After choosing a golden sheet, the internal monodromy is
\(A_3\cong C_{3,\mathrm{int}}\).  This finite-etale cover lives over the
cubic pencil base.  After adding an independent formal $q$-disc it is
unramified in the $q$-direction, whereas $q^{1/3}/q$ is totally ramified.
Thus the actual cubic's Prym packet carries a genuine product action

\[
 C_{3,\mathrm{ext}}\times C_{3,\mathrm{int}}.
\]

This proves that the cubic's internal resolvent does not diagonally collapse
with the projective Kummer action.  No auxiliary-period interpretation is
being used.

## 64.4 The exact obstruction

The false step is

> one outer center summand, defined by integral monomials, is one externally
> fixed primitive idempotent.

The algebra $K[t]/(t^3-q)$ disproves it.  It is one outer algebra over $K$
and three geometric idempotents over $L$.  In packet language, a unary
outer constructor is equivariantly equivalent to its inner packet.

The paper-local Lean theorem

`Comparison.DescentPacket.unaryPacket_isFixed_iff`

formalizes the exact statement: a unary outer constructor neither creates
nor removes fixedness.  Together with the two-layer stable-ledger theorem it
shows that closure requires an external-fixedness theorem for the inner
marked center packet; outer multiplicity one is insufficient.

## 64.5 Smallest remaining theorem

Let $Z^3\hookrightarrow Y^5$ be an actual codimension-two center occurrence,
and let \(\mathscr S_{4/9}(Z)\) be the finite geometric set of primitive
rank-two blocks with residue discriminant $4/9$, after a common splitting
extension.  Let $v_{\mathrm{ext}}$ be the divisorial valuation determined by
the source \(\mathbf P^2\) Kummer variable after transport to the common
Novikov spine.

The remaining theorem is the following three-part occurrence-uniform package:

> **Charged carrier-unramified Burnside lift.** The weak-factorization path admits a
> common faithful saturated coefficient trait with a primitive external
> mod-three charge preserved by every comparison and reindexing.  For every
> dangerous center occurrence, the splitting field (equivalently, the Galois
> closure of the finite etale algebra) of \(\mathscr S_{4/9}(Z)\) is linearly
> disjoint from the external cubic Kummer extension at that trait.  Equivalently,
> the named external subgroup fixes every geometric marked correction
> idempotent.  Finally, the actual projective-bundle, blowup, inverse, and
> adjacent-reindexing comparisons lift coherently to the oriented equivariant
> stable-ledger bijection of these marked finite-etale packets.

An equivalent geometric provider would identify every such marked block with
a carrier construction pulled back from a base independent of the external
Novikov direction.  The actual $A_5$-cubic Prym/resolvent supplies this for
the distinguished cubic source, not for arbitrary centers.

Once this charged carrier-unramified Burnside lift is proved
occurrence-uniformly, the remaining steps are formal:

1. the source marked packet is external regular by Section 64.1;
2. lower-dimensional centers are empty by the existing marker theorem;
3. dangerous codimension-two corrections are external fixed;
4. the target packet is empty;
5. the oriented equivariant stable ledger contradicts the paper-local Lean
   theorem.

## 64.6 Why current sources do not prove carrier-unramifiedness

Iritani--Koto determines the source's projective branches.  Iritani
determines the number and outer root denominator of blowup summands.  Neither
classifies the finite etale algebra of primitive blocks inside the center
QDM.  Functorial uniqueness of a block decomposition makes the Galois action
well defined; it does not make that action trivial.

The discriminant-resolvent paper determines one particular internal packet.
The scalar equality \(\delta^\sharp=4/9\) does not recover that packet: formal
rank-two connections can have the same residue discriminant with unrelated
descent algebras.  Therefore identifying every $4/9$ block with the Prym
resolvent would itself be a new carrier-recognition theorem, not a consequence
of rank-two rigidity.

## Source audit

* H. Iritani and Y. Koto, *Quantum cohomology of projective bundles*,
  arXiv:2307.03696v4, Theorem 5.1 and the monodromy paragraph preceding
  Proposition 5.5.  Cached PDF SHA-256:
  `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624`.
* H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  equation (1.1), equation (5.11), and Theorem 5.18.  Cached PDF SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
* `papers/cubic-gluing-resolvent/cubic_gluing_resolvent.tex`, Theorem
  ``Cubic--modular resolvent'' and Proposition ``Actual-axis comparison''.

The source claims above are positive statements.  The failure of individual
idempotent descent is established by the displayed finite-etale countermodel,
not inferred from an absence in the literature.

## EJ and TT closeout

The useful gain is the separation of local outer and global inner difficulty.
The source orbit is explicit, and the codimension-two operation introduces no
new outer root.  A global external charge still has to survive the path, and
only after that is supplied can the inner carrier be tested for cubic
ramification.

The cheapest falsifier for a proposed completion is now exact: specialize its
center block algebra to $K[t]/(t^3-q)$.  Any argument using only integrality,
saturation, one outer summand, or uniqueness of decomposition will accept this
countermodel and is therefore insufficient.

The highest-value positive test is geometric rather than analytic: determine
whether the source $\mathbf P^2$-valuation restricts trivially modulo three
to every actual threefold carrier of a $4/9$ atom.  A carrier-height or
coniveau theorem could prove this.  A general QDM comparison theorem without
that restriction cannot.

## Mystery ledger

| question | state | exact evidence gap |
|---|---|---|
| Is the source external orbit genuinely cyclic? | settled | Iritani--Koto explicitly transports $F_0$ to $F_j$ under $q$-plane monodromy |
| Does codimension two introduce a new outer root? | settled: no | Iritani has $s=1$ and one center summand |
| Is the actual cubic's internal $C_3$ independent of the external one? | settled after product-base change | actual Prym-axis resolvent is finite etale over the cubic base and unramified in $q$ |
| Does one outer correction imply one fixed idempotent? | settled: no | $K[t]/(t^3-q)$ and the Lean unary-packet theorem |
| What remains for $m=2$? | charged carrier-unramified Burnside lift for arbitrary actual threefold centers | construct the common primitive external charge, exclude cubic ramification of every marked inner block algebra, and lift the actual comparison/reindexing ledger equivariantly |
| Does this give all $m$? | no | higher Kummer degrees require a ramification filtration and carrier-height theorem |
