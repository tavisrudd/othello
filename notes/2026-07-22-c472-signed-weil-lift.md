# C472 — signed Hadamard lift and the central Weil discriminator

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `SHARP NEGATIVE — THE FROZEN PREIMAGE IS THE SPLIT DIRECT PRODUCT C2 x PSL_2(11), AND ITS SIGNED SIX-SPACE IS 1_- + 5_EPSILON,-, NOT EITHER IRREDUCIBLE GENUINE WEIL SIX-SPACE`

## Result

Starting only from C470's two literal signed monomial generators, the checker enumerates all
190,080 signed elements and retains those whose coordinate permutation belongs to C470's explicit
660-element frozen subgroup.  The full preimage has order 1,320 and kernel

```text
{I_12, -I_12}.
```

It is not the nonsplit cover `2.PSL_2(11)`.  Every frozen permutation occurs with the pure sign
mask, and these 660 pure lifts form a subgroup.  Multiplication gives a literal isomorphism

```text
< -I_12 > x PSL_2(11)  ->  preimage,
(z,g)                  |-> z (g,0).
```

Thus the exact extension is

```text
C2 x PSL_2(11).
```

This is a restriction theorem about C470's concrete signed extension.  It does not import the
abstract `2.M12` label used to name the ambient group.

## Literal complement, relations, and cocycle

C470's frozen generators already have zero sign masks.  In old-to-new coordinate notation they are

```text
T = [1,2,3,4,5,6,7,8,9,10,0,11],
S = [8,2,1,7,5,4,6,3,0,9,10,11].
```

With `a=S` and `b=S*T`, exact signed multiplication gives

```text
|T|=11,  |S|=2,  |b|=3,  |S*b|=11,  |[S,b]|=5,
```

and these zero-mask elements generate exactly 660 signed matrices.  Adjoining the central
all-minus mask `z=4095` doubles the order to 1,320.  The center is exactly `{1,z}`, while the
derived subgroup is exactly the pure 660-element complement.  The element-order census is

```text
1^1  2^111  3^110  5^264  6^330  10^264  11^120  22^120.
```

For the literal section `s(g)=(g,0)`, the cocycle is identically zero:

```text
c(g,h)=s(g)s(h)s(gh)^(-1)=0.
```

The checker verifies all `660^2=435,600` ordered pairs.  Since `PSL_2(11)` is perfect,
`Hom(PSL_2(11),C2)=0`; consequently this direct product has no second graph complement.  There is
no hidden alternative signed action obtained by choosing different lifts of the frozen subgroup.

## Sharp extension discriminator

The order census separates the extension without group names.  The split preimage has 110
noncentral involutions, two above each of the 55 projective involutions.  In the nonsplit
`SL_2(11)` cover, those 110 lifts instead have order four; C465's exact mod-3 double-cover table has
a single order-four class of size 110.  Therefore the two order-1,320 groups cannot be identified
over the frozen projective quotient.

Equivalently, the nonzero ambient central-extension class restricts to zero on this frozen
`PSL_2(11)` hinge.  The alternative nonzero class in the abstract multiplier exists, but this
embedding inside the signed Hadamard group does not realize it.

## Signed-pair geometry

C470's suggested geometric test is positive for splitting.  The stabilizer of the oriented pair

```text
(+e_11,+h_0)
```

is exactly the pure 660-element complement and projects bijectively to the frozen group.  The
global scalar changes it to `(-e_11,-h_0)` and therefore lies in the projective-cell stabilizer but
not the oriented-pair stabilizer.

The full picture is cleaner.  There are `24*24=576` signed coordinate/Hadamard-row pairs.  Under
the full 190,080-element signed group they form exactly two orbits:

| exact integral inner product | orbit size | stabilizer order |
|---:|---:|---:|
| `+1` | 288 | 660 |
| `-1` | 288 | 660 |

Choosing an oriented signed pair is therefore precisely a geometric trivialization of the
restricted cocycle.  Forgetting both signs merges each pair with its simultaneous negative and
recovers C470's projective base-cell stabilizer of order 1,320.

### Two-parent signed gluing

C470's two projective `M11` parents lift separately but do not glue to a global complement.

