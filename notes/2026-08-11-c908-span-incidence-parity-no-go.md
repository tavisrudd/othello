# C908: the span-incidence residue — an exact parity no-go, integrally the identity

Date: 2026-08-11

Status: **pass-7 complete: the full span-incidence candidate library is
computed; every residue is even, and integrally every live candidate is an
exact scalar multiple `c·I_10` of the Clemens–Griffiths identity with
`4 | c`.** The channel-population question is settled negatively for the
entire product dictionary, by mechanism; the pass-6 bimodal mystery is also
closed. C908 mathematics only; no manuscript, PDF, mirror, Lean, or
C904-surface edit.

Notation as in pass 6
(`notes/2026-08-11-c908-transfer-liveness-and-span-incidence.md`). Classical
inputs are extracted with loci in
`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md` (this pass;
cited as EXT).

## 1. The exact classes (all integral, all smooth X)

- `[I] = pr_1^*C_s + pr_2^*C_s + P`, `P` the unit polarization cross tensor;
  equivalently `[I] = K_{F×F} − ψ^*Θ` and `ψ^*O_J(Θ) ≅ ω_{F×F}(−I)`. The
  sign of `P` is pinned by effectivity of `Δ·I` together with CG Lemma 10.7
  (`Δ ⊄ I`; the intersection is the reduced second-type curve `D ∼ 2K_F`);
  the unit coefficient by CG Lemma 11.6. (EXT B1. The pass-6 design's
  expected shape `[I] = ψ^*Θ − α(C_s ⊕ C_s)` is unattainable — opposite
  cross sign.)
- `σ_1|_F = K_F = 3C_s` **exactly in `H^2(F,Z)`, torsion included** (EXT
  A1/A5; the `Pic`-level version is false); `∫_F σ_{1,1} = 27` — the lines
  of a cubic surface — and `∫_F σ_2 = 18` (EXT A2; an early draft of this
  pass's spec had the two swapped and was corrected before the certificate
  ran).
