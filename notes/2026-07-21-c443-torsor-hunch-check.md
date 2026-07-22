# C443 torsor-hunch check — Galois action on the four companions

**Lane:** `crowns` (exploratory memo, not an evidence bundle)

**Date:** 2026-07-21

**Executor:** exploratory sub-agent, Opus

## Verdicts

| # | Hypothesis | Verdict |
|:--|:--|:--|
| H1 | sigma stabilizes the golden 12-point configuration | **CONFIRMED up to a conic-preserving projectivity** (literal projective equality is FALSE — 0/12 — but the sigma-image is PGL(2)-equivalent to the original on the shared rational conic, with exactly 60 = \|A5\| correcting maps) |
| H2 | induced sigma-permutation of companions is a 4-cycle with square = kappa | **CONFIRMED** — sigma acts as the 4-cycle `(2,0,3,1)` = `(0 2 3 1)`, independent of the correcting map; its square is `(0 3)(1 2)` = kappa |
| H3 | companion→residue bijection is kappa- and sigma-equivariant | **CONFIRMED** — (a) kappa-pairs `{c0,c3},{c1,c2}` map onto residue pairs `{3,4},{5,9}`; (b) the bijection intertwines the sigma companion-4-cycle with the residue 4-cycle `z→z²`, up to a shared orientation (they are mutual inverses, the two square-roots of kappa) |
| H4 | pair-average degree-1 discrepancy = polar matching's degree-1 moment | **REFUTED (unrelated)** — the two kappa-pairs give the *same* support-3 discrepancy (not negatives); the polar matching's own degree-1 moment is unrelated (zero at π, support-9 at π̄) |

**Surprise worth flagging:** the torsor hunch is essentially correct. The Galois generator sigma acts as a single 4-cycle on the four companions whose square is complex conjugation, and this 4-cycle is intertwined (up to orientation) with the arithmetic 4-cycle `z→z²` on the four primes above 11 via the companion→residue reduction bijection. C443's "four companions, kappa = (0 3)(1 2)" is exactly the shadow of a `Z/4`-Galois torsor structure. The obstruction is real but *equivariant*: it is not a defect of an arbitrary labeling.

## Setup and conventions (frozen, reused verbatim)

