# C925: the adjacent-weight OADP quotient theorem

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Theorem

Let \(K\) be an infinite field, let \(Z\subset\mathbf P(V)\) be a
geometrically integral \(n\)-fold with dense \(K\)-points, and suppose that
tangent projection from \(T_zZ\) at a general \(z\in Z(K)\) is birational to
\(\mathbf P^n\). Let a one-dimensional \(K\)-torus \(L\) act generically
freely on \(Z\) through \(V\).

Over a separable closure, write the projective weight decomposition as

\[
V=\bigoplus_{j\in J}V_j,\qquad J\subset\mathbf Z. \tag{1}
\]

Assume that there is an integer \(a\) and a \(K\)-defined linear subspace

\[
B\supset\mathbf P\!\left(\bigoplus_{j\ne a,a+1}V_j\right) \tag{2}
\]

such that \(V_a,V_{a+1}\ne0\), and for general \(z\) the linear system of
hyperplanes containing \(\langle T_zZ,B\rangle\) has a member whose
restrictions to both \(V_a\) and \(V_{a+1}\) are nonzero. In particular,

\[
\langle T_zZ,B\rangle\ne\mathbf P(V). \tag{3}
\]

Then

\[
\boxed{Z/L\text{ is }K\text{-rational}.} \tag{4}
\]

Condition (2) is intrinsic under descent: the individual weight spaces need
not be \(K\)-defined, provided the span \(B\) is Galois-stable. The last
nonvanishing condition prevents the tangent constraint from killing one of
the two surviving monomials.

## Proof

Choose a general \(K\)-hyperplane

\[
H\supset\langle T_zZ,B\rangle.
\]

By tangent projection,

\[
H\cap Z\dashrightarrow\mathbf P^{n-1} \tag{5}
\]

is birational. On the closure of a general geometric \(L\)-orbit, choose a
torus parameter \(t\). Because \(H\) contains every weight space except the
two in (2), its equation restricts on the open orbit to

\[
c_at^a+c_{a+1}t^{a+1}=t^a(c_a+c_{a+1}t), \tag{6}
\]

with both coefficients nonzero for general \(H\) and general orbit. Equation
(6) has exactly one reduced solution in \(\mathbf G_m\). Thus
\(H\cap Z\dashrightarrow Z/L\) is generically one-to-one. Combining this
with (5) proves (4).

The proof does not require the orbit closure to be normal, a rational normal
curve, or to have every intermediate weight. All unused degree is absorbed
at the toric boundary by (2); adjacency is exactly what leaves one open root.

## Tschinkel--Zhang applications

Let \(Z=\mathbf P(\mathcal U)\subset\mathbf P^{15}\) be the projective Cox
closure of a universal torsor over a quartic del Pezzo surface. Tschinkel--
Zhang's Lemma 3.2 and Theorem 2.4 supply the tangent-projection hypothesis.

1. For the first two type-\(I_1\) sign subtori, the exact weight pattern is
   \(0^8,1^8\). Take \(B=\varnothing\) and \(a=0\). The theorem recovers the
   line-orbit quotient used in the type-\(I_1\) level-four proof.
2. For the full type-\(I_3\) sign subtorus, the weight pattern is
   \(0^2,1^6,2^6,3^2\). The Galois-stable space

   \[
   B=\mathbf P(V_0\oplus V_3)
    =\mathbf P\langle E_3,E_4,L_{34},Q\rangle
   \]

   removes all but the adjacent weights \(1,2\). The theorem recovers the
   uniform level-four quotient. The exact rank-three certificate includes a
   tangent covector at \((a,b,z_1,z_2,z_3)=(2,5,1,3,7)\) which vanishes on
   \(B\) and is nonzero on both middle blocks; openness verifies the theorem's
   generic nonvanishing hypothesis.

Consequently Tschinkel--Zhang's quartic-del-Pezzo OADP construction is one
application of a general quotient mechanism: any OADP Cox closure with an
adjacent two-weight window and a rational residual torus inherits the
corresponding stable-rationality bound.

## Why the theorem stops at the next level

For a rank-two torus, the natural type-\(I_1\) orbit polytopes are a square,
two rectangles, and a hexagon. A codimension-two analogue would need a
Galois-stable unimodular simplex window. The exact rank-two exhaustion shows
that every available boundary-edge orbit forces open degree divisible by two
or three. Thus the adjacent-weight theorem explains the level-four success
without silently implying level three or level two.

## Evidence and scope

- Type-\(I_1\) weights and residual torus:
  `notes/cubic-threefolds-tasks/c925-i1-level4-linear-slice-check.py` and the
  associated CARAT replay.
- Full type-\(I_3\) weights, stable boundary space, and residual torus:
  `notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py` and the
  associated CARAT replay.
- Rank-two cutoff:
  `notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion.py`.
- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1. **Read depth:
  partial** — Theorem 2.4, Lemma 3.2, Theorem 3.4, and Sections 4--5. PDF
  SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

This note proves a general quotient lemma. It does not improve the current
\(2\le s(X)\le4\) interval by itself.

**Resume line:** go C925 cubic-threefolds — use the adjacent-weight OADP
theorem as the general level-four provider; level three requires an intrinsic
rank-two quotient because no descended unimodular window exists.
