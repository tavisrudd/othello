# C682 characteristic-zero maximal-subgroup mate correspondence

## Outcome

The \(1+5+6+10\) Bockstein section has a single intrinsic
characteristic-zero predecessor.  It is the normalizer-mate
correspondence on the open icosahedral orbit, and it does not use a
divided transvectant, a lift modulo \(11^2\), or the characteristic-\(11\)
rank-drop pencil.

Let \(k\) be an algebraically closed field of characteristic zero, put
\[
 G=\operatorname{PGL}_2(k),
 \qquad A\simeq A_5\subset G,
 \qquad \mathcal M^\circ=G/A,
\]
and regard \(\mathcal M^\circ\) as the open icosahedral orbit in the
Mukai--Umemura threefold.  For a representative
\[
 H\in\{A_4,D_5,S_3\}
\]
of a maximal-subgroup class in \(A\), its ambient normalizer satisfies
\[
\begin{array}{c|c|c}
H&N_G(H)&N_G(H)/H\\ \hline
A_4&S_4&C_2\\
D_5&D_{10}&C_2\\
S_3=D_3&D_6&C_2.
\end{array}
\]
Here \(D_n\) has order \(2n\).  If \(\tau_H\) belongs to the nonidentity
coset of \(N_G(H)/H\), define
\[
 \mathcal C_H=G/H,\qquad
 p_H(gH)=gA,\qquad
 q_H(gH)=g\tau_HA.
\]
The second map is well defined because \(\tau_H\) normalizes \(H\), and
it is independent of the representative of the nonidentity coset.
Moreover \(\tau_H^2\in H\), so
\[
 \iota_H(gH)=g\tau_HH
\]
is an involution with \(p_H\iota_H=q_H\) and
\(q_H\iota_H=p_H\).

Consequently
\[
 \boxed{\quad
 \mathcal S=
 \Delta_{\mathcal M^\circ}
 \sqcup\mathcal C_{A_4}
 \sqcup\mathcal C_{D_5}
 \sqcup\mathcal C_{S_3}
 \quad}
\]
is a symmetric finite-etale correspondence of degree
\[
 1+[A:A_4]+[A:D_5]+[A:S_3]=1+5+6+10=22
\]
over either projection.  Its residual degree-\(21\) part is the requested
maximal-subgroup mate correspondence.

## Why the mate is unique

The construction has a formulation with no chosen normalizer element.
For every maximal \(H<A\), there are exactly two icosahedral subgroups of
\(G\) containing \(H\):
\[
 A,\qquad A_H=\tau_HA\tau_H^{-1}.
\]

Indeed, all icosahedral subgroups of \(G\) are conjugate.  If
\(B=gAg^{-1}\) contains \(H\), conjugating the preimage of \(H\) inside
\(A\) by an element of \(A\) reduces \(g\) to an element of \(N_G(H)\).
The quotient \(N_G(H)/H\) has two elements, so only the two displayed
overgroups occur.  They are distinct: \(A\) is self-normalizing in \(G\),
\(N_A(H)=H\), and \(\tau_H\notin H\).  Their intersection is exactly
\(H\), since \(H\) is maximal in \(A\).

This also proves that the construction is intrinsic.  The mate of a
marked icosahedron at an \(H\)-marking is simply the unique other
icosahedron containing that full rotation subgroup.  In particular:

- an \(A_4\)-marking produces the other icosahedron containing the same
  tetrahedral rotation group;
- a \(D_5\)-marking produces the other icosahedron containing the same
  full fivefold dihedral group, selecting one point canonically from
  Hitchin's larger common-axis curve; and
- an \(S_3\)-marking produces the other icosahedron containing the same
  full opposite-face dihedral group.

The normalizer table is elementary.  The centralizer of a noncyclic
finite subgroup of \(G\) is trivial.  For \(A_4\), conjugation embeds the
normalizer into
\(\operatorname{Aut}(A_4)\simeq S_4\), while the octahedral \(S_4\)
realizes equality.  For \(D_n\), \(n=3,5\), put its characteristic cyclic
subgroup in the form \(z\mapsto\zeta_nz\) and a reflection in the form
\(z\mapsto1/z\).  A normalizing dilation has \(a^2\in\mu_n\); together
with inversion this gives \(D_{2n}\), of order \(4n\).  Finally \(A\) is
self-normalizing because the classification of finite subgroups of
\(\operatorname{PGL}_2\) has no finite overgroup realizing the outer
automorphism of \(A_5\).

## Descent and the classical traces

The correspondence is conjugacy-invariant.  The three subgroup classes
are distinguished by their orders and are preserved by every
automorphism of \(A_5\).  Thus the three pieces and their union descend
with any characteristic-zero form of the marked icosahedral homogeneous
space.  Applied to the rational Mukai--Umemura open orbit, this gives the
correspondence over its rational descent datum; no individual
\(\mathbf Q(\sqrt5)\)-chart is incorrectly promoted to a rational
inclusion.

On the golden chart, the three components recover the already identified
classical objects:

- the five \(A_4\) mates are the tetrahedral parents whose common
  annihilator lines are the Clebsch frame \(q_i\);
- the six \(D_5\) mates are the nonradial common-fivefold-axis parents,
  whose traces are Hitchin's exceptional Schläfli six \(E_i\); and
- the ten \(S_3\) mates are the opposite-face-axis parents over
  \(q_\alpha+q_\beta\), not the Eckardt differences
  \(q_\alpha-q_\beta\).

