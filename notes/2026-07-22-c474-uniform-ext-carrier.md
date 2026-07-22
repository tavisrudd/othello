# C474 — exact Ext classification of the lower-Weil Lagrangian carriers

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `GREEN FOR THE EXACT TWO-CASE THEOREM; NO UNIFORM q-FAMILY IS ASSERTED`

## Result

For the frozen pointed matching sheets, with `S_q` the C465 simple core and `A_q` the sheet
augmentation, exact group cohomology gives

```text
Ext^1_{F_2 PSL_2(7)}(3_epsilon^*,3_epsilon) = F_2,
Ext^1_{F_3 PSL_2(11)}(5_epsilon^*,5_epsilon) = F_3.
```

In both cases the frozen sequence

```text
0 -> S_q -> A_q -> S_q^* -> 0
```

is the nonzero class.  Moreover

```text
End(S_q)=F_p,       End(S_q^*)=F_p,
```

so `Aut(S_q) x Aut(S_q^*)` acts on the one-dimensional Ext space through the scalar ratio.
It is transitive on its nonzero elements.  Consequently each case has exactly one nonsplit
extension up to module isomorphism: one nonzero cocycle at `q=7`, and two scalar cocycles but one
endpoint-automorphism orbit at `q=11`.

C473 orients the notation without an arbitrary character-table label.  The frozen `q=7` socle is
the lower constituent selected by `(2,alpha+1)` in `Z[alpha]`, while the frozen `q=11` socle is
selected by `(3,alpha)`, where `alpha^2+alpha+(q+1)/4=0`.

## Exact cohomology calculation

Use the two frozen generators in the order `(T,S)`.  Put the augmentation basis in the canonical
form

```text
(C465 RREF basis of S_q, followed by the first C465 augmentation RREF rows that extend it).
```

The resulting row-action matrix has blocks

```text
R_g = [[V_g, 0], [C_g, W_g]].
```

Here `V_g` acts on the socle and `W_g` on the head.  For `F in Hom(S_q^*,S_q)`, use the row-module
action

```text
g.F = W_g F V_g^(-1).
```

Then

```text
z(g)=C_g V_g^(-1)
```

satisfies `z(gh)=z(g)+g.z(h)`.  The literal frozen values on `(T,S)` are

```text
q=7, F_2:
z(T) = [1 1 0]    z(S) = [0 0 0]
       [0 0 0]           [0 0 0]
       [0 0 1]           [1 1 1]

q=11, F_3:
z(T) = [1 2 0 0 0]    z(S) = [0 0 0 0 0]
       [0 0 0 2 2]           [2 1 0 1 1]
       [0 2 1 1 0]           [2 0 1 2 1]
       [0 0 0 2 2]           [0 0 0 0 0]
       [0 0 0 2 2]           [0 0 0 0 0].
```

The certificate records the values on every group element, not only on the generators, and checks
the cocycle identity on all ordered pairs.

Writing a cocycle by its two generator values gives the exact ranks

| case | cochain parameters | relation rank | `dim Z^1` | `dim B^1` | `dim H^1` | ordered-pair checks |
|:--|--:|--:|--:|--:|--:|--:|
| `q=7`, `F_2` | 18 | 8 | 10 | 9 | 1 | 28,224 |
| `q=11`, `F_3` | 50 | 24 | 26 | 25 | 1 | 435,600 |

Thus in both cases `dim Z^1=d^2+1` and `dim B^1=d^2`.  The latter equality is also the expected
one from `Hom_G(S_q^*,S_q)=0`; the exact endpoint commutant calculations give dimension one on
both simples.  Against the certificate's canonical complement to `B^1`, the frozen class has
coordinate `1` at `q=7` and `2=-1` at `q=11`, so neither extension is a coboundary.

### Extra-juice upgrade: a one-scalar splitting detector

The clean ranks permit a literal operational strengthening.  For any generator cocycle `z`, put

