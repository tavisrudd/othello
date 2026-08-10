# C904 Paper V: high-ceiling upgrade search

Date: 2026-08-10

Status: research and framing only.  No manuscript source was edited and no
Lean command was run.

## Executive verdict

The search found one genuinely high-surprise structure that is both exact and
cheap enough to pursue: the elliptic factor of the nonstandard `A5`-invariant
cubic pencil is governed by the modular curve `X_0(3)`.

Write the canonical deleted-permutation representation as

```text
W = { (z_0,...,z_5) : sum z_i = 0 }
```

and let `P=sum z_i^3`.  The twenty triples split into two `A5`-orbits of
size ten; let `Q` be the difference of their squarefree monomial sums.  For

```text
X_t : P + t Q = 0,
```

Fourier diagonalization of a `D_5` subgroup and substitution into the explicit
van Geemen--Yamauchi elliptic Prym formula give

```text
j(E_t) = 9 (3t^2+1) (27t^2+1)^3 / t^2.
```

After `T=81t^2`, this is exactly

```text
j = (T+27)(T+3)^3/T,
```

the standard `X_0(3)` Hauptmodul formula.  The 3-isogenous companion has

```text
j' = (T+27)(T+243)^3/T^3,
```

and Fricke acts on the unmarked cubic parameter `s=t^2` by

```text
s -> 1/(9s).
```

This is stronger than the pre-existing statements that the period image is an
unspecified one-dimensional PEL special subvariety and that every intermediate
Jacobian is isogenous to `E^5`.  It identifies the previously unexplained
modulus as a cyclic 3-isogeny and supplies a new Hecke correspondence on the
cubic family.

The realistic top theorem package is therefore:

1. identify the normalized `A5` cubic moduli curve and its elliptic shadow with
   `X_0(3)` explicitly;
2. determine the integral principal-polarization gluing on `E^5`, thereby
   upgrading the shadow map to an arithmetic Torelli theorem;
3. prove the corresponding `A5`-equivariant motivic and zeta factorization;
4. identify Fricke and every singular/CM member geometrically.

The first item is essentially in hand.  Items 2 and 3 are the hard gates that
would raise this from a sharp paper upgrade to a genuinely major theorem.

## Exact algebra now in hand

### Fourier-to-Prym calculation

Let `zeta` be a primitive fifth root and put

```text
c = 2 zeta^3 + 2 zeta^2 + 1,       c^2=5,
u = ct.
```

In Fourier coordinates for the order-five subgroup, the seven `D_5`-invariant
monomial coefficients normalize to the van Geemen--Yamauchi standard form with

```text
a(u) = -32(u-3)^4 / (9(u+1)^3(u+3)^2),
b(u) = -8(u-3)^2(u-1) / ((u+1)(u+3)^2).
```

Direct substitution into their printed formula gives

```text
j(u) = 9(3u^2+5)(27u^2+5)^3/(125u^2),
j(t) = 9(3t^2+1)(27t^2+1)^3/t^2.
```

The exact derivation and assertions are in
`notes/2026-08-10-c904-a5-pencil-j-map.py`.  This is not a numerical fit.

### Classical boundary, reorganized arithmetically

The canonical pencil has the following geometric singular parameters:

| parameter | geometry | field visible in the parameter |
|---|---|---|
| `t=infinity` | six-point `A5/D_5` singular orbit | `Q` |
| `t=0` | ten-point partition orbit | `Q` |
| `t^2=-1/3` | five `A_2` singularities | `Q(sqrt(-3))` |
| `t^2=9/5` | chordal cubic, singular on a rational normal quartic | `Q(sqrt(5))` |

The first two orbit calculations are exact in the integral model.  The last two
supports follow from the exact standard-form reduction; their geometric types
agree with Pinardin--Zhang's explicit nonstandard-`A5` cubics.  Direct finite
field singular censuses at `p=7,11,13,17,19,23,29,31` give precisely the
predicted rational loci and point counts.

For good primes, this predicts the simple arithmetic count

```text
# rational singular pencil parameters
  = 2 + 2*[(-3/p)=1] + 2*[(5/p)=1].
```

Thus the Paper-V `F_11` census is forced: `-3` is nonsquare and `5` is square,
so only the two rational orbit members and the two chordal members appear over
`F_11`.  What looked characteristic-specific is the splitting law of the
character fields of the classical boundary.

