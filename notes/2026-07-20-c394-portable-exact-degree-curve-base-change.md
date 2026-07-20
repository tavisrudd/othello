# C394: portable exact-degree curve and finite-phase base change

**Date:** 2026-07-20
**Lane:** `crowns`
**Status:** queued; positive proof-level gate

## Purpose

Extract the genuinely portable content of C389 from the special action on `P1` and from the
four-target C333 repair interface.  The target is one theorem package with two parts:

1. an exact-degree free-action/Schreier decomposition for finite automorphism groups of curves;
2. a finite-phase support-function, normal-fan, and mixed-volume theorem for any additive convex
   resource functor on those decompositions.

The package must keep its classical ingredients separate from the claimed composition.  It does
not evaluate a low-degree game block, assert integral normality, or resume C294.

## Theorem A target: exact-degree Schreier layers on curves

Let `X/F_q` be a smooth projective geometrically integral curve, let
`H<=Aut_(F_q)(X)` be finite and faithful, and let `S` be a finite inverse-closed coloured
generating set.  Let `W` be a finite set of nonidentity words in `S`, and delete the fixed-point
set of every word in `W`.

For `d>=1`, let `E_d(X)` be the geometric points of `X` whose least field of definition is
`F_(q^d)`.  Since a nonidentity automorphism of a curve has a finite fixed locus, the union

\[
Z_H=\bigcup_{1\ne h\in H}\operatorname{Fix}(h)
\]

is finite.  Define

\[
\Delta(X,H)=\max\{[\kappa(x):F_q]:x\in Z_H\},
\]

with `Delta=0` when `Z_H` is empty.  The target theorem is that for every `d>Delta(X,H)`:

- no prescribed deletion meets `E_d(X)`;
- `H` acts freely on `E_d(X)`;
- the `S`-labelled residual on `E_d(X)` is a disjoint union of regular Cayley layers;
- their exact multiplicity is

\[
a_d(X,H)=\frac1{|H|}\sum_{e\mid d}\mu(d/e)\,#X(F_{q^e}).
\tag{A}
\]

Thus, for every extension degree `n`, the residual decomposes into its bounded low-degree term and

\[
\coprod_{\substack{d\mid n\\d>\Delta(X,H)}}
a_d(X,H)\operatorname{Cay}(H,S).
\tag{B}
\]

The exact-degree partition is canonical; choosing individual Cayley coordinates is not.  State the
general result for an `S`-labelled directed Schreier graph, and specialize to an undirected coloured
graph when inverse generators share colours.  C389 is recovered from `X=P1`, where every
nonidentity projectivity has fixed points of degree at most two and (A) reduces, for `d>2`, to

\[
|H|^{-1}\sum_{e\mid d}\mu(d/e)q^e.
\]

### Proof spine

1. Apply divisor-lattice Möbius inversion to
   `#X(F_(q^d))=sum_(e|d)|E_e(X)|`.
2. Use faithfulness and the curve hypothesis to make `Z_H` finite.
3. Above `Delta`, exclude both deletion and nontrivial stabilizers.
4. Identify every free orbit with the left Cayley graph by `h -> hx`.
5. Use base-definedness to show that automorphisms preserve least fields of definition and that
   extension inclusions add whole exact-degree layers.

The curve hypothesis is load-bearing: in higher dimension a nonidentity automorphism may have a
positive-dimensional fixed locus containing points of unbounded degree.

## Theorem B target: finite-phase additive-resource base change

Let `P` be any functor from disjoint coloured helper systems to compact convex subsets of `R^r`
such that disjoint union maps to Minkowski sum.  Aggregate the surviving degree-`e` low blocks into
fixed polytopes `P_e` for `e<=Delta`, and let `P_C` be the resource polytope of the regular Cayley
block.  Put

\[
c_n=\sum_{\substack{d\mid n\\d>\Delta}}a_d(X,H).
\]

Then the target identity is

\[
P_n=\sum_{\substack{e\mid n\\e\le\Delta}}P_e+c_nP_C.
\tag{C}
\]

After `c_n>0`, (C) gives the following portable consequences.

- **Support functions:** every linear objective is the corresponding sum of fixed low-block
  optimizations plus `c_n h_(P_C)`.
- **Finite normal-fan phases:** positive dilation does not change `N(P_C)`, so the normal fan
  depends only on the divisor-incidence pattern `{e<=Delta:e|n}`.  It is therefore periodic in
  `n` with period dividing `lcm(1,...,Delta)` and has only finitely many phases.  Different formulas
  may yield the same fan, so claim an upper bound on phases rather than forced distinction.
- **Normalized convergence:** along every sequence with `c_n -> infinity`, `c_n^(-1)P_n` converges
  to `P_C` in Hausdorff distance, with the elementary `O(1/c_n)` bound from the fixed low blocks.
- **Mixed-volume laws:** in ambient dimension `r`, every phase has an exact degree-`r` polynomial
  in `c_n`, with coefficients the mixed volumes of its low aggregate and `P_C`.

For `Delta=2`, the divisor pattern is parity, recovering C389's stable odd/even normal-fan formulas.
The theorem applies to any genuinely Minkowski-additive fractional resource interface; integral
semigroups, IDP, and normality are excluded.

## Optional appendix: complete exceptional layers

If it remains short, package the low-degree residual by stabilizer type.  For `K<=H`, apply field-
degree Möbius inversion to `#X^K(F_(q^e))`, then subgroup-poset Möbius inversion to pass from
points fixed by `K` to points with exact stabilizer `K`.  Each conjugacy class of stabilizers gives
a precise number of transitive Schreier blocks `Sch(H/K,S)`.

This appendix is useful only if it replaces the opaque low-degree term cleanly.  It is not allowed
to become a subgroup-census project or a quadratic-scar value computation.

## Literature and novelty gate

The following ingredients are classical and receive no novelty wording: exact-degree point counts,
fixed loci of curve automorphisms, free group actions, Cayley/Schreier coordinates, Hasse--Weil
estimates, support-function additivity, normal fans of Minkowski sums, and mixed-volume
polynomiality.

Before a paper-facing novelty or priority sentence, run a focused audit covering:

- finite-group actions and quotient curves over finite fields, especially exact-degree point and
  closed-point orbit formulas;
- zeta functions and equivariant point counts for free loci;
- voltage/Cayley/Schreier decompositions indexed by Frobenius degree;
- additive resource-region constructions and parametric Minkowski families.

Stop or narrow if one source already states Theorem A with deleted labelled Schreier layers, or if
Theorem B cannot be presented as a consumer-independent finite-phase result stronger than a bare
restatement of Minkowski additivity.  Record every source and screened set under
`notes/literature-audit-conventions.md`.

## Evidence and delivery boundary

This is a proof-level task.  No computation is required for Theorems A and B.  A small symbolic or
finite example may illustrate the exceptional-layer appendix, but it is not evidence for the
general theorem and must not expand into a census.

The deliverable is a dated theorem report under the stem
`notes/2026-07-20-c394-portable-exact-degree-curve-base-change.*`, a crisp crowns-handoff update,
and the normal queue/archive transition.  C389, C370, and C332 are read-only theorem dependencies.

