# Papers planning — cross-paper strategy

The resolved plan for turning the `papers/` candidate directories into submissions. The Fable
packaging review (2026-07-12) settled the decomposition, sequencing, and positioning recorded below.
`papers-index.md` is the registry; this doc is the strategy map and guardrails.

## Tracks

- **Games track** (impartial cap/Nofil/Node-Kayles): `dihedral-schreier-node-kayles`,
  `nofil-finite-geometry-outcomes`. Split by *technique* — Schreier-residual nimbers vs
  pairing/mirror ⇒ P.
- **Geometry/coding track** ("Package 2": arc extension & reconstruction):
  `equivariant-robust-completion` (canonical merge of `baer-equivariant-extension` and
  `completion-core-rigidity`), `continuation-graph-rigidity`, plus
  `arcs_complete_outside_conic` (related but separate; classical index equations, not the game
  machinery).
- **Sequence submissions** (`oeis-submissions/`): the queens A344227 extension and the new sum-free
  ℤₙ entry — a different deliverable kind.

A directory ≠ a paper. See the resolved decomposition next.

## Papers — decomposition and ship order (resolved)

**Target: six papers (+ one conditional) + two OEIS entries** — not one per directory. The 2026-07-12
Fable review resolved six (+1); **Clebsch was added 2026-07-13**, after that review, as a spin-out of
the Arcs q=11 material.

**One numbering scheme, repo-wide: papers are numbered 1–7 in ship order, ascending.** The list below
is the authoritative one — `papers-index.md` carries the same numbers on its directory rows and
points here; no other doc keeps a second ordered copy. Ship order is set by
formalization-to-full-trust distance, adjusted for the dependencies below.

**1 · Games flagship** — `nofil-finite-geometry-outcomes`
- *What:* folds sum-free ℤₙ + affine AG(n,q) + projective mirror outcomes + the
  boundary/sharpness negatives into one classification.
- *Gate:* core P-theorems done; owes the sum-free law, boundary negatives, capacity-2
  sharpness, the Scharlau/Witt lemma.

**2 · Dihedral Schreier catalogue** — `dihedral-schreier-node-kayles`
- *What:* **extended with the generalized-D₂ₘ family** before shipping; retitle toward
  "finite subgroups of PGL₂(q)".
- *Gate:* owes Φ_T, ½-density, the one `native_decide` clear, + the D₂ₘ additions.

**3 · Arcs complete outside a conic** — `arcs_complete_outside_conic`
- *What:* standalone; **owns the q=11 deep-holes=conic identification**.
- *Gate:* owes a new library — **in progress 2026-07-12 night**; explicit-constant restatement.

**4 · Clebsch hexagon code** — `clebsch-hexagon-code`
- *What:* rigidity TFAE + gap theorem + chirality ℤ/2 + why-11 for the `[6,3,4]₁₁`
  icosahedral code. Added 2026-07-13, post-review.
- *Gate:* **must follow 3 — hard dependency, not a preference.** Owes chirality/gap/TFAE
  Lean (TFAE likely needs `native_decide` — open decision), two checkers, C128.

**5 · Coding / LRC** *(conditional)* — `coding-repair-hypergraphs`
- *What:* promote after the external specialist citation-chain review.
- *Gate:* Lean and manuscript complete; externally gated on specialist priority review,
  not formalization.

**6 · Equivariant extension + robust completion** — `equivariant-robust-completion`
- *What:* canonical merge of `baer-equivariant-extension` and `completion-core-rigidity`.
- *Gate:* exact collision accounting Lean-built; all order-five profiles unproved pending
  Lean geometry/certificates; citations and priority gates remain.

**7 · Continuation-graph rigidity, N1 only** — `continuation-graph-rigidity`
- *What:* N2 demoted to remarks.
- *Gate:* no manuscript; hardest formalization; collaborator route if it stalls.

**Dependencies between papers** (the only two; everything else is independent):

- **3 → 4 is hard.** `arcs` owns the deep-holes=conic identification that `clebsch` takes as its
  starting point. See *Clebsch after Arcs*.
- **1 ↔ 3 is a seam, not an ordering constraint.** Both cite backwards; neither waits on the other.
  See *Arcs vs Nofil*.

### Non-paper deliverables (deliberately outside the paper numbering)

These are a different deliverable kind — an artifact and two database entries. They have no venue, no
formalization gate in the paper sense, and no novelty seam. Numbering them in the same sequence as
papers is what previously made a bare "#4" mean *Arcs* in one doc and *Equivariant/Baer* in another,
so they are named, not numbered.

