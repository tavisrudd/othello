# C1135 — AME two-star verification: proof, adversarial review, and literature audit

**Lane:** `ame-lu`
**Status:** RUNNING (2026-09-10).
**User request:** verify, red-team, audit the literature, and propose paper changes with proper literature positioning and motivation.

## Inputs and baseline

- User packet: `/home/tavis/Downloads/AME_LU_REVISION_PACKET_55e70c4.md`; SHA-256 `d7f1611138e80fb0a40cd68c613c15fb404b8cba8155f0131d03fbe58cce82fe`.
- Companion archive: `/home/tavis/Downloads/ame_lu_revision_packet_55e70c4.zip`; SHA-256 `742814be97a8e760f83a020cced59206e41acecacddb46449925dd6196c910a4`.
- Packet targets standalone `55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82`; authoritative manuscript revision `f6f342e24ae21ab2fdb6f1aef6fb4c006ebc1a5d`, under `papers/ame_lu/`.
- C1134 report documents the current 40-page paper and quantitative constants. C1089 already incorporated one-star marginal certification, sharp marginal count/locality, and factorwise stochastic conversion. Do not present those as new.
- Initial conversational review read all eight packet modules and README, confirmed the combined Markdown has the same content after heading/link normalization, and found the principal arguments plausible. That is preliminary assessment, not the independent audit requested here. The supplied scripts have not been rerun by this review.

## Deliverables and acceptance gates

1. **Claim-by-claim mathematical verification.** Re-derive the any-half direct-sum lemma, exact weighted gap, arbitrary-effect setting-count upper bound, locality cap, attainment and setting erasures. Check zero weights, repeated supports, prime-power additivity, phase-aware stabilizer characters, and all boundary hypotheses. Separately verify the non-stabilizer one-star construction and universal full two-star gap without assuming cross-star commutativity. Audit the MDS spectrum, qutrit example, observable thresholds, calibration/statistical wrapper, sample-cost scaling, and optional a posteriori branch certificate. Classify each claim as proved, repairable, unsupported, already present, or standard consequence; supply proofs or explicit counterexamples.
2. **Independent adversarial review.** Use fresh-context gpt-6-astra readers under the repository's cold-review rules, with useful independent work in parallel. Obtain a journal-style referee report and a focused attack on the sharp measurement-model optimum and universal extension. Challenge hidden hypotheses, stronger interpretations, normalization, actual physical implementation costs, and whether the verification addition distracts from the rigidity paper. Resolve objections explicitly; preserve substantive dissent.
3. **Recorded literature audit.** Follow `notes/literature-audit-conventions.md` and shared-cache rules before fetching. Verify primary sources and relevant references/forward citations for marginal determination, frustration-free parent Hamiltonians, quantum-state/stabilizer verification, perfect tensors and AME error spaces, additive MDS weight distributions, and setting/gap bounds. Start with Dangniam–Han–Zhu, Pallister–Linden–Montanaro, Wu et al., Tóth–Gühne, and Huber–Grassl, but test whether the exact proposed claims are already known or immediate specializations. Record theorem/page-level evidence, measurement classes, hypotheses, search coverage and stopping limits. Produce an explicit prior-work-versus-proposed-contribution matrix; no unsupported priority or absence claims. Apply the bounded novelty-extraction protocol if a proposed crown is pre-empted.
4. **Concrete paper-change proposal.** Deliver reviewable draft theorem/proof text, citation-supported related-work and motivation paragraphs, and a label-based insertion/removal plan. Explain why redundant tests improve normalized conditioning and what operational question the restricted measurement model answers. Distinguish compound subset tests from single-party Pauli settings or LOCC. Rank a minimal main-text package versus appendix/companion material, with estimated length and narrative cost. Reuse the four-qutrit example. Preserve the current robustness radius and character-correction limitations. Recommend adopt/revise/defer/reject for every module, including optional LP, spectrum, sample-cost and a posteriori additions.
5. **Evidence and closeout.** Keep audit reports, source records and draft proposal under this task's exact output stem. Review scripts before optional execution; follow reproducibility conventions for any computational claims used as evidence. State precisely what was and was not independently checked. Finish with an explicit ej+tt pass and Mystery ledger, naming remaining evidence gaps and successors.

## Scope

This task is an audit and a concrete revision proposal; adopting the proposed manuscript changes is a subsequent decision. No automatic manuscript integration, Lean coverage claim, mirror export, or push is part of this queued task. Keep six-arc phase classification, Ergodis benchmarks, and universal-radius character-control research outside the audit except where needed to delimit claims. Preserve Paper II and user-held C979 untouched.

## Next action

Read the lane handoff and routed conventions, confirm input hashes and current manuscript baseline, then prepare the claim inventory and independent review packets while beginning the primary-source audit.

## Execution record

Input Markdown preserved under the task output directory as `input-packet.md`; its hash is unchanged. Independent journal and mathematical attack readers and an adjacent-literature reader are running. No manuscript mutation is authorized by this proposal task.

Command-shaping correction: an attempted combined ten-page primary-source read emitted 12,238 original tokens and was truncated. That output is not used as evidence of reading; replaced it with selected pages from cached text (DHZ pages 3, 8, 13; PLM page 4), with further bounded reads below.
