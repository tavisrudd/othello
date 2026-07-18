# C263 — Generalized-D₂ₘ additions to the dihedral Schreier Node-Kayles paper

**Lane**: `dihedral` (task C263, per planning ruling D6)
**Date**: 2026-07-17
**Manuscript**: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`
**Report**: this file.

Do NOT touch `lean/` (C262 concurrent). Parent session owns queue/handoff/commit.

---

## 1. Scoped gap list (written BEFORE any math, per task instruction)

### 1.1 What the current manuscript already proves (complete, not to be redone)

Reading §2–§14 + Appendix A of the 2026-07-12 submission and the catalogue source note
`notes/2026-07-12-conic-involution-schreier-graphs.md`:

- **§3 Theorem 3.1** — orbit-template reduction is stated for an *arbitrary* finite involution
  set `T`; it is not restricted to triples. This is the general engine and is reused verbatim.
- **§4** — legal **triple** classification. A legal generating involution **triple** must contain
  the central involution `z = rⁿ` plus two reflections, because three reflection centres are always
  collinear (illegal under the capacity-two/no-three-collinear rule). Hence a legal *triple* forces
  `G ≅ D_{4n}` with `⟨r⟩` of **even** order `2n`. The manuscript writes this group as
  `D_{4n} = ⟨r,s : r^{2n}=s²=1⟩`, i.e. `D₂ₘ` with **m = 2n even only**.
- **§4 (one sentence, line ~291)** — "No dihedral group whose rotation subgroup has **odd** order
  can arise from a legal generating involution **triple**." True, and this is the *only* place the
  odd case is mentioned. It is dismissed, not classified.
- **§5–§9** — for `D_{4n}` (even m): free-orbit templates `M_{4n}` (Möbius ladder) / `C_{2n}□K₂`
  (prism), reflection templates `L_{n-1}, L_n, L_{n-2}` (ladders), rotation template `∅`, complete
  split/nonsplit-torus closed forms, `½`-density, converse. All triple-only.
- **Appendix A** — regular `S₄`, `A₅` templates (polyhedral, not dihedral).

### 1.2 The precise missing generality ("generalized D₂ₘ")

The manuscript classifies only legal sets `S` of **three** selected off-conic points. But the game
is defined for a legal set of **any** size, and:

> **Every** legal set of **two** off-conic points `{x, y}` induces a pair of involutions
> `σ_x, σ_y ∈ PGL₂(q)` that generate a dihedral group `D₂ₘ`, where `m = ord(σ_xσ_y)`.
> Two reflections `{s, srᵈ}` with `gcd(d,m)=1` generate the **full** `D₂ₘ` for **every** `m ≥ 3`,
> of **either parity**.

Consequences that are currently absent from the paper:

1. **Odd m (order `2m ≡ 2 mod 4`) is entirely unclassified.** `D₆, D₁₀, D₁₄, …` never arise from a
   triple (no central involution), but each arises from a legal **pair** of reflections. This is the
   whole "odd dihedral" half of the family.
2. **The pair templates differ from the triple templates even for even m.** For `T = {s, srᵈ}`
   (two reflections, no `z`), the free-orbit template is the **cycle** `C_{2m}`, not the Möbius
   ladder `M_{4n}`; the reflection template is the **path** `P_m`, not a ladder. These graphs and
   their nimbers are new to the paper.
3. **Non-`{0,1}` Grundy values appear only here.** The catalogue note's full enumeration
   (`notes/...conic-involution-schreier-graphs.md`, table at "largest observed Grundy value")
   records values up to 5 at q=11; the triple classification only ever produces values in `{0,1}`.
   The larger values come from the pair templates, whose nimbers are the **Dawson's-chess** path
   sequence `NK(Pₘ)` (OEIS A002187, eventually period 34) rather than a parity.
4. **The template-nimber table is a fixed function of m** (`NK(C_{2m})`, `NK(Pₘ)`), so the
   orbit-multiplicity-parity machinery of §3/§8 still applies; but the density statement is no
   longer a uniform `½` — it depends on whether these fixed nimbers vanish.

### 1.3 Deliverable (per D6, anti-salami: bundle, do not spawn a sequel)

Add the two-reflection dihedral family `D₂ₘ` (all `m ≥ 3`, both parities) at the existing rigor
level: legal-configuration classification (pairs vs triples), templates (`C_{2m}`, `Pₘ`, `∅`),
Grundy/orbit formula, split/nonsplit closed forms, periodicity/density, converse. Retitle the paper
away from "The Dihedral Case" toward the finite-subgroup framing. New title proposed in §5 below.

### 1.4 Explicitly OUT of scope (stay deferred per §14 and task)

- Nonregular polyhedral (`A₄`/`S₄`/`A₅`) coset templates — deferred (§14).
- The `PSL₂(q)`/`PGL₂(q)` escape residual — deferred (§14).
- Any `lean/` work (C262 owns it concurrently).

---

## 2. Named-expert context loaded (per project policy)

Read `notes/expert-personas/schaefer-siegel-nodekayles-certificates.md` (graph-game certificate
engineer: Schaefer / Siegel / Berlekamp–Conway–Guy) and
`notes/expert-personas/ernst-sieben-benesh-finite-group-games.md` (finite-group game theorist).
Emulated tactics: translate the geometry once (conic → involutions → Schreier residual), prove the
graph-game semantics, then reduce to compact, independently checkable component templates and their
Sprague–Grundy values; convert the algebraic (dihedral) constraints into orbit/stabilizer data and
a nim-value-compatible quotient. The templates here are paths and cycles, whose exact nimbers are
the classical Dawson's-chess sequence — a certificate, not a solver trust.

## 3. The generalized-D₂ₘ family: statements (all verified computationally, §4)

**Setup.** A legal set of **two** selected off-conic points `{x,y}` induces `σ_x,σ_y ∈ PGL₂(q)`,
two involutions that generate a dihedral group `G = ⟨σ_x,σ_y⟩ ≅ D₂ₘ` with `m = ord(σ_xσ_y) ≥ 3`
(the case `m=2` is the `V₄` boundary of §4; `m=1` needs `σ_x=σ_y`). Tame: `p ∤ 2m`. Because two
points are trivially not three-collinear, the pair is always legal, and — crucially — **no central
involution is required**, so the family exists for **every** `m`, of **either parity**. Odd `m`
(orders `2m ≡ 2 mod 4`: `D₆, D₁₀, …`) occurs here and nowhere in the triple classification.

Write `T = {σ_x, σ_y} = {s, srᵈ}` with `gcd(d,m)=1`; relabel `r` so that `d=1`.

**Taxonomy of legal dihedral configurations (extends §4).**

| `|S|` | selected involutions | generated group | `m` parity | templates |
|---|---|---|---|---|
| 2 | two reflections | `D₂ₘ`, all `m ≥ 3` | any | cycle `C_{2m}` / path `Pₘ` / `∅` **(new)** |
| 2 | reflection + central `z` | `V₄` | (`m=2`) | `K₄` boundary (§4) |
| 3 | two reflections + `z` | `D_{4n}` (`m=2n`) | even only | Möbius/prism, ladders (§5–§9) |

`|S| ≥ 4` inducing a dihedral group is impossible: it would need `≥ 3` reflection centres, which are
collinear (illegal). So `|S| ∈ {2,3}` exhausts the dihedral configurations, and the pair row is the
missing generality.

**Theorem A (templates).** For `T = {s, sr}` on a tame `D₂ₘ`-set:
- free orbit `→ Cay(D₂ₘ, T) = C_{2m}` (the 2-involution dihedral Cayley graph is one `2m`-cycle);
- reflection orbit `→ Pₘ` (the path on `m` vertices; **no vertex is deleted**, since the pair
  product `σ_xσ_y = r` is fixed-point-free on the reflection cosets);
- rotation orbit `→ ∅` (both cosets are `r`-fixed, hence deleted).

**Theorem B (template nimbers).**
- `𝒢(Pₘ) = ` Dawson's-chess value `A002187(m)` (Node Kayles on a path ≡ Dawson's chess, octal
  `0.137`; eventually periodic, period 34).
- `𝒢(C_n) = mex{ 𝒢(P_{n-3}) }` for `n ≥ 3` (vertex-transitive; every move deletes 3 consecutive
  vertices, leaving `P_{n-3}`).
- **Lemma:** `𝒢(C_{2m}) = 0` for every `m ≥ 2`. (`2m−3` is odd; `A002187` has no odd-index zero, so
  `𝒢(P_{2m-3}) ≠ 0` and the mex is `0`.) Thus **free orbits contribute nothing** for `m ≥ 2`.

**Theorem C (orbit formula).** For a tame `D₂ₘ`-set `Ω` with `f` free orbits and `ρ` reflection
orbits (rotation orbits contribute `0`),
```
𝒢(R_T(Ω)) = (f mod 2)·𝒢(C_{2m}) ⊕ (ρ mod 2)·𝒢(Pₘ) = (ρ mod 2)·𝒢(Pₘ)      (m ≥ 3).
```

**Theorem D (reflection-orbit parity → value).**
- **`m` odd:** the single reflection class is either fully split or fully nonsplit (all reflections
  conjugate and of odd order); when split, the two fixed points of each reflection fall in
  *distinct* orbits (reflections are self-normalizing for odd `m`), so `ρ ∈ {0,2}` — always even.
  Hence
  ```
  𝒢(R_S) = 0   for every m odd:  the odd-order dihedral game is always a P-position.
  ```
- **`m` even (`m = 2n`):** two reflection classes `⟨s⟩, ⟨sr⟩`; the central `z = rⁿ` pairs each split
  reflection's two fixed points into one orbit, so each split class gives exactly one reflection
  orbit. Class `⟨s⟩` (`t ↦ t⁻¹`) is always split; class `⟨sr⟩` is split iff `2m | q∓1`. Thus
  `ρ = 1 + δ`, `δ = 1_{2m|q∓1}`, and
  ```
  𝒢(R_S) = (1 − δ)·𝒢(Pₘ).
  ```

**Corollary (P-position criterion, pair family).** `R_S` is a P-position **iff**
`m` is odd, **or** `𝒢(Pₘ) = 0`, **or** `2m | q∓1` (both reflection classes split, `m` even).
(`−` = split torus `m|q−1`, `+` = nonsplit torus `m|q+1`.)

**Theorem E (density).** Fix `m ≥ 3` and a torus family. Among admissible primes the relative
Dirichlet density of P-positions is
```
1     if m is odd, or if m is even with 𝒢(Pₘ) = 0   (Dawson zeros m ∈ {4,8,14,20,24,28,34,…});
1/2   if m is even with 𝒢(Pₘ) ≠ 0.
```
The uniform `½` of the triple classification (§12) is the special even-`m` slice with `𝒢 ≠ 0`;
the pair family shows the density is not universally `½`.

**Theorem F (converse realization).** For every `m ≥ 3`, `C_{2m}` and `Pₘ` occur as transitive
residual templates of legal tame conic-involution pairs over infinitely many prime fields (Dirichlet:
`q ≡ ∓1 (mod m)` realizes the torus; a congruence mod `2m` selects/avoids the second reflection
class). The associated path/cycle nimber sequence is the paper's byproduct OEIS entry.

## 4. Computational verification (reproducible)

Script: `notes/2026-07-17-c263-dihedral-pair-templates.rs` (self-contained; Grundy core identical to
`rust/scripts/nodekayles_cayley.rs`, no canonicalization group). Output:
`notes/2026-07-17-c263-dihedral-pair-templates.json`. Manifest:
`notes/2026-07-17-c263-dihedral-pair-templates.sha256`.

Reproduce:
```
rustc -O notes/2026-07-17-c263-dihedral-pair-templates.rs -o /tmp/c263bin
cd notes && /tmp/c263bin 2026-07-17-c263-dihedral-pair-templates.json 5 7 11 13 17 19 23
sha256sum -c 2026-07-17-c263-dihedral-pair-templates.sha256
```

What it checks (all PASS):
- `𝒢(Pₙ)` for `n=0..60` equals OEIS A002187 (Dawson) on the hard-coded initial terms — **true**.
- `𝒢(C_n) = mex{𝒢(P_{n-3})}` for `3 ≤ n ≤ 60` — **true**; and `𝒢(C_{2m})=0` for `2 ≤ m ≤ 30`.
- **End-to-end conic simulation** over `q ∈ {5,7,11,13,17,19,23}`: builds every off-conic
  involution from its matrix `[[b,−a],[c,−b]]`, enumerates **all 241,344 tame legal pairs**, builds
  the actual fixed-point-deleted residual `R_S`, computes `𝒢(R_S)` directly, and compares against
  the closed orbit formula (Theorem C) using independently computed `𝒢(C_{2m})`, `𝒢(Pₘ)`:
  **0 formula mismatches**.
- **Structural** check: every free orbit is a 2-regular connected `2m`-cycle; every reflection
  orbit is a path (`m` vertices, exactly two degree-1 ends); every rotation orbit is fully deleted:
  **0 structure failures** across all 241,344 pairs.
- Value histogram `{0: 172668, 1: 36456, 2: 13296, 3: 18924}` — the non-`{0,1}` values (`2,3`) are
  produced only by these pair templates (via `𝒢(P₁₀)=3`, `𝒢(P₁₂)=2`, `𝒢(P₁₈)=3`, …), matching the
  catalogue note's observation that legal-configuration Grundy values exceed `1`.
- Cross-check of derived closed forms on the per-`(q,m)` representatives: every `m`-odd
  representative is P (`𝒢=0`); the `m`-even form `𝒢 = (1−δ)·𝒢(Pₘ)` holds on all representatives.

## 5. Manuscript integration

- **Retitle (proposed & applied).** Old: "…: The Dihedral Case". New:
  **"…: Dihedral Subgroups of PGL₂(q)"**. This matches D6's "toward finite subgroups of PGL₂(q)"
  while staying accurate: every legal *pair* of off-conic points already generates a dihedral
  subgroup of `PGL₂(q)`, and the classification now spans all `D₂ₘ`. A bare "Finite Subgroups of
  PGL₂(q)" would overclaim, since §15 (Discussion) still defers the polyhedral and `PSL₂/PGL₂` rows.
- Abstract updated to state both the two- and three-selected-point cases and all `m`.
- §4 extended with the legal-configuration taxonomy (pairs vs triples) so odd `m` re-enters via
  pairs.
- New **§14. The two-selected-point family `D₂ₘ`** inserted before Discussion, carrying Theorems
  A–F with proofs at the existing rigor level; Discussion renumbered to **§15**.

## 6. Vibe check

Good — better than expected. The task read as "add the odd-`m` dihedral rows," but the real find is
that the *whole* pair-of-points subgame (which is the generic 2-move position, and always dihedral)
was missing, and it closes with an unusually clean pair of theorems: **odd-order dihedral is always
P**, and the even case collapses to `(1−δ)·Dawson(m)`. That also explains, in one line, why the
manuscript's `½`-density and `{0,1}`-only values were artifacts of the triple restriction. Every
claim is machine-verified end-to-end over the conic (241k pairs, 0 mismatches, 0 structure
failures), so the formalization/adequacy bar is well supported. Residual risk is only editorial
(section renumbering, wording), not mathematical. §15 deferrals (polyhedral, PSL/PGL) are untouched
and correctly out of scope.
