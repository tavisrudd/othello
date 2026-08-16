# Adversarial check of the owed-lemmas note on Poincaré-pairing horizontality

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

Target: `notes/2026-08-15-c912-owed-lemmas.tex`, which claims to prove — over the Novikov
ring, with no convergence hypothesis and no passage to a complex-analytic bundle — that the
Poincaré pairing is horizontal for the A-model connection, thereby discharging the step that
`notes/2026-08-15-c912-atom-residue-proof-verification.md` (Check B) found was not an
available import for `notes/2026-08-15-c912-atom-residue-proof.tex`.

Hostile pass. Every convention was re-checked against the pinned source bytes, and the
frame-transfer step was recomputed rather than read off.

## Overall verdict: **MAJOR REVISION**

The two lemmas and the theorem are correct. The horizontality statement the earlier
verification asked for is genuinely established, coefficientwise, with no archimedean input —
for the **whole even A-model bundle in the global cohomology frame**. That is real and citable.

The corollary is not. `cor:for-atom` is the only part of the note that connects the theorem to
what the atom proof actually uses, and it contains a false step: the target's equations (4),
(7)–(11) are written in a frame of the atom's **even rank-two spectral factor**, which differs
from the global frame by a `u`-dependent gauge, and in that frame the pairing matrix is **not**
the constant Gram matrix. Separately, the corollary needs an item the note itself defers.
So the note does not yet discharge the step it was written to discharge, though the repairs
are short and are spelled out below.

## Sources

| Source | Version | Cache key | SHA-256 |
|---|---|---|---|
| Katzarkov–Kontsevich–Pantev–Yu, *Birational Invariants from Hodge Structures and Quantum Multiplication* | arXiv:2508.05105**v2** | `arXiv:2508.05105` | `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64` |

Re-extracted with `pdftotext -layout`; read at §3.5.1 (GW classes and their properties, Def.
3.25–Notation 3.27), §3.5.2.1 (Lemma 3.29 through Def. 3.32, including (3.30) and (3.31)),
§4.1 (Theorem 4.1, Remark 4.2), §5.2.2 (`U_X`), §6.4 (pairing definition, items (a)–(d)).

---

## Item 1 — `lem:frobenius` (Frobenius over the Novikov ring): **SURVIVES**, with four narrowings

**(a) The symmetry claim is correct on the even part, and the Koszul parenthetical is right.**
Permuting three even classes among themselves is sign-free irrespective of the other
insertions, so total symmetry of `⟨a,b,c,τ,…,τ⟩` in `a,b,c` holds with no signs.

The *reason given* is a misstatement dressed as a definition. KKPY's moduli stack `M_{0,n}(X,β)`
has ordered marked points; the Gromov–Witten class `I_{n,β}(X)` is `S_n`-invariant as their
**property (iii)** (cited to Kontsevich–Manin), and it is that invariance which lets them label
by an unordered finite set `J`. The note asserts the unordered labelling as the definition and
derives symmetry from it, which inverts the logic. Cite property (iii).

**A strictly better proof is available and the note half-states it.** KKPY *define* `⋆` by
contracting `∂³Φ/∂t_a∂t_b∂t_c` with `PD^{-1}` (§3.5.2.1, immediately before (3.30)), so
`(a ⋆_τ b, c) = ∂_a∂_b∂_c Φ` and total symmetry is commutativity of even partial derivatives —
tautological. In KKPY's own construction Frobenius is therefore an **import**, not a lemma
("the quantum product … tautologically satisfies the properties (i)-(v)"). The note's second
remark says exactly this and should be promoted to the proof.

**(b) The displayed structure-constant formula is correct, including the `1/m!`.** From KKPY
(3.26), `Φ = Σ_{n,β} (q^β/n!) Σ ⟨T_{i_1}···T_{i_n}⟩_β t_{i_1}···t_{i_n}`; three derivatives
select `n(n−1)(n−2)` ordered slots, and `n(n−1)(n−2)/n! = 1/m!` with `n = m+3`. The bulk
insertions and the `Q^d ↔ q^β` identification match. ✔

**`τ` must be even, and the note does not say so.** For odd `τ` the correlator sum acquires
exterior-algebra signs and, more seriously, `H^ev ⊗ Λ` is not closed under `⋆_τ` (an odd number
of odd bulk insertions produces odd output). KKPY's base `B_X` contains a purely odd factor
`B_X^odd`, so this is not vacuous — it is legitimate only because the Hodge-fixed base
`B_X^G` is purely even (§5.2.2). State the hypothesis and the reason.

**(c) The identity is coefficientwise, and there is no smuggled limit.** ✔ No archimedean
convergence anywhere.

