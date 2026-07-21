# C415/C416 depth–Fourier — three pre-paper upgrades (scoping report)

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** scoping/analysis report only. No queue, handoff, or other-doc edits. No new C-ID allocated.
Cheap verifications below run against the pinned C415 certificate
(`2026-07-20-c415-odd-fourier-polar-duality.json`,
SHA-256 `d0648c94b662e3ab9e565be439ea6d57c0e985097524c77d65dbb32b1272f475`) and C416 certificate
(`2026-07-20-c416-twisted-power-sum-duality.json`); the theorem-level claims state the exact
certification method and cost, not a completed bundle.

## Purpose

Fable flagged three cheap, exposition-strengthening upgrades to the depth–Fourier section (the
C415/C416 material). Each is an "observation → clean statement" move that makes the eventual paper
section symmetric and self-contained. This report states each precisely, grounds it in what the
pinned certificates already establish, verifies the cheap halves, and gives the certification plan
for the remaining halves. None is a new crown; all are packaging.

Backbone facts confirmed cheaply from the pinned C415 cert (q=11, all 22 matchings):

```text
matchings compress each profile to rank 2:  depth, polar, pole, deep all have rank 2 over Q
the ambient odd sector is rank 4:           depth+polar = depth+pole = pole+deep = rank 4
every crossing is a simple double point:    deep_point_excess is all-ones on every matching
the untwisted duality is exact:             S = q·Pole − Deep on all 22 matchings; M_odd = q·N^T; N^2 = qI
```

---

## Upgrade 1 — the pair-product / Jacobi identity for deep points (makes `S = q·Pole − Deep` section-level and symmetric)

### Statement

