# C907 — a descendant/Gamma intertwiner for the Geiser middle flop

Date: 2026-08-13

Status: exact geometric regression and a proof extension of Chen--Tseng from
one simple flop to a finite disjoint union of simple flops.  This constructs
the missing intrinsic Gamma/descendant frame transition for the **middle
flop** of the point-centred Geiser Sarkisov peak, including after product with
`P^2`.  It does not yet attach the two wall-local point-blowup receivers to
that intrinsic flop frame, does not close the complete Geiser peak, and does
not prove Gold.

## 1. Why this is the right first peak

The line-centred link of a cubic threefold ends in a conic bundle.  It is a
useful warning against rigidity, but it is not a two-contraction exchange
between smooth projective models of the kind left by valley localization.
The first genuine peak is the Geiser self-link.

Let `X` be a smooth cubic threefold and choose a point `p` in the dense open
set of Blanc--Lamy Lemma 2.10.  Then the tangent hyperplane section has an
ordinary double point at `p` and exactly six distinct lines of `X` pass
through `p`.  Put

\[
 \sigma:Y=\operatorname{Bl}_pX\longrightarrow X,
 \qquad H=\sigma^*\mathcal O_X(1),\qquad E=\operatorname{Exc}(\sigma).
\]

Writing `D=H-E`, one has

\[
 K_Y=-2H+2E=-2D,
 \qquad D^3=2.
\]

The system `|D|` resolves projection from `p` and gives the generically
two-to-one map to `P^3`.  If `h` is the class of a general line pulled back
from `X` and `e` a line in `E`, the strict transforms of the six lines through
`p` all have class

\[
 c=h-e,qquad D\cdot c=0.
\]

They are six disjoint `(-1,-1)` curves.  Flopping them gives `Y^+`.  The
strict transform of the tangent section, whose class before the flop is

\[
 T=H-2E,
\]

is a `P^2` with normal bundle `O(-1)` and contracts to a smooth point of a
second cubic `X'` (isomorphic to `X` in the self-link).  Thus

\[
 X \xleftarrow{\ \operatorname{Bl}_p\ }Y
 \dashrightarrow Y^+
 \xrightarrow{\ \operatorname{Bl}_{p'}\ }X'
 \tag{1}
\]

is the desired peak.

## 2. Exact lattice and deleted-corner calculation

Across the flop identify divisor groups in codimension one and set

\[
 E'=H-2E,
 \qquad H'=2H-3E.
 \tag{2}
\]

Then `H'-E'=H-E`, `K_{Y^+}=-2H'+2E'`, and the simple-flop cubic correction

\[
 (ABC)_{Y^+}=(ABC)_Y-
 \sum_{i=1}^6(A\cdot c_i)(B\cdot c_i)(C\cdot c_i)
\]

gives

\[
 (H')^3=3,\qquad (E')^3=1,\qquad (H')^2E'=H'(E')^2=0.
\]

The induced involutions are

\[
 H\mapsto2H-3E,qquad E\mapsto H-2E,
 \tag{3}
\]

and

\[
 h\mapsto2h-e,qquad e\mapsto3h-2e,qquad c\mapsto-c.
 \tag{4}
\]

This supplies a particularly sharp regression against formal-corner
banking.  With

\[
 u=Q^h,\quad q=Q^e,\quad
 u'=Q^{h'},\quad q'=Q^{e'},
\]

the common Novikov torus has

\[
 u'=u^2q^{-1},qquad q'=u^3q^{-2},
 \tag{5}
\]

with the same formulas in the opposite direction.  Equivalently, in the
pre-flop Mori coordinates `q=Q^e`, `s=Q^c`,

\[
 s'=s^{-1},qquad q'=qs^3.
 \tag{6}
\]

The two large-radius origins are therefore absent from their Laurent
overlap.  The peak cannot be closed by evaluating both exceptional variables
at zero, by formal-constant banking, or by a good formal structure at the
corner.  What is needed is an actual analytic continuation through the
flop.

## 3. The new input: descendant/Fourier--Mukai compatibility

Chen--Tseng, arXiv:2604.09962v1, Theorem 0.2 proves the following for a
single simple flop with exceptional `P^r` and normal
`O(-1)^{\oplus r+1}`.  If

\[
 \operatorname{FM}:K(Y)\longrightarrow K(Y^+)
\]

is the Fourier--Mukai map from the common blowup and `U` is the descendant
correspondence obtained by analytically continuing the quantum differential
system from `s=0` to `s'=s^{-1}=0`, then

\[
 \boxed{U\,\Psi_Y(\alpha)=\Psi_{Y^+}(\operatorname{FM}(\alpha))}
 \tag{7}
\]

for every even K-class `alpha`.  Here