The new point is not another orbit count.  The doubled ambient
normalizers explain why each maximal-subgroup marking has one and only
one nontrivial mate, uniformly in all three cases.

## Exact characteristic-\(11\) comparison

The exact certificate enumerates all \(1320\) elements of
\(\operatorname{PGL}_2(\mathbf F_{11})\), reconstructs the marked
\(A_5\), and derives representatives of its three maximal-subgroup
classes.  Their ambient normalizer orders are respectively
\[
 24,\qquad20,\qquad12.
\]
For every type, every element of the nonidentity normalizer coset sends
the \(A_5\)-fixed rank-four kernel to the same mate, sends that mate back
to the base kernel, and gives a point with stabilizer exactly \(H\).
The three representatives land in the existing rank-four orbits of sizes
\[
 5,\qquad6,\qquad10.
\]
By \(A_5\)-equivariance, the complete reduced \(22\)-point Bockstein
section is therefore exactly the finite normalizer star
\[
 1\sqcup A_5/A_4\sqcup A_5/D_5\sqcup A_5/S_3.
\]
This comparison identifies the finite shadow; the characteristic-zero
correspondence itself is the preceding group-theoretic construction and
does not depend on the certificate.

## Cheap upgrade: an intrinsic \((6_5,10_3)\) rank equation

The same exact data closes the earlier finite-section incidence question.
For a \(D_5\) mate with kernel plane \(U_D\) and an \(S_3\) mate with
kernel plane \(U_S\), define
\[
 D\sim S
 \quad\Longleftrightarrow\quad
 \dim(U_D\cap U_S)=1.
\]
Equivalently,
\[
 \dim(U_D^\perp\cap U_S^\perp)=2.
\]
Among the \(6\cdot10=60\) pairs, the rank condition selects exactly
thirty: every \(D_5\) row has degree five and every \(S_3\) column has
degree three.  It therefore realizes the classical
\((6_5,10_3)\) pentagon--edge incidence directly on the kernel section,
without importing labels from the five-letter model.

This last statement is proved for the characteristic-\(11\) section.
Persistence of the same kernel-rank equation on a chosen
characteristic-zero operator realization is a separate gate; the
normalizer-mate correspondence does not require it.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-maximal-subgroup-mates.py --check
python3 ../notes/2026-07-28-c682-maximal-subgroup-mates-replay.py
```

The primary checker imports the committed rank-four kernels but
independently enumerates the ambient projective group, derives the three
normalizers, acts on the kernels, and computes the \(6\)-by-\(10\)
intersection matrix.  The replay reimplements projective matrix
arithmetic, symmetric-power action, row-space comparison, ambient
normalizer enumeration, and the incidence-rank test without importing
the generator.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-maximal-subgroup-mates.py` | 13003 | `7d8a5cf6cb6a9c1e612bc8b5231c09a17a976dfd63e153f2d52ddebe308813d5` |
| `2026-07-28-c682-maximal-subgroup-mates-replay.py` | 5904 | `13b4208c62530da184dbf66ef37912a17f338ca7607dc76a41c00d0c0aa1c521` |
| `2026-07-28-c682-maximal-subgroup-mates.json` | 17043 | `c62915c4fb9f1c947618779a1841e166ccd42972a12ae0936d672f0af7afaccc` |

The computation does not prove the characteristic-zero finite-subgroup
classification, the descent statement, or Hitchin's geometric
identifications; those are the human parts of the proof.  Conversely the
human normalizer proof does not certify that the previously constructed
mod-\(11\) rank-drop points are its exact finite shadow; that is the
certificate's role.

## Source and claim boundary

Hitchin's two cited icosahedron papers remain the sources for the open
\(\operatorname{PGL}_2/A_5\) orbit, the common-axis curves, the exceptional
Schläfli six, and the opposite-face interpretation.  The only additional
input here is the classical classification of finite subgroups of
\(\operatorname{PGL}_2\) and the displayed elementary normalizer
calculation.  No novelty or priority claim is made, and Paper III remains
closed.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** one symmetric characteristic-zero correspondence produces
  all \(A_4,D_5,S_3\) mate components, with degrees \(5,6,10\).
- **Closed:** the construction is choice-free: a maximal subgroup has
  exactly two icosahedral overgroups, the base and its mate.
- **Closed:** the full \(D_5\), rather than only its fivefold axis, is the
  datum that selects the distinguished point from the common-axis curve.
- **Closed by `ej`:** the characteristic-\(11\) four-orbit section is
  exactly the finite normalizer star.
- **Closed by `ej`:** kernel-plane intersection gives an intrinsic rank
  equation for the finite \((6_5,10_3)\) incidence.
- **Settled by `tt`:** “share a maximal subgroup” alone would have been a
  tautological relabeling.  The doubled-normalizer theorem supplies the
  missing existence, uniqueness, involution, and descent mechanism.
- **Still open:** produce a characteristic-zero transvectant/operator
  realization of \(\mathcal S\) and decide whether the
  \(D_5\)--\(S_3\) kernel-rank equation survives there.  The exact gate is
  an explicit characteristic-zero normalizer-mate kernel calculation or
  a conceptual rank argument.
- **Still open:** determine whether the complementary Schläfli six is a
  second natural correspondence component or only the classical outer
  automorphism of the Clebsch surface.

C682 remains open; completion is the user's decision.
