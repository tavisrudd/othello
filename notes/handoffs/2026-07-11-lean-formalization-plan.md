# Lean formalization plan — the -10 / -11 PROVED corpus

**Date**: 2026-07-11
**Status**: IN PROGRESS. Plan approved (`yc` under `mi`, 2026-07-11); the three §5 decisions
are resolved. **Phase 0 MVP + Phase 1 step 1 (transfer lemma) + the concrete `FiniteGeom`
`𝔽_q` code layer landed** — see §7 Progress. Resume at Phase 1 step 2 (`δ_x = τ`); the real
`q = 9` discharge (trace-form nondegeneracy + Chen–Ling–Xing) remains the tracked next-step 2.
**Scope**: formalize the items tagged `[PROVED]` / "Lean-proved" across
[baer-equivariant-extension](../2026-07-10-baer-equivariant-extension-upgrades.md),
[completion-core-rigidity](../2026-07-10-completion-core-rigidity-upgrades.md),
[continuation-graph-rigidity](../2026-07-10-continuation-graph-rigidity-upgrades.md),
[coding/MDS cross-field sweep](../2026-07-11-codex-coding-mds-cross-field-sweep.md), and the
Lean-proved portfolio cards ([key cards](../2026-07-11-projective-cap-portfolio-key-cards.md)).
**Not in scope**: `[OPEN]`, `[SPECULATIVE]`, `[TRANSLATION]`, and applied/ML directions — those
are not theorems yet.

## 1. Layout decision (per the "new folders, same top-level `lean/`" steer)

`lean/` today holds five `[[lean_lib]]` targets (`NodeKayles`, `Sumfree`, `CapGame`,
`ProjectiveCap`, `Queens`), each an `X.lean` root importing an `X/` module dir; generated
certificates live under `ProjectiveCap/CertData/`. New work follows the same shape.

| New library | Covers | Source doc |
|---|---|---|
| `RepairCodes` | LRC repair hypergraph `(ν,τ)`, twisted-cubic–axis + Roth–Lempel seeds, bounded-repair transfer, seed-and-lift, `δ_x=τ` completion distance | sweep §1, §3 |
| `CompletionCore` | completion core, deletion/insertion distance, secant resilience, relative multiple saturation, the §4 example families | completion-core-upgrades |
| `ContinuationRigidity` | `M_(0,5)` four-map reduct, frame-graph semilinear rigidity (Thm 7.4), continuation-complex reconstruction (Thm 8.2–8.4), rook-graph / tangent-trace recovery | continuation-upgrades |
| `BaerExtension` | Galois/Baer-invariant arc pair-extension (Thm 3.1), fixed-subgeometry extension (Thm 6.1), Galois-rank section formula (Thm 7.1) | baer-upgrades |
| `FiniteGeom` (shared base) | `PG(n,q)`, linear codes / MDS / dual distance, hypergraph `ν`/`τ`, `PGL(2,q)` + symmetric-cube action, twisted cubic / NRC — the infrastructure the four libs share | all |

**Fits existing Lean (no new folder):** the odd-plane cap-game bidirectional reduction (card K1) and
the proof-carrying methodology (K18) are already `ProjectiveCap` (`Grid`, `GridGame`,
`FrameGridBridge`, `TrapConverse`, `Certificate`, `CertCheck`). New game-value `[PROVED]` items go
there; the `A5` frame/incidence work already has `rust/scripts/a5_*` companions.

`RepairCodes` is deliberately first and standalone (the juiciest lane, and the one with no existing
Lean) — it needs only the linear-code + hypergraph parts of `FiniteGeom`, not the projective-rigidity
machinery.

## 2. Three trust tiers — decide per theorem BEFORE writing it

The corpus is not uniform; forcing everything to "real proof" is the wrong call. Tag each item:

- **PROVE** — machine-check with no `sorry`, axioms clean (`propext`/`Classical.choice`/`Quot.sound`
  only, no `native_decide`), matching the current `NodeKayles`/`ProjectiveCap` bar. For the finite,
  elementary, general-in-`q` statements.
- **CERT** — a generated certificate + independent rules-only checker, the `CertData/` pattern, for
  the `COMPUTED-EXACT` single-`q` data (the `q=9` seed `(ν,τ)` table, the `q=5,7,11` orbit spectrum,
  the `s=7` Frobenius counterexample). These are *checked*, not `native_decide`d.
