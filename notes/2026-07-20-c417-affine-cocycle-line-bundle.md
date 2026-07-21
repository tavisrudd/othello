# C417 — affine base-change cocycle and projective line-bundle formulation

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `COMPOSITION LANDED; MECHANISMS CLASSICAL (REYNOLDS/TRANSFER + SIN SNF), CREDITED, NOT
CLAIMED. The base-change is an exact affine 1-cocycle whose N-torsion class explains the
product-covariance-succeeds / quotient-covariance-fails dichotomy; the [2,8,1]/[2,9,1] extension is
the twisted-conic instance of the Sin p-adic incidence-lattice program. Several free upgrades and a
set of scaling-law questions are the durable output.`

## What this task delivers

C417 formalizes the base-point dependence that ran unresolved through C406→C416 as a single object,
and certifies it for the three Coxeter conic markers A3/B3/H3 over `q = 5, 7, 11`. The **mechanisms**
it uses are classical and are credited, not claimed (see priority boundary): the covariance
obstruction is the modular Reynolds/transfer obstruction, and the integral-lattice degeneration of
the `[2,8,1]/[2,9,1]` planes is Sin's Smith-normal-form program. **The contribution is the
composition** — the specific conic-factorization realization and the free upgrades it exposes —
per the lane's decision to value the composition over the (classical) infrastructure.

Objects (frozen C406 normalization, `V = Sym^2(F_q^2)`, conic `Q = XZ − Y^2`, `h = (q−1)/2`):

```text
P_M   = product of the (q+1)/2 secants of a matching M   (degree h+1)
Phi_M = (P_M − P_0)/Q                                     (degree h−1)  [base matching 0]
rho(g)= Sym^2 action of g in PGL_2(q) on (X,Y,Z)
```

Everything below is asserted for **all** group elements and **all** matchings (not sampled), for
each of A3/B3/H3, by the primary checker and re-derived by an independent replay.

## The formalization

### Line bundle (LB)

The matching products realize the conic-restriction exact sequence

```text
0 → H^0(P^2, O(h−1)) --·Q--> H^0(P^2, O(h+1)) --res--> H^0(O_C(q+1)) → 0,
```

with `h^0` dimensions `C(h+1,2), C(h+3,2), q+2` (certified `= 3/10/7, 6/15/9, 15/28/13`). Every
`P_M` restricts to the **same** section of `O_C(q+1)` — the full `(q+1)`-point conic divisor — so
`P_M − P_0 ∈ (Q)` exactly, and `Phi_M` is an honest degree-`(h−1)` form. This is the precise
meaning of "the quartic quotients and degree-six products live in the correct projective line
bundles": `P_M ∈ H^0(O(h+1))⊗det`, `Phi_M ∈ H^0(O(h−1))`, `Q: O(h−1) ↪ O(h+1)`.

### Covariance dichotomy (CV)

```text
(CV1)  rho(g).Q   = det(g)^2 · Q                          conic is a relative invariant
(CV2)  rho(g).P_M = det(g)   · P_{g.M}                    PRODUCT covariance SUCCEEDS
(CV3)  rho(g).Phi_M = det(g)^{-1}·(Phi_{g.M} − c(g)),  c(g) = Phi_{g.0}
                                                          QUOTIENT covariance carries a translation
```

The product `P_M` is an **honest equivariant section** of the det-twisted line bundle: no base point,
no averaging, no obstruction. The quotient `Phi_M` requires a base matching, and (CV3) is an
**affine** transformation law: the linear part `det(g)^{-1}rho(g)` plus a **translation** `c(g)`.

### Affine cocycle and the N-torsion obstruction (AC)

`c(g) = Phi_{g.0}` is a twisted 1-cocycle for the right action `w ↦ det(g)·rho(g).w`,

```text
c(gh) = c(h) + det(h)·rho(h).c(g),        c(g) = 0  iff  g stabilizes the base matching.
```

Quotient covariance is fixable **iff** `c` is a coboundary, i.e. there is a base `b` with
`c(g) = b − det(g)·rho(g).b`. The orbit numerator `S = Σ_M Phi_M` satisfies
`det(g)·rho(g).S = S − N·c(g)` (with `N = |orbit| = 2q` for B3/H3), so the **orbit barycenter**
`b* = S/N` is an explicit trivialization over any ring where `N` is invertible. Hence:

