# C438 continuation — `E6/E7`, Mathieu, and arithmetic-lift gates

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** bounded continuation after the direct fibre and first theta-quotient obstructions

**Verdict:** `TWO NEW CLASSICAL HOSTS; NEITHER YET GIVES CANONICAL CROSS-FIELD RECOVERY`

## Executive answer

The best remaining attacks are no longer direct comparisons of the `8` and `6` local fibres.
They are:

1. a **consecutive del Pezzo lattice bridge** through `E6 < E7`; and
2. a **Golay/Mathieu host** in which q=9 supplies an octad-type action and q=11 supplies a
   dodecad with two Witt designs.

There is also a genuine arithmetic-lift clue: the q=9 Hermitian quartic is geometrically the
characteristic-three Klein/Fermat quartic, while C390 already links q=11 to the reduction of
Bring-curve trigonal discriminants.  This clue must retain twists and bad-reduction data.  The
standard Klein reduction has only `10` points over `F_9`, whereas the frozen Hermitian quartic has
`28`, so they are not `F_9`-isomorphic.

The first postmortem's cheapest unmarked Richelot quotient gate is now negative before any costly
theta calculation: the full q=11 symmetry conjugates all 22 matching kernels.  Any invariant of
the unmarked quotient ppav is therefore constant on the parent orbit.  A useful isogeny route must
retain a theta marking, descent datum, or kernel label.

## 1. The q=11 matching is already a double-six row

Let the six parent points be `p_1,...,p_6`, and blow them up.  On the resulting cubic surface the
six conics

```text
Q_i = 2H - sum_(j != i) E_j
```

form the conic row opposite the exceptional row `E_1,...,E_6` in the distinguished double-six.
C379's two-to-one map has the exact interpretation

```text
rho_X(u)=p_i  iff  u lies on Q_i.
```

After also blowing up `u`, the unique effective `A1` root is `Q_i-E_u`.  For the two points `u,v`
on the same `Q_i`, the roots on the common eight-point blow-up intersect in `-1`; otherwise they
intersect in zero.  Thus a q=11 matching edge is not merely analogous to an exceptional-system
object: it is the two-point fibre above one member of a classical double-six row.

This exposes the most concrete common host.  A marked q=9 Cayley octad gives an Aronhold heptad,
hence a degree-two del Pezzo surface with seven selected exceptional curves.  Contracting/deleting
one of the seven curves passes to a cubic surface and its `E6` double-six geometry.  Therefore

```text
q=9:  marked degree-2 del Pezzo / E7 exceptional system
                         | delete one mark
                         v
       marked cubic surface / E6 double-six
                         ^
                         | Q_i-E_u boundary roots
q=11: Clebsch cubic + twelve A1 extensions
```

is a category-correct bridge.  It does not identify the special q=9 cubic reductions with the
Clebsch cubic.

### Exact next gate

Project each frozen q=9 octad from its marked point to recover the seven Aronhold blow-up points.
For each of the seven deletions, compute the 27-line incidence, the distinguished double-six, and
the six conic-row evaluation divisors on the branch quartic.  Compare those six divisors—not the
whole cubic surface—with C379's six two-point divisors `Q_i cap Q(F_11)`.  Stop if no intrinsic
curve on the q=9 cubic reduction selects the conic row or if the row divisor has no recoverable
parent information.

This gate uses only C405's octad/net, C438's direct bitangent matrix, C379's five-point conics, and
standard blow-up Picard arithmetic.  It is the cheapest genuinely geometric successor.

## 2. Exact Mathieu gate on the q=11 twelve-set

Identify the deep-hole conic with `P^1(F_11)` by the pencil of lines through `(1,1,3)`.  Exact
enumeration of `PSL_2(11)` on six-subsets gives orbit sizes

```text
110, 110, 110, 132, 132, 330.
```

Both size-132 orbits are Witt `S(5,6,12)` designs: every five-subset occurs once, and each design
is closed under complementation.  They are distinct, and a determinant-nonsquare element of
`PGL_2(11)` exchanges them.  This is the same outer symmetry pattern as the two C379 matching
sheets.

For every one of the 22 frozen obstruction matchings and for either Witt design, the 132 hexads
have the identical profile

```text
12 hexads transverse to all six matching edges;
0 hexads equal to a union of three matching edges;
contained-edge count per hexad: 0^12, 1^60, 2^60.
```

Hence Mathieu geometry is a real extension of the structure, but it does not recover the parent:
all 22 matchings look identical.  What it adds is a second two-sheet torsor.  Since the outer
element swaps both the matching sheet and the Witt design, their relative orientation has two
`PGL_2(11)`-orbits.  This is a possible marked invariant, not a canonical choice on the unmarked
twelve-set.