```text
delta(z) = <Lambda_T,z(T)> + <Lambda_S,z(S)>,
```

where the pairing is entrywise matrix dot product.  In the canonical bases above, take

```text
q=7:
Lambda_T = [0 0 0]    Lambda_S = [0 1 0]
           [1 1 0]               [0 0 0]
           [0 1 1]               [0 0 0]

q=11:
Lambda_T = [1 0 1 1 1]    Lambda_S = [0 0 1 0 0]
           [1 1 2 1 1]               [0 0 0 0 0]
           [0 0 1 0 0]               [0 0 0 0 0]
           [2 0 0 0 2]               [0 0 0 0 0]
           [0 0 0 1 1]               [0 0 0 0 0].
```

Exact linear algebra proves that `delta` annihilates every coboundary and takes value one on the
recorded `H^1` basis.  Since `H^1` is one-dimensional, this gives the sharp test

```text
the extension represented by z splits  <=>  delta(z)=0.
```

The frozen cocycles have `delta=1` at `q=7` and `delta=2=-1` at `q=11`.  Thus the full
retraction-consistency calculation compresses, after the cocycle relations are known, to one
certified field element.

There is a second rigidity consequence.  In both cases the relation rank is exactly `d^2-1`, the
coboundary rank is `d^2`, and the carrier endomorphism ring is `F_p`.  Hence the projectivized Ext
space is a single point, there are exactly two extension middle-module classes (split and
nonsplit), and

```text
Aut_G(A_7)=1,       Aut_G(A_11)=F_3^* of order 2.
```

So arithmetic orientation is needed to name the socle constituent, but no scalar, cocycle-basis,
or endpoint gauge can create a second nonsplit carrier.

### Second-order extra juice: p-local detection depth

The scalar detector is basis-dependent as written, but the extension class has a sharper
basis-free local meaning.  Restrict it to cyclic subgroups in the coefficient characteristic.
Exact enumeration gives:

| case | cyclic subgroup | number of subgroups | local `dim H^1` | frozen restriction |
|:--|:--|--:|--:|:--|
| `q=7`, `F_2` | `C2` | 21 | 1 | zero on every one |
| `q=7`, `F_2` | `C4` | 21 | 1 | nonzero on every one |
| `q=11`, `F_3` | `C3` | 55 | 1 | nonzero on every one |

Thus the restriction from the global one-dimensional `H^1` to any displayed detecting cyclic
`H^1` is an isomorphism.  At `q=11` this is exactly Sylow detection: a Sylow 3-subgroup is cyclic
of order three, and restriction is injective abstractly because its index is prime to three.  At
`q=7`, restriction to a Sylow 2-subgroup is likewise injective, but the new fact is subtler: the
class dies on all 21 involution subgroups and first appears at cyclic order four.  It is a genuine
depth-two 2-local obstruction, not an involution-level sign.

Tiny witnesses suffice in the frozen generators.  With generator indices `(0,1)=(T,S)`, `T^3 S`
has order four and detects the binary class, while `T S` has order three and detects the ternary
class.  The certificate records their literal permutations and cocycle values.  It also checks all
42 order-four elements at `q=7`, all 110 order-three elements at `q=11`, and the full p-divisible
element census; the independent replay reconstructs the cyclic norm and coboundary ranks.

This isolates the shared Ext result from the differing local mechanisms:

```text
q=7:  invisible on C2, visible on C4;
q=11: visible already on the Sylow C3.
```

The agreement `dim Ext^1=1` is therefore not evidence that the two classes arise at the same
cohomological depth.

### Mystery resolved: the local endotrivial mechanism

Let `J_r` denote the length-`r` indecomposable module for the relevant cyclic p-group.  For a
full-order cyclic group, the full-length block is free/projective.  The exact nilpotent ranks of
`N=g-1` now give

