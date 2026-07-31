# C728 — Intrinsic synchronized pure-spinor geometry

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** complete

## Outcome

The six principal-Pfaffian systems have a canonical intrinsic construction.
They are the Cartan images of six graph-isotropic subspaces attached to the
coherent outer family of golden conference operators.  The construction is
fully outer-$S_6$-equivariant, and its linear synchronization occurs with
multiplicity one.  Its top-Pfaffian covariant also occurs with multiplicity
one.

The top-coordinate projection is exactly the classical GIT quotient of six
ordered points on $\mathbf P^1$.  Scheme-theoretically its image is the reduced
Segre cubic


\[
 \sum_{T\in\mathcal T}z_T=\sum_{T\in\mathcal T}z_T^3=0.
\]

There are no additional, embedded, or nilpotent image components.  The
projectivized map is undefined on a reduced union of fifteen lines, indexed by
the four-subsets of the six-axis set; on the line indexed by (Q), the four
values $x_i$, $i\in Q$, coincide.  The ten strictly semistable $3+3$
orbits map to the ten nodes of the Segre cubic.

This separates the two pieces of geometry sharply.  The Wick equations cut
out each spinor variety and explain the principal-Pfaffian coordinates inside
one cell.  Golden synchronization supplies the unique outer-$S_6$ map from
the common five-space, and the six-point invariant quotient supplies the
Segre relation among its top coordinates.  Wick identities alone supply
neither relation.

The focused audit names four sources, one read at full text.  It found a close
but distinct predecessor: after choosing a nonstandard $S_5$, the Segre
cubic itself has an equivariant single-Pfaffian (A)-net presentation.  That
presentation is a Pfaffian equation *on the target*; it is not a common
Gaussian parent of the six cells and does not recover their full outer-$S_6$
synchronization.

## 1. Intrinsic construction

Let (k) have characteristic zero, let (X) be the marked six-axis set, and
put

\[
 U=k^X,\qquad A_X=U/k\mathbf1.
\]

Let (mathcal T) be the outer six-set.  A coherent golden marking gives, for
each $T\in\mathcal T$, a symmetric zero-diagonal conference operator
$C_T:U\to U$, defined up to vertex switching and satisfying $C_T^2=5I$.
For $x\in A_X$, define the alternating form

\[
 \alpha_T(x)(e_i,e_j)=(x_i-x_j)(C_T)_{ij}.
\]

This is independent of the representative of (x).  On the hyperbolic space
$H_T=U_T\oplus U_T^*$, its graph

\[
 L_T(x)=\{u+\iota_u\alpha_T(x):u\in U_T\}
\]

is a maximal isotropic subspace in the positive component of
$\operatorname{OG}(6,12)$.  In the big cell determined by $U_T$, the Cartan
pure spinor is

\[
 s_T(x)=\exp(\alpha_T(x))
       =\sum_{|S|\ {m even}}\operatorname{Pf}(\alpha_T(x)_S)e_S.
\]

Thus the required map is

\[
 \Phi_C:A_X\longrightarrow
 \prod_{T\in\mathcal T}\operatorname{OG}^+(H_T),
 \qquad x\longmapsto (L_T(x))_T.
\]

It is a morphism, not merely a rational map: the empty Pfaffian is (1), so
every factor remains in its chosen big cell for every (x).

### Exact symmetry

For $g\in S_X$, let $gT$ denote the outer action.  Coherence supplies a
monomial switching isometry $M_{g,T}:U_T\to U_{gT}$ such that

\[
 C_{gT}=\operatorname{sgn}(g)
 M_{g,T}C_TM_{g,T}^{\mathsf T}.
\]

The diagonal algebra is switching-blind, and hence

\[
 \alpha_{gT}(gx)=\operatorname{sgn}(g)
 M_{g,T}\alpha_T(x)M_{g,T}^{\mathsf T}.
\]

The corresponding hyperbolic similitude carries $L_T(x)$ to
$L_{gT}(gx)$.  In Pfaffian coordinates it permutes supports through the
monomial frame, multiplies a (2r)-body coordinate by
(operatorname{sgn}(g)^r), and sends the (T)-factor to the (gT)-factor.
Changing a conference representative by vertex switching only changes the
big-cell trivialization.  Reversing the coherent orientation negates all six
top coordinates together.

This gives the commuting diagram

\[
\begin{CD}
 A_X @>{\Phi_C}>> \prod_T\operatorname{OG}^+(H_T)\\
 @V{g}VV @VV{g}V\\
 A_X @>{\Phi_C}>> \prod_T\operatorname{OG}^+(H_T).
\end{CD}
\]

