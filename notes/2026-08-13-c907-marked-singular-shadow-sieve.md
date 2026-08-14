# C907 — marked singular-shadow sieve for the dangerous peak object

Date: 2026-08-13

Status: exact reduction and two structural no-go results.  The cheapest
unmarked singular shadow fails on the safe `dP7` peak.  Quasi-symmetric
completion marks the correct vanishing category before confluence, but no
published theorem carries that marking through the nonconvex discrepant
confluence.  The remaining scalar is the zero-section multiplicity of the
output vanishing cycle; its vanishing is equivalent to the Gold rank row.

## 1. What the dangerous object is

At a smooth fivefold peak `Y`, let `D` be the union of the two unstable
boundaries and let `T` be the transition between the two incident sectorial
receivers.  A dangerous object is one complete ray-ordered residue block
`V` such that

\[
 [V]\ne0\quad\text{in}\quad
 K_0^{num}(Y)/K_{0,D}^{num}(Y).                                 \tag{1}
\]

Equivalently, for a point `p` in `Y-D`,

\[
 \chi(V,O_p)\ne0.                                                \tag{2}
\]

Analytically, `V` is the marked vanishing thimble produced when a wall
exponential collides/braids with an ambient exponential.  Categorically, it
would be the output of a window mutation which has escaped the subcategory
supported on `D`.  Microlocally, it is detected by a zero-section component
on the output side.

Thus the same object has four exact shadows:

| language | dangerous shadow |
|---|---|
| `K`-theory | nonzero class in (1) |
| Euler/Gamma | nonzero point row (2) |
| kernel support | a component of `T-1` not supported in `Y x D` |
| microlocal | nonzero output zero-section multiplicity |

The last is the cheapest singular detector.  In any holonomic/microlocal
realization, if `M` is the output object, the coefficient of the zero section
in `CC(M)` is its generic rank.
For a generic `p` it is equivalently the Euler characteristic of the stalk
`M_p`.  Therefore Gold would follow from the single scalar identity

\[
 \operatorname{mult}_{T_Y^*Y}
 CC\bigl(p_{2!}\phi_{\mathrm{peak}}\bigr)=0                     \tag{3}
\]

for every complete unstable-stratum residue block, with `p_2` the output
projection.  Formula (3) is a precise replacement for the informal phrase
"the singularity stays on the wall."

## 2. Unmarked singularities cannot prove (3)

The safe carrier peak `X x Bl_(p1,p2)P2` has the toric potential

\[
 x+y+a/x+B/(xy)+a/y.
\]

Its wall root and an ambient root meet at a simple discriminant point and
undergo an `A1` transposition.  Nevertheless its exact Gamma/window matrix
fixes the rank row.  See
`2026-08-13-c907-dp7-spectral-braid-shadow-failure.md`.

The incomplete-Gamma connection in
`2026-08-13-c907-minimal-ambient-target-stokes-countermodel.md` has the same
minimal rank-one unipotent/Stokes shape but marks the target by an ambient
rank-one vector.  It can also be written as an algebraic exponential/Kummer
period:

\[
 \Gamma(1-\alpha,t/z)
 =z^{\alpha-1}\int_t^{\infty}x^{-\alpha}e^{-x/z}\,dx,
 \qquad \alpha=1/6.                                             \tag{4}
\]

Hence merely requiring an algebraic exponential period, finite-order Kummer
monodromy, quasi-unipotence, an `A1` germ, or rank-one Picard--Lefschetz
monodromy still does not determine (3).  Pairing, integrality, and the `P2`
nilpotent tag were already built into the doubled/tagged version of that
model.

The safe and dangerous models differ only in the **marking of the vanishing
cycle in the output lattice**.  Any singular invariant which forgets that
marking is too coarse.

## 3. The quasi-symmetric-completion route

There is a natural attempt to recover the marking.  For a torus
representation with weights `b_i`, add on every weight line a compensator
whose weight is minus the sum of the existing weights on that line.  The
enlarged representation is quasi-symmetric.

For a unit standard wall with weights

\[
 (+1)^r,(-1)^s,\qquad r>s,
\]

one can add `r-s` further weight-`-1` coordinates.  The enlarged wall is
crepant/balanced.  The original discrepant quotients are the coordinate-zero
loci of those compensators in the two balanced chambers.

