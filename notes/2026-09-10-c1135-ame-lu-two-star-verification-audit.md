# C1135 — AME two-star verification: proof, adversarial review, and literature audit

**Lane:** `ame-lu`
**Status:** COMPLETE — audit and reviewable revision proposal (2026-09-10).
**User request:** verify, red-team, audit the literature, and propose paper changes with proper literature positioning and motivation.

## Outcome

The packet's principal mathematical claims pass independent verification and two fresh-context gpt-6-astra adversarial/journal reviews. Recommend a bounded manuscript addition: exact weighted and setting-count verification, a universal AME appendix, the four-qutrit illustration, and one observable-rounding corollary. The concrete proposal is `2026-09-10-c1135-ame-lu-two-star-verification-audit-proposal.md`; it contains full draft statements/proofs and citation-supported motivation, not just an editing plan.

The literature audit comprises **0 full-text and 9 partial primary-source reads**, with exact pages, versions, cached-byte hashes and bounded searches recorded in the two literature reports. It identifies established mechanisms and four close additional references for the proposed positioning. It does not close publication priority; no absence-based novelty sentence is approved. The mathematical content can be presented with the supplied proofs and generous attribution without such a sentence.

The adversarial pass also proves a stronger universal statement than the packet: any `m` doubled-star tests determine an arbitrary AME target, and the weighted stabilizer formula is a universal **lower bound**. Exact nonstabilizer weighted equality remains unclaimed. A separate sharpness calculation shows that the uniform verifier-to-defect conversion is already attained by one-party unitary errors, so a better global radius cannot come from tightening that scalar conversion alone.

The manuscript remains exactly at the C1134 revision. No source/PDF build, Lean work, mirror export or push occurred; C979/Paper II remained untouched. Adoption is the next decision, not an unfinished audit deliverable.

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

A subsequent diagnostic mistakenly applied `Object.keys` to the web tool's string result, emitting 64,706 original tokens of string indices. It was stopped and replaced with a bounded first-line title/URL parser; no source evidence depends on that output. A combined two-report read was also truncated at its display budget; the omitted referee opening was reread in a bounded range. Delegate command-shaping corrections are preserved in their reports. Future web results here are treated as strings, with explicit source-side bounds before emitting them.

## Claim verification and disposition

| Item | Verification result | Proposed treatment |
|---|---|---|
| Any-half doubled-star direct sum | Proven over the prime field using support intersection and dimension; target-fixing lifts handle characteristic two | Adopt as lemma |
| Weighted gap, including ties and zero weights | Nonzero annihilating characters attain every complementary `(m+1)` failure set | Adopt |
| Upper bound for arbitrary binary effects | Positivity forces identity on marginal support; `m-1` heaviest groups leave a nontrivial character | Adopt with explicit support model |
| Locality cap | One-site traceless unitary errors give `nu<=k/n` for any one-uniform state | Use in proof; avoid extra headline |
| Complete setting-count curve and missing settings | Follows with exact attainment, fixed-subset setting definition, and `m>=2` | Adopt |
| Universal one-star parent and spectrum | Error-basis rank argument or virtual Bell-pair conjugation | Background lemma/appendix; credit established framework |
| Universal full two-star gap | Orthogonal low-error spaces, no cross-star commutation | Adopt compact appendix |
| Universal selected-subset/weighted lower bound | New audit proof via shifted spectral filtrations; cross-checked by root and separately by referee after initial review | Include in appendix if length permits |
| Four-party projectors commute universally | Their omitted-site traceless-error spaces are orthogonal | Correct caution; defer unless diagnostic discussed |
| Test-syndrome MDS spectrum | Restriction bijection and inclusion–exclusion; physical/code weights distinguished | Defer full enumerator; keep qutrit illustration |
| Observable thresholds | Exact `epsilon^2=2(1-sqrt(F))`, current radii and phase conventions | Adopt short corollary |
| Calibration and iid sample-cost wrapper | Correct conditional bounds; no empirical-frequency or correlated-copy overclaim | One sentence/optional remark |
| Instance-specific branch certificate | Second moment plus overlap gap; centered-log chord criteria imply printed hypotheses | Correct, defer from core |
| Weighted LP and generic oracle | Correct order statistics and primal/dual directions; no hidden cardinality or efficiency result | Defer/companion material |
| Claimed computational checks | Both supplied standard-library scripts rerun, exact outputs match packet | Optional sanity evidence only |

No correctness rejection of the stated core was necessary. Small drafting changes: distinct symbols for extension degree and error budget; count internally randomized different supports as distinct settings; unique optimal weights only within the fixed library; no universal equality inferred from the stronger universal lower bound. The conditional exact-base relative-intertwiner premise and phase-sensitive character limitation remain unchanged.

## Review reconciliation and independence

- `...-referee.md`: independent journal-style report with contribution, significance, correctness, exposition, major/minor comments and a reasoned bounded-integration recommendation. It reads the full current quantitative section and the relevant exact/marginal source. No external literature priority assertion.
- `...-adversarial.md`: independent proof attack, including arbitrary effects, edge cases, additive conventions, universal noncommutation, and optional branch/chord conditions. Same no-blocker verdict. It derives the stronger universal lower bound.
- The referee's later check of that strengthening is clearly marked as a follow-up informed by the adversarial report, not falsely counted as a second independent discovery. Root reconstructed the spectral truncation identity and the telescoping weighted coefficient.
- `...-literature-adjacent.md`: five registered partial primary-source reads. Root verified the unconditional read-depth fields and the opening count. `...-literature.md` combines them with four root primary reads and owns the attribution/coverage verdict.

