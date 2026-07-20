# C384 — bounded non-GRS `AME(6,11)` family classification

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; EXACT TWO-CLASS NON-GRS PENCIL, SEPARATED BY LC AND LU INVARIANTS`

## The theorem

For `t in F_11`, let `H_t` have the six ordered projective columns

```text
(0,1,1-t), (0,1,t-1),
(1,1-t,0), (1,t-1,0),
(1,0,-t),  (1,0,t),
```

put `C_t=ker(H_t)`, and, whenever `C_t` is `[6,3,4]_11`, define the equal-phase CSS state

```text
|Psi_t> = 11^(-3/2) sum_(c in C_t) |c>.
```

Then, allowing party permutations:

1. `H_t` is a six-arc exactly for

   ```text
   t in {2,3,4,6,7,8,10}.
   ```

   The four excluded parameters `0,1,5,9` have certified duplicate or collinear triples.
   For every admitted parameter, both `C_t` and `C_t^perp` have exact minimum distance four,
   so `|Psi_t>` is a minimal-support stabilizer `AME(6,11)` state.
2. The seven admitted parameters form exactly two projective/monomial classes:

   ```text
   A = {10},                  B = {2,3,4,6,7,8}.
   ```

   Class `B` is C374's Clebsch class (`t=8`), including its golden conjugate `t=4`.
   The certificate records, for every parameter, an explicit `3 x 3` row transformation,
   party permutation, and six nonzero column scalars carrying its presentation to the class
   representative.  An independent pairwise projectivity test reproduces the same partition.
3. Both classes are non-GRS.  After canonical frame normalization, the exact six-by-six conic
   evaluation determinants are respectively `1` and `4` in `F_11`, hence neither six-arc lies
   on a conic.
4. C374's 450-entry minimal-support holonomy multiset separates the classes under local Clifford
   equivalence.  Class `A` has fifteen occupied `(trace,determinant)` bins, including
   `(1,2)` with multiplicity `24`; class `B` has C374's five-bin signature, including
   `(1,10)` with multiplicity `120` and no `(1,2)` bin.  A direct six-dimensional Lagrangian
   replay agrees with the CSS shortening calculation.
5. More strongly, C374's arbitrary-local-unitary marginal moment separates the classes:

   | class | parameters | `11^-4` triples | `11^-6` triples |
   |:---|:---|---:|---:|
   | `A` | `{10}` | **66** | 389 |
   | `B` | `{2,3,4,6,7,8}` | **70** | 385 |

   Here the 455 entries are

   ```text
   Tr((rho_T tensor I)(rho_U tensor I)(rho_V tensor I))
   ```

   over unordered triples of four-party marginals.  Since this multiset is invariant under
   arbitrary party-local unitaries, the two monomial classes are LU-inequivalent.  Conversely,
   the explicit monomial maps within each row are local computational-basis unitaries.  Thus the
   seven equal-phase states in this finite pencil have **exactly two LU classes**.

This is a family-level classification only for the displayed finite equal-phase pencil.  It is not
a classification of arbitrary non-GRS `AME(6,11)` states or of phase deformations on the same
orthogonal-array support.

## Exact finite proof

The checker performs the following deterministic calculations over `F_11`.

- It exhausts all eleven parameters, tests distinctness and all twenty three-column determinants,
  and records every failure triple for the four non-arcs.
- It canonicalizes each admitted six-arc by all `6P4=360` ordered projective frames.  Equality of
  canonical representatives gives the two monomial classes.  A second pairwise routine fixes one
  frame on the source and tests all 360 target frames, and agrees on every class pair.
- It computes the conic evaluation rank and determinant independently, then exhausts all
  `11^3-1=1330` nonzero coefficient vectors for the minimum distance of each class representative
  and its dual.
- It computes the holonomy signature first from the CSS code/dual shortenings and again directly
  from the six-dimensional stabilizer Lagrangian.
- It computes the 455 marginal moments as ranks of shortening coefficient spaces and independently
  as ranks of their embedded twelve-coordinate stabilizer labels.
- It hard-checks that the class containing `t=8` reproduces C374's exact five-bin holonomy signature
  and moment distribution `((4,70),(6,385))`.

The full canonical representatives, equivalence witnesses, failure triples, signatures, moments,
and collision buckets are in the JSON certificate.  Both the holonomy and moment bucket-size lists
are `[1,1]`; there are no collisions in the selected family.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-19-c384-clebsch-ame-family-classification.py --check
sha256sum -c notes/2026-07-19-c384-clebsch-ame-family-classification.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 20,179 | `14fcefef44a8a4dd1979a4c4a544de5eb7ca543dd58abfc046b38635d9aa2046` |
| certificate `.json` | 11,020 | `6f9eae589da917d51bab6129648c96c5e4d57995ac7b44bf1c68685e002ba2b0` |

The checker is standard-library-only and deterministic.  Its trusted boundary is Python 3 integer
arithmetic modulo 11, exact Gaussian elimination, exhaustive finite enumeration, the standard
arc--MDS and six-arc--conic/GRS dictionaries, and C374's proved stabilizer interpretations of the
two invariants.  The two independent replays share the field-arithmetic kernel but not the
shortening representation.

The certificate does not analyze non-stabilizer states, arbitrary coefficient phases, other local
dimensions, other six-arc families, or a continuous LU search.

## Primary-source closure and claim boundary

### Read-depth summary

C384 newly read **zero external papers in full** and **one external paper partially**.  It also
uses two external primary sources **secondarily only** through C374's same-day source audit.  No
novelty or priority claim is made, so C384 does not turn the exact finite theorem into an absence
claim and does not repeat C374's forward-citation search.

| source | read depth and exact access | boundary for C384 |
|:---|:---|:---|
| Ramadas--Lakshminarayan, *Local unitary equivalence of absolutely maximally entangled states constructed from orthogonal arrays* | **partial**: arXiv `2411.04096v1`; cached PDF/text key `arXiv:2411.04096`, SHA-256 `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647`; read the complete-invariant discussion at extracted lines 360--459, Theorem 1 discussion at 740--829, Corollary 2 at 1034--1053, and the `N=6` conclusion at 1195--1214 | Polynomial LU invariants and infinitely many LU classes of minimal-support `AME(6,d)` states are prior art.  This forces the finite equal-phase boundary: the two-value marginal moment is a separating invariant on this pencil, not a complete invariant for all AME states. |
| Raissi--Gogolin--Riera--Acin, *Constructing optimal quantum error correcting codes from absolute maximally entangled states* | **secondary only** through C374, which read arXiv `1701.03359v2` partially at Sections III and VI; cache key `arXiv:1701.03359`, SHA-256 `768f70614685a881ba7902428164fe9e2cf0e78be123cd344c6e838ac072e673` | Owns the MDS-to-minimal-support-AME and CSS stabilizer construction.  C384 claims no novelty for that bridge. |
| Burchardt--Raissi, *Stochastic Local Operations with Classical Communication of Absolutely Maximally Entangled States* | **secondary only** through C374, which read arXiv `2003.13639v1` partially at Sections III--IV and Appendix C opening; cache key `arXiv:2003.13639`, SHA-256 `7b38bd6a5bd8fb8299863e5ca3c7f64dfadd51a12f1b865edbbcbc3d4847a9e3` | Already pre-empts a generic multiple-class claim in bounded minimal-support regimes.  C384 contributes only the explicit exact two-class quotient and separator for the displayed pencil. |

C374's seven-source exact-object audit remains the authoritative coverage record for the Clebsch
state versus GRS presentations.  C384 does not claim that the holonomy construction or marginal
trace polynomial is a new general invariant, that ordinary orthogonal-array data classify LU
orbits, or that these two classes exhaust non-GRS `AME(6,11)` states.

## Ownership and hand-back

- C374 continues to own the invariant proofs and the Clebsch-versus-GRS classification.
- C384 owns only the displayed finite pencil, its exact two-class monomial quotient, and the
  family-level LC/LU separation.
- The general phase-family and arbitrary non-GRS classification problems remain deliberately open.
