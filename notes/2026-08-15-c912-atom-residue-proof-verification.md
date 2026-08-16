# Verification of the rank-two atomic residue proof of the unconditional `m = 1` theorem

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912 · **Purpose:**
independent verification of the rank-two atomic residue proof.

Target: `notes/2026-08-15-c912-atom-residue-proof.tex`, which claims that for every
smooth cubic threefold `X` the fourfold `X × P^1` is irrational, unconditionally,
importing only the ordinary non-enhanced Hodge-atom results of
Katzarkov–Kontsevich–Pantev–Yu (KKPY, arXiv:2508.05105v2).

This is a hostile pass. Every source claim was checked against the pinned bytes; both
residue computations were recomputed from scratch rather than read off the target.

## Overall verdict: **MAJOR REVISION**

No false step was found. Both discriminating numbers were reproduced independently, and
the two sign/normalization conventions genuinely agree. The proof is not fatally broken.
It is not yet the unconditional theorem it advertises, for three reasons, in decreasing
severity:

1. The parity ranks `(2, 10)` of the cubic atom — which is what forces the competitor to
   be a genus-five curve — rest on KKPY's Example 6.21 asserting that the eigenvalue-`0`
   packet does **not** split further near the hyperplane point `b`. That assertion is a
   worked example, not a theorem; its cited support (Remark 3.14) contains no proof and
   controls only the restriction `κ|_W` to the Witt-orbit germ, not `Eu ⋆ (−)` on `H^•`.
   Equivalently: `b ∈ U_X` is asserted, not proved.
2. Step 1 (the pairing step) uses the horizontality of the Poincaré pairing on the
   **non-archimedean** A-model F-bundle. KKPY state that horizontality only after
   assuming convergence and passing to the complex-analytic F-bundle. The extension is
   routine and the target says so in one sentence — but it is the target's own lemma,
   not an import, and must be stated and proved as such.
3. Several load-bearing steps are unstated: that the even part is a sub-F-bundle; that
   the spectral splitting is unique and therefore glues over the component; that the
   identity principle is available on an irreducible `k`-analytic space; and that
   `χ^♯` descends through the *extra* elementary equivalences that define `HAtoms`
   (disjoint union, blowup, projective bundle) and not only through Definition 5.21's two.

## Sources and read depth

| Source | Version | Depth | Cache key | SHA-256 |
|---|---|---|---|---|
| Katzarkov–Kontsevich–Pantev–Yu, *Birational Invariants from Hodge Structures and Quantum Multiplication* | arXiv:2508.05105**v2** | full text of §3.4–3.5.2, §5.2.2, §5.2.6, §5.3.2, §5.4, §6.4, Ex. 6.17–6.21; re-extracted with `pdftotext -layout` | `arXiv:2508.05105` | `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64` |
| Cai, *The cubic threefold is symplectically irrational* | arXiv:2608.01577**v1** | full text (§3 cubic, §4 Riemann surfaces), re-extracted with `-layout` | `arXiv:2608.01577` | `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e` |

Our-side files read: the target proof; `papers/cubic-stabilization-epilogue/sections/04-one-step.tex`
(Proposition `prop:cubic-packet`); `notes/2026-08-15-c912-h47h-source-exactness-audit.md` §4;
spot checks against `notes/2026-08-15-c912-frame-transport-memo.tex`.

---

# Part I — the three checks most likely to kill it

## Check A. Sign and normalization — **SURVIVES, cleanly**

**Verdict: the cubic and the curve are computed in the same convention, with the same
grading sign and the same loop coordinate. `(39)` is a legitimate comparison.**

Both sides reduce to the single normal form

    u ∂_u Y = ( u^{-1} U − Gr ) Y ,     Gr = (Deg − dim X · id)/2 ,

with `U` the Euler operator `Eu ⋆ (−)` and `u = z` the same disc coordinate traversed in
the same direction. The chain closes at three independent points:

1. **KKPY's own A-model connection (3.30), p. 30 of the extraction, verbatim:**

   > `∇_∂u = ∂_u − u^{-2}(Eu ⋆ (−)) + u^{-1} (Deg − dim X · id)/2`

   with `Deg = ⊕_a a · id_{H^a(X)}`. Horizontal sections therefore satisfy
   `u ∂_u Y = (u^{-1} Eu⋆ − Gr) Y`, i.e. `u^2 ∂_u Y = (Eu⋆ − u·Gr) Y`. So a system
   written as `z^2 ∂_z S = (K + zG) S` is in KKPY's convention exactly when `K = Eu⋆`
   and `G = −Gr`.

2. **Cai §3, verbatim:** `∇_z^{t=0} = ∂_z − z^{-2}(c_1(X) ⋆) + z^{-1} μ_X`, and then
   `z^2 ∂_z S = (K + zG) S` with `K = 2·[...]` and `G = (1/2)diag(3,1,−1,−3)`. So Cai's
   `K = c_1(X)⋆ = Eu⋆` at the small point, and `G = −μ_X`. For `dim X = 3`,
   `Gr = diag(−3/2, −1/2, 1/2, 3/2)` in the basis `1, P, P², P³`, so
   `−Gr = (1/2)diag(3,1,−1,−3)` — **character-for-character Cai's `G`**. The manuscript's
   `prop:cubic-packet` reproduces both matrices identically. Cubic side confirmed.