- **Public mirror + first extraction** — no Lean gate; **do this first**. It unblocks everything
  below and above: both OEIS links, any arXiv posting, the A344227 n=18 comment, and the
  public-artifact citation the *Arcs vs Nofil* ruling depends on.
- **OEIS A344227** (priority stamp now) — computational (`getK` pattern), no Lean gate.
- **OEIS sum-free ℤₙ** — the vehicle for the sum-free law per D1; never a standalone paper.

### The decision rulings

- **D1 — FOLD (not split).** Projective mirror outcomes become the flagship's projective section; no
  standalone projective "Paper 2." The nontrivial object is the *classification with its exact method
  boundary* (mirror ⇒ P across ℤₙ / AG(n,q) / PG(n,2) / elliptic / even-q planes / hyperbolic quadrics,
  **and** where it dies — parabolic/Hermitian, capacity ≥ 3); that object only exists in one paper, and
  a standalone projective paper is "the same elementary mirror trick on more boards." **No standalone
  sum-free paper** — its vehicle is the OEIS entry; if the flagship balloons, cut the capacity-c
  material, never sum-free.
- **D2 — MERGE Baer + completion now (default).** Each half is weak alone by its own audit; merged
  they are one paper — the exact quadratic-Frobenius orbit-valued extension criterion supported by
  a formally verified completion/transversal synthesis. The `δ(C)=τ` mechanism and classical-family
  distances are established infrastructure/applications, not novelty leads. The exact collision
  correction is Lean-proved, but its proposed `PG(2,25)` consequences are not: prose geometry and
  external enumeration are evidence only. A complete kernel-certified order-five theorem, inverse,
  gap, or spectrum theorem would upgrade it further.
- **D3 — N1 only.** N2 (full-complex reconstruction) → a remarks subsection, out of the abstract and
  contributions, until the paywalled Metsch / Drake–Sané read clears.
- **D4 — HOLD.** The conic-localization reduction lands on the open (ON) kernel — a scaffold with no
  result on it. Keep as the flagship's open-frontier section; revisit only when a kernel result exists.
- **D5 — arcs standalone, through the gate.** Fable's catch: arcs is the one finished manuscript with
  **zero Lean** — "extract-first" and "formalize-everything" conflicted. Resolution: **hold the gate**
  (the first paper out sets whether the gate is policy or aspiration). The arcs Lean library is **being
  formalized 2026-07-12 (tonight)**. When formalizing, **restate the asymptotic lower bound as an
  explicit inequality with concrete constants for all q ≥ q₀, not O-notation** — easier to formalize and
  a stronger published claim. Keep the Lunelli–Sce coordination with Baer (arcs owns the additive-3/2
  relative refinement; Baer owns the orbit criterion).
- **D6 — count.** Six papers (+1 conditional) + two OEIS, as above (five (+1) at the 2026-07-12
  review; Clebsch added 2026-07-13). Dihedral bundles D₂ₘ rather than
  spawning a sequel (anti-salami; the mandatory Φ_T/½-density formalization window is free calendar time
  for the classification). Escape hatch: if D₂ₘ stalls beyond that window, ship the committed catalogue
  with §14 as the stated program.

### Clebsch after Arcs — the novelty seam (ruled 2026-07-14)

`clebsch-hexagon-code` (4) postdates the 2026-07-12 decomposition and is **not** among its five (+1). It
spun out of the `arcs` q=11 material, and that parentage created a genuine salami-slicing exposure
that the original ruling did not address: **clebsch's Prop 3.1 *is* arcs' Prop 4.6(i)** — same
statement, same computation, with the Lean certificate living in `arcs` (`comp-q11-mds-deep-holes`).
Clebsch's "first identification of a deep-hole set with a named variety" therefore rested on a fact
`arcs` also publishes. Two papers, one computation, one novelty claim spread across both.

**Ruling — the split stands, the seam moves:**

1. **`arcs` submits first and owns the identification.** It is near submission-ready, holds the
   certificate, and already states the fact.
2. **`clebsch` claims only the reading** — the rigidity TFAE, the gap theorem, the chirality `ℤ/2`,
   why-11. None of that appears in `arcs`; all of it is the actual paper. Cor 3.2's "first" is
   demoted from novelty-carrier to setup, and the abstract/intro now name the companion.