> **The class `[c]` is exactly `N`-torsion.** Away from defining characteristic (`p ∤ 2q`) it
> vanishes and quotient-depth covariance holds; in defining characteristic `q | N` the barycenter
> degenerates and — certified by an inconsistent linear system over `F_q` — `[c] ≠ 0`, so
> quotient-depth covariance **fails**. Certified shadow: `S` is det-twisted invariant mod `q`
> (the numerator survives) while the coboundary system has no solution (it cannot be divided by `N`).

This is the exact answer to the C414-preflight/C416 question "why does product-depth covariance
succeed but quotient-depth covariance fail." It is **not** an accident of the frozen basis: it is a
minimal `2q`-torsion class with an explicit generator.

### Cubic-first ⟺ base-independence (CF, B3/H3)

The balanced signed sheet measure `Σ_M eps(M) Phi_M^{⊗d}` (sheets = PSL orbits, `Σ eps = 0`) has
`mu_1 = mu_2 = 0`, `mu_3 ≠ 0`, and — certified — `mu_3` is **base-independent**. One statement now
subsumes two facts C406/C412 recorded separately: because the base ambiguity is a *translation* and
the measure is balanced (`Σ eps = 0`), every signed moment is translation-insensitive, so the first
nonvanishing moment is automatically base-independent — and it is the cubic. "Vanishing signed
moments kill translation terms exactly through the first surviving cubic" is exactly this.

## Free upgrades the composition supplies (beyond the classical infrastructure)

1. **The product line-bundle twist IS the chirality character.** The forced covariance scalar is
   `det(g)`; its quadratic-residue reduction `det(g)^{(q-1)/2}` is `+1` exactly on `PSL_2(q)`
   (certified for B3/H3), i.e. it equals the outer sheet-sign `eps` that governs the entire
   C373–C416 golden/chirality story. The golden ambiguity is not extra data: it is the square-class
   of the product line bundle's twist.

2. **The whole branch's base/orientation ambiguity is one class.** Every C411–C416 step wrestled a
   base-matching / orientation / `J`-parity ambiguity. The affine cocycle `c(g) = Phi_{g.0}` *is*
   that ambiguity, and `[c] ∈ H^1(G, W)` is precisely why no canonical base can be chosen. The
   obstruction is already present on `PSL_2(q)` (the PSL-orbit of the base has size `q`, so its
   barycenter also dies) — the failure is not merely an outer/PGL effect.

3. **The relation constants are forced by the orbit sizes and the modular heart.**
   ```text
   depth relation [2,8,1] ≡ 2·(1,4,6) mod 11   =  the antipodal mass-balance  Σ n_i d_i = 0
   Tate  relation [2,9,1] = [2,8,1] + e_4       =  balance + one-unit defect on the size-4 orbit
   8 = q−3 = highest weight of the heart L(q−3)=Sym^{q−3}(F_q^2);  9 = q−2 = dim of the heart;  P(1)=1|9|1
   weights 1,4,6 = |A4|/{12,3,2},  sum = q
   ```
   So the "`8/9`" is not a coincidence: the depth relation is the pure orbit-size balance, and the
   Tate relation is that balance perturbed by exactly the socle direction `e_4`. The `8, 9` are the
   Loewy invariants `q−3, q−2` of the modular permutation cover.

## Part B — the [2,8,1]/[2,9,1] Stickelberger instance (bounded; mechanism pre-empted)

The mid-branch conjecture (that the two planes are associated-gradeds of one integral lattice
filtered by the Stickelberger valuation of the Jacobi weights, with C415's `N` as the untwisted
degeneration) has, at the **mechanism** level, a mature owner: **Sin's Smith-normal-form program**
(Chandler–Sin–Xiang `arXiv:math/0312506`; Sin, *SNF of Incidence Matrices*). That program already
lifts an incidence operator to the `p`-adic ring `Q_p(zeta_{q-1})` via a Teichmüller monomial basis,
computes the invariant factors from **Jacobi sums and Stickelberger's theorem**, and reads the
modular **radical/socle (Loewy) series** off the `p`-adic filtration — including conic/quadric
actions. This is exactly the "integral cyclotomic lattice → modular projective cover" mechanism.

