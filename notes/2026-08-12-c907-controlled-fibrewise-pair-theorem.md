# C907 controlled fibrewise exterior-pair theorem

**Lane:** `clebsch`

**Status:** conditional topology compression and correction of the collar
gate.  It proves no new property of the pilot graph.  Its point is exact:
Mather's proper controlled-submersion theorem gives the required exterior and
interface product *on each fixed parameter fibre*.  A log-smooth central
model does not give a product through the central parameter.

## The theorem actually needed

Let `D` be a closed parameter disk, `Omega` a contractible value disk, and
let `p : G -> D` be a proper complex analytic space equipped with a fixed
actual-boundary datum.  Choose a **closed** residual tube `R` and put

\[
 P=\overline{G\setminus R^\circ},\qquad I=P\cap R.
\tag{1}
\]

Thus `P` and `I`, unlike an open exterior thickening, are proper over the
base whenever `G` is.  Write `P_d`, `I_d`, and `L_d` for their restrictions
at `d in D`.  Suppose, for a fixed `d`, that there is a Whitney stratification
of the labelled pair `(P_d,I_d)` such that

1. the actual infinity boundary, the central/graph singular strata, every
   path-tube end face, the reference fibre `L_d^{-1}(u_0)`, and `I_d` are
   unions of labelled strata;
2. `L_d` is a submersion on every stratum of both `P_d` and `I_d`; and
3. `L_d:P_d -> Omega` and `L_d:I_d -> Omega` are proper.

Then there is a stratum- and label-preserving homeomorphism of pairs over
`Omega`

\[
 (P_d,I_d)\ \cong\
 \bigl(P_{d,u_0}\times\Omega,\ I_{d,u_0}\times\Omega\bigr).
\tag{2}
\]

It can be chosen isotopic to the identity over a chosen small star-shaped
neighborhood of `u_0`.  Consequently

\[
 H_*(P_d,P_{d,u_0};\mathbb Z)=
 H_*(I_d,I_{d,u_0};\mathbb Z)=0.
\tag{3}
\]

This is Mather's controlled-submersion/first-isotopy argument applied to
`P_d` and to the labelled closed subspace `I_d`: compatible control data give
controlled lifts of the coordinate vector fields on `Omega`; properness makes
their flows global; their flows trivialize the two maps simultaneously.  The
pair assertion is not a second Cech construction.  The labels ensure that the
same flow preserves the actual boundary and each distinguished path tube.

For the desired relative Mayer--Vietoris step, take open thickenings of the
closed decomposition `(P_d,R_d,I_d)` which form an excisive triad.  Equation
(3) then gives, naturally,

\[
 H_*(G_{d,\Omega},L_d^{-1}(u_0);\mathbb Z)
 \cong H_*(R_d,R_{d,u_0};\mathbb Z).
\tag{4}
\]

The same identity for open exteriors follows only after this closed-pair
statement and excision; an open exterior is not itself proper over `Omega`.

## Interface test: the one non-negotiable polar condition

If `I_d` is the regular level `rho_d=epsilon` on a stratum `S`, condition 2
on its interface part is exactly

\[
 d(L_d,\rho_d)|_{T S}\text{ is surjective along }I_d.
\tag{5}
\]

Thus the interface cannot be chosen after the fact.  Ordinary `dL_d`
surjectivity does not imply (5): locally on `C^2`, take `L=z_1` and
`rho=|z_1|^2`.  The value map is submersive, but `rho` factors through the
value map, so `(L,rho)` has deficient real rank.  This is the precise polar
check needed for a residual tube and its path-end faces.