The remaining boundary proof obligation is scheme-theoretic: compute the full
degree-80 discriminant with multiplicities and prove the local analytic types
uniformly away from an explicit bad-prime set.  Do not infer those
multiplicities merely from the rational point census.

### The `F_11` point-count coincidence is modular, not accidental

If `r=b/a` is the Paper-V affine pencil parameter, the canonical coordinate is

```text
t = 2(r-3)/r.
```

It sends the conference, ten-point, and two chordal members to
`infinity,0,-2,+2`, respectively.  The eight smooth rational parameters have
only two elliptic `j`-values, `4` and `10`.  Standard curves with either
`j`-value over `F_11` have trace `-3`.  Independently, direct enumeration of all
`16,105` points of `P^4(F_11)` gives

```text
#X(F_11)=1629,       Tr(H^3)=-165=5*11*(-3)
```

for every one of the eight smooth rational members.

This is exact evidence for the expected factorization

```text
H^3(X) = W_5 tensor H^1(E)(-1)
```

but the general l-adic/motivic statement still needs a correspondence or a
careful group-algebra descent proof before the point count is explained
theoretically in the paper.

### Six-axis arithmetic

For the six `D_5` axes in the deleted permutation module, let `P_i` be the
orthogonal rank-one projector.  Exact rational arithmetic gives

```text
sum_i P_i = (6/5) I,
P_i P_j P_i = (1/25) P_i            (i != j).
```

The least common multiplier making every projector integral on the root lattice
is five.  With `R_i=5P_i`,

```text
sum_i R_i = 6I,
R_i R_j R_i = R_i.
```

The normalized six-axis Gram matrix has diagonal `5`, off-diagonal `-1`, and
radical generated by the all-ones vector.  These identities strongly suggest
six degree-five elliptic subvarieties or quotient maps inside `J(X)`.  They do
not yet identify their integral images in `H^3(X,Z)` or the principal
polarization kernel.  In particular, the denominator five is not the modular
level: the exact `j`-map shows that the modular level is three.

## Ten upgrade ideas tested

| # | candidate | test and verdict | decision |
|---|---|---|---|
| 1 | Explicit modular identification | Exact Fourier reduction gives the standard `X_0(3)` `j`-map.  Hartlieb and van Geemen--Yamauchi do not state this. | **PASS; highest-EV theorem now.** |
| 2 | Bidirectional modular Torelli | `T=81t^2` recovers the cubic parameter up to the finite normalizer/orientation ambiguity; cubic Torelli says the principal polarization must restore any datum lost by one elliptic quotient. | **KEEP; prove the stack/normalizer statement.** |
| 3 | Universal integral model of `J(X)` from a 3-isogeny | Rationally `H^3=W_5 tensor M`; integrally the unimodular symplectic lattice and polarization require nontrivial gluing at `2,3` (and possibly `5`). | **KEEP; central hard gate.** |
| 4 | Fricke/Hecke cubic correspondence | Exact on parameters: `s -> 1/(9s)`.  It exchanges the six- and ten-point cusps and gives 3-isogenous elliptic shadows. | **PASS in the isogeny category; lift geometrically.** |
| 5 | Motive, zeta, and `L`-function fifth power | Representation theory predicts `P_3(X,z)=(1-q a_q(E)z+q^3z^2)^5` when the action and factor descend.  The full `F_11` family passes the trace test. | **KEEP; correspondence/descent proof needed.** |
| 6 | Complete arithmetic boundary theorem | Exact fields `Q(sqrt(-3))` and `Q(sqrt(5))` explain every `F_11` singular member and give a Legendre-symbol law over good primes.  Pinardin--Zhang pre-empts the isolated geometric types, not this modular organization. | **PASS as a strong supporting theorem; finish discriminant multiplicities.** |
| 7 | Six local elliptic shadows reconstruct the global ppav | Projector relations pass exactly and expose a rigid equiangular configuration.  Actual elliptic subvarieties and polarization intersections are not yet proved. | **KEEP; likely mechanism for integral Torelli.** |
| 8 | Rank-two Picard--Fuchs / hypergeometric reduction | Once the VHS tensor theorem is made integral, all periods reduce to the universal elliptic local system on `X_0(3)`.  The differential equation and monodromy should then be explicit. | **KEEP; cheap after #3, not before.** |
| 9 | CM/class-field and `E_6` tower | CM points now give explicit infinite arithmetic subfamilies; the level three may be the modular shadow of the `E_6` discriminant group.  This could judo the classical `A_5 subset E_6` tower, but no lattice identification yet proves it. | **FISH HARD, label conjectural.** |
| 10 | Stable irrationality, derived collapse, or a cap-set application | None follows from the present calculation.  Stable irrationality needs integral minimal-class work; a derived equivalence to one elliptic curve has dimensional/Hochschild obstructions; no honest cap-set bridge appeared. | **DO NOT put in Paper V now.** |