3. **§3 is self-contained** — the computation is 133 points; it is proved in place and cites `arcs`
   as "see also". This also removes the paper's dependency on an unpublished working paper for its
   own foundation, which a referee cannot check.

**Not folded**, deliberately: the spines differ (`arcs` = defect identity + F₁₆ classification;
`clebsch` = rigidity + gap + chirality + why-11). Folding would bury a five-way rigidity theorem
inside a paper about something else and make `arcs` incoherent.

**The order is a decision, not an artifact of which finishes first.** Once `arcs` is out, `clebsch`
cites a published companion instead of a working paper, and move 3 becomes optional rather than
load-bearing. Lane map: `../notes/handoffs/2026-07-13-clebsch-paper.md`.

### Arcs vs Nofil — the same seam, second instance (ruled 2026-07-14)

Six results were pegged to **both** `arcs` and `nofil`, with every proof location inside
`RelativeConicArcs/` — the `arcs` library — while `nofil` ships two slots earlier. That is the
*Clebsch after Arcs* pattern again: one computation, two readings, two papers, no ruling on who owns
it. It was latent only because `nofil`'s projective section is unwritten; it lands the moment that
section is written, which is exactly what `nofil` owes to ship.

**Ruling — split by reading, per result:**

- **`nofil` owns the game reading** — `thm-relative-game-localization`, `comp-q9-terminal`,
  `comp-q11-icosahedral`. P-positions, normal-play value, cap-game localization: its thesis and its
  technique.
- **`arcs` owns the arc/extension reading** — `thm-extension-conflict-hypergraph`,
  `comp-q11-extension-complex`, `comp-q11-chord-decomposition`. Extension complexes, conflict
  hypergraphs, chord decompositions: no game content in any of them.
- **Each cites the other for the gloss**, neither co-claims. `arcs` already presents the game half as
  a §7 *remark*, so the demotion costs it nothing.

**The apparent sequence inversion dissolves; the order does not change.** It was an artifact of the
mis-peg, not a real dependency:

1. **A Lean directory name is not paper ownership.** The game predicates (`isP`, `seed_isP`,
   `win_parametrizedHoles_iff`) sit under `RelativeConicArcs/` because that is where the witness was
   formalized — a file-location fact, not a claim by the `arcs` paper.
2. **Neither game result needs an `arcs` novelty.** `comp-q9-terminal`'s input — the `q=9` witness is
   a complete arc — is **classical** (Storme–Van Maldeghem 1995, Prop. 13), so `nofil` cites SVM.
   `comp-q11-icosahedral`'s input, the graph identification `adj_iff_icosahedron`, is a `decide`-grade
   finite check that `nofil` cites from the **public Lean artifact**, which ships as the first
   deliverable — before every paper.
3. **So dependencies point backwards in ship order in both directions**: `nofil` (1) cites SVM and the
   public artifact; `arcs` (3) cites `nofil` (1), by then published. No paper cites an unpublished
   companion — the fragility that forced move 3 in *Clebsch after Arcs*.

**Residual, not a sequencing problem:** the game theorems are now misfiled — `nofil` owns results
living in a directory named for `arcs`. Worth a Lean-side rename or move; it changes no proof and
gates nothing.

**Highest-leverage first move:** stand up the public-artifact spine — extract the first public repo
(tagged `FiniteGeom` base + the Lean-complete mirror outcomes), mint the Zenodo DOI, submit the
A344227 priority-stamp subset. Cheap; unblocks four deliverables at once (both OEIS links, arXiv
postings, the n=18 comment); starts the priority clock on the refutation; and forces the extraction
machinery to exist before any paper depends on it.

## Writing guardrails (from the Fable review)

**Lead with the nontrivial, not the mechanism.** The general moves (mirror/pairing, orbit-xor,
completions-as-hypergraph, Node-Kayles = neighbourhood deletion, saturating-set = covering-code) are
each *elementary*. Each abstract opens with the nontrivial lead:

**1 · Flagship** — *lead:* the complete outcome classification **with the exact method boundary**.
- *Watch:* `main.tex` is organized around the method and still calls projective open —
  reorganize to open with the classification + dichotomy.

**2 · Dihedral** — *lead:* exact nimbers for an explicit infinite family (the
((q+1−2s)/4)·K₄ law + D₂ₘ/polyhedral).
- *Watch:* elementary without D₂ₘ; the explicit families are the content.

**3 · Arcs** — *lead:* the exact prescribed-hole defect identity + additive-3/2 refinement +
verified values.
- *Watch:* fine.