The relative Thom condition `a_{L_d}` is a robust *certificate* for obtaining
one stratification and compatible control data when the strata were first
constructed by algebraic/log charts.  It is not an additional logical
hypothesis after conditions 1--3 have been verified: Mather's theorem takes
a proper controlled submersion as its input.  In particular, a list of
special-fibre Fitting calculations is still insufficient: it must be upgraded
to fixed-fibre stratumwise submersivity, including the interface, on a common
Whitney control partition.  This corrects the useful-but-too-strong wording
that `$a_L$ is the missing hypothesis' in the earlier checklist.

## What can be uniform in the parameter

On a closed subdisk of `D^*`, the stronger hypotheses

\[
 (p,L):P|_{D^*}\longrightarrow D^*\times\Omega,
 \qquad (p,L):I|_{D^*}\longrightarrow D^*\times\Omega
\tag{6}
\]

being proper controlled submersions of labelled Whitney pairs give a single
product pair over `D^* x Omega`.  If the interface is a `rho`-level, this
requires `(p,L,rho)` to be stratumwise submersive.  It transports the relative
group, its labelled path system, and the pairing uniformly for nonzero
parameters.

There is deliberately no analogous conclusion across `d=0`.  A proper
semistable/log-smooth morphism can have local equation
`d=x_1...x_r`; its central log strata map to the single point `d=0`, hence
`p` is not an ordinary stratified submersion to `D` there.  The elementary
smooth proper family `P^1 x D -> D` together with the value map
`L([x:y])=[x^2:y^2]` also shows that smooth/log-smoothness of `p` says nothing
about critical points of `L`.  The central-to-nearby comparison of the four
residual points must therefore remain the separate parameterized holomorphic
Morse transport already identified in the C907 plan.

## Automatic versus still-to-prove

Assuming the future graph is a proper **regular SNC/log-smooth** model, the
following are automatic or formal:

| Item | Consequence |
| --- | --- |
| Proper graph and closed exterior/tube | properness in (3) and (6) where the base is used |
| SNC actual boundary | finite coordinate Whitney charts and a finite control datum candidate |
| Log charts | local product coordinates for the actual boundary; the auxiliary `B=1,C=1` markings may be forgotten |
| Unit residue direction | the local value-submersion and controlled lift in the imbalanced charts |

The following are separate gates:

| Gate | Exact evidence required |
| --- | --- |
| Value map | `L_d` submersive on every **coarse actual-boundary** stratum, not merely on fine log initials |
| Control | common Whitney/controlled stratification of the closed labelled pair; `a_L` is a convenient sufficient audit |
| Polar/interface | (5), including path-tube end faces; uniformly (6) requires `(p,L,rho)` |
| Pairing | choose the controlled flow from the identity and preserve the complex orientation, labels, distinguished paths, and their sector ordering |
| Central comparison | parameterized Morse transport in `R`, not log-smooth isotopy through the semistable fibre |

For the imbalanced chart of `2026-08-12-c907-log-control-coarsening-lemma.md`,
the unit `partial_v L=1` supplies the fourth row's local value-map evidence
after forgetting the translated auxiliary divisors.  It supplies neither a
global proper exterior nor the polar condition (5).

## Pairing clause

The controlled homeomorphism in (2), chosen by integrating a lift from the
identity, is orientation-preserving on each oriented top stratum.  If the
labelled path tubes are kept as distinct labelled strata and their endpoints
as labelled sections, it transports relative cycles and their boundary
orientations.  Naturality of intersection and of the associated Seifert
pairing then gives the directed pairing comparison.  A bare abstract product
of unlabelled pairs is weaker: it can forget the path ordering needed for the
Stokes matrix.  Nonbraiding of the four value sections in `Omega` is therefore
an explicit residual-Morse check, not a consequence of (2).

## Primary source audit

John N. Mather, *Notes on Topological Stability*, 2012 publication of the
1970 notes, DOI `10.1090/S0273-0979-2012-01383-6`, cached under that key
with SHA-256
`afeecee7d4519f6dd2fdd7d28997771f759b3988169a5e68517729cf5b473e33`.
Proposition 9.1 constructs controlled lifts; Proposition 10.1 integrates
them; Corollary 10.2 gives the proper controlled-submersion conclusion; and
Proposition 11.1 upgrades a proper stratumwise submersion of a closed Whitney
stratified space to that controlled setting.  The more general paired-map
lifting mechanism is developed in §11 for Thom mappings.  René Thom's
original first isotopy formulation is
*Ensembles et morphismes stratifiés*, Bull. AMS **75** (1969), 240--284,
DOI `10.1090/S0002-9904-1969-12138-5`.

## EJ/TT and mystery ledger

- **EJ:** replace a proposed finite collar-Cech construction by one labelled
  proper controlled-submersion certificate for the closed exterior/interface
  pair.
- **TT:** log-smoothness controls the degeneration of the domain, not the
  value map, the polar interface, or marked thimble data.  It cannot be used
  to trivialize a semistable family across the central parameter.
- **Settled:** exact fixed-fibre theorem; precise polar rank test; the
  automatic/nonautomatic split; and the difference between a usable
  `a_L` audit and the logical hypothesis of first isotopy.
- **Open evidence gap:** global regular graph, coarse-stratum value audit,
  global interface, labelled control datum, and residual Morse/pairing
  transport.
