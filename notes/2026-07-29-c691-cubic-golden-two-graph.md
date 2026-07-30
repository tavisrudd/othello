# C691 — cubic/golden compatibility through the six-axis two-graph

**Lane**: `clebsch`

**Status**: complete; positive compatibility theorem for Paper I v2.

## Result

The support-orientation cubic and the continuation operator are canonically
equivalent.  Their common object is the signed two-graph on the six
\(A_5/D_5\) axes.

Let \(R\) be the antipodal involution on the twelve continuation directions.
Choose one of the two five-valent continuation orbitals and one representative
above each of the six axes.  On the fibre-odd lattice the chosen orbital is a
symmetric matrix
\[
 B=(B_{ij}),\qquad B_{ii}=0,\quad B_{ij}\in\{\pm1\},\quad B^2=5I.
\]
Changing the six representatives switches \(B\) to \(DBD\) for a diagonal
sign matrix \(D\).  Define
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}\qquad(i<j<k).
\]
The switching signs cancel, so the twenty \(c_{ijk}\) are intrinsic.  They
give the cubic
\[
 C_B(x)=\sum_{i<j<k}c_{ijk}x_ix_jx_k.
\]
Exchanging the two continuation orbitals sends \(B\) to \(-B\) on the odd
lattice and therefore sends \(C_B\) to \(-C_B\).  Thus the construction is
an equivariant map from the continuation-orbital orientation torsor to the
cubic orientation torsor.

It is invertible.  The triangle signs obey the two-graph identity
\[
 c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1
 \qquad(i<j<k<\ell).
\]
Choose a temporary gauge with \(B_{0i}=1\).  Then
\[
 B_{ij}=c_{0ij}\qquad(0<i<j),
\]
and the four-point identity recovers every remaining triangle product.
Changing the temporary gauge only switches \(B\).  Hence the oriented cubic
recovers the signed continuation operator on its fibre-odd local system, and
therefore recovers the golden algebra with \(B^2=5\).

The six coordinate positions and the six antipodal continuation axes are
both \(A_5/D_5\).  Since \(D_5\) is self-normalizing in \(A_5\), their
equivariant identification is unique.  Under this identification,
\[
\boxed{\quad c_{ijk}=B_{ij}B_{jk}B_{ki}\quad}
\]
is the requested intrinsic compatibility identity.

## Representation comparison

The oriented triangle-sign tensor has automorphism group \(A_5\) of order
60 inside \(S_6\).  Its unoriented line \(\{\pm c\}\) has automorphism group
of order 120, the outer \(S_5\) normalizer.  The two cosets have sizes
60 and 60 and act on the cubic line by signs \(+1\) and \(-1\).

The continuation orbital difference has the same outer character:
the inner \(A_5\) preserves \(B\) as an operator on the signed axis local
system, while the outer coset exchanges the two five-orbitals and negates
\(B\).  The triangle-product map is equivariant for this normalizer and its
inverse reconstructs the switching class.  This goes beyond observing that
two unrelated exchanges have sign \(-1\): it supplies mutually inverse
constructions between the two oriented objects.

## Frozen-marking replay

C690 identifies the continuation matrix with C682's golden Gram conference
matrix by
\[
 B=S\,P C P^{\mathsf T}S,
\]
where, in zero-based notation,
\[
 P=(0,1,4,5,3,2),\qquad
 S=\operatorname{diag}(1,1,-1,1,1,1).
\]
Switching by \(S\) disappears from every triangle product.  After transport
by \(P\), all twenty products
\[
 B_{ij}B_{jk}B_{ki}
\]
equal the twenty coefficients of C690's signed support cubic, not merely the
same orbit partition.  Complementary triples have opposite signs.  The
gauge reconstruction gives
\[
\begin{pmatrix}
0&1&1&1&1&1\\
1&0&1&1&-1&-1\\
1&1&0&-1&1&-1\\
1&1&-1&0&-1&1\\
1&-1&1&-1&0&1\\
1&-1&-1&1&1&0
\end{pmatrix},
\]
which is switching-equivalent to the continuation matrix and again squares
to \(5I\).

## Determinantal form

