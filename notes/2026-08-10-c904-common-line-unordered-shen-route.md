# C904 common-line normalization and the unordered Shen route

Date: 2026-08-10
Status: exact fixed-fibre integral quotient lift; relative Shen-cycle descent
remains open
Scope: no manuscript, Lean, or commit change

## Verdict

The common-line observation is a real correction to the earlier emphasis on
the ordered double cover.

Normalize the Abel--Jacobi embedding of the Fano surface by the common line
`s`,

\[
 a_s:F\longrightarrow J,\qquad a_s(\ell)=AJ(\ell-s).
\]

Then `a_s(s)=0` and the Clemens--Griffiths difference divisor is

\[
 \Theta=a_s(F)-a_s(F).
\]

Consequently

\[
                       a_s(F)\subset \Theta.
\]

Let `D_{+,s}=a_s(F)+a_s(F)`.  Shen's degree calculation gives the exact
factorization

\[
 F\times F\xrightarrow{q}\operatorname{Sym}^2F
 \xrightarrow{b_s}D_{+,s},
 \qquad \deg q=2,\quad \deg(a_s+a_s)=2,
\]

and hence `deg(b_s)=1`: `b_s` is a proper birational morphism.  Since
`F subset Theta`, it is the restriction of theta addition,

\[
 \begin{array}{ccc}
 \operatorname{Sym}^2F&\hookrightarrow&\operatorname{Sym}^2\Theta\\
 \downarrow b_s&&\downarrow m_\Theta\\
 D_{+,s}&\hookrightarrow&J.
 \end{array}
\]

Thus the generic point of `D_{+,s}` has a degree-one **unordered** theta-pair
lift.  More generally, every curve in `D_{+,s}` meeting the birational
isomorphism locus has a strict transform in `Sym^2 F subset Sym^2 Theta`
which maps with degree one.  No splitting of

\[
                 F\times F\longrightarrow\operatorname{Sym}^2F
\]

is needed.  The ordered cover may remain connected.

This genuinely bypasses the ordered lift--norm--transfer parity theorem:
that theorem applies to `q_*q^*`, whose multiplier is two.  Here the carrier
is already downstairs on the quotient and `b_s` has multiplier one.

Birationality alone does not lift components contained in the exceptional
image.  Beauville's moduli description nevertheless closes this fixed-fibre
gap.  The exceptional image is the conic Fano surface `F^2 subset D_+`; over a
line `r` the exceptional fibre is the discriminant plane quintic of the conic
bundle obtained by projecting the cubic from `r`.  A relative hyperplane cuts
this fibre in degree five.  Thus every exceptional curve has a degree-five
unordered lift, while every nonexceptional curve has a degree-one lift.

For Shen's particular cycle there is also an integral degree-two lift:

\[
 m_{\Theta,*}q_*\widetilde\theta
       =(\phi_+)_*\widetilde\theta=2\eta.
\]

If `L_5` denotes the degree-five lift of `eta`, then

\[
             \bar\eta=3q_*\widetilde\theta-L_5
             \quad\text{satisfies}\quad
             m_{\Theta,*}\bar\eta=\eta.
\]

This is an exact integral Chow lift on `Sym^2 F subset Sym^2 Theta`.  The
coefficients `3` and `-1` are simply Bezout for `3*2-5=1`.  No ordered
splitting and no assumption on the components of `eta` remain.

The sole remaining gate is relative: Shen's `eta` is presently available
fibre by fibre, not as a horizontal cycle on the marked pencil.

Accordingly, the exact conclusion is:

> **Unordered Fano-section theorem.**  For every fixed cubic satisfying
> Shen's hypothesis, common-line normalization gives an integral signed
> cycle `bar eta in CH_1(Sym^2 Theta)` with
> `m_{Theta,*}bar eta=eta`.  Away from `F^2` it is the birational strict
> transform; over `F^2` the degree-two Shen lift and the degree-five conic
> discriminant lift combine by Bezout.

Thus the degree ideal over the support of `eta` is the unit ideal.  What is
not yet justified is applying this construction to a relative `eta` on the
present marked base.

## 1. Translation conventions

Start with any Abel--Jacobi embedding `a_0` and let
`p=a_0(s)`.  Common-line normalization is translation by `-p`:

\[
                         a_s=a_0-p.
\]

The difference divisor is unchanged,

\[
 (a_0(F)-p)-(a_0(F)-p)=a_0(F)-a_0(F)=\Theta,
\]

whereas the sum divisor is translated by `-2p`:

