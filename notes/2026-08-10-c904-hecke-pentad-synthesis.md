# C904: the cubic--quartic Hecke pentad

**Date:** 2026-08-10

**Status:** theorem synthesis from proved C904 inputs; quarantined research,
with no manuscript or Lean promotion

## Executive statement

The cubic and quartic families are not merely one Hecke-related pair.  After
passing to the common cover that identifies their elliptic multiplicity
motives, they occupy two complementary parts of a canonical five-member
packet of principally polarized fivefolds.

Fix the monodromy-selected three-primary gluing of the six-axis source with
coefficient polarization

\[
                         G=6I_5-J_5.
\]

Its $A_5$-stable two-primary principal gluings are naturally

\[
                  \mathbf P^1(\mathbf F_4).
\]

The three points of $\mathbf P^1(\mathbf F_2)$ are exactly the gluings that
retain the full $S_6$ simplex symmetry.  The remaining two points are the
exceptional $A_5$ gluings, exchanged by the order-two normalizer.  Thus the
packet has the intrinsic split

\[
 \mathbf P^1(\mathbf F_4)
 =\underbrace{\mathbf P^1(\mathbf F_2)}_{\text{three classical sheets}}
  \sqcup
  \underbrace{\{\omega,\omega^2\}}_{\text{two exotic sheets}}.
\]

Geometrically, the three classical sheets are the three local
$\Gamma_0(2)$ choices in the forgetful cover $X_0(6)\to X_0(3)$ realized by
the $S_6$ quartic family.  The two exotic sheets are the two marked gluings
of the $A_5$ cubic family.  The latter are selected by the square class $T$;
the independent square class

\[
                         (T+27)(T-729/5)
\]

identifies the elliptic multiplicity motives.  Therefore the literal common
geometric packet lives over the already constructed biquadratic genus-three
marking cover, while the $3+2$ decomposition is visible before that final
twist is split.

Any two distinct members of the packet are transverse Hecke neighbors.
There is, generically up to sign, a unique primitive $A_5$-equivariant
isogeny between them.  It has

\[
 \Phi^\dagger\Phi=[4],\qquad
 \operatorname {SNF}(\Phi)=(1^4,2^2,4^4),\qquad
 \deg\Phi=2^{10},
\]

and kernel

\[
                    (\mathbf Z/2)^2\oplus(\mathbf Z/4)^4.
\]

Hence the five vertices form a complete Hecke graph $K_5$, not just one
isolated cubic--quartic edge.

Before the geometric three-primary line is selected, there is a larger
marked packet

\[
             \mathbf P^1(\mathbf F_4)\times
             \mathbf P^1(\mathbf F_3)
\]

of twenty principal quotients.  Its local Hecke graph has a $K_5$ direction
at two and a $K_4$ direction at three.  The six-axis saturation theorem holds
at every one of these twenty vertices.  This is stronger than transport by
an odd isogeny: the available Hecke maps have even degree, so the primitive
minimal class is forced independently by the integral divisor lattice at
each vertex.

This is the cleanest current compression of the C904 mathematics:

> The classical quartic and exceptional cubic families are the symmetry-
> enhanced and symmetry-broken sheets of one two-primary Hecke pentad.

## 1. Local theorem

Let

\[
 H=\operatorname {Aug}(\mathbf F_2^6)/\langle\mathbf1\rangle.
\]

For the exceptional $A_5<S_6$, the exact modular-representation calculation
gives

\[
                  \operatorname {End}_{A_5}(H)=\mathbf F_4.
\]

The two-primary discriminant module is $H\oplus H$.  Every element of the
$\mathbf F_4$ commutant is self-adjoint for the coefficient alternating
form.  Therefore the $A_5$-stable simple summands of $H\oplus H$ are all
maximal isotropics, and semisimplicity identifies them with the lines in
$\mathbf F_4^2$:

\[
             \{\text{$A_5$-stable principal halves}\}
               =\mathbf P^1(\mathbf F_4).
\]

Restriction from $S_6$ reduces the commutant from $\mathbf F_4$ to
$\mathbf F_2$.  Consequently the $S_6$-stable locus is exactly the
subline $\mathbf P^1(\mathbf F_2)$.  This proves the $3+2$ split without a
coordinate enumeration.

If $K\ne K'$ are two of the five lines, then $K\cap K'=0$ and
$H\oplus H=K\oplus K'$.  The corresponding self-dual lattices are therefore
transverse on all four defective symplectic planes.  Scalar multiplication
by two is primitive between them.  On each defective plane its matrix is
$\operatorname {diag}(1,4)$; on the common unimodular plane it is
$\operatorname {diag}(2,2)$.  This proves the displayed Smith type,
multiplier, degree, and kernel for every edge of $K_5$.