- **IMPORT** — a cited external result we do not re-prove. Handled with the **most rigorous
  review-ready discipline** (decision 3, below), not a loose `axiom`.

**IMPORT list (axiomatize, cite, never prove):**

| Imported theorem | Feeds | Cite |
|---|---|---|
| Sauermann `Z_p(𝔽_q)=o(p^h)` | `τ/ν → p` | arXiv:1904.09560 |
| Ellenberg–Gijswijt cap-set `Z_3=o(3^h)` | `τ/ν → 3` | Annals 2017 |
| Dias da Silva–Hamidoune restricted sumset | prime-NRC `δ_x` (§3) | classical |
| Han–Fan NMDS ⟺ zero-sum characterization | code/circuit prior art (§1.3) | IEEE IT 2023 |
| Garcia–Stichtenoth optimal tower | explicit outer / asymptotically-good | classical |
| classical MDS/GRS + Singleton-LRC bound | §1 parameters | GHSY arXiv:1106.3625 |
| BDMP twisted-cubic orbit sizes | orbit cross-check (`RepairCodes`/§6.5) | arXiv:1909.00207 |

The asymptotic conclusions (`τ/ν → p`, asymptotically-good fixed-alphabet families) then become
**conditional Lean theorems**: Lean proves the *reduction* (finite seed + transfer lemma ⇒ family
with the invariant distribution), taking the analytic bounds as inputs. The finite content is ours,
the analytic content is imported — and §5 decision 3 fixes exactly *how* imported, so a reviewer can
audit the boundary line by line.

## 3. mathlib gap analysis (what `FiniteGeom` must build)

mathlib pinned at v4.32-rc1; minimal-footprint preferred (per TRUST.md, `SetTheory/Game` is gone →
self-contained).

| Need | mathlib status | action |
|---|---|---|
| `𝔽_q`, Frobenius | `GaloisField`, `ZMod`, `frobenius` — present | reuse |
| `PG(n,q)` | `Projectivization` — partial | thin wrapper |
| linear code, dual, min distance, MDS | `CodingTheory` has Hamming/`Code`; MDS/dual-distance/generator-matrix — **thin/absent** | **build** a small generator-matrix + dual-distance layer |
| hypergraph transversal `τ` / matching `ν` | `SimpleGraph` matching partial; hypergraph `τ`/fractional — absent | **build** minimal `Finset`-of-`Finset` `ν`/`τ` |
| `PGL(2,q)`, symmetric cube | `GeneralLinearGroup`, `MulAction` present; `Sym^3` — absent | **build** the degree-3 rep (the Python `sym3_matrix` is the spec) |
| twisted cubic / NRC | absent | **build** on the code layer |
| zero-sum-free / cap sets | absent (and IMPORT-tier) | axiom only |

`FiniteGeom` is the critical-path dependency and the main cost. Keep it lean: build only the code +
hypergraph + `PGL`-action pieces the four libraries actually cite.

## 4. Dependency-ordered phases

```
FiniteGeom (codes + hypergraph τ/ν)  ── critical path
        │
        ├── RepairCodes      (needs codes + hypergraph + Sym^3)      ← FIRST vertical slice
        ├── CompletionCore   (needs codes + hypergraph; shares δ_x=τ with RepairCodes)
        ├── ContinuationRigidity (needs PG + Sym^3 + graph automorphisms)
        └── BaerExtension    (needs PG + Frobenius + subspace arrangements)
```

**Phase 0 — `FiniteGeom` MVP.** Generator matrix over `𝔽_q`, dual code, minimum/dual distance,
`Finset`-hypergraph with `ν` (max matching) and `τ` (min transversal). Just enough to *state*
`RepairCodes` Theorem 1.1.

**Phase 1 — `RepairCodes` vertical slice (recommended first deliverable).** In order:
1. `[PROVE]` transfer lemma (§1.4): inner `d(I⊥)=r+1`, outer `d(O⊥)≥r+2` ⇒ every `q`-weight-`≤r+1`
   dual word is confined to one inner block ⇒ the complete radius-`r` repair hypergraph transfers.
   Clean dual-weight/trace argument — the crux novelty, and it proves in Lean without any imported
   analytic input. **This is the single highest-value Lean target in the whole corpus.**
2. `[PROVE]` `δ_x = τ(𝓑_x)` completion-distance invariant (§3 / completion-core Prop 2.2, 2.4).
3. `[CERT]` the `q=9` full-orbit seed: `C_orb=[19,4,8]_9`, the three `(ν,τ)=(4,7),(6,12),(7,13)`
   rows, `minimal_circuits=[(3,120),(4,84)]`, all-symbol locality ≤3 — generated from
   `q9_pgl_orbit_seed.py`, checked by a rules-only validator (not `native_decide`).
