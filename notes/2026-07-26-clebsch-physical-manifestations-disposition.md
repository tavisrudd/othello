# Clebsch physical-manifestation disposition

**Lane:** `clebsch`

**Date:** 2026-07-26

## Provenance

The user supplied a prior-ChatGPT research report connecting the Clebsch
cubic to degree-six spherical-harmonic order parameters, icosahedral
face-axis modes, and possible materials and engineered-system tests. This
note records its durable mathematical disposition. The cited applied
literature has not yet been audited under the repository literature
conventions; C655 owns that audit.

## Paper III result candidate

Let \(u_e\), \(1\le e\le10\), be the axes through opposite faces of an
icosahedron and let
\[
 L(a)(\omega)=\sum_e a_eP_6(u_e\cdot\omega).
\]
The report gives the exact zonal Gram matrix
\[
 K=\frac1{243}(196I+47J-112A),
\]
where \(A\) is the Petersen adjacency matrix. Its predicted eigenvalues are
\[
 (110/81)^{(1)},\qquad(28/81)^{(5)},\qquad(140/81)^{(4)}.
\]
Thus \(L\) embeds the face-axis permutation module
\(\mathbf1\oplus V_4\oplus V_5\) in \(\mathcal H_6\).

Under the labeling by two-subsets of five points, the Clebsch summand is
the Petersen \((-2)\)-eigenspace
\[
 a_{ij}=y_i+y_j,\qquad\sum_i y_i=0.
\]
For
\[
 F_y(\omega)=\sum_{i<j}(y_i+y_j)P_6(u_{ij}\cdot\omega),
\]
the reported exact integration is
\[
 \frac1{4\pi}\int_{S^2}F_y(\omega)^3\,d\omega
 =
 -\frac{784000}{1247103}\sigma_3(y).
\]
This is the characteristic-zero side of the triangle whose finite side C651
already proves:
\[
 T_{\mathrm{sgn}}|_{V_4}=4\sigma_3\quad\text{over }\mathbf F_{11}.
\]
Because \(11\mid1247103\), these are two realizations of the same integral
invariant cubic line, not reductions of one rational normalization.

## Exact interpretation

The proposed theorem is narrower than saying that the Clebsch cubic is the
ordinary order parameter of a perfect icosahedral cage. The uniform cage
lies in the trivial summand. The Clebsch cubic is the Gaunt/Steinhardt-type
signed cubic on the four-dimensional channel of nonuniform weights on ten
opposite face pairs.

That distinction makes the physical object concrete. For a face-axis
weight vector \(a\), use
\[
 P_{V_4}=\frac{(A-3I)(A-I)}{15}
\]
and form the scale-free signed cubic of \(L(P_{V_4}a)\). Candidate weights
include opposed-face geometric distortion, chemical decoration, and normal
stress.

## Claim boundary

Mathematical target:

- certify the Gram matrix, its spectrum, and the explicit \(V_4\) embedding;
- certify the exact cubic scalar without floating-point representative
  choices;
- independently replay both calculations;
- verify the uniqueness of the invariant cubic and the normalization of the
  standard degree-six Gaunt/Steinhardt observable against primary sources.

Empirical target, outside the current theorem:

- test whether the signed four-channel descriptor adds predictive
  information for rearrangement, yielding, cage lifetime, or nucleation
  after conditioning on standard structural descriptors;
- compare geometric, chemical, and stress weightings;
- treat failure as a clean negative rather than as evidence for an
  application.

No present evidence shows that a material, capsid, nanoparticle, imaging
pipeline, or engineered device realizes the arithmetic \(T_{11}\) torsor.
The paper may state the exact equality of observables after C655, and may
formulate the benchmark as an open problem. It must not claim applied
performance or commercial utility.

## C655 acceptance

C655 passes when the exact harmonic theorem has:

1. a task-owned primary script and compact canonical certificate;
2. an independent implementation;
3. a prose proof separating representation theory from exact integration;
4. a primary-source audit of degree-six bond-orientational invariants and
   the first icosahedral harmonic channel;
5. an explicit normalization map to the standard convention; and
6. a Paper III trust-ledger update with no empirical claim promoted.