For a non-CM generic multiplicity elliptic curve,
$\operatorname {End}_{A_5}$ of the rational variation is scalar.  Thus each
primitive edge map is unique up to sign.

## 2. Geometric realization

The local pentad becomes geometric through three already proved inputs.

1. The resolved $S_6$ quartic family has root--weight $A_5$ coefficient
   lattice and period closure $X_0(6)$.  Its four admissible degenerations
   have exact primitive widths $1,2,3,6$, which force the corrected
   forgetful map to the common $X_0(3)$ factor.
2. The $A_5$ cubic family has the same rational five-dimensional coefficient
   module and the same three-primary defect.  Strong Torelli excludes an
   $S_6$-stable gluing for its generic member, so its two-primary kernel is
   one of the exotic pair.
3. The square classes $T$ and $(T+27)(T-729/5)$ respectively choose the
   exotic gluing and split the multiplicity twist.  Their pullback along the
   quartic parameter map gives the explicit genus-three common cover.

The previously proved quartic--cubic Hecke-neighbor theorem is therefore one
of the six cross edges between the three classical and two exotic vertices.
The same local proof supplies all ten edges of the pentad.

The hidden abstract symmetry of the local packet is

\[
                  \operatorname {PGL}_2(\mathbf F_4)\cong A_5,
\]

acting on its five vertices.  At present this is a symmetry of the modular
gluing problem, not a claimed geometric automorphism of the five families.
Promoting it to geometry would require compatible deck and boundary data.

## 3. Annals-level theorem packet

The strongest self-contained C904 paper would combine four layers.

1. **Boundary-to-period reconstruction.**  The four signed graph lattices of
   the quartic degenerations recover the cusp widths $1,2,3,6$, hence
   $X_0(6)$ and the exact rational forgetful map.
2. **Hecke pentad.**  The five principal gluings split $3+2$ under
   $S_6\supset A_5$, and every pair is joined by the same primitive
   multiplier-four isogeny.
3. **Shared boundary lattice.**  The exotic Petersen Prym and the six
   $D_5$ elliptic axes have the same integral polarization $6I-J$; this is
   the boundary witness that the two geometric branches use one coefficient
   object.
4. **Chow consequence.**  Six-axis saturation makes
   $\Theta^4/4!$ algebraic on every cubic member, so every smooth member is
   universally $CH_0$-trivial and satisfies the integral Hodge conjecture
   for one-cycles.

At the purely polarized-abelian level, layer 4 holds on the entire
$5\times4$ two-prime packet, not only on the geometrically selected cubic
vertex.

There is now a conceptual classical/exotic separation.  The general
Jordan-scalar minimal-class theorem proves integral divisor-product
saturation for every principal elliptic-power quotient whose gluing is
scalar on each local Jordan block.  It covers the full-Weyl/root--weight
branches in every rank.  The two exotic $\mathbf F_4$ cubic gluings are not
Jordan-scalar, so their separate $7/17$ saturation theorem is genuine extra
content.  Thus all five vertices of the present Hecke pentad carry primitive
minimal cycles, but the classical triple and exotic pair reach them by
different integral mechanisms.

The optional external successor is even sharper: combine layer 4 with the
C907 one-stabilization theorem to obtain a non-isotrivial family for which

\[
 X\text{ is universally }CH_0\text{-trivial},
 \qquad X\times\mathbf P^1\text{ is irrational}.
\]

That corollary should be kept logically separate until the enhanced-atom
bridge in C907 has been written self-contained and independently reviewed.

## 4. What would raise the packet further

### Algebraic threefold correspondence: the direct Prym route dies

The abelian-scheme isogeny is already integral.  The direct attempt to turn
it into an algebraic threefold correspondence uses conic-bundle Prym models
on both sides.  If $P_Q,P_X$ are the two Pryms, $\Phi=2\alpha$, and $\sigma_Q$
is the deck involution, the candidate

\[
 i_X\alpha(1-\sigma_Q):J(\widetilde\Delta_Q)
       \longrightarrow J(\widetilde\Delta_X)
\]

is integral even though $\alpha$ is not, and it restricts to $\Phi$ on the
anti-invariant lattice.  Nevertheless the reverse cubic cylinder has
composition $[2]$: the Jacobian polarization restricts to twice the
principal Prym polarization.  Composing the two integral cylinder
correspondences therefore realizes $2\Phi$, not $\Phi$.  The primitive map
would require the unavailable integral half-projector.  This route is dead
unless an independent integral realization of the six-axis cycle $3\Phi$
is found, in which case $3\Phi-2\Phi=\Phi$.

### Logarithmic boundary extension

After the exotic marking cover, the four cusp widths are $2,2,6,6$.
Scalar two extends across them as an isogeny of logarithmic one-motives, but
not as one ordinary finite-flat Neron kernel.  At the cusps lying over the
original widths $1,3$, the toric and log-lattice kernel pieces are