## 2. Equivariant uniqueness

Let

\[
 \mathscr W=\bigoplus_{T\in\mathcal T}\bigwedge^2U_T^*
\]

with the signed monomial action just described.  The differential of the
six-cell construction at the vacuum is the map

\[
 \alpha:A_X\longrightarrow\mathscr W,
 \qquad x\longmapsto(\alpha_T(x))_T.
\]

The exact $S_6$ character calculation gives

\[
 \dim\operatorname{Hom}_{S_6}(A_X,\mathscr W)=1.
\]

Since $\alpha\ne0$, it spans this Hom-space.  Therefore the synchronized
linear slice is unique up to common scale once the outer six-set, coherent
orientation, and switching frames are marked.  There is no independent scale
for each cell compatible with the full action.

Let $E=\operatorname{sgn}\otimes k[\mathcal T]_0$ be the signed outer
augmentation module.  The same class calculation gives

\[
 \dim\operatorname{Hom}_{S_6}(\operatorname{Sym}^3A_X,
     \operatorname{sgn}\otimes k[\mathcal T])=1,
 \qquad
 \dim\operatorname{Hom}_{S_6}(\operatorname{Sym}^3A_X,E)=1.
\]

The top Pfaffians

\[
 p_T(x)=\operatorname{Pf}\alpha_T(x)=4Z_T(x)
\]

are nonzero and sum to zero, so they span the unique cubic covariant line.
This proves equivariant uniqueness at both levels: the cell synchronization
is the unique linear tangent map, and its top-coordinate projection is the
unique signed outer cubic covariant.

The certificate records the character on all eleven conjugacy classes.  The
inner products are (720/720) in each of the three cases, so the conclusion
does not rest on a numerical decomposition package.

## 3. Exact projected ideal

Consider the coordinate-ring map

\[
 \varphi:k[z_T:T\in\mathcal T]\longrightarrow k[A_X],
 \qquad z_T\longmapsto p_T.
\]

The Golden identities give

\[
 J=\left(\sum_Tz_T,\sum_Tz_T^3\right)\subseteq\ker\varphi.
\]

Fix the translation gauge $x_5=0$.  At

\[
 (x_0,x_1,x_2,x_3,x_4)=(-2,-2,-1,-1,0)
\]

the top vector is ((16,-16,0,0,0,0)).  The Jacobian minor with target rows
((0,2,3,4)) and source columns ((0,1,2,4)) is
$-24576\ne0$.  Hence the affine image has dimension at least four.  It has
dimension at most four because it lies in (V(J)\subset\mathbf A^6).

The ideal (J) is prime.  After eliminating its linear generator, its cubic
defines the Segre cubic cone.  The projective cubic is irreducible: otherwise
two positive-degree components would meet in dimension at least two inside
its singular locus, whereas the Segre cubic has only ten singular points.
Thus $J$ and the prime ideal $\ker\varphi$ have the same height two, and

\[
 \boxed{\ker\varphi=J.}
\]

This is the human proof of the projected ideal.  Exact elimination independently
returns the same two-generator ideal.

### Base and exceptional strata

The six cubics are the Joubert coordinates for the GIT quotient

\[
 (\mathbf P^1)^6\mathbin{/{\mkern-6mu}/}\operatorname{PGL}_2
 \cong \{\textstyle\sum z_T=\sum z_T^3=0\}\subset\mathbf P^5.
\]

The affine point $x$ represents the ordered sextuple
$([x_i:1])_{i\in X}$.  The projectivized map is therefore the quotient map
on this affine slice.  Its stable fibres are the residual one-dimensional
$\operatorname{PGL}_2$-orbits after translation and scale have been fixed.

Hilbert--Mumford instability for six equal weights means that at least four
points coincide.  Hence the set-theoretic base locus is the union of the
fifteen lines

\[
 \ell_Q=\{[x]\in\mathbf P(A_X):x_i=x_j\text{ for all }i,j\in Q\},
 \qquad Q\in\binom X4.
\]

Exact radical and minimal-prime computation strengthens this to a scheme
statement: the ideal $(p_T)_T\subset k[x_0,\ldots,x_4]$ is radical and its
fifteen minimal primes are the codimension-three linear ideals of the
$\ell_Q$.  Thus the base scheme has projective degree fifteen and no embedded
or nonreduced stratum.  The strictly semistable configurations are the ten
(3+3) partitions; their quotient points are the ten ordinary nodes of the
Segre cubic.

## 4. Relation to the conference-cut partial isometry

