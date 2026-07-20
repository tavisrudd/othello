# C406 Gate 1 — Coxeter matching-orbit scout

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `GATE 1 PASSES; UNIFORM 5/14/22 MATCHING INTERFACE, CLASSICAL ORBIT ALONE, MODULE UNDECIDED`

## Result

At the three C399 conic phases, let `G=PGL_2(q)` act on the perfect matchings of
`P^1(F_q)`, and let `H` be the projective Coxeter parent (`S4,S4,A5`).  Exact canonical
enumeration gives:

| type | `q` | matchings | complete `(orbit size, stabilizer order)` distribution |
|:---|---:|---:|:---|
| `A3` | 5 | 15 | `(5,24), (10,12)` |
| `B3` | 7 | 105 | `(14,24), (21,16), (28,12), (42,8)` |
| `H3` | 11 | 10,395 | `(22,60)` once; `(55,24)` twice; `(66,20)` once; `(110,12)` three times; `(132,10)` once; `(165,8)` three times; `(220,6)` three times; `(330,4)` eight times; `(660,2)` nine times |

In every type there is exactly one `H`-invariant perfect matching:

```text
A3:  (0,5) (1,4) (2,3)
B3:  (0,2) (1,4) (3,7) (5,6)
H3:  (0,1) (2,5) (3,7) (4,9) (6,8) (10,11).
```

The indices use the certificate's canonical conic parameterization.  These are respectively the
complementary-edge pairing in the tetrahedral six-point action, the antipodal pairing in the
octahedral/cubic eight-point action, and the antipodal pairing in the icosahedral twelve-point
action.  The H3 matching agrees exactly with C379's frozen `tau=8` obstruction matching.

The target matching stabilizer and the parent subgroup normalizer are equal, not merely
isomorphic:

```text
Stab_G(M_H) = N_G(H) = H.
```

Consequently conjugation gives an equivariant bijection

```text
{conjugate Coxeter parent subgroups}  <->  G orbit of M_H,
                  H^g                |->  M_H^g,
```

of sizes `5,14,22`.  Thus the matching orbit by itself is exactly the already-classical homogeneous
marker space `G/H` with its points renamed.  The child conic alone does not select a matching; the
unique matching appears only after the parent subgroup has been supplied.

This nevertheless passes Gate 1's uniform-interface requirement: all three parent actions select
their matching by the same intrinsic fixed-block predicate, and the H3 member agrees with the frozen
C379 construction.  The orbit calculation does **not** decide the stronger C403 question.  The
perfect-matching augmentation kernel restricted to `S4,S4,A5` is semisimple because
`5,7,11` do not divide the respective parent orders; a genuine parent or H3 sheet-sign constituent
can therefore survive even though the orbit set itself is classical.  Character decomposition by
fixed-matching counts belongs to Gate 2 and was not run under the user's Gate-1-only scope.

## Factorization replay

For the standard endpoints

```text
(1,a), a in F_q, together with (0,1),
```

the checker evaluates every perfect-matching secant product.  All `15+105+10,395=10,515`
products restrict exactly, with the canonical scaling rather than merely projectively, to

```text
s^q t - s t^q.
```

This independently reconfirms the C403 full-boundary factorization identity on the three Gate-1
matching sets.  It does not create a new factorization-memory invariant: the common section forgets
every matching, while the distinguished matching orbit is recovered only from the supplied parent
subgroup.

## Gate disposition and ownership boundary

C406 remains open after Gate 1.  Edge and Dye already own the `5,14,22` marker spaces, their
`S4,S4,A5` stabilizers, transitivity, and substantial relation geometry.  The exact matching
calculation supplies the common interface needed to pose the restricted-module question, but the
orbit alone remains the same coset space.  Gate 2 is now mathematically authorized, but was not
executed.  No factorization-difference module, H3 sheet-sign/Fourier comparison, claim-specific new
literature audit, or Lean work was performed; Gates 3--6 remain gated.

This is a bounded Gate-1 compatibility result, not a flagship verdict.  It does not weaken C399's
uniform Coxeter-number distance/conic theorem, C403's general pairing-forgetting kernel, or C379's
Clebsch-specific root-resolution and matching-decorated recovery.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c406-matching-orbit-scout.py --check
python3 notes/2026-07-20-c406-matching-orbit-scout-replay.py
sha256sum -c notes/2026-07-20-c406-matching-orbit-scout.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c406-matching-orbit-scout.py --write
```

The primary checker imports the pinned C399 coordinate/group implementation and C379 H3 fixture,
then constructs every matching, every full `PGL_2(q)` orbit, exact stabilizers and normalizers,
the parent-subgroup/matching bijection, the frozen H3 comparison, and all canonical restricted
products.  The replay imports neither the primary checker nor those source implementations.  It
rebuilds the three Mobius permutation groups directly, re-enumerates the complete orbit
distributions, reconstructs each recorded stabilizer from the matching, verifies uniqueness of its
fixed matching, and derives the Frobenius form directly from the endpoint product.

The trusted boundary is finite exact arithmetic and the pinned source conventions.  The bundle
certifies the three stated finite actions and factorization identities.  It does not prove a new
literature theorem or compute the Gate-2 restricted matching modules.

Artifact hashes and byte counts are recorded in the adjacent checksum manifest; the JSON also pins
the exact C399 and C379 input hashes and byte counts.
