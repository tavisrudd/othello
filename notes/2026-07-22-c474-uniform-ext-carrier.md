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

### Full `D8` realization: reflection-relative syzygies

The binary endpoint is now identified on the whole Sylow group, not only on its detecting cyclic
subgroup.  Write

```text
P=D8=<r,s | r^4=s^2=1, srs=r^-1>,
H0=<s>,       H1=<rs>,
Omega(P/H)=ker(F_2[P/H] -> F_2).
```

Exact intertwiner calculations give

```text
S_7|P    ~= Omega(P/H0)    ~= Omega(P/H1)^*,
S_7^*|P  ~= Omega(P/H0)^*  ~= Omega(P/H1).
```

Thus the two endpoints are the dual reflection-relative syzygies associated with the two
reflection classes of `D8`.  The two displayed descriptions of each module are genuinely
isomorphic, not just stably equivalent.  For each identification the intertwiner space has
dimension two and contains exactly two invertible maps; the certificate records the canonical
one.

This proves full Sylow endotriviality internally.  On each endpoint, conjugation on its
nine-dimensional endomorphism module has the exact decomposition

```text
End(S_7|P) ~= F_2 direct-sum F_2 P,
End(S_7^*|P) ~= F_2 direct-sum F_2 P.
```

The trivial summand is generated by the identity matrix.  Its invariant complement is the
eight-dimensional trace-zero endomorphism space.  Exact orbit enumeration finds 128 vectors in
that complement whose eight `P`-translates form a basis, proving that the complement is the
regular module `F_2 P`.  Since projectivity is detected on a Sylow subgroup, both global endpoint
modules are endotrivial.

The coefficient module is subtler.  It is

```text
M=Hom(S_7^*,S_7)=S_7 tensor S_7
  ~= Omega(P/H0) tensor Omega(P/H0)
```

on `P`, with an explicit certified nine-by-nine intertwiner.  It is not the ordinary syzygy
`Omega^2(F_2)`, and it is not `F_2 direct-sum F_2 P`.  Its endomorphism ring has dimension 11; an
exhaustive check of all `2^11` endomorphisms finds only the zero and identity idempotents, of ranks
zero and nine.  Hence `M|P` is indecomposable.  Nevertheless

```text
M|<r> ~= J4^2 direct-sum J1,
```

so it becomes stably trivial on the detecting `C4`.  This is the exact missing explanation of the
binary Sylow gap: cyclic restriction kills the square of the relative endotrivial class, while the
whole dihedral group retains it.  The second direction in `H^1(P,M)` is therefore real
rank-two-local information, not numerical slack in the cocycle solver.

### Picard normalization and downstream meaning

Let `U=S_q` and write `x=[U]` in the group `T(G)` of endotrivial modules.  Both endpoints are now
proved endotrivial without importing a classification theorem:

- at `q=7`, the full `D8` decomposition above gives `End(U)|D8=F_2+F_2D8`;
- at `q=11`, `U|C3=J3+J2` is stably `J2=Omega(F_3)`, so its endomorphism module is one trivial
  summand plus free `C3` summands.

Tensoring the frozen extension by `U` converts it, in the stable category, to

```text
0 -> U tensor U -> A_q tensor U -> U^* tensor U -> 0,
                             with U^* tensor U ~= F_p stably.
```

Consequently C474's class is canonically

```text
Ext^1_G(U^*,U) ~= Ext^1_G(F_p,U tensor U)
                ~= stable-Hom_G(Omega(F_p),U tensor U),
```

and `U tensor U` represents the doubled Picard class `2x`.  The carrier is therefore a morphism
from the first syzygy of the tensor unit to a stable invertible object; it is not merely an
extension between two small unrelated simples.

The doubled classes behave differently in the two rows.

- At `q=11`, `2x` restricts trivially in `T(C3)`, because `Omega(F_3)` has period two.  It is not
  globally trivial: otherwise `H^1(G,U tensor U)=H^1(G,F_3)=0`, since `PSL_2(11)` is perfect,
  contradicting the certified nonzero carrier.  Thus `2x` is a nonzero element of the
  Sylow-restriction kernel `ker(T(G)->T(C3))`.
- At `q=7`, `2x` is already nontrivial on `D8`, where it is the indecomposable square of a
  reflection-relative generator, but becomes trivial after restriction to `C4`.  Fusion is
  therefore load-bearing at the level of the Picard class as well as at the level of `H^1`.