\[
             D_{+,s}=D_{+,0}-2p.
\]

Shen's minimal curve must be translated by the same `-2p`.  Replacing the
Abel--Jacobi map by its negative sends `D_+` and `eta` through `[-1]`, while
the symmetric divisor `Theta` is unchanged.  Neither operation changes any
degree or index statement.

The common line is a section over the smooth Roulleau pencil, so all these
translations are algebraic over the marked base.  There is no residual
translation torsor in the inclusion `F subset Theta`.

## 2. Exact degree and index consequence

Let `U_b subset D_+` be the largest open over which `b_s` is an isomorphism.
Since `b_s` is birational, `U_b` is dense.  For an integral curve
`C subset D_+` not contained in `D_+\setminus U_b`, define

\[
 \widetilde C=\overline{b_s^{-1}(C\cap U_b)}
        \subset\operatorname{Sym}^2F.
\]

Then

\[
                       b_{s,*}[\widetilde C]=[C]
\]

integrally, not only after tensoring with `Q`.  Hence if
`eta=sum n_i C_i` has all `C_i` meeting `U_b`, its strict transform
`bar eta=sum n_i \widetilde C_i` satisfies

\[
 m_{\Theta,*}[\bar\eta]=b_{s,*}[\bar\eta]=\eta.
\]

After base change to `C(C_i)`, `\widetilde C_i` gives a degree-one point of
the unordered theta-pair fibre.  For a signed cycle, the statement is a
degree-one zero-cycle statement; it does not assert an effective section of
every component.

This is a supportwise index over `eta`, not a generically finite cycle over
all of `J`.  To obtain a global odd carrier for
`Sym^2 Theta -> J` one can still use a theta-supported primitive curve `Z`
and the product `Z x Theta`, whose degree is five.  The present route instead
targets the relative Abel--Jacobi lifting step along the support of the
minimal cycle.

## 3. Why the ordered parity theorem does not apply

For the ordering quotient,

\[
 q_*q^*=2,\qquad q^*q_*=1+\iota.
\]

An ordered construction which lifts by `q^*` and returns by `q_*` is
therefore even.  The strict-transform carrier uses neither operation.  It is
the rational inverse of the degree-one map `b_s` on the quotient itself:

\[
 D_+\dashrightarrow\operatorname{Sym}^2F
       \hookrightarrow\operatorname{Sym}^2\Theta.
\]

Pulling this carrier back to `F x F` merely recreates the possibly connected
degree-two ordering cover.  Its connectedness has no bearing on the
unordered index-one statement.  Thus the older ordering-cover audit remains
correct about **ordered** lifts but does not obstruct this quotient route.

## 4. The exceptional plane quintic and the `2/5` Bezout lift

A proper birational morphism does not, by birationality alone, give an
integral degree-one lift of a curve wholly contained in its exceptional
image.  Thus the sentence

> every cycle on `D_+` has a degree-one strict transform

is too strong without additional geometry of `b_s`.  In the present case the
additional geometry is classical and gives an odd lift.

That geometry is largely known.  Beauville identifies the compactified
rank-two moduli space with

\[
                    \operatorname{Bl}_{F^2}J^2(X),
\]

where `F^2` is the Fano surface of conics.  Its boundary divisor `B` of split
sheaves `I_l plus I_{l'}` is `Sym^2 F`, and the restriction of the
blow-down to `B` is precisely

\[
                 b_s:\operatorname{Sym}^2F\longrightarrow F+F.
\]

Hence `b_s` is an isomorphism over `D_+\setminus F^2`; its exceptional image
is exactly `F^2`.

Fix a line `r`, viewed as the corresponding point of `F^2` through the class
`h^2-r`.  Projection from `r` makes the blow-up of the cubic a conic bundle
over the plane of planes through `r`.  Its discriminant is a plane quintic
`Delta_r`.  A point of `Delta_r` is a rank-two residual conic

\[
                         \ell+\ell',
\]

and its unordered pair of components is exactly a point of the fibre

\[
                    b_s^{-1}(h^2-r).
\]

Equivalently, the exceptional divisor of `Bl_{F^2}J^2` is a `P^2`-bundle and
its intersection with `B=Sym^2F` has relative degree five.  This description
works scheme-theoretically over the generic point of any curve in `F^2`; no
smoothness of the discriminant is needed for the degree calculation.

Let `C subset F^2` be an integral curve.  Restrict the exceptional
`P^2`-bundle to `C` and intersect its relative plane-quintic divisor with a
relative hyperplane.  The resulting one-cycle `W_C subset Sym^2F` satisfies