## Proposed theorem ladder

### Theorem A: modular shadow (nearly closed)

For the canonical nonstandard `A5`-invariant cubic pencil in characteristic
zero, a `D_5`-fixed elliptic Prym factor defines the degree-four `j`-cover
associated with `X_0(3)`, with Hauptmodul `T=81t^2` and the formula above.

Proof obligations remaining:

1. state the canonical integral pencil and its relation to the Paper-V basis;
2. turn the exact Fourier calculation into a short human lemma;
3. specify the field and excluded characteristics;
4. prove the precise normalizer quotient on the cubic moduli stack.

### Theorem B: arithmetic Torelli (major target)

An `A5` cubic in the smooth pencil is reconstructed from an elliptic curve with
the cyclic 3-isogeny and the finite orientation/polarization datum carried by
the six-axis configuration.  Equivalently, identify the PEL curve, including
its integral level, not just its rational Hodge group.

This is the point at which “bidirectional” becomes exact.  The elliptic curve
alone is insufficient: the map to the `j`-line has degree four.  A cyclic
3-subgroup reduces that ambiguity to the `X_0(3)` parameter, while any residual
normalizer/orientation ambiguity must be recovered by the principal
polarization or six-axis marking.  That is an improvable data-loss statement,
not a fundamental impossibility.

### Theorem C: motivic arithmetic (major target)

Over a suitable base such as `Z[1/N,sqrt(5)]`, construct an algebraic
correspondence realizing

```text
h^3(X_t) = W_5 tensor h^1(E_t)(-1)
```

in an explicit category of motives, with Galois descent and bad-prime terms.
Deduce the fifth-power local factor and modularity consequences.  A mere
complex-analytic isogeny of intermediate Jacobians is not enough for this
claim.

### Theorem D: Hecke shadow sisters (high-surprise corollary)

On the common smooth domain, Fricke gives a rational involution
`s -> 1/(9s)` between cubic members whose elliptic shadows are 3-isogenous.
Determine whether the induced `A5`-equivariant isogeny of intermediate
Jacobians is canonical and whether the known maximum-automorphism cubics form
distinguished CM/Hecke orbits.  The cusps `s=0,infinity` are exchanged; the
`5A_2` value `s=-1/3` is Fricke-fixed and maps to `j=0`, explaining its
`Q(sqrt(-3))` character field.

## TT and EJ passes

### Pass 1: the missing Hodge degree of freedom

`H^{2,1}` is the five-dimensional rational irreducible `W_5`, so
`H^3_Q = W_5 tensor M` with `rank(M)=2`.  The one free complex modulus is
therefore forced to be elliptic.  This recovered Hartlieb's `E^5` conclusion
but was pre-empted.

### Pass 2: integral axes versus modular level

The six rational projectors have denominator five.  This initially suggested
level five.  Exact calculation falsified that guess: five controls the local
axis embeddings, while three controls the elliptic modular parameter.  Their
interaction, rather than either number alone, is the integral mystery.

### Pass 3: do not stop at “special curve”

Substitution into the Prym formula exposed the exact `X_0(3)` Hauptmodul.  The
classical dimension count had left the arithmetic group unnamed; the explicit
formula locks it down.

### Pass 4: turn failure of injectivity into structure

One elliptic `j` loses four cubic possibilities.  Adding a cyclic 3-isogeny
removes the modular ambiguity; the remaining finite orientation question is
precisely what the full principal polarization and six axes can carry.  This is
the right local-to-global theorem, rather than pretending `E` alone determines
the cubic.

### Pass 5: interrogate the boundary instead of discarding it

The apparently sporadic fields `sqrt(-3)` and `sqrt(5)` organize the
`5A_2` and chordal members, explain the `F_11` census by quadratic splitting,
and place the singular fibres at modular/CM points.  The boundary is evidence
for the modular theorem, not debris around it.

### Pass 6: highest extra juice

The best additional payoff is the Fricke correspondence and its possible CM
classification of special cubics.  The best series-level test is whether the
level-three polarization gluing is exactly the discriminant-three step from
the `A_5` lattice into the classical `E_6` tower.  Both are cheap to formulate;
only the first is currently proved at the parameter level.

