# C417 priority audit — affine base-change cocycle, hypersurface-ideal covariants, Stickelberger-filtered twisted Radon transform, and trade polarization

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict (per claim):**

- **(1) Affine base-change 1-cocycle** — `FRAMEWORK CLASSICAL; SPECIFIC COMPOSITION LIKELY-NEW-WITHIN-COVERAGE, BUT THIN AND AT THE STOP-CONDITION BOUNDARY`.
- **(2) Covariants modulo the conic ideal / line bundles on a conic** — `FRAMEWORK PRE-EMPTED (Broer-Chuai + projective Reed-Muller on conics); equivariant-section cohomology composition LIKELY-NEW-WITHIN-COVERAGE, thin`.
- **(3) Stickelberger-filtered integral twisted Radon/Fourier transform** — `GENERAL MECHANISM PRE-EMPTED (Sin school: Chandler-Sin-Xiang, Sin survey, Bardoe-Sin); the specific twisted-conic realization with the exact [2,8,1]/[2,9,1] planes, P(1)=1|9|1 conic-stabilizer picture, and matching/secant decoration is LIKELY-NEW-WITHIN-COVERAGE. This is NOT an open near-neighbor field: it is a mature program the manuscript must position against`.
- **(4) Polarization of design trades as signed-moment cocycles** — `DESIGN-TRADE/NULL-DESIGN LAYER CLASSICAL; polarization-cocycle framing LIKELY-NEW-WITHIN-COVERAGE but essentially a re-description of the C406/C411 cubic-first result`.

**Decisive question (claim 1):** on the recorded evidence the cocycle, taken alone, **is** the elementary base-point-difference expansion dressed in group-cohomology language: its class lives in `H^1(PGL_2(q), Sym^{(q-3)/2})`, a cohomology group whose computation is a mature subject, and the "cannot re-center by the orbit barycenter because `p | |orbit|`" obstruction is the foundational Reynolds-operator/transfer failure of modular invariant theory. No predecessor was located for the specific identification of the product-depth-vs-quotient-depth covariance dichotomy with this cocycle class, but that composition is thin. Under C417's own stop rule the cocycle clears the bar only if a **portable covariance-dichotomy theorem** delivers something the generic `H^1` + transfer-obstruction statements do not.

**Opening coverage summary.** This audit **extends** the C406 baseline (`notes/2026-07-20-c406-priority-audit.md`); it consumes that report's covered sources (Edge, Dye, Filmus-Lindzey, Bamberg-Klawuhn, Chien-Kang, Lansdown-Martin, Srinivasan, Ghorbani et al., Hollmann-Xiang, Pan-Wu-Yin, Cameron-Korchmaros) and does not re-audit the classical one-factorization / conic-A5 / matching-design / generic Gauss-sum layer, which the baseline already owns as pre-empted. Read depth for the **new** C417-specific sources: **no source was read cover-to-cover in this pass**; four were read at **partial** depth on their load-bearing passages (Broer-Chuai, Sin SNF survey, Chandler-Sin-Xiang, Yanez); the remainder are **abstract/metadata only** or **secondary only**. Every source named below carries an explicit read-depth field. The mandated three-service check was run: OpenAlex and Crossref were reachable; **Semantic Scholar returned HTTP 429 (rate-limited) throughout and is recorded as NOT COVERED** for the keyword checks. MathSciNet, zbMATH, and Google Scholar are NOT COVERED (see Coverage gaps).

---

## Claim-by-claim disposition

### (1) Affine base-change 1-cocycle `c(g) = (P_{g.0} - P_0)/Q`

**What C417 asserts.** For `G = PGL_2(q)` on `V = Sym^2(F_q^2)` with conic `Q = XZ - Y^2`, the matching secant products `P_M` (degree `(q+1)/2`, all restricting to the same divisor on the conic) give the base-point quotient `Phi_M = (P_M - P_0)/Q ∈ H^0(P^2, O((q-3)/2))`, and `c(g) = (P_{g.0} - P_0)/Q` is a 1-cocycle valued in that symmetric-power `PGL_2`-module. The mechanism: quotient-depth covariance fails while product-depth covariance succeeds because `P_M` is an honest equivariant line-bundle section whereas the quotient needs a base point, and re-centering by the orbit barycenter needs `1/|orbit|` with `p | |orbit|` in defining characteristic.