This supplies immediate applications.  The carrier can be transported by stable tensor
autoequivalences; higher Ext becomes cohomology with a stable-invertible coefficient; and proposed
code/design carriers can first be screened by a Sylow endpoint test and then recognized by the
one-element Jordan rank jump.  In the cyclic-Sylow row, the class also lands directly in the
theory of Sylow-trivial endotrivial modules and weak homomorphisms.  These are conceptual
placements, not novelty claims; compare Carlson--Thevenaz, arXiv:1408.3982, and
Carlson--Mazza--Nakano, arXiv:1504.00881.  The broader rarity of simple endotrivial modules for
quasi-simple groups is documented by Lassueur--Malle--Schulte, arXiv:1305.3466, while higher Ext
for `PSL_2(q)` in cross characteristic is an available comparison target in Saunders,
arXiv:2002.04183.  The orbit-category/homotopy bridge is directly aligned with Grodal,
arXiv:1608.00499, and the Dade-group gluing viewpoint with Bouc, arXiv:0809.0493.

### Categorical form: a Picard-graded cone

The stable category `stmod(F_p G)` is triangulated and symmetric monoidal.  Endotrivial modules are
exactly its tensor-invertible objects, so `x=[U]` lies in its Picard group.  Under the stable
normalization above, the carrier sequence is the distinguished triangle

```text
U tensor U  ->  A_q tensor U  ->  1  --alpha-->  Sigma(U tensor U).
```

Equivalently, `alpha` is the unique nonzero morphism

```text
alpha: 1 -> Sigma(L_{2x}),
```

where `L_{2x}=U tensor U` represents the doubled Picard class.  Thus `alpha` has two gradings:
cohomological degree one and Picard degree `2x`.  The one-dimensional Ext computation says that
the nonzero cone/fibre is unique up to the endpoint scalar action.  This is the categorical reason
there is one nonsplit carrier middle object even though the ternary field has two nonzero cocycle
representatives.

There is a natural larger algebraic target.  Tensor products of stable morphisms give a
Picard-graded Tate-cohomology multiplication

```text
Hom(1,Sigma^a L_y) tensor Hom(1,Sigma^b L_z)
    -> Hom(1,Sigma^(a+b) L_(y+z)).
```

Hence powers of the carrier lie in

```text
alpha^n in Hom(1,Sigma^n L_(2n x)).
```

If the order of `2x` is `r`, a chosen trivialization of `L_(2r x)` returns `alpha^r` to ordinary
Tate cohomology.  C474 does not determine that order or whether these powers vanish.  Computing
the Picard order and the resulting products is the cleanest higher-Yoneda continuation; it is more
structured than listing unrelated higher Ext dimensions.

The `D8` result also has a relative-categorical interpretation.  Each endpoint is the fibre of a
permutation augmentation

```text
Omega(P/H_i) -> F_2[P/H_i] -> 1,
```

for a reflection subgroup `H_i`.  The two reflection classes give dual fibres.  The passage from
the two-dimensional Sylow `H^1` to the one-dimensional global group is then a concrete descent or
stable-elements condition: restriction to `P` supplies the local morphisms, and the single
ambient involution-fusion relation cuts out the global equalizer line.

There is one sharp Auslander--Reiten consequence.  For a symmetric group algebra an almost-split
sequence ending in `U^*` would have kernel stably `Omega^2(U^*)`.  Therefore the frozen sequence
could be almost split only if

```text
U tensor U ~= Omega^2(1) stably.
```

At q=7 this is false: the certificate separately constructs `Omega^2(1)` and its dual on `D8` and
finds no isomorphism from either to the indecomposable relative-syzygy square `U tensor U`.
Consequently the binary carrier is not an Auslander--Reiten sequence.  The analogous q=11 test is
still open; cyclic periodicity removes this easy local obstruction.

Further categorical doors, not yet proved here, are:

- determine whether the stable tensor autoequivalence defined by `U` lifts to a derived or block
  equivalence;
- locate `U`, `U^*`, and the carrier cone in the Auslander--Reiten component of the relevant block;
- compute the Picard-graded Tate ring generated by `alpha`, including nilpotence and periodicity;
- formulate the matching-sheet construction as a functorial permutation triangle whose fibre is
  forced to be invertible, which would be a genuinely categorical geometry-to-endotriviality
  theorem.

### Type-theoretic semantics: what is genuine and what is analogy

