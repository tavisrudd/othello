# C471--C474 downstream implications of the Hadamard--Golay--Weil bridge

**Lane:** `crowns`

**Date:** 2026-07-22

## Purpose

This memo records what the C471--C474 chain would unlock if its successive gates pass. It is a
shared consequence map, not evidence for any uncompleted claim. The four task cards own their
exact inputs, computations, acceptance gates, and negative dispositions.

## Certified starting point

C465 and C469 already establish the following finite objects and boundaries.

- The frozen `F_3 PSL_2(11)` permutation action on the punctured ternary Golay carrier is
  `1+5_epsilon`, not either genuine six-dimensional `SL_2(11)` Weil constituent.
- Its ten-dimensional augmentation is the rigid nonsplit self-dual extension
  `5_epsilon.5_epsilon^*`; the simple core is a stable Lagrangian, the perfect code is the full
  sheet socle, and the core is its radical.
- The unpunctured `[12,6,6]_3` code is self-dual and has an integral order-12 Hadamard row model.
  Its twelve distinguished projective words have all 66 projective minimum words as their secant
  shadow.
- With `m=(q+1)/4`, the lower period polynomial is `x^2+x+m` and the two design Grams are
  `mI+(m-1)J` and `m(I+J)`. In the frozen cases the coefficient characteristic equals `m`, so
  period splitting and Gram degeneration occur together.
- C450's characteristic-zero and frozen-action negatives remain in force. Equal dimensions,
  projective equivalence, or a common character restriction never overrides the central
  `SL_2/PSL_2` discriminator.

## The mechanism in reach

The strongest successful chain would replace a collection of adjacent coincidences by one
operator-and-extension theorem:

```text
integral Hadamard/Weil-type operator
              |
              v  reduction at the bad prime
rank-half exact complex on F_3^12
              |
              +-- kernel/image = self-dual ternary Golay Lagrangian
              |
              +-- puncture = 1+5_epsilon Golay carrier
              |
              +-- shorten = simple lower-Weil Lagrangian 5_epsilon
              |
              +-- augmentation = nonsplit 5_epsilon.5_epsilon^*
```

C471 decides the operator-level part. C472 decides whether the same underlying six-space also has
a distinct canonical signed action of the double cover. C473 decides whether the integral signs
and frozen geometry orient the split lower-Weil pair arithmetically. C474 decides whether the
extension is the instance of a uniform cohomological theorem.

## Conditional unlocks

### 1. A paper-level organizing theorem

If C471 succeeds, the code, Witt design, Hadamard frame, and C465 Loewy carrier become different
shadows of one degenerate integral operator. Several large finite certificates can then be
presented as consequences of a small mechanism: an operator identity, a rank-half reduction, a
puncture/shorten diagram, and a central-character boundary.

This supplies a natural paper-2 spine:

```text
characteristic-zero roof fails
  -> bad-prime operator degenerates
  -> lower-Weil Lagrangian carrier survives
  -> signed central extension is tested exactly
  -> arithmetic and Ext mechanisms classify the survivor.
```

### 2. Resolution of the apparent six-dimensional paradox

C465 proves that the frozen permutation action on the six-space is `1+5`, so it is not the genuine
degree-six Weil module. C472 tested the natural second signed action on the same underlying
Hadamard/Golay vector space. Its central involution acts as `-1`, but the frozen preimage splits as
`C2 x PSL_2(11)` and the action remains reducible `1_-+5_epsilon,-`, not a genuine degree-six
reduction.

The rejected positive branch would have required:

```text
same six-dimensional vector space,
different group actions,
permutation action = 1+5,
signed double-cover action = genuine Weil six-space.
```

That branch is now closed inside the signed monomial carrier. The exact replacement is a canonical
split signed Bockstein transport and a local-to-global extension theorem: the frozen hinge and both
`M11` parents split compatibly, but their complements generate the globally nonsplit signed group.

The missing ingredient for the rough genuine-Weil objective is the nonzero Schur cocycle plus a
canonical carrier refinement that realizes it. Plausible alternate attacks are a direct modular
Weil lattice, a quadratic/Maslov refinement of the Bockstein-Tor pairing, a nonmonomial projective
`PGL_6(3)` search, or a Clifford-phase-space realization. Replacing the input by abstract
`SL_2(11)` supplies genuine six-modules but does not by itself connect them canonically to the
Hadamard/Golay geometry.

