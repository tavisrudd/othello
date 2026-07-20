# C376 — Clebsch cubic blowdowns and code chirality

Date: 2026-07-19  
Lane: `crowns`  
Verdict: **THEOREM; DOOR I POSITIVE; BLOWDOWN EXCHANGE IS THE CODE OUTER CHARACTER**

## Theorem

Let `P=(P_0,...,P_5)` be the ordered q=11 Clebsch six-arc in the C373 `tau=8`
normalization, and let `S=Bl_P(P2)`.  Write `E_i` for the six exceptional curves and `Q_i` for
the strict transform of the conic through all `P_j` with `j != i`.

1. The anticanonical system embeds `S` as the Clebsch cubic surface.  Its 27 lines are exactly

   ```text
   E_i (6), L_ij (15), Q_i (6).
   ```

   Their exact q=11 incidence has 135 intersecting pairs, 45 tritangent triples, ten Eckardt
   triples, 72 sixers, and 36 double-sixes.  The ten Eckardt triples are all of matching type
   `L_ij,L_kl,L_mn`.  The two rows `(E_0,...,E_5)` and `(Q_0,...,Q_5)` form the distinguished
   `A5`-invariant double-six.
2. The net of quintics double at all six `P_i`, with divisor class

   ```text
   5H - 2(E_0+...+E_5),
   ```

   has dimension three and contracts the six `Q_i`.  Let `P'_i` be the image of `Q_i`, using the
   intrinsic double-six correspondence `E_i . Q_i = 0`.  Then `P'=(P'_0,...,P'_5)` is a six-arc.
3. The set of label permutations induced by projectivities `P -> P'` is **exactly** the 60-element
   outer coset in

   ```text
   N_S6(A5) = S5 = A5 disjoint-union outer.
   ```

   In particular the quintic passage from one blowdown row to the other exchanges C373's two
   ten-element `A5` orbits on three-subsets.
4. The second blowdown configuration `P'` is projectively equivalent to the golden-conjugate
   `tau=4` configuration.  The 60 label permutations `P' -> P_tau=4` are exactly `A5`, while the
   60 permutations `P_tau=8 -> P_tau=4` are exactly the outer coset.

Consequently the involution exchanging the two `A5`-equivariant blowdowns and the involution
exchanging the two code-chirality sheets realize the same quotient character

```text
S5 -> S5/A5 = C2.
```

This is the positive C373 gateway Door I compatibility theorem.

## What “the same chirality” means

The result proves equality of the two exchange characters and gives an explicit geometric path:

```text
first blowdown --quintic Cremona--> second blowdown
      |                                  |
   tau=8 code                    opposite code chirality
      |                                  |
      +-------- outer S5/A5 --------------+
```

It does **not** canonically name either unordered sheet `+` or `-`.  A two-element torsor has no
preferred element.  The invariant claim is that blowdown exchange acts nontrivially on exactly the
same `C2` quotient that exchanges C373's `10+10` triple orbits.  This is stronger than a numerical
`2=2` comparison and weaker than an unjustified choice of orientation.

## Exact construction

The ordered source points are

```text
(0,1,4), (0,1,7), (1,4,0), (1,7,0), (1,0,3), (1,0,8)
```

in normalized q=11 projective coordinates.  The checker verifies all 20 three-column determinants
are nonzero.  The conic through every five excludes the sixth, so the points are in the general
position needed for the degree-three del Pezzo blow-up.

The 21 degree-five monomials receive the 18 first-derivative constraints expressing a double point
at each `P_i`; the constraint matrix has rank 18.  Its three-dimensional kernel defines the second
contraction.  Direct evaluation on every rational point of each five-point conic is nonzero away
from the base points and constant projectively, producing

```text
P' = ((0,1,10), (0,1,1), (1,6,0), (1,5,0), (1,0,10), (1,0,1)).
```

The ten-dimensional vector space of plane cubics has six independent point conditions, leaving the
four-dimensional anticanonical system.  The checker constructs `E_i` from tangent directions at
the base points, `L_ij` from pair-lines, and `Q_i` from five-point conics.  It derives the unique
cubic equation of their anticanonical image, checks it at all constructed line points, and verifies
there is no q=11-rational singular point.  Geometric smoothness follows from the standard
general-position blow-up theorem, not from that rational-point check alone.