This is attractive because Špenko--Van den Bergh prove that, for a
quasi-symmetric torus representation and nonresonant GKZ parameter, the
decategorified GIT hyperplane-arrangement schober agrees with the GKZ
solution local system.  Its wall monodromy is therefore categorically
marked by window subcategories.  In that parent system the correction is
identity on the common-open quotient.

### The exact seam

The coordinate-zero restriction is not a crepant complete-intersection
descent.  On the two sides the same compensator is concave on one chamber
and convex on the other.  For the local wall above, the balanced parent has
`r` positive and `r` negative weights, whereas its zero loci are

\[
 \operatorname{Tot}(O(-1)^s/P^{r-1})
 \quad\text{and}\quad
 \operatorname{Tot}(O(-1)^r/P^{s-1}),                           \tag{5}
\]

which have discrepancy `r-s` and different cohomological ranks.  Thus no
invertible crepant comparison can descend directly.

Acosta--Shoemaker's general discrepant theorem performs exactly the missing
regularization/asymptotic operation, and their complete-intersection theorem
commutes with quantum-Lefschetz differential operators only for compatible
bundles whose characters lie in the common wall cone.  The compensator in
(5) points across the wall and does not satisfy that compatibility.  Their
result supplies an asymptotic map, not a Gamma/window marking of its output
row.

Confluence can change the marking: the incomplete-Gamma period (4) is the
rank-two normal form of a regular-to-irregular hypergeometric confluence and
creates the forbidden ambient target.  Therefore one cannot simply say that
the supported parent monodromy remains supported after deleting the
compensators.

The quasi-symmetric completion reduces the missing theorem to a smaller
one, but does not prove it:

> **Saturated rank-row confluence lemma.**  Under simultaneous compensator
> confluence, the categorical/window vanishing lattice of the balanced
> parent specializes into `K_{0,D}^{num}(Y)`; equivalently its image has
> zero multiplicity in (3).

This is a numerical, one-row version of nonconvex quantum-Serre compatibility
with the Gamma lattice.  It is strictly weaker than a full discrepant
schober/QDM comparison.

## 4. Structural filters which remain valid

A dangerous block must satisfy all of the following.

1. **Carrier dressing.**  A pure `c1`-neutral series cannot alter the leading
   spectrum; a positive-`c1` carrier coefficient must be present.
2. **Turning.**  It must pass through an ambient--wall discriminant braid.
3. **Neutral total character.**  Nontrivial exceptional Galois characters
   are killed by the rank row; only an invariant combination can survive.
4. **Zero-section output.**  Its marked vanishing cycle must have nonzero
   generic output rank, i.e. violate (3).
5. **Confluence escape.**  In a balanced completion it must arise by loss of
   saturation/support during the nonconvex compensator limit.

Items 1--3 are cheap necessary shadows and discard many terms.  The `dP7`
calculation proves they cannot discard every safe peak.  Item 4 is the exact
binary detector.  Item 5 is the most structured remaining attack on it.

## 5. What the C908 lattice can and cannot see

The `2^10` saturation phenomenon in the blown-up-theta lattice suggests the
right style of argument: prove that a geometrically defined sublattice stays
saturated under a limiting operation, then read the forbidden object from a
small quotient.  But no current comparison places the C907 peak vanishing
cycle in that theta lattice.  Its parity and saturation shadows therefore do
not evaluate (3).  The useful imported pattern is **saturated marked
specialization**, not the particular `2`-primary lattice.

## 6. Source boundary

- Špenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  arXiv:2007.04924, proves the schober/GKZ comparison for quasi-symmetric
  representations and nonresonant parameters.
- Acosta--Shoemaker, *Gromov--Witten Theory of Toric Birational
  Transformations*, arXiv:1604.03491v2, proves the general discrepant
  asymptotic `I`-function map and compatible complete-intersection version,
  but not Gamma/window calibration.
- Iritani--Mann--Mignon, *Quantum Serre theorem as a duality between quantum
  D-modules*, arXiv:1412.4523, treats convex quantum Serre/QDM duality; it
  does not supply the two-order nonconvex Gamma-lattice confluence above.

## EJ / TT / AA

- **EJ:** the broad two-wall theorem can be attacked through one integer:
  the output zero-section multiplicity (3).
- **TT:** an `A1` braid, a geometric period, and even an integral paired
  Stokes lattice do not say whether the vanishing cycle is boundary-supported.
- **AA:** balance the weights, use the proved GKZ schober upstairs, and prove
  only saturation of the supported rank row under compensator confluence.
