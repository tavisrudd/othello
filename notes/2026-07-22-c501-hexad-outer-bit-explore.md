# C501 — hexad outer-bit certification battery

**Lane:** `crowns`

**Date:** 2026-07-22

**Status:** `COMPLETE — leg 0 canonical residue proved; leg 1 positive after correcting the
two-orbit premise; leg 2 literal index zero with a noncanonical full-capacity repair; leg 3 sharp
mismatch with C472's central scalar.`

## Result

The two frozen degree-11 actions have a nontrivial relative outer class. The exceptional shared
hexad is their canonical local witness, not the sole carrier of the bit. The two 11-orbits inside
either one Golay carrier are complement-paired and have stabilizers in the same `A5` conjugacy
class; by contrast, the shared numeric support has stabilizers in the two nonconjugate `A5`
classes under the column action on `ker(H)` and row action on `ker(H^T)`. C471's row transport
realizes the outer automorphism exchanging the actions and classes.

The Wall/Kashiwara route does not recover C472's central sign. For the literal symmetric dot form
the triple form vanishes identically. The canonical alternating repair
`omega = (H-H^T) mod 3` has a 10-dimensional symplectic quotient and supports all four classes of
`W(F_3) = Z/4`, but none of the task's proposed standalone third spaces selects a new Lagrangian.
More decisively, all ten generators of C472's signed ambient group preserve `ker(H)`. The
length-eight central witness is therefore a constant loop in the quotient Lagrangian
Grassmannian, with Maslov class `0`, even though its linear lift closes at `-I_12`. The global
central scalar lies outside this odd-characteristic Witt shadow.

## Leg 0 — canonicity: positive

The common line is

```text
<s>,  s = [0,0,1,0,0,0,1,1,1,0,1,1],
supp(s) = {2,6,7,8,10,11}.
```

Under simultaneous row/column relabeling the displayed line and hexad move equivariantly. The
ordered pair of stabilizer classes therefore changes only by simultaneous conjugacy; the binary
statement "same class or opposite classes" is intrinsic. It is `opposite`.

The primary certificate closes the ambient ambiguity by exhaustively generating C472's
190,080-element signed group. The normalizer of the frozen pure `Gamma = PSL_2(11)` has order
1,320 and is exactly

```text
{(g,0), (g,4095) : g in Gamma} = Gamma x <-I_12>.
```

Its induced automorphisms of `Gamma` are all inner. Thus no ambient signed symmetry flips the
ordered class residue; abstract outer relabeling flips the two labels as expected.

## Leg 1 — outer swap: positive, with the premise repaired

Both frozen actions have shape `1+11`: the coordinate action fixes coordinate 11 and the
row-transport action fixes row 0. For the shared support:

- the column and row stabilizers both have order 60 and element census
  `{1:1, 2:15, 3:20, 5:24}`;
- their conjugacy classes each have size 11 and are disjoint;
- their intersection has order 12 and census `{1:1, 2:3, 3:8}`, hence the expected `A4`;
- the column stabilizer has a faithful even index-five action of order 60, independently
  certifying `A5`.

Write `rho(g) = perm(H R(g) H^T/12)`. Relabel rows `1,...,11` to affine coordinates by
`beta(j)=a(j-1)+b mod 11`, with row 0 sent to coordinate 11. Of these 110 affine maps, exactly 55
make `beta rho(-) beta^-1` an automorphism of the frozen `Gamma`: every `b` and precisely the five
nonsquare slopes `a in {2,6,7,8,10}`. They are the affine slice of the outer coset. There are 660
conjugating relabelings in total, obtained from any one by left composition with `Gamma`; all
induce outer automorphisms and exchange the two `A5` classes. Conversely, the degree-11
permutation normalizer is `Gamma`: an outer normalizer would have to swap the point-stabilizer
class, while an inner normalizer differs from `Gamma` by the trivial centralizer. The independent
replay separately constructs `PSL_2(11)` on `P^1(F_11)`, enumerates its two classes of 11 `A5`
subgroups, and verifies that the explicit `PGL_2(11)` element `x -> 2x` fuses them.

The correction to the conjectured carrier is exact:

- both column and row hexad censuses decompose as `11+11+55+55`;
- the column stabilizer fixes exactly the shared hexad and its complement, one in each column
  11-orbit;
- those two 11-orbits use the same `A5` class;
- the opposite row class fixes no column hexad, and conversely.

Thus the outer bit is the relative outer class of the column and row degree-11 actions, witnessed
at their common hexad; it is not `first versus second 11-orbit inside one carrier`.

## Leg 2 — triple index: literal zero; repaired form has unselected capacity

### Symmetric reading

For any symmetric bilinear form in characteristic not 2 and maximal isotropics
`L1,L2,L3`, if `x=x1+x2 in L3` with `xi in Li`, isotropy gives

```text
0 = b(x,x) = 2 b(x1,x2).
```

Hence the associated triple form is zero. In particular, the queue row's literal orthogonal
reading over `F_3` has Witt class `0`; an orthogonal Maslov phase does not arise here.

### Canonical alternating repair

The antisymmetrized operator form

```text
omega = (H-H^T) mod 3
```

has rank 10 and radical `<s,u>`, where the second canonical RREF vector has weight 7 and lies in
neither kernel. The shared line `<s>` lies in the radical tautologically because it is killed by
both `H` and `H^T`. After quotienting by the radical, both kernels map to 5-dimensional
Lagrangians meeting in a line.

The proposed third-space battery is negative:

- the extended shortened `S_11` space maps exactly to the first Lagrangian;
- the parity-mirror code has quotient dimension 6 and is not `omega`-isotropic;
- each divided-operator graph has quotient dimension 6, is neither `omega`- nor dot-isotropic,
  and changes with the integer lift convention;
- `ker(H+H^T)` has ambient dimension 2 and quotient dimension 1;
- `ker(H^2)` has dimension 7;
- the `+1` and `-1` eigenspaces of `H mod 3` have dimensions 0 and 1.

There is nevertheless no capacity obstruction: graph Lagrangians over a computed symplectic
basis realize all four Witt classes `0,1,2,3`. What is absent is a canonical third Lagrangian,
not phase capacity.

## Leg 3 — comparison with the central scalar: sharp mismatch

C472's word

```text
[0,0,7,1,7,0,2,6]
```

evaluates, under its recorded left-multiplication convention, to identity permutation with sign
mask 4095, namely `-I_12`.

Every one of the ten signed parent generators preserves `ker(H)`, so all nine vertices of the
partial-product path are literally the same code. Each descends to the same quotient
Lagrangian; all eight fan terms

```text
tau(L0,Lk,L{k+1})
```

have rank and Witt class `(0,0)`. The loop sum is `0`, not class `2`, and therefore cannot encode
the central `-1`.

The first extra-juice pass locates the surviving datum exactly. On the six-dimensional code frame
the word has holonomy `-I_6`; after projectivization its `PGL_6` holonomy is identity, and its
determinant-line holonomy is also `det(-I_6)=+1`. Thus neither carrier geometry, projective frame,
nor orientation sees the sign. It survives only as the scalar in the linear frame.

This is not repaired by changing to an ambient-invariant alternating form. Exact signed-pair
constraints give a one-dimensional invariant bilinear-form space for the full signed group,
spanned by the symmetric dot form, and a zero-dimensional invariant alternating-form space.
The independent replay obtains the same dimensions by signed orbits of ordered coordinate pairs
rather than the primary linear-equation solver.

## ej2 — the outer bit and central bit are distinct `C2` residues

The leg-0 normalizer computation and leg-1 outer swap combine into a separation theorem:

```text
N_signed(Gamma)/Gamma = <-I> ~= C2  ----->  Out(Gamma) ~= C2
                                      zero
```

The ambient quotient is the central scalar: it fixes the carrier geometry and induces only inner
automorphisms of `Gamma`. The row transport gives the nontrivial outer class and exchanges the two
`A5` classes, but no element of the signed ambient normalizer realizes it.

Consequently the two bits cannot be merged by the canonical structures tested here:

- C472's bit is a scalar linear-frame holonomy, invisible in `PGL_6`, the determinant line, the
  Lagrangian Grassmannian, and the `A5` class labels;
- C501's bit compares two carrier embeddings and exchanges `A5` classes, but is absent from the
  ambient signed normalizer.

