# C262 — Lean formalization of the dihedral Burnside homomorphism and half-density theorem

**Lane**: `dihedral`
**Task**: C262 — Lean-formalize the two owed paper-level theorems of
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`:
Prop 11.1 (Φ_T Burnside homomorphism) and Thm 12.1 (periodicity + ½-density).

Target library: `lean/DihedralSchreier/`. No `sorry`, no `native_decide`.

## Manuscript content being formalized

### Prop 11.1 (§11, lines ~860–916)
Φ_T(Ω) = 𝒢(R_T(Ω)) maps finite G-sets to (ℕ₀, ⊕). Claims:
- additive under disjoint union: Φ_T(Ω ⊔ Ω') = Φ_T(Ω) ⊕ Φ_T(Ω');
- extends uniquely to a group homomorphism A(G) → (ℕ₀, ⊕) (11.1) [A(G)'s additive
  group is free on transitive G-sets];
- vanishes on 2A(G), hence factors through A(G) ⊗_ℤ F₂ (11.2);
- Cor 11.2 bulk cancellation: Φ_T(Ω) = (f mod 2)·Φ_T(G/1) ⊕ Φ_T(Ω_exc).

### Thm 12.1 (§12, lines ~917–966)
Fix n≥2, a legal triple type, split or nonsplit torus. Verdict determined by q mod 2|G|
and bounded exceptional indicators; period 8n suffices. Among admissible prime fields, the
relative Dirichlet density of P positions is ½ (and of N positions ½). Proof: h = (q∓1)/2n,
the four h mod 4 give four reduced residue classes mod 8n (q = 2nh±1, gcd(q,8n)=1);
Cor 9.1 selects exactly two of four as P; PNT/Dirichlet-density gives each class equal
density 1/φ, so relative density ½.

## Deliverables (files)

- `DihedralSchreier/Burnside.lean` — Φ_T (Prop 11.1 + Cor 11.2). **Compiles, no sorry.**
- `DihedralSchreier/Density.lean` — Thm 12.1 periodicity/residue core + Dirichlet
  infinitude. **Compiles, no sorry.**

Both wired into `DihedralSchreier.lean` (root). The full `DihedralSchreier` target builds
green (queue run `run-20260718-001415-e43c9e44`, `passed DihedralSchreier`, exit 0, plus the
trace-only aggregate gate). Changes left uncommitted for the parent session to review.

## Definitions chosen

### Prop 11.1 (Burnside.lean)

- **Target `(ℕ₀, ⊕)` = `GrundyXor`**: a type synonym of `ℕ` with an `AddCommGroup` instance
  whose `+` is `Nat.xor`, `0` is `0`, and `neg` is the identity. It is 2-torsion
  (`GrundyXor.add_self : g + g = 0`). This is exactly the paper's monoid `(ℕ₀, ⊕)` promoted
  to the abelian group it in fact is. (Instance built by supplying base `Zero`/`Add`/`Neg`
  instances first, so `nsmulRec`/`zsmulRec` can resolve — the usual bootstrap.)
- **`A(G)`'s additive group = `FreeAbelianGroup ι`**: `ι` indexes the transitive types
  `[K]`. The paper explicitly says "the additive group of `A(G)` is already free on the
  transitive `G`-sets," so this is the faithful model of the *additive* Burnside group. No
  ring multiplication is used (the paper asserts none).
- **Template table `t : ι → GrundyXor`** = the paper's `t_K = 𝒢(R(G,K,T))`.
- **`Φ_T = FreeAbelianGroup.lift t`**: the unique `AddMonoidHom`, i.e. the Grothendieck-group
  universal property the paper invokes verbatim.

### Thm 12.1 (Density.lean)

- **Candidate prime** `q = 2·n·h + s` with `s : ℤ`, `s^2 = 1` (encoding `s = ±1`, unifying
  the split `+1` and nonsplit `-1` torus families).
- **P-selections** `P_dodd_nodd = {1,2}`, `P_dodd_neven = {2,3}`, `P_deven = {0,2}` as
  `Finset (ZMod 4)`, matching Corollary 9.1's table (h mod 4).

## Theorem statements as formalized (statement-adequacy)

### Prop 11.1

- `phi_add : Φ_T (Ω + Ω') = Φ_T Ω + Φ_T Ω'` — additivity under disjoint union (⊔ = + in
  A(G)); the group op on the right is `⊕`. **Adequate** to eq. (11.1) additivity clause.
- `phi_unique` — any hom agreeing with the template table on generators equals `Φ_T`.
  **Adequate** to "extends uniquely" (Grothendieck universal property).
- `phi_two_nsmul : Φ_T (2 • Ω) = 0` and `phi_vanishes_on_twoA : ∀ Ω ∈ 2·A(G), Φ_T Ω = 0`.
  **Adequate** to "vanishes on 2A(G)".
- `phiBar : (A(G) ⧸ 2·A(G)) →+ GrundyXor` with `phiBar_mk : phiBar (mk Ω) = Φ_T Ω`.
  **Adequate** to "factors through the mod-two Burnside group `A(G) ⊗ F₂`", using the
  canonical `A(G)/2A(G) ≅ A(G) ⊗_ℤ F₂`. *Divergence:* the quotient by 2A(G) is used in
  place of an explicit `TensorProduct ℤ _ (ZMod 2)`; these are canonically isomorphic and
  the quotient is the standard concrete model, but the literal `⊗` object is not
  constructed.
- `bulk_cancellation : Φ_T (f • of free + Ω_exc) = (if Even f then 0 else t free) + Φ_T Ω_exc`.
  **Adequate** to Cor 11.2 (11.3): `f` free orbits contribute `(f mod 2)·Φ_T(G/1)`.
- `phi_add_realized`: `ofNat (grundy (S₁∪S₂)) = ofNat (grundy S₁) + ofNat (grundy S₂)` for an
  edge-disjoint split — the concrete input "Grundy values XOR over components", delegated to
  the already-certified `NodeKayles.grundy_sum`. This grounds the abstract `Φ_T` in the real
  Sprague–Grundy fact rather than an abstract free-group exercise.

### Thm 12.1

- `candidate_coprime : IsCoprime (2·n·h + s) (8·n)` in `ℤ`, for all `n`, `h`, and `s^2=1`.
  **Adequate** to `gcd(q,8n)=1` for the four reduced residue classes.
- `candidate_distinct`: for `n ≥ 1` and distinct `k₁,k₂ < 4`, `¬ 8n ∣ (q(k₂) − q(k₁))`.
  **Adequate** to "the four `h mod 4` give four distinct residue classes mod `8n`", i.e.
  the P/N verdict depends only on `q mod 8n` (period `8n`).
- `card_P_* = 2`, `card_compl_* = 2`, `card_classes : Fintype.card (ZMod 4) = 4`.
  **Adequate** to Cor 9.1's "exactly two of the four classes are P" (and two N), for each of
  the three legal triple types.
- `candidate_primes_infinite : ∀ N, ∃ p > N, p.Prime ∧ (p:ℤ) ≡ 2·n·h + s [ZMOD 8n]` — mathlib
  Dirichlet. `P_and_N_primes_infinite` bundles a P-class and an N-class. **Reachable form**
  of the analytic claim.

## Density gap (precise, not a self-declared trust boundary)

The paper's numerical conclusion "relative Dirichlet density of P = 1/2" is **not derivable
in current mathlib**. mathlib has the qualitative Dirichlet theorem
(`Nat.forall_exists_prime_gt_and_zmodEq`, `Nat.infinite_setOf_prime_and_modEq`: infinitely
many primes in every reduced residue class) but **no quantitative equidistribution / density**
result (searched: no `natDensity`/`logDensity`/Dirichlet-density of prime sets; the L-function
machinery in `NumberTheory/LSeries/PrimesInAP.lean` stops at infinitude). The missing input is
exactly the statement "each reduced class mod `8n` has density `1/φ(8n)` among primes." What is
delivered instead: the exact residue classification (2 of 4 P, 2 of 4 N — `card_*`), the
reduced-class property (`candidate_coprime`), the periodicity (`candidate_distinct`), and
infinitude of both P-class and N-class primes (`candidate_primes_infinite`). Closing the gap
to the `1/2` value requires importing/formalizing prime equidistribution in AP.

## Axiom profiles (`#print axioms`)

All headline declarations depend only on `[propext, Classical.choice, Quot.sound]`:
`Burnside.{phi, phi_of, phi_add, phi_unique, phi_two_nsmul, phi_vanishes_on_twoA, phiBar,
phiBar_mk, bulk_cancellation, phi_add_realized, GrundyXor.nsmul_eq_ite}`,
`Density.{candidate_coprime, candidate_distinct, card_compl_dodd_nodd, candidate_primes_infinite,
P_and_N_primes_infinite}`. `Density.card_P_dodd_nodd` depends only on `[propext, Quot.sound]`.
No `sorryAx`, no `Lean.ofReduceBool`/`native_decide`.

## What remains open

- The quantitative density value `1/2` (needs prime equidistribution in AP; see gap above).
- Optional strengthening of `phiBar` to the literal `A(G) ⊗_ℤ (ZMod 2)` tensor object.
- The other unformalized paper items unchanged (Lemma 2.1 projection bridge, Thm 7.2 graph
  isos, ladder/prism Grundy evaluations, template nimbers, finite-field orbit counts).