\[
               \mu_2\ ;\quad \mathbf Z/2\oplus(\mathbf Z/4)^4,
\]

while at the cusps of widths $2,6$ they are

\[
               \mu_2^5\ ;\quad (\mathbf Z/2)^5.
\]

The total degree is $2^{10}$ in every case.  The ordinary Neron special
kernel has rank $1024$ at the ramified pair and only $64$ at the unramified
pair, which proves that ordinary finite-flat extension is the wrong target.
The logarithmic kernel packet is the uniform boundary theorem.

### Building interpretation

The link of the relevant self-dual lattice in the mod-two fixed-lattice
problem has five $A_5$-stable vertices and three $S_6$-stable vertices.  It
is tempting to call this the $\mathbf P^1(\mathbf F_4)$ link with
$\mathbf P^1(\mathbf F_2)$ symmetry-enhanced sublink.  Because the extra
$\mathbf F_4$ endomorphisms are currently proved only after reduction
modulo two, no claim about an actual $\mathbf Q_{2^2}$ Bruhat--Tits tree is
licensed without a separate integral-centralizer theorem.

### Infinite-family form

The local mechanism generalizes formally: if a simple modular $G$-module
$H$ has self-adjoint commutant $\mathbf F_{p^r}$, the $G$-stable halves of
$H\oplus H$ form $\mathbf P^1(\mathbf F_{p^r})$; if a supergroup cuts the
commutant to $\mathbf F_p$, its enhanced-symmetry locus is
$\mathbf P^1(\mathbf F_p)$.  Distinct halves are transverse and give
primitive multiplier-$p^2$ Hecke neighbors.  A publishable uniform theorem
still needs the precise integral-lattice hypotheses and at least one new
geometric family beyond the present $A_5<S_6$ instance.

## 5. Fit with Paper V

This is closer to the intended marked round trip than the relative Shen-half
problem.  Sparse boundary graphs recover the modular curve; the modular
curve determines the gluing packet; one two-primary orientation distinguishes
the cubic from the quartic; the chosen gluing reconstructs the principal
intermediate Jacobian; and Torelli reconstructs the cubic.  The route is
bidirectional after the marking and twist characters are retained.

The relative universal-cycle gate is valuable but not needed for this marked
reconstruction theorem.  It should be an optional strengthening rather than
the theorem on which Paper V's completion depends.

## 6. Dead-route and risk ledger

- The Hecke pentad does not make the relative Shen half canonical.
- The hidden $\operatorname {PGL}_2(\mathbf F_4)$ is not yet a family
  automorphism group.
- An abelian-scheme homomorphism is not by itself an algebraic correspondence
  between the two threefolds; the direct Prym-cylinder construction gives
  exactly $2\Phi$ and does not close the primitive gap.
- The common genus-three marking cover is essential: the gluing orientation
  and elliptic twist are independent quadratic characters.
- The quartic Petersen-cover classification is classical; novelty lies in
  its signed Prym lattice, period normalization, and match to the cubic
  six-axis polarization.
- The cross C907 corollary depends on very recent quantum/F-bundle sources and
  must not be imported without the special-case no-cancellation proof.

## 7. Mystery ledger

- **Settled:** the $3+2$ count is a projective-line decomposition, not an
  accidental enumeration.
- **Settled:** every distinct pair has the same primitive Hecke type.
- **Open:** whether the local $\operatorname {PGL}_2(\mathbf F_4)$ symmetry
  lifts to a geometric correspondence group.
- **Settled negatively:** the direct Prym-cylinder construction realizes
  twice the primitive edge map.
- **Settled:** ordinary finite-flat Neron extension cannot be uniform; the
  logarithmic one-motive kernel has constant total degree with two exact
  toric/lattice types.
- **Open:** whether all five sheets assemble into one natural compactified
  logarithmic packet over the cusps.
- **Open:** whether another exceptional subgroup pair realizes the uniform
  $\mathbf P^1(\mathbf F_{p^r})$ mechanism.

## Source boundary

This note introduces no new literature claim.  Its inputs and their source
audits are recorded in:

- `2026-08-10-c904-exotic-f4-gluing.md`;
- `2026-08-10-c904-quartic-x06-shadow-sister.md`;
- `2026-08-10-c904-quartic-cubic-hecke-correspondence.md`;
- `2026-08-10-c904-six-axis-minimal-class-saturation.md`;
- `2026-08-10-c904-adjacent-annals-uniform-theorems.md`; and
- `2026-08-10-c904-alternate-annals-crowns-priority-audit.md`.

The pentad formulation is a synthesis of those proved local statements.  Its
geometric compactification and threefold-correspondence clauses remain
explicit gates, not claimed results.
