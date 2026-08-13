# C907 — red team of the opposite via rigidity and diagonal methods

Date: 2026-08-13

Status: bounded attack complete.  It lands one unconditional generic theorem
from new literature and one exact no-go for the naive Mori-fibre-rigidity
route.  Very general cubic threefolds are now known to be stably irrational.
For every smooth cubic, the constant fibration
`X x P^2 -> P^2` lies outside all available rigidity theorems, violates their
twisting hypotheses maximally, and already admits explicit relative Sarkisov
links.  A Gold proof by this route would require a new relative pliability
classification, not a routine Noether--Fano inequality.

## 1. The opposite is impossible for a very general cubic

Engel--de Gaay Fortman--Schreieder, arXiv:2507.15704v3, Theorem 1.3 prove that
for a very general smooth cubic threefold `X`, every curve on its intermediate
Jacobian has class in

\[
 2\mathbf Z\,\frac{\Theta^4}{4!}.
\]

Their Corollary 1.4 combines this parity with Voisin's decomposition-of-the-
diagonal criterion to show that `X` is not stably rational.  Thus

\[
 X\times\mathbf P^m\not\dashrightarrow\mathbf P^{m+3}
 \quad\text{for every }m
\]

for a very general `X`.  The proof uses a maximal degeneration of the
10-nodal Segre cubic whose monodromy matroid is the noncographic regular
matroid `R_10`.  The checkable family-level input is their Definition 4.1 and
Theorem 1.6; the excluded-minor test appears in Theorems 7.1 and 7.6.

This result does not specialize to an arbitrary named cubic.  Maximal
Mumford--Tate group and Picard rank one do not decide algebraicity of
`Theta^4/4!`: it is already a Hodge class on every fibre.  A curve on a
special fibre need not spread to the geometric generic fibre.

Voisin's Corollary 4.4 gives the exact boundary for every smooth cubic:

\[
 X\text{ universally }CH_0\text{-trivial}
 \iff \frac{\Theta^4}{4!}\text{ is algebraic on }J(X).
\]

Theorem 4.5 constructs nonempty special loci of codimension at most three
where this obstruction vanishes, including cubics with a specified
order-three symmetry.  Such cubics are not thereby stably rational; only the
diagonal obstruction disappears.  This makes intermediate-Jacobian parity a
complete generic answer but not a uniform replacement for C907.

## 2. Constant cubic fibration: exact numerical data

Put

\[
 V=X\times\mathbf P^2,
 \qquad H=\operatorname{pr}_X^*\mathcal O_X(1),
 \qquad L=\operatorname{pr}_{\mathbf P^2}^*\mathcal O(1).
\]

Then

\[
 \operatorname{Pic}(V)=\mathbf ZH\oplus\mathbf ZL,
 \quad K_V=-2H-3L,
 \quad K_{V/\mathbf P^2}=-2H,
 \quad H^3L^2=3,
\]

with `Eff(V)=Nef(V)=R_{>=0}H+R_{>=0}L`.  For
`M=aH+bL`,

\[
 M^5=30a^3b^2.
\]

A hypothetical birational map to `P^5` pulls hyperplanes back to a mobile
system with `a,b>0`.  Relative to the cubic fibre, write

\[
 M\equiv -nK_V+\pi^*(dL),
 \qquad n=\frac a2,
 \qquad d=b-\frac{3a}{2}.
\]

The generic fibre is the constant cubic threefold over `C(P^2)` and the
restricted system lies in `|aH|=|-nK|`.

## 3. Why existing rigidity theorems miss it

Pukhlikov's 2023 Fano--Mori theorem requires index-one, high-dimensional
complete-intersection fibres and a sufficiently twisted total space.  The
constant cubic fails each point:

1. its fibre has index two and codimension one;
2. `Pic(V)` is not `Z K_V + pi^*Pic(P^2)`: the latter has index two in the
   `H` direction;
3. the mobile system `|H|` cannot be written with an integral anticanonical
   coefficient;
4. the `K` and `K^2` conditions fail maximally because `-K_V=2H+3L` is ample
   and `K_V^2=4H^2+12HL+9L^2` is interior to the effective codimension-two
   cone;
5. for a base line `C`, every class
   `-N(K_V·pi^{-1}C)-F=2NHL+(3N-1)L^2` is effective.

The mismatch is structural, not a missing citation.

## 4. Explicit failure of naive rigidity

Choose a line `ell` on `X`.  Blanc--Lamy Proposition 2.2 gives

\[
 \operatorname{Bl}_{\ell}X\longrightarrow\mathbf P^2
\]

as a conic bundle.  Taking the product with the original base gives

