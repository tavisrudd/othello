# C465 — mod-3 Brauer bridge between the Golay carrier and the Weil pair

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `SHARP NEGATIVE FOR THE SIX-DIMENSIONAL F_3 WEIL/GOLAY IDENTIFICATION; GREEN FOR THE FIVE-DIMENSIONAL SIMPLE CORE; THE F_2 CONTROL IS BRAUER-POSITIVE`

## Result

Let `D_q` and `S_q` be the row spans of the frozen cross-sheet disjointness and shared-edge
matrices in the C464 characteristic (`F_2` for `q=7`, `F_3` for `q=11`). Exact prime-field
reduction, direct invariant-subspace generation, and exact Brauer-character evaluation give

```text
q=7:   0 < S_7 < D_7,     dim(S_7,D_7)=(3,4),
q=11:  0 < S_11 < D_11,   dim(S_11,D_11)=(5,6),

D_q = S_q direct-sum <1>.
```

Here `S_q` is simple. The full submodule-dimension lists are `[0,3]` and `[0,1,3,4]` at `q=7`,
and `[0,5]` and `[0,1,5,6]` at `q=11`. Thus both perfect-code modules are semisimple, their
socles are the whole modules, and their radicals vanish. The complementary matrices give the
same two modules in the opposite role:

```text
disjoint row span = shared-edge right kernel = D_q,
shared-edge row span = disjoint right kernel = S_q.
```

This certifies the complete kernel/span structure requested by the card, not merely its
composition-factor multiset.

## Characteristic three: the roof remains negative

The irreducible `F_3 PSL_2(11)` Brauer degrees are

```text
1, 5_a, 5_b, 10, 12_a, 12_b.
```

On concrete `3`-regular classes of orders `1,2,5,5,11,11`, the frozen simple core has Brauer
character

```text
[5, 1, 0, 0,
 E(11)^2+E(11)^6+E(11)^7+E(11)^8+E(11)^10,
 E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9].
```

It is one member of the Galois-conjugate degree-five pair; swapping the two equal-size order-11
classes swaps the table names `5_a,5_b`. Consequently

```text
S_11 has Brauer character 5_epsilon,
D_11 has Brauer character 1 + 5_epsilon.
```

The two ordinary degree-five Gérardin constituents of `2.PSL_2(11)=SL_2(11)` reduce irreducibly
to the two degree-five Brauer characters and have central value `+5`. Therefore exactly one lower
Weil constituent matches the frozen core, at the Brauer-character level.

The degree-six halves behave differently. Each ordinary genuine degree-six constituent reduces
to an irreducible degree-six Brauer character of the double cover. Its central scalar remains
`-1=2` in `F_3`, and its central Brauer value is `-6`; it does not descend to `PSL_2(11)`. In
particular it cannot equal the Golay module `D_11=1+5_epsilon`, whose inflated center acts
trivially. Thus the numerical `6` is not a hidden modular Weil identification: C450's central
discriminator survives unchanged, and the proposed Brauer-level roof is sharp-negative in
dimension six.

## Characteristic-two control

For `PSL_2(7)` in characteristic two the irreducible Brauer degrees are `1,3_a,3_b,8`. The
three-dimensional Hamming dual `S_7` is one member `3_epsilon` of the Galois pair, while

```text
D_7 = 1 + 3_epsilon
```

as an actual semisimple module. The ordinary degree-three lower Weil pair reduces to
`3_a,3_b`. Each genuine degree-four upper constituent has decomposition row `1+3_a` or
`1+3_b`. Hence one lower constituent matches `S_7`, and one upper constituent has the same
Brauer character as `D_7`.

Here the central obstruction dies for the literal lattice reductions because the scalar `-I`
reduces to `+I` in `F_2`; equivalently, the central two-subgroup is invisible on every simple
Brauer factor. The positive statement is deliberately at the Brauer-character/semisimplification
level. It does not select an integral Weil lattice and prove that its reduction is the particular
split Hamming module rather than another extension with the same factors.

## Alt-attacks stress test

Three logically distinct routes reach the same disposition.

1. **Central-character attack.** In characteristic three the genuine degree-six reduction has
   center `-I`, while every inflated frozen `PSL_2(11)` module has center `+I`. This alone forbids
   an isomorphism, independent of code structure.
2. **Ambient-decomposition attack.** C450's nontrivial sheet constituent has degree `q-1`. Its
   computed decomposition row is `3_a+3_b` at `q=7` and `5_a+5_b` at `q=11`. Therefore the full
   sheet has factors `1+3_a+3_b` or `1+5_a+5_b`; the perfect-code flag takes `1` and one member of
   the pair, leaving the conjugate simple as the ambient quotient. There is no six-dimensional
   genuine factor available at `q=11`.
3. **Direct-lattice attack.** Exhausting every cyclic submodule inside the row spans gives only
   dimensions `[0,d]` for the core and `[0,1,d,d+1]` for the perfect code. This proves the literal
   split `1+ d` module without using any character-table decomposition.

