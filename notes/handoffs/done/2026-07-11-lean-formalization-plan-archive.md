# Lean formalization plan — session log / archive companion

**Status**: Append-only history companion to the live map
[`../2026-07-11-lean-formalization-plan.md`](../2026-07-11-lean-formalization-plan.md).
The narrative of *how* each result landed — dated session notes, the per-slice "landed"
writeups, the referee-hardening trail — lives here; the live doc holds the current-state map
(status table + open next-step queue). Newest notes at the bottom.

---

## Landed-slice narratives

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

---

## Dated session notes

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

### Handoff Note — 2026-07-11 (cont.: δ_x = τ invariant + the τ > ν witness)

- Landed **Phase 1 step 2's abstract identity**: `FiniteGeom/Completion.lean`
  `completionDistance_eq_transversalNumber` — completion-core Prop 2.2's `δ_x(C) = τ(𝓗_C(x))`,
  the finite content, shared into the base so `RepairCodes` and `CompletionCore` cite one proof.
  Abstract-first: the matroid content ("`(C∖D)∪{x}` independent ⟺ no circuit survives, and every
  relevant circuit passes through `x`") is folded into the *definition* of the deletion predicate
  (a trace `A` dies iff the deletion meets it), faithful to the paper's own proof, so the theorem
  is a pure hypergraph identity `min deletion = τ` with no imported input. `≥ τ`: a witnessing
  deletion is a transversal; `≤ τ`: intersect a minimum transversal with `C` (legitimate since
  every edge already lies in `C`). Reuses `transversalNumber`/`transversalNumber_le_card`.
- Closed the **documented `τ > ν` gap**: the triangle hypergraph `{{0,1},{1,2},{0,2}}` on `Fin 3`
  (pairwise-intersecting edges) added to `Hypergraph.lean` with a full `ν = 1 ∧ τ = 2` proof, so
  weak duality `ν ≤ τ` is shown *strict* in general (the prior only numeric instance had `ν = τ`).
  `ν ≤ 1` from "matching edges are pairwise disjoint but distinct triangle edges intersect";
  `τ ≥ 2` from "no single vertex meets all three edges" (small `decide`). A *code-derived* `τ > ν`
  is still the remaining goal. `decide` used only on 3-edge/`Fin 3`-subset checks — no
  `native_decide`; axioms stay `[propext, Classical.choice, Quot.sound]`.
- Build green, no warnings, all new results `#print axioms`-clean. Fifth commit this session.

### Handoff Note — 2026-07-11 (cont.: p-uniform τ ≤ p·ν bound)

- Landed `transversalNumber_le_mul_matchingNumber` in `Hypergraph.lean`: for a hypergraph whose
  edges are nonempty with `≤ p` vertices, `τ(H) ≤ p·ν(H)`. This is one of the elementary bounds
  §5 decision 3 marks **prove-don't-import** — the finite structural counterpart to the imported
  Sauermann/Ellenberg–Gijswijt asymptotic `τ/ν → p` (the import supplies the matching lower bound;
  this supplies the `p·ν` upper bound). Classic proof: the vertex set of a *maximum* matching is a
  transversal (a missed edge would extend the matching, contradicting maximality) with `≤ p`
  vertices per matched edge. Reuses the `ν`/`τ` attainment machinery already in the file.
- With the `τ > ν` witness (strictness) and now `τ ≤ p·ν` (the uniform upper bound), the `ν`/`τ`
  layer carries both the qualitative gap and the quantitative envelope the asymptotics need.
- Build green, no warnings, axioms clean (`[propext, Classical.choice, Quot.sound]`). Sixth commit.

### Handoff Note — 2026-07-11 (cont.: dual-of-generator characterization + adversarial review)

- Landed the **parity-check characterization** in `Code.lean`: `mem_dualCode_rowCode`
  (`y ∈ (rowCode G)⊥ ↔ ∀ i, Gᵢ ⬝ᵥ y = 0`, load-bearing `←` via "orthogonal-to-`y` is a
  submodule containing the rows ⇒ contains their span") and `mem_dualCode_rowCode_iff_mulVec`
  (matrix form `↔ G.mulVec y = 0`). This is the computational route from a concrete generator
  matrix to its dual code — the actual path to instantiating real inner codes for the q=9 discharge.
- **Adversarial review of the whole session's corpus** (definitional-faithfulness / vacuity lens,
  since kernel-checking already guarantees soundness): no soundness or overclaim defects.
  `completionDistance_eq_transversalNumber` is genuinely `min(hitting set ⊆ C) = τ` with the
  matroid step folded into the definition (documented, not proved — abstract-first);
  `ofInnerCode` sets `dI := dualDist I` (real dual distance, not faked) so the hard lower bound
  stays correctly deferred. One actionable gap: the code layer had **no pinned concrete value**
  (unlike the ν/τ layer's worked examples). Closed it with a non-vacuity witness over `𝔽₅`
  (`G = [1 1]`: `(1,4)` is in the dual, `(1,1)` is not), exercising
  `mem_dualCode_rowCode_iff_mulVec` end-to-end via `decide`.
- Build green, no warnings, all new results `#print axioms`-clean. Seventh commit.

### Handoff Note — 2026-07-11 (cont.: Singleton bound + MDS predicate)

- Landed `singleton_bound` (`d(C) + k ≤ n + 1`) and `IsMDS` in `Code.lean` — the elementary
  general-in-`q` bound §5 decision 3 marks **prove-don't-import** (the Singleton-LRC input), no
  imported content. Standard puncturing proof: restricting codewords to the complement of any
  `d-1` coordinates (`LinearMap.funLeft` to `↥Sᶜ → 𝔽`) is injective on `C` (two codewords
  agreeing there differ on `≤ d-1 < d` coords, so their difference is a sub-minimum-weight
  codeword and vanishes), hence `k = dim C ≤ dim(Sᶜ → 𝔽) = n-(d-1)`. Trivial-code branch
  (`d=0`) handled by `dim C ≤ n`.
- This is the code layer's most-standard previously-missing bound; it also lets the docs *state*
  the seed `[10,4,6]_9` is near-MDS (`d+k = 10 = n`, one under the Singleton value `11`) rather
  than assert it. Distance *lower* bounds (the hard content of the q=9 / q=3^h theorems) are a
  separate lever — Singleton is an upper bound and does not discharge them.
- Chose this over the two open next-steps deliberately: both (q=9 discharge, q=3^h) are blocked
  on deep/specific constructions (trace-form nondegeneracy + Chen–Ling–Xing for q=9; a
  general min-distance lower bound for q=3^h), whereas Singleton is a self-contained,
  high-certainty, in-scope infrastructure win.
- Build green (`lake build FiniteGeom RepairCodes`), no warnings, `#print axioms singleton_bound`
  = `[propext, Classical.choice, Quot.sound]`. Eighth commit.
- Doc-hygiene note: per the CLAUDE.md live/companion split added this session, §7's dated
  Handoff Notes should migrate to a companion `-archive.md` at end-of-session; deferred (kept
  inline for now to match the file's current structure). *(Done: this archive is that companion.)*

### Handoff Note — 2026-07-11 (cont.: distance lower-bound tool — Reed–Solomon)

- Landed the **distance-lower-bound direction** (Singleton is only an upper bound): new
  `FiniteGeom/EvalCode.lean` + the general `le_minDist` helper in `Code.lean`.
  - `le_minDist` (dual of `minDist_le_hammingNorm`): a uniform per-nonzero-codeword weight
    lower bound `m` transfers to `m ≤ d(C)` for nontrivial `C`. Reusable "hard direction".
  - `card_eval_zero_le_natDegree`: a nonzero degree-`<k` polynomial vanishes at `≤ deg p < k`
    of the `n` distinct evaluation points (vanishing points inject into the roots). The one
    classical fact the whole lane rests on.
  - `evalPi` (the `𝔽`-linear evaluation map via `Polynomial.leval`), the Reed–Solomon code
    `rsCode pts k = map evalPi (degreeLT 𝔽 k)`, `rsCode_hammingNorm_ge`
    (`n-(k-1) ≤ wt` per nonzero codeword), and `rsCode_minDist_ge : n-(k-1) ≤ d(RS_k)` for
    `1 ≤ k, 1 ≤ n` (nontriviality witnessed by the all-ones evaluation of the constant `1`).
- This is general-in-`q` infrastructure feeding both blocked theorems (the q=9 seed's real
  dual-distance lower bound and the q=3^h family's `d = q-1`) — the min-distance *lower* bounds
  those turn on, which `singleton_bound` (upper) cannot supply.
- Remaining capstone (queued as next-step 5): RS-is-MDS equality — `finrank (rsCode) = k` (via
  `evalPi` injective on `degreeLT k` + `degreeLTEquiv`) closes `d = n-k+1` against Singleton.
- Build green (`lake build FiniteGeom RepairCodes`), no warnings; `#print axioms` on
  `le_minDist` / `card_eval_zero_le_natDegree` / `rsCode_hammingNorm_ge` / `rsCode_minDist_ge`
  = `[propext, Classical.choice, Quot.sound]`. Ninth commit.

### Handoff Note — 2026-07-11 (cont.: Reed–Solomon-is-MDS capstone)

- Closed next-step 5's capstone: **`rsCode_isMDS`** — Reed–Solomon codes meet Singleton with
  equality (`d + k = n + 1`) for `1 ≤ k ≤ n`. Route: `finrank_rsCode : finrank (rsCode) = k`
  (evaluation is injective on `degreeLT k` since a nonzero deg-`<k` poly can't vanish at all
  `n ≥ k` points; `rsCode` is then the injective image of `degreeLT k`, finrank `k` via
  `degreeLTEquiv` + rank-nullity `LinearMap.finrank_range_of_inj`), then `singleton_bound`
  (upper) meets `rsCode_minDist_ge` (lower) ⇒ `d = n-k+1`.
- Now the layer has BOTH Singleton directions unified in a worked family: `singleton_bound`
  (general upper), `rsCode_minDist_ge` (RS lower), and their equality `rsCode_isMDS`. This is
  the MDS baseline the sweep's near-MDS seeds sit one below.
- Build green, no warnings; `#print axioms finrank_rsCode` / `rsCode_isMDS`
  = `[propext, Classical.choice, Quot.sound]`. Tenth commit.

### Handoff Note — 2026-07-12 (q=9 inner-code discharge slice)

- Narrowed the concatenation import boundary. `RepairCodes/CodeInstance.lean` now represents each
  block coefficient canonically in the linear dual of the outer symbol space:
  `blockFunctional I e w : Module.Dual 𝔽 V` for an encoder equivalence `e : V ≃ₗ[𝔽] I`.
  `blockFunctional_eq_zero_iff` proves this functional is zero exactly when `w ∈ I⊥`, using only
  surjectivity of `e`. Thus trace-form nondegeneracy is not needed for the transfer theorem;
  field trace is one choice of coordinates for the already-faithful dual functional. New
  `ofInnerCodeFunctional` / `transfer_ofInnerCodeFunctional` leave only the Chen–Ling–Xing
  outer-dual alternative as the structural hypothesis.
- Replaced the intended q=9 seed's placeholder-only state with real code infrastructure in
  `RepairCodes/Q9Seed.lean`: `GF9 = GaloisField 3 2`, a bijective enumeration of its nine field
  elements, the ten columns `{(1,t,t²,t³):t∈𝔽₉} ∪ {e₂}`, their generator matrix and row code.
  Restriction to four finite columns is a transposed Vandermonde minor, proving row independence;
  this yields `q9SeedEncoder : 𝔽₉⁴ ≃ₗ C₀` and `q9InnerCode_finrank : dim C₀ = 4`.
  `q9Inner_transfer` specializes the bounded-weight theorem to this actual encoder, with
  coefficient faithfulness fully discharged.
- Remaining q=9 finite work is exact distance: prove `d(C₀⊥)=4` (needed to turn the radius-four
  inequality into arithmetic) and `d(C₀)=6` (the full `[10,4,6]₉` theorem). The only external
  transfer input left is the Chen–Ling–Xing outer-dual statement `houter`; the repair hypergraph
  remains a separate concrete lane.
- Validation: `nix develop --command lake build RepairCodes` green with no Lean warnings.
  Independent `#print axioms` audit of `blockFunctional_eq_zero_iff`,
  `transfer_ofInnerCodeFunctional`, `q9SeedGenerator_rows_linearIndependent`,
  `q9InnerCode_finrank`, and `q9Inner_transfer` returned exactly
  `[propext, Classical.choice, Quot.sound]` for each.

### Handoff Note — 2026-07-12 (q=9 exact dual distance)

- Landed the reusable lower-bound criterion
  `FiniteGeom.le_dualDist_rowCode_of_column_independent`: if every set of fewer than `d`
  generator columns is independent and the dual code is nontrivial, then `d ≤ dualDist`.
  The proof restricts a dual relation to its Hamming support and invokes finite-family linear
  independence. The nontrivial-dual hypothesis is explicit because this code layer defines
  `minDist ⊥ = 0` rather than infinity.
- Generalized Vandermonde position to `momentCurve_linearIndependent_of_card_le`: any distinct
  family of at most `n` points on the moment curve in `𝔽ⁿ` is independent. The proof reindexes by
  `Fin (card ι)` and projects to the first `card ι` coordinates, where the square Vandermonde
  theorem applies.
- Proved every sub-four family of `q9SeedGenerator` columns independent. Finite-only families use
  the generalized moment-curve theorem. For a family containing `e₂`, projection to the first two
  coordinates gives at most two independent `(1,t)` points; their coefficients vanish, and the
  `X²` coordinate then forces the axis coefficient to vanish.
- Constructed the explicit characteristic-three circuit on the columns at parameters
  `0,1,-1` plus `e₂`, packaged its indicator as `q9DualWitness`, and proved membership in `C₀⊥`,
  Hamming weight four, and nonzeroness. The lower and upper bounds meet in
  `q9InnerCode_dualDist : d(C₀⊥)=4`.
- Added `q9Inner_transfer_radiusFour`: for a radius-four word and outer dual-distance gate five,
  both numeric obligations are now internal arithmetic. Only the Chen–Ling–Xing outer-dual
  alternative and the total-weight hypothesis remain arguments.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on the two shared lemmas, the small-column theorem, witness membership, exact
  dual distance, and specialized transfer theorem returned exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (q=9 exact primal distance)

- Identified the two concrete presentations of the seed:
  `q9InnerCode_eq_columnCode : rowCode q9SeedGenerator = columnCode q9SeedColumn`.
  The bridge is the transpose identity between right multiplication by the generator and point
  evaluation against its columns, proved as `q9PointEval_eq_encoder`.
- Proved `q9Seed_sectionCount_le`: every hyperplane meets the ten generator points in at most
  four positions. Removing `e₂`, the remaining zero positions inject into the zero set of a
  nonzero degree-at-most-three polynomial on the nine distinct `𝔽₉` parameters, bounded by
  `momentCurve_section_le`; the axis contributes at most one further point.
- Defined `q9DistanceForm = (0,-1,0,1)`, the coefficient vector of `T³-T`. Its point evaluation
  is nonzero by injectivity of the seed encoder, and its section contains the three finite points
  `0,1,-1` plus `e₂`. The universal upper bound makes this an exact four-point maximum section.
- Applied `columnCode_minDist_eq` to obtain `q9InnerCode_minDist : d(C₀)=10-4=6` and packaged
  the final statement as `q9InnerCode_parameters`: dimension four, minimum distance six, dual
  distance four. The real inner seed is now fully `[10,4,6]₉`; only the imported outer-dual
  decomposition remains for the intended concatenation transfer theorem.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on the presentation bridge, section upper/attainment theorems, exact minimum
  distance, and parameter package returned exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (outer-dual step proved; citation boundary corrected)

- Reopened the claimed final transfer dependency under the plan's strict import discipline. The
  existing citation audit had already found that the “Chen–Ling–Xing dual decomposition of a
  concatenated code” attribution was not locatable; a fresh primary-source search again found
  Güneri–Ling–Özkaya's general QC trace/decomposition survey and adjacent generalized-QC work,
  but no matching Chen–Ling–Xing theorem. No axiom was introduced.
- Added `RepairCodes/OuterDual.lean`. For an outer base-field code `O ≤ (ι → V)`,
  `functionalDual O ≤ (ι → V*)` is its annihilator under the summed evaluation pairing.
  `IsOrthogonalToConcatenation I e O w` states blockwise orthogonality to the ordinary
  concatenation, and `blockFunctional_mem_functionalDual` proves directly that the canonical block
  coefficients lie in the functional outer dual. `HasFunctionalDualDistanceAtLeast O d` then gives
  `blockFunctional_outerAlternative`, exactly the zero-or-weight-`≥d` input consumed by transfer.
- Added `q9Inner_transfer_ofOuterCode`: for the real `[10,4,6]₉` seed, concatenation orthogonality,
  functional outer-dual distance at least five, and total q-ary weight at most four imply every
  block is inner-dual and at most one block is nonzero. Coefficient faithfulness, both numeric
  gates, and outer-dual membership are all internal proofs; no trace-form or decomposition import
  remains.
- Corrected the live handoff, code documentation, and coding sweep. The sweep retains an explicit
  dated correction because it overturns an already-committed attribution; the citation-audit note
  remains the detailed evidence trail. The real q=9 block-local transfer path is closed; the
  concrete repair hypergraph is now first in the open queue.

### Handoff Note — 2026-07-12 (code-derived q9 repair hypergraph)

- Added `FiniteGeom/Repair.lean`, defining `wordSupport` and the complete bounded-radius
  `repairHypergraph C x r`: helper sets `R ⊆ univ.erase x` with `|R|≤r` for which an actual dual
  word is nonzero at `x` and has support exactly `{x}∪R`. This is all bounded dual supports, not a
  selected family of declared repair groups.
- Proved `repair_edge_card_eq_of_dualDist`: when `r+1≤d(C⊥)`, every radius-`r` edge has exactly
  `r` helpers. The witness has weight `|R|+1`; dual distance supplies the lower bound and the
  radius definition supplies the upper bound. Also proved edge nonemptiness for positive radius.
- Instantiated the real seed at its distinguished axis coordinate:
  `q9AxisRepairHypergraph = repairHypergraph q9InnerCode q9Axis 3`. The existing explicit
  `{0,1,-1,e₂}` dual word gives the concrete helper edge `{0,1,-1}`; hence the hypergraph is
  nonempty. Exact `d(C₀⊥)=4` makes every edge a three-helper minimum repair.
- This closes the object-definition/non-vacuity part of the concrete repair lane. The remaining
  theorem is now purely sharp: characterize all edges as distinct zero-sum triples in `𝔽₉`,
  transport to affine lines of `AG(2,3)`, and prove `ν=3`, `τ=5`. The latter will be the first
  code-derived strict `τ>ν` witness.
- Validation: `nix develop --command lake build FiniteGeom RepairCodes` green with no Lean
  warnings. `#print axioms` on the repair hypergraph definition, dual-distance cardinality lemma,
  concrete edge membership/cardinality, and nonemptiness returned exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (q9 repair edges are zero-sum triples)

- Added `dual_word_column_relation`, turning row-code dual membership into an explicit linear
  relation among generator columns. `FiniteGeom/Repair.lean` now packages this as
  `repair_edge_columns_dependent` and, after an arbitrary square reindexing,
  `repair_edge_reindexed_det_eq_zero`.
- Computed the generalized Vandermonde determinant for three finite cubic columns with the axis
  column `e₂`. For distinct parameters its determinant vanishes exactly when their sum is zero.
  The proof expands only the single nonzero axis cofactor and reduces the resulting 3×3
  determinant algebraically.
- Added the finite-coordinate parameter map `q9IndexParam`. Every actual edge of
  `q9AxisRepairHypergraph` can now be enumerated by `Fin 3`; its parameters are distinct and sum
  to zero (`q9AxisRepair_edge_zeroSum`). This proves the forward half of the exact affine-line
  characterization from the code definition, rather than from a declared combinatorial family.
- Remaining in this lane: construct a full-support dual relation from each distinct zero-sum
  triple (the converse), transport the resulting hypergraph to `AG(2,3)`, and prove
  `matchingNumber=3`, `transversalNumber=5`.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on the column-relation and determinant bridges, determinant criterion, and q9
  zero-sum theorem returned exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (exact q9 zero-sum edge characterization)

- Added the reverse generator-column bridge
  `mem_dualCode_rowCode_of_column_relation`. In `FiniteGeom/Repair.lean`, the reusable theorem
  `mem_repairHypergraph_of_columns_dependent` extends a dependent selected-column relation to a
  dual word; when the selected family has the minimum size allowed by dual distance, cardinality
  forces its support to contain every helper and the target.
- Factored the q9 helper-plus-axis ordering into `q9AxisSupport_reindex`, shared by both directions
  of the characterization. This keeps the determinant calculation tied to one canonical
  three-finite-columns-plus-axis matrix.
- Proved `q9AxisRepair_edge_of_zeroSum` and the exact theorem
  `q9AxisRepair_edge_iff_zeroSum`: the code-derived axis repair edges are precisely the
  three-element non-axis sets whose distinct `𝔽₉` parameters sum to zero.
- The next step is now purely combinatorial/linear: transport the zero-sum triple hypergraph along
  an additive equivalence `𝔽₉ ≃ (Fin 2 → ZMod 3)`, identify it with the twelve affine lines of
  `AG(2,3)`, and prove `matchingNumber=3`, `transversalNumber=5`.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on both reverse bridges, the shared support reindexing, and both converse/exact
  q9 theorems returned exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (affine-plane zero-sum invariants)

- Extended `FiniteGeom/Hypergraph.lean` with bijective vertex relabeling, preservation of
  matchings/transversals, and exact invariance of `matchingNumber` and `transversalNumber`.
- Added `RepairCodes/Q9Affine.lean` and the general three-element zero-sum hypergraph. Additive
  equivalences relabel this hypergraph exactly. A basis over `ZMod 3` supplies the linear
  equivalence `𝔽₉ ≃ (Fin 2 → ZMod 3)`.
- Proved the affine-plane values `matchingNumber=3`, `transversalNumber=5`. An explicit parallel
  class supplies the three-edge matching; disjoint-union cardinality proves no matching has four
  edges. An explicit five-point cover and the sharp lower bound are checked over the 512 vertex
  subsets with kernel `decide`; no `native_decide` or generated certificate is used.
- Transport along the additive equivalence gives the same sharp values for the zero-sum triple
  hypergraph on `𝔽₉`. The remaining bridge to the actual code hypergraph is injective rather than
  bijective: `q9FiniteIndex` maps the nine field elements into `Fin 10`, with the axis as one
  isolated vertex. Prove extremal invariance under that isolated-vertex embedding, then rewrite
  edges using `q9AxisRepair_edge_iff_zeroSum`.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on relabeling invariance, additive transport, the affine-plane computation,
  basis equivalence, and GF9 invariant theorem returned exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (GF9 triples embed as q9 repair edges)

- Added the inverse coordinate identity `q9FiniteIndex_indexParam` and packaged
  `q9FiniteEmbedding : 𝔽₉ ↪ Fin 10`.
- Proved `q9FiniteImage_mem_repair`: every edge of the GF9 zero-sum triple hypergraph maps to an
  actual edge of `q9AxisRepairHypergraph`. The proof explicitly reindexes the mapped three-set,
  transports its finite sum through the equivalence, and applies the exact converse theorem from
  `Q9Seed`.
- Remaining: map a maximum GF9 matching forward for `ν≥3`, use three-uniformity and the nine
  finite coordinates for `ν≤3`, map a five-point GF9 transversal forward for `τ≤5`, and pull any
  q9 transversal back along `q9FiniteEmbedding` for `τ≥5`.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on the coordinate inverse, embedding, and edge-image theorem returned exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (exact embedded q9 hypergraph)

- Proved `q9RepairEdge_exists_finiteImage`: every actual q9 repair edge is the image of a GF9
  zero-sum triple. The proof enumerates the edge, forms its parameter image, and uses the inverse
  finite-coordinate identity to recover the original helper set exactly.
- Consequently `q9AxisRepairHypergraph_eq_finiteImage` identifies the code-derived hypergraph
  literally with the edgewise image of the GF9 affine-line hypergraph. Only extremal-number
  bookkeeping across the isolated axis remains.

### Handoff Note — 2026-07-12 (code-derived q9 strict gap complete)

- Proved `q9AxisRepairHypergraph_invariants`:
  `matchingNumber q9AxisRepairHypergraph = 3` and
  `transversalNumber q9AxisRepairHypergraph = 5`.
- For `ν≥3`, a maximum GF9 affine-line matching is mapped into the finite seed coordinates;
  `ν≤3` follows because disjoint three-helper edges must fit in the nine non-axis coordinates.
- For `τ≤5`, a minimum GF9 line cover is mapped forward. For `τ≥5`, every q9 cover is pulled
  back along `q9FiniteEmbedding`; the isolated axis disappears and cardinality cannot increase.
- This closes the concrete q9 repair lane and supplies the first repair hypergraph derived from an
  actual linear code with a formally verified strict gap `τ>ν`.
- Validation: full `nix develop --command lake build RepairCodes` green with no Lean warnings.
  `#print axioms` on the final embedded equality and invariant theorem returned exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (uniform characteristic-three code parameters complete)

- Added `FiniteGeom/AxisTwistedCubic.lean` with the natural `𝔽 ⊕ 𝔽 ⊕ Unit` indexing of the affine
  twisted cubic plus its full axis. The section count splits into cubic and axis blocks.
- Proved the exact maximum plane section `q+2`: a plane not containing the axis contributes at
  most `3+1`; a plane containing it has cubic equation `a₀+a₃t³=0`, so Frobenius injectivity in
  characteristic three gives at most one cubic point. The form `X₃=0` attains the bound.
- Proved the system spans in dimension four directly from cubic parameters `0,1` and two axis
  points. This covers `q=3` as well as the paper's `q≥9` range, where the earlier four-cubic-point
  spanning route was unavailable at the smallest field.
- The headline theorem `axisTwistedCubic_code_parameters` gives exact `[2q+1,4,q−1]_q` parameters
  over every finite characteristic-three field. The next uniform-family frontier is the
  size-at-most-four circuit classification and the locality / `τ>ν` analysis.
- Validation: focused Lean compilation and full `nix develop --command lake build RepairCodes`
  pass with no Lean warnings. Both the maximum-section theorem and headline parameter theorem have
  axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (uniform small-circuit algebra)

- Added `FiniteGeom/AxisTwistedCubicCircuits.lean`. The q9 determinant calculation is generalized
  over an arbitrary field and arbitrary axis vector: three cubic parameters `s,t,u` plus
  `(0,e₁,e₂,0)` are dependent exactly when
  `e₁(st+su+tu)=e₂(s+t+u)` (for distinct parameters).
- In characteristic three, proved that `(s+t+u,st+su+tu)` is nonzero for distinct parameters and
  that every dependent axis vector is its scalar multiple. The normalized finite/infinite axis
  point in the actual `S_q` point system therefore gives the unique projective completion.
- Proved that completion is a genuine four-circuit: the four columns are dependent and every
  three-column deletion is independent. Separately proved that three distinct axis points form a
  three-circuit, while one cubic plus two axis points, two cubics plus one axis point, and two
  cubics plus two axis points are independent. Together with the existing moment-curve bounds,
  these are all algebraic cases in the size-at-most-four circuit classification.
- Added a Discovery track to the live handoff using the explicit taxonomy from the relative-conic
  formalization. The `q=3` parameter extension, field-generic determinant, and projective-uniqueness
  consequence are recorded as proved results; novelty remains reserved for C98's literature audit.
- Remaining: package the family-level lemmas as an exact arbitrary-coordinate-set classification,
  then identify the resulting circuits with complete repair hypergraphs and derive locality and
  matching/transversal formulas.
- Validation: focused compilation and full `nix develop --command lake build RepairCodes` pass
  without warnings. Load-bearing determinant, projective-uniqueness, four-circuit, and mixed-family
  independence theorems have axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (uniform all-symbol locality bridge)

- Generalized the dual/row-code and repair-hypergraph APIs from `Fin n` to arbitrary finite
  coordinate types, preserving the q9 source API. Added radius monotonicity and full-support,
  circuit-local, and reindexed circuit converses.
- The circuit-local converse is essential here: the full `S_q` code has axis three-circuits, so its
  global dual distance cannot justify cubic four-circuit repairs through the old `d⊥≥4` converse.
  Minimality of the selected circuit supplies the required full-support dual relation directly.
- Added `RepairCodes/AxisTwistedCubic.lean`, identifying its natural-index row code with the
  existing column code. Three distinct cubic points produce an actual three-helper repair edge via
  their unique completing axis point; three distinct axis points produce an actual two-helper edge.
- Canonical triples through any requested coordinate yield
  `axisTwistedCubic_allSymbol_locality_three`: every coordinate has a repair edge of radius at most
  three over every finite characteristic-three field, including `q=3`.
- Remaining uniform-family mathematics: transport all family-level independence cases to an exact
  arbitrary-coordinate-set classification, deduce the locality lower bounds, and prove the
  per-orbit matching/transversal formulas with the `Z₃(q)` boundary explicit.
- Validation: `nix develop --command lake build RepairCodes` completed successfully without Lean
  warnings. The row/column identification, both orbit repair-edge theorems, circuit bridge, and
  all-symbol locality theorem have axiom profile exactly
  `[propext, Classical.choice, Quot.sound]`; the touched source has no `sorry`, `admit`,
  `native_decide`, or custom axiom declaration.

### Handoff Note — 2026-07-12 (uniform exact locality)

- Classified arbitrary distinct triples of `S_q`: every triple containing a cubic coordinate is
  independent in characteristic three, while the already-proved all-axis triples are circuits.
  Also packaged nonzero columns, pairwise independence, and independence of every selected family
  of size at most two.
- Applied the arbitrary-set statements to code-derived repair edges. A cubic repair with at most
  two helpers would force a dependent selected family of at most three columns containing a cubic;
  an axis repair with at most one helper would force a dependent family of at most two columns.
  Both contradict the classification.
- Combined with the explicit repair edges to prove `cubicCoordinate_exact_locality_three` and
  `axisCoordinate_exact_locality_two`. Thus exact all-symbol locality is now closed for every
  finite characteristic-three field; only the size-four/per-orbit extremal analysis remains in
  Phase 1 step 4.
- Validation: the full `RepairCodes` target builds without warnings. Both exact-locality headline
  theorems have axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (minimal-repair semantic gate)

- Re-read the uniform `ν`/`τ` formulas against the Lean definition. The paper correctly states
  them for complete **inclusion-minimal** repair hypergraphs; `repairHypergraph` intentionally stores
  every bounded exact dual support, including nonminimal supports.
- Therefore the formulas must pass through a minimal-repair clutter. Existing
  `FiniteGeom/BaerCompletion/Clutter.lean` proves that minimal-edge reduction preserves
  transversals and `τ`. A matching-preservation theorem is also valid when every edge is nonempty:
  shrink each edge of a matching to a nonempty minimal subedge, preserving disjointness and
  cardinality. That generic lemma and the repair-specific clutter wrapper are the next formal step.
- This is a formal path/statement-adequacy issue, not a defect in the prose mathematics. Applying
  the paper's formulas directly to the all-support Lean hypergraph would, however, be an invalid
  unproved identification under the strict gate.

### Handoff Note — 2026-07-12 (minimal-repair semantic gate closed)

- Generalized minimal-edge reduction into `FiniteGeom/Hypergraph.lean`. Every edge contains an
  inclusion-minimal subedge; transversals are equivalent before and after reduction, and a
  matching can be shrunk edgewise without changing its cardinality when all edges are nonempty.
  Consequently both `transversalNumber_minimalHyperedges` and
  `matchingNumber_minimalHyperedges` are Lean-proved.
- Added the paper-facing `minimalRepairHypergraph` wrapper and its generic invariant bridges.
  For the twisted-cubic–axis code, proved every repair edge nonempty directly from dependence of
  the target-plus-helper columns and the nonzero target column. This is stronger than relying on
  global dual distance and applies at radius three despite the axis three-circuits.
- `matchingNumber_minimalAxisTwistedCubicRepairHypergraph` and
  `transversalNumber_minimalAxisTwistedCubicRepairHypergraph` now close the exact semantic gap
  between Lean's complete all-support repair object and the paper's inclusion-minimal clutter.
- Validation: `FiniteGeom.Hypergraph`, `FiniteGeom.Repair`, and
  `RepairCodes.AxisTwistedCubic` all build successfully.

### Handoff Note — 2026-07-12 (cubic repair classification, first cases)

- Added an explicit equivalence enumerating any four-element target/helper support, allowing the
  geometric finite-family independence and determinant theorems to be applied directly to an
  arbitrary repair edge.
- Proved `cubicRepair_axis_eq_of_mem`: if a cubic target has two cubic helpers and one axis helper,
  the axis helper is forced to equal the normalized symmetric-polynomial completion. This uses the
  code-derived repair determinant and the field-generic determinant equation; there is no chosen
  repair-family assumption.
- Proved the competing four-cubic and two-cubic/two-axis support patterns cannot be repairs, by
  transporting the corresponding independent-family theorems to the exact support subtype.
- Remaining cubic classification case: exclude three axis helpers using the full-support dual
  relation (its cubic-target coefficient is killed by the `X₀` coordinate), then package the exact
  repair-hypergraph membership iff.
- Validation: `RepairCodes.AxisTwistedCubic` builds successfully; the new classification theorems
  have only the standard foundational axiom profile.

### Handoff Note — 2026-07-12 (cubic all-axis support excluded)

- Proved `cubicRepair_threeAxis_not_mem` directly from the full-support dual witness: evaluating
  its generator-column relation at `X₀` kills every axis term and forces the cubic target
  coefficient to zero, contradicting repair membership.
- This closes the last helper-type exclusion for cubic targets; only assembling the cases into the
  exact membership iff remains before the coloured-complete-graph invariant proof.

### Handoff Note — 2026-07-12 (exact cubic repair classification)

- Proved every radius-three cubic repair has exactly three helpers, since any smaller support
  would contradict the exact-locality lower bound.
- Exhausted all eight cubic/axis type patterns for those helpers. The only surviving case is two
  other cubic points and the forced normalized axis completion.
- Combined this forward classification with the previously constructed four-circuit repairs to
  prove `mem_cubicRepairHypergraph_iff`, an exact characterization of the complete code-derived
  repair hypergraph. The next layer may now reason purely with the properly edge-coloured complete
  graph without an unproved geometric identification.
- Validation: `RepairCodes.AxisTwistedCubic` builds without warnings; the classification uses only
  standard foundational axioms.

### Handoff Note — 2026-07-12 (cubic orbit extremal invariants)

- Added a reusable augmented properly edge-coloured complete-graph module. It proves every
  matching uses two graph vertices per edge, so `ν≤⌊n/2⌋`, and proves `τ=n−1` by counting the
  distinct colors forced by the uncovered vertices of any transversal.
- Proved the actual symmetric-polynomial completion coloring is proper. For fixed target `x` and
  helper `s`, its finite branch is a Möbius map with determinant
  `(x+s)²−xs=(x−s)²` in characteristic three; the infinite branch is handled explicitly.
- Applied the exact code-derived support iff directly—without a selected-family substitution—to
  prove `cubicRepair_transversalNumber : τ_T=q−2` and
  `cubicRepair_matchingNumber_le : ν_T≤(q−1)/2`. Therefore every cubic coordinate has strict
  `τ>ν` for `q≥9`.
- This formalizes the headline-relevant part of the paper's displayed cubic bounds. The stronger
  lower bound `ceil((q−2)/3)≤ν_T` is not needed for strictness and remains to be audited against the
  maximal-rainbow-matching prose if the complete displayed interval is retained as `[PROVED]`.
- Validation: focused builds are warning-free and the headline axiom profiles are exactly
  `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (exact axis minimal-repair clutter)

- Added the generic `repairHypergraph_retarget` theorem: a full-support dual relation can repair
  any coordinate in its support, with the old target becoming a helper. This is a reusable
  strengthening of the circuit-to-repair bridge.
- Proved radius-two repairs at an axis coordinate are exactly pairs of other axis points.
- Retargeted three-cubic axis repairs to the already-classified cubic orbit, proving such a support
  repairs exactly its unique normalized completing axis coordinate. Supports with two cubic
  helpers and one extra axis helper are impossible by the same retargeting argument.
- Proved every radius-three axis repair either contains an axis-pair repair or is an exact
  three-cubic completion. Applying inclusion minimality then gives
  `mem_minimalAxisRepairHypergraph_iff`: the paper-facing clutter contains exactly those two
  canonical types. Thus nonminimal all-axis dual supports are formally removed rather than
  silently omitted.
- Validation: the focused invariant target builds without warnings and the new bridge and
  classification theorems have only the standard foundational axiom profile.

### Handoff Note — 2026-07-12 (uniform all-symbol strict gap closed)

- The exact minimal axis clutter yields an elementary weighted matching bound. Every pair repair
  consumes two of the `q` available axis helpers and every completion triple consumes three of the
  `q` cubic helpers, on disjoint grounds; summing over a matching proves `6ν≤5q`.
- Every axis transversal must hit the complete graph on the `q` other axis coordinates, so it
  contains at least `q−1` vertices. Thus `τ>ν` for every axis coordinate when `q≥9`, with no
  cap-set estimate.
- Combined this with the exact cubic theorem to prove
  `axisTwistedCubic_allSymbol_tau_gt_nu` for the complete code-derived radius-three repair
  hypergraph at every coordinate. Minimal-clutter invariance transfers the axis proof back to the
  all-support Lean object.
- This strengthens the proof architecture in the paper: `Z₃(q)` is needed only for the sharp
  orbit formulas/asymptotic ratios, not for the headline all-symbol separation.
- Validation: the invariant target is warning-free; the all-symbol theorem's axiom profile is
  exactly `[propext, Classical.choice, Quot.sound]`.

### Handoff Note — 2026-07-12 (Phase 1 completion and strict-gate review)

- Proved the sharp nucleus and finite-axis repair formulas, the exact q9 row table, and the
  algebraic four-edge rainbow matching certificate without `native_decide`.
- Constructed the actual concatenated submodule and proved its dimension, distance lower bound,
  exact complete-repair-hypergraph transfer, locality, row invariants, and `7ν≤4τ`.
- Corrected the inner-distance premise: the full `[19,4,8]₉` code has global dual distance three
  because of axis triples. The transfer theorem needs only `r+1<2*d(I⊥)`, so radius three remains
  valid. This is a genuine generalization, not a paper defect.
- Closed the script-only diagnostics with kernel-checked proofs: exact `28`, `36+8`, `36+12`
  repair counts and the `120`/`84` small-circuit support inventory.
- Ran the strict adversarial review recorded in
  `notes/2026-07-12-axis-twisted-cubic-adversarial-review.md`. The finite theorem chain passes with
  only the standard foundational axiom profile. The PGL orbit provenance is context-only; the
  outer trace bridge and asymptotically good outer-family existence remain explicit external
  mathematics before an unconditional asymptotic theorem can be claimed.
- Updated the research ledger and registry to match the formal boundary and added
  `lean/RepairCodes/TRUST.md` as the stable trust-chain description.

### Handoff Note — 2026-07-13 (RepairCodes asymptotic closure)

- C102 closed with a kernel proof of the finite-separable trace-duality bridge, including ordinary
  extension-dual membership and exact support equality after restriction of scalars.
- The degree-four extension lift now constructs the actual concatenated submodule and proves
  `[19N,4K,≥8D]₉` plus exact complete repair-row transfer from ordinary dual distance.
- C103 uses exactly one quarantined result: Stichtenoth, arXiv:math/0506264, Theorem 1.6(ii),
  specialized to self-dual codes over `GF(6561)` with limiting distance at least `39/80`.
- Lean constructs concrete `GF(9) ⊆ GF(6561)`, proves degree four, and derives unbounded length,
  exact rate `2/19`, eventual relative distance at least `8/57`, and exact rows
  `(4,7),(6,12),(7,13)` at every coordinate.
- The strict adversarial pass found no further math blocker.  The concrete headline axiom report is
  exactly the Stichtenoth import plus `propext`, `Classical.choice`, and `Quot.sound`; all finite and
  reduction theorems remain import-free.  C97 is unblocked for full manuscript assembly and the
  specialist novelty/citation audit.

### Handoff Note — 2026-07-13 (C97 manuscript and internal novelty audit)

- Assembled `papers/coding-repair-hypergraphs/`: a self-contained 12-page LaTeX manuscript/PDF,
  bibliography, README, proof ledger, and claim-by-claim adversarial novelty report.
- The literature attack found and corrected one real positioning error:
  Pamies-Juarez--Hollmann--Oggier, Definition 3, explicitly defines the same minimum hitting-set
  invariant as local repair tolerance. The paper now treats both that invariant and the broader
  regenerating-set framework as prior art.
- Added the closest current adjacent work: Gruica--Jany--Ravagnani on refined dual-support weight
  distributions and Jin--Fu on concatenated binary LRCs. Neither checked source states the exact
  coordinatewise `(ν,τ)` results or complete bounded repair-hypergraph transfer.
- Removed the unsupported word “sharp” from the transfer hypothesis. Lean proves sufficiency of
  `r+1<2*d(I⊥)`, not global necessity.
- The surviving candidate novelty is narrow and explicitly qualified: exact all-symbol
  matching/transversal separation for the twisted-cubic--axis family, and complete bounded
  repair-hypergraph equality under the dual-distance gates. The asymptotic theorem is positioned
  as their derived fixed-alphabet application, not as novelty for AG concatenation itself.
- Tectonic rebuilt the PDF with no citation/reference/box warnings; `lake build RepairCodes`,
  forbidden-token scan, and axiom audit pass. C97 is reported. An external coding-theory
  citation-chain review remains a submission preflight gate, not a mathematics or formalization
  blocker.

### Handoff Note — 2026-07-13 (paper/Lean consistency pass)

- Ran a theorem-by-theorem checklist across the manuscript, Lean declarations, trust boundary,
  novelty report, bibliography, paper registry, task queue, and handoff.
- Corrected the finite-lift parameter display from malformed punctuation to
  `[19N,4K,≥8D]₉`; standardized lifted/asymptotic locality as “at most three”; and marked the
  legacy `[10,4,6]₉` seed as formal-library-only rather than part of this manuscript.
- Removed two stale registry statements: the transfer gate is sufficient, not proved sharp, and
  the internal novelty audit is complete rather than pending.
- Closed two proof-ledger omissions. `axisTwistedCubic_q9_ratio` now directly kernel-checks the
  paper's `7ν≤4τ` corollary, and the existing `q9_smallCircuit_support_counts` theorem is mapped to
  the manuscript's `120/84` inventory claim.
- Rechecked Stichtenoth Theorem 1.6(ii) against the primary paper. Its self-dual sequence and
  limiting-distance statement match the single imported axiom; `ℓ=81` gives `39/80`.
- Validation is green: `lake build RepairCodes`; exactly one project axiom in `RepairCodes`;
  forbidden-token scan otherwise empty; zero missing/unused citation keys, missing/duplicate
  labels, or duplicate bibliography keys; warning-free 12-page Tectonic PDF.
- The completed checklist is in `papers/coding-repair-hypergraphs/proof_ledger.md`. The only open
  box is the external specialist citation-chain review, which remains a submission preflight gate.

### Handoff Note — 2026-07-13 (small theorem tightenings and rolling novelty check)

- Strengthened the asymptotic arithmetic from the earlier displayed `8/57` bound to `1/5` by
  kernel-checking the eventual inequality `19N≤40D`, a direct consequence of
  `39/80>19/40`.
- Generalized the extension-lift transfer through radii one, two, and three. This proves exact
  locality three on cubic coordinates and exact locality two on both axis types, rather than only
  all-symbol locality at most three.
- Added kernel theorems for a disjoint exhaustive lifted coordinate partition, exact
  multiplicities `9N,9N,N`, and guaranteed arbitrary-helper failure thresholds `6,11,12`.
- The rolling novelty check kept these as derived tightenings: they sharpen the statement and its
  operational interpretation but do not change the two surviving candidate-novelty loci. Primary
  sources continue to establish ordinary locality-preserving concatenation, AG asymptotics, and
  repair tolerance as prior art.
- Rebuilt the full `RepairCodes` aggregate and 12-page paper. New finite declarations use only the
  standard logical axioms; the asymptotic headline still adds exactly the single quarantined
  Stichtenoth import. The PDF has no citation, reference, or box warnings.

### Handoff Note — 2026-07-13 (near-limit and generic exact-locality strengthening)

- Kernel-proved that every fixed real `c<39/190` is eventually a strict lifted relative-distance
  lower bound. The eventual index may depend on `c`; no endpoint attainment claim is made.
- Bundled the disjoint coordinate partition, `9N,9N,N` multiplicities, exact mixed locality, all
  three rows, and thresholds `6,11,12` directly into `HasQ9UniformRepairFamily`.
- Added the reusable `HasExactLocalityAt` predicate and proved that radius-`r` transfer gates
  preserve every exact locality `s≤r`.
- Classified all three changes as derived tightenings. They improve statement precision and API
  reuse without changing the paper's two cautious candidate-novelty loci or its single imported
  Stichtenoth boundary.


## Live-file snapshot before pruning — 2026-07-15

# Lean formalization plan — the -10 / -11 PROVED corpus

**Lane**: `repaircodes` — see CLAUDE.md § Lane routing. Pegged to the lane that owns the
delivered work; the `CompletionCore` / `ContinuationRigidity` / `BaerExtension` phases named in
the original scope were never started.

**Date**: 2026-07-11
**Status**: REPAIRCODES FORMALIZATION AND MANUSCRIPT TRACK COMPLETE under the strict trust gate. The uniform axis–twisted-cubic code,
small-circuit classification, exact repair clutters and sharp invariants, q=9 `[19,4,8]₉` row and
edge-count table, `120`/`84` support inventory, and conditional finite seed-and-lift theorem are
Lean-proved. The full seed has global dual distance three; transfer uses the correct weaker gate
`r+1 < 2*d(I⊥)`, so radius three remains valid. The strict-gate review is
[recorded separately](../2026-07-12-axis-twisted-cubic-adversarial-review.md), and the stable trust
boundary is in [`lean/RepairCodes/TRUST.md`](../../lean/RepairCodes/TRUST.md). The trace-duality
bridge, degree-four extension lift, concrete finite-field instantiation, and asymptotic reduction
are Lean-proved.  The resulting unbounded q9 family has exact rate `2/19`, eventual relative
distance greater than every fixed `c<39/190` (with `1/5` retained as a clean corollary), exact
locality three on cubic coordinates and two on axis coordinates, and exact repair rows; its sole
deep dependency is the quarantined
Stichtenoth self-dual TVZ theorem (arXiv:math/0506264, Theorem 1.6(ii)).  The asymptotic strict-gate
review is [recorded separately](../2026-07-13-repaircodes-asymptotic-adversarial-review.md).
The assembled manuscript, PDF, proof ledger, and adversarial novelty report are in
[`papers/coding-repair-hypergraphs/`](../../papers/coding-repair-hypergraphs/). The internal
novelty audit returns the repair-tolerance invariant to explicit prior art and retains only
cautious candidate claims for the exact all-symbol `(ν,τ)` separation and complete-hypergraph
transfer. It now also includes the projectively completed `[2q+2,4,q]_q` seed, its exact full
minimal radius-four repair rows, the `[20N,4K,>=9D]_9` q9 lift, and the second unbounded family
with exact rate `1/10` and every fixed eventual distance bound `c<351/1600`. Those additions are
Lean-checked under the same strict boundary: finite results use only standard logical axioms, and
the asymptotic family adds exactly the quarantined Stichtenoth import. Their geometry, ordinary
parameters, and rate/distance arithmetic are classified as classical or derived; only the exact
completed repair rows and bounded transfer retain cautious none-found candidate wording. An
external specialist citation-chain review remains a submission preflight gate.
The synchronized theorem/source/build checklist is maintained in
[`proof_ledger.md`](../../papers/coding-repair-hypergraphs/proof_ledger.md); every internal box is
checked, with only that external review left open.
Session-by-session narrative lives in the
[archive companion](done/2026-07-11-lean-formalization-plan-archive.md).
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
| `PGL(2,q)`, symmetric cube | `GeneralLinearGroup`, `MulAction` present; `Sym^3` — absent | not needed by the RepairCodes proof chain: define the full axis directly; retain the orbit derivation as optional context |
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
1. `[PROVE]` transfer lemma (§1.4): `r+1 < 2*d(I⊥)` plus the outer functional-dual gate ⇒ every
   dual word of weight `≤r+1`
   dual word is confined to one inner block ⇒ the complete radius-`r` repair hypergraph transfers.
   Clean dual-weight/trace argument — the crux novelty, and it proves in Lean without any imported
   analytic input. **This is the single highest-value Lean target in the whole corpus.**
2. `[PROVE]` `δ_x = τ(𝓑_x)` completion-distance invariant (§3 / completion-core Prop 2.2, 2.4).
3. `[PROVE]` the `q=9` axis–twisted-cubic seed: `C_orb=[19,4,8]_9`, the three
   `(ν,τ)=(4,7),(6,12),(7,13)` rows, exact repair counts, `120`/`84` circuit-support inventory,
   and all-symbol locality ≤3. This closed more strongly than the planned certificate route.
4. `[PROVE]` uniform `q=3^h` theorem (§1.5.1): `C(S_q)=[2q+1,4,q-1]_q`, all-symbol `τ>ν`.
5. `[PROVE, conditional]` seed-and-lift (§1.4/§1.5): construct the finite concatenated code and
   transfer its complete repair hypergraphs under explicit outer-code hypotheses. The finite
   theorem is complete; the asymptotic outer-family instantiation remains external.

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

2. **Single-`q` tables — no `native_decide`.** The original fallback was a generated certificate.
   The q=9 table closed more strongly by algebraic proofs plus tiny kernel-`decide` checks, with
   `#print axioms` clean.

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
discharging instance) is the first commitment; the rest sequences behind it.

## 6. Provenance
Backing scripts (COMPUTED-EXACT sources for the `[CERT]` items) are tracked under
[`notes/scripts/2026-07-11-coding-mds-sweep/`](../scripts/2026-07-11-coding-mds-sweep/) with frozen
hashes; each `[CERT]` Lean cert should regenerate from the corresponding script and be checked by a
rules-only validator, mirroring `ProjectiveCap/CertData/`.

## 7. Current state

Two `[[lean_lib]]` targets (`FiniteGeom`, `RepairCodes`) are wired into `lakefile.toml` and
`defaultTargets`. Everything below is `#print axioms`-clean
(`[propext, Classical.choice, Quot.sound]` only — no `sorryAx`, no `native_decide`);
`lake build FiniteGeom RepairCodes` is green with no warnings. Abstract-first (decision 1):
deep/imported inputs enter as named hypotheses, never global axioms (decision 3).

| Module | Landed content |
|---|---|
| `FiniteGeom/Weight.lean` | q-ary weight counting: `card_filter_le_sum`, `mul_card_filter_le_sum` |
| `FiniteGeom/Hypergraph.lean`, `ColoredCompleteGraph.lean` | `Finset`-hypergraph `ν`/`τ`: weak duality, `τ ≤ p·ν`, extremal-value pins, minimal-clutter invariance, and the generic properly colored complete-graph package (`τ=n−1`, `ν≤⌊n/2⌋`) |
| `FiniteGeom/Code.lean` | linear codes over arbitrary finite coordinate types: `dualCode` / `minDist` / `dualDist` (+ `_le_hammingNorm` pins), parity-check char. `mem_dualCode_rowCode(_iff_mulVec)`, dual-word ↔ generator-column relation bridges, `le_dualDist_rowCode_of_column_independent` (small independent column sets imply a dual-distance lower bound), `singleton_bound` (`d+k≤n+1`) + `IsMDS`, `le_minDist` (lower-bound lifter), `𝔽₅` non-vacuity witness |
| `FiniteGeom/EvalCode.lean` | Reed–Solomon: `card_eval_zero_le_natDegree`, `evalPi`, `rsCode`, `rsCode_minDist_ge` (`n-(k-1)≤d`), `finrank_rsCode` (`=k`), `rsCode_isMDS` (RS codes are MDS) |
| `FiniteGeom/EvalCodeInstance.lean` | concrete MDS discharge of the eval-code layer: RS `[7,3,5]₇` over `ZMod 7` (`rsCode_zmod7_isMDS`/`_minDist`) and RS `[3,2,2]₉` over the target `GaloisField 3 2 = 𝔽₉` on subfield points (`rsCode_gf9_isMDS`/`_minDist`, injectivity via `algebraMap`) — exercises `rsCode_isMDS` on a real non-prime field |
| `FiniteGeom/MomentCurve.lean` | moment-curve / NRC general position via Vandermonde: `momentCurve`, `momentCurve_linearIndependent` (square family), `momentCurve_linearIndependent_of_card_le` (any distinct family of size `≤n`), `twistedCubic_linearIndependent` (`n=4`, no four coplanar), `twistedCubic_span` (four distinct cubic points span `𝔽⁴`); **hyperplane sections**: `formPoly` + `momentCurve_section_le` — the sharp "plane meets twisted cubic in `≤3` points" `T_q` bound |
| `FiniteGeom/ColumnCode.lean` | projective systems as codes over a general `Fintype` index `ι` (`columnCode` for a point system `P : ι → 𝔽^k`), `sectionCount`, weight↔section identity, `le_columnCode_minDist` (all sections `≤ s` ⇒ `card ι − s ≤ d`), `columnCode_minDist_le`, `columnCode_minDist_eq` (`d = card ι − max section`), `finrank_columnCode` (`dim = k` when points span) — the geometric-distance bridge for the whole geometric-code lane. (`minDist`/`le_minDist`/`minDist_le_hammingNorm` in `Code.lean` generalized `Fin n → ι`, backward-compatible, so the `S_q` point system can be indexed by the natural `𝔽 ⊕ 𝔽 ⊕ Unit`.) |
| `FiniteGeom/AxisTwistedCubic.lean` | explicit `S_q=T_q∪L_q` on `𝔽 ⊕ 𝔽 ⊕ Unit`; axis/cubic section split; characteristic-three Frobenius bound; exact maximum section `q+2`; direct four-vector spanning proof (including `q=3`); strict-trust `axisTwistedCubic_code_parameters : [2q+1,4,q−1]_q` |
| `FiniteGeom/AxisTwistedCubicCircuits.lean` | field-generic determinant for three cubic points plus an arbitrary axis vector; characteristic-three unique projective completion `(0:s+t+u:st+su+tu:0)`; normalized completing point in the actual `S_q`; minimal four-circuit proof; axis three-circuits; and independence of every other mixed triple plus the two-cubic/two-axis four-family |
| `FiniteGeom/Completion.lean` | `completionDistance_eq_transversalNumber` (`δ_x = τ`, abstract identity — the matroid step folded into the deletion predicate) |
| `FiniteGeom/Repair.lean` | coordinate-type-generic complete bounded-radius repair hypergraph from actual dual-word supports; paper-facing inclusion-minimal repair clutter; radius monotonicity; exact edge cardinality/nonemptiness from dual distance; clutter invariance; repair edge → dependent columns/zero determinant; global-distance, full-support, circuit-local, and reindexed converses. |
| `RepairCodes/Transfer.lean` | concatenation transfer lemma (`transfer_blockwise` / `transfer_single_block` / `transfer_lemma`) over the abstract `ConcatDualWord` interface |
| `RepairCodes/CodeInstance.lean` | `ofInnerCode` / `transfer_ofInnerCode`; plus coordinate-free `blockFunctional`, `blockFunctional_eq_zero_iff`, `ofInnerCodeFunctional`, and `transfer_ofInnerCodeFunctional`. An encoder equivalence `V ≃ₗ I` discharges coefficient faithfulness internally; field trace is only an optional coordinate presentation. |
| `RepairCodes/OuterDual.lean` | coordinate-free outer dual `functionalDual O ≤ (ι → V*)`, `HasFunctionalDualDistanceAtLeast`, concatenation orthogonality, direct `blockFunctional_mem_functionalDual`, and `blockFunctional_outerAlternative`; `hasFunctionalDualDistanceAtLeast_top` proves the gate is nonvacuous. |
| `RepairCodes/Q9Seed.lean` | legacy formal-library seed (not the manuscript seed): full `[10,4,6]₉`, `d(C₀⊥)=4`, and block-local transfer; concrete 3-uniform `q9AxisRepairHypergraph`; generalized four-column determinant; exact edge characterization as the distinct zero-sum triples in `𝔽₉`. |
| `RepairCodes/Q9Affine.lean` | additive-equivalence transport for zero-sum triple hypergraphs; basis equivalence `𝔽₉ ≃ (Fin 2 → ZMod 3)`; exact embedded identification of the actual q9 repair hypergraph; `ν=3`, `τ=5`; exact twelve-line/eight-avoiding-zero counts. |
| `RepairCodes/AxisTwistedCubic.lean`, `AxisTwistedCubicInvariants.lean` | natural-index row code; exact global dual distance three; exact locality two/three and complete repair classifications; sharp nucleus/generic-axis formulas; cubic `τ=q−2`, rainbow lower bound and matching upper bound; exact cubic repair count `choose(q−1,2)`; all-symbol `τ>ν` for `q≥9`. |
| `RepairCodes/Q9Uniform.lean`, `Q9CircuitInventory.lean` | kernel-checked q9 row table `(4,7),(6,12),(7,13)`; exact `28`, `36+8`, `36+12` repair counts; exact `120` axis-three / `84` completed-cubic-four circuit-support inventory; no generated or native certificate. |
| `RepairCodes/SeedLift.lean`, `Q9SeedLift.lean` | actual concatenated submodule; dimension and distance lower bound; exact equality of complete repair hypergraphs under `r+1<2*d(I⊥)` and the outer functional-dual gate; generic preservation of every exact locality `s≤r`; exact `ν`/`τ` transfer; q9 `[19N,4K,≥8D]₉`, all-symbol locality at most three, exact lifted row table, and `7ν≤4τ`. |
| `RepairCodes/TraceDual.lean` | nondegenerate trace representation; ordinary extension-field dual word recovery; exact functional/Hamming support equality; ordinary dual distance ⇒ restricted functional-dual gate |
| `RepairCodes/Q9ExtensionLift.lean` | actual degree-four restricted-scalar lift; dimension multiplier; `[19N,4K,≥8D]₉`; disjoint exhaustive type partition with exact counts `9N,9N,N`; exact locality three/two; exact repair-row transfer and failure thresholds `6,11,12` from ordinary extension-field dual distance |
| `RepairCodes/Imported.lean` | sole quarantined deep input: Stichtenoth Theorem 1.6(ii), specialized to self-dual codes over `GF(6561)` with limit distance `≥39/80` |
| `RepairCodes/Asymptotic.lean` | kernel-checked analytic reduction; concrete `GF(9) ⊆ GF(6561)` construction; unbounded q9 family with rate `2/19`, every fixed eventual distance bound `c<39/190`, and a bundled exact coordinate distribution/locality/row/threshold profile |

Both Singleton directions are now unified in a worked family: `singleton_bound` (general upper),
`rsCode_minDist_ge` (RS lower), `rsCode_isMDS` (equality). This is the MDS baseline the sweep's
near-MDS seeds (e.g. `[10,4,6]_9`, `d+k = n`) sit one below.

### Open next steps (in order)

**The RepairCodes formalization track is closed.** The q9 seed, uniform formulas, trace bridge,
extension lift, concrete asymptotic family, strict trust audits, and source-ledger/registry
synchronization are complete.

1. **External priority review:** a coding-theory specialist follows the cited repair-tolerance,
   dual-support, and concatenation literature through MathSciNet/zbMATH/IEEE Xplore. This is a
   submission-confidence gate, not a mathematics or formalization blocker; until then the paper
   uses “candidate contribution” / “we did not locate.”
2. **Public artifact:** extract the paper/Lean package and mint the public versioned DOI required
   by the publication policy.
3. **Optional context only:** formalize the symmetric-cube PGL orbit description of the axis if a
   later paper needs that provenance in its proof chain. It is not used by the code construction.
4. Continue Phases 2–4 per §4 as separate tracks; they are not blockers for RepairCodes.

### Optional real-math strengthening shortlist (not current-paper blockers)

The remaining item is deliberately excluded from the completed-paper claim ledger until a theorem
is proved.

1. **Explicit cap-number input beyond semantic `Z_3(q)`.** The axis transversal formulas are exact
   in terms of the defined cap number, and `q=9` is evaluated. New exact values or useful uniform
   estimates for further fields would require cap-set results (proved or imported with the same
   source discipline).
Closed strengthenings: **C104** proves the exact cubic row `((q−1)/2,q−2)` by a shifted-inverse
rainbow perfect matching. **C105** proves that neither transfer gate can be weakened uniformly,
using nondegenerate `GF(3)` examples and literal complete-hypergraph inequality. See the
[RepairCodes strengthening handoff](done/2026-07-13-repaircodes-strengthening-plan.md).

### Discovery track for final review

Final classification after the strict trust and internal adversarial novelty audits. Candidate
novelty remains subject to the external specialist gate unless explicitly stated otherwise.

- **Proved strengthening:** the exact `[2q+1,4,q−1]_q` code-parameter theorem holds over every
  finite characteristic-three field, including `q=3`; the paper only needs `q≥9` for its uniform
  all-symbol repair gap.
- **Proved reusable extension:** for three distinct cubic parameters and an arbitrary axis vector
  `(0,e₁,e₂,0)`, dependence is equivalent to
  `e₁(st+su+tu)=e₂(s+t+u)`, a field-generic statement strictly more general than the displayed
  characteristic-three completion.
- **Proved structural consequence:** in characteristic three the symmetric coordinates
  `(s+t+u,st+su+tu)` cannot both vanish for distinct `s,t,u`; hence the completing axis point is
  projectively unique, and the normalized point already present in `S_q` forms a genuine
  four-circuit.
- **Proved paper-level strengthening:** the complete code-derived repair hypergraph has exact
  locality two at every axis coordinate and exact locality three at every cubic coordinate, so
  all-symbol locality three holds over every finite characteristic-three field, including
  `q=3`; the paper only needs the `q≥9` range for the strict transversal/matching gap.
- **Proved reusable extension:** a selected circuit gives a repair edge from its own full-support
  relation, even when smaller circuits elsewhere make the global dual-distance converse unusable.
  The reindexed form lets geometric circuit proofs use their natural finite enumeration.
- **Proved transfer strengthening:** complete repair-hypergraph preservation needs only
  `r+1<2*d(I⊥)`, not `d(I⊥)=r+1`. This covers mixed-locality seeds such as the full q9 code, whose
  global dual distance is three even though radius-three repair transfer is exact.
- **Proved boundary theorem:** the strict inner inequality and outer functional-dual threshold
  `r+2` are both best possible for a theorem uniform over all inner and outer codes. The explicit
  nondegenerate `GF(3)` examples prove literal complete-hypergraph failure; they do not assert
  necessity for a fixed concatenation.
- **Proved reusable corollary:** the same radius-`r` gates preserve every exact inner locality
  `s≤r`, including both existence at radius `s` and nonexistence at all smaller radii.
- **Proved coordinate-free extension:** the outer alphabet may be any finite-dimensional symbol
  module with an encoder equivalence; extension-field trace coordinates are one optional
  presentation, not part of the finite theorem.
- **Proved exact-distribution consequence:** the lift preserves every inner row exactly, so the
  three q9 orbit rows survive blockwise rather than only their worst-case `7/4` ratio.
- **Proved exact operational consequence:** in an `N`-block lift the three rows occur with
  multiplicities `9N,9N,N`, retain exact localities three, two, two, and have guaranteed
  arbitrary-helper failure thresholds `6,11,12` respectively.
- **Proved broader q9 certificate:** the four-disjoint-repair construction works over any
  characteristic-three field containing a square root of `−1`; order nine is used only to make
  the matching bound sharp.
- **Proved applied upgrade:** the paper's fixed-alphabet asymptotic existence claim now has a
  concrete Lean theorem: unbounded length, exact rate `2/19`, eventual relative distance greater
  than every fixed `c<39/190`, and a bundled exact partition, locality, row, and threshold profile,
  with only Stichtenoth Theorem 1.6(ii) imported. The near-limit formulation is a checked
  arithmetic tightening of the same construction, not a separate novelty claim; the endpoint is
  not asserted.
- **Proved simplification:** self-dual TVZ outer codes replace a two-sided AG-code distance
  construction: primal and dual distances coincide, so one cited theorem supplies both gates.
- **Possible application / novelty candidate:** the exact complete-hypergraph transfer can be
  reused for any inner seed whose repair statistics are known, including mixed-locality seeds.
  The internal none-found search survives, but categorical priority still requires the external
  specialist citation-chain review.

**Landed 2026-07-11:** (a) the eval-code stepping stone — RS instances over `ZMod 7` and the
target `GaloisField 3 2 = 𝔽₉` (`FiniteGeom/EvalCodeInstance.lean`), discharging the eval-code MDS
layer's non-vacuity on a real non-prime field and retiring the "instantiate RS over a concrete
`GaloisField`" on-ramp (does **not** touch the below-MDS `[10,4,6]₉` seed of step 1); (b) the
Vandermonde general-position core of the `q=3^h` family (`FiniteGeom/MomentCurve.lean`); (c) the
projective-systems→codes distance bridge `d = n − max hyperplane section` plus `dim = k`
(`FiniteGeom/ColumnCode.lean`), reusable across the whole geometric-code lane; (d) the NRC
hyperplane-section bound `momentCurve_section_le` (the `≤3` cubic-per-plane `T_q` leg). All
`#print axioms`-clean.

The session-by-session narrative of how the §7 corpus landed (per-slice writeups, referee-hardening,
the ten dated notes) is in the
[archive companion](done/2026-07-11-lean-formalization-plan-archive.md).