**Located prior art (framework).**

- *The cohomology group is a studied object.* `H^1` / `Ext^1` of symmetric powers of the natural 2-dimensional module for `SL_2`/finite groups of Lie type in defining characteristic is a mature computation. The Specht-module route reduces exactly to `Ext^1_{B(n)}(S^d E, K_lambda)` — extensions by symmetric powers `S^d E` of the natural module (arXiv:1704.02417, abstract read; explicit description of `H^1(Sigma_a, Sp(lambda))` for `p>2`). Cross-characteristic `Ext^*` for `PSL_2(q), PGL_2(q), SL_2(q)` is fully determined (arXiv:2002.04183, abstract read; this is the cross-characteristic case, so it bounds rather than realizes the defining-characteristic cocycle). A general survey of cohomology of algebraic groups / finite groups of Lie type with these coefficients exists (arXiv:2209.01140, not machine-readable in this pass; NOT COVERED at depth).
- *The barycenter-mod-p obstruction is the foundational modular-invariant-theory obstruction.* In characteristic `p | |G|` the Reynolds/averaging operator fails because `|G| ≡ 0 (mod p)`, and the transfer is non-surjective on degrees divisible by `p`; this is textbook (Wikipedia "Reynolds operator"; "The transfer in the invariant theory of modular permutation representations", PJM 199 (2001), secondary only). "Cannot average over an orbit whose size is divisible by `p`" is precisely this classical failure.
- *The equivariant-section side is classical equivariant algebraic geometry.* `G`-linearized bundles and the `Pic^G(X) -> Pic(X)^G -> H^2(G, C^*)` sequence, and 1-cocycles obstructing a global equivariant lift, are standard (equivariant AG references, secondary only).

**Not located.** No source forms the secant-product base point difference `(P_M - P_0)/Q`, identifies its class in `H^1(PGL_2(q), Sym^{(q-3)/2})`, or uses that class to explain the **product-depth-succeeds / quotient-depth-fails covariance dichotomy** for the conic-quotient factorization construction. That identification has no located predecessor in the recorded coverage.

**Disposition:** `FRAMEWORK CLASSICAL; SPECIFIC COMPOSITION LIKELY-NEW-WITHIN-COVERAGE`. The abstract machinery is elementary/classical on both ends (cohomology group known; barycenter obstruction textbook). The novelty is the geometric realization only, and it is thin. This is the crown-critical claim and it sits **at** the stop-condition boundary (see Decisive question).

### (2) Covariants modulo a hypersurface ideal / line bundles on a conic

**What C417 asserts.** The conic-restriction sequence `0 -> O(h-1) --·Q--> O(h+1) --res--> O_C(q+1) -> 0`, modules of covariants `(k[V] ⊗ M)^G` modulo the conic ideal `(Q)`, and placing the quartic quotients and degree-six products in the correct projective line bundles.

**Located prior art (framework).**

- *Modules of covariants modulo a hypersurface.* Broer-Chuai, *Modules of covariants in modular invariant theory* (arXiv:0709.0703, partial; read the codimension-one / free-in-codimension-one covariant results and its citation of Broer, *Hypersurfaces in modular invariant theory*, J. Algebra 306 (2006)). This is exactly the theory of `(k[V] ⊗ M)^G` as a module, its freeness in codimension one, and hypersurface quotients — the baseline already flags it as cited, and it directly owns the "covariants modulo a hypersurface ideal" frame.
- *Restriction/evaluation on a conic.* The exact sequence `0 -> O(h-1) --·Q--> O(h+1) -> O_C(q+1) -> 0` is the textbook restriction sequence for a degree-2 divisor in `P^2` (Hartshorne). Evaluation of degree-`d` forms on the `q+1` conic points is the projective Reed-Muller code on a conic; forms restricted to conics / linear systems of conics are treated by Gatti-Korchmaros-Schulte, *Evaluation codes from linear systems of conics* (arXiv:2605.11187, abstract/metadata only, cached), and the general projective-Reed-Muller-on-quadric literature (Lachaud; "Maximal quadrics and minimal codewords of PRM codes", search-snippet only).

