# C925 two-layer resolvent packet

**Lane:** `cubic-threefolds`

## Status

The elliptic two-division resolvent supplies a genuine internal $C_3$-torsor,
but it does not identify the cubic-center action with the cube-root deck action
of the $\mathbf P^2$ comparison.  Keeping those two actions separate repairs the
main objection to the earlier Burnside marker.

The resulting $m=2$ theorem is conditional and exact.  If the external
Kummer action extends to the common spectral-block receiver, acts regularly on
the distinguished source projective-bundle branches, and acts trivially on
every target/rational endpoint block and every correction block, then no
internal center action can erase the obstruction.  The remaining geometric theorem is external descent of the
spectral idempotents and equivariance of the occurrence comparisons.  Neither
the elliptic resolvent nor the codimension count proves that theorem alone.

## 63.1 The internal resolvent

Let $V$ be two-dimensional over $\mathbf F_2$.  Extension of scalars gives a
canonical inclusion

\[
  \mathbf P_{\mathbf F_2}(V)
  \subset
  \mathbf P_{\mathbf F_4}(\mathbf F_4\otimes_{\mathbf F_2}V).
\]

The two sets have three and five elements.  The complement is therefore a
canonical two-set.  Under
$\operatorname{GL}_2(\mathbf F_2)\simeq S_3$, the three-set is the natural
permutation representation and the complementary two-set is the sign set.
Indeed, the scalar-extension embedding lands in
$\operatorname{PGL}_2(\mathbf F_4)\simeq A_5$; the five-point permutation is
even, so the signs on the three-set and its complementary two-set agree.

For an elliptic scheme $\mathcal E/S$ with $2\in\mathcal O_S^\times$ (or,
equivalently here, with $\mathcal E[2]$ finite etale of rank four), this
identifies the sign class of the exotic pair in the five-sheet gluing packet
with the discriminant orientation cover of
$\mathbf P(\mathcal E[2])$.  After pulling back to one sheet of that orientation
cover, the monodromy lies in $A_3\simeq C_3$.  When the original mod-two
monodromy is all $S_3$, the rational three-cover becomes a regular
$C_3$-torsor.  Surjectivity is load-bearing: an arbitrary programme base may
pull the universal cover back with smaller monodromy.  The complementary
two-set has the same sign class as the orientation torsor; without an
orientation convention there is no preferred sheetwise isomorphism between
the two torsors.

This is intrinsic finite-etale descent data.  It is not a label asserting that
three blocks once arose together.

## 63.2 Separation from the projective-bundle deck action

The projective-bundle splitting for $X\times\mathbf P^2$ uses a Kummer
parameter $q^{1/3}$.  Over a characteristic-zero coefficient field containing
the cube roots of unity, put

\[
 K=K_0((q)),\qquad
 L_{\mathrm{ext}}=K_0((q^{1/3})).
\]

Then $L_{\mathrm{ext}}/K$ is a totally ramified cyclic cubic extension.  An
internal finite-etale cover pulled back from $K_0$ is unramified at the
$q$-adic valuation.  Hence a connected internal cyclic cubic extension and
$L_{\mathrm{ext}}$ are linearly disjoint: a nontrivial intersection would be
the whole cubic extension, which cannot be both unramified and totally
ramified.  Their compositum has group

\[
          C_3^{\mathrm{ext}}\times C_3^{\mathrm{int}}.
\tag{63.1}
\]

The same statement is cleaner for finite-etale torsors over a product base.
The exterior product of the internal resolvent torsor and the punctured Kummer
torsor is a torsor for the product group, without choosing geometric sheets.
After restriction to a diagonal or another occurrence base, product
independence must still be carried by the supplied torsor action; it must not
be inferred from two abstract groups of order three.

This gives a sharp falsifier.  If the internal and external cubic extensions
coincide, the action factors through the diagonal $C_3$, and a unary cubic
center can carry the same free orbit as the source.  The earlier one-action
Burnside marker then fails exactly as the unary-packet countermodel predicts.

## 63.3 The two-layer marker

Let $G_{\mathrm{ext}}$ be nontrivial and let $G_{\mathrm{int}}$ act on an
arbitrary set $A$.  There are two product-group packets:

* the external-regular packet $G_{\mathrm{ext}}\times A$, on which the two
  factors act independently;
* an external-trivial packet $B$, on which $G_{\mathrm{ext}}$ acts trivially
  while $G_{\mathrm{int}}$ may act arbitrarily.

Every point of the second packet is fixed by
$G_{\mathrm{ext}}\times\{1\}$.  No point of the first packet is fixed by that
subgroup.  Consequently there is no equivariant bijection between them.  The
internal action can be regular, trivial, or mixed; it does not affect the
argument.

