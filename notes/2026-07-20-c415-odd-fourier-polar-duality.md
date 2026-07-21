# C415 — the odd Fourier images are the polar zero-depth profiles

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; THE ODD FOURIER IMAGE OF THE DEPTH PROFILE IS THE SIGNED POLAR
ZERO-DEPTH PROFILE; THE ODD BLOCK IS q TIMES THE TRANSPOSE OF AN INTEGRAL INCIDENCE
SQUARE ROOT OF q; EXACT POLE/DEEP-POINT DUAL FACTORIZATION; UNIFORM OVER H3 AND BOTH
B3 SEAMS`

## Statement

Fix one of the frozen configurations: H3 at `q=11` with the scalar-`A4` common group and
the golden involution `J`, or a B3 seam at `q=7` (either `S3` or `D8` type) with its
determinant-one seam lift and any of its four involutive pair exchanges.  Let
`(O_{l_1},O_{r_1}),...,(O_{l_4},O_{r_4})` be the four exchange-paired projective point
orbits, `Z(M)` the zero-depth locus of a matching `M` (the union of its `(q+1)/2` secant
lines), and

```text
D_i(M) = #(Z(M) cap O_{l_i}) - #(Z(M) cap O_{r_i})            (depth profile)
S_i(M) = sum_{y in O_{l_i}} #(Z(M) cap y^perp)
       - sum_{y in O_{r_i}} #(Z(M) cap y^perp)                (polar profile)
```

with `y^perp` the polar line of `y` under the invariant-conic polarity.  Let `M_odd` be
the ordinary odd Fourier block of the `qz-ell` rule, `(M_odd)_{ij} =
E[l_i][l_j] - E[l_i][r_j]` with `E[r][s] = q z(r,s) - n_s`.  Then:

1. **Integral square root.**  `M_odd = q N^T`, where
   `N_{ij} = z(l_j, l_i) - z(l_j, r_i)` is the signed perpendicular-incidence matrix
   between the odd orbit pairs, and `N^2 = q I_4` (hence `M_odd^2 = q^3 I_4`).
2. **Polar duality.**  `N D(M) = S(M)` for every matching, equivalently
   `M_odd^T D(M) = q S(M)`, and inversely `M_odd^T S(M) = q^2 D(M)`.
3. **Dual factorization.**  Pointwise,
   `#(Z(M) cap y^perp) = (q+1)/2 + q * #{secants of M with pole y} -
   sum_{z deep} (depth(z)-1) [y in z^perp]`, so
   `S_i(M) = q * Pole_i(M) - Deep_i(M)`: the transform is carried exactly by the six
   (respectively four) **secant poles** — the dual matching points, the
   tangent-tangent intersections of the matched conic pairs — and by the polars of the
   deep (crossing) points weighted by `depth - 1`.  Combining,
   `M_odd^T D(M) = q^2 Pole(M) - q Deep(M)`.

The proof is three elementary steps and contains no matrix mystery: (a) double counting
`sum_{y in O_s} #(Z cap y^perp) = sum_{s'} c_{s'} z(s', s)` (Radon adjointness of the
perpendicularity correspondence); (b) the function `s -> z(s, l_i) - z(s, r_i)` is
`J`-odd because the exchange is orthogonal, so only the odd part of the zero-count
vector survives the pairing; (c) the `-n_s` terms of the `qz-ell` rule cancel on odd
pairs since exchange-paired orbits have equal sizes.  `N^2 = q I` is the restriction of
radial Fourier inversion `E^2 = q^3 I` to the odd sector, divided by the certified
divisibility `M_odd = q N^T`.  This resolves the C414 preflight's open question 6: the
geometric shadow of the odd transform is zero-divisor (polarity) incidence followed by
common-subgroup radialization, exactly the leading candidate, in fully signed and exact
form.

## Certified data

Primary checker and independent replay are committed adjacent to this report; every
claim below is asserted, not sampled.