This is stronger than the leg-3 mismatch: the two `C2` objects live at different functorial levels,
and the certified natural comparison between them is trivial.

## Reproducibility

Atomic evidence bundle:

- `notes/2026-07-22-c501-hexad-outer-bit-explore.py`
- `notes/2026-07-22-c501-hexad-outer-bit-explore.json`
- `notes/2026-07-22-c501-hexad-outer-bit-explore-replay.py`
- `notes/2026-07-22-c501-hexad-outer-bit-explore.sha256`

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c501-hexad-outer-bit-explore.py --check
python3 notes/2026-07-22-c501-hexad-outer-bit-explore-replay.py
sha256sum -c notes/2026-07-22-c501-hexad-outer-bit-explore.sha256
```

Load-bearing inputs:

| Input | Bytes | SHA-256 |
|---|---:|---|
| `2026-07-22-c471-hadamard-degeneration-complex.json` | 69,824 | `3676e3b8b1c7c92f9c74b80c90b572d3322c73a2509cd96b5718e769fb0e5a15` |
| `2026-07-22-c472-signed-weil-lift.json` | 29,087 | `9c9311c48a33d4e3fe0101ecb82cb29154e926e3bf920771716ae5bb69ffefe5` |
| `2026-07-22-c489-maslov-roof-staged.json` | 10,354 | `a8990f63545b5cfd693c303e74b5712d023fa23e93b2c661cdf3740fca9c9a8c` |

The primary generator uses exact integer and `F_3` arithmetic; exhaustive closures of the
660-element frozen group and 190,080-element signed ambient group; and exhaustive finite
stabilizer, conjugacy, affine-relabeling, normalizer, codeword, and invariant-form computations.
Its canonical `--check` mode regenerates in memory and does not alter the worktree.

The independent replay rebuilds `H` from its incidence block, finds both kernels by enumerating all
`3^12` vectors, constructs a separate `P^1(F_11)` model for the outer class fusion, propagates
invariant-form constraints by signed coordinate-pair orbits, and verifies directly that all eight
partial products fix the entire 729-word kernel.

The bundle does not claim that the non-invariant `omega` is a metaplectic representation, nor any
literature priority. Its trusted boundary is the stated exact finite arithmetic and the three
hash-pinned upstream certificates.

## ej closeout and mystery ledger

- **Settled — why 55 affine relabelings?** They are exactly the five nonsquare slopes times all
  11 translations, the affine slice of the nontrivial `PGL_2(11)/PSL_2(11)` coset. The full
  conjugating-relabeling torsor has 660 elements.
- **Settled — why does the central loop have zero index despite `-I`?** The full signed group
  stabilizes `ker(H)`, so the loop is constant after passing to the Lagrangian Grassmannian; the
  central sign belongs to the linear lift and is erased by this shadow.
- **Settled by ej — where does that sign remain visible?** Exactly in the `GL_6` frame holonomy
  `-I_6`; projective and determinant holonomies are both trivial.
- **Settled by ej2 — is the carrier outer bit the same `C2` as the central sign?** No. The signed
  normalizer quotient is central and maps trivially to `Out(Gamma)`, while row transport realizes
  the nontrivial outer class from outside that normalizer.
- **Settled — why is the shared hexad in the alternating radical?** Membership in both kernels
  forces `(H-H^T)s=0`; no extra coincidence is needed.
- **Retired by the Tao stress test — the second radical line.** Its frozen coset weights are
  `7,10,10` modulo `<s>`, but `omega` is not ambient-invariant and the entire Witt branch closes
  negative. No functorial statement makes this direction more than a coordinate-level artifact,
  so it is not handed to C502.

No genuine task-owned mystery remains.

## Successor consequence

C502 is unblocked, but its premise must be corrected before integration: the theorem-level bit is
the relative outer class of the two degree-11 carrier actions, with the common hexad as a canonical
witness; it is not a choice between the two 11-orbits on one carrier. The triple-index branch
closes negative: it has no connection to C472's central scalar through this canonical
odd-characteristic construction. The two-bit separation theorem is the correct integration
boundary: retain the outer carrier torsor and the central frame extension as distinct `C2`
objects.