4. `[PROVE]` uniform `q=3^h` theorem (§1.5.1): `C(S_q)=[2q+1,4,q-1]_q`, all-symbol `τ>ν`.
5. `[PROVE, conditional]` seed-and-lift (§1.4/§1.5): seed + transfer + IMPORTed outer family ⇒
   asymptotically-good fixed-alphabet family with the same invariant distribution.

**Phase 2 — `CompletionCore`.** completion core closure (Prop 1.1), sharp deletion radius (Thm 2.1),
relative multiple saturation (Prop 5.3), the §4 example families (each `[CERT]` or short `[PROVE]`).
Shares `δ_x=τ` with Phase 1 — build it once in `FiniteGeom`, cite from both.

**Phase 3 — `ContinuationRigidity`.** Minimal nonfaces (Prop 8.1) → two-point complex reconstructs
the plane (Thm 8.2) → frame-graph semilinear rigidity `S_4`+Frobenius (Thm 7.4, via Lemmas 7.2/7.3)
→ full continuation-complex reconstruction (Thm 8.4). Fixed small-`q` rigidity checks are `[CERT]`;
the general theorems `[PROVE]`. Heaviest lane (graph-automorphism + moduli reduct).

**Phase 4 — `BaerExtension`.** Pair-extension theorem (Thm 3.1) and its corollaries (3.2–3.4),
fixed-subgeometry extension (Thm 6.1), Galois-rank section formula (Thm 7.1). Depends on Frobenius
+ subspace-arrangement counting; the `sqrt` lower bound (Cor 3.4) needs care (real-valued bound over
a finite statement).

## 5. Recommended first move + risks

**First move:** Phase 0 MVP + Phase 1 step 1 (the transfer lemma) as one thin vertical slice — it is
the crux novelty, is self-contained (no imported analytic input), and validates the `FiniteGeom`
code/hypergraph layer against a real theorem before the other three libraries commit to it.

**Decisions (resolved 2026-07-11, `yc` under `mi`):**

1. **Code layer — abstract-first.** State `RepairCodes` over an abstract `[LinearCode 𝔽 …]`
   typeclass carrying only the properties the transfer lemma cites (dual code, dual distance,
   bounded-weight dual supports). Reach the transfer lemma fast against the abstract interface; the
   concrete `𝔽_q` NRC / twisted-cubic instance comes later. **Required follow-through (review-ready
   guard):** the abstract layer is not done until it is *discharged by at least one concrete instance*
   (the `q=9` seed), else the theorem is vacuous — track the instance as part of Phase 1, not "later".

2. **Single-`q` tables — CERT, no `native_decide`.** Hold the `CertData/Q13` bar: generated
   certificate + independent rules-only checker, `#print axioms` clean. Confirmed.

3. **Imported results — most rigorous review-ready boundary.** In priority order:
   - **Prove, don't import, whenever feasible.** The *elementary* inputs — Vandermonde independence,
     the zero-sum circuit identity, the `p`-uniform `τ ≤ pν` bound, the Singleton-LRC bound — are
     finite/algebraic and get **PROVE**d, not axiomatized. Only genuinely deep external theorems stay
     imported.
   - **Prefer explicit hypotheses over axioms.** Where an imported bound can be a *named argument* of
     the theorem (e.g. `(hSauermann : Z p q ≤ …) → …`), do that — the dependency then lives in the
     signature, visible to any reader, with **zero** global axioms introduced.
   - **Quarantine the irreducible ones.** Results that must be standing facts go in a single
     `Imported.lean` per library as `axiom`s whose statements are **copied verbatim from the cited
     paper** (theorem number + arXiv/DOI in the docstring), nothing else in that file.
   - **Audit gate.** Every headline theorem carries a `#print axioms` check (as TRUST.md already does):
     an unconditional theorem shows `[propext, Classical.choice, Quot.sound]` only; a conditional one
     shows *exactly* the quarantined imports it rests on and no others. That set is the reviewable
     boundary between "ours" and "imported".

**Effort.** Multi-session program. Phase 1 (FiniteGeom MVP + transfer lemma + `δ_x=τ` + the `q=9`
discharging instance) is the first commitment; the rest sequences behind it. Starting fresh session.

