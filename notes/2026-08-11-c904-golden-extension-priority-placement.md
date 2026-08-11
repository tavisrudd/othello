# C904 golden extension, priority, and placement closeout

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** all three residual mysteries from the maximal-order bridge are
closed.  The extension group is computed exactly, the literature boundary is
audited at bounded primary-source depth, and the result belongs structurally
in Paper V rather than being proved for the first time in the geometric
epilogue.

## Final verdict

Let \(H\) be either of the two Frobenius-conjugate, two-dimensional natural
\(\mathbf F _4A_5\)-modules under
\(A_5\simeq\operatorname{SL}_2(\mathbf F _4)\).  Then

\[
 \operatorname{Ext}^1_{\mathbf F _4A_5}(\mathbf F _4,H)
 \simeq H^1(A_5,H)\simeq \mathbf F _4.
\]

The golden maximal-order sequence

\[
0\longrightarrow H\longrightarrow
D_6^\vee/2D_6^\vee\longrightarrow\mathbf F _4\longrightarrow0
\]

is nonsplit, hence represents a nonzero class and spans this one-dimensional
space.  All three nonzero classes give isomorphic middle modules.  The exact
basis-free formulation is therefore:

> \(D_6^\vee/2D_6^\vee\) is the unique nonsplit extension middle module of
> the trivial line by the selected natural heart.

There is not a canonical nonzero *vector* of the abstract one-dimensional
Ext space until generators of both the heart and quotient line are fixed.
Their scalar automorphisms move the three nonzero vectors transitively.  The
canonical object is the nonsplit extension isomorphism class, and the golden
orientation selects which Frobenius-conjugate natural heart occurs.

The literature audit changes the novelty posture but not the theorem:

- conference matrices acting on root/weight-type lattices over quadratic
  integer rings are classical in Robin Chapman's skew-conference setting;
- the relevant nonsplit trivial/natural \(A_5\)-modules occur in the classical
  characteristic-two \(A_5\)-block description;
- no source was located for the exact symmetric order-six synthesis

  \[
  B\rightsquigarrow D_6^\vee
  \rightsquigarrow D_6^\vee/2D_6^\vee
  \rightsquigarrow [A_5,-]
  \rightsquigarrow\{\omega,\omega^2\}.
  \]

Thus neither the lattice ingredient nor the modular Ext ingredient should be
sold as a standalone novelty.  The publishable point is their canonical
composition with the reconstructed golden orientation.

## 1. Structural Ext calculation

Take

\[
s=\begin{pmatrix}1&1\\0&1\end{pmatrix},
\qquad
t=\begin{pmatrix}0&\omega\\\omega^2&1\end{pmatrix}
\in\operatorname{SL}_2(\mathbf F _4).
\]

Then \(s,t,st\) have orders \(2,3,5\), respectively, and generate the
order-sixty group.  A cocycle \(f:A_5\to H\) is determined by

\[
a=f(s),\qquad b=f(t).
\]

The triangle relations impose

\[
(1+s)a=0,
\qquad
(1+t+t^2)b=0,
\qquad
(1+st+\cdots +(st)^4)(a+sb)=0.
\]

On the natural module, \(1+s\) has rank one.  The other two norm operators
vanish: \(t^2+t+1=0\), while \(st-1\) is invertible and
\((st)^5=1\).  Consequently

\[
\dim_{\mathbf F _4}Z^1(A_5,H)=1+2=3.
\]

The coboundary map

\[
H\longrightarrow H\oplus H,
\qquad
v\longmapsto((s-1)v,(t-1)v)
\]

is injective because \(H^{A_5}=0\).  Therefore

\[
\dim_{\mathbf F _4}B^1(A_5,H)=2,
\qquad
\dim_{\mathbf F _4}H^1(A_5,H)=1.
\]

This proof is unchanged for the Frobenius-conjugate natural module.  For a
cocycle \((a,b)\), the corresponding middle module has generator matrices

\[
\begin{pmatrix}s&a\\0&1\end{pmatrix},
\qquad
\begin{pmatrix}t&b\\0&1\end{pmatrix}.
\]

It has a complementary invariant line precisely when the cocycle is a
coboundary.  Multiplication by \(\mathbf F _4^\times\) is transitive on the
three nonzero cohomology classes, proving uniqueness of the nonsplit middle
module.

The earlier maximal-order theorem already proves that
\(D_6^\vee/2D_6^\vee\) has no invariant complementary \(\mathbf F _4\)-line.
Its class is therefore nonzero, so no further comparison matrix is needed.

## 2. Literature boundary

### 2.1 Conference matrices and quadratic orders

