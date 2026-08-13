# C907 formal direct sums cannot select the Silver Jordan operator

**Lane:** `clebsch`

**Status:** exact algebraic no-go and minimum positive datum.  Iritani's
formal quantum-`D`-module direct sums determine the underlying cyclotomic
vector spaces and their Tate-indexed associated grades.  They do not select
the nilpotent operator needed by the minimal Silver category: the same three
formal copies admit both the split packet `J_1^3` and the endpoint packet
`J_3`.

## The three-copy ambiguity

Let `K=Q(zeta_6)` and let `E` be a one-dimensional generalized `zeta_6`
formal packet.  The projective-bundle formula supplies an underlying
Tate-indexed vector space

\[
 V=E_0\oplus E_1\oplus E_2.
 \tag{1}
\]

On the same formal-monodromy object define

\[
 N_{\rm split}=0,
 \tag{2}
\]

or, after choosing nonzero maps between the one-dimensional consecutive
copies,

\[
 N_{\rm end}(E_0)=E_1,qquad
 N_{\rm end}(E_1)=E_2,qquad
 N_{\rm end}(E_2)=0.
 \tag{3}
\]

Both commute with the scalar formal monodromy, have the same underlying
formal QDM, the same three associated Tate grades, and the same formal
primitive-sixth multiplicity.  But

\[
 (V,N_{\rm split})\cong J_1^{\oplus3},
 \qquad
 (V,N_{\rm end})\cong J_3.
 \tag{4}
\]

No functor of the unextended direct sum, its characteristic polynomial, or
its graded dimensions can distinguish (2) from (3).  The same ambiguity
persists for higher-dimensional `E`: consecutive isomorphisms give copies of
`J_3`, while zero arrows give only `J_1`.

## Why the formal blowup theorem does not remove it

The formal blowup comparison is an isomorphism of quantum `D`-modules after
mirror/Laurent base change.  At the basepoint its lower-left restriction term
and higher-order corrections disappear only after the `t`-adic and dominance
associated gradeds.  Hence it supplies the analogue of (1), not a
presentation-independent choice between (2) and (3).

The transverse and nested two-blowup exchange checks prove coherence of the
Tate-polynomial/associated-grade ledger.  They cannot prove coherence of an
operator that the ledger does not contain.  Bittner's relation has the same
boundary: it globalizes an additive associated-grade formula once a motivic
assignment exists, but it does not manufacture the extension arrows.

This remains true after forgetting Gamma lattices, pairings, and directed
flags.  Those structures are not logically required by the final Silver
cancellation, but some geometric extension datum is required to choose
`N_end` at the endpoint and a strict direct-sum `N` at every blowup.

## Minimum positive datum

The smallest sufficient upgrade of the formal comparison is a natural
transformation

\[
 N_Y:E_\zeta(Y)\longrightarrow E_\zeta(Y)
 \tag{5}
\]

on the whole generalized `zeta_6` formal packet, satisfying:

1. `[N_Y,T_f]=0` and `N_Y` is nilpotent;
2. on a projective bundle, `N` is the consecutive relative-hyperplane
   operator joining the Tate summands, so `X x P^2` contains (3);
3. on a blowup, the formal comparison intertwines `N` with an actual
   block-diagonal biproduct of the ambient and shifted center operators; and
4. these intertwiners obey the transverse/nested exchange diagrams, or at
   least give the same object after composing any chosen weak factorization.

Item 3 is stronger than strictness on an associated graded.  Item 4 concerns
the operator, not only the polynomial shifts.  Together they are exactly the
minimal Jordan-packet realization hypotheses in the Silver theorem.

Exceptional/base Novikov monodromy is a plausible source of (5): on the
Orlov `P^d` block, `1-H` has the desired single Jordan string.  But the landed
sources identify this operator only on the candidate residual block.  They
do not transport it to the localized formal packet or make the full blowup
comparison block diagonal for it.  Declaring (5) to be `1-H` before that
transport is presentation-dependent: the ambient variety need not have a
distinguished relative hyperplane, and two blowup presentations supply
different exceptional directions.

## Consequence for attack order

The internal directed `P^3` Seifert theorem and the marked Gamma seed are no
longer Silver prerequisites.  The highest-value toric pilot is instead the
following smaller question:

> does exceptional Novikov continuation on
> `Bl_(P^3)P^5`, after projection to the generalized primitive-sixth packet,
> define a nilpotent `N` which is `J_1` on the center contribution and for
> which the formal blowup comparison is an actual `K[N]`-module biproduct?

A positive answer calibrates item 3 in the smallest codimension-two example;
a nonzero off-diagonal `N` term is the exact obstruction.  Computing another
Stokes Gram or associated-grade mask has zero expected value for this target.

## EJ/TT and mystery ledger

- **EJ:** strip Silver to the one datum formal QDM forgets: the arrows between
  its Tate-indexed copies.  Everything else in the final cancellation is
  ordinary Jordan-module Krull--Schmidt.
- **TT:** coherent associated grades do not imply a coherent extension.
  `J_1^3` and `J_3` have identical grades and opposite Silver behavior.
- **Settled:** formal QDM direct sums, Tate indices, and exchange-polynomial
  coherence cannot construct the operation-compatible `N`.
- **Open:** define `N` from exceptional/base continuation, prove its strict
  block-diagonal blowup transport, and test the operator-level exchange
  diagrams.
