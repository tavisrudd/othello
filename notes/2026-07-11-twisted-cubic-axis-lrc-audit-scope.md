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

**Searches run this session:** `concatenated locally repairable code dual distance preserve repair
sets locality outer code`; `concatenated code preserve all bounded weight dual codewords single
inner block outer dual distance availability`; `Chen Ling Xing dual code concatenated code trace
decomposition locality`.

**Verdict so far: partial-overlap, crux unlocated.** Preservation of *locality* and of *disjoint
availability* under concatenation is established; preservation of the **entire bounded-weight repair
hypergraph** (hence exact adversarial `τ`) was not surfaced. This is the load-bearing seam.

**Kill condition.** Any paper stating that concatenation under an outer dual-distance gate preserves
*all* bounded-size repair supports (not just locality/availability) collapses N1 to an application of
known machinery.

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

**Verdict so far: none-found for the τ-side, partial-overlap on geometry.** The `ν`/availability
literature on geometric LRCs is active; the `τ` (adversarial hitting-set) of *this* `2q+1`-point
system, and all-symbol `τ>ν`, are unlocated.

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

**Verdict so far: partial-overlap.** Code + circuits + `τ` definition all prior art; the additive
evaluation and the "attains the universal cover/matching ratio" statement are unlocated.

**Kill condition.** Any prior connection of LRC repair-tolerance to `Z_p`/cap-set asymptotics, or a
prior exact `τ` for this Roth–Lempel puncture.

---

## Priority + decisive gate

**Audit order = risk order: N1, then N2, then N3.** N1 is the crux — if the complete-hypergraph
transfer is already in the concatenated-LRC literature, the headline drops from "new transfer lemma"
to "new seed lifted by known machinery," which changes what the paper claims. N2 and N3 are each
"new exact computation on a classical object" and survive as contributions even if N1 softens.

**Single decisive gate:** a MathSciNet/zbMATH + full-text pass on the four N1 candidate-collision
papers (Güneri–Ling–Özkaya; generalized-AG-locality; multiple-localities; Chen–Ling–Xing),
answering one yes/no — *does any of them preserve the complete bounded-size repair hypergraph, or
only locality/availability?* Everything else in the audit is bounded by that answer.

**Reads queued (full text, in order):**
1. Chen–Ling–Xing dual decomposition (exact ref TBD) + Güneri–Ling–Özkaya [2007.16029] — N1 crux.
2. Bartoli–Davydov–Marcugini–Pambianco [1909.00207] — N2 sharpest near-miss (counts vs transversals).
3. Han–Fan (IEEE IT 2023) Lemma 6 — N3, confirm the circuit classification boundary already CLOSED.

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
