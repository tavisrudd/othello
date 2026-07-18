# C264: dihedral paper multi-session execution plan

**Lane:** `dihedral`

**Status:** READY umbrella; execute C306--C311 in order

**Architecture ruling:** Fable, 2026-07-17, **Adopt with changes**

**Working title:** *Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates*

## Objective

Rebuild the markdown submission as a publication-grade LaTeX paper around one universal
fixed-point-deleted Schreier reduction and three applications: two-point dihedral configurations,
three-point dihedral configurations, and the finite polyhedral boundary. Produce a reproducible PDF,
an explicit evidence/trust boundary, and a manuscript that has passed adversarial mathematical and
repeated cold-prose review.

C264 is the umbrella, not a single editing session. Its executable chain is C306--C311. Only one
phase edits the main manuscript at a time, every phase ends in a coherent commit, and C264 closes
only after C311 passes.

## Authoritative inputs

- Source manuscript: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.
- Architecture and Fable ruling: `notes/2026-07-17-dihedral-paper-spine-proposal.md`.
- Lane state and cautions: `notes/handoffs/2026-07-17-dihedral-paper.md`.
- Correctness and validation: C281 dihedral census, including the value-affecting second-class
  `t=0` correction; C288 polyhedral embedding census.
- Polyhedral structure: C284 template classification and table; C289 elementary explanation of the
  `A5 (3,5,5; rho=3/5)` split and mirror lemmas.
- Arithmetic: C290 proved congruence laws and corollaries P1--P4; C278 conditional density theorem
  with exactly one quarantined equidistribution axiom.
- Scholarly and computational boundary: C261 wording recommendations R1--R5; C260 and C284
  independent replay evidence; C262 Lean boundary; C263 pair-family extension; C283 wild-pair
  boundary.

Later reports supersede earlier empirical wording when they overlap: in particular C290's proved
split laws supersede C288's empirical formulations.

## Fixed paper spine

1. **Introduction and main theorem.** State the unified classified-family theorem and name the
   conic-only, tame, and no-growing-full/subfield-group boundaries in the same breath.
2. **From conic saturation to Node Kayles.** Preserve the coordinate model, pair-product
   fixed-point lemma, and exact residual reduction.
3. **Orbit templates and mod-two cancellation.** State the abstract template theorem; keep the
   Burnside result as a Lean-anchored corollary plus remark.
4. **Two selected points: every dihedral order.** Put the full `D_{2m}` pair family first; include
   cycles, paths, reflection parity, Dawson's chess, and the period-34 corollary.
5. **Three selected points: the dihedral ladder family.** Preserve the double-cover-of-a-tree lemma
   and all ladder-recognition proofs intact. Compress arithmetic only.
6. **Polyhedral triples: the finite boundary.** Lead with completeness and the load-bearing
   `A5 (3,5,5; rho=3/5)` refinement. Keep the ten-row table in the body, with edge lists and replay
   counts in an evidence appendix. Claim no unproved geometric interpretation.
7. **Arithmetic synthesis.** Consolidate the closed laws and P/N congruences, but retain the
   density-half result as a named headline theorem with the C278 single-axiom sentence. Keep the
   `D12` example and add a contrasting `A5` example.
8. **Realization, boundaries, and outlook.** Collect converses. Include C283's wild
   `D_{2p} -> P_p` result as the sharp boundary marker; distinguish C292 wild polyhedral work and
   C84's growing full/subfield escape residual.

Appendices hold the censuses, evidence and replay map, trust/adequacy statement, and material that
would otherwise make the body follow discovery order.

## Execution chain

| Task | Session scope | Owned deliverable | Exit gate |
|---|---|---|---|
| **C306** | Structural rebuild | Create `papers/dihedral-schreier-node-kayles/main.tex`, bibliography, and updated README; migrate the source into the fixed eight-section order without deleting structural proofs. | LaTeX builds; every old theorem/proof has a destination; no known claim silently dropped. |
| **C307** | Correctness-first integration | Apply C281's `t`-case split before polishing; integrate C284, C289, C290, C278, C283, the Dawson corollary, and the C288/C281 validation appendices. | Claim ledger traces every imported statement to its report; formulas and hypotheses agree with the final reports; examples reproduce. |
| **C308** | Scholarly apparatus and trust boundary | Apply C261 R1--R5; finish citations, novelty calibration, provenance, computation/evidence map, Lean adequacy statement, and title/abstract boundary language. | No unqualified novelty or coverage claim; all computational and formal claims expose their verification boundary. |
| **C309** | Artifact and reproducibility gate | Stabilize typography, references, tables, appendix links, regeneration commands, and PDF build; run the scoped existing Lean/build checks required by the claims. | Clean build from documented commands; no broken references; evidence manifests verify; scoped checks pass. |
| **C310** | Adversarial mathematical review | Read as a hostile referee, produce a dated issue report, and repair every blocking correctness, scope, dependency, and reproducibility issue. | Zero open blocking or major mathematical findings; dispositions recorded for every review item. |
| **C311** | Cold-prose and release pass | Perform two separated cover-to-cover prose passes, final title/abstract calibration, journal-neutral preflight, and release artifact update. | Both passes recorded; notation and navigation are consistent; final PDF and source agree; C264 closure checklist is complete. |