All objects come from `C461.finite_geometry()` (which rebuilds C443's frozen golden geometry) and the
C443/C461 helper functions — no new coordinates were invented.

- `sigma(v) = zauto(v, 2)` (zeta₅ → zeta₅²), `kappa(v) = zauto(v, 4)` (zeta₅ → zeta₅⁻¹). Note `sigma² = kappa` in `Gal(Q(zeta_5)/Q) ≅ Z/4`.
- Companion labeling is C443's canonical `matching_orbits` order, the one giving `kappa_candidate_permutation = (3,2,1,0) = (0 3)(1 2)` — verified identical to the JSON field.
- The 12 golden vertices lie on the rational conic `q = 4(XZ − Y²)` (matrix `B` from C443); its coefficients are in Q, so sigma fixes the conic as a variety.

## H1 — Galois stability of the configuration

Applying sigma coordinate-wise to each of the 12 frozen vertices and normalizing projectively:

- **Literal equality: FALSE.** `sigma(pointset) == pointset` is false; **0 of 12** images coincide with an original vertex. This is expected: sigma moves `phi = 1+zeta+zeta⁴` to its conjugate `1−phi`, so the whole icosahedral frame moves.
- **Up to a projectivity the machinery provides: TRUE.** Every sigma-image still lies on the same rational conic (verified by exact round-trip through `B`∘Veronese). Searching PGL(2) on the conic parameter (using C443's `mat2`/`frame_to_standard` bridge machinery) for a Möbius map `g` with `g(orig params) = sigma-image params` yields **exactly 60 such maps** — i.e. the two configurations are projectively equivalent on the conic, and the correcting projectivity is well-defined up to the order-60 golden A5 normalizer.

So sigma stabilizes the configuration *as a projective conic point-set up to the A5-normalizer projectivity*. The torsor hypothesis survives step one. (It fails only the strictest reading — sigma is not a literal permutation of the frozen representatives, because unlike kappa it does not fix `phi`.)

## H2 — induced permutation of the companions

Correcting sigma by any of the 60 maps `g` gives a vertex permutation `tau = g⁻¹∘sigma` of the 12 vertices
(example: `tau = (0,4,1,10,9,7,8,5,3,2,6,11)`). Its induced action on the four companion A5-orbits is

```
sigma_companion_permutation = (2, 0, 3, 1)     # 0→2, 1→0, 2→3, 3→1, i.e. cycle (0 2 3 1)
```

This is **the same for all 60 correcting maps** (they differ by A5 elements, which fix each companion
setwise), so it is canonical. It is a **single 4-cycle**, and

```
sigma_companion_permutation² = (3, 2, 1, 0) = (0 3)(1 2) = kappa_companion_permutation.
```

Both properties CONFIRMED: 4-cycle, square = kappa.

## H3 — equivariance with the primes above 11

Companion→residue bijection (which residue each companion hits a frozen C406 sheet at), read from the
C443 reduction table / JSON:

| companion | residue (zeta mod 11) | frozen sheet | golden prime |
|:--|:--|:--|:--|
| c0 | 4 | base | π  (phi ≡ 8) |
| c1 | 5 | outer | π̄ (phi ≡ 4) |
| c2 | 9 | outer | π̄ |
| c3 | 3 | base | π  |

- **(a) kappa-pairing:** kappa-pairs of companions are `{c0,c3}` and `{c1,c2}`; under the bijection they map to `{4,3}={3,4}` and `{5,9}` — exactly the residue kappa-pairs (`z→z⁻¹`: 3·4≡1, 5·9≡1 mod 11). CONFIRMED.
- **(b) sigma-intertwining:** residue 4-cycle `z→z²` (3→9→4→5→3) induces, via the bijection, the companion permutation `(1,3,0,2) = (0 1 3 2)`. The sigma companion permutation from H2 is `(2,0,3,1) = (0 2 3 1)`. These are **mutual inverses** — the two square-roots of the common involution `(0 3)(1 2)`. So the bijection intertwines the Galois action on companions with the arithmetic `z→z²` action up to orientation (the direction is fixed by an arbitrary choice of `g` vs `g⁻¹` in correcting sigma). Internally consistent: on residues `(z→z²)² = z→z⁴ = z→z⁻¹ = kappa`. CONFIRMED (up to orientation).

## H4 — identity of the degree-1 obstruction vector

Frozen 15-coordinate F₁₁ quotient basis (`Sym¹` of C406's rank-4 conic quotient), C443 `finite_moment` machinery.

- **C406 target (base − outer) degree-1 moment:** the zero vector (support 0) — reproduced.
- **Pair-average degree-1 discrepancy** `mu_at_pi = avg@zeta3 − avg@zeta9`:

  ```
  [0, 0, 0, 0, 2, 0, 0, 7, 0, 2, 0, 0, 0, 0, 0]     support 3 at coords {4, 7, 9}
  ```

  sha256 `5369f349…` — **matches the C443 JSON `mu_at_pi_sha256` exactly**. **Both** kappa-pairs `{c0,c3}` and `{c1,c2}` give the **identical** vector (equal — *not* negatives, *not* distinct sigma-images).

- **Polar (A5-fixed) matching's own degree-1 moment**, same frozen basis:
  - at zeta = 3, 4 (prime π): the **zero** vector (support 0);
  - at zeta = 5, 9 (prime π̄): `[2,0,5,0,4,10,0,7,0,9,0,5,10,0,2]` (support 9).
  - Its golden-odd difference `D − sigma(D) = m1@3 − m1@9` therefore has **support 9**.

**Comparison:** the support-3 companion discrepancy (`{4,7,9}`) and the polar matching's degree-1 moment
are **unrelated** — not equal, not proportional mod 11, and supported on disjoint-in-character sets
(the polar moment is *zero* precisely at the π frame where the discrepancy is nonzero, and has support 9
at π̄). The degree-1 obstruction is an intrinsic property of the companion family, not a shadow of the
polar matching. REFUTED as an identity; the relationship is "unrelated."

## Commands

From `/home/tavis/src/othello` (uv provides no extra deps; stdlib exact rationals + F₁₁ only):

```bash
uv run python3 <scratch>/torsor_check.py     # H1 literal, H3(a), H4
uv run python3 <scratch>/torsor_h1b.py       # H1 fallback (Mobius search), H2, H3(b)
```

Scratch scripts:
`/tmp/claude-1000/-home-tavis-src-othello-rust/146b5f8f-d308-4e66-aaf6-b97f7b3d7b12/scratchpad/torsor_check.py`
and `…/torsor_h1b.py`. All arithmetic exact (cyclotomic integers `Z[zeta_5]`, rationals, `F_11`); no
floating point. Every number above is a direct computation, cross-checked against the C443 JSON where the
JSON records it (companion labeling, kappa permutation, companion→residue table, degree-1 discrepancy
sha256).

## Reading

C443/C461 proved a *negative* (no single companion / no linear weighting descends). This memo shows the
four companions carry a clean `Z/4` Galois-torsor structure over the four primes above 11: sigma permutes
them in a 4-cycle intertwined with `Frobenius z→z²`, squaring to complex conjugation. The lower-moment
obstruction is `Gal`-equivariant and identical on both conjugate pairs — so it is a genuine invariant of
the torsor, not an artifact of labeling. A future abstract lift (the "nonuniform intrinsic weight line" of
C443/C461) would need to respect this `Z/4`-action; the memo makes the symmetry it must satisfy explicit.
It does **not** revive the secant-product construction — H4 confirms the degree-1 kernel obstruction stands.