There is no new theorem here in ordinary Martin--Lof type theory.  The genuine connection appears
after enhancing the stable module category to a stable infinity category and reading its internal
homotopy theory as a linear or spectral type theory.  Stable infinity categories supply mapping
spaces/spectra whose homotopy category is triangulated; see Lurie, arXiv:math/0608228.  In that
setting the C474 objects admit the following type-like reading:

```text
G-module                 = linear local system over BG,
endotrivial U            = invertible linear type/local system,
Sigma                    = suspension type former,
Ext^1(U^*,U)             = pi_0 Map(U^*,Sigma U),
carrier                  = fibre/cofibre type of alpha:1 -> Sigma L_(2x).
```

The cocycle calculation also has a precise homotopy-level interpretation.  Cocycle gauges are
paths between presentations; quotienting by coboundaries computes the set of connected components.
Keeping the full groupoid retains automorphisms that the vector-space quotient forgets.  Thus
“there is one nonsplit carrier up to isomorphism” should not be read as saying its moduli type is
contractible.  After passing to unpointed middle modules, the nonsplit component has loop group

```text
q=7:  Aut_G(A_7)=1,          moduli component equivalent to a point;
q=11: Aut_G(A_11)=F_3^*=C2, moduli component of homotopy type B C2.
```

This is a clean use for univalent/groupoid language: isomorphic carriers become paths, while their
automorphisms remain nontrivial loops.  It also explains why the two nonzero ternary cocycles are
one object only after taking the correct homotopy quotient by endpoint scalars.

The complete finite groupoid cardinal data are now certified.  Because
`Hom_G(U^*,U)=0`, the degree-zero gauge group acts freely on cocycles.  Hence

```text
q=7:  |Z1|=2^10, |gauge|=2^9,  two contractible marked components;
q=11: |Z1|=3^26, |gauge|=3^25, three contractible marked components.
```

Set-truncation gives the Ext sets `F_2` and `F_3`.  Removing the split component and then taking
the endpoint-scalar homotopy quotient produces one unpointed nonsplit component, with homotopy
types `point` and `B(C2)` respectively.  This is a fully computed example where the successive
operations “choose coordinates,” “quotient by gauge,” “set-truncate,” and “forget endpoint
markings” are visibly different.

It also resolves the determinant phenomenon in type-theoretic language.  A function defined on
cocycle representatives descends to the quotient only if it respects gauge paths.  At q=11 the
determinant takes all three values `0,+1,-1` within the single fixed nonzero local class, so it is
not path-invariant and cannot eliminate out of the quotient type.  Its failure to orient C473 is
therefore a descent failure, not merely an unlucky statistic.  At q=7 it is constant, but the base
field has no second sign and supplies no missing arithmetic orientation.

There is a second type-theoretic view through `BG`.  A `G`-module is a functor from the one-object
groupoid `BG` to vector spaces.  The frozen cocycle is twisted descent data for an extension of two
such local systems.  Restriction to `BP` is substitution along `BP -> BG`; the binary fusion
condition is coherence under a conjugacy path in `BG`.  In this language the one-dimensional global
line is the type of coherent local sections, while the discarded Sylow direction fails one
conjugacy coherence.

Possible formal/type-theoretic continuations are therefore sharply separated:

- **finite formalization:** machine-check the matrix intertwiners, regular-orbit bases, cocycle
  identities, and idempotent exhaustion in a proof assistant; this needs finite algebra, not a
  full stable-category implementation;
- **univalent moduli:** define the groupoid/type of short exact sequences with these endpoints and
  recover its two connected components and their loop groups;
- **linear HoTT semantics:** internalize `alpha:1 -> Sigma L_(2x)` and its Picard-graded powers in a
  stable/spectral type theory;
- **fusion as descent:** express the q=7 global line as a homotopy equalizer of restriction and
  conjugation maps, turning the current one-relation calculation into a reusable dependent-descent
  pattern.

The first item is practical now.  The last three are conceptual research directions; C474 supplies
an unusually small exact test object for them but does not itself construct the required type
theory.

One further proof-engineering payoff is certificate compression.  A kernel-checked formalization
does not need the entire table of group-element cocycle values as axioms.  It can reconstruct them
from the two generator actions and retain only small witnesses: the cocycle values on generators,
the splitting detector, the two relative-syzygy intertwiners, one regular cyclic vector, the fusion
conjugator, and the endomorphism-ring idempotent exhaustion.  All remaining claims are decidable
finite equalities.  The present JSON remains the reproducibility artifact; this smaller witness
set is the natural future proof term.

