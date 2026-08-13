# C907 — the K-positive carrier-face peak theorem

Date: 2026-08-13

Status: positive peak class after hostile revision.  The first two-face
formulation was false: keeping only the blowdown variables leaves the cubic
carrier in the formal ambient ideal, so every Artin fibre is still confluent
and inverse-limit localization does not construct the missing sectorial
embedding of `P6`.  The repaired theorem retains one exposed
rational-polyhedral face containing both blowdown rays **and** all Novikov
directions needed by the endpoint primitive-sixth packets.  Strict
`c_1`-positivity on that whole carrier face makes the relevant small quantum
connections coefficientwise polynomial, so the comparison takes place on an
honest analytic torus and never asks an Artin closed fibre to see the atom.

This includes Fano peaks and more generally peaks admitting a
`P6`-faithful K-positive carrier face.  It does not prove that every
smooth-fivefold factorization admits such a face.

## 1. Setup

Let `Y` be smooth projective with two smooth blowdowns

\[
 p:Y\to X,\qquad p':Y\to X'
\]

and primitive fibre rays `R=R_{>=0}e`, `R'=R_{>=0}e'`.  Assume that there is
an exposed rational-polyhedral face `G` of the numerical effective cone such
that:

1. `e,e' in G`;
2. `c_1(Y).beta>0` for every nonzero `beta in G`;
3. the monomial pushforwards of `G` define compatible endpoint
   specializations, and killing curve classes outside these three retained
   monoids is `P6`-faithful: the resulting generalized primitive-sixth
   packets and Gamma rank Booleans are the packets and Booleans to be
   compared;
4. both endpoint blowups satisfy the one-arrow fixed-sector rank theorem;
5. on the finite ramified carrier cover, the two admissible endpoint sectors
   lie in one nonturning component of the parameter-and-direction space.

Condition 3 is not cosmetic.  A face containing only `e,e'` usually kills
the cubic curve variable which creates the primitive-sixth atom.  That was
the fatal defect in the first draft.

The simplest sufficient case is `G=NE(Y)` with `Y` Fano and rational
polyhedral Mori cone, provided the induced endpoint specializations retain
their packets.  The formulation with a smaller face is useful when irrelevant
effective directions are K-trivial or K-negative but the atom lives on a
K-positive subface.

## 2. The carrier specialization is legal and finite

Define

\[
 Q^\beta\longmapsto
 \begin{cases}
  Q^\beta,&\beta\in G,\\
  0,&\beta\notin G.
 \end{cases}
\]

Because `G` is a face, this is a multiplicative Novikov specialization.  Its
effective monoid has a finite Hilbert basis after saturation.

For fixed homogeneous insertions and descendant degree, the genus-zero
dimension axiom fixes `c_1(Y).beta`.  Strict positivity on the rational
polyhedral cone gives

\[
 c_1(Y).\beta\ge \epsilon\|\beta\|
\]

for some `epsilon>0`.  Hence only finitely many classes in `NE(Y) cap G`
contribute to each coefficient of the small quantum connection.  Every such
coefficient is a polynomial in the carrier-face monomials.

This is stronger than the formal-Novikov Artin receiver.  All variables that
create and split `P6` are now honest analytic parameters.  Formal variables
outside `G` have been killed by a ring map, rather than retained nilpotently.

## 3. Common analytic receiver

Choose generic nonzero carrier points in the two one-arrow charts.  At the
left point, the exceptional variable of `p` is nonzero and the remaining
carrier variables are chosen in the domain reached from its fixed-sector
receiver; make the analogous choice for `p'` on the right.

At either end, begin with the one-arrow sectorial comparison at the extremal
closed fibre.  Only the center-versus-ambient separation is used there.  The
ambient block may be internally confluent.  Since the carrier connection is
polynomial and logarithmic in the Novikov boundary coordinates, the
multivariable regular-singular Frobenius theorem gives convergent punctured
germs after the standard Novikov-monodromy factors are removed.  These germs
analytically continue the whole ambient block, its flat pairing, and the
normalized large-`z` Gamma point section to a neighbourhood with every
carrier variable nonzero.  Equivalently, one can start at a sufficiently
small nonzero carrier point and use ordinary parallel transport there.  This
is not evaluation of Iritani's formal comparison series, and it does not
treat `Q=0` as an ordinary nonsingular initial point.