A Tao-style reframing sharpens this further. The full signed Mathieu action on C471's same
six-space is irreducible by exhaustive cyclic-submodule generation; only its frozen hinge
restriction is `1+5`. The two split parent actions recover the center when glued. The remaining
metaplectic question is therefore whether the recorded central word is the Maslov holonomy of the
coordinate/Hadamard-row change of polarization, not whether the hinge preimage is nonsplit.

### 3. Canonical arithmetic orientation

The pair `5_a,5_b` is currently intrinsic only as a Galois/dual pair; table labels are not a
geometric orientation. C473 asks whether the Hadamard sign normalization, minority-symbol block,
frozen sheet, or signed cocycle selects one prime above `3` in `Q(sqrt(-11))`, and analogously one
prime above `2` in `Q(sqrt(-7))`.

A positive result would turn chirality from a table swap into a residue-prime choice and provide a
literal integral-to-modular intertwiner. A negative result would still be valuable if it proves
that the orientation is a genuine torsor under every allowed gauge rather than a missing
normalization convention.

### 4. A reusable modular-carrier diagnostic

C474 tests whether the two frozen augmentation modules are the unique nonzero classes in the
relevant `Ext^1(d^*,d)` spaces. At full strength, it would identify a uniform package:

```text
period polynomial x^2+x+m splits mod m
  + design Gram degenerates mod m
  + a simple half-dimensional Lagrangian appears
  + the dual simple is the head
  + the self-dual carrier is the unique nonsplit extension.
```

This would be a transportable diagnostic for analogous bad-prime carriers in other finite-group,
code, or design settings. The diagnostic must state exact hypotheses; the two cases `q=7,11` do
not by themselves establish a family.

### 5. Reconstruction from one twelve-point object

Combined with C469, a successful C471 identifies a single twelve-point Hadamard configuration as
the source of:

- the self-dual ternary Golay code as kernel/image;
- the 66 projective minimum words as complete secant closure;
- the Witt blocks after puncturing;
- the simple five-dimensional carrier after shortening; and
- the nonsplit augmentation after removing the fixed line.

This is stronger than matching parameters or automorphism labels: it gives explicit recovery maps
between the operator, code, projective, design, and module layers.

### 6. Quantum and metaplectic interface

The self-dual `[12,6,6]_3` code defines a distinguished twelve-qutrit stabilizer state through the
standard self-dual-code construction. C472 shows that its certified signed monomial symmetry is
not a genuinely metaplectic/Weil six-space: the restricted group is split and the carrier is
reducible. A Clifford-phase-space lift remains a distinct possible construction. Any quantum statement
must be derived with explicit stabilizer conventions and distance checks; this memo makes no AME,
local-Clifford, or physical-realization claim.

## Success ladder

The chain remains useful under partial failure.

| Passing gates | Durable consequence |
|:--|:--|
| C471 only | Exact Hadamard degeneration complex and canonical puncture/shorten explanation of C465 |
| C471 + negative C472 | Operator mechanism and canonical signed transport survive; the upper-Weil monomial door closes, while compatible local splittings expose a global gluing obstruction |
| C471 + positive C472 | Same-space/two-action theorem and a genuine double-cover Weil realization |
| plus C473 | The lower constituent is canonically oriented, or its exact arithmetic torsor is proved |
| plus C474 two-case result | Exact cohomological classification of both frozen carriers |
| plus C474 uniform theorem | Reusable period/Gram/Ext mechanism beyond the two examples |

Thus no later negative erases C471's operator theorem or C465's modular carrier.

## Paper and novelty boundary

If the full package passes, it is a plausible headline mechanism for paper 2 because it connects
finite geometry, coding theory, modular representation theory, arithmetic splitting, and signed
quantum/Weil symmetry through explicit maps. External claims of novelty or priority require a
separate literature audit covering modular reductions of the ternary Golay module, Hadamard
operator degenerations, `2.PSL_2(11)` restrictions inside signed Golay automorphisms, and known
Ext/Loewy descriptions. Classical names such as `M12`, ternary Golay, or Weil do not establish that
this particular mechanism is new.

## Gates that prevent overclaiming

- C470 owns the exact automorphism boundary; later tasks may consume but not assume a Mathieu
  identification.
- C471 must prove literal kernel/image and puncture/shorten maps, not infer them from dimensions.
- C472 must distinguish permutation, projective, monomial, split-cover, and nonsplit-cover actions
  and record every scalar.
- C473 must track every allowed sign, row, sheet, and projective gauge before calling an
  orientation canonical.
- C474 must compute Ext and cocycles; a nonsplit example or scalar commutant is insufficient.
- Phase-3 manuscript synthesis starts only after the task dispositions are known.
