# C907 proper-support descent removes the common-fan requirement

**Lane:** `clebsch`

**Status:** theorem-grade proper-support descent lemma and a sharp correction
to the common-model gate.  The compactly supported direct image of the
original open graph is independent of compactification, and nearby/vanishing
cycles commute with proper modifications.  Consequently one common
**toroidal fan** is unnecessary.  However, local acyclicity must be proved on
the whole proper fibre of one modification (or by proper cohomological
descent); one good lift of each valuation is not enough.  The existing
protected and exterior charts have not yet been assembled into that
whole-fibre cover.

This does not by itself identify the four residual thimbles with Iritani's
individual Gamma basis.  It replaces the false global-Fitting demand by a
finite **proper-pushforward local-acyclicity** audit.

## 1. The intrinsic object

Let

\[
 a=(p,L):G^\circ\longrightarrow D\times\Omega
 \tag{1}
\]

be the original very-affine graph over a small parameter disk `D` and a
bounded value disk \(\Omega\Subset\mathbf C^*\).  Fix coefficients
`A=Z[1/6]`.  For any compactification

\[
 G^\circ\xrightarrow{j}\overline G
 \xrightarrow{\bar a}D\times\Omega,
 \qquad \bar a\text{ proper},
 \tag{2}
\]

define

\[
 K_a=R\bar a_*j_!A_{G^\circ}=Ra_!A_{G^\circ}.
 \tag{3}
\]

The right-hand side makes independence of (2) explicit.  This is the
constructible object whose fibre over `delta` computes the compactly
supported topology of the value map and hence the value-localized thimble
group.  Constant sheaves on boundary divisors of a chosen resolution are not
the object.

Let

\[
 \pi:\widetilde G\longrightarrow\overline G
 \tag{4}
\]

be any proper modification which is an isomorphism on `G^circ`, and let
`tilde j:G^circ->tilde G`.  There is a canonical identity

\[
 R\pi_*\widetilde j_!A_{G^\circ}\simeq j_!A_{G^\circ}.
 \tag{5}
\]

Indeed it is the identity on the open graph.  At a boundary point, proper
base change computes the stalk from a proper fibre contained in the boundary,
where `tilde j_!A` restricts to zero.  Thus all its derived stalks vanish.

If `q` is a coordinate on `D` or `Omega`, proper pushforward commutes with
nearby and vanishing cycles.  Combining this with (5) gives

\[
 R\pi_*\psi_{q\circ\bar a\circ\pi}(\widetilde j_!A)
 \simeq\psi_{q\circ\bar a}(j_!A),\qquad
 R\pi_*\phi_{q\circ\bar a\circ\pi}(\widetilde j_!A)
 \simeq\phi_{q\circ\bar a}(j_!A).
 \tag{6}
\]

The same holds for the iterated functors needed for the parameter/value
problem, such as `psi_delta phi_(L-u)`.  Therefore a boundary component
created by a blow-up can be critical for the restricted regular function on
that component without contributing a new summand to (3).  Its contribution
is computed with `tilde j_!A`, not with the constant sheaf of the exceptional
divisor, and only its proper pushforward is intrinsic.

## 2. Modification-local acyclicity criterion

Let `x` be a point of the boundary of one coarse proper compactification
`bar G`.  Suppose there is a proper modification (4), an open neighborhood
`V` of `x`, and a Whitney stratification of `pi^{-1}(V)` compatible with the
actual boundary such that:

1. the actual-boundary pair is a proper controlled `L`-submersion over
   `Omega` (equivalently, one supplies the needed
   `SS(tilde j_!A)`-noncharacteristic certificate; a bare Fitting unit on a
   chosen stratum is not enough);
2. `tilde j_!A` is constructible for this stratification; and
3. no protected Morse section lies over `V`.

Assume these conditions hold on the **entire** proper inverse image
`pi^{-1}(V)`, not merely on one chart or on one point of each fibre.  Then
Thom--Mather local triviality gives

\[
 \phi_{L-u}(\widetilde j_!A)|_{\pi^{-1}(V)}=0
 \quad(u\in\Omega).
 \tag{7}
\]

Equations (6)--(7) imply

\[
 \phi_{L-u}(j_!A)_x=0.
 \tag{8}
\]

Thus local acyclicity may be checked after a **different** proper
modification near each member of a finite boundary cover, provided each such
modification is controlled on its entire proper inverse image.  There is no
need for a common fan to make every auxiliary marked valuation monomial.
Alternatively one may use a proper hypercover, but then cohomological descent
and every multiple intersection are part of the proof.

For a regular SNC chart, the coarse tangent tests already used in C907 are
candidate local certificates for condition 1, but the control/Whitney or
microsupport compatibility must still be checked on their finite cover.  The
protected bounded chart is excluded from (7) and retains its four Morse
sections.

## 3. Why the forced `(h,v)` exceptional families are harmless here

The common marked-fan construction is forced to blow up `(h,v)`.  On its
exceptional divisor the restricted potential is

\[
 F=f_Q,
 \tag{9}
\]

and has four critical families with the new residue coordinate free.  This
correctly disproves stratumwise `L`-submersivity for the constant sheaf on
that fine boundary divisor.  It does **not** prove that (3) gains four
families.