### Second-order category/type `ej`: orbit fibres, gerbes, and higher products

The full Sylow calculation reveals a more uniform upstream object than the two Jordan tables.  In
both cases there is a subgroup `H<=P` such that

```text
U|P = reduced linearization of P/H, plus projectives
     = ker(F_p[P/H] -> F_p), plus projectives:

q=7:  P=D8, H=<reflection>, |P/H|=4, no projective summand;
q=11: P=C3, H=1,            |P/H|=3, one free F_3[C3] summand.
```

This puts the common mechanism in the orbit/Burnside category.  Start with the transitive p-local
set `P/H`, apply linearization `X |-> F_p[X]`, and take the fibre of augmentation to the tensor
unit.  In these two cases that fibre is invertible in the stable module category.  The matching
geometry is already built from finite group sets, so a future uniform theorem should be sought as
a statement about which geometric orbit fibres become invertible after modular linearization—not
as a scalar theorem about Grams alone.

The moduli quotient also has one further categorical layer.  The coarse nonzero Ext quotient is
the point `P^0`, but the quotient stack is uniformly

```text
[Ext^1 - {0} / (G_m x G_m)] ~= B G_m,
```

because the ratio of endpoint scalars acts transitively and the diagonal `G_m` remains as
stabilizer.  The earlier `point` versus `B(C2)` distinction concerns finite-field rational points:
`G_m(F_2)=1`, whereas `G_m(F_3)=C2`.  Intrinsically both nonsplit carriers form the same residual
gerbe `B G_m`.  The projective Ext point is therefore only the coarse shadow of the true extension
moduli type.

Fusion suggests a higher descent formulation.  Local carrier maps over p-subgroups form a diagram
over the orbit/fusion category.  A global carrier should be a point of its homotopy limit: local
classes together with conjugation paths and all higher coherences.  C474 sees the first nontrivial
shadow of that statement.  At q=7, two Sylow directions are available, and one conjugacy coherence
cuts them to the global line.  For a larger family, higher derived limits of this diagram are the
natural obstruction groups; this replaces ad hoc fusion equations by a reusable descent problem.

Finally, the next information after Yoneda degree one is not only a list of vector-space
dimensions.  For the object `U direct-sum U^*`, the carrier is an arrow in its Ext quiver.  Higher
compositions, Massey products, and Toda brackets form the minimal `A_infinity` structure on the
derived endomorphism algebra.  They determine relations invisible to the one-dimensional Ext
space and are candidates for distinguishing the cyclic-torsion and dihedral-relative mechanisms.
Concretely:

- compute Picard-graded products `alpha^n` first;
- where a product vanishes, compute the associated Toda/Massey bracket;
- compare the resulting minimal `A_infinity` algebras for q=7 and q=11;
- test whether the period/Gram operator supplies a canonical nullhomotopy or higher operation.

The last possibility is the most plausible remaining route by which the upstream Gram/operator
geometry could control more than the endpoint module: not by determining `Ext^1` again, but by
selecting higher coherence data on its unique nonzero class.

There is also a clean “structure versus property” lesson for C473.  Arithmetic orientation is
extra structure—a chosen point of a free two-point torsor—not a proposition recoverable from the
unpointed carrier.  Univalent language makes the obstruction precise: any proposed orientation
eliminator must be invariant under every path/automorphism of the unpointed moduli object.  The
determinant fails that test explicitly in the ternary gauge component.

### Complete second-order bridge map

The bridges now compose into one chain rather than a list of analogies:

```text
pointed matching G-set
  -> orbit/Burnside fibre ker(F_p[P/H] -> F_p)
  -> endopermutation source / Dade-class representative
  -> endotrivial Picard object U
  -> doubled invertible coefficient L_(2x)=U tensor U
  -> Picard-graded twisted class alpha in H^1(G,L_(2x))
  -> unique stable cone A_q tensor U
```

Three secondary branches leave that chain:

```text
p-local restrictions -> fusion/orbit-category descent -> global stable-elements line;
endpoint scalars      -> quotient stack B G_m          -> arithmetic rigidification torsor;
higher compositions  -> A_infinity/Toda structure     -> possible Gram/operator coherence.
```

The individual theory bridges, with their exact current status, are as follows.