\[
 \operatorname{Bl}_{\ell\times\mathbf P^2}V
 =\operatorname{Bl}_{\ell}X\times\mathbf P^2
 \longrightarrow\mathbf P^2\times\mathbf P^2,
\]

an alternative Mori-fibre structure birational to `V`.  Thus `V/P^2` is not
birationally rigid.

This is not an isolated accident.  Cubic threefolds have:

- point-centred Geiser-type self-links;
- the line-centred conic bundle;
- plane-cubic and conic centres leading to del Pezzo fibrations;
- rational-quintic and genus-two sextic involutory links;
- special equivariant links to genus-eight Fanos.

Blanc--Lamy classify curve blowups with weak-Fano total space, not all maximal
centres of arbitrary birational maps.  Zikas proves that some curve-centred
links lie in no nontrivial elementary Sarkisov relation.  Therefore the
required uniform untwisting theorem is genuinely absent.

## 5. Elementary maximal-centre sieve

For a smooth centre of codimension `c`, the elementary Noether--Fano
condition is

\[
 \operatorname{mult}_C M>\frac{a(c-1)}2.
\]

On a cubic fibre, two and three general members give budgets

\[
 m^2\delta\le 3a^2,
 \qquad m^3e\le 3a^3.
\]

These bounds exclude most first centres, but leave exactly the known low-
degree geometry:

1. horizontal fibre curves of degree at most 11;
2. horizontal multisections of degree one or two;
3. a hyperplane-divisor centre over a base curve;
4. line or conic centres over a base curve;
5. a whole special fibre with `a/2<m<=b`;
6. a line in a special fibre.

The `4n^2` bound is `a^2`, versus total cubic-fibre degree `3a^2`; by itself
it cannot contradict the degree budget.  The `8n^2` inequality leaves the
same low-degree survivors and requires point-centre/infinitely-near
hypotheses that cannot be imposed indiscriminately.  Hypertangent methods
would have to be combined with a classification of the surviving links.

## 6. Equivariant rigidity does not bridge the gap

Cheltsov--Krylov--Ma'u classify `G`-birationally rigid cubic threefolds.  For
the trivial group, their criterion deliberately gives non-rigidity; projection
from a plane produces a cubic-surface fibration.  Large symmetry groups can
make the Fermat or Klein cubic `G`-superrigid, but rationality of
`X x P^2` would transport `G` only to a birational Cremona action on `P^5`.
It supplies no reason that this action is linear or projectively linear.
Thus equivariant rigidity or stable-linearization obstructions do not forbid
underlying rationality.

## 7. Verdict and viable successor

The bounded attack does not produce Gold.  It proves that a standard rigidity
argument cannot: the target is untwisted, violates the required cone
conditions, and has real Sarkisov links occupying the numerical survivor
list.

The only plausible rigidity successor is a new **relative pliability
classification** for the constant cubic over `C(P^2)`: classify every first
maximal centre, untwist it by the known cubic links, and prove that every
resulting Mori-fibre model remains nonrational.  This is substantially larger
than the bounded pass and currently less efficient than the C907
Gamma-coherence problem.

## 8. AA / EJ / TT

- **AA:** the opposite is now impossible for very general cubics, but the
  generic parity proof cannot specialize across the special algebraic-cycle
  loci.
- **EJ:** one line on `X` already manufactures a relative conic-bundle link,
  so the constant product fails naive rigidity before any delicate maximal-
  singularity computation.
- **TT:** `G`-rigidity concerns `G`-Mori models; stable linearizability concerns
  projective representations; underlying rationality gives only a birational
  Cremona action.  No implication connects the last object back to either of
  the first two.

## Primary sources

- P. Engel, O. de Gaay Fortman, S. Schreieder, *Matroids and the integral
  Hodge conjecture for abelian varieties*, arXiv:2507.15704v3, Theorems 1.3,
  1.6 and Corollary 1.4.
- C. Voisin, *On the universal CH0 group of cubic hypersurfaces*, especially
  Corollary 4.4 and Theorem 4.5.
- J. Blanc, S. Lamy, *Weak Fano threefolds obtained by blowing-up a space
  curve and construction of Sarkisov links*, arXiv:1409.7778, Theorem A and
  Proposition 2.2.
- S. Zikas, *Rigid birational involutions of P3 and cubic threefolds*,
  arXiv:2111.04711, Propositions 3.1, 3.4, 3.5 and Corollary 3.6.
- A. Pukhlikov, *Birationally rigid Fano--Mori fibre spaces*,
  arXiv:2305.16219, Definitions 0.1--0.2 and Theorems 0.2--0.3.
- I. Cheltsov, I. Krylov, S. Ma'u, *G-birationally rigid cubic threefolds*,
  arXiv:2604.20426, Theorem 3 and Lemma 7.
