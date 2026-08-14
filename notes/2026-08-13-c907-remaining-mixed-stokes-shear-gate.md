# C907 — the sole remaining Gold failure mode is a mixed ambient Stokes shear

Date: 2026-08-13

Status: exact reduction, not Gold closure.  After the ordinary-flop theorem,
the simple-VGIT wall theorem, and the AKMW unit-circuit coverage theorem, a
failure of the Gamma-rank telescope can occur only at two consecutive
discrepant unit walls.  The transition must contain an exponentially small
**ambient-to-ambient** Stokes shear which changes the rank restriction on the
primitive-sixth packet.  Center-supported shears, single-wall effects,
ordinary crepant directions, and packet-faithful `c_1`-positive carrier faces
cannot cause failure.  A dangerous shear must be supported by an affine
tower of mixed classes in a `c_1`-neutral direction involving both incident
wall parameters.

This is the precise target for either a final proof or a counterexample.

## 1. Set-up after geometric coverage

Choose the projective pi-desingularized AKMW elementary chain between
`X x P^2` and `P^5`.  By
`2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md`, every wall is a
unit-coefficient standard wall (including blowups as one-sided cases).

For an ordinary wall, the intrinsic C907 point-row theorem compares the
large-radius Gamma row and `P_6` across analytic continuation.  Such a wall
composes without a receiver choice.

For a discrepant wall, Gu--Yu--Yu give a pairing-compatible decomposition

\[
 QDM(Y_-)=QDM(Y_+)\oplus\bigoplus_j QDM(S)_j,                       \tag{1}
\]

and the C907 simple-wall theorem gives, in its fixed-sector receiver,

\[
 r_-|_{\mathrm{amb}}=r_+,
 \qquad r_-|_{QDM(S)_j}=0.                                         \tag{2}
\]

Thus only a chamber `Y` incident to two discrepant walls has two unresolved
realizations.  Let `R_L(Y)` and `R_R(Y)` denote their sectorial fibre
functors and let

\[
 T_Y:R_L(Y)\dashrightarrow R_R(Y)                                  \tag{3}
\]

be the unproved transition.

## 2. Center shears are harmless

Let `C_L,C_R` be the sums of all wall/exceptional blocks entering the two
receivers.  Every Gamma lattice vector in either center block is represented
by an object supported on the exceptional locus, hence has rank zero.  By
flat Gamma/Euler pairing,

\[
 r_Y(C_L)=r_Y(C_R)=0.                                               \tag{4}
\]

Suppose the transition (3), in either orientation, differs from its ambient
identification only by maps through these center blocks.  Then

\[
 r_YT_Y=r_Y                                                        \tag{5}
\]

on the whole ambient solution space.  Consequently its restriction is
nonzero on `P_6` in one receiver iff it is nonzero in the other.  This remains
true for any finite sequence of mutations by center blocks and for every
`O(kE)` twist, since support and rank do not change.

Therefore the familiar Stokes-small center admixtures are not the remaining
problem.  A counterexample must have a nonzero induced transformation on the
ambient quotient

\[
 \overline T_Y: R_L(Y)/C_L\longrightarrow R_R(Y)/C_R.             \tag{6}
\]

## 3. Exact shape of a Boolean-changing shear

The positive-`z` QDM identifications on both sides of (6) are the same
intrinsic ambient QDM of `Y`.  Hence the formal asymptotic expansion of
`overline T_Y` is the identity.  Any nonidentity term is an exponentially
small Stokes automorphism, invisible in the formal Novikov/QDM category.

For it to change the Boolean, there must be a primitive-sixth vector `v` and
an ambient vector `w` outside its sectorial packet such that a Stokes term

\[
 v\longmapsto v+c\,w\quad\text{or}\quad
 w\longmapsto w+c\,v,\qquad c\ne0,                                \tag{7}
\]

changes whether `r_Y` annihilates the transported packet.  Necessarily

\[
 r_Y(w)\ne0                                                        \tag{8}
\]

in the dangerous orientation.  A shear into a center direction violates
(8) by (4), and a change of basis internal to `P_6` cannot change whether the
restriction of a covector to the whole packet is zero.

Thus the missing datum is one ambient-to-ambient Stokes coefficient, not a
center row and not the full central connection matrix.

## 4. Its curve classes must form a mixed `c_1`-neutral tower

A one-wall contribution is already measured by (1)--(2), so a coefficient
in (7) must involve both incident wall parameters.  It disappears on each
one-axis extremal specialization and can only occur in mixed monomials.

If all packet-carrying mixed classes lie on an exposed rational-polyhedral
face on which `c_1` is strictly positive, the complete carrier connection is
polynomial by the genus-zero dimension axiom.  The K-positive carrier-face
theorem then joins the two receivers in one honest nonturning analytic family
and rules out a Boolean-changing transition.

If the mixed direction is an ordinary crepant extremal ray, the LLW graph
gauge and the ordinary-flop point-row theorem rule it out.

The precise conclusion is slightly subtler than saying that the dangerous
stable-map class itself has `c_1=0`.  A surviving coefficient requires a
nonzero numerical direction `delta` with

\[
 c_1(Y)\cdot\delta=0,                                               \tag{9}
\]

and infinitely many effective packet-carrying classes in an affine tower

\[
 \beta_n=\beta_0+n\delta.                                          \tag{9a}
\]

Here `delta` involves both incident parameters but is not itself isolated as
an ordinary-flop ray covered by the graph theorem.  It can be a formal
difference direction even when not every `delta` is separately effective;
what matters is effectivity of the tower.  The contact-budget examples show
that neutral directions are not formally impossible: iterated blowups can
create K-trivial differences of exceptional curves.