\[
                         b_{s,*}W_C=5C.
\]

For a cycle `eta=sum n_iC_i` on `D_+`, take five times the strict transform
when `C_i` is not contained in `F^2`, and take `W_{C_i}` when it is.  This
constructs an integral cycle `L_5` with

\[
                         b_{s,*}L_5=5\eta.
\]

Shen's Proposition 5.7 proves

\[
              (\phi_+)_*\widetilde\theta=2\eta,
 \qquad -[\eta]=\frac{\Theta^4}{4!},
\]

with `eta` supported on `D_+`.  Pushing the centered cycle through the
ordering quotient gives the second integral lift

\[
 L_2=q_*\widetilde\theta\in CH_1(\operatorname{Sym}^2F),
 \qquad b_{s,*}L_2=2\eta.
\]

Therefore

\[
 \bar\eta=3L_2-L_5,
 \qquad b_{s,*}\bar\eta=(6-5)\eta=\eta.
\]

This closes the fixed-fibre quotient-lift problem exactly.  Notice what has
and has not happened: the ordered double cover was not split; its even lift
was combined with an intrinsically unordered odd lift on the exceptional
plane quintic.

## 5. Relative availability

The geometric objects

\[
 \mathcal F\subset\mathcal\Theta,
 \quad \operatorname{Sym}^2_U\mathcal F,
 \quad \mathcal D_+,
 \quad b:\operatorname{Sym}^2_U\mathcal F\to\mathcal D_+
\]

are relative on the smooth common-line-normalized base.  The map `b` is
birational on the generic fibre, so it supplies a rational section over the
generic point of the relative `D_+` without further marking.

What is not currently relative is Shen's `eta`.  On each marked fibre the
already certified algebraic minimal class implies universal `CH_0`
triviality by Voisin, so Shen applies fibrewise.  But his symmetric cycle is
built from a Chow decomposition of the diagonal and several choices of
correspondences.  Fibrewise existence does not produce a horizontal Chow
cycle.

The odd lifting operation itself is relative **once a horizontal target
curve is supplied**.  The conic Fano surface, the exceptional `P^2`-bundle,
and its relative plane-quintic intersection are all defined over the cubic
base.  Thus a relative cycle on `mathcal D_+` would automatically acquire a
relative degree-five lift through `Sym^2_U mathcal F`.  The exceptional
quintic does not, by itself, supply that horizontal curve.  Its global
hyperplane cut is a surface mapping with degree five to the surface
`mathcal F^2`, not a curve representing the primitive minimal class.

Consequently it is not yet a relative multiplier-five universal cubic
correspondence which can be combined with the known multiplier two.  To
obtain the literal relative Chow identity `b_*bar eta=eta` by the formula
above one must spread both `eta` and Shen's degree-two centered cycle.  At the
operator level, a relative `eta` plus its degree-five lift would be enough to
construct the odd carrier, but the exceptional surface alone does not remove
the horizontality gate.

The existing `Z_min` is a relative signed cycle of minimal class on
`mathcal J`, but no relative rational equivalence has been established which
moves it onto `mathcal D_+`.  Producing such an equivalence via Voisin's
fixed-fibre argument is essentially the relative Abel--Jacobi index problem
one is trying to solve.  Hence using a relative Shen cycle without a new
descent/spreading argument would be circular.

After a generically finite base change, a fixed-fibre construction can be
spread.  On the present marked base the remaining exact gate is:

\[
 \boxed{\text{construct a relative }\eta\text{ on }\mathcal D_+
 \text{ (and, for the literal }2/5\text{ Chow formula, its relative
 centered cycle).}}
\]

Once that is done, common-line normalization and the relative plane-quintic
construction place the odd lift in the relative `Sym^2 Theta` automatically.
The multipliers two and five generate the unit ideal.

## 6. Operator audit: why the exceptional quintic is not an autonomous `[5]`

There is a useful relative correspondence, but its domain is the Fano
surface, not the intermediate Jacobian.

For a line `r`, choose a relative hyperplane in the plane of planes through
`r`.  It cuts the discriminant quintic in five residual rank-two conics

\[
                       \ell_i+\ell'_i,\qquad 1\leq i\leq5.
\]

In `CH_1(X)` each satisfies

\[
                  \ell_i+\ell'_i+r=h^2.
\]

Summing gives the exact fibre relation