**Not located.** No source computes the `G`-cohomology of these specific equivariant secant-product sections as the obstruction to descending covariance through `res`. But the ingredients — restriction sequence, covariants-mod-`(Q)`, conic evaluation — are individually classical, so any novelty is the same thin composition as claim (1) viewed sheaf-theoretically.

**Disposition:** `FRAMEWORK PRE-EMPTED; equivariant-section-cohomology composition LIKELY-NEW-WITHIN-COVERAGE, thin`. Manuscript wording must credit Broer-Chuai/Broer and PRM-on-conics and must not present the exact sequence or covariants-mod-`(Q)` as new.

### (3) Stickelberger-filtered integral twisted Radon/Fourier transform (crown-critical, highest stated upside)

**What C417 asserts.** A finite-field twisted Radon/Fourier transform on a ternary quadratic space, with an integral cyclotomic lattice filtered by the Stickelberger valuation of Gauss/Jacobi sums ("Jacobi weights"), whose associated-graded pieces are two combinatorially distinct relation planes (`[2,8,1]` vs `[2,9,1]`), whose special fibre mod the prime above `q` is the modular projective-cover `P(1) = 1|9|1`, and whose untwisted degeneration is an integral operator `N` with `N^2 = qI`, square-zero mod `q`.

**Located prior art — this is a mature program, not an open field.**

- *The exact organizing mechanism.* Chandler-Sin-Xiang, *The invariant factors of the incidence matrices of points and subspaces in PG(n,q) and AG(n,q)* (arXiv:math/0312506, partial). They realize the incidence operator over the unramified `p`-adic ring `R = Q_p(zeta_{q-1})`, lift a **monomial basis** by Teichmuller characters, and compute the **p-adic Smith normal form / invariant factors** of the operator; the `p`-elementary divisors are obtained from **Jacobi sums and Stickelberger's theorem on Gauss sums**, with the `p`-adic valuation of `J(T^{-a},T^{-b})` given by the base-`p` digit sums modulo `q-1`. This is precisely "an integral cyclotomic lattice filtered by the Stickelberger valuation of the Gauss/Jacobi sums."
- *The integral-to-modular degeneration.* Sin, *Smith Normal Forms of Incidence Matrices* survey (cached `Sin-snf-incidence-survey`, partial). It works over a DVR `R`, identifies the `RG`-submodule structure of the lifted lattice, and shows `M^i = rad`, `N^i = soc` — the **radical and socle series** of the modular (`F_q`) permutation module are read off the `p`-adic filtration, with the sums `chi(B)` evaluated by Jacobi sums and Stickelberger's theorem. It explicitly treats quadric/conic-related actions (Klein quadric noncollinearity graph; nondegenerate quadrics). This is exactly "special fibre mod the prime above `q` is the modular projective-cover / Loewy picture," the `Rees`-module degeneration, and the `N^2 = qI` incidence-operator behavior.
- *The modular side for conic/`PGL_2` actions specifically.* Bardoe-Sin (modular submodule structure of `GL(n+1,q)` on `PG(n,q)`; secondary, via the survey and searches); "Subextensions for a permutation `PSL(2,q)`-module" (arXiv:1305.1431, abstract/metadata); "On Binary Codes from Conics in `PG(2,q)`" (arXiv:1104.0324, abstract/metadata) — the incidence matrix of passant lines / internal points of a conic via modular representation theory. The `[2,8,1]`/`[2,9,1]` two-plane and `P(1)=1|9|1` conic-stabilizer picture live in exactly this neighborhood.
- *Finite Radon transform as intertwiner (characteristic 0 side).* Soto-Andrade, Dunkl, Stanton, and Yanez, *Harmonic Analysis of Radon Filtrations for `S_n` and `GL_n(q)`* (arXiv:0901.2669, partial). "Radon **filtrations**" of finite Radon transforms intertwining Gelfand-pair natural representations is a named object — but over `C`, giving spherical functions, not the integral/modular degeneration.

**Not located.** The **specific** twisted (multiplicative-character-twisted) Radon/Fourier transform on the ternary **conic** space, its exact `[2,8,1]` vs `[2,9,1]` associated-graded planes, the `P(1)=1|9|1` conic-stabilizer special fibre packaged as a **Rees module**, and the **secant-product / matching decoration** — no located predecessor. The C412/C416 twisted realization and the decision of whether the `8/9` difference is supported on the compression/socle defect or obstructs a common filtered lattice are not in the Sin-program sources at the depth read.

