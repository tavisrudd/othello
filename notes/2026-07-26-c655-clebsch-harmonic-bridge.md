# C655 Clebsch harmonic bridge

**Lane:** `clebsch`

**Date:** 2026-07-26

## Result

The ten axes through opposite faces of an icosahedron define an exact
\(A_5\)-equivariant embedding
\[
 L:\mathbf R^{10}\longrightarrow\mathcal H_6,\qquad
 L(a)=\sum_ea_eP_6(u_e\cdot-).
\]
If \(A\) is the Petersen adjacency matrix on those axes, its zonal Gram
matrix is
\[
 K=\frac1{243}(196I+47J-112A).
\]
The eigenvalues on
\(\mathbf1\oplus V_4\oplus V_5\) are
\[
 \frac{110}{81},\qquad\frac{140}{81},\qquad\frac{28}{81},
\]
so \(L\) is injective.

Label the axes by the two-subsets of five points. The Clebsch four-space is
the Petersen \((-2)\)-eigenspace
\[
 a_{ij}=y_i+y_j,\qquad\sum_i y_i=0.
\]
For the corresponding harmonic
\[
 F_y(\omega)=\sum_{i<j}(y_i+y_j)P_6(u_{ij}\cdot\omega),
\]
the exact cubic is
\[
 \frac1{4\pi}\int_{S^2}F_y^3
 =
 -\frac{784000}{1247103}\sigma_3(y).
\]
Thus the Clebsch cubic is exactly the degree-six Gaunt cubic restricted to
the icosahedral four-channel, up to the displayed normalization.

In the orthonormal Condon--Shortley convention,
\[
 \begin{pmatrix}6&6&6\\0&0&0\end{pmatrix}
 =-\frac{20}{\sqrt{46189}},
\]
and the standard unnormalized Steinhardt cubic satisfies
\[
 \int_{S^2}F^3
 =-\frac{130}{\sqrt{3553\pi}}W_6(F).
\]
For the witness \(y=(4,-1,-1,-1,-1)\), the normalized four-channel
descriptor is
\[
 C_4=-\frac{120\sqrt{273}}{3553}.
\]

This closes the mathematical signed-tensor--Clebsch--\(W_6\) triangle at
the level of the common invariant line. C651 gives the finite identity
\(T_{\mathrm{sgn}}|_{V_4}=4\sigma_3\) over \(\mathbf F_{11}\); C655 gives
the characteristic-zero harmonic identity. Since \(11\) divides the
rational Gaunt denominator, this is not a reduction of one rational scalar.

## Proof

The face-axis module is
\(\mathbf1\oplus V_4\oplus V_5\), while
\(\mathcal H_6|_{A_5}\) is
\(\mathbf1\oplus V_3\oplus V_4\oplus V_5\).
Exact evaluation of \(P_6(u_e\cdot u_f)\) gives the Gram formula. The
Petersen spectrum gives positivity and injectivity.

For \(a_{ij}=y_i+y_j\),
\[
 (Aa)_{ij}
 =
 \sum_{\{k,l\}\cap\{i,j\}=\varnothing}(y_k+y_l)
 =-2(y_i+y_j),
\]
which identifies the four-space.

The map \(L|_{V_4}\) is \(A_5\)-equivariant, so its cubic integral is an
\(A_5\)-invariant cubic on \(V_4\). There is one such line: before
restriction, the degree-three orbit sums on the five-point permutation
space have exponent types \(3\), \(2+1\), and \(1+1+1\); after imposing
\(\sum y_i=0\), only the \(e_3\), equivalently \(\sigma_3\), line remains.
Evaluation at the displayed witness gives
\[
 \left\langle F_y^2\right\rangle=\frac{2800}{351},
\quad
 \left\langle F_y^3\right\rangle=-\frac{15680000}{1247103},
\quad
 \sigma_3(y)=20.
\]
The Gaunt formula and the factorial formula for the zero-row Wigner
\(3j\)-symbol give the exact conversion to \(W_6\).

## Reproduction

Run from `/home/tavis/src/othello`:

```text
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch.py --check
python3 papers/clebsch-passages/verification/evidence/harmonic_clebsch_replay.py
sha256sum -c papers/clebsch-passages/verification/evidence/harmonic_clebsch.sha256
```

Expected terminal lines:

```text
harmonic Clebsch certificate: OK
independent harmonic replay: OK (10 axes, Petersen spectrum 3^1 1^5 (-2)^4, Gaunt scalar -784000/1247103)
```

Artifacts:

| file | bytes | SHA-256 |
|---|---:|---|
| `harmonic_clebsch.py` | 7832 | `d93f4241d8b55194e7cd115bb622511bb83656c2c722ce8336bd0c8e6ec0b1a3` |
| `harmonic_clebsch_replay.py` | 7931 | `08a4ce779a5e9e80e2e75ab857ea50287298dd7135446e13586b3cad68cefd2f` |
| `harmonic_clebsch.json` | 8088 | `70948429b7b5dd9780a10023176f556f74246c7a4054f4b84a7b6b14bdbb33a8` |
| `harmonic_clebsch.sha256` | 405 | checksum manifest |