The top projection of $\Phi_C$ lands in $E$.  C720's syndrome matrix gives
the next canonical arrow

\[
 \frac1{\sqrt{12}}R^{\mathsf T}:E
 \stackrel{\sim}{\longrightarrow}E_{+3}(S_{10}).
\]

Consequently the spinor and conference-cut maps fit into one equivariant
factorization:

\[
 A_X\xrightarrow{\ \Phi_C\ }
 \prod_T\operatorname{OG}^+(H_T)
 \xrightarrow{\ \mathrm{top}\ }E
 \xrightarrow{\ R^{\mathsf T}/\sqrt{12}\ }E_{+3}(S_{10}).
\]

The first arrow is linear in the big-cell skew coordinates, the second is
cubic, and the third is linear and isometric.  They are therefore not three
coordinate versions of one linear map.  They are consecutive functorial
operations on the same outer augmentation object.  This locates the exact
common universal construction: the synchronized Cartan section produces the
outer cubic module, and the Naimark--Gram map transports that module to the
ten-cut conference eigenspace.

There is also a distinct single-Pfaffian presentation of the target.  After a
nonstandard $S_5\subset S_6$ is selected, Tschinkel--Zhang exhibit a
six-dimensional representation $V$ of a Schur cover and a five-dimensional
summand $A\subset\bigwedge^2V^*$ whose Pfaffian cubic is the Segre cubic.
This presentation chooses an $S_5$ marking and places one Pfaffian equation
on $E$.  It neither constructs the six graph-isotropic subspaces
$L_T(x)$ nor makes their top-coordinate relation a Wick relation.

## 5. Literature audit

### Search and coverage

The audit searched the following query families on 2026-07-31:

- `pure spinor variety principal Pfaffians Wick relations matchgate identities`;
- `matchgate identities spinor variety Pfaffian signatures`;
- `six points P1 GIT quotient Segre cubic Joubert invariants`;
- `Segre cubic pure spinor`, `Segre cubic matchgate Pfaffian`,
  `Joubert Pfaffian spinor`, and `synchronized pure spinor Segre`.

The general Segre/GIT batch returned 36 records, the pure-spinor/Wick batch
21, the matchgate-primary-source batch 19, the spinor-homogeneous-space batch
27, and the exact-combination batch 22.  All 125 returned records were
screened over title, snippet, and displayed metadata; duplicates between
batches were retained in these provenance counts.  The mechanical
discriminator was: “promote a record if its displayed fields join
pure-spinor, matchgate, or Pfaffian geometry to the Segre/Joubert six-point
system, or if it supplies the defining equations on one side of that
comparison.”  Sources promoted for individual use are listed below.
MathSciNet was not accessible and is **NOT COVERED**; zbMATH Open was not
separately queried.  Google Scholar was not used because automated access is
unreliable.  The negative novelty wording below is deliberately qualified.

### Sources and read depth

1. Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil,
   *The relations among invariants of points on the projective line*,
   arXiv:0906.2437v1 — **full text**, all six pages, cached as
   `arXiv:0906.2437`, SHA-256
   `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.
   Used for the six-point invariant ring, the outer action, and the unique
   Segre cubic relation.
2. Rocco Chirivì and Andrea Maffei, *Pfaffians and Shuffling Relations for
   the Spin Module*, arXiv:1203.2943v1 — **partial**, introduction and
   Section 6 (Theorems 17--18), cached as `arXiv:1203.2943`, SHA-256
   `69c7b479c12de24d2a71677a6e049b6ed577f359ce720478003219df0cf731ad`.
   Used for principal Pfaffians as the spinor big cell and for the quadratic
   ideal of their relations.
3. Jin-Yi Cai and Aaron Gorenstein, *Matchgates Revisited*,
   arXiv:1303.6729v2 — **partial**, abstract, introduction, and Section 2
   through Theorems 1--2, cached as `arXiv:1303.6729`, SHA-256
   `3a0b58ae7252720ae6beaa58b27b9a5db6d1bb3cf2312d23bbb504a39bc412a6`.
   Used for the necessary-and-sufficient matchgate identities and their
   Pfaffian/Grassmann--Plücker origin.
4. Yuri Tschinkel and Zhijia Zhang, *Stable equivariant birationalities of
   cubic and degree 14 Fano threefolds*, arXiv:2409.08392v1 — **partial**,
   Sections 1, 3, and 7, cached as `arXiv:2409.08392`, SHA-256
   `f8a72383325e8e6e9ab3113f5b9a0e2b7ea3cc5edf5d8e2f35ae2fe07b8557ab`.
   Used for the equivariant Pfaffian--Grassmannian construction and the
   nonstandard-$S_5$ Pfaffian presentation of the Segre cubic.

### Verdict and manuscript-safe boundary

Classical spinor geometry says that one skew matrix gives one pure spinor and
that its principal Pfaffians satisfy the quadratic Wick relations.  Classical
matchgate theory gives the same equations as the signature constraints.
Classical invariant theory says that six ordered points on $\mathbf P^1$ have
the Segre cubic as their equal-weight quotient.  Recent equivariant
Pfaffian--Grassmannian work also gives an $S_5$-equivariant single-Pfaffian
presentation of that cubic.

No consulted source constructs the six conference-indexed Cartan cells from
one marked golden operator family, proves the multiplicity-one outer-$S_6$
synchronization, or identifies its top projection with the six-point quotient.
The manuscript may therefore say:

> The principal-Pfaffian coordinates in each factor are classical pure-spinor
> or matchgate coordinates.  For the marked golden family, the six factors
> admit a unique outer-$S_6$-equivariant synchronization, and its top
> projection is the Joubert quotient onto the Segre cubic.  Thus the Segre
> equation records golden synchronization; it is not a Wick identity.

Any priority phrase stronger than “to our knowledge” remains blocked by the
uncovered MathSciNet and zbMATH searches.

## 6. Reproducibility

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-31-c728-synchronized-pure-spinor-geometry.py --check
python3 notes/2026-07-31-c728-synchronized-pure-spinor-replay.py
```