**4 · Clebsch** — this table predates the paper; its lead and its claim boundary are ruled in
*Clebsch after Arcs* above (lead with the rigidity TFAE; claim only the reading).

**5 · Coding** — *lead:* the `[19,4,8]₉` all-symbol repair seed + exact unbounded `GF(9)` row
transfer.
- *Watch:* lead with the certified family, not the transfer mechanism alone.

**6 · Baer ⊕ completion** — *lead:* exact quadratic-Frobenius orbit-valued criterion and
semantic legal-extension theorem.
- *Watch:* completion/hypergraph machinery and classical radii are supporting synthesis; seek
  one family-specific strengthening.

**7 · Continuation** — *lead:* the rigidity theorem: Aut(frame graph) = ambient semilinear
group for q ≥ 13.
- *Watch:* fine if N2 truly demoted.

**A344227** (OEIS, not a paper) — *lead:* **G(17)=2 refutes the published eventual-alternation
conjecture** (a refutation).
- *Watch:* frame exactly this way.

- **Negatives that bound a published method are theorems; the rest are logbook.** The boundary
  negatives and capacity sharpness belong in the flagship as theorems (they delimit the method). Do not
  convert the wider rejected-conjecture list.
- **Bright line:** an application without ≥1 worked nontrivial instantiation is a remark, never an
  abstract-level contribution. Bites the higher-dim cap/MDS extensions in Baer and the higher-rank
  resilience claims in completion — instantiate one each or demote.

## Authorship, provenance & reception

The research is human-directed (program lead), but the mathematics, code, and proofs are
agent-generated; the lead directs the program and cannot defend the proofs at referee depth. This is a
first-class design constraint, not a footnote.

**Lean is the trust anchor.** For a machine-checked result, proof *validity* is referee-verifiable
without the author understanding the mathematics. The lead can confirm the mechanical half — build
succeeds, `sorry`-free, `#print axioms` clean — unaided. The residual is **statement adequacy**: does
the Lean theorem actually say what the paper claims (not a vacuous or mis-stated version)? That still
needs mathematical judgment, handled below.

**Formalization gate (release policy).** **Every lemma and proof is Lean-formalized to the project's
full trust standard (`lean/TRUST.md`) before that paper is published** — not merely `sorry`-free, but:
- `#print axioms` clean — only `propext, Classical.choice, Quot.sound`; **no `sorryAx`, no
  `native_decide`**;
- the formal *statement adequate* to the published claim — definitions anchored to standard / mathlib
  objects where possible, adequacy argued, not self-asserted;
- a **trust-chain note** per result (what Lean certifies, what is deferred to differential tests, what
  stays trusted);
- nontrivial proofs developed with the named-expert rigor (CLAUDE.md §Lean).

The formalization backlog is the **critical path**; the per-paper Lean libraries in
`../notes/handoffs/2026-07-11-lean-formalization-plan.md` are release-blocking. One standing adequacy
caveat: mathlib `v4.32` dropped `SetTheory/Game/`, so the game-outcome semantics (`win`/`grundy`) are
self-contained and **not yet anchored to a cited `Impartial`/`grundyValue`** — adequacy for the game
papers rests on the standard-recurrence argument + literature values + differential tests until
`CombinatorialGames` bumps to ≥ `v4.32` (`lean/TRUST.md` Phase 4). Status against the gate:
- *Closest:* the `nofil` mirror⇒P outcomes (P-theorems Lean; boundary/sharpness negatives + capacity-2
  sharpness still paper-only) and the completion δ(C)=τ / coding base.
- *Outstanding (blocks release):* arcs (**being formalized tonight**), Baer, continuation, completion
  beyond δ=τ, the `nofil` boundary negatives + capacity-2 sharpness, the dihedral paper-level theorems
  (Φ_T, ½-density) plus its one isolated `native_decide` (`KleinFourBridge.explicit_pairProducts`, no
  dependents — clear to `decide`/manual or delete).
- *Computational (enumerations, not lemmas):* queens/OEIS, S₄/A₅ nimbers, ρ_𝒞 small values follow the
  `getK` pattern — Lean-proved recurrence + a reproducible differential-tested solver + a trust-chain
  note. **Not** `native_decide`; a small witness enters the trust base only via kernel-reducible
  `decide`.