**Disposition:** `GENERAL MECHANISM PRE-EMPTED; specific twisted-conic realization LIKELY-NEW-WITHIN-COVERAGE`. This claim's headline framing ("integral cyclotomic lattice filtered by Stickelberger valuations of Gauss/Jacobi sums degenerating to a modular projective cover") **is the Sin-school incidence-operator program**. The manuscript must present the conic-twisted secant-decorated instance as a new object **inside** that program, cite Chandler-Sin-Xiang / Sin / Bardoe-Sin, and must not advertise the Stickelberger-filtered-lattice-to-modular-cover mechanism as novel. The Jason Lo relative Fourier-Mukai analogy (arXiv:1710.03771, baseline-cited, not re-fetched) remains a proof-design model only.

### (4) Polarization of design trades as signed-moment cocycles

**What C417 asserts.** That "the first surviving moment is cubic because lower moments are coboundaries/translation terms" has a predecessor in cubature/trade theory beyond Ghorbani et al.

**Located prior art.** The trade-off method for BIB designs, `t`-trades, and null designs (Colbourn-Dinitz *Handbook*; "Combinatorial Topology and the Trade Off Method in BIB Designs"; universal null designs, arXiv:2012.04202 — all search-snippet/secondary) classically equate incidence counts through a fixed strength; the baseline already owns Ghorbani-Kamali-Khosrovshahi-Krotov (arXiv:1810.02296) for `[t]`-trade volumes/affine types.

**Not located.** No source frames vanishing lower moments as coboundaries/translation terms of an affine cocycle (the "polarization" reading), nor derives cubic-first from that framing. But this is the same object as claim (1) restated for the signed measure, and it reads as a re-description of the C406/C411 cubic-first push-forward rather than an independent contribution.

**Disposition:** `DESIGN-TRADE/NULL-DESIGN LAYER CLASSICAL; polarization-cocycle framing LIKELY-NEW-WITHIN-COVERAGE but repackaging`. Keep the safe wording; do not claim a new trade theory.

---

## C416 lemma cross-check (requested)

The C416 twisted-Fourier pole-delta lemma (`F_r((chi o ell)^r) = q^2 · delta^can_[pole(ell)]`, Gauss-free) and the matching power-sum -> dual-matching pole-delta intertwiner (`notes/2026-07-20-c416-twisted-power-sum-duality.md`) are adjacent to claim (3) and share its integral-lattice target (C416 hands the `Z[sqrt(q)]` structure `N`, `N^2 = qI`, and the `8/9`/Rees comparison to C417). The C416 report's own bounded-negative wording is confirmed and refined:

- The underlying affine fact (additive Fourier of `chi ∘ (linear form)` concentrates on the dual line as a Gauss sum) is classical, as C416 states (Kazhdan-Polishchuk circle).
- **Nearer named neighbors than C416 cited:** the pole-delta diagonalization is a projectivized finite-Weil-representation / Gauss-sum eigenvalue statement, and the matching power-sum -> pole-delta map is a finite **Radon-transform-as-intertwiner** statement in the Soto-Andrade / Dunkl / Stanton / Yanez tradition. The `N` / `N^2 = qI` integral comparison C416 defers to C417 is exactly the Sin-school incidence-operator `p`-adic structure.
- No located predecessor for the projectivized Gauss-free `q^2` normalization or the specific matching / dual-matching secant-power-sum intertwiner. C416's bounded "likely-new wording, no priority claim" stands; nothing in this audit contradicts it, and the added neighbors should be cited when the lemma reaches manuscript.

---

## Source ledger

Every named source carries an explicit read-depth field. A cache entry proves only that bytes were fetched; readings are recorded here. **No source in this ledger was read cover-to-cover in this pass**; the four `partial` entries had their load-bearing passages read directly from the cached extraction.