What is now required is far stronger: the tower (9a) must produce the
ambient Stokes coefficient (7) with the nonzero-rank condition (8).  The
individual classes can have positive fixed `c_1(beta_0)`; the zero slope in
the `delta` direction is what defeats coefficientwise polynomiality.

## 5. Two exact routes to closure

Before the two routes, one large class of suspects can be eliminated
unconditionally.

### Pure-boundary elimination lemma

Let `D subset Y` be the union of the toroidal/exceptional boundary strata in
the chosen AKMW model, and let

\[
 H_D=\operatorname{im}\bigl(H_D^*(Y)\longrightarrow H^*(Y)\bigr). \tag{10}
\]

Suppose an effective curve class `beta` has the property that every stable
map of class `beta` is supported in `D`.  For any insertions, the output
evaluation map of the corresponding genus-zero correspondence factors
through `D`.  If `Q_beta(alpha)` denotes the `Q^beta` coefficient of quantum
multiplication by `alpha`, then every positive-`beta` correction has image in
`H_D`:

\[
 Q_\beta(\alpha)(H^*(Y))\subset H_D.                                \tag{11}
\]

The same support argument makes `H_D` stable under these corrections.  Thus
the quantum connection in all such variables induces, on the quotient, only
the fixed classical divisor action and no positive-curve correction:

\[
 H^*(Y)/H_D.                                                       \tag{12}
\]

Its irregular sectorial/Stokes transport is therefore the identity on (12),
up to the regular classical line-bundle factor, which preserves rank.  Under
Chern character, `H_D` is generated over `C` by supported perfect classes and
the Gamma rank covector annihilates it.  Therefore a pure-boundary class can
produce only the harmless center-type shears of Section 2, even when
`c_1(beta)=0` and even when several exceptional variables occur.

This eliminates the concrete likely suspects already encountered:

- differences and combinations of exceptional fibre classes created by
  iterated blowups;
- the six Geiser flop curves and all ordinary-flop packets;
- center-supported curve/surface packets in the standard walls;
- the Fano-surface/C908 two-layer packet;
- any toroidal circuit curve contained in the factorization boundary.

The support lemma does **not** eliminate a connected stable map with an
off-boundary component and boundary bubbles.  Such a class can meet the
chosen point on its ambient component.  Consequently the only remaining
geometric suspect is a tower

\[
 \beta_n=\beta_{\mathrm{carrier}}+\tau_0+n\delta,\qquad
 c_1(\delta)=0,                                                     \tag{13}
\]

where the first component carries the cubic primitive-sixth atom and
`tau_0+n delta` is a boundary tree meeting it at relative nodes.  The total
`c_1(beta_n)` can be positive and fixed.  This is a mixed relative-Gromov--
Witten effect, not a pure exceptional-class effect.  None of the currently
computed regressions exhibits a nonzero coefficient of this kind.

### Route A: vanishing/triangularity

Prove that every neutral-tail Stokes term between incident unit walls factors
through the wall-supported categories.  Equation (4) then kills it.  A
categorical version would say that the incident window transition is a
finite composition of mutations by unstable-stratum objects; rank descends
unchanged to the ambient quotient.

This is weaker than a full Gamma/Orlov/Stokes theorem: only the quotient
transition and one rank row are involved.

### Route B: a two-wall Fourier--Fubini receiver

Construct one rank-two master for the two incident unit circuits.  At every
Artin level in the remaining Novikov variables, the two orders of the
Gu--Yu--Yu Mellin--Barnes/Fourier transform are finite-dimensional integrals.
On a common absolute-convergence sector, Fubini gives equality of the two
orders; Gamma kernels and pairings factor, and the common-open point class
has zero restriction to every unstable stratum.  The resulting common
receiver makes `overline T_Y=id` on the rank row.

The bounded regression is the smallest pair of adjacent unit discrepant
toric circuits.  A failure there must exhibit the coefficient `c` in (7)
explicitly.  A success gives the local analytic lemma needed for the full
AKMW chain because all other variables remain Artin-formal.

## 6. What cannot close the gate

- Formal constant banking: it cannot identify the two sectorial embeddings.
- Good formal structure at the two-parameter corner: it sees exponential
  labels but not the Stokes coefficient `c`.
- Center-row computation: center rows are annihilated already by (4).
- The C908 theta lattice: its ordinary blowup framing contains the primitive
  exceptional identity component and does not constrain (7).
- General birational rigidity: the product has explicit relative Sarkisov
  links and lies outside known rigidity criteria.

These negatives are now useful: they certify that any proposed proof which
does not address (7)--(9) is solving the wrong problem.

## EJ / TT / AA

- **EJ:** the only dangerous number is a mixed ambient Stokes coefficient
  whose target has nonzero rank.  Pure-boundary quantum corrections vanish
  on the ambient quotient, so the source must be a carrier component with a
  negative boundary tail.
- **TT:** “formal identity modulo centers” is insufficient; the shear in (7)
  is exponentially small and lives precisely beyond the formal comparison.
- **AA:** first enumerate the smallest unit two-circuit toric models which
  admit (13).  Models with only boundary-supported `c_1=0` curves are now
  proved harmless.  For the first model with an off-boundary carrier, compute
  the two Fourier orders; a discrepancy is the exact Gold falsifier.

## Dependencies

- `2026-08-13-c907-simple-vgit-rank-theorem.md`.
- `2026-08-13-c907-ordinary-flop-point-row-theorem.md`.
- `2026-08-13-c907-k-positive-carrier-face-peak-theorem.md`.
- `2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md`.
- `2026-08-13-c907-peak-confluence-obstruction.md`.
