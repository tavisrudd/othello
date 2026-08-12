# C909 — fixed-data modular/period intersection dichotomy

Date: 2026-08-12  
Status: bounded TT/EJ mathematical closeout; no manuscript, PDF, mirror,
Lean, or commit change

## Verdict

There is one further honest theorem forced by the fixed-data moduli picture:
for each fixed finite-etale graph datum \(\tau\), the intersection of its
modular graph curve with the cubic intermediate-Jacobian locus is either
zero-dimensional or contains a shared curve component. In the shared case,
the normalization of the cubic component is a finite quotient of the
normalization of the marked modular graph curve; if the graph-to-\(\mathcal
A_5\) map is generically injective, the two normalizations agree.

This is a useful rigidity/dichotomy proposition, but its proof is elementary
intersection theory plus cubic Torelli. It is not a new classification of the
intersection and is not an Annals-level headline without an actual
classification of which \(\tau\) give the shared case.

## 1. Fixed-data setup

Fix \(\tau\), including the finite list of primes/depths, level structure on
the source elliptic curve, and marked self-adjoint finite-etale graph slopes.
After adding enough level and removing CM/boundary points, let
\[
 Y_\tau\longrightarrow\mathcal A_5
\]
be the resulting normal modular graph curve (or a connected component of
the finite graph-packet cover over the modular curve). Its map is
nonconstant whenever the elliptic source varies non-isotrivially.

Let
\[
 j:\mathcal C\longrightarrow\mathcal A_5
\]
be the period map from the smooth cubic-threefold moduli stack on the
generic automorphism-free locus. Strong Torelli and the known local
period-map statement make \(j\) a locally closed immersion there. Define
\[
 Z_\tau=\mathcal C\times_{\mathcal A_5}Y_\tau.
\]
This is the fixed-data marked separation locus. The all-primes/all-depths
union is only a countable union of these finite-type loci and must not be
treated as one algebraic subvariety.

## 2. Finite-or-shared-component theorem

Let \(\overline Y_\tau\) and \(\overline{\mathcal C}\) be suitable
compactifications/closures in a fixed compactification of \(\mathcal A_5\),
and discard components supported entirely at the boundary. Then every
irreducible component of \(Z_\tau\) is either zero-dimensional or maps
dominantly to a one-dimensional component of \(Y_\tau\). Equivalently:

* if \(Y_\tau\) is not contained in the cubic period image, its intersection
  with that image is finite after compactification (hence \(Z_\tau\) is
  finite away from boundary and stack multiplicity);
* if \(Z_\tau\) has a positive-dimensional component, the corresponding
  modular graph curve image is contained in the cubic period image, and the
  cubic family is modularly parameterized by that graph curve.

The proof is only the dimension theorem for a nonconstant map from a curve:
the image of \(Y_\tau\) is a curve, and a positive-dimensional closed
intersection with the cubic image contains a curve component of that image.
Chevalley gives constructibility before compactification; properness gives
the finite conclusion after closure. No new Hodge or quantum input occurs.

This dichotomy is the strongest unconditional “inevitability” statement
available from the two moduli maps. It rules out language suggesting that
every modular Hecke curve should produce a cubic family. Generic fixed data
produce at most finitely many cubic points unless containment is proved.

## 3. Normalization and rigidity in the shared case

Suppose \(Y_{\tau,0}\) is a normal component whose image is contained in the
cubic period locus, and let \(N_\tau\) be the normalization of its common
image. The induced maps are finite on the generic locus:
\[
 Y_{\tau,0}\longrightarrow N_\tau
 \longleftarrow \widetilde{\mathcal C}_{\tau,0}.
\]
Here \(\widetilde{\mathcal C}_{\tau,0}\) is the normalization of the
corresponding cubic-moduli component. Since \(j\) is generically injective by
Torelli, the right-hand map is birational (and becomes an isomorphism after
normalization under the usual automorphism-free hypotheses). Thus the cubic
component is a finite image of the marked modular graph curve; a group
quotient should not be asserted unless a deck-group action is constructed. If
the graph map \(Y_{\tau,0}\to\mathcal A_5\) is generically injective, then
\[
 \widetilde{\mathcal C}_{\tau,0}\simeq Y_{\tau,0}\simeq N_\tau.
\]

This is a genuine rigidity statement: once a fixed graph modular curve is
known to lie in the cubic period locus, the cubic family has no independent
period parameter. But it does not determine the modular curve, its degree,
or its boundary normalization. Those require a separate calculation of the
graph map and its generic stabilizer.

## 4. What this says about the A5 pencil

The existing A5 argument proves a non-isotrivial one-dimensional cubic
family and a fibrewise finite graph packet. To promote “the A5 pencil is a
component of \(Z_\tau\)” to the stack theorem above, one must print the
following modest globalization step:

1. globalize one elliptic quotient (or the required common elliptic source)
   over the smooth pencil, using the relative Fano surface/Albanese;
2. trivialize the finite local graph data after a finite etale base change;
3. form the universal quotient and descended polarization over that cover;
4. obtain the algebraic map from the resulting finite cover of the pencil
   to \(Y_\tau\).

The existing finite-sub-local-system statement supplies the local graph
constancy, but by itself is not a printed modular-stack morphism. Once the
four steps are supplied, non-isotriviality and the period-map immersion imply
that the A5 family is a shared one-dimensional component for the relevant
fixed \(\tau\), not merely a collection of fibrewise points.

The finite graph-packet cover also gives the clean modular-resolvent
description: the A5 two-primary fibre has
\[
 \mathbf P^1(\mathbf F_4)
 =\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\},
\]
so the three rational graph choices and the exotic degree-two orientation
cover are finite etale data over the modular curve. This is a resolvent
algebra, not an explicit modular polynomial.

## 5. New versus formal content

Formal consequences:

* finite-or-shared-component dichotomy for each fixed \(\tau\);
* finite normalization maps and the Torelli rigidity statement;
* constructibility for an open fixed-level stack and countability of the
  unrestricted union.

Potentially material but not yet proved in the epilogue:

* the relative elliptic quotient/graph globalization needed to place the A5
  pencil in one fixed \(\mathscr S_\tau\);
* the generic degree and normalization of the A5 modular graph map;
* classification of all \(\tau\) for which containment occurs;
* any second cubic shared component.

Thus the theorem is worth adding as a precise structural proposition if the
paper wants the word “locus,” but it should not be sold as a classification.
It makes the architecture sharper: the cycle detector is supported on a
countable union of fixed modular curves, while the quantum detector is
universal on the cubic period locus; a positive-dimensional meeting is a
rigid modular coincidence, and otherwise only finitely many cubic points
occur at that fixed datum.

## Bottom line

Use the fixed-\(\tau\) finite-or-shared-component proposition as the strongest
honest unity upgrade. State the A5 pencil as a shared component only after its
marked modular lift is constructed; otherwise call it a verified geometric
family with fibrewise graph data. Do not infer further components, generic
nonemptiness, or an explicit modular resolvent from dimension and Torelli
alone.