1. **Burnside/orbit category to modular representations — proved in both rows.**  The endpoint
   source is the reduced linearization of one transitive Sylow orbit, plus projectives.  This is
   the most economical upstream common construction and suggests Mackey-functor or biset methods
   for transporting the carrier.

2. **Dade/endopermutation theory to block sources — proved locally.**  The q=7 source is the
   reflection-relative endotrivial module `Omega(D8/<s>)`; the q=11 source is `J2=Omega(F_3)`.
   The remaining `J3` at q=11 is projective.  Hence the simple endpoints have Sylow vertex and
   explicitly identified endopermutation sources.  This opens Green correspondence, source
   algebra, and block-equivalence calculations without first reconstructing the large carrier.

3. **Stable Picard theory to twisted cohomology — proved.**  Tensoring by `U` turns the original
   Ext problem into a unit-to-`2x` problem.  The coefficient is invertible, so its cohomology is a
   Picard twist of ordinary group cohomology.  What remains is to locate `x` and `2x` exactly in
   `T(G)` and determine their orders.

4. **Essential cohomology and detection — newly proved at q=7.**  Inside the recorded `D8`, the
   two Klein four subgroups have coefficient-cohomology dimensions

   ```text
   H^1(<r^2,s>,M):  dimension 4,
   H^1(<r^2,rs>,M): dimension 1.
   ```

   The frozen class restricts nontrivially to both `V4`s, but its restriction to every one of the
   three order-two subgroups of either `V4` is zero.  It is therefore essential on both Klein four
   subgroups in the literal sense “nonzero but zero on every proper nontrivial subgroup.”  This
   explains why rank-one elementary-abelian tests see nothing while rank two does.  It also warns
   against importing ordinary-cohomology detection slogans unchanged into twisted coefficients.

   The full restriction profile strengthens this.  With the established `D8` basis,

   | `D8 H^1` class | essential on `<r^2,s>` | essential on `<r^2,rs>` |
   |:--|:--:|:--:|
   | `(0,1)` | no | yes |
   | `(1,0)` frozen/global | yes | yes |
   | `(1,1)` | no | no (restriction zero) |

   On the first `V4`, all three classes are nonzero but only the frozen one is essential; on the
   second, the restriction has rank one, the first two classes give its unique essential class,
   and `(1,1)` is the kernel.  Hence the frozen/global line is intrinsically the unique
   **bi-essential** nonzero class: essential on the Klein four subgroups attached to both reflection
   classes.  This is a p-local characterization independent of the chosen global cocycle basis.

5. **Fusion systems and homotopy descent — degree-one shadow proved.**  The ambient group fuses
   involutions from the two local reflection patterns, cutting `H^1(D8,M)` from dimension two to
   one.  The general bridge is a homotopy limit over the p-orbit/fusion category; higher derived
   limits should measure failure to glue local carrier classes.

6. **Tensor-triangular geometry — door open.**  Endotrivial objects are invertible and therefore
   have the same tensor support as the unit.  Yet q=7 distinguishes `2x` on `D8` while killing it
   on `C4`.  Support alone cannot remember this Picard/fusion information.  The natural question
   is what refinement of Balmer support records the relative-syzygy or fusion label.

7. **Yoneda, Auslander--Reiten, and `A_infinity` theory — one negative proved, higher structure
   open.**  The binary carrier is not almost split because its kernel fails the `Omega^2(U^*)`
   test.  The ternary AR status, the Ext quiver around `U+U^*`, and its minimal derived
   endomorphism `A_infinity` algebra remain open.

8. **Tate periodicity and secondary operations — open but sharply posed.**  Powers of `alpha`
   live in Picard-shifted Tate groups.  When a Picard power returns to the unit, they enter ordinary
   Tate cohomology.  Vanishing products then expose Massey products or Toda brackets.  These are
   the correct second-order invariants if the Gram/operator geometry supplies coherent
   nullhomotopies rather than another degree-one class.

9. **Derived deformation/moduli theory — coarse and stacky degree zero proved.**  The carrier is a
   Schur object (`End_G(A_q)=F_p`), the coarse nonsplit extension space is `P^0`, and the residual
   extension gerbe is `B G_m`.  Tangent and obstruction groups `Ext^1(A_q,A_q)` and
   `Ext^2(A_q,A_q)` are not yet computed; they would determine whether the rigid finite-field
   point sits in a nontrivial derived deformation family.