- The stabilizer of `+e_11` has order 7,920 and is a complement in the order-15,840 preimage of
  the parity-coordinate `M11`.  Only its intersection of order 660 is pure; the remaining lifts
  carry nontrivial coordinate signs.
- The stabilizer of `+h_0` also has order 7,920 and is a complement in the other order-15,840
  `M11` preimage.  It is literally C470's pure transitive `M11`.
- Their intersection is exactly the pure frozen `PSL_2(11)` complement.
- Nevertheless, the two complements generate all 190,080 signed elements, including the central
  scalar.  A shortest word in the certificate's deterministic ten-generator set reaches the
  center in length eight.

Thus every piece of the `M11 <- PSL_2(11) -> M11` diagram splits, and the splittings agree on the
hinge, but their join is the globally nonsplit signed group.  The obstruction is genuinely in the
global two-parent gluing rather than in either parent or the common subgroup.  This is the signed
counterpart of C470's outer `M11` gluing theorem.

### Tao-style reframing: the phase is global, not on the hinge

The natural missed question is whether splitting on the frozen subgroup is actually expected.
Metaplectic covers often split on polarization stabilizers; the nontrivial phase appears when
Fourier intertwiners glue different polarizations. Here the coordinate and Hadamard-row parents
play exactly those two roles.

This analogy has a new exact foothold. Restricting C470's signed generators to the C471 six-space
and generating the cyclic submodule of every one of its 728 nonzero vectors gives dimension six
every time. Thus

```text
full signed Mathieu action on C_12: irreducible,
either frozen hinge restriction:   1 + 5,
two parent splittings joined:       globally nonsplit, center recovered by a length-eight loop.
```

So the irreducibility and central phase we were seeking already reappear globally; only the demand
that they occur on the frozen `PSL_2(11)` hinge was wrong. The exact missing comparison is now
smaller: express the recorded central witness as holonomy around a loop in the signed
coordinate-row cell groupoid and compare that scalar with the standard Maslov/metaplectic cocycle.
Until that comparison is made, this is a certified global signed irreducible carrier and a precise
metaplectic analogy, not an `SL_2(11)` Weil identification.

## The six-dimensional action

Restrict the literal signed coordinate matrices to C471's certified basis

```text
C_12=ker(H)=im(H^T).
```

The JSON records the exact `6x6` matrices for `T`, `S`, and `z`.  The center acts as

```text
z | C_12 = 2 I_6 = -I_6 over F_3,
```

so its Brauer value is `-6`.  This passes the necessary central discriminator that killed C465's
unsigned permutation action.

It is not sufficient.  On the unique complement, the all-one line is fixed and C471's extended
shortened code is the stable simple five-space.  Hence

```text
C_12 | PSL_2(11) = 1 direct-sum 5_epsilon,
C_12 | (C2 x PSL_2(11)) = 1_- direct-sum 5_epsilon,-.
```

The module is semisimple and reducible.  Its Brauer character on the twelve 3-regular direct-product
classes is exactly

```text
chi(z^e,g)=(-1)^e (1+chi_5_epsilon(g)).
```

On the six frozen `PSL_2(11)` classes of orders `1,2,5,5,11,11`, the complement values are C465's

```text
[6, 2, 1, 1, -A, -B],
```

where `A` and `B` are the two conjugate five-term 11th-root periods recorded literally in the
certificate.  The central coset has the negatives of these values.

C471's divided Bocksteins make this representation canonical on both sides of the exact complex:
they transport the signed kernel action equivariantly to the corresponding cokernel action.  C472
therefore classifies a genuine signed transport, not just the original coordinate model.

## Genuine Weil comparison

C465's two genuine degree-six Gérardin reductions are irreducible modules for the nonsplit
double cover.  Both have central value `-6`, but both have value zero on the order-four lift of a
projective involution.  The C472 carrier instead lives on the split group, has two involution
classes above the projective involution with values `2` and `-2`, and decomposes as `1_-+5_-`.

Thus three exact discriminators agree:

1. **Extension:** `C2 x PSL_2(11)` versus `SL_2(11)`.
2. **Element order:** involution lifts of order two versus order four.
3. **Module:** reducible `1_-+5_epsilon,-` versus irreducible degree six.