The attacks share only the frozen action and agree on both controls. Their agreement rules out a
table-naming accident, a rank-only coincidence, and a hidden nonsplit extension as explanations
of the `5+6` profile.

## Extra-juice replacement roof: the self-dual sandwich

The orthogonality already computed for the two codes upgrades the ambient decomposition to a
canonical module flag. Since `S_q=D_q^perp`, the invariant dot product gives

```text
0 < S_q < D_q=S_q direct-sum <1> < M_q,
M_q / D_q  ~=  S_q^*.
```

Exact Brauer-table duality exchanges the two small simples (`3_a <-> 3_b` and
`5_a <-> 5_b`). Hence the full frozen sheet is not merely a multiset
`1+d_a+d_b`: it is the self-dual sandwich

```text
q=7:   3_epsilon < 1+3_epsilon < M_7,    quotient 3_epsilon^*,
q=11:  5_epsilon < 1+5_epsilon < M_11,   quotient 5_epsilon^*.
```

This is the sharp surviving Brauer roof. Both lower Gérardin halves occur canonically, one as the
cross-matrix core and its conjugate as the ambient quotient, with the trivial line between them.
The genuine upper half still does not occur at `q=11`. Thus C450's failed `5+6` split is replaced
by an exact `5|1|5^*` orthogonal flag rather than discarded wholesale.

## Second-order extra juice: the sandwich is nonsplit

Because `q` is nonzero in the working characteristic, the all-one line splits orthogonally from
the augmentation module `A_q=1^perp`, so `M_q=<1> direct-sum A_q`. The remaining question is
whether

```text
0 -> S_q -> A_q -> S_q^* -> 0
```

splits. An equivariant retraction `A_q -> S_q` would solve a finite affine linear system obtained
from the two frozen group generators plus the condition that the restriction to `S_q` is the
identity. The exact ranks are

```text
q=7,  F_2:  18 unknowns, 45 equations, rank 18, augmented rank 19;
q=11, F_3:  50 unknowns, 125 equations, rank 50, augmented rank 51.
```

Both systems are inconsistent. Hence the augmentation modules are nonsplit extensions

```text
A_7  = 3_epsilon . 3_epsilon^*,
A_11 = 5_epsilon . 5_epsilon^*,
```

with socle and radical equal to the lower core `S_q` and head `S_q^*`. For the full sheet,

```text
soc(M_q)=D_q=<1> direct-sum S_q,    rad(M_q)=S_q.
```

Thus the cross-disjointness perfect code is intrinsically the entire socle of the frozen sheet
module, not an arbitrarily chosen `1+d` summand. This is stronger than the Brauer-character
sandwich and fixes its extension class at the split/nonsplit level.

## Third-order extra juice: a rigid Lagrangian carrier

Solving the commutant equations for the two generator matrices gives

```text
End_{F_2 PSL_2(7)}(A_7)   = F_2,
End_{F_3 PSL_2(11)}(A_11) = F_3.
```

Thus each nonsplit augmentation is a brick: it has only scalar equivariant endomorphisms and no
nontrivial idempotent decomposition. Since the coordinate dot product restricts nondegenerately
to `A_q`, the invariant bilinear form is consequently unique up to scalar. It is alternating
symplectic on the six-dimensional binary augmentation and symmetric hyperbolic on the
ten-dimensional ternary augmentation.

Moreover `S_q=D_q^perp` and `S_q < D_q` force the Gram matrix on `S_q` to vanish. Its dimension is
half that of `A_q`, so the shared-edge simple core is a `PSL_2(q)`-stable Lagrangian. The surviving
modular mechanism can therefore be stated geometrically:

```text
the frozen sheet augmentation is the rigid self-dual nonsplit extension
of a simple Lagrangian lower-Weil core by its dual.
```

This formulation explains simultaneously the code duality, the two conjugate lower Brauer
characters, the nonsplit Loewy structure, and the uniqueness of the carrier form. It still makes
no claim that the genuine upper Weil constituent occurs at `q=11`.

## Fourth-order synthesis: one integer controls arithmetic and geometry

Set `m=(q+1)/4`. In the two frozen cases

```text
(q,m)=(7,2),(11,3),
```

so the coefficient characteristic is exactly `m`. The exact lower-Weil period polynomial and the
two cross-design Gram identities are

```text
period:                  x^2+x+m,
disjoint Gram:           A_D A_D^T = m I + (m-1) J,
shared-edge Gram:        A_S A_S^T = m (I+J).
```

Reduction modulo `m` simultaneously gives

```text
x^2+x+m = x(x+1),        A_D A_D^T = -J,        A_S A_S^T = 0.
```

Thus the same arithmetic event splits the conjugate lower-Weil pair over the base field, makes
the shared-edge image totally isotropic, and collapses the disjoint Gram to rank one. This is the
conceptual common cause behind the `3|1|3^*` and `5|1|5^*` carriers; the agreement is not a
coincidence between unrelated character and design calculations.