**But "over the Novikov ring" mis-locates the object.** KKPY's non-archimedean A-model
F-bundle is `H = H^•(X) ⊗_k O_{B_X × D}` over an admissible open of
`T_k(X)^an × (polydisk)`, and `Φ` is an *analytic* function there (their Lemma 3.29) — non-
archimedean convergence is used to build the object, even though none is used for the
identity. The note proves a `Λ`-module statement and never says how it transfers to
`O_{B_X × D}`-modules. The transfer is one sentence (same global frame `{T_i}`, same structure
constants as convergent series, `O`-bilinear extension of the pairing, `PD^{-1}` constant per
§3.5.2.1), but this is precisely the gap the note exists to close, so it must be written.

**(d) The Euler operator worry does not land — checked at the source.** KKPY (3.31):
`Eu_γ = c_1(TX) + ((Deg − 2·id)/2)(γ) ∈ T_{Bσ,γ} ⊂ H_γ`. `Eu` is a *cohomology class* at each
base point, and (3.30) writes the `u`-direction connection as
`∇_{∂u} = ∂_u − u^{-2}(Eu ⋆ (−)) + u^{-1}(Deg − dim X·id)/2` — an `O`-linear multiplication
operator with **no derivation term**. So `U = Eu ⋆_τ` really is quantum multiplication by a
class and self-adjointness follows from Frobenius. ✔

The concern is well-founded in general: in Dubrovin-style conventions where the Euler *vector
field* acts on the base as a derivation, the step fails. The note writes its (1) with no
citation. A note whose entire purpose is to replace a mis-described citation must pin (1) to
KKPY (3.30)–(3.31) explicitly.

## Item 2 — `lem:grading`: **SURVIVES**

**Computation correct.** Poincaré pairs `H^k` with `H^{2n−k}`, and
`½(k−n) + ½(ℓ−n) = ½[(k+ℓ) − 2n] = 0` when `k + ℓ = 2n`. ✔

**The `−n/2` remark is correct.** Replacing `Gr` by `Gr + cI` gives defect `2c(a,b)`, nonzero
for `c ≠ 0` on a non-degenerate pairing. Note the claim is about the *additive* constant only:
rescaling the `½` preserves anti-self-adjointness, and the remark as phrased says the right
thing.