Projective equivalences are exhausted over all `6!` label permutations: four point images determine
the unique projectivity, and the remaining two are checked exactly.  Independently, the 60-element
source stabilizer and its 120-element normalizer in `S6` are exhausted.  Equality of the relevant
permutation sets, rather than equality of their orders, proves the inner/outer statements.

## Independent replay

The primary generator builds all polynomial systems and surface incidence from the C341 coordinates.
The independent replay does not import C341 or the primary generator.  It separately

- checks the rank-18 quintic double-point constraints and the supplied kernel basis;
- evaluates every non-base rational point of all six contracted conics;
- reconstructs projective frame maps and independently exhausts `S6`;
- verifies that the source-to-second equivalences equal `N_S6(A5) \ A5` as sets;
- verifies every supplied line lies on the cubic equation;
- rechecks rational smoothness, 135 intersections, 45 tritangents, ten Eckardt triples, 72 sixers,
  36 double-sixes, and the distinguished `E/Q` pair.

The replay therefore has a separate finite-field and projective-equivalence implementation.  It
shares only the committed JSON certificate.

## Reproduction and trusted boundary

From the repository root `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c376-clebsch-cubic-chirality.py --check
python3 notes/2026-07-19-c376-clebsch-cubic-chirality-replay.py
```

To regenerate the canonical JSON intentionally:

```bash
python3 notes/2026-07-19-c376-clebsch-cubic-chirality.py
```

Load-bearing artifacts before this report and checksum manifest were added:

| artifact | bytes | SHA-256 |
|---|---:|---|
| primary checker `.py` | 22,151 | `cea5dff8981529297eaafd1387e5fef2efcc2372e7856ccb6b2f7bf85a80a501` |
| independent replay `.py` | 9,519 | `901145a73474ad0d0c160e782fe348d460a77c8d1c447831a584a08c41eca66a` |
| canonical certificate `.json` | 18,584 | `6c997c30ff374dcb205a9800751d7e3a33147b8499e39891b01291ad64cfd972` |

The computation is exact over the prime field `F_11`, deterministic, and seed-free.  It proves the
q=11 compatibility theorem and does not by itself prove an integral, all-prime, or moduli-family
statement.  Door II must construct the golden integral descent datum and compare its specialization
with this outer character.

## Literature and claim boundary

Prokhorov, [*Icosahedron in birational geometry*](https://arxiv.org/abs/2411.15334), arXiv
`2411.15334v2`, was read at full-text depth for Section 3.1.3 and Section 3.2, plus the immediately
following Bring-curve context.  Cached PDF SHA-256:
`59ce9cc76cbc374371465a1c193140740dee3225fd2a65d8a83dc8d9517c8360` (28 pages; text extraction
18,430 words).  Section 3.2 explicitly states the six-long-diagonal blow-up model, the two
`A5`-equivariant contractions, their invariant double-six interpretation, and their exchange by
`S5 \ A5`.

The classical blow-up, 27-line, double-six, and quintic-Cremona infrastructure is not claimed new.
This task did not conduct MathSciNet, zbMATH, Google Scholar, or forward-citation closure, and it
does not yet claim priority for the code/scheme compatibility theorem.  The surviving candidate
contribution is the exact identification of the natural blowdown passage with C373's independently
reconstructed outer chirality character.

## Hand-back

Door I is positive.  The originally proposed Door II was:

1. lift the two blowdowns and quintic contraction over the golden integer ring;
2. compute the descent cocycle on the six points, Picard lattice, and double-six;
3. prove that its code/scheme action specializes to the q=11 outer coset certified here; and
4. verify the predicted inert-semilinear and ramified-characteristic-five behavior.

Subsequent disposition: C377 found the exact integral involution and specializations, but Benson
pre-empts the generic descent mechanism.  C378 then used the involution productively to complete
`A5` to `PGL_2(11)` and construct the rank-16 signed Fourier refinement.  C379 proves that the
undecorated q=11 transform terminates, while a canonical obstruction matching reverses it on a
22-parent locus; those matchings form two one-factorizations with eleven-point-biplane
cross-incidence.  C380 is now the remaining gateway task.
