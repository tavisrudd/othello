# The Clebsch hexagon code — paper lane (`clebsch`)

**Lane**: `clebsch` — see CLAUDE.md § Lane routing. (Spoken synonym: `hexagon`. Formerly called the
*icosahedral MDS / deep-holes* lane — same lane, renamed 2026-07-14 when it and the paper were
unified under one alias.)
**This is the lane's single live doc.** The paper-outline note was folded in here and removed
(2026-07-14): its abstract/skeleton/deepened-core/draft-prose were superseded by the manuscript
itself, which is authoritative for all prose and citations. **Manuscript + checkers**:
[`papers/clebsch-hexagon-code/`](../../papers/clebsch-hexagon-code/) (`clebsch_hexagon_code.tex` +
PDF; builds with texliveFull — Small/Medium lack `enumitem`). Indexed in
[papers-index.md](../../papers/papers-index.md) as `clebsch`. **Venue:** Designs, Codes and
Cryptography / Finite Fields and Their Applications / J. Geometry — **not** IEEE-TIT.

## Paper sequencing and the novelty seam vs `arcs` (ruled 2026-07-14)

**The overlap:** this paper's Prop 3.1 (deep holes of the `[6,3,4]₁₁` code = the twelve-point conic)
*is* the `arcs` paper's Prop 8.7(i) (renumbered from 4.6; re-verified 2026-07-14) — same statement, same computation, and `arcs` carries the Lean
certificate (`comp-q11-mds-deep-holes`). Cor 3.2's "first identification of a complete deep-hole set
with the `F_q`-points of a named variety" therefore rested on a fact `arcs` also states. Two papers,
one computation, a novelty claim spread across both: the classic salami-slicing pattern a referee
flags.

**Ruling — split stays, seam moves:**
1. **`arcs` submits first and owns the identification.** It is near submission-ready, carries the
   Lean certificate, and the fact is already Prop 8.7(i) there. `clebsch` cites it as setup.
2. **`clebsch` claims only the reading**: the rigidity TFAE, the gap theorem, the chirality `ℤ/2`,
   and why-11. That is the whole point of the paper and is unambiguously its own — none of it appears
   in `arcs`. Cor 3.2's "first" is demoted from novelty-carrier to setup.
3. **§3 is made self-contained** and says the relationship out loud: the Prop 3.1 computation is 133
   points and `check_rigidity_degenerate_conic.py` already does it, so prove it in place and cite
   `arcs` as "see also" rather than as the proof. This also removes the current dependency of the
   paper's foundation on a working paper a referee cannot obtain.

**Why not fold:** the two have genuinely different spines (`arcs` = defect identity + the F₁₆
classification; `clebsch` = rigidity + gap + chirality + why-11). Folding would bury a five-way
rigidity theorem inside a paper about something else and make `arcs` incoherent.

**Order:** `arcs` → `clebsch`. Once `arcs` is out, `clebsch` cites a published companion for its
setup instead of a working paper, and move 3 becomes optional rather than necessary. This ordering is
a decision, not an artifact of which paper finishes first.

**Date**: 2026-07-13
**Status**: **MAJOR REVISION — INTERNAL REPAIRS LANDED; EXTERNAL GATES OPEN.** C128, C146, and
C163–C173 have repaired the mathematics, terminology, prior-art framing, reproducibility,
quantitative gaps, unconditional q=11 theorem, and manuscript scope. The draft builds warning-free
with one rigidity spine. C185's finite synthesis, C187's arithmetic and geometric layers, and
C186's finite A₅ action bridge now pass Lean; C184's manuscript disposition and C186's conceptual
source argument remain open. The proved
q=11 defect bridge plus a two-axiom Dye interface now kernel-check the conic-rigidity implication;
C187's actual projective small-`k` mathematics is also complete in Lean.
It is not submission-ready until C131/C161 settle ownership, the remaining new tails close, and C168 runs
the clean-source/PDF closeout.

**Authority note.** The repair map immediately below is the current route and supersedes every lower
“CONVERGED”, “all gaps closed”, or speculative-framing claim. This file still contains retained
exploration history below the live map; C168 must move it to the companion archive and leave this
handoff crisp. Until then, do not route work from the historical sections when they disagree with the
map.

**Allowed paths for this lane:** `papers/clebsch-hexagon-code/**`, this handoff and its companion,
`notes/2026-07-14-c1*.md` and the `notes/2026-07-15-c1*.md` reports pegged `clebsch`, the explicit `clebsch` rows of the global queue,
and the Q11/Q9 Lean modules needed by C128/C164/C183. The `arcs` companion manuscript, gem-mining scripts,
and other lanes remain read-only unless the user switches or expands scope.

## Adversarial takeover repair map (authoritative, 2026-07-14)

Full issue ledger: [Clebsch + gem takeover audit](../2026-07-14-clebsch-gem-adversarial-takeover.md).
Cheap-upgrade report: [reader questions and cheap upgrades](../2026-07-14-clebsch-gem-cheap-upgrades.md).
Incidental observations: [Clebsch discovery track](../2026-07-14-clebsch-discovery-track.md) —
append-only; promote scoped findings to C items rather than routing work directly from the log.

| Priority | Task | Current failure | Exit condition |
|---|---|---|---|
| 1 | **C163 — REPORTED** | exact `12/120/159720/2400` semantics, `U(A)` boundary, and projective/monomial/pure group dictionary landed | closed → [C163 report](../2026-07-14-c163-clebsch-coding-semantics.md) |
| 2 | **C146/C153 — REPORTED** | the Clebsch/Edge/BSW rebase and exterior-set vocabulary landed; BSW 1992 primary text proves only the exterior inclusion, not exact covering | C146 report → [prior art](../2026-07-14-c146-edge-bsw-prior-art.md); primary-source verdict is recorded in the discovery track |
| 3 | **C164 — REPORTED** | two support orbits, Petersen graph, `S5` normalizer, `10+10` per coset, `1200+1200` globally, and 1.44M coefficient-equivariance cases are tracked and cited | closed → [C164 report](../2026-07-14-c164-clebsch-chirality.md) |
| 3a | **C173 — REPORTED** | the five self-polar triangles pair to the ten complementary supports by alternating-cycle bipartition; Petersen=`KG(5,2)` and all displayed self-polarities are certified | closed → [C173 report](../2026-07-14-c173-dye-triangles-petersen.md) |
| 3b | **C176 — REPORTED** | the triangle-pair/Brianchon/support dictionary, complete chord-intersection ledger, exact equivariance, and manuscript proposition are tracked | closed → [C176 report](../2026-07-15-c176-brianchon-petersen-dictionary.md) |
| 3c | **C179 — REPORTED** | the direct fixed-conic binary incidence and orbit-conic code lineage is now cited and distinguished at the object and parameter levels | closed → [C179 report](../2026-07-15-c179-conic-ldpc-literature.md) |
| 3d | **C180 — LEAN/SOURCE COMPLETE; MANUSCRIPT OPEN** | the five chord directions form a certified proper five-edge-colouring, the prism factors are extracted, odd characteristic rules out the five-covered-point equality case, and Dye 1991 pp.270--276 directly supplies the sharp bound plus ground-field equality classification | integrate the conceptual rigidity proof and retain the census as independent verification → [C180 report](../2026-07-15-c180-conceptual-clebsch-rigidity.md) |
| 3e | **C181 — REPORTED** | the universal `c<=15` matching bound reduces all characteristics to `q=4,5,9,11`; the first two are excluded geometrically and the q=9 internal graph is Sylvester with published `eq_2=5`, independently checked from scratch | closed; manuscript now uses the conceptual proof and retains both exact checkers as verification → [C181 report](../2026-07-15-c181-classification-free-why11.md) |
| 3f | **C182 — QUEUED; EXTERNAL ARCHIVE GATE** | all cited computations are indexed and manifested locally, but the PDF gives no immutable public artifact location | after C168 clean-HEAD closeout, publish/replay a versioned archive and cite its DOI in a data/code-availability paragraph → [C182 report](../2026-07-15-c182-clebsch-artifact-archive.md) |
| 3g | **C183 — IN PROGRESS** | decoding synthesis, actual small-`k` projective mathematics, `u+c=22`, explicit Dye consequences, leaf-split A₅ point action, and C180's full odd-characteristic prism exclusion pass their Lean gates | finish manuscript synthesis and record the final theorem gallery → [C183 report](../2026-07-15-c183-clebsch-lean-new-claims.md) |
| 3h | **C184 — CHECKERS COMPLETE; DISPOSITION OPEN** | the tracked checker and Singular replay certify the complete low-degree table, unique cubic containment, and exact C02/C04/C12 companions | decide a concise manuscript disposition; Lean only what survives that decision → [C184 report](../2026-07-15-c184-low-degree-uncovered-loci.md) |
| 3i | **C185 — REPORTED** | the total oracle, ambiguity enumerator, uniform twenty-support theorem, decoder/Brianchon reconstruction, and corrected size-five versus chirality hierarchy are integrated; checker, narrow Lean synthesis, and PDF gates pass | closed; the full monomial action remains an optional Lean upgrade → [C185 report](../2026-07-15-c185-clebsch-decoding.md) |
| 3j | **C186 — FINITE LEAN BRIDGE COMPLETE; CONCEPTUAL/SOURCE GATE OPEN** | all 60 action leaves, representative and fixed-point leaves, and the lightweight aggregator pass serial build, freshness, generator, and standard-axiom gates | write/source the representation-theoretic proof and integrate its Brianchon/triple-point consequences → [C186 report](../2026-07-15-c186-a5-orbit-conic-proof.md) |
| 3k | **C187 — CHECKER/LEAN MATHEMATICS COMPLETE; PRIORITY/MANUSCRIPT OPEN** | the hardened checker plus `SmallKChordMoments.lean` and `SmallKGeometricBridge.lean` cover the finite, arithmetic, and actual projective layers | literature-check `(4,5)` and integrate without displacing rigidity → [C187 report](../2026-07-15-c187-general-k-arc-conic-filling.md) |
| 3l | **C194 — REPORTED** | Dye's ten concurrences and the chord-defect identity now give `|U(H)|=q^2-14q+45`; for `q=3 mod 4` the associated conic lies in `U(H)` with exact excess `(q-4)(q-11)` | integrated into §6; new algebra passes narrow Lean elaboration and q=19 enumeration is verification → [C194 report](../2026-07-15-c194-clebsch-family-uncovered-formula.md) |
| 3m | **C197 — REPORTED** | BSW's second q=11 complete exterior configuration is now used as the natural non-arc/non-MDS foil | one concise Pasch comparison landed in related work; no coordinates, computation, or second spine → [C197 report](../2026-07-15-c197-bsw-pasch-mds-foil.md) |

C183's live report contains the compaction-safe subagent roster. Its delegated finite Lean tasks
are complete. Root owns integration, the Dye axiom/source audit, all validation, and uses
`choom -n 500` for current Clebsch Lean work.
| 4 | **C165 — REPORTED** | 42-per-vertex/252-neighbour theorem, both histograms, no-conic result, and distance-zero global counterexample are tracked and cited | closed → [C165 report](../2026-07-14-c165-clebsch-gap-theorem.md) |
| 5 | **C166 + C170 — REPORTED** | unconditional q≤14 exact census leaves q=11 alone; old q=9 conjugacy claim removed | closed → [C166 scope audit](../2026-07-14-c166-clebsch-why11.md), [C170 theorem](../2026-07-14-c170-unconditional-q11-uniqueness.md) |
| 6 | **C128 + C167 — REPORTED** | exact syzygy certified; unsupported group provenance isolated; Klein/Further remarks removed; C174 seam landed | closed → [C128](../2026-07-14-c128-icosahedral-syzygy.md), [C167](../2026-07-14-c167-clebsch-manuscript-scope.md) |
| 7 | **C131 + C161** | Sadeh ownership and earliest `(iv)⟺(v)` source unresolved | exact priority ledger from primary sources |
| 8 | **C168** | all current named scripts are hardened and Git-indexed; C128 closed; C167 removed decorative executables | replay clean-source manifest; audit PDF/citations; prune handoff → [preflight](../2026-07-14-c168-clebsch-computation-source-preflight.md) |