**Novikov-linearity is the right convention and it matches the source and the target.** KKPY
(3.30) define `Deg = ⊕_a a·id_{H^a(X)}` on `H^•(X)` alone, extended `O_{B_X × D}`-linearly; the
Kähler/Novikov variables `q_j` are **base** directions with their own connection
`∇_{∂q_j} = ∂_{q_j} + u^{-1} q_j^{-1}(ω_j ⋆ (−))`, not part of `Gr`. The atom proof uses the
same convention throughout (Cai's `G` matrices are constant), and the earlier verification
already confirmed the two match character-for-character. **No mismatch.**

**Why there is no repeat of the `[μ, U] = U` failure.** That identity was false because
`Q^d` carries degree `2 c_1·d` while `μ` is `Λ`-linear. Nothing here needs any commutator
identity — only adjointness — so the degree of `Q^d` is simply irrelevant to this proof. Worth
stating the converse explicitly, because it makes the convention load-bearing in the *other*
direction: had `Gr` included `Q∂_Q`, it would **not** be anti-self-adjoint for the
`Λ`-bilinear pairing (`(Q∂_Q a, b) + (a, Q∂_Q b) = Q∂_Q(a,b) ≠ 0`). The `Λ`-linear convention is
the one under which the lemma is true, and it is KKPY's.

## Item 3 — `thm:horizontal`: **SURVIVES**, with a presentational fix

- `u∂_u` invariance: with `w = −u`, `u∂_u = u(dw/du)∂_w = −u∂_w = w∂_w`. ✔
- Bracket: `A(u) = u^{-1}U − Gr`, `A(−u) = −u^{-1}U − Gr`, so
  `A(u)^T P_0 + P_0 A(−u) = u^{-1}(U^T P_0 − P_0 U) − (Gr^T P_0 + P_0 Gr)`. ✔ Exactly as displayed.
- **Sign consistency between (1) and (2) holds.** `∇_ξ y = 0` gives `ξ y = −u^{-1}C_ξ y`, so
  `B_ξ(u) = −u^{-1}C_ξ` is the correct reading of (1), and `B_ξ(−u) = +u^{-1}C_ξ` gives
  `B_ξ(u)^T P_0 + P_0 B_ξ(−u) = −u^{-1}(C_ξ^T P_0 − P_0 C_ξ) = 0`. ✔ The suspected invisible
  inconsistency is not there.

Two defects, neither affecting the mathematics:

1. **"Horizontal sections" do not exist in this category.** The connection is irregular at
   `u = 0`; over `Λ`-modules there is no fundamental solution, so `y, ỹ` are fictitious and the
   "Equivalently" is not an equivalence. What is actually proved, and what is actually used
   downstream, is the matrix identity (3) — equivalently `∇`-preservation of `ψ` in KKPY's
   sense, `dψ(ξ_1,ξ_2) = ψ(∇ξ_1,ξ_2) + ψ(ξ_1,(ν^*∇)ξ_2)` (§6.4). State the theorem that way.
2. **The base-direction step silently uses that `P_0` is constant along the base.** True in
   KKPY's global frame (§3.5.2.1: `PD^{-1}` "is constant in the frame `{T_i}` and therefore
   analytic"), but unstated.

## Item 4 — `cor:for-atom`: **REFUTED as stated**; the conclusion survives by the target's own argument

**The precise false step:** "Theorem `thm:horizontal` gives it with `P(u) = P_0` constant."

`thm:horizontal` is proved in the global cohomology frame `{T_i}`, where the connection matrix
is exactly `u^{-1}U − Gr` — two terms, no tail. The target's (4) and (7) are written in a frame
of the atom's **even rank-two spectral factor**, where `A(u) = u^{-1}N + A_0 + uA_1 + ⋯` has an
infinite tail. Those frames are not the same frame: the spectral factor is a `u`-dependent
subbundle (KKPY Theorem 4.1 / Remark 4.2 — the decomposition extends a splitting of `H_{b,0}`,
the fibre at `u = 0`, over a neighbourhood), reached from the global frame by a gauge
`F(u) = I + F_1 u + F_2 u² + ⋯`. Writing `F|` for the columns spanning the factor,

    P(u) = F|(u)^T P_0 F|(−u).

With `P_0` block-diagonal (spectral orthogonality) and `F_n` block-off-diagonal, this expands to

    P(u) = (P_0)|_block − u² Σ_{J ≠ block} (F_1)_{J,block}^T (P_0)_{JJ} (F_1)_{J,block} + O(u³),

which is **not constant**: the `u²` term is generically nonzero. The corollary's claim that the
Gram matrix of the pairing on the factor is the constant `P_0` is false.

**The `P_1 = 0` sub-claim is accidentally true in the gauge the manuscript uses, for a reason
the note does not give.** The same expansion gives `P_1 = 0` because the order-`u` term is
`(F_1^T P_0 − P_0 F_1)|_block`, and `F_1` block-off-diagonal against `P_0` block-diagonal kills
it. That is a statement about the Sylvester gauge (the one the verification's cubic
recomputation used), not about the pairing: an arbitrary further frame change `G(u) = I + uG_1`
within the factor sends `P_1 ↦ P_1 + G_1^T P_0 − P_0 G_1`, generically nonzero. So `P_1 = 0` is
**frame-dependent**, and asserting it is exactly the "pairing-preserving block-splitting gauge"
the target explicitly declines to assume (its §1, after (11)).

**Nothing downstream breaks.** The target's derivation of (8) and (11) never uses `P_1 = 0`:
the `u^{-1}` coefficient is `N^T P_0 − P_0 N = 0` regardless, and sandwiching (10) between
`x ∈ ker N` kills both `P_1` terms (`x^T N^T P_1 x = (Nx)^T P_1 x = 0` and `x^T P_1 N x = 0`),
leaving `2 x^T P_0 A_0 x = 0` and hence `A_0 L ⊂ L`. The earlier verification checked this with
general `P(u)`. So the sandwich argument still gives `A_0 L ⊂ L` with a `u`-dependent pairing.

**Repair (short).** Delete the `P(u) = P_0` claim. Replace it with: the induced pairing on the
factor is `P(u) = F|(u)^T P_0 F|(−u)`, whose `u⁰` term is the restriction of the Gram matrix —
symmetric and non-degenerate by spectral orthogonality — and whose higher terms are
unconstrained; then observe that (8) and (11) need only `P_0` symmetric non-degenerate with
`N^T P_0 = P_0 N`. Optionally add the one-line remark that `P_1 = 0` in the block-off-diagonal
gauge, flagged as gauge-dependent bookkeeping rather than as a property of the pairing.

**Checked against the F-bundle definition, not just quantum D-modules.** KKPY §6.4 define a
non-degenerate pairing on an analytic F-bundle as an even `O_{B×D}`-**linear** map
`ψ : H ⊗ ν^*H → O_{B×D}`, symmetric in the twisted sense `ψ(ξ_1,ξ_2) = (ν^*ψ)(ξ_2,ξ_1)`,
inducing `H ≅ ν^*H^∨`, and `∇`-preserved. `u`-dependence of the Gram matrix is *permitted by
the definition*; only the A-model instance in the global frame is constant. The twisted
symmetry is also what gives the target `P(u)^T = P(−u)`, i.e. `P_0` symmetric and `P_1`
antisymmetric — which the note never derives and which the target's (11) uses.

## Item 5 — Scope: **UNSUPPORTED**, and the corollary needs an item the note defers

The theorem covers the whole even bundle. Three further steps stand between it and the object
the atom proof manipulates, and none is in the note:

1. **Descent to a spectral factor.** Importable from KKPY §6.4 verbatim — "by definition
   non-degenerate pairings are compatible with the spectral decomposition of F-bundles. This
   immediately gives induced pairings on `G`-atoms" — or provable here in two lines from
   `lem:frobenius`: `U` self-adjoint makes distinct generalized eigenspaces of `U` orthogonal at
   `u = 0`, and the `u∂_u`-flatness of `ψ` then forces `H_λ ⊥ ν^*H_μ` for `λ ≠ μ` (the leading
   terms `u^{-1}λ` and `−u^{-1}μ` must cancel for `ψ(s,t)` to be regular). The note has every
   ingredient and assembles none of them. **Assumed, not proved.**
2. **Non-degeneracy and symmetry of the induced `P_0` on the even rank-two factor**, which the
   target's (9) (`L^⊥ = L`) requires. The earlier verification listed this as "unstated but
   needed"; the note's own "Still owed" list omits it. Add it.
3. **The even part as a sub-F-bundle** — the note's own owed item (i). The corollary is about
   the *even* rank-two factor, so it cannot be claimed until (i) is discharged. **The suspected
   circularity is real**: `cor:for-atom` depends on an item the note defers. The fix is one
   sentence (KKPY §5.2.2: `B_X^G` is purely even, so every base direction in play is even and
   `C_δ` preserves parity; `Gr` and `Eu ⋆` likewise), but it must move from "Still owed" into
   the corollary's hypotheses.

Add to that the `Λ`-vs-`O_{B_X × D}` mis-location from item 1(c): as written the note proves a
statement about `Λ`-modules, while the atom proof works on a `k`-analytic F-bundle over `B_X`.

## What may now be treated as proved

- `lem:frobenius` and `lem:grading` as stated, on `H^ev(T) ⊗ Λ` with **even** bulk parameter.
  Both are convergence-free and archimedean-free. Frobenius is better cited as tautological in
  KKPY's construction (`⋆` defined by contracting `∂³Φ` with `PD^{-1}`) than proved.
- `thm:horizontal` in its matrix form (3), for the **whole even A-model bundle in the global
  cohomology frame**, over `Λ` — and, after the missing one-sentence transfer, for the
  non-archimedean analytic A-model F-bundle over `B_X`. This does replace the
  convergence-dependent citation to KKPY §6.4(a) that the earlier verification flagged, at the
  level of the ambient bundle. The target may cite it instead of §6.4(a).
- The note's characterization of what KKPY defer (the Euler-pairing comparison and the Serre
  automorphism) is accurate and is untouched by any of this.