What C417 contributes at instance level, certified from the pinned C415 data (`N²=11I`, `N` mod 11
square-zero with image = polar plane, joint depth+polar rank `= 4`):

- `N` is a genuine **integral `√q`** operator; the depth plane is a complement of the mod-`q` socle
  (= polar plane) — the untwisted degeneration the conjecture wants.
- The precise instance shape: **depth = orbit-size balance, Tate = balance + `e_4` socle defect.**
  So the two planes *are* adjacent by exactly the socle direction, consistent with being two
  associated-graded levels.

**Where it does not close cheaply, and why that is the honest boundary.** The naive Stickelberger
valuation of the two sector Gauss sums (`g(χ^{h−1})`, `g(χ^{h+1})`) differs by `2`, whereas the
observed shift is `1` (the single `e_4` defect). Resolving the exact `1` requires the **Jacobi-sum
carry** structure — i.e. the full `p`-adic SNF computation — which is precisely the pre-empted Sin
mechanism. Building it would confirm the instance but add no mechanism. C417 therefore records the
instance as **well-posed inside the Sin program** (twisted-conic, secant/matching-decorated,
`P(1)=1|9|1` special fibre) rather than a new general theorem.

## What is surprising, constrained, or more general than expected

- **More constrained than expected — the normalization is gauge-clean.** A priori the secant-product
  representative choice could inject an arbitrary scalar cocycle `λ(g,M)`. Empirically
  `λ(g,M) = det(g)` — independent of `M` and of the representatives. The frozen C406 normalization
  is exactly the one for which the product is a clean `O(h+1)⊗det` section; why it is that rigid is
  not explained here.
- **More constrained — the obstruction is minimal.** `[c]` is not a generic `H^1` element; it is
  killed by exactly `N = 2q` and has an explicit generator (the barycenter). The whole "why doesn't
  it descend" reduces to "you cannot divide by `2q` in characteristic `q`."
- **Surprising — the interesting structure lives on a knife-edge.** All three cases sit at
  `q = h_cox + 1`, which is exactly where `|orbit| = 2q ≡ 0`. The modular compression (the `6→2`
  rank drop, `P(1)=1|9|1`) is a *defining-characteristic* phenomenon; move off `q` and the cocycle
  trivializes. The base-independent cubic `mu_3`, by contrast, survives into all characteristics —
  so the composition cleanly separates the "characteristic-`q` resonance" (compression) from the
  "arithmetic-stable" content (the cubic relative invariant).
- **More general than expected — the explanation is not H3-special.** The affine-cocycle /
  N-torsion / line-bundle package is a statement about *any* group acting on an orbit of sections
  with `p | |orbit|`, over *any* field and *any* smooth conic. The H3 story is one instance.
- **Uniform and `q`-independent — the surviving degree is always 3.** Ambient degrees grow
  (`h±1 = 1/3, 2/4, 4/6`) but the first surviving moment is pinned at cubic for all three, forced by
  the two balanced constraints plus antipodal parity.

## Questions the scaling laws beg (the durable output)

| scaling law | A3 (q=5) | B3 (q=7) | H3 (q=11) | question it opens |
|---|---|---|---|---|
| `q = h_cox + 1` | 4+1 | 6+1 | 10+1 | the family lives at the *conic phase*; what is the matching cocycle for the **same Coxeter group at larger `q`** (off the boundary)? does the compression vanish there? |
| `deg Φ, deg P = h∓1`, sum `q−1` | 1,3 | 2,4 | 4,6 | the two sectors are Fourier-complementary (`r ↔ −r`); is the **middle weight `h`** a self-dual sector with its own content? |
| double-coset weights sum to `q` | (1 sheet) | 1+2+4 / 1+3+3 | 1+4+6 | is `q = Σ weights` a **mass formula**, and what Coxeter datum fixes the partition of `q`? |
| first surviving moment `= 3` | — | 3 | 3 | why is the surviving degree `q`-independent? what configuration first survives at degree 5, 7? (C409 trade-filtration) |
| `N^2 = qI` (integral `√q`) | vacuous | ✓ | ✓ | not every finite Radon transform has an *integral* `√q`; which do, and is integrality forced by the scheme self-duality `P=Q` (C372)? |
| `[c]` is `2q`-torsion | ✓ | ✓ | ✓ | is `q` the **only** bad prime (good reduction elsewhere, à la C346)? is `2` also bad (the sheet sign)? |

