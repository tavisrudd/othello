# C416 — twisted Fourier: pole-delta diagonalization and the power-sum intertwiner

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; TWISTED FOURIER DIAGONALIZES LINE SECTIONS INTO GAUSS-FREE q^2
POLE DELTAS; THE MATCHING POWER-SUM SECTION MAPS EXACTLY TO THE DUAL-MATCHING
POLE-DELTA MEASURE; THE MULTIPLICATIVE SECTION IDENTITY FAILS SHARPLY AND ITS ODD
SYMMETRIZATION IS ZERO; MOVING-MATCHING EQUIVARIANCE ISOLATES THE FOURIER LINE ON THE
RANK-2 POWER-SUM PLANE WITH AN EXACT DEGENERACY LAW`

Interim research trail: `notes/2026-07-20-c416-twisted-fourier-interim.md`.

## Statements

Work over `q=11` (standard Veronese frame, conic `XZ-Y^2`, polar Gram pairing,
`chi` of order 10) and `q=7` (Coxeter frame, invariant conic `X^2+Y^2+Z^2`, dot
polarity, `chi` of order 6), with the projective twisted kernel
`(F_r f)(y) = sum_{<x,y> != 0} f(x) chi(<x,y>)^{-r}` on projective representative
points.  `F_r` maps scalar weight `r` to weight `-r`, pairing the quotient degree
`h-1` with the product degree `h+1` (weights `4/6` at q=11, `2/4` at q=7).

1. **Pole-delta lemma.**  For every projective line `ell` (tangents included) and
   every tested weight (`r = 4, 6` on all 133 lines and `r = 1` on all 66 secants at
   q=11; `r = 2, 4` on all 57 lines at q=7),

   ```text
   F_r((chi o ell)^r) = q^2 * delta^can_[pole(ell)],
   ```

   the canonically weighted twisted delta at the pole of `ell`, with **no Gauss-sum
   factor**.  Proof: pairing against the pole reproduces the line functional itself
   (`<x, pole(ell)> = ell(x)` up to the recorded pivot scalar), so the kernel column
   at the pole is the exact conjugate character and the sum counts the `q^2` points
   off the line; at any other target the sum is a multiplicative-character sum over
   the pencil fibres of `[ell(x) : <x,y>]` and vanishes by orthogonality.

2. **Power-sum intertwiner.**  For every matching `M` (all 22 at q=11, all 14 at
   q=7) and both factorization weights,

   ```text
   F_r( sum_k (chi o ell_k)^r ) = q^2 * sum_k delta^can_[pole_k],
   ```

   the twisted transform carries the secant **power-sum section** exactly to the
   **dual-matching pole-delta measure**.  This is a nonzero linear factorization
   intertwiner living at scalar weight `r != 0`; C406's central-character
   obstruction proves no such map exists in the ordinary weight-zero Bose--Mesner
   algebra, so this is precisely the object the C416 mandate asked for.  Composing
   with orbit radialization lands on C415's untwisted pole profile `Pole(M)`: the
   untwisted polar duality is the radial shadow of this section-level identity.

3. **Sharp multiplicative negative.**  For every golden pair (11 at q=11; each
   exchange pair on all seven q=7 seams), with `G_M = P_M - P_JM` (secant-product
   difference) and `F_M = G_M / Q` (conic quotient), the transforms `F_4(chi o F_M)`
   and `F_6(chi o G_M)` are **not** proportional to `chi o G_M` and `chi o F_M`
   respectively: the transform has full support 133 while the targets vanish on
   their zero loci (support statistics recorded per pair in the certificate).
   Stronger, and structurally decisive: the seam-symmetrized `J`-odd parts of the
   multiplicative sections `chi o F_M` **vanish identically** at both fields.  The
   preflight's matching-section conjecture (question 3) is thus false in its
   multiplicative form and true in the additive power-sum form: the twisted
   functional equation lives on power sums of secant characters, not on their
   products.

4. **Rank-2 planes and the isolation law.**  The symmetrized `J`-odd power-sum
   family spans a rank-2 plane in the certified four-dimensional odd block, and its
   pole-delta image spans a rank-2 plane — the exact twisted parallel of C415's
   rank-2 depth plane.  The moving-matching linear system `T p_M = lambda_M d_M`
   over the cyclotomic field has nullity exactly

   ```text
   1  +  #{M : odd section vanishes}  +  [nonzero sections span only 2 directions],
   ```

   verified on q=11 (nullity 1: no vanishing, 5 distinct directions) and on all
   7 x 4 q=7 seam/exchange choices (nullity 1 except two S3 seams: one with a
   vanishing section, nullity 2, and one with a vanishing section plus a
   two-direction family, nullity 3).  With three or more distinct directions and no
   vanishing, **moving-matching equivariance alone cuts the 16-dimensional local Hom
   space to the Fourier line** — the isolation mechanism the C414 preflight asked
   for, now with its exact failure boundary.  All quantities are identical across
   the four pair exchanges of every seam.

A3/q=5 remains the nonsplitting control: no determinant-sheet exchange exists, so
only the ambient lemma/intertwiner content survives there.

## Stop-rule compliance

The construction is not a standard induced-character block repackaging: it carries a
C406 reconstruction consequence (the dual matching, hence by C415/C379 the
matching-decorated parent data, is read off the transform of the power-sum section),
and its exact covariance lives over `Q(zeta_{q-1})` with no uncontrolled splitting
field — all computations are exact in `Z[x]/Phi_{q-1}` with rational linear algebra.

## Relation to the preflight questions

- Question 2 (local intertwiner uniqueness): resolved with an exact law — the
  moving-parent family is the missing constraint, and its failure modes are
  precisely vanishing sections and two-direction degeneracy.
- Question 3 (matching-section identity): resolved — false multiplicatively, true
  additively with the Gauss-free scalar `q^2`.
- Question 6 (odd Fourier geometry): the twisted refinement of C415's answer — the
  section-level carrier is the dual matching's poles.
- The `8/9`/modular question stays with C417; note that the power-sum/pole-delta
  planes give C417 a canonical integral lattice inside the twisted odd block, to
  compare against C415's `Z[sqrt(q)]` structure `N` on the untwisted profiles.

## Literature boundary

The affine statement underlying the lemma — the additive Fourier transform of a
multiplicative character composed with a linear form is a Gauss sum concentrated on
the dual line — is classical (the Kazhdan--Polishchuk Gauss-sum-identities circle,
read at abstract depth in the C414 preflight audit, is the closest named
neighborhood; general Gauss-sum/finite-Fourier background confirmed in a bounded web
pass this session).  This report claims no novelty for it.  The bounded pass located
no source stating the projectivized Gauss-free `q^2` normalization, the
matching/dual-matching power-sum intertwiner, its realization of the exceptional
`A4`-invariant `J`-odd blocks, the identical vanishing of the symmetrized odd
multiplicative sections, or the exact nullity law.  MathSciNet, zbMATH, Google
Scholar, and forward-citation graphs were not searched; only bounded likely-new
wording for the composition is supported, and no priority claim is made.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13:

```bash
python3 notes/2026-07-20-c416-twisted-power-sum-duality.py --check
python3 notes/2026-07-20-c416-twisted-power-sum-duality-replay.py
sha256sum -c notes/2026-07-20-c416-twisted-power-sum-duality.sha256
```

Regeneration is `--write` on the primary checker.

| artifact | bytes | SHA-256 |
|---|---:|---|
| primary checker `.py` | 36,072 | `b0d76e2dccb52a1232ae7d931fb606ad39a0016515776608051d5336e279f5fd` |
| independent replay `.py` | 31,854 | `b09838e3f57d00721631ac3abdcfb512e3a807aae8d363479f81940253f91fa4` |
| certificate `.json` | 82,167 | `48310ba843f6c236e416b9c51f8f50e5a94eb17b004f401905bf89c636833774` |

Trusted inputs (hash-pinned): the C341 checker, C406 matching module and
certificate, C406 orbit scout, and C378 certificate.  All cyclotomic arithmetic is
exact in `Z[x]/Phi_10` and `Z[x]/Phi_6`; span/direction/nullity computations use
exact `Q(zeta)` Gaussian elimination in the primary.  The replay is independent in
frame and method: q=11 is rebuilt in the H3 frame with dot polarity and the frozen
C378 reflection matrices (no `Sym^2` homographies), q=7 in the standard frame with
the polar Gram and native secant functionals, and all linear algebra is replayed
through modular embeddings of the cyclotomic ring at two primes per field (31/41 and
13/31), matching the primary's exact values; the modular replays are consistency
checks of the primary's exact upper bounds, as specialization can only lower rank.
The determinant-one normalization (unique cube root, `x -> x^3` bijective mod 11 and
the `SO_3` lift construction at q=7) removes the projective-lift scalar cocycle
exactly; group closure is asserted.

**What this bundle does not certify:** any spanning of the full four-dimensional odd
block by matching families (they span rank-2 planes), a B3 seam selector, the
modular/Rees lattice comparison and the `8/9` extension class (C417), or novelty
beyond the bounded coverage stated above.