Robin Chapman, *Conference Matrices and Unimodular Lattices*, European
Journal of Combinatorics 22 (2001), 1033--1045,
doi:10.1006/eujc.2001.0539, proves that skew-symmetric conference matrices
make \(D_n^+\)-type lattices into modules over maximal imaginary quadratic
orders.  His Lemmas 3.1--3.2 explicitly establish the half-integral lattice
stability, and the later sections develop ideal multiplication and residue
codes.  This is the direct classical predecessor for the broad mechanism
"normalize a quadratic order on a conference lattice before reduction."

It is not the theorem used here.  Chapman treats skew conference matrices of
order divisible by four, with \(W^2=-(n-1)\), \(D_n^+\), and imaginary
quadratic orders.  The present bridge treats symmetric conference matrices
of order \(n\equiv2\pmod4\), with \(B^2=n-1\), the weight lattice
\(D_n^\vee\), and the real operator
\((1+B)/2\).  No real/symmetric analogue or commutator-heart statement was
found in that paper or the bounded follow-up searches.

Haemers--Parsaei Majd, *Spectral Symmetry in Conference Matrices*, Designs,
Codes and Cryptography 90 (2022), 1983--1990,
doi:10.1007/s10623-021-00858-8, supplies the classical normalized symmetric
conference and pentagon-core facts.  It contains no root/weight lattice,
quadratic-order normalization, modular heart, or \(A_5\)-extension statement.

### 2.2 The \(A_5\) nonsplit module

Bleher, *Universal Deformation Rings and Klein Four Defect Groups*,
Transactions of the AMS 354 (2002), 3893--3906,
doi:10.1090/S0002-9947-02-03072-6, Section 3.3, records that the principal
characteristic-two block of \(kA_5\) has simples \(S_0,S_1,S_2\), with
\(S_0\) trivial, and exactly the four oriented length-two uniserial modules

\[
U_{01},U_{02},U_{10},U_{20}.
\]

After scalar extension, the golden middle module is one of the two
trivial/natural cases in this list.  Thus uniqueness of its nonsplit
isomorphism type is classical block structure.  The elementary triangle
calculation above is still worth printing: it works over the exact field
\(\mathbf F _4\), computes the Ext line rather than importing the whole block,
and makes the orientation/Frobenius action transparent.

Bendel--Nakano--Pillen et al., *First Cohomology for Finite Groups of Lie
Type: Simple Modules with Small Dominant Weights*, arXiv:1010.1203, gives the
general small-weight context and dimension-at-most-one theorems, but its type
\(A\) results assume \(p>2\).  It does not cover this defining-characteristic
two exception.

### 2.3 Read depth and bounded coverage

Opening full-text count: **two**.

| source | read depth | exact use |
|---|---|---|
| Chapman, arXiv:math/0007116 | **full text**, 17 pages; cache SHA-256 `779712a919c09464330d07b5e77f337e1023536bfceddb6a3bbb02ab91437ed3` | Direct predecessor for quadratic-order modules on conference lattices; skew/imaginary case only. |
| Haemers--Parsaei Majd, doi:10.1007/s10623-021-00858-8 | **full text**, 8 pages; cache SHA-256 `86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e` | Classical symmetric conference normalization, Paley order-six classification, and bordering context; no lattice/module bridge. |
| Bleher, doi:10.1090/S0002-9947-02-03072-6 | **partial full text**, Section 3.3 and Lemma 3.5 via the indexed published-PDF extraction; abstract/metadata checked against the Iowa and AMS records | Explicit four length-two uniserial \(kA_5\)-modules. |
| Bendel--Nakano--Pillen et al., arXiv:1010.1203 | **partial full text**, abstract, Section 1, Theorems 1.2.1--1.2.3, Corollary 4.3.1, and bibliography; cache SHA-256 `f885e32e3a84a9b22a479684694e4a5ea3a294a1169f6ef35df95c6e4ab10cc9` | General first-cohomology context; explicit \(p>2\) exclusion in type \(A\). |

The bounded search used exact-title and keyword combinations around
"symmetric conference matrix", \(D_n^\vee\), weight lattices, real quadratic
orders, \((I+C)/2\), \(A_5\simeq\operatorname{SL}_2(4)\), natural modules,
and nonsplit extensions.  It also re-used the earlier full-text audit of the
order-six conference core.  MathSciNet, Scopus, and an external specialist
return were not covered, so the safe priority statement is "no exact
synthesis located", not an absolute novelty claim.

## 3. Placement decision: Paper V

The maximal-order/Ext theorem should be the last structural theorem of Paper
V, with only its statement recalled in the geometric epilogue.

This reverses the earlier provisional placement for four reasons.

1. The theorem uses only the marked conference operator, the \(D_6\)
   root--weight passage, modular representation theory, and Frobenius.  It is
   structural reconstruction mathematics, not Hodge or cubic geometry.