The triangle identity is the cubic part of one canonical determinant.  For a
three-element set \(S=\{i,j,k\}\),
\[
 \det B_S=2B_{ij}B_{jk}B_{ki}=2c_{ijk}.
\]
All principal minors of \(B\) have the distributions
\[
\begin{array}{c|rrrrrrr}
\text{size}&0&1&2&3&4&5&6\\ \hline
\text{values}&1&0&-1&\pm2&5&0&-125.
\end{array}
\]
The size-three values occur ten times with each sign.  Therefore, writing
\(e_d(x)\) for the elementary symmetric polynomial,
\[
\boxed{\;
\det\!\bigl(B+\operatorname{diag}(x_0,\ldots,x_5)\bigr)
=e_6(x)-e_4(x)+5e_2(x)-125-2C_B(x).
\;}
\]
The support cubic is the sole nonsymmetric term in the diagonal determinant
pencil of the golden operator.

Homogenizing makes the orientation character explicit.  Put
\[
 F_B(x,z)=\det\!\bigl(zB+\operatorname{diag}(x)\bigr).
\]
Then
\[
 F_B(x,z)
 =e_6-z^2e_4+5z^4e_2-125z^6-2z^3C_B(x),
\]
and golden/orbital conjugation \(B\mapsto-B\), equivalently \(z\mapsto-z\),
has odd part
\[
\boxed{\quad F_B(x,z)-F_B(x,-z)=-4z^3C_B(x).\quad}
\]
Thus the support cubic is the normalized conjugation-odd determinant
coefficient of the golden operator.

The even coefficients do not require an additional enumeration.  From
\(B^2=5I\), one has \(B^{-1}=B/5\) and \(\det B=-125\).
Jacobi's complementary-minor identity pairs principal minors of sizes
\(r\) and \(6-r\).  It forces the size-four minors to equal \(5\), the
size-five minors to vanish, and complementary size-three minors to have
opposite signs.  This recovers support complementation directly from the
golden quadratic identity.

The same identity also gives a conceptual proof of C690's moment
vanishing.  For \(i\ne j\),
\[
 \sum_{k\ne i,j}c_{ijk}
 =B_{ij}\sum_k B_{ik}B_{kj}
 =B_{ij}(B^2)_{ij}=0.
\]
Summing these equations gives the signed one-index and total sums as zero.
Consequently
\[
 C_B(x+t\mathbf1)=C_B(x),
\]
so the cubic descends naturally from \(\mathbf Q^6\) to
\(\mathbf Q^6/\mathbf Q\mathbf1\), the five-dimensional augmentation
module.  Its first nonzero signed moment is forced to occur in degree three
by \(B^2=5I\), rather than established by twenty-term enumeration.

The implication reverses.  Start from the oriented support cubic.  Its
four-point identities reconstruct a switching class \(B\), and for
\(i\ne j\)
\[
 (B^2)_{ij}=B_{ij}\sum_{k\ne i,j}c_{ijk}.
\]
The diagonal entries of \(B^2\) are automatically five.  Therefore
\[
\boxed{\quad
\text{all signed pair moments vanish}
\ \Longleftrightarrow\ B^2=5I.
\quad}
\]
The cubic and its lower-moment balance alone recover the golden quadratic
relation; it need not be supplied separately by the continuation scheme.

There is only one balanced switching class.  Fix the gauge \(B_{0i}=1\).
The five equations \((B^2)_{0i}=0\) say that each of the remaining five
vertices has two positive and two negative incident edges.  The positive
edges therefore form a 2-regular simple graph on five vertices, necessarily
a pentagon.  Conversely a pentagon satisfies every remaining off-diagonal
equation.  The twelve labeled pentagons give twelve gauge matrices and one
class up to relabeling.  Hence the balanced support cubic forces the unique
six-vertex conference two-graph, whose oriented automorphism group is the
reconstructed \(A_5\).

## Intrinsic projective frame

The cubic also recovers the six-axis carrier without being handed its
coordinate labels.  Regard \(C_B=0\) as a cubic threefold in
\[
 \mathbf P(\mathbf Q^6/\mathbf Q\mathbf1)=\mathbf P^4.
\]
Its singular locus consists of exactly the six points
\[
 p_a=[\,\mathbf1-6e_a\,]\qquad(0\leq a<6).
\]
These points form a projective frame.