10. **Stable infinity categories and type theory — semantic model identified.**  The carrier is a
    fibre/cofibre type of `1 -> Sigma L_(2x)`, gauges are paths, automorphisms are loops, and fusion
    is coherent descent.  The finite marked/unmarked extension groupoids are completely counted.
    A formal univalent or spectral internalization remains future work.

11. **Arithmetic/Galois descent — obstruction clarified.**  C473's two-point orientation is a
    rigidification torsor over the unpointed object.  Determinant fails to descend through gauge,
    so it cannot supply a section.  The open arithmetic question is whether the Picard class or a
    higher product carries a genuinely Galois-equivariant rigidification.

12. **Incidence geometry, codes, and permutation modules — practical application proved.**  The
    matching incidence construction feeds the orbit-fibre source, while one p-element's top
    nilpotent rank recognizes the nonsplit middle module.  This gives a two-stage search strategy
    for other code/design carriers: find a reduced Sylow orbit fibre, then test the carrier by one
    Jordan surgery.

13. **Operator/Bockstein geometry — separation and possible reunion.**  C471's q=11 integral
    operator explains a bad-prime degeneration, whereas the q=7 Ext class is ordinary quotient
    inflation and needs no Bockstein.  They are distinct degree-one mechanisms.  A possible reunion
    can only occur at second order, if the operator canonically selects a nullhomotopy, Toda
    bracket, or deformation of the unique carrier class.

14. **Proof theory and certified computation — compression target identified.**  Every new claim
    is finite linear algebra.  The independent replay reconstructs the local orbit modules,
    intertwiners, regular summands, essential `V4` restrictions, and idempotent exhaustion.  A
    proof-assistant port can use reflection on these compact witnesses while leaving the large JSON
    as an external reproducibility transcript.

15. **Exact categories with duality and Witt theory — metabolic/nonsplit distinction proved.**
    The augmentation carrier is self-dual and contains `U` as a Lagrangian, so it is metabolic and
    represents zero in the ordinary Witt group.  At the same time its underlying module extension
    is the unique nonzero Ext class.  Thus Witt triviality does not imply module splitting here.
    This opens Grothendieck--Witt or hermitian `K`-theory as the natural home for a secondary
    invariant of the nonsplit metabolic object.  A single Lagrangian supplies no Maslov index;
    an additional Lagrangian, orientation, or comparison trivialization would be needed.  That is
    exactly compatible with the failure of determinant gauge to recover C473's orientation.

16. **Ext quivers and Hall algebra — degree-one input proved, multiplication open.**  The
    one-dimensional Ext space supplies one arrow from `U^*` to `U` in the block's Ext quiver, and
    the split/nonsplit dichotomy gives the two middle-module strata in the corresponding Hall
    product.  The scalar quotient explains why two ternary nonzero extension vectors contribute
    one isomorphism class.  Computing the actual Hall structure constants, the reverse arrow,
    quiver relations, and derived Hall products would package the finite-field counting and the
    higher `A_infinity` structure together.

The highest-value bridges to pursue next are therefore not fourteen separate projects.  They
collapse to three calculations:

```text
(A) determine the Picard orders and Picard-graded powers of alpha;
(B) compute the orbit-category descent/higher-limit picture, starting with the essential V4 class;
(C) compute the minimal A_infinity/deformation and self-dual Witt data, then test whether Gram
    operators select a higher coherence.
```

Together these would say whether C474 is merely a small exceptional carrier, or the degree-one
face of a uniform orbit-to-Picard-to-coherence mechanism.

### Which bridges are most surprising and most fruitful?

The strongest ranking after the complete bridge audit is:

1. **Bi-essential fusion descent — most surprising and most immediately fruitful.**  A class that
   vanishes on every involution nevertheless survives essentially on both rank-two elementary
   abelian subgroups, and this property singles out the global line among all Sylow classes.  It
   converts the binary proof from “one lucky fusion equation” into a gluing condition across the
   rank-two subgroup complex.  The next bounded calculation is the orbit-category restriction
   complex and its first higher limit; it should expose whether bi-essentiality is exactly the
   descent obstruction.

2. **Reduced orbit fibre to endotrivial source — most plausible uniform theorem.**  Both rows come
   from `ker(F_p[P/H]->F_p)` plus projectives.  This is the only bridge that naturally starts at the
   matching `G`-set and ends at the Picard object without passing through character tables.  It is
   the best route to other Golay/Hadamard/design carriers and to a real family statement.

