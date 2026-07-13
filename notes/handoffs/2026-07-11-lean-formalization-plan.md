# Lean formalization plan — the -10 / -11 PROVED corpus

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
The assembled 12-page manuscript, PDF, proof ledger, and adversarial novelty report are in
[`papers/coding-repair-hypergraphs/`](../../papers/coding-repair-hypergraphs/). The internal
novelty audit returns the repair-tolerance invariant to explicit prior art and retains only
cautious candidate claims for the exact all-symbol `(ν,τ)` separation and complete-hypergraph
transfer. An external specialist citation-chain review remains a submission preflight gate.
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

These are deliberately excluded from the completed-paper claim ledger until a theorem is proved.

1. **Exact cubic matching number for general `q=3^h`.** Lean proves uniform lower and upper
   bounds and the exact `q=9` value, but no closed general formula. Closing the gap needs new
   finite-additive/combinatorial mathematics before formalization.
2. **Explicit cap-number input beyond semantic `Z_3(q)`.** The axis transversal formulas are exact
   in terms of the defined cap number, and `q=9` is evaluated. New exact values or useful uniform
   estimates for further fields would require cap-set results (proved or imported with the same
   source discipline).
3. **Necessity or optimality of the transfer gates.** The current theorem proves sufficiency of
   `r+1<2*d(I⊥)` and functional-dual distance at least `r+2`. Any sharpness statement needs either
   counterexample families at the boundary or a genuinely weaker transfer theorem; none is
   claimed in the paper.

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