**Positive upgrades:** C170 and C172 are reported, giving unconditional q≤14 uniqueness and the
monomial/affine deep-hole orbit statements. C171 is reported with a sharp PGL-invariant global
gap `delta>=12` off the Clebsch class and eight local `A₅` move orbits. C173 is reported with the
five-triangles/Petersen explanation. Dependencies are encoded in the queue rows.

**Current execution order:** C176, C179, and the finite/checker portions of C184, C185, and C187 are
reported. C180's internal Lean proof and Dye primary-source audit are complete and retain only manuscript integration; C181 is independent of C180 and its conceptual
all-field proof is integrated. C184/C185/C187 retain the exact manuscript/Lean tails recorded in
the table, and C186 retains both its conceptual proof and source gate. C188 (`relconic`) and C189
(`cap`, consuming the Nofil implication) are downstream queued consumers, not Clebsch-owned result
work. C194 and C197 are reported; C190
records the completed gem-mining routing seam. C153 and C131/C161 remain the live
external-source gates; C168 is the last local closeout after their claim boundaries settle.
The C163 boundary and completed validation are in
[coding-semantics repair](../2026-07-14-c163-clebsch-coding-semantics.md).
The C165 local metric, exact replay, and counterexample are in
[one-point perturbation gap](../2026-07-14-c165-clebsch-gap-theorem.md).
The unconditional q=11 theorem and nine-field replay are in
[small-field uniqueness](../2026-07-14-c170-unconditional-q11-uniqueness.md).
The monomial code characterization and four-level orbit ledger are in
[coding-level orbits](../2026-07-14-c172-clebsch-monomial-orbits.md).
The sharp global nearest-conic gap and local move-orbit decomposition are in
[global and local gaps](../2026-07-14-c171-global-conic-gap.md).
**Lean gallery (plan A = small `decide` pieces first):**
- ✅ **Schreier = icosahedron DONE** — `residual_graph_icosahedral` in `Q11Coding.lean` (commit
  3b75a04): 5-regular, 30 edges, every vertex link a 5-cycle (Whitney ⇒ icosahedron). Pure `decide`,
  standard axioms, **no `native_decide`** — strict-trust clean. (Deep-holes=conic / covering-radius-3 /
  20-leader facts were already Lean-certified in `Q11Coding`/`Q11Semantic*`.)
- ✅ **Klein syzygy DONE** — `Q11KleinSyzygy.lean` proves the exact integer identity, canonical
  mod-11 reductions, and reduced syzygy; standard axioms, no `native_decide`. It deliberately does
  not certify the removed group/resolvent/diagonal claims.
- ✅ **C174/C176, small-field finite spine, and C186 point action DONE** — narrow elaboration and
  axiom audit pass for
  `ClebschChordDefect.lean`, `Q11BrianchonPetersen.lean`, `ClebschSmallFields.lean`,
  `Q5SixArcExclusion.lean`, `Q9Sylvester.lean`, and the leaf-split `Q11A5PointOrbits.lean`; all
  expose only the standard axioms recorded in C183. `Q11DecodingSynthesis.lean` and
  `SmallKChordMoments.lean` are also certified.
- ⏳ **Chirality ℤ/2 — NEXT, needs new infra:** no A₅-on-columns action exists in Lean; must derive the
  60 column permutations (Fin 6) from Stab(arc)⊂PGL(3,11) — the 60 matrices are in
  `papers/clebsch-hexagon-code/check_ten_arc_foil.py` — then act on the 20 triples and `decide` the two
  size-10 complementation-reversing orbits. A real piece, not a tail-end `decide`.
- ⏳ **Gap theorem** (252 perturbations, |UΔconic|≥18) — **DECISION FIRST:** may need `native_decide` at
  Fin-133 scale → the two-bar strict-trust caveat; decide reflected-computation vs. trust-chain note
  before building.
- ⏳ **Rigidity TFAE** (1548 arcs) — the heavy one; almost certainly `native_decide`, same caveat.
**Open lit (all non-blocking; folded from the removed outline 2026-07-14):**
- **C131 Sadeh on-receipt confirmation** — send the drafted email
  (`notes/2026-07-14-sadeh-thesis-request.md` → JWPH@sussex.ac.uk). On arrival: (a) confirm no
  over-concession beyond the extension-count spectrum — in particular that it does NOT state the
  deep-hole/covering reading or U-on-a-conic (those stay ours); (b) fix the exact citation form for
  the spectrum; (c) mine the 27-lines/cubic-surfaces-over-F₁₁ half for R-A/E₆. Hirschfeld–Sadeh,
  Giessen 164 (1984) 245–257 is the faster, citable public version (ILL/GDZ).
- **Dye 1991 primary text — read.** At q=11 Dye proves that every hexagon edge is non-secant to
  the associated conic, hence the conic is contained in the ordinary uncovered locus. He does not
  state or prove that the edges cover every off-conic point.
- **DMP AMC-numbering residual** — we cite Thm 6.3 / (6.4) / Thm 7.7 by **arXiv v2** numbering and the
  bibliography says so. The published AMC 17(5) numbering is unverified (paywalled). **Chronology is
  unfavorable, not favorable:** v2 is stamped 30 Jun 2021 and AMC 17(5) is 2023, so v2 *predates*
  publication by ~2 years, and the arXiv page carries **no journal-ref** — the authors never synced
  arXiv to the published version. Renumbering between v2 and print is therefore more plausible than
  less. The bibliography's v2 disclosure makes the paper safe either way; what is not safe is
  asserting the numbers match. Confirm against the published version if a copy becomes reachable.
  (Corrected 2026-07-14: an earlier version of this entry claimed "v2 postdates acceptance … very
  likely identical", which has the chronology backwards.)

## ⚠ PRIOR ART — the paper cites 70 years of it nowhere (2026-07-14 literature sweep)

**This is the lane's blocking item (C146).** Full detail:
[novelty status tables](../2026-07-14-novelty-status-review-summary-tables.md),
[gem-program vet](../2026-07-14-gem-program-vet.md) §2.1 (a row-by-row map of the `.tex`),
[exterior sets](../2026-07-14-gem-lit-exterior-sets.md). A TODO is planted at the §2 site in the tex.
**C153 is settled from the BSW 1992 primary text.** Their definition of a complete exterior set is
a set of `(q+1)/2` exterior points whose pair-joins all miss the conic. At q=11 they explicitly list,
up to isomorphism, one such six-arc (and one Pasch configuration). This owns the relative
six-arc/exterior-conic configuration and proves `C subset U(A)`, but the paper nowhere asserts the
reverse inclusion `U(A) subset C` or exact covering `U(A)=C`.
The rigidity and gap theorems are under their first-ever literature check
(`../2026-07-14-gem-lit-rigidity-gap.md`).

- **Dye 1991 is NOT the nearest prior art. Edge 1956 is, by 35 years.** W. L. Edge, "Conics and
  orthogonal projectivities in a finite plane", *Canad. J. Math.* **8** (1956) 362–382, §§29–32 (read
  from the primary text) constructs the q=11 object outright: six external points, all fifteen joins
  skew to the conic, named **"Clebsch hexagons"**, crediting **Clebsch 1871** (Math. Ann. 4, 284–345).
  He gives 22 of them over a fixed conic, each external point on exactly 2, forming two systems of 11
  that each partition the 66 external points, plus the order-60 stabilizer (22 = 1320/60). The §2
  priority footnote currently argues at length against the wrong paper.
- **The "all joins external" condition is classical too** — it is Blokhuis–Seress–Wilbrink's
  *complete exterior set* of size (q+1)/2 (Mitt. Math. Sem. Giessen 201 (1991) 39–44; *Combinatorica*
  **12** (1992) 143–147). BSW's object **is** Edge's hexagon renamed. **The paper contains no
  occurrence of "external point", "external line", or "exterior set" anywhere** — so C146 is a
  vocabulary job, not a citation patch: without that sentence the new citations have nothing to
  attach to.
- **What survives as ours:** the covering fact (`U(A)` = exactly the conic) appears in **none of**
  Edge, Dye, BSW 1992, or Van de Voorde, now all read in primary/full text. Dye and BSW establish
  only the inclusion of the conic in the uncovered locus. The deep-hole "first" is audited and survives
  ([deep holes](../2026-07-14-gem-lit-deep-holes.md)), with Reed–Muller deep holes marked NOT
  SEARCHED rather than cleared.
- **Chirality Prop 5.1 — the proposition survives, its surroundings do not.** The
  two-systems-swapped-by-the-non-PSL-operations motif is classical (Edge §§29/32); cite it rather
  than let a referee find it.
- **§3.1 five self-polar triangles:** Edge §§30.2–31 exhibits the five triangles, the synthematic
  total, and the order-60 stabilizer at q=11. Add Edge alongside Dye, who is the general-field theory.
- **Do not cite the genus-2 literature** for anything about PGL(2,11)-orbits: it classifies
  *geometric* automorphisms, ours are F₁₁-rational, and they agree only by luck. **CO-TR §8 requires
  p > 23** and cannot support the 132+132 PSL/PGL split. **arXiv's journal-ref for 1201.0484 is
  wrong** — Van de Voorde is *Discrete Math.* **311**(20) (2011) 2253–2258.

## The rigidity/gap headline — first-ever literature check, 2026-07-14: NO COLLISION FOUND

Full report: [rigidity/gap sweep](../2026-07-14-gem-lit-rigidity-gap.md). **The theorem survives.**
Nobody characterises the Clebsch hexagon via its extension points; nobody observes that `U(A)` lies
on, or is, a conic.

**The limit, stated plainly, because it decides what the verdict is worth:** the two most dangerous
sources were **not read** — Sadeh's thesis (not online) and Hirschfeld PGOFF Ch. 14 (403 on
archive.org, in-copyright lending). So this is *"no collision in any source that could be opened, and
the surrounding evidence argues against one existing"*, **not** "verified novel". The ILL is the gate.

Four independent supports, all verified from full text:
- **Karaoglu's 2018 Sussex thesis** — the direct modern continuation of the Sadeh line, same school
  and method — tabulates 6-arcs with **no extension-point column** and zero occurrences of any
  extension/deep-hole concept.
- **DMP**, our own dictionary source, checks out exactly (`c₀ = |U(A)|`; Thm 6.3(iii) verified
  verbatim) but contains **no q=11 6-arc data**.
