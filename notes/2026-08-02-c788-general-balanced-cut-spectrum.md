# C788 — general balanced-cut exchange-spectrum theorem

**Date:** 2026-08-02

**Lane:** `golden`

**Status:** complete; structural classification proved, exact falsifier gate passed,
no manuscript edited

## Result

Let (C=C^{\mathsf T}) be a symmetric conference matrix of order (2d),
so (C^2=qI) with (q=2d-1).  For a balanced half (T), order the
coordinates by (T,T^c) and write

\[
 C=\begin{pmatrix}A&R\\R^{\mathsf T}&E\end{pmatrix}.
\]

Let (P_\pm=(I\pm C/\sqrt q)/2), let (D_T) be the sign involution of the
cut, and let (Q_+) be an isometry onto (\operatorname{im}P_+).  The
balanced exchange operator is

\[
 H_T=Q_+^{\mathsf T}D_TP_-D_TQ_+.
\]

Then its complete spectrum is

\[
 \boxed{\operatorname{Spec}(H_T)
 =\operatorname{Spec}\!\left(\frac1qRR^{\mathsf T}\right)
 =\left\{1-\frac{\alpha_1^2}{q},\ldots,
          1-\frac{\alpha_d^2}{q}\right\},}
\]

where (\alpha_1,\ldots,\alpha_d) are the eigenvalues of the principal
block (A=C[T,T]).  Equivalently,

\[
 \det(xI-H_T)=q^{-d}\det\!\left(q(x-1)I+A^2\right).
\]

This formula gives an exact classification of the uniform case.

There is a sharper two-moment form.  Call a signed four-set *aligned* when
the sum of its three Hamilton-cycle signs is (3), and let (c_T) count the
aligned four-sets contained in (T).  Then every balanced cut satisfies

\[
 \boxed{\operatorname{tr}(H_T)=\frac{d^2}{q},}
\]

while

\[
 \boxed{
 \operatorname{tr}(H_T^2)
 =\frac{F_d+32c_T}{q^2},
 \quad
 F_d=dq^2-2qd(d-1)+d(d-1)+12\binom d3-8\binom d4.}
\]

Thus the one-copy exchange trace is universal at every conference order, but
the two-copy exchange purity is cut-independent if and only if (d\leq3).
Whenever two purities differ, their gap is an integer multiple of
(32/q^2).  Full spectrum rigidity therefore already fails at the first
nonautomatic exchange moment.

> **Balanced-cut exchange-rigidity theorem.**  For a symmetric conference
> matrix of order (2d), the exchange spectrum is independent of the
> balanced cut if and only if (d\leq3).  Among realized nontrivial symmetric
> conference orders, order six is therefore the unique cut-independent case.
> Its spectrum is
> \[
> \left\{\frac15,\frac45,\frac45\right\}.
> \]

The qualification about realized orders only removes the nonexistent
order-four symmetric conference case.  Order two is the trivial one-mode
case.  Thus the six-mode theorem is an exceptional endpoint, not the first
member of a higher-order uniform family.

## Structural proof

### 1. The commutator is the exchange map

Put (Q=C/\sqrt q).  The commutator (L=[D_T,Q]) anticommutes with (Q),
so it exchanges the (+1) and (-1) eigenspaces of (Q).  On the positive
eigenspace,

\[
 Lv=2P_-D_Tv.
\]

Hence (H_T) is one quarter of (L^*L) restricted to that eigenspace.  In
cut coordinates,

\[
 L=\frac2{\sqrt q}
 \begin{pmatrix}0&-R\\R^{\mathsf T}&0\end{pmatrix}.
\]

The restrictions of (L^*L) to the two (Q)-eigenspaces have the same
spectrum, while the full coordinate expression has the squared singular
values of (R), each twice.  Therefore

\[
 \operatorname{Spec}(H_T)=q^{-1}\operatorname{Spec}(RR^{\mathsf T}).
\]

The (T\times T) block of (C^2=qI) gives