Remove from the carrier torus the singular, turning, level-changing, and
primitive-sixth resonance loci.  Their complex-analytic part has proper
complement, but this alone does not prove that two **oriented** sectorial
germs lie in the same component: moving anti-Stokes rays can separate lifts
of the direction circle.  Hypothesis 5 is exactly the required oriented path
statement.  Choose such a compact path and continuously lifted nonsingular
`z` direction.  A finite cover by nonturning polydiscs and Dreyfus's parameterized
Hukuhara--Turrittin summation gives compatible canonical sectorial lifts.
On overlaps, integrability and sectorial uniqueness identify them.

Thus one receiver contains simultaneously:

- the intrinsic normalized Gamma point section;
- the **total** generalized primitive-sixth sectorial packet;
- the flat Poincare/Euler pairing.

The packet is already separated at the generic analytic carrier points.  No
packet is extracted from a nilpotent Artin fibre, and no localization of an
inverse limit is used as a substitute for sectorial summation.

## 4. Peak theorem

The point section and the total primitive-sixth packet are horizontal along
the chosen nonturning path, so their flat pairing has constant rank.  At the
left endpoint the one-arrow theorem decomposes the peak packet into the
ambient packet from `X` plus center packets and identifies the rank row with
the rank row of `X`; all center contributions have rank zero.  The same
statement at the right endpoint identifies the transported row with that of
`X'`.  Therefore

\[
 \boxed{
 \mathfrak r_X|_{P_6(X)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_{X'}|_{P_6(X')}\ne0.}
\]

The conclusion is independent of basis permutations inside the total
primitive-sixth packet.  The path is required not to cross a turning or
resonance locus which mixes that packet with a different formal-monodromy
packet.

External product with the small quantum D-module of `P^2` gives the same
statement in the Gold dimension whenever the product carrier variables are
included in `G`.

## 5. Regression and boundary

For `Y=Bl_{p_1,p_2}P^2`, the two chamber coordinates satisfy `B=xx'`.  The
old obstruction remains exact on the closed fibre `B=0`: its two punctured
axes do not meet.  A carrier face containing the relevant third/base
direction instead travels with `B ne 0`; if `c_1` is positive on that entire
face, the polynomial analytic receiver applies.  The two-ray face alone says
nothing about a primitive-sixth packet and is no longer claimed sufficient.

The theorem covers:

- Fano peaks with `P6`-faithful full Mori cone;
- relative peaks admitting an exposed rational-polyhedral K-positive face
  carrying both contractions and all endpoint atom variables;
- commuting blowups when their common carrier face satisfies the same
  conditions.

It does **not** cover:

- an ordinary flop direction (`c_1.c=0`), handled separately in the Geiser
  theorem by LLW plus the Gamma/Fourier--Mukai intertwiner;
- a face on which `c_1` is zero or negative;
- a two-ray face which omits the cubic carrier;
- non-exposed retained classes, since killing their complement is not
  multiplicative;
- singular endpoint chamber spaces outside the one-arrow theorem.

The exact Gold coverage question is therefore: can the smooth AKMW
subdivision peaks be arranged so that every peak is either an ordinary split
flop peak or admits a `P6`-faithful K-positive carrier face with the oriented
path property?  AKMW's theorem states neither the cone property nor the
sector-path property, so coverage remains open.

The necessary numerical test is in
`2026-08-13-c907-carrier-face-contact-budget.md`.  If a carrier curve of class
`beta` meets a codimension-`c` blowup center with multiplicity `m`, faciality
forces its strict transform into every carrier face and positivity requires
`c_1 beta>(c-1)m`.  AKMW imposes no such inequality.  The equality case for a
cubic line and a codimension-three center is the Geiser K-trivial ray; higher
codimension gives a negative ray.

## EJ / TT / AA

- **EJ:** `B=xx'` obstructs comparison only while one insists on `B=0`.
  Leaving that fibre is useful precisely when every packet-carrying variable
  belongs to a coefficientwise-finite analytic face.
- **TT:** positivity on the two exceptional rays is insufficient.  The
  cubic atom lives in an ambient carrier direction, and an Artin inverse
  limit cannot manufacture its missing sectorial embedding.
- **AA:** first audit Fano and toroidal K-negative peaks for a faithful
  carrier face.  Send the first K-trivial direction to the ordinary-flop
  Gamma/FM route; do not weaken positivity to unsupported Novikov
  convergence.

## Sources used

- Dreyfus, arXiv:1203.2904, Proposition 1.3, Proposition 1.13, and
  Lemma 1.14; cached SHA-256
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.
- Lee--Lin--Qu--Wang, arXiv:1401.7097, for the ordinary-flop contrast;
  cached SHA-256
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- AKMW, arXiv:math/9904135, for the remaining smooth-peak coverage question;
  cached SHA-256
  `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`.