3. **Cai §4, verbatim** (the curve, which the target's (36) cites): the Riemann surface
   `Σ_g`, `g > 0`, has

   > `z² ∂_z S = (2 − 2g) [[0,0],[1,0]] S + (z/2) [[1,0],[0,−1]] S`

   i.e. `z² ∂_z S = (a E_21 + z·diag(1/2, −1/2)) S` with `a = 2 − 2g`. Dividing by `z`
   gives exactly the target's (36), `u ∂_u Y = [u^{-1} a E_21 + diag(1/2,−1/2)] Y`. And
   `diag(1/2,−1/2) = −Gr` for `dim = 1`, since `Gr = diag((0−1)/2, (2−1)/2) = diag(−1/2, 1/2)`.
   **Same convention, from the same paper, as the cubic block.**

The grading normalization `μ(φ) = (deg φ/2 − dim/2)φ` checks against both targets: `dim 1`
gives `(−1/2, 1/2)` and `dim 3` gives `(−3/2, −1/2, 1/2, 3/2)`, and in each case the
matrix appearing in the target is `−Gr`, not `Gr`.

**A non-trivial consistency witness.** `tr R = tr A_0 − 1` on both sides, and `tr A_0 = 0`
on both sides (`tr D_0 = 0`; `tr(−Gr)|_{rank 2 curve block} = 0`). So `tr R_X = tr R_C = −1`.
Two computations run in mismatched conventions would generically not agree in the trace;
they do. The entire discrimination in (39) is carried by the determinant, `5/36` versus
`9/36`, and the determinant difference comes from the single product
`ν · (A_1)_{21} = 2 · (−8/81) = −16/81`. That product is invariant under rescaling `e_2`
(`ν` scales up, `(A_1)_{21}` scales down), so it is intrinsic, not a frame artefact.

**No mismatch found. (39) stands.**

## Check B. Is the Poincaré pairing the deferred object? — **SURVIVES, with a narrowing**

**Verdict: no. The Poincaré pairing is not the Euler pairing, and it is not what KKPY
defer. But KKPY state its horizontality only for the complex-analytic F-bundle under a
convergence assumption, so the target's step 1 is its own lemma, not an import.**

Three findings, in order.

1. **The Poincaré pairing is already a building block of KKPY's non-archimedean
   construction.** In the construction of the non-archimedean A-model F-bundle
   (their §3.5.2, immediately before Definition 3.32), verbatim:

   > "let `H = H^•(X) ⊗_k O_{B_X × D}` be the trivial analytic vector bundle on `B_X × D`
   > with fiber `H^•(X) ⊗_k k`. Note that our chosen basis of `H^•(X)` gives a global
   > frame of `H` … **The inverse `(g^{ij})` of the Gram matrix of the Poincaré pairing
   > gives a section `PD^{-1} ∈ H^0(B_X × D, H ⊗ H)`. The section is constant in the
   > frame `{T_i}` and therefore analytic.**"

   The quantum product itself is defined by contracting `∂³Φ` against `PD^{-1}`. So the
   Poincaré pairing exists, is constant, and is analytic on the non-archimedean A-model
   F-bundle by KKPY's own construction. It is not a structure that has to be imported
   from the archimedean theory.

2. **The Poincaré pairing and the Euler pairing are different objects.** KKPY §6.4(c)
   defines the Euler pairing `χ(a,b) = ⟨√td(X) ⌣ a, √td(X) ⌣ b⟩` via the Mukai pairing,
   builds the "F-bundle Euler pairing" from it by half-circle parallel transport, and
   then proves that for exponential type it **coincides** with the Poincaré-duality
   pairing. The sentence the prior audit flagged —

   > "**Extra work is required to carry out this comparison for the non-archimedean
   > A-model F-bundles**, and this will be discussed in more detail in [49]."

   — is attached to that word *comparison*. What is deferred is the identification of the
   two pairings in the non-archimedean case, plus (in (d)) the Serre/duality automorphism,
   which needs a Riemann–Hilbert correspondence KKPY say is unavailable non-archimedean.
   The target uses neither. **The sharpest available kill does not land.**

3. **The narrowing that is real.** KKPY's horizontality statement (their §6.4(a)) is
   preceded, verbatim, by:

   > "Let now `X` be a complex smooth projective variety. **Assume for simplicity that the
   > quantum product is convergent and so we have a complex analytic version `(H,∇)/B_X`
   > of the A-model maximal F-bundle for `X`.** In this case we have
   > `H_u := H|_{B×{u}} = H^•_B(X,C) ⊗ O_B`, and we can define `ψ_u` … to be the
   > `O_B`-linear extension of the Poincaré pairing …"

   and then (a): "The pairing `ψ` is preserved by the connection `∇`. Indeed, in the
   `u`-direction we have `∇_∂u = ∂_u − u^{-2}Eu⋆(−) + u^{-1}Gr`, the operators `Eu⋆(−)`
   and `Gr` are independent of `u`, and by definition `Eu⋆(−)` is selfadjoint with respect
   to the Poincaré pairing while `Gr` is anti-selfadjoint …"

   The target's sentence — "KKP(Y) record exactly this calculation; it is algebraic in the
   quantum product and therefore applies equally to their formal/non-archimedean A-model" —
   is a correct mathematical claim but a misdescription of the citation. The convergence
   assumption is explicit in the source and the conclusion is stated for the complex
   analytic object.

   The claim is nevertheless true, and re-derivable in two lines over the Novikov ring:
   `Gr` is anti-self-adjoint because Poincaré pairs `H^a` with `H^{2d−a}` and
   `(a−d)/2 + (b−d)/2 = 0` when `a+b = 2d`; `Eu ⋆ (−)` and `ξ ⋆ (−)` are self-adjoint
   because the quantum product is Frobenius, `(a⋆b, c) = (a, b⋆c)`, an identity of formal
   Gromov–Witten generating functions with no convergence content. Neither uses
   archimedean input.

   **Required repair:** state the horizontality of `ψ` on the non-archimedean A-model
   F-bundle as a lemma of the target with that two-line proof, citing KKPY §3.5.2 for the
   trivialization and constancy of `PD^{-1}` and KKPY §6.4(a) for the archimedean
   template — not as an imported theorem.

   The companion statement the target also uses, that pairings are compatible with the
   spectral decomposition and so induce pairings on atoms, **is** stated in the general
   analytic setting (KKPY §6.4, verbatim: "non-degenerate pairings are compatible with the
   spectral decomposition of F-bundles. This immediately gives induced pairings on
   `G`-atoms."). Non-degeneracy on the single atom factor additionally needs `Eu⋆`
   self-adjointness, which orthogonalizes distinct generalized eigenspaces — fine, but
   again the target's own step.

   **One presentational point.** KKPY open §6.4 by listing "pairings" among the
   *enhancements*. The target's disclaimer — "the pairing is not being added to the atom
   as enhancement data" — is defensible, since the pairing is used only to derive property
   (11) of the un-enhanced object and is then discarded, and no pairing-preservation is
   demanded of the isomorphisms in (30). But a referee will read §6.4's opening sentence
   first, so the target must say explicitly that (11) is a property of the atom, provable
   from an auxiliary structure, and that no morphism in the atom category is required to
   respect it.

## Check C. Are the imported statements ordinary, and do they say what is claimed?

| Import | At source | Verdict |
|---|---|---|
| Definition 5.21 (two equivalences) | "(1) Two geometric `G`-atomic F-bundles are equivalent if the `G`-atomic F-bundles are isomorphic. (2) … `AX,b1,b̃1` and `AX,b2,b̃2` arising from the same variety `X` are equivalent if `b̃1` and `b̃2` belong to the same connected component of `Ũ_X`." | SURVIVES — as quoted, ordinary, non-enhanced |
| Proposition 5.22 (atoms → geometric atomic F-bundles) | "We have a map from the set `Atoms^K_G` … to the set `Atoms^{K,F}_G` sending each connected component `Ũ_{X,α}` to a `G`-atomic F-bundle `A_{X,b,b̃}` …" Proof checks the three additivity properties, which "hold almost tautologically … statements (2) and (3) follow again from Theorems 4.5 and 4.11." | SURVIVES, but see the gap below: the target checks descent through Def. 5.21 only, while `HAtoms` is a quotient by more relations |
| Proposition 5.23 (invariance of the Hodge representation) | "For a `G`-atom … the isomorphism class of the `G_k`-representation `A\|_{b,u=0}` is well-defined and independent of the choice of the representative." Proof: rigidity of finite-dimensional representations of a proreductive group. | SURVIVES — ordinary, proved, gives the parity ranks and the total rank as invariants |
| Lemma 5.24 (nef `K_X` ⟹ one atom) | "Let `X` be a connected complex smooth projective variety with a numerically effective canonical class. Then `HAtoms(X)` consists of a single atom `η(X)`. *Proof.* This is a special case of Lemma 5.18." Lemma 5.18 **is** proved, by a virtual-dimension count on `∂³Φ`. | SURVIVES — ordinary and proved |
| Proposition 5.30 (non-rationality criterion) | "Let `X` be a smooth complex projective variety of dimension `d ≥ 2`. Suppose we have a Hodge atom `α` which appears in the atomic decomposition of `X` and is such that `α ∉ HAtoms_{dim ≤ d−2}`. Then `X` can not be a rational variety. *Proof.* This is a special case of Proposition 5.17." Proposition 5.17 **is** proved, from weak factorization plus `CF(P^d) = (d+1)·CF(pt)`. | SURVIVES — the bound is exactly `d−2` and the hypothesis is exactly as used. **This is the numbered, ordinary criterion, not the unnumbered enhanced one.** A genuine strength of this route over the earlier framed-monodromy route, which needed the asserted enhanced form |
| Projective-bundle chemical formula | Proposition 5.22 proof, item (3): "`CF^F_G(P(V)) = r · CF^F_G(X)`", following from Theorem 4.11 | SURVIVES, with the caveat the prior audit already recorded: Theorem 4.11 is stated over analytic domains and its proof "reduces the non-archimedean statement to the formal version, **which is shown by Iritani-Koto in [45, Theorem 5.1]**" — so this import is not independent of Iritani–Koto |
| Point-blowup formula | Proposition 5.22 proof, item (2): `CF^F_G(X̂) = CF^F_G(X) + (r−1)·CF^F_G(Z)`; at `r = 2`, `Z = pt`, this is the target's (41) | SURVIVES |
| Example 6.21 (cubic atomic composition) | "the atomic composition of `X` consists of three atoms — two one dimensional atoms corresponding to non-zero eigenvalues of `Eu⋆(−)`, and one atom `α(X)` corresponding to the eigenvalue 0. **The Witt algebra argument from Remark 3.14 shows that there is no further splitting in a neighborhood of `b`.**" | **UNSUPPORTED at theorem strength.** See below |

### The Example 6.21 problem, stated precisely

The *composition into `1 + 1 + 12`* is independently verifiable and I verified it:

- On the even part, `Eu⋆ = c_1 ⋆ = 2P ⋆` has eigenvalues `{6r, −6r, 0, 0}` where
  `r = (3q)^{1/2}` — visible in the block form `K_0` I recomputed below.
- On the odd part, `Eu ⋆ α = 0` **exactly** for `α ∈ H³(X)`, by a degree count that needs
  no citation: the Novikov-degree-`d` term of `c_1 ⋆ α` lies in `H^{3+2−2c_1·d} = H^{5−4d}`,
  and `H^5 = H^1 = 0` while `d ≥ 2` gives negative degree. So the whole of `H³` sits in the
  eigenvalue-`0` packet.
- Hence the `0`-packet has rank `2 + 10 = 12`, parity `(2, 10)`, as the target's (32) says.

What is **not** established is that this packet is a single *atom*. An atom is a connected
component of the unramified reduced spectral cover `Ũ_X` over
`U_X ⊂ B_X^G`, and KKPY define `U_X` (§5.2.2, verbatim) as

> "the open locus where the number of eigenvalues of `Eu|_{B_X^G} ⋆ (−)` is maximal, i.e.
> the locus over which the reduced cover `B̃_{X,red} → B_X^G` is unramified."

So the target needs `b ∈ U_X`, i.e. the eigenvalue count locally constant at `b`. Example
6.21 supplies exactly that — by assertion. Its cited support, Remark 3.14, reads verbatim:

> "let `(H,∇)/B` be a maximal F-bundle, and let `b ∈ B^ev ⊂ B` be a rigid even point of
> `B`. Then there exists a unique germ `W ⊂ B^ev` at `b` … s.t. `span_k{Eu^k_w}_{k≥0} = T_{W,w}`
> … The number of distinct eigenvalues of **`κ|_W : T_W → T_W`** and the list of their
> multiplicities are constant on a neighborhood of `b ∈ W`. Moreover, **more fine results
> can be proved**, like, e.g., …"

Two defects, both confirmed at the source. First, Remark 3.14 carries **no proof**, and
the string "Witt algebra" does not occur in it — in arXiv:2508.05105v2 it occurs only in
Examples 6.19 and 6.21, which cite Remark 3.14 for an argument Remark 3.14 does not
contain. Second, Remark 3.14's constancy statement is about `κ` restricted to the tangent
space `T_W` of the Witt-orbit germ `W`, and constancy is asserted *along `W`*, whereas
`U_X` is a locus in `B_X^G`. Reading the number of distinct eigenvalues of `κ|_W` as the
number of distinct eigenvalues of `Eu⋆` on `H^•` is defensible (each spectral block
contributes its eigenvalue to the cyclic subspace generated by the unit), but constancy
along `W` is weaker than local constancy on `B_X^G`.

**Consequence for the target.** The theorem does not rest on KKPY's Serre argument — the
target correctly disclaims that — but it does rest on Example 6.21's no-further-splitting
claim, which is neither a theorem nor proved. Without it there is no rank-12 atom `α(X)`
and (32) collapses, taking (35) and (40) with it. The target's front matter, "The only
external atom-theoretic inputs are the ordinary, non-enhanced Hodge-atom results of
KKP(Y)", must be amended: one of the inputs is an assertion inside a worked example.

**Partial mitigation worth recording.** If the even `2×2` packet did split into distinct
eigenvalues `λ₁ ≠ λ₂` near `b`, the odd part would carry a single eigenvalue `λ₀`
(`Eu⋆` commutes with the `Hod(Q)`-action on `B_X^{Hod}`, and `H³(X,Q)` is an irreducible
Hodge structure for a general cubic threefold, so `Eu⋆|_{H³}` is scalar by Schur). If
`λ₀ ∉ {λ₁, λ₂}` the odd part would be a purely odd atom with no even unit vector,
contradicting KKPY's Proposition 5.28 (`ρ_α ≥ 1`). So the only surviving degeneration is
`λ₀ ∈ {λ₁, λ₂}`, giving parity ranks `(1, 10)` and `(1, 0)`. That does not close the gap,
but it narrows what a proof would have to exclude, and it is a cheap thing for the target
to add.

---

# Part II — the mathematics, step by step

## 1. Eqs (7)–(11), the pairing step — **SURVIVES**

Re-derived from scratch, not read off.

- **(7) is the right convention.** With `ψ` pairing `H_u` against `H_{−u}`, set
  `P(u)_{ij} = ψ(e_i(u), e_j(−u))`. For horizontal `s = e·y`, `t = e·w` one has
  `ψ(s(u), t(−u)) = y(u)^T P(u) w(−u)`, and `u∂_u[w(−u)] = A(−u) w(−u)` since
  `u∂_u = v∂_v` under `v = −u`. Constancy gives
  `u∂_u P + A(u)^T P(u) + P(u) A(−u) = 0`. **Exactly (7).**
- **(8).** `u^{-1}` coefficient: `N^T P_0 − P_0 N = 0`. ✔
- **Isotropy.** `(Nx, Ny) = x^T N^T P_0 N y = x^T P_0 N² y = 0` by (8) and `N² = 0`. ✔
- **(9).** `L` isotropic, `dim L = 1`, `P_0` non-degenerate on a 2-space ⟹ `L^⊥ = L`. ✔
- **(10).** `u^0` coefficient: `A_0^T P_0 + P_0 A_0 + N^T P_1 − P_1 N = 0`. ✔
- **(11).** Sandwiching (10) between `x ∈ ker N`: the two `N`-terms die; using `P_0^T = P_0`
  (KKPY's super-symmetry `ψ(ξ1,ξ2) = (ν*ψ)(ξ2,ξ1)` gives `P(u)^T = P(−u)`, hence
  `P_0^T = P_0` and `P_1^T = −P_1`), the remaining terms are `2 x^T P_0 A_0 x = 0`, so
  `A_0 x ⊥ x` and `A_0 x ∈ L^⊥ = L`. ✔

- **"Centering by (2) does not alter horizontality" — TRUE, and for the stated reason.**
  `A°(u) = A(u) − λ u^{-1} I`, so `A°(−u) = A(−u) + λ u^{-1} I`, and the two scalar terms
  cancel in `A°(u)^T P + P A°(−u)`. Same in base directions:
  `B°_δ = B_δ ∓ (δλ) u^{-1} I` with opposite signs at `u` and `−u`. ✔ Requires only that
  `λ` be a scalar function of the base, which it is.

- **Unstated but needed:** that `P_0` restricted to the *even* part of the atom is
  non-degenerate. True — Poincaré pairs `H^a` with `H^{2d−a}`, same parity — but the target
  never says it, and the whole of §1 is about the even factor.

- **Unstated but needed:** that the even part is a sub-F-bundle. True, because `B_X^G` is
  purely even (KKPY §5.2.2: "the fixed point locus `B_X^G` is a **purely even** connected
  closed non-archimedean **smooth** `k`-analytic subvariety in `B_X`"), so every base
  direction `δ` in play is even and `C_δ` preserves parity. Must be stated.

## 2. Eqs (12)–(17), the elementary modification — **SURVIVES**

- `E^♯ = {s ∈ E : s mod u ∈ L}` has basis `(e_1, u e_2)` in the frame (13), so
  `S = diag(1, u)`. ✔
- `(S^{-1} M S)_{ij} = s_i^{-1} M_{ij} s_j`, so `S^{-1}E_{12}S = u E_{12}` and
  `S^{-1}E_{21}S = u^{-1}E_{21}`. ✔ Leading `u^{-1}N = ν u^{-1}E_{12}` becomes `ν E_{12}`. ✔
- **Pole bookkeeping, recomputed.** In the frame (13), `N_{21} = 0`, so
  `A_{21}(u) = (A_0)_{21} + u(A_1)_{21} + O(u²)`, and
  `(A^♯)_{21} = u^{-1}(A_0)_{21} + (A_1)_{21} + O(u)`. The **only** possible pole is
  `u^{-1}(A_0)_{21}`, and (11) says exactly `(A_0)_{21} = 0`. ✔ Every `u^m A_m`, `m ≥ 1`,
  loses at most one power of `u`. ✔
- **The order-one term does survive into the residue.** `R_{21} = (A_1)_{21}`. This is why
  `−8/81` is load-bearing, and it is the *only* place a non-diagonal contribution reaches
  the determinant. ✔ Confirmed by direct expansion, and confirmed again by the fact that
  `R_X`'s eigenvalues reproduce the manuscript's independently-derived indicial exponents
  (below).
- `R_{12} = ν` exactly: the `A_0` contribution to the `(1,2)` slot carries a factor `u`. ✔
- **Intrinsicness.** Under `F(u) ∈ GL_2(O[[u]])`, `R ↦ F(0)^{-1} R F(0)` since
  `u∂_u F ≡ 0 mod u`. Any frame change of `E` must carry `L` to `L` (`L = im N` is
  intrinsic), so `F(0)` is triangular in an adapted basis and descends to `E^♯`. ✔

## 3. Eqs (18)–(28), flatness makes `χ^♯` constant — **SURVIVES, with one narrowing to state**

Flatness (6) re-derived: `δ(u∂_u y) = u∂_u(δ y)` gives
`δA − u∂_u B_δ + [A, B_δ] = 0`. ✔

- **(18)** `u^{-2}`: `[N, C_δ] = 0`. ✔
- **(19)** `u^{-1}`: `δN + C_δ + [N, C_{δ,0}] + [A_0, C_δ] = 0`. ✔
- **(20)** `tr C_δ = 0`: follows since `tr N = 0` and traces of commutators vanish. ✔
  **I stress-tested this on the curve, because it looks too strong.** For `δ = ∂_t` (the
  `H^0` direction) the *uncentered* `C_δ = 1⋆ = I` has trace 2. The resolution is the
  centering: `C_δ^{centered} = (δλ)I − δ⋆`, and `δλ = ½ tr(δ⋆)` by the flatness identity
  `δU = C_δ + [C_δ, Gr]`, so the trace is zero. On the curve, `U = a E_21 + t·I`, `λ = t`,
  `δλ = 1`, `C_δ^{centered} = I − I = 0`. Consistent. **(20) is correct.**
  *Incidental, logged for the discovery track, not a defect in the target:* KKPY's
  displayed Euler vector field (3.31), `Eu_γ = c_1(TX) + ((Deg − 2·id)/2)(γ)`, has the
  opposite sign on the non-`c_1` part from the standard `E = c_1 + Σ(1 − deg/2)t^i T_i`;
  with their sign the flatness identity `δU = C_δ + [C_δ, Gr]` fails on the genus-`g`
  curve, and with the standard sign it holds. The target never uses (3.31), so nothing
  here is affected.
- **(21)** `C_δ = q_δ N`: the commutant of a nonzero rank-one nilpotent `2×2` matrix is
  `O·I ⊕ O·N`; `tr C_δ = 0` kills the `I` part. ✔ **This requires `N ≠ 0`.** The target
  does not restate the restriction in §3, having stated it in §2. It is used only on
  `𝔘^× = {N ≠ 0}`, and §4 then does the crossing-point work, so the logic is intact —
  but §3 should say "on `𝔘^×`" at (21), because a reader checking (21) at a zero of `N`
  will find it false.
- **(22)** `S` is base-independent in the chosen frame, so `B^♯_δ = S^{-1}B_δ S` with no
  `δS` term; `u^{-1}q_δ N` becomes regular, `u C_{δ,1}` stays regular, and the only pole
  is `u^{-1}(C_{δ,0})_{21}E_{21}`. ✔
- **(24)–(26)** `[R, k_δ E_{21}] = k_δ [[ν,0],[d−a,−ν]]`, so the `(1,1)` entry of (24) is
  `ν k_δ`; `ν` a unit forces `k_δ = 0`. ✔ Recomputed.
- **(27)–(28)** `u^0` of (23): `δR + [R, G_δ] = 0`. Then `δ tr R = 0`,
  `δ tr(R²) = 2 tr(R[G_δ,R]) = 0`, `det R = (tr²R − tr R²)/2`. ✔

## 4. Eq (29), the crossing-point argument — **SURVIVES, with unstated inputs**

This is the step that replaces the globalization that defeated earlier attempts, so it
deserves the most scepticism. It holds, but for reasons the target under-states.

- **Is a connected component of `Ũ_X` integral? YES, and the source says so directly.**
  KKPY §5.2.2, verbatim: "the fixed point locus `B_X^G` is a purely even connected closed
  non-archimedean **smooth** `k`-analytic subvariety in `B_X`", and `U_X` is "the locus
  over which the reduced cover `B̃_{X,red} → B_X^G` is **unramified**". Unramified over
  smooth ⟹ `Ũ_X` smooth ⟹ locally irreducible ⟹ each connected component is irreducible.
  The target's argument ("locally a disjoint union of eigenvalue branches; consequently a
  connected component is smooth and locally irreducible") reaches the right conclusion by
  a slightly weaker route; citing the source's own "smooth" is stronger and shorter.
- **Does the maximal-eigenvalue locus cover the whole component? YES, by definition:**
  `Ũ_X := B̃_{X,red} ×_{B_X^G} U_X`, so every point of `𝔘` lies over `U_X`. The target's
  phrasing invites the objection but the objection does not land.
- **Are the coefficients genuinely meromorphic across `{N = 0}`? YES, and more simply than
  the target argues.** Since `N ≠ 0` generically and `N² = 0`, `im N` is spanned by a
  nonzero column of `N`, giving a meromorphic frame `(e_1, e_2)` on all of `𝔘`. In that
  frame `R` has entries `(A_0)_{11}`, `ν = N_{12}`, `(A_1)_{21}`, `(A_0)_{22} − 1` — all
  coefficients of the connection matrix in a meromorphic frame, hence meromorphic on `𝔘`.
  So `c_0 = det R` and `c_1 = −tr R` lie in the meromorphic function field of `𝔘`.
- **The logic.** `c_i` is meromorphic on the irreducible `𝔘` and equals a constant on a
  nonempty open subset of `𝔘^×`; therefore `c_i − const` vanishes identically. Distinct
  components of `𝔘^×` cannot disagree. ✔ Valid.
- **The unstated analytic input** — and this is exactly the shape of hypothesis that
  blocked a previous attempt in this lane — is the **identity principle on an irreducible
  non-archimedean `k`-analytic space**: a section of `O` vanishing on a nonempty admissible
  open vanishes. This is standard for irreducible rigid/Berkovich spaces, but it is an
  input, it is not cited, and it is not the trivially-true statement it would be over `C`.
  **Must be stated with a citation.**
- **A second unstated input:** the target treats `E`, `N`, `L`, `A_0`, `A_1` as globally
  defined over `𝔘`, whereas KKPY's atomic F-bundle is a *germ* at each point. At `u = 0`
  the gluing is explicit in KKPY (Proposition 5.23's proof constructs a subbundle
  `A ⊂ H|_{U_X × {u=0}}` over `U_X`). For the higher `u`-order data one needs uniqueness of
  the spectral splitting, which holds because the eigenvalues are distinct over `U_X`
  (Sylvester/Hukuhara–Levelt–Turrittin uniqueness). True, cheap, and absent.

## 5. Eq (30) and the rank-two atomic residue lemma — **SURVIVES with a gap in the descent claim**

- **Isomorphism invariance is correct.** For `F : (E,∇) → (E',∇')` regular and invertible
  at `u = 0`, `A' = F^{-1}AF − F^{-1}u∂_u F`, whose `u^{-1}` coefficient is
  `N' = F(0)^{-1} N F(0)`. So `F(0)` carries `L` to `L'` and `E^♯` to `E'^♯`, and the
  induced residues are conjugate. ✔
- **Descent through Definition 5.21(1) and (2)** — (30) and (29) respectively. ✔
- **GAP.** `HAtoms` is *not* the quotient by Definition 5.21's two relations alone. KKPY
  §5.4, verbatim: `HAtoms := (⊔_{[X]} π_0(Ũ_X)/Aut(X)) / ∼`, "where … the equivalence
  relation `∼` is generated by the elementary equivalences corresponding to **disjoint
  unions, blowups with smooth centers, and projective bundles**." The target's lemma claims
  well-definedness on the ordinary Hodge atom but only checks Definition 5.21. The gap is
  fillable — Proposition 5.22's proof realizes each elementary equivalence by an
  isomorphism of the geometric atomic F-bundles (via Theorems 4.5 and 4.11), which (30)
  covers — but as written the lemma is not proved for the object it names, and this matters
  because the competitor comparison is precisely an identification across two different
  varieties.
- **Proposition 5.22 is used in the right direction.** The argument needs only
  well-definedness of atoms → geometric atomic F-bundles, not injectivity. ✔

## 6. Eqs (31)–(32), the Chern class computation and parity ranks — **SURVIVES**

Recomputed. `c(TX) = (1+H)^5/(1+3H)`: coefficients `1`, `5−3 = 2`, `10−15+9 = 4`,
`10−30+45−27 = −2`, so `c(TX) = 1 + 2H + 4H² − 2H³` ✔ and `c_3 = −2H³`. With
`∫_X H³ = 3`, `χ_top = −6` ✔. Lefschetz plus Poincaré duality give
`b_0 = b_2 = b_4 = b_6 = 1`, `b_1 = b_5 = 0`, so `4 − b_3 = −6` and `b_3 = 10` ✔.

"A one-dimensional atom is necessarily even" — correct, and the citation is KKPY
Proposition 5.28, whose proof is: the fiber of an atom is a nonzero unital commutative
associative superalgebra, so it contains a nonzero even `Hod_Q(Q)`-invariant vector,
namely its unit. ✔

Hence `(2, 10)` for `α(X)` — **conditional on Example 6.21's no-splitting assertion**, per
Part I, Check C. The `1+1+2` split of the even part and the annihilation of `H^odd` are
both independently verified above.

## 7. Eqs (33)–(34), the cubic residue — **SURVIVES, independently recomputed**

I recomputed the block reduction from Cai's `K_X`, `G_X` **without using the target's or
the manuscript's intermediate numbers**: applied the manuscript's constant basis change
`C` (checking `det C = −486 r^5`), then solved the Sylvester recursion for the unique
formal gauge `A(z) = I + Σ A_n z^n` with block-off-diagonal `A_n`, blocks `1|1|2`, and read
off the rank-two block of `M(z) = A^{-1}[(K_0 + zG_0)A − z²A']`:

    M_0 block = [[0, 2], [0, 0]]                  = J_0
    M_1 block = [[-19/18, 0], [0, 19/18]]         = D_0
    M_2 block = [[0, -14/(81 r^2)], [-8/81, 0]]   = E_0
    M_3 block = [[0, 0], [0, -4/(81 r^2)]]

**Exact agreement** with the manuscript's (4.9e), including the off-diagonal `−14/(81r²)`
that the target does not use. `(E_0)_{21} = −8/81` ✔, `ν = 2` ✔.

Then `λ = ½ tr J_0 = 0`, `N = J_0 = 2E_{12}`, `L = ⟨e_1⟩`, `S = diag(1, z)`, and

    R_X = 2E_12 + D_0 + (E_0)_21 E_21 − diag(0,1)
        = [[−19/18, 2], [−8/81, 1/18]]

`tr R_X = −19/18 + 1/18 = −1` ✔, `det R_X = −19/324 + 16/81 = 45/324 = 5/36` ✔, so
`χ^♯ = T² + T + 5/36 = (T + 1/6)(T + 5/6)` ✔ — **(33) and (34) confirmed.**

**Independent cross-check that the modification is the right one.** The eigenvalues of
`R_X` are `−1/6, −5/6`, which are exactly the roots `ρ` of the manuscript's indicial
equation (4.9g), derived there by a completely different route (the ansatz
`S̃_3 = z^ρ(1+O(z))`, `S̃_4 = c z^{ρ+1}`). That the canonical elementary modification
converts the nilpotent-leading system into a regular-singular one whose residue spectrum
*is* the exponent pair is a strong structural check on §2.

## 8. Eqs (36)–(38), the curve residue — **SURVIVES, independently recomputed**

- "For `g ≥ 1` there are no nonconstant genus-zero maps to `C`, so the genus-zero quantum
  product is the classical cup product" ✔ — and this holds for the *big* product too, since
  the `β = 0`, `n ≥ 4` genus-zero invariants vanish. So `⋆_τ = ∪` at every point of
  `B_C^{Hod}`.
- `Eu = c_1(TC) + t·1 = ap + t·1` on the Hodge locus (the `H²` coordinate has grading
  weight `1 − deg/2 = 0`), so `U = Eu⋆ = a E_21 + t·I`, `λ = t`, `N = a E_21`. ✔ The number
  of distinct eigenvalues is `1` everywhere, so `U_C = B_C^{Hod}` and `Ũ_C` is connected of
  degree 1 — consistent with Lemma 5.24's single atom. ✔
- (36) matches Cai §4 **verbatim** after dividing by `z` (see Check A). ✔
- `L = im(aE_21) = ⟨e_2⟩`, `S = diag(u, 1)`,
  `R_C = aE_21 + diag(1/2, −1/2) − diag(1,0) = aE_21 − ½ I`, `χ^♯_C = (T + ½)²`. ✔
  Verified against Cai's fundamental solution `(z^{1/2}, (2−2g)z^{-1/2}log z; 0, z^{-1/2})`:
  in the modified lattice `Y^♯ = (u^{-1}Y_1, Y_2) ∼ u^{-1/2}(I + a log u · E_21)`, so the
  modified exponents are `−1/2` twice, with the log reflecting the Jordan block. ✔
- **`g = 1` is genuinely moot.** At `g = 1`, `a = 0`, `N = 0`, and `χ^♯` is undefined — but
  `g = 1` gives parity `(2, 2) ≠ (2, 10)` and is excluded before `χ^♯` is invoked. The
  target says "For `g > 1`, `a ≠ 0`" and never uses `g = 1`; the ordering is correct. Only
  `g = 5` (`a = −8`) is ever needed. ✔
- (39): `(T + ½)² = T² + T + ¼ = T² + T + 9/36 ≠ T² + T + 5/36`. ✔ Note the traces agree
  and only the determinants differ, which is the convention witness discussed in Check A.

## 9. Eqs (41)–(42), the surface exclusion — **SURVIVES**

- Point blowup removes only point atoms: `CF(Bl_p S) = CF(S) + CF(pt)` is KKPY's blowup
  formula at `r = 2`, `Z = pt`. ✔ Every smooth projective surface is a sequence of point
  blowups of a minimal one, so by induction `α(X)`, having total rank 12 ≠ 1, must already
  occur on a minimal model. ✔
- Nef minimal model: Lemma 5.24 gives one atom carrying all of `H^•(S)`; its even part
  contains `H^0`, an ample class in `H²`, and `H^4`, so even rank ≥ 3 > 2. ✔
- Non-nef minimal surface: by the surface classification, `P²` or a geometrically ruled
  `P_C(V)`. ✔ Then `CF(P²) = 3·CF(pt)` and `CF(P_C(V)) = 2·CF(C)` by the projective-bundle
  formula. ✔ Both give point or curve atoms, excluded. ✔
- Disconnected and lower-dimensional cases are covered by additivity over disjoint unions
  and by the rank-1 exclusion of point atoms. ✔

## 10. Eq (43) and the conclusion — **SURVIVES**

`X × P^1 = P_X(O^{⊕2})` with `r = 2`, so `CF(X × P^1) = 2·CF(X)` and `α(X)` occurs with
multiplicity ≥ 2 > 0. ✔ `d = 4`, `d − 2 = 2`, and (42) is exactly
`α(X) ∉ HAtoms_{dim ≤ 2}`. Proposition 5.30 applies as stated, in its **numbered, ordinary
form**. ✔

---

# What may be cited, and at what strength

**May be cited now, at full strength:**

- The convention reconciliation of Check A. Both the cubic block and the curve block are in
  the normal form `u∂_u Y = (u^{-1}U − Gr)Y` with `Gr = (Deg − dim)/2`, and both come from
  Cai in the same convention, which is KKPY's (3.30). The comparison in (39) is sound.
- The independently recomputed cubic block data `J_0 = [[0,2],[0,0]]`,
  `D_0 = diag(−19/18, 19/18)`, `(E_0)_{21} = −8/81`, and `R_X = [[−19/18, 2], [−8/81, 1/18]]`
  with `tr = −1`, `det = 5/36`, `χ^♯ = (T+1/6)(T+5/6)`. Replay command and script below.
- The curve residue `R_C = aE_21 − ½I`, `χ^♯_C = (T+½)²`, cross-validated against Cai §4's
  fundamental solution.
- The algebraic content of §§1–3: eqs (7)–(11), (18)–(28) are correct as derived, with
  (21) restricted to `{N ≠ 0}`.
- The observation that this route needs only KKPY's **numbered** Proposition 5.30, not the
  unnumbered enhanced criterion, and not the Serre automorphism. That is a genuine and
  citable improvement over the framed-monodromy route.

**May be cited only as conditional / with the hypothesis named:**

- The rank-two atomic residue lemma, pending: the Poincaré-pairing horizontality lemma
  being written out for the non-archimedean A-model F-bundle; the even part being declared
  a sub-F-bundle; the identity principle being cited; and descent being checked through the
  blowup/projective-bundle/disjoint-union equivalences as well as Definition 5.21's two.
- The parity ranks `(2, 10)` of `α(X)`, and therefore the headline theorem, pending KKPY's
  Example 6.21 no-further-splitting assertion — or a proof of `b ∈ U_X` for the cubic.

**May not be cited:** the front-matter claim that the only external atom-theoretic inputs
are "results" of KKPY. One input is an assertion inside a worked example.

## External inputs the theorem rests on, after repair

1. KKPY Definition 5.21, Propositions 5.22, 5.23, 5.28, 5.30 (via 5.17), Lemma 5.24 (via
   5.18) — all ordinary, all proved in the source.
2. KKPY's blowup and projective-bundle chemical formulas, i.e. Theorems 4.5 and 4.11.
   Theorem 4.11's proof reduces to **Iritani–Koto, Theorem 5.1**, so this is not
   independent of the Iritani–Koto machinery, contrary to the impression the target gives.
3. KKPY Example 6.21's atomic composition of the cubic, including no further splitting at
   the hyperplane point. **Asserted, not proved.**
4. KKPY §3.5.2 (the non-archimedean A-model F-bundle, its global frame and constant
   `PD^{-1}`) and §6.4 (pairings compatible with spectral decomposition), plus the target's
   own extension of §6.4(a) to the non-archimedean setting.
5. The identity principle on irreducible non-archimedean `k`-analytic spaces.
6. Weak factorization (Abramovich–Karu–Matsuki–Włodarczyk), inside KKPY's Proposition 5.17.
7. The classification of minimal surfaces, and the Enriques/Mori dichotomy for non-nef
   minimal models.
8. Cai's small even quantum connection of the cubic threefold and his genus-`g` curve
   connection, arXiv:2608.01577v1 §§3–4. The block reduction from them is reproduced
   independently here and in the manuscript.
9. All of KKPY is an arXiv preprint, unrefereed.

## Replay

The block-reduction recomputation was run as a standalone script under
`uv run --with sympy`; it takes only Cai's `K_X`, `G_X`, the manuscript's constant basis
change `C`, and the block partition `1|1|2`, and solves the Sylvester recursion itself.
Output reproduced verbatim in §7 above. The script is not committed here because it is
scratch verification of an already-committed manuscript computation
(`papers/cubic-stabilization-epilogue/sections/04-one-step.tex`, (4.9a)–(4.9e)); if this
verification is ever cited as evidence rather than as review, the script must be committed
under `notes/scripts/` per `notes/research-reproducibility-conventions.md`.

## Mystery ledger

| Surprise | Status |
|---|---|
| `tr R_X = tr R_C = −1`, so the whole theorem hangs on the determinant alone | **Settled.** `tr R = tr A_0 − 1` and `tr A_0 = 0` on both sides for structural reasons (`tr D_0 = 0`; `Gr` is traceless on each rank-two block). Not a coincidence, and it is a useful convention witness rather than a defect |
| `R_X`'s eigenvalues coincide with the manuscript's indicial exponents `ρ` from a different derivation | **Settled.** The canonical modification is precisely what converts the nilpotent-leading system to regular-singular form, so its residue spectrum is the exponent pair. Structural, and a strong check on §2 |
| KKPY's Euler vector field (3.31) carries the opposite sign to the standard convention on the non-`c_1` part | **Open, but harmless here.** With their sign the flatness identity `δU = C_δ + [C_δ, Gr]` fails on the genus-`g` curve; with the standard sign it holds. The target never uses (3.31). Logged as an incidental source observation, provenance arXiv:2508.05105v2 (3.31), p. 30 of the `-layout` extraction |
| Example 6.21 cites a "Witt algebra argument from Remark 3.14" that Remark 3.14 does not contain | **Open and load-bearing.** Confirmed at the source: "Witt algebra" occurs in arXiv:2508.05105v2 only in Examples 6.19 and 6.21. Owner: whoever writes the `b ∈ U_X` argument for the cubic |
| Why the odd part cannot detach into its own atom under a hypothetical splitting | **Partially settled** by KKPY Proposition 5.28 (`ρ_α ≥ 1`) plus `Hod`-equivariance of `Eu⋆` on `B_X^{Hod}`. Narrows the degeneration to `λ_0 ∈ {λ_1, λ_2}`; does not close it |