**Adequacy appendix (policy).** Every paper prints (1–2 pp.) the Lean statements of its headline
theorems and the handful of definitions they bottom out in, verbatim — turning statement-adequacy (the
residual the lead cannot self-check) into a *refereeable object* an expert clears in two pages without
touching the development. Keep the game-semantics `win`/`grundy` kernel deliberately tiny so the
appendix stays inspectable (a better answer to the mathlib `CombinatorialGames` gap than waiting).

**Provenance & verification section (policy).** A titled section in every paper — not an
acknowledgments footnote; burying it reads as concealment, the one reception outcome the model cannot
survive: human-directed, agent-generated, Lean-certified, trust-chain note, repo + DOI. AI is not an
author; the lead signs alone and takes responsibility.

**Scoped pre-submission adequacy reviewer.** One mathematician (acknowledged, not authored) checks
*statements only* (not proofs) for the two highest-adequacy-risk papers — the games flagship and
continuation N1 — at submission time. A named, scheduled step, not aspirational.

**Reception split.** Specialist track (arXiv + journal) rides the credibility spine = Lean + adequacy
appendix + provenance section + repo + DOI. The public meta-story (human-directed, machine-checked AI
mathematics + the queens explorable) is the `non-formal-bloggy/` track. Lead with verifiability to
preempt AI-slop skepticism; do not overclaim novelty ahead of the prior-art audits. Suggested venues:

| Deliverable  | Venue class                                                         |
|--------------|--------------------------------------------------------------------|
| Flagship     | arXiv math.CO + INTEGERS (CGT) or Discrete Applied Mathematics      |
| Dihedral     | arXiv math.CO + INTEGERS or Electronic J. Combinatorics             |
| Arcs         | arXiv math.CO + Designs, Codes and Cryptography / Finite Fields & Apps |
| Baer⊕compl.  | FFA / DCC                                                           |
| Continuation | Electronic J. Combinatorics or DCC                                  |
| Coding       | DCC, or IEEE Trans. Inf. Theory if the LRC angle survives audit     |
| OEIS entries | OEIS directly, independent of the papers                           |

## Extraction & DOI plan

This research repo stays private (many leads still open); publish by **extracting** clean,
self-contained repos per paper.

- **Shared `FiniteGeom` = its own tagged public repo, pinned by commit** — not copied per-paper
  subsets. Copied subsets drift, and drift in shared definitions silently invalidates the cross-paper
  adequacy story (one trust-chain note pointing at diverging definitions is worse than none).
- **Per-paper public repo** = manuscript + its Lean library (pinning the `FiniteGeom` tag) + the
  minimal solver/verifier + certificates / b-files / data + a reproducibility README + the adequacy
  appendix source.
- **DOI:** Zenodo ↔ GitHub-release integration mints a versioned DOI (+ concept DOI); arXiv for the
  manuscripts; cross-link. Versioned DOIs are what let "disclose the adequacy caveat now, anchor to
  mathlib later" be a respectable posture. This also clears the **public-artifact blocker** (OEIS `%H`,
  arXiv code links).
- **Order:** driven by formalization readiness (see *Papers — decomposition and ship order*), not "most finished
  manuscript" — the first extraction is the `FiniteGeom` base + the Lean-complete mirror outcomes.

## Novelty gates & loose ends

**Batch the audits.** Storme–Szőnyi, the embedding genre (Batten/Drake–Sané/Beutelspacher–Metsch), and
LRC/availability/concatenation live in overlapping communities — one specialist engagement (or one
deep-research pass reviewed by one specialist) clears three gates. Don't run them serially per paper.

**1 · `nofil-finite-geometry-outcomes`** — Q⁻ elliptic method-negative needs a Scharlau/Witt-transfer
lemma; verify Clark–Mancini–Van Hook full text before any "first" language; HHS STS(7)/STS(9) are
prior art.

**5 · Coding / LRC** — internal audit narrows novelty to exact all-symbol `(ν,τ)` separation and
complete-hypergraph transfer; external specialist citation-chain review remains.

**6 · `baer` ⊕ `completion`** — broad adversarial audit complete. Exact collision accounting is
checked; every order-five consequence remains unproved until Lean checks the geometry and finite
certificate. Specialist priority search follows proof.

**7 · `continuation-graph-rigidity`** — N1 cleared; N2 blocked on the paywalled Metsch / Drake–Sané
read (keep N2 out of the abstract).

## Planning-source docs (in ../notes/, not symlinked into a paper dir)