3. **Nonsplit but metabolic — best route back to Gram geometry.**  Ext sees a unique nonzero
   module extension while Witt theory sees zero because a Lagrangian exists.  A secondary
   Grothendieck--Witt/Maslov/formation invariant is therefore exactly the kind of datum the Gram
   construction might still control.  This is more targeted than asking the Gram scalar to force
   Ext dimension.

4. **The doubled Picard class — cheapest higher-Yoneda payoff.**  At q=11 it is nonzero globally
   but trivial on the Sylow subgroup; at q=7 it is nontrivial on `D8` but trivial on `C4`.  Finding
   its Picard order immediately determines when powers of the carrier return to ordinary Tate
   cohomology.  The cyclic q=11 case is likely the shortest complete computation.

5. **Residual gerbe and univalent moduli — cleanest conceptual payoff.**  The coarse answer `P^0`
   hides a uniform `B G_m`.  This precisely organizes gauges, scalar orbits, automorphisms, and the
   orientation descent failure.  It is an excellent formalization example, though less likely by
   itself to produce a new finite-group theorem.

6. **`A_infinity`/Toda and derived deformation — highest upside, highest cost.**  These structures
   could be where the integral operator and Gram geometry re-enter, but they should follow the
   Picard-order and orbit-descent calculations rather than precede them.  Otherwise the search
   space is unnecessarily large.

Two negative results are also valuable route filters.  The binary coefficient is neither the
stable unit nor an ordinary `Omega^(+/-2)` module, and the carrier is not Auslander--Reiten.
Consequently the useful binary theory is genuinely relative/fusion-theoretic; ordinary periodic
syzygy or AR explanations are closed.

### Upstream mystery: what the geometry does and does not force

The geometry-to-endotriviality bridge is now proved for the two frozen carriers.  Starting only
from the pointed matching construction, C465's row-space core, and the Sylow action induced on
that core, one obtains

```text
q=7:  reflection-relative Omega on D8;
q=11: Omega(F_3) plus a free summand on C3.
```

Those two local normal forms imply global endotriviality by Sylow detection of projectivity.  Thus
no external character table or classification of simple endotrivial modules is required for the
two-case theorem.

What remains open is narrower than before.  The scalar period/Gram identities alone cannot imply
endotriviality: they specify a degenerate pairing and a Lagrangian dimension, but contain no Sylow
action, reflection class, or local Jordan type.  The load-bearing upstream datum is the interaction
of the Lagrangian core with the p-local orbit geometry.  A genuine family theorem must therefore
produce, uniformly, one of the following local conclusions:

```text
cyclic P:  U|P = Omega(F_p) plus free modules;
dihedral P: U|P is a reflection-relative syzygy (or its dual).
```

This gives a precise replacement for the former vague question “does Gram geometry force
endotriviality?”: determine geometric hypotheses forcing one of these Sylow-module normal forms.
For the two matching sheets the answer is yes by the explicit constructions above; outside them,
the report still has neither a carrier nor a p-local orbit theorem.

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
6. `S_q` and `S_q^*` are endotrivial, detected on a Sylow subgroup by the local normal forms
   proved above; and
7. `Ext^1_{F_p PSL_2(q)}(S_q^*,S_q)` is one-dimensional, with `A_q` its unique nonzero
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
- **Settled — the full binary Sylow realization.** On `D8`, the socle and head are the dual
  reflection-relative syzygies `Omega(P/<s>)` and `Omega(P/<s>)^*`, equivalently the dual pair
  attached to the other reflection class.  Their trace-zero endomorphisms are regular, proving
  `End(U)=F_2+F_2D8` and full endpoint endotriviality.
- **Settled — the nine-dimensional coefficient is not an ordinary second syzygy.** The tempting
  guess `Hom(U^*,U)=Omega^2(F_2)` is false.  It is the square of a reflection-relative generator,
  has an 11-dimensional endomorphism ring with only trivial idempotents, and is not
  `F_2+F_2D8`.  Its stable triviality appears only after restriction to `C4`.
- **Settled — the stable/Picard interpretation.** Tensoring by the endotrivial endpoint identifies
  the carrier with the unique nonzero element of
  `stable-Hom_G(Omega(F_p),S_q tensor S_q)`.  At q=11 the doubled endpoint class is a nonzero
  Sylow-trivial endotrivial class; at q=7 it remains nontrivial on `D8` and is killed on `C4`.
