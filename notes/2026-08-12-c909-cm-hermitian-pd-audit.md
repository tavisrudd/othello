# C909 — CM Hermitian rank-one / divided-power audit

Date: 2026-08-12  
Status: bounded local and source audit; durable note only; no manuscript, PDF,
mirror, Lean, or certificate edit

## Verdict

There is no intrinsic CM factorial or factor-two obstruction in the marked
finite-etale graph model, provided the CM action is Rosati-compatible and the
local CM module is free over the relevant CM order (equivalently, after the
chosen local splitting the divisor lattice is a conjugate-Hermitian
matrix-of-ideals lattice).  The rank-one straightening identity works in
inert, ramified, split, and dyadic local cases.

This does **not** yet upgrade the existing C909 full-
\(\operatorname{PD}(\operatorname{NS})\) theorem at arbitrary CM points.  A
CM fibre has extra divisor classes, and the current non-CM dictionary does not
identify all of them with the marked graph coefficient lattice.  The safe
current statement remains:

* full \(\operatorname{PD}(\operatorname{NS})\) equality on the non-CM locus;
* the prescribed graph-lattice equality at CM points;
* a conditional CM extension once the full Rosati-Hermitian lattice and its
  local graph ideals are proved.

Thus the audit result is **conditional GO / current theorem MINOR**: no
counterexample or forced 2-defect was found, but an unqualified CM theorem
would overclaim the NS identification.

## Local Hermitian model

Let \(R=\mathbf Z_p\), let \(\mathcal O\) be the CM order acting on the
elliptic source, and let \(\bar{\phantom{x}}\) be complex conjugation.  At a
CM-compatible graph quotient, assume the local CM module is free and choose a
CM basis.  The divisor coefficient lattice is then of the form

\[
 \mathcal H=\{H=H^\dagger:\ H_{ii}\in p^{a_i}R_0,\quad
 H_{ij}\in p^{e_{ij}}\mathcal O\ (i<j)\},                 \tag{1}
\]

where \(R_0=\mathcal O^{\bar{\phantom{x}}}\) (in the maximal quadratic CM
case, \(R_0=R\)); a more general coefficient ring is allowed after a finite
unramified splitting extension.  The graph integrality calculation normally
gives

\[
                    e_{ij}\geq\max(a_i,a_j).             \tag{2}
\]

If the polarization is represented by a nonidentity unimodular Hermitian
matrix \(B\), use the associated Hermitian form \(H=BU\), rather than the
self-adjoint endomorphism \(U\), as the divisor coordinate.  The claim below
requires that the graph congruences remain slotwise in these coordinates.

### Rank-one straightening

Diagonal generators are already rank one:
\(c e_i e_i^\dagger\), for \(c\in p^{a_i}R_0\).  For
\(\alpha\in\mathcal O\), put

\[
 v=e_i+\bar\alpha e_j.
\]

Then

\[
 vv^\dagger-e_i e_i^\dagger-N(\alpha)e_j e_j^\dagger
   =\alpha e_i e_j^\dagger+\bar\alpha e_j e_i^\dagger.   \tag{3}
\]

Multiplication by a scalar \(c\in p^{e_{ij}}R_0\) gives every cross-slot
generator in \(p^{e_{ij}}\mathcal O\) (write the desired coefficient as
\(c\alpha\)).  The three terms on the left lie in (1): the first diagonal is
allowed because \(e_{ij}\geq a_i\), and the second because
\(e_{ij}+v_p(N(\alpha))\geq a_j\).  No polarization sign, norm
surjectivity, division by two, or trace averaging is used.  In particular,
the argument is unchanged at \(p=2\).

Consequently, under (1)--(2), \(\mathcal H\) is generated over \(R\) by
Hermitian rank-one forms.  If \(R_v\) is the corresponding divisor class,
its pullback to the CM elliptic power is a decomposable alternating
two-form, hence \(R_v^2=0\).  For \(D=\sum c_vR_v\),

\[
 \frac{D^k}{k!}=\sum_{|I|=k}\left(\prod_{v\in I}c_v\right)\prod_{v\in I}R_v,  \tag{4}
\]

because every repeated index vanishes and the \(k!\) orderings of a
distinct set cancel.  This proves local ordinary-product membership of every
divided power, including the CM extra divisor classes, once they are in the
Hermitian lattice (1).  Faithfully flat splitting/descent is the same quotient
lattice argument as in the non-CM theorem.

## Three local CM tests

1. **Inert place.**  For an unramified quadratic \(\mathcal O/R\), Hermitian
   matrices have diagonal entries in \(R\) and arbitrary \(\mathcal O\)
   off-diagonal entries paired by conjugation.  Formula (3) generates each
   pair.  This remains valid for an arbitrary power of \(p\), including
   \(p=2\) when the quadratic extension is unramified.