| case | endpoint restrictions `S_q`, `S_q^*` | `Hom(S_q^*,S_q)` restriction |
|:--|:--|:--|
| `F_2[C4]` | `J3 = Omega^1(J1)` | `J4^2 direct-sum J1` |
| `F_3[C3]` | `J3 direct-sum J2`, stably `J2=Omega^1(J1)` | `J3^8 direct-sum J1` |

The load-bearing rank profiles are

```text
q=7 Hom:   rank(N^0,N^1,N^2,N^3,N^4) = (9,6,4,2,0),
q=11 Hom:  rank(N^0,N^1,N^2,N^3)     = (25,16,8,0).
```

Thus the two endpoint restrictions are isomorphic and endotrivial on the detecting cyclic
subgroup: their Hom module is one trivial line plus projective summands.  Projective summands have
no cyclic cohomology, so the unique `J1` is exactly the source of the one-dimensional local `H^1`.
This is the structural common mechanism hidden behind the two Ext calculations.  The common
feature is local endotriviality, not merely the equality `m=(q+1)/4`.

The binary depth-two behavior is even more explicit.  After one certified coboundary gauge, for
`c=T^3S` the cocycle has

```text
z(c) = phi = [1 0 1]
             [0 0 1]
             [0 1 1],       c.phi=phi,       det(phi)=1.
```

All four fixed representatives of the nonzero local class are invertible intertwiners
`S_7^*|C4 -> S_7|C4`.  On the unique stable trivial line the cocycle is simply the quotient
character

```text
C4 -> C4/C2 ~= F_2,       c |-> 1.
```

Consequently `z(c^2)=phi+c.phi=2phi=0`.  The class is ordinary inflation from `C4/C2`; its
vanishing on involutions requires neither a Bockstein nor a quadratic refinement.  Those remain
possible structures elsewhere in the Hadamard/Golay story, but they do not explain this Ext
phenomenon.

The full binary p-local ladder is also exact:

```text
H^1(PSL_2(7),M)  --injective restriction-->  H^1(D8,M)  -->  H^1(C4,M)
dimension 1                                  dimension 2      dimension 1
```

The first map is injective by odd-index transfer (`[PSL_2(7):D8]=21`); the second has rank one and
one-dimensional kernel.  The frozen class survives both maps.  Thus local endotriviality explains
the cyclic class, while global fusion selects one of the two Sylow-cohomology directions.  For
`q=11`, the detecting `C3` is already Sylow and restriction is an isomorphism directly.

### Further extra juice: normal form and one-element recognition

The endotrivial description gives a common literal normal form.  On the detecting cyclic subgroup
`C=<g>`, there is an invariant isomorphism `phi:S_q^*|C -> S_q|C` and a coboundary gauge in which

```text
z(g^a) = (a mod p) phi.
```

For `q=7` the additive character has kernel `<g^2>` of order two; for `q=11` it is faithful on
`C3`.  The certificate chooses the lexicographically first invertible fixed representative in the
literal frozen class.  There are four such representatives in the binary case and 4,374 in the
ternary case.  Thus both cocycles are exactly “additive local character times endpoint
intertwiner,” with the unequal detection depth residing only in the character kernel.

The middle module itself now has a cocycle-free recognition test.  Restricting the split and
nonsplit carriers to one detecting element gives

| case | split endpoint sum | frozen nonsplit carrier | distinguishing rank |
|:--|:--|:--|:--|
| `q=7`, `C4` | `J3^2` | `J4 direct-sum J2` | `rank(g-1)^3: 0 -> 1` |
| `q=11`, `C3` | `J3^2 direct-sum J2^2` | `J3^3 direct-sum J1` | `rank(g-1)^2: 2 -> 3` |

Because C474 already proves that split and nonsplit are the only middle-module classes, this
single top-power rank jump is equivalent to nonsplitting in each frozen case.  It replaces the
full retraction or cocycle calculation by the Jordan type of one small p-local element once the
endpoints are known.

There is also a sharp determinant-gauge result.  On the affine space of fixed cocycle
representatives in the frozen local class:

```text
q=7:  dimension 2 over F_2; determinant is constantly 1 on all 4 points;
q=11: dimension 8 over F_3; determinant restricts to a nonzero linear functional,
      with exactly 2,187 representatives at each value 0, 1, and -1.
```

Hence every binary fixed representative is automatically an endpoint isomorphism.  In the
ternary case the invertible representatives are exactly the complement of one affine hyperplane,
split evenly between determinant `+1` and `-1`.  Determinant sign therefore cannot refine C473's
ternary arithmetic orientation without an additional gauge choice; the exact gauge orbit erases
it.

### Proof compression: cyclic Nakayama algebra plus one fusion relation

The Jordan surgery is forced symbolically.  Write the cyclic group algebras as

```text
F_2[C4] = F_2[t]/(t^4),       F_3[C3] = F_3[t]/(t^3),       t=g-1.
```

For q=7 the endpoints are both `J3`.  Their unique nonzero local extension has middle module
`J4+J2`; the alternative `J3+J3` is split.  For q=11, projective `J3` summands disappear from Ext,
reducing the problem to the unique nonzero extension of `J2` by `J2`, whose middle module is
`J3+J1`; restoring the projectives gives `J3^3+J1`.  Thus the one-element rank tests above follow
from the elementary module theory of the two truncated polynomial rings, independently of the
global cocycle solver.

This also yields short structural proofs of both global Ext dimensions.

- At q=11, restriction to the Sylow `C3` is injective by transfer, the local `H^1` has dimension
  one, and the frozen class restricts nontrivially.  Hence the global dimension is exactly one.
- At q=7, restriction to the Sylow `D8` is injective because its index is 21.  Exact `D8`
  cohomology has dimension two.  Its three nonzero classes have restriction profiles

  ```text
                     C4   central C2   reflection C2
  class (0,1):       nonzero    zero         nonzero
  class (1,0):       nonzero    zero         zero       <- frozen/global
  class (1,1):       zero       zero         nonzero.
  ```

  The central and reflection involutions are conjugate in `PSL_2(7)`; a literal conjugator is
  recorded.  Any globally stable class must therefore have compatible restrictions on them.
  Since every Sylow class vanishes centrally, fusion forces reflection restriction to vanish and
  leaves only the one-dimensional `(1,0)` line.  The frozen class occupies that line.

Consequently the full-group ranks `(10,9)` and `(26,25)` are no longer black-box explanations of
`dim Ext^1=1`: they independently verify a p-local proof using endotriviality, transfer, and—in the
binary case—one involution-fusion condition.

## Strongest honest common theorem

Let

```text
Q = {(7,2,B3), (11,3,H3)}.
```

For every `(q,p,type)` in `Q`, take the pointed Coxeter-matching sheet, its shared-edge core `S_q`,
and its sheet augmentation `A_q` with the conventions frozen by C406, C465, and C473.  Then:

1. `p=(q+1)/4`, and `x^2+x+(q+1)/4` splits as `x(x+1)` over `F_p`;
2. the shared-edge and disjointness Grams reduce respectively to `0` and `-J`;
3. `S_q` is a simple lower-Weil module, canonically oriented by the pointed sheet;
4. `S_q` is a stable Lagrangian in the self-dual augmentation `A_q`;
5. `A_q/S_q` is `S_q^*`, and `A_q` is nonsplit; and
6. `Ext^1_{F_p PSL_2(q)}(S_q^*,S_q)` is one-dimensional, with `A_q` its unique nonzero
   extension up to module isomorphism.

This is a uniform statement over the exact two-element domain `Q`, not a theorem for arbitrary
prime powers `q`.

## Exact obstruction to a larger family claim

The common integer `m=(q+1)/4` controls the period and Gram identities, but those scalar identities
do not define a `PSL_2(q)`-set, identify simple endpoint modules, or determine a group-cohomology
dimension.  The frozen carriers come from two exceptional pointed Coxeter-matching actions only:
the task's evidence supplies no corresponding sheet, incidence pair, simple core, or extension for
any `q` outside `{7,11}`.  C471 also proves that its simple-bad-prime operator mechanism is specific
to the `q=11` Hadamard scalar; its valuation hypothesis fails for the binary order-eight analogue.

