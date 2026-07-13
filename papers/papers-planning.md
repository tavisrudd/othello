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

## Decomposition (resolved — Fable review 2026-07-12)

**Target: five papers (+ one conditional) + two OEIS entries** — not one per directory.

1. **Games flagship** (`nofil-finite-geometry-outcomes`) — folds sum-free ℤₙ + affine AG(n,q) +
   projective mirror outcomes + the boundary/sharpness negatives into one classification.
2. **Dihedral Schreier catalogue** (`dihedral-schreier-node-kayles`) — **extended with the
   generalized-D₂ₘ family** before shipping; retitle toward "finite subgroups of PGL₂(q)."
3. **Arcs complete outside a conic** (`arcs_complete_outside_conic`) — standalone.
4. **Equivariant extension + robust completion** (`equivariant-robust-completion`; canonical merge
   of `baer-equivariant-extension` and `completion-core-rigidity`).
5. **Continuation-graph rigidity, N1 only** (`continuation-graph-rigidity`) — N2 demoted to remarks.
6. **(Conditional) Coding / LRC** — manuscript and internal adversarial audit complete; promote
   after the external specialist citation-chain review.

Plus the two `oeis-submissions/` entries (independent of the papers).

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
- **D6 — count.** Five papers (+1 conditional) + two OEIS, as above. Dihedral bundles D₂ₘ rather than
  spawning a sequel (anti-salami; the mandatory Φ_T/½-density formalization window is free calendar time
  for the classification). Escape hatch: if D₂ₘ stalls beyond that window, ship the committed catalogue
  with §14 as the stated program.

## Submission sequence (under the formalization gate)

Ordered by formalization-to-full-trust distance:

| # | Deliverable                       | Gate distance                                                                                         |
|---|-----------------------------------|-------------------------------------------------------------------------------------------------------|
| 0 | Public mirror + first extraction  | No Lean needed; unblocks everything below                                                             |
| 1 | OEIS A344227 (priority stamp now) | Computational (`getK` pattern) — no Lean gate                                                          |
| 2 | Games flagship                    | Core P-theorems done; owes sum-free law, boundary negatives, capacity-2 sharpness, Scharlau/Witt lemma |
| 3 | Dihedral (+ D₂ₘ)                  | Owes Φ_T, ½-density, the one `native_decide` clear, + the D₂ₘ additions                                |
| 4 | Arcs                              | Owes a new library — **in progress 2026-07-12 night**; explicit-constant restatement                  |
| 5 | Coding / LRC (conditional)        | Lean and manuscript complete; externally gated on specialist priority review, not formalization       |
| 6 | Baer ⊕ completion                 | Exact collision accounting Lean-built; all order-five profiles unproved pending Lean geometry/certificates; citations and priority gates remain |
| 7 | Continuation N1                   | No manuscript; hardest formalization; collaborator route if it stalls                                 |

**Highest-leverage first move:** stand up the public-artifact spine — extract the first public repo
(tagged `FiniteGeom` base + the Lean-complete mirror outcomes), mint the Zenodo DOI, submit the
A344227 priority-stamp subset. Cheap; unblocks four deliverables at once (both OEIS links, arXiv
postings, the n=18 comment); starts the priority clock on the refutation; and forces the extraction
machinery to exist before any paper depends on it.

## Writing guardrails (from the Fable review)

**Lead with the nontrivial, not the mechanism.** The general moves (mirror/pairing, orbit-xor,
completions-as-hypergraph, Node-Kayles = neighbourhood deletion, saturating-set = covering-code) are
each *elementary*. Each abstract opens with the nontrivial lead:

| Paper        | The lead                                                                                  | Watch |
|--------------|--------------------------------------------------------------------------------------------|-------|
| Flagship     | The complete outcome classification **with the exact method boundary**                      | `main.tex` is organized around the method and still calls projective open — reorganize to open with the classification + dichotomy |
| Dihedral     | Exact nimbers for an explicit infinite family (the ((q+1−2s)/4)·K₄ law + D₂ₘ/polyhedral)     | elementary without D₂ₘ; the explicit families are the content |
| Arcs         | The exact prescribed-hole defect identity + additive-3/2 refinement + verified values       | fine |
| Baer⊕compl.  | Exact quadratic-Frobenius orbit-valued criterion and semantic legal-extension theorem       | completion/hypergraph machinery and classical radii are supporting synthesis; seek one family-specific strengthening |
| Continuation | The rigidity theorem: Aut(frame graph) = ambient semilinear group for q ≥ 13                | fine if N2 truly demoted |
| Coding       | The `[19,4,8]₉` all-symbol repair seed + exact unbounded `GF(9)` row transfer                  | lead with the certified family, not the transfer mechanism alone |
| A344227      | **G(17)=2 refutes the published eventual-alternation conjecture** (a refutation)             | frame exactly this way |

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
- **Order:** driven by formalization readiness (see Submission sequence), not "most finished
  manuscript" — the first extraction is the `FiniteGeom` base + the Lean-complete mirror outcomes.

## Novelty gates & loose ends

**Batch the audits.** Storme–Szőnyi, the embedding genre (Batten/Drake–Sané/Beutelspacher–Metsch), and
LRC/availability/concatenation live in overlapping communities — one specialist engagement (or one
deep-research pass reviewed by one specialist) clears three gates. Don't run them serially per paper.

| Paper                            | Gate / loose end                                                                          |
|----------------------------------|-------------------------------------------------------------------------------------------|
| `nofil-finite-geometry-outcomes` | Q⁻ elliptic method-negative needs a Scharlau/Witt-transfer lemma; verify Clark–Mancini–Van Hook full text before any "first" language; HHS STS(7)/STS(9) are prior art |
| `baer` ⊕ `completion`            | Broad adversarial audit complete. Exact collision accounting is checked; every order-five consequence remains unproved until Lean checks the geometry and finite certificate. Specialist priority search follows proof. |
| `continuation-graph-rigidity`    | N1 cleared; N2 blocked on the paywalled Metsch / Drake–Sané read (keep N2 out of the abstract) |
| Coding / LRC                     | Internal audit narrows novelty to exact all-symbol `(ν,τ)` separation and complete-hypergraph transfer; external specialist citation-chain review remains |

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

- **Coding / LRC → Paper 6 assembled and internally audited.** `coding-repair-hypergraphs/` contains
  the manuscript, PDF, proof ledger, and adversarial novelty report. `RepairCodes` proves the trace
  bridge, concrete degree-four lift, and unbounded q9 family of exact rate `2/19` with every fixed
  eventual distance bound `c<39/190`, plus a bundled exact coordinate distribution, mixed
  locality, rows, and thresholds. The sole deep boundary is Stichtenoth
  Theorem 1.6(ii), quarantined and visible in the headline axiom report. The remaining submission
  gate is an external specialist citation-chain review, not formalization or manuscript assembly.
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