The generator reconstructs the coherent outer six family, verifies
$C_T^2=5I$, constructs the top Pfaffians, evaluates all eleven $S_6$
character classes, checks the three Hom-space multiplicities, and records the
rank-four Jacobian witness.  It then invokes Singular 4.4.1 through
`nixpkgs#singular` on
`notes/2026-07-31-c728-synchronized-pure-spinor-elimination.sing`.  The exact
elimination checks the projected ideal; radical and minimal-prime computation
check the reduced fifteen-line base scheme.

The replay hard-codes the six normalized conference matrices and the
independently transcribed class table.  It recomputes the three character inner
products and verifies both Segre identities on an interpolation-complete
$4^5$ grid.  Since each top Pfaffian is multiaffine, its cube has degree at
most three in each variable, so this grid proves the polynomial identity in
the translation gauge $x_5=0$.

The computation certifies the stated conventions over (mathbb Q).  The
scheme-theoretic image proof does not depend on trusting elimination: it uses
the displayed Jacobian witness and the classical irreducibility of the Segre
cubic.  Singular is load-bearing only for the sharpened radical statement
about the projective base scheme.

Hashes and byte counts are recorded in
`notes/2026-07-31-c728-synchronized-pure-spinor-geometry.sha256`.

## 7. `ej` + `tt` closeout

The closeout exposed two cheap strengthenings and one boundary correction.

1. The rank-four Jacobian witness turns the computational containment in the
   Segre equations into a short human proof of the complete projected ideal.
2. The GIT interpretation identifies every exceptional stratum: fifteen
   reduced unstable lines and ten strictly semistable nodal images.
3. The closest Pfaffian predecessor does not weaken the synchronization
   theorem, but it changes the wording.  “No single Pfaffian Segre parent” is
   false after an $S_5$ marking; the correct claim is that no single Wick
   parent produces these six cells or their outer-$S_6$ coupling.

The highest-value structural formulation is therefore the three-arrow
factorization through the signed outer augmentation module (E).  It joins
the synchronized Cartan cells to the order-ten Naimark--Gram shadow without
collapsing their different degrees or functorial roles.

## Mystery ledger

- **Settled:** whether the synchronized tangent slice is forced.  The relevant
  Hom-space has multiplicity one.
- **Settled:** whether the top cubic covariant is forced.  Both the signed
  outer permutation and augmentation multiplicities are one.
- **Settled:** whether elimination has extra target equations or nilpotent
  strata.  The image ideal is prime and generated by the Segre linear and
  cubic equations.
- **Settled:** the projective indeterminacy.  It is a reduced union of fifteen
  four-coincidence lines; the ten (3+3) strata map to the nodes.
- **Open boundary, not needed for C728:** whether the nonstandard-$S_5$
  single-Pfaffian (A)-net of the Segre target admits a natural enhancement
  carrying the full outer $S_6$ action.  The consulted source proves only
  the $S_5$ construction, and C728 needs no such enhancement because its
  product construction is already fully $S_6$-equivariant.