**The biggest opening — rank scaling.** A3/B3/H3 are exactly the three irreducible **rank-3**
Coxeter groups → ternary conic → `P^2`. Rank 2 (dihedral → `P^1`) and rank ≥ 4 (→ quadrics in
`P^n`) beg whether the whole affine-cocycle / secant-product / cubic-first package is the **rank-3
floor of a Coxeter-rank tower**, with the rank controlling the ambient quadric dimension and the
first-surviving-moment degree.

### What Coxeter or Tao would ask

- **Coxeter.** Complete the classification: for which finite reflection groups does the
  conic-matching cocycle exist, and what is the uniform statement across the rank-3 list (including
  the reducible and dihedral cases)? How do the weights `1,4,6` relate to the **exponents/degrees**
  (H3 degrees `2,6,10`, exponents `1,5,9`)? What is the concrete **icosahedral** realization of the
  22 matchings and the `1,4,6` orbits — Petrie polygons, hexagons (Edge/Dye), or polytope faces? Is
  `Σ weights = q` an Euler characteristic / chamber count?
- **Tao.** State the general principle stripped of the geometry ("a group acts on an orbit of
  line-bundle sections; the product is equivariant, the affine chart is not; the obstruction is
  `|orbit|`-torsion") and identify the **correspondence principle**: the char-0 barycenter-trivial
  object degenerating to the char-`q` obstructed one is a Rees/`p`-adic degeneration — is `N` a
  "square root of Frobenius," with integrality forced by self-duality? What is the `q → ∞`
  asymptotic of the family, and is the phenomenon a genuine char-`p` **resonance** (only at
  `q = h_cox+1`) or does a shadow persist off the boundary? What is the minimal example (B3/`q=7` is
  the minimal splitting case; A3 the nonsplitting control)?

## Priority boundary (credit, not claim)

Per the claim-specific audit `notes/2026-07-20-c417-affine-cocycle-line-bundle-audit.md`
(extends the C406 baseline; three-service check run, Semantic Scholar `NOT COVERED` (HTTP 429),
MathSciNet/zbMATH/Google Scholar `NOT COVERED`):

- **Cocycle mechanism:** the `H^1(PGL_2(q), Sym^{q−3})` class and the barycenter-`mod p` obstruction
  are the classical modular Reynolds/transfer failure. **Credited, not claimed.**
- **Line bundle / covariants mod `(Q)`:** the conic-restriction sequence and covariants modulo a
  hypersurface are textbook (Broer–Chuai `arXiv:0709.0703`; projective Reed–Muller on conics,
  Gatti–Korchmáros–Schulte). **Credited, not claimed.**
- **Stickelberger integral lattice:** the general "Teichmüller lift → `p`-adic SNF via Jacobi
  sums/Stickelberger → modular Loewy series" mechanism is the Sin school (Chandler–Sin–Xiang
  `arXiv:math/0312506`; Sin survey; Bardoe–Sin). **Credited, not claimed.**
- **Surviving as likely-new-within-coverage (composition only):** the conic-twisted,
  secant/matching-decorated realization; the identification of the product/quotient covariance
  dichotomy with the `2q`-torsion cocycle; the `depth = 2·(orbit sizes)` / `Tate = balance + e_4`
  constants; and the cubic-first⟺base-independence unification. Bounded wording only: *no
  predecessor for this conic-twisted / cocycle / Stickelberger-filtered composition was located in
  the recorded coverage; the general mechanisms are classical.*

## Adjacent-crown extraction (bounded, no allocation here)

Prior work pre-empts the general mechanisms, so the bounded extraction records candidates without
allocating (allocation needs a reserve + C-ID recheck, deferred):