## 6. Provenance
Backing scripts (COMPUTED-EXACT sources for the `[CERT]` items) are tracked under
[`notes/scripts/2026-07-11-coding-mds-sweep/`](../scripts/2026-07-11-coding-mds-sweep/) with frozen
hashes; each `[CERT]` Lean cert should regenerate from the corresponding script and be checked by a
rules-only validator, mirroring `ProjectiveCap/CertData/`.

## 7. Progress

### Phase 0 + Phase 1 step 1 — landed (`lean/`, 2026-07-11)

Two new `[[lean_lib]]` targets wired into `lakefile.toml` (`defaultTargets` too):

- **`FiniteGeom`** (shared base) — two self-contained modules:
  - `FiniteGeom/Weight.lean`: the q-ary weight-counting arithmetic the transfer argument stands
    on. `card_filter_le_sum` (#nonzero coords ≤ total weight) and `mul_card_filter_le_sum`
    (`d · #coords ≤ total weight`). Pure `Finset`/`ℕ`.
  - `FiniteGeom/Hypergraph.lean`: the minimal `Finset`-of-`Finset` hypergraph layer (§3).
    `IsMatching`/`IsTransversal`, matching number `matchingNumber` (`ν`, `sSup` of matching
    sizes), transversal number `transversalNumber` (`τ`, `sInf` of transversal sizes), the
    pointwise weak-duality injection `matching_card_le_transversal_card` (each matched edge hit
    by a distinct cover vertex), and `nu_le_tau : ν ≤ τ`. The definitions are pinned by
    `card_le_matchingNumber` / `transversalNumber_le_card` (upper/lower bound + attainment) and
    exercised on a concrete one-edge hypergraph (`ν = τ = 1`). Baseline for the `(ν,τ)`
    distribution claims and the `δ_x = τ` invariant (Phase 1 step 2 / `CompletionCore`).
    Framing note: this is *weak duality* (the elementary `ν ≤ τ`), **not** König's equality
    `ν = τ` (bipartite-only, not claimed).

  Kept minimal per decision 1 (abstract-first); the concrete `𝔽_q` generator-matrix /
  dual-distance code layer is **not built yet** and is the next `FiniteGeom` job.
- **`RepairCodes`** — `RepairCodes/Transfer.lean`: the **concatenation transfer lemma (§1.4)**,
  the crux self-contained novelty. Stated over an abstract-first interface `ConcatDualWord`
  (decision 1): the deep structural inputs — trace-representation faithfulness (`hbeta`),
  `β ∈ O⊥` (`houter`), inner dual distance (`hdist`) — are **named fields**, visible in the
  signature, zero global axioms (decision 3, preferred form). Proved:
  - `transfer_blockwise` (Part A): every block of a `< d(O⊥)`-weight dual word lies in `I⊥`.
  - `transfer_single_block` (Part B, budget `< 2·d(I⊥)`): at most one nonzero block — the "no
    new cross-block repair supports" content.
  - `transfer_lemma`: combined.
- **`RepairCodes/Q9Seed.lean`** — decision-1 non-vacuity guard: a concrete two-block **consistency
  witness** `q9SeedToy` (one nonzero weight-4 inner-dual block, one zero block) discharging every
  `ConcatDualWord` field, with an `example` applying `transfer_lemma` to a single-block verdict
  witnessed by an actual nonzero block (card = 1). Docstring records the **real `q = 9` obligation**
  (inner `C₀ = [10,4,6]_9`, `dI = 4`, `dO ≥ 5`, `s = 4`, `(ν,τ)` distribution) as the tracked
  follow-up, blocked on the concrete `FiniteGeom` code layer + trace-form nondegeneracy — and is
  explicit that the witness establishes only interface *consistency/inhabitation*, not the real
  discharge, and cannot (by design) exercise `transfer_blockwise`'s `exfalso` branch.

**Referee-hardening (framing + hypothesis surface):** the transfer lemma is framed as the finite
*counting corollary* the sweep flags as candidate-new; the classical trace-representation /
Chen–Ling–Xing dual-decomposition step is **not** claimed as ours — it enters as named
`ConcatDualWord` fields, and the theorems are stated as holding "in the model `ConcatDualWord`",
conditional on instantiation. Hypothesis surface tightened: `hpos` replaced by the
manifestly-true `innerDual_zero` (`0 ∈ I⊥`) + `blockWt_eq_zero` (Hamming weight zero iff zero
vector), from which the weight-≥1 fact is derived. "No imported analytic input" is stated
precisely (the Sauermann / Ellenberg–Gijswijt asymptotics are simply not used by this finite
lemma; they are not silently assumed).

**Audit gate (passes):** `#print axioms` on `transfer_lemma`, `transfer_blockwise`,
`transfer_single_block`, `q9SeedToy`, `nu_le_tau`, `matching_card_le_transversal_card`,
`card_le_matchingNumber`, `transversalNumber_le_card`, and the `FiniteGeom` weight lemmas =
`[propext, Classical.choice, Quot.sound]` only — no `sorryAx`, no `native_decide`.
`lake build FiniteGeom RepairCodes` clean, no warnings.

### Phase 0 code layer + interface bridge — landed (`lean/`, 2026-07-11, cont.)

The **algebraic half** of the `FiniteGeom` MVP (the outstanding Phase-0 blocker), plus a bridge
that discharges the transfer interface's finite fields from it:

- **`FiniteGeom/Code.lean`** — linear codes as `𝔽_q`-`Submodule`s of `Fin n → 𝔽`. mathlib at
  this pin ships `hammingNorm` (`InformationTheory/Hamming`) but **no** `Code`/dual/MDS layer,
  so this is built on `Submodule` + `Matrix.dotProduct` + `hammingNorm`:
  - `dualCode C` — orthogonal complement under `x ⬝ᵥ y = ∑ xᵢyᵢ`, packaged as a `Submodule`
    (`mem_dualCode` the membership iff);
  - `minDist C` — least Hamming weight of a nonzero codeword (`sInf`, so `0` on the trivial
    code), pinned as a lower bound by `minDist_le_hammingNorm` (mirrors how `τ` was pinned by
    `transversalNumber_le_card`);
  - `dualDist C = minDist (dualCode C)`, with `dualDist_le_hammingNorm` — a nonzero dual word
    has weight `≥ d(C⊥)`, **exactly the shape of `ConcatDualWord.hdist`**;
  - `rowCode G` — code generated by a generator matrix's rows (`row_mem_rowCode`).
  MDS/Singleton deliberately not built (not cited by the transfer slice) — later `FiniteGeom` job.
- **`RepairCodes/CodeInstance.lean`** — `ofInnerCode`: builds a `ConcatDualWord` from a concrete
  inner code `I` over `𝔽_q`, filling `innerDual` (`∈ dualCode I`), `blockWt` (`hammingNorm`),
  `dI` (`dualDist I`), and their defining fields (`innerDual_zero`, `blockWt_eq_zero`, `hdist`)
  **from the code layer, zero extra assumptions**. The residual hypotheses are exactly the deep
  imported content — `beta` + trace faithfulness `hbeta` + outer bound `houter`. This draws the
  "ours vs imported" boundary (§5 decision 3) at the *type level*: `transfer_ofInnerCode` fires
  the transfer lemma against any real inner code once those three are supplied. Code-backed
  replacement for `Q9Seed`'s toy witness.

**Audit gate (passes):** `#print axioms` on `dualCode`, `mem_dualCode`, `minDist_le_hammingNorm`,
`dualDist_le_hammingNorm`, `row_mem_rowCode`, `ofInnerCode`, `transfer_ofInnerCode` =
`[propext, Classical.choice, Quot.sound]` only (some fewer) — no `sorryAx`, no `native_decide`.
`lake build FiniteGeom RepairCodes` clean, no warnings.

**Next steps (in order):**
1. ~~Concrete `FiniteGeom` code layer~~ **(landed)** — `dualCode` / `minDist` / `dualDist` /
   `rowCode` in `FiniteGeom/Code.lean`; interface bridge `ofInnerCode` in `CodeInstance.lean`.
2. Discharge the **real `q = 9` seed** via `ofInnerCode` (retire the toy witness's role): supply
   the inner code `I` (`C₀ = [10,4,6]_9`) as a concrete `rowCode`/`Submodule` and the three
   residual fields `beta`/`hbeta`/`houter` — needs the
   trace-form nondegeneracy (`Algebra.trace` / `traceForm_nondegenerate`) for `hbeta` and the
   Chen–Ling–Xing dual decomposition for `houter`.
3. Phase 1 step 2: `δ_x = τ(𝓑_x)` completion-distance invariant (shared into `CompletionCore`).
   The `τ` side now exists (`FiniteGeom.transversalNumber`); the remaining work is defining `δ_x`
   (completion distance) on the code layer and identifying the repair hypergraph `𝓑_x`.
4. Phase 1 step 4: uniform `q = 3^h` theorem `C(S_q) = [2q+1,4,q-1]_q`.

### Handoff Note — 2026-07-11 (session: lean-formalization Phase 0/1)

- Landed the FiniteGeom weight base + the RepairCodes concatenation transfer lemma as one thin
  vertical slice (the plan's recommended first move), abstract-first with the analytic/structural
  inputs as explicit hypotheses. Build green, axioms clean.
- No concrete code layer yet — the transfer lemma is currently discharged only by the toy witness;
  the real `q = 9` instance is the immediate next commitment (blocks the "not vacuous in the
  intended sense" story, though the interface *is* proven inhabited).
- Commit: this session (FiniteGeom/RepairCodes libs + lakefile wiring + this handoff update).

### Handoff Note — 2026-07-11 (cont.: FiniteGeom hypergraph layer)

- Added `FiniteGeom/Hypergraph.lean`: the `Finset`-hypergraph `ν`/`τ` half of Phase 0 (§3),
  with `nu_le_tau` proved via a König-style matching→cover injection. Self-contained, axioms
  clean. This completes the *combinatorial* half of the `FiniteGeom` MVP; the *algebraic* half
  (generator matrix / dual distance over `𝔽_q`) is still the outstanding Phase-0 job and the
  blocker for the real `q = 9` discharge and `δ_x = τ`.
- Second commit this session.

### Handoff Note — 2026-07-11 (cont.: referee-hardening pass)

- Passed the whole slice through an adversarial-referee lens for both math and framing:
  - **Framing (names/docs/comments):** removed overclaims. The transfer lemma is now framed as
    the finite counting corollary (the sweep's candidate-new content), with the classical
    trace/Chen–Ling–Xing input explicitly *assumed* via named fields and the theorems stated as
    holding "in the model `ConcatDualWord`" (conditional on instantiation). Fixed the hypergraph
    lemma's "König-type" label → "weak duality" (ν ≤ τ is elementary; König's ν = τ is
    bipartite-only and not claimed). Q9Seed reframed as a *consistency witness*, not a discharge.
  - **Hypothesis surface:** replaced `hpos` with the manifestly-true `innerDual_zero` +
    `blockWt_eq_zero`, so every `ConcatDualWord` field is a self-evident property of the real
    object (a referee can check faithfulness field-by-field) rather than a compound assumption.
  - **Cheap de-risks landed:** `card_le_matchingNumber` / `transversalNumber_le_card` pin
    `ν`/`τ` to their intended extremal meanings (upper/lower bound + attainment, proved via the
    correctly-oriented `le_csSup`/`Nat.sInf_le`, which by construction catches a def swap); plus a
    concrete one-edge-hypergraph `example` proving `ν = τ = 1` end-to-end.
- Known gap (documented, not hidden): the only numeric hypergraph instance has `ν = τ`;
  a `τ > ν` instance is deferred to the code-derived repair hypergraph (needs the code layer).
- Build green, all headline results + the witness `#print axioms`-clean. Third commit this session.

### Handoff Note — 2026-07-11 (cont.: concrete code layer + interface bridge)

- Built the algebraic half of the `FiniteGeom` MVP — the Phase-0 blocker for the real `q = 9`
  discharge: `FiniteGeom/Code.lean` (`dualCode`, `minDist`/`minDist_le_hammingNorm`, `dualDist`/
  `dualDist_le_hammingNorm`, `rowCode`) on `Submodule` + `Matrix.dotProduct` + `hammingNorm`
  (mathlib at this pin has no `Code`/dual/MDS layer, only `hammingNorm`).
- Bridged it to the transfer interface: `RepairCodes/CodeInstance.lean` `ofInnerCode` fills the
  finite `ConcatDualWord` fields from the code layer with zero extra assumptions, leaving exactly
  `beta`/`hbeta`/`houter` (the trace / Chen–Ling–Xing inputs) as the residual hypotheses —
  making the §5-decision-3 "ours vs imported" boundary a type-level fact. `transfer_ofInnerCode`
  fires the transfer lemma against any real inner code. This retires the toy witness as the
  *only* discharge path; the real `q = 9` instance (next-step 2) now reduces to three fields.
- MDS/Singleton intentionally deferred (not cited by the slice). Build green, no warnings, all
  new results `#print axioms`-clean (`[propext, Classical.choice, Quot.sound]`). Fourth commit
  this session.