\[
 \Psi_Y(\alpha)=z^{-\mu_Y}z^{\rho_Y}
 \widehat\Gamma_Y(2\pi i)^{\deg_0/2}\operatorname{ch}(\alpha)
\]

is Iritani's Gamma framing.  Their `U` is independent of every Novikov
variable.  Equation (7), not quantum-ring invariance alone, is exactly the
frame transition missing from the formal peak proposals.

The printed theorem assumes one connected `P^r`; it does **not** literally
cover the six-curve Geiser flop or its product with `P^2`.  Sequentially
applying it six times is also illegitimate: the six curves are numerically
equivalent and need not admit six projective one-curve contractions.

## 4. Finite-disjoint-simple-flop extension

The following is a direct extension of Chen--Tseng's proof, rather than a
claim about the wording of their theorem.

**Lemma.**  Let `Y --> W <-- Y^+` be a projective flop of smooth projective
varieties whose exceptional locus is a finite disjoint union

\[
 Z=\coprod_{a=1}^N\mathbf P^r,
 \qquad N_{Z_a/Y}\cong
 \mathcal O_{\mathbf P^r}(-1)^{\oplus r+1},
\]

and suppose all components span the same extremal curve class.  Then the
descendant transformation `U` and the Fourier--Mukai transform satisfy (7).

**Proof.**  Every step of Chen--Tseng Sections 2--3 commutes with a finite
disjoint union.

1. Deformation to the normal cone of `Z` has central fibre
   `Bl_ZY` together with
   `P_Z(N_{Z/Y}\oplus O_Z)`, and the latter is the disjoint union of the `N`
   projective local models.  The Borel--Moore specialization injection and
   the even-cohomology Mayer--Vietoris embedding used in their (2.1)--(2.4)
   are unchanged.
2. The good degeneration of a coherent sheaf and its Fourier--Mukai image
   in their Section 2.2 is performed along the same disconnected smooth
   centre.  The common-blowup kernel and all restrictions split over the
   disjoint local components.
3. Extremal stable maps lie in exactly one `Z_a`.  Hence the extremal
   descendant fundamental solution is the identity on the common blowup
   factor together with the direct sum of the `N` projective-local
   fundamental solutions.  This is the disconnected version of their
   displayed block formula preceding (3.8).
4. Coates--Iritani--Jiang's toric Gamma/Fourier--Mukai identity applies to
   every projective local component.  Taking their direct sum proves the
   analogue of Chen--Tseng (3.12), after which their specialization
   injection proves (7).

No connectedness is used in these four operations.  This proves the lemma.
`\square`

For the Geiser flop, `r=1` and `N=6`, so the lemma applies.

## 5. Exact point-row consequence

Choose a point `y` away from the exceptional divisors and the six flopping
curves, and let `y^+` be the same point in the common open subset.  The
Fourier--Mukai kernel is the graph of the isomorphism there, whence

\[
 \operatorname{FM}(\mathcal O_y)=\mathcal O_{y^+}.
\]

Equation (7) gives the exact identity

\[
 \boxed{U\Psi_Y(\mathcal O_y)=\Psi_{Y^+}(\mathcal O_{y^+}).}
 \tag{8}
\]

In dimension three the Gamma and `z^rho` factors have no higher action on a
top point class, so this is literally preservation of the normalized point
column.  The symplectic/Euler pairing therefore transports the rank row.
Because `U` intertwines the descendant quantum differential systems, it also
transports the whole primitive-sixth formal-monodromy packet.  Consequently

\[
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \iff
 \mathfrak r_{Y^+}|_{P_6(Y^+)}\ne0
 \tag{9}
\]

in the two incident analytic receivers.

This is the datum the earlier formal proposals could not manufacture for the
middle crepant wall.  The Laurent relation (5) causes no problem **inside
that wall**: `U` is precisely analytic continuation across its deleted
overlap and is independent of the remaining Novikov variables.

It is not yet enough to compose the complete peak.  The two point blowups in
(1) are controlled by
`2026-08-13-c907-simple-vgit-rank-theorem.md` only in their own fixed-wall
sectorial receivers.  That theorem explicitly does not identify either
receiver's copy of `Y` or `Y^+` with the intrinsic large-radius Gamma frame
used in (7).  In coordinates, the first attachment is normalized in the
point-exceptional direction `e`, the middle continuation runs in the flopping
direction `c=h-e`, and the second attachment is normalized in
`e'=e+3c`.  The transition (5) shows why these cannot be silently regarded as
one formal chart.

Thus the complete Geiser conclusion remains the conditional statement

\[
 \boxed{
 \text{intrinsic attachment of both point-blowup rows to (7)}
 \Longrightarrow
 \bigl(\mathfrak r_X|_{P_6(X)}\ne0
 \iff
 \mathfrak r_{X'}|_{P_6(X')}\ne0\bigr).}
 \tag{10}