| Source | Read depth, access, version | Load-bearing boundary |
|:---|:---|:---|
| A. Broer, J. Chuai, *Modules of covariants in modular invariant theory*, arXiv:0709.0703 (2007) | **partial**; cached extraction, read the codimension-one / free-in-codimension-one covariant statements (§ around "codimension one ... k[V]^G is a polynomial ring and all its modules of covariants are free") and its reference to Broer, *Hypersurfaces in modular invariant theory* (J. Algebra 306, 2006). Cache key `arXiv:0709.0703`, SHA-256 `e8b7e4504c1acfe005fc2087259c93de95e987d8a6d24bd7dc78eff82309ac7e`. | Owns the theory of covariants `(k[V]⊗M)^G` and hypersurface quotients (claim 2 framework). Does not form the secant-product cocycle. |
| P. Sin, *Smith Normal Forms of Incidence Matrices* (survey) | **partial**; cached extraction, read the DVR/`RG`-submodule passages (`M^i = rad`, `N^i = soc`), the Stickelberger/Jacobi-sum evaluation of `chi(B)`, and the quadric/conic examples. Cache key `Sin-snf-incidence-survey`, SHA-256 `803e40ad6dcab6a4dd8a81d21f05cf83936465126c6446f4a05f7dc227983405`. Version: the `people.clas.ufl.edu/sin/files/snf.pdf` posting; may correspond to the Science China Math 2013 survey (DOI `10.1007/s11425-013-4643-8`) but the published bytes were not separately read. | Owns the integral-lattice-to-modular-Loewy-series degeneration via Stickelberger/Jacobi sums (claim 3 general mechanism). Does not treat the twisted conic secant-decorated instance. |
| D. Chandler, P. Sin, Q. Xiang, *The invariant factors of the incidence matrices of points and subspaces in PG(n,q) and AG(n,q)*, arXiv:math/0312506 (2003) | **partial**; cached extraction, read the Teichmuller monomial-basis construction, the `p`-adic SNF reduction over `R = Q_p(zeta_{q-1})`, and the Stickelberger/Jacobi-sum digit-sum valuation passages (§§2, 4, and the Gauss/Jacobi/Stickelberger section). Cache key `arXiv:math/0312506`, SHA-256 `e82ea3b524a03715abb2eec7953c1bb09615a9d1b51ca3c638efe26b1cf5110d`. | Owns the exact Stickelberger/Jacobi-sum organization of the `p`-adic invariant factors of a finite-geometry incidence operator (claim 3 mechanism). Full `GL(n+1,q)` on `PG(n,q)`, not the conic-stabilizer twist. |
| M. F. Yanez, *Harmonic Analysis of Radon Filtrations for `S_n` and `GL_n(q)`*, arXiv:0901.2669 (2009) | **partial**; cached extraction, read abstract and Introduction (Soto-Andrade, Dunkl, Stanton lineage; generalized Radon transforms as Gelfand-pair intertwiners). Cache key `arXiv:0901.2669`, SHA-256 `61cf6ac9af80be3fe1764f6bdf19dee36e1a9e02472f383734716a5388c330d9`. | Establishes "Radon filtration" as a named object over `C` (spherical functions). Does not give the integral/modular Stickelberger degeneration. |
| *Cohomology of `PSL_2(q)`, `PGL_2(q)`, `SL_2(q)`* (cross characteristic), arXiv:2002.04183 (2020) | **abstract/metadata only**; abstract read, PDF cached but not read at text depth. Cache key `arXiv:2002.04183`, SHA-256 `a66f56967afb655048db66f239759db8fe3130b4f5078669e6d628af80a036fe`. | Determines `Ext^*` for irreducible modules in **cross** characteristic; bounds but does not realize the defining-characteristic cocycle of claim 1. |
| *First-degree cohomology of Specht modules and extensions of symmetric powers*, arXiv:1704.02417 | **abstract/metadata only**; arXiv abstract via WebFetch. | Reduces `H^1(Sigma_a, Sp(lambda))` to `Ext^1_{B(n)}(S^d E, K_lambda)` — the symmetric-power-extension computation underlying claim 1's cohomology group. Not fetched at text depth. |
| B. Gatti, G. Korchmaros, G. Schulte, *Evaluation codes from linear systems of conics*, arXiv:2605.11187 (2026) | **abstract/metadata only**; cached (from prior lane fetch), title/metadata + search snippet. Cache key `arXiv:2605.11187`, SHA-256 `45efc77d6200ff59ea84f4a1e68025a6369f88fd8e13dbcedfa9ea9884ed4c1b`. | Evaluation (PRM) on conics / linear systems of conics — the `res` map of claim 2's exact sequence. Not read at text depth. |
| *Cohomology of algebraic groups, Lie algebras, and finite groups of Lie type*, arXiv:2209.01140 | **NOT COVERED at depth**; PDF not machine-readable in this pass (WebFetch returned encoded streams). | Would bound defining-characteristic `H^1(G(F_q), Sym^d(std))` for claim 1; carried as an open gap. |
| "The transfer in the invariant theory of modular permutation representations", Pacific J. Math. 199 (2001) | **secondary only** (search snippet, MSP hosted PDF surfaced) | Supports that the averaging/transfer obstruction on degrees divisible by `p` is classical (claim 1 barycenter obstruction). |
| M. Bardoe, P. Sin (modular submodule structure of `GL(n+1,q)` on `PG(n,q)`) | **secondary only**; via the Sin survey and search results. | The modular `F_q`-submodule structure (Loewy/socle, projective covers) of finite-geometry permutation modules — the defining-characteristic side of claim 3. Not read directly. |
| *Subextensions for a permutation `PSL(2,q)`-module*, arXiv:1305.1431; *On Binary Codes from Conics in `PG(2,q)`*, arXiv:1104.0324 | **abstract/metadata only** (search snippets) | Modular submodule structure of `PSL(2,q)` permutation modules and conic incidence codes — near-neighbors for claim 3's `[2,8,1]`/`[2,9,1]`, `P(1)=1|9|1`. Not read at text depth. |