**H3, q=11.**  All 22 matchings.  Odd relation pairs `(1,10),(3,13),(6,14),(9,11)` with
projective sizes `6,6,12,12`; `M_odd` recomputed from raw incidence equals the frozen
C378 block; `N = [[-1,0,2,-1],[0,-1,1,2],[4,2,1,0],[-2,4,0,1]]`, `N^2 = 11 I`.  Every
zero locus has exactly 57 points and every matching has exactly 15 simple crossings (no
three secants are ever concurrent, uniformly over all 22 matchings).  The six depth
profiles map bijectively onto six polar profiles:

| `D(M)` | `S(M) = N D(M)` | `Pole(M)` | `Deep(M)` |
|---|---|---|---|
| `(-6, 0, 12,-12)` | `( 42,-12,-12,  0)` | `( 6, 0, 0, 0)` | `( 24, 12, 12, 0)` |
| `(-3, 2,  2,  0)` | `(  7,  0, -6, 14)` | `( 1, 0, 0, 2)` | `(  4,  0,  6, 8)` |
| `(-3, 3,  0,  3)` | `(  0,  3, -6, 21)` | `( 0, 0, 0, 3)` | `(  0, -3,  6,12)` |
| and the three `J`-negatives | | | |

**B3, q=7.**  All 7 seams (4 of type `S3`, 3 of type `D8`), all 4 pair exchanges each,
all 14 matchings: `N^2 = 7 I`, `N D = S`, `S = 7 Pole - Deep`, and exchange
antisymmetry `D(tM) = -D(M)`, `S(tM) = -S(M)` hold throughout.  Within each seam the
entire profile table is identical across all four involutive pair exchanges, so the
ordinary depth/polar statistics are pair-exchange independent (preflight question 5 is
resolved for the untwisted block: the four exchanges differ only by common-seam
elements, which act trivially on seam orbits).

**A3, q=5.**  The `S4` parent meets the outer determinant coset, there is no two-sheet
exchange and no odd orbit pair; the duality statement is vacuous and A3 remains the
nonsplitting control.

## Structural consequences

1. **The depth shadow and its dual span the whole odd sector.**  Mod 11 the depth
   profiles span the plane `{2a+2b+c=0, 9a+8b+d=0}` (C411) while the polar profiles
   span the different plane `{4a+2b+c=0, 9a+4b+d=0}`; jointly they have rank 4.  The
   same joint rank 4 holds on every B3 seam.  So the moving pair `(D(M), S(M))`
   integrally generates the entire four-dimensional odd Fourier block: C414's rank-two
   "linear section shadow" plus its canonical `N`-image is a complete coordinate system
   for the exceptional sector.  This gives C416 a concrete new constraint: any
   section-level Fourier line must be compatible with the `(D, S)` basis, not just with
   the 16-dimensional local Hom space.
2. **Divided-power/radical-socle degeneration.**  `N` is integral with `N^2 = q I`, so
   the odd profile lattice is a module over `Z[N] = Z[sqrt(q)]`.  Mod `q`, `N` becomes
   square-zero with image the polar plane: `N` maps (full odd space) -> (polar plane)
   -> 0.  This is precisely the shape of C412's divided transfer `B^2 = 11B` becoming
   square-zero mod 11, now realized inside the ordinary Fourier block itself: the polar
   plane is the mod-`q` socle of the odd sector and the depth plane is a complement of
   it.  The C417 Rees/filtered-lattice comparison should treat `N` as the integral
   filtration operator; the `8/9` question becomes whether the C412 boundary map is the
   associated graded of this `N`.
3. **The odd pair `(1,10)` is intrinsically a pole locus.**  For the singleton (base)
   matching all six secant poles are exactly the six points of relation `O_1`; its
   golden mate's poles are `O_10`.  The first odd coordinate is thus the
   dual-matching/pole coordinate, which explains why the cubic-first witness lives in
   coordinate one (C411): it is the coordinate where the pole term `q Pole_1` is
   maximally concentrated.
4. **The golden mate is arithmetic, not combinatorial.**  In `PGL_2(11)`, exactly five
   minus-sheet matchings meet the base `A5` stabilizer in an order-12 subgroup, and all
   five intersections are `A4`s with identical orbit structure `1,1,4,4,6,6` on the 22
   matchings.  Only the frozen golden map `J` selects the true mate.  This is an
   independent confirmation of C413's theorem that the bare combinatorics recovers only
   an unordered structure, met here concretely while building the replay.