The blow-up is a proper modification which is the identity on the original
open graph.  Hence (5)--(6) identify its total extension-by-zero
vanishing-cycle pushforward with that of the unblown ratio chart.  In the
unblown finite-ratio chart, `partial_v F=1` on every nonempty actual-boundary
piece.  Therefore the downstairs object is locally acyclic there only after
the whole blow-up fibre is compared with that unblown chart.  The **total**
exceptional vanishing-cycle complex may have zero proper pushforward by
derived cancellation; no individual exceptional family is asserted to
vanish.  Requiring every exceptional stratum itself to be
`L`-submersive was stronger than the compactly supported topology requires.

This is exactly analogous to computing `Rf_!` from two compactifications:
the boundary complexes may look different, while their proper pushforwards
are canonically the same.

## 4. Application to the landed C907 atlas

Take as coarse ambient the multihomogeneous Cartier graph closure in the
projective `y` and two marked-line ambient.  It is proper over
\(D\times\Omega\); regularity of this coarse ambient is unnecessary.

There are two kinds of proper local modifications of it.

1. **Exterior.**  The supported intrinsic tropical compactification is the
   strict closure of the same dense graph.  Filtered Koszul proves its full
   initials.  On all exterior masks, `L` is either free, the face is empty
   over `Omega`, or one of the 70 regular residue derivations has unit
   derivative.  Hence its extension-by-zero complex is `L`-locally acyclic.
2. **Protected residual ends.**  The two projective ratio-graph
   modifications are proper closures of rational graphs of the same open
   graph.  Their finite-ratio charts have the exact unit derivatives
   `partial_v F=1` and `partial_w F=1`; ratio poles either make `L`
   unbounded or enter one of the exterior types.  The bounded chart contains
   exactly the four reduced residual Morse sections.

The valuative trichotomy, together with complex curve selection at a point of
the coarse closure, shows only that every bounded-value boundary germ has
**a** lift to one of these two kinds of chart.  That is weaker than the
whole-fibre hypothesis of Section 2: other lifts over the same coarse point
can contribute after proper pushforward.  Consequently the current atlas
does not yet prove that the four protected sections are the only vanishing
cycles.  What it proves is the exact target for a shorter replacement:
construct one proper modification per coarse boundary neighborhood whose
entire fibre is covered by the certified ratio/exterior charts, or construct
a finite proper hypercover and verify its intersections.

The remaining application audit is finite and narrower than the former
global gluing theorem:

- record explicitly that each exterior and ratio model maps properly to the
  coarse Cartier closure and is the identity on the same `G^circ`;
- strengthen the valuative image cover to a finite **whole-proper-fibre**
  chart cover (or a proper-hypercover descent certificate);
- make the ordinary type-`1` residue derivatives explicit on the chosen
  unimodular scheme charts; and
- run (6) first for `L-u` and then for `delta`, preserving the four section
  labels and their nonbraiding.

None of these items asks for a common toroidal refinement, but it does ask
for one coherent proper fibre or a full descent diagram.

## 5. From vanishing cycles to the four-thimble group

On a value line, the shifted compact-support direct image is perverse **after
the usual tame-Lefschetz comparison is proved**.  Once the preceding finite
whole-fibre audit proves that its vanishing cycles are precisely the four
rank-one Morse groups, the usual cut-disk calculation gives a free rank-four
compact-support group.  Identifying that group with the C907 rapid-decay
thimble/Stokes object, including labels and pairing, remains a separate
comparison gate; compactification independence alone does not supply it.

At `delta=0`, the bounded chart is `f_Q+ZW`.  Thom--Sebastiani identifies its
four local groups and directed local Seifert pairing with the `P^3` system.
Proper-support descent transports the constructible object and its
Verdier-dual pairing through the parameter comparison.  Labels, sector
ordering, and the identification with Iritani's rapid-decay/Gamma object must
be included in the tame-Lefschetz comparison.  It still does not identify an
individual transported thimble with Iritani's chosen central-connection
seed.

## 6. Source boundary

The two formal inputs are standard six-functor facts:

- compactly supported direct image is computed as
  `Ra_!=Rbar a_* j_!` and is independent of compactification;
- nearby and vanishing cycles commute with proper direct image.

For the second statement see Claude Sabbah, *Vanishing cycles and their
algebraic computation (I)*, Theorem 1.3.1 (proper push-forward), official
lecture PDF
`https://perso.pages.math.cnrs.fr/users/claude.sabbah/livres/sabbah_notredame1305-pro1.pdf`.
The theorem states both the nearby- and vanishing-cycle identities for a
proper map.  Mather's controlled first isotopy theorem supplies the local
acyclicity implication (7); its cached source and exact proposition numbers
are recorded in `2026-08-12-c907-controlled-fibrewise-pair-theorem.md`.

## EJ/TT and mystery ledger

- **EJ:** use the intrinsic compact-support object rather than demanding a
  globally good boundary for the constant sheaf.  This turns incompatible
  compactifications into legitimate local proof charts.
- **EJ2:** the forced exceptional `f_Q` families are not automatically new
  thimbles; only the total extension-by-zero complex after proper pushforward
  is intrinsic.
- **TT:** the correct descent unit is a proper modification, not a common
  fan.  Local acyclicity is allowed to be proved on different modifications
  because the target is `Ra_!`, not a chosen boundary-stratum ledger.
- **Settled:** compactification independence; proper-modification descent;
  and why the common-*fan* obstruction is not intrinsically fatal.
- **Open:** a whole-proper-fibre chart cover or proper hypercover; controlled
  local acyclicity for `j_!`; the compact-support-to-rapid-decay comparison
  with labels/pairing; then the Gamma/Orlov central-connection seed.  The strict
  positive-order Rees comparison and universal carrier theorem remain
  separate.