Baseline sources (Edge, Dye, Filmus-Lindzey, Bamberg-Klawuhn, Chien-Kang, Lansdown-Martin, Srinivasan, Ghorbani et al., Hollmann-Xiang, Pan-Wu-Yin, Cameron-Korchmaros) are consumed at the read depths recorded in `notes/2026-07-20-c406-priority-audit.md` and were not re-read.

## Search record

### Exact queries (web, this pass)

```text
group cohomology H^1 PGL_2(q) symmetric power natural module defining characteristic
Stickelberger valuation Gauss sums finite field Fourier transform integral structure eigenvalues
finite Radon transform incidence matrix Smith normal form p-rank Wilson eigenvalues projective plane
projective Reed-Muller code conic evaluation covariants modulo conic ideal line bundle restriction
combinatorial design trade first nonvanishing moment cubic polarization null designs
finite Radon transform projective space p-adic integral structure Gauss sum diagonal N^2 = q modular reduction
Bardoe Sin permutation module GL(3,q) points projective plane submodule Loewy structure characteristic p
modular invariant theory transfer Reynolds operator averaging obstruction orbit size divisible by p cocycle
Smith normal form incidence matrix PG(n,q) Jacobi sums Stickelberger p-adic elementary divisors Chandler Sin Xiang
modular representation permutation module PGL(2,q) conic points secants F_p submodule Loewy projective cover
equivariant sections line bundle conic restriction exact sequence group cohomology covariants finite group
```

Each web batch returned ~8-10 result cards, screened over title/snippet. Promotions: Broer-Chuai (already cached), Sin survey, Chandler-Sin-Xiang, Yanez, arXiv:2002.04183, arXiv:1704.02417, arXiv:2209.01140, the PJM transfer paper, Bardoe-Sin, arXiv:1305.1431, arXiv:1104.0324, Gatti-Korchmaros-Schulte. No promoted card described the conic-twisted secant-decorated instance; the near-neighbor for claim 3 is a whole program (Sin school), promoted for positive pre-emption.

### Three-service counts for the load-bearing negatives

Counts are in **OpenAlex / Crossref / Semantic Scholar** order. Semantic Scholar returned **HTTP 429 (rate-limited)** on every attempt (single-query and batched, with backoff) and is **NOT COVERED** for these checks. Crossref's `query.bibliographic` endpoint is a ranked relevance search whose `total-results` scores the whole corpus loosely, so the integer is not a match count; the top-5 ranked items were screened and are all non-matching (recorded below). OpenAlex `search` counts are meaningful.