The shared central value `-6` is necessary but not diagnostic.  Neither genuine degree-six Weil
reduction matches.

## Alt-attacks stress test

Five independent routes reach the same disposition.

1. **Signed geometry.** The oriented-pair stabilizer is a 660-element subgroup projecting
   bijectively to the frozen group.
2. **Cocycle algebra.** The pure section has zero cocycle on all 435,600 ordered pairs.
3. **Internal group structure.** The preimage has center two, derived subgroup 660, and 110
   noncentral involutions—the direct-product profile, not the perfect nonsplit profile.
4. **Module structure.** The all-one line and extended shortened five-space are complementary
   invariant summands even after the center is made negative.
5. **Brauer/order discriminator.** The split involution lifts have values `+/-2`; the genuine
   modules have value zero on order-four lifts.

There is also an exhaustive attack on lift choice.  Each of `T,S` has exactly two lifts, differing
by `z`.  All four pairs give:

| central factor on `T` | central factor on `S` | generated order | `|T|` | `|S|` | `|ST|` | complement? |
|---:|---:|---:|---:|---:|---:|:--|
| 0 | 0 | 660 | 11 | 2 | 3 | yes |
| 0 | 1 | 1,320 | 11 | 2 | 6 | no |
| 1 | 0 | 1,320 | 22 | 2 | 6 | no |
| 1 | 1 | 1,320 | 22 | 2 | 3 | no |

Only the pure pair obeys both `T^11=1` and `(ST)^3=1` and avoids generating the center.  Therefore
the negative cannot be evaded by a different central choice for the standard generators.

## Alt-attacks, alternative framing, and alternative inputs

The negative is not the best top-level framing. The exact positive replacement is:

```text
canonical signed Bockstein transport on the C471 six-space,
group = C2 x PSL_2(11),
center = -I,
unique complement action = 1 + 5_epsilon,
full signed action = 1_- + 5_epsilon,-,
local splittings agree but fail to glue globally.
```

This is an unqualified green structure theorem. What remains sharply negative is only the proposed
identification with an irreducible genuine upper-Weil six-space.

The alt-attacks exhaust every same-input escape:

| attack / alternative input | genuine six-space? | reason |
|:--|:--:|:--|
| choose other central lifts of `T,S` | no | all four choices were exhausted |
| twist by a linear character | no | abelianization is `C2`, so only trivial and central-sign twists exist; both restrict as `1+5` |
| use the other signed-pair orbit | no | both 288-orbits have the same pure hinge complement |
| use either `M11` parent | no | both parent preimages split and agree on the hinge |
| conjugate the frozen base cell | no | conjugation preserves extension class and module decomposition |
| use the canonical five-space | lower-Weil only | positive and C473-oriented, but degree five rather than genuine degree six |
| replace the preimage by abstract `SL_2(11)` | yes, as new input | genuine six-modules exist there, but order-four involution lifts prevent embedding it as C470's frozen preimage |
| switch to the characteristic-two control | different problem | the central sign collapses, but this is the q=7 case |

The only positive rescue therefore changes the central-extension class. An arbitrary vector-space
identification could place an `SL_2(11)` genuine module on the same six-dimensional set, but it
would not be the signed monomial action, would not intertwine C471's operator geometry, and would
not be canonical from the Golay/Hadamard input. That is replacement, not repair.

That same-input exhaustion is only the first alt-attack layer. For the rough objective—put a
genuine Weil/metaplectic structure in meaningful contact with the Hadamard/Golay carrier—the
missing ingredient has three simultaneous faces:

```text
group:    the nonzero class in H^2(PSL_2(11),C2),
module:   an irreducible six-dimensional F_3 action of its nonsplit cover,
geometry: a canonical refinement of the C471 carrier that realizes that cocycle.
```

The central scalar `-I` supplies only a necessary shadow. The signed-pair orientation actually
trivializes the restricted cocycle, and C471's Bockstein currently supplies bilinear transport but
no phase refinement. The strongest intrinsic candidate is therefore a quadratic refinement—or
Maslov/metaplectic phase—of the Bockstein–Tor pairing. Such data can carry a Schur cocycle where a
plain equivariant linear isomorphism cannot.