- **Span = Gauss ∘ difference** (CG (13.6), EXT C1): the span map
  `g(ℓ_1,ℓ_2) = P^3(ℓ_1,ℓ_2)` satisfies `g^*O(1) = ψ^*Θ`. It is a morphism
  off the diagonal — on incident pairs its value is the tangent hyperplane
  `T_xX` (CG Lemma 12.16; independently LLPZ Example 5.7) — and one blow-up
  of `Δ` resolves it with multiplicity two:
  `g̃^*O(1) = μ^*ψ^*Θ − 2E`, `deg g = 432` (EXT C2, three independent
  confirmations; CG's 702 after (13.7) is a harmless slip).
- Hence, with `G_1 := [D_p] = g^*O(1)` and `G_2 := τ_*(g̃^*O(1)²)`:

      G_1 = ψ^*Θ = 2pr_1^*C_s + 2pr_2^*C_s − P
      G_2 = (ψ^*Θ)² − 4[Δ_F]          (μ_*E = 0, μ_*(E²) = −[Δ_F])

  and the honest geometric span-incidence class on `F³` is

      [Z_sp] = G_2 ⊗ 1 + G_1 ⊗ 3C_s + 1 ⊗ 27[pt].

  The product representative (`G_2 ↦ G_1²`) differs by `4[Δ_F]⊗1`, whose
  Künneth coefficients are all divisible by four; the two representatives
  have the same residues mod 2 (and mod 4).

## 2. The no-go theorem

> **Theorem (span-incidence parity no-go).** Let `W` be any codimension-three
> class on `(F×F)×(F×F)` of the form `pr^*[Z_sp] · pr^*[I]`, with `[Z_sp]`
> placed on any ordered triple of the four slots (either representative) and
> `[I]` on any pair. Then the `(1,5)` residue of `W` — the pass-2 §1 readout
> pushed through `Ψ = ψ_{12} × ψ_{34}` — satisfies:
> **integrally `M_int(W) = c_W·I_10` for an integer `c_W` with `4 | c_W`,
> and hence `M ≡ 0 mod 2` for every arrangement.** The transpose `(5,1)`
> channel is identical by symmetry, and pure divisor products were already
> dead (pass-6 Lemma).

The integral scalar-identity form is the rigidity theorem (pass-5 §4.2)
made concrete: the certificate observes it exactly, for all 44 arrangements
with a live route (`|c| ∈ {48,…,900}`, 2-adic valuations 2–5, minimum
exactly 2); the other 28 arrangements are integrally zero.

*Proof mechanism (five kill moves; the certificate sweeps every arrangement,
the hand analysis — recorded in the working spec before the sweep ran —
covers them structurally).* Mod 2 the dictionary collapses: `G_1 ≡ P` and

1. **Frobenius evenness.** `G_2 ≡ G_1² ≡ P² ≡ 0 mod 2`: the square of any
   integral cross tensor is twice an integral tensor (off-diagonal products
   pair under the factor swap, diagonal products pair with themselves). The
   span cycle's entire codimension-two transcendental content is even. So
   `[Z_sp] ≡ P ⊗ C_s + [pt] (mod 2)` — one cross tensor inseparably coupled
   to an incidence divisor, plus a point class.
2. **`C_s` pushes even.** `a_*C_s = 2Θ^{[4]}` and `a_*(C_s·a^*z) =
   2Θ^{[4]}∧z`, so any slot pairing `C_s` with an odd leg dies; the `C_s`
   riding with `[Z_sp]`'s surviving cross tensor lands fatally in every
   arrangement (p-side: overshoots the degree-1 budget; q-side: even
   pushforward or surface-degree overflow).
3. **Exponent two kills the `(4,1)/(1,4)` splits.** Any second leg
   `c·(z∧Θ^{[3]})` (where every point-class and `C_s²`-route lands,
   including the 27-line term) vanishes in `Q_15` for every integer `c`:
   `3(z∧Θ^{[3]}) ∈ L∧^5Λ` integrally and `[3x] = [x]` in a group of
   exponent two. Even the odd 27 dies.
4. **The p-budget.** A `(1,5)` component needs total degree exactly one on
   the first ψ-pair — a single cross leg. A live q-side needs a transverse
   degree-2 leg `a^*(z∧z')` (two cross legs on one slot from two
   different-support tensors) plus a degree-3 partner with odd pushforward;
   the at most two cross tensors available in any candidate cannot satisfy
   this together with the p-budget.
5. **Gauss factorization (conceptual summary).** `g^*O(1) = ψ^*Θ`: the span
   family's divisor content is a difference-map pullback — the family
   pass 1 killed. Beyond pullbacks, the span construction adds only the
   diagonal excess (`−4Δ_F`, even) and the 27-line point class (dead
   channel). The 27-lines local system's transcendental richness is real
   but lives in non-product Künneth structure that no cycle of this product
   dictionary expresses. ∎

## 3. Certificate

Full 6×2×6 sweep (72 candidates), wall time ~10 s, replayed from the
committed paths (independent replay: the bundle below was regenerated from
the committed script after promotion from the scratchpad where it was
developed and first run). Replay, from the repository root:

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-11-c908-span-incidence-residues.sage \
  --json notes/2026-08-11-c908-span-incidence-residues.json \
  --out notes/2026-08-11-c908-span-incidence-residues.out
```

(delete the `.sage.py` preparse debris afterwards). Controls, all asserted
in-script: `ψ_*(1⊗1) = 6Θ`; `ψ^*Θ` pullback parts `a^*Θ` with coefficient
`+1` and cross matrix `−Θ`, derived not guessed; `G_1 = ψ^*Θ` exactly (the
mutual-consistency check of `k1 = 3` with the corrected `[I]`-sign); the two
certified dead lines of pass 6; the `H^2(F,Z)` lattice
`a^*∧²Λ + Z·C_s` is **unimodular** (Gram det `+1`, validating the index-two
structure); Theorem E pin `{0, I}` — 0 violations in 72; a synthetic
positive control of the live shape gives rank 1 (the pipeline can emit
nonzero); and both readout legs surject mod 2 (first-leg `α'` rank 10,
second-leg pairing rows rank 10), so the zeros are cancellations inside the
candidates, not a dead readout. Headline rows:

| candidate                        | live (1,5) terms | `M_int`     | mod 2 |
|----------------------------------|-----------------:|-------------|-------|
| `Zsp(G=12,third=3)·I(24)` (W_A)  |               54 | `324·I_10`  | ZERO  |
| `Zsp(G=34,third=1)·I(24)` (W*)   |            18827 | `216·I_10`  | ZERO  |
| `Zsp(G=34,third=1)·I(23)`        |            18827 | `−216·I_10` | ZERO  |
| 41 further live arrangements     |                — | `c·I_10`, `4 \| c` | ZERO |
| 28 arrangements                  |                0 | `0`         | ZERO  |

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-11-c908-span-incidence-residues.sage` | `6f7f015c864884059d21f75c790aa382f8ca353fe4a21d617560588baddb323d` |
| `notes/2026-08-11-c908-span-incidence-residues.out`  | `a5106a0e8bf32a29f84c044cec5aa0e86ff30b299e3404d6ef4d8c2b85c50e0e` |
| `notes/2026-08-11-c908-span-incidence-residues.json` | `87179cf44ca0cdc7511a101add9abc896205e58afa6e96da5e682430b9c24a19` |
| input `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage` | `d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734` |

What the certificate covers: the 72 contraction verdicts, the controls, and
the scalar-identity observation. Human proofs, not certified: the class
identities of §1 (literature-anchored in EXT), the five-mechanism analysis
of §2, and the readout-reduction bookkeeping (pass-2/pass-6 machinery).

## 4. The pass-6 bimodal mystery is closed

The pass-6 open item — the unexplained `{2: 24, 8: 21}` split of
`dim span_z [E(u,z)]` over the 45 standard-basis bivectors — is solved by
the symplectic-basis probe:

- in the symplectic basis the histogram is `{2: 40, 8: 5}`, and the five
  dimension-8 bivectors are **exactly the five symplectic-pair bivectors**
  `a_k∧b_k` (the summands of `Θ`);
- the intrinsic invariant is the **Pfaffian-complement functional**
  `ℓ(u) = coefficient of u∧Θ^{[4]}` in the top wedge: the dichotomy
  `dim = 8 ⟺ ℓ(u) odd` holds exactly in both bases
  (`(2,ℓ even): 24, (8,ℓ odd): 21` standard; `40/5` symplectic).

Pass-6's failed correlate was the matrix entry `S_ij` — the wrong invariant;
the right one is the complementary Pfaffian. The split is not a coordinate
accident; it is the mod-2 geometry of `Θ^{[4]}`. Probe bundle (replay:
`nix shell nixpkgs#sage -c sage notes/2026-08-11-c908-span-histogram-invariant.sage`
from the repository root; output captured verbatim):

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-11-c908-span-histogram-invariant.sage` | `eff7632f27b08aec20fd0a2eda5094ea11b3c6578afa2a7dad753f1d9a6fc017` |
| `notes/2026-08-11-c908-span-histogram-invariant.out`  | `390c34f4a0df836bdef60daea9a36cf9c9c6c1f73ff225598ebbe59138f58a34` |

The dichotomy is certified as a finite check; a structural proof (why the
rank jumps exactly at `ℓ` odd) is not attempted here.

## 5. What this means, and the reposed target

1. The pass-6 channel-population design is settled **negatively for the
   entire span-incidence product library** — by mechanism, not census.
   Theorem E's pin was never violated; every candidate sits at `0`, and
   integrally at `c·I_10` with `v_2(c) ≥ 2`, minimum exactly 2.
2. The pass-6 liveness theorem stands: the escape lattice is fully
   reachable topologically. Pass 7 adds the exact complementary negative:
   no product cycle from the span/incidence dictionary reaches it. The
   channel produces the Clemens–Griffiths identity **over Z**, always short
   by exactly two powers of two in the best case — and the geometric
   `−4Δ_F` excess has the same valuation, a suggestive coincidence recorded
   for the successor: breaking the parity needs a correction or class of
   2-adic valuation below two.
3. The unique standing route to populating the `(1,5)` channel is
   **non-product** algebraic structure: the universal-family Chern class
   `c_4(ℰ)` — the single bit `λ` of pass-5 §6, whose plan (the degree-six
   `Bl_Δ(F×F)` model, odd legs through the 27-lines monodromy) is unchanged
   and is now known to be unavoidable rather than merely convenient.
4. Nothing regresses for the odd-degree crown: an odd witness still
   requires deck-asymmetric, non-deformation-canonical, exotic-special
   cycles (pass-5 §5) — and now provably nothing from the span-incidence
   dictionary.

## 6. Mystery ledger (EJ + TT closeout)

- **Settled:** the span map is the Gauss map of `Θ` composed with the
  difference map (classical, CG (13.6)) — the pass-6 span route was
  structurally a pullback route in disguise; its failure is a theorem with
  an exact five-part mechanism, certified across the full library.
- **Settled:** `[I] = K_{F×F} − ψ^*Θ` with unit cross term, sign pinned by
  the second-type curve; `G_2 = (ψ^*Θ)² − 4Δ_F` (diagonal excess
  multiplicity 4, closing the fiber-degree bookkeeping `20 − 4 = 16`).
- **Settled (pass-6 inheritance):** the bimodal histogram — intrinsic
  invariant `ℓ(u) = u∧Θ^{[4]} mod 2`, exact in both bases. Open remainder:
  a structural proof of the dichotomy (small, not blocking).
- **Corrected en route (before any conclusion depended on them):** the
  spec's σ-degree swap (18 ↔ 27) and the `[I]`-cross sign; both caught by
  independent checks; the certificate asserts `G_1 = ψ^*Θ`, which fails if
  either is wrong.
- **Open, sharpened:** the bit `λ` (channel population by `c_4(ℰ)`) is now
  the unique standing source. Pass-5 §6 plan unchanged.
- **Open, new lead (suggestive, not manufactured):** the uniform `4 | c`
  across all 44 live arrangements, with the `−4Δ_F` excess at the same
  valuation — is there a single divided-square mechanism forcing
  `v_2 ≥ 2` on every deformation-canonical class of this dictionary, and
  is `v_2 = 2` the true boundary? A successor could look for a canonical
  class with `v_2 = 1`.
- **Open, inherited:** the odd-witness profile of pass-5 §5.
- **Logged to the discovery track (incidental):**
  `C_s∪(−): H^1(F,Z) → H^3(F,Z)` has cokernel `(Z/2)^10` (EXT A5, from CG
  (13.2) — the matrix is `2E`), the same group as `Q_15`; whether the two
  `(Z/2)^10`s are canonically the same under `a_*`/duality is a cheap
  question with structural upside.
- **Flagged upstream (harmless):** CG's fibre count 702 after (13.7)
  should be 432 (EXT C2).