- `2026-07-09-stepping-stone-deliverables-proposal.md` — earlier games-track master plan.
- `2026-07-10-codex-publishable-spinout-audit.md` — the Package-2 parent + anti-salami voice.
- `2026-07-11-projective-cap-portfolio-key-cards.md` — packaging-neutral "what is proved/computed" deck.
- `handoffs/2026-07-11-lean-formalization-plan.md` — the per-paper Lean library plan.
- `2026-07-11-codex-coding-mds-cross-field-sweep.md` — research ledger feeding Baer/completion and the
  coding/LRC lane (source for `RepairCodes`).

## Submission logistics

- **OEIS is independent of the papers.** A344227 can go now as a priority stamp (DATA + b-file + `%E` +
  method comment + Jenrich `%H`); the sum-free ℤₙ entry is a ready draft. The sum-free outcome law is
  shared source with the flagship.
- **Public-artifact blocker.** The A344227 `%H` / n=18 comment, the sequences' program links, and any
  arXiv posting all want a public URL the repo lacks — the first extraction (above) unblocks them together.
- **Plan-stage candidate (not staged):** a short CGT-tooling methods note / blog post is specced in
  `../notes/handoffs/2026-07-09-cgt-tooling-novelty-writeup.md`; tool novelty is methods-level, not
  theorem-level — revisit when there is appetite.

## New paper ideas / adjacent seams

Post-review dispositions:

- **Determinant-hypergraph program identity (2026-07-13, cross-lane).** The twisted cubic in
  `PG(3,q)` is a *third* shared object (alongside the arc/conic conflict graph and the `δ=τ`
  transversal): coding's D-PC9 `(C∪axis)` weight distribution, completion §6.5's external-point
  transversal spectrum `ρ(x)=τ`, and arcs' `d=2` conic defect are the on-curve / off-curve / `d=2`
  instances of one "circuit/determinant hypergraph of small linear dependencies." State this once per
  intro to convert the salami-slicing risk into a program identity (same discipline as the √(2q)
  coordination). The equivariance backbone `⟨T_a,inv,scaling⟩=PGL(2,q)` is verified; the
  external-point τ-spectrum (a stated §6.5 open problem, likely reducible to max-arc-in-a-cubic via
  projection) is the live prize. Follow-up: `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md`
  (C115–C120); writeup task C119.

- **Coding / LRC → Paper 6 assembled and internally audited.** `coding-repair-hypergraphs/` contains
  the manuscript, PDF, proof ledger, and adversarial novelty report. `RepairCodes` proves the trace
  bridge, concrete degree-four lift, and unbounded q9 family of exact rate `2/19` with every fixed
  eventual distance bound `c<39/190`, plus a bundled exact coordinate distribution, mixed
  locality, rows, and thresholds. The projectively completed second seed is also integrated:
  `[2q+2,4,q]_q`, exact full-minimal
  radius-four rows, a `[20N,4K,>=9D]_9` bounded-port lift, and an unbounded q9 family of exact rate
  `1/10` with every fixed eventual bound `c<351/1600`. The sole deep boundary for both families is
  Stichtenoth Theorem 1.6(ii), quarantined and visible in the headline axiom report. The remaining
  submission gate is an external specialist citation-chain review, not formalization or manuscript
  assembly.
- **Prescribed-hole covering code → post-arcs companion.** The coding translation of the arcs problem;
  audited first, never delaying arcs.
- **Generalized D₂ₘ → folded into the dihedral paper** (not a separate paper). Its **Möbius-ladder /
  dihedral-Cayley nimber sequence** is a byproduct OEIS entry.
- **Cross-domain transfers → parked, as "connections" remarks.** Completion→learning,
  continuation→matroid reconstruction, Baer→rank-metric: reception risk is maximal in distant fields the
  lead cannot direct agents to audit. Downgrade each to a connections remark in its parent paper — stakes
  the idea publicly at zero audit cost.
- **Flagship (if it lands):** the uniform odd-plane / (ON) theorem — research track, delays nothing.
- **Parked — do not mine now:** RSA-on-conic-involution-graphs (vocabulary); the MDS "exact drain"
  analogy (informal); isolated small-q outcomes unless they settle a stated conjecture; Baer blocking
  sets as a sealing explanation (geometry mismatched); the bare orbit-template xor without an infinite
  family.

## Not publishable yet (research track, kept out of `papers/`)

The abundance / odd-complete-arc / odd-plane frontier is the open primary lane, not a result. Entry
point: C84 in `../notes/handoffs/2026-07-06-projective-cap-game-handoff.md`. The conic-localization /
escape-count material sits at this boundary (D4).
