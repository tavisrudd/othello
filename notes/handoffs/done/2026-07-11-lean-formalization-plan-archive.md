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