\[
 RR^{\mathsf T}=qI-A^2,
\]

which proves the displayed formula.  It also shows intrinsically why
complementary halves have the same exchange spectrum: their two Gram matrices
are (RR^{\mathsf T}) and (R^{\mathsf T}R).

### 2. Uniform spectra force uniform four-vertex holonomy

Assume (d\geq4) and that the exchange spectrum is cut-independent.  Since

\[
 \operatorname{tr}(H_T^2)
 =d-\frac2q\operatorname{tr}(A^2)
   +\frac1{q^2}\operatorname{tr}(A^4)
\]

and (\operatorname{tr}(A^2)=d(d-1)), the value of
(\operatorname{tr}(A^4)) is the same for every (d)-subset (T).

For a four-set (K=\{a,b,c,e\}), let (w(K)) be the sum of the signs of
its three undirected Hamilton cycles.  Every edge occurs twice in the product
of those three cycle signs, so

\[
 w(K)\in\{3,-1\}.
\]

Classifying the closed four-walks in (A) by support gives

\[
 \operatorname{tr}(A^4)
 =d(d-1)+12\binom d3
 +8\sum_{\substack{K\subset T\\|K|=4}}w(K).
\]

Since (w(K)=-1+4\mathbf 1_{\{K\text{ aligned}\}}), substitution in
the preceding trace formula proves the displayed purity formula.  It also
shows that the higher-order obstruction is local: the second exchange moment
counts one signed four-vertex pattern exactly.

The inclusion map from functions on four-subsets of a (2d)-set to their
sums on (d)-subsets is injective for (d\geq4).  A short proof uses swaps:
equality on (U\cup\{a\}) and (U\cup\{b\}) makes the sums of the
differences (f(J\cup\{a\})-f(J\cup\{b\})) vanish on all
((d-1))-subsets (U); induction on the subset size makes every such
difference zero.  Single-element exchanges then connect all four-subsets.
Consequently the constant fourth trace forces (w(K)) itself to be constant
on all four-sets.

### 3. The local condition stops at six vertices

Switch (C) so that every edge incident with one fixed vertex (\infty)
has sign (+1).  On a four-set (\{\infty,i,j,k\}), write the three
remaining edge signs as (x,y,z\).  Then

\[
 w(\{\infty,i,j,k\})=xy+xz+yz.
\]

If the common value is (3), every triangle in the signed complete graph on
the other (2d-1) vertices is monochromatic.  All its edges therefore have
one sign.  The inner product of two corresponding conference rows is then
(2d-2\), contradicting (C^2=qI).

If the common value is (-1), the two-coloring on those (2d-1) vertices
has no monochromatic triangle.  The elementary Ramsey bound
(R(3,3)=6) gives (2d-1\leq5), hence (d\leq3), again contradicting
(d\geq4).  This proves the obstruction.

For (d=1) the statement is immediate.  For (d=2), every zero-diagonal
two-by-two sign block satisfies (A^2=I).  For (d=3), if (\tau) is the
product of the three edge signs, then

\[
 A^2=2I+\tau A,
\]

so (A^2) always has spectrum (\{4,1,1\}).  This proves the converse and
recovers the six-mode spectrum without enumerating cuts.

## Exact falsifier gate

The deterministic standard-library checker enumerates balanced cuts modulo
complement for symmetric conference matrices of orders 6, 10, and 14.  It
checks (C^2=(n-1)I), verifies (RR^{\mathsf T}=qI-A^2) independently on
every cut, computes exact Gram characteristic polynomials by Newton
identities, and checks the closed-four-walk formula separately.

The order-six matrix has one profile on all ten cuts:

\[
 \det(tI-RR^{\mathsf T})=t^3-9t^2+24t-16.
\]

The first higher case already splits.  At order ten the 126 projective cuts
have two profiles:

\[
\begin{array}{c|l}
90&t^5-25t^4+224t^3-832t^2+1024t,\\
36&t^5-25t^4+240t^3-1120t^2+2560t-2304.
\end{array}
\]