## What the atomic residue proof still owes after this note

1. The frame/spectral-factor transfer: (7) on the atom's even rank-two factor, with `P(u)`
   allowed to be `u`-dependent — i.e. the version the target already writes. The note must not
   assert `P_1 = 0`.
2. Orthogonality of distinct spectral factors and non-degeneracy plus symmetry of the induced
   `P_0` on the even rank-two factor.
3. The even part as a sub-F-bundle (note's owed item (i)), which the corollary consumes.
4. The note's remaining owed items (ii) uniqueness/gluing of the spectral splitting,
   (iii) the identity principle on irreducible `k`-analytic spaces, (iv) descent through the
   blowup, projective-bundle and disjoint-union equivalences.
5. Unchanged and still the only genuinely conditional input: KKPY Example 6.21's assertion that
   the eigenvalue-`0` packet does not split further at the hyperplane point, i.e. `b ∈ U_X`.

## Mystery ledger

| Surprise | Status |
|---|---|
| `P_1 = 0` is asserted without argument and turns out to be true anyway | **Settled.** It holds in the block-off-diagonal Sylvester gauge because `P_0` is block-diagonal, and fails under a generic `u`-dependent frame change within the factor. Gauge bookkeeping, not a property of the pairing — which is why the corollary's stated derivation of it is still a false step |
| The full pairing is constant in the global frame, yet the target insists on `P(u) = P_0 + uP_1 + ⋯` | **Settled.** The spectral factor is a `u`-dependent subbundle; the induced Gram matrix picks up `−u² Σ F_1^T P_0 F_1` at order two. The target's generality is correct and the note's constancy claim is what is wrong |
| A note written to close a citation gap cites nothing | **Open, presentational.** (1) is never pinned to KKPY (3.30)–(3.31), and the Euler-operator step is convention-sensitive: it is right in KKPY's convention and would be wrong in a Dubrovin-style one where the Euler vector field acts as a base derivation |
| The note's "Still owed" list omits non-degeneracy of `P_0` on the even factor, which its own corollary needs | **Open.** Owner: whoever revises `cor:for-atom` |
