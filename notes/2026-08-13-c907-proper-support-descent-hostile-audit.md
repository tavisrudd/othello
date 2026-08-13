# C907 hostile audit: proper-support modification descent

**Target:** `2026-08-13-c907-proper-support-modification-descent.md`  
**Verdict:** **MAJOR for the advertised C907 application; PASS, after small
qualification, for the formal proper-support mechanism.**

The distinction is sharp.  Proper-support descent genuinely removes the
requirement that a *good local calculation* be made on a common toroidal
model.  It does not turn separate arcwise protected/exterior charts into a
local-acyclicity proof downstairs.  One needs a fibrewise proper-modification
cover.  The current atlas has not supplied it.

## 1. What is formally correct

Let `U=G^circ`, let `j:U -> X` be an open immersion, and let
`pi:X' -> X` be proper and an isomorphism over `U`.  For the induced
`j':U -> X'`, there is indeed a canonical isomorphism

\[
 R\pi_*j'_!A\simeq j_!A. \tag{1}
\]

It is the identity on `U`.  At a point of `X\setminus U`, proper base change
identifies the stalk of the left side with the cohomology of the proper fibre
against a sheaf whose restriction to that fibre is zero.  This proves (1),
not merely equality after taking a global direct image.

If `q'=q\circ pi`, proper direct image commutes with nearby and vanishing
cycles:

\[
 R\pi_*\psi_{q'}F\simeq\psi_qR\pi_*F,\qquad
 R\pi_*\phi_{q'}F\simeq\phi_qR\pi_*F. \tag{2}
\]

Thus (1) gives the displayed identities in the target note.  Iterated
functors such as `psi_delta phi_(L-u)` are also legitimate: apply (2) one
functor at a time, with all functions pulled back along the same proper map.
This is exactly the scope of Sabbah's proper-pushforward theorem cited in the
target note.

Two qualifications belong in the statement.

1. `pi` must be a proper morphism **over the bases on which the indicated
   functions live**, and must be an isomorphism over precisely the same open
   graph `U`; a merely birational comparison of two strict closures is not
   enough.
2. From `Rpi_* phi=0` one may conclude that the **total** exceptional
   vanishing-cycle complex has zero proper pushforward.  One may not say that
   every exceptional component/family has zero pushforward separately:
   cancellation can occur in the derived complex unless a direct-sum
   decomposition has been proved.

The `(h,v)` observation is therefore a valid warning against computing with
the constant sheaf of the exceptional divisor.  It is not by itself a
calculation of the extension-by-zero complex after the blow-up.

## 2. Correct local criterion

Here is the sufficient statement actually supplied by proper descent.  For a
coarse boundary point `x`, it is enough to exhibit one proper modification
`pi_x:X_x' -> X`, isomorphic over `U`, and a proper controlled
`L`-product neighbourhood of the **whole fibre** `pi_x^{-1}(x)`.  The
neighbourhood must carry a finite stratification compatible with `U` and its
complement, with `j'_!A` constructible, such that `L` is a controlled
submersion there.  Equivalently, it suffices to prove directly that

\[
 \phi_{L-u}(j'_!A)|_{\pi_x^{-1}(x)}=0. \tag{3}
\]

Proper base change and (2) then give the desired zero stalk downstairs.
Covering the entire fibre is essential.

The wording in target §2 is too weak in two ways.

- `pi^{-1}(V)` is normally open and need not be proper over the value disk,
  so Thom--Mather proper isotopy cannot be invoked on it as written.  Supply
  a closed proper controlled-product neighbourhood, or state local sheaf
  acyclicity (3) as the hypothesis.
- Ordinary stratumwise unit derivatives in unrelated local charts do not,
  by themselves, prove a product for `j'_!A`.  The boundary and every other
  sheaf-singular locus must be labelled strata, and the required condition is
  a controlled/non-characteristic `L`-product.  In a regular SNC coordinate
  chart a single regular vector field tangent to the actual components with
  `D(L)` a unit supplies this explicitly.  The 70 exterior records are only
  conditional on the asserted regular-chart coverage/descent, as their own
  unit-lift note says.

Under these repairs, a finite family of different modifications is entirely
legitimate; they need not dominate one another.

## 3. The present valuative atlas does not meet that criterion

The proposed application makes a non sequitur:

\[
 \text{every arc has a lift to some good chart}
 \quad\not\Rightarrow\quad
 \phi_{L-u}(j_!A)_x=0. \tag{4}
\]

Curve selection can rule out a closed bad locus only after that locus has
been defined on one fixed proper model (or after a single modification has
been selected for the coarse point).  It cannot select a different
modification for different arcs and then provide the one fibrewise vanishing
statement (3).  Proper images are closed, not generally open, so images of
the separate good chart neighbourhoods do not make a local cover of the
coarse boundary either.

Concretely, the following records are missing.

1. For each exterior and protected ratio construction, a proper map to the
   same multihomogeneous Cartier closure over `D x Omega`, an identification
   with the same `G^circ`, and an exact specification of the strict
   extension-by-zero support.
2. For every coarse bounded-value boundary point `x`, one selected model
   `pi_x` and a neighbourhood containing all of `pi_x^{-1}(x)`, covered by
   its actual acyclic charts.  If multiple charts of that one model are used,
   their overlaps and all extra exceptional components must be included.
3. A finite image/fibre-cover proof, not merely the compact-`y` valuative
   trichotomy.  The latter itself says that the noncompact-`y` import and the
   protected/exterior attachment remain conditional.
4. The intrinsic exterior compactification must be compared to the coarse
   Cartier graph across the retained `U=0,V=0` divisors.  The existing
   intrinsic tangent note explicitly does not transfer its strict closure to
   an unrelated embedded resolution; the earlier coarse-gluing audit records
   precisely this comparison as open.

The common-fan obstruction shows why simply taking a common dominating
modification is not an innocent repair: it can introduce the polar-bad
exceptional family.  A fibrewise local choice may still solve the problem,
but it needs the four records above.  Until then, the sentence "Consequently
the only possible value vanishing cycles ... are the four" is unsupported.
The exact safe conclusion is conditional:

> If the finite fibrewise proper-modification acyclicity audit just listed is
> completed, then proper-support descent implies that all non-protected value
> vanishing cycles of `Ra_!A` vanish.  The only remaining possible value
> cycles are the four protected Morse sections.

## 4. The final thimble paragraph needs a second gate

Even after the conditional support statement, four local rank-one Morse
groups do not automatically imply a free rank-four compact-support thimble
group or transport a directed Seifert basis.  One needs the stated tame
perverse/Lefschetz hypothesis for the relevant `Ra_!` restriction, and an
iterated `psi_delta phi_L` audit.  Proper pushforward transports the total
object and is compatible with duality; it does not by itself preserve chosen
individual labels, a nonbraiding system of paths, or a directed pairing.
Those are separate residual-Morse and parameter-transport inputs.

## Required change in status

Keep §§1 and the corrected form of §2 as a theorem-grade structural lemma.
Downgrade §4--5 and the `Settled` ledger to **conditional / open finite
audit**.  In particular, do not state that the common-fan obstruction is
already irrelevant to the intrinsic thimble computation: it is irrelevant
only once one of the valid fibrewise descent covers has been constructed.