There is a further projective obstruction. The split action preserves both the all-one projective
point and the projective hyperplane of the five-space. Either genuine six-space is irreducible, so
it preserves no proper projective linear subspace. Projective conjugacy preserves that property.
Thus allowing scalars or moving from `GL_6(3)` to `PGL_6(3)` does not repair the comparison.

Consequently a successful alternate construction cannot remain an automorphism of the full
pointed Golay `1<1+5` flag. It must either preserve only coarser H/Bockstein data while mixing the
line and five-space, or move to a larger Clifford/phase-space carrier. This is the exact price of
recovering irreducibility.

The genuine alternate attacks on the rough objective are:

1. **Direct modular Weil model.** Construct literal `6x6` generators over `F_3` for a genuine
   `SL_2(11)` Weil reduction, put them on C471's abstract six-space, and search for an H-derived
   tensor or quadratic refinement that makes the identification canonical.
2. **Bockstein quadratic refinement.** Compute the perfect kernel/cokernel pairing implicit in the
   Smith/Tor model, enumerate its quadratic refinements, and test whether one has automorphism
   extension `SL_2(11)` rather than `C2 x PSL_2(11)`.
3. **Projective nonmonomial search.** Search `PGL_6(3)` for a projective frozen action preserving a
   coarser H/Bockstein structure whose inverse image in `GL_6(3)` is nonsplit. It must leave the
   signed monomial subgroup tested by C472.
4. **Clifford-space reframing.** Seek the nonsplit action on the qutrit Pauli symplectic phase space
   and its metaplectic lift, rather than on the six-dimensional codeword carrier. This could recover
   the quantum rough objective without contradicting the linear-module negative.
5. **Different subgroup class.** Enumerate nonconjugate `PSL_2(11)` subgroups in the ambient
   projective group and test the restricted extension class. A nonsplit class would necessarily
   abandon the frozen base-cell stabilizer unless it preserves an equivalent coarser geometry.
6. **Lower-Weil replacement.** Treat the canonical five-space, C473 trace-prime orientation, and
   C474 Ext carrier as the actual bad-prime Weil object. This route is already achieved except for
   C474's assigned uniformity gate.

Routes 1–5 are new constructions or bounded new searches, not reinterpretations of C472's failed
lift. Route 2 is the most likely to preserve the exact operator geometry; Route 6 is the strongest
result requiring no new carrier.

## Verified downstream impact of the negative

The damage is localized to the optional upper-Weil/metaplectic branch.

- C471's exact Hadamard complex survives intact and gains canonical signed kernel/cokernel
  transport.
- C473's arithmetic orientation survives intact because it concerns the lower five-space; C472's
  central sign contributes no independent orientation bit.
- C474's Ext question survives intact because it classifies the lower-Weil augmentation carrier,
  not an upper six-space.
- Paper 2 must drop the proposed same-space/two-action genuine-Weil headline. Its stronger surviving
  spine is bad-prime degeneration to a lower-Weil Lagrangian, together with the theorem that the
  signed extension splits on the hinge and both parents but is nonsplit in their global gluing.
- The twelve-qutrit carrier retains its certified signed monomial symmetry, but C472 supplies no
  genuine metaplectic/Weil symmetry claim.

No code, Hadamard, Golay, lower-Weil, arithmetic-prime, or Ext conclusion is invalidated.

## Sharp disposition

The signed genuine-Weil door closes:

```text
same six-dimensional vector space: yes,
canonical signed kernel/cokernel transport: yes,
central scalar -1: yes,
nonsplit 2.PSL_2(11) action: no,
genuine irreducible Weil six-space: no.
```

The only frozen complement is the pure one, so the signed action is exactly the central-sign twist
of C465's `1+5` carrier.  C465's negative remains unchanged and is now strengthened: even the full
signed Hadamard preimage supplies no alternative genuine six-dimensional action.

## Certificate and reproducibility

The atomic bundle consists of:

- `notes/2026-07-22-c472-signed-weil-lift.md`;
- `notes/2026-07-22-c472-signed-weil-lift.py`;
- `notes/2026-07-22-c472-signed-weil-lift-replay.py`;
- `notes/2026-07-22-c472-signed-weil-lift.json`;
- `notes/2026-07-22-c472-signed-weil-lift.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c472-signed-weil-lift.py --check
python3 notes/2026-07-22-c472-signed-weil-lift-replay.py
sha256sum -c notes/2026-07-22-c472-signed-weil-lift.sha256
```

Intentional regeneration is the primary command without `--check`.  It reconstructs the full
signed group and frozen preimage from literal generators, checks the zero cocycle on every ordered
pair, computes center, derived subgroup, relations, element orders, signed-pair orbits, carrier
matrices, and imports only the hash-pinned exact Brauer rows from C465.

The independent replay uses a distinct 24-point signed-permutation representation.  It re-enumerates
the groups of orders 190,080, 1,320, and 660; rechecks the direct factorization, zero cocycle,
center, derived subgroup, order census, both 288-point signed-pair orbits, the `6x6` carrier action,
and the Brauer discriminators.  It imports no primary code.

Trusted boundary: exact finite permutation, signed-monomial, integer, and `F_3` arithmetic plus the
hash-pinned C450/C455/C465/C470/C471 certificates.  No new Mathieu classification, arithmetic
orientation, Ext computation, or literature claim is made.

## Extra-juice closeout and mystery ledger

- **Settled — split or nonsplit.** The pure zero-mask section is a literal subgroup and its cocycle
  vanishes on all 435,600 pairs.  Center and derived subgroup independently give `2` and `660`.
- **Settled — why the global nonsplit cover can split here.** The ambient extension class restricts
  trivially on the frozen hinge.  The two 288-point signed-pair orbits exhibit the trivialization
  geometrically through oriented inner product `+1` or `-1`.
- **Settled by the second extra-juice pass — where the global obstruction lives.** Both order-15,840
  `M11` preimages split, their chosen order-7,920 complements meet in the pure frozen complement,
  yet together generate all 190,080 signed elements and an explicit length-eight word recovers the
  center.  Nonsplitting is a global parent-gluing phenomenon invisible on every piece of the hinge.
- **Settled — central scalar versus genuine Weil structure.** The center does act as `-I`, but the
  carrier is reducible `1_-+5_epsilon,-`; projective involutions lift to involutions and have
  character values `+/-2`, not the genuine order-four value zero.
- **Settled — whether another complement could rescue the action.** Perfectness gives
  `Hom(PSL_2(11),C2)=0`, so the split preimage has a unique complement.  There is no second signed
  restriction to test.  Exhausting all four central choices for the two frozen generators reaches
  the same conclusion and records the first failed order relation in every nonpure case.
- **Settled by alt-attacks — whether a twist or alternate frozen input rescues it.** The derived
  subgroup has index two, so the only linear characters are trivial and central sign; both retain
  the reducible `1+5` complement action. Both signed-pair orbits, both `M11` parents, all conjugate
  base cells, and all generator lifts leave the restriction split. Only replacing it by abstract
  nonsplit `SL_2(11)` produces genuine six-modules, at the cost of leaving the certified carrier.
- **Settled by impact verification.** The negative cuts only the optional upper-Weil/metaplectic
  branch. C471 transport, C473 lower-prime orientation, and C474 lower-carrier Ext remain valid.
- **Settled by further extra juice — projectivizing does not help.** The split action fixes the
  all-one point and five-space hyperplane in projective space; either genuine six-space is
  irreducible and has neither. Any successful alternate attack must therefore forget the full
  pointed Golay flag, retaining only coarser operator/pairing data or moving to phase space.
- **Settled by the Tao-style global question.** Exhaustive cyclic-submodule generation proves the
  full signed Mathieu action on the six-space is irreducible even though the frozen hinge is
  `1+5`. The nontrivial central phase is a global row/coordinate gluing phenomenon. What remains is
  the exact holonomy/Maslov comparison for the recorded length-eight central loop.
- **Open with exact owner — arithmetic orientation.** The five-space remains named only up to the
  conjugate label `epsilon`; C473 decides whether the integral signs orient it or prove a torsor
  obstruction.
- **No genuine C472 mystery remains.** Extension, cocycle, signed geometry, central action,
  composition factors, Brauer character, and both genuine-Weil comparisons pass independent replay.