Lean proves this in
`Comparison.TwoLayerDescentPacket.externalRegular_not_equivariantlyEquivalent_externalTrivial`.
The earlier theorem
`Comparison.DescentPacket.unaryPacketEquivariantEquiv` supplies the converse
warning: without the independent external factor, a unary constructor retains
the whole internal action.

Thus the correct marker is not the total number of $C_3$-orbits.  It is the
fixed-point mark for the named external subgroup, or equivalently the external
layer of the finite-etale packet.  A single external-regular orbit cannot be
assembled from any positive disjoint union of external-trivial corrections.

## 63.4 Conditional $m=2$ telescope

The formal codimension-two branch count passes a primary-source check.
Iritani defines the Fourier projections over Laurent series in
$q^{-1/s}$, with

\[
 s=r-1\quad(r\text{ even}),\qquad
 s=2(r-1)\quad(r\text{ odd})
\]

in equation (5.11) of *Quantum cohomology of blowups*
(arXiv:2307.13555).  Theorem 5.18 then has $r-1$ center summands indexed by
$0\le j\le r-2$.  For codimension $r=2$, one has $s=1$ and only $j=0$.
Thus the formal center projection introduces no nontrivial root extension in
its own exceptional Fourier variable.  This proves the local branch-label
part of (63.2).