### Phase discipline

- Start a phase only when its predecessor is committed and the handoff names that commit.
- At session start, read this plan, the lane handoff, and the predecessor's closing report/diff.
- Before editing, inventory dirty state for the owned paths and leave all foreign state untouched.
- The main `.tex` has one owner at a time. Parallel work, if explicitly authorized, is limited to
  read-only review or disjoint evidence files and returns findings to the phase owner.
- Each phase updates this plan's execution log and the lane handoff in the same commit as its
  deliverable. Do not leave required corrections only in chat or an untracked review note.
- If a phase finds a mathematical defect, fix it within that phase when scoped. If it needs new
  mathematics, stop the chain, allocate a named gate, and record the dependency rather than
  weakening prose silently.

## Content migration and non-loss checklist

| Existing material | Destination | Required treatment |
|---|---|---|
| Abstract and current introduction | §§1, 8 | Rewrite around the unified theorem and explicit exclusions. |
| Current §2 | §2 | Preserve with light compression. |
| Current §3 and §11 | §3 | Fold Burnside into corollary + remark; retain its Lean anchor. |
| Current §4.3 and §14 | §4 | Move before triples; add Dawson period-34 corollary. |
| Current §§4.1--4.2 and §§5--8 | §5 | Preserve structural proofs; move repeated arithmetic only. |
| Current §§9--10, §12, arithmetic from §14 | §7 | Apply C281 correction, then synthesize with C290; keep density prominent. |
| Current §13 and pair converses | §8 | Consolidate realization statements. |
| C284/C289 polyhedral work | §6 | Promote classification and ten-row table into the body. |
| C281/C288 censuses and C260/C284 replays | Appendices/evidence map | Use as validation, not narrative spine. |
| Current §15 | §8 | Rewrite after theorem boundary and title are fixed. |

## Correctness hazards that block release

1. The second `D_{4n}` conjugacy class for even `h` changes values. The §9 equations and Corollary
   9.1 must use C281's `t`-case split; this is not merely an appendix note.
2. Keep the notational distinction between the pair family `D_{2m}` and the triple family
   `D_{4n}` explicit at every theorem boundary.
3. Use C290, not the exploratory C288 phrasing, for the final `S4` split indicators and every
   polyhedral congruence law.
4. Restrict the `rho` interpretation to what C289 proves. The exact invariant refinement is enough;
   no speculative chirality/geometric claim enters the theorem.
5. The density theorem remains conditional on exactly the single named equidistribution axiom in
   the formal layer; the paper must not imply an axiom-free Lean proof.
6. The theorem covers classified tame conic-only dihedral/polyhedral families, not wild
   polyhedral characteristic, off-conic continuation, or growing full/subfield `PSL2/PGL2` groups.
7. C283's wild pair result is a proved boundary marker, not evidence that all wild cases are covered.
8. Computed table values and human/group-theoretic proofs must be visibly distinguished. C291 is a
   post-C264 upgrade and does not block this release.

## C264 closure invariant

C264 may move to the archive only when C306--C311 are all closed, the final source and PDF build
from documented commands, every blocking C310 issue is disposed, both C311 cold reads are recorded,
the paper registry/README and lane handoff describe the shipped artifact accurately, and C291 is
left as the first post-paper mathematical upgrade. C292 and C293 remain post-release; C84 remains
foreign `cap`-lane work.

## Execution log

- 2026-07-18: Fable's adopted spine converted into the C306--C311 gated execution chain. All
  pre-submission content gates C281/C284/C288/C289/C290 were already closed. C306 is next.
- 2026-07-18: **C306 closed.** The markdown submission is migrated into
  `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex` on the eight-section
  spine (runbook filename `main.tex` superseded by the `papers/` naming convention; recorded in the
  phase report). `make dihedral` builds clean with zero matches against the shared `warnings`
  pattern, and the paper is registered in `papers/Makefile`. Every source theorem, proof, equation,
  table, and remark has a named destination in the phase report's non-loss ledger; nothing was
  dropped. Owed integrations are marked in-source by `\phasenote` boxes naming their owning phase.
  Two items carry forward explicitly: the §7.1 formulas and P-congruences are migrated verbatim and
  remain known-incomplete pending C281's `t`-case split (correctness hazard 1, C307), and three
  bibliography entries are uncited in the body (C308). C309 must set `\draftnotesfalse`.
  Commit `ef86aacf`. → `notes/2026-07-18-c306-dihedral-structural-rebuild.md`. **C307 is next.**