The primary generator uses sparse exact polynomials over
\(\mathbf Q(\sqrt5)\). It removes the imported script's floating-point
representative choice: antipodal axes are deduplicated algebraically, and
the even polynomial \(P_6\) needs no orientation.

The replay uses a separate quadratic-field type and a distinct multinomial
polynomial expansion. It reconstructs the axes, Gram matrix, Petersen
adjacency, minimal polynomial, spherical moments, and Wigner factorial
formula. Both routes use rational arithmetic only.

## Source audit

Opening read-depth summary: **zero sources were read at full-text depth;
three were read partially at full-text level.** No novelty or absence claim
is made.

1. P. J. Steinhardt, D. R. Nelson, and M. Ronchetti,
   *Bond-Orientational Order in Liquids and Glasses*,
   Physical Review B 28 (1983), DOI
   `10.1103/PhysRevB.28.784`.
   Read depth: **partial**; published APS PDF, introduction, Section II,
   equations (1.1)--(2.6), Figure 2, and Table I. Cached key
   `10.1103/PhysRevB.28.784`, SHA-256
   `0efaad674f48c98b716e6732c63e2b04b0d5339c0844c733e72d09d58d041fc5`.
   This source defines the quadratic and Wigner-\(3j\) cubic
   bond-orientational invariants, uses them for cluster-shape
   discrimination, and records the first nonzero perfect-icosahedron
   channel at \(l=6\).
2. P. J. Steinhardt, D. R. Nelson, and M. Ronchetti,
   *Icosahedral Bond Orientational Order in Supercooled Liquids*,
   Physical Review Letters 47 (1981), DOI
   `10.1103/PhysRevLett.47.1297`.
   Read depth: **partial**; published APS PDF, abstract and the
   order-parameter definition and numerical-result discussion.
   Cached key `10.1103/PhysRevLett.47.1297`, SHA-256
   `762f38490ed9b29e6bec0d67113fc3e35d4493759ca3dbfa5798cae04f187eef`.
   This source supplies the original supercooled-liquid use and the
   statement that the first nonzero bond harmonic of the 13-atom
   icosahedral cluster occurs at \(l=6\).
3. Nigel Hitchin, *Spherical harmonics and the icosahedron*,
   arXiv:0706.0088.
   Read depth: **partial**; arXiv PDF, Sections 1--3 and 9--10.
   Cached key `arXiv:0706.0088`, SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
   This source supplies the four-dimensional Clebsch space inside harmonic
   cubics, the ordered-icosahedron cover, and the restriction of Hitchin's
   sextic invariant to \(\sigma_3^2\). It does not state the degree-six
   face-axis Gaunt restriction proved here.

The Steinhardt normalization uses spherical-harmonic coefficients and
Wigner \(3j\)-symbols. The manuscript's integral formula is connected to it
by the standard Gaunt identity, proved explicitly at \(l=6\) in the
manuscript. The ordinary perfect-cage \(W_6\) lies in the trivial
icosahedral summand; the new equality concerns the nonuniform
four-dimensional face-axis channel.

## Trust boundary

The exact theorem is mathematical. It does not show that a real liquid,
glass, capsid, nanoparticle, imaging pipeline, or engineered device
populates two physically distinct Clebsch sectors. Candidate geometric,
chemical, and stress weights define a falsifiable descriptor, but predictive
utility requires atomistic or experimental data.

The cubic is invariant under rotational \(A_5\). Its sign flips under the
outer-odd operation in the sign-twisted extension, not under an ordinary
rotation of a uniformly weighted cage. A physical application must specify
that decorated state and operation.

## `ej` + `tt` closeout

The cheap upgrade was the exact normalization to the standard \(W_6\), not
only proportionality to an unnamed Gaunt cubic. The same pass extracted the
closed-form normalized witness and exposed the physical-symmetry boundary.

The strongest question prompted by the theorem is empirical: does the
four-channel sign add information after conditioning on ordinary
\(Q_6\), \(\widehat W_6\), density, energy, composition, and a rich
descriptor such as SOAP or ACE? This is not a paper-facing claim without a
benchmark dataset and a separately allocated task.

## Mystery ledger

- **Settled:** the imported floating-point sign was unnecessary; exact
  antipodal deduplication gives the same axes and moments.
- **Settled:** the Clebsch cubic is an exact restriction of the standard
  degree-six Gaunt/\(W_6\) cubic, with an explicit normalization.
- **Settled:** the physical object is a nonuniform \(V_4\) decoration of
  ten opposite face pairs, not the ordinary uniform icosahedral amplitude.
- **Open under C653:** whether the denominator
  \(1247103=3^3\cdot11\cdot13\cdot17\cdot19\) has an intrinsic integral
  interpretation compatible with the arithmetic Hitchin model.
- **Open, unallocated empirical program:** whether geometric, chemical, or
  stress versions of \(C_4\) have predictive information beyond standard
  structural descriptors.
- **No further task-owned mathematical mystery remains:** the exact
  harmonic embedding, cubic scalar, and standard normalization are closed.
