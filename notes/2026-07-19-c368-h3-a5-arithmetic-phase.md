# C368 — `H3/A5` arithmetic phase theorem

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; ONE INVARIANT CONIC, TWO ARITHMETIC PHASES; q=11 NON-GRS-TO-GRS DEEP-HOLE TRANSFORM`

## The theorem

Put

```text
O = Z[tau],                 tau^2-tau-1=0,
Q: X^2+Y^2+Z^2=0,
```

and let `X_P` be the reduction modulo an odd prime ideal `P` of the ordered six fivefold
points

```text
(0,1,1-tau), (0,1,tau-1),
(1,1-tau,0), (1,tau-1,0),
(1,0,-tau),  (1,0,tau).
```

Write `k=O/P`, `q=|k|`, let `H_P` have these six points as columns, and put

```text
C_P = ker(H_P) <= k^6.
```

Let `A_P` be the union of the fifteen joins of pairs in `X_P`, and let

```text
B_P = PG(2,k) \ A_P.
```

Finally, let `D_P` mean the dimension-three projective code whose generator columns are
representatives of `B_P`.  Thus `D_P` is C339's degree-one evaluation code on `B_P`; it is not
the kernel of a matrix with columns `B_P`.

Then the odd-prime reductions have the following exact phase diagram.

1. **Uniform lattice and parent code.** Every odd `P` preserves the full projectivized `H3`
   mirror lattice `6_5,10_3,15_2` and its faithful projective `A5` action.  The set `X_P` is the
   transitive `A5/D5` six-arc, and `C_P` is an `[6,3,4]_q` MDS code.  The parent is GRS exactly in
   characteristic five.
2. **Characteristic five — source-conic phase.** At the ramified prime above five, `q=5` and
   `tau=3`.  The six source columns are exactly `Q(F_5)`, so `C_P` is GRS.  Their fifteen secants
   cover `PG(2,5)`, hence `B_P` is empty.
3. **Characteristic three — empty non-GRS phase.** The rational prime three is inert, so `q=9`.
   The parent is non-GRS, but again `B_P` is empty.  This is the second root of the complement
   count `(q-5)(q-9)` and is not a conic phase.
4. **Characteristic eleven — deep-hole-conic phase.** The rational prime eleven splits, with
   `tau=4` and `tau=8`.  For both fibres the parent is non-GRS and

   ```text
   B_P = Q(F_11).
   ```

   This twelve-point conic is the complete projective locus of syndromes of minimum spanning
   weight three for `C_P`.  Consequently `D_P` is a projective, or extended, GRS
   `[12,3,10]_11` code.  In the manuscript fibre `tau=8`, the exact projectivity

   ```text
   T = [[2,3,8],
        [10,6,9],
        [2,2,5]]
   ```

   sends `X_P` to the displayed Clebsch parity-check columns and sends `Q` to the manuscript
   conic `XZ=Y^2`.  The 120 nonzero scalar lifts of `B_P` are exactly C341's
   `deep_hole_C5` relation inside the symmetric rank-eight translation association scheme with
   valencies

   ```text
   1, 60, 100, 120, 150, 300, 300, 300.
   ```

5. **Every remaining odd prime — stable recovery phase.** If the rational prime below `P` is not
   `3,5,11`, then `q>=19`; in particular `q>14`.  The parent is non-GRS,

   ```text
   |B_P| = (q-5)(q-9),
   D_P has parameters [(q-5)(q-9), 3, (q-6)(q-9)]_q,
   ```

   and C339's six-class line spectrum gives its complete weight enumerator.  From the unmarked
   projective system of `D_P`, the fifteen disjoint lines recover the mirror arrangement, its six
   fivefold points recover `X_P`, and hence `C_P` is recovered up to projective/monomial
   equivalence.

The new combined corollary is therefore a genuine transform statement, not parallel exposition:

```text
q=5:   Q is the six-column source orbit       -> GRS parent, no deep holes;
q=11:  Q is the twelve-direction deep locus  -> non-GRS parent, GRS deep-hole child;
q>14:  the larger deep locus recovers the non-GRS parent intrinsically.
```

The same integral invariant quadratic form changes role between the two exceptional residue
characteristics.

## Proof and compatibility maps

C346 proves that `(2)` is the unique bad mirror-lattice prime, supplies the faithful `A5` action at
every odd prime, and gives the split/ramified/inert residue fields.  Its field classification also
shows that the only odd-prime residue sizes below the stable range are `9`, `5`, and `11`; all
others have `q>=19`.

C341 proves integrally that all twenty three-column minors have norm `+/-4`, so `X_P` is a six-arc
at every odd prime.  Its quadratic evaluation determinant

```text
16(3*tau-4),                norm -2^8*5,
```

vanishes at exactly the prime above five.  At that prime direct substitution gives
`X_P=Q(F_5)`.  Since a nonsingular conic over `F_5` has six points, this is equality rather than
mere containment.  The standard conic--projective-GRS dictionary then gives the parent GRS phase.

C339 identifies the fifteen secants of `X_P` with the reduced mirrors and proves
`|B_P|=(q-5)(q-9)`.  A projective syndrome outside their union is in the span of no one or two
columns.  Every three columns of `H_P` form a basis of `k^3`, so every such syndrome has spanning
weight at most three.  Thus `B_P` is exactly the complete projective weight-three syndrome locus,
with no decoder convention left implicit.

At q=11, the compatibility certificate constructs all 133 projective points twice: as the
complement of the fifteen secants for each root `tau=4,8`, and as the zero set of `Q`.  The two
sets agree exactly and contain twelve points.  It also applies `T` in the `tau=8` fibre and checks
set equality with `XZ=Y^2` in the manuscript coordinates.  A line meets this nonsingular conic in
at most two points, so the generator-column code `D_P` has

```text
n=12, k=3, d=12-2=10.
```

Because the projective system is the full `F_11`-point set of a conic, this is the length-`q+1`
extended/projective GRS convention.  This fixes the possible ambiguity between a generator-column
child `[12,3,10]` and the unrelated kernel code `[12,9,4]`.

For `q>14`, C339 proves that every nonmirror line meets `B_P`, so the lines disjoint from the
unmarked child system are precisely the fifteen mirrors.  That is the exact implication that
turns the phase diagram into a recovery theorem.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-19-c368-h3-a5-arithmetic-phase.py --check
sha256sum -c notes/2026-07-19-c368-h3-a5-arithmetic-phase.sha256
```