### Cross-field Golay gate

Classically, a dodecad in the extended binary Golay code has stabilizer `M12`, contains the natural
`PSL_2(11)` action on twelve points, and supports the Witt design.  The q=9 Cayley octad has the
natural `PSL_2(7)` action expected on a Golay octad.  Thus both can be placed in `M24`, but their
relative position is additional data: octad/dodecad intersection has several allowed sizes, and
the present constructions select none.

The useful bounded question is therefore not “are they both Golay objects?” but:

> Does the q=9 Aronhold mark or the q=11 relative Witt orientation canonically select an
> octad--dodecad incidence class in one Golay realization?

If no, Mathieu is an elegant ambient envelope only.  If yes, shortening/puncturing the Golay code
along that pair supplies a common binary module on which both outer involutions can be compared.

## 3. Klein/Bring arithmetic route, with the twist retained

Elkies records that the Klein and Fermat quartics become isomorphic in characteristic three.  The
frozen q=9 curve is a nonsingular Hermitian quartic, hence belongs to this geometric exceptional
class.  But the exact point counts

```text
frozen Hermitian model over F_9: 28,
standard Klein equation over F_9: 10
```

prove that the arithmetic models are different twists.  A characteristic-zero Klein lift cannot
be substituted for C405's curve without transporting the determinantal class and its descent
cocycle.

On the other side, C390 has already done more than analogy: the two published trigonal maps on
Bring's curve have a common discriminant reducing modulo 11 to `4t^3(t^10-1)`, with the golden
roots `4,8`.  Bring's curve also has a classical modular interpretation as `X_0(2,5)`.

This suggests an integral-stack attack:

- lift the q=9 **curve plus even theta plus Aronhold mark**, not just the quartic;
- retain its characteristic-three twist cocycle;
- place the q=11 **Bring trigonal map plus chosen Witt design/matching sheet** in its stable
  integral model; and
- compare boundary monodromy on level-two data.

This is higher cost than the `E6/E7` deletion gate.  It becomes attractive only if the marked
Klein lift has a small field of definition and the q=11 stable model preserves the two Witt
orientations.

## Revised attack order

1. **Run the `E7 -> E6` deletion gate.**  It is intrinsic, coordinate-explicit, and uses the actual
   q=11 matching curves `Q_i`.
2. **Adjoin the two Witt designs to q=11.**  Test the relative-orientation bit against C390's
   Bring theta/trigonal data; the unmarked profiles are already known to collapse.
3. **Only then attempt a Golay embedding.**  Require a canonical octad--dodecad incidence class;
   do not choose one by hand.
4. **Reserve integral Klein/Bring lifting** for a positive marked-orientation signal.

The direct unmarked Richelot quotient and a common rank-three Hecke graph should be deprioritized:
the former is constant by conjugacy, while the latter forgets precisely the marking now known to
carry the surviving information.

## Evidence

Run from the repository root:

```bash
python3 notes/2026-07-20-c438-continuation-mathieu-gate.py --check
sha256sum -c notes/2026-07-20-c438-continuation-mathieu-gate.sha256
```

The standard-library checker pins C379's JSON by SHA-256, rebuilds `PSL_2(11)`, enumerates every
six-subset orbit and both Witt designs, checks the outer exchange, evaluates all 22 matching
profiles, and independently counts both q=9 plane quartics over `F_9`.

## Classical sources and boundary

- Noam Elkies, *The Klein Quartic in Number Theory*, MSRI Publications 35 (1998), especially the
  characteristic-three discussion.  Read depth: targeted search/result passage plus source
  metadata; used only for the geometric Klein/Fermat identification.  The `F_9` twist obstruction
  is our exact calculation.
- Igor Dolgachev and David Ortland, *Point Sets in Projective Spaces and Theta Functions*,
  Asterisque 165 (1988), the degree-two del Pezzo/Aronhold correspondence.  Read depth: previously
  targeted relevant sections; used for the classical `E7` marking dictionary.
- Braden and Disney-Hogg, *Bring's curve: old and new*, DOI `10.1007/s40879-023-00706-0`.
  Read depth: C390's substantive sections; used through C390 for the trigonal maps and Bring data.
- The ATLAS `M12` subgroup data and the classical Witt-design construction were checked at
  reference/metadata depth.  The claims used here are independently enumerated by the checker;
  no novelty claim is made for either Witt design or the Mathieu embeddings.

This continuation makes no priority claim.  Its new contribution is the exact identification of
C379's edges with double-six-row fibres, the all-22 Mathieu profile, and the explicit warning that
the tempting Klein lift is arithmetically twisted over `F_9`.