It does not yet prove external triviality for the projective-bundle Kummer
action.  That action belongs to the $\mathbf P^2$ coefficient variable, while
the blow-up theorem uses the occurrence's exceptional Fourier variable.  A
lawful path reindexing could mix their valuations.  The remaining coefficient
statement is that every occurrence map has zero external Kummer weight on the
codimension-two center summand.  The cached source checked here is
`arXiv:2307.13555`, SHA-256
`c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
This is analogous to the bounded zero-weight/cocharacter gate isolated in
Module 29, but it is not literally the same datum until a typed path map
identifies the $\mathbf P^2$ Kummer valuation with that module's chosen
line-bundle state.  The present consumer asks only for finite spectral-block
descent, not Levelt/Gamma-row transport.

Let $\mathscr S_{4/9}(Y)$ denote the finite set, or finite-etale scheme, of
geometric spectral blocks carrying the cubic marker.  The following inputs
would close the packet route.

1. **Intrinsic block descent.**  Construct $\mathscr S_{4/9}(Y)$ before the
   ramified Laurent splitting and prove that scalar extension recovers the
   marked geometric blocks.
2. **External source orbit.**  For $X\times\mathbf P^2$, identify the three
   projective-bundle branches as a regular
   $C_3^{\mathrm{ext}}$-orbit.
3. **Independent internal descent.**  Any elliptic two-division resolvent
   carried by a cubic atom is pulled from the coefficient/base direction and
   is unramified for the external $q$-adic Kummer valuation.  Equivalently,
   work with the product action in (63.1).
4. **External-trivial corrections.**  Every codimension-two exceptional block
   is defined before adjoining $q^{1/3}$, and the blow-up comparison preserves
   its descended spectral idempotent.  Its internal center packet may be
   arbitrary.
5. **External-trivial target.**  Every relevant primitive idempotent of the
   projective/rational endpoint descends individually to the base field.
   Merely defining the unsplit finite-etale scheme over that field is
   insufficient: its geometric idempotents may still form a regular Galois
   orbit.
6. **Stable equivariant ledger.**  The oriented occurrence comparisons and
   reindexings compose to an actual product-action-equivariant bijection
   \[
     \mathscr S_{4/9}(X\times\mathbf P^2)\sqcup\mathscr C_{\mathrm{left}}
       \;\simeq\;
     \mathscr S_{4/9}(\mathbf P^5)\sqcup\mathscr C_{\mathrm{right}},
   \]
   where every block in both correction ledgers and every target block is
   externally fixed.  Each reindexing preserves the named external subgroup,
   or transports it by an explicitly product-preserving automorphism.

Under these hypotheses the left ledger contains an external-regular packet
plus externally trivial corrections, while the right ledger is wholly
external-trivial.  Section 63.3 forbids the required equivariant stable
identification.  Lean checks this exact disjoint-union form in
`Comparison.TwoLayerDescentPacket.externalRegularSum_not_equivariantlyEquivalent_externalTrivial`.

The codimension-two formula contributes only one outer exceptional copy, but
that count is used here solely to show that no new exceptional Kummer root is
introduced.  It does not erase the center's internal resolvent.  The relevant
geometric statement is therefore

\[
 \boxed{\text{codimension-two correction descends across }
        K_0((q^{1/3}))/K_0((q)),}
\tag{63.2}
\]

with its spectral idempotent preserved.  This is smaller and more precise than
"the center packet is fixed under a common $C_3$-action."

## 63.5 Relation to the fixed-phase reader

This route does not prove the window square
$T_jv_i=j_+F$, the Gamma-row restrictions, or the resonant can/variation
identification isolated in Module 62.  It may avoid consuming those statements
if the invariant is defined on the generic finite-etale spectral-block scheme
and every weak-factorization comparison is already equivariant there.

Linear equivariance is insufficient.  The regular representation of $C_3$
contains a trivial line, so an equivariant linear map may mix an externally
fixed correction with the invariant sum of a regular orbit.  The provider must
preserve primitive spectral idempotents, or an equivalent finite-etale block
decomposition.  At $q=0$ the Kummer cover is ramified and its three-point
fibre degenerates; the marker must be formed on the punctured/formal generic
fibre and extended by a specified nearby-cycle or intermediate-extension
construction.

The most economical source theorem is now:

> The unsplit projective-bundle and blow-up QDM comparisons induce coherent
> maps of marked finite-etale spectral schemes over $K_0((q))$; after the
> external cubic Kummer extension, the projective-bundle packet is regular and
> every codimension-two correction descends from the base field.

If this holds, no Gamma normalization or Stokes-matrix calculation is needed
for the packet consumer.  If it fails, Module 62's fixed-phase rank-row reader
remains the stronger fallback.

## 63.6 All-$m$ boundary

The argument is especially clean for $m=2$: the source has external
ramification degree three and a dangerous codimension-two center has exceptional
outer degree one.  For general $m$, the source Kummer degree is $m+1$, while
successive lower-arity operations can have ramification degrees with common
factors whose composites recreate part or all of that inertia.  Cardinality or
one fixed-point mark is then inadequate.

An all-$m$ theorem would retain the ramification filtration or the tower of
primitive inertia quotients.  This is the number-theoretic form of packet
height.  It is a lawful continuation of the $m=2$ proof, not a free corollary
of it.

## Verification boundary

The new Lean module proves only the product-action set theorem.  It assumes the
two group actions and does not construct a Galois cover, a QDM block scheme, or
an equivariant blow-up comparison.  Its checked declarations are:

* `Comparison.TwoLayerDescentPacket.externalTrivialPacket_isExternallyFixed`;
* `Comparison.TwoLayerDescentPacket.externalRegularPacket_not_externallyFixed`;
* `Comparison.TwoLayerDescentPacket.externalRegular_not_equivariantlyEquivalent_externalTrivial`;
* `Comparison.TwoLayerDescentPacket.externalRegularSum_not_equivariantlyEquivalent_externalTrivial`.

The ramification argument in Section 63.2 is a standard field-theoretic proof
recorded in prose.  No modular Hauptmodul, cusp-signature, or programme-base
surjectivity claim from the supplied resolvent note is consumed by the
conditional telescope.

## EJ and TT closeout

The useful upgrade is that the internal $C_3$-torsor is not an obstruction to
the marker once external Kummer inertia is named independently.  The exact
cheap test is $q$-adic ramification: internal data pulled from the cubic base
are unramified, whereas the projective-bundle cube root is totally ramified.

The main hostile model is diagonal collapse.  Two unnamed cyclic actions of
order three may be the same action; then a unary cubic center can reproduce the
free orbit.  The second hostile model is linear mixing through the trivial
summand of the regular representation.  These show why both product descent
and primitive-idempotent preservation are load-bearing.

The highest-value next check is source-local: inspect the unsplit formal
projective-bundle and codimension-two blow-up comparisons and decide whether
their marked spectral idempotents are defined over the base Laurent field.  A
positive answer closes the external-triviality input (63.2); a negative answer
ends this detour without disturbing the fixed-phase reader route.

## Mystery ledger

| question | state | exact evidence gap |
|---|---|---|
| Is the elliptic resolvent the same $C_3$ as the projective Kummer deck group? | separated under a product-base or $q$-unramified hypothesis | prove that the actual occurrence base and coefficient trait realize this separation |
| Does a cubic center's internal $C_3$ defeat the marker? | settled: no under an independent external action | Lean proves arbitrary internal actions cannot remove the external fixed-point distinction |
| Does codimension two force external triviality? | local formal branch count passes; global external descent open | Iritani's $r=2$ projection uses $s=1$, but prove zero external Kummer weight under every occurrence reindexing and preserve the idempotent |
| Is linear Galois equivariance enough? | settled: no | the regular representation contains a trivial summand; preserve the finite block scheme or primitive idempotents |
| Does this prove all $m$? | no | retain primitive inertia/ramification towers and exclude reconstruction from lower arities |