\[
              \sum_{i=1}^5(\ell_i+\ell'_i)=5h^2-5r.
\]

Therefore the resulting family over `F^2 congruent F` has normal function

\[
                         r\longmapsto -5a_s(r)+\text{constant}.
\]

After identifying `Alb(F)` with `J`, its action on `H_1` is exactly
`-5 id`.  This is the strongest operator statement supplied directly by the
exceptional quintic.

It is not yet a cycle on `J times X`.  Descending a family on `F times X`
whose normal function is `-5a_s` to a universal cycle on `J times X` is
precisely the missing integral Albanese/Abel--Jacobi descent.  Because five
is odd and a relative multiplier-two cycle is already known, such a descent
would itself be equivalent by Bezout to the desired relative identity; it
cannot be assumed as a formal consequence of the universal property of the
Albanese.

The same obstruction appears by dimension count on `Sym^2F`.  The global
exceptional hyperplane cut is a surface

\[
               S_5\subset\operatorname{Sym}^2F,
               \qquad b_{s,*}S_5=5F^2.
\]

To obtain a one-cycle one must restrict it over a curve `C subset F^2`.
Then the output is `5C`.  Any intrinsic curve on the Fano surface has even
theta degree because

\[
                         a_s^*\Theta=2C_s
\]

numerically.  More precisely, the Poincare construction from a curve `C`
has Rosati operator `N_C` with

\[
                \operatorname{tr}(N_C)=\Theta\cdot a_{s,*}C
                   =2(C_s\cdot C).
\]

In the `A_5`-equivariant scalar channel, `N_C=lambda I_5`, so
`5lambda` is even and therefore `lambda` is even.  Composing with the
exceptional `-5` correspondence remains divisible by ten.  In particular,
the incidence curve has `N_{C_s}=2I_5` and produces multiplier `-10`, not
five.  It cannot be combined with two to obtain one.  Without equivariance a
general curve can give a nonscalar Rosati operator; even trace alone should
not be misquoted as entrywise evenness.

Thus there are two sharply different statements:

1. **Lift cokernel (closed fibrewise):** once `eta` on `D_+` is given, the
   exceptional quintic supplies the odd degree-five lift needed to combine
   with Shen's degree-two lift.
2. **Horizontality/operator gate (open):** the exceptional quintic does not
   itself construct a relative minimal curve on `D_+` or a codimension-two
   cycle on `J times X` inducing `[5]`.

No autonomous relative `[5]` follows from Beauville's exceptional geometry.

## Sources and audit boundary

- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Theorem 13.4 and proof: the difference image is `Theta` and the
  ordered difference map has degree six.
- M. Shen, *Rationality, universal generation and the integral Hodge
  conjecture*, arXiv:1602.07331, Lemma 5.6 and Proposition 5.7: `D_+` has
  class `3Theta`, the ordered sum map has degree two, and the signed minimal
  cycle `eta` is supported on `D_+`.
- A. Beauville, *Vector bundles on the cubic threefold*,
  arXiv:math/0005017, the Prym/conic-bundle discussion and Section 6,
  Theorem 6.3 and Remark 6.5: the discriminant is a plane quintic, the compactified
  moduli space is the blow-up of `J^2(X)` along `F^2`, its split boundary is
  `Sym^2 F`, and restriction of the blow-down is the sum map to `F+F`.
- `notes/2026-08-10-c904-shen-minimal-curve-ordering-audit.md`: exact source
  trace for what Shen does and does not claim about quotient/ordered lifts.
- `notes/2026-08-10-c904-fano-symmetric-transfer.md`: exact 30=`2*15`
  degree calculation and the ordered transfer theorem.

The exceptional geometry and fixed-fibre integral quotient lift are closed.
No claim here constructs the relative Shen cycle.

## Mystery ledger

- **Settled:** common-line normalization makes `0 in F`, hence `F subset
  Theta`, fibrewise and relatively.
- **Settled:** `Sym^2 F -> D_+` is degree one and birational.
- **Settled:** over the birational locus, the unordered theta-pair lift has
  exact degree/index one; ordered splitting is irrelevant.
- **Settled:** this route is outside the scope of the ordered
  lift--transfer parity theorem.
- **Settled:** the exceptional image of `Sym^2 F -> D_+` is the conic Fano
  surface `F^2`.
- **Settled:** exceptional components have a degree-five lift cut from the
  plane-quintic discriminant; together with Shen's degree-two lift this gives
  an exact integral quotient lift of `eta` by `3*2-5=1`.
- **Open:** construction/descent of a relative `eta` on the present marked
  base.