The strongest next theorem suggested by this identity is uniform and cohomological: determine
whether the carrier is the unique nonzero class in `Ext^1(d^*,d)` whenever the same period/Gram
parameter degenerates. A second sharp question is arithmetic orientation: identify which split
prime of `Q(sqrt(-q))` the frozen sheet chooses, rather than leaving `d_epsilon` defined only up to
the table's Galois swap. Those require new work; C465 certifies the common parameter and both
finite instances, not the uniform Ext theorem.

## Computation and certificate

The canonical certificate is `notes/2026-07-21-c465-mod3-weil-golay.json`. It records the literal
cross matrices, bases for every kernel and span, all submodule bases found by exhaustive module
generation, every `PSL_2` and double-cover irreducible Brauer character, both full decomposition
matrices used, the four relevant Weil rows and central values, and the comparison verdicts. The
two pairs of equal-order/equal-size regular classes are retained explicitly rather than assigned
an artificial `a/b` orientation.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c465-mod3-weil-golay.py --check
python3 notes/2026-07-21-c465-mod3-weil-golay-replay.py
sha256sum -c notes/2026-07-21-c465-mod3-weil-golay.sha256
```

Intentional regeneration is the primary command without `--check`. It rebuilds both frozen
matching sheets from the pinned C406 base objects, reconstructs both relations, computes the
prime-field kernels and spans, exhausts their invariant submodules under two standard
`PSL_2(q)` generators, and asks GAP 4.15 for the exact Brauer values and decomposition matrices.

The independent replay imports none of the primary code. It builds each sheet as a breadth-first
orbit, constructs the other sheet with an independently chosen nonsquare diagonal map, recomputes
the matrices and row spaces, exhausts every nonzero vector's cyclic submodule, and reconstructs
the four Brauer characters through a separate GAP pass. It compares equal-order classes without
assuming the primary table orientation.

Trusted boundary: exact integer and prime-field arithmetic; exhaustive finite generation inside
dimensions at most six; GAP 4.15's exact character/Brauer tables, decomposition matrices, and
`BrauerCharacterValue`; and the hash-pinned C406/C450/C464 certificates. The computation does not
certify the full Golay automorphism group, identify an integral Weil lattice, or alter C450's
characteristic-zero verdict.

## Extra-juice closeout and mystery ledger

- **Settled — rank coincidence versus module mechanism.** The dimensions `5+6` come from the
  exact split flag `S_11 < S_11 direct-sum <1>`, not from the genuine degree-six Weil simple.
  This explains why the lower half appears genuinely while the upper half does not.
- **Settled — why the two controls diverge.** The central scalar survives in `F_3` but reduces to
  identity in `F_2`. The same discriminator therefore gives a sharp negative at `q=11` and the
  Brauer-positive `1+3` control at `q=7` without any exception or naming convention.
- **Settled by explicit `ej` — the surviving roof.** The full sheet carries the canonical
  orthogonal sandwich `d_epsilon < 1+d_epsilon < M`, with quotient `d_epsilon^*`; Brauer duality
  exchanges the two lower Weil characters. This replaces the failed `5+6` claim by an exact
  `5|1|5^*` theorem and simultaneously explains the q=7 `3|1|3^*` control.
- **Settled by second-order `ej` — the extension class.** Exact equivariant-retraction systems
  are inconsistent by rank gaps `18/19` and `50/51`. The augmentation factors are therefore
  nonsplit `d_epsilon.d_epsilon^*` modules, and the perfect Hamming/Golay code is exactly the full
  sheet socle; the sheet radical is the simple shared-edge core.
- **Settled by third-order `ej` — rigidity and form geometry.** Both augmentation commutants are
  exactly the base field. The inherited nondegenerate form is therefore unique up to scalar, and
  the simple core is a stable Lagrangian: symplectic in the binary control and hyperbolic symmetric
  in the ternary case.
- **Settled by fourth-order synthesis — the common cause.** With `m=(q+1)/4` equal to the module
  characteristic, the lower period polynomial `x^2+x+m` splits exactly when the two design Grams
  reduce to `-J` and `0`. One integer therefore controls both arithmetic splitting and Lagrangian
  degeneration.
- **Open — uniform Ext and arithmetic orientation.** C465 does not compute the full
  `Ext^1(d^*,d)` group or identify which prime above `m` corresponds to the frozen sheet. These are
  the precise missing conceptual upgrades; they should be gated as new work rather than inferred
  from two cases.
- **Open but outside C465 — lattice-level strengthening at `q=7`.** Brauer characters do not
  determine whether a chosen integral degree-four Weil lattice reduces to the split Hamming
  module. A lattice choice and an explicit intertwiner are the exact missing evidence. No
  paper-facing claim here needs that strengthening.
- **No other genuine C465 mystery remains.** Kernel/span structure, composition factors,
  socle/radical, all Brauer rows, the central descent verdict, and both controls pass independent
  replay.