1. **Rank tower.** The rank-3 → higher-rank Coxeter/quadric lift of the affine-cocycle/cubic-first
   package (highest ceiling; the "what would Coxeter ask" direction).
2. **Bardoe–Sin conic comparison.** Read the conic-specific modular submodule literature
   (`arXiv:1305.1431`, `arXiv:1104.0324`) at text depth and decide whether the `[2,8,1]/[2,9,1]`,
   `P(1)=1|9|1` picture is already in the conic modular canon or a genuine new instance.
3. **Good-reduction / bad-prime.** Is `q` the only bad prime for the C406 configuration (à la
   C346), and does `2` enter via the sheet sign?

The top-two cheap tests were performed inline (the constant identities `depth = 2·(1,4,6)`,
`Tate = balance + e_4`, and the `8=q−3, 9=q−2` Loewy identification are confirmed; the naive
Stickelberger shift is `2` vs observed `1`, isolating the Jacobi-carry as the sole gap). None is
allocated by this report.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13:

```bash
python3 notes/2026-07-20-c417-affine-cocycle-line-bundle.py --check
python3 notes/2026-07-20-c417-affine-cocycle-line-bundle-replay.py
sha256sum -c notes/2026-07-20-c417-affine-cocycle-line-bundle.sha256
```

Intentional regeneration: `python3 notes/2026-07-20-c417-affine-cocycle-line-bundle.py --write`.

The primary checker reconstructs, for each of A3/B3/H3, the endpoints, full `PGL_2(q)`, PSL subgroup,
matching orbit, secant products `P_M`, conic quotients `Phi_M`, and verifies LB/CV/AC/CF and the
free upgrades for **all** group elements and matchings. The independent replay re-derives the
load-bearing facts by disjoint methods: explicit polynomial **long division** by `Q` (divisibility),
per-**secant covector** transforms (product covariance), an independent augmented-**rank** test
(coboundary inconsistency), a **rational** barycenter (N-torsion), and the **opposite** sheet-sign
convention (cubic-first).

| artifact | bytes | SHA-256 |
|---|---:|---|
| primary checker `.py` | 21,991 | `5062e2ac48b3a00be1cd50b7c23922ddda410b99e485442241874e447d240ac0` |
| independent replay `.py` | 13,893 | `d70e1609c6f898372e33a72240d9a7407ac4fe88728aefbe22f7d1b0b4a9c70c` |
| certificate `.json` | 5,081 | `ca8b009710da9893578f23e20b16e53f18be8573b06dfebb8f4ccb74c0854109` |

Trusted inputs (SHA-pinned in both scripts): the C406 matching module
`a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51` and orbit scout
`fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246`. Part B's `N` facts are read from
the pinned C415 certificate
`d0648c94b662e3ab9e565be439ea6d57c0e985097524c77d65dbb32b1272f475`. The trusted boundary is exact
`F_q` integer arithmetic, the standard `Sym^2` action, and the frozen C406 secant-product
normalization; no cyclotomic embedding is used (the Stickelberger/Jacobi analysis is cited, not
recomputed).

**What this bundle does not certify:** a new general covariance or Stickelberger theorem (both
mechanisms are classical/pre-empted); the exact `[2,8,1]→[2,9,1]` Jacobi-carry computation (Sin
program); any rank-tower generalization; or novelty beyond the bounded coverage above.

## Disposition

C417 lands as a composition result: the base-point dependence of the C406→C416 depth construction is
an exact affine 1-cocycle whose `2q`-torsion class is the single reason quotient-depth covariance
fails while product-depth covariance succeeds, packaged through the conic line bundle, with the
cubic-first survival unified as the balanced-moment translation-killing. The `[2,8,1]/[2,9,1]`
extension is the twisted-conic instance of the Sin `p`-adic incidence-lattice program, with the
`8/9` isolated as a one-unit `e_4` socle defect. The mechanisms are classical and credited; the
durable output is the composition, the free upgrades, and the scaling-law questions — chiefly the
rank-3-floor-of-a-Coxeter-tower direction. No manuscript edit and no successor allocation are made
here.