Both mathematical reviewers recommend a compact consequence of the atlas, not an equally extensive third theme. Their main substantive concerns—measurement-model scope, novelty language, and overexpansion—are built into the proposal. No substantive dissent was suppressed.

The referee then checked the concrete Drafts A/B/C and accepted them, requesting two minor definition repairs: define the marginal projector for every allowed support, and specify integer ranges for setting and erasure counts. Both are applied, along with the fixed-support convention. No theorem/proof repair was requested. The complete proposal remains an unapplied, reviewable artifact.

## Literature and motivation acceptance

The revision should not claim new general support determination, parent Hamiltonians, constant-gap stabilizer verification, eigenbasis LPs, or inverse-infidelity sampling. These have direct primary-source precedents, detailed in the contribution matrix. In particular the minimal-test `1/s` gap bound is already V1 Proposition 1; the generic linear-program framework is V1 Section V.B; the scalar fidelity methodology is already V1/V3 and A2; the parent verification framework is V4 and A5.

The worthwhile mathematical question is sharp verification at the first informative AME support size. The doubled family supplies redundancy with an exactly quantified gain, while the universal error-space argument identifies which part comes purely from AME entanglement geometry. The observable corollary connects these measured tests to the paper's principal rigidity theorem under its existing product-unitary promise.

No exact-core pre-emption was established in the consulted passages; this is not a literature-wide absence finding. Broad methods were already identified as standard in the task and packet, so there is no failed crown requiring a separate novelty-extraction successor. Exhaustive forward-citation/priority closure remains outside the approved wording, as recorded in the literature report. Do not silently promote the bounded audit into such closure.

## Reproducible optional checks

Directory: `notes/2026-09-10-c1135-ame-lu-two-star-verification-audit/`.
Working directory for the following commands: repository root `/home/tavis/src/othello`.

```sh
python3 notes/2026-09-10-c1135-ame-lu-two-star-verification-audit/check_four_qutrits.py
python3 notes/2026-09-10-c1135-ame-lu-two-star-verification-audit/check_six_qubits.py
```

The exact supplied scripts were read before execution, copied verbatim from the ZIP, and run without optimization flags. They use only the Python standard library; `checks-manifest.json` records the Python version plus script/output byte counts and SHA-256 hashes. There is no random seed. Their stdout JSON matches respectively `four_qutrit_check.json` and `six_qubit_check.json`, which also match the supplied packet outputs as parsed objects. The preserved input Markdown hash was checked again.

Domain: all 81 four-qutrit labels and their characters, all 15 nonempty selected libraries; all 64 six-qubit labels and characters, all 63 nonempty selected libraries, and the 20 three-group spanning choices. Both check one specified nonuniform weight vector; both exact histograms match analytic inclusion–exclusion. They do not exhaust all weights, prove universal statements, construct noisy experiments, or test nonstabilizer examples. The independently reconstructed analytic proofs and hand-derived spectra are the cross-check; no second independent enumeration implementation is claimed. CPython execution and its integer arithmetic are trusted. The general manuscript proofs have no computational premise.

## Explicit ej + tt closeout and Mystery ledger

After the principal proof/review and attribution gates passed, the closeout asked what the proof really needs, whether the universal restriction was artificial, and whether a better scalar certificate would strengthen rigidity. The cheap improvements were carried out and written into the proposal.

| Question | Status and evidence | Remaining gate/owner |
|---|---|---|
| Why does one star commute without stabilizers? | Settled: unitary conjugation of Bell-pair projectors; equivalently tensor-error coordinate tests | No mathematical gap; background attribution in A4/A5 |
| Must any-half sufficiency depend on stabilizer characters? | Settled: shifted opposite-half error filtrations give a gap of at least one for any `m` selected tests | Full proof in Draft C, independently checked follow-up |
| Does the weighted formula extend universally? | Lower bound settled; exact equality unresolved | Need a nontrivial common accepting vector for mixed `m-1` tests, or a counterexample; optional future research, not an adoption blocker |
| Can a sharper rejection-to-defect conversion improve the global radius? | Settled negatively for this scalar route: one-party unitary outputs attain the conversion | Improving the radius requires other structure; existing character-control frontier remains separate |
| Is the exact restricted-model theorem first in the literature? | Unresolved evidence question, not a mathematical defect | No priority wording; further citation/subject coverage before any ledger priority assertion |
| Are compound tests cheap on actual hardware? | Not established by the model | Needs specified implementation/cost model; not a claim in the proposal |

The universal refinement and sharpness check were explicitly sought within verification/red-team/closeout work, so they are task deliverables, not incidental discovery-log entries. The discovery-track review found no additional incidental observation to append; the lane companion link remains intact.

## Proposed next decision

Adopt the bounded package in the concrete proposal, including its corrected literature account and universal lower-bound appendix, then run the paper's manuscript/release and rendered comparison gates. Allocate that implementation task only after the adoption decision. Keep the full spectrum, general optimization oracle and instance-specific certificate in these notes. No unallocated successor ID is invented here.