| Composition-specific query | OpenAlex | Crossref (top-5 screened) | Sem. Scholar |
|:---|:---|:---|:---|
| `affine cocycle symmetric power PGL(2,q) conic secant covariant defining characteristic` | **1** (only hit "Nets of Conics and associated Artinian algebras of length 7" — unrelated) | ranked total 6659; top-5 all unrelated (spline interpolation, conic optimization, Boolean functions) — no predecessor | NOT COVERED (429) |
| `twisted Radon transform conic stabilizer PGL Stickelberger projective cover finite field` | **0** | ranked total 19350; top-5 unrelated (codes in PGL(2,q), FRT hardware, vector-field tomography) — no predecessor | NOT COVERED (429) |
| `signed moment trade first nonvanishing cubic coboundary polarization finite field design` | **0** | ranked total 105366; top-5 unrelated (Dickson nonvanishing cubic forms, Hochschild cohomology, piezo polarization) — no predecessor | NOT COVERED (429) |

These bounded keyword negatives support "no predecessor located in the recorded coverage" for the **specific compositions** of claims 1, 3, and 4. They do **not** weaken the positive pre-emptions of the **frameworks** (claims 1, 2, 3 general mechanism, 4 layer), which rest on the promoted sources above. No forward-citation closure from a pinned seed was performed; where a negative would need one, "to our knowledge" is retained.

## Coverage gaps

- **Semantic Scholar** — HTTP 429 throughout: **NOT COVERED** for the three-service keyword checks.
- **MathSciNet** — institutional auth unavailable: **NOT COVERED**; "to our knowledge" retained on every claim it would gate.
- **zbMATH Open** — not closed claim-by-claim this pass: **NOT COVERED**.
- **Google Scholar** — blocks automated access: **NOT COVERED**.
- **arXiv:2209.01140** (defining-characteristic cohomology survey) — PDF not machine-readable this pass: NOT COVERED at depth; a defining-characteristic `H^1(G(F_q), Sym^d(std))` closure for claim 1 remains open.
- **Bardoe-Sin** and the conic-specific modular submodule papers (arXiv:1305.1431, arXiv:1104.0324) — read only at abstract/secondary depth; a text-depth read is needed before asserting the `[2,8,1]`/`[2,9,1]` and `P(1)=1|9|1` picture is absent from the conic modular literature. Currently carried as "no predecessor located," not a stronger negative.
- The **published** versions of the Sin survey and Chandler-Sin-Xiang were not separately read; the arXiv/preprint bytes were.

## Decisive question and manuscript guidance

**Is claim (1)'s affine cocycle merely the elementary change-of-base expansion in abstract language, or a genuine contribution?** Best-evidenced read: the cocycle **by itself is** the elementary expansion. Its target `H^1(PGL_2(q), Sym^{(q-3)/2})` is a computed cohomology group, and the coboundary obstruction being the orbit barycenter with `p | |orbit|` is the textbook Reynolds/transfer failure of modular invariant theory. No predecessor was located for the **specific** identification of the product-depth/quotient-depth covariance dichotomy with this cocycle class, so that composition is likely-new-within-coverage — but it is thin, and under C417's own stop rule it clears the bar **only** if the promised **portable covariance-dichotomy theorem** (valid beyond `q ∈ {5,7,11}`) says something the generic `H^1` + transfer-obstruction statements do not already give. On current evidence claim (1) leans toward "elementary repackaging" absent that portable consequence.

Ranked crown-value of the four claims after this audit: **(3) specific twisted-conic realization > (1) covariance-dichotomy theorem (only if portable) > (2) equivariant-section cohomology > (4) polarization framing**. But (3)'s **headline** must move from "we build a Stickelberger-filtered integral lattice degenerating to a modular cover" (that is the Sin program) to "we exhibit the **conic-twisted, secant/matching-decorated** instance and resolve the `[2,8,1]`/`[2,9,1]` extension class," with Chandler-Sin-Xiang / Sin / Bardoe-Sin credited.

Safe priority phrase for all four: **"no predecessor for this conic-twisted / cocycle / Stickelberger-filtered composition was located in the recorded coverage; the general Stickelberger-valuation-to-modular-cover mechanism and the modular-averaging obstruction are classical (Sin school; modular invariant theory)."**