2. It is the first theorem proving that Paper V's golden orientation performs
   indispensable work: it selects a literal exotic residue sheet, rather
   than merely producing an abstract two-element torsor.
3. The literature audit shows that its ingredients are classical.  Its value
   is the series-specific synthesis, which is strongest as Paper V's
   culmination and weakest as an allegedly novel opening theorem of a
   standalone geometry paper.
4. Moving it leaves the epilogue a cleaner job: construct the rank-ten
   symplectic envelope, identify cubic homology, and prove the geometric
   consequences.  It no longer begins by repairing a finite-to-modular gap in
   the preceding series.

### Revised Paper V theorem packet

Add after the residual marking theorem:

> **Theorem V.G (normalization--residue bridge).**  The oriented conference
> operator determines the minimal maximal-order lattice \(D_6^\vee\).  Its
> reduction fits into the unique nonsplit sequence
> \[
> 0\to H\to D_6^\vee/2D_6^\vee\to\mathbf F _4\to0,
> \]
> and restriction of \((1+B)/2\) to \(H\) identifies the golden-orientation
> torsor with the exotic Frobenius torsor
> \(\{\omega,\omega^2\}\).

The proof occupies three to four pages:

1. one page for \(D_6^\vee\) and normalization before reduction;
2. one page for the commutator heart and six-point-heart identification;
3. one page for the Ext calculation and Frobenius/outer-normalizer match;
4. at most half a page for functoriality under switching and relabelling.

This revises Paper V's target from 17--22 pages to approximately **20--26
pages**.  It does not import the rank-ten symplectic lattice, PEL
classification, period map, Chow theory, or quantum argument.

The epilogue should restate Theorem V.G in a concise proposition for
standalone readability and cite Paper V for its structural proof.  Its first
new theorem is then the rank-ten integral symplectic envelope and exotic
cubic realization.

## 4. Reproducibility

Primary exact replay from `/home/tavis/src/othello/rust`:

```text
nix shell nixpkgs#python3 --command python ../notes/2026-08-11-c904-golden-extension-h1.py --check
```

Independent Sage replay:

```text
C904_MODE=check nix shell nixpkgs#sage --command sage -c "exec(preparse(open('../notes/2026-08-11-c904-golden-extension-h1-replay.sage').read()))"
```

The primary replay enumerates all cocycles and coboundaries over
\(\mathbf F _4\), constructs every extension class, and tests invariant
complements.  The Sage replay instead computes the presentation-relation
kernel and coboundary rank by exact finite-field linear algebra.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-golden-extension-h1.py` | 6687 | `b52872bcc57972a120fb2b5287eabe603cd6a9c6f7b6b6cfe2d4ee56b5c635f6` |
| `2026-08-11-c904-golden-extension-h1.out` | 431 | `98c495d6aa75a1209750c9dcb774b6b63c8a6170bbc1a6785ea4901441c2f7dd` |
| `2026-08-11-c904-golden-extension-h1-replay.sage` | 2792 | `ba1e0c0c447ed9c9618b0b5d1502d39778f0ee3c66f03ce4f347de15f3961452` |
| `2026-08-11-c904-golden-extension-h1-replay.out` | 195 | `3661bbe4fd9c3141a212f8432a66aaf81ada8542641c8cec3cedaa85ad9fe634` |

## EJ + TT closeout

**EJ.**  The apparent final computation collapses to the spherical triangle
presentation.  The relation norms have ranks \((1,0,0)\), so the entire Ext
calculation is the line

\[
(1+2)-2=1.
\]

This is the structural proof; the scripts are replay evidence only.

**TT.**  Separate "canonical element" from "canonical extension object".
The Ext line has three nonzero vectors and no basis-free preferred one, but
their middle modules are all isomorphic.  Golden orientation selects the
Frobenius-conjugate coefficient module, while maximal-order saturation
selects its unique nonsplit extension.  This is exactly the amount of
canonicity the series needs and avoids an overstated scalar normalization.

## Mystery ledger

| mystery | resolution |
|---|---|
| What is the extension group? | \(\operatorname{Ext}^1_{\mathbf F _4A_5}(\mathbf F _4,H)\simeq\mathbf F _4\). |
| Is the golden class the generator? | It is nonzero and hence spans; canonically it is the unique nonsplit extension isomorphism class, not a distinguished vector without scalar rigidification. |
| Is the mechanism classical? | Quadratic-order conference lattices and the \(A_5\) uniserial modules are classical separately; no exact symmetric \(D_6^\vee\to\mathbf F _4\)-heart synthesis was located in the bounded audit. |
| Paper V or epilogue? | Paper V, as Theorem V.G; the epilogue restates and consumes it but does not duplicate the proof. |