There is a short exact elimination proof.  Use translation invariance to put
\(x_0=0\), write \(y_i=x_i-x_0\), and cover projective space by the five
charts in which the last nonzero \(y_r\) is \(1\).  The reduced lexicographic
Gröbner bases of the five gradient ideals are
\[
\begin{array}{c|l}
r&\text{basis}\\ \hline
1&\varnothing\\
2&y_1\\
3&y_1,y_2\\
4&y_1,y_2,y_3\\
5&y_1-y_4,\ y_2-y_4,\ y_3-y_4,\ y_4(y_4-1).
\end{array}
\]
Thus the first four charts contribute one coordinate point each, and the
last contributes the fifth coordinate point and \((1,1,1,1,1)\).  There are
no other geometric singular points.

The nodes are ordinary for a structural reason.  At \(p_a\), pair balance
gives
\[
 \operatorname{Hess}(C_B)_{ij}(p_a)=
 \begin{cases}
 -6c_{aij},&a\notin\{i,j\},\\
 0,&a\in\{i,j\}.
 \end{cases}
\]
The nonzero block is switching-equivalent to the five-by-five principal
minor of \(B\), whose characteristic polynomial is
\(\lambda(\lambda^2-5)^2\).  Hence every Hessian has rank four on
\(\mathbf Q^6\); after removing the translation and radial kernels, each
singularity is an ordinary double point.

This also closes the automorphism calculation intrinsically.  Every
projective automorphism of the cubic permutes its complete six-node frame,
and a permutation of a projective frame has a unique projective extension.
The earlier permutation census therefore computes the full projective
automorphism group, not merely a coordinate subgroup:
\[
 \operatorname{Aut}_{\mathrm{proj}}(C_B=0)\cong S_5,\qquad
 |\operatorname{Aut}_{\mathrm{proj}}|=120.
\]
Its index-two subgroup preserving the oriented cubic form is \(A_5\).

## Integral closeout

The compatibility is integral and lives on the coarse order
\(\mathbf Z[\sqrt5]\).  Modulo \(2\), every coefficient \(c_{ijk}=\pm1\)
becomes \(1\), so the oriented cubic loses its bipartition and its symmetry
jumps from \(A_5\) to all of \(S_6\).  Simultaneously
\[
 N=B-I=B+I\pmod2
\]
has rank one and satisfies \(N^2=0\).  This is the cubic side of the
conductor-two degeneration
\[
 \mathbf Z[\sqrt5]\otimes\mathbf F_2
 \cong\mathbf F_2[u]/(u-1)^2.
\]
Equivalently, the term \(-2C_B\) disappears from the diagonal determinant
pencil modulo \(2\), leaving only its symmetric even part.
The normalized golden coordinate \(t=(1+B)/2\) is still unavailable
integrally at \(2\).  The two-graph identity therefore explains the shared
orientation collapse but does not erase the normalization boundary.

## Scope

This theorem is internal to Paper I's reconstructed six-axis package.  It
does not construct an ambient map between harmonic degrees three and six,
identify the Mukai--Umemura geometry, or import Paper III's dodecic
operator.  It says that Paper I's two previously adjacent orientation
structures are the same switching/two-graph datum.

No novelty claim is made here.  The signed-graph/two-graph correspondence is
classical structure; the task-specific result is the exact identification
with the two reconstructed Paper I objects.  Any manuscript priority
sentence still requires the lane's literature-audit protocol.

## Reproducibility and trust boundary

From the repository root:

```text
python3 notes/2026-07-29-c691-cubic-golden-two-graph.py --check
python3 notes/2026-07-29-c691-cubic-golden-two-graph-replay.py
```

The standard-library generator reads the two prior exact certificates,
checks \(B^2=5I\), verifies the twenty triangle coefficients, reconstructs
the switching gauge, enumerates the 60/120 automorphism groups, performs
exact chartwise Buchberger elimination of the gradient ideal, checks the six
Hessian ranks, and checks the mod-\(2\) degeneration.  The replay reads the
two upstream certificates directly, independently recomputes the forward
triangle identity and inverse gauge identity, verifies the nodes and Hessian
ranks, and exhausts the projective singular loci over \(\mathbf F_7\) and
\(\mathbf F_{11}\) as an independent invariant check.  The human two-graph
and projective-frame arguments prove the intrinsic reconstruction; the
programs fix the task-specific marking and coefficients.

