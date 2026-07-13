# Papers planning — cross-paper strategy

The map for how the candidate directories in `papers/` become actual submissions. This is the
input document for the Fable packaging review. `papers-index.md` is the registry; this doc holds
the open decisions and the guardrails.

## Tracks

- **Games track** (impartial cap/Nofil/Node-Kayles manuscripts): `dihedral-schreier-node-kayles`,
  `nofil-finite-geometry-outcomes`. Split by *technique* — Schreier-residual nimbers vs
  pairing/mirror ⇒ P.
- **Geometry/coding track** ("Package 2": arc extension & reconstruction):
  `baer-equivariant-extension`, `completion-core-rigidity`, `continuation-graph-rigidity` —
  distinct headline theorems on distinct objects, shared `FiniteGeom` Lean base, common parent
  audit. `arcs_complete_outside_conic` sits alongside as a **related but separate**, self-contained
  finished manuscript (classical index equations, not the game machinery).
- **Sequence submissions** (`oeis-submissions/`): the queens A344227 extension and the new
  sum-free ℤₙ entry — a different deliverable kind (sequences, not papers).

A directory ≠ a paper. The number of submissions is a decision, not the directory count — see
the anti-salami guardrail (D6).

## Open packaging decisions (the questions for the Fable review)

- **D1 — projective outcomes: fold or split?** `nofil-finite-geometry-outcomes` currently means
  the pairing/mirror flagship (sum-free ℤₙ + affine AG(n,q), already drafted in `main.tex`).
  The projective mirror-outcome theorems (all Lean-proven, `sorry`-clean, unwritten) can either
  finish that flagship as its projective section — which is what the two existing plans
  (`stepping-stone-deliverables-proposal` D1/D2, `publishable-spinout-audit` Package 1) already
  intend — or split out as a standalone companion "Paper 2." The existing plans lean fold; the
  recent Fable conversation leans split. **This is the central call.**
- **D2 — completion-core: standalone or companion?** `completion-core-rigidity` is a swing piece;
  its own Stage C folds it into `baer-equivariant-extension` as a section if its headline
  computation (twisted-cubic transversal spectrum / t_h(q)) does not land. Decide after that
  computation + the Storme–Szőnyi audit.
- **D3 — continuation-graph: carry N2 or not?** N1 (frame-graph semilinear rigidity, q ≥ 13) is
  the standalone headline and survives audit. N2 (full-complex reconstruction) is SOFTEN and
  gated on a paywalled Metsch / Drake–Sané read — publish N1, defer/soften N2.
- **D4 — conic-localization reduction: spin out or hold?** Unresolved conflict between plans.
  `stepping-stone-deliverables-proposal` D3 recommends spinning the conic-localization reduction
  out as a standalone scaffold paper (~65%). Against that: `escape-count-lemma` and
  `conic-localization-onconic-escape` show the reduction lands on the **open** odd-plane kernel
  (the (ON) conjecture, empirical only through q=19), and `publishable-spinout-audit` §5 calls
  the perspectivity/conic formulas "coordinate lemmas, not standalone results." Default: hold as
  kernel infrastructure inside `nofil-finite-geometry-outcomes`' open-frontier section until
  there is a kernel result; Fable to adjudicate.
- **D5 — `arcs_complete_outside_conic` (RESOLVED: distinct, finished).** A self-contained,
  near-submission-ready manuscript (secant-defect identity, √(2q)+3/2 lower bound, PGL(3,q)
  averaging transfer, even-char nucleus constraints, verified small values) — *related but
  separate* from the game work; it does not merge into Baer. **Cross-paper coordination:** its
  √(2q)+3/2 bound is the same classical Lunelli–Sce √(2q) scale as `baer-equivariant-extension`'s
  Cor 3.4 — frame the two so they don't appear to double-claim the constant (arcs owns the
  additive-3/2 relative-conic refinement; Baer owns the orbit-valued criterion). Distinct again
  from the game-side conic-localization / "intruder calculus" line (open, proved only q=5,7), which
  is a dormant research candidate, not this paper.