- **Settled — the binary carrier is not almost split.** An Auslander--Reiten sequence ending in
  `S_7^*` would force `S_7 tensor S_7` to be stably `Omega^2(F_2)`.  The full `D8` certificate
  rules out isomorphism with both `Omega^2(F_2)` and its dual, while proving the coefficient
  indecomposable; stable Krull--Schmidt cancellation therefore rules out the AR possibility.
- **Settled by type-theory `ej` — the extension moduli groupoid.** Endpoint-fixed gauge acts freely,
  giving `p` contractible marked components.  After removing the split component and quotienting
  endpoint scalars, the unpointed nonsplit component is a point at q=7 and `B(C2)` at q=11.
- **Settled by type-theory `ej` — determinant is a failed descent datum.** Its ternary variation
  inside one gauge component proves that it is not path-invariant and cannot descend to the
  extension quotient; the absence of an orientation is structural, not a failure to choose the
  right representative.
- **Settled by second-order category `ej` — a common orbit-fibre source.** Both Sylow endpoints are
  reduced linearizations `ker(F_p[P/H]->F_p)` plus projectives: a reflection orbit of `D8` and the
  regular orbit of `C3`.  This relocates the uniform mechanism from Gram scalars to the
  orbit/Burnside category.
- **Settled by second-order category `ej` — coarse point versus residual gerbe.** The projectivized
  nonzero Ext space is `P^0`, while the genuine algebraic quotient stack is uniformly `B G_m`.
  The point/`B(C2)` distinction is its `F_2`/`F_3` rational-point groupoid.
- **Settled by theory-bridge `ej` — essential rank-two detection.** The frozen q=7 class is
  nonzero on both Klein four subgroups in the recorded `D8` and zero on every constituent `C2`.
  The two `V4` coefficient `H^1` dimensions are four and one, exposing the two reflection classes
  and proving that rank-one detection loses genuine twisted-cohomology information.
- **Settled by the full restriction profile — bi-essentiality characterizes the global line.** Of
  the three nonzero `D8` classes, only the frozen `(1,0)` class is essential on both reflection-type
  Klein four subgroups.  The other two are essential on one and neither, respectively.  This gives
  a basis-free p-local recognition criterion for the global carrier class.
- **Settled — effects of C472/C473.** The signed split cover introduces no second extension class;
  the pointed trace-prime rule canonically names the socle in each case.
- **Partly settled, with exact Phase-3 boundary — geometry-to-endotriviality.** For both frozen
  sheets the matching geometry, core construction, and induced Sylow action now derive
  endotriviality internally: reflection-relative on `D8`, and `Omega+free` on `C3`.  Pure
  period/Gram scalars still do not force those local actions.  The remaining family-level problem
  is to formulate geometric hypotheses forcing one of the two recorded Sylow normal forms.
  Outside `{7,11}` no carrier is defined, so Phase 3 must retain a proved two-case mechanism rather
  than assert a family theorem.
- **Open — higher Yoneda structure.** C474 determines degree one and provides the coefficient as a
  doubled stable Picard class, but does not compute `Ext^n(S_q^*,S_q)` or its Yoneda products for
  `n>1`.  More precisely, it does not determine the Picard order of `2[S_q]`, the powers of the
  carrier in Picard-graded Tate cohomology, or whether the q=11 carrier is an AR triangle.  The
  q=11 cyclic-Sylow row is the cheapest next target because periodicity should give a finite
  repeating calculation.
- **Open — categorical/type-theoretic enhancement.** The stable triangle and the unpointed moduli
  loop groups are determined, but the report does not construct a stable infinity-category model,
  a univalent extension type, or the fusion line as a formal homotopy equalizer.  The finite
  certificate is ready for proof-assistant formalization independently of those larger semantics.
- **Open — the three composed second-order bridges.** The remaining theory map compresses to:
  Picard orders and powers, orbit-category higher descent from the essential `V4` class, and the
  minimal `A_infinity`/deformation and secondary Witt structure possibly selected by Gram
  operators.  None is implied by the completed degree-one calculation.
- **No other genuine C474 mystery remains.** Ext dimensions, cocycle representatives, frozen-class
  coordinates, endpoint automorphisms, full Sylow endpoint types, scalar orbits, and the exact
  larger-family obstruction are closed.