The standard-library checker uses prime-field arithmetic only.  It enumerates all 31 points and
31 lines at q=5 and all 133 points and 133 lines at q=11.  It checks all 20 source triples at q=5,
all 220 child triples at q=11, both q=11 roots, both sets of fifteen secants, the exact conic-set
equalities, the parent quadratic determinants `0` at q=5 and `7,1` for `tau=4,8` at q=11, and the
child maximum line intersection two.

The independent invariant check inside the certificate compares two definitions of the q=11
locus: direct secant-complement incidence and direct quadratic-zero enumeration.  In the `tau=8`
fibre it adds a third coordinate check by mapping both the source and complement through `T`.
C339, C341, and C346 retain their own independent symbolic/finite-field replays for the source
theorems.  The trusted boundary here is Python 3 integer arithmetic, the short checker, those three
source theorem bundles, and the standard conic--GRS dictionary.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 8,280 | `3c5d03e3538a5b75d5706d3a51924dadc70957268bdc5ccaeaa5025bcbe94905` |
| certificate `.json` | 4,176 | `e4d8e97210df22498401ae2ea0dbe3b816a7fcbdf31f4d36d659680730e7019e` |

The certificate does not recompute C341's 512 intersection numbers or prove separability of the
rank-eight scheme.  It checks the exact projective compatibility needed to attach C341's already
certified `deep_hole_C5` relation to the conic child.

## Literature and claim boundary

C368 performed no new external literature search and makes no universal novelty or priority
claim.  It consumes the exact local theorem records C211, C339, C341, C346, and the bounded C371
audit.  C371 reports zero external papers read in full, explicitly treats the characteristic-five
Clebsch conic and the `PSL_2(5)`/Veronese explanation as classical, and leaves catalogue identity
and separability of the rank-eight scheme open.  The claim made here is only that the cited local
theorems, after the displayed coordinate compatibility is proved, imply the single arithmetic
phase theorem and the non-GRS-parent/deep-hole-conic/GRS-child corollary.

In particular, this report does not claim a new conic, a new arc--MDS or conic--GRS dictionary, a
new association scheme, or a new AME class.  Nor does it identify the two conic roles through an
exact sequence of codes: “child” means the projective deep-hole transform `B_P -> D_P` defined
above.

## Source theorem hand-back

- C346 continues to own good reduction and residue-field descent.
- C341 continues to own the parent GRS boundary and rank-eight q=11 scheme.
- C339 continues to own the complement line spectrum, transform parameters, and stable inverse.
- C211 and the Clebsch paper remain read-only owners of the manuscript-coordinate conic theorem.
- The `tau=4` conic equality is certified here, but C341's exact intersection tensor was computed
  in the manuscript `tau=8` normalization; this report does not silently relabel that tensor as a
  second independent computation.