- **D6 — anti-salami (meta).** `publishable-spinout-audit` is explicit: *"the best decision is
  not to create many small papers."* Six candidate directories are a staging convenience, not a
  target of six submissions. Reconcile to a defensible count — plausibly: one games-track
  flagship (+ the committed catalogue), one arc-extension paper (Baer, possibly absorbing
  completion-core), and continuation-graph's N1, with the coding/LRC material as its own or a
  companion.

## Framing for the Fable review

Lenses from the 2026-07-12 external triage to fold into the Fable brief — sharpen the questions,
don't just ask "how to package":

- **Lead with the nontrivial, not the mechanism.** The general moves — mirror/pairing strategy,
  orbit-wise xor, alternative-completions-as-hypergraph, Node-Kayles = closed-neighbourhood
  deletion, saturating-set = covering-code — are each individually *elementary*. For every paper,
  ask: what is the nontrivial lead (a classification, a sharp bound, an exact family, or an
  unexpected application), and does the abstract open with it rather than the general packaging?
- **Decomposition is the bottleneck, not discovery.** The open work is splitting into papers +
  prior-art audits + clean theorem–proof narratives. Ask Fable to rule on the paper *count* —
  guarding against both salami-slicing and over-bundling (target: a few strong papers, not many
  thin ones).
- **Submission order.** External priority: ship the finished/cheap wins first, then the
  already-complete units, then the seams, then the Schreier family; keep the odd-plane flagship
  last and do not delay the small papers for it. Ask Fable to confirm/adjust the order.
- **The A344227 hook is a refutation.** G(17)=2 refutes the entry's published "eventually
  alternates 0/1" conjecture — a stronger lead than "new terms." Frame the queens/OEIS deliverable
  that way.
- **Sum-free: standalone or folded?** The triage makes sum-free ℤₙ its *own* paper and
  affine+projective a separate "building-avoidance games on finite geometries" paper — diverging
  from our current single-flagship fold (see D1). Put this split explicitly to Fable.
- **Specialist prior-art audits are the gate.** Coding (vs LRC / availability / concatenation),
  completion & continuation (vs defining sets / matroid reconstruction / line-graph
  reconstruction), relative arcs (vs complete arcs / saturating sets). Ask which claim survives
  each audit as the sharpest defensible novelty.
- **Convert rejected conjectures into impossibility theorems.** The long list of
  computationally-rejected conjectures adds little weight unless recast as negative/impossibility
  theorems (e.g. the escape lower bound, the no-pairing-mechanism results). Ask which are worth
  converting.
- **Statement-level vs instantiated.** Some higher geometric applications are stated but not fully
  instantiated. Ask Fable which must be instantiated before they count as results.
