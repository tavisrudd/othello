# C907 intrinsic Seifert transport without a common collar

**Lane:** `clebsch`

**Status:** theorem-grade formal mechanism.  Once the nearby value object is a
four-section Morse local system with no braid, its directed Seifert form is
transported intrinsically by the `j_! -> j_*`, duality, and `can/var` package.
A common boundary compactification or collar is not logically required.
For the toric pilot this reduces the pairing gate to the already isolated
proper nearby-cycle/direct-image and local-orientation comparisons.

## Intrinsic pairing package

Let `j:U -> X` be an oriented smooth complex `n`-fold open in a proper space
over a parameter disk `Delta` and value disk `Omega`; assume constructibility
and fix the proper compactification `bar a`.  Put

\[
 K_!=R\bar a_*j_!A_U,
 \qquad K_*=R\bar a_*Rj_*A_U,
 \qquad A=\mathbf Z[1/6].
 \tag{1}
\]

The natural map `j_!A -> Rj_*A`, Poincare--Verdier duality

\[
 D(j_!A_U)\simeq Rj_*A_U[2n](n),
 \tag{2}
\]

and the canonical/variation maps for value vanishing cycles determine the
usual relative intersection and Seifert pairings after fixing the complex
orientation convention.  Fix also one value-loop/path-star convention and
one `can/var` normalization.  This package is intrinsic to the open map: if
`p:X' -> X` is proper over both parameter and value maps, identifies the same
open by `p o j'=j`, and is an isomorphism on `U`, then functorial composition
gives

\[
 Rp_*j'_!A\simeq j_!A,
 \qquad Rp_*Rj'_*A\simeq Rj_*A,
 \tag{3}
\]

and proper pushforward commutes with duality, nearby/vanishing cycles, and
`can/var`.  Thus (3) transports the whole pairing package, not just its
support.  No pairing is assigned separately to exceptional strata.

## Nonbraiding Morse transport

Assume the nearby value vanishing-cycle object over `Delta` is a disjoint
union of `r` nondegenerate Morse sections, their critical values remain
distinct in the interior of `Omega`, and a distinguished path star from a
regular boundary value varies without braid.  Parameterized holomorphic Morse
theory makes the oriented local groups rank-one local systems.  Naturality of
the package above makes every entry of their intersection and Seifert matrices
a locally constant element of `A`.  Since `Delta` is contractible, the ordered
matrix is equal to its central value.

Consequently, if the central function is a Thom--Sebastiani sum

\[
 f_Q(y)+ZU,
 \tag{4}
\]

and the transverse `ZU` thimble is oriented with self-Seifert pairing `+1`,
the transported four-thimble matrix is exactly the `P^3` matrix

\[
 \begin{pmatrix}
 1&4&10&20\\
 0&1&4&10\\
 0&0&1&4\\
 0&0&0&1
 \end{pmatrix}.
 \tag{5}
\]

The even double-suspension shift contributes no extra sign in this
orientation convention.

## C907 scope

The order-zero proper-support theorem supplies the four-section support and
rank.  The local residual calculation supplies nondegenerate sections with
values

\[
 4a-a^2\delta^2+O(\delta^3),\qquad a^4=Q,
 \tag{6}
\]

so their values remain distinct and admit a nonbraiding path star after
shrinking `Delta`.  Therefore (5) follows once the assumed proper
nearby-cycle/direct-image comparison identifies the intrinsic nearby object
with these normalized local systems and their complex orientations.  That is
strictly weaker than constructing a common exterior collar.

This lemma does not yet give the integral residual Orlov/Gamma identification,
the hyperplane action, or the positive-order Rees extension.  It identifies
the directed internal four-thimble form once the nearby comparison is made.

## EJ/TT and mystery ledger

- **EJ:** the same multi-model proper descent used for support also preserves
  the intrinsic `j_! -> j_*` and `can/var` data; exceptional-stratum pairings
  never need to be compared.
- **TT:** an integral pairing is locally constant, so after no-braid and
  orientation are fixed its entire matrix is determined at the central
  Thom--Sebastiani fibre.
- **Settled:** common-collar independence of the Seifert package and the
  formal transport from the central `P^3+ZU` matrix.
- **Open:** the concrete proper nearby-cycle/direct-image and orientation
  identification, followed by the hyperplane-equivariant integral Orlov/Rees
  comparison.