Accordingly, extrapolating the Ext conclusion from the shared polynomial and Gram formulas would
discard the load-bearing representation data.  A genuine larger-family theorem requires, for a
quantified new domain, all of the following new inputs: a uniform carrier construction, proof of
simple Lagrangian socle and dual head, and a cohomology calculation or structural argument forcing
`dim Ext^1=1`.  None is implied by `m` alone.  This is the sharp stopping point requested by the
card.

## Signed and arithmetic refinements

C472 does not alter the Ext group.  Its signed preimage over the frozen `PSL_2(11)` is the split
group `C2 x PSL_2(11)` and restricts on the six-space as the central-sign twist of `1+5_epsilon`;
the lower five-dimensional carrier and its augmentation extension remain exactly those computed
here.  C473 supplies the pointed arithmetic orientation recorded above, while proving that the
unpointed object retains only the corresponding free two-point torsor.

## Certificate and reproducibility

The atomic evidence bundle is:

- `notes/2026-07-22-c474-uniform-ext-carrier.md`;
- `notes/2026-07-22-c474-uniform-ext-carrier.py`;
- `notes/2026-07-22-c474-uniform-ext-carrier-replay.py`;
- `notes/2026-07-22-c474-uniform-ext-carrier.json`;
- `notes/2026-07-22-c474-uniform-ext-carrier.sha256`.