2. **Ramified place, including dyadic CM.**  For a maximal ramified
   quadratic order, \(N(\alpha)\in R\) and (3) is unchanged.  For example,
   over \(\mathbf Z_2[i]\), the class with matrix
   \(\left[\begin{smallmatrix}0&\alpha\\\bar\alpha&0\end{smallmatrix}\right]\)
   is the difference of the three rank-one classes in (3).  The dyadic
   parity obstruction appearing in trace-transfer constructions is a
   different problem: it concerns representing an alternating trace form by
   an \(\mathcal O\)-rank-one module, not generating Hermitian NS forms.

3. **Split place.**  If \(\mathcal O\otimes R\simeq R\times R\) and conjugation
   swaps the factors, a Hermitian matrix is identified with an arbitrary
   matrix \(M\in M_g(R)\): its two components are \((M,M^t)\).  Taking a
   vector with plus component \(e_i\) and minus component \(e_j\) gives the
   matrix unit \(E_{ij}\).  Thus there is again no factor-two defect.

These tests also show why the CM enlargement of NS is not by itself a
problem: for a literal CM product \(E^g\),
\(\operatorname{NS}(E^g)\) is the full Hermitian lattice, of rank \(g^2\),
and the same rank-one calculation handles its off-diagonal CM classes.

## Where the geometric theorem can fail to follow

The local calculation should not be silently promoted to a theorem for every
CM source.  There are three separate gates.

* **Rosati compatibility.**  The CM action must descend through the graph and
  the Rosati involution must restrict to complex conjugation.  This holds for
  the scalar/O-stable graph presentations used by C909, but is not a property
  of an arbitrary isogenous ppav presentation without marking.

* **Module/order gate.**  For a maximal CM order, each local order is a DVR or
  a product of DVRs, and a torsion-free local CM module is free; (1) is then
  the right model.  At a nonmaximal conductor prime, the local order is not a
  DVR and a torsion-free rank-one CM module can be nonfree.  The factorization
  of an off-diagonal Hom class into two vectors from one common source is then
  not automatic.  Formula (3) proves the result for a free/slotwise lattice,
  not for every nonprojective module over a nonmaximal order.

* **Full-NS identification.**  The marked graph lattice is visibly a
  sublattice of \(\operatorname{NS}(A)\).  At a non-CM fibre it is the full
  NS lattice by the usual \(\operatorname{End}^0(E)=\mathbf Q\) dictionary.
  At a CM fibre, extra Hermitian classes appear.  It is necessary either to
  place all of them in (1), or to state only the prescribed graph-lattice
  equality.  “The NS lattice got larger” is not a proof of saturation for the
  larger lattice.

Accordingly, the safe conditional extension is:

> If \(E\) has a maximal CM order \(\mathcal O\), the graph is
> \(\mathcal O\)-stable and Rosati-compatible, and at every bad prime the
> full NS lattice is the free conjugate-Hermitian matrix-of-ideals lattice
> (1) with (2), then
> \(\operatorname{PD}(\operatorname{NS}(A))^k=P_A^k\) for all \(k\).

The conclusion is cohomological and ordinary-integral; it is not a claim
about Chow or the full ambient integral Hodge lattice.  CM can enlarge the
ambient Hodge lattice even when the divisor PD equality holds.

## Source check and priority boundary

A bounded adjacent-source check found the precise Hermitian dictionary but no
source for the C909 graph-lattice/PD statement.  Fabien Narbonne,
*Polarized products of elliptic curves with complex multiplication and field
of moduli \(\mathbf Q\)*, arXiv:2203.11982v3 (2025 revision), states an
equivalence between polarized products with maximal CM order and integral
Hermitian \(R\)-lattices (Theorem 2.3; abstract and experimental HTML were
read, not the PDF line-by-line).  This supports the CM coordinate model and
also flags the maximal-order restriction.  It does not assert rank-one
generation of every Hermitian lattice, finite-etale graph congruences, or
ordinary integral divided-power saturation.

The existing C909 bounded source ledger separately records Lange's
Rosati/form dictionary, Jacobowitz at metadata depth for local Hermitian
forms, and the finite-etale graph saturation search.  No exact CM analogue
of the C909 theorem was located in that bounded coverage.  The safe priority
sentence is therefore “the Hermitian CM model is classical; the graph
matrix-of-ideals rank-one/PD application is not located in the bounded
search,” not “new CM Hermitian theory.”

## Final scope / mystery ledger

* **Settled locally:** free maximal-order CM Hermitian graph lattices have
  integral rank-one generation, including ramified dyadic and split places;
  no factorial or factor-two defect is forced.
* **Not settled geometrically:** equality between the full CM NS lattice and
  the displayed graph lattice in a family; nonmaximal-order/nonfree modules;
  globalizing the CM action and all graph ideals.
* **Recommended wording now:** retain the full-NS theorem on the non-CM locus;
  state the marked-lattice theorem at CM points; add the boxed conditional CM
  extension only if the three gates above are proved.
* **Potential next lemma:** a local conductor-order theorem for Hermitian
  forms on the actual CM graph module. A counterexample, if one exists, must
  come from nonprojective conductor modules or failure of slotwise ideals,
  not from a dyadic Hermitian factor of two.