Their principal fourth traces are respectively (132) and (100).  At
order ten these are exactly the cuts containing respectively one and zero
aligned four-sets.  At order fourteen, 1,716 cuts split into five complete
Gram spectra, fourth-trace values (342,406), and aligned-four-set counts
(5,7).  These finite checks are normalization and falsifier evidence; the
unrestricted higher-order exclusion is the structural proof above, not an
extrapolation from the census.

## Reproducibility

The evidence bundle is:

- `notes/2026-08-02-c788-balanced-cut-spectrum.py` — deterministic generator
  and checker;
- `notes/2026-08-02-c788-balanced-cut-spectrum.json` — canonical exact
  certificate;
- `notes/2026-08-02-c788-balanced-cut-spectrum.sha256` — hashes and byte
  counts.

Replay from the repository root:

```sh
python3 notes/2026-08-02-c788-balanced-cut-spectrum.py --check
```

The trusted boundary is Python integer arithmetic, canonical enumeration of
halves containing vertex zero, the displayed Paley prime-field construction
at orders 6 and 14, and the integral simplex construction of the order-ten
conference matrix.  Characteristic polynomials and fourth traces use separate
exact computations.  The certificate does not classify conference switching
classes; the theorem does not need such a classification.

## Literature and manuscript boundary

The bounded audit
`notes/2026-08-02-c788-balanced-cut-spectrum-literature-audit.md` consulted five
individually discussed sources, four at full-text depth.  It found direct prior
art for complementary conference-block spectra, conference-ETF moment methods,
inclusion-matrix descent, and spectral monomorphy of Hermitian matrices and
two-graphs.  It did not locate the weaker singular-spectral classification proved
here, the aligned-four-set purity formula, or its Ramsey cutoff.

The safe positioning is therefore “we prove” together with “we have not located
this singular-spectral analogue,” never “first.”  MathSciNet, Google Scholar,
two published full texts, and a subject-expert check remain uncovered.  The
audit also exposed a terminology collision: two-graph literature reserves
“coherent” for triples, so this report uses *aligned four-set* for the condition
(w(K)=3).  No paper source was edited.

## `ej` + `tt` closeout and Mystery ledger

- **Settled by `tt`:** the right invariant is the full cross-Gram spectrum,
  not its determinant.  The commutator calculation identifies it exactly with
  the exchange spectrum.
- **Settled by `ej`:** only the fourth spectral moment is needed for the global
  obstruction.  Inclusion-matrix injectivity converts its cutwise constancy to
  a four-vertex condition, avoiding any classification of conference matrices.
- **Settled by `ej2`:** the obstruction is stronger than nonuniform complete
  spectra.  The first exchange moment is universal in every order, whereas the
  second moment is an exact affine count of aligned four-sets and is uniform
  only for (d\leq3).  Its nonzero gaps are quantized in units of
  (32/(2d-1)^2).
- **Settled by `ej`:** the two possible four-cycle sums have distinct endings:
  value (3) contradicts row orthogonality, while value (-1) is exactly a
  triangle-free two-coloring and stops at six vertices by (R(3,3)=6).
- **Settled:** order ten is the first realizable falsifier and already has two
  complete spectra; order fourteen has five.  The computational gate agrees
  with, but is not load-bearing for, the general proof.
- **Open, not needed here:** classify the distribution of complete exchange
  spectra within higher Paley cut orbits.  The C729 cross-ratio signatures are
  the natural input, but this would be a new arithmetic successor rather than
  a gap in the rigidity theorem.
- **Partially settled publication gate:** the focused audit found no exact
  predecessor for the singular-spectral classification and identified spectral
  monomorphy as the correct neighboring framework.  MathSciNet, Google Scholar,
  two published full texts, and a subject-expert check remain open, so C788
  licenses no “first” claim.

No unexplained feature remains in the cut-independence classification.