- **Ball–Lavrauw surveys ×2** — zero hits for Sadeh/Clebsch/hexagon/A₅; the one near-miss ("arcs of
  size 6") is q=7/q=8 and was cleared in context.
- **Structural reason nobody would have noticed:** the 6-arc classification exists to *build cubic
  surfaces*, and the Clebsch map only consumes "**the arc** is not on a conic". No one in that
  program had a reason to compute `U(A)` at all.

**Three consequences for the manuscript:**

1. **Narrow the priority claim to the deep-hole side.** **(iv) ⟺ (v)** — PGL-equivalent to the
   Clebsch hexagon ⟺ stabilizer contains A₅ — is very likely classical: the q=11 "Diagonal" surface
   with `|G| = 120` sits in Karaoglu's Table 5.1, credited to Sadeh. Claim
   **(i)/(ii)/(iii) ⟺ (iv)/(v)**, not the whole TFAE.
2. **⚠ The Hirschfeld–Sadeh 1984 concession may be mis-aimed — in our favour.** Per its zbMATH review
   (Zbl 0538.51010, Grundhöfer), HS84 is about Singer-cycle orbits, complete 7-arcs, and
   (n;3)/(n;4)-arcs — **it is not a 6-arc paper**. The manuscript may be conceding priority to a paper
   that does not contain the conceded result. This is a citation fix, not a retraction, and it rests
   entirely on a ~90-word third-party review — **gate it on the ILL copy** (C131).
3. **⚠ Conflation hazard, one sentence to pre-empt.** The literature's standing condition is "6-arc
   **not on a conic**"; ours is "**U(A)** on a conic". One word apart, logically unrelated. A referee
   from this school will reach for the familiar meaning unless told.

## The gap theorem — its own pass, 2026-07-14: SURVIVES, but the framing must change

Full report: [gap theorem sweep](../2026-07-14-gem-lit-gap-theorem.md). **Both halves survive, no
collision** — and with *higher* confidence than the rigidity verdict, because the negative now has a
mechanism instead of being a bare absence.

**The framing is the finding. Thm 4.3 must be written as the genre's standard sentence.**
The genre is **Problem (III) of the packing problem** — *the size of the second largest complete set*
— one of four numbered problems organizing the whole field. Its defining paper is **Hirschfeld &
Storme, "The packing problem in statistics, coding theory and finite projective spaces", JSPI 72
(1998) 355–380** (update 2001), read end to end. The genre's standard sentence, verified three times
in it (Blokhuis–Bruen; Segre/Thm 2.5; Ball–Blokhuis):

> *"There is no ⟨object⟩ with X < ⟨invariant⟩ < Y. Furthermore, all ⟨objects⟩ with ⟨invariant⟩ = X are
> ⟨classified⟩."*

**Claim (a) is already exactly that shape** and should be written as that sentence rather than as "the
histogram has a hole". Same content; one reads as a theorem, the other as a curiosity. Highest-value
change the sweep found, and the vet confirms it — all three template instances verified verbatim.

**Refinement (vet):** anchor on the **minimum-side** precedents — Blokhuis–Bruen, and the Kakeya
"gap in the spectrum … smallest examples" line — not on Problem (III) itself, which along with Thas's
open problem (j) is a *maximum-side* question. Minimum-side matches claim (a)'s orientation exactly,
and it is the cheapest defusal of the (j) hazard (a referee reading us as claiming progress on
second-largest-complete-arc). Note the hazard arrives anyway via the published `m″(2,11) = 10` table,
whether or not we adopt the language.

**G5 — `U(A)` is classical machinery, and the defence is narrower than first written.** (Corrected by
the [Fable vet](../2026-07-14-gap-theorem-vet-fable.md); the version landed here earlier contained a
parity error and two overdrawn claims.)

`U(A)` is **not** a newly-noticed object: a point extends a k-arc iff its pencil is a component of the
**tangent envelope** — Segre's theory, and that *is* `U(A)`. **Cite Ball–Lavrauw
[arXiv:1908.10772](https://arxiv.org/abs/1908.10772) Thms 39–41**, not PGOFF Cor. 10.3: open access,
both parities, exact gates, Segre attribution — and De Boeck records that PGOFF's printed versions
contain misprints here.

**⚠ The threshold was wrong, at our parity.** `k > q/2 + 1` (= 6.5 at q=11) is the **q-even**
theorem's gate. The correct **odd-q** gate is `|A| ≥ 2q/3 + 2` ≈ **9.34**, i.e. **ten points** at
q=11 (Ball–Lavrauw Thm 40, planar case due to Segre). The exclusion of `k = 6` **survives and widens**
— it fails by four points, not by half a point — so any "strikingly close" remark is **false at our
parity and must not enter the tex**. Segre's extension bound `k > q − √q/4 + 25/16` (≈ 11.73) is
**verified** (Thas notes verbatim; HS survey Table 2.3). One-line vacuity witness: at `k = 6` the
envelope's class is 14 > 12 lines per pencil, so envelope membership constrains nothing.

**What the defence is and is not.** It is a **non-collision certificate**: no classical theorem
subsumes the gap statement, because their hypotheses provably exclude `k = 6`. It is **not** a
significance certificate. "Beneath notice" is true *alongside* "out of reach" — Sadeh's census has
existed since 1984 and computing `|U|` per class was always trivial, so the hypothesis gate explains
why no *theorem* covers k=6, not why nobody *stated* the fact. **State both mechanisms in one
calibrated sentence** (the arc-classification line had the census but no motive; the arc-extension
line has the motive but its hypotheses exclude k=6) and hang significance where the manuscript
already puts it: the coding reading and the rigidity theorem the gap protects.

**And do not say the companion sweep is "falsified".** Machinery is not motive: its cubic-surface
no-motive argument survives intact. The correction is that `U(A)` is not an unnoticed object, not that
the tradition had a reason to look.

**G3 — the Hirschfeld–Sadeh concession is settled, in our favour, and the ILL gate lifts for it.**
Hirschfeld's *own* survey cites **Sadeh's thesis [189]** and **PGOFF §14.8** for the q=11 arc data, and
**omits HS84 from its bibliography entirely**. A co-author leaving out his own paper exactly where it
would be needed is far stronger evidence than the ~90-word zbMATH inference. The concession was
mis-aimed; the withdrawal already applied to the tex stands, and C131 no longer gates it. (C131 still
asks whether *Sadeh's thesis* has the six-arc extension data.)

**⚠ G8 — a concrete conflation hazard, distinct from the (i)/(iv) one.** Faina–Marcugini–Milani–
Pambianco, *"The spectrum of the values k for which there exists a complete k-arc in PG(2,q) for
q ≤ 23"*, Ars Combin. **47** (1997) — **covers q=11**. A referee will point at it, because "spectrum"
+ "q=11" + "gap" is our sentence too, about a different invariant (complete-arc *sizes*, not `|U|`).
Cite it and distinguish. Also published: `t(2,11) = 7` and `m″(2,11) = 10` (survey Tables 2.4/2.5) —
cite `t(2,11) = 7` as the reason the `|U|` histogram has no zero bin.

**On claim (b):** one-point perturbation is **not** a named genre (NOT FOUND). Its home is
**stability** — *near-extremal ⟹ close to extremal* — and claim (b) **denies** that, so the
manuscript's "rigid, not merely stable" is technically correct and well chosen. Keep it, but cite the
genre nearby or it reads as informal. Note Thas lists "second largest complete arc for **q odd**" as an
**open problem**: good (the genre is live) and dangerous (a referee may think we claim progress on it
— we do not).

**ILL targets (revised by the vet).** Ball–Lavrauw supersedes PGOFF as the *defence* citation, which
**downgrades §10.1 from "could collapse the defence" to confirmatory**. **§14.8 — the q=11 arc census
— reverts to the top target**, since that is what C131 actually needs. Name sections, not chapters:
**§14.8, then §10.1 + Cor. 10.3, Table 9.4**.

**Open obligations (surfaced by the 2026-07-14 adversarial review; previously recorded nowhere):**
- **C146 — the Edge/BSW prior-art re-base. BLOCKS SUBMISSION.** See above.
- **C128 — kernel-check the syzygy `H³+T²=f⁵ mod 11`.** The manuscript states the syzygy as fact
  (§7). C125 verified it in Python (`notes/2026-07-13-c125-klein-resolvent.md`), but the Lean
  kernel-check is open and the task sits only in the queue. NB the handoff previously said the C125
  reduction facts were "all certified" — that oversells while C128 is open.
- **Checker-coverage gap.** Three finite computations ship with no checker: the gap theorem's
  252-perturbation spectrum (§4 Thm 4.3 — 4.1 is rigidity, 4.2 the corollary), the chirality orbit
  computation (§5 Prop 5.1), and the syzygy (§7). The finite clauses were independently re-derived:
  the local perturbation calculation has `42` legal moves per deleted vertex and spectrum
  `{18:30,19:60,20:90,22:42,24:30}` (min 18, ≤7 conic points surviving); chirality has
  `#Stab=60`, orbits `[10,10]` complementary; and the syzygy holds. The gap theorem's final global
  “nearest other six-arc” gloss does **not** follow and is false literally: a conic-preserving
  projectivity yields another six-arc with the same deep-hole conic. C165 preserves the valid local
  theorem, removes/localizes that gloss, and commits the checker. Every cited computation must be
  backed by a Git-tracked artifact; C168 rejects scratchpad-, session-, and untracked-only evidence.
- **Sequencing/novelty seam vs the `arcs` paper — see §Paper sequencing below.**

**Closed 2026-07-14 (were the outline's blocking research items):**
- **O'Keefe–Storme 1996 — was never open; the outline was stale.** C129 already settled it: the arc
  catalogue has no extension-point data, SVM 1995 supersedes it for planar uniqueness, "cite it for
  completeness; not a gate." What *had* been missed is that C129's actual instruction was never
  carried out — the paper cited it **nowhere**. Now cited in §2 (planar $A_5$ case of their
  catalogue) with a bibliography entry. A paper on $A_5$-fixed six-arcs omitting "Arcs fixed by
  $A_5$ and $A_6$" is a referee flag; that hole is closed, and the ILL stays unnecessary.
- **Dye 1991 priority footnote — C129 asked for it; it was never written. Now in §2.** C129's
  recommendation was "draft now with a cite of Dye for the hexagon/conic apparatus *and a footnote
  that the q=11 0-bisecant identification does not appear in Dye's stated results*." The cites were
  in; the footnote was not, so the paper's priority claim against its nearest prior art rested on
  proxy evidence that appeared nowhere in the manuscript. The footnote now records the zbMATH/1997
  self-recap evidence, that SVM prove q=11 incompleteness without invoking any such fact from Dye,
  and the structural reason (a per-q rationality statement has no home in general-field synthetic
  geometry; at q=9 the Brianchon points lie on 𝒞).
- **DMP Thm 6.3 pin — SOUND, no hole.** Its hypotheses are exactly two: an *arbitrary* n-arc in
  PG(2,q), and its `[n,n−3,4]_q` MDS code per their Def 6.1. **No GRS/NRC/conic hypothesis, no
  restriction on n, k, q, or characteristic** — covers our non-GRS q=11 case directly, so the Lean
  fallback is not needed. DMP explicitly anticipate non-GRS arcs ("the corresponding codes are not
  GDRS or GTRS"); note their `c_i` table (6.1) is for *complete* arcs (n=6 at q=7/8/9; n=7 at q=11)
  and so contains nothing of our shape — the coverage comes from Thm 6.3's own "both the cases c₀=0
  and c₀≠0 are possible" clause, not from the table. (Their n=6, q=9 row `(60,15,10)` is the complete
  q=9 sibling of our `(90,15,10)` and independently corroborates `check_q9_exclusion.py`.) The
  GRS/conic hypotheses live downstream in their
  Thms 6.4/6.5/6.8/6.10, which we don't cite. Leader count `binom(n,3)` is their (6.4) and
  independently the `d=4` case of `binom(n,d−1)` (their Thm 7.7) — two supports, so 20 is an
  instantiation, not a fitted constant. **Two §3 fixes applied:** "adjoining x preserves MDS iff
  missed by every secant" was mis-attributed to Thm 6.3 (it is Def 6.1 + arc-completeness — now split
  out); and `binom(n,3)` is now written before specializing to 20.
- **q=19 non-example — exact `|U| = 140`**, replacing the "≥105" counting bound (and 111 — both were
  bounds on the wrong quantity). `140 = 20 + 120`: all 20 conic points stay deep holes but 120 more
  escape all 15 secants, so `U ⊋ 𝒞` and lies on no conic (rank 6/6). q=19 fails by the conic ceasing
  to be *all* the deep holes, not by ceasing to be deep holes — the capacity deficit
  `15(q−1)=270 < q²−6=355` that Lemma 6.1 predicts. Also verified rather than assumed: the recipe
  still yields a genuine 6-arc at q=19 even though `5 | q+1` there (order-5 elements non-split, fix
  no rational conic point; their conjugate fixed-pairs give Galois-stable rational chords ⇒ rational
  poles). Checker: `papers/clebsch-hexagon-code/check_q19_nonexample.py`.
- **|U| histogram independently recomputed** by a second code path
  (`check_rigidity_degenerate_conic.py`), reproducing `{12:6,16:30,18:150,19:300,20:630,21:360,22:72}`
  and returning exactly the six concyclic arcs, all nonsingular — this also closes the
  degenerate-conic exclusion, the one place the TFAE could have had a hole. Cited in a §4 footnote.
- **Citation lock verify** is DONE. Headline = rigidity theorem, SAFE as "first" (item-5 round-3); "first"
scoped to the conic-rigidity/covering reading, Sadeh cited for the census. **Priority on the |U| extension-count spectrum is GRANTED to the arc-
classification literature outright** (it's the standard byproduct of arc classification) — so the
Sadeh Sussex thesis (~1984) + Hirschfeld–Sadeh Giessen 164 (1984) ILL is **confirmatory, not
blocking**; nothing gates drafting. Dye 1991 is now read from the primary text. P¹ labeling reconciled (Lean chart canonical);
parent-program feed CLOSED NEGATIVE (C130) — do not route C84 through this. **The four-target
reduce-at-best-prime spike is CLOSED NEGATIVE (C132):** none realizes the arc/deep-hole template.
The corrected 27-line model is `Q⁻(5,2) ⊂ PG(5,2)` and is non-cap; the spike does not prove global
uniqueness or exhaust every `P¹` construction. The paper stays single-instance.
**Companion log**: append dated riffs to
[`done/2026-07-13-clebsch-paper-archive.md`](done/2026-07-13-clebsch-paper-archive.md)
(create on first archive).
**Related lanes**: arcs manuscript (`arcs_complete_outside_conic`, Prop `prop:q11-code`);
[twisted-cubic transversal-spectrum](2026-07-13-twisted-cubic-transversal-spectrum.md) (k=4 lift
lives there); paper #1 icosahedral-extension-complex (`comp-q11-icosahedral`) — shares the A₅ orbit
(the "fusion/two-spine" framing was later DEMOTED by the red-team; treat as a shared-object link,
not a merged thesis).

## The object

The projectively **non-GRS `[6,3,4]₁₁` MDS code** of covering radius 3 (`comp-q11-mds-deep-holes`,
Lean `RelativeConicArcs/Q11Coding.lean`, `Q11Semantic*.lean`, coords `Examples.lean:46`,
conic `XZ=Y²`). Equivalently a **6-arc off every conic** in PG(2,11).

**Confirmed structure (Fable, against Lean coords):**
- Each of the 6 arc points is an **external point** of the deep-hole conic; its two tangency points
  are exactly its **missed antipodal pair** (`witness_chords_miss_antipodes`, `witnessMissingEdge`;
  all six match, e.g. witness 0 = (1,10,0), tangents {0,9} = missing edge (0,9)).
- So the **arc = poles of the six antipodal chords = poles of the six 5-fold axes of the A₅
  (icosahedral) action** on the 12 conic points (A₅ ⊂ PGL₂(11), classical at q=11).
- **Arc stabilizer in the conic stabilizer PGL₂(11) is exactly order 60 = A₅**; point-stabilizer
  order 10 = D₁₀. Single A₅-orbit.
- This answers *why* deep holes are a conic (the arc's A₅ symmetry) and shares the A₅ orbit with
  paper #1. (NB: the causal "deep holes = conic *because* Klein-reduction" was struck by the
  red-team — see the deflation section; the A₅-symmetry cause here is the rigidity theorem, C126.)

## Verified facts (cheap, Lean-able)

- Coset-leader-weight distribution **(1, 60, 1150, 120)**, sums to 11³=1331. `60=6×10`,
  **`120 = 12×10`** = (12 conic points)×(10 scalars) — "deep holes = conic" made quantitative.
- Codeword weight enumerator **(1,0,0,0,150,420,760)** (MDS-forced; verified vs formula).
- **(900,150,100)** = split of the 1150 distance-2 cosets by leader count (1/2/3), tied to the
  secant-index spectrum (90,15,10)×10 (`Q11SemanticLeaders.lean`, `Q11SemanticSpectrum.lean`). NOT
  the min-weight codewords (=150) — do not conflate (numerical coincidence only).
- **Every deep-hole coset has exactly C(6,3)=20 leaders** (uniform 20-way tie).
- Code is **not completely regular** (distance-2 leader counts non-constant) → no naive
  association scheme.

## ⚠ RED-TEAM DEFLATION (adversarial pass — OVERTURNS the fused framing below)

A hostile-referee pass (read SVM 1995 full text, DMP series, ZWK, and now Dye 1991) cut the
lane down. **What actually survives — treat this as the current framing; the "FUSED FRAMING" section
below is DEMOTED to companion history:**

- **Headline "deep holes = the conic": TRUE but corollary-grade.** It is *exactly equivalent* (via
  DMP 2021 arXiv:2101.12722 Thm 6.3, the known arc↔coset dictionary — our own C122 concedes this) to
  one finite-geometry sentence: *the extension points of the Clebsch hexagon in PG(2,11) are the 12
  points of its A₅-invariant conic.* SVM 1995 Prop. 13 already proved incompleteness-by-computer at
  q=11 but **did not print the extension points** — that one unprinted finite fact + a known
  dictionary is the real contribution. True, apparently unstated, thin.
- **Dye-1991 gate: CLEARED FROM THE PRIMARY TEXT.** Dye p.281 proves that an edge of the associated
  conic is a chord iff `-1` is square and otherwise is non-secant. Thus at q=11 Dye supplies
  `C subset U(A)`, but he does not state the reverse inclusion or exact equality. The exact source
  boundary and BSW comparison are in
  [the primary-source audit](../2026-07-15-dye-bsw-primary-source-audit.md).
- **Klein spine: DECORATION, and the causal "because" is FALSE by our own data.** f mod 11 is the
  PGL₂(11)-invariant Dickson form (forgot the icosahedron); and C126 shows covering-exactness *fails*
  for every sibling — so the Klein reduction produces the *objects* but does NOT cause the *theorem*.
  **Strike "because"; drop the two-spine architecture.** BUT the sizing was overcorrected: the C125
  *form-level* reduction (vertex form → 12 conic points, six diagonals → `witnessMissingEdge` chords,
  syzygy H³+T²=f⁵ via 1728≡1 — all certified, and found **nowhere** in the literature per C127) earns
  a short **discussion section**, not one line — written explicitly as non-causal and hedged via
  Elkies §3.3 + the Dickson-invariant note. p+1=12 is a triviality, a remark not an organizing
  principle.
- **Dual-variety conjecture: DEAD — CONFIRMED by a second independent pass with proofs. C123 = NO-GO.**
  The dual-variety examination (read ZWK full text) kills it five ways: (i) ill-posed (non-GRS columns
  aren't on any RNC — only an *existential-curve* repair parses); (ii) **tautology at k=3** — in
  P(Sym²) the RNC, its dual, and the discriminant conic all coincide (self-dual), so q=11 gives zero
  evidence distinguishing "dual variety" from "RNC" from "quadric"; (iii) **FALSE as a k=3 law by our
  own arc family** — the Clebsch hexagon at **q=19** has ≥105 deep holes (counting: 381 pts − 15
  bisecants×18) vs 20 for a conic; same arc, next prime, dead; (iv) **impossible at k=4** in both
  radius regimes (every plane meets the ruled developable in ~q rational pts → not deep holes; and
  bisecant capacity gives Ω(q³) deep holes vs ~q² on the developable); (v) **ZWK 2020 already
  subsumes+refutes the GRS shadow** — for PRS redundancy-4, deep holes = tangent-developable ∪
  quadratic-extension family, the dual-variety part a ~2/q *sliver*, not an equality. **Do NOT run
  C123** (would test an impossible equality against an empty uncovered locus in the degenerate char-3
  fields). Replace the "forward half" with the **ZWK stratification/excision framing** (below).
- **Replacement forward framing (survives):** *the Clebsch hexagon's bisecants excise the non-split
  (quadratic-extension) strata exactly, leaving the disc=0 stratum — a covering coincidence provably
  unique within its own arc family* (fails at q=19 by counting). Two citable impossibility lemmas
  (plane-meets-ruled-surface; bisecant capacity q³/2) + the q=19 counterexample close R3/D2 cleanly,
  no compute. Only surviving forward *question* (pose, don't conjecture): does any radius-4 non-GRS
  MDS code have deep-hole locus = F_q-points of a *twisted cubic* (the curve, not its developable)?
  — no candidate arc/mechanism.
- **Chirality Z/2: survives as a PROPOSITION** (canonical automorphism-invariant Z/2 on deep-hole
  leaders, Lean-certified) — but the group theory is exercise-grade (PSL(2,5) not 3-homogeneous;
  Hom(A₅,ℤ/2)=0). Not a headline. **Meaning (R-B, re-homed from the demoted framing):** this Z/2 is
  exactly the obstruction to descending the Clebsch diagonal cubic's full **S₅** down to the conic's
  **A₅** — the odd elements act on the surface but do NOT descend to PGL₂(11) (the N_{PGL₂(p)}(A₅)=60
  fact), and only A₄/A₅ lack a sign character, so the phenomenon is icosahedron-only. A clean,
  previously-unstated *meaning* for the proposition — one paragraph, costs nothing.
- **11-cell (F1) and j-function (F2): STRIKE / demote to one remark.** F1 uses the degree-11 PSL₂(11)
  action — the very numerology the mirage list bans conflating with our degree-12 object (internal
  contradiction). F2 is a re-labeling of the N2 syzygy. No independent content.

**Surviving paper (modest, single-spine, finite-geometry/designs venue — NOT IEEE TIT):** *"The
Clebsch hexagon code: the deep holes of a `[6,3,4]₁₁` MDS code are the points of the A₅-invariant
conic."* Known hexagon (SVM 1995, Dye 1991) × known dictionary (DMP 2021) → first MDS code whose
complete deep-hole set is the full F_q-point set of a positive-dimensional named variety, with
group-theoretic cause. + chirality-Z/2 proposition + the p=11 uniqueness theorem (C126, as the
result not a defect). Klein/dual-variety demoted to discussion + one open question.

**Citations locked (C129) — draftable now:**
- **Dye gate cleared from the primary text** (above) — cite p.281 directly; no ILL residue remains.
- **ZWK** arXiv:1901.05445 **Thms I.4–I.7** (I.5 = tangent lines to the NRC; I.6 = quadratic-extension
  family; I.7 = completeness, count q(q+1)²/2) — cite as the true precursor of any dual-variety talk.
- **DMP k=4** = arXiv:**1909.00207** Thm 3.1 + Tables 1–2, Def 7.1(M2), Thms 7.2/7.3 (codim-4 GDRS
  quasi-perfect R=3; distance-3 cosets = points off every real chord) — the k=4 "uncovered locus"
  citation; companions 2104.12254/2103.11248/2112.14803.
- **O'Keefe–Storme 1996** (Zbl 0848.51007) — cite-for-completeness; SVM 1995 supersedes for the plane.
- **PG(2,11) arc classification** — **Hirschfeld–Sadeh, Mitt. Math. Sem. Giessen 164 (1984) 245–257**
  + Sadeh (Sussex) thesis + Hirschfeld PGOFF 2nd ed. Ch.14 — cite before writing "first".

**Pending corroboration:** the dual-variety-examination and minimal-hypothesis (Thread A) agents were
still running when this landed — their independent reads may soften or harden the above.

## ✅ LOOP-BACK to parent program (Thread B, computed vs Lean coords) — EXACT, not analogical

The icosahedral deep-hole lane is the **extremal instance of the parent program's conic-involution
Schreier machinery** (`notes/2026-07-12-conic-involution-schreier-graphs.md`):

- **"Deep holes = whole conic" ⟺ D(S) = ∅** — the parent's saturation set (conic points on arc
  secants) is empty. Verified: all 15 products σ_xσ_y are **elliptic/nonsplit** (tr²−4det a nonsquare).
  So healthiness = **15 quadratic-residue conditions on the §6.3 trace-classifier invariant**, and via
  tr(A_xA_y)=−B(x,y) it's a statement about the polarity form restricted to the arc.
- **The Schreier graph of the six σ_x on the 12 conic points IS the icosahedron graph** (30 edges =
  6 matchings of 5, 5-regular, neighborhoods C₅, Whitney triangulation of S² ⇒ icosahedron uniquely).
  The 6 missing "diameters" = the axis chords. A clean `decide`-grade **edge-level** witness for F1
  (previously only a face-lattice match) — new and headline-adjacent. (√5 *is* in this graph's
  spectrum — vindicates the Hoffman–Singleton kill.)
- **The six σ_x generate full PGL₂(11)** (order 1320); all have nonsquare det ⇒ outside PSL₂(11) —
  the "missing reflections" made external. Clebsch hexagon = extremal §6-A₅ instance: empty saturation
  + full-PGL₂ generation + icosahedral residual.
- **Correction:** governed by the fixed-point/saturation *calculus*, **NOT the spectrum** (bounded
  data at fixed q; "spectral gap" is a category error here). σ_x do NOT act on the 6 arc pts / 10
  Petersen pairs (σ_x ∉ A₅) — arc-side Schreier graphs need A₅-internal generators.
- **NEW counting bound (upgrades p=11 uniqueness to a ~2-line proof of the forward direction):**
  complete-outside needs 15(q−1) ≥ q²−6 ⟹ **q ≤ 14**; with A₅-rationality (q≡±1 mod 10) the only
  candidate is **q=11** (150 secant-slots vs 115 off-conic pts, realized with zero slack by the
  spectrum 90·1+15·2+10·3). Predicts the p≥19 degeneration *before* any group theory. Belongs in the
  "why 11" section alongside p+1=12 and 11∤60.
- **Markoff/BGS-expansion: MIRAGE, kill hardened.** Expansion is *robust* (almost all p); ours is
  *anti-robust* (exactly one prime) — bounded 12-orbit vs growing ~p²-orbit. Opposite signatures.
  Residue: both reduce to "trace split/nonsplit" (Fricke *language*, not structure) — claim nothing.
- **Bookkeeping RESOLVED (by convention):** the two P¹ labelings — Lean/`Examples.lean` (conic
  XZ=Y², `witnessMissingEdge` indices; witness (1,10,0) tangents {0,9}) vs the parent-note ([t²:t:1],∞)
  chart ({5,∞}) — are the same 12 points under different charts, not a discrepancy. **Canonical =
  the Lean labeling** for all Lean/paper work; translate any parent-note statement through the chart
  when crossing over. No re-derivation needed.

## ✅ RIGIDITY THEOREM (Thread A/B, exhaustive) — the real content; rebuts "corollary-grade"

Exhaustive classification of **all 1548 frame-normalized 6-arcs in PG(2,11)** up to PGL(3,11)
(deep-hole locus U = points off arc and off all 15 secants; conic-containment by exact nullspace):

- **Every 6-arc has U≠∅** (covering radius 3 universal; smallest complete arc is 7) → "non-GRS radius
  3" distinguishes nothing; all content is *where* the deep holes sit.
- **|U| histogram {12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72}.** Minimum |U|=12 hit by
  exactly 6 arcs, all PGL-equivalent to the Clebsch witness (mult 6 = 360/60 ⇒ |Aut|=60=A₅). **Gap
  12→16.**
- **U ⊆ a conic (degenerate allowed) for the Clebsch class ONLY**, and there U = the *full* 12-point
  conic. Zero other classes qualify. The `252` here counts concyclic representatives within the
  `1548` frame-normalized sweep, not all conic six-subsets; the latter count is `C(12,6)=924`.

**RIGIDITY THEOREM (exhaustive at q=11, `decide`-grade Lean-able):** for a 6-arc A in PG(2,11), TFAE
— (i) deep-hole locus ⊆ some conic; (ii) = all F₁₁-points of a nondegenerate conic; (iii) |U(A)|≤15
(=12); (iv) A is the Clebsch hexagon, i.e. Stab(A)⊇A₅. **So condition (b) alone — deep holes ⊆ a
conic — FORCES A₅**; the three-part "healthy" characterization collapses to one, and **A₅ is
RECOVERED from the coding condition, not assumed.**

**Thread B — RIGID not stable, as a GAP theorem:** all 252 one-point perturbations keep radius 3
(deep holes never vanish) but shatter the conic instantly — |U Δ conic| ∈ {18,19,20,22,24}, min 18;
≤7 of 12 conic points survive; zero perturbations land U on any conic. Thus the correct quantitative
statement is a **local deficiency/gap theorem on the one-point neighbourhood** (there the distance
jumps 0→≥18),
replacing the impossible stability theorem. The 5-arc's U has 43 pts ⊇ conic; the Clebsch 6th point
uniquely prunes it to exactly the conic.

**Why this matters (rebuts red-team #1):** the DMP dictionary makes "deep holes = no-bisecant points"
routine, but *"uniquely the Clebsch hexagon among all 6-arcs has its no-bisecant points on a conic,
and that condition recovers A₅"* is a genuine **extremal/rigidity theorem** with a proof — not a
one-arc computation. This is the headline content the surviving paper should lead with. (Caveat:
exhaustive at q=11 only, consistent with the q=19 failure — the rigidity is itself a p=11 fact.)
**Priority (item 5, round-3 audit below):** the conic-containment ⇒ A₅ rigidity + the gap/deficiency
theorem are SAFE to claim "first"; but the underlying 6-arc *census* and the raw |U| histogram are
extension-count data likely in Sadeh's F₁₁ thesis — cite Sadeh/Hirschfeld-Sadeh, do NOT claim first
on the numbers until that thesis is obtained.
**Open proof obligations (two, currently asserted — see paper outline §Remaining-work):** (1) the
TFAE (i)⇒(ii) *degenerate-conic exclusion* — prove no 6-arc with |U|∈{12..15} has U on a line-pair;
(2) the §6 counting-premise lemma "complete-outside ⟹ 15(q−1) ≥ #off-conic" (the only real-math, non-
enumeration step) + explicit exclusion of q=9. Everything else is certified compute or standard-cited.

---

## FUSED FRAMING [DEMOTED by red-team above — kept as exploration history]

> **Re-homed as live levers (NOT demoted):** R-A (Brianchon=Eckardt→W(E₆) → family route C),
> R-B (S₅-non-descent → the chirality proposition in §RED-TEAM), and the hemi-icosahedron
> face-lattice + Schreier=icosahedron witness (→ §loop-back, kept as a `decide`-grade proposition).
> The *thesis* is demoted; these sub-items were collateral and survive above.

**Lead thesis (superseded — see red-team):** *The `[6,3,4]₁₁` icosahedral code is the unique prime at which Klein's
solution of the quintic closes over a finite field — the six columns are the mod-11 reduction of his
resolvent sextic (the six diagonals), the deep holes are his degree-12 vertex form (which at p=11
alone fills the whole projective line), and the reflection-free chirality of its deep-hole leaders is
the icosahedron's own handedness — with the deep-holes = dual-variety conjecture carrying the
phenomenon to every rational normal curve.*

Two-spined paper: **Klein spine explains q=11** (deep holes are a conic *because* they're the
reduction of Klein's vertex form; C125 REAL); **dual-variety spine (D2/C123) generalizes it** (the
forward-looking half, predicts k=4). Neither alone survives: coding-only loses to ETGRS literature
(C122); Klein-only is a coincidence without a theorem. The chirality even/odd result (C124) is the
most self-contained headline *result*, subordinate to the Klein *framing*.

### The mod-p Platonic family — C126 RESULT: q=11 is SINGULAR, the "family" is a foil

C126 built the axis-pole arc for every Family-A case (vertex-count=p+1) and tested it. **Two
properties we hoped were family-wide are UNIQUE to the icosahedron/p=11:**

| Solid | Grp | p | arc | complete-outside-conic? | chirality |
|---|---|---|---|---|---|
| Tetrahedron | A₄ | 3 | — | construction **doesn't instantiate** (order-3 stab parabolic at p=3) | N/A |
| Octahedron | S₄ | 5 | 3 | **no** (arc too small) | vacuous |
| Cube | S₄ | 7 | 4 | **no** (conic uncovered but 12 extra pts too) | **not chiral** (single orbit, G odd-inclusive) |
| **Icosahedron** | **A₅** | **11** | **6** | **YES, exact** | **chiral — clean S vs Sᶜ Z/2** |
| Dodecahedron | A₅ | 19 | 10 | **no** (over-covers, 0 uncovered) | all-even but 5 orbits, not clean 2-way |

- **"Deep holes = whole conic" is special to p=11** — every other Family-A reduction degenerates
  (arc too small, or over-covers). So the earlier "family with deep holes = whole conic" narrative
  is **refuted**; q=11 is the singular clean case. This *strengthens* the uniqueness thesis.
- **Chirality-iff-reflection-free holds as a THEOREM:** `Hom(A₄,ℤ/2)=Hom(A₅,ℤ/2)=0` forces every
  perm rep of A₄/A₅ all-even (unmergeable); S₄'s sign character makes odd images generic (cube's G
  *is* odd-inclusive → not chiral). Confirmed computationally.
- **BUT the clean single-Z/2 (S vs Sᶜ) packaging is specific to arc size 6** (a 3-subset of a
  6-set has a natural same-size complement). Dodecahedron (arc 10, A₅) is still unmergeable — in
  fact *no* permutation merges its two size-24 orbits — but splits 5 ways, a messier phenomenon.
  So "clean icosahedral chirality Z/2" = icosahedron/p=11 only.
- **Syzygy H³+T²=f⁵ mod 11** (1728≡1): cheap kernel-checkable identity anchoring "real reduction."
- Family B (√5-primes A₅⊂PSL₂(p)) and the N1 one-scheme/Frobenius framing survive as the
  *arithmetic* backdrop; but the *clean coding phenomenon* (complete-outside + Z/2) does not spread
  across it — it is the exceptional fiber at 11.

### Number-theory spine (outward dig)

- **N1 [REAL — unifying statement]. One ℤ[1/30]-scheme, reductions = the family.** Klein's
  icosahedral configuration (group + forms f,H,T + arc + conic) is a scheme **𝒳 over ℤ[1/30]** (bad
  primes exactly 2,3,5). Our F₁₁ object = 𝒳 mod 11. **Family B = the split primes of ℚ(√5)**
  (p≡±1 mod 5): Frobenius at p splits ⇔ A₅ is F_p-rational ⇔ 12-orbit F_p-rational. The whole
  √5-family is "reduce one ℤ[1/30]-scheme, watch Frobenius in ℚ(√5)." Family A (p=5,7,11,19,29) =
  the sub-locus where the orbit *fills* the line.
- **N2 [REAL, needs-literature — the striking bridge]. The icosahedral syzygy IS the modular
  discriminant relation.** H³+T²=1728f⁵ is the invariant-theoretic avatar of
  **E₄³−E₆²=1728Δ** (same 1728; f↔Δ, H↔E₄, T↔E₆; j=H³/1728f⁵). Mod 11 both collapse (1728≡1): our
  certified **H³+T²=f⁵** is the mod-11 reduction of the modular discriminant syzygy → the deep-hole
  conic (=f) is a **mod-11 avatar of Δ**. Calibrate novelty (the certified mod-11 coding incarnation
  likely is new).
- **N3 [REAL, computed — corrects earlier speculation]. Chirality is UNIVERSAL, not arithmetic.**
  N_{PGL₂(p)}(A₅)=60 at every √5-prime tested (11,19,29,31): the icosahedral reflection is *never*
  F_p-realized (needs F_{p²} / a correlation). Chirality is a group-fact of A₅, uniform across the
  family — NOT a per-prime splitting phenomenon (kills the "arithmetic handedness" reach). The
  uniformity is itself clean; the S₄ octa/cube members should *merge* (the C126 separator).
- **Mirage:** class-number / Ramanujan-τ-mod-11 (11 not a τ-congruence prime); McKay 2·A₅↔E₈ (we use
  A₅⊂PGL₂, not binary 2·A₅); inverse Galois / X(11) rational pts (Klein already realizes A₅ over ℚ;
  degree-11 PSL₂(11) action is a different object). Note kinship, claim nothing.

### Second-order functor: "reduce a famous invariant-theoretic object at its best prime → certified finite code"

Canonical exactly when a distinguished orbit has size = |Pⁿ(F_p)| (P¹: p+1) — one best prime per
object, the way 11 is singled out here. Candidate lanes (surprising × real × own-lane):
icosahedron/p=11 (template); **octa/cube S₄ p=5,7 + tetra A₄ p=3** (C126 control — S₄ non-chiral
isolates chirality to A₄/A₅); Hesse config (9 inflections, order 216) over F_p⊇ζ₃ → certified
[n,k]₃ code (good small 2nd instance); Klein quartic / PSL₂(7) / Hurwitz curves (own lane); 27 lines
W(E₆) / 28 bitangents W(E₇) — the theta-characteristic parity would be the higher analog of our
chirality Z/2 (speculative). Leech/Golay: mirage for this functor (already codes).

### Phone-call-worthy for a number theorist

1. "One ℤ[1/30]-scheme; Frobenius in ℚ(√5) tells you the code (deep holes and all) at each prime" (N1).
2. "The deep-hole conic is a mod-11 avatar of the modular discriminant Δ; the code's syzygy is
   E₄³−E₆²=1728Δ reduced" (N2, pending novelty).
3. "p=11 is the unique prime where an exceptional simple group's natural form fills the projective
   line — completely certifiable."
4. Question our exact data settles that they can't cheaply verify: for which exceptional-orbit/prime
   pairs does the orbit fill Pⁿ AND the arc stay complete-outside (deep holes = whole variety)?

### Third-order reaches (Clebsch/E₆/modular tower) — from the classical names

- **R-A [REAL structure; SPECULATIVE it moves coding; needs-lit]. Clebsch cubic → 27 lines / 10
  Eckardt points / E₆.** The char-0 avatar is the **Clebsch diagonal cubic surface** (the S₅-symmetric
  cubic carrying the 27 lines W(E₆)⊃S₅, the Sylvester pentahedron, and **10 Eckardt points**). Dye's
  **10 Brianchon points** are the plane-conic shadow of those 10 Eckardt points. Chain:
  *deep-hole leaders (Petersen) = 10 Brianchon = 10 Eckardt of the Clebsch cubic = a W(E₆)/S₅
  config* — drags **E₆ / 27 lines into the deep-hole side** for the first time. Explore: does the
  code's weight/coset structure see the 27 lines? (Rank #1 to chase.)
- **R-B [REAL, in-repo]. Chirality Z/2 = the S₅-non-descent obstruction.** The Clebsch surface
  carries full S₅ (reflections included); the conic/line only sees A₅ — the odd elements act on the
  surface but do **not** descend to PGL₂(11) (the N=60 fact). So the chirality bit is precisely *the
  obstruction to lifting the surface's S₅ down to the conic* — a clean previously-unstated meaning,
  and why the phenomenon is icosahedron-only (only A₄/A₅ lack a sign character).
- **R-C [REAL, in-repo]. 5 self-polar triangles = A₅-on-5 / Sylvester pentahedron.** The code has
  both a **hexad** (6 columns) and a **pentad** (5 self-polar triangles) structure. Check: do the 5
  triangles index a code decomposition (cosets / weight classes)?
- **R-D [REAL, side-note]. Dickson invariant → modular invariant theory** (Dickson algebra,
  Steenrod). Flag, don't build.
- **Modular-tower conjecture [SPECULATIVE, highest-reach — extends D2].** If deep-hole conic = mod-11
  Δ (weight/degree 12 = vertex form), the dual-variety conjecture becomes: *the deep-hole variety of
  the degree-(k−1) RNC is a mod-p avatar of the **discriminant of the associated binary form***.
  k=3 → Δ; **k=4 (binary cubic) → the binary-cubic discriminant = the tangent-developable quartic**.
  The tower k=2,3,4… shadows the graded ring of forms, with E₄³−E₆²=1728Δ its k=3 shadow. Reframes
  covering radius as a modular-discriminant phenomenon. Testable seed via the twisted-cubic module.

### Higher-dim "next 11" candidates (C132 tested; no hit)

1. **27 lines / GQ(2,4) / E₆ — no arc-template hit.** The correct finite projective model is
   `Q⁻(5,2) ⊂ PG(5,2)`; its 45 lines make the 27-point set non-cap.
2. **Valentiner A₆ ⊂ PGL₃ over P² — no arc orbit at F₁₉.** The projective orbits have sizes
   `36,45,60,60,180`, all exceeding the odd-plane arc maximum 20.
3. **Hesse configuration over F₇ — empty uncovered locus.** Its 12 secants cover all 57 plane
   points. See the corrected C132 report and durable verifier.

### Unfound faces (face-hunt) — ranked surprising × real

- **F1 [REAL, in-repo — top find]. The object is the CELL OF THE 11-CELL.** The **hemi-icosahedron**
  (icosahedron/antipodal) has exactly 6 vertices, 15 edges, 10 triangular faces, symmetry A₅ in the
  exotic 6-point action — *literally* our structure: 6 arc points = its vertices, 15 duads = edges,
  10 triple-pairs (Petersen/Brianchon) = faces. We have the antipodal map in-repo. **Eleven
  hemi-icosahedra glue into the 11-cell** (Grünbaum–Coxeter abstract 4-polytope), symmetry group
  **PSL₂(11)** = our ambient — so the "11" of the 11-cell is the "11" of F₁₁; the 57-cell (PSL₂(19))
  is the p=19 sibling. A genuine structural identity that reorganizes all the small numbers.
  Check: match (hexad, duads, Petersen) to the hemi-icosahedron face lattice.
- **F2 [REAL, needs-lit]. Our forms compute the j-function.** Klein's **j = H³/(1728 f⁵)** means the
  code's three invariants (f = arc/vertex form, H, T) are a mod-11 incarnation of the j-line
  uniformization — the deep-hole conic (=f) is not just a weight-12 form, it's **the denominator of
  j**. Sharpens N2; the k-tower becomes "shadows of the j-line covariant tower."
- **F3 [REAL substrate, code-link MIRAGE, one open check]. Shared 12-point Mathieu geometry.**
  **S(5,6,12) is standardly built on P¹(F₁₁) = our conic**; PSL₂(11)⊂M₁₂ acts 3-transitively on the
  12 points. Same point set + common subgroup — but NOT a Golay/Mathieu *code* link (ternary Golay
  is [11,6,5]₃, ours [6,3,4]₁₁). Open cheap check: are the two icosahedral hexads (arc-poles / axes)
  among the 132 Mathieu hexads or transverse to them? (Expect transverse.)
- **F4 [REAL, done — sharp negative]. No quantum/self-dual face.** Computed: not Euclidean
  self-dual, and no weighted/monomial diagonal makes it self-dual (nullspace dim 0) — consistent
  with non-GRS/no-quadratic-vanishing. Unlike the hexacode, the F₁₁ analogue is exactly where the
  self-duality/stabilizer-code structure **fails** (odd char, non-GRS). Publish the contrast; kill
  the quantum hope.
- **F5 [speculative]. Bring curve** (genus 4, S₅) — same quintic/S₅ ecosystem as the Clebsch cubic;
  no distinct code handle shown. Note, don't build.
- **F6 [speculative]. Icosian/600-cell/E₈** — via *binary* 2·A₅ on ℂ², not our A₅⊂PGL₂(11); no map
  to the icosian lattice. Only live thread: chirality Z/2 = center of 2·A₅→A₅ (spin cover), but
  unrealized in the code. Stays speculative.

**"11" is one thing seen three ways (the true home):** p+1=12 (icosahedron fills P¹) · the 11-cell
built from 11 hemi-icosahedra · PSL₂(11)⊂M₁₂ as the 12-point stabilizer complement. NOT the biplane
/ M₁₁-on-11.

**Mirages killed with reason (do NOT claim):** Hoffman–Singleton (√5 not in its spectrum 7,2,−3;
Petersen-containment generic); Paley/Peisert/biplane on 11 (wrong 11-point action); **Δ mod 11 as
Galois rep** (ρ_{Δ,11} has big image SL₂(F₁₁) — 11 non-exceptional Serre prime — a *different*
"mod 11 of Δ" than our invariant-theory reduction; do not conflate); Markoff-mod-11 / LPS Ramanujan
(generic PSL₂(11), no icosahedral tie); Clebsch graph SRG(16,5,0,2) (name-share only; our code is
three-weight).

### Family tree (siblings/cousins) — computed; p=11 PROVEN-unique, family runs through k not p

Sibling search across √5-primes × all small A₅ plane-orbits (arc? complete-outside? deep-hole set?):

| p | 6-orbit (axis-poles) | 10-orbit | 15-orbit |
|---|---|---|---|
| **11** | **arc, complete-outside, deep = FULL conic ✓ HEALTHY** | complete-outside, deep = ∅ | not an arc |
| 19 | arc, **not** complete-outside (over-covers) | complete-outside, deep = ∅ | not an arc |
| 29 | arc, not complete-outside | not complete-outside | not an arc |

- **Only (p=11, 6-orbit) is healthy** — every other (p,orbit) either isn't a complete-outside arc or
  has empty deep holes (radius 2). Kills the "√5-family of codes" hope but converts it into a clean
  **uniqueness theorem**. Varying the orbit does NOT rescue higher primes.
- **Characterization of "healthy" (publishable, explains the singularity):** all three of
  **(a)** orbit is an arc; **(b)** pole-arc is complete-outside (deep holes ⊆ conic, needs arc size =
  ρ_𝒞(p)); **(c)** deep holes = the WHOLE conic (vertex orbit fills the line, p+1=12). All three
  coincide only at icosahedron/p=11. Failures diagnostic: octa/cube fail (a)/(b) + non-chiral (S₄
  sign); dodeca/p=19 fails (b); tetra parabolic.
- **Polytope siblings real, code-siblings degenerate.** 57-cell (PSL₂(19), hemi-dodecahedron) is the
  true {3,5,3} abstract-polytope sibling of the 11-cell — but the code/deep-hole structure dies where
  the p=19 arc fails complete-outside. F1 (11-cell) stands as *structure*, not a code family.
- **Cousins by group:** the W(E₆)/27-line and A₆/Valentiner arc-template proposals failed C132;
  PSL₂(7)/Klein quartic and M₁₂-S(5,6,12) remain only shared-substrate analogies.
- **Cousins by modular object [open]:** if f = j-denominator, ours is the **level-1/icosahedral** case;
  natural cousins = other **genus-0 Hauptmodul / McKay–Thompson (Γ₀(N)+) moonshine levels**. Richest
  conjectural family framing; entirely open, no in-repo handle — a question for a modular-forms person.
- **THE relative that turns "singular" into "family" is not a sibling — it is the k-TOWER (dual
  variety).** Prime-siblings are proven dead, so the family must come from varying **k**: if deep
  holes of a non-GRS [n,4] MDS code = tangent-developable quartic, q=11/k=3 is rung 1 of a real tower.
  Highest-value relative, partially testable in-repo now (C123). The paper's path from singular→family
  runs through k, not p.

### ML/stats micro-implications (certified unit-tests, not a lane)

Value = exact *certified* micro-examples for someone else's methods paper; none stands alone, none
needs the multi-q program.
- **real** — deep holes = certified closed-form *hard distribution* (worst-case decoding inputs on a
  named variety); the uniform 20-way tie = certified **Bayes-optimal error floor** (no decoder beats
  it).
- **real** — chirality Z/2 = a **certified non-identifiable latent**: invariant under all 60
  symmetries ⇒ no equivariant learner recovers the handedness bit from the task — minimal
  symmetry-protected-unlearnable example (sharpens "invariant but not blind"). Also a proven
  *insufficient-statistic* pair.
- **real** — non-GRS/no-quadratic-vanishing = certified **kernel-inadequacy witness** (no degree-≤2
  Veronese kernel separates arc from conic).
- **real** — anti-robustness at p=11 = certified example of task structure as a **sharp isolated
  point**, not a robust basin (proof-backed extrapolation-trap for ML-for-math).
- **speculative** — A₅ learnable but chirality not (symmetry-discovery test case); Petersen leader
  graph as a fixed adversarial confusion graph; A₅-augmentation ceiling.
- **mirage** — self-dual/contrastive pairing (refuted); "recover group from orbit samples" (needs
  multi-q).

### Further mining (broad brainstorm, across sub-fields) — real/spec/mirage

**A. Feeds the PARENT program — CLOSED NEGATIVE (C130).** *Both levers = shared-machinery-but-no-new-
content; the spin-off does NOT pay rent to the odd-plane program.* Lever 1 (counting bound) is an
*upper* bound on q forcing a sporadic extremal — wrong quantifier direction for C84's `≥c·q²` lower
bound, and it's dim-1 (Θ(q)) coverage, on the known-insufficient side of the parent's own dim-2 wall;
its only landing (sealing lane) reproduces the classical √(2q) saturating-set bound (arXiv:1505.01426),
nothing new. Lever 2 (D(S)=∅ ⟺ all-elliptic) is a two-line corollary of the parent's Thm 2.1 + §6.3
classifier already covered by Cor 2.2; escape children are generic (nonempty varied D(S)), so it adds
no escape-kernel lemma. Clebsch hexagon = one PGL-orbit at one prime (dim 0 uniform-in-q) → cannot be
a density test point. Only use: a one-line boundary-evaluator sanity corner (6 centres, D(S)=∅,
|live|=12, H_S=full PGL₂(11)). **Do not route C84 through the icosahedral results.**

**B. Standalone small spin-offs (cheap, un-run):**
- [real] **the 10-arc companion** (SVM's other A₅-arc at q=11; radius 2, empty deep holes) — free sibling result.
- [real] **dual [6,3] code** deep-hole geometry vs primal — un-examined, cheap.
- [real] **Mathieu-hexad check (F3)** — are our 2 hexads among the 132 hexads of S(5,6,12) or transverse? genuine design-theory yes/no.
- [real] **Schreier=icosahedron graph** as a standalone algebraic-graph-theory note.
- [minor] publish the exhaustive **|U| histogram {12,16,18,19,20,21,22}** for PG(2,11) 6-arcs as a table.

**C. "Reduce-at-best-prime" four-target spike — CLOSED NEGATIVE (C132).** The tested 27-line,
Valentiner, 57-cell, and Hesse proposals do not realize the template. Adversarial correction: the
27-point geometry is `Q⁻(5,2) ⊂ PG(5,2)`, with 36 external points, but its 45 contained lines make it
non-cap; no `PG(5,4)` model is asserted. Valentiner has no arc orbit or invariant conic, the 57-cell
group cannot act on `PG(2,7)`, and the Hesse secants cover `PG(2,7)`. The durable verifier and
corrected detector prescription are in `notes/2026-07-14-c132-second-instance-spike.md`. This closes
the spike, not all possible genus-zero examples. The 27-lines/R-A link survives only as a
shared-object note.

**D. Expository / aesthetic** [real, low-risk high-appeal]: a "one object seen ten ways" gem
(Monthly/Intelligencer/Notices — largely written in this handoff); an interactive visual artifact
(icosahedron drawn on the conic by σ_x, arc-as-poles, Petersen leaders, chirality flip); a teaching example.

**E. Formalization** [real]: machine-certified gallery piece (rigidity + Schreier=icosa + syzygy, all
`decide`-grade) — ITP short / strict-trust showcase.

**F. Methodological meta** [real]: this investigation (generative→adversarial red-team→exhaustive→
gate→loop-back) as a reusable AI-assisted math-triage case study.

**G. Applied [mostly thin]:** specific A₅-symmetric non-GRS (3,6) secret-sharing w/ certified fairness
[speculative]; rigidity-enables-recovery instance for OBS_1 resilience-vs-reconstructability
[speculative]; LRC/storage [mirage — length 6 too small]; icosahedral-chirality physics
(quasicrystals/capsids) [speculative→mirage, no load-bearing bridge].

**Worth pursuing:** A (parent feed, strategic) · D (gem+artifact, low-risk) · E (formalization).
~~C (four-target functor spike)~~ **CLOSED NEGATIVE (C132)** — no hit among those targets; global
uniqueness is not claimed. Rest = free footnotes or thin.

### Ranked open checks (surprising × real × deliverable)

1. **C126 [in-repo, HIGH]** — Family A at p=5,7,19: build octa/cube/dodeca axis-pole arcs, test
   complete-outside + chirality present/absent. Isolates chirality to A₄/A₅. Highest surprise/effort.
2. **C123 [in-repo partial, HIGH]** — D2 dual-variety k=4 twisted cubic = tangent-developable
   quartic vs `ProjectiveTwistedCubicTransversalSpectrum.lean`. The theory-bearing thread.
3. **C127 [literature] — DONE** (see "Novelty audit round 2" below): arc = Clebsch hexagon (SVM
   1995 + Dye 1991); Klein reduction partially known (hedge with Elkies §3.3, Dickson invariant);
   coding bridge novel; "Adler icosahedron/PSL₂(11)" paper does not exist. Dye 1991 is now read.
   ~~novelty of the Klein-reduction claim itself (Adler "The~~
   icosahedron and PSL₂(11)," Kondō, X(11), Martin–Singerman, Elkies) + settle O'Keefe–Storme on the
   arc. Calibrates whether the reduction is new or only its coding/deep-hole reading.
4. **C128 [in-repo, cheap]** — kernel-check H³+T²=f⁵ mod 11.

## Open frontiers (ranked surprising × plausible)

| ID | Claim | Status |
|----|-------|--------|
| R1 | Aut(code) = A₅ as the **exotic S₆-hexad** action; permutation aut group is **2-transitive** on the 6 coords (generic MDS: trivial) | **C121 CONFIRMED** — order 60, cycle-type census (1+15+20+24) = A₅ exotic action; pair-orbit size 30 |
| R2 | A₅ **symmetry-reduced decoder**: weight enum forced by 2-transitivity; deep-hole leaders reduce to orbit reps | **C121 REVISED** — the 20 wt-3 leaders split into **TWO complementary orbits of size 10** (S and Sᶜ always differ), NOT one. Decoder stores **2 reps not 20** (still a real 10× reduction); "single orbit" was wrong |
| R3 | **Conjecture:** deep holes of a non-GRS `[n,k]` MDS code = F_q-points of the **dual variety** of the RNC. k=3: dual of conic = conic ✓. **k=4: tangent developable = quartic surface** | C123 conjecture; partly testable vs `ProjectiveTwistedCubicTransversalSpectrum.lean` |
| R4 | **Construction principle:** poles of a group orbit → code with prescribed deep-hole variety; family exists where `ρ_𝒞(q) < t₂(2,q)` meets an A₅/A₄ orbit (q=8,9 six-arcs are ordinarily complete → radius 2, empty deep holes) | conjecture |
| R5 | Non-RS 3-of-6 secret sharing: positionally fair (A₅-transitive, uniform 20-tie) but **not pseudorandom** (deep holes enumerable as 12 conic points; roles leak via 2-transitivity) | reasoning |

## Directions to pursue — re-ranked after C121/C122 (novel × plausible × deliverable)

- **D1 (NEW, top deliverable). Chirality invariant from the two-orbit split.** The 20 wt-3 leaders
  split into two A₅-orbits of 10, complementation-reversing (S, Sᶜ never share an orbit), and A₅ has
  **no odd permutation** — so the split is the icosahedron's **chirality**; the absent reflection is
  what would merge them. Deliverable: define the Z/2 sign on leaders, prove it A₅-invariant and
  complementation-reversing — all `decide`-grade, in-repo, safely novel. This is R2 inverted into
  its correct form.
- **D2 (survivor R3, top thesis). Dual-variety conjecture.** deep holes = F_q-points of the dual
  variety of the RNC (k=3 conic ✓; k=4 = tangent-developable quartic). C122-certified novel; test
  uncovered-locus = tangent-developable vs `RepairCodes/ProjectiveTwistedCubicTransversalSpectrum.lean`
  (= open task **C123**).
- **D3 (NEW, blocking/defensive). Settle O'Keefe–Storme catalogue** before writing — determines
  whether we claim "new arc" or "new coding-theoretic reading of a known arc." Our contribution
  survives either way (nobody connects the arc to a deep-hole/covering-radius statement).
- **D4 (survivor R1, downgraded to framing).** Position as the **F₁₁ off-conic analogue of the
  hexacode `[6,3,4]₄`**; precedent + sanity anchor, not a headline. The delta over the hexacode is
  exactly D1+D2.

**Lead thesis (one sentence):** *the deep holes of a projective non-GRS MDS code are the F_q-points
of the dual variety of its underlying rational normal curve, exhibited for the `[6,3,4]₁₁` code
whose columns are the poles of the six icosahedral axes — an A₅-symmetric, chiral off-conic analogue
of the hexacode.* (If O'Keefe–Storme already has the arc: drop "new arc," keep the dual-variety
identification + chirality invariant.)

**What the two-orbit fact unlocks (that a single orbit would not):** a canonical Z/2 chirality
function on every deep-hole coset; a combinatorial witness that the stabilizer is A₅ not S₅; the
S₆-outer-automorphism made functional (S↦Sᶜ swaps the two D₁₀ classes); a decoder that stores 2 reps
(10× reduction) whose representative choice *carries the chirality bit*; and a likely k=4 bridge
("leaders ≅ symmetry orbits on the dual variety") to conjecture alongside D2.

## Cross-field lenses (beyond coding theory) — ranked surprising × real

- **L1 [C125: REAL — genuine reduction mod 11 of Klein's actual polynomials/group, NOT an
  analogy].** Klein's icosahedral group Γ ⊂ PSL(2,ℚ(ζ₅)) reduces mod a prime 𝔭|11 (11 splits
  completely) injectively to a PGL(2,11)-conjugate of our arc-stabilizer A₅ (explicit conjugator
  z↦1/(z+5)). The vertex form **f = z₁z₂(z₁¹⁰+11z₁⁵z₂⁵−z₂¹⁰)** reduces to the 12 F₁₁ conic points;
  the six diagonals (roots of **Klein's sextic resolvent**, *Lectures* I.4 §15) reduce to the six
  `witnessMissingEdge` chords; the six arc points are their poles. Syzygy H³+T²=1728f⁵ reduces to
  H³+T²=f⁵ (1728≡1 mod 11).
  - **11 is uniquely optimal:** 11∤60 (faithful, forms squarefree — bad primes are 2,3,5); 11≡1
    mod 5 (group + all 12 vertices F₁₁-rational); and **p=11 is the only prime with p+1=12**, so
    Klein's coefficient 11 dies mod 11 and the icosahedron's 12 vertices exhaust P¹(F₁₁).
  - **Caveats to bake into wording:** (A) claim "reduction of Klein's six *diagonals*" (the objects
    the resolvent's roots enumerate), not "F₁₁-roots of the resolvent polynomial" (its coeffs depend
    on the icosahedral parameter); (B) f mod 11 gains full PGL(2,11)-invariance, so always pair the
    vertex-form clause with the group/diagonal clause — f alone no longer remembers A₅. All finite
    clauses `decide`-grade Lean-able. Sources: Klein (archive.org); Nash arXiv:1308.0955; Kostant
    Notices 1995.
- **L2 [C124: Petersen CONFIRMED, chirality Z/2 CONFIRMED, five-tetrahedra REFUTED].** The 10
  complementary triple-pairs carry the **Petersen graph** — A₅-on-10, stab S₃, adjacency = "share
  exactly 2 of 3 columns" (10v/15e/3-reg/girth-5). The 10+10 leader split is a genuine chirality
  Z/2: all 60 arc-stabilizer perms are even (orbitA-preserving), all 60 orbit-swappers are **odd**
  (form S₅ via the exotic S₆ outer-auto embedding) — no code automorphism merges them ("the
  rotation group has no reflection"). **But** the A₅-on-10 action is **primitive** (no invariant
  5+5 block system) → the "each orbit = 5 chiral tetrahedra pairs" reading is **computationally
  refuted**; only the 10=2×5 / Petersen / chirality level holds, not an exact five-tetrahedra
  bijection. Claim Petersen + chirality, drop the tetrahedra pairing.
- **L3 [REAL group, SPECULATIVE vehicle]. Buckyball / PSL₂(11) / Arnold trinity.** Our A₅ ⊂
  PGL₂(11) is the same subgroup at the center of Martin–Singerman "Biplanes → Klein Quartic →
  Buckyball" and Arnold's trinity. One paragraph, not a new-bridge claim.
- **L4 [REAL, in-repo]. S₆ outer automorphism = conic polarity over F₁₁.** The two D₁₀ classes /
  arc↔axes hexad duality / pole-chord polarity ARE the S₆ outer automorphism made geometric; the 6
  arc points + 6 axes are the two synthematic hexads, complementation = the outer automorphism
  acting.
- **L5–L7 [SPECULATIVE].** Chirality Z/2 as a spinor sign via binary icosahedral 2·A₅ → **McKay
  E₈** (L5); theta-characteristic parity / 28 bitangents / 27 lines shared-S₆ Z/2 (L6);
  Valentiner/Wiman A₅⊂PGL₃ ternary-icosahedral sibling (L7). Appealing, no concrete map — do not
  claim.
- **Mirage (re-judged at this aperture):** (11,5,2) biplane / M₁₁ use PSL₂(11) in its **degree-11**
  action; ours is **degree-12** icosahedral A₅ — same group, different action, cousins in the trinity
  ambient only. Never equate. Markov-A₅ / lattices: omit.

**Who cares & what:** invariant theorists / classical alg-geom (exact certified F₁₁ avatar of
Klein's sextic resolvent + five-tetrahedra chirality); finite geometers (S₆ outer auto as PG(2,11)
polarity; A₅-primitive complete-outside arc — the O'Keefe–Storme lineage/risk); moonshine-trinity
crowd (fresh certified inhabitant of the buckyball ambient, candidate E₈-spinor chirality);
combinatorialists / design theorists (Petersen + synthemes from deep-hole leaders); physicists of
icosahedral symmetry (an intrinsic, unmergeable chirality — clean finite model of icosahedral
handedness).

**Sit-up sentence for a non-coding-theorist:** *the deep-hole combinatorics of this little F₁₁ code
is an exact, machine-certified copy of Klein's icosahedral quintic-resolvent, and its two-way
ambiguity split is literally the chirality of the compound of five tetrahedra* (L1/L2/L4 checkable
in-repo now).

## Closed / mirage (do NOT claim)

- **M₁₁ / PSL(2,11)-on-11-points / (11,5,2) biplane** — MIRAGE. Those live on 11 points, PSL(2,11)
  order 660; our object is on the **12 conic points**, A₅ order 60. Lead with the icosahedron, drop
  Mathieu.
- **Sphere-packing / lattices** — no credible bridge; natural home is designs / OA(1331,6,11,3).

## Novelty audit (C122 — `notes/2026-07-13-c122-deep-hole-novelty-audit.md`)

- **DROP "first non-GRS deep-hole determination"** — contradicted by 2025–26 ETGRS/TRS literature
  (Wu–Ding–Chen, IEEE TIT 71(5) 2025; TRS ISIT 2024 arXiv:2403.11436; Ma–Kai–Zhu FFA 2026).
- **The (1,60,1150,120) distribution, `120=(q−1)c₀`, and the uniform 20-way tie are KNOWN
  machinery**, not novelties: Davydov–Marcugini–Pambianco (arXiv:2101.12722, 2021) derive coset
  distributions from the secant spectrum and force `B₃=C(n,3)` for every such code. Keep them as
  worked facts, not headline claims.
- **2-transitive A₅ on 6 coords has a precedent:** the **hexacode `[6,3,4]₄`** (hyperoval in
  PG(2,4)) has PAut=A₅ 2-transitive. So frame R1 as *the F₁₁ / off-conic analogue of the hexacode
  phenomenon*, not as unprecedented. Our exact q=11 code has no prior appearance found.
- **Genuinely NEW (safe to headline):** *the code's complete deep-hole set = the F_q-points of a
  named variety (a conic)*, with a **group-theoretic cause** (poles of the six icosahedral axes) —
  first such identification; plus the **dual-variety conjecture** (R3) as its generalization (no
  prior art states deep holes = F_q-points of the dual variety / tangent developable).
## Novelty audit round 2 (C127 — `notes/2026-07-13-c127-klein-reduction-novelty.md`)

- **The arc is KNOWN — it is the CLEBSCH HEXAGON. Settled decisively.** Storme–Van Maldeghem,
  *"Primitive arcs in PG(2,q)"* (JCTA 1995, open PDF at Ghent): Prop. 11 gives our 6-arc with
  explicit coords for all q≡±1 mod 10, Prop. 12 proves projective uniqueness, computer check shows
  incomplete at q=11. Studied as the Clebsch hexagon in **Dye, "Hexagons, conics, A₅ and PSL₂(K)"
  (JLMS 1991)** — already has the A₅-invariant conic (5 self-polar triangles) + the 10 Brianchon
  points (= the geometry under our 100-coset / triple-pair split). Char-0 six-axes-off-every-conic
  = the classical Clebsch diagonal cubic (Hitchin 2007). **Do NOT claim a new arc — name it the
  Clebsch hexagon and cite SVM 1995 + Dye 1991.** (O'Keefe–Storme no longer blocking; SVM+Dye
  answer it. The primary text is now archived and read.)
- **Klein form-level reduction — PARTIALLY KNOWN, two mandatory hedges.** A₅⊂PSL(2,11) is classical
  (Galois 1832, Klein, Dickson, Kostant, Martin–Singerman). The *form-level* facts (vertex form
  collapsing mod 11 to the all-points Dickson form; diagonals→chords; H³+T²=f⁵ via 1728≡1; the
  p+1=12 uniqueness) were **not found anywhere** — BUT cite **Elkies, *Klein Quartic in Number
  Theory* §3.3** as the model (same genre for PSL(2,7) at p=2,3,7), and note **f mod 11 = the
  classical Dickson–Euler invariant** (Dickson 1911).
- **FIX BAD REFERENCE:** the paper *"Adler, The icosahedron and PSL₂(11)"* **does not exist** —
  Adler's PSL(2,11) work is X(11)/cubic-threefold/M₁₁. Remove it wherever cited (see L1).
- **Coding/deep-hole bridge — NOVEL** (C122 stands after fresh 2025–26 sweep): nothing links any A₅
  object to covering radius / deep holes.
- **mod-p Platonic family — skeleton PARTIALLY KNOWN, assembly NOVEL:** Platonic-solids-over-F_p =
  Grothendieck *Esquisse* §4 (+ Caleb Ji arXiv:2304.03345); Dickson gives the √5-prime criterion;
  Klein did the p=5 member. The "vertex count=p+1 fills line ⇒ axis-pole arc, deep holes=conic"
  assembly appears nowhere (and per C126 it degenerates except at p=11 anyway).
- **Dye 1991 is read:** p.281 states the non-secant edge criterion, hence `C subset U` at q=11,
  but not exact equality. See the primary-source audit before changing the wording.

**Safest new headline (C127):** *the complete deep-hole set of the `[6,3,4]₁₁` code on the **Clebsch
hexagon** is the full point set of the A₅-invariant conic — first identification of an MDS code's
deep holes with the rational points of a named variety — arising as the mod-11 shadow of Klein's
icosahedron at the unique prime with p+1=12* (+ dual-variety conjecture as the forward half).

## Novelty audit round 3 (item 5 — rigidity-theorem priority check)

Splits the rigidity theorem into two priority layers; verdict below is what the paper may claim.
**Sharpening that drives it:** U (deep-hole locus) = points off the arc and off all 15 secants =
the points *extending* the arc to a 7-arc = the exact intermediate data of an extension-based arc
classification. So the |U| numbers are exposed to prior art; the conic-containment *reading* is not.

- **Arc census (all 6-arcs in PG(2,11) up to PGL) — NOT first; CITE Sadeh.** Sadeh's Sussex thesis is
  titled *"The classification of k-arcs and cubic surfaces with twenty-seven lines over the field of
  eleven elements"* — 6-arcs are k-arcs, so the title alone forbids "first classification." Attribute
  the enumeration to Hirschfeld–Sadeh 1984 + Sadeh thesis + PGOFF §14; do not claim it.
- **|U| histogram {12,16,18,19,20,21,22} — GRANT priority outright (no "first" on the numbers).** |U|
  = the number of points extending the arc to a 7-arc = a projective invariant and the standard
  byproduct of extension-based arc classification, so the extension-count spectrum belongs to
  Hirschfeld–Sadeh 1984 whether or not printed. Do NOT hedge conditionally — concede it cleanly, cite
  the classification, present the spectrum as "which we recompute." (The frame-normalized
  multiplicities {12:6,16:30,…} are our enumeration artifact; the invariant is the value-set + per-
  class assignment.) This **de-blocks the Sadeh ILL** → confirmatory, not gating.
- **min |U|=12 ⇔ Clebsch — HEDGE.** Clebsch identity is SVM 1995 + Dye 1991 (cite); min extension
  count could be in Sadeh. State as a reading, not a first.
- **U ⊆ a conic ⇒ Clebsch/A₅ (the TFAE rigidity, 12→16 gap, and the perturbation/deficiency theorem)
  — SAFE, claim first.** The conic-containment/covering-radius overlay is alien to extension-based arc
  classification (which only asks how many extensions / whether complete) and absent from the
  accessible deep-hole/MDS-covering literature (DMP 2021, ZWK 2019, Al-Ogaidi 2020). Outside Sadeh
  1984's scope by construction. **This carries the paper's only "first."**
- **Worst-case survivors (Sadeh classified everything AND listed all |U|):** the rigidity/TFAE
  theorem, the gap/deficiency theorem, and the deep-holes = named-variety coding identification all
  remain first. Only the raw enumeration and raw |U| numbers are conceded.
- **Blocking docs before "first" on the numbers:** (1) **Sadeh thesis**, Sussex ~1984 (EThOS/ILL) —
  the real gate; (2) **Hirschfeld–Sadeh**, Mitt. Math. Sem. Giessen 164 (1984) 245–257 (ILL); (3)
  **PGOFF** 2nd ed. §14 (library/Google Books). Dye 1991 is footnote-only (C129 NO), bears on the
  conic side, non-blocking.
- **Safe headline wording:** lead with the deep-hole/covering reading and the conic-rigidity theorem
  as the "first"; cite Hirschfeld–Sadeh + Sadeh thesis for the underlying arc enumeration; scope any
  "not appeared before" to the reading, not the numbers. With this wording nothing blocks drafting.
  The **census sentence** is now written into the manuscript itself —
  [`clebsch_hexagon_code.tex`](../../papers/clebsch-hexagon-code/clebsch_hexagon_code.tex) §4,
  the *Census framing* paragraph.

## Paper framing

Lead with: *complete deep-hole set of an MDS code identified with the rational points of a named
variety (a conic), caused by a 2-transitive A₅ acting as poles of the icosahedral axes* — plus the
dual-variety conjecture. (NOT "first non-GRS deep-hole determination.") One-liners by audience:
- coding theorist — *an MDS code with a 2-transitive aut group whose covering radius is realized on
  a conic*;
- finite-geometer — *the six poles of the icosahedral axes form a complete-outside-the-conic arc,
  stabilizer the exotic-hexad A₅*;
- group theorist — *the S₆ outer automorphism realized as conic polarity over F₁₁*.

Guardrail: respect the papers-planning salami-slicing check before splitting from the arcs
manuscript.