## Stop-rule compliance

The task's stop rule excludes "merely the matrix product already certified by C378" and
cyclotomic numerical fitting.  Neither occurs: `S(M)`, `Pole(M)`, and `Deep(M)` are
computed directly from the configuration geometry (polar-line intersection counts, conic
poles, crossing points) with no reference to the Fourier matrix, and the agreement with
all four transformed coordinates is proved from the `qz-ell` rule by double counting.
All computation is integer arithmetic in the prime fields; no cyclotomic embedding is
used anywhere in this bundle.

## Literature boundary

The adjointness core — pushforward/pullback duality for the point-line (here
point-polar) incidence correspondence over a finite field, and eigenmatrix/Delsarte
duality for translation schemes — is classical, and this report claims no novelty for
it.  Bounded coverage for this task's specific claims:

- Feldman--Grinberg, *Admissible Complexes for the Projective X-Ray Transform over a
  Finite Field* (arXiv:1707.06695): **partial** (abstract and introduction through the
  double-fibration/Bolker setup, read during the C414 preflight).  Supplies the finite
  Radon comparison category; does not treat signed orbit profiles, matching
  configurations, or an integral square root of `q` on an odd sector.
- *Finite Geometry and the Radon Transform* (arXiv:1111.4628): **search-result/metadata
  depth only** in this pass; records the classical adjoint and the rank-one-perturbation
  composition on finite planes, i.e. the unsigned ambient version of step (a).
- Godsil, *Association Schemes* notes, and standard Delsarte references:
  **metadata/background**; eigenmatrix duality is classical, and no source located in
  this bounded pass states the odd-sector divisibility `M_odd = q N^T` with `N^2 = q I`
  or a depth/polar profile exchange on matching configurations.
- Two targeted web searches (finite projective Radon adjoint with group orbits/signed
  data; association-scheme eigenmatrix integral square roots on odd involution sectors)
  returned only the classical background above.

MathSciNet, zbMATH, Google Scholar, and the forward-citation graphs were **not**
searched in this pass.  Accordingly this report supports only bounded likely-new
wording for the composition (matching depth profile, polar dual profile, integral
`sqrt(q)`, pole/deep factorization, B3/H3 uniformity, mod-`q` socle filtration) and
makes no priority claim.  The C406 baseline audit's coverage and gaps carry over
unchanged.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13:

```bash
python3 notes/2026-07-20-c415-odd-fourier-polar-duality.py --check
python3 notes/2026-07-20-c415-odd-fourier-polar-duality-replay.py
sha256sum -c notes/2026-07-20-c415-odd-fourier-polar-duality.sha256
```

Regeneration is `--write` on the primary checker.

| artifact | bytes | SHA-256 |
|---|---:|---|
| primary checker `.py` | 27,963 | `a5f773f10a6090ce7e582a65b2d2da92eafafdf27473b041182381208dae2190` |
| independent replay `.py` | 22,509 | `cd6a3a748579b816aae20bb14a5e8b568e101d8a5d530cc08018a445e7b10247` |
| certificate `.json` | 162,676 | `d0648c94b662e3ab9e565be439ea6d57c0e985097524c77d65dbb32b1272f475` |

Trusted inputs (hash-pinned in both scripts): the C341 checker, the C406 matching
module and certificate, the C406 orbit scout, the C411 certificate, and the C378
certificate.  The replay is independent in construction: it works natively in the
standard Veronese frame, rebuilds every group element as a 2x2 homography from its
parameter permutation and lifts by the symmetric square (no `frame_map` reuse), uses
the Veronese conic polar form `2yy' - xz' - zx'` for perpendicularity, computes poles
through the inverse polar Gram matrix, and evaluates the transform side through odd
differences of the full eigenmatrix image of the zero-count vector rather than through
`N`.  The golden mate is selected by the frozen C378 golden map, the only arithmetic
input (see consequence 4).

**What this bundle does not certify:** any twisted weight-`4/6` (or `2/4`)
section-level Fourier identity (C416), a B3 seam selector, the modular
filtered-lattice comparison and the `8/9` extension class (C417), separability of the
rank-16 scheme, or novelty beyond the bounded coverage stated above.