The checksum manifest pins the report, primary script, independent replay, and canonical JSON
certificate; their exact byte counts are recorded there by the adjacent bundle audit.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c474-uniform-ext-carrier.py --check
python3 notes/2026-07-22-c474-uniform-ext-carrier-replay.py
sha256sum -c notes/2026-07-22-c474-uniform-ext-carrier.sha256
```

Intentional regeneration is the primary command without `--check`.  It rebuilds both pointed
matching sheets from C406, reconstructs the C465 core and augmentation actions, solves the full
generator-cocycle and coboundary systems, locates the frozen block cocycle, computes both endpoint
commutants, and verifies the cocycle identity on all group-element pairs.

The independent replay imports no primary code.  Starting from C465's frozen core bases and
C473's independently recorded coordinate permutations, it reconstructs both augmentation block
actions with a separate linear-algebra implementation, rebuilds the relation systems through
canonical group words, checks the Ext dimensions and non-coboundary rank gaps, and repeats all
463,824 ordered-pair cocycle checks.

Trusted boundary: exact prime-field arithmetic, complete enumeration of groups of orders 168 and
660 from their two recorded generators, and the hash-pinned C406/C465/C471/C472/C473 certificates.
The computation proves no claim about a carrier outside the two frozen matching actions and makes
no literature novelty or priority claim.

## Extra-juice closeout and mystery ledger

- **Settled — nonsplit versus the whole Ext group.** C465's inconsistent retraction systems showed
  only that the frozen classes were nonzero.  C474 computes `Z^1/B^1` and proves that each class
  spans the entire one-dimensional Ext group.
- **Settled by explicit `ej` — cocycle versus module uniqueness.** Both endpoint endomorphism
  rings are the base field.  Hence endpoint scalars are transitive on nonzero Ext classes; the two
  nonzero `F_3` cocycles give one nonsplit module-isomorphism class, not two hidden carriers.
- **Settled by explicit `ej` — literal representatives.** The two generator matrices above and
  every group-element value are frozen in the JSON, with all ordered-pair identities checked by
  two implementations.
- **Settled by the follow-up `ej` — one-scalar obstruction.** The explicit functional `delta`
  kills every coboundary, normalizes the recorded `H^1` generator to one, and evaluates nontrivially
  on both frozen cocycles.  Splitting can therefore be decided by one field operation after the
  cocycle relations are checked.
- **Settled by the follow-up `ej` — carrier moduli collapse.** The projectivized Ext space is one
  point and `End_G(A_q)=F_p`, leaving exactly the split and unique nonsplit middle modules.  Their
  nonsplit automorphism groups have orders one and two respectively.
- **Settled by second-order `ej` — local meaning of the class.** The global class restricts
  isomorphically to every `C4` at q=7 and every Sylow `C3` at q=11.  The binary class vanishes on
  every involution subgroup, proving that its first cyclic detection occurs at order four; the
  ternary class is already detected at order three.
- **Settled by mystery-directed `ej` — the shared cohomological mechanism.** On the detecting
  cyclic subgroup both endpoints are endotrivial: their Hom module is a single `J1` plus free
  blocks (`J4^2+J1` and `J3^8+J1`).  The lone stable trivial summand, and no Gram scalar by itself,
  supplies the one-dimensional local class.
- **Settled — why the binary class vanishes on involutions.** After coboundary gauge it is the
  quotient character `C4 -> C4/C2` multiplied by an invertible fixed endpoint intertwiner.  It is
  ordinary inflation, so the square maps to zero.  No Bockstein or quadratic refinement is needed.
- **Settled — the binary Sylow gap.** `H^1(D8,M)` has dimension two, restriction to `C4` has rank
  one, and odd-index transfer injects the one-dimensional global group into it.  Global fusion,
  rather than cyclic cohomology, removes the extra Sylow direction.
- **Settled by further `ej` — character/intertwiner normal form.** In both cases the frozen local
  cocycle is gauge-equivalent to `z(g^a)=(a mod p)phi` for an invariant endpoint isomorphism.  The
  binary order-two kernel and faithful ternary character now account for the entire depth
  difference.
- **Settled by further `ej` — one-element module recognition.** Nonsplitting is exactly a unit
  jump in the top nonzero nilpotent-power rank: `rank(g-1)^3` at q=7 and `rank(g-1)^2` at q=11.
  This is a basis-free local diagnostic requiring no cocycle coordinates.
- **Settled — determinant cannot secretly orient the ternary class.** Determinant is constant one
  on the four binary fixed gauges, but on the ternary eight-dimensional gauge coset it is linear
  and equidistributed among `0,+1,-1`.  The 4,374 invertible gauges split evenly by sign, so no
  preferred arithmetic prime is recovered.
- **Settled by repeated `ej` — the local computations are symbolic Nakayama extensions.** The
  surgeries `J3+J3 -> J4+J2` and `J2+J2 -> J3+J1` are the unique nonzero extensions over
  `k[t]/(t^4)` and `k[t]/(t^3)` after projectives are removed.  The rank-jump diagnostic is
  therefore a theorem of the local module types, not a pattern inferred from matrices.
- **Settled by repeated `ej` — structural global dimension proofs.** Sylow transfer and local
  endotriviality prove the ternary dimension directly.  In the binary case, the two-dimensional
  `D8` cohomology is cut to the frozen one-dimensional line because `PSL_2(7)` fuses the central
  and reflection involutions; the other two nonzero Sylow classes violate that compatibility.
- **Settled — effects of C472/C473.** The signed split cover introduces no second extension class;
  the pointed trace-prime rule canonically names the socle in each case.
- **Open, with exact Phase-3 boundary — geometry-to-endotriviality.** The Ext and unequal-depth
  mysteries are resolved internally.  What remains is whether a future uniform carrier theorem
  can derive the local endotrivial endpoint restrictions from the period/Gram geometry.  Outside
  `{7,11}` no carrier is defined, so this is the precise evidence gap; Phase 3 must record the
  current Rosetta row as a proved two-case mechanism, not a family theorem.
- **No other genuine C474 mystery remains.** Ext dimensions, cocycle representatives, frozen-class
  coordinates, endpoint automorphisms, scalar orbits, and the exact larger-family obstruction are
  closed.