C415 proves the profile identity `S(M) = q·Pole(M) − Deep(M)`, where `Pole(M)` is carried by the
**secant poles** (the dual matching, section-level: C416 shows the secant power-sum section
transforms to the dual-matching pole-delta measure) and `Deep(M)` is carried by the polars of the
**deep (crossing) points** weighted by `depth − 1`. The asymmetry is that `Pole` has a clean
section-level realization (C416's pole-delta lemma) while `Deep` is currently only a point-count.

**Upgrade:** give `Deep` the same section-level realization. Each deep point is the intersection of
two matched secant *pairs*; the deep-point contribution should be a **pair-product** section
`(χ∘ℓ_i)(χ∘ℓ_j)` (equivalently a Jacobi sum, being the additive Fourier of a product of two
multiplicative-character line sections), so that `S = q·Pole − Deep` becomes an identity of
**section-level twisted-Fourier objects** — pole-delta minus pair-product — rather than a
profile-level count. This makes the whole duality symmetric: `Pole` = single-secant power-sum →
pole-delta; `Deep` = secant-pair-product → Jacobi/pair-delta.

### What is already confirmed

- **Deep points are uniform simple crossings.** `deep_point_excess` is `[1,…,1]` (15 crossings, each
  a simple double point) on *every* matching. So `Deep` weights each crossing by `depth − 1 = 1`
  uniformly — the pair-product carries a constant weight, no higher-order tangency correction. This
  is exactly the hypothesis under which a clean Jacobi-sum identity closes.
- **`S = q·Pole − Deep` holds at profile level** for all 22 matchings (verified).
- **The single-secant → pole-delta half is done** (C416 pole-delta lemma: `F_r((χ∘ℓ)^r)=q²δ_pole`).

### Mechanism / why it should close

A deep point `y = ℓ_i ∩ ℓ_j` is the pole-analogue of a *pair* of secants. The additive Fourier of
the pair section `(χ∘ℓ_i)(χ∘ℓ_j)` is, by the same pencil-orthogonality argument as C416's pole-delta
lemma, concentrated on the line through `pole(ℓ_i)` and `pole(ℓ_j)` with a **Jacobi-sum**
normalization `J(χ^a, χ^b) = g(χ^a)g(χ^b)/g(χ^{a+b})` in place of the single Gauss sum. Summing over
the `15 = C(6,2)` matched pairs gives the section-level `Deep` term. The polar of the deep point is
where the two poles' line meets the conic — matching C415's "polars of the deep points" description.

### What it strengthens

Turns `S = q·Pole − Deep` from a two-kinds-of-object identity (one section-level, one a count) into
a **symmetric section-level functional equation**: single-secant poles vs secant-pair Jacobi
products. This is the natural bridge that makes C415 (untwisted, radial) a clean *shadow* of C416
(twisted, section-level) — and it is the correct home for the Jacobi sums that Part-B/C417 flags.

### Certification (cost ~1 unit)

Extend the C416 checker: for each matched pair `(ℓ_i, ℓ_j)` of each matching, form the pair-product
section, apply the twisted transform `F_r`, and verify it equals `q · J(χ^a,χ^b) ·` (pair-delta at
the two poles), exact in `Z[ζ_{q-1}]`; then confirm `Σ_pairs (pair term) = Deep(M)` after
radialization, reproducing the profile identity. Reuse C416's exact cyclotomic arithmetic; no new
machinery. Uniform deep-excess makes the weight constant, so no tangency book-keeping is needed.

---

## Upgrade 2 — the commutative square "radialized twisted transform = `q·N` + deep correction" (fuses C415 and C416)

### Statement

C415 owns the untwisted odd operator `N` (`M_odd = q·N^T`, `N² = qI`, integral `√q`, square-zero
mod `q` with socle = polar plane). C416 owns the twisted transform `T` (secant power-sum section →
dual-matching pole-delta). They are currently two separate theorems handed to C417.

**Upgrade:** one commutative diagram. Let `rad` be radialization (sum over each scalar-`A4` point
orbit, i.e. pass from a section to its orbit-profile vector). Then

```text
        T (twisted, section-level)
  power-sum sections  ───────────────►  pole-delta sections
        │                                     │
   rad  │                                     │  rad
        ▼                                     ▼
   depth profiles  ───────────────────►  q·Pole  =  q·N·(depth) + (deep correction)
                    radialized transform
```

i.e. **`rad ∘ T = q·N ∘ rad + (deep correction)`**, where the deep correction is exactly Upgrade 1's
Jacobi/pair term. The single diagram says: the radial shadow of the twisted transform is the
untwisted `q·N` up to the deep defect.

### What is already confirmed

- `M_odd = q·N^T`, `N² = qI` (C415 cert).
- `rad(T(power-sum)) = q·Pole` (C416: "composing with orbit radialization lands on C415's untwisted
  pole profile `Pole(M)`").
- `N·(depth) = S = q·Pole − Deep` (C415: `N D(M) = S(M)`), so `q·Pole = N·depth + Deep`. This *is*
  the square, with `deep correction = Deep`.

So the square is essentially assembled from facts already in the two certs; the upgrade is to state
it as one diagram and verify commutativity end-to-end (rather than as two half-statements).

### Mechanism

`T` is the section-level twisted Fourier; `rad` collapses sections to orbit profiles; `N` is the
untwisted radial operator. `rad` intertwines `T` with `q·N` up to the part of `T` supported on the
deep (pair) sections, which `rad` sees as the `Deep` term. The commutator `rad∘T − q·N∘rad` is
therefore exactly the deep correction — the same object Upgrade 1 makes section-level.

### What it strengthens

One diagram replaces "here is the untwisted duality (C415) and separately the twisted intertwiner
(C416)". It makes the exposition state the relationship *between* the two transforms, which is what a
reader needs to see that C415 is the `√q`-integral degeneration of C416. It is also the cleanest
setup for the C417/Sin `p`-adic-lattice framing: the square is the generic fibre, and `N` (mod `q`)
is the special fibre.

### Certification (cost ~1 unit)

Assemble from the two pinned certs plus Upgrade 1: verify `rad∘T = q·N∘rad + Deep` as an exact
identity on all 22 matchings (and each B3 seam), reusing C415's `N`/`Pole`/`Deep` and C416's `T`. No
new hard computation — it is a consistency assembly of existing certified pieces into one checked
diagram.

---

## Upgrade 3 — single-secant span of the full odd 4-space (turns "matchings compress 4→2" into a theorem)

### Statement

C416 observed that matching families span only rank-2 planes inside the certified 4-dimensional odd
block ("matchings compress 4→2"). This is currently an observation about the *output* of a matching.

**Upgrade — theorem:** the compression is a property of *matchings* (sums of `(q+1)/2` secants), not
of the odd sector. A **single secant** already spans the full odd 4-space. Precisely: let
`d(ℓ)_i = #(ℓ ∩ O_{l_i}) − #(ℓ ∩ O_{r_i})` be the single-secant depth profile of a secant `ℓ`
(and `p(ℓ)` its single-secant pole profile). Then

```text
{ (d(ℓ), p(ℓ)) : ℓ a secant of the conic }  spans the full rank-4 odd block,
while  Σ_{ℓ ∈ M} (…)  compresses to rank 2 for every matching M.
```

So "4→2" is exactly the statement that matching-summation projects the rank-4 single-secant span
onto a rank-2 subspace — a genuine theorem about the summation map, not a coincidence of the output.

### What is already confirmed

- **Ambient odd block is rank 4** (verified: `depth+polar = depth+pole = pole+deep = rank 4`).
- **Matchings compress to rank 2** (verified: matching depth/polar/pole/deep each rank 2 over Q).

The two endpoints of the theorem are confirmed; the remaining content is the single-secant span
being *already* rank 4 (so the compression is entirely in the summation), plus the identification of
the rank-2 image as the depth (resp. pole) plane.

### Mechanism

There are `C(q+1,2) = 66` secants; each meets the conic in 2 points and the odd orbits `O_{l_i},
O_{r_i}` in a small pattern. The single-secant profile map `ℓ ↦ (d(ℓ), p(ℓ))` factors through the
pole (a point of the dual `P^2`), so its image is the odd-isotypic part of functions on the dual
conic — 4-dimensional. Matching-summation restricts to the balanced (one-factorization) sublattice,
which lands in the depth/pole rank-2 plane because the six poles of a matching form the dual matching
(C415 consequence 3), a rank-2 configuration.

### What it strengthens

Converts a bald "matchings compress 4→2" into: **the odd 4-space is the single-secant span, and
matching-summation is a rank-4→rank-2 projection with the depth plane as image.** This is the clean
statement a paper wants — it explains *why* the matching profiles live in a plane (they are averages
of a spanning secant family) and pins the exact rank drop `4→2` to the one-factorization structure.
It also dovetails with C417's "matchings compress `6→2`" cocycle picture: the same balanced-average
projection appears one level up.

### Certification (cost ~1 unit)

Reconstruct the 4 odd point-pair orbits (scalar-`A4`, from the C415 replay machinery), enumerate all
66 secants, compute `(d(ℓ), p(ℓ))` per secant, and check: (i) the `66 × 4` matrix has rank 4;
(ii) each matching's 6 secants sum into the rank-2 depth/pole plane; (iii) the summation map's image
is exactly the depth plane. Small enumeration; reuses C415's orbit/incidence code. Do the same on
each B3 seam for the uniform statement.

---

## Summary and cost

All three are packaging upgrades that reuse the existing C415/C416 machinery; none is a new crown and
none needs new mathematics beyond assembly. Their backbones are already certified in the pinned certs:
the `4→2` and rank-4 facts (Upgrade 3), `S = q·Pole − Deep` and uniform simple crossings (Upgrade 1),
and `M_odd = q·N^T`, `N D = S`, `rad(T) = q·Pole` (Upgrade 2). The remaining halves are:

| upgrade | what it adds | already certified | to certify (method) | ~cost |
|---|---|---|---|---|
| 1 pair-product/Jacobi deep term | section-level, symmetric `S = q·Pole − Deep` | `S=q·Pole−Deep`, uniform simple crossings, pole-delta half | Jacobi-sum pair-delta identity + radialization = Deep (extend C416 checker) | 1 |
| 2 `rad∘T = q·N + deep` square | one diagram fusing C415↔C416 | `M_odd=q·N^T`, `N D=S`, `rad(T)=q·Pole` | assemble the square, check commutativity end-to-end | 1 |
| 3 single-secant spans odd-4 | theorem, not observation, for "4→2" | ambient rank 4, matchings rank 2 | 66-secant span = rank 4; summation = rank-4→2 projection onto depth plane | 1 |

Recommended order for the paper: **3 → 1 → 2** (3 fixes the ambient object and the meaning of the
rank drop; 1 makes the two carriers symmetric; 2 states the single diagram that ties C415 and C416
together). Doing all three makes the depth–Fourier section self-contained and symmetric, and gives
C417's Sin-`p`-adic framing its clean generic-fibre diagram (the square) whose special fibre is `N`.

No allocation is made here; promote any of these through the normal C-ID/lane process if wanted.