## Mystery ledger

| mystery / unexplained degree of freedom | status | exact gap or owner |
|---|---|---|
| What is Hartlieb's one-dimensional PEL curve? | **Settled rationally:** its elliptic shadow has the `X_0(3)` Hauptmodul. | Integral/stack identification remains Theorem B. |
| Why does level three appear when axis projectors have denominator five? | **Open and genuine.** | Classify the unimodular `A5`-symplectic lattice and polarization kernel locally at `2,3,5`. |
| Why are the extra boundaries over `sqrt(-3)` and `sqrt(5)`? | **Settled at support/type level.** | Full discriminant multiplicities and bad primes remain. |
| Why do all eight smooth `F_11` members have the same point count? | **Explained numerically/modularly:** only `j=4,10`, both trace `-3`. | Motive/l-adic factorization needed for a theorem-level explanation. |
| Does Fricke act geometrically on cubic threefolds or only on their elliptic shadows? | **Open.** | Construct the correspondence and track principal polarizations. |
| Do the six `D_5` axes give six actual elliptic subvarieties with the computed intersection algebra? | **Open.** | Produce algebraic projectors/correspondences in `J(X)` and calculate degrees. |
| Which modular/CM points are the Fermat, Klein, and `Y_6` cubics? | **Open but now finite and explicit.** | Evaluate the canonical pencil parameters and match their `T,j,j'`. |
| Is the `E_6` discriminant-three tower the source of the 3-isogeny? | **Open/high-risk.** | Integral lattice comparison; do not claim from numerology. |
| Does this prove stable irrationality or a cap-set theorem? | **No.** | Separate successor only if new evidence appears. |

## Literature and priority audit

Audit date: 2026-08-10.  Searches were bounded to the exact family, its
intermediate Jacobians, modular curves/3-isogenies, boundary types, motives,
and stable-rationality consequences.  The stop condition was two consecutive
query rounds returning only the sources below or irrelevant material, plus
full-text phrase checks in the three closest papers.

### Closest primary sources read

1. Moritz Hartlieb, *Special subvarieties in the locus of intermediate
   Jacobians of cubic threefolds*, Math. Z. 310 (2025), article 52,
   DOI `10.1007/s00209-025-03745-3`; cached preprint `arXiv:2304.03214`.
   Proposition 34 identifies the nonstandard `A5` family as a one-dimensional
   PEL special subvariety; Remark 35 gives `J(Y) ~ E^5`.  The current published
   full text contains no occurrence of `3-isogeny` or `modular curve` and does
   not identify `X_0(3)`.

2. Bert van Geemen and Takuya Yamauchi, *On intermediate Jacobians of cubic
   threefolds admitting an automorphism of order five*, `arXiv:1506.05346`.
   This supplies the `D_5` standard form, Prym construction, and explicit
   elliptic `j` formula used here.  It treats the two-parameter order-five
   family and does not mention `A5`, `X_0(3)`, or a 3-isogeny.

3. Antoine Pinardin and Zhijia Zhang, *A5-equivariant geometry of quadric
   threefolds*, `arXiv:2508.11496`.  Section 3 identifies the nonstandard
   five-`A_2` cubic over the sixth-root field; Section 6.2 prints the two
   chordal cubics over the fifth-root field.  It contains no intermediate
   Jacobian, isogeny, or modular-curve discussion.  This pre-empts presenting
   those isolated boundary geometries as new, but not their `X_0(3)`
   organization or finite-field splitting law.

4. Sebastian Casalaina-Martin, Samuel Grushevsky, Klaus Hulek, and Radu Laza,
   *Complete moduli of cubic threefolds and their intermediate Jacobians*,
   `arXiv:1510.08891`.  This is the boundary authority: chordal degeneration
   has a pure hyperelliptic genus-five limit with finite monodromy, so a
   chordal member must not be mislabeled a modular cusp.

5. The standard formula `(T+27)(T+3)^3/T` is recorded in the literature as the
   `X_0(3)` `j`-map (for example, Daniels et al., *Torsion subgroups of rational
   elliptic curves over the compositum of all quartic dihedral extensions of
   the rational numbers*, Trans. London Math. Soc. 6 (2019)).  This formula is
   classical; the new candidate is its occurrence in this `A5` cubic pencil.

6. Engel--de Gaay Fortman--Schreieder, `arXiv:2507.15704`, concerns very
   general cubic threefolds and does not settle this special PEL family.  It
   reinforces that stable-irrationality claims here would require a separate
   integral minimal-class argument.

