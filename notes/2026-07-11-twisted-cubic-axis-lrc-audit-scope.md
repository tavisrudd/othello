# Twisted-cubic–axis LRC — citation-audit scope (sweep §1)

**Date:** 2026-07-11
**Lane:** §1 of [coding/MDS cross-field sweep](2026-07-11-codex-coding-mds-cross-field-sweep.md)
— the all-symbol `τ>ν` twisted-cubic–axis family + bounded-repair concatenation transfer.
**Why this note exists:** §1 is the sweep's strongest, nearest-to-publishable lane, and it is the
**one lane without a parallel 07-10 upgrade/audit note.** The adjacent lanes already have theirs:

| Adjacent lane | Upgrade/audit note |
|---|---|
| §2 recovery spectrum + §3 MDS-shortening/completion distance | [`2026-07-10-completion-core-rigidity-upgrades.md`](2026-07-10-completion-core-rigidity-upgrades.md) (§6.5 twisted-cubic transversal spectrum [OPEN]; pins Bartoli–Davydov–Marcugini–Pambianco [arXiv:1909.00207](https://arxiv.org/abs/1909.00207), Ball–Lavrauw [arXiv:1908.10772](https://arxiv.org/abs/1908.10772)) |
| §5 Frobenius-marked MDS extension | [`2026-07-10-baer-equivariant-extension-upgrades.md`](2026-07-10-baer-equivariant-extension-upgrades.md) (§10 required gates) |
| K11/K12 `M_{0,5}` reduct | [`2026-07-10-continuation-graph-rigidity-upgrades.md`](2026-07-10-continuation-graph-rigidity-upgrades.md) (§7.5 novelty boundary; Metsch, Batten) |

This note scopes the specialist MathSciNet/zbMATH/full-text audit for §1 only. It does **not** repeat
those three. Method + house style match [`2026-07-09-spinoff-bridges-litcheck.md`](2026-07-09-spinoff-bridges-litcheck.md):
every citation reached via a search hit this session; unopened full texts tagged `[VERIFY]`; each
none-found verdict logs its queries so absence of evidence is auditable.

The scripts backing every COMPUTED-EXACT number here are now tracked (moved out of `/tmp` on
2026-07-11) under [`scripts/2026-07-11-coding-mds-sweep/`](scripts/2026-07-11-coding-mds-sweep/);
hashes frozen, all three re-run clean.

---

## The novelty claim, decomposed

Sweep §1.5.2 states the defensible claim as:

> an explicit geometric inner family with strict all-symbol separation between repair tolerance and
> disjoint availability, together with a dual-distance transfer lemma that preserves the complete
> bounded-radius repair hypergraph and yields asymptotically good fixed-alphabet families.

This factors into three atomic sub-claims with **different prior-art risk**. The audit clears each
independently; a collision on any one resizes (not necessarily kills) the headline.

### N1 — Bounded-repair transfer lemma *(highest risk; the crux)*

**Claim.** For concatenation `C = O∘I` with `d(I⊥)=r+1` and `d(O⊥) ≥ r+2`, every dual word of
`q`-weight `≤ r+1` lies in a single inner block and is a word of `I⊥`. Hence the **complete**
radius-`r` repair hypergraph (every minimal repair set, therefore `τ` and the full `(ν,τ)` profile)
is copied block-for-block — not merely declared locality `r` or a chosen availability subfamily.

**Prior-art risk: HIGH.** Concatenated LRCs preserving *locality* are classical, and the
dual/trace-decomposition machinery the proof uses is standard.

**Located adjacent art (must cite; candidate collisions):**
- Güneri–Ling–Özkaya, *dual/trace decomposition of (generalized quasi-cyclic) concatenated codes*
  ([arXiv:2007.16029](https://arxiv.org/abs/2007.16029)) — the trace-algebra decomposition step.
  **Check:** does it already give a per-block dual-weight confinement under an outer dual-distance
  gate? `[VERIFY full text]`
- *Introducing locality in some generalized AG codes* ([arXiv:2403.00430](https://arxiv.org/html/2403.00430));
  Xing–Niederreiter–Lam generalized-AG LRCs — concatenation-like constructions that carry locality.
  **Check:** locality-preservation only, or full-repair-set preservation? Expected: locality only.
- *Bounds and Constructions of Codes with Multiple Localities* ([arXiv:1601.02763](https://arxiv.org/pdf/1601.02763));
  generalized-concatenated-with-locality (patent US 11031956) — availability/multiple-locality via
  concatenation. **Check:** disjoint availability `ν` vs the *complete* hypergraph (`τ`).
- Chen–Ling–Xing dual decomposition of concatenated codes (cited in sweep §1.4 as subsuming the
  trace-algebra input) — **obtain exact reference + full text** `[VERIFY]`.

**Searches run:** `concatenated locally repairable code dual distance preserve repair sets locality
outer code`; `concatenated code preserve all bounded weight dual codewords single inner block outer
dual distance availability`; `Chen Ling Xing dual code concatenated code trace decomposition
locality`; `Chen Ling Xing asymptotically good LRC concatenation dual distance function field`.

**Full-text pass run 2026-07-11 (four candidate-collision papers):**

- **[CHECKED — non-colliding] Liu–Ma–Wu–Xing, *Good LRCs via Propagation Rules*
  ([arXiv:2208.04484](https://arxiv.org/abs/2208.04484)) — the sharpest near-miss.** It *names the
  repair-hypergraph object*: `R_C(r) := {supp(c) : c ∈ C⊥, |supp(c)| ≤ r+1}`, with the same
  dual-code recovery-set characterization the sweep uses (Lemma 2.2, "R is a recovery set at i iff
  ∃ c ∈ C⊥ with i ∈ supp(c) ⊆ R", attributed to [12, Lemma 5]) and Cor. 2.3 (locality `r` ⟺
  `[n] = ∪ R_C(r)`). **But** its concatenation Theorem 3.1 preserves *only locality*: "Cconc has
  locality r due to the fact that the inner code Cin has locality r." No outer dual-distance gate;
  no claim that the *complete* `R_C(r)` transfers block-for-block; the only "block" reasoning is a
  min-distance column count. **This is the anchor prior art to cite for both the dual-support object
  and concatenation-preserves-locality — and precisely the paper N1 improves on.**
- **[CHECKED — non-colliding] *Introducing locality in generalized AG codes*
  ([arXiv:2403.00430](https://arxiv.org/abs/2403.00430)):** preserves only the locality parameter
  `r` (Prop. 2, each symbol in one inner code with its own locality bound); no availability, no `τ`,
  no dual-block confinement.
- **[CHECKED — non-colliding] Ma–Xing, *Constructive asymptotic bounds of LRCs via function fields*
  ([arXiv:1908.01471](https://arxiv.org/abs/1908.01471)):** asymptotic locality-`r` bound via
  function-field local expansion; no availability/`τ`, no concatenation-block-confinement theorem.
- **[CHECKED — non-colliding] Song–Cai–Yuen et al., *Bounds and Constructions of Codes with Multiple
  Localities* ([arXiv:1601.02763](https://arxiv.org/abs/1601.02763)):** "multiple localities" =
  *heterogeneous* locality (different coordinates carry different `r_i`), built by generalized
  (Blokh–Zyablov/Zinoviev) concatenation which "inherits the locality." Uses a count of disjoint
  repair sets `ρ`; never the complete hypergraph or `τ`.

**[CHECKED — non-colliding, `[VERIFY]` closed] Güneri–Ling–Özkaya, *Quasi-Cyclic Codes*
([arXiv:2007.16029](https://arxiv.org/abs/2007.16029)):** a QC-codes **survey chapter** — CRT /
concatenated decomposition of QC codes, algebraic structure, trace representation. Full-text scan
finds **no** "locally repairable / locality / availability / repair set / block confinement /
hypergraph"; "Chen" occurs only as a 1969 QC-codes reference, **not** "Chen–Ling–Xing." It is general
dual/trace-decomposition background, not the N1 result.

**Action item — sweep §1.4 citation correction.** The attribution "Chen–Ling–Xing's dual
decomposition of a concatenated code" is **not locatable in public search** (Google/Semantic Scholar/
arXiv). The dual-decomposition machinery the sweep actually leans on is the classical CRT / trace
decomposition (Güneri–Ling–Özkaya survey; Blokh–Zyablov/Zinoviev/Forney generalized concatenation).
Before manuscript: pin the exact "Chen–Ling–Xing" source via MathSciNet, or replace the citation with
the CRT/trace-decomposition + generalized-concatenation references.

**Verdict: none-found for the crux, with a named adjacent genre.** Concatenation-preserves-*locality*
is classical (Forney; Blokh–Zyablov/Zinoviev generalized concatenation; Theorem 3.1 of 2208.04484),
and the bounded-weight dual-support object `R_C(r)` is already in print — but no located work
preserves the **entire** `R_C(r)` (hence exact adversarial `τ` and the full `(ν,τ)` profile) under an
outer dual-distance gate `d(O⊥) ≥ r+2`. The N1 crux survives this pass. **Novelty risk downgraded
HIGH → MEDIUM** (crux clear, but the object and the concatenation-locality half are prior art, so the
lemma must be framed as strengthening 2208.04484-style preservation from locality to the whole
hypergraph).

**Kill condition (still open, now narrower).** Any paper stating that concatenation under an outer
dual-distance condition preserves *all* bounded-size repair supports (not just locality or a chosen
disjoint family) collapses N1. The four highest-probability candidates are cleared; a MathSciNet
forward-citation sweep of 2208.04484 and Ma–Xing is the remaining diligence.

### N2 — Explicit all-symbol `τ>ν` geometric seed *(medium risk)*

**Claim.** `C(S_q) = [2q+1,4,q-1]_q` from the punctured twisted cubic ∪ char-3 axis has **every**
coordinate with `τ_i > ν_i`, uniform `min τ/ν ≥ 7/4` (exact at `q=9`; COMPUTED-EXACT
`q9_pgl_orbit_seed.py`, and the uniform `q=3^h` theorem hand-proved in §1.5.1).

**Prior-art risk: MEDIUM.** The geometry is classical: the twisted cubic's char-3 axis / nucleus and
its `PGL(2,q)` line orbits are treated by Gmainer–Havlicek and Davydov–Marcugini–Pambianco
(sweep §1.5.2). The code parameters and ordinary weight enumerator are elementary. What must be new
is the **complete repair hypergraph per coordinate type** and the all-symbol `τ>ν` theorem.

**Located adjacent art (finite-geometry LRCs — candidate collisions):**
- *LRCs with high availability based on generalised quadrangles* ([arXiv:1912.06372](https://arxiv.org/abs/1912.06372)).
- *LRCs with multiple recovering sets from maximal curves* ([arXiv:2509.15163](https://arxiv.org/pdf/2509.15163));
  *LRCs with availability via elliptic function fields* ([arXiv:2605.06182](https://arxiv.org/html/2605.06182));
  *Geometric construction of k-optimal LRCs* ([arXiv:2605.31214](https://arxiv.org/html/2605.31214)).
  **Check:** all report *availability* (disjoint sets, `ν`-side); none located reports the
  hitting-set `τ` for a twisted-cubic/axis system.
- Bartoli–Davydov–Marcugini–Pambianco, *planes through points off the twisted cubic and multiple
  covering codes* ([arXiv:1909.00207](https://arxiv.org/abs/1909.00207)) — external-orbit
  point/plane representation **counts**. Sweep §2 and the completion-core note both flag: counts
  ≠ transversals. **This is the sharpest near-miss to read in full.** `[VERIFY]`

**Full-text pass (2026-07-11): BDMP [1909.00207] CHECKED — non-colliding.** It computes the
twisted-cubic point–plane **incidence counts** per `PGL(2,q)`-orbit (five point-orbits × five
plane-orbits → 25 submatrices `I_ij`) and **multiple-covering / saturating-set density** (`(3,μ)`-MCF
codes). Term scan of the full text finds **no** "transversal / hitting / matching / availability /
repair / locality / locally repairable." Exactly the counts-vs-transversals gap the completion-core
note §6.5 flagged: counts per orbit are computed, the hitting-set `τ` is not.

**Verdict: none-found for the τ-side, partial-overlap on geometry.** The `ν`/availability/covering
literature on the twisted cubic is covered (BDMP + multiple-covering corpus); the `τ` (adversarial
hitting-set) of *this* `2q+1`-point system, and all-symbol `τ>ν`, are unlocated.

**Kill condition.** Any computation of the bounded-repair hitting set (or an equivalent all-symbol
fault-tolerance-vs-availability separation) for the twisted-cubic–axis code, or for a system a
`PGL`-equivalence away.

### N3 — Extremal `τ/ν → p` via cap-set / zero-sum *(medium risk; Roth–Lempel companion)*

**Claim.** The Roth–Lempel-puncture hot coordinate has `τ/ν = p(1 − Z_p(𝔽_q)/q) → p`, attaining the
universal `p`-uniform hypergraph ceiling `τ ≤ pν` asymptotically (sweep §1.2), on the back of
Sauermann / Ellenberg–Gijswijt.

**Prior-art risk: MEDIUM.** The code and its zero-sum minimum circuits are **prior art** — Han–Fan,
*Roth–Lempel NMDS codes of non-elliptic-curve type* (IEEE IT 69(9):5670–5675, 2023;
[DOI](https://doi.org/10.1109/TIT.2023.3272384)), Lemma 6 already has the zero-sum circuit
classification (sweep §1.3 marks this CLOSED as headline). The `τ` metric itself is Pamies-Juarez–
Hollmann–Oggier ([arXiv:1302.5518](https://arxiv.org/abs/1302.5518)). The candidate-new layer is the
**exact additive-combinatorial evaluation of `τ` and the extremal `τ/ν → p` reading**.

**Located adjacent art:** *On Fault Tolerance, Locality, and Optimality in LRCs* (Kolosov et al.,
USENIX ATC'18 / ACM ToS, [DOI:10.1145/3381832](https://dl.acm.org/doi/10.1145/3381832)) — full-node
fault tolerance vs locality, the systems-facing framing of the same tension. **Check:** whether any
LRC line connects repair-tolerance to zero-sum-free / cap-set bounds. None surfaced.

**Full-text pass (2026-07-11): Li–Heng [2204.11208] CHECKED — non-colliding.** It computes the
**minimum linear locality** of NMDS codes and their duals (Lemma 21/22, Thm 23, off Tan–Fan–Ding–Zhou
[arXiv:2102.…]) — a single locality figure per code, with one repair set `R_i`. Term scan finds **no**
"tolerance / transversal / hitting / availability / disjoint / (r,δ) / zero-sum / cap set / additive"
(the "tolerance parameters" in the search snippet was a summarizer gloss, not in the paper). And the
Han–Fan zero-sum NMDS characterization ("`RL_{k,0}(S)` NMDS ⟺ `S` has a `k`-zero-sum subset") is
confirmed prior art, as sweep §1.3 already ruled.

**Verdict: partial-overlap.** The code, its zero-sum NMDS characterization (Han–Fan), the
NMDS↔optimal-LRC-via-minimum-linear-locality connection (Li–Heng, Tan–Fan–Ding–Zhou), and the `τ`
metric definition (Pamies-Juarez et al.) are all prior art. The narrow candidate-new layer — exact
additive-combinatorial `τ = q − Z_p(𝔽_q)` and the asymptotic `τ/ν → p` attaining the universal
`p`-uniform ceiling via Sauermann / Ellenberg–Gijswijt — survives, but it is the thinnest of the three
lanes.

**Kill condition.** Any prior connection of LRC repair-tolerance to `Z_p`/cap-set asymptotics, or a
prior exact `τ` for this Roth–Lempel puncture.

---

## Priority + decisive gate

**Audit order = risk order: N1, then N2, then N3.** N1 is the crux — if the complete-hypergraph
transfer is already in the concatenated-LRC literature, the headline drops from "new transfer lemma"
to "new seed lifted by known machinery." N2 and N3 are each "new exact computation on a classical
object" and survive as contributions even if N1 softens.

**N1 gate — RESULT (2026-07-11 full-text pass): crux clears, risk HIGH → MEDIUM.** The four
highest-probability candidate-collision papers were read (see N1 above); all preserve only locality
(or a chosen disjoint family), none preserves the complete bounded-size repair hypergraph via an
outer dual-distance gate. Liu–Ma–Wu–Xing (2208.04484) is the anchor to cite — it already names the
`R_C(r)` dual-support object and does concatenation-preserves-locality, so N1 must be framed as
*strengthening* that from locality to the whole hypergraph, not as a fresh idea. Remaining N1
diligence: MathSciNet forward-citation sweep of 2208.04484 + Ma–Xing, and pin/correct the sweep §1.4
"Chen–Ling–Xing" attribution (read Güneri–Ling–Özkaya [2007.16029] full text).

**N2 gate — RESULT (2026-07-11): non-colliding.** BDMP [1909.00207] read in full — orbit incidence
counts + covering density, no transversal/`τ`. Forward-sweep found a *large* active twisted-cubic
orbit/incidence-matrix program (Davydov–Marcugini–Pambianco et al.:
[2604.14628](https://arxiv.org/abs/2604.14628) points/planes/lines incidence matrices `q=2,3,4`;
[2209.04910](https://arxiv.org/abs/2209.04910) + [2401.00333](https://arxiv.org/abs/2401.00333)
external-line class `O_6`) — **all orbit classification + incidence counts, none computing the
repair-hitting-set `τ`.** The counts-vs-transversals gap holds; N2's all-symbol `τ>ν` and the
twisted-cubic-axis hitting-set spectrum are unlocated.

**N3 gate — RESULT (2026-07-11): non-colliding, thinnest lane.** Li–Heng [2204.11208] read in full —
minimum linear locality only, no `τ`/availability/zero-sum link. Code + zero-sum NMDS characterization
+ NMDS↔optimal-LRC all prior art; only the exact `τ = q − Z_p` evaluation and the `τ/ν → p` extremal
reading survive.

**All three lanes cleared; no collision found. Confirmatory sweeps done 2026-07-11:**
1. **N1 forward-citation neighborhood of 2208.04484** (journal version IEEE IT 2023; Jin–Ma–Xing,
   Ma–Xing elliptic, Huang–Zhao hyperelliptic, Tamo–Barg repair schemes, elliptic-availability
   2605.06182) — all locality/availability curve constructions; **none** preserves the complete
   repair hypergraph under an outer dual-distance gate. Crux still unlocated.
2. **N2 twisted-cubic incidence-matrix program** (Davydov et al. 2604.14628 / 2209.04910 / 2401.00333
   + BDMP) — thoroughly computes orbits/incidence *counts*; `τ` unlocated.
3. **N1 `[VERIFY]` closed** — Güneri–Ling–Özkaya [2007.16029] read (QC survey, no LRC content);
   sweep §1.4 "Chen–Ling–Xing" citation flagged for pin-or-correct (see N1 action item).

**Residual (auth-gated, non-blocking):** a definitive MathSciNet/zbMATH forward-citation run (public
web + Semantic Scholar approximated it here) and pinning the "Chen–Ling–Xing" reference. First
full prior-art pass is otherwise **complete and clean**; the sweep §1 novelty claim stands.

**Recommended next non-audit move:** the reads pointed *outward* to N2's open target — no one has the
twisted-cubic external-orbit `τ` spectrum. That is the completion-core §6.5 [OPEN] item and the
natural first new theorem: enumerate `ρ(x)=τ{B∈binom(C_3(q),3): x∈⟨B⟩}` per `PGL(2,q)` orbit for
`q=5,7,11` (holding out `13,17,19`), against the now-cited incidence-matrix program.

**Do not fund** a broad code-parameter-table search: the `[n,k,d]` parameters are prior art (N3), so
this lane does **not** target MinT/codetables entries — the contribution is the repair-invariant
concept, not a new parameter tuple. (Sweep §7 already says the code/circuits are prior art.)

## House-keeping

- All §1 replay scripts tracked at `scripts/2026-07-11-coding-mds-sweep/` (README carries hashes +
  expected key outputs). Re-verified this session.
- The `[VERIFY]` tags above mark full texts not opened this session — clearing them is the audit.
- Cross-lane: the completion-core note's §6.5 twisted-cubic transversal spectrum is the same
  `PGL(2,q)`-orbit machinery N2 needs; coordinate the two so the external-orbit enumeration is done
  once.