- **Formalization gate (firm policy).** Every lemma/proof is Lean-formalized, `sorry`-free, before
  publication — so the submission queue is driven by *formalization readiness*, not mathematical
  completeness. Ask Fable to sequence by formalization cost: which papers are cheapest to fully
  formalize, and which supporting lemmas (e.g. the boundary negatives, Φ_T, ½-density, the arcs
  proofs) are still un-formalized and therefore release-blocking. (See "Authorship, provenance &
  reception".)
- **Venue split.** Which deliverables are specialist (arXiv/journal, credibility spine = Lean +
  public repo + DOI) vs public (the meta-story of human-directed, machine-checked AI mathematics +
  the queens explorable)? Ask Fable to assign each.
- **Extraction boundaries.** Each paper ships as a self-contained public repo (manuscript + minimal
  Lean subset + solver/certs) with a DOI. Ask Fable to confirm the per-paper repo boundaries and the
  shared-dependency handling. (See "Extraction & DOI plan".)

## Authorship, provenance & reception

The research is human-directed (program lead), but the mathematics, code, and proofs are
agent-generated; the lead directs the program and cannot defend the proofs at referee depth. This
is a first-class design constraint, not a footnote.

**Lean is the trust anchor.** For a machine-checked result, proof *validity* is referee-verifiable
without the author understanding the mathematics. The lead can confirm the mechanical half —
build succeeds, `sorry`-free, `#print axioms` clean — unaided. The residual is **statement
adequacy**: does the Lean theorem actually say what the paper claims (not a vacuous or mis-stated
version)? That still needs mathematical judgment, so the project handles it by anchoring definitions
to standard/mathlib objects where possible and shipping a per-result trust-chain note (`lean/TRUST.md`
is the model). This is what lets human-directed, agent-generated mathematics be published
responsibly, and it reorders the priority to **publish in order of formalization readiness.**

**Formalization gate (release policy).** Decision: **every lemma and proof is Lean-formalized to the
project's full trust standard (`lean/TRUST.md`) before that paper is published** — not merely
`sorry`-free, but:
- `#print axioms` clean — only `propext, Classical.choice, Quot.sound`; **no `sorryAx`, no
  `native_decide`**;
- the formal *statement is adequate* to the published claim — definitions anchored to standard /
  mathlib objects where possible, adequacy argued, not self-asserted;
- a **trust-chain note** per result stating what Lean certifies, what is deferred to differential
  tests, and what stays in the trusted base;
- nontrivial proofs developed with the named-expert rigor (CLAUDE.md §Lean).

No hand-proved-only submissions — formalization is the release gate, and it is what lets the lead
take authorship responsibility for agent-generated mathematics. Consequence: the formalization
backlog is the **critical path**, and the per-paper Lean libraries in
`../notes/handoffs/2026-07-11-lean-formalization-plan.md` are release-blocking prerequisites. The
submission queue is ordered by *formalization readiness*, not mathematical completeness. One standing
adequacy caveat: mathlib `v4.32` dropped `SetTheory/Game/`, so the game-outcome semantics
(`win`/`grundy`) are self-contained and **not yet anchored to a cited `Impartial`/`grundyValue`** —
adequacy for the game papers (`nofil`, dihedral) currently rests on the standard-recurrence argument
+ literature values + differential tests until the `CombinatorialGames` package bumps to ≥ `v4.32`
(see `lean/TRUST.md` Phase 4). Status against the gate:
- *Closest to the gate (core theorems formalized, some support outstanding):* the `nofil` mirror⇒P
  outcomes (the P-theorems are Lean; the boundary/sharpness negatives and capacity-2 sharpness are
  still paper-only) and the completion δ(C)=τ / coding base.
- *Formalization outstanding (blocks release):* the arcs paper (entirely hand-proved, not yet in the
  formalization plan — needs a new library), Baer, continuation, completion beyond δ=τ, the `nofil`
  boundary negatives (parabolic/Hermitian no-fpf-involution) and capacity-2 sharpness, the dihedral
  paper-level theorems (Φ_T homomorphism, ½-density) plus its one isolated `native_decide`
  (`KleinFourBridge.explicit_pairProducts`, no dependents — clear to `decide`/manual or delete).
- *Computational (enumerations, not lemmas):* queens/OEIS, S₄/A₅ nimbers, ρ_𝒞 small values follow
  the `getK` pattern — the underlying recurrence/semantics is Lean-proved (adequately, axiom-clean),
  and the large search rides a reproducible, differential-tested solver, with a trust-chain note
  drawing the boundary. **Not** `native_decide` (below the trust bar); a small witness enters the Lean
  trust base only via kernel-reducible `decide`, otherwise it stays solver-certified data.

A mathematician collaborator/reviewer stays valuable for exposition, prior-art audits, and novelty
framing — but under this policy is no longer needed to vouch for *validity*.

**Disclosure & attribution.** Attribute transparently as human-directed, agent-generated, with Lean
as the verification method; AI is not a listed author (arXiv/journal norms) and the human takes
responsibility. The exposure is the *not-formalized* set — taking responsibility for proofs no human
has checked. Mitigate by formalizing those results or bringing in a mathematician
collaborator / pre-submission reviewer.

**Reception split.** Specialist venues (arXiv + journal) ride the credibility spine = Lean + public
repo + DOI. Public venue (blog / talk) carries the meta-story — human-directed AI producing
machine-checked mathematics, alongside the queens explorable — which plays to the lead's
communication strengths. Lead with verifiability (open repos, machine-checked proofs) to preempt
AI-slop skepticism; do not overclaim novelty ahead of the prior-art audits.

## Extraction & DOI plan

This research repo stays private (many leads still open); publish by **extracting** clean,
self-contained repos per paper — not by opening this one.

- **Per-paper public repo** = manuscript + its self-contained Lean subset (the per-paper libraries
  from `../notes/handoffs/2026-07-11-lean-formalization-plan.md`, over a shared `FiniteGeom`
  dependency) + the minimal solver/verifier + certificates / b-files / data + a reproducibility
  README.
- **DOI:** Zenodo ↔ GitHub-release integration mints a versioned DOI (+ a concept DOI); arXiv for the
  manuscripts; cross-link the two. This also clears the **shared public-artifact blocker** — the OEIS
  `%H` links and arXiv code links point at these repos.
- **Extraction order:** most-finished and self-contained first — `arcs_complete_outside_conic`, the
  queens/OEIS package, and the Lean-complete mirror outcomes.
- **Watch-outs:** the extracted Lean must build independently (shared `FiniteGeom` base + a pinned
  mathlib) — the per-paper-library plan supports this but it is real work; extract the *minimal*
  reproducible solver slice, not the whole Rust workspace.

## Novelty gates & loose ends

| Paper                          | Gate / loose end                                                                          |
|--------------------------------|-------------------------------------------------------------------------------------------|
| `nofil-finite-geometry-outcomes` | Q⁻ elliptic method-negative needs a Scharlau/Witt-transfer lemma (sharpness); verify Clark–Mancini–Van Hook full text before any "first" language; HHS STS(7)/STS(9) are prior art |
| `baer-equivariant-extension`   | √2·s = Lunelli–Sce √(2q) (not new) — headline is the orbit criterion; open gate = √2 sharpness (unbuilt construction) |
| `completion-core-rigidity`     | Abstract infra overlaps defining-set/trade/saturation theory; needs one new headline computation + Storme–Szőnyi audit |
| `continuation-graph-rigidity`  | N2 collides with complement-embedding genre (Batten/Drake–Sané/Beutelspacher–Metsch); paywalled full-text read pending |

## Planning-source docs (in ../notes/, not symlinked into a paper dir)

- `2026-07-09-stepping-stone-deliverables-proposal.md` — master plan for the games track (D1–D6,
  dependency graph, commit order).
- `2026-07-10-codex-publishable-spinout-audit.md` — the later, more conservative consolidation and
  the Package-2 parent; strongest anti-salami voice.
- `2026-07-11-projective-cap-portfolio-key-cards.md` — packaging-neutral "what is proved/computed"
  input deck.
- `handoffs/2026-07-11-lean-formalization-plan.md` — the per-paper Lean library plan.
- `2026-07-11-codex-coding-mds-cross-field-sweep.md` — research ledger feeding Baer/completion-core
  and the latent coding/LRC lane (source for the built `RepairCodes` Lean library).

## Submission logistics

- **OEIS is independent of the papers** (`oeis-submissions/`). The A344227 extension can go now as
  a priority stamp (DATA + b-file + `%E` credit + heap-sum method comment + Jenrich `%H`); the
  sum-free ℤₙ entry is a ready draft. Neither needs a manuscript first. The sum-free outcome law is
  shared source with `nofil-finite-geometry-outcomes`.
- **Non-formal outputs** (`non-formal-bloggy/`) target a project page / blog / technical-report
  venue, not paper review — kept apart so they aren't judged against manuscript standards. Current
  member: the queens n=18 solve write-up + demo.
- **Shared public-artifact blocker.** The A344227 `%H` link and its n=18 comment, the sequences'
  program links, the queens-n18 citation, and any arXiv posting of the manuscripts all want a
  public code/preprint URL the repo does not yet have (no public remote). One public mirror or
  preprint unblocks them together — a cheap, high-leverage prerequisite.
- **Plan-stage candidate (not staged):** a short CGT-tooling methods note / blog post ("a game
  tablebase meets CGT — the S4 query tool in context") is specced in
  `../notes/handoffs/2026-07-09-cgt-tooling-novelty-writeup.md` but has no prose yet — revisit when
  there is appetite; tool novelty is methods-level, not theorem-level.

## New paper ideas / adjacent seams (not yet staged)

Candidates surfaced (external triage, 2026-07-12) without a `papers/` directory yet — extensions,
coding translations, cross-domain transfers. Ideas, not commitments; most need a prior-art audit
before they are real.

**Coding / LRC**

- **LRC constructions + bounded-repair transfer.** The `RepairCodes` results (`thm-gf9-dualdist`,
  `lem-transfer`) are Lean-proven but unhomed — plausibly one or two coding papers. Needs a
  specialist audit against LRC / availability / concatenation literature. *Decide: promote to a
  `coding/` dir?*
- **Prescribed-hole covering code.** The coding translation of `arcs_complete_outside_conic`:
  "shortest linear code whose radius-two syndrome cover misses only a prescribed quadratic
  variety" (a covering code with prescribed holes). May be more publishable than the arc/game
  motivation; "codes with holes" likely has prior art, the prescribed-conic version may not.
  Companion to the arcs paper.

**Schreier extensions (make the catalogue clearly paper-sized)**

- **Generalized dihedral D₂ₘ infinite family.** Treat D₂ₘ uniformly: free orbits →
  generalized Möbius-ladder / dihedral Cayley components; nonfree → finitely many truncated
  templates; structural classification for all m + congruence formulas over F_q. No prior
  Node-Kayles treatment of Möbius ladders / dihedral Cayley graphs / fixed-point-deleted Schreier
  graphs found — an infinite family is what lifts the current V₄/D₈/S₄ material to paper size.
- **Möbius-ladder / dihedral-Cayley Node-Kayles nimber sequence** — a candidate new OEIS sequence
  falling out of the above.
- **Full polyhedral classification + retitle** toward "Node Kayles on fixed-point-deleted Schreier
  graphs of finite subgroups of PGL₂(q)" (complete the D₂ₘ, S₄, A₅ tables). The abstract
  orbit-template theorem is too elementary alone; the explicit classifications are the content.
  Dovetails with the dihedral paper's deferred §14.

**Cross-domain transfers (second papers from existing proofs)**

- **Completion cores → learning / reconstruction.** The alternative-completion hypergraph encodes
  deletion robustness (min edge), defining-set size (transversal τ), completion overlap
  (intersection spectrum) — transfer to teaching dimension, sample compression, database keys,
  reconstruction of maximal feasible objects. Substantiated by the exact conic/hyperoval/quadric/
  spread values.
- **Continuation complexes → matroid & code reconstruction.** Adjacent to representable-matroid
  recovery from circuits, nonlinear-code recovery from punctured coordinate traces, Whitney-type
  reconstruction; a general theorem for partial linear spaces would widen the audience.
- **Equivariant arc extension → rank-metric coding.** The Galois-rank section formula identifies
  the obstruction with rank weight — translate into subfield subcodes / rank-metric covering /
  extension of MDS evaluation sets. A second paper from the same proofs.

**Flagship (if it lands):** the uniform odd-plane / abundance / (ON) theorem — keep as the
difficult flagship, do not delay the smaller papers for it (see below).

**Parked — do not mine now:** RSA-on-conic-involution-graphs (vocabulary change only); the MDS
"exact drain" analogy (insufficiently formal); isolated small-q outcomes unless they settle a
stated conjecture; Baer blocking sets as a sealing explanation (geometry mismatched unless a
specific subfield arc is proved to cover the required points); the bare orbit-template xor theorem
without an infinite family of explicit values.

## Not publishable yet (research track, kept out of `papers/`)

The abundance / odd-complete-arc / odd-plane frontier is the open primary lane, not a result.
Entry point: C84 in `../notes/handoffs/2026-07-06-projective-cap-game-handoff.md`. The
conic-localization / escape-count material sits at this boundary (see D4).
