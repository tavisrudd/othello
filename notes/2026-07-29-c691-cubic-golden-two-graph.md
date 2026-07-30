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
the switching gauge, enumerates the 60/120 automorphism groups, and checks
the mod-\(2\) degeneration.  The replay reads the two upstream certificates
directly and independently recomputes the forward triangle identity and
inverse gauge identity.  The human two-graph argument proves switching
invariance and inverse reconstruction; the programs fix the task-specific
marking and coefficients.

| input | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c690-rigidity-fingerprints.json` | 6,076 | `dc973a8751ece1207b1a1a84d336b31284e4cf8cbea69830236343663b45f4d6` |
| `notes/2026-07-26-c682-transvectant-bridge.json` | 19,904 | `e4704b1de4c042a8ed4b1876edebefa919ab562ebe0417c2d835e0e9cc403161` |

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c691-cubic-golden-two-graph.py` | 10,157 | `09e2fc9bab8db3f0824c4c6cab0d2dada2b3eeda92a42ec86aa7471e0fbee131` |
| `notes/2026-07-29-c691-cubic-golden-two-graph-replay.py` | 2,798 | `f927cca7c8103df6bf77c23b65f3bda9e4d891ad3feda45babe6865a36a871c6` |
| `notes/2026-07-29-c691-cubic-golden-two-graph.json` | 5,481 | `4cc78793c4a7e651f2151a284a41f02412ccaf75e19f732a9be8d2883fc13a29` |

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | unchanged |
| Paper I v2 | integrate as the bridge joining C690's cubic line and golden continuation algebra |
| Paper II | no dependency |
| Paper III | no imported result; the six-axis marking is replay evidence only |
| C693 | owns concise manuscript integration and cold read |

## Extra-juice and Tao-style closeout

The triangle-product identity upgrades the result twice.  First, the support
cubic is not merely compatible with the golden operator: it reconstructs its
switching class, while the operator reconstructs every cubic coefficient.
Second, reduction modulo \(2\) makes the conductor defect visible without
the normalized golden coordinate: all cubic signs merge, the symmetry jumps
to \(S_6\), and \(B-I\) becomes rank-one square-zero.

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
- **Prime \(2\):** settled on this package; the cubic orientation collapses
  exactly when \(B-I\) becomes square-zero.  Normalization to
  \(\mathbf F_4\) remains unavailable without adjoining \((1+B)/2\).
- **Ambient degree-three/degree-six map:** not supplied and not required.
  The exact evidence gap is an equivariant covariant between the ambient
  harmonic representations, which this six-axis identity does not address.

Vibe check: the bounded kill test lands positively and cleanly.  The two
Paper I v2 propositions are not adjacent coincidences; they are mutually
recoverable presentations of one integral two-graph.