### Exact query families used

```text
A5 invariant cubic threefold modular curve X0(5) intermediate Jacobian
A5 invariant cubic threefold modular curve X0(3) intermediate Jacobian
alternating group cubic threefold intermediate Jacobian 3-isogeny
"2304.03214" "X_0(3)"
"Special subvarieties in the locus of intermediate Jacobians" "3-isogeny"
"MH1" "X0(3)" cubic threefold
"A5" cubic threefold "3-isogeny"
A5 cubic threefold pencil singular members
icosahedral hyperelliptic genus 5 A5 12 branch points Jacobian
cubic threefold A5 Chow motive elliptic curve zeta function
cubic threefold special intermediate Jacobian minimal class stable rationality
"(t+27)(t+3)^3" X_0(3) j invariant
```

### Priority verdict

The following are pre-empted and must be credited rather than sold:

- the one-dimensional PEL special image;
- `J(X) ~ E^5`;
- the order-five Prym elliptic factor and its general formula;
- the existence/types of the five-`A_2` and chordal boundary cubics;
- the general compactified behavior of chordal intermediate Jacobians.

The bounded audit did **not** locate prior identification of this `A5` family
with the explicit `X_0(3)` Hauptmodul, the Fricke formula on the cubic
parameter, the `F_11` trace collapse through the two modular `j`-values, or an
integral arithmetic Torelli theorem.  This is a priority lead, not yet a
publication-grade global novelty claim; forward citations and classical
invariant-theory sources must be closed before manuscript language is written.

## Reproducibility packet

Replay:

```text
python3 notes/2026-08-10-c904-paper-v-modular-clues.py
python3 notes/2026-08-10-c904-a5-pencil-boundary.py
nix-shell -p 'python3.withPackages (ps: [ ps.sympy ])' --run \
  'python -u notes/2026-08-10-c904-a5-pencil-j-map.py'
```

Inputs and artifacts:

| path | bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.json` | 8,380 | `b7e0adde2bc32c7ad7f35b4f97703c1c91a63fab7b563d2bef5a9e97962c344b` |
| `notes/2026-08-10-c904-paper-v-modular-clues.py` | 7,370 | `2c86c76641bfd9ea74d8ccaf8b1b04454900a6f2694c60f4c2c92d339e4e2ba2` |
| `notes/2026-08-10-c904-paper-v-modular-clues.out` | 752 | `16fb413976ea623ecbab74d527c76892a8724486b121fa2a9636c6e86b09bdb8` |
| `notes/2026-08-10-c904-a5-pencil-boundary.py` | 6,340 | `fbf84962b3e4f06b77badba21251934ccb7e5f50f4a8a3c08cc8108450ad2e2b` |
| `notes/2026-08-10-c904-a5-pencil-boundary.out` | 782 | `f5cc29b44cca66d9c1a4d1c7b73d2d3a4e782943cfb377e52387209838bb06aa` |
| `notes/2026-08-10-c904-a5-pencil-j-map.py` | 5,626 | `e76612c19740cd6dd4e96f0e365ac8c27bc3aaf55dfd2b915b297b0ee623376c` |
| `notes/2026-08-10-c904-a5-pencil-j-map.out` | 1,052 | `d60a636f35e8d85a6535aaa7c8bbdc7a5a9f35c424ecfa2cecca44e2c3463663` |

The boundary census is an independent finite-field scan of the canonical
integral pencil.  The `F_11` point counts independently enumerate projective
points using the committed Paper-V coefficients.  The modular identity is a
third calculation from the integral six-point model and the published Prym
formula.  No single numerical fit is being used as sole evidence.

## Highest-EV next work

1. Prove the human version of the modular-shadow lemma and close classical and
   forward-citation priority.
2. Compute the normalizer quotient and decide exactly whether `t`, `t^2`, or a
   finite orientation marking is the true cubic moduli coordinate.
3. Classify the integral `A5`-stable symplectic lattice in `H^3` and calculate
   the principal-polarization gluing on the six elliptic axes.
4. Only then attempt the motivic/zeta theorem and Picard--Fuchs package.
5. Match Fermat, Klein, and `Y_6` to explicit `T`-values and test Fricke/CM
   pairings; this is the cheapest high-surprise corollary.

Vibe: the search moved from speculative to excellent.  The rational modular
crown is real; the integral polarization is now the decisive frontier.
