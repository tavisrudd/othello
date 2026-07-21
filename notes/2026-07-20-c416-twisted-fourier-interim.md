# C416 — twisted Fourier sector: interim research state

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `IN PROGRESS — CENTRAL IDENTITY RESOLVED IN EXPLORATION; CERTIFICATE BUNDLE
NOT YET BUILT`

C415 (complete, committed at `0b256cd0`) is the input: `M_odd = q N^T`, `N^2 = q I`,
`N D(M) = S(M) = q Pole(M) - Deep(M)`.

## Exploration results at q=11 (exact, standard Veronese frame, verified this session)

Conventions: standard frame, conic `Q = XZ - Y^2`, polar Gram `G = [[0,0,1],[0,-2,0],
[1,0,0]]`, `chi` of order 10 with generator 2, cyclotomic arithmetic exact in
`Z[x]/Phi_10`, projective twisted kernel `(F_r f)(y) = sum_{<x,y> != 0} f(x)
chi(<x,y>)^{-r}` on the 133 representative points.  These are scratchpad-verified
exact computations, not yet a committed certificate.

1. **Pole-delta lemma (verified r=1,4,6; all six base secants; tangent lines too).**
   For a line `ell` with pole `a = G^{-1} ell`, the transform of the section
   `(chi o ell)^r` is `q^2` times the canonically weighted twisted delta at `[a]`
   (value `q^2 * chi^r(pivot)` at the normalized pole representative, zero
   everywhere else).  Proof shape: pairing against the pole recovers the line
   functional itself (`<x, G^{-1} ell> = ell(x)`), so the kernel column at the pole
   is the exact conjugate character and the sum is `#{[x]: ell(x) != 0} = q^2`;
   vanishing elsewhere is multiplicative-character orthogonality along the pencil
   through `[ell] cap [<.,y>]` fibres.  Tangent lines obey the same statement.

2. **Power-sum intertwiner (verified for all 22 matchings, r=4 and r=6).**
   `F_r( sum_k (chi o ell_k)^r ) = q^2 * sum_k delta^{can}_{[pole_k]}`: the twisted
   transform carries the matching's secant **power-sum section** exactly to the
   **dual-matching pole-delta measure**.  This is the twisted refinement of C415's
   untwisted pole theorem, and it is a nonzero linear factorization intertwiner that
   the weight-0 Bose--Mesner algebra cannot contain (C406's central-character
   obstruction) — the C416 mandate's object.

3. **Sharp negative (verified on the golden base pair).**  The multiplicative
   product/quotient sections do NOT satisfy the proportional functional equation:
   `F_4(chi o F_M)` vs `chi o G_M` has 127/133 cross-product defects and full
   support (133) while `chi o G_M` vanishes at 27 of those points; `F_6(chi o G_M)`
   vs `chi o F_M` fails similarly (121 defects).  Here `G_M = P_M - P_JM` (degree
   6) and `F_M = G_M / Q` (degree 4, via `quotient_by_conic`).  So the twisted
   functional equation lives on **additive** (power-sum) factorization data, not on
   the product sections; preflight question 3 is answered negatively in its naive
   form and positively in power-sum form.

4. **Weight parity note.**  Weights 4 and 6 are even, so the `+-I` lift cocycle is
   invisible and no determinant-one splitting subtlety enters (consistent with
   C414's "killed orbits: none" at 4/6).  `F_4` maps weight 4 to weight
   `-4 = 6 mod 10`, exactly pairing quotient-degree with product-degree sections.

## Open gates (next session)

- **Gate C (odd-block realization):** dimensions of the `A4`-invariant `J`-odd spans
  of the symmetrized power-sum family and pole-delta family inside the certified
  four-dimensional odd blocks.  The last scratch run failed an internal assertion
  that the symmetrized section is `K`-invariant — almost certainly a bug in the
  scratch group-action code (lift/inverse composition convention), not mathematics;
  rebuild the action as in the committed C415 replay (`Sym^2` homographies, pivot
  transport) and re-run.
- **Gate D (Fourier-line isolation):** solve the linear system `T p_M = lambda_M
  d_M` over `Q(zeta_10)` on the odd blocks; expected nullity 1, which would prove
  that moving-matching equivariance alone cuts the 16-dimensional local Hom space to
  the Fourier line — the isolation mechanism the C414 preflight asked for.  C415
  adds the compatible constraint that `(D, S)` spans the untwisted odd sector.
- **q=7 seams:** replicate lemma + intertwiner on both B3 seam types (weights 2/4,
  `chi` of order 6); expect uniformity as in C414/C415.
- **Certificate bundle:** primary checker + independent replay (different frame or
  loop order) + canonical JSON + sha256 + report, C415-style; then queue/archive
  transition.
- **Novelty gate:** Gauss/Jacobi-sum transforms of products of linear forms are
  classical territory (Stickelberger/Jacobi-sum land); the pole-delta lemma itself
  may well be known in some form — the audit must check finite Radon/Gauss-sum
  literature before any novelty wording.  The surviving candidate claim is the
  composition: power-sum/pole-delta intertwiner realizing the exceptional odd
  blocks, its agreement with the C415 untwisted pole profile, and the Hom-space
  isolation.

## Scratch artifacts

Exploration script: session scratchpad `c416_explore.py` (not committed; the
verified results above are reproducible from the descriptions and will be
re-derived by the certificate checker).  No repository state depends on the
scratchpad.