| input | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c690-rigidity-fingerprints.json` | 6,076 | `dc973a8751ece1207b1a1a84d336b31284e4cf8cbea69830236343663b45f4d6` |
| `notes/2026-07-26-c682-transvectant-bridge.json` | 19,904 | `e4704b1de4c042a8ed4b1876edebefa919ab562ebe0417c2d835e0e9cc403161` |

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c691-cubic-golden-two-graph.py` | 24,559 | `11be0efe9d6c9bca4ad7bb7ab0827ce5cb302bcad92644989d0140785de1dc1e` |
| `notes/2026-07-29-c691-cubic-golden-two-graph-replay.py` | 7,918 | `04c95b4d53c276171245f2185ac1a21099d34052a8948438e394bf9cd3f372f4` |
| `notes/2026-07-29-c691-cubic-golden-two-graph.json` | 10,787 | `3d140e589fcbd3f3256ceebbbb22229460ed9e100abdf275c9f67b53b48e969a` |

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | unchanged |
| Paper I v2 | integrate as the bridge joining C690's cubic line and golden continuation algebra |
| Paper II | no dependency |
| Paper III | no imported result; the six-axis marking is replay evidence only |
| C693 | owns concise manuscript integration and cold read |

## Extra-juice and Tao-style closeout

The triangle-product identity upgrades the result six times.  First, the
support cubic is not merely compatible with the golden operator: it
reconstructs its switching class, while the operator reconstructs every
cubic coefficient.
Second, the full determinant pencil shows that the cubic is its unique
nonsymmetric coefficient layer; Jacobi duality derives complementation from
\(B^2=5I\).  Third, its conjugation-odd part recovers the cubic and the
off-diagonal equations of \(B^2=5I\) force the lower signed moments to
vanish.  Fourth, the converse balance equations force the unique pentagonal
switching class and recover \(B^2=5I\) from the cubic alone.  Fifth,
reduction modulo \(2\) makes the conductor defect visible without the
normalized golden coordinate: all cubic signs merge, the symmetry jumps to
\(S_6\), and \(B-I\) becomes rank-one square-zero.  Sixth, the cubic
threefold's six ordinary nodes intrinsically recover the projective
six-axis frame, so the order-\(120\) permutation stabilizer is its full
projective automorphism group.

The structural boundary is equally sharp.  The construction is inevitable
on the six-axis carrier because triangle holonomy is exactly the
switching-invariant information of a signed complete graph.  It gives no
ambient harmonic covariant.  Seeking such a covariant would be a different
Paper III question and is outside this kill test.

## Mystery ledger

- **Relative orientation of the cubic and golden operator:** settled by
  \(c_{ijk}=B_{ij}B_{jk}B_{ki}\), with an explicit inverse up to switching.
- **Why the same outer sign occurs twice:** settled; both are the orientation
  character of the same six-axis two-graph, whose oriented and line
  automorphism groups have orders 60 and 120.
- **Determinantal source of the cubic:** settled; it is the size-three
  principal-minor layer, equivalently the sole nonsymmetric term
  \(-2C_B\) in the diagonal determinant pencil.
- **Vanishing below degree three:** settled conceptually;
  \(\sum_kc_{ijk}=B_{ij}(B^2)_{ij}=0\), and the lower sums follow.
  Hence the cubic descends to the augmentation five-space.
- **Does the cubic itself force the golden operator?** Settled.  The
  two-graph identities reconstruct \(B\) up to switching, pair balance is
  equivalent to \(B^2=5I\), and the gauge-fixed positive graph is a
  pentagon.  There is one switching class.
- **Is the six-axis coordinate carrier extra marking?** Settled
  projectively.  The cubic threefold has exactly six singular points, all
  ordinary nodes, and they form the coordinate projective frame.  Its full
  projective automorphism group is therefore the computed outer \(S_5\).
- **Prime \(2\):** settled on this package; the cubic orientation collapses
  exactly when \(B-I\) becomes square-zero.  Normalization to
  \(\mathbf F_4\) remains unavailable without adjoining \((1+B)/2\).
- **Ambient degree-three/degree-six map:** not supplied and not required.
  The exact evidence gap is an equivariant covariant between the ambient
  harmonic representations, which this six-axis identity does not address.

Vibe check: the bounded kill test now lands more strongly than expected.
The cubic not only recovers the golden operator; its own nodal geometry
recovers the six-axis stage on which that operator acts.