\]

This is a smaller residue than the original peak problem: its crepant middle
transition is now exact, and only two discrepant attachment maps remain.

## 6. Product with `P^2`

Taking (1) times `P^2` blows up `{p} x P^2`, flops the six disjoint families
`c_i x P^2`, and contracts the transformed tangent divisor times `P^2`.
Numerically,

\[
 \operatorname{rk}K_0^{\rm num}:\qquad
 12\longrightarrow18\longrightarrow18\longrightarrow12;
\]

the point-blowup packet is two copies of `K_0(P^2)`, not six independent
flop packets.

For the **small** quantum D-module used by C907, product/Kunneth naturality
gives

\[
 U_{Y\times\mathbf P^2}=U_Y\otimes\mathrm{id}_{\mathbf P^2},
 \qquad
 \Psi_{Y\times\mathbf P^2}(E\boxtimes F)
 =\Psi_Y(E)\otimes\Psi_{\mathbf P^2}(F).
\]

The Fourier--Mukai kernel also external-products with the diagonal of
`P^2`.  Therefore (8)--(9) tensor with every projective-space Gamma factor.
The aggregate primitive-sixth packet and the rank covector are preserved
across the middle fivefold flop.  Equation (10) remains conditional on the
two point-blowup attachments, now after external product with `P^2`.

This product argument is deliberately used instead of citing Chen--Tseng for
the ordinary flop over `P^2`: their Remark 3.1 says that the split ordinary
case should follow by their method, but they do not prove it there.

## 7. What the negatives buy

The failed routes now have a positive use: they identify the only kind of
input worth seeking.

1. Formal QDM decompositions, scalar constancy, Artin receivers, and good
   formal structures cannot cross (5).  Do not spend more time trying to
   force them to.
2. Valley localization remains useful: it reduces globalization to a
   library of peak intertwiners.
3. For a peak containing a crepant wall, the correct target is a
   **descendant/Gamma/Fourier--Mukai intertwiner**, not another formal
   decomposition.  Chen--Tseng supplies the first one.
4. The next publishable theorem is the split ordinary-flop extension of
   Chen--Tseng Remark 3.1.  Their degeneration proof reduces it to the
   descendant/Gamma theorem for split toric bundles.  It would cover all
   products of simple flops and a much larger class of Sarkisov peaks.
5. The immediate Geiser residue is a **mixed two-parameter attachment
   theorem**: identify the point-blowup wall-local rank row with the intrinsic
   Gamma frame on `Y`, uniformly while the transverse flop parameter remains
   available for continuation.  This is narrower and more testable than a
   general peak theorem.
6. Gold still requires either enough complete peak intertwiners to cover the
   peaks in a smooth fivefold factorization or a theorem reducing those peaks
   to a controlled library.  The Geiser calculation is a positive regression,
   not that classification.

## Sources

- J. Blanc and S. Lamy, *On birational maps from cubic threefolds*,
  arXiv:1409.7778, introduction and Lemma 2.10.  Cached PDF SHA-256:
  `de33c70c6b0a1274fa1779b315304c4bccbe89bff094e58af46713e90e28c1cd`.
- J.-C. Chen and H.-H. Tseng, *Descendant and Fourier--Mukai equivalences
  for simple flops*, arXiv:2604.09962v1, Theorem 0.2, Sections 1--3, and
  Remark 3.1.  Cached PDF SHA-256:
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Y.-P. Lee, H.-W. Lin, F. Qu, and C.-L. Wang, *Invariance of quantum rings
  under ordinary flops III*, arXiv:1401.7097, for the analytic continuation
  of ordinary-flop quantum rings.  This source alone is insufficient because
  it explicitly does not identify descendants.  Cached PDF SHA-256:
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.

## EJ / TT / AA

- **EJ:** the Geiser peak turns the abstract `B=qq'` obstruction into the
  exact transition `u'=u^2/q`, `q'=u^3/q^2`; Chen--Tseng's `U` supplies the
  middle analytic bridge and fixes the off-exceptional Gamma point class by
  Fourier--Mukai functoriality.  The remaining obstruction is no longer the
  flop: it is attaching the two discrepant point-blowup receivers to that
  bridge.
- **TT:** Chen--Tseng's stated theorem has one connected exceptional `P^r`.
  Six curves and `x P^2` are not citation-level instances.  The former is
  covered by the finite-disjoint proof extension above; the latter is handled
  by small-QDM product naturality, not by silently promoting Remark 3.1.
- **AA:** this closes one explicit Gold-relevant **middle wall**, not the
  whole peak.  It does not make a general weak factorization a chain of Geiser
  peaks, and it does not repair singular/toroidal wall coverage.
