# C1137 — focused AME draft and cold-reader A/B test

**Lane:** `ame-lu`
**Status:** COMPLETE (2026-09-10).

User authorizes drafting the certification integration proposed in the conversation and cold-reader A/B testing. Preserve exact and robust rigidity as headlines; one four-qutrit example, compact uniform verification result in the body, weighted/test-count and universal proofs in an optional appendix, one observable-rounding corollary. Baseline PDF and hash are frozen in the task directory before changes. Three fresh gpt-6-astra readers will receive neutral names and counterbalanced order with no drafting history, evaluating primary-specialist confidence separately from adjacent-reader accessibility and enjoyment. No new priority claims, Lean work, Paper II changes, or push.

## Draft gate and root review

The frozen tested draft is `fe92349c7`, 43 pages versus the 40-page baseline. `make check` passed without manuscript warnings. Exact and robust rigidity are consecutive introductory theorems; encoder conversion follows. The new uniform-gap proof occupies roughly a page and a half including its setup, literature paragraph and qutrit callback. The weighted/test-count and universal proofs occupy approximately two appendix pages. The observable corollary is a short closing subsection of the robustness section.

Three gpt-6-astra readers received fresh contexts, neutral X/Y paths, explicit reader disciplines, counterbalanced order, no prior review and no preferred result. They are reading full PDFs/text rather than excerpts. This is a qualitative model-based cold-reader comparison, not a human user study or statistical experiment. The private mapping and hashes are frozen in the task directory.

Root inspected rendered pages 2, 3, 16, 17, 31, 36, 37 and 38 of the draft; margins, formulas and appendix transitions are legible. A source check found duplicate equation numbers (4.1)/(4.2): old manually tagged atlas equations did not advance the counter used by the new equations. Repair all three old Section 4 displays to automatic semantic labels before finalizing. Also define perfect completeness at first use in the body. These are post-test repairs: do not overwrite the frozen tested PDF. The release verifier's current formal-source identities match the prior manifest exactly; twenty public artifacts now include the two new source units. No Lean build or new formal claim is needed.

## Cold-reader outcome

All three readers preferred the focused draft, moderately (quantum information and mathematical physics) or narrowly (coding theory). They found no mathematical blocker; each recommended minor revision. This is three qualitative same-model assessments, not evidence of statistical significance or a human readership consensus. Full journal-style reports are preserved in the companion directory. The coding reader noticed PDF timestamps incidentally; chronology was not supplied in its instructions.

Scores below are baseline → tested draft, each out of five. Frozen tested draft: `fe92349c7`; final repairs were not put through another blind comparison.

| Reader | Confidence | Accessibility | Focus | Enjoyment | Preference |
|---|---:|---:|---:|---:|---|
| Quantum information | 4 → 4 | 4 → 4 | 4 → 3 | 3 → 4 | Draft, moderate |
| Mathematical physics | 4 → 4 | 3 → 4 | 3 → 4 | 4 → 4 | Draft, moderate |
| Coding theory | 4 → 4 | 3 → 4 | 4 → 4 | 4 → 4 | Draft, narrow |

The shared benefit was a concrete link from marginal tests to the robust theorem, with the four-qutrit character example tying it to the exact structure. The QI focus penalty is a real counterweight: retain the compact integration, keep the optional proofs in Appendix C, and do not promote certification to a third introductory headline.

## Reader repairs and final gate

- Removed the separate transition-radius clause from the abstract; its precise statement remains in the introduction and proof section.
- Made the main reading route honest about its Choi-encoder prerequisite and the atlas required by the transition refinement. Added a direct continuation pointer after the exact proof.
- Defined the Frobenius normalization and perfect completeness at first relevant use.
- Explained explicitly why the nonstabilizer appendix does not assume cross-star commutativity.
- Added the four-qutrit sufficient rejection bound `gamma < 1/4000`. This follows analytically from `R=1/(16 pi)`, `nu=3/4`, and `pi^2<10`; it is not a numerical experiment or a sampling guarantee.
- Replaced the three manual Section 4 equation tags with semantic labels; the new gap and fidelity formulas are now (4.4) and (4.5). Corrected stochastic-conversion cross references and removed retrospective “former list” prose.
- Made all eight new bibliography entries display the actual version-pinned arXiv identifiers already used in C1136. No new literature-priority inference was made.

Final `make -C papers/ame_lu check` passed, warning-free, 43 pages (baseline 40). Build log: `/tmp/claude-run-quiet/20260910-214314-make-C-ame_lu-check/`. Root rechecked the rendered verification page and extracted equation/reference/threshold output after repair; earlier root inspection covered the affected theorem and appendix layouts. `git diff --check` passed. The release verifier checked 20 public artifacts and 83 unchanged formal artifacts after repinning only the public release surface. No Lean build, replay, or new formal coverage is claimed. A PDF extraction initially found Poppler absent from PATH; rerunning through the Nix package succeeded.

`baseline.pdf`, `draft-tested.pdf`, and `draft-final.pdf` remain separate; SHA-256 identities and the neutral-label mapping are committed alongside the reader reports. The final authority PDF is `papers/ame_lu/ame-lu.pdf`. The standalone mirror remains at C1134's `55e70c4`; no mirror sync or push was performed for this draft comparison.

## Post-gate ej + tt and Mystery ledger

**ej:** the tests now have a direct observable-to-rounding use, with the qutrit threshold exposing the conservative scale rather than hiding it. No extra theorem is needed to extract that value.

**tt:** the organizing question is what the tests detect that the transition labels miss. The existing qutrit character repair and new test callback answer that question without adding another conceptual framework. The universal proof uses orthogonality between low-rejection spaces, not a nonexistent common eigenbasis; this distinction is now explicit.

| Feature | Disposition / evidence gap |
|---|---|
| Does the extra material help adjacent readers without changing the headlines? | Supported qualitatively by all three votes and two accessibility gains; QI focus worsened by one point. Human-reader generalization remains untested. |
| Why can the universal argument work without cross-star commutation? | Settled in the manuscript by half-set error bases and orthogonality of low-rejection spaces; explicit explanatory sentence added. |
| Why is the observable rounding threshold small despite a constant verification gap? | The conservative global rigidity entry radius controls it; the qutrit calculation now makes this visible. Improving that radius is outside this editorial task. |
| Dimension-independent nearby exact symmetry / character control | Still open as recorded by the existing theorem boundary; no claim added. |
| Exact weighted gap for arbitrary nonstabilizer AME states | Not established: Appendix C claims the weighted lower bound and exact uniform gap only. |
| Publication priority of the verification package | C1136 remains qualified; seventeen partial reads, zero full reads, and its recorded database/citation gaps are unchanged. |

No incidental discovery-track entry is warranted: these were the planned editorial and review questions. Highest-EV next action is to synchronize/export the selected revised draft when the user resumes the lane; no successor C-ID allocated. Vibe: a useful, restrained improvement, with the remaining brevity tradeoff visible.
